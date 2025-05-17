# login
login menggunakan email dan password 

# register
register hanya mengambil username, email, password, dan phone number (alasan kenapa ada email gak sesuai di petmigo figma adalah karena profile di figma ada email alhasil itu membingungkan bagaimana ada email tapi register tidak dan alasan lainnya karena login diganti menjadi email dan akan ditambahkan otp next time )

## Penambahan lainnya
# status
penambahan status agar chat bisa dilihat statusnya secara online atau tidak (ini di pikirkan agar user mengetahui status apakah dokter online atau tidak atau user online atau tidak, ini dipikirkan dalam prespeksif pengguna)

## ADR
# controller
- menggunakan rest api oleh karena itu controller menggunakan adr ke 3
- controller juga menggunakan MVC yaitu adr ke 1
# Repository
- repository menggunakan JPA yaitu ADR 5 soal depedency JPA

# NOTE for TEAM
- try to use it and contact your back end if there any error thanks you

# how to use 
- clone terlebih dahulu, gak tau cara clone? saya punya link,berterimakasihlah sama our lord youtube dan our lord india people Link : https://www.youtube.com/watch?v=q9wc7hUrW8U
- buka foldernya pakai vscode sesuai letak dimana anda clone
- jangan lupa pergi ke resource folder dan click application.properties dan ganti urlnya dari origami ke nama database sesuai keinginanmu "NOTE : JANGAN PERNAH MEMAKAI NAMA DATABASE YANG SUDAH DIGUNAKAN KECUALI ANDA INGIN DROP TERLEBIH DAHULU"
- anda juga bisa tanpa mengubah urlnya dan lansung play backendnya melalui folder petmigo dan file bernama BackendApplication.java
- jika diarahkan login maka kamu harus isi user dan passwordnya digenerate di terminal
- saat sudah play file tersebut anda harus membuka swagger dengan mengetik http://localhost:8080/swagger-ui/
- anda harus check registernya apakah sudah sesuai atau tidak
- jika sudah mengecek harap check kembali di localhost phpmyadmin agar tidak ada kesalahan sama sekali
- jika sudah semuanya then goodluck if there any problem or a bug please contact me dont change it please
- by itsukachiyogami
