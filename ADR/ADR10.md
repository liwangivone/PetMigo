# ADR 10
# Title: Testing Strategy & CI/CD Pipeline
# Status: Proposed

## Context
Aplikasi yang sedang dikembangkan bertujuan untuk membantu pemilik hewan peliharaan dalam mengelola jadwal perawatan, kesehatan, pengingat, serta aktivitas penting lainnya. Untuk memastikan aplikasi ini mudah digunakan, intuitif, dan benar-benar memenuhi kebutuhan pengguna akhir, maka dibutuhkan strategi pengujian yang berfokus pada pengalaman pengguna secara langsung.

Metode testing yang hanya mengandalkan functional test atau automated test belum cukup dalam mengevaluasi apakah fitur-fitur yang dibuat benar-benar mudah dipahami dan digunakan oleh target pengguna. Oleh karena itu, tim ingin menerapkan strategi pengujian yang melibatkan pengguna secara langsung untuk mendapatkan masukan yang lebih holistik.

## Decision
Tim memutuskan untuk menerapkan Usability Testing sebagai bagian dari strategi pengujian utama. Pengujian ini akan dilakukan dengan cara mengamati dan mengevaluasi cara pengguna nyata berinteraksi dengan aplikasi.

Dalam prosesnya, peserta akan diminta untuk menyelesaikan sejumlah tugas atau skenario tertentu (misalnya: menambahkan hewan peliharaan, membuat jadwal vaksin, atau membaca notifikasi pengingat), dan tim pengembang akan mencatat kesulitan, kebingungan, atau kesalahan yang terjadi.

Usability testing akan digunakan baik pada fase prototipe (low/high fidelity) maupun setelah aplikasi selesai dikembangkan, sebagai bentuk validasi terhadap pengalaman pengguna yang diharapkan.

## Alternatives
1. Hanya menggunakan Functional Testing (Manual/Automated)
Fokus pada pengujian logika aplikasi, alur backend, dan validasi input.
    - Kelebihan: Cocok untuk kestabilan sistem dan logika aplikasi.
    - Kekurangan: Tidak mengukur apakah aplikasi mudah dipahami oleh pengguna biasa.

2. A/B Testing
Digunakan untuk membandingkan dua versi UI/fitur dengan pengguna sebenarnya.
    - Kelebihan: Bagus untuk membandingkan opsi UI atau fitur.
    - Kekurangan: Tidak cukup untuk mengetahui pain point pengguna atau perilaku penggunaan secara menyeluruh.

3. Survei atau Feedback Form
Memberikan masukan berdasarkan opini pengguna.
    - Kelebihan: Skala besar, mudah dilakukan.
    - Kekurangan: Subjektif dan tidak menangkap langsung interaksi atau kesalahan nyata.

## Consequences
- Good : 
    -  Dapat mengetahui masalah UX sejak dini, sebelum aplikasi dirilis secara luas.
    - Mendapatkan insight langsung dari pengguna nyata mengenai alur aplikasi, penamaan fitur, dan kenyamanan UI.
    - Memastikan bahwa fitur yang dibuat memang berguna dan mudah dimengerti oleh pengguna.
    - Menurunkan risiko aplikasi dianggap membingungkan atau tidak berguna meskipun fiturnya lengkap.

- Bad : 
    - Membutuhkan waktu dan sumber daya lebih, termasuk merekrut peserta dan melakukan observasi.
    - Proses pengujian dan analisis hasil bisa memakan waktu lebih lama dibanding automated testing.
    - Jika tidak dilakukan dengan metodologi yang tepat, hasilnya bisa bias atau tidak merepresentasikan pengguna sesungguhnya.
    Mungkin perlu dilakukan beberapa kali seiring perubahan UI/UX untuk tetap relevan.
