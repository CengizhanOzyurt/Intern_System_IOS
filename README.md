# Yaz Bilgi Intern Task Management System (iOS)

## Overview
This is the **iOS version** of the Intern Task Management System, built with **Swift** and **Xcode**.  
The mobile app allows users to log in and, upon successful authentication, view a personalized welcome screen.  
It integrates with the ASP.NET Core backend API used in the web version.  

---

## Features
- User authentication (login)  
- Personalized home screen showing the user’s name after login  
- Integration with RESTful API endpoints from the backend  
- Simple and user-friendly iOS UI  

---

## Technology Stack
- **Language**: Swift 5  
- **Framework**: UIKit / SwiftUI  
- **IDE**: Xcode 15+  
- **Backend**: ASP.NET Core Web API (PostgreSQL + Swagger)  

---

## Project Structure
- **Intern System.xcodeproj**: Main Xcode project file  
- **AppDelegate.swift**: Application lifecycle management  
- **SceneDelegate.swift**: Scene/session management  
- **LoginView.swift**: Login screen implementation  
- **HomeView.swift**: Home (welcome) screen implementation  
- **Models.swift**: Data models  
- **APIClient.swift**: REST API client to communicate with backend  

---

## Prerequisites
- Xcode 15+  
- iOS 17+ Simulator or a real iOS device  
- Running ASP.NET Core backend API (for login and task endpoints)  

---

## Setup and Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Intern_System_IOS
   ```

2. **Open the project in Xcode**
   - Double click `Intern System.xcodeproj`

3. **Run the application**
   - Select a simulator or device  
   - Press `⌘R` to build and run  

4. **Login**
   - Use valid credentials connected to the backend API  

---

## Screenshots

### Login Screen
![Login Screen](/images/images/login.png)
### Home Screen
![Home Screen](/Intern System/images/home.png)

---

## API Endpoints
The iOS app communicates with the same backend API as the web project:
- **User Login** → `/api/HomeApi/login`  
- **Task Management** → `/api/Task`  

Endpoints can be tested via Swagger UI at `/swagger`.  

---

## License
This project is licensed under the MIT License - see the LICENSE file for details.
