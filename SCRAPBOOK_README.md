# Mummy's Birthday Digital Scrapbook 🌹

A beautiful, interactive timeline scrapbook celebrating your memories with your Mummy. Built with Python Flask and gorgeous red floral styling.

## Features

✨ **4 Interactive Timeline Buttons:**
- 👶 Baby Years
- 🧒 Toddler Years  
- 📚 School Years
- 🌟 Teen Years

💝 **Beautiful Design:**
- Red and pink floral color scheme
- Smooth animations and hover effects
- Responsive design (works on desktop and mobile)
- Birthday scrapbook aesthetic

## Setup

### 1. Install Flask

```bash
pip install -r requirements.txt
```

### 2. Run the App

```bash
python mom_scrapbook_app.py
```

The app will start at `http://localhost:5000`

## How to Add Your Canva Presentations

**All presentations are embedded directly in the website - no linking to external sites!**

1. **Create 4 slideshows on Canva:**
   - Go to [Canva.com](https://www.canva.com)
   - Create 4 presentations for each timeline period
   - Make them beautiful with your photos!

2. **Get the embed link for each presentation:**
   - In Canva, click the **Share** button
   - Click **Embed**
   - Copy the **embed link** (it will look like: `https://www.canva.com/design/DXXXXXXXXXX/view?embed`)

3. **Add the links to your website:**
   - Open `templates/index.html`
   - Find these placeholders:
     - `YOUR_BABY_DESIGN_ID`
     - `YOUR_TODDLER_DESIGN_ID`
     - `YOUR_SCHOOL_DESIGN_ID`
     - `YOUR_TEEN_DESIGN_ID`
   - Replace them with your actual Canva embed links

**Example:**
```html
<!-- Before -->
<iframe class="canvas-embed" src="https://www.canva.com/design/YOUR_BABY_DESIGN_ID/view?embed" allowfullscreen></iframe>

<!-- After -->
<iframe class="canvas-embed" src="https://www.canva.com/design/DAXYZ1234567/view?embed" allowfullscreen></iframe>
```

4. **Refresh your browser** and click the buttons - your presentations will pop up in a beautiful modal!

## Customization

You can customize the scrapbook by editing `templates/index.html`:

- **Change titles:** Edit the `<h2 class="card-title">` text
- **Change ages/descriptions:** Edit the `<p class="card-age">` text  
- **Change emojis:** Replace the emoji in `<span class="card-emoji">` 
- **Change colors:** Look for `#c41e3a` (red) or `#d63652` (pink) in the CSS and modify

## Files Included

- `mom_scrapbook_app.py` - Flask application (Python backend)
- `templates/index.html` - Beautiful HTML template with CSS styling
- `requirements.txt` - Dependencies

---

**Made with 💖 for Mummy's Birthday!**
