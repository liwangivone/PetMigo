# ADR 02
# Title: State Management Approach
# Status: Proposed

## Context
Pada pengembangan Aplikasi menggunakan Flutter perlu memilih State Management Aprroach.
## Decision
Tim Kami memutuskan untuk menggunakan Riverpod dikarenakan mudah untuk digunakan
## Alternatives
Tim kami mempertimbangkan penggunaan BLoC akan tetapi penggunaan BLoC lebih cocok untuk Aplikasi dengan skala yang lebih besar dan lebih sulit untuk digunakan.
## Consequences
- good 
    1. Tidak bergantung pada BuildContext, membuat logic lebih testable dan fleksibel.
    1. Mendukung clean architecture (layered architecture).
    1. Komponen seperti AsyncNotifier dan StateNotifier sangat cocok untuk integrasi API dan UI.
    1. Dependency injection dan state composition mudah dilakukan.
    1. Kurva belajar tidak terlalu tajam dibanding Bloc, tapi lebih powerfull dari Provider.
##
- bad 
    1. Perlu waktu adaptasi bagi tim yang terbiasa dengan Provider atau Bloc.
    1. Dokumentasi dan tooling belum sebesar Bloc untuk enterprise use-case tertentu.
    1. Tidak semua library pihak ketiga langsung mendukung Riverpod secara eksplisit.
