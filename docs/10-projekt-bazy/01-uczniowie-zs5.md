---
title: Budujemy bazę uczniowie_ZS5 - od projektu do tabel
mermaid: true
---

# Budujemy bazę uczniowie_ZS5 - od projektu do tabel

## Zaczynamy od zmiany sali

Wyobraź sobie zajęcia w ZS5 przy ul. Ogrodowej w Wałbrzychu. Fikcyjna klasa `3TI` liczy w naszym przykładzie 28 uczniów. Ma bazy danych w sali `205`. Jedne konkretne zajęcia zostają przeniesione do sali `32`.

Gdyby numer sali tych zajęć zapisano osobno przy każdym uczniu, ile wpisów trzeba byłoby poprawić? Co się stanie, jeśli poprawisz tylko część z nich?

<details markdown="1" class="lesson-hint">
<summary>Pokaż podpowiedź - zmiana sali</summary>

Policz powtórzenia tej samej informacji. Zmiana dotyczy jednych zajęć całej klasy, a nie osobnej decyzji dla każdego ucznia.

</details>

<details markdown="1" class="lesson-solution">
<summary>Pokaż rozwiązanie - zmiana sali</summary>

Trzeba byłoby poprawić 28 wpisów dotyczących tych samych zajęć. Pominięcie części uczniów zostawiłoby sprzeczne informacje. Lepiej zapisać jedne zajęcia klasy w jednym wierszu i wskazać w nim salę.

To opis problemu, nie dane już zapisane w bazie. W tej lekcji utworzymy tylko pustą strukturę. Klasy, uczniowie i plan w przykładach są fikcyjne.

</details>

## Dwa tryby tej samej pracy

**Z nauczycielem:** przed każdym etapem odpowiedz na pytanie do klasy. Nauczyciel omawia decyzję i pokazuje pierwszą tabelę. Przy kolejnych tabelach najpierw zapisz własny pomysł. Wykonaj krok i zatrzymaj się na kontroli. Porównaj rezultat przed przejściem dalej.

**Bez nauczyciela:** czytaj etapy po kolei. Każdy zawiera wymagane kolumny, oczekiwany wynik i kontrolę. Spróbuj samodzielnie zapisać polecenie. Podpowiedź otwórz, gdy utkniesz. Osobne rozwiązanie otwórz dopiero po próbie. Nie uruchamiaj drugi raz polecenia, jeśli tabela już powstała.

W obu trybach wykonujemy ten sam ciąg: potrzeba szkoły => znaczenie wiersza => tabele => typy i klucze => kolejność tworzenia => sprawdzenie wyniku. Notujesz powody decyzji, nie całą stronę.

## Co chcemy zapisywać i czym jest jeden wiersz?

Potrzebujemy informacji o klasach, uczniach, salach, przedmiotach i konkretnych zajęciach. Na potrzeby tego modelu uczeń należy do jednej klasy, a jedne zajęcia dotyczą całej klasy, jednego przedmiotu i jednej sali.

Nazwy przedmiotów z naszego przykładu to: **bazy danych**, **programowanie obiektowe**, **testowanie aplikacji** i **aplikacje mobilne**. Numery sal to `205` i `32`. Nie przepisuj tych wartości do każdej tabeli.

| Tabela | Znaczenie jednego wiersza |
| --- | --- |
| `klasy` | Jedna klasa, np. fikcyjna `3TI`. |
| `uczniowie` | Jeden uczeń przypisany do jednej klasy. |
| `sale` | Jedna sala, np. sala o numerze `205`. |
| `przedmioty` | Jeden przedmiot, np. bazy danych. |
| `zajecia` | Jedno konkretne spotkanie klasy na przedmiocie, w sali, w danym dniu i o danej godzinie. |

Wiersz `zajecia` nie oznacza całego tygodniowego planu ani samej nazwy przedmiotu. Dwa spotkania z tego samego przedmiotu w różnych dniach będą dwoma wierszami.

**Pytanie do klasy:** „Czy `bazy danych` i konkretne zajęcia z baz danych w przyszły wtorek to ten sam rodzaj informacji? Co musi odróżnić dwa spotkania?”.

