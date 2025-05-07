# ADR 04
# Title: Local Data Persistence
# Status: Accepted

## Context
Aplikasi yang kami kembangkan ditujukan untuk membantu pemilik hewan peliharaan dalam merawat hewan mereka, termasuk pencatatan aktivitas, pengingat, jadwal perawatan, dan informasi penting lainnya. Oleh karena itu kami memerlukan penyimpanan lokal untuk cache data di device pengguna, dan agar data tersebut juga dapat diakses saat offline.

## Decision
Setelah mempertimbangkan arsitektur data dan kebutuhan fitur aplikasi, kami menyimpulkan bahwa data yang dikelola cukup kompleks dan saling berelasi, seperti data hewan, pengguna, riwayat kesehatan, dan jadwal pengingat. Oleh karena itu kami memutuskan untuk menggunakan SQlite untuk penyimpanan lokal utama dalam pengembangan aplikasi ini.

SQLite adalah solusi database relasional yang sudah tertanam (embedded) di platform Android, ringan, dan telah terbukti stabil dalam berbagai aplikasi. Oleh karena itu, SQLite sangat sesuai untuk digunakan pada aplikasi ini, terutama karena Android sudah mendukungnya secara native, dan kami dapat mengimplementasikan SQLite dengan bantuan Room ORM untuk mempermudah pengelolaan data.

## Alternatives
    
    SharedPreferences / DataStore

    Cocok untuk penyimpanan key-value sederhana seperti pengaturan aplikasi.
    Tidak cocok untuk data kompleks dan relasional.

## Consequences
- Good :

    1. Mendukung query kompleks dan relasi antar tabel.
    1. SQLite stabil, ringan, dan sudah tersedia secara native di Android.
    1. Dapat digunakan sepenuhnya offline.
    1. Kompatibel dengan ORM Room yang membuat coding lebih rapi dan aman.
    1. Memungkinkan sinkronisasi data ke server saat online.
##
- Bad : 

    1. Perlu desain struktur database yang baik sejak awal.
    1. Meningkatkan kompleksitas development jika data terlalu sering berubah struktur.
    1. Perlu implementasi manual untuk migrasi schema jika struktur database diubah di versi berikutnya.
