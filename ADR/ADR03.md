# ADR 03
# Title: Backend Integration Strategy
# Status: Accepted

## Context
Aplikasi Kami membutuhkan Framework yang akan digunakan sebagai backend dari aplikasi.

## Decision
Dalam pengembangan sistem backend pada proyek ini, tim dihadapkan pada beberapa pilihan framework yang dapat mendukung skalabilitas, performa, serta kemudahan integrasi dengan layanan lain. Dua opsi utama yang dipertimbangkan adalah Spring Boot (Java) dan Laravel (PHP). Kedua framework ini memiliki ekosistem yang matang dan dokumentasi yang baik, namun karakteristik dan kebutuhan proyek mendorong tim untuk melakukan seleksi berdasarkan kriteria teknis dan strategis.

Keputusan ini kami ambil berdasarkan beberapa faktor seperti kompatibilitas tim kami, Skalabilitas dan performa, serta dukungan Komunitas dan Ekosistem yang Kuat. Tim kami juga mempertimbangkan pengembangan dan keamanan dalam menentukan Framework backend yang akan digunakan.

## Alternatives
Tim kami memutuskan untuk tidak menggunakan Laravel sebagai framework utama dalam pengembangan proyek ini karena beberapa pertimbangan strategis. Salah satu alasan utamanya adalah kebutuhan akan performa yang lebih ringan serta fleksibilitas dalam struktur proyek, yang saat ini lebih sesuai dipenuhi oleh framework utama yang kami gunakan, yaitu Spring Boot.

Meskipun demikian, Laravel tetap kami pertimbangkan sebagai alternatif cadangan. Apabila di kemudian hari ditemukan kendala signifikan dalam penggunaan Spring Boot baik dari segi keterbatasan fitur, waktu pengembangan, atau kompleksitas implementasi maka tidak menutup kemungkinan bahwa Laravel akan dipertimbangkan kembali sebagai solusi pengganti, terutama mengingat ekosistemnya yang matang dan kemudahan dalam membangun aplikasi web secara cepat.

## Consequences
- Good : 

    Bagus dalam pembuatan dari awal dan tidak memusingkan akibat banyaknya fitur yang sudah jadi seperti laravel yang sudah lumayan kompleks
##
- Bad : 

    Membuat dari awal seperti password encrypt, user model dll
