---
title: Od zadania do programu - jak zaplanować rozwiązanie INF.03?
---

# Od zadania do programu - jak zaplanować rozwiązanie INF.03?

Masz przed sobą kilka stron poleceń. Znasz SQL i podstawy PHP, ale nie wiesz, od czego zacząć. Zacznij od podziału pracy. Nie musisz od razu pisać całego programu.

W tym rozdziale zaplanujesz portal turystyczny Islandii z arkusza **INF.03-01-26.06-SG**. Pracujesz w XAMPP, phpMyAdmin i VS Code. Korzystasz z bazy `Islandia` i proceduralnych funkcji MySQLi.

## 1. Duże zadanie to kilka małych zadań

W arkuszu są polecenia dotyczące bazy, zapytań i strony. Czytane naraz mogą wydawać się trudne. Oddziel je od siebie.

Zamiast myśleć „muszę zrobić portal”, wybierz pierwszy krok: „zaimportuję bazę”. Potem sprawdź, czy są w niej tabele. Dopiero wtedy przejdź do zapytania.

Każdy mały krok ma wynik, który możesz zobaczyć. To pomaga ustalić, gdzie pojawił się błąd.

## 2. Trzy części aplikacji

| Część | Co robi? | Przykład |
| --- | --- | --- |
| Baza danych | Przechowuje informacje o obiektach. | W tabeli `obiekty` znajduje się nazwa Strokkur i jego opis. |
| PHP | Pobiera dane i tworzy zawartość strony. | Wybiera obiekt o numerze 46 i wyświetla jego nazwę. |
| HTML/CSS | Określa strukturę i wygląd strony. | Wyznacza miejsce na nazwę, opis i zdjęcie. |

**Baza danych => PHP => strona widoczna w przeglądarce**

Przykład: baza zwraca nazwę Strokkur. PHP umieszcza ją w odpowiednim miejscu strony. Przeglądarka pokazuje nazwę uczniowi.

Na tym etapie korzystamy z gotowego szablonu HTML/CSS. Nie uczymy się jego składni. Najpierw ustal, gdzie mają pojawić się wyniki PHP: listy, galeria i opis miejsca.

## 3. Co zrobić najpierw, a co później?

1. **Przeczytaj całe zadanie.** Zobacz, jaki ma być końcowy efekt. Nie zaczynaj kodowania po przeczytaniu pierwszego akapitu.
2. **Sprawdź wymagane pliki.** Zapisz ich nazwy. W portalu są to między innymi `islandia.php`, `obiekty.php` i `styl.css`. W arkuszu sprawdź też wymagania dotyczące plików SQL i zrzutów ekranu.
3. **Sprawdź potrzebną bazę.** Ustal jej nazwę i plik do importu. W kursie używamy nazwy `Islandia`. Na egzaminie stosuj nazwę z polecenia.
4. **Zaimportuj bazę.** Uruchom serwer bazy w XAMPP. Otwórz phpMyAdmin i wykonaj import do właściwej bazy.
5. **Obejrzyj tabele.** Sprawdź nazwy kolumn. Znajdź tabelę z nazwami obiektów i tabelę z ich rodzajami.
6. **Przygotuj wymagane zapytania SQL.** Każde zapytanie ma wykonać jedną czynność z polecenia. Na przykład wybrać obiekty leżące na Islandii.
7. **Sprawdź zapytania w phpMyAdmin.** Porównaj kolumny i wiersze z oczekiwanym wynikiem. Popraw zapytanie przed użyciem go w PHP.
8. **Napisz skrypty PHP.** Zacznij od połączenia z bazą. Potem wykonaj jedno działające zapytanie i odczytaj wynik.
9. **Umieść wyniki na stronie.** Wstaw listę lub opis w odpowiednie miejsce szablonu. Dodawaj po jednej części.
10. **Sprawdź całą aplikację.** Otwórz stronę przez localhost. Przejdź z galerii do szczegółów i wróć. Porównaj działanie z poleceniem.

Jeśli arkusz wymaga zrzutu ekranu, wykonaj go po uzyskaniu właściwego wyniku. Zapisz go pod wskazaną nazwą. Nie odkładaj wszystkich zrzutów na koniec.

## 4. Czego potrzebuję do kolejnego kroku?

Nie musisz pamiętać wszystkiego. Wybierz czynność i wróć do odpowiedniej lekcji.

