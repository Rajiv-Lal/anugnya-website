# Anugnya Holistic Care - Website Setup Guide

Complete setup instructions for deploying the Anugnya Holistic Care website on GitHub Pages with Google Sheets integration.

## 📁 Repository Structure

```
anugnya-website/
├── index.html                          # Main website file
├── data/
│   └── anugnya-resources.json         # Resources data (YouTube/Substack)
├── images/                             # All image assets
│   ├── anugnya-logo.png
│   ├── hero-landing-_page_.png
│   ├── sangeeta-bhalla.jpg
│   ├── viiveck-verma.png
│   ├── service-01-energy-healing.png
│   ├── service-02-psychotherapy.png
│   ├── service-03-aromatherapy.png
│   ├── service-04-healing-offsite.png
│   ├── service-05-cancer-companion.png
│   ├── service-06-self-empowerment.png
│   ├── therapeutic-energy-healing.png
│   ├── _energy-psychotherapy.png
│   ├── energy-aromatherapy.png
│   ├── restorative-healing-retreat.png
│   ├── community-support-guidance.png
│   └── self-empowerment.png
└── README.md                          # This file
```

## 🚀 Deployment Steps

### Step 1: Prepare Your Repository

1. **Create GitHub Account** (if you don't have one)
   - Go to [github.com](https://github.com)
   - Sign up for free

2. **Create New Repository**
   - Click "New" or "Create repository"
   - Name: `anugnya-website` (or your preferred name)
   - Set to Public
   - Don't initialize with README (we have our own)
   - Click "Create repository"

3. **Upload Files to GitHub**
   
   **Option A: GitHub Web Interface (Easiest)**
   - Click "uploading an existing file"
   - Drag and drop `index.html` and `README.md`
   - Create folder `data/` and upload `anugnya-resources.json`
   - Create folder `images/` and upload all images
   - Commit changes
   
   **Option B: Git Command Line**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/YOUR-USERNAME/anugnya-website.git
   git push -u origin main
   ```

### Step 2: Enable GitHub Pages

1. Go to your repository on GitHub
2. Click **Settings** (top menu)
3. Click **Pages** (left sidebar)
4. Under "Source":
   - Select branch: `main`
   - Select folder: `/ (root)`
5. Click **Save**
6. Wait 2-3 minutes
7. Your site will be live at: `https://YOUR-USERNAME.github.io/anugnya-website/`

### Step 3: Set Up Google Sheets Backend

#### A. Create Google Sheet

1. Go to [sheets.google.com](https://sheets.google.com)
2. Create a new spreadsheet
3. Name it: "Anugnya Form Submissions"
4. Create **4 sheets** (tabs at bottom) with these EXACT names:
   - `Contacts`
   - `Treatment`
   - `Recovery`
   - `Caregiver`

#### B. Set Up Google Apps Script

1. In your Google Sheet, click **Extensions** > **Apps Script**
2. Delete any default code
3. Copy ALL the code from `google-apps-script.gs`
4. Paste it into the Apps Script editor
5. Click **Save** (💾 icon)
6. Name the project: "Anugnya Form Handler"

#### C. Deploy as Web App

1. Click **Deploy** > **New deployment**
2. Click the gear icon ⚙️ next to "Select type"
3. Select **Web app**
4. Fill in settings:
   - Description: "Form submission handler"
   - Execute as: **Me** (your email)
   - Who has access: **Anyone**
5. Click **Deploy**
6. Review permissions:
   - Click **Review permissions**
   - Select your Google account
   - Click **Advanced** > **Go to Anugnya Form Handler (unsafe)**
   - Click **Allow**
7. **IMPORTANT**: Copy the **Web App URL**
   - It looks like: `https://script.google.com/macros/s/AKfyc.../exec`
   - Keep this URL - you'll need it in the next step

#### D. Initialize Sheet Headers

1. Back in Apps Script editor
2. Click **Run** > Select `initializeSheets` function
3. Click **Run** button
4. This will create column headers in all 4 sheets
5. Verify that headers appeared in each sheet

### Step 4: Connect Website to Google Sheets

1. Open your `index.html` file on GitHub
2. Click the **Edit** (pencil icon)
3. Find this line (around line 1920):
   ```javascript
   const GOOGLE_SCRIPT_URL = 'PASTE_YOUR_GOOGLE_SCRIPT_URL_HERE';
   ```
4. Replace `PASTE_YOUR_GOOGLE_SCRIPT_URL_HERE` with your actual Web App URL from Step 3C
5. Scroll to bottom and click **Commit changes**
6. Wait 2-3 minutes for GitHub Pages to update

### Step 5: Test Everything

1. Visit your live website: `https://YOUR-USERNAME.github.io/anugnya-website/`
2. Test each section:
   - ✅ Navigation works
   - ✅ Images load
   - ✅ Resources section shows YouTube videos and Substack articles
   - ✅ Clicking YouTube videos opens modal with embedded player
   - ✅ Clicking Substack opens modal with description
   - ✅ Submit a test form
3. Check Google Sheets:
   - New row appears in appropriate sheet
   - Contact added to Contacts sheet
   - Phone number is properly recorded

## 📊 Google Sheets Structure

### Sheet 1: Contacts (Master List)
- **Phone** - Primary key, links all sheets
- First Contact - Timestamp of first submission
- Last Updated - Most recent submission
- Name
- Email
- Customer Type - (Treatment/Recovery/Caregiver/Contact Form)
- Interaction Count - Number of form submissions

### Sheet 2: Treatment
- **Phone** - Links to Contacts
- Timestamp
- Status - (Paused/Active)
- Pause Reason
- Pause Duration
- Treatment Type
- Symptoms - Comma-separated list
- Disclaimer Consent

### Sheet 3: Recovery
- **Phone** - Links to Contacts
- Timestamp
- Service Selected
- Journey Notes
- Disclaimer Consent

### Sheet 4: Caregiver
- **Phone** - Links to Contacts
- Timestamp
- Path Type - (Consultation/Service)
- Tiredness Score (1-5)
- Exhaustion Score (1-5)
- Anxiety Score (1-5)
- Overwhelmed Score (1-5)
- Sadness Score (1-5)
- Average Score
- Service Selected
- Preferred Time/Concerns
- Disclaimer Consent

## 🔄 Making Updates

### Update Resources (Easy)

1. Edit `data/anugnya-resources.json` on GitHub
2. Add/remove/modify YouTube or Substack entries
3. Commit changes
4. Site updates automatically within 2-3 minutes

### Update Website Content

1. Edit `index.html` on GitHub
2. Make changes to text, styling, etc.
3. Commit changes
4. Site updates automatically within 2-3 minutes

### Update Images

1. Go to `images/` folder on GitHub
2. Upload new images or replace existing ones
3. Keep the same filenames if replacing
4. Commit changes

## 🔧 Troubleshooting

### Forms Not Submitting

1. **Check console for errors**:
   - Open website
   - Press F12 (Developer Tools)
   - Click "Console" tab
   - Submit a form
   - Look for error messages

2. **Verify Google Script URL**:
   - In `index.html`, search for `GOOGLE_SCRIPT_URL`
   - Ensure it's your actual Web App URL, not the placeholder

3. **Check Apps Script deployment**:
   - Go to Apps Script
   - Click **Deploy** > **Manage deployments**
   - Ensure status is "Active"
   - Ensure "Who has access" is "Anyone"

### Resources Not Loading

1. **Check JSON file path**:
   - Verify `data/anugnya-resources.json` exists
   - Check spelling and capitalization

2. **Check browser console**:
   - Look for 404 errors or JSON parse errors

### Images Not Loading

1. **Check file paths**:
   - Ensure all images are in `images/` folder
   - Check spelling matches exactly (case-sensitive)

2. **Check image formats**:
   - Use .png, .jpg, or .jpeg only
   - SVG may not work in all contexts

## 📞 Contact Information

- **Email**: care@anugnyaholistic.com
- **Phone**: +918106248800
- **Calendly**: https://calendly.com/rajivlalkl/30min

## 🔐 Security & Privacy

- Phone numbers are used as primary keys
- All form data stored in your private Google Sheet
- Only you have access to the Google Sheet
- Website is public, but form submissions are private
- No data is stored in GitHub
- No third-party analytics by default

## 📝 Customization Guide

### Change Colors

Edit these CSS variables in `index.html`:
```css
/* Primary purple */
#4C22A6

/* Light purple */
#d0c3f1

/* Dark purple */
#1B0564

/* Rose/pink */
#b1365b

/* Beige background */
#fdf7f3

/* Light beige */
#E8D4D1
```

### Change Calendly Link

Search for `calendly.com/rajivlalkl/30min` and replace with your Calendly URL.

### Add More Resources

Edit `data/anugnya-resources.json`:
```json
{
  "title": "Your Video Title",
  "type": "YouTube",
  "description": "Description here",
  "url": "https://youtu.be/VIDEO_ID",
  "thumbnail": "",
  "published": true
}
```

For Substack articles, use `"type": "Substack"`.

## ✅ Deployment Checklist

- [ ] GitHub repository created
- [ ] All files uploaded (index.html, data/, images/)
- [ ] GitHub Pages enabled
- [ ] Website is live and accessible
- [ ] Google Sheet created with 4 tabs
- [ ] Apps Script deployed as Web App
- [ ] Web App URL copied
- [ ] Web App URL added to index.html
- [ ] Sheet headers initialized
- [ ] Test form submitted successfully
- [ ] Test form data appears in Google Sheets
- [ ] Resources section loading correctly
- [ ] YouTube videos playing in modal
- [ ] All images loading correctly
- [ ] Mobile responsive view tested
- [ ] Calendly link working

## 🎉 You're Done!

Your website is now live with full functionality:
- ✅ Professional design
- ✅ Form submissions to Google Sheets
- ✅ Phone-based customer tracking
- ✅ Resource management via JSON
- ✅ Embedded YouTube videos
- ✅ Calendly integration
- ✅ Mobile responsive

---

**Need Help?** Check the troubleshooting section above or review the Google Sheets data to ensure everything is connecting properly.
