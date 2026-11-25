---
title: Wypełniamy bazę uczniowie_ZS5 - INSERT krok po kroku
---

# Wypełniamy bazę uczniowie_ZS5 - INSERT krok po kroku

## Najpierw kolejność, potem dane

Pracujesz na pustej strukturze z [poprzedniej lekcji]({{ '/10-projekt-bazy/01-uczniowie-zs5.html' | relative_url }}). Wybierz w phpMyAdmin bazę `uczniowie_ZS5`. Ma zawierać pięć pustych tabel, z ustawieniami `utf8mb4` i `utf8mb4_polish_ci`.

Wprowadzisz jeden zestaw: **3 klasy, 3 sale, 4 przedmioty, 8 uczniów i 6 spotkań**. Osoby, klasy i plan są fikcyjne. Kontekst to zajęcia ZS5 przy ul. Ogrodowej w Wałbrzychu.

Kolejność pracy:

1. **Słowniki => `klasy`, `sale`, `przedmioty`.** Najpierw zapisujesz wartości, które będą wskazywane z innych tabel.
2. **Tabela podstawowa => `uczniowie`.** Każdy uczeń wskazuje istniejącą klasę.
3. **Powiązania, czyli asocjacje => `zajecia`.** Jeden wiersz łączy istniejącą klasę, salę i przedmiot oraz opisuje termin spotkania. Nie łączy pojedynczych uczniów i nie jest samą listą identyfikatorów.

Chcesz zapisać, że `3TI` ma przedmiot „Bazy danych” w sali `205`. Klucze obce muszą wskazać konkretne wiersze słowników. Dopóki tych wierszy nie ma, nie da się poprawnie wskazać klasy, sali i przedmiotu.

Trzy słowniki możesz zasilić w dowolnej kolejności między sobą. `zajecia` wymagają słowników, ale **nie wymagają wcześniejszego dodania uczniów**. Umieszczamy je na końcu jako ostatni etap nauki. To kolejność dydaktyczna, a nie dodatkowe ograniczenie SQL.

Pracuj według zasady **przewidź => wykonaj => sprawdź => zanotuj**. Na zajęciach zatrzymaj się po każdym etapie na kontrolę wyniku. Samodzielnie porównaj wynik z opisem, a w razie potrzeby rozwiń podpowiedź i rozwiązanie.

Wszystkie polecenia wykonuj w zakładce **SQL** wybranej bazy. Każdy poprawny `INSERT` wykonaj tylko raz. Rozwiązanie służy do porównania lub wykonania brakującego kroku, nie do ponownego dodania tych samych danych. Zapytania `SELECT` możesz powtarzać.

## Etap 1 - słowniki

### Jeden wiersz klasy

Po wykonaniu poniższego polecenia ile wierszy powinno przybyć w `klasy`? Zapisz przewidywanie, a potem wykonaj przykład:

```sql
INSERT INTO klasy (oznaczenie) VALUES ('3TI');
```

- `INSERT INTO klasy` wybiera tabelę docelową.
- `(oznaczenie)` to jawna lista kolumn, do których dodajesz dane.
- `VALUES ('3TI')` dostarcza wartości w tej samej kolejności co kolumny.
- Apostrofy oznaczają tekst. `3TI` jest oznaczeniem klasy.

Nie podajesz `id_klasy`. Wartość nada `AUTO_INCREMENT`.

Sprawdź efekt:

```sql
SELECT id_klasy, oznaczenie FROM klasy;
```

Oczekujesz jednego wiersza z oznaczeniem `3TI` i identyfikatorem nadanym przez twoją bazę. Nie zakładaj, że identyfikator wynosi `1`.

### Kilka wierszy jednym poleceniem

Dodaj pozostałe dwie klasy:

```sql
INSERT INTO klasy (oznaczenie) VALUES
    ('4TI'),
    ('3TP');
```

Każda para nawiasów po `VALUES` opisuje osobny wiersz. Między wierszami jest przecinek, a średnik zamyka całe polecenie. Wartości nadal odpowiadają tej samej liście kolumn.

Uruchom ponownie wcześniejszy `SELECT`. Teraz mają istnieć dokładnie trzy klasy: `3TI`, `4TI`, `3TP`.

### Ćwiczenie 1 - pozostałe słowniki

Dodaj sale `205`, `32` i fikcyjną `32A` jednym poleceniem. Wszystkie trzy oznaczenia zapisz jako tekst w kolumnie `numer_sali`.

