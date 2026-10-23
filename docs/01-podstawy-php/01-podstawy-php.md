---
title: Podstawy PHP i pierwsze tablice
---

# Lekcja 1 - Podstawy PHP i pierwsze tablice

**Temat:** Uruchamianie PHP w XAMPP i Visual Studio Code. Podstawy składni, pętle, tablice indeksowane i asocjacyjne.

**Wymagania wstępne:** Znajomość podstaw Pythona - zmiennych, instrukcji warunkowych, pętli i list.

**Środowisko:** Windows, XAMPP, Visual Studio Code, terminal PowerShell.

**Cel lekcji:** Samodzielnie napisać i uruchomić skrypt PHP, korzystać z tablic oraz rozumieć różnicę między wyświetlaniem wartości a wyświetlaniem całej tablicy.

**Sposób pracy:** Najpierw krótki przykład, później uruchomienie, zmiana kodu i samodzielne ćwiczenie. Na tej lekcji nie łączymy się jeszcze z bazą danych.

**Uwaga do przykładów:** Kompletny plik PHP zaczynamy od `<?php`. Krótsze przykłady bez tego znacznika są fragmentami przeznaczonymi do dopisania w już otwartym bloku PHP.

---

## 1. PHP a Python - co już potrafimy?

W Pythonie poznaliśmy już zmienne, warunki, pętle i listy. Nie musimy uczyć się tych zagadnień od początku. W PHP wykonujemy podobne operacje, ale zapisujemy je trochę inaczej.

PHP możemy uruchamiać na dwa sposoby:

- W terminalu - interpreter wykonuje plik i wyświetla wynik. Ten sposób wykorzystamy do nauki składni.
- Przez serwer WWW Apache - przeglądarka wysyła żądanie do serwera, PHP wykonuje kod, a przeglądarka otrzymuje wynik. Ten sposób przyda się później przy formularzach.

Prosty schemat:

```text
Plik .php => interpreter PHP => wynik w terminalu

Przeglądarka => Apache w XAMPP => PHP => wynik w przeglądarce
```

**Ważne:** Do uruchomienia programu PHP w terminalu nie musimy włączać Apache. Do pracy w przeglądarce przez `localhost` uruchamiamy Apache w panelu XAMPP.

## 2. Katalog projektu i pierwszy plik

Utwórz katalog:

```text
C:\xampp\htdocs\kurs-php
```

W katalogu utwórz plik `index.php`.

Zapisz w nim:

```php
<?php
$imie = "Anna";
$wiek = 18;

echo "Witaj $imie!\n";

if ($wiek >= 18) {
    echo "Jesteś osobą pełnoletnią.\n";
}
```

Co oznaczają poszczególne elementy?

- `<?php` - początek kodu PHP.
- `$imie`, `$wiek` - zmienne. W PHP nazwy zmiennych rozpoczynają się od `$`.
- `=` - przypisanie wartości do zmiennej.
- `;` - zakończenie instrukcji.
- `echo` - wypisanie wartości.
- `if` - sprawdzenie warunku.
- `{` i `}` - początek i koniec bloku instrukcji.
- `\n` - nowy wiersz w terminalu, jeśli znajduje się w tekście zapisanym w podwójnych cudzysłowach.

Gdy plik zawiera tylko kod PHP, nie trzeba umieszczać na końcu znacznika `?>`. Jego pominięcie jest zalecaną praktyką. Jeśli w jednym pliku mieszamy PHP i zwykły HTML, znacznik `?>` pozwala zakończyć fragment PHP.

### Ćwiczenie 1

Zmień wartość `$wiek` na `16`, uruchom ponownie program i sprawdź, czy komunikat o pełnoletności nadal się pojawia. Wyjaśnij dlaczego.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź</summary>

Sprawdź wartość warunku `$wiek >= 18` po zmianie wieku. Które instrukcje są wewnątrz bloku `if`?

</details>

## 3. Konfiguracja Visual Studio Code

### 3.1. Otwarcie projektu

- Otwórz Visual Studio Code.
- Wybierz `File => Open Folder`.
- Wskaż `C:\xampp\htdocs\kurs-php`.
- Otwórz plik `index.php`.

Dzięki otwarciu całego folderu wszystkie pliki ćwiczeniowe będą widoczne po lewej stronie edytora.

### 3.2. Rozszerzenie PHP

