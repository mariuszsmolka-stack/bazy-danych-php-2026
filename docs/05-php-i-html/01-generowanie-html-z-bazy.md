---
title: Lekcja 8 - PHP i dynamiczne generowanie HTML z danych MariaDB
---

# Lekcja 8 - PHP i dynamiczne generowanie HTML z danych MariaDB

**Cel: wyświetlić tabelę turystów i ich punktów z bazy Islandia.** Zamiast wpisywać każdy wiersz ręcznie, polecimy PHP: pobierz rekord i utwórz dla niego wiersz HTML.

## Część A - podstawowa, obowiązkowa

Pracuj po kolei. Po kroku 3 możesz zrobić przerwę; przy powrocie przypomnij sobie, co kończy pętlę. Po części A powinieneś umieć wyjaśnić: **jedna iteracja pętli pobiera jednego turystę i tworzy jeden wiersz tabeli**.

### 1. Z czego składa się tabela?

Oto dwa fikcyjne wiersze demonstracyjne, niezwiązane z wynikami bazy:

```html
<table>
    <tr><th>Turysta</th><th>Punkty</th></tr>
    <tr><td>Turysta A</td><td>10</td></tr>
    <tr><td>Turysta B</td><td>20</td></tr>
</table>
```

`table` otacza tabelę, `tr` jeden wiersz, `th` komórkę nagłówka, a `td` komórkę danych. Ukośnik oznacza zamknięcie elementu. Wiersze znajdują się wewnątrz tabeli, a komórki wewnątrz wierszy.

Przeglądarka pokaże:

| Turysta | Punkty |
| --- | --- |
| Turysta A | 10 |
| Turysta B | 20 |

Bez stylów CSS tabela może nie mieć obramowania. Jej wiersze i kolumny nadal istnieją.

**Mały krok:** wskaż w kodzie cały wiersz Turysty B. Który fragment trzeba powtórzyć, aby dodać Turystę C?

### 2. PHP tworzy HTML

Najpierw jeden akapit. To kod źródłowy PHP:

```php
<?php
echo "<p>Witaj na stronie turystów</p>";
?>
```

`echo` wysyła tekst do odpowiedzi serwera. Powstaje HTML:

```html
<p>Witaj na stronie turystów</p>
```

Przeglądarka pokazuje akapit „Witaj na stronie turystów”. Nie pokazuje cudzysłowów PHP ani średnika.

Teraz dwa akapity:

```php
<?php
echo "<p>Poznajemy Islandię.</p>";
echo "<p>Zbieramy punkty.</p>";
?>
```

Dwie instrukcje tworzą dwa elementy `p`, więc czytelnik zobaczy dwa akapity. **Spróbuj zmienić tekst drugiego akapitu.**

Kod PHP wykonuje serwer. Przeglądarka otrzymuje HTML, nie wykonuje PHP:

`MariaDB => PHP => HTML => przeglądarka`

Uruchamiaj przykłady w XAMPP: włącz Apache i MariaDB, przygotuj bazę `Islandia` z `baza/baza1.sql`. Zapisuj kod w UTF-8 jako `C:\xampp\htdocs\kurs-php\turysci.php` i otwieraj `http://localhost/kurs-php/turysci.php`. Każdy mały program uruchamiaj osobno. Otwarcie pliku przez `file://` nie uruchamia PHP. GitHub Pages pokazuje przykłady, ale ich nie wykonuje.

### 3. while - powtarzaj, dopóki warunek jest prawdziwy

Najpierw przykład bez bazy:

```php
<?php
$numer = 1;
while ($numer <= 3) {
    echo "<p>Numer " . $numer . "</p>";
    $numer++;
}
```

`while` sprawdza warunek **przed każdym wykonaniem**. Początkowo `$numer` wynosi 1. Ciało pętli tworzy akapit, a `$numer++` zwiększa liczbę o 1. Dla 2 i 3 pętla działa ponownie. Dla 4 warunek jest fałszywy i pętla się kończy. Powstaną trzy akapity: Numer 1, Numer 2, Numer 3.

**Przewidź wynik:** co zmieni zastąpienie `3` przez `2`? Dlaczego nie wolno tutaj usunąć `$numer++`?

Znasz już `for` z licznikiem i `foreach` przechodzące przez tablicę. `while` przyda się, gdy chcemy pobierać rekordy tak długo, jak są dostępne.

