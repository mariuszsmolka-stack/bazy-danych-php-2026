---
title: Budujemy bazę uczniowie_ZS5 - od projektu do tabel
mermaid: true
---

# Budujemy bazę uczniowie_ZS5 - od projektu do tabel

## Co mamy w szkole?

Wyobraź sobie zajęcia w ZS5 przy ul. Ogrodowej w Wałbrzychu. Osoby, klasy i plan w tym przykładzie są fikcyjne.

- **Uczniowie** - Łukasz Lis i Zofia Łoś chodzą do `3TI`, a Anna Żuk i Paweł Ćwik do `4TI`. To kilka osób z dwóch klas, nie pełne listy uczniów.
- **Klasy** - `3TI` i `4TI`. Przyjmijmy, że cała `3TI` liczy 28 osób.
- **Sale** - `205` i `32`.
- **Przedmioty** - Bazy danych, Programowanie obiektowe, Testowanie aplikacji, Aplikacje mobilne.
- **Konkretne zajęcia** - `3TI` ma Bazy danych we wtorek 1 grudnia 2026 o 8:00 w sali `205` oraz w czwartek 3 grudnia 2026 o 9:50 w sali `32`.

Chcemy opisać tę sytuację tak, żeby dało się ustalić, kto ma jakie zajęcia, kiedy i w której sali.

## Jak te rzeczy się łączą?

Uczeń należy do jednej klasy. Klasa ma zajęcia. Konkretne zajęcia są z jednego przedmiotu i odbywają się w jednej sali, w określonym dniu i o określonej godzinie.

Ile przedmiotów i ile spotkań opisują wtorkowe i czwartkowe Bazy danych? Najpierw zapisz swoją odpowiedź.

<details markdown="1" class="lesson-hint">
<summary>Pokaż podpowiedź - przedmiot a spotkania</summary>

Porównaj nazwę przedmiotu z terminami. Co jest wspólne, a co odróżnia te zajęcia?

</details>

<details markdown="1" class="lesson-solution">
<summary>Pokaż rozwiązanie - przedmiot a spotkania</summary>

Bazy danych to jeden przedmiot. Wtorek i czwartek to dwa różne spotkania tej samej klasy z tego przedmiotu.

</details>

Sala nie jest na stałe przypisana do klasy. Przypisujemy ją do konkretnych zajęć. Dlatego ta sama klasa może mieć kolejne spotkania w różnych salach.

Wtorkowe zajęcia przenosimy z `205` do `32`. Czy musimy zmieniać informację przy każdym uczniu, czy wystarczy poprawić jedno spotkanie? Ile poprawek wymagałby zapis sali osobno przy każdej z 28 osób?

<details markdown="1" class="lesson-hint">
<summary>Pokaż podpowiedź - zmiana sali</summary>

Zmienia się miejsce jednych zajęć całej klasy. Uczniowie nadal należą do tej samej klasy.

</details>

<details markdown="1" class="lesson-solution">
<summary>Pokaż rozwiązanie - zmiana sali</summary>

Wystarczy poprawić opis jednego spotkania. Gdyby jego salę zapisano przy każdym uczniu, trzeba byłoby poprawić 28 wpisów. Pominięcie części osób zostawiłoby sprzeczne informacje.

</details>

## Jak zapisać to w tabelach?

Rozdzielimy opis szkoły na pięć tabel. Każdy wiersz opisze jedną rzecz lub jedno spotkanie.

| Tabela | Co oznacza jeden wiersz? |
| --- | --- |
| `klasy` | Jedna klasa, np. `3TI`. |
| `uczniowie` | Jeden uczeń należący do jednej klasy. |
| `sale` | Jedna sala, np. `205`. |
| `przedmioty` | Jeden przedmiot, np. Bazy danych. |
| `zajecia` | Jedno spotkanie klasy z danego przedmiotu, w sali, w określonym dniu i o określonej godzinie. |

W tabeli `uczniowie` kolumna `id_ucznia` będzie wskazywać, o którego ucznia chodzi. To **klucz główny**: odróżnia jeden wiersz od pozostałych, nawet gdy dwie osoby mają takie samo imię i nazwisko.

Kolumna `id_klasy` w tym samym wierszu powie, do której klasy należy uczeń. To **klucz obcy**: wskazuje klucz główny w tabeli `klasy`. Kilku uczniów może wskazywać tę samą klasę.