- Otwórz panel rozszerzeń za pomocą `Ctrl + Shift + X`.
- Wyszukaj `PHP Intelephense`.
- Zainstaluj rozszerzenie autorstwa Bena Mewburna.

Rozszerzenie pomaga podczas pisania kodu: podpowiada nazwy, ułatwia poruszanie się po plikach i wskazuje część błędów. Nie zastępuje interpretera PHP z XAMPP.

### 3.3. Ustawienie interpretera w `settings.json`

- Naciśnij `Ctrl + Shift + P`.
- Uruchom polecenie `Preferences: Open User Settings (JSON)`.
- Otworzy się globalny plik ustawień użytkownika. W typowej instalacji Windows znajduje się w katalogu `%APPDATA%\Code\User\settings.json`.

Dodaj ustawienie:

```json
{
    "php.validate.executablePath": "C:/xampp/php/php.exe"
}
```

Jeśli `settings.json` zawiera już inne ustawienia, dopisz tylko właściwość `"php.validate.executablePath"` do istniejącego obiektu JSON. Zachowaj prawidłowe przecinki. Nie usuwaj pozostałych ustawień.

To ustawienie wskazuje plik interpretera wbudowanemu mechanizmowi sprawdzania składni PHP w VS Code. Nie uruchamia Apache, nie konfiguruje Xdebug i nie dodaje automatycznie przycisku wykonywania programu.

**Dodatkowa informacja:** Ustawienie można też umieścić w pliku `.vscode/settings.json` wewnątrz folderu projektu. Wówczas dotyczy tylko tego projektu. Na tych zajęciach korzystamy z ustawienia globalnego.

### 3.4. Uruchomienie programu w terminalu

- Otwórz `Terminal => New Terminal`.
- Sprawdź, czy terminal pracuje w katalogu `C:\xampp\htdocs\kurs-php`.
- Wpisz:

```powershell
C:\xampp\php\php.exe index.php
```

Oczekiwany wynik przy wartości `$wiek = 18`:

```text
Witaj Anna!
Jesteś osobą pełnoletnią.
```

Możesz również użyć:

```powershell
& "C:\xampp\php\php.exe" index.php
```

Znak `&` to operator wywołania w PowerShell. Jest potrzebny wtedy, gdy ścieżka programu jest podana jako tekst w cudzysłowie. W naszym przykładzie z niecytowaną ścieżką bez spacji można go pominąć.

Przydatne polecenia:

```powershell
C:\xampp\php\php.exe -v
C:\xampp\php\php.exe -l index.php
```

- `-v` - pokazuje wersję PHP.
- `-l` - sprawdza składnię pliku, ale nie wykonuje programu.

Po zmianie kodu zapisuj plik przez `Ctrl + S` i ponownie uruchamiaj polecenie w terminalu.

### 3.5. Uruchamianie przez przeglądarkę

- W panelu XAMPP uruchom `Apache`.
- Otwórz adres `http://localhost/kurs-php/index.php`.

Kod PHP wykonuje się na serwerze. Przeglądarka otrzymuje wynik działania programu, a nie kod źródłowy PHP.

**Uwaga:** `\n` tworzy nowy wiersz tekstu, ale przeglądarka nie musi wyświetlić go jako nowej linii na stronie HTML. Później nauczymy się używać znaczników HTML do formatowania wyniku.

Na razie nie konfigurujemy skrótu `Ctrl + F5` ani debugowania krokowego. Do ćwiczeń wystarczy terminal VS Code.

## 4. Zmienne, tekst i warunki

### 4.1. Zmienne - porównanie z Pythonem

Python:

```python
imie = "Anna"
wiek = 18
print(imie)
```

PHP:

```php
<?php
$imie = "Anna";
$wiek = 18;

echo $imie . "\n";
```

Różnice:

- PHP wymaga znaku `$` przed nazwą zmiennej.
- Instrukcję kończymy średnikiem `;`.
- `echo` nie dodaje automatycznie nowego wiersza.

### 4.2. Łączenie tekstów

```php
<?php
$imie = "Anna";
$wiek = 18;

echo "Witaj " . $imie . "!\n";
echo "Wiek: " . $wiek . "\n";
```

W PHP operator `.` łączy teksty. Nie mylimy go z `+`, który służy do działań arytmetycznych.

Możemy też wstawić zmienną do ciągu zapisanego w podwójnych cudzysłowach:

