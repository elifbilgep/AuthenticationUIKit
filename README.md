# Authentication UIKit

A modern iOS authentication application built with UIKit, showcasing clean architecture and best practices in iOS development. This project includes both the iOS client and a custom-built Node.js/Express authentication service ([Authentication Service Repository](https://github.com/elifbilgep/BasicNodeJsAndExpressAuthService)) to provide a complete end-to-end authentication solution.

## Features

- Complete authentication system with custom Node.js/Express backend
- User Registration and Login
- Profile Management
- Users List View
- Token-based Authentication
- Auto Token Refresh
- Secure API Communication
- Responsive UI with UICollectionView
- Tab Bar Navigation

## Architecture

The project follows the MVVM (Model-View-ViewModel) architecture pattern with the following components:

### Core Components

- **Views**: Custom UIKit views with programmatic auto-layout
- **ViewControllers**: Managing view lifecycle and user interactions
- **ViewModels**: Business logic and data transformation
- **Services**: Network and authentication handling

### Key Services

- `AuthService`: Handles all authentication-related API calls
- `NetworkService`: Generic network layer with token refresh mechanism
- `AppManager`: Manages application state and authentication
- `UserDefaultsManager`: Handles local data persistence

## Technical Stack

- Language: Swift
- UI Framework: UIKit
- Networking: Alamofire
- Asynchronous Programming: Combine, async/await
- Data Persistence: UserDefaults
- Layout: Programmatic Auto Layout
- Pattern: MVVM

## Project Structure

```
AuthenticationUIKit/
├── Views/
│   ├── HomeView
│   ├── ProfileView
│   ├── SignInView
│   └── SignUpView
├── ViewControllers/
│   ├── HomeViewController
│   ├── ProfileViewController
│   ├── SignInViewController
│   └── SignUpViewController
├── ViewModels/
│   ├── HomeViewModel
│   ├── ProfileViewModel
│   └── SignUpViewModel
└── Services/
    ├── AuthService
    └── NetworkService
```

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.5+

## Setup

1. Clone the repository
2. Install dependencies (if using CocoaPods or Swift Package Manager)
3. Open `AuthenticationUIKit.xcodeproj`
4. Build and run the project

## Backend API

The application communicates with a REST API running on `http://localhost:3000` with the following endpoints:

- `/register` - User registration
- `/login` - User authentication
- `/refresh-token` - Token refresh
- `/logout` - User logout
- `/users` - Fetch all users
- `/user` - Fetch current user

## Authentication Flow

1. User registers/logs in
2. Server returns authentication token
3. Token is stored securely
4. Subsequent requests include token
5. Auto-refresh mechanism handles expired tokens
6. Logout clears stored tokens

## Error Handling

The application includes comprehensive error handling for:

- Network errors
- Authentication failures
- Token refresh failures
- Invalid data
- Server errors

## Future Improvements

- Add unit and UI tests
- Enhance error handling
- Implement push notifications
- Add user search functionality
- Enhance profile management features