<figure class="lesson-diagram">
<pre class="mermaid-source" hidden>
erDiagram
    klasy ||--o{ uczniowie : "id_klasy"
    klasy ||--o{ zajecia : "id_klasy"
    sale ||--o{ zajecia : "id_sali"
    przedmioty ||--o{ zajecia : "id_przedmiotu"
</pre>
<p class="diagram-fallback">Jedna klasa może mieć wielu uczniów i wiele zajęć. Jedna sala i jeden przedmiot mogą wystąpić w wielu zajęciach. Każdy uczeń wskazuje jedną klasę, a każde zajęcia jedną klasę, salę i przedmiot.</p>
<figcaption>Połączenie klasy z uczniami czytaj: jedna klasa może mieć wielu uczniów, a każdy uczeń należy do jednej klasy. Strona „wiele” może być na razie pusta.</figcaption>
</figure>

## Jak zamienić projekt na SQL?

Na zajęciach przechodź przez etapy w tempie ustalonym dla grupy. Jeśli pracujesz samodzielnie, wykonaj każdy krok, sprawdź wynik i dopiero w razie potrzeby otwórz podpowiedź lub rozwiązanie.

### Przygotuj bazę w phpMyAdmin

W panelu XAMPP uruchom Apache i MySQL, a potem wybierz **Admin** przy MySQL. W typowej instalacji ten moduł uruchamia serwer MariaDB, którym zarządzasz przez phpMyAdmin.

Kliknij: **Nowa => `uczniowie_ZS5` => `utf8mb4_polish_ci` => Utwórz**. Nazwę wpisz w polu nazwy bazy, a regułę wybierz z listy metod porównywania napisów.

`utf8mb4` odpowiada za zapis znaków, w tym polskich liter. `utf8mb4_polish_ci` określa porównywanie i sortowanie po polsku, bez rozróżniania wielkości liter.

Wybierz nową bazę w lewym panelu. Oczekujesz pustej listy tabel. Jeśli baza o tej nazwie już istnieje i ma tabele, zatrzymaj się, zamiast je usuwać lub wykonywać kolejne polecenia w niej.

W zakładce **SQL** wykonaj jedną kontrolę ustawień:

```sql
SHOW CREATE DATABASE uczniowie_ZS5;
```

W wyniku znajdź `CHARACTER SET utf8mb4` oraz `COLLATE utf8mb4_polish_ci`. Nasze tabele odziedziczą te ustawienia. Jeśli są inne, popraw je w **Operacje** pustej bazy przed tworzeniem tabel.

<details markdown="1" class="lesson-hint">
<summary>Gdy nie widzisz tej opcji</summary>

W zakładce **SQL** sprawdź dostępność reguły:

```sql
SHOW COLLATION WHERE Collation = 'utf8mb4_polish_ci';
```

Oczekujesz wiersza z `Collation = utf8mb4_polish_ci` i `Charset = utf8mb4`. Jeśli jest, odśwież listę w phpMyAdmin i wybierz tę regułę. Jeśli wynik jest pusty, skonsultuj konfigurację. Nie wybieraj przypadkowego zamiennika.

</details>

### Tabela klasy - pierwszy przykład

Przy wybranej bazie `uczniowie_ZS5` otwórz **SQL**. Wklej pełne polecenie i kliknij **Wykonaj**:

```sql
CREATE TABLE klasy (
    id_klasy INT AUTO_INCREMENT PRIMARY KEY,
    oznaczenie VARCHAR(10) NOT NULL UNIQUE
) ENGINE=InnoDB;
```

| Fragment kodu | Co robi? |
| --- | --- |
| `CREATE TABLE klasy` | Tworzy tabelę `klasy`. |
| `id_klasy INT` | Tworzy kolumnę na liczbowy identyfikator klasy. `INT` przechowuje liczby całkowite. |
| `AUTO_INCREMENT` | Baza sama nada numer przy dodawaniu wiersza. |
| `PRIMARY KEY` | Ustala klucz główny. Jego wartości nie mogą się powtarzać ani być `NULL`. |
| `oznaczenie VARCHAR(10)` | Tworzy kolumnę na tekst o długości do 10 znaków, np. `3TI`. |
| `NOT NULL` | Wymaga wartości innej niż `NULL`. `NULL` oznacza brak wartości. To ograniczenie nie zakazuje pustego napisu. |
| `UNIQUE` | Nie pozwala powtórzyć oznaczenia klasy według reguły porównywania tekstu. |
| `ENGINE=InnoDB` | Wybiera silnik tabeli, który obsługuje nasze klucze obce. |

Nawiasy obejmują definicje kolumn, przecinek je rozdziela, a średnik kończy polecenie. Po ostatniej kolumnie nie ma przecinka.

Po wykonaniu zobaczysz komunikat o powodzeniu i tabelę `klasy` na liście. Utworzenie tabeli nie zapisuje jeszcze klasy `3TI`. W wykonanej definicji znajdź, co identyfikuje wiersz, a co nie pozwala powtórzyć oznaczenia `3TI`.

### Tabela uczniowie - pierwszy klucz obcy

W tej samej bazie, w zakładce **SQL**, wykonaj kolejny pełny przykład:

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

Przeczytaj definicję po kolei:

- `CREATE TABLE uczniowie` tworzy tabelę na uczniów.
- `id_ucznia INT AUTO_INCREMENT PRIMARY KEY` nadaje każdemu przyszłemu uczniowi własny identyfikator.
- `imie VARCHAR(50) NOT NULL` rezerwuje do 50 znaków na imię.
- `nazwisko VARCHAR(80) NOT NULL` rezerwuje do 80 znaków na nazwisko. Imię i nazwisko nie mają `UNIQUE`, więc różne osoby mogą nazywać się tak samo.
- `id_klasy INT NOT NULL` wymaga wskazania klasy. Typ `INT` jest taki sam jak w `klasy.id_klasy`.
- `CONSTRAINT fk_uczniowie_klasy` nadaje nazwę powiązaniu.
- `FOREIGN KEY (id_klasy)` wskazuje kolumnę w tworzonej tabeli.
- `REFERENCES klasy(id_klasy)` wskazuje tabelę i kolumnę, do której prowadzi powiązanie. Przy dodawaniu ucznia baza będzie wymagać, aby wskazana klasa istniała.
- `ENGINE=InnoDB` pozostawia ten sam silnik co w tabeli `klasy`.

Po wykonaniu na liście pojawi się pusta tabela `uczniowie` z czterema kolumnami i powiązaniem do `klasy`.

**Twoja notatka:** opisz własnymi słowami, dlaczego dwóch uczniów tej samej klasy może mieć wspólne `id_klasy`, ale potrzebuje różnych `id_ucznia`.

### Tabela sale - wybierz typ i utwórz tabelę

Numery sal to `205`, `32` i hipotetyczne `32A`. Który typ wybierzesz dla `numer_sali`: `INT` czy `VARCHAR`? Zapisz uzasadnienie przed otwarciem rozwiązania.

Na podstawie `klasy` przygotuj tabelę z dwiema kolumnami: `id_sali INT` z autonumerem i kluczem głównym oraz obowiązkowym, unikalnym `numer_sali`. Przyjmij limit 10 znaków i silnik `InnoDB`. Po porównaniu z rozwiązaniem wykonaj zgodną definicję w **SQL** bazy `uczniowie_ZS5`. Oczekujesz komunikatu o powodzeniu i nowej, pustej tabeli `sale`.

<details markdown="1" class="lesson-hint">
<summary>Pokaż podpowiedź - sale</summary>

Sprawdź, czy wybrany typ pomieści każdy z trzech przykładów. Czy numer z drzwi służy do obliczeń?

</details>

<details markdown="1" class="lesson-solution">
<summary>Pokaż rozwiązanie - sale</summary>

```sql
CREATE TABLE sale (
    id_sali INT AUTO_INCREMENT PRIMARY KEY,
    numer_sali VARCHAR(10) NOT NULL UNIQUE
) ENGINE=InnoDB;
```

Numer sali jest etykietą. `VARCHAR(10)` mieści także `32A`, którego nie zapiszesz w `INT`.

</details>

### Tabela przedmioty - dobierz długość tekstu

Wróć do czterech nazw: `Bazy danych`, `Programowanie obiektowe`, `Testowanie aplikacji`, `Aplikacje mobilne`. Która nie mieści się w `VARCHAR(20)`? Policz znaki razem ze spacjami i zaproponuj limit z zapasem.

Przygotuj tabelę z `id_przedmiotu INT` z autonumerem i kluczem głównym oraz obowiązkową, unikalną kolumną `nazwa` typu `VARCHAR`. Wykorzystaj przykład `klasy` i silnik `InnoDB`. Porównaj swoją propozycję z ustaloną długością w rozwiązaniu, a następnie wykonaj zgodną definicję w **SQL** bazy `uczniowie_ZS5`. Na liście ma pojawić się pusta tabela `przedmioty` z dwiema kolumnami.

<details markdown="1" class="lesson-hint">
<summary>Pokaż podpowiedź - przedmioty</summary>

Spacja też zajmuje jeden znak. Limit powinien pomieścić wszystkie nazwy i zostawić miejsce na kolejne przedmioty.

</details>

<details markdown="1" class="lesson-solution">
<summary>Pokaż rozwiązanie - przedmioty</summary>

Nazwa `Programowanie obiektowe` ma 23 znaki. Przyjmujemy `VARCHAR(80)`, tak samo jak w pliku struktury.

```sql
CREATE TABLE przedmioty (
    id_przedmiotu INT AUTO_INCREMENT PRIMARY KEY,
    nazwa VARCHAR(80) NOT NULL UNIQUE
) ENGINE=InnoDB;
```

</details>

**Twoja notatka:** zapisz po jednym przykładzie, który uzasadnia typ numeru sali i długość nazwy przedmiotu.

### Tabela zajecia - połącz poznane relacje

Tę tabelę tworzymy na końcu, bo jej trzy klucze obce wymagają już istniejących tabel `klasy`, `sale` i `przedmioty`.

W tabeli `sale` sala `205` ma przykładowe `id_sali = 7`. Którą wartość zapiszesz w `zajecia.id_sali`? To przykład do rozumowania, nie dane zapisane już w naszej pustej bazie.

Przygotuj definicję według zestawienia. Zapis pierwszego klucza obcego znasz z `uczniowie`; tutaj zastosuj go trzy razy.

| Kolumna | Co zapisuje i jakiego typu wymaga? |
| --- | --- |
| `id_zajec` | Identyfikator spotkania: `INT`, autonumer, klucz główny. |
| `id_klasy` | Wskazanie `klasy.id_klasy`: `INT NOT NULL`. |
| `id_sali` | Wskazanie `sale.id_sali`: `INT NOT NULL`. |
| `id_przedmiotu` | Wskazanie `przedmioty.id_przedmiotu`: `INT NOT NULL`. |
| `data_zajec` | Data spotkania: `DATE NOT NULL`, np. `2026-12-01`. |
| `godzina_rozpoczecia` | Godzina rozpoczęcia: `TIME NOT NULL`, np. `08:00:00`. |

`DATE` przechowuje datę, a `TIME` posłuży tu do zapisania godziny. Porównaj definicję z rozwiązaniem i wykonaj ją w **SQL** bazy `uczniowie_ZS5`. Oczekujesz pustej tabeli `zajecia` z sześcioma kolumnami i trzema powiązaniami.

<details markdown="1" class="lesson-hint">
<summary>Pokaż podpowiedź - zajecia</summary>

Po kolumnach dopisz trzy ograniczenia `CONSTRAINT ... FOREIGN KEY ... REFERENCES ...`. Rozdziel je przecinkami. Wskazujesz identyfikatory, a nie numery z drzwi czy nazwy przedmiotów.

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

W przykładzie wybralibyśmy `7`, czyli identyfikator sali o numerze `205`. Kilka spotkań może wskazywać tę samą salę, klasę lub przedmiot, dlatego te klucze obce nie mają `UNIQUE`.

</details>

## Wspólna kontrola gotowej struktury

W phpMyAdmin wybierz `uczniowie_ZS5` i sprawdź:

- **Struktura bazy** => pięć tabel: `klasy`, `uczniowie`, `sale`, `przedmioty`, `zajecia`. Mają silnik `InnoDB` i regułę `utf8mb4_polish_ci`.
- **Struktura każdej tabeli** => jeden `PRIMARY KEY` z `AUTO_INCREMENT` (autonumerem). Razem pięć kluczy głównych.
- **Widok relacji** w strukturze tabel => jeden klucz obcy w `uczniowie` i trzy w `zajecia`. Razem cztery klucze obce.
- **Przeglądaj** każdej tabeli => brak rekordów. Powstała struktura, bez danych.

<details markdown="1" class="lesson-hint">
<summary>Pomoc - gdy wynik lub definicja budzi wątpliwości</summary>

W **SQL** możesz odczytać definicje i ustawienia:

```sql
SHOW CREATE TABLE klasy;
SHOW CREATE TABLE uczniowie;
SHOW CREATE TABLE sale;
SHOW CREATE TABLE przedmioty;
SHOW CREATE TABLE zajecia;
SHOW TABLE STATUS;
```

W definicjach znajdziesz klucze i autonumer. `int(11)` wyświetlone przez serwer nadal oznacza nasz `INT`. W statusie sprawdź `Engine = InnoDB` oraz `Collation = utf8mb4_polish_ci`. Wartość `Rows` dla InnoDB bywa szacunkowa. Dokładną liczbę wierszy otrzymasz tak:

```sql
SELECT COUNT(*) AS liczba_wierszy FROM klasy;
SELECT COUNT(*) AS liczba_wierszy FROM uczniowie;
SELECT COUNT(*) AS liczba_wierszy FROM sale;
SELECT COUNT(*) AS liczba_wierszy FROM przedmioty;
SELECT COUNT(*) AS liczba_wierszy FROM zajecia;
```

Każdy wynik ma wynosić `0`.

</details>

<details markdown="1" class="lesson-hint">
<summary>Pomoc - gdy tworzenie tabeli kończy się błędem</summary>

- **Nie ma wybranej bazy** => wybierz `uczniowie_ZS5` w lewym panelu i dopiero otwórz **SQL**.
- **Tabela już istnieje** => nie uruchamiaj jej definicji drugi raz. Sprawdź istniejącą strukturę zamiast usuwać tabelę.
- **Błąd składni** => porównaj przecinki, nawiasy i nazwy z przykładem.
- **Nie można utworzyć klucza obcego**, np. błąd `1005` z `errno: 150` => sprawdź, czy wskazywana tabela już istnieje. Kolejność to `klasy => uczniowie => sale => przedmioty => zajecia`. Porównaj też nazwy, typy obu końców relacji i silnik `InnoDB`. Nie zmieniaj jednego końca z `INT` na `INT UNSIGNED` i nie wyłączaj kontroli kluczy obcych.

Bezpośrednio po błędzie w **SQL** możesz wykonać:

```sql
SHOW WARNINGS;
```

Odczytaj szczegóły ostatniego błędu, popraw jego przyczynę i ponów tylko polecenie, które się nie udało. Nie odtwarzaj celowo błędów w gotowej bazie.

</details>

## Zapisz własne wnioski

Uzupełnij wcześniejsze notatki dwoma krótkimi zdaniami: dlaczego termin należy do zajęć, a nie do przedmiotu, oraz którą tabelę i kolumnę wskażesz przy przeniesieniu jednego spotkania z `205` do `32`. Użyj naszego przykładu zamiast przepisywać definicje.

<details markdown="1" class="lesson-hint">
<summary>Pokaż podpowiedź - wnioski</summary>

Ten sam przedmiot występuje we wtorek i w czwartek. Przy zmianie sali zmienia się opis jednego z tych spotkań. Odróżnij identyfikator sali od numeru na drzwiach.

</details>

<details markdown="1" class="lesson-solution">
<summary>Pokaż przykładowe rozwiązanie - wnioski</summary>

Wtorkowe i czwartkowe Bazy danych mają różne terminy, więc data i godzina opisują konkretne wiersze `zajecia`. Przy przeniesieniu jednego spotkania zmienialibyśmy jego `zajecia.id_sali` na identyfikator sali o numerze `32`, a nie dane uczniów ani numer `205` w tabeli `sale`.

Wiersz spotkania wskaże jego `id_zajec`. Nie znamy jeszcze rzeczywistych identyfikatorów, bo tabele pozostają puste.

</details>

## Plik struktury i dalsza droga

[Pobierz uczniowie_ZS5-struktura.sql]({{ '/assets/downloads/uczniowie_ZS5-struktura.sql' | relative_url }})

Plik UTF-8 bez BOM zawiera te same pięć definicji tabel. Użyj go do porównania swojej pracy. Możesz też odtworzyć strukturę w osobnej, **pustej** bazie `uczniowie_ZS5`, utworzonej wcześniej z ustawieniami `utf8mb4` i `utf8mb4_polish_ci`.

Import: **wybierz pustą bazę => Import => `uczniowie_ZS5-struktura.sql` => UTF-8 (`utf-8` na liście) => wykonaj**. Następnie przejdź przez wspólną kontrolę powyżej. Nie importuj pliku do bazy, w której masz już te tabele.

**Utworzone tabele => `INSERT` dodaje dane => `SELECT` je odczytuje => `UPDATE` je zmienia.**

W tej lekcji zatrzymujemy się na tworzeniu tabel. Dane dodasz w następnej lekcji: [Wypełniamy bazę uczniowie_ZS5 - INSERT krok po kroku]({{ '/10-projekt-bazy/02-uczniowie-zs5-insert.html' | relative_url }}).
