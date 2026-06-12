#!/bin/bash
# ============================================================
# anugnya-cta-patch.sh
# Run from inside anugnya-website-dev:   bash anugnya-cta-patch.sh
#
# Does two things:
#  A. book.html  — adds URL-hash deep-link handler so
#     book.html#treatment / #recovery / #caregiver auto-open
#     the matching path on arrival (no conflict with click flow).
#  B. faq.html   — replaces each answer-cta block with a single
#     intent-matched selling phrase + one Book button (deep-linked).
#     Drops the "Join Support Group" / WhatsApp buttons from answers.
#
# Idempotent: re-running detects already-patched blocks and skips.
# Edits a COPY check first; backs up both files with .bak timestamp.
# ============================================================
set -e

TS=$(date +%Y%m%d-%H%M%S)

for f in book.html faq.html; do
  if [ ! -f "$f" ]; then
    echo "❌ $f not found. Run from anugnya-website-dev folder."; exit 1
  fi
  cp "$f" "$f.bak-$TS"
done
echo "🗂  Backups created: book.html.bak-$TS , faq.html.bak-$TS"

# ============================================================
# PART A — book.html deep-link handler
# ============================================================
python3 << 'PYBOOK'
f = "book.html"
s = open(f, encoding="utf-8").read()

marker = "// ANUGNYA_DEEPLINK_HANDLER"
if marker in s:
    print("⏭  book.html deep-link handler already present — skipping.")
else:
    # Insert a hash handler right after selectCustomerType is defined.
    anchor = "        function selectRecoveryService(service) {"
    if anchor not in s:
        print("⚠️  book.html: anchor for handler not found — NObook edit made.")
    else:
        handler = '''        // ANUGNYA_DEEPLINK_HANDLER
        // Deep-link: book.html#treatment | #recovery | #caregiver
        // auto-opens the matching path. No hash => normal chooser.
        function anugnyaOpenFromHash() {
            var h = (window.location.hash || '').replace('#','').toLowerCase();
            if (h === 'treatment' || h === 'recovery' || h === 'caregiver') {
                selectCustomerType(h);
            }
        }
        window.addEventListener('DOMContentLoaded', anugnyaOpenFromHash);
        window.addEventListener('hashchange', anugnyaOpenFromHash);

'''
        s = s.replace(anchor, handler + anchor, 1)
        open(f, "w", encoding="utf-8").write(s)
        print("✅ book.html: deep-link handler inserted.")
PYBOOK

# ============================================================
# PART B — faq.html answer CTAs
# Replace each <div class="answer-cta"> ... </div> with a
# single phrase + one deep-linked Book button.
# Matched per-question by the unique question text preceding it.
# ============================================================
python3 << 'PYFAQ'
import re
f = "faq.html"
s = open(f, encoding="utf-8").read()

# Map: unique EN question substring -> (phrase, book-path)
M = [
 ("Why am I so exhausted during chemotherapy?",
  "To manage exhaustion during treatment, book a call with Sangeeta now.", "book.html#treatment"),
 ("What can I do about nausea during chemo?",
  "To ease nausea during chemo, book a call with Sangeeta now.", "book.html#treatment"),
 ("I can't sleep during treatment. Is this normal?",
  "To sleep better during treatment, book a call with Sangeeta now.", "book.html#treatment"),
 ("How do I stay positive when treatment feels endless?",
  "To find strength through treatment, book a call with Sangeeta now.", "book.html#treatment"),
 ("How do I cope with chemo side effects?",
  "To manage side effects and stay on treatment, book a call with Sangeeta now.", "book.html#treatment"),
 ("How do I deal with caregiver burnout?",
  "To deal with caregiver burnout, book a call for yourself now.", "book.html#caregiver"),
 ("How do I support my spouse through chemotherapy?",
  "To support your spouse without breaking down, book a call now.", "book.html#caregiver"),
 ("What support do caregivers need that nobody talks about?",
  "For support that's just for you, book a call now.", "book.html#caregiver"),
 ("When will I feel normal after chemo?",
  "To rebuild your strength after chemo, book a call with Sangeeta now.", "book.html#recovery"),
 ("How long does chemo fatigue last and how do I get my energy back?",
  "To get your energy back after treatment, book a call with Sangeeta now.", "book.html#recovery"),
]

def new_cta(phrase, path):
    return (
      '<div class="answer-cta-phrase" style="margin:14px 0 10px;font-weight:600;color:var(--primary-purple);">'
      + phrase +
      '</div>\n'
      '                                <div class="answer-cta">\n'
      '                                    <a href="' + path + '" class="btn btn-secondary">Book a Call Now</a>\n'
      '                                </div>'
    )

# Each faq-item is: question text ... <div class="answer-cta"> ... </div>
# We find each question, then the NEXT answer-cta after it, and replace that block.
cta_re = re.compile(r'<div class="answer-cta">.*?</div>', re.DOTALL)

count = 0
skipped = 0
for q, phrase, path in M:
    qi = s.find(q)
    if qi == -1:
        print(f"⚠️  question not found (skip): {q[:45]}")
        skipped += 1
        continue
    m = cta_re.search(s, qi)
    if not m:
        print(f"⚠️  no answer-cta after: {q[:45]}")
        skipped += 1
        continue
    # idempotency: if already replaced (phrase present just before), skip
    pre = s[max(0,m.start()-400):m.start()]
    if "answer-cta-phrase" in pre and phrase in pre:
        skipped += 1
        continue
    s = s[:m.start()] + new_cta(phrase, path) + s[m.end():]
    count += 1

open(f, "w", encoding="utf-8").write(s)
print(f"✅ faq.html: {count} answer CTAs replaced, {skipped} skipped.")
PYFAQ

echo ""
echo "Done. Review locally, then:"
echo "  git add book.html faq.html"
echo "  git commit -m 'CTA: single deep-linked Book button per FAQ answer + book.html hash handler'"
echo "  git push origin main"
echo ""
echo "Backups: *.bak-$TS  (delete once verified)"
