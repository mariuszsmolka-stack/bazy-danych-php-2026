---
title: Lekcja 8B - PHP i MariaDB. Lista danych z bazy
---

# Lekcja 8B - PHP i MariaDB. Lista danych z bazy

Chcemy wyświetlić listę turystów zapisanych w bazie. Czy musimy wpisać każdy nick osobną instrukcją `echo`? Nie. PHP może pobierać kolejne rekordy i tworzyć listę automatycznie.

Przypomnij sobie [lekcję 8A - tworzenie HTML przez echo]({{ '/05-php-i-html/01a-php-tworzy-html.html' | relative_url }}) oraz [lekcję 2 - odczyt danych z MariaDB]({{ '/02-php-i-mariadb/01-odczyt-danych.html' | relative_url }}). Teraz połączymy te umiejętności.

Pracujemy z bazą `Islandia` z pliku `baza/baza1.sql`. Przed uruchomieniem PHP włącz Apache i MariaDB w XAMPP oraz zaimportuj bazę.

## 1. Sprawdź dane w phpMyAdmin

Wykonaj zapytanie:

```sql
SELECT nick
FROM turysci
ORDER BY idTurysta;
```

Wynik zawiera 13 nicków. Pierwszy to **Ewa**, a ostatni to **Adam**. `SELECT` pobiera tylko kolumnę `nick`. `ORDER BY idTurysta` ustala kolejność.

## 2. Pobierz jeden rekord

`mysqli_query()` wykonuje zapytanie SQL. Jego wynik zapisujemy w zmiennej `$wynik`.

Z takiego wyniku możemy pobrać jeden rekord:

```php
$rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC);
```

`mysqli_fetch_array()` pobiera kolejny rekord. Dzięki `MYSQLI_ASSOC` odczytujemy wartość przez nazwę kolumny:

```php
$rekord["nick"]
```

Dla pierwszego rekordu jest to **Ewa**. Ten pojedynczy odczyt tylko wyjaśnia działanie funkcji. W gotowym programie rekordy będziemy pobierać wewnątrz pętli. Gdybyśmy pobrali Ewę wcześniej, nie trafiłaby do listy.

## 3. Pobieraj rekordy w pętli while

Nie znamy osobnej instrukcji dla każdego turysty. Użyjemy jednej pętli:

```php
while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
    // Tutaj wykorzystamy pobrany rekord.
}
```

`while` pobiera rekord i wykonuje kod w klamrach. Potem próbuje pobrać następny. Gdy rekordy się skończą, pętla się zatrzyma.

`$wynik` oznacza wynik całego zapytania. `$rekord` oznacza jeden aktualnie pobrany wiersz. Kolejne przebiegi dadzą nicki: **Ewa**, **Monika**, **Janek**, dalej pozostałych turystów, a na końcu **Adam**.

## 4. Utwórz listę z rekordów

W lekcji 8A wpisywaliśmy nazwę wprost w instrukcji `echo`. Teraz użyjemy nicka z rekordu:

```php
echo "<ul>";

while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
    $nick = htmlspecialchars(
        $rekord["nick"],
        ENT_QUOTES | ENT_SUBSTITUTE,
        "UTF-8"
    );

    echo "<li>" . $nick . "</li>";
}

echo "</ul>";
```

Najpierw otwieramy listę, tylko raz. Każde wykonanie pętli pobiera jeden rekord i tworzy jeden element `li`. Po ostatnim rekordzie zamykamy listę.

`htmlspecialchars()` przygotowuje nick do bezpiecznego wyświetlenia jako tekst HTML. Opcji w tej funkcji nie musisz teraz zapamiętywać. Zachowaj całą instrukcję, gdy wyświetlasz tekst z bazy.

Początek wyniku w przeglądarce:

- Ewa
- Monika
- Janek

Lista ma 13 elementów i kończy się nickiem **Adam**.

## 5. Uruchom cały program

Zapisz poniższy kod jako `C:\xampp\htdocs\kurs-php\lista_turystow.php`. Plik zapisz w UTF-8. Otwórz `http://localhost/kurs-php/lista_turystow.php`.

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

$zapytanie = "SELECT nick FROM turysci ORDER BY idTurysta;";
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
    <title>Turyści</title>
</head>
<body>
    <h1>Turyści</h1>
    <?php
    echo "<ul>";

    while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
        $nick = htmlspecialchars(
            $rekord["nick"],
            ENT_QUOTES | ENT_SUBSTITUTE,
            "UTF-8"
        );

        echo "<li>" . $nick . "</li>";
    }

    echo "</ul>";
    mysqli_close($polaczenie);
    ?>
</body>
</html>
```

Konto `root` bez hasła stosuj tylko na lokalnym stanowisku XAMPP, jeśli jest tak skonfigurowane. Program sprawdza połączenie i wynik zapytania, zanim zacznie tworzyć listę.

W przeglądarce zobaczysz 13 nicków. Pierwsze trzy to **Ewa**, **Monika**, **Janek**. Ostatni to **Adam**. Jeśli pojawi się komunikat o błędzie, sprawdź, czy MariaDB działa i czy zaimportowano bazę `Islandia`.

## 6. Ćwiczenia

W obu ćwiczeniach zacznij od pełnego programu z kroku 5. Zmieniaj tylko wskazane miejsce.

### Ćwiczenie 1 - wybierz część turystów

Zmień tylko zapytanie SQL. Pokaż nicki turystów, którzy mają co najmniej 20 punktów. Zachowaj kolejność według `idTurysta`.

Zanim uruchomisz program, przewidź liczbę elementów listy. Pętli PHP nie zmieniaj.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Dodaj do zapytania warunek `WHERE punkty >= 20` przed `ORDER BY`.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

W pełnym programie zastąp tylko przypisanie do `$zapytanie`:

```php
$zapytanie = "SELECT nick FROM turysci WHERE punkty >= 20 ORDER BY idTurysta;";
```

Lista ma 7 elementów: Ewa, Paula, Ela, Piotrek, Tomek, Grzesiek i Ola. Zmieniła się liczba rekordów, a pętla pozostała taka sama.

</details>

### Ćwiczenie 2 - zmień tekst elementu

Przywróć zapytanie pobierające wszystkich turystów. Zmień tylko instrukcję `echo` wewnątrz pętli. Zamiast samego nicka pokaż na przykład **Turysta: Ewa**. Tak samo wyświetl pozostałe osoby.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Połącz początek elementu listy, tekst `Turysta: `, zmienną `$nick` i koniec elementu za pomocą kropek.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

W pełnym programie przywróć pierwotne przypisanie do `$zapytanie` i zastąp tylko instrukcję `echo` w pętli:

```php
$zapytanie = "SELECT nick FROM turysci ORDER BY idTurysta;";
```

```php
echo "<li>Turysta: " . $nick . "</li>";
```

Lista nadal ma 13 elementów. Pierwszy to **Turysta: Ewa**, a ostatni to **Turysta: Adam**.

</details>

Dlaczego `echo` otwierające `ul` znajduje się poza pętlą? Każdy rekord ma dodać element do jednej listy.

**Jeden rekord => jedno wykonanie pętli => jeden element listy.** W kolejnej lekcji tę samą zasadę zastosujemy do wierszy tabeli.
