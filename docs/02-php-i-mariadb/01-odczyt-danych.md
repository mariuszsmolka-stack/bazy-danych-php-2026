---
title: PHP i odczytywanie danych z bazy Islandia
mermaid: true
---

# Lekcja 2 - PHP i odczytywanie danych z bazy Islandia

## Informacje o lekcji

- Temat: połączenie PHP z MariaDB, zapytanie `SELECT` i pobieranie rekordów.
- Środowisko: XAMPP, phpMyAdmin, Visual Studio Code, terminal PowerShell.
- Baza: `Islandia`, zaimportowana z pliku `baza1.sql`.
- Tabela używana w ćwiczeniach: `turysci`.
- Wymagania wstępne: zmienne, `if`, tablice indeksowane i asocjacyjne, `print_r()`, `array_slice()` oraz podstawy SQL.
- Zakres: odczyt danych. Nie dodajemy, nie zmieniamy i nie usuwamy rekordów.
- Przygotowanie do INF.03: stosujemy proceduralne funkcje MySQLi spotykane w materiałach egzaminacyjnych. Składnię funkcji sprawdzamy w udostępnionej dokumentacji lub w tabeli dołączonej do arkusza, jeśli taka tabela się w nim znajduje.

## 1. Cel lekcji

Po lekcji potrafisz:

- sprawdzić zawartość tabeli za pomocą phpMyAdmin;
- połączyć skrypt PHP z bazą `Islandia`;
- wykonać zapytanie `SELECT` za pomocą `mysqli_query()`;
- pobrać jeden rekord za pomocą `mysqli_fetch_row()`;
- pobrać wszystkie pozostałe rekordy za pomocą `mysqli_fetch_all()`;
- odróżnić `MYSQLI_NUM`, `MYSQLI_ASSOC` i `MYSQLI_BOTH`;
- sprawdzić dane przez `print_r()` i `var_dump()`;
- wyświetlić fragment pobranej tablicy za pomocą `array_slice()`;
- wyjaśnić, czym różni się `array_slice()` od `LIMIT`.

Na tej lekcji **nie korzystamy jeszcze z formularzy HTML** ani z bardziej złożonych zapytań.

## 2. Przygotowanie środowiska

1. Uruchom w XAMPP usługę `MySQL` (jest to serwer MariaDB).
2. Jeśli używasz phpMyAdmin, uruchom również `Apache`.
3. Otwórz `http://localhost/phpmyadmin`.
4. Wybierz bazę `Islandia`, a następnie tabelę `turysci`.
5. Otwórz w VS Code dotychczasowy katalog projektu, np. `C:\xampp\htdocs\kurs-php`.

Programy PHP uruchamiane w terminalu nie wymagają uruchomionego Apache. Do połączenia z bazą serwer MariaDB musi działać.

W tabeli `turysci` są trzy kolumny:

| Kolumna | Znaczenie |
| --- | --- |
| `idTurysta` | Identyfikator turysty |
| `nick` | Nick turysty |
| `punkty` | Liczba zdobytych punktów |

W oryginalnym zrzucie `baza1.sql` tabela zawiera 13 rekordów. Trzy pierwsze po uporządkowaniu według `idTurysta` to:

| idTurysta | nick | punkty |
| ---: | --- | ---: |
| 1 | Ewa | 23 |
| 2 | Monika | 4 |
| 3 | Janek | 12 |

Wyniki przykładowe w dalszej części odnoszą się do tych danych. Jeśli baza została zmieniona, wyniki mogą się różnić.

## 3. Pierwszy SELECT w phpMyAdmin

W zakładce SQL wykonaj:

```sql
SELECT * FROM turysci;
```

- `SELECT` - wybierz dane.
- `*` - wybierz wszystkie kolumny.
- `FROM turysci` - pobierz je z tabeli `turysci`.

To samo możemy zapisać z wymienieniem nazw kolumn:

```sql
SELECT idTurysta, nick, punkty
FROM turysci;
```

W naszej tabeli oba zapytania wybierają te same kolumny, ponieważ są w niej tylko trzy pola. W większych tabelach wypisanie konkretnych kolumn pozwala określić dokładnie, co ma zostać pobrane.

### 3.1. Co oznacza WHERE 1?

phpMyAdmin może pokazywać zapytanie:

```sql
SELECT * FROM turysci WHERE 1;
```

