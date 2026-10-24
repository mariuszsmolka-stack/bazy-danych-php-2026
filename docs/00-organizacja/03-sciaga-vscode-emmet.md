---
title: Ściąga VS Code i Emmet - skróty przydatne na zajęciach
---

# Ściąga VS Code i Emmet - Windows

**Do czego służy?** Do szybkiego pisania HTML, wygodnej edycji plików PHP i korzystania z terminala w Visual Studio Code.

Skróty klawiszowe poniżej dotyczą **Windows i domyślnych ustawień VS Code**. Własna konfiguracja, układ klawiatury lub zainstalowane rozszerzenia mogą je zmienić.

## 1. Emmet - zamiast pisać całe znaczniki HTML

Emmet jest wbudowany w VS Code. Pozwala wpisać krótki zapis i rozwinąć go do kodu HTML. **Nie trzeba instalować dodatkowego rozszerzenia.**

Przykład: wpisz w pliku HTML `ul>li*3`, rozwiń skrót - otrzymasz listę z trzema elementami.

```html
<ul>
    <li></li>
    <li></li>
    <li></li>
</ul>
```

### Jak rozwinąć skrót?

1. Otwórz plik o rozszerzeniu `.html`.
2. Wpisz np. `ul>li*3`.
3. Wybierz propozycję **Emmet Abbreviation** z listy podpowiedzi i zaakceptuj ją, zwykle klawiszem `Enter`.
4. Jeśli chcesz rozwijać skróty bezpośrednio klawiszem `Tab`, włącz ustawienie `Emmet: Trigger Expansion On Tab`.

W ustawieniach JSON odpowiada za to:

```json
"emmet.triggerExpansionOnTab": true
```

To **jedno ustawienie wewnątrz istniejącego pliku `settings.json`**, a nie kompletny plik JSON. Bez zmiany ustawień możesz użyć palety poleceń `Ctrl+Shift+P` i wybrać **Emmet: Expand Abbreviation**.

### Najważniejsze znaki Emmeta

| Znak | Co oznacza? | Przykład |
| --- | --- | --- |
| `>` | Umieść element wewnątrz innego. | `ul>li` |
| `+` | Dodaj element obok, na tym samym poziomie. | `h2+p` |
| `*` | Powtórz element. | `li*3` |
| `.` | Nadaj klasę (`class`). | `section.galeria` |
| `#` | Nadaj identyfikator (`id`). | `section#galeria` |
| `{}` | Wstaw tekst do elementu. | `h2{Galeria}` |
| `[]` | Dodaj atrybut. | `a[href="islandia.php"]` |
| `$` | Kolejny numer podczas powtarzania. | `li.element$*3` |
| `()` | Zgrupuj fragmenty skrótu. | `(header>h1)+main+footer` |

### Przydatne skróty i otrzymywane elementy

| Wpisz w pliku HTML | Co powstanie? |
| --- | --- |
| `!` | Szkielet dokumentu HTML5 (m.in. `doctype`, `html`, `head`, `body`). |
| `h1{Zwiedzaj Islandię}` | Nagłówek `h1` z wpisanym tekstem. |
| `ul>li*3` | Jedna lista `ul`, a w niej trzy elementy `li`. |
| `ol>li*4` | Jedna numerowana lista z czterema elementami. |
| `aside>h3{Do zwiedzania}+ul>li*2` | Panel `aside` z nagłówkiem i listą dwóch elementów. |
| `section.galeria` | Element `section` z `class="galeria"`. |
| `main#tresc` | Element `main` z `id="tresc"`. |
| `a[href="obiekty.php?id=46"]{Strokkur}` | Odnośnik z adresem i tekstem „Strokkur”. |
| `img[src="Strokkur.jpg" alt="Strokkur"]` | Obraz z atrybutami `src` i `alt`. |
| `ul>li.element$*3` | Trzy elementy o klasach `element1`, `element2`, `element3`. |
| `details>summary{Podpowiedź}` | Element rozwijany z nagłówkiem „Podpowiedź”. |

**Pułapka - kolejność ma znaczenie:**

- `ul>li*3` - **jedna lista `ul`** zawierająca **trzy elementy `li`**.
- `li>ul*3` - **jeden element `li`** zawierający **trzy osobne listy `ul`**.

Aby zrobić zwykłą listę trzech elementów, użyj pierwszego zapisu. Sam skrót Emmeta nie sprawdza, czy wygenerowana struktura jest zgodna z wymaganiami zadania.

## 2. VS Code - skróty klawiszowe do codziennej pracy

