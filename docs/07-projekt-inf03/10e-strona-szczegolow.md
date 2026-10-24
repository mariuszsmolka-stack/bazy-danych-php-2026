---
title: Lekcja 10E - Od zdjęcia do szczegółów obiektu
---

# Lekcja 10E - Od zdjęcia do szczegółów obiektu

W [lekcji 10D]({{ '/07-projekt-inf03/10d-zdjecia-jako-linki.html' | relative_url }}) zdjęcia w galerii stały się linkami. Po kliknięciu Strokkur przeglądarka otwiera `obiekty.php?id=46`. Teraz przygotujesz tę stronę szczegółów.

Znasz już wybieranie rekordu przez GET z [lekcji 9B]({{ '/05-php-i-html/02b-get-rekord-z-bazy.html' | relative_url }}) oraz wyświetlanie zdjęcia z nazwy pliku z [lekcji 10B]({{ '/07-projekt-inf03/10b-jedno-zdjecie.html' | relative_url }}). Połączymy te części. Nie trzeba pisać całego programu od początku.

**Jedno zdjęcie => jeden link => jedno id => jeden rekord => szczegóły obiektu.**

## 1. Użyj właściwej nazwy pliku

W lekcji 9B program szczegółów nazywał się `obiekt.php`. W projekcie INF.03 linki galerii wskazują `obiekty.php`. To dwa odrębne przykłady.

Utwórz nowy plik `obiekty.php` na podstawie znanego programu z lekcji 9B. Umieść go obok galerii:

```text
C:\xampp\htdocs\kurs-php\
    islandia.php
    obiekty.php
    Strokkur.jpg
    Skogafoss.jpg
    hekla.jpg
```

Zachowaj zdjęcia z wcześniejszych lekcji. Ich nazwy muszą zgadzać się z kolumną `plik` w bazie.

## 2. Sprawdź numer z adresu

Galeria tworzy na przykład link `obiekty.php?id=46`. Program odczyta `id` przez znany wzorzec:

```php
$idObiekt = filter_input(INPUT_GET, "id", FILTER_VALIDATE_INT);
```

Użytkownik może zmienić adres. Dlatego zachowaj z lekcji 9B sprawdzenie braku parametru oraz odrzucenie wartości, która nie jest dodatnią liczbą całkowitą. Surowego `$_GET["id"]` nie wstawiaj do SQL.

## 3. Pobierz dane i nazwę zdjęcia

Najpierw wykonaj w phpMyAdmin:

```sql
SELECT nazwa, panstwo, opis, plik
FROM obiekty
WHERE idObiekt = 46;
```

Otrzymasz jeden rekord: `nazwa = Strokkur`, `panstwo = Islandia` i `plik = Strokkur.jpg`. Kolumna `opis` zawiera opis gejzeru. Wcześniej pobieraliśmy nazwę, państwo i opis. Teraz potrzebujemy także kolumny `plik`.

W PHP zastąp stałe `46` sprawdzoną zmienną `$idObiekt`:

```php
$zapytanie = "SELECT nazwa, panstwo, opis, plik
FROM obiekty WHERE idObiekt = " . $idObiekt;
```

Do zapytania trafia wyłącznie zweryfikowana dodatnia liczba całkowita. Kolumna `idObiekt` jest kluczem głównym, więc zapytanie zwróci najwyżej jeden rekord.

## 4. Odczytaj jeden rekord

Wykonaj zapytanie przez `mysqli_query()`. Po sprawdzeniu, czy się powiodło, pobierz rekord:

```php
$rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC);
```

Nie potrzebujesz pętli `while`. Gdy `$rekord === null`, nie znaleziono obiektu. Gdy `$rekord === false`, wystąpił błąd odczytu. Dla `id=999` program powinien pokazać komunikat o braku obiektu.

## 5. Wyświetl tekst i zdjęcie

Z jednego rekordu odczytaj `nazwa`, `panstwo`, `opis` i `plik`. Nazwa pliku z bazy trafia do `src`, a nazwa obiektu do `alt`.

Przygotuj każdą z tych wartości przez `htmlspecialchars()` z `ENT_QUOTES | ENT_SUBSTITUTE` i kodowaniem `UTF-8`. Dotyczy to również wartości umieszczanych w atrybutach HTML. Same znaczniki HTML pozostają znacznikami.

Dla `id=46` przeglądarka otrzyma między innymi:

```html
<h1>Strokkur</h1>
<img src="Strokkur.jpg" alt="Strokkur">
```

Zdjęcie musi leżeć obok `obiekty.php`, tak jak leżało obok `islandia.php` w galerii.

## 6. Uruchom cały program

Włącz Apache i MariaDB w XAMPP. Zaimportuj `baza/baza1.sql` do bazy `Islandia`. Zapisz poniższy kod w UTF-8 jako `C:\xampp\htdocs\kurs-php\obiekty.php`.

Konto `root` bez hasła stosuj tylko na lokalnym stanowisku XAMPP, jeśli jest tak skonfigurowane.

```php
<?php
$idObiekt = filter_input(INPUT_GET, "id", FILTER_VALIDATE_INT);
if ($idObiekt === null) {
    exit("Brakuje parametru id.");
}
if ($idObiekt === false || $idObiekt <= 0) {
    exit("Niepoprawny identyfikator.");
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

$zapytanie = "SELECT nazwa, panstwo, opis, plik FROM obiekty WHERE idObiekt = " . $idObiekt;
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
    exit("Nie znaleziono obiektu.");
}

$nazwa = htmlspecialchars($rekord["nazwa"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
$panstwo = htmlspecialchars($rekord["panstwo"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
$opis = htmlspecialchars($rekord["opis"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
$plik = htmlspecialchars($rekord["plik"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
?>
<!doctype html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Szczegóły obiektu</title>
</head>
<body>
<?php
echo "<h1>" . $nazwa . "</h1>";
echo "<p>Państwo: " . $panstwo . "</p>";
echo "<p>" . $opis . "</p>";
echo '<img src="' . $plik . '" alt="' . $nazwa . '">';
?>
<p><a href="islandia.php">Powrót do galerii</a></p>
</body>
</html>
```

Otwórz `http://localhost/kurs-php/islandia.php` i kliknij zdjęcie Strokkur. Na stronie szczegółów zobaczysz nazwę, państwo, opis i zdjęcie `Strokkur.jpg`. Link **Powrót do galerii** otworzy ponownie `islandia.php`.

Sprawdź też Skogafoss (`id=47`) i Heklę (`id=52`). Dla Hekli pole `plik` zawiera dokładnie `hekla.jpg`. Zachowaj tę wielkość liter w nazwie lokalnego zdjęcia.

## 7. Ćwiczenia

### Ćwiczenie 1 - trzy zdjęcia, trzy obiekty

Przewidź `id` dla zdjęć Strokkur, Skogafoss i Hekli. Kliknij każde zdjęcie w galerii. Sprawdź nazwę obiektu, państwo i zdjęcie na stronie szczegółów. Po każdym obiekcie wróć do galerii.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Identyfikator znajduje się w adresie po `id=`. Nazwa zdjęcia pochodzi z kolumny `plik` tego samego rekordu.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

Strokkur: `id=46`, zdjęcie `Strokkur.jpg`. Skogafoss: `id=47`, zdjęcie `Skogafoss.jpg`. Hekla: `id=52`, zdjęcie `hekla.jpg`. Wszystkie trzy rekordy mają państwo `Islandia`.

</details>

### Ćwiczenie 2 - błędne id i brak rekordu

Otwórz `obiekty.php` bez parametru, a potem z `?id=abc` i `?id=999`. Wyjaśnij, które adresy zostaną odrzucone przed SQL, a który przejdzie walidację bez znalezienia rekordu.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Oddziel sprawdzenie liczby od szukania obiektu w bazie. `999` jest dodatnią liczbą całkowitą.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

Bez `id` zobaczysz `Brakuje parametru id.`. Dla `id=abc` zobaczysz `Niepoprawny identyfikator.`. Te adresy nie wykonają SELECT.

Wartość `999` przejdzie walidację. Zapytanie wykona się, lecz w kursowej bazie nie ma takiego obiektu. Program pokaże `Nie znaleziono obiektu.`.

</details>

## 8. Zapamiętaj

Kliknięcie zdjęcia przekazuje `id` do `obiekty.php`. Program sprawdza numer, pobiera jeden rekord i wyświetla jego tekst oraz zdjęcie. Nazwa zdjęcia pochodzi z pola `plik` tego rekordu.

## Sprawdzian samodzielności

Zakończyłeś projekt? [Przejdź do sprawdzianu samodzielności]({{ '/07-projekt-inf03/sprawdzian-samodzielnosci.html' | relative_url }}).