```php
echo "Witaj $imie!\n";
```

### 4.3. Instrukcja `if`

Python:

```python
if wiek >= 18:
    print("Osoba pełnoletnia")
```

PHP:

```php
<?php
$wiek = 18;

if ($wiek >= 18) {
    echo "Osoba pełnoletnia\n";
} else {
    echo "Osoba niepełnoletnia\n";
}
```

Warunek umieszczamy w nawiasach `()`, a instrukcje w nawiasach klamrowych `{}`.

## 5. Pętla `for`

Pętla `for` pozwala wielokrotnie wykonywać instrukcje.

Python:

```python
for liczba in range(1, 6):
    print(liczba)
```

PHP:

```php
<?php
for ($liczba = 1; $liczba <= 5; $liczba++) {
    echo $liczba . "\n";
}
```

Wynik:

```text
1
2
3
4
5
```

### Jak czytać instrukcję `for`?

```text
for (wartość początkowa; warunek; zmiana licznika)
```

W naszym przykładzie:

- `$liczba = 1` - zaczynamy od 1.
- `$liczba <= 5` - wykonujemy pętlę, dopóki warunek jest prawdziwy.
- `$liczba++` - po każdej iteracji zwiększamy licznik o 1.

### Ćwiczenie 2 - liczby podzielne przez 3

Napisz program, który sprawdza liczby od 1 do 20 i wypisuje tylko te podzielne przez 3. Użyj operatora `%`, który zwraca resztę z dzielenia.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź</summary>

W każdej iteracji pętli oblicz resztę z dzielenia bieżącej liczby przez 3. Zastanów się, jaka reszta oznacza podzielność.

</details>

<details class="lesson-hint" markdown="1">
<summary>Sprawdź wynik</summary>

Oczekiwany wynik:

```text
3
6
9
12
15
18
```

</details>

## 6. Tablice indeksowane

Tablica przechowuje wiele wartości pod jedną nazwą. W tablicy indeksowanej odwołujemy się do elementów przy użyciu indeksów liczbowych.

Python:

```python
liczby = [10, 20, 30, 40]
print(liczby[0])
```

PHP:

```php
<?php
$liczby = [10, 20, 30, 40];

echo $liczby[0] . "\n";
```

W obu przykładach wynik to `10`. Indeks pierwszego elementu wynosi `0`.

### Ile elementów znajduje się w tablicy?

```php
<?php
$liczby = [10, 20, 30, 40];

echo count($liczby) . "\n";
```

Wynik:

```text
4
```

Porównanie:

- Python - `len(liczby)`.
- PHP - `count($liczby)`.

## 7. Pętla `foreach`

`foreach` przechodzi po kolejnych elementach tablicy. Nie musimy sami ustawiać i zwiększać indeksu.

Python:

```python
liczby = [10, 20, 30, 40]
for liczba in liczby:
    print(liczba)
```

PHP:

```php
<?php
$liczby = [10, 20, 30, 40];

foreach ($liczby as $liczba) {
    echo $liczba . "\n";
}
```

Wynik:

```text
10
20
30
40
```

**Jak to działa?** Przy pierwszym obiegu `$liczba` ma wartość 10, przy drugim 20, później 30 i 40. Pętla kończy się po przejściu przez wszystkie elementy.

### Ćwiczenie 3 - suma i średnia ocen

Utwórz tablicę:

```php
$oceny = [4, 5, 3, 5, 4, 2, 5];
```

Program powinien:

- Wyświetlić każdą ocenę za pomocą `foreach`.
- Policzyć sumę ocen, dodając je w pętli.
- Policzyć średnią na podstawie sumy oraz `count($oceny)`.
- Wyświetlić średnią z dokładnością do dwóch miejsc po przecinku za pomocą `number_format()`.

Na razie nie używaj `array_sum()`. Celem ćwiczenia jest utrwalenie pętli.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź</summary>

Przed pętlą ustaw sumę na zero. W pętli dodawaj bieżącą ocenę. Średnią oblicz dopiero po zakończeniu pętli.

Fragmenty, które możesz wykorzystać w odpowiednich miejscach:

```php
$suma = 0;
$suma += $ocena;
```

</details>

<details class="lesson-hint" markdown="1">
<summary>Sprawdź wynik</summary>

Oczekiwane podsumowanie:

```text
Suma ocen: 28
Srednia: 4.00
```

