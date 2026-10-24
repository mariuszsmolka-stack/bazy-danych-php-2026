---
title: SPRAWDZIAN SAMODZIELNOŚCI - INF.03
---

# SPRAWDZIAN SAMODZIELNOŚCI - INF.03

**To nie jest kolejna lekcja.**

**Nie poznajesz nowych instrukcji. Sprawdzasz, czy umiesz wykorzystać to, czego już się nauczyłeś.**

Najpierw spróbuj samodzielnie. Z podpowiedzi skorzystaj dopiero wtedy, gdy nie potrafisz przejść dalej.

To autorski sprawdzian ćwiczeniowy kursu, a nie oryginalny arkusz CKE.

## Ranking turystów i karta uczestnika

Pracuj lokalnie w XAMPP na bazie `Islandia`. W tabeli `turysci` są kolumny `idTurysta`, `nick` i `punkty`.

Przygotuj dwa pliki w katalogu `C:\xampp\htdocs\kurs-php\`: `ranking.php` oraz `karta_turysty.php`. Możesz korzystać z wcześniejszych lekcji i ściągi, ale zacznij bez zaglądania do rozwiązania.

### Część A - ranking

W pliku `ranking.php` pokaż w tabeli turystów, którzy zdobyli co najmniej 20 punktów. Uporządkuj ich od największej liczby punktów. Przy remisie zachowaj kolejność według `idTurysta`.

Tabela ma mieć kolumny **Turysta** i **Punkty**. Każdy nick ma być linkiem do `karta_turysty.php?id=...`. W linku umieść `idTurysta` osoby z danego wiersza, nie numer jej miejsca w rankingu.

### Część B - karta uczestnika

W pliku `karta_turysty.php` odczytaj `id` z adresu i sprawdź, czy jest poprawne. Znajdź wskazanego turystę. Pokaż jego nick oraz punkty.

Jeśli turysty nie ma w bazie, wyświetl informację o braku rekordu. Dodaj możliwość powrotu do rankingu.

Nie dodawaj zdjęć, CSS, formularzy, JavaScript, klas PHP ani nowych bibliotek.

## Sprawdź swoje decyzje

Zaznacz pola w swojej kopii materiału po zakończeniu pracy:

- [ ] Czy sam napisałem zapytanie SQL?
- [ ] Czy potrafię wyjaśnić wybór pętli?
- [ ] Czy wiem, skąd pochodzi `id` w linku?
- [ ] Czy potrafię odczytać jeden rekord?
- [ ] Czy program obsługuje błędne `id`?
- [ ] Czy umiem sprawdzić wynik programu?

## Wypróbuj oba programy

- [ ] Ranking zawiera 7 osób.
- [ ] Pierwsza jest Ela.
- [ ] Kliknięcie Eli otwiera kartę właściwej osoby.
- [ ] Zmiana `id` w adresie zmienia dane na karcie.
- [ ] Dla `id=999` pojawia się komunikat o braku turysty.
- [ ] Brak `id` i niepoprawne `id` nie uruchamiają zapytania do bazy.
- [ ] Z karty można wrócić do rankingu.

---

## Pomoc po samodzielnej próbie

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź 1 - Od czego zacząć?</summary>

Najpierw ustal, jakie dane są potrzebne na każdej stronie. Sprawdź własne zapytanie w phpMyAdmin. Dopiero potem napisz kod PHP.

Jeśli utkniesz, wróć do lekcji o tabeli z rekordów oraz o wyborze jednego rekordu przez adres.

</details>

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź 2 - Jak połączyć elementy?</summary>

Przypomnij sobie `SELECT`, `WHERE`, `ORDER BY`, `mysqli_query()`, `mysqli_fetch_array()`, `while`, `echo` i GET.

Ranking zawiera wiele rekordów. Karta uczestnika dotyczy jednego rekordu wskazanego przez `id`.

</details>

<details class="lesson-solution" markdown="1">
<summary>Pełne rozwiązanie - sprawdź swoją pracę</summary>

### Zapytanie do rankingu

```sql
SELECT idTurysta, nick, punkty
FROM turysci
WHERE punkty >= 20
ORDER BY punkty DESC, idTurysta ASC;
```

### Plik ranking.php

```php
<?php
mysqli_report(MYSQLI_REPORT_OFF);
$polaczenie = mysqli_connect("localhost", "root", "", "Islandia");
if (!$polaczenie) {
    exit("Nie udało się połączyć z bazą.");
}

