# ADR 09
# Title: Error Handling & Monitoring
# Status: Accepted

## Context
Tim Kami memutuskan untuk membuat error handling sendiri tanpa bantuan dependency atau sesuatu yang mirip. Keputusan ini diambil untuk memberikan fleksibilitas dan kendali penuh atas implementasi error handling, tanpa bergantung pada library eksternal.

## Decision
Tim akan membuat sistem error handling dan monitoring custom tanpa menggunakan dependency pihak ketiga seperti Sentry, Logback, atau sejenisnya. Kami akan memanfaatkan mekanisme standar dari framework yang digunakan (seperti Spring Boot's @ControllerAdvice dan loggers seperti SLF4J) untuk menangani dan mencatat error.

## Alternatives
- Menggunakan dependency eksternal seperti Sentry atau Logback untuk error tracking dan monitoring.

- Menggunakan sistem monitoring yang sudah ada di framework, seperti Spring Boot's default error handling dan logging mekanisme tanpa penyesuaian lebih lanjut.

## Consequences
- Good : 

    Kontrol penuh atas cara error ditangani dan dilaporkan.
    Dapat disesuaikan sepenuhnya dengan kebutuhan spesifik aplikasi.
    Meminimalkan ketergantungan pada library eksternal, yang dapat mengurangi kompleksitas dan beban proyek.

- Bad : 

    Pengelolaan error dan logging membutuhkan lebih banyak waktu dan usaha dari tim untuk membuat dan menguji sistem yang handal.
    Kemungkinan kesalahan dalam penanganan error yang lebih kompleks jika tidak dikelola dengan baik.
    Monitoring dan analitik terkait error mungkin tidak sekuat solusi eksternal yang sudah terbukti, sehingga memerlukan lebih banyak pengawasan manual.