</details>

## 8. Komentarze w PHP

Komentarz wyjaśnia kod, ale nie jest wykonywany przez PHP.

### Komentarz jednoliniowy

```php
// Tworzymy tablicę ocen
$oceny = [4, 5, 3, 5];
```

Możemy też dodać komentarz po instrukcji:

```php
$suma += $ocena; // Dodajemy kolejną ocenę
```

### Komentarz wieloliniowy

```php
/*
Program oblicza średnią ocen.
Opis może zajmować kilka wierszy.
*/
```

PHP rozpoznaje również komentarze zaczynające się od `#`, podobnie jak Python. W tym kursie stosujemy `//` oraz `/* ... */`.

W VS Code:

- `Ctrl + /` - komentowanie lub odkomentowanie zaznaczonych wierszy.
- `Shift + Alt + A` - dodawanie lub usuwanie komentarza blokowego.

## 9. Tablice asocjacyjne - odpowiednik słowników Pythona

W Pythonie poznaliśmy słowniki (`dict`). Słownik przechowuje pary `klucz => wartość`. W PHP podobną rolę pełni tablica asocjacyjna.

W zwykłej tablicy indeksowanej używaliśmy numerów `0`, `1`, `2`. W tablicy asocjacyjnej możemy posługiwać się nazwami, np. `nick` i `punkty`.

### 9.1. Słownik w Pythonie

```python
turysta = {
    "nick": "Ewa",
    "punkty": 23
}

print(turysta["nick"])
print(turysta["punkty"])
```

### 9.2. Tablica asocjacyjna w PHP

```php
<?php
$turysta = [
    "nick" => "Ewa",
    "punkty" => 23
];

echo $turysta["nick"] . "\n";
echo $turysta["punkty"] . "\n";
```

Wynik:

```text
Ewa
23
```

Schemat zawartości tablicy:

```text
"nick"   => "Ewa"
"punkty" => 23
```

- `nick` i `punkty` - klucze.
- `Ewa` i `23` - wartości.
- `=>` - znak łączący klucz z wartością przy tworzeniu elementu tablicy.

Przykład nie jest przypadkowy. Turystka Ewa, która ma 23 punkty, występuje w tabeli `turysci` z bazy `Islandia`. W tej lekcji wpisujemy te wartości ręcznie do PHP. Nie pobieramy jeszcze danych z bazy.

### 9.3. Zmiana wartości istniejącego klucza

```php
<?php
$turysta = [
    "nick" => "Ewa",
    "punkty" => 23
];

$turysta["punkty"] = 30;

echo $turysta["punkty"] . "\n";
```

Wynik:

```text
30
```

Zmieniliśmy wartość z 23 na 30. Nazwa klucza `punkty` pozostała bez zmian.

### 9.4. Dodawanie nowego elementu

Aby dodać identyfikator turysty, wpisujemy:

```php
$turysta["idTurysta"] = 1;
```

Teraz tablica zawiera:

```text
"nick"       => "Ewa"
"punkty"     => 30
"idTurysta"  => 1
```

Zwróć uwagę: ta sama składnia służy do zmiany wartości istniejącego klucza i dodania nowego klucza. Jeśli podana nazwa klucza nie istnieje, PHP utworzy nowy element.

### 9.5. Usuwanie elementu

W Pythonie możemy użyć `del`:

```python
del turysta["punkty"]
```

W PHP używamy `unset()`:

```php
unset($turysta["punkty"]);
```

Od tej chwili klucz `punkty` nie istnieje w tablicy. Próba odczytania go przez `$turysta["punkty"]` spowoduje ostrzeżenie `Undefined array key`.

**Ważne:** Usuwamy element tablicy znajdującej się w pamięci programu. Nie usuwamy rekordu z MariaDB.

### Ćwiczenie 4 - turysta

Napisz program, który:

- Utworzy tablicę `$turysta` z kluczami `nick` i `punkty`.
- Zmieni liczbę punktów.
- Doda klucz `idTurysta` o wartości 1.
- Doda klucz `kraj` o wartości `Polska`.
- Usunie klucz `kraj` za pomocą `unset()`.
- Wyświetli wynik.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź</summary>

Zapis `$turysta["klucz"] = wartość;` służy zarówno do dodawania, jak i zmieniania elementu. Po `unset()` sprawdź całą tablicę przez `print_r()`.

