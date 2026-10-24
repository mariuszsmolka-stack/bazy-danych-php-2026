---
title: Lekcja 9C - PHP i GET. Od listy do szczegółów
---

# Lekcja 9C - PHP i GET. Od listy do szczegółów

W [lekcji 8B]({{ '/05-php-i-html/01b-php-lista-z-bazy.html' | relative_url }}) PHP tworzył listę z rekordów MariaDB. W [lekcji 9B]({{ '/05-php-i-html/02b-get-rekord-z-bazy.html' | relative_url }}) adres z `id` wybierał jeden obiekt. Teraz każda nazwa na liście będzie prowadzić do strony tego obiektu.

**SELECT pobiera numer i nazwę => PHP tworzy link => kliknięcie przekazuje id => drugi program pokazuje szczegóły.**

## 1. Zobacz jeden link

```html
<a href="obiekt.php?id=46">Strokkur</a>
```

Na stronie widzimy nazwę **Strokkur**. Po kliknięciu przeglądarka otwiera `obiekt.php` i przekazuje mu `id=46`.

Drugi link prowadzi do innego obiektu:

```html
<a href="obiekt.php?id=47">Skogafoss</a>
```

Zmieniają się nazwa widoczna na stronie oraz numer po `id=`. Plik docelowy pozostaje ten sam.

## 2. Pobierz numer i nazwę z bazy

Wykonaj w phpMyAdmin:

```sql
SELECT idObiekt, nazwa
FROM obiekty
WHERE panstwo = 'Islandia'
ORDER BY idObiekt;
```

Wynik zawiera **9 rekordów**. Pierwsze dwa to `46 => Strokkur` i `47 => Skogafoss`. Rekord `52 => Hekla` też należy do tej listy.

Każdy obiekt ma swój numer `idObiekt`. Ten numer umieścimy w adresie linku. Nie używaj pozycji na liście: pierwszy obiekt ma `idObiekt = 46`, a nie `1`.

## 3. Z jednego rekordu zbuduj link

Po pobraniu rekordu odczytaj jego numer i nazwę:

```php
$idObiekt = (int)$rekord["idObiekt"];

$nazwa = htmlspecialchars(
    $rekord["nazwa"],
    ENT_QUOTES | ENT_SUBSTITUTE,
    "UTF-8"
);
```

`idObiekt` jest liczbą z bazy. Rzutowanie `(int)` zapewnia zapis liczbowy w adresie. `htmlspecialchars()` przygotowuje nazwę do wyświetlenia jako tekst HTML.

Teraz połącz części linku:

```php
echo '<li><a href="obiekt.php?id=' .
     $idObiekt . '">' .
     $nazwa . '</a></li>';
```

PHP otwiera element listy i link do `obiekt.php`. Wstawia numer bieżącego rekordu po `id=`. Następnie pokazuje nazwę i zamyka link oraz element listy.

Dla Strokkur powstanie:

```html
<li><a href="obiekt.php?id=46">Strokkur</a></li>
```

## 4. Utwórz link dla każdego rekordu

Zastosuj znaną pętlę `while`:

```php
echo "<ul>";

while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
    $idObiekt = (int)$rekord["idObiekt"];

    $nazwa = htmlspecialchars(
        $rekord["nazwa"],
        ENT_QUOTES | ENT_SUBSTITUTE,
        "UTF-8"
    );

    echo '<li><a href="obiekt.php?id=' .
         $idObiekt . '">' .
         $nazwa . '</a></li>';
}

echo "</ul>";
```

Każdy przebieg pętli pobiera kolejny rekord. **Jeden rekord => jeden link.** Z dziewięciu rekordów powstanie dziewięć linków.

## 5. Uruchom program listy

Włącz Apache i MariaDB w XAMPP. Przygotuj bazę `Islandia` z pliku `baza/baza1.sql`. Zapisz program w UTF-8 jako `C:\xampp\htdocs\kurs-php\lista_obiektow.php`.

Konto `root` bez hasła stosuj tylko na lokalnym stanowisku XAMPP, jeśli jest tak skonfigurowane.

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

