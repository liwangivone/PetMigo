# ADR 04
# Title: Local Data Persistence
# Status: Proposed

## Context
Aplikasi yang kami kembangkan ditujukan untuk membantu pemilik hewan peliharaan dalam merawat hewan mereka, termasuk pencatatan aktivitas, pengingat, jadwal perawatan, dan informasi penting lainnya. Aplikasi ini ditargetkan untuk tetap dapat digunakan secara offline, sehingga data tetap dapat diakses dan dimodifikasi meskipun tidak ada koneksi internet. Untuk itu, dibutuhkan solusi local data persistence yang andal dan sesuai dengan kebutuhan data yang berstruktur serta berelasi.

## Decision
Setelah mempertimbangkan arsitektur data dan kebutuhan fitur aplikasi, kami menyimpulkan bahwa data yang dikelola cukup kompleks dan saling berelasi, seperti data hewan, pengguna, riwayat kesehatan, dan jadwal pengingat. Karena itu, dibutuhkan penyimpanan lokal yang mampu menangani relasi data, query yang kuat, dan dukungan jangka panjang.

SQLite adalah solusi database relasional yang sudah tertanam (embedded) di platform Android, ringan, dan telah terbukti stabil dalam berbagai aplikasi. Oleh karena itu, SQLite sangat sesuai untuk digunakan pada aplikasi ini, terutama karena Android sudah mendukungnya secara native, dan kami dapat mengimplementasikan SQLite dengan bantuan Room ORM untuk mempermudah pengelolaan data.

## Alternatives
Beberapa Pertimbangan Alternatif yang Tim kami lakukan : 

1. SharedPreferences / DataStore

    Cocok untuk penyimpanan key-value sederhana seperti pengaturan aplikasi.

    Tidak cocok untuk data kompleks dan relasional.

1. Realm / ObjectBox

    Lebih modern dan cepat, berbasis objek.
    Namun, lebih berat, menambah dependency eksternal, dan kompleks untuk sinkronisasi jika ingin interoperabilitas dengan SQL.

1. File Storage (JSON/XML)

    Sederhana tapi tidak scalable, tidak cocok untuk query, dan rentan rusak saat manipulasi data besar.

1. Firebase Local Cache / Cloud Sync

    Bergantung pada koneksi internet dan tidak ideal untuk mode offline penuh tanpa setup tambahan.

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
