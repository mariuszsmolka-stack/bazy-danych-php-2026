---
title: CSS - wygląd portalu Islandii
---

# CSS - odtwarzamy wygląd portalu Islandii

> Materiał dodatkowy. Na lekcjach SQL i PHP korzystamy z gotowego arkusza stylów; tutaj możesz zrozumieć i samodzielnie zmodyfikować jego reguły.

**Cel:** uzyskać wygląd portalu z arkusza INF.03-01-26.06-SG, wiedzieć, jakie reguły CSS odpowiadają poszczególnym cechom oraz potrafić skontrolować wynik w przeglądarce. Nie uczymy tutaj PHP.

[Pobierz wszystkie pliki przykładów (ZIP)](portal-islandii-html-css.zip).

[Otwórz podgląd galerii z gotowym stylem](przyklady/islandia.html) i [podgląd opisu obiektu](przyklady/obiekty.html).

Zdjęcia wykorzystane w zadaniu pobierz z [oryginalnych załączników egzaminacyjnych](https://arkusze.pl/zawodowy/inf03-2026-czerwiec-egzamin-zawodowy-praktyczny-zalaczniki.zip). Po rozpakowaniu umieść je w katalogu z plikami HTML i CSS, zachowując oryginalne nazwy.

## 1. HTML jest konstrukcją, CSS jest wyglądem

W części HTML powstały `header`, `aside`, `main`, `section`, `footer`. Domyślnie przeglądarka wyświetliłaby je w swoim standardowym układzie. Arkusz CKE wymaga określonych rozmiarów, kolorów, rozmieszczenia i zachowania miniatur.

**CSS zapisujemy w jednym zewnętrznym pliku `styl.css`.** Obie podstrony korzystają z tej samej wersji arkusza.

W kodzie HTML łączy go wiersz:

```html
<link rel="stylesheet" href="styl.css">
```

Jeżeli arkusz nie działa, w pierwszej kolejności sprawdź nazwę pliku, lokalizację i atrybut `href`.

## 2. Jak czytać regułę CSS?

```css
aside {
    background-color: PaleTurquoise;
    width: 25%;
}
```

- `aside` to selektor - wskazuje element, który ma zostać sformatowany.
- `background-color` jest właściwością, a `PaleTurquoise` jej wartością.
- Średnik `;` kończy deklarację, a klamry obejmują całą regułę.

Zapis `header, main` pozwala nadać te same właściwości obu elementom. Zapis `.miniatury` wybiera elementy z `class="miniatury"` - kropka jest tutaj istotna.

## 3. Wspólna czcionka i model pudełkowy

```css
* {
    font-family: "Comic Sans MS", sans-serif;
    box-sizing: border-box;
}
```

Gwiazdka `*` wybiera wszystkie elementy. `Comic Sans MS` jest pierwszą wskazaną czcionką, a `sans-serif` czcionką zastępczą - tak wymaga arkusz. Napis w cudzysłowie oznacza nazwę kroju zawierającą spacje.

`box-sizing: border-box` jest dodatkiem technicznym: szerokość i wysokość uwzględniają obramowanie oraz padding. Pomaga utrzymać zadane wymiary bez przypadkowego nakładania się bloków. Nie jest osobnym wymaganiem punktowanym w arkuszu.

**Uwaga:** jeśli komputer nie ma Comic Sans MS, przeglądarka wybierze czcionkę zastępczą. To nie oznacza, że sam zapis reguły jest błędny.

## 4. Jak uzyskać układ zgodny z rysunkiem?

W naszym przykładzie zastosujemy prosty układ oparty na `float` i `clear`. To jedna z metod akceptowanych w zasadach oceniania; można użyć także flex lub grid, jeśli działa poprawnie.

```css
header,
main {
    width: 70%;
    text-align: center;
}

header {
    float: left;
}

aside {
    float: right;
    width: 25%;
}

main {
    float: left;
}

footer {
    clear: both;
}
```

**Dlaczego tak?** Nagłówek i część główna mają zajmować 70% szerokości po lewej, panel boczny 25% po prawej. Pozostałe miejsce daje odstęp między kolumnami. `clear: both` sprawia, że stopka zaczyna się pod obiema kolumnami, a nie pomiędzy nimi.

`text-align: center` wyrównuje tekst w `header` i `main`, zgodnie z arkuszem.

Nie myl `float: right` (pozycja bloku) z `text-align: right` (wyrównanie tekstu wewnątrz).

## 5. Kolor i zaokrąglenia

```css
header,
aside {
    background-color: PaleTurquoise;
    border-radius: 20px;
}
```

Wspólna reguła daje turkusowe tło oraz zaokrąglone rogi tylko nagłówkowi i blokowi bocznemu. Nie dodajemy tego tła do `main` ani `footer`, bo arkusz tego nie wymaga.

## 6. Wymiary nagłówka i bloku bocznego

```css
header {
    float: left;
    height: 100px;
    padding: 2%;
}

aside {
    float: right;
    width: 25%;
    height: 700px;
    line-height: 2;
}
```

`height` określa wysokość. `padding` to przestrzeń **wewnątrz** elementu. `line-height: 2` ustala dwukrotną wysokość linii względem rozmiaru tekstu - to nie są 2 piksele.

Porównaj:

| Właściwość | Co zmienia? |
| --- | --- |
| `width: 25%` | szerokość bloku względem jego kontenera |
| `height: 700px` | wysokość bloku bocznego |
| `padding: 2%` | wewnętrzny odstęp w nagłówku |
| `line-height: 2` | odległość między wierszami tekstu |

## 7. Sekcja z przewijaniem

```css
section {
    border: 1px dashed DimGray;
    margin: 10px 50px;
    height: 400px;
    overflow: auto;
}
```

Ta krótka reguła spełnia kilka wymagań jednocześnie:

- `1px` to grubość obramowania.
- `dashed` oznacza linię kreskowaną.
- `DimGray` jest kolorem obramowania.
- `margin: 10px 50px` oznacza **góra i dół 10px, lewo i prawo 50px**.
- `height: 400px` nadaje sekcji określoną wysokość.
- `overflow: auto` pokazuje paski przewijania wtedy, gdy treść nie mieści się wewnątrz bloku.

W szczególności nie zmieniaj `overflow: auto` na `hidden` - wtedy część zdjęć lub opisów może stać się niedostępna.

## 8. Klasa miniatury i efekt po najechaniu

```css
.miniatury {
    height: 200px;
    padding: 10px;
    opacity: 0.8;
    transition: opacity 1s;
}

.miniatury:hover {
    opacity: 1;
}
```

`height: 200px` ustala wysokość obrazu. `padding: 10px` tworzy odstęp wewnętrzny. `opacity: 0.8` powoduje lekką przezroczystość. Po najechaniu kursorem `:hover` zmienia ją na `1` (pełna nieprzezroczystość).

`transition: opacity 1s` sprawia, że zmiana nie jest natychmiastowa, lecz trwa jedną sekundę.

Zwróć uwagę, że `:hover` zawiera **dwukropek**, a selektor klasy zaczyna się od **kropki**.

## 9. Stopka - tylko odstęp od góry

```css
footer {
    clear: both;
    padding-top: 10px;
}
```

W arkuszu dla stopki podano **tylko górny padding**. `clear: both` odpowiada za poprawne umieszczenie stopki pod kolumnami - jest dodatkiem realizującym układ strony.

## 10. Pełny arkusz stylów `styl.css`

Poniższy kod jest kompletną wersją gotowego arkusza. Jest zgodny z wymaganymi cechami stylistycznymi zadania, a `box-sizing`, `float` i `clear` odpowiadają za poprawny układ bloków.

```css
/* przygotował Mariusz Smółka */

* {
    font-family: "Comic Sans MS", sans-serif;
    box-sizing: border-box;
}

header,
main {
    width: 70%;
    text-align: center;
}

header,
aside {
    background-color: PaleTurquoise;
    border-radius: 20px;
}

header {
    float: left;
    height: 100px;
    padding: 2%;
}

aside {
    float: right;
    width: 25%;
    height: 700px;
    line-height: 2;
}

main {
    float: left;
}

footer {
    clear: both;
    padding-top: 10px;
}

section {
    border: 1px dashed DimGray;
    margin: 10px 50px;
    height: 400px;
    overflow: auto;
}

.miniatury {
    height: 200px;
    padding: 10px;
    opacity: 0.8;
    transition: opacity 1s;
}

.miniatury:hover {
    opacity: 1;
}
```

Gotowy plik: [styl.css](przyklady/styl.css).

## 11. Jak sprawdzić działanie CSS?

1. Uruchom [galerię](przyklady/islandia.html).
2. Sprawdź, czy panel boczny jest po prawej, a stopka pod obiema kolumnami.
3. Najedź na obraz i sprawdź, czy miniatura przez jedną sekundę staje się wyraźniejsza.
4. Przewiń zawartość sekcji - pasek powinien pojawić się przy przepełnieniu.
5. Otwórz narzędzia deweloperskie przeglądarki (zwykle `F12`) i wybierz jeden z obrazów; sprawdź, czy ma klasę `miniatury`.

W przypadku innej rozdzielczości rozmiary i proporcje strony mogą wyglądać inaczej niż na ilustracji egzaminacyjnej. Weryfikuj więc **konkretne wymagane właściwości**, a nie wyłącznie podobieństwo wizualne.

## 12. Ćwiczenia

### Ćwiczenie 1 - rozpoznaj selektor

Wskaż regułę, która ustawia kolor tła zarówno `header`, jak i `aside`.

<details markdown="1">
<summary>Podpowiedź</summary>

Szukaj selektorów rozdzielonych przecinkiem.

</details>
<details markdown="1">
<summary>Rozwiązanie</summary>

```css
header,
aside {
    background-color: PaleTurquoise;
    border-radius: 20px;
}
```

</details>

### Ćwiczenie 2 - zmiana szerokości

Na kopii `styl.css` ustaw próbnie szerokość `aside` na `20%`. Obserwuj, jak zmienia się ilość miejsca między kolumnami. Następnie przywróć wartość wymaganą w arkuszu.

<details markdown="1">
<summary>Podpowiedź</summary>

Zmień jedną deklarację w selektorze `aside`.

</details>
<details markdown="1">
<summary>Rozwiązanie</summary>

Eksperyment: `width: 20%;`. W arkuszu: `width: 25%;`.

</details>

### Ćwiczenie 3 - margin kontra padding

Wyjaśnij, dlaczego `margin: 10px 50px` zmienia odstęp sekcji od innych elementów, a `padding: 10px` w `.miniatury` zmienia przestrzeń wewnątrz obrazu.

<details markdown="1">
<summary>Podpowiedź</summary>

Pomyśl o granicy elementu: poza nią jest margines, a wewnątrz - padding.

</details>
<details markdown="1">
<summary>Rozwiązanie</summary>

`margin` to odstęp zewnętrzny wokół elementu, a `padding` to odstęp wewnętrzny, pomiędzy zawartością a granicą elementu.

</details>

### Ćwiczenie 4 - efekt miniatury

Na kopii arkusza zmień chwilowo `opacity` z `0.8` na `0.5`, a następnie przywróć wartość z arkusza. Sprawdź, czy efekt `:hover` nadal działa.

<details markdown="1">
<summary>Podpowiedź</summary>

Nie zmieniaj wartości w `:hover` - zostaw tam `opacity: 1`.

</details>
<details markdown="1">
<summary>Rozwiązanie</summary>

W wariancie testowym `.miniatury { opacity: 0.5; }`, w wersji egzaminacyjnej `.miniatury { opacity: 0.8; }`. `:hover` ma wartość `1`.

</details>

### Ćwiczenie 5 - napraw brak przewijania

W przeglądarce nie widać dolnych zdjęć, ponieważ ktoś ustawił `overflow: hidden` dla `section`. Popraw jedną deklarację.

<details markdown="1">
<summary>Podpowiedź</summary>

Wymagany jest pasek przewijania w razie przepełnienia sekcji.

</details>
<details markdown="1">
<summary>Rozwiązanie</summary>

```css
section {
    overflow: auto;
}
```

To fragment poprawki; zachowaj pozostałe deklaracje sekcji.

</details>

### Ćwiczenie 6 - kontrola według klucza

Otwórz `styl.css` i znajdź deklaracje odpowiadające trzem wymaganiom: sekcja ma 400px wysokości, bok ma 700px, a przejście miniatury trwa jedną sekundę.

<details markdown="1">
<summary>Podpowiedź</summary>

Szukaj odpowiednio `section`, `aside` i `.miniatury`.

</details>
<details markdown="1">
<summary>Rozwiązanie</summary>

- `section` - `height: 400px;`
- `aside` - `height: 700px;`
- `.miniatury` - `transition: opacity 1s;`

</details>

## 13. Kryteria egzaminacyjne - kontrola

| Kryterium z klucza | Wymaganie | Gdzie w CSS? |
| --- | --- | --- |
| R.4.1 | Czcionka Comic Sans MS / sans-serif | `*` |
| R.4.2 | Tło PaleTurquoise w nagłówku i bloku bocznym | `header, aside` |
| R.4.3 | Szerokości 70% / 25% | `header, main` i `aside` |
| R.4.4 | Wysokości 100 / 700 / 400px oraz padding nagłówka 2% i górny stopki 10px | `header`, `aside`, `section`, `footer` |
| R.4.5 | Wyśrodkowanie tekstu w nagłówku i części głównej | `header, main` |
| R.4.6 | Kreskowane obramowanie sekcji, odstępy 10px / 50px, przewijanie | `section` |
| R.4.7 | Zaokrąglenia 20px | `header, aside` |
| R.4.8 | Interlinia 2 | `aside` |
| R.4.9 | Wysokość miniatur 200px, padding 10px, opacity 0.8, tranzycja 1s | `.miniatury` |
| R.4.10 | Zmiana opacity na 1 po najechaniu | `.miniatury:hover` |

Powyższe numery i wymagania odpowiadają kryteriom oceniania CKE dla rezultatu R.4. **Aby zdobyć punkty, właściwości muszą działać na stronie**, a nie tylko znajdować się w pliku CSS.

[Wróć do HTML](01-html-portal-islandii.html) | [Materiały dodatkowe - spis](index.html)
