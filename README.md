A Flutter-based mobile document scanning app with a Laravel backend for file storage and MySQL database management.

## 📦 Requirements

Before starting, make sure you have the following installed:

### **For Flutter App**
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.x or later recommended)
- Android Studio or Visual Studio Code
- Dart SDK (comes with Flutter)
- Android Emulator or a physical Android device

### **For Laravel Backend**
- PHP 8.1 or later
- Composer
- MySQL (or MariaDB)
- Laravel 10.x

### **Local Use**
- Create DB named audit_scanner

---

## 🚀 Setup Instructions

### 1 Clone the repository
bash
- git clone https://github.com/YOUR_USERNAME/Audit_Field_Scanner.git

### 2 Laravel Backend Setup

Navigate to Folder
-cd audit_backend

Install dependencies
- composer install

Create .env file
- cp .env.example .env

-Inside .env file
  DB_CONNECTION=mysql
  DB_HOST=127.0.0.1
  DB_PORT=3306
  DB_DATABASE=audit_scanner_db
  DB_USERNAME=root
  DB_PASSWORD=

Migration
- php artisan key:generate
- php artisan migrate

Run Server
- php artisan serve --host=0.0.0.0 --port=8000

### 3 Flutter App Setup

Navigate Folder
-cd ../audit_scanner

Install dependencies
- flutter pub get

Run App
- flutter run
