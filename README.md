# Seek Auto Apply Accelerator

An AI-assisted job application accelerator focused on **Seek** workflows.

This project helps candidates reduce repetitive work by:
- generating and tailoring resume content for each role,
- generating role-specific cover letters,
- answering common application questions (skills, salary, visa/work rights),
- and assisting with browser-based form filling before final human submission.

> Goal: speed up applications while keeping users in control and preserving data accuracy.

## Project Status

This repository currently provides:
- product planning documents,
- initial database schema draft,
- reusable prompt templates,
- Chrome extension MVP architecture and code skeleton.

Implementation can proceed incrementally from semi-automated flow to deeper automation.

## Quick Start (Planning Artifacts)

1. Read product requirements: [`docs/PRD_zh-CN.md`](docs/PRD_zh-CN.md)
2. Review data model SQL draft: [`db/schema.sql`](db/schema.sql)
3. Reuse prompt templates: [`prompts/prompt_templates.md`](prompts/prompt_templates.md)
4. Build extension MVP from skeleton: [`extension/README.md`](extension/README.md)

## Recommended MVP Scope

- User profile and skill library input
- JD parsing into structured output
- Resume and cover letter generation
- Seek form auto-fill with **human confirmation before submit**

## Compliance & Safety Notes

- Do not fabricate user facts (education/work rights/experience).
- Keep sensitive data encrypted at rest and in transit.
- Respect platform terms; prefer “assistive automation” with user confirmation.

## Roadmap (High Level)

- **Phase 1**: PRD and schema lock
- **Phase 2**: AI generation pipeline
- **Phase 3**: Seek extension auto-fill
- **Phase 4**: reliability, audit logs, and quality scoring

