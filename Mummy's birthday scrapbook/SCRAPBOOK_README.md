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

## How to Add Your Video Presentations

**All four presentations are now MP4 videos embedded directly in the website.**

### Add your video files

1. Place your video files in the `static/` folder.
2. Name them exactly as follows:
   - `early_days_video.mp4`
   - `everyday_adventures.mp4`
   - `adventure_years.mp4`
   - `our_journey_continues.mp4`
3. Supported formats: MP4, WebM, OGV.

### Notes

- The first modal now shows a video instead of a Canva embed.
- The other three presentation cards also now play MP4 videos.
- If you want to switch back to Canva embeds later, open `templates/index.html` and replace the `<video>` sections with Canva `<iframe>` embeds.

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
