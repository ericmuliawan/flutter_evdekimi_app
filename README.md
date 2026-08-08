# flutter_evdekimi_app

Evdekimi app.

dummy user login 
"email": "eve.holt@reqres.in",
"password": "cityslicka"

"email": "michael.lawson@reqres.in",
"password": "pistol" 

MockAPI = https://app.reqres.in
Ai bot = Google genertive AI - Gemini
Ai on Device = llama - https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF/resolve/main/qwen2.5-0.5b-instruct-q4_k_m.gguf


#####My Ai Assistante#####

1. User: You and I are senior Flutter developers; we will build the application with great care and precision, always prioritizing clean code, architecture, and performance, while ensuring the UI runs smoothly across all devices.

2. User: As usual, I have `uikit` and `common` folders that serve as the foundational base before the build; now, let's adapt them to this project. Oh, and we'll be using BLoC for state management. also MVVM architecture

3. User: Okay, before we start building the UI, let's first ensure our app supports both dark and light modes.

4. User: why you not use or modif my UIKIT for appcolor to setup darkmode and lightmode

5. User: Now, let's start setting up the UI for authentication—specifically, the login and registration screens—with excellent UI/UX, you can add label "EVDEKimi" in center top

6. User: Please check main.dart. i already add some code, make sure its clean and run smoothly

7. User: oke next we will build home page chatbot screen, we will use google generative ai, using streaming responses

8. User: oke now after lgin succes, direct user to home screen chat bot

9. User: great UI, but we have some problem on chatbot, the respone chat always says "sorry something went wrong, please try again" i already checked on apikey but i think apikey its correct

10. User: why the response chat, its not like stream respone text by text

11. User: Why does the AI chatbot's response feel quite slow? Is there a specific buffer setting involved, and can we optimize it to make it faster?

12. User: Before we move on to the chat history storage feature, could we add a dark mode toggle button to the main screen to the left of the trash icon

13. User: Okay, now we're going to save the entire chat history to local storage so we can display it later in offline mode. Let's use SQLite, I find it to be the most stable option. What do you think?

14. User: It looks like we missed something yesterday: on the message sender side, we need to add a label displaying the username based on the login. Also, local storage should be specific to each logged-in user. Since the dummy API doesn't seem to provide a user ID, we can use the username for now so that message history remains separated between users.

15. User: oke now because my exmaple api register just needed only email and password like this "{"email": "eve.holt@reqres.in", "password": "pistol"}", so can we just update on function post api, dont update the ui

16. User: oke letsgo to implement ai llm on device, like my project before, the rules is if in offline mode will use ai on device, dont add in aseset, if offline and not downloaded model, will be appear popup to suggest dowbnload ai for offline mode

17. User: ah okay, can we add on chat message with speechtotext, i ever use flutter library speech_to_text, thats good plan or you have some suggest other thinks

18. User: next we will add option to upload image on chat bot, as I know, Google's generative AI can read images

19. User: please check we are forgot to set focus list chat on last message on bottom

20. User: last step, we are already implement ai on device with my rule, now explanation of how the architecture supports future on-device AI models on read me

## Setup Instructions

### Prerequisites
- Flutter 3.32.x (Dart SDK 3.8.x)
- iOS: Xcode 16.x + CocoaPods (installed via rbenv in this machine: `/Users/mac/.rbenv/versions/3.3.11/bin`)
- macOS: CocoaPods
- Android: Android Studio / SDK

If your `flutter` / `pod` binaries are not on `PATH`, export them first:
```bash
export PATH="$PATH:/Users/mac/development/flutter/bin:/Users/mac/.rbenv/versions/3.3.11/bin"
```

### Install & Run
```bash
flutter pub get
dart run build_runner build        # regenerates env.g.dart from .env (envied)
flutter analyze
flutter run                  # default device
flutter build web            # web verification build
flutter build ios --simulator --no-codesign
```

### Platform configuration
- **iOS / macOS**: minimum deployment target **13.0** (set in `ios/Podfile` and `ios/Runner.xcodeproj/project.pbxproj`). Required by `speech_to_text`. Add `llama.xcframework` (3 slices: ios-arm64, ios-arm64-simulator, macos-arm64) in Xcode for on-device LLM support.
- **Android**: `RECORD_AUDIO` + `INTERNET` permissions declared in `AndroidManifest.xml`. Add `llama-cpp-dart.aar` in `android/app/libs/` + `implementation files('libs/llama-cpp-dart.aar')` in Gradle for on-device LLM support.
- **Environment variables**: everything is managed with **envied** — edit `.env` (gitignored), then run `dart run build_runner build` to regenerate `lib/data/env/env.g.dart`. Required keys: `GEMINI_API_KEY`, `GEMINI_MODEL`, `BASE_URL`, `API_ACCESS_KEY`, `LLM_MODEL_URL`/`LLM_MODEL_FILE_NAME`/`LLM_MODEL_SIZE_BYTES`/`LLM_MODEL_MIN_BYTES`, plus `REVERB_*`. Free-tier Gemini is quota-limited and may return HTTP 429.
- **On-device model**: `qwen2.5-0.5b-instruct-q4_k_m.gguf` (~491 MB) is downloaded at runtime (never shipped as an asset) to the app documents dir. URL/size come from `Env` (`.env`).

