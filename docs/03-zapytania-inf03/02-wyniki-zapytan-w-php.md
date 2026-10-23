---
title: Wykonanie zapytań SQL w PHP
---

# Lekcja 4 - Wykonanie czterech zapytań SQL w PHP

**Cel:** wykonać w PHP zapytania poznane na lekcji 3 i zobaczyć ich wyniki. Nie zmieniamy struktury bazy ani jej danych. Korzystamy z `Islandia`, XAMPP i VS Code.

Potrzebujesz czterech zapytań z [poprzedniej lekcji]({{ '/03-zapytania-inf03/01-cztery-zapytania.html' | relative_url }}). Jeśli nie pamiętasz składni funkcji, otwórz [ściągę INF.03]({{ '/00-organizacja/02-sciaga-php-inf03.html' | relative_url }}).

## 1. Co już znamy?

```text
mysqli_connect() => mysqli_query() => mysqli_fetch_all() => print_r() => mysqli_close()
```

Ten przepływ ćwiczyliśmy na lekcji 2. Na razie wyświetlamy strukturę danych, nie budujemy jeszcze gotowego portalu z obrazami.

## 2. Jeden program - różne zapytania

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

**Sprawdzenie:** powinieneś zobaczyć 9 rekordów. Pierwszy, pochodzący z oryginalnych danych, to `Strokkur`. Bez `ORDER BY` kolejność nie jest gwarantowana, dlatego sprawdzaj zawartość, a nie numer pozycji.

## 3. Ćwiczenia - zamieniaj tylko zapytanie

1. Wklej do zmiennej `$zapytanie` rozwiązanie zadania 2 z poprzedniej lekcji. Sprawdź, czy wynikiem jest `Strokkur` i `gorące źródło`.
2. Wklej rozwiązanie zadania 3. Sprawdź, czy pobrano 4 wodospady z Islandii.
3. Wklej rozwiązanie zadania 4. Sprawdź, czy otrzymano 8 grup rodzajów, a liczby obiektów odpowiadają wynikowi w phpMyAdmin.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - gdzie zmienić program?</summary>

Nie zmieniaj `mysqli_connect()`, `mysqli_query()`, `mysqli_fetch_all()` ani `print_r()`. Zmień tylko tekst SQL przypisany do zmiennej `$zapytanie`.

Jeżeli w SQL używasz apostrofów, możesz zachować podwójne cudzysłowy wokół całego zapytania PHP.

</details>

## 4. Wynik w przeglądarce (opcjonalnie)

Uruchom Apache w XAMPP i otwórz adres `http://localhost/kurs-php/zapytania_inf03.php`, jeśli plik znajduje się w katalogu `C:\xampp\htdocs\kurs-php`.

W przeglądarce `print_r()` może wyświetlić tekst bez czytelnych przejść do nowej linii. Aby zachować odstępy i bezpiecznie wyświetlić wynik, zamień linię `print_r($rekordy);` na:

```php
echo "<pre>";
echo htmlspecialchars(print_r($rekordy, true), ENT_QUOTES, "UTF-8");
echo "</pre>";
```

- `print_r($rekordy, true)` - zwraca tekst wyniku zamiast wyświetlić go od razu.
- `htmlspecialchars()` - zamienia znaki specjalne HTML na bezpieczne odpowiedniki do wyświetlania.
- `<pre>` - zachowuje układ wierszy i odstępów.

To nadal widok diagnostyczny. Budowanie właściwych elementów HTML na podstawie rekordów omówimy osobno.

## 5. Co sprawdzić przed zakończeniem?

- Czy każde z czterech zapytań działało wcześniej w phpMyAdmin?
- Czy po wklejeniu do PHP daje te same dane?
- Czy potrafisz odróżnić błąd połączenia od błędu zapytania?
- Czy rozumiesz, że `mysqli_fetch_all(..., MYSQLI_ASSOC)` zamienia wynik SQL w tablicę rekordów PHP?

Nie przechodzimy jeszcze do formularzy, `GET` ani generowania zdjęć. Do tych elementów wrócimy na dalszych zajęciach.
