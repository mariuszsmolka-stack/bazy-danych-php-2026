---
title: Lekcja 8 - PHP i dynamiczne generowanie HTML z danych MariaDB
---

# Lekcja 8 - PHP i dynamiczne generowanie HTML z danych MariaDB

Potrafisz zobaczyć rekord przez `print_r()`. Teraz zbudujesz dla czytelnika stronę: **tabelę turystów z bazy Islandia wraz z liczbą zdobytych punktów**. Najpierw zobaczysz, z czego składa się tabela, potem zastąpisz ręczne wpisywanie danych pętlą.

`MariaDB => PHP => HTML => przeglądarka`

MariaDB przechowuje dane. PHP działa na serwerze: pobiera rekordy i składa z nich HTML. Przeglądarka otrzymuje gotowy HTML i pokazuje stronę. Nie wykonuje kodu PHP.

Przydadzą się [lekcja 1 - podstawy PHP]({{ '/01-podstawy-php/01-podstawy-php.html' | relative_url }}), [lekcja 2 - odczyt danych]({{ '/02-php-i-mariadb/01-odczyt-danych.html' | relative_url }}) i [lekcja 4 - zapytania w PHP]({{ '/03-zapytania-inf03/02-wyniki-zapytan-w-php.html' | relative_url }}).

## 1. Najpierw zwykła tabela HTML

Poniższe trzy wiersze są **fikcyjnymi danymi demonstracyjnymi**, a nie wynikiem zapytania do bazy Islandia.

```html
<table>
    <tr><th>Turysta</th><th>Punkty</th></tr>
    <tr><td>Turysta A</td><td>10</td></tr>
    <tr><td>Turysta B</td><td>20</td></tr>
    <tr><td>Turysta C</td><td>30</td></tr>
</table>
```

`<table>` otacza całą tabelę. `<tr>` wyznacza jeden wiersz, `<th>` komórkę nagłówka, a `<td>` zwykłą komórkę danych. Znacznik z ukośnikiem zamyka element. Wiersz zawiera komórki, a tabela zawiera wiersze.

Przeglądarka układa zawartość tak:

| Turysta | Punkty |
| --- | --- |
| Turysta A | 10 |
| Turysta B | 20 |
| Turysta C | 30 |

Obramowanie zależy od stylów strony. W naszych lokalnych przykładach nie dodajemy CSS, więc tabela może nie mieć widocznych linii. Nadal ma wiersze i kolumny.

## 2. PHP tworzy HTML

**Kod źródłowy PHP:**

```php
<?php
echo "<p>Witaj na stronie turystów</p>";
?>
```

PHP wykonuje `echo`, czyli wysyła podany tekst do odpowiedzi. Cudzysłowy i średnik są składnią PHP i nie trafiają do strony.

**HTML otrzymany przez przeglądarkę:**

```html
<p>Witaj na stronie turystów</p>
```

Czytelnik widzi akapit „Witaj na stronie turystów”, a nie znaczniki. HTML nie musi być zapisany na stałe w pliku: PHP może go utworzyć podczas każdego żądania strony.

### Uruchomienie w XAMPP

1. Włącz Apache oraz usługę bazy danych w panelu XAMPP. Przygotuj bazę `Islandia` z kursowego pliku `baza/baza1.sql`.
2. Utwórz katalog `C:\xampp\htdocs\kurs-php`.
3. Zapisz kod w UTF-8 w pliku `C:\xampp\htdocs\kurs-php\turysci.php`.
4. Otwórz `http://localhost/kurs-php/turysci.php`.

Otwarcie pliku przez `file://` nie uruchamia PHP na serwerze. GitHub Pages pokazuje tę lekcję i bloki kodu, ale nie wykonuje PHP. Każdy kompletny program poniżej kopiuj osobno do pliku `turysci.php`.

## 3. Pobierz dane w ustalonej kolejności

```sql
SELECT nick, punkty
FROM turysci
ORDER BY idTurysta;
```

