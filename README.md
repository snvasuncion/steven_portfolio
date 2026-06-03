# Steven Nikko V. Asuncion — Portfolio

A responsive Flutter portfolio website showcasing projects, skills, and professional experience. Built with Flutter for web, Android, and iOS.

## ✨ Features

- **Responsive Design** — Adaptive layout for desktop (sidebar + nav bar) and mobile (drawer menu)
- **Dark / Light Mode** — Full theme toggle with custom color schemes
- **Splash Animation** — Animated brand intro with staggered fade-scale transitions
- **Project Showcase** — Filterable project cards with GitHub and live demo links
- **Contact Form with Moderation** — Visitors leave messages that go through an approval queue
- **Admin Panel** — Password-protected interface to approve / reject messages before publishing
- **Interactive Cards** — Hover animations with dynamic shadows and elevation
- **Custom Toast Notifications** — Animated success / error overlays with progress bars
- **Optimized for Web** — SEO meta tags, PWA manifest, Open Graph preview

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) 3.24.x or later

### Run Locally

```sh
flutter pub get
flutter run -d chrome
```

### Build for Web

```sh
flutter build web --release --dart-define=ADMIN_PASSWORD=your_password_here
```

The `ADMIN_PASSWORD` must match what you enter in the admin panel dialog.

### Run Tests

```sh
flutter test
```

## 🏗️ Architecture

```
lib/
├── blocs/              # State management (NavigationBloc, ThemeCubit)
├── config.dart         # Build-time environment configuration
├── data/               # Data provider (single source of truth)
├── models/             # Data models (Project)
├── utility/            # Shared widgets & helpers (animations, toast, formatters)
├── viewmodels/         # View models that read from DataProvider
├── views/              # UI screens (HomePage, About, Projects, Contact, Admin)
└── main.dart           # App entry point
```

## 📦 Deployment

### Vercel (recommended)

A `vercel.json` is included. Connect your GitHub repo to Vercel and set the `ADMIN_PASSWORD` environment variable in the Vercel dashboard.

### GitHub Actions

The included `.github/workflows/ci.yml` workflow runs `flutter analyze` and builds for web on every push. Set `ADMIN_PASSWORD` as a repository secret for the build step.

## 🛠️ Built With

- **Flutter** & **Dart**
- **flutter_bloc** — State management
- **google_fonts** — Typography
- **flutter_svg** — SVG rendering
- **font_awesome_flutter** — Icon set
- **url_launcher** — External link handling
- **shimmer** — Splash and loading effects
- **http** — REST API calls (MockAPI backend)

## 📄 License

Private — All rights reserved.
