---
title: Ściąga INF.03 - znaczniki HTML i płynne zmiany CSS
---

# Ściąga INF.03 - HTML i CSS z arkusza egzaminacyjnego

**Zakres:** arkusz praktyczny **INF.03-01-26.06-SG**, strona 6, **tabela 3 (CSS transition Property)** i **tabela 4 (Semantic Elements in HTML)**.

Ta ściąga obejmuje elementy wymienione w obu tabelach. Nie jest wykazem wszystkich znaczników HTML ani właściwości CSS. Na egzaminie kieruj się tabelami znajdującymi się w swoim arkuszu - ich zawartość może być inna.

## 1. Który znacznik wybrać do danej części strony?

W HTML różne znaczniki wskazują role części strony. Na przykład `<header>` oznacza nagłówek, a `<footer>` stopkę. Takie znaczniki nazywamy semantycznymi. Ich wykaz znajduje się w tabeli 4 arkusza INF.03. Dzięki nim programista, przeglądarka i czytnik ekranu mogą rozpoznać rolę danej części.

| Znacznik z arkusza | Znaczenie | Kiedy go użyć? |
| --- | --- | --- |
| `<article>` | Samodzielna, niezależna treść | Artykuł lub wpis, który może być zrozumiały osobno. |
| `<aside>` | Treść poboczna względem głównej | Panel boczny z dodatkowymi informacjami. |
| `<details>` | Szczegóły, które można rozwinąć i zwinąć | Ukrywane wyjaśnienie lub odpowiedź. |
| `<figcaption>` | Podpis do elementu `<figure>` | Podpis zdjęcia lub diagramu. |
| `<figure>` | Samodzielny element, np. ilustracja albo diagram | Obraz z podpisem. |
| `<footer>` | Stopka dokumentu albo sekcji | Informacje na dole strony. |
| `<header>` | Nagłówek dokumentu albo sekcji | Tytuł i wprowadzenie. |
| `<main>` | Główna zawartość strony | Najważniejsza treść dokumentu. |
| `<mark>` | Tekst wyróżniony jako istotny w danym kontekście | Podświetlone słowo. |
| `<nav>` | Obszar nawigacji | Menu z odnośnikami. |
| `<section>` | Wydzielona część tematyczna dokumentu | Galeria lub sekcja z opisem. |
| `<summary>` | Widoczny nagłówek elementu `<details>` | Tekst, który użytkownik klika, aby rozwinąć szczegóły. |
| `<time>` | Data lub czas | Oznaczenie daty i godziny w treści. |

**Nie myl:** `header` to nagłówek strony lub sekcji, a `main` to jej zasadnicza zawartość. `aside` jest częścią poboczną. `figure` może zawierać ilustrację, a `figcaption` jej podpis. `summary` stosujemy wewnątrz `details`.

### Krótkie przykłady

**Podział portalu turystycznego na obszary:**

```html
<header>Zwiedzaj Islandię</header>
<aside>Do zwiedzania</aside>
<main>
    <section>Galeria</section>
</main>
<footer>Autor: numer zdającego</footer>
```

Powyższy fragment pokazuje **role bloków**, a nie kompletną stronę egzaminacyjną. W arkuszu podano również wymagania dotyczące nagłówków, list, obrazów i odnośników.

**Rozwijane objaśnienie:**

```html
<details>
    <summary>Co to jest znacznik main?</summary>
    To obszar z główną treścią strony.
</details>
```

**Ilustracja z podpisem:**

```html
<figure>
    <img src="Strokkur.jpg" alt="Strokkur">
    <figcaption>Gejzer Strokkur na Islandii</figcaption>
</figure>
```

## 2. Właściwość transition - tabela 3

`transition` pozwala płynnie zmieniać wartość właściwości CSS, na przykład przez jedną sekundę.

Arkusz przedstawia zapis skrócony:

```css
transition: property duration timing-function delay;
```

Arkusz podaje też dwie osobne wartości ogólne: `initial` i `inherit`. Nie są one dodatkowymi czasami ani nazwami właściwości.

| Pozycja z arkusza | Do czego służy? | Przykładowa wartość |
| --- | --- | --- |
| `transition-property` | Wskazuje właściwość CSS objętą przejściem. | `opacity` |
| `transition-duration` | Określa czas trwania przejścia. | `1s` |
| `transition-timing-function` | Określa sposób zmiany wartości w czasie (krzywą tempa). | `ease` |
| `transition-delay` | Określa opóźnienie rozpoczęcia przejścia. | `0s` |
| `initial` | Przywraca wartość początkową właściwości CSS. | `transition: initial;` |
| `inherit` | Dziedziczy wartość właściwości CSS po elemencie nadrzędnym. | `transition: inherit;` |

Właściwości `transition-property`, `transition-duration`, `transition-timing-function` i `transition-delay` można zapisać osobno. `initial` oraz `inherit` są alternatywnymi wartościami ogólnymi CSS, więc nie dopisujemy ich po czasie trwania.

### Przykład odpowiadający zadaniu z Islandią

W arkuszu miniatura ma mieć przezroczystość `0.8`, a po najechaniu kursorem - `1`. Zmiana powinna trwać jedną sekundę.

```css
.miniatury {
    opacity: 0.8;
    transition: opacity 1s;
}

.miniatury:hover {
    opacity: 1;
}
```

Przeczytaj ten kod w trzech krokach:

1. Normalnie miniatura ma `opacity: 0.8`.
2. `transition: opacity 1s` powoduje płynną zmianę właściwości `opacity` przez jedną sekundę.
3. Po wskazaniu kursorem reguła `:hover` zmienia `opacity` na `1`.

Równoważny, bardziej szczegółowy zapis samego przejścia:

```css
.miniatury {
    transition-property: opacity;
    transition-duration: 1s;
    transition-timing-function: ease;
    transition-delay: 0s;
}
```

Ten drugi fragment pokazuje składniki `transition`. Nie zawiera reguł ustalających początkową i końcową przezroczystość.

## 3. Co zapamiętać przed ćwiczeniem?

- `section` oznacza część tematyczną, a `main` - główną część strony.
- `details` razem z `summary` tworzą rozwijany element.
- `figure` i `figcaption` służą do powiązania ilustracji z podpisem.
- `transition-property` wskazuje **co** się zmienia, a `transition-duration` - **jak długo**.
- `transition-timing-function` ustala tempo, a `transition-delay` opóźnienie startu.
- `initial` i `inherit` nie są zamiennikami nazwy właściwości ani czasu w `transition`.

**Powiązane materiały:** [HTML - szkielet portalu Islandii]({{ '/06-html-css-dodatkowe/01-html-portal-islandii.html' | relative_url }}) · [CSS - wygląd portalu Islandii]({{ '/06-html-css-dodatkowe/02-css-portal-islandii.html' | relative_url }}) · [Ściąga funkcji PHP INF.03]({{ '/00-organizacja/02-sciaga-php-inf03.html' | relative_url }}).

**Źródło zakresu:** CKE, arkusz praktyczny **INF.03-01-26.06-SG**, strona 6, tabele 3 i 4.