Kolumny `nick`, `punkty` i `idTurysta` należą do tabeli `turysci`. Sortujemy po identyfikatorze, chociaż nie wyświetlamy go w wyniku. Bez `ORDER BY` kolejność rekordów nie jest gwarantowana.

Znany schemat to `mysqli_connect() => mysqli_query() => odczyt rekordów => mysqli_close()`. `mysqli_query()` zwraca dla poprawnego `SELECT` obiekt wyniku, a nie gotową tabelę HTML. Dopiero odczytamy z niego rekordy.

W niezmienionej bazie jest 13 turystów. Początek wyniku:

| nick | punkty |
| --- | --- |
| Ewa | 23 |
| Monika | 4 |
| Janek | 12 |

## 4. while - pobieraj, dopóki są rekordy

`for` nadaje się do powtarzania czynności z licznikiem, a `foreach` przechodzi przez elementy tablicy. Tutaj pytamy wynik SQL o kolejny rekord, dopóki taki rekord istnieje.

Poniższy fragment działa **po udanym zapytaniu**, gdy `$wynik` zawiera jego wynik:

```php
while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
    // Przetwarzanie kolejnego rekordu
}
```

Czytaj warunek od prawej strony:

1. `mysqli_fetch_array()` pobiera kolejny rekord z `$wynik`.
2. `MYSQLI_ASSOC` oznacza tablicę z nazwami kolumn, np. `$rekord["nick"]`.
3. `=` przypisuje pobraną wartość do `$rekord`.
4. PHP ocenia przypisaną wartość jako warunek. Tablica rekordu jest niepusta, więc wykonuje ciało pętli.
5. Wraca do warunku i ponownie pobiera rekord.

`=` to **przypisanie**, a `==` to **porównanie wartości**. Zastąpienie przypisania przez porównanie nie zapisze nowego rekordu w zmiennej.

Wynik pamięta miejsce odczytu. Wywołania przesuwają to miejsce, zamiast stale wracać do pierwszego wiersza:

| Wywołanie | Wartość pobrana z wyniku | Działanie |
| --- | --- | --- |
| 1 | Ewa, 23 | Wykonaj ciało pętli |
| 2 | Monika, 4 | Wykonaj ciało pętli |
| 3 | Janek, 12 | Wykonaj ciało pętli |
| ... | Kolejni turyści | Powtarzaj |
| 13 | Adam, 11 | Wykonaj ciało pętli |
| 14 | `null` | Zakończ pętlę |

Na końcu danych funkcja zwraca `null`; w razie błędu może zwrócić `false`. Obie wartości zatrzymują tę pętlę. Dla pustego wyniku ciało nie wykona się ani razu. W programach sprawdzamy pusty wynik wcześniej, żeby pokazać czytelny komunikat.

### Instrukcje potrzebne w pełnym programie

- `mysqli_report(MYSQLI_REPORT_OFF)` wyłącza automatyczne raportowanie błędów MySQLi, w tym wyjątki. Dlatego samodzielnie sprawdzamy wyniki połączenia, ustawienia kodowania i zapytania.
- `if (!$polaczenie)` znaczy: jeśli połączenie się nie udało. `!` oznacza zaprzeczenie. Podobnie sprawdzamy `$wynik`.
- `mysqli_set_charset($polaczenie, "utf8mb4")` ustawia kodowanie komunikacji z bazą.
- `mysqli_num_rows($wynik)` podaje liczbę rekordów. Wywołujemy ją tylko po udanym zapytaniu.
- `elseif` pozwala sprawdzić kolejny przypadek, gdy poprzedni warunek nie zachodzi.
- `htmlspecialchars()` przygotowuje tekst do HTML. Już użyjemy jej dla danych z bazy; szczegółowy przykład znajdziesz w sekcji 7.
- `(string)` zamienia wartość na tekst, a kropka `.` łączy teksty.
- `$rekord === false` sprawdza dokładnie wartość `false`, odróżniając błąd od zwykłego końca danych (`null`). `===` porównuje zarówno wartość, jak i typ.

