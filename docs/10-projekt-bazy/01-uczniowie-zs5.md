---
title: Budujemy bazę uczniowie_ZS5 - od projektu do tabel
mermaid: true
---

# Budujemy bazę uczniowie_ZS5 - od projektu do tabel

## Zaczynamy od zmiany sali

Wyobraź sobie zajęcia w ZS5 przy ul. Ogrodowej w Wałbrzychu. Klasa `3TI` liczy w naszym przykładzie 28 uczniów. Ma bazy danych w sali `205`. Jedne konkretne zajęcia zostają przeniesione do sali `32`. Klasy, uczniowie i plan w tej lekcji są fikcyjne.

Gdyby numer sali tych zajęć zapisano osobno przy każdym uczniu, ile wpisów trzeba byłoby poprawić? Co się stanie, jeśli poprawisz tylko część z nich?

<details markdown="1" class="lesson-hint">
<summary>Pokaż podpowiedź - zmiana sali</summary>

Policz powtórzenia tej samej informacji. Zmiana dotyczy jednych zajęć całej klasy, a nie osobnej decyzji dla każdego ucznia.

</details>

<details markdown="1" class="lesson-solution">
<summary>Pokaż rozwiązanie - zmiana sali</summary>

Trzeba byłoby poprawić 28 wpisów dotyczących tych samych zajęć. Pominięcie części uczniów zostawiłoby sprzeczne informacje. Lepiej zapisać jedne zajęcia klasy w jednym wierszu i wskazać w nim salę.

</details>

## Dwa tryby tej samej pracy

Na zajęciach przechodź przez etapy w tempie ustalonym dla grupy. Jeśli pracujesz samodzielnie, wykonaj każdy krok, sprawdź wynik i dopiero w razie potrzeby otwórz podpowiedź lub rozwiązanie.

## Co chcemy zapisywać i czym jest jeden wiersz?

Chcemy zapisywać klasy, uczniów, sale, przedmioty i terminy spotkań.

Nazwy przedmiotów z naszego przykładu to: **bazy danych**, **programowanie obiektowe**, **testowanie aplikacji** i **aplikacje mobilne**. Numery sal to `205` i `32`.

Klasa `3TI` ma bazy danych we wtorek i w czwartek. Ile wierszy potrzebujesz w tabeli `przedmioty`, a ile w `zajecia`, aby opisać te dwa spotkania? Zapisz odpowiedź, zanim przejdziesz do opisu tabel.

<details markdown="1" class="lesson-hint">
<summary>Pokaż podpowiedź - przedmiot a spotkania</summary>

Porównaj nazwę przedmiotu z datami obu spotkań. Która informacja pozostaje ta sama, a która odróżnia jedno spotkanie od drugiego?

</details>

<details markdown="1" class="lesson-solution">
<summary>Pokaż rozwiązanie - przedmiot a spotkania</summary>

W `przedmioty` potrzebujesz jednego wiersza: bazy danych. W `zajecia` potrzebujesz dwóch wierszy, po jednym na wtorkowe i czwartkowe spotkanie. Oba będą wskazywać ten sam przedmiot, ale każde będzie miało własny termin.

</details>

| Tabela | Znaczenie jednego wiersza |
| --- | --- |
| `klasy` | Jedna klasa, np. fikcyjna `3TI`. |
| `uczniowie` | Jeden uczeń przypisany do jednej klasy. |
| `sale` | Jedna sala, np. sala o numerze `205`. |
| `przedmioty` | Jeden przedmiot, np. bazy danych. |
| `zajecia` | Jedno konkretne spotkanie klasy na przedmiocie, w sali, w danym dniu i o danej godzinie. |

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

Zachowaj dokładną pisownię nazwy, także wielkie `ZS`. Jeśli taka baza już istnieje i zawiera tabele, nie usuwaj ich. Zatrzymaj pracę, dopóki nie masz do dyspozycji pustej bazy o wymaganej nazwie.

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

### Wykonanie