</details>

## 10. `echo`, `print_r()` i `var_dump()`

Pytanie: jak zobaczyć wszystkie elementy tablicy bez wypisywania każdego osobno?

### 10.1. `echo` - pojedyncza wartość

```php
<?php
$turysta = [
    "nick" => "Ewa",
    "punkty" => 23
];

echo $turysta["nick"] . "\n";
echo $turysta["punkty"] . "\n";
```

`echo` dobrze nadaje się do wyświetlenia jednej wartości.

Nie używamy go natomiast do oglądania całej tablicy:

```php
echo $turysta;
```

Taki zapis zgłasza ostrzeżenie `Array to string conversion` i wyświetla słowo `Array`, a nie poszczególne wartości.

### 10.2. `print_r()` - zawartość całej tablicy

```php
print_r($turysta);
```

Wynik:

```text
Array
(
    [nick] => Ewa
    [punkty] => 23
)
```

`print_r()` pokazuje klucze i wartości. Jest przydatna do szybkiego sprawdzenia struktury danych.

### 10.3. `var_dump()` - wartości i typy danych

```php
var_dump($turysta);
```

Wynik zawiera również informację, że `nick` to tekst, a `punkty` to liczba całkowita. Widać w nim między innymi `string(3) "Ewa"` oraz `int(23)`.

Zapamiętaj:

| Sposób | Kiedy używać? |
| --- | --- |
| `echo $turysta["nick"]` | Gdy potrzebujemy konkretnej wartości |
| `print_r($turysta)` | Gdy chcemy obejrzeć całą tablicę |
| `var_dump($turysta)` | Gdy chcemy dodatkowo sprawdzić typy danych |

### Ćwiczenie 5 - porównanie wyników

Utwórz tablicę z kluczami `nick`, `punkty` i `idTurysta`. Następnie:

- Wyświetl samą nazwę turysty przez `echo`.
- Wyświetl całą tablicę przez `print_r()`.
- Wyświetl całą tablicę przez `var_dump()`.
- Wyjaśnij, czym różnią się otrzymane wyniki.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź</summary>

Do `echo` przekaż wartość spod jednego klucza. Do `print_r()` i `var_dump()` przekaż całą tablicę. Porównaj, które wywołanie pokazuje także typy danych.

</details>

## 11. `array_slice()` - pobieranie fragmentu tablicy

Ta funkcja jest przydatna, ale na początku nauki wystarczy znać jej podstawowe zastosowanie.

Załóżmy, że mamy tablicę:

```php
<?php
$liczby = [10, 20, 30, 40, 50];

$fragment = array_slice($liczby, 1, 2);
print_r($fragment);
```

Wynik:

```text
Array
(
    [0] => 20
    [1] => 30
)
```

Czytamy to w następujący sposób:

```text
array_slice(tablica, pozycja_początkowa, liczba_elementów)
```

- `$liczby` - tablica źródłowa.
- `1` - zaczynamy od elementu o indeksie 1, czyli od wartości 20.
- `2` - bierzemy dwa elementy.

### 11.1. Przykład z tablicą asocjacyjną

```php
<?php
$turysta = [
    "nick" => "Anna",
    "punkty" => 23
];

$as = array_slice($turysta, 0, 1);

foreach ($as as $wartosc) {
    echo $wartosc . "\n";
}
```

Wynik:

```text
Anna
```

Dlaczego tylko `Anna`?

- `0` - zaczynamy od pierwszego elementu tablicy.
- `1` - pobieramy jeden element.
- `foreach` - wyświetla wartość tego jednego elementu.

W przypadku tablic asocjacyjnych funkcja `array_slice()` domyślnie zachowuje klucze tekstowe. Klucze liczbowe są domyślnie numerowane ponownie.

### 11.2. Czy `array_slice()` zmienia oryginalną tablicę?

Nie. Zwraca nową tablicę zawierającą wybrany fragment.

```php
print_r($turysta); // Oryginalna tablica
print_r($as);      // Tylko jeden element
```

### 11.3. Co zrobić, jeśli wynik pojawia się dwa razy?

Najpierw sprawdź, czy tego samego elementu nie wyświetlasz w dwóch miejscach programu, np. raz przez `echo`, a drugi raz wewnątrz `foreach`.

