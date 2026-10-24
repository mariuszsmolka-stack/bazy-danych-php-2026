---
title: Lekcja 10C - Galeria zdjęć z pętli
---

# Lekcja 10C - Galeria zdjęć z pętli

W [lekcji 10A]({{ '/07-projekt-inf03/10a-nazwy-z-bazy.html' | relative_url }}) pętla pobierała kolejne rekordy i tworzyła akapity. W [lekcji 10B]({{ '/07-projekt-inf03/10b-jedno-zdjecie.html' | relative_url }}) PHP pobrało nazwę pliku z jednego rekordu i pokazało jedno zdjęcie.

Co zrobić, żeby zobaczyć wszystkie zdjęcia Islandii? W każdej iteracji znanej pętli utworzysz jeden obraz.

**Jedna iteracja pętli => jeden rekord => jedno zdjęcie.**

## Zobacz dane w phpMyAdmin

W bazie `Islandia` wykonaj:

```sql
SELECT nazwa, plik
FROM obiekty
WHERE panstwo = 'Islandia'
ORDER BY idObiekt;
```

Wynik ma **9 rekordów**. Każdy ma własną nazwę obiektu i nazwę pliku:

| Nazwa | Plik |
| --- | --- |
| Strokkur | `Strokkur.jpg` |
| Skogafoss | `Skogafoss.jpg` |
| Hekla | `hekla.jpg` |

Zwróć uwagę na wielkie i małe litery. PHP wykorzysta dokładnie te wartości, które znajdują się w kolumnie `plik`.

## Umieść zdjęcia obok programu

[Pobierz oryginalne załączniki egzaminacyjne](https://arkusze.pl/zawodowy/inf03-2026-czerwiec-egzamin-zawodowy-praktyczny-zalaczniki.zip). Rozpakuj je. Umieść wszystkie dziewięć zdjęć obok lokalnego `islandia.php` w `C:\xampp\htdocs\kurs-php\`.

Porównaj nazwy plików z wynikiem zapytania:

```text
Strokkur.jpg       Skogafoss.jpg       Seljalandsfoss.jpg
maskonur.jpg       kirkjuffel.jpg      husavik.jpg
hekla.jpg          godafoss.jpg        dettifoss.jpg
```

Nie zmieniaj wielkości liter. Nazwa w `src` musi wskazywać istniejący plik.

## Zmień dwa miejsca w islandia.php

Otwórz program z lekcji 10B. Jeśli w ćwiczeniu wybierałeś obiekt 47, teraz wróć do wszystkich obiektów Islandii. Nie przepisuj programu od początku. Zachowaj połączenie z bazą, kodowanie `utf8mb4` i sprawdzanie zapytania.

Pierwsza zmiana to przypisanie do `$zapytanie`:

```php
$zapytanie = "SELECT nazwa, plik FROM obiekty
WHERE panstwo = 'Islandia' ORDER BY idObiekt;";
```

Druga zmiana: zastąp pojedynczy odczyt rekordu oraz cały związany z nim blok `if` tą pętlą i kontrolą błędu:

```php
while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
    $plik = htmlspecialchars($rekord["plik"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    $nazwa = htmlspecialchars($rekord["nazwa"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    echo '<img src="' . $plik . '" alt="' . $nazwa . '" title="' . $nazwa . '" width="200">';
}
if ($rekord === false) {
    echo "<p>Nie udało się odczytać wszystkich danych.</p>";
}
```

Pierwszy przebieg pobiera Strokkur i tworzy obraz z `src="Strokkur.jpg"`. Drugi pobiera Skogafoss i tworzy kolejny obraz. Trzeci pobiera Seljalandsfoss. Pętla działa dalej, aż skończą się rekordy. Wtedy na stronie jest dziewięć elementów `img`.

`src` wskazuje zdjęcie. `alt` i `title` zawierają nazwę obiektu. `htmlspecialchars()` przygotowuje wartości z bazy do HTML, tak jak w 10B. `width="200"` zmniejsza rozmiar wyświetlanego obrazu. Sprawdzenie po pętli pokaże komunikat, jeśli odczyt zakończy się błędem.

Jeśli chcesz porównać cały program po tych dwóch zmianach, rozwiń przykład:

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
$zapytanie = "SELECT nazwa, plik FROM obiekty
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
    $plik = htmlspecialchars($rekord["plik"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    $nazwa = htmlspecialchars($rekord["nazwa"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    echo '<img src="' . $plik . '" alt="' . $nazwa . '" title="' . $nazwa . '" width="200">';
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

Konto `root` bez hasła stosuj wyłącznie na lokalnym, izolowanym stanowisku XAMPP, jeśli tak jest skonfigurowane.

## Sprawdź wynik

Otwórz `http://localhost/kurs-php/islandia.php`. Powinieneś zobaczyć **9 zdjęć**. W źródle strony sprawdź `alt` i `title` dla Strokkur oraz Hekli. Jeżeli brakuje któregoś zdjęcia, porównaj jego `src` z nazwą pliku w folderze.

Dlaczego powstało dziewięć obrazów? Zapytanie zwróciło dziewięć rekordów, a każda iteracja pętli utworzyła jeden `img`. Jeśli zmienisz warunek `WHERE`, liczba rekordów może się zmienić. Ta sama pętla utworzy wtedy inną liczbę obrazów.

## Spróbuj sam

### Ćwiczenie 1 - policz obrazy

Przed uruchomieniem przewidź liczbę zdjęć. Otwórz stronę i policz je. W źródle HTML znajdź wartości `alt` i `title` dla Strokkur i Hekli.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Pętla tworzy jeden `img` dla każdego rekordu. Nazwa Hekli pochodzi z kolumny `nazwa`, a jej plik to `hekla.jpg`.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

Powstaje 9 obrazów. Pierwszy ma `alt="Strokkur"` i `title="Strokkur"`. Obraz Hekli ma `src="hekla.jpg"`, `alt="Hekla"` i `title="Hekla"`.

</details>

### Ćwiczenie 2 - tylko wodospady

Zmień tylko warunek SQL: wybierz wodospady Islandii o `idRodzaj = 10`. Przewidź liczbę zdjęć, a potem sprawdź wynik. Nie zmieniaj pętli PHP.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Połącz warunek państwa i rodzaju przez `AND`. Zachowaj sortowanie po `idObiekt`.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

```php
$zapytanie = "SELECT nazwa, plik FROM obiekty
WHERE panstwo = 'Islandia' AND idRodzaj = 10 ORDER BY idObiekt;";
```

Powstaną 4 obrazy: Skogafoss, Seljalandsfoss, Godafoss i Dettifoss. Pętla działa tak samo, ale zapytanie zwraca mniej rekordów.

</details>

### Ćwiczenie 3 - odwrotna kolejność (dodatkowe)

Przywróć zapytanie dla wszystkich obiektów Islandii. Zmień sortowanie na `ORDER BY idObiekt DESC`. Przewidź, które zdjęcie będzie pierwsze. Nie zmieniaj pętli PHP.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 3</summary>

Największy `idObiekt` wśród obiektów Islandii to 54. Sprawdź, do którego pliku prowadzi ten rekord.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 3</summary>

```php
$zapytanie = "SELECT nazwa, plik FROM obiekty
WHERE panstwo = 'Islandia' ORDER BY idObiekt DESC;";
```

Pierwszy będzie Dettifoss (`dettifoss.jpg`). Nadal powstanie 9 zdjęć. Zmieni się tylko ich kolejność.

</details>
