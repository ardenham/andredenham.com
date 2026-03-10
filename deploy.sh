#!/bin/bash
# ===========================================
# Andre Denham — One-click GitHub Pages Deploy
# Run this from inside the site-deploy folder
# ===========================================

GITHUB_USERNAME="ardenham"
REPO_NAME="andredenham.com"
TOKEN="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"

# Check for headshot
if [ ! -f "assets/headshot.jpg" ]; then
  echo "⚠️  Missing headshot!"
  echo "   Please save your photo as: assets/headshot.jpg"
  echo "   (JPEG format, any size — the site will crop it automatically)"
  echo ""
  read -p "Press Enter once you've added the file, or Ctrl+C to cancel..."
fi

echo "🚀 Creating GitHub repository..."
curl -s -X POST \
  -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/user/repos \
  -d "{\"name\":\"$REPO_NAME\",\"description\":\"Personal website of Andre Denham\",\"private\":false,\"auto_init\":false}" \
  | grep -E '"full_name"|"html_url"|"message"'

echo ""
echo "📁 Initializing git and pushing files..."
git init
git checkout -b main
git add .
git commit -m "Initial site launch 🎉"
git remote add origin https://${GITHUB_USERNAME}:${TOKEN}@github.com/${GITHUB_USERNAME}/${REPO_NAME}.git
git push -u origin main

echo ""
echo "⚙️  Enabling GitHub Pages..."
sleep 3
curl -s -X POST \
  -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/${GITHUB_USERNAME}/${REPO_NAME}/pages \
  -d '{"source":{"branch":"main","path":"/"}}' \
  | grep -E '"html_url"|"status"|"message"'

echo ""
echo "✅ Done! Your site will be live at:"
echo "   https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/"
echo ""
echo "   (Custom domain andredenham.com takes effect once you update DNS —"
echo "    see DEPLOYMENT-GUIDE.md for the DNS records to add.)"
echo ""
echo "🔒 Delete this token now at: https://github.com/settings/tokens"
