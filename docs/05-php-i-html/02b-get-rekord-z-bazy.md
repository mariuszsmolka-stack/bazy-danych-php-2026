---
title: Lekcja 9B - PHP i GET. Wybieramy rekord z bazy
---

# Lekcja 9B - PHP i GET. Wybieramy rekord z bazy

W [lekcji 9A]({{ '/05-php-i-html/02a-get-podstawy.html' | relative_url }}) odczytywaliśmy `id` z adresu. W [lekcji 8B]({{ '/05-php-i-html/01b-php-lista-z-bazy.html' | relative_url }}) pobieraliśmy dane z MariaDB. Teraz numer z adresu pomoże nam wybrać jeden obiekt z bazy `Islandia`.

**Adres URL => odczyt id => sprawdzenie numeru => SELECT => jeden rekord => wyświetlenie danych.**

## 1. Jeden adres, jeden obiekt

Otwórz adres:

```text
http://localhost/kurs-php/obiekt.php?id=46
```

Adres zawiera parametr `id`. Jego wartość to `46`. Chcemy znaleźć obiekt o takim identyfikatorze. W bazie `Islandia` jest to **Strokkur**.

Porównaj dwa kolejne adresy:

```text
http://localhost/kurs-php/obiekt.php?id=47
http://localhost/kurs-php/obiekt.php?id=52
```

Numer `47` wskazuje **Skogafoss**, a `52` wskazuje **Heklę**. Za każdym razem działa ten sam plik `obiekt.php`. Zmieniamy tylko numer w adresie.

## 2. Sprawdź rekord w phpMyAdmin

Najpierw wykonaj zapytanie w phpMyAdmin:

```sql
SELECT nazwa, panstwo, opis
FROM obiekty
WHERE idObiekt = 46;
```

Wynik to jeden rekord: **Strokkur**, państwo **Islandia** i opis gejzeru. Warunek `WHERE idObiekt = 46` wybiera obiekt o wskazanym numerze.

Zmień w zapytaniu `46` na `47` i wykonaj je ponownie. Powinien pojawić się **Skogafoss**. W tym kroku nie potrzebujesz PHP.

## 3. Odczytaj i sprawdź numer

Użytkownik może sam zmienić adres. Nie zakładaj, że wpisał poprawny numer. Nie wstawiaj surowego `$_GET["id"]` do zapytania SQL.

Skorzystaj z gotowego wzorca:

```php
$idObiekt = filter_input(
    INPUT_GET,
    "id",
    FILTER_VALIDATE_INT
);
```

PHP odczytuje `id` i sprawdza, czy jest liczbą całkowitą. Nie musisz zapamiętywać wszystkich argumentów `filter_input()`.

Następnie odrzuć brak parametru i niepoprawne liczby:

```php
if ($idObiekt === null) {
    exit("Brakuje parametru id.");
}

if ($idObiekt === false || $idObiekt <= 0) {
    exit("Niepoprawny identyfikator.");
}
```

Bez `id` zobaczysz komunikat o braku parametru. Wartości `abc`, `0` i `-1` są odrzucane. Dla `id=46` zmienna `$idObiekt` zawiera dodatnią liczbę całkowitą.

## 4. Użyj numeru w SELECT

Nie wpisuj już na stałe liczby `46`. Wykorzystaj sprawdzoną zmienną:

```php
$zapytanie = "SELECT nazwa, panstwo, opis
FROM obiekty
WHERE idObiekt = " . $idObiekt;
```

Dla `id=46` zapytanie wybierze Strokkur. Dla `id=47` wybierze Skogafoss, a dla `id=52` Heklę.

W tym przykładzie do SQL dołączamy **wyłącznie sprawdzoną dodatnią liczbę całkowitą**. Nie dołączaj w ten sposób dowolnego tekstu z adresu.

## 5. Pobierz jeden rekord

Po połączeniu z bazą wykonaj zapytanie:

```php
$wynik = mysqli_query($polaczenie, $zapytanie);
```

Po sprawdzeniu, czy zapytanie się powiodło, pobierz rekord:

```php
$rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC);
```

Nie potrzebujemy pętli `while`. Kolumna `idObiekt` jest kluczem głównym, więc jeden numer może wskazać najwyżej jeden rekord.

Gdy `$rekord === null`, obiektu nie znaleziono. Gdy `$rekord === false`, wystąpił błąd odczytu. Na przykład `id=999` jest poprawną liczbą, ale nie wskazuje rekordu w danych kursowych.

## 6. Wyświetl dane obiektu

