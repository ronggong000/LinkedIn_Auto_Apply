# Chrome Extension MVP Skeleton

This folder contains a lightweight Manifest V3 skeleton for Seek application assistance.

## Directory Structure

```text
extension/
  manifest.json
  src/
    background.js
    content.js
    popup.html
    popup.js
    styles.css
```

## Responsibilities

- **content.js**
  - Detect Seek application pages.
  - Extract visible job metadata and application fields.
  - Fill known form fields (salary, visa, notice period, skills).
  - Upload generated resume/cover letter files when available.

- **background.js**
  - Receive events from content script.
  - Call backend APIs for JD parsing and content generation.
  - Persist temporary state in `chrome.storage.local`.

- **popup.js / popup.html**
  - Trigger analysis and autofill actions.
  - Show status (idle / generating / ready / review needed).

## Security Notes

- Request minimum permissions only.
- Never hardcode API keys in extension bundle.
- Use short-lived backend session tokens.

## Next Steps

1. Connect `background.js` to backend endpoints:
   - `POST /api/jd/parse`
   - `POST /api/documents/generate`
   - `POST /api/questions/suggest`
2. Improve selector strategy with fallback matching.
3. Add a review modal before final submit action.

