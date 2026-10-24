---
title: Lekcja 8A - PHP generuje HTML za pomocą echo
---

# Lekcja 8A - PHP generuje HTML za pomocą echo

Chcemy wyświetlić tekst na stronie, ale tworzyć go w programie PHP. Użyjemy znanej już instrukcji `echo`.

## 1. Uruchom plik PHP

Uruchom Apache w XAMPP. Utwórz plik `C:\xampp\htdocs\kurs-php\html_z_php.php` i otwórz adres:

```text
http://localhost/kurs-php/html_z_php.php
```

Kod zapisujemy w pliku `.php`. Serwer wykonuje program, a wynik oglądamy przez `localhost`. Otwarcie pliku przez `file://` nie uruchomi PHP.

Każdy przykład możesz uruchomić w tym samym pliku. Przed następnym krokiem zastąp jego poprzednią zawartość nowym kodem. Do tej lekcji nie potrzebujesz MariaDB.

## 2. Jeden akapit

Jak wyświetlić powitanie? Zapisz w pliku:

```php
<?php
echo "<p>Witaj na stronie turystów</p>";
?>
```

W przeglądarce zobaczysz:

> Witaj na stronie turystów

`echo` wysyła tekst. Tutaj tekst zawiera HTML, z którego przeglądarka wyświetla akapit.

Zmień powitanie na własne i odśwież stronę. Sprawdź, czy w przeglądarce pojawił się nowy tekst.

## 3. Dwa akapity

Jak pokazać dwa oddzielne teksty? Wykonaj dwie instrukcje `echo`:

```php
<?php
echo "<p>Poznajemy Islandię.</p>";
echo "<p>Zbieramy punkty.</p>";
?>
```

W przeglądarce pojawią się dwa akapity:

> Poznajemy Islandię.

> Zbieramy punkty.

Każde `echo` wysyła kolejny fragment HTML. Zmień tekst drugiego akapitu i sprawdź wynik.

## 4. Tekst ze zmiennej

Chcemy wyświetlić nazwę obiektu. Zamiast wpisywać ją w akapicie, zapiszmy ją w znanej już zmiennej.

```php
<?php
$nazwaObiektu = "Strokkur";

echo "<p>Obiekt: " . $nazwaObiektu . "</p>";
?>
```

W przeglądarce zobaczysz:

> Obiekt: Strokkur

Zmienna przechowuje nazwę. Kropka łączy fragment tekstu ze zmienną, a `echo` wysyła gotowy HTML.

Zmień wartość `$nazwaObiektu` na `"Hekla"`. Po odświeżeniu zobaczysz **Obiekt: Hekla**. Układ wysyłanego akapitu pozostał taki sam.

## 5. Lista z kilku instrukcji echo

Chcemy pokazać trzy obiekty jako listę. Każdy obiekt będzie osobnym elementem.

```php
<?php
echo "<ul>";

echo "<li>Strokkur</li>";
echo "<li>Skogafoss</li>";
echo "<li>Hekla</li>";

echo "</ul>";
?>
```

W przeglądarce pojawi się lista:

- Strokkur
- Skogafoss
- Hekla

`ul` oznacza listę, a `li` jeden jej element. Pierwsze `echo` otwiera listę, trzy następne dodają elementy, a ostatnie ją zamyka.

Które instrukcje `echo` wykonujemy raz dla całej listy? Które tworzą poszczególne elementy? Pomyśl też, ile takich linii trzeba by napisać dla 100 obiektów.

## 6. Co otrzymuje przeglądarka?

PHP wykonuje się na serwerze. Przeglądarka otrzymuje gotowy HTML, a nie instrukcje PHP.

```text
PHP => HTML => przeglądarka
```

W pierwszym przykładzie PHP wysyła taki fragment HTML:

```html
<p>Witaj na stronie turystów</p>
```

Użyj w przeglądarce opcji „Pokaż źródło strony”. Zobaczysz znacznik `<p>` i tekst, ale nie zobaczysz instrukcji `echo`.

## 7. Ćwiczenia

Najpierw napisz kod samodzielnie. Potem uruchom plik przez `localhost` i sprawdź wynik.

### Ćwiczenie 1 - zmienna i echo

Utwórz zmienną `$panstwo` o wartości `"Islandia"`. Za pomocą `echo` wyświetl akapit z tekstem **Zwiedzamy: Islandia**.

Potem zmień tylko wartość zmiennej na `"Polska"`. Sprawdź, jaki tekst zobaczysz po odświeżeniu strony.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Połącz początek akapitu, zmienną `$panstwo` i koniec akapitu za pomocą kropek.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

```php
<?php
$panstwo = "Islandia";

echo "<p>Zwiedzamy: " . $panstwo . "</p>";
?>
```

Wynik: **Zwiedzamy: Islandia**. Po zmianie wartości zmiennej na `"Polska"` wynik brzmi **Zwiedzamy: Polska**.

</details>

### Ćwiczenie 2 - lista obiektów

Za pomocą `echo` utwórz listę z trzema elementami: **Strokkur**, **Skogafoss**, **Hekla**. Każdy obiekt ma być osobnym elementem listy.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Wyślij najpierw `<ul>`, potem trzy elementy `<li>`, a na końcu `</ul>`.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

```php
<?php
echo "<ul>";

echo "<li>Strokkur</li>";
echo "<li>Skogafoss</li>";
echo "<li>Hekla</li>";

echo "</ul>";
?>
```

W przeglądarce zobaczysz trzy elementy listy: Strokkur, Skogafoss i Hekla.

</details>

`echo` może wysłać jeden fragment HTML lub kilka kolejnych fragmentów. W następnej lekcji wykorzystamy to do wyświetlania danych pobranych z bazy.