Z pobranego rekordu odczytamy `$rekord["nazwa"]`, `$rekord["panstwo"]` i `$rekord["opis"]`. Każda wartość dotyczy tego samego obiektu.

Przed wyświetleniem tekstu z bazy użyj `htmlspecialchars()` z `ENT_QUOTES | ENT_SUBSTITUTE` i kodowaniem `UTF-8`. Znaczniki HTML pozostają zwykłymi znacznikami.

## 7. Uruchom cały program

Włącz Apache i MariaDB w XAMPP. Zaimportuj `baza/baza1.sql` do bazy `Islandia`. Zapisz program w UTF-8 jako `C:\xampp\htdocs\kurs-php\obiekt.php`.

Konto `root` bez hasła stosuj tylko na lokalnym stanowisku XAMPP, jeśli jest tak skonfigurowane.

```php
<?php
$idObiekt = filter_input(INPUT_GET, "id", FILTER_VALIDATE_INT);
if ($idObiekt === null) {
    exit("Brakuje parametru id.");
}
if ($idObiekt === false || $idObiekt <= 0) {
    exit("Niepoprawny identyfikator.");
}

mysqli_report(MYSQLI_REPORT_OFF);
$polaczenie = mysqli_connect("localhost", "root", "", "Islandia");
if (!$polaczenie) {
    exit("Nie udało się połączyć z bazą.");
}

if (!mysqli_set_charset($polaczenie, "utf8mb4")) {
    mysqli_close($polaczenie);
    exit("Nie udało się ustawić kodowania.");
}

$zapytanie = "SELECT nazwa, panstwo, opis FROM obiekty WHERE idObiekt = " . $idObiekt;
$wynik = mysqli_query($polaczenie, $zapytanie);
if (!$wynik) {
    mysqli_close($polaczenie);
    exit("Nie udało się wykonać zapytania.");
}

$rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC);
mysqli_close($polaczenie);
if ($rekord === false) {
    exit("Nie udało się odczytać rekordu.");
}
if ($rekord === null) {
    exit("Nie znaleziono obiektu.");
}
?>
<!doctype html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <title>Szczegóły obiektu</title>
</head>
<body>
<?php
echo "<h1>" . htmlspecialchars($rekord["nazwa"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8") . "</h1>";
echo "<p>Państwo: " . htmlspecialchars($rekord["panstwo"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8") . "</p>";
echo "<p>" . htmlspecialchars($rekord["opis"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8") . "</p>";
?>
</body>
</html>
```

Otwórz `http://localhost/kurs-php/obiekt.php?id=46`. Program pokaże nazwę Strokkur, państwo Islandia i opis gejzeru.

Sprawdzenie numeru następuje przed połączeniem z bazą. Po zapytaniu program zamyka połączenie. Dopiero potem wyświetla dane pobranego rekordu.

## 8. Ćwiczenia

### Ćwiczenie 1 - zmień obiekt

Otwórz ten sam program z `id=46`, `id=47` i `id=52`. Przed każdym otwarciem przewidź nazwę obiektu. Nie zmieniaj kodu PHP.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Zmień tylko numer po `id=` w adresie `obiekt.php`.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

`id=46` pokazuje Strokkur, `id=47` pokazuje Skogafoss, a `id=52` pokazuje Heklę. Każdy adres uruchamia ten sam program.

</details>

### Ćwiczenie 2 - błędne id i brak obiektu

Sprawdź `obiekt.php` bez parametru, a potem `?id=abc`, `?id=0` i `?id=999`. Które adresy zostaną odrzucone przed zapytaniem? Który przejdzie walidację, lecz nie wskaże obiektu?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Oddziel sprawdzenie numeru od szukania rekordu. `999` jest dodatnią liczbą całkowitą.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

Bez `id` program pokaże `Brakuje parametru id.`. Dla `abc` i `0` pokaże `Niepoprawny identyfikator.`. Żaden z tych adresów nie wykona SELECT.

Wartość `999` przejdzie walidację i uruchomi SELECT. W danych kursowych nie ma takiego obiektu, więc program pokaże `Nie znaleziono obiektu.`. To nie jest błąd składni SQL.

</details>

## 9. Zapamiętaj

Numer `id` pochodzi z adresu, który użytkownik może zmienić. Sprawdzamy go przed zapytaniem. `WHERE idObiekt = ...` wybiera najwyżej jeden rekord, ponieważ `idObiekt` jest kluczem głównym.

**Adres wskazuje numer => SELECT znajduje rekord => PHP wyświetla jego dane.** Zmiana numeru w adresie zmienia obiekt bez zmiany programu.
