# 🏘️ Colony — Location-Based Social Community App

This repository houses the entire **Colony** project, including the Flutter frontend and self-hosted backend infrastructure.

## 📂 Project Structure

The project has been rearranged to follow a clean, structured repository layout:

```
colony-app/
├── frontend/                  # Flutter mobile app
│   ├── android/
│   ├── ios/
│   ├── lib/                   # Feature-first Dart code
│   ├── test/
│   ├── pubspec.yaml
│   └── ...
│
├── backend/                   # Self-hosted backend infrastructure (WSL compatible)
│   ├── bin/                   # Binary tools (e.g. supabase.exe)
│   ├── database/              # Schema setup files (e.g. QUICK_DATABASE_SETUP.sql)
│   ├── docker/                # Docker compose files (Supabase local stack)
│   ├── docs/                  # Project status guides & setup documentation
│   ├── scripts/               # Deployment, tunnel, and verification scripts
│   └── supabase_cli/          # Supabase CLI configurations & local migrations
│
├── push-backend.sh            # Root utility script to sync the backend/ folder to colony-backend repo
└── .gitignore                 # Repo-level ignore file (tracks configs/secrets in dev phase)
```

---

## 🚀 Quick Start — Backend (WSL Setup)

To run the backend environment inside Windows Subsystem for Linux (WSL), fetch the latest backend codebase and run the setup scripts from the root:

```bash
# 1. Start the main environment setup (installs Docker, Coolify, and Supabase)
bash backend/scripts/setup.sh

# 2. Run the Cloudflare permanent tunnel setup (configure DNS, routing, and certs)
bash backend/scripts/cloudflare-setup.sh

# 3. Start the tunnel daemon
bash backend/scripts/tunnel.sh start

# 4. Verify that all backend services are healthy and running
bash backend/scripts/verify.sh
```

---

## 📱 Quick Start — Frontend (Flutter Mobile App)

Ensure you have Flutter SDK installed (`>= 3.11.4`).

```bash
# 1. Navigate to frontend directory
cd frontend

# 2. Install dependencies
flutter pub get

# 3. Run on a connected device/emulator
flutter run
```

---

## 🔄 Git Subtree Synchronization Strategy

This repository (`colony-app`) contains the full project. The `backend/` directory is mirrored to a standalone [colony-backend](https://github.com/devamskshinde/colony-backend) repository for modular deployments.

To stage, commit, and push changes to both repositories at once, run:

```bash
# Run from the root of colony-app
bash push-backend.sh "Your commit message"
```

This script will:
1. Commit all local changes in `colony-app`.
2. Push `colony-app` to the main repository (`origin master`).
3. Split the `backend/` folder and push it to the `colony-backend` repository (`colony-backend master`).
