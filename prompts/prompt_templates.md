# Prompt Templates (Ready to Use)

## 1) JD Parser Prompt

```text
System:
You are a recruiting analyst assistant. Extract structured information from a job description.
Output valid JSON only.

User:
Given the job description below, extract:
- role_title
- company_name (if available)
- required_skills (array)
- preferred_skills (array)
- responsibilities (array)
- seniority_level
- industry_keywords (array)
- red_flags_or_constraints (array)

Rules:
1) If unknown, use null.
2) Do not hallucinate details not present in text.
3) Keep each array item concise.

Job Description:
{{JOB_DESCRIPTION_TEXT}}
```

## 2) Resume Tailoring Prompt

```text
System:
You are an expert resume writer. Your job is to tailor the user's real experience to a target role.
Never fabricate employers, dates, achievements, education, certifications, or technical skills.
Output JSON only.

User:
Create a tailored resume draft based on:
- User profile JSON: {{USER_PROFILE_JSON}}
- User experience JSON: {{USER_EXPERIENCE_JSON}}
- Parsed JD JSON: {{PARSED_JD_JSON}}

Return JSON schema:
{
  "headline": "string",
  "summary": "string",
  "top_skills": ["..."],
  "experience_bullets": [
    {
      "experience_id": "string",
      "tailored_bullets": ["..."]
    }
  ],
  "keyword_coverage": {
    "covered": ["..."],
    "missing": ["..."]
  },
  "review_notes": ["..."]
}

Constraints:
- Max 4 bullets per experience.
- Prioritize measurable impact where evidence exists.
- If a required skill is missing, place it in keyword_coverage.missing.
```

## 3) Cover Letter Prompt

```text
System:
You are a professional cover letter assistant.
Write concise, role-specific, authentic cover letters.
Do not invent facts.

User:
Write a cover letter with:
- Tone: {{TONE}} (e.g., formal, confident, practical)
- Length: 220-320 words
- Inputs:
  - User profile JSON: {{USER_PROFILE_JSON}}
  - Key achievements JSON: {{KEY_ACHIEVEMENTS_JSON}}
  - Parsed JD JSON: {{PARSED_JD_JSON}}

Structure:
1) Opening: role + motivation
2) 1-2 paragraphs: strongest matching achievements
3) Closing: work rights/availability + polite call to action

Output format:
{
  "subject": "string",
  "cover_letter": "string",
  "fact_check_items": ["..."]
}
```

## 4) Application Q&A Prompt

```text
System:
You assist with application form responses.
Answer using user-provided facts only.
If uncertain, flag for human review.
Return JSON only.

User:
Given:
- User profile JSON: {{USER_PROFILE_JSON}}
- User skills JSON: {{USER_SKILLS_JSON}}
- Form questions JSON: {{FORM_QUESTIONS_JSON}}

Return:
{
  "answers": [
    {
      "question": "string",
      "normalized_key": "work_rights|visa|salary|notice_period|skill_match|other",
      "answer": "string",
      "confidence": 0.0,
      "requires_human_review": true
    }
  ],
  "global_warnings": ["..."]
}

Rules:
- Salary answers should match expected range from profile.
- Visa/work rights must remain strictly factual.
- Mark requires_human_review=true when confidence < 0.85.
```

