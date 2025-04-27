% Fakta: Gejala yang mungkin muncul
gejala(daun_menguning).
gejala(bercak_hitam).
gejala(daun_berlubang).
gejala(tanaman_layu).

% Aturan untuk menentukan jenis hama berdasarkan gejala
hama(kutu_daun) :-
    cek_gejala(daun_menguning),
    cek_gejala(tanaman_layu),
    \+ cek_gejala(daun_berlubang),
    \+ cek_gejala(bercak_hitam).

hama(ulat_daun) :-
    cek_gejala(daun_berlubang),
    \+ cek_gejala(daun_menguning),
    \+ cek_gejala(bercak_hitam).

hama(jamur) :-
    cek_gejala(bercak_hitam),
    cek_gejala(daun_menguning),
    \+ cek_gejala(daun_berlubang).

hama(busuk_akar) :-
    cek_gejala(tanaman_layu),
    \+ cek_gejala(daun_menguning),
    \+ cek_gejala(bercak_hitam),
    \+ cek_gejala(daun_berlubang).

hama(tungau) :-
    cek_gejala(bercak_hitam),
    cek_gejala(daun_menguning),
    cek_gejala(daun_berlubang).

% Rekomendasi solusi untuk tiap hama
solusi(kutu_daun, [
    'Gunakan larutan sabun untuk insektisida',
    'Manfaatkan serangga predator alami',
    'Semprotkan minyak neem'
]).

solusi(ulat_daun, [
    'Aplikasikan Bacillus thuringiensis (Bt)',
    'Kumpulkan ulat secara manual',
    'Gunakan predator serangga alami'
]).

solusi(jamur, [
    'Semprotkan fungisida',
    'Jaga area agar tidak lembab',
    'Buang daun yang terinfeksi'
]).

solusi(busuk_akar, [
    'Perbaiki aliran air tanah',
    'Kurangi intensitas penyiraman',
    'Gunakan fungisida sistemik'
]).

solusi(tungau, [
    'Gunakan semprotan air bertekanan',
    'Aplikasikan akarisida',
    'Manfaatkan tungau predator'
]).

% Predikat untuk memulai proses diagnosis
mulai :-
    nl, write('=== SISTEM PAKAR IDENTIFIKASI HAMA TANAMAN ==='), nl,
    reset_gejala,
    input_gejala,
    hasil_identifikasi.

% Reset gejala sebelum diagnosis baru
reset_gejala :-
    retractall(gejala_aktif(_)).

% Proses tanya jawab gejala
input_gejala :-
    tanyakan(daun_menguning),
    tanyakan(bercak_hitam),
    tanyakan(daun_berlubang),
    tanyakan(tanaman_layu).

% Menanyakan gejala kepada pengguna
tanyakan(Gejala) :-
    format('Apakah tanaman mengalami ~w? (ya/tidak): ', [Gejala]),
    read(Jawab),
    (Jawab == ya -> assertz(gejala_aktif(Gejala)); true).

% Cek apakah gejala aktif
cek_gejala(Gejala) :-
    gejala_aktif(Gejala).

% Proses identifikasi hama
hasil_identifikasi :-
    hama(Hama),
    nl, format('Diagnosa: Tanaman Anda kemungkinan diserang oleh ~w.~n', [Hama]),
    tampilkan_solusi(Hama),
    !.

hasil_identifikasi :-
    nl, write('Gejala yang Anda masukkan tidak cocok dengan basis pengetahuan kami.'), nl,
    write('Disarankan untuk berkonsultasi lebih lanjut dengan ahli pertanian.').

% Menampilkan solusi berdasarkan jenis hama
tampilkan_solusi(Hama) :-
    solusi(Hama, Daftar),
    nl, write('Saran Penanganan:'), nl,
    cetak_list(Daftar, 1).

% Mencetak list saran satu per satu
cetak_list([], _).
cetak_list([Saran|Lainnya], N) :-
    format('~d. ~w~n', [N, Saran]),
    N1 is N + 1,
    cetak_list(Lainnya, N1).

% Dinamisasi fakta
:- dynamic gejala_aktif/1.

% Otomatis mulai saat file dijalankan
:- initialization(mulai).