Drugim poleceniem dodaj cztery nazwy do `przedmioty.nazwa`:

- `Bazy danych`.
- `Programowanie obiektowe`.
- `Testowanie aplikacji`.
- `Aplikacje mobilne`.

Nie podawaj identyfikatorów słowników. Ile grup wartości po `VALUES` potrzebujesz w każdym z dwóch poleceń?

<details markdown="1" class="lesson-hint">
<summary>Pokaż podpowiedź - ćwiczenie 1</summary>

Lista kolumn występuje raz. Każdy nowy wiersz ma własną grupę wartości. Sprawdź, czy nie pomyliłeś przecinka między wierszami ze średnikiem kończącym polecenie.

</details>

<details markdown="1" class="lesson-solution">
<summary>Pokaż rozwiązanie - ćwiczenie 1</summary>

```sql
INSERT INTO sale (numer_sali) VALUES
    ('205'),
    ('32'),
    ('32A');

INSERT INTO przedmioty (nazwa) VALUES
    ('Bazy danych'),
    ('Programowanie obiektowe'),
    ('Testowanie aplikacji'),
    ('Aplikacje mobilne');
```

Pierwsze polecenie dodaje trzy wiersze, drugie cztery. Numery sal są etykietami, dlatego również `205` i `32` mają apostrofy.

</details>

### Sprawdź i zanotuj

```sql
SELECT id_sali, numer_sali FROM sale ORDER BY numer_sali;
SELECT id_przedmiotu, nazwa FROM przedmioty ORDER BY nazwa;
```

Oczekujesz trzech sal i czterech przedmiotów dokładnie o podanych nazwach. Razem z trzema klasami słowniki są gotowe. Zapisz: które identyfikatory nadała baza, a jakie dane wpisałeś samodzielnie?

## Gdy odczyt identyfikatora niczego nie znajdzie

W następnych krokach `SELECT` ma znaleźć dokładnie jeden wiersz. Jeśli wynik jest pusty, **zatrzymaj się przed `INSERT` wymagającym tego wskazania**.

- Sprawdź, czy wybrana jest baza `uczniowie_ZS5`.
- Porównaj oznaczenie lub nazwę z listą odpowiedniego słownika. Zwróć uwagę na spacje i literówki.
- Jeśli brakuje wiersza z zestawu, wróć do etapu 1 i wykonaj brakujący krok tylko raz.

Nie zastępuj brakującego wyniku zerem ani numerem zgadniętym z przykładu.

## Etap 2 - uczniowie

### Najpierw wybierz klasę

Pierwszy fikcyjny uczeń to **Łukasz Lis z `3TI`**. Zanim go dodasz, odczytaj identyfikator klasy:

```sql
SELECT id_klasy FROM klasy WHERE oznaczenie = '3TI';
```

Załóżmy, że przykładowy wynik wynosi `7`. To tylko przykład - w swoim poleceniu użyj liczby zwróconej przez **twoją bazę**. Jeśli dostałeś inną wartość, zastąp nią `7` w poniższym kodzie.

```sql
INSERT INTO uczniowie (imie, nazwisko, id_klasy)
VALUES ('Łukasz', 'Lis', 7);
```

**Pomijasz `id_ucznia`, bo nada go baza. Podajesz `id_klasy`, bo sam wybierasz klasę ucznia.** Nie nadajesz nowego identyfikatora klasy - wskazujesz już istniejącą klasę.

```sql
SELECT id_ucznia, imie, nazwisko, id_klasy
FROM uczniowie
ORDER BY id_ucznia;
```

Oczekujesz jednego ucznia: Łukasz Lis, ze wskazaniem klasy odczytanym wcześniej. Zwróć uwagę na poprawny zapis litery `Ł`.

### Ćwiczenie 2 - sprawdź identyfikator i dodaj dwie osoby

Do tej samej klasy `3TI` dodaj **Zofię Łoś** i **Michała Maka**. W kolumnach zapisz formy imion i nazwisk: `Zofia`, `Łoś`, `Michał`, `Mak`.

Najpierw ponownie sprawdź identyfikator klasy prostym `SELECT`. Użyj wyniku w jednym poleceniu dodającym obie osoby. Po wykonaniu wskaż, która wartość jest wspólna dla trzech uczniów, a która odróżnia ich wiersze.

<details markdown="1" class="lesson-hint">
<summary>Pokaż podpowiedź - ćwiczenie 2</summary>