### Known gotchas
- `connectivity_plus` is pinned to `>=7.0.0 <7.1.0` — 7.1.x+ references `NWPath.isUltraConstrained` (iOS 26 SDK only) and breaks compilation on older Xcode.
- Regenerate `env.g.dart` after any `.env` change, otherwise the app keeps the last generated values.
- `lib/data/env/env.g.dart` is gitignored (it bakes secrets into source and triggered GitHub push protection). After a fresh clone, run `dart run build_runner build` once before building.

## Architecture Decisions

### Stack
- **State management**: BLoC (`flutter_bloc`) + Cubit — UI is dumb, logic lives in cubits.
- **Architecture**: feature-first clean architecture. Each feature (`auth`, `chatbot`, `home`) is split into:
  - `data/` — datasources (remote/local), models, services (`datasources/`, `local/`, `models/`)
  - `domain/` — repositories (interfaces + impl), services
  - `presentation/` — cubits/states, pages, widgets
- **DI**: `get_it` service locator (`lib/common/di/service_locator.dart`).
- **Config**: envied-generated `Env` from `.env` (`lib/data/env/env.g.dart`).
- **Theme**: `ThemeCubit` above `MaterialApp`; `AppTheme` light/dark + system toggle from `uikit`.
- **Networking**: Dio with header/logger interceptors; `BaseProvider`.

### Chatbot
- **Online**: Gemini `generateContentStream` (SSE streaming), text streamed token-by-token into the assistant bubble.
- **Offline**: `llama_cpp_dart` runs Qwen2.5-0.5B on-device via `spawnFromProcess`; same streaming UX. The model is **downloaded at runtime** (dio, progress callback), never bundled.
- **Routing**: `ChatCubit` checks connectivity on every send → online → Gemini; offline + model → local LLM; offline + no model → download popup, message held as pending and auto-sent after download.
- **History**: SQLite per-user (`messages` table, `username` column), schema v3 with `image_bytes BLOB`; migrations handled by `_onUpgrade`. Web falls back to an in-memory stub (`sqflite`/`dart:io` are platform-gated via conditional imports).
- **Speech-to-text**: `speech_to_text` (on-device, no API key). One toggle button: mic standby when the field is unfocused, send arrow when focused.
- **Image upload**: `image_picker` → bytes stored as BLOB in SQLite → sent to Gemini as `DataPart` (multimodal). Offline LLM is text-only.
- **Sender labels**: bubbles show the login username above user messages, "EVDEKimi AI" above assistant.

### Cross-platform strategy
- Native-only plugins (`llama_cpp_dart`, `sqflite`) are behind abstract interfaces + factories with io/web stub implementations, so the web build compiles and runs (in-memory, no native LLM).

### On-device AI & future model support
The offline LLM is designed so a different (or bigger) on-device model can be swapped in without touching the chat UI, persistence, or routing logic. The seam is three layers:

1. **Model inference — `ILlmInferenceService`** (`domain/services/llm_inference_service.dart`)
   Exposes a single streaming contract: `Stream<String> chatStream({history, message})`. Today the io implementation runs Qwen2.5-0.5B through `llama_cpp_dart` (`llm_inference_service_io.dart`). Because everything downstream consumes chunks from a `Stream<String>`, any future model (a larger GGUF, a distilled variant, Whisper for offline STT, etc.) only needs a new implementation of this one interface — the live-updating bubble, SQLite persistence, and error handling are unchanged.

2. **Model download — `ILlmModelDownloader`** (`data/datasources/llm_model_downloader.dart`)
   Abstracts *how/where* a model file is obtained: `modelFilePath`, `isModelDownloaded()`, `download(onProgress)` (runtime download via dio with progress reporting, never bundled as an asset; integrity checked against a minimum byte size). The **model identity lives entirely in `.env`** — `LLM_MODEL_URL`, `LLM_MODEL_FILE_NAME`, `LLM_MODEL_SIZE_BYTES`, `LLM_MODEL_MIN_BYTES` — so pointing the app at a new model is a `.env` change plus `dart run build_runner build`, no Dart code.

3. **Routing — `ChatCubit._prepareAndRoute`** (`presentation/cubits/chat_cubit.dart`)
   Implements the project rule: **online → Gemini; offline + model present → on-device; offline + no model → download popup, message held as pending and auto-sent once downloaded.** Routing is connectivity-driven, so adding a new offline model does not change when it is used.

**Platform strategy**: inference and downloader are behind factories with conditional imports (`if (dart.library.io)`). `_io.dart` = real native runtime (llama.xcframework / .aar); `_stub.dart` = web fallback (throws `UnsupportedError`), so the web build still compiles and runs (online Gemini path) without native LLM binaries.

**Why this scales**: swapping models = new `ILlmInferenceService` impl (or a `.env` tweak for a different GGUF). No changes to `ChatMessage`, the local DB schema, streaming UI, or the offline popup/download flow. The one stream contract (`Stream<String>`) is the single extension point the whole chat pipeline is built around.


