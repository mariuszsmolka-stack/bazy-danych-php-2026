---
title: Lekcja 8C - PHP i MariaDB. Tabela danych z bazy
---

# Lekcja 8C - PHP i MariaDB. Tabela danych z bazy

W [lekcji 8B]({{ '/05-php-i-html/01b-php-lista-z-bazy.html' | relative_url }}) wyświetlaliśmy nicki turystów w liście. Teraz chcemy pokazać obok nicka także punkty. Każdy rekord stanie się jednym wierszem tabeli.

Mechanizm pozostaje ten sam: `SELECT` pobiera dane, `mysqli_query()` wykonuje zapytanie, `mysqli_fetch_array()` odczytuje kolejny rekord, `while` powtarza odczyt, a `echo` tworzy wynik.

Pracujemy z bazą `Islandia` z pliku `baza/baza1.sql`. Przed uruchomieniem PHP włącz Apache i MariaDB w XAMPP oraz zaimportuj bazę.

## 1. Pobierz dwie kolumny

W lekcji 8B pobieraliśmy tylko `nick`. Teraz w phpMyAdmin wykonaj:

```sql
SELECT nick, punkty
FROM turysci
ORDER BY idTurysta;
```

Zapytanie zwraca 13 rekordów. Każdy zawiera nick i liczbę punktów. Początek wyniku wygląda tak:

| Turysta | Punkty |
| --- | ---: |
| Ewa | 23 |
| Monika | 4 |
| Janek | 12 |

Ostatni rekord to **Adam - 11**. `ORDER BY idTurysta` ustala kolejność rekordów.

## 2. Jeden rekord to jeden wiersz

Dla Ewy chcemy utworzyć taki fragment:

```html
<tr>
    <td>Ewa</td>
    <td>23</td>
</tr>
```

`tr` oznacza wiersz, a dwa `td` - jego komórki. Całą tabelę otacza `table`. Nagłówki kolumn tworzymy przez `th`.

Za chwilę PHP utworzy podobny wiersz dla każdego turysty. Nie musimy wpisywać wierszy ręcznie.

## 3. Zastąp element listy wierszem

W lekcji 8B pętla tworzyła element listy:

```php
echo "<li>" . $nick . "</li>";
```

Teraz odczytujemy dwie wartości z bieżącego rekordu:

```php
$nick = htmlspecialchars(
    $rekord["nick"],
    ENT_QUOTES | ENT_SUBSTITUTE,
    "UTF-8"
);

$punkty = (int)$rekord["punkty"];

echo "<tr><td>" . $nick .
     "</td><td>" . $punkty .
     "</td></tr>";
```

Nick trafia do pierwszej komórki, punkty do drugiej. `htmlspecialchars()` przygotowuje tekst nicka do wyświetlenia w HTML. Nie musisz teraz zapamiętywać jego opcji. Punkty są liczbą całkowitą, dlatego używamy `(int)`.

Jedno wykonanie tej instrukcji `echo` tworzy jeden wiersz z danymi. Dla pierwszego rekordu powstaje wiersz z Ewą i 23 punktami.

## 4. Utwórz jedną tabelę

Otwórz tabelę i wypisz nagłówki przed pętlą. W pętli dodawaj wiersze. Po pętli zamknij tabelę:

```php
echo "<table>";
echo "<tr><th>Turysta</th><th>Punkty</th></tr>";

while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
    $nick = htmlspecialchars(
        $rekord["nick"],
        ENT_QUOTES | ENT_SUBSTITUTE,
        "UTF-8"
    );

    $punkty = (int)$rekord["punkty"];

    echo "<tr><td>" . $nick .
         "</td><td>" . $punkty .
         "</td></tr>";
}

echo "</table>";
```

Przed pętlą powstaje jedna tabela i jeden wiersz nagłówków. Każdy pobrany rekord dodaje jeden wiersz danych. Po odczytaniu ostatniego rekordu zamykamy tabelę.

Nagłówek nie jest rekordem z bazy. Dlaczego nie otwieramy nowej tabeli przy każdym wykonaniu pętli? Chcemy jedną tabelę z 13 wierszami danych, a nie 13 osobnych tabel.

## 5. Uruchom cały program

Zapisz poniższy kod w UTF-8 jako `C:\xampp\htdocs\kurs-php\tabela_turystow.php`. Otwórz `http://localhost/kurs-php/tabela_turystow.php`.

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
    <title>Turyści i punkty</title>
</head>
<body>
    <h1>Turyści i punkty</h1>
    <?php
    echo "<table>";
    echo "<tr><th>Turysta</th><th>Punkty</th></tr>";

    while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
        $nick = htmlspecialchars(
            $rekord["nick"],
            ENT_QUOTES | ENT_SUBSTITUTE,
            "UTF-8"
        );

        $punkty = (int)$rekord["punkty"];

        echo "<tr><td>" . $nick .
             "</td><td>" . $punkty .
             "</td></tr>";
    }

    echo "</table>";
    mysqli_close($polaczenie);
    ?>
</body>
</html>
```

Konto `root` bez hasła stosuj tylko na lokalnym stanowisku XAMPP, jeśli jest tak skonfigurowane. Program sprawdza połączenie, kodowanie i wykonanie zapytania przed utworzeniem tabeli.

W przeglądarce zobaczysz jedną tabelę. Ma dwa nagłówki i 13 wierszy danych. Pierwszy wiersz danych to **Ewa - 23**, a ostatni to **Adam - 11**.

## 6. Ćwiczenia

W obu ćwiczeniach zacznij od programu z kroku 5. Zmieniaj tylko zapytanie SQL. Kod pętli i tabeli zostaw bez zmian.

### Ćwiczenie 1 - ranking turystów

Pokaż turystów od największej do najmniejszej liczby punktów. Przy tej samej liczbie punktów zachowaj kolejność według `idTurysta`. Sprawdź, kto pojawia się na początku tabeli.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Posortuj wyniki przez `ORDER BY punkty DESC, idTurysta`.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

W pełnym programie zastąp tylko przypisanie do `$zapytanie`:

```php
$zapytanie = "SELECT nick, punkty FROM turysci ORDER BY punkty DESC, idTurysta;";
```

Tabela nadal ma 13 wierszy danych. Na początku są **Ela - 51**, **Tomek - 46** i **Grzesiek - 45**. Kolejność zmieniło zapytanie, nie pętla.

</details>

### Ćwiczenie 2 - wybierz rekordy

Przywróć kolejność według `idTurysta`. Pokaż tylko turystów, którzy mają co najmniej 20 punktów. Sprawdź liczbę wierszy danych.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Dodaj `WHERE punkty >= 20` przed `ORDER BY idTurysta`.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

W pełnym programie zastąp tylko przypisanie do `$zapytanie`:

```php
$zapytanie = "SELECT nick, punkty FROM turysci WHERE punkty >= 20 ORDER BY idTurysta;";
```

Tabela ma 7 wierszy danych. Nagłówki **Turysta** i **Punkty** pozostają takie same. SQL wybiera rekordy, a pętla wyświetla każdy z nich.

</details>

## 7. Sprawdź, czy rozumiesz

- Dlaczego `table` otwieramy przed `while`?
- Dlaczego `tr` z danymi tworzymy w pętli?
- Co oznaczają `$rekord["nick"]` i `$rekord["punkty"]`?
- Ile wierszy danych powstanie, jeśli `SELECT` zwróci trzy rekordy?
- Czy zmiana `ORDER BY` wymaga zmiany pętli?

**Jeden rekord => jedno wykonanie pętli => jeden wiersz tabeli.**