`WHERE 1` jest warunkiem zawsze prawdziwym. Nie usuwa żadnego wiersza z wyniku. Dlatego:

```sql
SELECT * FROM turysci;
```

oraz:

```sql
SELECT * FROM turysci WHERE 1;
```

zwracają te same rekordy.

Taki zapis bywa używany przez narzędzia, które automatycznie dodają kolejne warunki:

```sql
SELECT * FROM turysci
WHERE 1 AND punkty > 20;
```

W zapytaniu pisanym samodzielnie wystarczy `WHERE punkty > 20`.

### 3.2. Dlaczego w przykładach dodajemy ORDER BY?

```sql
SELECT * FROM turysci ORDER BY idTurysta;
```

`ORDER BY idTurysta` porządkuje wynik według identyfikatora. Dzięki temu możemy przewidzieć, że pierwszy będzie rekord Ewy, a drugi Moniki. Bez `ORDER BY` SQL nie gwarantuje kolejności rekordów.

## 4. Nawiązanie połączenia - mysqli_connect()

W VS Code utwórz plik `polaczenie.php`:

```php
<?php
// Ustawienie używane tutaj do prostego sprawdzania błędów za pomocą if
mysqli_report(MYSQLI_REPORT_OFF);

$polaczenie = mysqli_connect("localhost", "root", "", "Islandia");

if ($polaczenie) {
    echo "Połączenie z bazą działa.\n";
    mysqli_close($polaczenie);
} else {
    echo "Błąd połączenia: " . mysqli_connect_error() . "\n";
}
```

Składnia połączenia:

```php
mysqli_connect("adres_serwera", "uzytkownik", "haslo", "nazwa_bazy");
```

- `localhost` - serwer na tym samym komputerze.
- `root` - przykładowa nazwa użytkownika z domyślnej lokalnej instalacji XAMPP.
- `""` - puste hasło, **tylko jeśli tak skonfigurowano lokalny XAMPP**.
- `Islandia` - dokładna nazwa bazy używanej w ćwiczeniach.

Nie należy używać konta `root` bez hasła w aplikacji udostępnianej w sieci. To ustawienie występuje w niektórych lokalnych instalacjach szkolnych; w innym środowisku wpisujemy dane właściwego użytkownika.

`mysqli_report(MYSQLI_REPORT_OFF)` wyłącza automatyczne zgłaszanie wyjątków MySQLi. Ułatwia to początkującym wykonanie prostego testu `if ($polaczenie)`. Od PHP 8.1 domyślnie włączony jest tryb zgłaszania wyjątków, dlatego bez tej linii błędne połączenie może zakończyć działanie programu wyjątkiem.

Uruchom w terminalu PowerShell:

```powershell
C:\xampp\php\php.exe polaczenie.php
```

Wynik poprawnego połączenia:

```text
Połączenie z bazą działa.
```

`mysqli_close($polaczenie)` zamyka połączenie. Przed zamknięciem połączenia wykonujemy zapytania i pobieramy potrzebne dane.

## 5. Wykonanie zapytania - mysqli_query()

Połączenie to dopiero pierwszy krok. Aby pobrać dane, wysyłamy zapytanie SQL:

```php
$sql = "SELECT * FROM turysci ORDER BY idTurysta";
$wynik = mysqli_query($polaczenie, $sql);
```

`mysqli_query()` przyjmuje:

- pierwszy argument - połączenie z bazą;
- drugi argument - treść zapytania SQL.

Dla zapytania `SELECT` poprawne wykonanie zwraca obiekt `mysqli_result`.

Ważne: **`$wynik` nie jest jeszcze zwykłą tablicą turystów**. Zawiera wynik zapytania, z którego dopiero pobierzemy rekordy.

Możemy sprawdzić, czy zapytanie się wykonało:

```php
if ($wynik) {
    echo "Zapytanie wykonano poprawnie.\n";
}
```

W tym miejscu nadal nie wyświetlamy pól turystów.

## 6. Pobranie jednego rekordu - mysqli_fetch_row()

Poniższy przykład jest kompletnym programem. Zapisz go np. jako `jeden_turysta.php`:

```php
<?php
mysqli_report(MYSQLI_REPORT_OFF);

$polaczenie = mysqli_connect("localhost", "root", "", "Islandia");

if (!$polaczenie) {
    echo "Błąd połączenia.\n";
    exit;
}

$sql = "SELECT * FROM turysci ORDER BY idTurysta";
$wynik = mysqli_query($polaczenie, $sql);

if (!$wynik) {
    echo "Błąd zapytania.\n";
    mysqli_close($polaczenie);
    exit;
}

$turysta = mysqli_fetch_row($wynik);
print_r($turysta);

mysqli_close($polaczenie);
```