$zapytanie = "SELECT idObiekt, nazwa FROM obiekty WHERE panstwo = 'Islandia' ORDER BY idObiekt;";
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
    <title>Obiekty Islandii</title>
</head>
<body>
<h1>Obiekty Islandii</h1>
<?php
echo "<ul>";

while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
    $idObiekt = (int)$rekord["idObiekt"];
    $nazwa = htmlspecialchars(
        $rekord["nazwa"],
        ENT_QUOTES | ENT_SUBSTITUTE,
        "UTF-8"
    );
    echo '<li><a href="obiekt.php?id=' .
         $idObiekt . '">' .
         $nazwa . '</a></li>';
}

echo "</ul>";
mysqli_close($polaczenie);
?>
</body>
</html>
```

Otwórz `http://localhost/kurs-php/lista_obiektow.php`. Zobaczysz dziewięć nazw. Każda jest linkiem z numerem pobranym z tego samego rekordu.

## 6. Przejdź od listy do szczegółów

Umieść `lista_obiektow.php` i `obiekt.php` z lekcji 9B w tym samym katalogu. Nie przepisuj programu szczegółów i nie zmieniaj jego obsługi GET.

Otwórz listę i kliknij **Strokkur**. Przeglądarka przejdzie do `obiekt.php?id=46`. Program szczegółów sprawdzi numer, pobierze rekord i pokaże dane Strokkur.

Wróć do listy i kliknij **Skogafoss**. Adres zmieni się na `obiekt.php?id=47`, a strona pokaże dane Skogafoss.

## 7. Ćwiczenia

### Ćwiczenie 1 - sprawdź adresy linków

Uruchom listę. Przed kliknięciem przewidź adresy linków **Strokkur**, **Skogafoss** i **Hekla**. Kliknij każdy z nich i sprawdź nazwę na stronie szczegółów.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Numer pochodzi z kolumny `idObiekt`, nie z miejsca obiektu na liście.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

Strokkur prowadzi do `obiekt.php?id=46`, Skogafoss do `obiekt.php?id=47`, a Hekla do `obiekt.php?id=52`. Po kliknięciu program szczegółów pokazuje odpowiedni obiekt.

</details>

### Ćwiczenie 2 - pokaż tylko wodospady

W `lista_obiektow.php` zmień tylko SQL. Pokaż linki do wodospadów Islandii. Zachowaj kolejność według `idObiekt`. Pętli PHP nie zmieniaj.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Do warunku `WHERE` dodaj `AND idRodzaj = 10`. W kursowej bazie ta wartość oznacza wodospady.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

W programie listy zastąp tylko przypisanie do `$zapytanie`:

```php
$zapytanie = "SELECT idObiekt, nazwa FROM obiekty WHERE panstwo = 'Islandia' AND idRodzaj = 10 ORDER BY idObiekt;";
```

Otrzymasz cztery linki: Skogafoss (`47`), Seljalandsfoss (`48`), Godafoss (`53`) i Dettifoss (`54`). Numery nadal pochodzą z rekordów. Kod pętli pozostaje taki sam.

</details>

### Ćwiczenie 3 - wróć do listy

To ćwiczenie dodatkowe. W `obiekt.php` dodaj zwykły link powrotny do `lista_obiektow.php`. Nie zmieniaj GET ani zapytania SQL. Sprawdź drogę: lista => szczegóły => lista.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 3</summary>

Oba pliki znajdują się w tym samym katalogu. Wystarczy względny adres `lista_obiektow.php`.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 3</summary>

Przed `</body>` w pliku `obiekt.php` dodaj:

```html
<a href="lista_obiektow.php">Powrót do listy</a>
```

Kliknięcie otwiera ponownie listę. Program sprawdzający `id` pozostaje bez zmian.

</details>

## 8. Zapamiętaj

`SELECT` wybiera obiekty. Pętla `while` tworzy link dla każdego rekordu. Po kliknięciu GET przekazuje `id` do `obiekt.php`, a drugi program pobiera szczegóły.

W tym ćwiczeniu używamy `obiekt.php`. W odrębnym projekcie INF.03 pojawia się plik `obiekty.php`; te nazwy dotyczą różnych przykładów.
