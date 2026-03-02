const statusEl = document.getElementById("status");

document.getElementById("analyze").addEventListener("click", async () => {
  setStatus("extracting JD...");
  const tab = await getActiveTab();
  const context = await sendToTab(tab.id, { type: "EXTRACT_JOB_CONTEXT" });
  if (!context.ok) return setStatus("failed to read page context");

  const parsed = await sendToBackground({ type: "PARSE_JD", payload: context.result });
  setStatus(parsed.ok ? "JD parsed" : `parse failed: ${parsed.error}`);
  if (parsed.ok) {
    await chrome.storage.local.set({ parsedJd: parsed.result, jobContext: context.result });
  }
});

document.getElementById("generate").addEventListener("click", async () => {
  setStatus("generating documents...");
  const state = await chrome.storage.local.get(["parsedJd", "jobContext"]);
  const payload = { parsedJd: state.parsedJd, jobContext: state.jobContext };
  const generated = await sendToBackground({ type: "GENERATE_DOCS", payload });
  setStatus(generated.ok ? "documents ready" : `generation failed: ${generated.error}`);
  if (generated.ok) {
    await chrome.storage.local.set({ generatedDocs: generated.result });
  }
});

document.getElementById("autofill").addEventListener("click", async () => {
  setStatus("autofilling...");
  const tab = await getActiveTab();
  const result = await sendToTab(tab.id, {
    type: "AUTOFILL_FORM",
    payload: {
      salary: "AUD 120000",
      visa: "Full working rights in Australia",
      noticePeriod: "2 weeks"
    }
  });
  setStatus(result.ok ? "autofill complete (review before submit)" : "autofill failed");
});

async function getActiveTab() {
  const tabs = await chrome.tabs.query({ active: true, currentWindow: true });
  return tabs[0];
}

function sendToBackground(message) {
  return chrome.runtime.sendMessage(message);
}

function sendToTab(tabId, message) {
  return chrome.tabs.sendMessage(tabId, message);
}

function setStatus(text) {
  statusEl.textContent = `Status: ${text}`;
}