`mysqli_fetch_row($wynik)` pobiera **jeden kolejny rekord** jako tablicę indeksowaną.

Początek oczekiwanego wyniku:

```text
Array
(
    [0] => 1
    [1] => Ewa
    [2] => 23
)
```

- `$turysta[0]` - `idTurysta`.
- `$turysta[1]` - `nick`.
- `$turysta[2]` - `punkty`.

Jeśli wykonamy funkcję ponownie:

```php
$turysta2 = mysqli_fetch_row($wynik);
print_r($turysta2);
```

otrzymamy następny rekord, czyli Monikę. Po wyczerpaniu wierszy funkcja zwraca `null`.

## 7. Pobranie pozostałych rekordów - mysqli_fetch_all()

W osobnym programie albo po ponownym wykonaniu zapytania możemy napisać:

```php
$turysci = mysqli_fetch_all($wynik);
print_r($turysci);
```

`mysqli_fetch_all()` pobiera **wszystkie pozostałe rekordy** do jednej tablicy. Każdy rekord jest kolejną tablicą, więc otrzymujemy tablicę dwuwymiarową.

Początek wyniku:

```text
Array
(
    [0] => Array
        (
            [0] => 1
            [1] => Ewa
            [2] => 23
        )

    [1] => Array
        (
            [0] => 2
            [1] => Monika
            [2] => 4
        )
)
```

W przykładzie pokazano początek wyniku; przy pełnym zapytaniu rekordów jest więcej.

**Ważna pułapka:** jeżeli najpierw pobraliśmy Ewę przez `mysqli_fetch_row($wynik)`, późniejsze `mysqli_fetch_all($wynik)` zacznie od następnego rekordu. Nie otrzymamy ponownie Ewy. Jeśli chcemy zacząć pobieranie od początku w prostych ćwiczeniach, wykonujemy nowe zapytanie `mysqli_query()`.

## 8. Drugi parametr mysqli_fetch_all()

Pełny zapis:

```php
mysqli_fetch_all($wynik, TRYB);
```

Drugi parametr określa rodzaj tablic zwracanych przez funkcję.

| Tryb | Jakie klucze otrzymamy? | Przykład odczytu nicku Ewy |
| --- | --- | --- |
| `MYSQLI_NUM` | Liczbowe | `$turysci[0][1]` |
| `MYSQLI_ASSOC` | Nazwy kolumn | `$turysci[0]["nick"]` |
| `MYSQLI_BOTH` | Liczbowe i nazwy kolumn | Oba zapisy działają |

### 8.1. MYSQLI_NUM

```php
$turysci = mysqli_fetch_all($wynik, MYSQLI_NUM);
echo $turysci[0][1] . "\n";
```

- Pierwsze `[0]` - pierwszy rekord.
- Drugie `[1]` - druga kolumna, czyli `nick`.

To jest tryb **domyślny** funkcji `mysqli_fetch_all()`. Nie trzeba go wpisywać jawnie.

### 8.2. MYSQLI_ASSOC

```php
$turysci = mysqli_fetch_all($wynik, MYSQLI_ASSOC);
echo $turysci[0]["nick"] . "\n";
```

W tablicy asocjacyjnej nazwy kluczy odpowiadają nazwom kolumn w wyniku zapytania.

- `$turysci[0]` - pierwszy rekord.
- `["nick"]` - wartość z kolumny `nick`.

Ten zapis jest czytelny i zwykle wygodny w pracy z rekordami.

### 8.3. MYSQLI_BOTH

```php
$turysci = mysqli_fetch_all($wynik, MYSQLI_BOTH);

echo $turysci[0][1] . "\n";
echo $turysci[0]["nick"] . "\n";
```

Oba polecenia wypiszą `Ewa`. To dwa sposoby dostępu do tej samej wartości, nie dwa rekordy.

**Uwaga egzaminacyjna:** `mysqli_fetch_all()` domyślnie używa `MYSQLI_NUM`, natomiast `mysqli_fetch_array()` domyślnie używa `MYSQLI_BOTH`. Nie należy mylić tych funkcji.

## 9. Diagnostyka danych

