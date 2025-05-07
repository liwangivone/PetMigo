# ADR 01
# Title: App Architecture Pattern
# Status: Accepted

## Context
Penentuan App Architecture Pattern dibutuhkan untuk memudahkan pengembangan dan mmaintanance Aplikasi kedepannya.

## Decision
Dalam pengembangan aplikasi PetMigo, pola arsitektur yang digunakan adalah Model-View-Controller (MVC). Pemilihan pola ini didasarkan pada kebutuhan untuk memisahkan logika bisnis, antarmuka pengguna, dan manajemen data agar aplikasi lebih mudah dikelola dan dikembangkan secara modular.

Tim kami memilih MVC karena selain seluruh anggota tim sudah sangat familiar dengan arsitektur MVC, setiap bagian sistem nantinya dapat dikembangkan dan diuji secara terpisah. Misalnya, saat melakukan pembaruan pada tampilan fitur My Expenses, kami tidak perlu mengubah komponen logika bisnis atau data. Hal ini sangat efisien terutama jika pengembangan dilakukan oleh tim berbeda untuk front-end dan back-end. 


## Alternatives
Tim kami juga mempertimbangkan pengembangan Aplikasi kami menggunakan MVVM dikarenakan kecocokan dengan flutter, akan tetapi tim kami kurang familiar dengan penggunaan MVVM. Oleh karena itu kemungkinan besar alternatif ini tidak akan kami gunakan.


## Consequences
- Good : 

    Pemisahan logika bisnis dan antarmuka pengguna meningkatkan modularitas, memungkinkan pengembangan parallel antara tim front-end dan back-end, dan memudahkan pengujian unit karena masing-masing komponen dapat diuji secara terpisah.
##
- Bad : 

    Untuk aplikasi kecil, penggunaan MVC bisa terasa terlalu kompleks dan koordinasi antara ketiga komponen memerlukan arsitektur yang disiplin dan perancangan serta penulisan kode bisa menjadi lebih panjang dan membutuhkan banyak boilerplate.