Nie wybierasz nowej klasy, tylko dwa razy wskazujesz tę samą. Porównaj rolę identyfikatora nadawanego uczniowi z rolą wskazania klasy. Nie kopiuj liczby z przykładu bez sprawdzenia wyniku odczytu.

</details>

<details markdown="1" class="lesson-solution">
<summary>Pokaż rozwiązanie - ćwiczenie 2</summary>

```sql
SELECT id_klasy FROM klasy WHERE oznaczenie = '3TI';
```

Dla przykładowego wyniku `7` polecenie wygląda tak. Podstaw własny wynik:

```sql
INSERT INTO uczniowie (imie, nazwisko, id_klasy) VALUES
    ('Zofia', 'Łoś', 7),
    ('Michał', 'Mak', 7);
```

Wspólny jest `id_klasy`. Każda z trzech osób ma własny `id_ucznia`, nadany automatycznie. W tabeli powinny być teraz trzy wiersze.

</details>

### Domknij zestaw ośmiu uczniów

Dodaj jeszcze pięć fikcyjnych osób:

| Imię | Nazwisko | Klasa |
| --- | --- | --- |
| Anna | Żuk | 4TI |
| Paweł | Ćwik | 4TI |
| Julia | Śliwa | 3TP |
| Łucja | Zając | 3TP |
| Stanisław | Żak | 4TI |

Odczytaj identyfikatory obu klas, zamiast zakładać, że są kolejnymi liczbami:

```sql
SELECT id_klasy FROM klasy WHERE oznaczenie = '4TI';
SELECT id_klasy FROM klasy WHERE oznaczenie = '3TP';
```

<details markdown="1" class="lesson-hint">
<summary>Pokaż podpowiedź - pozostałe osoby</summary>

Przy każdym wierszu dobierz wskazanie na podstawie ostatniej kolumny tabeli. Nie przenoś identyfikatora `3TI` do wszystkich nowych osób.

</details>

<details markdown="1" class="lesson-solution">
<summary>Pokaż rozwiązanie - pozostałe osoby</summary>

Jeśli przykładowe wyniki to `4TI => 8` oraz `3TP => 9`, zapis będzie następujący. Zastąp te liczby swoimi wynikami:

```sql
INSERT INTO uczniowie (imie, nazwisko, id_klasy) VALUES
    ('Anna', 'Żuk', 8),
    ('Paweł', 'Ćwik', 8),
    ('Julia', 'Śliwa', 9),
    ('Łucja', 'Zając', 9),
    ('Stanisław', 'Żak', 8);
```

</details>

### Sprawdź i zanotuj

Uruchom ponownie zapytanie wypisujące uczniów. Oczekujesz **8 osób**: trzy w `3TI`, trzy w `4TI` i dwie w `3TP`. Zapisz, dlaczego pomijasz `id_ucznia`, ale nie możesz pominąć `id_klasy`.

## Etap 3 - konkretne zajęcia

### Przygotuj jedno spotkanie

Zapiszesz spotkanie klasy `3TI` z przedmiotu **Bazy danych**, w sali `205`, we wtorek **2026-12-01 o 08:00:00**.

W `zajecia` wskazujesz klasę, salę i przedmiot. Nie wybierasz pojedynczych uczniów. Tabela nie ma klucza obcego do `uczniowie`.

Odczytaj trzy wskazania:

```sql
SELECT id_klasy FROM klasy WHERE oznaczenie = '3TI';
SELECT id_sali FROM sale WHERE numer_sali = '205';
SELECT id_przedmiotu FROM przedmioty WHERE nazwa = 'Bazy danych';
```

Przykładowe wyniki odczytu:

| Co odczytano? | Przykładowy wynik |
| --- | --- |
| Klasa `3TI` | `id_klasy = 7` |
| Sala `205` | `id_sali = 12` |
| Bazy danych | `id_przedmiotu = 21` |

Zastąp te trzy liczby własnymi wynikami. **`numer_sali = '205'` nie oznacza `id_sali = 205`.** Numer z drzwi i identyfikator wiersza to różne rzeczy.

Data ma format `RRRR-MM-DD`, a godzina `HH:MM:SS`. Obie wartości zapisujemy w apostrofach:

```sql
INSERT INTO zajecia
    (id_klasy, id_sali, id_przedmiotu, data_zajec, godzina_rozpoczecia)
VALUES (7, 12, 21, '2026-12-01', '08:00:00');
```