Konto `root` bez hasła w przykładach służy wyłącznie do lokalnego stanowiska XAMPP. Nie jest wzorcem konta dla publicznego serwera.

## 5. Pierwsza dynamiczna lista

Lista `<ul>` zawiera elementy `<li>`. Każdy rekord utworzy jeden element z nickiem i punktami. Oto cały program:

```php
<!doctype html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dane z bazy Islandia</title>
</head>
<body>
<h1>Dane z bazy Islandia</h1>
<?php
mysqli_report(MYSQLI_REPORT_OFF);
$polaczenie = mysqli_connect("localhost", "root", "", "Islandia");
if (!$polaczenie) {
    echo "<p>Nie udało się połączyć z bazą.</p>";
} else {
    if (!mysqli_set_charset($polaczenie, "utf8mb4")) {
        echo "<p>Nie udało się ustawić kodowania.</p>";
    } else {
        $zapytanie = "SELECT nick, punkty FROM turysci ORDER BY idTurysta;";
        $wynik = mysqli_query($polaczenie, $zapytanie);
        if (!$wynik) {
            echo "<p>Nie udało się wykonać zapytania.</p>";
        } elseif (mysqli_num_rows($wynik) == 0) {
            echo "<p>Brak danych do wyświetlenia.</p>";
        } else {
            echo "<ul>";
            while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
                echo "<li>";
                echo htmlspecialchars((string)$rekord["nick"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
                echo " - ";
                echo htmlspecialchars((string)$rekord["punkty"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
                echo "</li>";
            }
            echo "</ul>";
            if ($rekord === false) {
                echo "<p>Nie udało się odczytać wszystkich rekordów.</p>";
            }
        }
    }
    mysqli_close($polaczenie);
}
?>
</body>
</html>
```

Połączenie otwiera `mysqli_connect()`, a zapytanie wykonuje `mysqli_query()`. `while` odczytuje rekordy. `echo "<ul>"` rozpoczyna listę tylko raz, natomiast instrukcje wewnątrz pętli tworzą po jednym `<li>` dla każdego turysty. Po pętli zamykamy listę, a na końcu połączenie.

Początek listy będzie wyglądał tak:

- Ewa - 23
- Monika - 4
- Janek - 12

To początek rzeczywistego wyniku; cały program pokaże 13 elementów.

## 6. Z listy do tabeli

Zmieniamy opakowanie danych. Początek tabeli i nagłówki są poza pętlą. W pętli tworzymy jeden `<tr>` z dwiema komórkami `<td>`. Zamknięcie tabeli znów znajduje się poza pętlą.

Kompletny program do uruchomienia:

```php
<!doctype html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dane z bazy Islandia</title>
</head>
<body>
<h1>Dane z bazy Islandia</h1>
<?php
mysqli_report(MYSQLI_REPORT_OFF);
$polaczenie = mysqli_connect("localhost", "root", "", "Islandia");
if (!$polaczenie) {
    echo "<p>Nie udało się połączyć z bazą.</p>";
} else {
    if (!mysqli_set_charset($polaczenie, "utf8mb4")) {
        echo "<p>Nie udało się ustawić kodowania.</p>";
    } else {
        $zapytanie = "SELECT nick, punkty FROM turysci ORDER BY idTurysta;";
        $wynik = mysqli_query($polaczenie, $zapytanie);
        if (!$wynik) {
            echo "<p>Nie udało się wykonać zapytania.</p>";
        } elseif (mysqli_num_rows($wynik) == 0) {
            echo "<p>Brak danych do wyświetlenia.</p>";
        } else {
            echo "<table><tr><th>Turysta</th><th>Punkty</th></tr>";
            while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
                echo "<tr>";
                echo "<td>" . htmlspecialchars((string)$rekord["nick"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8") . "</td>";
                echo "<td>" . htmlspecialchars((string)$rekord["punkty"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8") . "</td>";
                echo "</tr>";
            }
            echo "</table>";
            if ($rekord === false) {
                echo "<p>Nie udało się odczytać wszystkich rekordów.</p>";
            }
        }
    }
    mysqli_close($polaczenie);
}
?>
</body>
</html>
```