<figure class="lesson-diagram">
<pre class="mermaid-source" hidden>
erDiagram
    klasy ||--o{ uczniowie : "id_klasy"
    klasy ||--o{ zajecia : "id_klasy"
    sale ||--o{ zajecia : "id_sali"
    przedmioty ||--o{ zajecia : "id_przedmiotu"
</pre>
<p class="diagram-fallback">klasy.id_klasy =&gt; uczniowie.id_klasy oraz zajecia.id_klasy; sale.id_sali =&gt; zajecia.id_sali; przedmioty.id_przedmiotu =&gt; zajecia.id_przedmiotu.</p>
<figcaption>Cztery relacje 1:N w projektowanej bazie.</figcaption>
</figure>

Jedna klasa może mieć wielu uczniów i wiele zajęć. Jedna sala oraz jeden przedmiot mogą wystąpić w wielu zajęciach. Każdy uczeń wskazuje dokładnie jedną klasę. Każde zajęcia wskazują dokładnie jedną klasę, salę i przedmiot. Strona „wiele” może być na razie pusta.

## Przygotowanie - baza w phpMyAdmin

Uruchom moduły Apache i MySQL w panelu XAMPP. W typowej instalacji XAMPP przycisk MySQL uruchamia serwer MariaDB. Otwórz phpMyAdmin przez przycisk **Admin** modułu MySQL.

W interfejsie wykonaj:

**Nowa => nazwa `uczniowie_ZS5` => metoda porównywania napisów `utf8mb4_polish_ci` => Utwórz**.

Zachowaj dokładną pisownię nazwy, także wielkie `ZS`. Jeśli taka baza już istnieje i zawiera tabele, nie usuwaj ich. Zatrzymaj się i uzgodnij z nauczycielem przygotowanie pustej bazy o wymaganej nazwie.

### Zapis znaków a ich porównywanie

- `utf8mb4` to zestaw znaków i sposób ich kodowania. Pozwala zapisywać m.in. polskie litery.
- `utf8mb4_polish_ci` to reguła porównywania i sortowania tekstu dla tego zestawu. Uwzględnia polski porządek liter. Końcówka `ci` oznacza porównywanie bez rozróżniania wielkości liter.

To nie są dwa zamienne ustawienia. Jedno mówi, jak zapisać znaki, a drugie, jak porównywać zapisany tekst.

Wybierz bazę `uczniowie_ZS5` w lewym panelu. W zakładce **SQL** sprawdź:

```sql
SHOW CREATE DATABASE uczniowie_ZS5;
```

W otrzymanej definicji znajdź `CHARACTER SET utf8mb4` oraz `COLLATE utf8mb4_polish_ci`. Zapisz obie wartości. To kontrola istniejącej bazy, nie polecenie tworzenia jej struktury.

Jeśli nie widzisz wymaganej reguły na liście phpMyAdmin, sprawdź jej dostępność:

```sql
SHOW COLLATION WHERE Collation = 'utf8mb4_polish_ci';
```

Oczekiwany wynik to wiersz z `Collation = utf8mb4_polish_ci` i `Charset = utf8mb4`. Jeśli reguła jest dostępna, wróć do wyboru reguły w interfejsie, ewentualnie odśwież listę. Jeśli zapytanie nie zwróci wiersza, zatrzymaj się i skonsultuj konfigurację. Nie wybieraj przypadkowego zamiennika.

**Kontrola przed pierwszą tabelą:** u góry phpMyAdmin jest wybrana baza `uczniowie_ZS5`, jest ona pusta, a oba ustawienia są zgodne. Jeżeli ustawienia są inne, popraw je w zakładce **Operacje** tej pustej bazy i sprawdź ponownie. Dopiero potem wykonuj `CREATE TABLE`.

Wszystkie nasze tabele będą dziedziczyć sprawdzone ustawienia bazy. W ich definicjach nie dopisujemy innego kodowania ani reguły porównywania.

**Krótka notatka:** `uczniowie_ZS5 => utf8mb4 => utf8mb4_polish_ci` oraz jedno zdanie wyjaśniające różnicę tych ustawień.

## Etap 1 - klasy

### Decyzja

Jeden wiersz oznacza jedną klasę. Potrzebujemy trwałego identyfikatora i czytelnego oznaczenia. Nazwa `3TI` jest tekstem. Identyfikator będzie liczbą generowaną przez bazę.

**Pytanie do klasy:** „Czy dwie klasy powinny mieć ten sam identyfikator? A to samo oznaczenie? Dlaczego oznaczenie nie jest liczbą do obliczeń?”.

### Wykonanie

Nauczyciel pokazuje ten pełny przykład. Pracując samodzielnie, również wykonaj go jako pierwszy:

```sql
CREATE TABLE klasy (
    id_klasy INT AUTO_INCREMENT PRIMARY KEY,
    oznaczenie VARCHAR(10) NOT NULL UNIQUE
) ENGINE=InnoDB;
```

| Zapis | Znaczenie |
| --- | --- |
| `CREATE TABLE klasy` | Tworzy tabelę o nazwie `klasy` w wybranej bazie. |
| `id_klasy` | Nazwa kolumny identyfikującej klasę. |
| `INT` | Typ całkowity, odpowiedni dla liczbowego identyfikatora. |
| `AUTO_INCREMENT` | Baza będzie nadawać kolejne numery przy dodawaniu wierszy. Samo utworzenie tabeli nie dodaje żadnego wiersza. |
| `PRIMARY KEY` | Klucz główny: identyfikuje wiersz, nie dopuszcza powtórzeń ani `NULL`. |
| `VARCHAR(10)` | Napis o zmiennej długości, do 10 znaków. Mieści oznaczenie `3TI` i zostawia miejsce na inne oznaczenia. |
| `NOT NULL` | Kolumna musi mieć wartość inną niż `NULL`. Nie jest to zakaz pustego napisu. |
| `UNIQUE` | Dwa wiersze nie mogą mieć tego samego oznaczenia według reguły porównywania tekstu. |
| `ENGINE=InnoDB` | Ustala silnik tabeli obsługujący nasze klucze obce. |

Nawiasy obejmują definicje kolumn. Przecinek je rozdziela. Po ostatniej kolumnie nie dodajemy przecinka. Średnik kończy polecenie.

### Kontrola

Odśwież listę tabel. W zakładce **Struktura** tabeli `klasy` znajdź obie kolumny, klucz główny i indeks unikalny. W **Przeglądaj** zobaczysz brak rekordów. Sprawdź też:

```sql
SHOW CREATE TABLE klasy;
SELECT COUNT(*) AS liczba_wierszy FROM klasy;
```

Oczekiwany wynik licznika to `0`. Informacja o początkowej wartości autonumeru nie jest zapisanym uczniem ani klasą. Działanie autonumeru na danych zobaczymy dopiero przy późniejszym dodawaniu rekordów.

### Krótka notatka

`klasy => jedna klasa => id_klasy => brak kluczy obcych => oznaczenie jest tekstem, a UNIQUE nie dopuszcza powtórzonego oznaczenia`.

## Etap 2 - uczniowie

### Decyzja

Jeden wiersz opisuje jednego ucznia. Zapisz identyfikator ucznia, imię, nazwisko i wskazanie jego klasy.

| Kolumna | Wymaganie |
| --- | --- |
| `id_ucznia` | `INT`, autonumer i klucz główny. |
| `imie` | `VARCHAR(50)`, `NOT NULL`. |
| `nazwisko` | `VARCHAR(80)`, `NOT NULL`. |
| `id_klasy` | `INT`, `NOT NULL`, klucz obcy do `klasy.id_klasy`. |

`id_ucznia` identyfikuje osobę w naszym modelu. `id_klasy` wskazuje jej klasę. Wielu uczniów ma prawo wskazywać tę samą klasę. Imię i nazwisko nie muszą być unikalne: dwie różne osoby mogą nazywać się tak samo.

**Pytanie do klasy:** „Czy przy 28 uczniach jednej klasy powinno wystąpić 28 różnych wartości `id_klasy`? Która kolumna odróżni dwie osoby o takim samym imieniu i nazwisku?”.

### Wykonanie

Napisz i wykonaj definicję według tabeli wymagań. Użyj `ENGINE=InnoDB` i jawnego zapisu `FOREIGN KEY (...) REFERENCES ...`. Kolumna wskazująca klasę ma ten sam typ `INT` co wskazywany klucz. Nie dodawaj `UNIQUE` do imienia, nazwiska ani `id_klasy`.

<details markdown="1" class="lesson-hint">
<summary>Pokaż podpowiedź - uczniowie</summary>

Zacznij od wzoru pierwszej tabeli. Dodaj pola opisowe, a po kolumnach ograniczenie wskazujące klasę. Własny identyfikator ucznia i wskazanie jego klasy pełnią różne role.

</details>

<details markdown="1" class="lesson-solution">
<summary>Pokaż rozwiązanie - uczniowie</summary>

```sql
CREATE TABLE uczniowie (
    id_ucznia INT AUTO_INCREMENT PRIMARY KEY,
    imie VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(80) NOT NULL,
    id_klasy INT NOT NULL,
    CONSTRAINT fk_uczniowie_klasy
        FOREIGN KEY (id_klasy) REFERENCES klasy(id_klasy)
) ENGINE=InnoDB;
```

`CONSTRAINT fk_uczniowie_klasy` nadaje ograniczeniu nazwę. Dalej `FOREIGN KEY` wskazuje kolumnę tej tabeli, a `REFERENCES` tabelę i kolumnę docelową. `NOT NULL` sprawia, że wskazanie klasy jest obowiązkowe. Klucz obcy wymaga istnienia wskazywanej klasy przy późniejszym zapisywaniu danych.

</details>

### Kontrola

W **Struktura** sprawdź cztery kolumny. W widoku relacji sprawdź powiązanie z `klasy`. Potwierdź definicję:

```sql
SHOW CREATE TABLE uczniowie;
```

Oczekujesz jednego klucza głównego z autonumerem i jednego klucza obcego, bez unikalności nazwiska. Tabela nadal ma zero wierszy.

### Krótka notatka

Zapisz jednym zdaniem, dlaczego `id_ucznia` nie zastępuje `id_klasy`, oraz dlaczego dwie osoby mogą mieć to samo nazwisko.

## Etap 3 - sale

### Decyzja

Jeden wiersz oznacza jedną salę. Jej identyfikator to liczba. Numer widoczny na drzwiach to etykieta: `32`, `205`, a w innym budynku mógłby wystąpić `32A`.

Wybierz `id_sali INT` z autonumerem i kluczem głównym oraz `numer_sali VARCHAR(10) NOT NULL UNIQUE`.

**Pytanie do klasy:** „Czy do numeru sali dodajemy liczbę 1, aby znaleźć kolejną salę? Jak przechowasz `32A` w typie całkowitym?”.

### Wykonanie

Utwórz tabelę z dwiema kolumnami według decyzji. Ustaw `InnoDB`. Uzasadnij wybór `VARCHAR`, odnosząc się osobno do `32`, `205` i hipotetycznego `32A`.

<details markdown="1" class="lesson-hint">
<summary>Pokaż podpowiedź - sale</summary>

O typie nie decyduje sam wygląd dwóch pierwszych przykładów. Zastanów się, czy numer służy do działań arytmetycznych i czy zawsze składa się wyłącznie z cyfr.

</details>

<details markdown="1" class="lesson-solution">
<summary>Pokaż rozwiązanie - sale</summary>

```sql
CREATE TABLE sale (
    id_sali INT AUTO_INCREMENT PRIMARY KEY,
    numer_sali VARCHAR(10) NOT NULL UNIQUE
) ENGINE=InnoDB;
```

Wszystkie trzy etykiety mieszczą się w tekście o długości do 10 znaków. `INT` nie pomieści litery w `32A`. Numer sali nie służy do sumowania. `UNIQUE` dotyczy etykiety, a klucz główny osobnego identyfikatora sali.

</details>

### Kontrola

W **Struktura** zobacz dwa pola, autonumer przy `id_sali` oraz unikalność `numer_sali`. Sprawdź:

```sql
SHOW CREATE TABLE sale;
```

Oczekujesz tabeli z zerem wierszy. Powstanie tabeli nie zapisuje jeszcze numerów `205` ani `32`.

### Krótka notatka

`numer_sali => etykieta => VARCHAR(10)`, a potem własne uzasadnienie obejmujące możliwość wystąpienia litery.

## Etap 4 - przedmioty

### Decyzja

Jeden wiersz to jeden przedmiot. Potrzebujesz `id_przedmiotu INT` z autonumerem i kluczem głównym oraz obowiązkowej, unikalnej kolumny `nazwa` typu `VARCHAR`.

Dobierz jej długość na podstawie nazw:

- `bazy danych` - 11 znaków.
- `programowanie obiektowe` - 23 znaki.
- `testowanie aplikacji` - 20 znaków.
- `aplikacje mobilne` - 17 znaków.

Spacja też jest znakiem. Przyjmij limit, który pomieści te nazwy i pozostawi zapas na dłuższe nazwy. Nie istnieje jedna długość właściwa dla każdej możliwej szkoły. W rozwiązaniu przyjmiemy 80 znaków.

**Pytanie do klasy:** „Która z naszych nazw nie zmieściłaby się w `VARCHAR(20)`? Dlaczego nie dobieramy długości tylko do najkrótszego przykładu?”.

### Wykonanie

Zapisz wybrany limit z uzasadnieniem i utwórz tabelę. Pamiętaj o `NOT NULL`, `UNIQUE` i `InnoDB`. Aby uzyskać dokładnie tę samą strukturę co w pliku na końcu lekcji, użyj `VARCHAR(80)`.

<details markdown="1" class="lesson-hint">
<summary>Pokaż podpowiedź - przedmioty</summary>

Porównaj limit ze wszystkimi czterema nazwami. Identyfikator i nazwa to różne kolumny. Powtórzona nazwa nie powinna tworzyć drugiego wpisu tego samego przedmiotu.

</details>

<details markdown="1" class="lesson-solution">
<summary>Pokaż rozwiązanie - przedmioty</summary>

```sql
CREATE TABLE przedmioty (
    id_przedmiotu INT AUTO_INCREMENT PRIMARY KEY,
    nazwa VARCHAR(80) NOT NULL UNIQUE
) ENGINE=InnoDB;
```

Limit 80 mieści najdłuższy przykład i pozostawia zapas. `NOT NULL` odrzuca brak wartości `NULL`. Samo to ograniczenie nie odrzuca pustego napisu. `UNIQUE` pilnuje niepowtarzalności nazwy zgodnie z regułą porównywania bazy.

</details>

### Kontrola

Sprawdź typ i długość `nazwa`, jej obowiązkowość i indeks unikalny:

```sql
SHOW CREATE TABLE przedmioty;
```

Oczekujesz dwóch kolumn i zera wierszy.

### Krótka notatka

Zapisz najdłuższy przykład, jego długość i uzasadnienie przyjętego zapasu.

## Etap 5 - zajecia

### Decyzja

Teraz zapisujemy jedno konkretne spotkanie. Wybieramy klasę, salę i przedmiot przez ich identyfikatory. Dodajemy datę i godzinę rozpoczęcia.

| Kolumna | Wymaganie |
| --- | --- |
| `id_zajec` | `INT`, autonumer i klucz główny. |
| `id_klasy` | `INT NOT NULL`, wskazuje `klasy.id_klasy`. |
| `id_sali` | `INT NOT NULL`, wskazuje `sale.id_sali`. |
| `id_przedmiotu` | `INT NOT NULL`, wskazuje `przedmioty.id_przedmiotu`. |
| `data_zajec` | `DATE NOT NULL`, data konkretnego spotkania. |
| `godzina_rozpoczecia` | `TIME NOT NULL`, godzina rozpoczęcia. |

`DATE` przechowuje datę, np. zapisaną jako `2026-12-01`. `TIME` przechowuje tu godzinę, np. `08:00:00`. To przykłady znaczenia typów, nie dane do dodania w tym etapie.

Nie przepisujemy tu nazwy przedmiotu ani numeru sali. Te informacje mają własne tabele. Kilka zajęć może wskazywać tę samą salę, przedmiot lub klasę, więc ich klucze obce nie są unikalne.

**Pytanie do klasy:** „Dlaczego `id_sali` nie musi mieć wartości `205`, nawet gdy zajęcia są w sali `205`? Które tabele muszą już istnieć, aby utworzyć te relacje?”.

### Wykonanie

Utwórz tabelę z sześcioma kolumnami i trzema jawnymi kluczami obcymi. Wszystkie wskazywane klucze są typu `INT`, więc kolumny wskazujące też mają być `INT`. Zwracaj uwagę również na zgodność wariantu ze znakiem: nie zmieniaj jednego końca relacji na `UNSIGNED`.

<details markdown="1" class="lesson-hint">
<summary>Pokaż podpowiedź - zajecia</summary>

Po definicjach kolumn potrzebujesz trzech osobnych powiązań. Każde wskazuje inną tabelę. Daty i godziny nie należą do opisu sali ani przedmiotu, lecz do tego konkretnego spotkania.

</details>

<details markdown="1" class="lesson-solution">
<summary>Pokaż rozwiązanie - zajecia</summary>

```sql
CREATE TABLE zajecia (
    id_zajec INT AUTO_INCREMENT PRIMARY KEY,
    id_klasy INT NOT NULL,
    id_sali INT NOT NULL,
    id_przedmiotu INT NOT NULL,
    data_zajec DATE NOT NULL,
    godzina_rozpoczecia TIME NOT NULL,
    CONSTRAINT fk_zajecia_klasy
        FOREIGN KEY (id_klasy) REFERENCES klasy(id_klasy),
    CONSTRAINT fk_zajecia_sale
        FOREIGN KEY (id_sali) REFERENCES sale(id_sali),
    CONSTRAINT fk_zajecia_przedmioty
        FOREIGN KEY (id_przedmiotu) REFERENCES przedmioty(id_przedmiotu)
) ENGINE=InnoDB;
```

Tę tabelę tworzymy po `klasy`, `sale` i `przedmioty`, ponieważ serwer musi odnaleźć cele jej kluczy obcych. Dlatego nasza kolejność to `klasy => uczniowie => sale => przedmioty => zajecia`. `uczniowie` wymaga tylko wcześniejszej tabeli `klasy`.

</details>

### Kontrola

W **Struktura** sprawdź sześć kolumn. W widoku relacji znajdź trzy wskazania. Następnie wykonaj:

```sql
SHOW CREATE TABLE zajecia;
```

Oczekujesz jednego klucza głównego z autonumerem i trzech kluczy obcych. Nazw sal i przedmiotów nie ma wśród kolumn tej tabeli. Nadal nie zapisano żadnego spotkania.

### Krótka notatka

Wyjaśnij, dlaczego data i godzina opisują wiersz `zajecia`, a nazwa przedmiotu pozostaje w osobnej tabeli.

## Diagnoza - wskazywana tabela jeszcze nie istnieje

Wyobraź sobie, że w pustej bazie próbujesz utworzyć `uczniowie` przed `klasy`, z kluczem obcym pokazanym wyżej. MariaDB może zgłosić błąd `1005` z informacją `errno: 150` o niepoprawnie utworzonym kluczu obcym. Sama poprawna pisownia kolumn nie wystarczy.

Najpierw sprawdź, czy pracujesz w `uczniowie_ZS5` i czy na liście istnieje tabela `klasy`. Jeśli błąd pojawił się przed chwilą, szczegóły sprawdzisz przez:

```sql
SHOW WARNINGS;
```

W tym przypadku brakuje tabeli docelowej. Najpierw utwórz `klasy`, dopiero potem ponów poprawne polecenie dla `uczniowie`. Nie wyłączaj kontroli kluczy obcych. Jeśli tabela docelowa istnieje, sprawdź także zgodność typów i dokładną nazwę wskazywanej kolumny.

Nie odtwarzaj celowo błędu na już gotowej strukturze. To opis diagnozy sytuacji z niewłaściwą kolejnością.

## Odbiór - co ma istnieć po lekcji?

Wybierz `uczniowie_ZS5`. W phpMyAdmin sprawdź:

- **Struktura bazy** => dokładnie pięć tabel: `klasy`, `uczniowie`, `sale`, `przedmioty`, `zajecia`.
- **Struktura każdej tabeli** => jeden klucz główny z autonumerem. Łącznie jest ich pięć.
- **Struktura / Widok relacji** => jeden klucz obcy w `uczniowie` i trzy w `zajecia`. Łącznie cztery.
- **Przeglądaj** każdej tabeli => brak rekordów. Nie ma jeszcze przykładowej klasy ani sali.
- **Operacje tabeli** albo lista tabel => silnik `InnoDB` i reguła `utf8mb4_polish_ci`.

Kontrola SQL:

```sql
SHOW CREATE TABLE klasy;
SHOW CREATE TABLE uczniowie;
SHOW CREATE TABLE sale;
SHOW CREATE TABLE przedmioty;
SHOW CREATE TABLE zajecia;
SHOW TABLE STATUS;
```

W definicjach szukaj `PRIMARY KEY`, `AUTO_INCREMENT`, czterech zapisów `FOREIGN KEY` oraz ustawień tekstu. Serwer może wyświetlać `INT` jako `int(11)` - taki zapis nie oznacza, że powstał inny typ liczbowy.

W wyniku `SHOW TABLE STATUS` kolumna `Engine` ma wszędzie wartość `InnoDB`, a `Collation` wartość `utf8mb4_polish_ci`. Potwierdza to regułę zgodną z wybranym `utf8mb4` i dziedziczenie ustawień bazy. Liczba `Rows` dla InnoDB może być szacunkowa. Dokładny brak rekordów potwierdzisz przez **Przeglądaj** lub liczniki:

```sql
SELECT COUNT(*) AS liczba_wierszy FROM klasy;
SELECT COUNT(*) AS liczba_wierszy FROM uczniowie;
SELECT COUNT(*) AS liczba_wierszy FROM sale;
SELECT COUNT(*) AS liczba_wierszy FROM przedmioty;
SELECT COUNT(*) AS liczba_wierszy FROM zajecia;
```

Każdy z pięciu wyników ma wynosić `0`.

### Wzór krótkiej notatki

**tabela => znaczenie jednego wiersza => klucz główny => klucze obce => jeden uzasadniony wybór typu**.

Wypełnij po jednym wierszu dla każdej tabeli. Nie przepisuj całych definicji. Przy `uczniowie` odróżnij własny identyfikator od wskazania klasy. Przy `zajecia` wymień wszystkie trzy klucze obce.

<details markdown="1" class="lesson-hint">
<summary>Pokaż podpowiedź - odbiór i notatka</summary>

Wróć do znaczenia jednego wiersza. Zestaw je z rolą każdej kolumny identyfikatora. Do uzasadnienia typu użyj konkretnego przykładu wartości, a nie samego stwierdzenia „tak jest w rozwiązaniu”.

</details>

<details markdown="1" class="lesson-solution">
<summary>Pokaż rozwiązanie - odbiór i notatka</summary>

| Tabela | Jeden wiersz | Klucz główny | Klucze obce | Uzasadniony typ |
| --- | --- | --- | --- | --- |
| `klasy` | Jedna klasa | `id_klasy` | brak | `VARCHAR(10)` mieści tekst `3TI`. |
| `uczniowie` | Jeden uczeń | `id_ucznia` | `id_klasy` do `klasy` | `INT` wskazania klasy odpowiada typowi jej klucza. |
| `sale` | Jedna sala | `id_sali` | brak | `VARCHAR(10)` dopuszcza również etykietę `32A`. |
| `przedmioty` | Jeden przedmiot | `id_przedmiotu` | brak | `VARCHAR(80)` mieści 23-znakową nazwę i daje zapas. |
| `zajecia` | Jedno konkretne spotkanie | `id_zajec` | `id_klasy`, `id_sali`, `id_przedmiotu` | `DATE` zapisuje datę spotkania, a `TIME` jego godzinę. |

Odbiór: pięć pustych tabel, pięć kluczy głównych z autonumerem, cztery klucze obce. Każda tabela ma silnik `InnoDB` i regułę `utf8mb4_polish_ci`.

</details>

## Typowe błędy

- Wykonywanie poleceń w innej bazie niż `uczniowie_ZS5`.
- Pominięcie kontroli kodowania przed utworzeniem tabel.
- Tworzenie tabeli zależnej przed tabelą wskazywaną przez klucz obcy.
- Inny typ lub wariant ze znakiem po obu końcach relacji.
- Uznanie `id_sali` za numer z drzwi sali.
- Ustawienie unikalności imienia i nazwiska, choć różni uczniowie mogą mieć takie same dane.
- Mylenie utworzenia tabeli z dodaniem wiersza albo ponowne uruchomienie jej definicji.

## Kiedy tego użyć?

Gdy z opisu sytuacji chcesz zbudować nową strukturę relacyjnej bazy. Najpierw ustalasz znaczenie wiersza i powiązania, a potem zapisujesz typy i ograniczenia w SQL.

## Kiedy wybrać coś innego?

Jeżeli struktura już istnieje i chcesz tylko odczytać dane, użyj poznanych zapytań `SELECT`. Ponowne tworzenie tych samych tabel nie jest sposobem odczytu ani dopisania danych.

## Plik do sprawdzenia lub odtworzenia struktury

[Pobierz uczniowie_ZS5-struktura.sql]({{ '/assets/downloads/uczniowie_ZS5-struktura.sql' | relative_url }})

Plik jest zapisany w UTF-8 bez BOM. Zawiera pięć poleceń `CREATE TABLE` w prawidłowej kolejności. Służy do porównania własnej pracy albo odtworzenia struktury w **pustej** bazie `uczniowie_ZS5`, założonej wcześniej w phpMyAdmin z ustawieniami `utf8mb4` i `utf8mb4_polish_ci`.

Nie importuj go do bazy, w której wykonałeś już etapy lekcji. Nie usuwa istniejących tabel i nie dodaje danych.

Instrukcja importu: **wybierz pustą bazę `uczniowie_ZS5` => Import => plik `uczniowie_ZS5-struktura.sql` => zestaw znaków UTF-8 (`utf-8` na liście) => wykonaj => sprawdź wynik**.

Po imporcie wykonaj tę samą kontrolę pięciu tabel, kluczy, pustych wyników i kodowania. Dane oraz pełny import z danymi przygotujemy w następnym etapie.

## Pytanie na koniec

Gdy zajęcia przenosimy z sali `205` do `32`, który wiersz i którą kolumnę będziemy zmieniać?

<details markdown="1" class="lesson-hint">
<summary>Pokaż podpowiedź - przeniesienie zajęć</summary>

Zmiana dotyczy jednego spotkania, a nie numeru na drzwiach sali ani listy uczniów. Wybierz wiersz opisujący to spotkanie. Odróżnij identyfikator sali od jej etykiety.

</details>

<details markdown="1" class="lesson-solution">
<summary>Pokaż rozwiązanie - przeniesienie zajęć</summary>

Zmienialibyśmy kolumnę `id_sali` w jednym wierszu tabeli `zajecia`, tym, który opisuje przenoszone spotkanie. Wiersz można jednoznacznie wskazać przez jego `id_zajec`. Nowe wskazanie ma prowadzić do wiersza `sale`, którego `numer_sali` to `32`.

Nie zakładamy, że identyfikator tej sali wynosi `32`. Nie zmieniamy nazwiska ucznia ani numeru sali `205` w słowniku sal. Na razie tabele są puste, więc nie znamy rzeczywistych identyfikatorów tych przyszłych rekordów i niczego jeszcze nie modyfikujemy.

</details>
