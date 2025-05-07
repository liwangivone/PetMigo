# ADR 08
# Title: Offline Support & Caching
# Status: Proposed

## Context
Aplikasi yang sedang dikembangkan ditujukan untuk membantu pemilik hewan peliharaan dalam merawat peliharaan mereka secara rutin dan efisien. Namun, dalam beberapa kondisi, pengguna mungkin tidak selalu memiliki akses internet yang stabil atau terus-menerus tersedia. Untuk menjaga kenyamanan dan kontinuitas penggunaan, tim pengembang mempertimbangkan solusi agar pengguna tetap dapat mengakses dan melakukan perubahan data pada aplikasi meskipun dalam keadaan offline.

Dibutuhkan mekanisme penyimpanan sementara (cache) di sisi perangkat yang akan menyimpan data perubahan secara lokal terlebih dahulu. Selanjutnya, ketika perangkat pengguna kembali terhubung ke internet, data yang telah diperbarui akan disinkronkan secara otomatis ke server pusat untuk menjaga konsistensi data antara sisi klien dan server.

## Decision
Tim memutuskan untuk mengimplementasikan mode offline dalam aplikasi. Dengan fitur ini, pengguna tetap dapat menjalankan beberapa fungsi penting, seperti mencatat aktivitas perawatan hewan, membuat catatan kesehatan, atau mengatur pengingat, meskipun tidak sedang terhubung ke internet.

Data yang dimasukkan selama kondisi offline akan disimpan sementara di dalam cache lokal perangkat, dan akan disinkronkan ke server secara otomatis ketika koneksi internet kembali tersedia.

Keputusan ini diambil untuk memastikan pengalaman pengguna tetap lancar, responsif, dan tidak terganggu oleh keterbatasan jaringan.

## Alternatives
1. Menggunakan Sistem Online-Only
Seluruh data disimpan dan diambil langsung dari server melalui koneksi internet.

    - Kelebihan: Data selalu real-time dan terpusat. Tidak perlu implementasi sinkronisasi data lokal.

    - Kekurangan: Pengguna tidak dapat menggunakan aplikasi saat offline, pengalaman pengguna sangat tergantung pada kestabilan koneksi internet.

1. Offline Mode dengan Full Synchronization Layer (seperti Firestore atau Couchbase Mobile)
Menggunakan solusi database dengan sinkronisasi otomatis antar perangkat dan cloud.

    - Kelebihan: Minim effort dalam membangun sistem sync manual.

    - Kekurangan: Lebih berat, menambah dependensi, dan potensi biaya tambahan jika menggunakan solusi cloud pihak ketiga.

1. Hybrid dengan Manual Save Draft ke File
Perubahan disimpan sebagai file (misal JSON) lalu dikirim ke server saat online.

    - Kelebihan: Implementasi cepat dan simpel.

    - Kekurangan: Sulit dalam manajemen versi data dan konflik sinkronisasi.

## Consequences
- Good : 
    1. Meningkatkan pengalaman pengguna, karena pengguna tetap bisa mengakses dan menggunakan aplikasi kapan saja.
    1. Menjaga kontinuitas penggunaan, terutama bagi pengguna dengan jaringan tidak stabil.
    1. Mengurangi ketergantungan pada server, sehingga beban trafik ke server lebih ringan.
    1. Memungkinkan pengembangan fitur proaktif, seperti reminder atau pencatatan otomatis walau sedang offline.

- Bad : 
    1. Memerlukan mekanisme sinkronisasi yang kompleks untuk memastikan data tidak bentrok antara versi lokal dan server.
    1. Penggunaan cache lokal menambah beban penyimpanan dan memori pada perangkat pengguna.
    1. Risiko inkonsistensi data jika proses sinkronisasi gagal atau terjadi konflik data.
    1. Perlu strategi keamanan tambahan, terutama jika cache menyimpan data sensitif (misalnya informasi pengguna atau hewan peliharaan).