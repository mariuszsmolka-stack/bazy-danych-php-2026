---
title: Lekcja 10D - Zdjęcie jako link do obiektu
---

# Lekcja 10D - Zdjęcie jako link do obiektu

W [lekcji 10C]({{ '/07-projekt-inf03/10c-galeria-w-petli.html' | relative_url }}) pętla utworzyła dziewięć zdjęć. Teraz każde zdjęcie będzie linkiem do strony wybranego obiektu. Numer po `id=` pochodzi z tego samego rekordu co zdjęcie.

**Jeden rekord => jedno zdjęcie => jeden link.**

| Obiekt | Adres strony po kliknięciu zdjęcia |
| --- | --- |
| Strokkur | `obiekty.php?id=46` |
| Skogafoss | `obiekty.php?id=47` |
| Hekla | `obiekty.php?id=52` |

Parametr `id` znasz z [lekcji 9]({{ '/05-php-i-html/02-get-parametry-url.html' | relative_url }}). W tamtej lekcji plik nazywał się `obiekt.php`; w przykładzie portalu używamy nazwy `obiekty.php`.

## Zobacz jeden zwykły link

```html
<a href="obiekty.php?id=46">
    <img src="Strokkur.jpg" alt="Strokkur">
</a>
```

`a` tworzy odnośnik, a `href` podaje jego adres. W środku jest `img`, więc kliknięcie zdjęcia otworzy wskazany adres. Każdy obiekt potrzebuje innej liczby po `id=`.

## Dodaj numer obiektu do zapytania

W bazie `Islandia` wykonaj w phpMyAdmin:

```sql
SELECT idObiekt, nazwa, plik
FROM obiekty
WHERE panstwo = 'Islandia'
ORDER BY idObiekt;
```

Wynik nadal ma **9 rekordów**. Do znanych kolumn `nazwa` i `plik` dodaliśmy `idObiekt`. Sprawdź w wynikach numery 46, 47 i 52.

Otwórz lokalny `islandia.php` z lekcji 10C. Jeśli po ćwiczeniu wyświetlasz tylko wodospady lub używasz odwrotnego sortowania, teraz wróć do zapytania powyżej. Zmień przypisanie do `$zapytanie`:

```php
$zapytanie = "SELECT idObiekt, nazwa, plik FROM obiekty
WHERE panstwo = 'Islandia' ORDER BY idObiekt;";
```

Zachowaj lokalne zdjęcia obok `islandia.php` w `C:\xampp\htdocs\kurs-php\`. Jeśli ich brakuje, [pobierz oryginalne załączniki egzaminacyjne](https://arkusze.pl/zawodowy/inf03-2026-czerwiec-egzamin-zawodowy-praktyczny-zalaczniki.zip) i rozpakuj je do tego folderu.

## Otocz znany obraz linkiem

Pozostaw pętlę z lekcji 10C. Dodaj w niej tylko te trzy instrukcje:

```php
$idObiekt = (int)$rekord["idObiekt"];
echo '<a href="obiekty.php?id=' . $idObiekt . '">';
echo '</a>';
```

Pierwszą linię wstaw na początku pętli. `(int)` zapisuje identyfikator jako liczbę całkowitą. Drugą linię umieść **przed** dotychczasowym `echo` tworzącym `img`. Trzecią umieść **po** nim. Otwarty i zamknięty znacznik `a` obejmą wtedy jedno zdjęcie.

W każdej iteracji `$idObiekt` pochodzi z bieżącego rekordu. Nie wpisujesz dziewięciu numerów ręcznie. Kod pętli pozostaje ten sam dla wszystkich zdjęć. Zachowaj też sprawdzenie błędu odczytu po pętli.

## Sprawdź adresy

Otwórz `http://localhost/kurs-php/islandia.php`. Powinieneś zobaczyć dziewięć zdjęć. Najedź kolejno na Strokkur, Skogafoss i Heklę. Sprawdź adresy `obiekty.php?id=46`, `obiekty.php?id=47` i `obiekty.php?id=52`. Możesz też obejrzeć `href` w źródle wygenerowanej strony.

Na razie sprawdzamy adres linku. Plik `obiekty.php` nie musi jeszcze istnieć. Po kliknięciu przeglądarka może pokazać błąd 404. Nie oznacza to błędu w utworzeniu linku.

Jeśli zapytanie nie zwróci rekordów, pętla nie utworzy żadnego zdjęcia ani linku. Nie trzeba do tego zmieniać programu.

Pełny program po dodaniu linków możesz rozwinąć tutaj:

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
$zapytanie = "SELECT idObiekt, nazwa, plik FROM obiekty
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
    $idObiekt = (int)$rekord["idObiekt"];
    $plik = htmlspecialchars($rekord["plik"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    $nazwa = htmlspecialchars($rekord["nazwa"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    echo '<a href="obiekty.php?id=' . $idObiekt . '">';
    echo '<img src="' . $plik . '" alt="' . $nazwa . '" title="' . $nazwa . '" width="200">';
    echo '</a>';
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

## Spróbuj sam

### Ćwiczenie 1 - który obiekt?

Przewidź adres zdjęcia Strokkur, Skogafoss i Hekli. Potem sprawdź je na stronie. Wyjaśnij, dlaczego po `id=` widzisz za każdym razem inną liczbę.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Odszukaj `idObiekt` tych trzech rekordów w wyniku zapytania. Pętla używa numeru bieżącego rekordu.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

Strokkur: `obiekty.php?id=46`, Skogafoss: `obiekty.php?id=47`, Hekla: `obiekty.php?id=52`. Każdy rekord ma własny `idObiekt`, więc każdy obraz dostaje właściwy adres.

</details>

### Ćwiczenie 2 - tylko wodospady

Zmień tylko zapytanie SQL: wybierz obiekty Islandii o `idRodzaj = 10`. Przewidź liczbę zdjęć i linków. Sprawdź ich adresy. Nie zmieniaj pętli.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Dodaj drugi warunek po `AND`. Zostaw w `SELECT` kolumnę `idObiekt`, bo jest potrzebna do adresu.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

```php
$zapytanie = "SELECT idObiekt, nazwa, plik FROM obiekty
WHERE panstwo = 'Islandia' AND idRodzaj = 10 ORDER BY idObiekt;";
```

Powstaną 4 zdjęcia i 4 linki. Ich adresy kończą się na `id=47`, `id=48`, `id=53` i `id=54`.

</details>
