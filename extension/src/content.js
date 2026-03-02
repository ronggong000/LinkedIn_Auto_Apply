function extractJobContext() {
  const roleTitle = document.querySelector("h1")?.innerText?.trim() || null;
  const companyName = document.querySelector('[data-automation="advertiser-name"]')?.innerText?.trim() || null;
  const description = document.body.innerText.slice(0, 12000);

  return {
    roleTitle,
    companyName,
    description,
    url: window.location.href
  };
}

function fillInputByLabel(labelKeywords, value) {
  if (!value) return false;

  const labels = Array.from(document.querySelectorAll("label"));
  const target = labels.find((label) => {
    const text = label.innerText.toLowerCase();
    return labelKeywords.some((k) => text.includes(k));
  });

  if (!target) return false;

  const inputId = target.getAttribute("for");
  const input = inputId ? document.getElementById(inputId) : target.querySelector("input, textarea");
  if (!input) return false;

  input.focus();
  input.value = value;
  input.dispatchEvent(new Event("input", { bubbles: true }));
  input.dispatchEvent(new Event("change", { bubbles: true }));
  return true;
}

chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.type === "EXTRACT_JOB_CONTEXT") {
    sendResponse({ ok: true, result: extractJobContext() });
    return true;
  }

  if (message.type === "AUTOFILL_FORM") {
    const p = message.payload || {};
    const result = {
      salary: fillInputByLabel(["salary", "expected salary"], p.salary),
      visa: fillInputByLabel(["visa", "work rights", "sponsorship"], p.visa),
      noticePeriod: fillInputByLabel(["notice", "available from"], p.noticePeriod)
    };
    sendResponse({ ok: true, result });
    return true;
  }

  return false;
});
