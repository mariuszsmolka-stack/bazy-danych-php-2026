---
title: Lekcja 9A - PHP i GET. Informacje w adresie
---

# Lekcja 9A - PHP i GET. Informacje w adresie

Czy jeden program PHP może otrzymywać różne informacje bez zmieniania kodu? Porównaj dwa adresy:

```text
http://localhost/kurs-php/parametr.php?id=46
http://localhost/kurs-php/parametr.php?id=47
```

Oba otwierają ten sam plik `parametr.php`. Różni się tylko wartość po `id=`. Program może ją odczytać i wyświetlić.

## 1. Odczytaj adres

Spójrz na fragment `parametr.php?id=46`:

| Fragment | Znaczenie |
| --- | --- |
| `parametr.php` | Nazwa programu |
| `?` | Początek parametrów w adresie |
| `id` | Nazwa parametru |
| `=` | Oddziela nazwę od wartości |
| `46` | Wartość parametru |

Gdy w adresie wpiszesz `id=47`, uruchomisz ten sam program. Przekażesz mu inną wartość.

## 2. Odczytaj wartość w PHP

PHP zapisuje informacje z adresu w tablicy `$_GET`. Wartość parametru `id` odczytujemy tak:

```php
$_GET["id"]
```

Dla `?id=46` otrzymamy tekst `"46"`. To wartość pochodząca z adresu. Na razie nie zakładamy, że jest poprawnym numerem.

## 3. Sprawdź, czy parametr istnieje

Ktoś może otworzyć sam adres `parametr.php`, bez `?id=...`. Przed odczytem sprawdźmy obecność parametru:

```php
<?php
if (isset($_GET["id"])) {
    echo "Parametr został przekazany.";
} else {
    echo "Brakuje parametru id.";
}
?>
```

`isset()` sprawdza, czy parametr został przekazany. Dla `?id=46` program pokaże pierwszy komunikat. Bez `id` pokaże drugi.

Sama obecność nie oznacza poprawnego numeru. Adres `?id=abc` również zawiera parametr `id`. Sprawdzaniem numeru zajmiemy się w kolejnej lekcji.

## 4. Uruchom cały program

Włącz Apache w XAMPP. Zapisz kod w UTF-8 jako `C:\xampp\htdocs\kurs-php\parametr.php`. Nie potrzebujesz MariaDB.

```php
<?php
if (isset($_GET["id"])) {
    if (is_string($_GET["id"])) {
        echo htmlspecialchars(
            $_GET["id"],
            ENT_QUOTES | ENT_SUBSTITUTE,
            "UTF-8"
        );
    } else {
        echo "Oczekiwano jednej wartości id.";
    }
} else {
    echo "Brakuje parametru id.";
}
?>
```

`is_string()` sprawdza, czy otrzymaliśmy jedną wartość tekstową, a nie tablicę. Traktuj tę kontrolę jako gotowy fragment programu. Dopiero potem `htmlspecialchars()` przygotowuje tekst do bezpiecznego wyświetlenia w HTML.

Otwórz kolejno:

| Adres | Wynik |
| --- | --- |
| `http://localhost/kurs-php/parametr.php?id=46` | `46` |
| `http://localhost/kurs-php/parametr.php?id=47` | `47` |
| `http://localhost/kurs-php/parametr.php` | `Brakuje parametru id.` |

Zmieniasz adres, nie kod programu. Możesz też sprawdzić `?id[]=46`. Wtedy program pokaże komunikat o oczekiwaniu jednej wartości, zamiast przekazywać tablicę do `htmlspecialchars()`.

## 5. Ćwiczenia

### Ćwiczenie 1 - zmień wartość parametru

Otwórz ten sam program kolejno z `id=46`, `id=47` i `id=52`. Przed każdym otwarciem przewidź tekst, który zobaczysz. Kodu PHP nie zmieniaj.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

W adresie zmieniaj tylko tekst po `id=`.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

Otwórz kolejno `parametr.php?id=46`, `parametr.php?id=47` i `parametr.php?id=52` przez `localhost`. Program pokaże odpowiednio `46`, `47` i `52`. Plik PHP pozostaje ten sam.

</details>

### Ćwiczenie 2 - zmień nazwę parametru

Zmień program tak, aby odczytywał `panstwo` zamiast `id`. Otwórz `http://localhost/kurs-php/parametr.php?panstwo=Islandia`. Program powinien pokazać `Islandia`.

Zachowaj sprawdzenie obecności, kontrolę pojedynczego tekstu i bezpieczne wyświetlanie.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Zmień klucz w każdym odczycie `$_GET` oraz nazwę parametru w komunikatach.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

Zapisz w tym samym pliku `parametr.php`:

```php
<?php
if (isset($_GET["panstwo"])) {
    if (is_string($_GET["panstwo"])) {
        echo htmlspecialchars(
            $_GET["panstwo"],
            ENT_QUOTES | ENT_SUBSTITUTE,
            "UTF-8"
        );
    } else {
        echo "Oczekiwano jednej wartości panstwo.";
    }
} else {
    echo "Brakuje parametru panstwo.";
}
?>
```

Dla `?panstwo=Islandia` otrzymasz **Islandia**. Bez `panstwo` program pokaże komunikat o brakującym parametrze.

</details>

## 6. Zapamiętaj

Użytkownik może sam zmienić adres. Nie zakładaj więc, że przekazana wartość jest poprawna.

`htmlspecialchars()` chroni sposób wyświetlania tekstu jako HTML. Nie sprawdza, czy `id` jest liczbą, i nie zabezpiecza zapytań SQL. W następnej lekcji sprawdzimy identyfikator przed użyciem go do odczytu z bazy.
