# Changes

## 2026-10-20 — Two Sum fixed-history evaluation

- `evals/two-sum/scenarios.json`: added 40 frozen Two Sum interview turns across clarification, approach, hints, misconceptions, memory, progression, and code review, with behavior-based expectations and no hidden test inputs.
- `evals/two-sum/run.mjs`, `evals/two-sum/checks.mjs`: added a headless runner that calls the existing interviewer API for one reply per scenario, captures real stream/tool events, checks deterministic constraints, optionally obtains labeled Ollama judge assessments, and writes JSON/Markdown reports.
- `evals/two-sum/checks.test.mjs`, `evals/two-sum/README.md`, `evals/two-sum/baseline-observations.md`, `evals/two-sum/baselines/2026-10-20/`, `evals/two-sum/.gitignore`: added dataset/check validation, execution instructions and replay limits, a versioned baseline report with preliminary observations, and ignored ad hoc reports. Production interviewer behavior was not changed.

Lint: `npm run lint` passed with zero errors. Dataset/check tests: `node --test evals/two-sum/checks.test.mjs` passed (4 tests). All 40 scenarios executed against the local Ollama interviewer API; 31 passed and 9 failed deterministic checks after correcting overstrict tool expectations. One optional local-judge smoke case returned valid rubric JSON; semantic judge assessments remain model-generated and are not included in the 40-case deterministic baseline.

Smoke-test checklist:
- Start Ollama and `npm run dev`, then run `node evals/two-sum/run.mjs --ids approach-01` and inspect the generated reply and checks.
- Run `node evals/two-sum/run.mjs` for all 40 frozen replies; review representative failures and uncertain semantic judgments.
- Optionally run with `--judge-model <installed-ollama-model>` and audit the judge's evidence before using scores as a baseline.

## 2026-10-19 — Keyless local models

- `lib/ai-models.ts`, `lib/interviewer-model.ts`, `lib/feedback.ts`, `lib/providers/openai.ts`, `lib/resolve-provider-key.ts`, `lib/ai-errors.ts`: made the installed Ollama Qwen3 4B Instruct model the keyless default for interviewer turns and feedback, using Ollama's local OpenAI-compatible endpoint. Saved model choice moved to v3 so prior cloud selections reset once.
- `lib/local-speech.ts`, `types/sherpa-onnx-node.d.ts`, `app/api/transcribe/route.ts`, `app/api/tts/route.ts`, `lib/speech.ts`, `lib/groq-ambient.ts`, `next.config.ts`: replaced cloud voice calls with offline Moonshine transcription and Piper TTS, decoding microphone audio with ffmpeg and returning the existing JSON/WAV route contracts.
- `scripts/setup-local-models.sh`, `scripts/Modelfile`, `package.json`, `package-lock.json`, `.gitignore`: added the native speech runtime, idempotent model setup, a 32k Ollama context preset, and ignored model files.
- `components/ChatPanel.tsx`, `lib/byok-mode.ts`, `app/api/interviewer/route.ts`: hid the API Keys button for the local model and bypassed the cloud at-capacity gate in local mode.
- `.env.example`, `README.md`, `CLAUDE.md`, `PROJECT-NOTES.md`, `AGENTS.md`: documented the no-key Ollama setup, offline voice dependencies, and optional cloud presets.

Lint: `npm run lint` passed with zero errors. Type check: `npx tsc --noEmit` passed. Local Ollama returned text and a tool call; the configured preset loaded with 32k context; `/api/transcribe` returned a sample transcript and `/api/tts` returned playable WAV bytes through `npm run dev`.

Smoke-test checklist:
- Start Ollama and `npm run dev`; open a fresh interview and confirm Local Qwen3 4B is selected with no API Keys prompt.
- Send a typed message and generate the final scorecard.
- Record a focused mic message, allow an ambient coding chunk, and play Alex's voice.
- Confirm Judge0 visible and hidden test runs still work through the configured Judge0 endpoint.

## 2026-10-19 — Gemini across the interview

- `lib/ai-models.ts`: made Gemini 2.5 Flash the default and versioned the saved model choice so existing OpenAI selections reset once.
- `app/api/interviewer/route.ts`, `components/AtCapacity.tsx`, `components/ByokGate.tsx`, `lib/byok-mode.ts`: aligned the at-capacity BYOK gate with Gemini.
- `app/api/transcribe/route.ts`, `lib/speech.ts`, `lib/groq-ambient.ts`: send focused and ambient audio to Gemini 2.5 Flash for transcription, retaining the client response shape.
- `app/api/tts/route.ts`: generate WAV speech with Gemini 3.8 Flash TTS using the same Gemini key.
- `components/ByokDrawer.tsx`, `lib/byok.ts`: removed the unused ElevenLabs key option.
- `.env.example`, `README.md`, `CLAUDE.md`, `PROJECT-NOTES.md`, `AGENTS.md`: documented the Gemini default and one-key voice setup.

Lint: `npm run lint` passed with zero errors. Type check: `npx tsc --noEmit` passed.

Smoke-test checklist:
- Restart `npm run dev` and confirm Gemini 2.5 Flash is selected in a fresh interview.
- Send a typed message and generate feedback without an OpenAI key error.
- Record one focused utterance, allow one ambient chunk, and play one spoken reply.
- If BYOK mode is used, confirm the at-capacity page accepts a Gemini key.

## 2026-10-19

- `.env.local`: configured the existing Gemini API key for local interviewer requests using the Gemini preset; kept the file ignored and restricted to the current user.
- `.env.example`: removed the populated Gemini key so the tracked template no longer carries a credential.
- `docs/CHANGES.md`: recorded the local configuration change.

Lint: `npm run lint` passed with zero errors.

Smoke-test checklist:
- Restart `npm run dev` so Next.js loads `.env.local`.
- In the interview workspace, open Advanced and choose Gemini 2.5 Flash as the Interviewer.
- Send an interview message and confirm the missing OpenAI key error does not appear.