Dla Ewy powstanie ten fragment HTML:

```html
<tr><td>Ewa</td><td>23</td></tr>
```

Pętla wykona ten sam zestaw instrukcji dla pozostałych rekordów. Nie potrzebujesz 13 ręcznie zapisanych wierszy ani `print_r()`.

## 7. Tekst powinien pozostać tekstem

Wyobraź sobie napis `Szlak <północ> & jezioro`. Wstawiony bezpośrednio do HTML może zostać błędnie potraktowany jako znaczniki lub zapis encji. Chcemy pokazać napis, a nie interpretować go jako kod.

```php
<?php
$tekst = "Szlak <północ> & jezioro";
echo "<p>" . htmlspecialchars($tekst, ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8") . "</p>";
?>
```

Wygenerowany HTML:

```html
<p>Szlak &lt;północ&gt; &amp; jezioro</p>
```

Przeglądarka pokaże dokładnie: `Szlak <północ> & jezioro`. `htmlspecialchars()` zamienia znaki specjalne na zapis bezpieczny w tekście HTML. `ENT_QUOTES` obejmuje oba rodzaje cudzysłowów, a `ENT_SUBSTITUTE` zastępuje niepoprawne sekwencje kodowania znakiem zastępczym. Operator `|` łączy te dwie opcje.

W naszych programach `(string)` zapewnia tekstowy argument również dla punktów. Przekazujemy do funkcji **wartość z rekordu**, nie cały wiersz `<tr>...</tr>`, bo chcemy zachować działające znaczniki tabeli.

Spójne kodowanie ma trzy miejsca: zapis pliku w UTF-8, `<meta charset="UTF-8">` w dokumencie i `utf8mb4` w połączeniu z MariaDB. Dzięki temu poprawnie wyświetlają się polskie i islandzkie znaki.

`htmlspecialchars()` przygotowuje tekst do wyświetlenia w HTML. **Nie zabezpiecza zapytań SQL przed SQL Injection.** Tutaj wykonujemy stałe zapytania bez danych pochodzących od użytkownika.

## 8. Pełna strona - sprawdź każdą drogę wykonania

Program tabeli z sekcji 6 jest już kompletnym dokumentem HTML z osadzonym PHP. Część poza `<?php ... ?>` trafia do odpowiedzi bez wykonywania przez PHP, a część wewnątrz generuje dane i znaczniki przez `echo`. Zapisz cały program, od `<!doctype html>` do `</html>`, w `turysci.php`.

| Sytuacja | Co robi program |
| --- | --- |
| Nie można nawiązać połączenia | Pokazuje komunikat; nie próbuje wykonać zapytania |
| Nie ustawiono kodowania | Pokazuje komunikat; nie pobiera tekstu w nieustalonym kodowaniu |
| Zapytanie zwraca `false` | Pokazuje błąd; nie przekazuje `false` do funkcji odczytu |
| Poprawne zapytanie bez rekordów | Pokazuje „Brak danych do wyświetlenia” |
| Są rekordy | Tworzy nagłówki i po jednym wierszu na rekord |
| Odczyt rekordu zwraca `false` | Zamyka tabelę i sygnalizuje niepełny odczyt |

`mysqli_close()` znajduje się wewnątrz gałęzi udanego połączenia, ale poza warunkami dotyczącymi zapytania. Zamyka więc otwarte połączenie także po błędzie zapytania lub przy pustym wyniku. Znaczniki kończące dokument pozostają poza PHP i są wysyłane w każdym przypadku.

Uruchom stronę przez localhost. W źródle odpowiedzi przeglądarki zobaczysz HTML, bez instrukcji `mysqli_query()` i `while`. Dla ćwiczenia pustego wyniku możesz tymczasowo zastąpić warunek zapytania przez `WHERE 1 = 0` przed `ORDER BY`. To nie zmienia danych w bazie. Następnie przywróć zapytanie podstawowe.

