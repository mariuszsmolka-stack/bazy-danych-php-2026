---
title: Ściąga INF.03 - funkcje PHP do obsługi MariaDB
---

# Ściąga INF.03 - funkcje PHP do obsługi MariaDB

**Źródło:** arkusz praktyczny INF.03-01-26.06-SG, czerwiec 2026, strona 5, tabela 1: "Wybór funkcji języka PHP do obsługi bazy MySQL i MariaDB".

Poniżej zestawiono **dokładnie te funkcje**, które wymieniono w tabeli arkusza. Opisy są krótkie i przeznaczone do szybkiego sprawdzania składni. Nie jest to lista wszystkich funkcji PHP ani gwarancja zawartości przyszłych arkuszy.

## 1. Funkcje wymienione w arkuszu

| Funkcja i argumenty | Do czego służy? |
| --- | --- |
| `mysqli_connect(serwer, użytkownik, hasło, nazwa_bazy)` | Nawiązuje połączenie. Arkusz opisuje wynik jako identyfikator połączenia lub `FALSE`. |
| `mysqli_select_db(id_polaczenia, nazwa_bazy)` | Wybiera bazę na istniejącym połączeniu. Zwraca wynik powodzenia operacji. |
| `mysqli_error(id_polaczenia)` | Zwraca opis błędu ostatniej operacji związanej z połączeniem. |
| `mysqli_close(id_polaczenia)` | Zamyka połączenie z bazą. |
| `mysqli_query(id_polaczenia, zapytanie)` | Wysyła zapytanie SQL do serwera. |
| `mysqli_fetch_row(wynik_zapytania)` | Pobiera kolejny rekord jako tablicę indeksowaną liczbowo. |
| `mysqli_fetch_array(wynik_zapytania)` | Pobiera kolejny rekord jako tablicę. W arkuszu opisano ją jako asocjacyjną. |
| `mysqli_num_rows(wynik_zapytania)` | Zwraca liczbę wierszy wyniku zapytania. |
| `mysqli_num_fields(wynik_zapytania)` | Zwraca liczbę kolumn wyniku zapytania. |
| `isset($zmienna)` | Sprawdza, czy zmienna jest ustawiona i ma wartość różną od `null`. |

## 2. Jak wykorzystać tę tabelę?

Przykład dla lokalnej bazy `Islandia` w XAMPP:

```php
<?php
mysqli_report(MYSQLI_REPORT_OFF);

$polaczenie = mysqli_connect("localhost", "root", "", "Islandia");

if (!$polaczenie) {
    exit("Nie udało się połączyć z bazą.\n");
}

$zapytanie = "SELECT nick, punkty FROM turysci";
$wynik = mysqli_query($polaczenie, $zapytanie);

if ($wynik) {
    echo "Liczba rekordów: " . mysqli_num_rows($wynik) . "\n";
}

mysqli_close($polaczenie);
```

Schemat:

```text
mysqli_connect() => mysqli_query() => odczyt wyniku => mysqli_close()
```

Konto `root` z pustym hasłem jest dopuszczone tu tylko jako przykład lokalnego stanowiska egzaminacyjnego i nie jest wzorcem do publikacji aplikacji w Internecie.

## 3. Ważne uwagi o składni

- W obecnych wersjach PHP poprawne `mysqli_connect()` zwraca obiekt `mysqli`, chociaż tabela w arkuszu używa starszego określenia identyfikatora połączenia.
- `mysqli_fetch_array()` domyślnie umożliwia dostęp do pola zarówno po numerze, jak i po nazwie kolumny (`MYSQLI_BOTH`). Można też wskazać `MYSQLI_ASSOC` lub `MYSQLI_NUM`. Współczesne PHP zwraca `null`, gdy nie ma kolejnego rekordu. W tabeli egzaminacyjnej podano uproszczony opis zakończenia odczytu.
- `isset()` zwraca `false` także dla zmiennej istniejącej, której wartość wynosi `null`.
- Od PHP 8.1 błędy MySQLi mogą domyślnie powodować wyjątki. W prostych przykładach kursu wyłączamy ten tryb przez `mysqli_report(MYSQLI_REPORT_OFF)`, aby ćwiczyć kontrolę wyniku przez `if`.
- Znana z lekcji 2 funkcja `mysqli_fetch_all()` **nie występuje w tabeli tego arkusza**. Jest poprawną funkcją PHP, ale nie należy jej dopisywać do listy udostępnionej w arkuszu.

## 4. Dodatkowa informacja z arkusza - GET

Na stronie 6 arkusza opisano przekazywanie danych w adresie, np. `index.php?lang=pl&param1=2`, i odczyt przez tablicę `$_GET`. Nie jest to jedenasta funkcja tabeli MySQLi.

```php
$jezyk = $_GET["lang"] ?? "pl";
```

Do GET wrócimy na lekcji o formularzach i linkach.

## 5. Materiał odniesienia

- Arkusz: INF.03-01-26.06-SG, zadanie praktyczne, czerwiec 2026, strona 5 (tabela MySQLi) oraz strona 6 (`GET`).
- Kurs: [Lekcja 2 - PHP i MariaDB]({{ '/02-php-i-mariadb/01-odczyt-danych.html' | relative_url }}).