### Pliki, wyszukiwanie i edycja

| Skrót Windows | Działanie |
| --- | --- |
| `Ctrl+S` | Zapisz bieżący plik. |
| `Ctrl+P` | Szybko otwórz plik z projektu po jego nazwie. |
| `Ctrl+Shift+P` lub `F1` | Otwórz paletę poleceń. |
| `Ctrl+Shift+E` | Pokaż panel plików (Explorer). |
| `Ctrl+B` | Pokaż lub ukryj panel boczny. |
| `Ctrl+F` | Znajdź tekst w bieżącym pliku. |
| `Ctrl+H` | Znajdź i zamień w bieżącym pliku. |
| `Ctrl+Shift+F` | Znajdź tekst w plikach całego projektu. |
| `Ctrl+G` | Przejdź do podanego numeru wiersza. |
| `Ctrl+/` | Skomentuj lub odkomentuj zaznaczone wiersze. |
| `Shift+Alt+F` | Sformatuj dokument, jeśli dostępny jest formatter dla danego języka. |
| `Alt+Up` / `Alt+Down` | Przenieś bieżący wiersz w górę lub w dół. |
| `Shift+Alt+Down` | Skopiuj bieżący wiersz poniżej. |
| `Ctrl+D` | Zaznacz kolejne wystąpienie bieżącego zaznaczenia. |
| `Ctrl+Space` | Wywołaj podpowiedzi edytora. |
| `Ctrl+K`, potem `Ctrl+S` | Otwórz ustawienia skrótów klawiszowych. |

### Terminal i praca z projektem

| Skrót Windows | Działanie |
| --- | --- |
| `` Ctrl+` `` | Pokaż lub ukryj zintegrowany terminal. |
| `` Ctrl+Shift+` `` | Utwórz nowy terminal. |
| `Ctrl+J` | Pokaż lub ukryj dolny panel. |
| `Ctrl+Shift+M` | Otwórz panel błędów i ostrzeżeń (Problems). |
| `Ctrl+Shift+V` | Otwórz podgląd pliku Markdown. |

Znak **backtick** (odwrócony apostrof), a nie zwykły apostrof `'`. Jeżeli na Twojej klawiaturze skrót nie działa, użyj menu **Terminal => New Terminal** albo palety poleceń i polecenia **View: Toggle Terminal**.

Samo otwarcie terminala **nie uruchamia pliku PHP**. Skrypt możesz uruchomić poleceniem interpretera PHP z XAMPP, a stronę PHP w przeglądarce - przez lokalny serwer Apache.

### Dwa przydatne polecenia PHP w terminalu PowerShell

Sprawdzenie składni pliku bez wykonywania programu:

```powershell
C:\xampp\php\php.exe -l index.php
```

Wykonanie skryptu PHP w terminalu:

```powershell
C:\xampp\php\php.exe index.php
```

Uruchamiaj je w katalogu, w którym znajduje się `index.php`. Aby przetestować stronę z PHP i HTML przez `http://localhost/...`, uruchom Apache w XAMPP i otwórz właściwy adres w przeglądarce.

## 3. Trzy krótkie przykłady praktyczne

**Przykład 1:** chcesz utworzyć listę czterech nazw wodospadów. W pliku HTML wpisz `ol>li*4` i rozwiń Emmet.

**Przykład 2:** chcesz wstawić odnośnik do szczegółów obiektu. Wpisz `a[href="obiekty.php?id=46"]{Strokkur}` i rozwiń Emmet.

**Przykład 3:** po zmianie pliku PHP chcesz upewnić się, że nie brakuje średnika lub nawiasu. Zapisz plik przez `Ctrl+S`, otwórz terminal i wykonaj `php.exe -l` z nazwą pliku.

## 4. Gdzie szukać pełnej listy?

- [Emmet w Visual Studio Code - dokumentacja](https://code.visualstudio.com/docs/languages/emmet).
- [Emmet - składnia skrótów](https://docs.emmet.io/abbreviations/syntax/).
- [VS Code - domyślne skróty klawiszowe](https://code.visualstudio.com/docs/reference/default-keybindings).
- [VS Code - terminal](https://code.visualstudio.com/docs/terminal/getting-started).

**Powiązane materiały:** [Lekcja 1 - podstawy PHP]({{ '/01-podstawy-php/01-podstawy-php.html' | relative_url }}) · [HTML - portal Islandii]({{ '/06-html-css-dodatkowe/01-html-portal-islandii.html' | relative_url }}).