## 9. Ćwiczenia

Pracuj na niezmienionej bazie z kursowego pliku. Każde rozwiązanie uruchamiaj osobno. Najpierw napisz własny kod; podpowiedzi i pełne programy są domyślnie zwinięte.

### Ćwiczenie 1 - Trzy elementy HTML

Wygeneruj przez PHP nagłówek h1 i dwa akapity. Nie korzystaj z bazy.

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie 1</summary>

```php
<!doctype html>
<html lang="pl">
<head><meta charset="UTF-8"><title>Pierwsze elementy</title></head>
<body>
<?php
echo "<h1>Turyści</h1>";
echo "<p>Poznajemy Islandię.</p>";
echo "<p>Zbieramy punkty.</p>";
?>
</body>
</html>
```

Wynik: nagłówek i dwa akapity.

</details>

### Ćwiczenie 2 - Lista turystów

Pokaż wszystkich turystów jako listę HTML: nick i punkty, według idTurysta.

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie 2</summary>

```php
<!doctype html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dane z bazy Islandia</title>
</head>
<body>
<h1>Dane z bazy Islandia</h1>
<?php
mysqli_report(MYSQLI_REPORT_OFF);
$polaczenie = mysqli_connect("localhost", "root", "", "Islandia");
if (!$polaczenie) {
    echo "<p>Nie udało się połączyć z bazą.</p>";
} else {
    if (!mysqli_set_charset($polaczenie, "utf8mb4")) {
        echo "<p>Nie udało się ustawić kodowania.</p>";
    } else {
        $zapytanie = "SELECT nick, punkty FROM turysci ORDER BY idTurysta;";
        $wynik = mysqli_query($polaczenie, $zapytanie);
        if (!$wynik) {
            echo "<p>Nie udało się wykonać zapytania.</p>";
        } elseif (mysqli_num_rows($wynik) == 0) {
            echo "<p>Brak danych do wyświetlenia.</p>";
        } else {
            echo "<ul>";
            while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
                echo "<li>";
                echo htmlspecialchars((string)$rekord["nick"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
                echo " - ";
                echo htmlspecialchars((string)$rekord["punkty"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
                echo "</li>";
            }
            echo "</ul>";
            if ($rekord === false) {
                echo "<p>Nie udało się odczytać wszystkich rekordów.</p>";
            }
        }
    }
    mysqli_close($polaczenie);
}
?>
</body>
</html>
```

Wynik: 13 elementów; pierwszy Ewa - 23, ostatni Adam - 11.

</details>

### Ćwiczenie 3 - Tabela turystów

Pokaż nick i punkty w tabeli z nagłówkami Turysta i Punkty, według idTurysta.

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie 3</summary>

```php
<!doctype html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dane z bazy Islandia</title>
</head>
<body>
<h1>Dane z bazy Islandia</h1>
<?php
mysqli_report(MYSQLI_REPORT_OFF);
$polaczenie = mysqli_connect("localhost", "root", "", "Islandia");
if (!$polaczenie) {
    echo "<p>Nie udało się połączyć z bazą.</p>";
} else {
    if (!mysqli_set_charset($polaczenie, "utf8mb4")) {
        echo "<p>Nie udało się ustawić kodowania.</p>";
    } else {
        $zapytanie = "SELECT nick, punkty FROM turysci ORDER BY idTurysta;";
        $wynik = mysqli_query($polaczenie, $zapytanie);
        if (!$wynik) {
            echo "<p>Nie udało się wykonać zapytania.</p>";
        } elseif (mysqli_num_rows($wynik) == 0) {
            echo "<p>Brak danych do wyświetlenia.</p>";
        } else {
            echo "<table><tr><th>Turysta</th><th>Punkty</th></tr>";
            while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
                echo "<tr>";
                echo "<td>" . htmlspecialchars((string)$rekord["nick"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8") . "</td>";
                echo "<td>" . htmlspecialchars((string)$rekord["punkty"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8") . "</td>";
                echo "</tr>";
            }
            echo "</table>";
            if ($rekord === false) {
                echo "<p>Nie udało się odczytać wszystkich rekordów.</p>";
            }
        }
    }
    mysqli_close($polaczenie);
}
?>
</body>
</html>
```