Po wykonaniu zapytania `$wynik` zawiera jego wynik. Odczytujemy go tak:

```php
while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
    // Operacje na kolejnym rekordzie
}
```

Czytaj warunek od prawej strony:

1. `mysqli_fetch_array()` pobiera **kolejny rekord** jako tablicę.
2. `MYSQLI_ASSOC` oznacza klucze z nazwami kolumn, np. `$rekord["nick"]` i `$rekord["punkty"]`.
3. `=` zapisuje tablicę w `$rekord`. To przypisanie. `==` porównuje wartości i nie zapisałoby nowego rekordu.
4. Niepusta tablica oznacza prawdziwy warunek, więc PHP wykonuje ciało pętli.
5. Przy następnym sprawdzeniu funkcja pobiera następny rekord. Wynik zapamiętuje miejsce odczytu, dlatego nie wracamy za każdym razem do pierwszego turysty.

Dla zapytania sortowanego według `idTurysta`:

| Sprawdzenie warunku | Zawartość rekordu | Działanie |
| --- | --- | --- |
| Pierwsze | nick: Ewa, punkty: 23 | Wykonaj ciało pętli |
| Drugie | nick: Monika, punkty: 4 | Wykonaj ciało pętli |
| Trzecie | nick: Janek, punkty: 12 | Wykonaj ciało pętli |

Potem odczytujemy pozostałych turystów. Po ostatnim funkcja zwraca `null`, więc pętla się kończy. W razie błędu może zwrócić `false`, co również ją zatrzyma. Rozróżnienie tych sytuacji zostawimy do części B.

### 4. Jeden rekord => jeden element listy

Pobierzemy dane zapytaniem:

```sql
SELECT nick, punkty FROM turysci ORDER BY idTurysta;
```

`ORDER BY` ustala kolejność; bez niego kolejność nie jest gwarantowana. W oryginalnej bazie jest 13 turystów.

Najpierw sam fragment generujący listę. Wstawia się go **po udanym zapytaniu**, gdy istnieje `$wynik`:

```php
echo "<ul>";
while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
    $nick = htmlspecialchars($rekord["nick"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    echo "<li>" . $nick . " - " . (int)$rekord["punkty"] . "</li>";
}
echo "</ul>";
```

`ul` otwiera listę raz. W każdym przebiegu `echo` tworzy jedno `li`. Kropka `.` łączy teksty. W pierwszym przebiegu powstaje:

```html
<li>Ewa - 23</li>
```

Początek widocznego wyniku:

- Ewa - 23
- Monika - 4
- Janek - 12

Program pokaże także pozostałych turystów. Linia z `htmlspecialchars()` przygotowuje nick do bezpiecznego wyświetlenia jako tekst HTML. Na razie kopiuj ją jako gotowy wzorzec - nie musisz pamiętać nazw opcji. `(int)` zamienia punkty na liczbę całkowitą; ta kolumna zawiera całkowite punkty.

**Mały krok:** wskaż instrukcję wykonywaną 13 razy i instrukcję zamykającą listę tylko raz. W kroku 6 umieścisz ten fragment w kompletnym programie, zastępując wskazany blok tabeli.

### 5. Jeden rekord => jeden wiersz tabeli

Zamiast `li` tworzymy wiersz `tr` z dwiema komórkami `td`:

```php
echo "<table>";
echo "<tr><th>Turysta</th><th>Punkty</th></tr>";
while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
    $nick = htmlspecialchars($rekord["nick"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    echo "<tr><td>" . $nick . "</td><td>" . (int)$rekord["punkty"] . "</td></tr>";
}
echo "</table>";
```

Zapamiętaj trzy miejsca:

1. **Przed pętlą:** otwarcie tabeli i nagłówki - tylko raz.
2. **W pętli:** jeden cały wiersz z nickiem i punktami.
3. **Po pętli:** zamknięcie tabeli - tylko raz.

Dla pierwszego turysty PHP tworzy:

```html
<tr><td>Ewa</td><td>23</td></tr>
```

Dla Moniki powstanie następny `tr`. **Wyjaśnij własnymi słowami:** dlaczego otwarcie `table` wewnątrz pętli utworzyłoby wiele tabel zamiast jednej?

### 6. Jeden kompletny program wyjściowy

