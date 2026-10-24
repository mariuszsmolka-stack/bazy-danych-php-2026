---
title: Lekcja 10 - Od zapytania SQL do galerii zdjęć
---

# Lekcja 10 - Od zapytania SQL do galerii zdjęć

W tabeli `obiekty` są informacje o miejscach turystycznych. Kolumna `plik` zawiera nazwę zdjęcia. PHP może użyć tej nazwy w HTML. Przeglądarka pobierze wtedy obraz z odpowiedniego pliku.

**MariaDB => SELECT => PHP => HTML => zdjęcie w przeglądarce**

Znasz już większość potrzebnych instrukcji. Teraz połączysz je małymi krokami: nazwy => jedno zdjęcie => galeria => linki.

Powtórka: [połączenie z bazą - lekcja 2]({{ '/02-php-i-mariadb/01-odczyt-danych.html' | relative_url }}), [zapytania SQL - lekcja 3]({{ '/03-zapytania-inf03/01-cztery-zapytania.html' | relative_url }}), [HTML z danych - lekcja 8]({{ '/05-php-i-html/01-generowanie-html-z-bazy.html' | relative_url }}) i [GET - lekcja 9]({{ '/05-php-i-html/02-get-parametry-url.html' | relative_url }}).

Jeśli nie wiesz, od czego zacząć, wróć do [przewodnika planowania INF.03]({{ '/07-projekt-inf03/01-jak-zaplanowac-zadanie.html' | relative_url }}).

## 1. Pobieramy nazwy obiektów

Włącz Apache i MariaDB w XAMPP. W phpMyAdmin wybierz bazę `Islandia`. Na danych z kursowego pliku `baza1.sql` wykonaj:

```sql
SELECT idObiekt, plik, nazwa
FROM obiekty
WHERE panstwo = 'Islandia'
ORDER BY idObiekt;
```

Wynik ma **9 rekordów**. Każda kolumna ma inne zadanie:

| Kolumna | Do czego jej użyjemy? | Pierwszy rekord |
| --- | --- | --- |
| `idObiekt` | Numer obiektu w linku | 46 |
| `plik` | Nazwa pliku obrazu | Strokkur.jpg |
| `nazwa` | Nazwa miejsca i opis zdjęcia | Strokkur |

`WHERE` wybiera Islandię. `ORDER BY` ustala kolejność według identyfikatora. Bez sortowania nie zakładamy określonej kolejności wyników.

### Pliki na komputerze