Samo `array_slice($turysta, 0, 1)` nie powoduje dwukrotnego wyświetlenia wartości. Ta funkcja przygotowuje fragment tablicy, ale niczego nie wypisuje.

### Czy trzeba dobrze znać `array_slice()`?

Warto wiedzieć, do czego służy, ale nie trzeba poświęcać jej dużo czasu na pierwszej lekcji. Na obecnym etapie ważniejsze są:

- `foreach` - przechodzenie przez elementy tablicy.
- `count()` - liczenie elementów.
- `unset()` - usuwanie wskazanego elementu.
- `print_r()` - oglądanie zawartości tablicy.

Później poznamy także sposób sprawdzania, czy określony klucz istnieje.

### Ćwiczenie 6 - fragment tablicy

Utwórz tablicę:

```php
$kolory = ["czerwony", "zielony", "niebieski", "żółty"];
```

Wykorzystaj `array_slice()`, aby otrzymać nową tablicę z elementami `zielony` i `niebieski`. Wyświetl ją przez `print_r()`. Następnie sprawdź, czy oryginalna tablica nadal zawiera wszystkie cztery kolory.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź</summary>

Indeksy liczymy od zera. Drugi argument `array_slice()` wskazuje początek, a trzeci liczbę elementów, nie indeks końca. Zapisz wynik pod nową nazwą.

</details>

## 12. Typowe błędy początkujących

### Brak średnika

```php
$wiek = 18
```

Poprawnie:

```php
$wiek = 18;
```

### Brak znaku `$` przed nazwą zmiennej

```php
echo wiek;
```

Poprawnie:

```php
echo $wiek;
```

### Próba wyświetlenia całej tablicy przez `echo`

```php
echo $turysta;
```

Do sprawdzenia zawartości tablicy użyj:

```php
print_r($turysta);
```

### Odczytanie usuniętego klucza

```php
unset($turysta["punkty"]);
echo $turysta["punkty"]; // Ostrzeżenie: brak klucza
```

### Program wyświetla poprzedni wynik

Upewnij się, że:

- Zapisałeś zmiany przez `Ctrl + S`.
- Uruchamiasz właściwy plik.
- Nie masz dodatkowego `echo` albo drugiej pętli wypisującej tę samą wartość.

## 13. Podsumowanie lekcji

Po zakończeniu materiału potrafisz:

- Uruchomić skrypt PHP w terminalu VS Code.
- Wyjaśnić, kiedy potrzebny jest Apache w XAMPP.
- Wskazać interpreter PHP w `settings.json`.
- Zapisać zmienne i warunki w składni PHP.
- Napisać pętlę `for` i `foreach`.
- Utworzyć tablicę indeksowaną i tablicę asocjacyjną.
- Odczytać, zmienić, dodać i usunąć element tablicy asocjacyjnej.
- Rozróżnić `echo`, `print_r()` i `var_dump()`.
- Pobrać prosty fragment tablicy przez `array_slice()`.
- Używać komentarzy i podstawowych narzędzi diagnostycznych.

### Najważniejsze polecenia i konstrukcje

| PHP | Znaczenie |
| --- | --- |
| `echo $imie;` | Wyświetlenie wartości |
| `if ($wiek >= 18) { ... }` | Warunek |
| `for (...) { ... }` | Pętla z licznikiem |
| `foreach ($tablica as $wartosc) { ... }` | Pętla po elementach tablicy |
| `count($tablica)` | Liczba elementów |
| `$turysta["nick"]` | Odczyt wartości przypisanej do klucza |
| `$turysta["kraj"] = "Polska";` | Dodanie albo zmiana elementu |
| `unset($turysta["kraj"]);` | Usunięcie elementu |
| `print_r($tablica);` | Podgląd całej tablicy |
| `var_dump($tablica);` | Podgląd tablicy i typów danych |
| `array_slice($tablica, 0, 2)` | Pobranie fragmentu tablicy |

## 14. Co będzie dalej?

Na [lekcji 2 - PHP i odczytywanie danych z bazy Islandia]({{ '/02-php-i-mariadb/01-odczyt-danych.html' | relative_url }}) połączymy się z MariaDB, wykonamy zapytanie `SELECT` i pobierzemy rekordy do tablic PHP.

**Baza ćwiczeniowa projektu:** `Islandia`. Import, schemat i relacje tabel opisuje [Baza Islandia]({{ '/00-organizacja/01-baza-islandia.html' | relative_url }}).
