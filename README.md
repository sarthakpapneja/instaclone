# Instagram Home Feed Clone - Flutter UI/UX Challenge

A "Pixel-Perfect" replication of the Instagram Home Feed built with Flutter. This project demonstrates advanced UI/UX patterns, clean architecture, and complex gesture handling.

## Features

- **Pixel-Perfect UI**: Replicated the Home Feed exactly, including the logo, icons, stories tray, and post structure.
- **Advanced Media Handling**:
  - **Horizontal Carousel**: Multi-image posts with smooth scrolling and synchronized dot indicators.
  - **Pinch-to-Zoom**: Custom implementation that scales images over the UI and animates back on release.
- **Stateful Interactions**: Local toggling for "Like" (heart) and "Save" (bookmark) states.
- **Lazy Loading (Infinite Scroll)**: Automatically fetches the next page of posts when the user nears the bottom.
- **Shimmer Effects**: Professional loading states for stories and posts using the `shimmer` package.
- **Custom Snackbars**: Persisting feedback for unimplemented features (Share, Comments).
- **Clean Architecture**: Separation of concerns into `models`, `widgets`, `providers`, and `services`.

## Technical Choices

- **State Management**: **Provider**. Chosen for its simplicity and efficiency in managing local state and dependency injection across the widget tree.
- **Image Handling**: `cached_network_image` for memory and disk caching techniques.
- **Dependency Injection**: Simple DI pattern using `MultiProvider` at the root.
- **Responsiveness**: Built with flexible layouts to handle different aspect ratios and screen sizes.

## Project Structure

```text
lib/
├── models/         # Data structures (User, Post, Story)
├── pages/          # Full screen widgets (HomeFeedPage)
├── providers/      # State management logic (FeedProvider)
├── services/       # Data fetching logic (PostRepository)
├── theme/          # App design system and tokens
└── widgets/        # Reusable UI components (PostCard, StoryTray, etc.)
```

## How to Run

1. **Clone the repository** (if not already local).
2. **Install Flutter SDK**: If not installed, follows the instructions at [flutter.dev](https://docs.flutter.dev/get-started/install).
3. **Execute the following commands**:

   ```bash
   # Get dependencies
   flutter pub get
   
   # Run the application (replace `chrome` with `macos` or `android` if needed)
   flutter run -d chrome
   ```

## Design Aesthetics

- **Dark Mode Support**: Fully themed for both light and dark modes.
- **Premium Typography**: Uses `Google Fonts (Inter)` for a modern, sleek feel.
- **High-Quality Assets**: Uses high-resolution mock images and custom-drawn SVGs.
