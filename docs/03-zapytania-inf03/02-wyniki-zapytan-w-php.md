---
title: Wykonanie zapytań SQL w PHP
---

# Lekcja 4 - Wykonanie czterech zapytań SQL w PHP

W poprzedniej lekcji uruchamialiśmy cztery zapytania w phpMyAdmin. Teraz wykonamy je w PHP i obejrzymy wyniki.

Użyjemy bazy `Islandia`, XAMPP i VS Code. Nie zmieniamy bazy ani jej danych.

Potrzebujesz czterech zapytań z [poprzedniej lekcji]({{ '/03-zapytania-inf03/01-cztery-zapytania.html' | relative_url }}). Jeśli nie pamiętasz składni funkcji, otwórz [ściągę INF.03]({{ '/00-organizacja/02-sciaga-php-inf03.html' | relative_url }}).

## 1. Co już znamy?

```text
mysqli_connect() => mysqli_query() => mysqli_fetch_all() => print_r() => mysqli_close()
```

Ten sposób pracy znasz z lekcji 2. Po połączeniu z bazą PHP wysyła zapytanie SQL. Potem pobiera rekordy i pokazuje je przez `print_r()`.

Na razie oglądamy dane. Portal ze zdjęciami zbudujemy później.

## 2. Jeden program - różne zapytania

Jeden program PHP może wykonać różne zapytania SQL. W kolejnych ćwiczeniach zmienisz tylko tekst zapytania. Pozostała część programu będzie działać tak samo.

W katalogu używanym z XAMPP utwórz plik `zapytania_inf03.php`:

```php
<?php
mysqli_report(MYSQLI_REPORT_OFF);

$polaczenie = mysqli_connect("localhost", "root", "", "Islandia");

if (!$polaczenie) {
    exit("Błąd połączenia z bazą.\n");
}

// Zmieniaj wyłącznie treść zapytania w kolejnych ćwiczeniach.
$zapytanie = "SELECT idObiekt, plik, nazwa FROM obiekty WHERE panstwo = 'Islandia'";

$wynik = mysqli_query($polaczenie, $zapytanie);

if (!$wynik) {
    echo "Błąd SQL: " . mysqli_error($polaczenie) . "\n";
    mysqli_close($polaczenie);
    exit;
}

$rekordy = mysqli_fetch_all($wynik, MYSQLI_ASSOC);
print_r($rekordy);

mysqli_close($polaczenie);
```

Uruchom w terminalu VS Code:

```powershell
C:\xampp\php\php.exe zapytania_inf03.php
```

**Sprawdź wynik:** powinieneś zobaczyć 9 rekordów. Wśród nich jest `Strokkur`.

Zapytanie nie zawiera `ORDER BY`, więc `Strokkur` nie musi być pierwszy. Sprawdzaj zawartość wyniku, a nie pozycję rekordu.

## 3. Ćwiczenia - zamieniaj tylko zapytanie

1. Wstaw do `$zapytanie` SQL z zadania 2 poprzedniej lekcji. Uruchom program. Sprawdź, czy wynik zawiera `Strokkur` i `gorące źródło`.
2. Wstaw SQL z zadania 3 i uruchom program. Sprawdź, czy pobrano 4 wodospady z Islandii.
3. Wstaw SQL z zadania 4 i uruchom program. Sprawdź, czy wynik ma 8 grup. Porównaj liczby obiektów z wynikiem w phpMyAdmin.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - gdzie zmienić program?</summary>

Nie zmieniaj `mysqli_connect()`, `mysqli_query()`, `mysqli_fetch_all()` ani `print_r()`. Zmień tylko tekst SQL przypisany do zmiennej `$zapytanie`.

Jeżeli w SQL używasz apostrofów, możesz zachować podwójne cudzysłowy wokół całego zapytania PHP.

</details>

## 4. Wynik w przeglądarce (opcjonalnie)

Uruchom Apache w XAMPP i otwórz adres `http://localhost/kurs-php/zapytania_inf03.php`, jeśli plik znajduje się w katalogu `C:\xampp\htdocs\kurs-php`.

W przeglądarce wynik `print_r()` może być trudny do przeczytania. Możesz zachować odstępy i bezpiecznie wyświetlić tekst. W tym celu zamień linię `print_r($rekordy);` na:

```php
echo "<pre>";
echo htmlspecialchars(print_r($rekordy, true), ENT_QUOTES, "UTF-8");
echo "</pre>";
```

- `print_r($rekordy, true)` - zwraca tekst wyniku zamiast wyświetlić go od razu.
- `htmlspecialchars()` - zamienia znaki specjalne HTML na bezpieczne odpowiedniki do wyświetlania.
- `<pre>` - zachowuje układ wierszy i odstępów.

Ten sposób służy do sprawdzenia pobranych danych. Nie tworzy jeszcze elementów portalu HTML na podstawie rekordów. Zrobimy to w dalszych lekcjach.

## 5. Co sprawdzić przed zakończeniem?

- Czy każde z czterech zapytań działało wcześniej w phpMyAdmin?
- Czy po wklejeniu do PHP daje te same dane?
- Czy potrafisz odróżnić błąd połączenia od błędu zapytania?
- Czy rozumiesz, że `mysqli_fetch_all(..., MYSQLI_ASSOC)` zamienia wynik SQL w tablicę rekordów PHP?

Nie przechodzimy jeszcze do formularzy, `GET` ani generowania zdjęć. Do tych elementów wrócimy na dalszych zajęciach.
