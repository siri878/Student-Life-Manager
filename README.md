# Student Life Manager — Flutter Lab Project

A small student planner app built to demonstrate the topics in the lab record.

## Run it

1. Install Flutter and Android Studio (or another Flutter-supported editor).
2. Open this folder in your editor.
3. In a terminal in this folder, run:

   ```bash
   flutter pub get
   flutter run
   ```

## Features

- Dart classes and basic variables
- Material widgets, `Row`, `Column`, `ListView`, and `Stack`-ready Flutter layout concepts
- Responsive layout using `MediaQuery`, `ConstrainedBox`, and a width breakpoint
- Named routes with `Navigator.pushNamed` and `pushReplacementNamed`
- Stateless and stateful widgets
- State management using `Provider` and `ChangeNotifier`
- Reusable custom widgets
- App-wide theme and input styling
- Form fields, validation, controllers, and error messages
- Animation using `AnimatedContainer`, `AnimatedDefaultTextStyle`, and progress changes

## Lab-record topic mapping

| Lab topic | Where to find it |
|---|---|
| Install Flutter / SDK and Dart basics | Project setup and `main.dart` |
| Flutter widgets | `HomeScreen`, `TaskTile`, `ProfileScreen` |
| Row, Column and layout widgets | `HomeScreen`, `_QuickActionCard`, `AddTaskScreen` |
| Responsive UI / media queries / breakpoints | `HomeScreen` uses `MediaQuery` and `width >= 650` |
| Navigation and named routes | `MaterialApp.routes`, `AppNavigation` |
| Stateful and stateless widgets | `AddTaskScreen` is stateful; dashboard and profile are stateless |
| `setState` / Provider state management | Provider `TaskStore` with `ChangeNotifier` |
| Custom widgets and themes | `_QuickActionCard`, `TaskTile`, `ThemeData` |
| Form inputs and validation | `AddTaskScreen` |
| Error handling | `Form` validators and save guard |
| UI animations | `AnimatedContainer`, `AnimatedDefaultTextStyle`, progress indicator |

Note: This project uses Provider as the main state-management demonstration. The `setState` method is Flutter's built-in alternative for managing local state in a `StatefulWidget`.

## Publish on Vercel (Flutter Web)

This repository includes `build.sh` and `vercel.json` for a Vercel build. Push the project files to GitHub, import that repository in Vercel, and deploy with the project root set to this folder. Vercel should use `bash build.sh` as the build command and `build/web` as the output directory (configured in `vercel.json`). The first build downloads the Flutter SDK and may take several minutes. After deployment, open the Vercel URL in a browser.

Note: The Vercel build depends on network access to download Flutter and may need adjustments if Vercel's build environment changes. Test the deployment before sharing it as a finished app.
