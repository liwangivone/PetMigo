# ADR 05
# Title: Dependency Injection Framework
# Status: Proposed

## Context
Dalam pengembangan Aplikasi ini Tim Kami menggunakan beberapa dependency untuk meningkatkan efisiensi pengerjaan aplikasi.

## Decision
Dalam pengembangan backend aplikasi ini, tim kami membutuhkan sejumlah dependency yang dapat menunjang kebutuhan inti sistem, seperti pembuatan REST API, pengelolaan data dengan database relasional, pengamanan akses terhadap sistem, penyediaan dokumentasi API, dan juga kemampuan untuk mengirim email kepada pengguna. Selain itu, diperlukan juga alat bantu untuk mengurangi kode boilerplate agar pengembangan lebih efisien dan mudah dipelihara. Karena itu, dipertimbangkanlah dependency dari ekosistem Spring Boot yang telah terbukti stabil, mudah diintegrasikan, serta didukung oleh komunitas yang luas.

Tim kami memutuskan untuk menggunakan beberapa dependency utama sebagai berikut. spring-boot-starter-web digunakan untuk membangun REST API berbasis Spring MVC. Untuk pengelolaan database, digunakan spring-boot-starter-data-jpa yang memanfaatkan JPA dan Hibernate. Keamanan aplikasi akan ditangani dengan spring-boot-starter-security untuk mendukung autentikasi dan otorisasi. lombok digunakan untuk menghilangkan kebutuhan penulisan kode boilerplate seperti getter dan setter. Untuk koneksi ke database MySQL, dipakai mysql-connector-j sebagai JDBC driver. Dokumentasi API akan disediakan melalui springdoc-openapi-starter-webmvc-ui yang menampilkan Swagger UI secara otomatis. Sementara itu, spring-boot-starter-mail akan digunakan untuk fitur pengiriman email, seperti verifikasi akun dan notifikasi lainnya. Dengan kombinasi dependency ini, diharapkan backend aplikasi dapat dibangun dengan cepat, aman, dan terstruktur dengan baik.

## Alternatives
Alternatif lainnya diharapkan dapat muncul seiring dengan jalannya pengembangan aplikasi ini, seperti kebutuhan mendadak lainnya di luar dari dependency yang sudah disebutkan sebelumnya

## Consequences
- Good : 

    Sangat membantu dalam proses keseluruhan pengembangan aplikasi.
##
- Bad : 

    Harus mempelajari dokumentasi agar dapat menggunakan depedency tersebut 