Sprawdzamy zawartość pobranej tablicy:

```php
print_r($turysci);
```

Jeśli potrzebujemy także typów danych PHP:

```php
var_dump($turysci);
```

Aby wyświetlić jedną konkretną wartość:

```php
echo $turysci[0]["nick"] . "\n";
```

Pamiętaj:

- `MYSQLI_ASSOC` określa postać pobranych rekordów.
- `print_r()` pokazuje zawartość tablicy.
- `var_dump()` pokazuje również typy danych.
- `echo` służy tutaj do wyświetlania wybranych wartości.

## 10. Ograniczanie danych - array_slice()

Funkcję `array_slice()` znamy z poprzedniej lekcji. Możemy jej użyć także do tablicy rekordów pobranych z MariaDB.

```php
$turysci = mysqli_fetch_all($wynik, MYSQLI_ASSOC);
$pierwsi = array_slice($turysci, 0, 3);

print_r($pierwsi);
```

Znaczenie argumentów:

- `$turysci` - tablica źródłowa;
- `0` - początek fragmentu;
- `3` - liczba pobieranych elementów.

Wynik zawiera trzy pierwsze rekordy. `array_slice()` **nie modyfikuje** tablicy `$turysci`. Zwraca nową tablicę z wybranym fragmentem.

Jeśli rekordy pobrano wcześniej przez `mysqli_fetch_all()`, to nadal zostały one wcześniej pobrane z bazy do PHP. `array_slice()` ogranicza tylko fragment tej tablicy.

### 10.1. A czym jest LIMIT?

W SQL możemy napisać:

```sql
SELECT * FROM turysci
ORDER BY idTurysta
LIMIT 3;
```

Teraz sam wynik zapytania zawiera najwyżej trzy wiersze.

Prosty schemat:

```text
SELECT bez LIMIT => pobranie rekordów do PHP => array_slice() => fragment tablicy

SELECT z LIMIT => baza zwraca najwyżej 3 rekordy => pobranie wyniku do PHP
```

| Narzędzie | Gdzie działa? | Co ogranicza? |
| --- | --- | --- |
| `array_slice()` | W PHP | Fragment istniejącej tablicy |
| `LIMIT` | W SQL | Liczbę wierszy wyniku zapytania |

Nie rozwijamy jeszcze stronicowania ani innych wariantów `LIMIT`. Na dziś wystarczy rozumieć tę różnicę.

## 11. Schemat pracy z bazą

<figure class="lesson-diagram">
<pre class="mermaid-source" hidden>
flowchart TD
    A["mysqli_connect()"] --> B["mysqli_query()"]
    B --> C["Pobranie rekordów"]
    C --> D["Użycie danych"]
    D --> E["mysqli_close()"]
</pre>
<p class="diagram-fallback">mysqli_connect() =&gt; mysqli_query() =&gt; pobranie rekordów =&gt; użycie danych =&gt; mysqli_close()</p>
<figcaption>Kolejność pracy przy poprawnym połączeniu i zapytaniu SELECT. Rekordy pobieramy przez mysqli_fetch_row() lub mysqli_fetch_all().</figcaption>
</figure>

- Możemy wykonać kilka zapytań w ramach jednego połączenia.
- Dla `SELECT` najpierw wykonujemy zapytanie, później pobieramy rekordy.
- `mysqli_fetch_row()` pobiera jeden kolejny rekord.
- `mysqli_fetch_all()` pobiera wszystkie pozostałe rekordy.
- Na koniec można jawnie zamknąć połączenie.

## 12. Ćwiczenia dla uczniów

Pracuj na bazie `Islandia` i tabeli `turysci`. W każdym ćwiczeniu, w którym odczytujesz pierwsze rekordy, użyj w SQL `ORDER BY idTurysta`.

Nie zmieniaj danych w bazie. Każde zadanie zapisz w oddzielnym pliku `.php` lub wykonuj po kolei w jednym pliku, pamiętając o ponownym wykonaniu zapytania przed nowym odczytem wyników.

### Ćwiczenie 1 - Sprawdzenie połączenia

- Utwórz plik `cw01_polaczenie.php`.
- Połącz się z bazą `Islandia`.
- Sprawdź wynik połączenia za pomocą `if`.
- Jeśli połączenie działa, wyświetl `Połączenie poprawne`.
- Zamknij połączenie.

**Sprawdź:** czy komunikat pojawia się tylko przy poprawnym połączeniu?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź</summary>