if (!mysqli_set_charset($polaczenie, "utf8mb4")) {
    mysqli_close($polaczenie);
    exit("Nie udało się ustawić kodowania.");
}

$zapytanie = "SELECT idTurysta, nick, punkty
FROM turysci
WHERE punkty >= 20
ORDER BY punkty DESC, idTurysta ASC";
$wynik = mysqli_query($polaczenie, $zapytanie);
if (!$wynik) {
    mysqli_close($polaczenie);
    exit("Nie udało się wykonać zapytania.");
}
?>
<!doctype html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Ranking turystów</title>
</head>
<body>
<h1>Ranking turystów</h1>
<table>
    <thead>
        <tr><th>Turysta</th><th>Punkty</th></tr>
    </thead>
    <tbody>
<?php
while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
    $idTurysta = (int) $rekord["idTurysta"];
    $nick = htmlspecialchars($rekord["nick"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    $punkty = (int) $rekord["punkty"];
    echo '<tr><td><a href="karta_turysty.php?id=' . $idTurysta . '">' . $nick . '</a></td><td>' . $punkty . '</td></tr>';
}
mysqli_close($polaczenie);
?>
    </tbody>
</table>
</body>
</html>
```

### Zapytanie do karty

Przykład dla `id=7`:

```sql
SELECT nick, punkty
FROM turysci
WHERE idTurysta = 7;
```

W programie zamiast stałej liczby użyj sprawdzonego identyfikatora.

### Plik karta_turysty.php

```php
<?php
$idTurysta = filter_input(INPUT_GET, "id", FILTER_VALIDATE_INT);
if ($idTurysta === null) {
    exit('Brakuje parametru id. <a href="ranking.php">Powrót do rankingu</a>');
}
if ($idTurysta === false || $idTurysta <= 0) {
    exit('Niepoprawny identyfikator. <a href="ranking.php">Powrót do rankingu</a>');
}

mysqli_report(MYSQLI_REPORT_OFF);
$polaczenie = mysqli_connect("localhost", "root", "", "Islandia");
if (!$polaczenie) {
    exit("Nie udało się połączyć z bazą.");
}

if (!mysqli_set_charset($polaczenie, "utf8mb4")) {
    mysqli_close($polaczenie);
    exit("Nie udało się ustawić kodowania.");
}

$zapytanie = "SELECT nick, punkty FROM turysci WHERE idTurysta = " . $idTurysta;
$wynik = mysqli_query($polaczenie, $zapytanie);
if (!$wynik) {
    mysqli_close($polaczenie);
    exit("Nie udało się wykonać zapytania.");
}

$rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC);
mysqli_close($polaczenie);
if ($rekord === false) {
    exit("Nie udało się odczytać rekordu.");
}
if ($rekord === null) {
    exit('Nie znaleziono turysty. <a href="ranking.php">Powrót do rankingu</a>');
}

$nick = htmlspecialchars($rekord["nick"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
$punkty = (int) $rekord["punkty"];
?>
<!doctype html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Karta uczestnika</title>
</head>
<body>
<h1>Karta uczestnika</h1>
<p>Turysta: <?php echo $nick; ?></p>
<p>Punkty: <?php echo $punkty; ?></p>
<p><a href="ranking.php">Powrót do rankingu</a></p>
</body>
</html>
```

### Wyniki do porównania

| Turysta | Punkty |
| --- | ---: |
| Ela | 51 |
| Tomek | 46 |
| Grzesiek | 45 |
| Ola | 31 |
| Ewa | 23 |
| Paula | 23 |
| Piotrek | 21 |

Ela ma `idTurysta = 7`. Karta dla `id=7` pokazuje Elę i 51 punktów. Monika ma `idTurysta = 2` i 4 punkty. Jej karta działa, choć Moniki nie ma w rankingu.

Przy 23 punktach Ewa pojawia się przed Paulą, ponieważ ma mniejszy `idTurysta`. Dla `id=999` karta pokazuje komunikat o braku turysty.

Ranking czyta wiele rekordów i tworzy wiersz dla każdego z nich. Karta wybiera jeden rekord według sprawdzonego `id`. W linku nicka używamy identyfikatora rekordu, a tekst z bazy przygotowujemy przez `htmlspecialchars()`.

Konto `root` bez hasła stosuj tylko na lokalnym stanowisku XAMPP, jeśli jest tak skonfigurowane.

</details>