| Co trzeba wykonać? | Co muszę umieć? | Gdzie już się tego uczyłem? |
| --- | --- | --- |
| Uruchomić PHP i odczytać pole tablicy | Uruchamianie pliku, zmienne, tablice | [Lekcja 1]({{ '/01-podstawy-php/01-podstawy-php.html' | relative_url }}) |
| Zaimportować bazę i obejrzeć relacje | Import oraz powiązania tabel | [Baza Islandia]({{ '/00-organizacja/01-baza-islandia.html' | relative_url }}) |
| Połączyć PHP z bazą | `mysqli_connect()` | [Lekcja 2]({{ '/02-php-i-mariadb/01-odczyt-danych.html' | relative_url }}) |
| Pobrać wybrane dane | `SELECT`, `WHERE` | [Lekcja 3 - zapytania SQL]({{ '/03-zapytania-inf03/01-cztery-zapytania.html' | relative_url }}) |
| Połączyć dane z dwóch tabel | `JOIN` i kolumny łączące tabele | [Lekcja 3 - zapytania SQL]({{ '/03-zapytania-inf03/01-cztery-zapytania.html' | relative_url }}) |
| Wykonać zapytanie w PHP | `mysqli_query()` i odczyt wyniku | [Lekcja 4]({{ '/03-zapytania-inf03/02-wyniki-zapytan-w-php.html' | relative_url }}) |
| Policzyć obiekty w grupach | `GROUP BY`, `COUNT()` | [Lekcja 5A]({{ '/04-grupowanie-danych/01a-group-by-podstawy.html' | relative_url }}) |
| Wybrać grupy spełniające warunek | `HAVING` | [Lekcja 6A]({{ '/04-grupowanie-danych/02a-having-podstawy.html' | relative_url }}) |
| Usunąć powtórzenia z wyniku | `DISTINCT` | [Lekcja 7A]({{ '/04-grupowanie-danych/03a-distinct-podstawy.html' | relative_url }}) |
| Wyświetlić wiele rekordów na stronie | `while` i `mysqli_fetch_array()` | [Lekcja 8B]({{ '/05-php-i-html/01b-php-lista-z-bazy.html' | relative_url }}) |
| Wybrać obiekt przez adres | GET i sprawdzenie identyfikatora | [Lekcja 9B]({{ '/05-php-i-html/02b-get-rekord-z-bazy.html' | relative_url }}) |

Nie każde zadanie wymaga wszystkich tych umiejętności. Dobierz je do poleceń w arkuszu.

## 5. Dlaczego najpierw SQL, a potem PHP?

Załóżmy, że chcesz pokazać obiekty Islandii. Najpierw sprawdź zapytanie w phpMyAdmin. W niezmienionej bazie kursowej powinno wybrać **dziewięć obiektów**.

Sama liczba nie wystarczy. Sprawdź też nazwy i państwo. Strokkur powinien znaleźć się w wyniku. Obiekt z innego państwa nie powinien się w nim znaleźć.

Jeśli wynik jest zły już w phpMyAdmin, popraw zapytanie. Zmiana pętli PHP nie naprawi złego warunku SQL.

Gdy wynik jest dobry, użyj tego zapytania w PHP. Jeśli strona pokaże tylko jeden obiekt, sprawdź odczyt rekordów. Wiesz już, że baza zwróciła dziewięć.

## 6. Wykonaj => sprawdź => przejdź dalej

Po każdej małej części zatrzymaj się na chwilę. Zobacz jej wynik.

| Wykonana czynność | Co sprawdzić? |
| --- | --- |
| Import bazy | Czy widzisz tabele i ich dane w phpMyAdmin? |
| Zapytanie SELECT | Czy liczba rekordów i ich zawartość odpowiadają poleceniu? |
| Połączenie PHP | Czy połączenie się powiodło? Czy skrypt używa właściwej bazy? |
| Odczyt wielu rekordów | Czy PHP pokazuje wszystkie oczekiwane wiersze? |
| Galeria | Czy zdjęcia się pojawiają? Czy ich nazwy odpowiadają obiektom? |
| Wybór przez GET | Czy `id=46` pokazuje Strokkur, a `id=47` Skogafoss? |

Gotowy statyczny podgląd HTML nie zmienia opisu po zmianie `id`. Wybór rekordu sprawdzaj w działającej wersji PHP.

## 7. Gdy coś nie działa

Wróć do ostatniego wykonanego kroku. Zmień jedną rzecz i sprawdź wynik ponownie. Nie poprawiaj naraz zapytania, pętli i całej strony.

