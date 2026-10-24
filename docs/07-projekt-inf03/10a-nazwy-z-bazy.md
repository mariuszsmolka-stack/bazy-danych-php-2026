---
title: Lekcja 10A - Od SELECT do nazw obiektów
---

# Lekcja 10A - Od SELECT do nazw obiektów

Znasz już `SELECT` z [lekcji 2]({{ '/02-php-i-mariadb/01-odczyt-danych.html' | relative_url }}). W [lekcji 4]({{ '/03-zapytania-inf03/02-wyniki-zapytan-w-php.html' | relative_url }}) łączyłeś PHP z bazą MariaDB. W [lekcji 8B]({{ '/05-php-i-html/01b-php-lista-z-bazy.html' | relative_url }}) używałeś pętli `while` do wyświetlania rekordów.

Teraz połączysz te umiejętności. Z tabeli `obiekty` pokażesz na stronie dziewięć nazw miejsc z Islandii. Jeśli trudno Ci zacząć, zajrzyj do [przewodnika planowania pracy]({{ '/07-projekt-inf03/01-jak-zaplanowac-zadanie.html' | relative_url }}).

**SELECT wybiera rekordy => PHP pobiera je kolejno => pętla tworzy akapity HTML => przeglądarka pokazuje nazwy.**

## Najpierw zobacz wynik w phpMyAdmin

Uruchom MariaDB w XAMPP. W phpMyAdmin otwórz bazę `Islandia` i wykonaj zapytanie:

```sql
SELECT nazwa
FROM obiekty
WHERE panstwo = 'Islandia'
ORDER BY idObiekt;
```

`WHERE` wybiera obiekty Islandii. `ORDER BY idObiekt` ustala ich kolejność. Wynik zawiera **9 rekordów**. Pierwsza nazwa to **Strokkur**, a ostatnia to **Dettifoss**. Sprawdź je w tabeli wyników, zanim przejdziesz do PHP.

Każdy rekord zawiera jedną nazwę. PHP będzie pobierać rekordy z tego samego wyniku po kolei.

## Zbuduj stronę z nazwami

Włącz Apache w XAMPP. W VS Code zapisz plik jako `C:\xampp\htdocs\kurs-php\islandia.php`. Otwórz `http://localhost/kurs-php/islandia.php`.

Program używa tego samego zapytania co phpMyAdmin. Konto `root` bez hasła dotyczy wyłącznie lokalnego stanowiska XAMPP, jeśli tak je skonfigurowano.

<details class="lesson-hint" markdown="1">
<summary>Pełny program islandia.php</summary>

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
$zapytanie = "SELECT nazwa FROM obiekty
WHERE panstwo = 'Islandia' ORDER BY idObiekt;";
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
    <title>Obiekty Islandii</title>
</head>
<body>
<h1>Obiekty Islandii</h1>
<?php
while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
    $nazwa = htmlspecialchars($rekord["nazwa"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    echo "<p>" . $nazwa . "</p>";
}
if ($rekord === false) {
    echo "<p>Nie udało się odczytać wszystkich danych.</p>";
}
mysqli_close($polaczenie);
?>
</body>
</html>
```

</details>

Połączenie i zapytanie są sprawdzane przed wyświetleniem strony. Jeśli coś się nie uda, program pokaże komunikat. Po odczytaniu danych zamyka połączenie.

Skup się na tej pętli z programu:

```php
while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
    $nazwa = htmlspecialchars($rekord["nazwa"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    echo "<p>" . $nazwa . "</p>";
}
```

`mysqli_fetch_array()` pobiera kolejny rekord. Jego nazwa trafia do zmiennej `$nazwa`. `htmlspecialchars()` to znany już sposób bezpiecznego wyświetlania tekstu. `echo` tworzy jeden akapit z tą nazwą. Potem pętla wraca po następny rekord. Gdy rekordy się skończą, pętla się zatrzyma.

**Jeden rekord => jeden akapit.** Dziewięć rekordów daje dziewięć akapitów.

## Sprawdź wynik

Na stronie powinno być dziewięć nazw. Pierwsza to **Strokkur**, ostatnia to **Dettifoss**. Porównaj je z wynikiem w phpMyAdmin.

Jeśli `SELECT` wybierze mniej rekordów, strona pokaże mniej akapitów. Nie trzeba zmieniać pętli. Jeśli strona nie pokazuje nazw, najpierw sprawdź wynik zapytania w phpMyAdmin, a potem komunikat programu.

## Spróbuj sam

### Ćwiczenie 1 - dziewięć akapitów

Przed uruchomieniem programu przewidź liczbę akapitów. Sprawdź pierwszą i ostatnią nazwę. Wyjaśnij, dlaczego powstało właśnie tyle akapitów.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Policz rekordy wyniku zapytania. Każdy przebieg pętli tworzy jeden akapit.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

Powstaje 9 akapitów. Pierwszy zawiera Strokkur, a ostatni Dettifoss. Zapytanie zwraca 9 rekordów. Pętla wykonuje się raz dla każdego z nich.

</details>

### Ćwiczenie 2 - cztery wodospady

W zapytaniu wewnątrz programu dodaj warunek wyboru wodospadów Islandii. W bazie kursowej wodospady mają `idRodzaj = 10`. Przewidź liczbę nazw, a potem sprawdź zapytanie w phpMyAdmin i stronę. Nie zmieniaj pętli PHP.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Połącz warunek państwa z warunkiem rodzaju za pomocą `AND`. Pozostaw `ORDER BY idObiekt`.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

Zmień tylko przypisanie do zmiennej `$zapytanie`:

```php
$zapytanie = "SELECT nazwa FROM obiekty
WHERE panstwo = 'Islandia' AND idRodzaj = 10 ORDER BY idObiekt;";
```

Wynik to 4 nazwy: Skogafoss, Seljalandsfoss, Godafoss i Dettifoss. Pętla utworzy 4 akapity, bo zapytanie zwraca 4 rekordy.

</details>