Kolejność wartości odpowiada jawnej liście pięciu kolumn. `id_zajec` pomijamy, bo nada go baza.

### Sprawdź spotkanie przez JOIN

Zamiast samych numerów wierszy wyświetl nazwy i termin:

```sql
SELECT zajecia.data_zajec, zajecia.godzina_rozpoczecia,
       klasy.oznaczenie, przedmioty.nazwa, sale.numer_sali
FROM zajecia
INNER JOIN klasy ON zajecia.id_klasy = klasy.id_klasy
INNER JOIN sale ON zajecia.id_sali = sale.id_sali
INNER JOIN przedmioty ON zajecia.id_przedmiotu = przedmioty.id_przedmiotu
ORDER BY zajecia.data_zajec, zajecia.godzina_rozpoczecia;
```

Oczekujesz jednego wiersza:

| Data | Godzina | Klasa | Przedmiot | Sala |
| --- | --- | --- | --- | --- |
| 2026-12-01 | 08:00:00 | 3TI | Bazy danych | 205 |

### Ćwiczenie 3 - dlaczego klucz obcy odrzuca wiersz?

Przygotowujesz drugie spotkanie tej samej klasy i przedmiotu: **2026-12-03 o 09:50:00**, docelowo w sali `32`. W poleceniu ktoś podał jednak `id_sali = 999999`.

Najpierw sprawdź, czy takie wskazanie faktycznie nie istnieje:

```sql
SELECT id_sali, numer_sali FROM sale WHERE id_sali = 999999;
```

Oczekiwany wynik tej próby to brak wierszy. Jeśli u ciebie ta liczba oznacza istniejącą salę, wybierz inną nieistniejącą wartość i sprawdź ją tak samo.

Podstaw własne, poprawne identyfikatory klasy i przedmiotu zamiast przykładowych `7` i `21`. Zachowaj celowo błędne wskazanie sali. Przewidź wynik i wykonaj próbę:

```sql
INSERT INTO zajecia
    (id_klasy, id_sali, id_przedmiotu, data_zajec, godzina_rozpoczecia)
VALUES (7, 999999, 21, '2026-12-03', '09:50:00');
```

Co zgłosi serwer? Jak ustalisz poprawne wskazanie sali `32` bez wyłączania ograniczeń? Nie dodawaj jeszcze poprawionego spotkania - zrobisz to w ćwiczeniu 4.

<details markdown="1" class="lesson-hint">
<summary>Pokaż podpowiedź - ćwiczenie 3</summary>

Klucz obcy ma znaleźć wiersz, nie samą dowolną liczbę. Szukaj sali po znanej etykiecie z drzwi. Błąd wskazania nie jest powodem do wyłączenia relacji.

</details>

<details markdown="1" class="lesson-solution">
<summary>Pokaż rozwiązanie - ćwiczenie 3</summary>

MariaDB odrzuci polecenie błędem klucza obcego, zwykle `1452`. Wiersz sali o wskazanym identyfikatorze nie istnieje. Próba nie powinna dodać spotkania.

```sql
SELECT id_sali FROM sale WHERE numer_sali = '32';
SELECT COUNT(*) AS liczba_spotkan FROM zajecia;
```

Pierwszy wynik jest poprawnym wskazaniem sali, np. `13`. Jeśli nie ma wyniku, wróć do kontroli słownika sal. Drugi wynik nadal ma wynosić `1`.

Odrzucona próba może pozostawić lukę w autonumerze. Nie oceniaj liczby wierszy na podstawie ostatniego numeru. W następnej próbie użyjesz odczytanego wskazania, a nie wymyślonej wartości.

</details>

### Ćwiczenie 4 - kolejne spotkanie z istniejących danych

Dodaj poprawnie spotkanie przygotowane wyżej: `3TI`, Bazy danych, sala `32`, **2026-12-03 o 09:50:00**. Najpierw odczytaj identyfikatory klasy, sali i przedmiotu. Zapisz nowy wiersz z jawną listą kolumn.

<details markdown="1" class="lesson-hint">
<summary>Pokaż podpowiedź - ćwiczenie 4</summary>

Klasa i przedmiot pozostają te same co we wtorek. Inna jest sala i termin. Użyj istniejących słowników, zamiast tworzyć drugi wpis tego samego przedmiotu.

</details>

