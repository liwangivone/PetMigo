# ADR 01
# Title: App Architecture Pattern
# Status: Accepted

## Context
Penentuan App Architecture Pattern dibutuhkan untuk memudahkan pengembangan Aplikasi kedepannya

## Decision
Dalam pengembangan aplikasi PetMigo, selama pola arsitektur yang digunakan adalah Model-View-Controller (MVC). Pemilihan pattern ini didasarkan pada kebutuhan untuk memisahkan logika bisnis, antarmuka pengguna, dan manajemen data agar aplikasi lebih mudah dikelola dan dikembangkan secara modular.

Tim kami memilih MVC karena dengan arsitektur MVC, setiap bagian sistem dapat dikembangkan dan diuji secara terpisah. Misalnya, saat melakukan pembaruan pada tampilan fitur My Expenses, pengembang tidak perlu mengubah komponen logika bisnis atau data. Hal ini sangat efisien terutama jika pengembangan dilakukan oleh tim berbeda untuk front-end dan back-end.


## Alternatives
Tim kami juga mempertimbangan pengembangan Aplikasi kami menggunakan MVVM dikarenakan kecocokan dengan flutter, akan tetapi tim kami kurang familiar dengan penggunaan MVVM.


## Consequences
- Good : 

    Pemisahan logika bisnis dan antarmuka pengguna meningkatkan modularitas, memungkinkan pengembangan parallel antara tim front-end dan back-end, dan memudahkan pengujian unit karena masing-masing komponen dapat diuji secara terpisah.
##
- Bad : 

    Untuk aplikasi kecil, penggunaan MVC bisa terasa terlalu kompleks dan koordinasi antara ketiga komponen memerlukan arsitektur yang disiplin dan perancangan serta penulisan kode bisa menjadi lebih panjang dan membutuhkan banyak boilerplate.
