#!/bin/bash

# ==============================================
# Add Google Analytics to Anugnya Website
# ==============================================
# Run this script in your anugnya-website-dev folder
# Usage: bash add-google-analytics.sh
# ==============================================

# Google Analytics code block
GA_CODE='    <!-- Google Analytics (GA4) -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-5EM10412DY"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('\''js'\'', new Date());
      gtag('\''config'\'', '\''G-5EM10412DY'\'');
    </script>'

# Check if we're in the right directory
if [ ! -f "index.html" ]; then
    echo "❌ Error: index.html not found!"
    echo "Please run this script from your anugnya-website-dev folder"
    exit 1
fi

echo "🔍 Finding HTML files..."
echo ""

# Counter for files processed
count=0

# Process all HTML files in root and guides folder
for file in *.html guides/*.html; do
    if [ -f "$file" ]; then
        # Check if GA code already exists
        if grep -q "G-5EM10412DY" "$file"; then
            echo "⏭️  $file - Already has Google Analytics"
        else
            # Add GA code after <head>
            # Using sed to insert after first <head> tag
            if [[ "$OSTYPE" == "darwin"* ]]; then
                # macOS
                sed -i '' 's/<head>/<head>\
    <!-- Google Analytics (GA4) -->\
    <script async src="https:\/\/www.googletagmanager.com\/gtag\/js?id=G-5EM10412DY"><\/script>\
    <script>\
      window.dataLayer = window.dataLayer || [];\
      function gtag(){dataLayer.push(arguments);}\
      gtag('\''js'\'', new Date());\
      gtag('\''config'\'', '\''G-5EM10412DY'\'');\
    <\/script>/' "$file"
            else
                # Linux
                sed -i 's/<head>/<head>\n    <!-- Google Analytics (GA4) -->\n    <script async src="https:\/\/www.googletagmanager.com\/gtag\/js?id=G-5EM10412DY"><\/script>\n    <script>\n      window.dataLayer = window.dataLayer || [];\n      function gtag(){dataLayer.push(arguments);}\n      gtag('\''js'\'', new Date());\n      gtag('\''config'\'', '\''G-5EM10412DY'\'');\n    <\/script>/' "$file"
            fi
            echo "✅ $file - Added Google Analytics"
            ((count++))
        fi
    fi
done

echo ""
echo "========================================"
echo "📊 Google Analytics added to $count files"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. git add ."
echo "2. git commit -m 'Add Google Analytics tracking'"
echo "3. git push origin main"
echo ""
