<p align="center">
  <img src="frontend/assets/images/petmigo_logo.png" alt="PetMigo Logo" width="200"/>
</p>

PetMigo adalah aplikasi manajemen dan perawatan hewan peliharaan komprehensif yang membantu pemilik pet untuk melacak jadwal peliharaan mereka, berkonsultasi dengan dokter hewan (vet), menemukan klinik terbaik, dan berkomunikasi melalui fitur chat.

## 🌟 Fitur Utama
- **Manajemen Peliharaan (Pets):** Pencatatan profil dan manajemen data hewan kesayangan Anda.
- **Jadwal & Pengingat (Pet Schedule):** Mengelola jadwal penting seperti vaksinasi, pemeriksaan rutin, atau waktu makan. 
- **Integrasi Klinik & Dokter Hewan:** Jelajahi daftar klinik hewan dan buat janji temu dengan dokter hewan pilihan.
- **Konsultasi & Chat:** Fitur *real-time* chat untuk konsultasi terkait kesehatan peliharaan atau berinteraksi dengan pengguna lainnya.
- **Sistem Keamanan:** Dilengkapi fitur autentikasi (*Login/Register*) dan verifikasi OTP (One-Time Password) via email.

## 🛠️ Stack Teknologi

Proyek ini dibangun menggunakan struktur *Monorepo* yang memisahkan Backend dan Frontend:

### Frontend
- **Framework:** [Flutter](https://flutter.dev/)
- **Bahasa:** Dart
- **State Management:** BLoC (*Business Logic Component Pattern*)

### Backend
- **Framework:** Spring Boot
- **Bahasa:** Java
- **Build Tool:** Maven

### Database & Arsitektur
- **Desain Database:** Desain data tersimpan di file model `pertamax.mwb` (MySQL Workbench).
- **ADR (Architecture Decision Records):** Dokumen arsitektur dan keputusan desain dapat dibaca pada folder `/ADR`.

## 📂 Struktur Direktori Utama

```text
PetMigo/
├── ADR/        # Catatan keputusan arsitektur (Architecture Decision Records)
├── backend/    # Kode sumber API (Spring Boot / Java)
├── frontend/   # Kode sumber Aplikasi Client (Flutter / Dart)
└── pertamax.mwb # Skema Database MySQL
```

## 🚀 Panduan Instalasi (Development)

### 1. Menjalankan Backend (Spring Boot)
1. Buka terminal dan masuk ke folder API: `cd backend`
2. Pastikan Java dan Maven sudah terinstal dengan baik.
3. Jalankan server:
   - Windows: `.\mvnw spring-boot:run`
   - Mac/Linux: `./mvnw spring-boot:run`

### 2. Menjalankan Frontend (Flutter)
1. Buka terminal dan arahkan ke UI: `cd frontend`
2. Pasang semua dependency Dart: `flutter pub get`
3. Jalankan aplikasi ke perangkat/emulator yang terhubung: `flutter run`

---

## 📝 Catatan Pembaruan Backend Terakhir (Changelog / To-Do)
- Login, register etc testing
- Pembuatan chat, message
- Pembuatan akun vet, login vet, vet all (list vet)
- API edit profile , get profile (by id)
- Send OTP by email


# Our Team
- Ivone Liwang
- Apryadi Dwi Putra
- Aditya Ridwan 