Wynik: 13 wierszy danych i jeden wiersz nagłówkowy.

</details>

### Ćwiczenie 4 - Ranking punktów

Pokaż tabelę turystów malejąco według punktów. Przy remisie sortuj rosnąco po idTurysta.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź 1 - ćwiczenie 4</summary>

Sortowanie zmienia zapytanie, a nie pętlę PHP.

</details>

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź 2 - ćwiczenie 4</summary>

Po ORDER BY podaj punkty DESC, a po przecinku idTurysta.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie 4</summary>

```php
<!doctype html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dane z bazy Islandia</title>
</head>
<body>
<h1>Dane z bazy Islandia</h1>
<?php
mysqli_report(MYSQLI_REPORT_OFF);
$polaczenie = mysqli_connect("localhost", "root", "", "Islandia");
if (!$polaczenie) {
    echo "<p>Nie udało się połączyć z bazą.</p>";
} else {
    if (!mysqli_set_charset($polaczenie, "utf8mb4")) {
        echo "<p>Nie udało się ustawić kodowania.</p>";
    } else {
        $zapytanie = "SELECT nick, punkty FROM turysci ORDER BY punkty DESC, idTurysta;";
        $wynik = mysqli_query($polaczenie, $zapytanie);
        if (!$wynik) {
            echo "<p>Nie udało się wykonać zapytania.</p>";
        } elseif (mysqli_num_rows($wynik) == 0) {
            echo "<p>Brak danych do wyświetlenia.</p>";
        } else {
            echo "<table><tr><th>Turysta</th><th>Punkty</th></tr>";
            while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
                echo "<tr>";
                echo "<td>" . htmlspecialchars((string)$rekord["nick"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8") . "</td>";
                echo "<td>" . htmlspecialchars((string)$rekord["punkty"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8") . "</td>";
                echo "</tr>";
            }
            echo "</table>";
            if ($rekord === false) {
                echo "<p>Nie udało się odczytać wszystkich rekordów.</p>";
            }
        }
    }
    mysqli_close($polaczenie);
}
?>
</body>
</html>
```

Wynik: 13 wierszy. Początek: Ela - 51, Tomek - 46, Grzesiek - 45.

</details>

### Ćwiczenie 5 - Co najmniej 20 punktów

Pokaż tabelę turystów mających co najmniej 20 punktów, według idTurysta.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź 1 - ćwiczenie 5</summary>

Filtruj rekordy przez WHERE przed sortowaniem.

</details>

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź 2 - ćwiczenie 5</summary>

Co najmniej oznacza >=. Warunek to punkty >= 20.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie 5</summary>

```php
<!doctype html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dane z bazy Islandia</title>
</head>
<body>
<h1>Dane z bazy Islandia</h1>
<?php
mysqli_report(MYSQLI_REPORT_OFF);
$polaczenie = mysqli_connect("localhost", "root", "", "Islandia");
if (!$polaczenie) {
    echo "<p>Nie udało się połączyć z bazą.</p>";
} else {
    if (!mysqli_set_charset($polaczenie, "utf8mb4")) {
        echo "<p>Nie udało się ustawić kodowania.</p>";
    } else {
        $zapytanie = "SELECT nick, punkty FROM turysci WHERE punkty >= 20 ORDER BY idTurysta;";
        $wynik = mysqli_query($polaczenie, $zapytanie);
        if (!$wynik) {
            echo "<p>Nie udało się wykonać zapytania.</p>";
        } elseif (mysqli_num_rows($wynik) == 0) {
            echo "<p>Brak danych do wyświetlenia.</p>";
        } else {
            echo "<table><tr><th>Turysta</th><th>Punkty</th></tr>";
            while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
                echo "<tr>";
                echo "<td>" . htmlspecialchars((string)$rekord["nick"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8") . "</td>";
                echo "<td>" . htmlspecialchars((string)$rekord["punkty"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8") . "</td>";
                echo "</tr>";
            }
            echo "</table>";
            if ($rekord === false) {
                echo "<p>Nie udało się odczytać wszystkich rekordów.</p>";
            }
        }
    }
    mysqli_close($polaczenie);
}
?>
</body>
</html>
```