Skopiuj ten program raz do `turysci.php`. Zawiera dwa oznaczone miejsca do ćwiczeń: **ZAPYTANIE** oraz **WIDOK**. Aby uruchomić pełną wersję z listą z kroku 4, zastąp wyłącznie zawartość bloku WIDOK tamtym fragmentem. Połączenie, zapytanie i zamknięcie połączenia pozostają wspólne.

Najpierw poznaj przygotowane instrukcje techniczne:

- `mysqli_report(MYSQLI_REPORT_OFF)` pozwala sprawdzać błędy samodzielnie. Dlatego kontrolujemy wyniki operacji.
- `if (!$polaczenie)` sprawdza niepowodzenie połączenia; `!` oznacza zaprzeczenie. Podobnie sprawdzamy zapytanie.
- `exit("komunikat")` wyświetla komunikat i kończy program. Sprawdzenia są przed HTML, więc błąd nie zostawia otwartej tabeli.
- `mysqli_set_charset(..., "utf8mb4")` ustawia kodowanie komunikacji z bazą. Dokument i plik również używają UTF-8.
- `mysqli_close()` zamyka połączenie, także przed zakończeniem programu po błędzie zapytania.

Konto `root` bez hasła stosujemy **wyłącznie na lokalnym stanowisku XAMPP**.

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
// ZAPYTANIE
$zapytanie = "SELECT nick, punkty FROM turysci ORDER BY idTurysta;";
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
    <title>Turyści</title>
