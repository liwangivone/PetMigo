# ADR 02
# Title: State Management Approach
# Status: Accepted

## Context
Pada pengembangan Aplikasi menggunakan Flutter perlu memilih State Management Aprroach untuk membantu pengelolaan state karena melibatkan banyak perubahan data, seperti navigasi perpindahan halaman, pemrosesan data AI, dan data lainnya dari back-end.
## Decision
Tim kami memutuskan penggunaan BLoC sebagai state management utama.
## Alternatives
-
## Consequences
- good 

    Penggunaan BLoC sangat cocok digunakan dalam pola arsitektur MVC karena dapat memisahkan UI dan logika bisnis dengan baik, sehingga kode menjadi lebih rapi dan mudah untuk dipahami oleh tim lainnya (jika butuh).