Wynik: 7 wierszy: Ewa, Paula, Ela, Piotrek, Tomek, Grzesiek, Ola.

</details>

### Ćwiczenie 6 - Obiekty na Islandii

Pokaż listę nazw obiektów, których panstwo ma wartość Islandia. Sortuj po idObiekt.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź 1 - ćwiczenie 6</summary>

Tabela obiekty ma kolumny nazwa i panstwo.

</details>

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź 2 - ćwiczenie 6</summary>

Użyj WHERE panstwo = 'Islandia'. W PHP odczytuj klucz nazwa.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie 6</summary>

```php
<!doctype html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dane z bazy Islandia</title>
</head>
<body>
<h1>Dane z bazy Islandia</h1>
<?php
mysqli_report(MYSQLI_REPORT_OFF);
$polaczenie = mysqli_connect("localhost", "root", "", "Islandia");
if (!$polaczenie) {
    echo "<p>Nie udało się połączyć z bazą.</p>";
} else {
    if (!mysqli_set_charset($polaczenie, "utf8mb4")) {
        echo "<p>Nie udało się ustawić kodowania.</p>";
    } else {
        $zapytanie = "SELECT nazwa FROM obiekty WHERE panstwo = 'Islandia' ORDER BY idObiekt;";
        $wynik = mysqli_query($polaczenie, $zapytanie);
        if (!$wynik) {
            echo "<p>Nie udało się wykonać zapytania.</p>";
        } elseif (mysqli_num_rows($wynik) == 0) {
            echo "<p>Brak danych do wyświetlenia.</p>";
        } else {
            echo "<ul>";
            while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
                echo "<li>";
                echo htmlspecialchars((string)$rekord["nazwa"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
                echo "</li>";
            }
            echo "</ul>";
            if ($rekord === false) {
                echo "<p>Nie udało się odczytać wszystkich rekordów.</p>";
            }
        }
    }
    mysqli_close($polaczenie);
}
?>
</body>
</html>
```

Wynik: 9 elementów; pierwszy Strokkur, ostatni Dettifoss.

</details>

### Ćwiczenie 7 - Obiekt i rodzaj

Pokaż tabelę nazw obiektów na Islandii i ich rodzajów. Połącz obiekty z rodzaje po idRodzaj. Sortuj po identyfikatorze obiektu.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź 1 - ćwiczenie 7</summary>

Potrzebujesz nazwy z obiekty i rodzaju z rodzaje.

</details>

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź 2 - ćwiczenie 7</summary>

Połącz obiekty.idRodzaj = rodzaje.idRodzaj. PHP odczytuje klucze nazwa i rodzaj.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie 7</summary>

```php
<!doctype html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dane z bazy Islandia</title>
</head>
<body>
<h1>Dane z bazy Islandia</h1>
<?php
mysqli_report(MYSQLI_REPORT_OFF);
$polaczenie = mysqli_connect("localhost", "root", "", "Islandia");
if (!$polaczenie) {
    echo "<p>Nie udało się połączyć z bazą.</p>";
} else {
    if (!mysqli_set_charset($polaczenie, "utf8mb4")) {
        echo "<p>Nie udało się ustawić kodowania.</p>";
    } else {
        $zapytanie = "SELECT obiekty.nazwa, rodzaje.rodzaj FROM obiekty JOIN rodzaje ON obiekty.idRodzaj = rodzaje.idRodzaj WHERE obiekty.panstwo = 'Islandia' ORDER BY obiekty.idObiekt;";
        $wynik = mysqli_query($polaczenie, $zapytanie);
        if (!$wynik) {
            echo "<p>Nie udało się wykonać zapytania.</p>";
        } elseif (mysqli_num_rows($wynik) == 0) {
            echo "<p>Brak danych do wyświetlenia.</p>";
        } else {
            echo "<table><tr><th>Obiekt</th><th>Rodzaj</th></tr>";
            while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
                echo "<tr>";
                echo "<td>" . htmlspecialchars((string)$rekord["nazwa"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8") . "</td>";
                echo "<td>" . htmlspecialchars((string)$rekord["rodzaj"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8") . "</td>";
                echo "</tr>";
            }
            echo "</table>";
            if ($rekord === false) {
                echo "<p>Nie udało się odczytać wszystkich rekordów.</p>";
            }
        }
    }
    mysqli_close($polaczenie);
}
?>
</body>
</html>
```

