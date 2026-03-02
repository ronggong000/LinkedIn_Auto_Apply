const API_BASE = "http://localhost:8000";

chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.type === "PARSE_JD") {
    parseJd(message.payload)
      .then((result) => sendResponse({ ok: true, result }))
      .catch((error) => sendResponse({ ok: false, error: error.message }));
    return true;
  }

  if (message.type === "GENERATE_DOCS") {
    generateDocs(message.payload)
      .then((result) => sendResponse({ ok: true, result }))
      .catch((error) => sendResponse({ ok: false, error: error.message }));
    return true;
  }

  return false;
});

async function parseJd(payload) {
  const res = await fetch(`${API_BASE}/api/jd/parse`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload)
  });
  if (!res.ok) {
    throw new Error(`Failed to parse JD: ${res.status}`);
  }
  return res.json();
}

async function generateDocs(payload) {
  const res = await fetch(`${API_BASE}/api/documents/generate`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload)
  });
  if (!res.ok) {
    throw new Error(`Failed to generate docs: ${res.status}`);
  }
  return res.json();
}