<details markdown="1" class="lesson-solution">
<summary>Pokaż rozwiązanie - ćwiczenie 4</summary>

```sql
SELECT id_klasy FROM klasy WHERE oznaczenie = '3TI';
SELECT id_sali FROM sale WHERE numer_sali = '32';
SELECT id_przedmiotu FROM przedmioty WHERE nazwa = 'Bazy danych';
```

Dla przykładowych wyników `7`, `13`, `21` polecenie wygląda tak. Użyj własnych wyników:

```sql
INSERT INTO zajecia
    (id_klasy, id_sali, id_przedmiotu, data_zajec, godzina_rozpoczecia)
VALUES (7, 13, 21, '2026-12-03', '09:50:00');
```

Po ponownym wykonaniu wcześniejszego `JOIN` zobaczysz dwa spotkania: wtorkowe w `205` i czwartkowe w `32`. Pierwszy wiersz nadal opisuje wtorek. Drugie spotkanie jest nowym wierszem.

</details>

### Domknij zestaw sześciu spotkań

Masz już dwa spotkania. Dodaj pozostałe cztery:

| Klasa | Sala | Przedmiot | Data | Godzina |
| --- | --- | --- | --- | --- |
| 3TI | 32A | Programowanie obiektowe | 2026-12-02 | 08:55:00 |
| 4TI | 205 | Testowanie aplikacji | 2026-12-02 | 10:45:00 |
| 3TP | 32 | Aplikacje mobilne | 2026-12-03 | 08:00:00 |
| 4TI | 32A | Bazy danych | 2026-12-04 | 11:40:00 |

Odczytaj aktualną mapę wskazań:

```sql
SELECT id_klasy, oznaczenie FROM klasy ORDER BY oznaczenie;
SELECT id_sali, numer_sali FROM sale ORDER BY numer_sali;
SELECT id_przedmiotu, nazwa FROM przedmioty ORDER BY nazwa;
```

<details markdown="1" class="lesson-hint">
<summary>Pokaż podpowiedź - pozostałe spotkania</summary>

Dla każdego wiersza dobierz trzy wskazania z odpowiednich słowników. Nazwa przedmiotu i numer sali są opisem wyboru, ale do kolumn kluczy obcych trafiają identyfikatory.

</details>

<details markdown="1" class="lesson-solution">
<summary>Pokaż rozwiązanie - pozostałe spotkania</summary>

Poniższy przykład korzysta z takiej mapy. Twoje liczby mogą być inne:

| Słownik | Przykładowe wskazania |
| --- | --- |
| Klasy | `3TI => 7`, `4TI => 8`, `3TP => 9` |
| Sale | `205 => 12`, `32 => 13`, `32A => 14` |
| Przedmioty | `Bazy danych => 21`, `Programowanie obiektowe => 22`, `Testowanie aplikacji => 23`, `Aplikacje mobilne => 24` |

Podstaw własne liczby i wykonaj jedno polecenie:

```sql
INSERT INTO zajecia
    (id_klasy, id_sali, id_przedmiotu, data_zajec, godzina_rozpoczecia) VALUES
    (7, 14, 22, '2026-12-02', '08:55:00'),
    (8, 12, 23, '2026-12-02', '10:45:00'),
    (9, 13, 24, '2026-12-03', '08:00:00'),
    (8, 14, 21, '2026-12-04', '11:40:00');
```

</details>

### Sprawdź i zanotuj

Uruchom ponownie zapytanie `JOIN`. Ma zwrócić sześć wierszy. Zanotuj, jakie wskazania i jaki termin opisują jedno spotkanie oraz skąd wziąłeś identyfikatory.

## Kontrola całego zestawu

### Liczby wierszy

```sql
SELECT COUNT(*) AS liczba_klas FROM klasy;
SELECT COUNT(*) AS liczba_sal FROM sale;
SELECT COUNT(*) AS liczba_przedmiotow FROM przedmioty;
SELECT COUNT(*) AS liczba_uczniow FROM uczniowie;
SELECT COUNT(*) AS liczba_spotkan FROM zajecia;
```

Oczekujesz kolejno **3, 3, 4, 8, 6**. Jeśli liczby się różnią, porównaj zawartość z etapami. Nie dodawaj ponownie całego zestawu na próbę.

### Polskie znaki i sortowanie

```sql
SELECT imie, nazwisko FROM uczniowie ORDER BY nazwisko, imie;
SELECT nazwa FROM przedmioty ORDER BY nazwa;
```