Wróć do przykładu `polaczenie.php`. Wynik `mysqli_connect()` zapisz w zmiennej i sprawdź przed zamknięciem połączenia. W tym ćwiczeniu zachowaj ustawienie `mysqli_report()` z przykładu.

</details>

### Ćwiczenie 2 - SQL i gwiazdka

W phpMyAdmin wykonaj trzy zapytania:

```sql
SELECT * FROM turysci;
```

```sql
SELECT * FROM turysci WHERE 1;
```

```sql
SELECT nick, punkty FROM turysci;
```

Wyjaśnij własnymi słowami:

- Dlaczego pierwsze dwa zapytania zwracają ten sam zestaw rekordów?
- Czego brakuje w wyniku trzeciego zapytania?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź</summary>

Porównaj osobno liczbę wierszy i nazwy kolumn wyników. Zastanów się, czy warunek `WHERE 1` może odrzucić którykolwiek wiersz.

</details>

### Ćwiczenie 3 - Pierwszy i drugi turysta

- Nawiąż połączenie i wykonaj `SELECT * FROM turysci ORDER BY idTurysta`.
- Użyj dwa razy `mysqli_fetch_row()`.
- Wyświetl obie pobrane tablice przez `print_r()`.
- Wyświetl przy użyciu `echo` tylko nick drugiego turysty.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź</summary>

Oba odczyty wykonaj na tym samym `$wynik`, bez ponawiania zapytania między nimi. Numer kolumny z nickiem odczytaj ze schematu wyniku w sekcji 6.

</details>

<details class="lesson-hint" markdown="1">
<summary>Sprawdź wynik</summary>

**Oczekiwany nick:** `Monika`.

</details>

### Ćwiczenie 4 - Tryby pobierania

- Wykonaj zapytanie pobierające turystów uporządkowanych według identyfikatora.
- Pobierz rekordy przez `mysqli_fetch_all($wynik, MYSQLI_ASSOC)`.
- Wyświetl strukturę danych przez `print_r()`.
- Wypisz przez `echo` nick i punkty pierwszego turysty, odwołując się do nazw kolumn.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź</summary>

Najpierw wybierz pierwszy element zewnętrznej tablicy. Potem odczytaj z niego pola przez nazwy kolumn, nie ich numery.

</details>

<details class="lesson-hint" markdown="1">
<summary>Sprawdź wynik</summary>

**Oczekiwany wynik:** `Ewa - 23`.

</details>

### Ćwiczenie 5 - Trzy pierwsze rekordy

- Pobierz wszystkie rekordy jako `MYSQLI_ASSOC`.
- Użyj `array_slice()` do wybrania pierwszych trzech rekordów.
- Za pomocą `foreach` wypisz same nicki tych trzech turystów.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź</summary>

Elementem tablicy `$pierwsi` jest kolejna tablica asocjacyjna. W pętli `foreach` odwołaj się do klucza `nick` bieżącego rekordu.

</details>

<details class="lesson-hint" markdown="1">
<summary>Sprawdź wynik</summary>

**Oczekiwany wynik:**

```text
Ewa
Monika
Janek
```

</details>

### Ćwiczenie 6 - Liczba rekordów

- Pobierz wszystkie rekordy do `$turysci`.
- Wyświetl przez `count()` liczbę elementów tablicy.
- Zapisz fragment trzech rekordów do `$pierwsi`.
- Wyświetl przez `count()` liczbę elementów tablicy `$pierwsi`.



Wyjaśnij, dlaczego użycie `array_slice()` nie zmieniło liczby elementów tablicy `$turysci`.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź</summary>

Wywołaj `count()` osobno dla obu zmiennych. Sprawdź, do której zmiennej przypisano wynik `array_slice()`.

</details>

<details class="lesson-hint" markdown="1">
<summary>Sprawdź wynik</summary>

**Dla niezmienionej bazy:** liczby `13` oraz `3`.

</details>

### Ćwiczenie 7 - LIMIT a array_slice()

- W phpMyAdmin uruchom `SELECT * FROM turysci ORDER BY idTurysta LIMIT 3;`.
- Sprawdź, ile wierszy zwróciło zapytanie.
- W PHP porównaj ten wynik z pierwszymi trzema rekordami wybranymi przez `array_slice()` z pełnej tablicy.
- Napisz jedno zdanie wyjaśniające, która metoda ogranicza wynik już w bazie danych.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź</summary>