Pierwszą tabelę wykonaj według omówionego przykładu:

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

W wyniku `SHOW CREATE TABLE klasy` znajdź, co identyfikuje wiersz, a co nie pozwala powtórzyć oznaczenia `3TI`. Wskaż odpowiednie fragmenty definicji.

Oczekiwany wynik licznika to `0`. Utworzenie tabeli nie dodało klasy. Działanie autonumeru na danych sprawdzisz przy późniejszym dodawaniu rekordów.

### Krótka notatka

`klasy => jedna klasa => id_klasy => brak kluczy obcych => oznaczenie jest tekstem, a UNIQUE nie dopuszcza powtórzonego oznaczenia`.

## Etap 2 - uczniowie

### Decyzja

Przyjrzyj się dwóm fikcyjnym osobom. To przykład do rozumowania, nie rekordy zapisane już w bazie.

| Osoba | Imię | Nazwisko | Klasa |
| --- | --- | --- | --- |
| A | Anna | Przykładowa | 3TI |
| B | Anna | Przykładowa | 3TI |

Która wartość musi odróżniać te osoby: `id_ucznia` czy `id_klasy`? Która może być wspólna? Zapisz odpowiedź, a potem dobierz ograniczenia na podstawie wymagań tabeli.

Jeden wiersz ma opisywać jednego ucznia:

| Kolumna | Wymaganie |
| --- | --- |
| `id_ucznia` | `INT`, autonumer i klucz główny. |
| `imie` | `VARCHAR(50)`, `NOT NULL`. |
| `nazwisko` | `VARCHAR(80)`, `NOT NULL`. |
| `id_klasy` | `INT`, `NOT NULL`, klucz obcy do `klasy.id_klasy`. |

### Wykonanie

Napisz i wykonaj definicję według tabeli wymagań. Użyj `ENGINE=InnoDB` i jawnego zapisu `FOREIGN KEY (...) REFERENCES ...`. Sprawdź, czy twoja definicja pozwala zapisać obie osoby z przykładu.

<details markdown="1" class="lesson-hint">
<summary>Pokaż podpowiedź - uczniowie</summary>

Wróć do znaczenia klucza głównego. Sprawdź, czy wspólne imię, nazwisko lub klasa nie uniemożliwią zapisania drugiej osoby.

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

Osoby A i B muszą mieć różne `id_ucznia`. Mogą mieć wspólne `id_klasy`, bo należą do tej samej klasy. Nie wymuszamy unikalności imienia ani nazwiska.

`CONSTRAINT fk_uczniowie_klasy` nadaje ograniczeniu nazwę. `FOREIGN KEY` wskazuje kolumnę tej tabeli, a `REFERENCES` tabelę i kolumnę docelową. `NOT NULL` wymaga wskazania klasy, a klucz obcy wymaga, aby wskazywana klasa istniała.

</details>

### Kontrola

W **Struktura** sprawdź cztery kolumny. W widoku relacji sprawdź powiązanie z `klasy`. Potwierdź definicję:

```sql
SHOW CREATE TABLE uczniowie;
```

Oczekujesz jednego klucza głównego z autonumerem i jednego klucza obcego, bez unikalności nazwiska. Tabela nadal ma zero wierszy.

### Krótka notatka

Opisz role obu identyfikatorów na przykładzie osób A i B.

## Etap 3 - sale

### Decyzja

Spójrz na oznaczenia `205`, `32` i hipotetyczne `32A`. Wybierz typ kolumny `numer_sali`: `INT` czy `VARCHAR`? Uzasadnij wybór na podstawie wszystkich trzech przykładów. Zapisz propozycję przed otwarciem rozwiązania.

Jeden wiersz tabeli będzie opisywać jedną salę.

### Wykonanie

Utwórz `id_sali INT` z autonumerem i kluczem głównym oraz obowiązkowy, unikalny `numer_sali`. Dla numeru przyjmij limit 10 znaków i wybrany wcześniej typ. Ustaw `InnoDB`.

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