Wynik: 9 wierszy; Strokkur - gorące źródło, Skogafoss - wodospad. Każda komórka zawiera pojedynczą wartość rekordu.

</details>

## 10. Typowe błędy

| Problem | Przyczyna i poprawka |
| --- | --- |
| Pusta strona po błędzie PHP | Sprawdź log błędów Apache/PHP w XAMPP. Odczytaj numer linii i popraw błąd składni; sama biała strona nie oznacza pustego wyniku SQL. |
| Brak średnika | Zakończ instrukcję, np. `echo "<p>Tekst</p>";`. Błąd bywa wskazany w następnej linii. |
| Cudzysłowy wewnątrz echo | Niezabezpieczony cudzysłów kończy tekst. Możesz użyć `echo '<p title="Opis">Tekst</p>';`. |
| echo całej tablicy | `$rekord` jest tablicą. Wybierz pole, np. `$rekord["nick"]`, i przygotuj jego wartość przez `htmlspecialchars()`. |
| Nieprawidłowy fetch | Przekazuj wynik udanego SELECT, nie połączenie ani tekst SQL. Użyj `MYSQLI_ASSOC` dla kluczy z nazwami kolumn. |
| while nie pobiera kolejnych rekordów | Pobieraj rekord w warunku pętli. Samo sprawdzanie starej zmiennej nie przesuwa odczytu. |
| == zamiast = w warunku pobierania | Porównanie nie zapisuje nowego rekordu. Przywróć przypisanie ze wzorca w sekcji 4. |
| Średnik bezpośrednio po while | Tworzy puste ciało pętli. Usuń go i umieść generowanie wiersza wewnątrz klamer. |
| Niepoprawna tabela | Zamykaj td, tr i table. Początek oraz koniec tabeli umieść poza pętlą, a cały wiersz danych wewnątrz. |
| Zepsute polskie znaki | Sprawdź zapis pliku UTF-8, meta charset oraz udane mysqli_set_charset z utf8mb4. |
| Brak danych | Odróżnij nieudane zapytanie od poprawnego wyniku z zerem rekordów. Sprawdź warunek WHERE i pokaż komunikat zamiast pustej tabeli. |

## 11. Co już potrafisz?

Potrafisz wyjaśnić drogę `MariaDB => PHP => HTML => przeglądarka`, odróżnić źródło PHP od odpowiedzi HTML oraz użyć `while` do pobierania kolejnych rekordów. Tworzysz listę i tabelę, bezpiecznie wyświetlasz wartości przez `htmlspecialchars()` i rozpoznajesz błędy połączenia, zapytania oraz pusty wynik.

Sprawdź własne rozumienie: dlaczego otwarcie tabeli jest przed pętlą, a otwarcie wiersza w pętli? Co zobaczysz, gdy zapytanie nie zwróci żadnego turysty? Dlaczego przeglądarka nie potrzebuje dostępu do bazy, żeby pokazać otrzymaną tabelę?

Dokumentacja: [mysqli_fetch_array()](https://www.php.net/manual/en/mysqli-result.fetch-array.php) oraz [htmlspecialchars()](https://www.php.net/manual/en/function.htmlspecialchars.php).
