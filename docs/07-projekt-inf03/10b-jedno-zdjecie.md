---
title: Lekcja 10B - Jedna nazwa pliku, jedno zdjęcie
---

# Lekcja 10B - Jedna nazwa pliku, jedno zdjęcie

W [lekcji 10A]({{ '/07-projekt-inf03/10a-nazwy-z-bazy.html' | relative_url }}) PHP pobierało nazwy z tabeli `obiekty` i tworzyło akapity. Teraz pobierzesz jeden rekord i pokażesz jedno zdjęcie.

**Jeden rekord => jedna nazwa pliku => jedno zdjęcie.**

## Nazwa pliku i zdjęcie to dwie różne rzeczy

W bazie `Islandia` rekord o `idObiekt = 46` ma nazwę **Strokkur**. W kolumnie `plik` znajduje się napis `Strokkur.jpg`. Ten napis nie jest zdjęciem. Zdjęcie jest osobnym plikiem na komputerze.

Najprostszy znacznik obrazu wygląda tak:

```html
<img src="Strokkur.jpg" alt="Strokkur">
```

`img` oznacza obraz. `src` mówi przeglądarce, który plik ma otworzyć. `alt` opisuje obraz tekstem. Gdy pliku nie ma we wskazanym miejscu, przeglądarka nie pokaże zdjęcia.

[Pobierz oryginalne załączniki egzaminacyjne](https://arkusze.pl/zawodowy/inf03-2026-czerwiec-egzamin-zawodowy-praktyczny-zalaczniki.zip). Rozpakuj archiwum. Umieść `Strokkur.jpg` obok swojego pliku `islandia.php`:

```text
C:\xampp\htdocs\kurs-php\
    islandia.php
    Strokkur.jpg
```

Zachowaj wielkie i małe litery w nazwie. W ćwiczeniu 2 umieścisz w tym samym folderze także `Skogafoss.jpg`.

## Wybierz jeden rekord

Najpierw uruchom w phpMyAdmin:

```sql
SELECT nazwa, plik
FROM obiekty
WHERE idObiekt = 46;
```

Otrzymasz jeden rekord: `nazwa = Strokkur` i `plik = Strokkur.jpg`. Zapytanie wybiera dane, ale samo nie otwiera pliku zdjęcia.

Otwórz lokalny `islandia.php` z lekcji 10A. Jeśli po ćwiczeniu z wodospadami masz inne zapytanie, teraz je zastąp. Zmień tylko przypisanie do `$zapytanie`:

```php
$zapytanie = "SELECT nazwa, plik FROM obiekty WHERE idObiekt = 46;";
```

Zachowaj połączenie, ustawienie kodowania, sprawdzenie zapytania i dokument HTML. W miejscu pętli `while` oraz następującego po niej sprawdzenia `$rekord === false` wstaw:

```php
$rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC);
if ($rekord === false) {
    echo "<p>Nie udało się odczytać danych.</p>";
} elseif ($rekord === null) {
    echo "<p>Nie znaleziono obiektu.</p>";
} else {
    $nazwa = htmlspecialchars($rekord["nazwa"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    $plik = htmlspecialchars($rekord["plik"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    echo '<img src="' . $plik . '" alt="' . $nazwa . '">';
}
```

`mysqli_fetch_array()` pobiera jeden rekord. Jeśli odczyt się nie uda, program pokaże komunikat. Jeśli zapytanie nie znajdzie rekordu, pokaże inny komunikat. Przy poprawnym wyniku `$plik` trafia do `src`, a `$nazwa` do `alt`. `htmlspecialchars()` przygotowuje obie wartości do użycia w HTML. To ten sam sposób wyświetlania tekstu, który już znasz.

Sprawdź końcową wersję programu, jeśli potrzebujesz porównać swoje dwie zmiany:

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
$zapytanie = "SELECT nazwa, plik FROM obiekty WHERE idObiekt = 46;";
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
$rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC);
if ($rekord === false) {
    echo "<p>Nie udało się odczytać danych.</p>";
} elseif ($rekord === null) {
    echo "<p>Nie znaleziono obiektu.</p>";
} else {
    $nazwa = htmlspecialchars($rekord["nazwa"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    $plik = htmlspecialchars($rekord["plik"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    echo '<img src="' . $plik . '" alt="' . $nazwa . '">';
}
mysqli_close($polaczenie);
?>
</body>
</html>
```

</details>

Dane konta `root` bez hasła stosuj wyłącznie w lokalnym, izolowanym XAMPP, jeśli tak jest skonfigurowany.

## Sprawdź jedno zdjęcie

Otwórz `http://localhost/kurs-php/islandia.php`. Powinieneś zobaczyć **jedno zdjęcie Strokkur**. Odpowiedz sobie: skąd PHP zna nazwę pliku? Gdzie leży rzeczywisty obraz? Co robi `src`? Co zobaczysz, jeśli zabraknie pliku?

Jeśli zdjęcia nie ma, porównaj nazwę z kolumny `plik` z nazwą w folderze. Sprawdź również, czy plik leży obok `islandia.php`.

## Spróbuj sam

### Ćwiczenie 1 - brak pliku

Przewidź, co się stanie, jeśli na chwilę zmienisz nazwę lokalnego `Strokkur.jpg` na `Strokkur-brak.jpg`. Odśwież stronę. Jeśli nadal widzisz zdjęcie z pamięci przeglądarki, użyj `Ctrl+F5`. Potem przywróć nazwę `Strokkur.jpg` i odśwież ją ponownie. Nie zmieniaj danych w bazie.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

`src` nadal wskazuje `Strokkur.jpg`. Sprawdź, czy plik o tej nazwie istnieje w folderze strony.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

Po zmianie nazwy przeglądarka nie znajdzie zdjęcia. Znacznik `img` nadal powstaje, bo zapytanie działa. Po przywróceniu nazwy zdjęcie znów się wyświetli.

</details>

### Ćwiczenie 2 - inny obiekt

Umieść `Skogafoss.jpg` obok `islandia.php`. Zmień zapytanie tak, aby pobrać obiekt o `idObiekt = 47`. Przed uruchomieniem sprawdź w phpMyAdmin jego nazwę i wartość kolumny `plik`. Przewidź obraz na stronie. Nie zmieniaj kodu tworzącego `img`.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

W przypisaniu do `$zapytanie` zmień tylko numer w warunku `WHERE`. Plik zdjęcia leży w tym samym folderze co `islandia.php`.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

```php
$zapytanie = "SELECT nazwa, plik FROM obiekty WHERE idObiekt = 47;";
```

Wynik to `nazwa = Skogafoss` i `plik = Skogafoss.jpg`. Strona pokaże jedno zdjęcie Skogafoss. PHP wstawi nową wartość kolumny `plik` do tego samego znacznika `img`.

</details>