[Pobierz oryginalne załączniki egzaminacyjne](https://arkusze.pl/zawodowy/inf03-2026-czerwiec-egzamin-zawodowy-praktyczny-zalaczniki.zip). Rozpakuj fotografie. Umieść je obok pliku PHP, zachowując nazwy i wielkość liter.

Przykładowy folder:

```text
C:\xampp\htdocs\kurs-php\
    islandia.php
    Strokkur.jpg
    Skogafoss.jpg
    Seljalandsfoss.jpg
    maskonur.jpg
    kirkjuffel.jpg
    husavik.jpg
    hekla.jpg
    godafoss.jpg
    dettifoss.jpg
```

Kod zapisuj w VS Code jako UTF-8. Stronę uruchamiaj pod adresem `http://localhost/kurs-php/islandia.php`.

GitHub Pages wyświetla materiał dydaktyczny. Kod PHP uruchamiasz lokalnie w XAMPP. Otwarcie pliku z dysku przez `file://` nie uruchamia PHP.

### Najpierw same nazwy

Zacznij od listy nazw. Dzięki temu sprawdzisz połączenie i odczyt danych przed dodaniem zdjęć. Użyj znanego wzorca z lekcji 8.

Zapisz poniższy program w `islandia.php`:

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
$zapytanie = "SELECT idObiekt, plik, nazwa FROM obiekty
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
// WIDOK - początek
while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
    $nazwa = htmlspecialchars($rekord["nazwa"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    echo "<p>" . $nazwa . "</p>";
}
// WIDOK - koniec
if ($rekord === false) {
    echo "<p>Nie udało się odczytać wszystkich danych.</p>";
}
mysqli_close($polaczenie);
?>
</body>
</html>
```

Gotowe kontrole zatrzymują program po błędzie połączenia lub zapytania. `MYSQLI_REPORT_OFF` oznacza, że sami sprawdzamy wyniki operacji. Ustawienie `utf8mb4` i zapis dokumentu w UTF-8 pozwalają wyświetlić nazwy miejsc. Konto `root` bez hasła stosujemy wyłącznie na lokalnym stanowisku XAMPP.

W bloku WIDOK pętla pobiera kolejne rekordy. Każde `echo` tworzy jeden akapit. `htmlspecialchars()` przygotowuje tekst do HTML. Zachowaj jej argumenty; nie musisz uczyć się ich ponownie. Końcowa kontrola odróżnia błąd odczytu od końca danych.

Po uruchomieniu powinieneś zobaczyć kolejno:

| Numer na stronie | Nazwa |
| --- | --- |
| 1 | Strokkur |
| 2 | Skogafoss |
| 3 | Seljalandsfoss |
| 4 | Fuglaskoðunarhús |
| 5 | kirkjuffell |
| 6 | Siedlisko wielorybów |
| 7 | Hekla |
| 8 | Godafoss |
| 9 | Dettifoss |

Jeśli nazw nie ma, zatrzymaj się na tym etapie. Sprawdź komunikat programu oraz wynik SQL w phpMyAdmin.

## 2. Wyświetlamy jedno zdjęcie

`Strokkur.jpg` w bazie jest zwykłym tekstem. Sam obraz znajduje się w pliku na dysku. Poprawna nazwa w bazie nie wystarczy, jeśli brakuje pliku zdjęcia.

Najprostszy obraz w HTML wygląda tak:

```html
<img src="Strokkur.jpg" alt="Strokkur" title="Strokkur" width="200">
```

`src` wskazuje plik. `alt` opisuje obraz, także gdy nie można go wczytać. `title` może pokazać nazwę po najechaniu. `width="200"` pozwala obejrzeć obraz w niewielkim rozmiarze bez tworzenia stylów.

Teraz użyj pierwszego rekordu zapytania. **Zastąp cały blok WIDOK** poniższym fragmentem. Nie dopisuj go po starej pętli, bo ta odczytała już wszystkie rekordy.

```php
$rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC);
if ($rekord) {
    $plik = htmlspecialchars($rekord["plik"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    $nazwa = htmlspecialchars($rekord["nazwa"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    echo '<img src="' . $plik . '" alt="' . $nazwa . '" title="' . $nazwa . '" width="200">';
}
```

Pobierasz jeden rekord, bez pętli. `if ($rekord)` pozwala użyć pól tylko wtedy, gdy rekord istnieje. Pole `plik` daje nazwę zdjęcia, a pole `nazwa` jego opis. Kropki łączą fragmenty HTML z wartościami.

Apostrofy otaczają tekst PHP. Cudzysłowy wewnątrz należą do atrybutów HTML. Wartości z bazy kodujemy przez `htmlspecialchars()`, aby pozostały tekstem w tych atrybutach. Korzystamy tutaj z nazw plików w niezmienionej bazie ćwiczeniowej.

Wynik: **jedno zdjęcie Strokkur**. Jedna wartość pola `plik` wskazuje jeden obraz. Po odświeżeniu zapytanie wykonuje się od początku.

## 3. Tworzymy dziewięć zdjęć

Potrafisz już pobrać rekord i wyświetlić obraz. Teraz powtórz te same instrukcje dla każdego rekordu. Zastąp blok WIDOK:

```php
while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
    $plik = htmlspecialchars($rekord["plik"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    $nazwa = htmlspecialchars($rekord["nazwa"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    echo '<img src="' . $plik . '" alt="' . $nazwa . '" title="' . $nazwa . '" width="200">';
}
```

`$rekord` zawiera teraz dane bieżącego obiektu. Pierwszy ma `plik` równy `Strokkur.jpg`. Kolejny wskazuje `Skogafoss.jpg`.

Przy każdym sprawdzeniu warunku funkcja pobiera następny rekord. Dlatego pętla tworzy kolejne obrazy. Gdy rekordy się skończą, funkcja zwróci `null` i pętla się zatrzyma. Błąd odczytu zwraca `false`; obsługuje go kontrola po bloku WIDOK.

Wynik: **9 elementów img i 9 zdjęć**, jeśli pliki znajdują się we właściwym folderze. Każdy obraz ma własne `alt` i `title` z kolumny `nazwa`. Układ zdjęć zależy od szerokości okna.

## 4. Zdjęcie staje się odnośnikiem

W lekcji 9 przekazywaliśmy numer obiektu przez GET. Przykładowy adres portalu to `obiekty.php?id=46`.

Uwaga na nazwę: w lekcji 9 używaliśmy `obiekt.php`. W portalu egzaminacyjnym plik szczegółów nazywa się **`obiekty.php`**. Linki w tej lekcji wskazują tę drugą nazwę.

Dla jednego rekordu docelowy HTML wygląda tak:

```html
<a href="obiekty.php?id=46">
    <img src="Strokkur.jpg" alt="Strokkur" title="Strokkur" width="200">
</a>
```

Znacznik `a` otacza obraz. Dzięki temu kliknięcie zdjęcia przechodzi pod adres z `href`.

W przykładzie jednego rekordu z kroku 2, wewnątrz `if`, zamień samą instrukcję `echo` na:

```php
$idObiekt = (int)$rekord["idObiekt"];
echo '<a href="obiekty.php?id=' . $idObiekt . '">';
echo '<img src="' . $plik . '" alt="' . $nazwa . '" title="' . $nazwa . '" width="200">';
echo '</a>';
```

Identyfikator pochodzi z całkowitoliczbowej kolumny `idObiekt`. Znane `(int)` zapewnia zapis liczby w adresie. Pierwsze `echo` otwiera link, drugie tworzy obraz, a trzecie zamyka link.

Teraz zrób to dla wszystkich rekordów. Wstaw cały nowy blok WIDOK do programu z kroku 1:

```php
while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
    $idObiekt = (int)$rekord["idObiekt"];
    $plik = htmlspecialchars($rekord["plik"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    $nazwa = htmlspecialchars($rekord["nazwa"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    echo '<a href="obiekty.php?id=' . $idObiekt . '">';
    echo '<img src="' . $plik . '" alt="' . $nazwa . '" title="' . $nazwa . '" width="200">';
    echo '</a>';
}
```

**Jeden rekord => jedno zdjęcie => jeden odnośnik z właściwym identyfikatorem.**

Strokkur prowadzi do `obiekty.php?id=46`, Skogafoss do `obiekty.php?id=47`, a Hekla do `obiekty.php?id=52`.

Plik szczegółów powstanie na następnej lekcji. Teraz sprawdzaj adres linku, nie gotowy opis obiektu. Jeśli `obiekty.php` jeszcze nie istnieje, kliknięcie zakończy się komunikatem o braku strony. Nie oznacza to błędu galerii. Wróć do `islandia.php` przyciskiem Wstecz.

## 5. Sprawdzamy działanie

| Co sprawdzam? | Oczekiwany wynik |
| --- | --- |
| Zapytanie SQL | 9 rekordów z Islandii |
| PHP w kroku 1 | 9 nazw obiektów |
| Galeria | 9 zdjęć |
| Odnośniki | Różne wartości `id`, zgodne z rekordami |
| Kliknięcie | Adres właściwego obiektu; opis wymaga pliku szczegółów |

W źródle strony zobaczysz HTML wygenerowany przez PHP. Możesz odszukać `img` i sprawdzić wartości `src`. Adres linku sprawdzisz także po najechaniu na zdjęcie.

Jeśli nazwa jest widoczna, a zdjęcia brakuje, sprawdź plik obrazu i ścieżkę. Porównaj wielkość liter. Nie zaczynaj od zmiany zapytania SQL.

Jeśli widzisz tylko jedno zdjęcie, sprawdź, czy używasz pętli z kroku 3 lub 4. Jeśli nie ma żadnych danych, wróć do kroku 1. Pusty wynik nie wykona ciała pętli ani razu.

## 6. Cztery ćwiczenia obowiązkowe

Pracuj na jednej kopii `islandia.php`. Zmieniaj tylko wskazane fragmenty. Przed uruchomieniem przewidź wynik.

### Ćwiczenie 1 - nazwy

Uruchom program z kroku 1. Ile akapitów powinno powstać? Podaj pierwszą i ostatnią nazwę według idObiekt.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Porównaj wynik SQL z tabelą nazw. Jeden rekord tworzy jeden akapit.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

Powstanie 9 akapitów. Pierwszy pokaże Strokkur, ostatni Dettifoss. Wykorzystaj program z kroku 1 bez zmian.

</details>

### Ćwiczenie 2 - jeden obraz

Zastąp blok WIDOK fragmentem z kroku 2. Przewidź, które zdjęcie zobaczysz i dlaczego tylko jedno. Sprawdź wynik w przeglądarce.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Zapytanie jest sortowane po idObiekt. Fragment wykonuje tylko jeden odczyt rekordu.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

Zobaczysz Strokkur. Pierwszy rekord wskazuje `Strokkur.jpg`. Nie ma pętli, więc pozostałe osiem rekordów nie utworzy obrazów.

</details>

### Ćwiczenie 3 - galeria

Zamień pojedynczy odczyt na blok WIDOK z kroku 3. Przewidź liczbę obrazów. Sprawdź `alt` i `title` pierwszego obrazu w źródle strony.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 3</summary>

Pętla pobiera wszystkie rekordy. Oba atrybuty korzystają ze zmiennej `$nazwa`.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 3</summary>

Powstanie 9 obrazów. Pierwszy ma `alt="Strokkur"` oraz `title="Strokkur"`. Kod pętli z kroku 3 zastępuje cały dotychczasowy blok WIDOK.

</details>

### Ćwiczenie 4 - tylko wodospady

W galerii z kroku 3 zmień warunek SQL. Wybierz tylko wodospady z Islandii. W tabeli `rodzaje` wodospad ma `idRodzaj = 10`. Przewidź liczbę zdjęć. Zachowaj sortowanie po idObiekt.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 4</summary>

Połącz warunek państwa i rodzaju przez AND. Nie zmieniaj pętli PHP.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 4</summary>


```php
$zapytanie = "SELECT idObiekt, plik, nazwa FROM obiekty
WHERE panstwo = 'Islandia' AND idRodzaj = 10 ORDER BY idObiekt;";
```

Wynik: 4 zdjęcia - Skogafoss, Seljalandsfoss, Godafoss i Dettifoss. Zmień tę instrukcję przed wykonaniem `mysqli_query()`.

</details>

## 7. Dwa ćwiczenia dodatkowe

### Ćwiczenie 5 - linki galerii

Przywróć zapytanie dla wszystkich obiektów Islandii. Wstaw blok WIDOK z kroku 4. Przewidź adres linku Hekli. Sprawdź go bez pisania strony szczegółów.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 5</summary>

Numer Hekli to 52. Link wskazuje `obiekty.php`, a nie `obiekt.php`.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 5</summary>

W galerii będzie 9 linków. Hekla prowadzi do `http://localhost/kurs-php/obiekty.php?id=52`. Do przywrócenia wszystkich obiektów usuń wyłącznie `AND idRodzaj = 10` z zapytania ćwiczenia 4.

</details>

### Ćwiczenie 6 - podpis pod linkiem

W pętli z kroku 4 dopisz nazwę obiektu po zamknięciu jego linku. Użyj zmiennej `$nazwa`. Przewidź liczbę podpisów dla wszystkich obiektów Islandii.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 6</summary>

Zmienna `$nazwa` jest już przygotowana do wyświetlenia w HTML. Dopisz akapit wewnątrz pętli, po `echo '</a>';`.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 6</summary>


```php
echo "<p>" . $nazwa . "</p>";
```

Powstanie 9 podpisów. Nie przenoś instrukcji poza pętlę, bo każdy rekord ma własną nazwę.

</details>

## 8. Co już potrafisz?

Umiesz przejść od wyniku SELECT do nazw, obrazów i linków. Wiesz, że nazwa zdjęcia w bazie i plik obrazu to dwie różne rzeczy. Jedna iteracja pętli zamienia jeden rekord w jeden element galerii.

Na następnej lekcji wykorzystasz identyfikator z linku do pokazania szczegółów miejsca. Pomoc dotycząca wyglądu strony jest w [materiałach dodatkowych HTML i CSS]({{ '/06-html-css-dodatkowe/index.html' | relative_url }}).
