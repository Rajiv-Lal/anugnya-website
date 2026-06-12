#!/bin/bash
# anugnya-cta-patch-2.sh — patches the ONE missed question.
# Run from anugnya-website-dev:  bash anugnya-cta-patch-2.sh
set -e
TS=$(date +%Y%m%d-%H%M%S)
cp faq.html "faq.html.bak2-$TS"
echo "🗂  Backup: faq.html.bak2-$TS"

python3 << 'PY'
import re
f="faq.html"; s=open(f,encoding="utf-8").read()
q="Why do I feel anxious now that treatment is over?"
phrase="To ease anxiety after treatment, book a call with Sangeeta now."
path="book.html#recovery"

qi=s.find(q)
if qi==-1:
    print("⚠️  question not found — no edit."); raise SystemExit
cta=re.compile(r'<div class="answer-cta">.*?</div>',re.DOTALL).search(s,qi)
if not cta:
    print("⚠️  answer-cta not found after question — no edit."); raise SystemExit
pre=s[max(0,cta.start()-400):cta.start()]
if "answer-cta-phrase" in pre:
    print("⏭  already patched — skip."); raise SystemExit

new=('<div class="answer-cta-phrase" style="margin:14px 0 10px;font-weight:600;color:var(--primary-purple);">'
     +phrase+'</div>\n'
     '                                <div class="answer-cta">\n'
     '                                    <a href="'+path+'" class="btn btn-secondary">Book a Call Now</a>\n'
     '                                </div>')
s=s[:cta.start()]+new+s[cta.end():]
open(f,"w",encoding="utf-8").write(s)
print("✅ faq.html: anxiety question CTA replaced.")
PY

echo "Review, then: git add faq.html && git commit -m 'CTA: patch missed anxiety FAQ' && git push origin main"