Rozdziel dwa etapy: wykonanie zapytania w MariaDB i pracę na gotowej tablicy w PHP. W którym z nich działa każda z porównywanych metod?

</details>

### Ćwiczenie 8 - Zrozumienie kolejnych odczytów

- Wykonaj zapytanie `SELECT * FROM turysci ORDER BY idTurysta`.
- Pobierz pierwszy rekord przez `mysqli_fetch_row()`.
- Następnie pobierz pozostałe przez `mysqli_fetch_all($wynik, MYSQLI_ASSOC)`.
- Sprawdź przez `count()`, ile rekordów znalazło się w tablicy `$pozostali`.
- Wyjaśnij, dlaczego nie ma tam Ewy.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź</summary>

Pierwszy odczyt przesuwa pozycję w wyniku zapytania. Przed `mysqli_fetch_all()` nie wykonuj nowego zapytania. Porównaj liczbę pozostałych rekordów z liczbą wszystkich turystów.

</details>

<details class="lesson-hint" markdown="1">
<summary>Sprawdź wynik</summary>

**Dla niezmienionej bazy:** tablica `$pozostali` ma `12` rekordów.

</details>

## 13. Pytania sprawdzające

1. Co zawiera zmienna zwrócona przez `mysqli_query()` dla poprawnego zapytania `SELECT`?
2. Czym różni się wynik `mysqli_fetch_row()` od wyniku `mysqli_fetch_all()`?
3. Co oznaczają dwa indeksy w zapisie `$turysci[0][1]`?
4. Kiedy użyjemy `$turysci[0]["nick"]`?
5. Jaki jest domyślny tryb `mysqli_fetch_all()`?
6. Czy `print_r($wynik)` pokaże nam automatycznie zawartość wszystkich rekordów?
7. Dlaczego `array_slice()` nie oznacza, że pobraliśmy mniej danych z bazy?
8. Po co w ćwiczeniach stosujemy `ORDER BY idTurysta`?

## 14. Podsumowanie

Na tej lekcji poznaliśmy pełną drogę od zapytania SQL do wartości wyświetlonej w PHP:

```text
Połączenie => zapytanie SELECT => wynik MySQLi => tablica PHP => wyświetlenie danych
```

Najważniejsze do zapamiętania:

- `mysqli_connect()` - nawiązuje połączenie;
- `mysqli_query()` - wykonuje zapytanie SQL;
- `mysqli_fetch_row()` - pobiera jeden kolejny wiersz jako tablicę indeksowaną;
- `mysqli_fetch_all()` - pobiera wszystkie pozostałe wiersze do tablicy;
- `MYSQLI_ASSOC` - pozwala odwoływać się do pól według nazw kolumn;
- `print_r()` i `var_dump()` - służą do sprawdzania danych;
- `array_slice()` - wybiera fragment tablicy już pobranej do PHP;
- `LIMIT` - ogranicza liczbę wierszy wyniku zapytania SQL;
- `mysqli_close()` - zamyka połączenie.

**Na kolejnej lekcji** będziemy dalej pracować na bazie `Islandia`, korzystając z poznanych funkcji. Nowe operacje wprowadzimy dopiero po utrwaleniu dzisiejszych przykładów.

## 15. Materiały odniesienia

- [PHP Manual - `mysqli_fetch_all()`](https://www.php.net/manual/en/mysqli-result.fetch-all.php)
- [PHP Manual - `mysqli_fetch_row()`](https://www.php.net/manual/en/mysqli-result.fetch-row.php)
- [PHP Manual - `mysqli_fetch_array()`](https://www.php.net/manual/en/mysqli-result.fetch-array.php)
- [PHP Manual - `mysqli_report()`](https://www.php.net/manual/en/mysqli-driver.report-mode.php)
- Zrzut bazy do ćwiczeń - [baza1.sql](https://raw.githubusercontent.com/mariuszsmolka-stack/bazy-danych-php-2026/main/baza/baza1.sql). [Instrukcja importu]({{ '/00-organizacja/01-baza-islandia.html' | relative_url }}).
- W zakresie egzaminacyjnym - arkusz CKE INF.03-01-26.06-SG (egzamin praktyczny, czerwiec 2026, portal turystyczny), w tym tabela funkcji `mysqli`. Arkusz jest materiałem odniesienia, a nie autorskim materiałem kursu.