Sprawdź czytelność liter w imionach i nazwiskach, np. `Łukasz`, `Michał`, `Łoś`, `Ćwik`, `Śliwa`, `Żak`. Nie powinny pojawiać się znaki zapytania ani przekłamane litery. Nazwy czterech przedmiotów mają być zgodne ze słownikiem z etapu 1.

<details markdown="1" class="lesson-solution">
<summary>Pokaż wynik sortowania uczniów</summary>

| Imię | Nazwisko |
| --- | --- |
| Paweł | Ćwik |
| Łukasz | Lis |
| Zofia | Łoś |
| Michał | Mak |
| Julia | Śliwa |
| Łucja | Zając |
| Stanisław | Żak |
| Anna | Żuk |

Fragment `Lis => Łoś => Mak` pokazuje polską kolejność. Litera `Ł` nie trafia dopiero na koniec listy. Zachowane `utf8mb4` odpowiada za zapis znaków, a `utf8mb4_polish_ci` za ich porównywanie i kolejność sortowania.

</details>

### Wynik połączenia sześciu spotkań

<details markdown="1" class="lesson-solution">
<summary>Pokaż oczekiwany wynik JOIN</summary>

| Data | Godzina | Klasa | Przedmiot | Sala |
| --- | --- | --- | --- | --- |
| 2026-12-01 | 08:00:00 | 3TI | Bazy danych | 205 |
| 2026-12-02 | 08:55:00 | 3TI | Programowanie obiektowe | 32A |
| 2026-12-02 | 10:45:00 | 4TI | Testowanie aplikacji | 205 |
| 2026-12-03 | 08:00:00 | 3TP | Aplikacje mobilne | 32 |
| 2026-12-03 | 09:50:00 | 3TI | Bazy danych | 32 |
| 2026-12-04 | 11:40:00 | 4TI | Bazy danych | 32A |

Wynik opisuje powiązania nazwami. Wartości identyfikatorów mogą się różnić między bazami, ale te sześć spotkań ma być takie samo.

</details>

## Krótka notatka do uzupełnienia

**tabela => jakie dane dodaję => które identyfikatory nadaje baza => które muszę wskazać samodzielnie**.

Wypełnij po jednym wierszu dla słowników, uczniów i zajęć. Wyjaśnij różnicę między numerem sali a identyfikatorem jej wiersza.

## Podsumowanie

**Słowniki => uczniowie => zajęcia.** Najpierw zapisujesz wartości docelowe, potem wskazania. Uczniowie wymagają istniejącej klasy. Zajęcia wymagają klasy, sali i przedmiotu, ale nie wymagają wcześniejszych wierszy uczniów. Końcowy zestaw to **3 klasy, 3 sale, 4 przedmioty, 8 osób i 6 spotkań**.

## Dwa alternatywne pliki do pobrania

- [uczniowie_ZS5-dane.sql]({{ '/assets/downloads/uczniowie_ZS5-dane.sql' | relative_url }}) - tylko dane do pięciu wcześniej utworzonych **pustych tabel**.
- [uczniowie_ZS5-komplet.sql]({{ '/assets/downloads/uczniowie_ZS5-komplet.sql' | relative_url }}) - ta sama struktura i te same dane do **pustej bazy** `uczniowie_ZS5`, bez tabel, założonej wcześniej w phpMyAdmin.

To **dwie alternatywy, nie dwa importy po sobie**. Jeśli wprowadziłeś dane ręcznie według lekcji, nie importuj ich ponownie. Pliki nie usuwają istniejących danych.

W phpMyAdmin: **wybierz bazę `uczniowie_ZS5` => Import => jeden właściwy plik => UTF-8 (`utf-8`) => wykonaj => sprawdź wynik**. W bazie zachowaj `utf8mb4` i `utf8mb4_polish_ci`. Oba pliki są zapisane w UTF-8 bez BOM.

Pliki samodzielnie odczytują powiązania po unikalnych oznaczeniach klas, numerach sal i nazwach przedmiotów. Nie zakładają startu autonumeru od `1`. Ten dodatkowy zapis w plikach służy odtworzeniu zestawu; w głównym toku lekcji odczytujesz identyfikatory zwykłym `SELECT` i sam wpisujesz je do `INSERT`.

Po wybranym wariancie wykonaj te same kontrole: liczby wierszy, powiązania przez `JOIN`, polskie znaki i `ORDER BY`.
