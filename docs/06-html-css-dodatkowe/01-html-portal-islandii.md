---
title: HTML - szkielet portalu Islandii
---

# HTML - budujemy szkielet portalu Islandii

> Materiał dodatkowy dla uczniów zainteresowanych samodzielnym ćwiczeniem HTML. Nie zastępuje lekcji SQL i PHP.

**Cel:** po przeczytaniu tego materiału umiesz rozpoznać części strony w arkuszu INF.03 i przygotować strukturę dwóch podstron portalu. Użyjemy prostych znaczników, które będą potrzebne, gdy do strony dodamy PHP.

[Pobierz wszystkie pliki przykładów (ZIP)](portal-islandii-html-css.zip).

Przygotowaliśmy także [gotowy podgląd galerii](przyklady/islandia.html) i [podgląd strony szczegółów](przyklady/obiekty.html). Możesz otworzyć oba przykłady w przeglądarce.

Zdjęcia nie są publikowane w tym kursie ani w ZIP-ie przykładów. [Pobierz oryginalne załączniki egzaminacyjne](https://arkusze.pl/zawodowy/inf03-2026-czerwiec-egzamin-zawodowy-praktyczny-zalaczniki.zip). Po rozpakowaniu umieść dziewięć zdjęć obok plików HTML i CSS, zachowując ich nazwy. Podgląd online pokazuje układ i style bez fotografii; pełny podgląd ze zdjęciami uruchom lokalnie.

## 1. Najpierw zrozum układ

Arkusz **INF.03-01-26.06-SG** wymaga czterech obszarów: nagłówka, bloku bocznego, obszaru głównego i stopki. W obszarze głównym znajduje się sekcja (`section`). W tym zadaniu takie znaczniki mają znaczenie: są wskazane w poleceniu i oceniane w kluczu.

```text
+-----------------------------------+----------------+
| header                            |                |
| Zwiedzaj Islandię                 | aside          |
+-----------------------------------+ Do zwiedzania  |
| main                              |                |
| Galeria / Opis miejsca            | - Wodospady    |
|   +---------------------------+   | - Siedliska   |
|   | section                   |   |   zwierząt    |
|   | zdjęcia lub opis          |   |                |
|   +---------------------------+   |                |
+-----------------------------------+----------------+
| footer                                             |
| Autor: numer zdającego                             |
+----------------------------------------------------+
```

**HTML opisuje, co znajduje się na stronie. CSS decyduje, gdzie to się pojawi i jak będzie wyglądać.** Dlatego najpierw tworzymy strukturę, a dopiero potem styl.

### Kiedy stosować znacznik?

| Znacznik | Zadanie na stronie | W naszym portalu |
| --- | --- | --- |
| `<header>` | nagłówek witryny | nazwa portalu i link do strony głównej |
| `<aside>` | treść poboczna | dwie listy miejsc do zwiedzania |
| `<main>` | najważniejsza treść strony | galeria albo opis miejsca |
| `<section>` | wydzielona część głównej treści | miniatury lub dane obiektu |
| `<footer>` | stopka | linia i napis „Autor: ...” |

Nie zastępuj tych znaczników przypadkowymi `<div>`, skoro zadanie wyraźnie wymaga semantycznego HTML5.

## 2. Minimalny poprawny dokument HTML

```html
<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Islandia</title>
    <link rel="stylesheet" href="styl.css">
</head>
<body>
    <!-- przygotował Mariusz Smółka -->
    <h1>Zwiedzaj Islandię</h1>
</body>
</html>
```

Omówmy elementy, które naprawdę będą potrzebne:

- `<!DOCTYPE html>` wskazuje współczesny tryb HTML.
- `lang="pl"` deklaruje polski język treści.
- `charset="UTF-8"` pozwala prawidłowo zapisywać m.in. `ą`, `ę`, `ł` i nazwy islandzkie.
- `<title>` określa tytuł karty przeglądarki - w arkuszu musi być **Islandia**.
- `<link ... href="styl.css">` podłącza **zewnętrzny** arkusz stylów. Nie wstawiamy tutaj reguł CSS.
- `<body>` zawiera treść widoczną dla odbiorcy.

Komentarz autorski w HTML jest niewidoczny na stronie. Można go zobaczyć w kodzie źródłowym. **To informacja o autorstwie opracowania, nie zabezpieczenie przed kopiowaniem.**

## 3. Nagłówek z odnośnikiem

W arkuszu cały tekst „Zwiedzaj Islandię” ma prowadzić do strony głównej portalu.

```html
<header>
    <h1><a href="islandia.php">Zwiedzaj Islandię</a></h1>
</header>
```

`<h1>` oznacza główny nagłówek strony. `<a>` tworzy odnośnik, a `href` podaje plik, który ma się otworzyć.

**W pliku demonstracyjnym** link prowadzi do `islandia.html`, ponieważ jeszcze nie uruchamiamy PHP. **W rozwiązaniu egzaminacyjnym** będzie prowadził do `islandia.php`. To celowa różnica.

## 4. Blok boczny - lista w liście

Arkusz wymaga **jednej listy punktowanej** (`ul`) z dwoma elementami (`li`), a wewnątrz obu elementów - **list numerowanych** (`ol`).

```html
<aside>
    <h3>Do zwiedzania</h3>
    <ul>
        <li>Wodospady:
            <ol>
                <li>Skogafoss</li>
                <li>Seljalandsfoss</li>
                <li>Godafoss</li>
                <li>Dettifoss</li>
            </ol>
        </li>
        <li>Siedliska zwierząt:
            <ol>
                <li>Fuglaskoðunarhús</li>
                <li>Siedlisko wielorybów</li>
            </ol>
        </li>
    </ul>
</aside>
```

**Dlaczego `ol` jest wewnątrz `li`?** Bo „Wodospady:” jest jednym elementem listy głównej, a cztery nazwy są jego podlistą. Gdyby umieścić `ol` poza `li`, powstałaby inna struktura niż wymagana w zadaniu.

W podglądzie nazwy wpisaliśmy na stałe, aby widzieć wynik. W pełnej wersji **skrypty 1 i 2 mają pobierać te nazwy z bazy danych** - listy nie mogą pozostać wpisane ręcznie. Taką wersję zbudujemy na zajęciach PHP.

## 5. Główna część i sekcja

Na stronie galerii:

```html
<main>
    <h2>Galeria</h2>
    <section>
        <!-- Tutaj skrypt PHP wygeneruje miniatury -->
    </section>
</main>
```

Na stronie szczegółów:

```html
<main>
    <h2>Opis miejsca</h2>
    <section>
        <!-- Tutaj PHP pokaże dane wybranego obiektu -->
    </section>
</main>
```

**Uwaga:** powyższe komentarze wskazują jedynie miejsce przyszłego kodu PHP. Nie są jeszcze rozwiązaniem. W gotowych plikach demonstracyjnych zawartość sekcji wypełniliśmy przykładowymi danymi.

## 6. Obraz, tekst alternatywny i dymek

Przykład miniatury z arkusza:

```html
<img class="miniatury"
     src="Strokkur.jpg"
     alt="Strokkur"
     title="Strokkur">
```

Każdy atrybut spełnia inną funkcję:

| Atrybut | Znaczenie |
| --- | --- |
| `src` | wskazuje plik zdjęcia |
| `alt` | opisuje obraz, także gdy zdjęcie się nie załaduje; pomaga czytnikom ekranu |
| `title` | może wyświetlać dodatkową wskazówkę po najechaniu kursorem |
| `class="miniatury"` | pozwala nadać obrazowi styl w pliku CSS |

Po pobraniu umieść wszystkie pliki zdjęć **w tym samym katalogu co HTML**, aby wystarczała sama nazwa pliku. Wielkość liter ma znaczenie na serwerach działających pod Linuksem: `Strokkur.jpg` i `strokkur.jpg` nie muszą oznaczać tego samego pliku.

## 7. Miniatura jako odnośnik z GET

```html
<a href="obiekty.php?id=46">
    <img class="miniatury"
         src="Strokkur.jpg"
         alt="Strokkur"
         title="Strokkur">
</a>
```

Po kliknięciu przeglądarka otworzy `obiekty.php` i przekaże parametr `id=46`. Właśnie to ćwiczyliśmy w **lekcji 9 o GET**.

W statycznym podglądzie używamy adresu `obiekty.html?id=46`, który pokazuje sposób zapisu URL, ale **HTML bez PHP nie odczytuje tego identyfikatora i nie zmienia automatycznie treści strony**. Strona demonstracyjna szczegółów pokazuje zawsze Godafoss. Dopiero wersja PHP wybierze właściwy rekord z MariaDB.

## 8. Strona szczegółów - właściwe nagłówki

Wewnątrz `section` w docelowej aplikacji mają znaleźć się:

```html
<img src="godafoss.jpg" alt="Godafoss">
<h2>Godafoss</h2>
<h3>wodospad</h3>
<p>wysokość: 30</p>
<p>Opis obiektu pobrany z bazy danych.</p>
```

Oprócz wspólnego nagłówka „Opis miejsca” w `<main>` arkusz wymaga **nazwy miejsca w `h2`**, **rodzaju w `h3`**, a cechy i opisu w paragrafach. Godafoss służy tylko jako przykład wyniku. W rozwiązaniu egzaminacyjnym wszystko w tej sekcji ma powstać na podstawie zapytania SQL.

## 9. Stopka

```html
<footer>
    <hr>
    <p>Autor: 00000000000</p>
</footer>
```

`<hr>` tworzy linię. Na **prawdziwym egzaminie** zera trzeba zastąpić numerem zdającego zgodnie z poleceniem. W przygotowanym przykładzie nie umieszczamy danych konkretnej osoby.

## 10. Dwa gotowe pliki - sprawdź strukturę

- [Otwórz kompletny przykład `islandia.html`](przyklady/islandia.html)
- [Otwórz kompletny przykład `obiekty.html`](przyklady/obiekty.html)
- [Otwórz `styl.css`](przyklady/styl.css)

W każdym pliku HTML jest ukryty w kodzie komentarz `przygotował Mariusz Smółka`. W przykładach zdjęcia, nazwy i listy są stałe - **to demonstracja warstwy HTML/CSS, nie rozwiązanie PHP**.

## 11. Ćwiczenia

### Ćwiczenie 1 - poznaj strukturę

Wskaż w źródle `islandia.html` pięć znaczników semantycznych, które odpowiadają obszarom zadania.

<details markdown="1">
<summary>Podpowiedź</summary>

Pomyśl o nagłówku, bloku bocznym, głównym, jego sekcji i stopce.

</details>
<details markdown="1">
<summary>Rozwiązanie</summary>

`header`, `aside`, `main`, `section`, `footer`.

</details>

### Ćwiczenie 2 - zmień nagłówek

Na kopii `islandia.html` zamień napis „Galeria” na „Galeria obiektów”, nie zmieniając poziomu nagłówka.

<details markdown="1">
<summary>Podpowiedź</summary>

Poszukaj `h2` znajdującego się bezpośrednio wewnątrz `main`.

</details>
<details markdown="1">
<summary>Rozwiązanie</summary>

```html
<h2>Galeria obiektów</h2>
```

Wersja demonstracyjna może mieć taką zmianę. Wersja egzaminacyjna musi jednak zachować oryginalne polecenie „Galeria”.

</details>

### Ćwiczenie 3 - dymek zdjęcia

Znajdź obraz `Strokkur.jpg` i ustaw wartość `title` na „Gejzer Strokkur”, pozostawiając `alt="Strokkur"`.

<details markdown="1">
<summary>Podpowiedź</summary>

W tym zadaniu zmienia się tylko jeden atrybut obrazu.

</details>
<details markdown="1">
<summary>Rozwiązanie</summary>

```html
<img class="miniatury" src="Strokkur.jpg" alt="Strokkur" title="Gejzer Strokkur">
```

Na egzaminie `title` ma pochodzić z pola `nazwa`, dlatego tutaj zmieniamy go wyłącznie ćwiczeniowo.

</details>

### Ćwiczenie 4 - dodaj obraz do galerii

W kopii podglądu dodaj w sekcji galerii kolejny obraz `hekla.jpg` z tekstem alternatywnym i tytułem „Hekla”.

<details markdown="1">
<summary>Podpowiedź</summary>

Skopiuj strukturę istniejącego obrazu i zmień nazwę pliku oraz opisy.

</details>
<details markdown="1">
<summary>Rozwiązanie</summary>

```html
<img class="miniatury" src="hekla.jpg" alt="Hekla" title="Hekla">
```

W pełnym portalu PHP zdjęcia będą generowane automatycznie i nie będzie potrzeby ręcznego dopisywania każdego z nich.

</details>

### Ćwiczenie 5 - przenosimy GET do linku

Zbuduj odnośnik zawierający zdjęcie `Godafoss` i prowadzący do docelowego adresu `obiekty.php?id=53`.

<details markdown="1">
<summary>Podpowiedź</summary>

Znacznik `a` powinien obejmować znacznik `img`.

</details>
<details markdown="1">
<summary>Rozwiązanie</summary>

```html
<a href="obiekty.php?id=53"><img class="miniatury" src="godafoss.jpg" alt="Godafoss" title="Godafoss"></a>
```

</details>

### Ćwiczenie 6 - przygotuj sekcję do PHP

W osobnej kopii `obiekty.html` usuń ze środka `section` przykładowy obraz i opis, ale zachowaj całe `<section>...</section>`. To miejsce ma być później uzupełniane skryptem PHP.

<details markdown="1">
<summary>Podpowiedź</summary>

Nie usuwaj `main`, jego nagłówka ani znaczników otwierającego i zamykającego `section`.

</details>
<details markdown="1">
<summary>Rozwiązanie</summary>

```html
<main>
    <h2>Opis miejsca</h2>
    <section>
    </section>
</main>
```

Tak przygotowana sekcja może być później wypełniana danymi pobranymi z MariaDB.

</details>

## 12. Lista kontroli przed zakończeniem

- [ ] `lang="pl"`, `UTF-8`, tytuł `Islandia` i połączenie z `styl.css`.
- [ ] Nagłówek, blok boczny, główny, sekcja i stopka.
- [ ] Jeden `ul` z dwoma elementami i zagnieżdżone `ol`.
- [ ] Link w `h1` do strony głównej.
- [ ] Obrazy z `alt`, `title` i klasą `miniatury` na stronie galerii.
- [ ] `h2`, `h3` i paragrafy na stronie szczegółów.
- [ ] Linia i informacja o autorze/numerze zdającego w stopce.

**Powiązanie z kryteriami egzaminacyjnymi:** R.2.1–R.2.9 oraz R.3.3–R.3.5. Część kryteriów wymaga działających skryptów PHP; wersja demonstracyjna HTML jeszcze ich nie spełnia.

[Dalej: CSS - wygląd portalu Islandii](02-css-portal-islandii.html) | [Materiały dodatkowe - spis](index.html)
