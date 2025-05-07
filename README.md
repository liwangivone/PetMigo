# Model dan Skema Database Backend

## Schema Database

### 1. User ke Pet
- Relasi: One To Many dan Many To One
- Deskripsi:
  Satu user dapat memiliki banyak pet,
  tetapi satu pet hanya dimiliki oleh satu user.

### 2. Pet ke Pet_Schedule
- Relasi: One To Many dan Many To One
- Deskripsi:
  Satu pet dapat memiliki banyak jadwal (schedule),
  tetapi satu jadwal hanya terkait dengan satu pet.

### 3. User ke Chat dan Doctor ke Chat
- Relasi: Many To One untuk masing-masing
- Deskripsi:
  Satu chat melibatkan satu user dan satu doctor.
  Seorang user atau doctor bisa memiliki banyak chat.

### 4. Chat ke Message
- Relasi: One To Many
- Deskripsi:
  Satu chat bisa memiliki banyak pesan (message),
  tetapi satu pesan hanya terkait dengan satu chat.

### 5. Doctor ke Clinics
- Relasi: Many To One
- Deskripsi:
  Satu klinik bisa memiliki banyak dokter,
  tetapi satu dokter hanya bekerja di satu klinik.

# Perubahan pada Dependency

## Penghapusan
- Menghapus dependency Thymeleaf karena frontend menggunakan Flutter, bukan HTML.

## Penambahan
- Menambahkan dependency berikut:
  - Springdoc OpenAPI (Swagger) untuk dokumentasi API
  - Spring Boot Starter Mail untuk pengiriman email
  - Lain-lain sesuai kebutuhan proyek