</head>
<body>
<h1>Turyści i punkty</h1>
<?php
// WIDOK - początek
echo "<table>";
echo "<tr><th>Turysta</th><th>Punkty</th></tr>";
while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
    $nick = htmlspecialchars($rekord["nick"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    echo "<tr><td>" . $nick . "</td><td>" . (int)$rekord["punkty"] . "</td></tr>";
}
echo "</table>";
// WIDOK - koniec
mysqli_close($polaczenie);
?>
</body>
</html>
```

Uruchom stronę przez localhost. Powinieneś zobaczyć 13 wierszy danych. Kod czytamy od góry: połączenie => zapytanie => dokument HTML => pętla tworząca wiersze => zamknięcie połączenia. W źródle strony otrzymanym przez przeglądarkę są znaczniki HTML, a nie instrukcje PHP.

### 7. Cztery ćwiczenia podstawowe

Ćwiczenie 1 wykonaj osobno. W ćwiczeniach 2-4 korzystaj z jednej kopii programu z kroku 6. Nie przepisuj połączenia ani obsługi błędów.

#### Ćwiczenie 1 - akapit

Napisz PHP, który wyświetli akapit „Moja wyprawa”.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Użyj `echo`, a tekst otocz znacznikami `p`.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>


```php
<?php
echo "<p>Moja wyprawa</p>";
?>
```


</details>

#### Ćwiczenie 2 - lista

W programie z kroku 6 zastąp cały blok WIDOK listą nicków i punktów. Zostaw zapytanie bez zmian.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Otwórz `ul` przed pętlą. Jedno `li` powstaje wewnątrz pętli.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

Wstaw zamiast zawartości bloku WIDOK:
```php
echo "<ul>";
while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
    $nick = htmlspecialchars($rekord["nick"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    echo "<li>" . $nick . " - " . (int)$rekord["punkty"] . "</li>";
}
echo "</ul>";
```

Wynik: 13 elementów, od Ewa - 23 do Adam - 11.

</details>

#### Ćwiczenie 3 - tabela

Przerób listę z ćwiczenia 2 na tabelę z kolumnami Turysta i Punkty. Zmień tylko blok WIDOK.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 3</summary>

Zastąp `ul` przez `table`. Przed pętlą dodaj nagłówki, a w pętli twórz `tr` z dwiema komórkami.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 3</summary>

Wstaw zamiast zawartości bloku WIDOK:
```php
echo "<table>";
echo "<tr><th>Turysta</th><th>Punkty</th></tr>";
while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
    $nick = htmlspecialchars($rekord["nick"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    echo "<tr><td>" . $nick . "</td><td>" . (int)$rekord["punkty"] . "</td></tr>";
}
echo "</table>";
```

Wynik: jeden nagłówek i 13 wierszy danych. Każdy rekord tworzy jeden wiersz.

</details>

#### Ćwiczenie 4 - ranking

Zachowaj tabelę. Zmień tylko linię ZAPYTANIE, aby sortować malejąco po punktach, a przy remisie rosnąco po idTurysta.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 4</summary>

Użyj `ORDER BY punkty DESC, idTurysta`. Pętla nie odpowiada za sortowanie.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 4</summary>


```php
$zapytanie = "SELECT nick, punkty FROM turysci ORDER BY punkty DESC, idTurysta;";
```

Początek wyniku: Ela - 51, Tomek - 46, Grzesiek - 45.

</details>

## Część B - rozszerzenie i utrwalenie

Najpierw samodzielnie wykonaj część A. Poniższe fragmenty rozwijają ten sam program; nie trzeba pisać od nowa obsługi połączenia.

### 8. Dlaczego htmlspecialchars()?

Tekst z bazy może zawierać znaki `<`, `>` lub `&`. Nie chcemy, aby przeglądarka uznała je za kod HTML.

```php
<?php
$tekst = "Szlak <północ> & jezioro";
echo htmlspecialchars($tekst, ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
?>
```

W odpowiedzi powstaje `Szlak &lt;północ&gt; &amp; jezioro`, a czytelnik widzi `Szlak <północ> & jezioro`. `ENT_QUOTES` obejmuje oba rodzaje cudzysłowów. `ENT_SUBSTITUTE` zastępuje niepoprawne sekwencje kodowania znakiem zastępczym. `|` łączy opcje.

Kodujemy wartość z rekordu, nie cały tekst z `tr` i `td`, bo znaczniki tabeli mają działać. Gdy wartość nie jest tekstem, można przed kodowaniem użyć `(string)`. W podstawowym programie nick jest tekstem, a punkty wyświetlamy po zamianie na liczbę całkowitą.

`htmlspecialchars()` przygotowuje tekst do HTML. **Nie zabezpiecza zapytań SQL przed SQL Injection.** W tej lekcji zapytania są stałe i nie zawierają danych od użytkownika.

### 9. Jedno kodowanie w trzech miejscach

Zapisz plik w UTF-8, pozostaw `<meta charset="UTF-8">` i ustaw połączenie przez `mysqli_set_charset($polaczenie, "utf8mb4")`. To zapewnia zgodne przesyłanie i interpretowanie znaków. Gdy polskie lub islandzkie litery są niepoprawne, sprawdź wszystkie trzy miejsca.

### 10. Pusty wynik to nie błąd zapytania

Poprawny SELECT może zwrócić zero rekordów. Podstawowy program pokaże wtedy same nagłówki tabeli. Aby dodać komunikat, wstaw poniższy fragment **przed blokiem WIDOK**, wewnątrz PHP:

```php
if (mysqli_num_rows($wynik) == 0) {
    echo "<p>Brak danych do wyświetlenia.</p>";
}
```

`mysqli_num_rows()` liczy rekordy poprawnego wyniku. `== 0` porównuje liczbę z zerem. Możesz sprawdzić tę sytuację zapytaniem `SELECT nick, punkty FROM turysci WHERE 1 = 0 ORDER BY idTurysta;`. Nie zmienia ono bazy. Potem przywróć poprzednie zapytanie.

### 11. Połączenie, zapytanie i odczyt - różne problemy

| Sytuacja | Co sprawdzić |
| --- | --- |
| Błąd połączenia | Czy MariaDB działa i czy nazwa bazy oraz dane logowania są poprawne? |
| Błąd zapytania | Czy SQL ma poprawną składnię i prawdziwe nazwy tabel oraz kolumn? |
| Pusty wynik | Czy warunek WHERE nie wykluczył wszystkich rekordów? |
| Pusta strona po błędzie PHP | Sprawdź log PHP/Apache w XAMPP, numer linii, średniki i cudzysłowy. |

Program wyjściowy kończy pracę po nieudanym połączeniu lub zapytaniu, więc nie przekazuje błędnego wyniku do pętli. `MYSQLI_REPORT_OFF` nie zwalnia z tych kontroli.

Rozszerzone sprawdzenie odczytu wstaw **po zamknięciu tabeli, przed mysqli_close()**:

```php
if ($rekord === false) {
    echo "<p>Nie udało się odczytać wszystkich rekordów.</p>";
}
```

`===` sprawdza wartość i typ. Odróżnia `false` (błąd odczytu) od `null` (koniec rekordów). Nie dodawaj tej kontroli zamiast sprawdzenia zapytania - dotyczy innego etapu. To gotowe rozszerzenie, nie warunek wykonania podstawowych ćwiczeń.

### 12. Trzy ćwiczenia dodatkowe

Każde rozpocznij od podstawowego programu z kroku 6. Zmieniaj tylko wskazane miejsca.

#### Ćwiczenie 5 - obiekty Islandii

Zmień ZAPYTANIE i WIDOK: pokaż listę nazw obiektów, których panstwo to Islandia, według idObiekt.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 5</summary>

Pobierz `nazwa` z `obiekty`. W pętli czytaj klucz `nazwa` zamiast `nick`; nie wyświetlaj punktów.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 5</summary>

Linia ZAPYTANIE:
```php
$zapytanie = "SELECT nazwa FROM obiekty WHERE panstwo = 'Islandia' ORDER BY idObiekt;";
```
Cały blok WIDOK:
```php
echo "<ul>";
while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
    $nazwa = htmlspecialchars($rekord["nazwa"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    echo "<li>" . $nazwa . "</li>";
}
echo "</ul>";
```

Wynik: 9 obiektów, od Strokkur do Dettifoss. Dopasuj też tytuł dokumentu i h1 do obiektów.

</details>

#### Ćwiczenie 6 - co najmniej 20 punktów

W podstawowym programie tabeli zmień tylko ZAPYTANIE. Pokaż turystów z co najmniej 20 punktami, według idTurysta.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 6</summary>

Warunek `WHERE punkty >= 20` umieść przed `ORDER BY`.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 6</summary>


```php
$zapytanie = "SELECT nick, punkty FROM turysci WHERE punkty >= 20 ORDER BY idTurysta;";
```

Wynik: 7 turystów - Ewa, Paula, Ela, Piotrek, Tomek, Grzesiek, Ola.

</details>

#### Ćwiczenie 7 - obiekt i rodzaj

Zmień ZAPYTANIE i WIDOK. Pokaż tabelę nazw obiektów Islandii oraz nazw ich rodzajów. Połącz tabele obiekty i rodzaje po idRodzaj, sortuj po idObiekt.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 7</summary>

Pobierz `obiekty.nazwa` i `rodzaje.rodzaj`. Połączenie to `obiekty.idRodzaj = rodzaje.idRodzaj`. W PHP czytaj klucze `nazwa` oraz `rodzaj`.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 7</summary>

Linia ZAPYTANIE:
```php
$zapytanie = "SELECT obiekty.nazwa, rodzaje.rodzaj
FROM obiekty JOIN rodzaje ON obiekty.idRodzaj = rodzaje.idRodzaj
WHERE obiekty.panstwo = 'Islandia' ORDER BY obiekty.idObiekt;";
```
Cały blok WIDOK:
```php
echo "<table><tr><th>Obiekt</th><th>Rodzaj</th></tr>";
while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
    $nazwa = htmlspecialchars($rekord["nazwa"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    $rodzaj = htmlspecialchars($rekord["rodzaj"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    echo "<tr><td>" . $nazwa . "</td><td>" . $rodzaj . "</td></tr>";
}
echo "</table>";
```

Wynik: 9 wierszy. Początek: Strokkur - gorące źródło, Skogafoss - wodospad. Dopasuj tytuł dokumentu i h1 do obiektów.

</details>

### 13. Podsumowanie i pomoc

Jeden rekord trafia do `$rekord`. Jedno wykonanie ciała `while` tworzy jeden element listy lub jeden wiersz tabeli. HTML otaczający wszystkie rekordy powstaje poza pętlą.

Jeżeli pętla nie działa, sprawdź przypisanie `=` i pobieranie rekordu w warunku. Nie stawiaj średnika między warunkiem `while` a klamrą. Wyświetlaj pojedyncze pola, a nie całą tablicę przez `echo`. Domykaj `td`, `tr` i `table`.

Powtórka: [lekcja 1]({{ '/01-podstawy-php/01-podstawy-php.html' | relative_url }}), [lekcja 2]({{ '/02-php-i-mariadb/01-odczyt-danych.html' | relative_url }}) i [lekcja 4]({{ '/03-zapytania-inf03/02-wyniki-zapytan-w-php.html' | relative_url }}).

Dokumentacja: [mysqli_fetch_array()](https://www.php.net/manual/en/mysqli-result.fetch-array.php) oraz [htmlspecialchars()](https://www.php.net/manual/en/function.htmlspecialchars.php).