Numer z drzwi jest etykietą. `VARCHAR(10)` mieści wszystkie trzy przykłady, w tym literę w `32A`, której nie zapiszesz w `INT`. `UNIQUE` dotyczy numeru, a klucz główny osobnego identyfikatora sali.

</details>

### Kontrola

W **Struktura** zobacz dwa pola, autonumer przy `id_sali` oraz unikalność `numer_sali`. Sprawdź:

```sql
SHOW CREATE TABLE sale;
```

Oczekujesz tabeli z zerem wierszy. Powstanie tabeli nie zapisuje jeszcze numerów `205` ani `32`.

### Krótka notatka

Zapisz wybrany typ `numer_sali` i jeden przykład, który uzasadnia ten wybór.

## Etap 4 - przedmioty

### Decyzja

Jeden wiersz to jeden przedmiot. Potrzebujesz `id_przedmiotu INT` z autonumerem i kluczem głównym oraz obowiązkowej, unikalnej kolumny `nazwa` typu `VARCHAR`.

Sprawdź poniższe nazwy:

- `bazy danych`.
- `programowanie obiektowe`.
- `testowanie aplikacji`.
- `aplikacje mobilne`.

Która z nich nie mieści się w `VARCHAR(20)`? Policz znaki, uwzględniając spacje. Zapisz najdłuższą nazwę i zaproponuj limit z zapasem na inne przedmioty.

### Wykonanie

Zapisz uzasadnienie proponowanej długości. Następnie porównaj ją z ustalonym wariantem w rozwiązaniu i utwórz tabelę zgodną z nim. Pamiętaj o `NOT NULL`, `UNIQUE` i `InnoDB`.

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

Nazwa `programowanie obiektowe` ma 23 znaki, więc nie mieści się w limicie 20. Ustalony `VARCHAR(80)` mieści ją i pozostawia zapas. Ten sam limit obowiązuje w pliku SQL do pobrania.

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

Teraz opiszesz jedno konkretne spotkanie klasy.

W tabeli `sale` sala `205` ma przykładowe `id_sali = 7`. Którą wartość zapiszesz w `zajecia.id_sali`? Zapisz odpowiedź, zanim przejdziesz do definicji.

To przykład do rozumowania. W naszej pustej bazie nie zapisano jeszcze sali ani takiego identyfikatora.

Tabela ma mieć następujące kolumny:

| Kolumna | Wymaganie |
| --- | --- |
| `id_zajec` | `INT`, autonumer i klucz główny. |
| `id_klasy` | `INT NOT NULL`, wskazuje `klasy.id_klasy`. |
| `id_sali` | `INT NOT NULL`, wskazuje `sale.id_sali`. |
| `id_przedmiotu` | `INT NOT NULL`, wskazuje `przedmioty.id_przedmiotu`. |
| `data_zajec` | `DATE NOT NULL`, data konkretnego spotkania. |
| `godzina_rozpoczecia` | `TIME NOT NULL`, godzina rozpoczęcia. |

`DATE` przechowuje datę, np. zapisaną jako `2026-12-01`. `TIME` przechowuje tu godzinę, np. `08:00:00`. To przykłady znaczenia typów, nie dane do dodania w tym etapie.

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

W przykładzie do `zajecia.id_sali` wpisalibyśmy `7`. To identyfikator wskazujący salę o numerze `205`. Nazwa przedmiotu i numer sali pozostają w swoich tabelach. Kilka spotkań może wskazywać te same rekordy, dlatego klucze obce nie są tu unikalne.

Tabelę `zajecia` tworzymy po `klasy`, `sale` i `przedmioty`, aby serwer mógł odnaleźć cele kluczy obcych. Nasza kolejność to `klasy => uczniowie => sale => przedmioty => zajecia`. `uczniowie` wymaga tylko wcześniejszej tabeli `klasy`.

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

## Co dziś powstało?

Dziś utworzyliśmy strukturę: pięć pustych tabel i ich powiązania. Dane dodamy przez `INSERT` w następnej lekcji.

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