| Objaw | Od czego zacząć? |
| --- | --- |
| Baza nie odpowiada | Sprawdź w XAMPP, czy serwer MariaDB jest uruchomiony. |
| Zapytanie zwraca złe dane | Uruchom je osobno w phpMyAdmin. Sprawdź warunek i nazwy kolumn. |
| PHP nie łączy się z bazą | Sprawdź nazwę bazy i dane połączenia. |
| PHP nie pokazuje wyniku | Sprawdź powodzenie zapytania, odczyt rekordów i instrukcję wyświetlania. |
| Nie widać zdjęcia | Sprawdź, czy plik istnieje. Porównaj ścieżkę i wielkość liter w nazwie. |
| Otwiera się niewłaściwy obiekt | Sprawdź `id` w adresie oraz jego użycie w warunku SQL. |

Przykład: widzisz nazwę Strokkur, ale nie widzisz zdjęcia. Zacznij od pliku zdjęcia i jego ścieżki. Nie zmieniaj od razu całego połączenia z bazą.

## 8. Czy umiem zaplanować pracę?

Odpowiedz własnymi słowami. Nie pisz kodu.

### Pytanie 1 - pierwsze kroki

Masz arkusz i pliki do zadania. Czy od razu piszesz PHP? Wymień trzy pierwsze czynności.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - pytanie 1</summary>

Najpierw ustal, co masz wykonać i z jakich danych skorzystasz.

</details>

<details class="lesson-hint" markdown="1">
<summary>Odpowiedź - pytanie 1</summary>

Przeczytaj całe zadanie. Sprawdź wymagane pliki. Ustal potrzebną bazę i plik do importu. Dopiero później przygotuj bazę i zapytania.

</details>

### Pytanie 2 - za dużo obiektów

Zapytanie w phpMyAdmin pokazuje obiekty z różnych państw. Potrzebujesz tylko dziewięciu obiektów Islandii. Co poprawisz przed pisaniem PHP?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - pytanie 2</summary>

Która część SQL wybiera rekordy spełniające warunek?

</details>

<details class="lesson-hint" markdown="1">
<summary>Odpowiedź - pytanie 2</summary>

Sprawdź warunek WHERE dotyczący państwa. Uruchom zapytanie ponownie w phpMyAdmin. Sprawdź liczbę oraz zawartość rekordów. Dopiero potem użyj zapytania w PHP.

</details>

### Pytanie 3 - jeden zamiast dziewięciu

SQL w phpMyAdmin zwraca dziewięć właściwych obiektów. PHP pokazuje tylko pierwszy. Który etap sprawdzisz teraz?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - pytanie 3</summary>

Wynik zapytania jest już poprawny. Co pobiera kolejne rekordy?

</details>

<details class="lesson-hint" markdown="1">
<summary>Odpowiedź - pytanie 3</summary>

Sprawdź pętlę odczytującą wynik i miejsce wyświetlania danych. Jeden odczyt pobiera jeden rekord. Do pokazania wszystkich rekordów potrzebujesz kolejnych odczytów.

</details>

### Pytanie 4 - nazwa jest, zdjęcia nie ma

Po kliknięciu linku z `id=46` widzisz nazwę Strokkur i jego opis. Brakuje zdjęcia. Co sprawdzisz najpierw?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - pytanie 4</summary>

Skoro nazwa i opis są poprawne, wybór rekordu działa. Zdjęcie jest osobnym plikiem.

</details>

<details class="lesson-hint" markdown="1">
<summary>Odpowiedź - pytanie 4</summary>

Sprawdź obecność zdjęcia i ścieżkę do niego. Porównaj nazwę pliku z nazwą używaną przez stronę. Uwzględnij wielkość liter. Po jednej poprawce odśwież stronę.

</details>

## 9. Ten plan przyda się też później

Ta sama kolejność pomoże przy dodawaniu, zmienianiu i usuwaniu danych. Odpowiadają za to INSERT, UPDATE i DELETE.

Najpierw ustalisz, które dane mają się zmienić. Potem sprawdzisz zapytanie na kopii bazy ćwiczeniowej. Dopiero działające zapytanie połączysz z PHP. Na końcu obejrzysz wynik w bazie i na stronie.

## Czy wiem, od czego zacząć?

- [ ] Umiem wskazać wymagane pliki i potrzebną bazę.
- [ ] Wiem, które tabele zawierają potrzebne dane.
- [ ] Potrafię powiedzieć, jaki wynik ma dać pierwsze zapytanie.
- [ ] Wiem, jak sprawdzę ten wynik w phpMyAdmin.
- [ ] Umiem wybrać jeden mały krok do wykonania w PHP.
- [ ] Wiem, gdzie poszukam błędu, jeśli ten krok się nie uda.
