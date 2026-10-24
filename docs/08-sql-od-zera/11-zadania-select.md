---
title: ZBIÓR ZADAŃ 1 - SELECT. 20 zadań
---

# ZBIÓR ZADAŃ 1 - SELECT. 20 zadań

Dwadzieścia zadań sprawdzi, czy potrafisz samodzielnie wybierać dane i budować warunki. Każde zadanie rozwiąż osobno.

Wykonaj zadania na niezmienionej bazie `Islandia`. Najpierw napisz własne zapytanie w phpMyAdmin. Potem rozwiń rozwiązanie i porównaj wynik.

## Zadanie 1 - Wszystkie dane turystów

Wyświetl wszystkie kolumny i wszystkie rekordy tabeli `turysci`.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT *
FROM turysci;
```

Wynik: **13 rekordów**. Przykładowe wiersze: `idTurysta` = `1`, `nick` = `Ewa`, `punkty` = `23`; `idTurysta` = `2`, `nick` = `Monika`, `punkty` = `4`; `idTurysta` = `3`, `nick` = `Janek`, `punkty` = `12`. Bez `ORDER BY` kolejność nie jest gwarantowana.

</details>

## Zadanie 2 - Nicki i punkty

Wyświetl nicki i punkty wszystkich turystów. Pomiń kolumnę identyfikatora.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick, punkty
FROM turysci;
```

Wynik: **13 rekordów**. Przykładowe wiersze: `nick` = `Ewa`, `punkty` = `23`; `nick` = `Monika`, `punkty` = `4`; `nick` = `Janek`, `punkty` = `12`. Bez `ORDER BY` kolejność nie jest gwarantowana.

</details>

## Zadanie 3 - Identyfikatory i nicki

Wyświetl identyfikatory i nicki turystów. Uporządkuj rekordy według identyfikatora rosnąco.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT idTurysta, nick
FROM turysci
ORDER BY idTurysta ASC;
```

Wynik: **13 rekordów**. Przykładowe wiersze: `idTurysta` = `1`, `nick` = `Ewa`; `idTurysta` = `2`, `nick` = `Monika`; `idTurysta` = `3`, `nick` = `Janek`. Kolejność rośnie według `idTurysta`: od Ewy (1) do Adama (13).

</details>

## Zadanie 4 - Jeden turysta

Wyświetl nick i punkty turysty o nicku `Ewa`.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE nick = 'Ewa';
```

Wynik: **1 rekord**. Przykładowe wiersze: `nick` = `Ewa`, `punkty` = `23`.

</details>

## Zadanie 5 - Dokładnie 23 punkty

Wyświetl nicki i punkty wszystkich turystów mających dokładnie 23 punkty.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty = 23;
```

Wynik: **2 rekordy**. Przykładowe wiersze: `nick` = `Ewa`, `punkty` = `23`; `nick` = `Paula`, `punkty` = `23`. Bez `ORDER BY` kolejność nie jest gwarantowana.

</details>

## Zadanie 6 - Inny wynik

Wyświetl nicki i punkty turystów, których wynik jest różny od 23.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty <> 23;
```

Wynik: **11 rekordów**. Przykładowe wiersze: `nick` = `Monika`, `punkty` = `4`; `nick` = `Janek`, `punkty` = `12`; `nick` = `Krzysiek`, `punkty` = `5`. Bez `ORDER BY` kolejność nie jest gwarantowana.

</details>

## Zadanie 7 - Najwyżej 7 punktów

Wyświetl nicki i punkty turystów, którzy mają najwyżej 7 punktów.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty <= 7;
```

Wynik: **3 rekordy**. Przykładowe wiersze: `nick` = `Monika`, `punkty` = `4`; `nick` = `Krzysiek`, `punkty` = `5`; `nick` = `Ania`, `punkty` = `7`. Bez `ORDER BY` kolejność nie jest gwarantowana.

</details>

## Zadanie 8 - Punkty od 11 do 23

Wyświetl nicki i punkty turystów mających od 11 do 23 punktów, łącznie z obiema granicami.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty BETWEEN 11 AND 23;
```

Wynik: **6 rekordów**. Przykładowe wiersze: `nick` = `Ewa`, `punkty` = `23`; `nick` = `Janek`, `punkty` = `12`; `nick` = `Paula`, `punkty` = `23`. Bez `ORDER BY` kolejność nie jest gwarantowana.

</details>

## Zadanie 9 - Wyniki poza przedziałem

Wyświetl nicki i punkty turystów, których wynik znajduje się poza przedziałem od 11 do 23 punktów.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty NOT BETWEEN 11 AND 23;
```

Wynik: **7 rekordów**. Przykładowe wiersze: `nick` = `Monika`, `punkty` = `4`; `nick` = `Krzysiek`, `punkty` = `5`; `nick` = `Ania`, `punkty` = `7`. Bez `ORDER BY` kolejność nie jest gwarantowana.

</details>

## Zadanie 10 - Trzy możliwe wyniki

Wyświetl nicki i punkty osób, które mają 4, 5 albo 7 punktów.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty IN (4, 5, 7);
```

Wynik: **3 rekordy**. Przykładowe wiersze: `nick` = `Monika`, `punkty` = `4`; `nick` = `Krzysiek`, `punkty` = `5`; `nick` = `Ania`, `punkty` = `7`. Bez `ORDER BY` kolejność nie jest gwarantowana.

</details>

## Zadanie 11 - Pomiń dwie wartości

Wyświetl nicki i punkty osób, które nie mają ani 11, ani 23 punktów.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty NOT IN (11, 23);
```

Wynik: **9 rekordów**. Przykładowe wiersze: `nick` = `Monika`, `punkty` = `4`; `nick` = `Janek`, `punkty` = `12`; `nick` = `Krzysiek`, `punkty` = `5`. Bez `ORDER BY` kolejność nie jest gwarantowana.

</details>

## Zadanie 12 - Początek nicka

Wyświetl nicki zaczynające się od litery `J`.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick
FROM turysci
WHERE nick LIKE 'J%';
```

Wynik: **2 rekordy**. Przykładowe wiersze: `nick` = `Janek`; `nick` = `Jowita`. Bez `ORDER BY` kolejność nie jest gwarantowana.

</details>

## Zadanie 13 - Trzy znaki

Wyświetl nicki składające się z dokładnie trzech znaków.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick
FROM turysci
WHERE nick LIKE '___';
```

Wynik: **3 rekordy**. Przykładowe wiersze: `nick` = `Ewa`; `nick` = `Ela`; `nick` = `Ola`. Bez `ORDER BY` kolejność nie jest gwarantowana.

</details>

## Zadanie 14 - Koniec nicka

Wyświetl nicki kończące się na `ek`.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick
FROM turysci
WHERE nick LIKE '%ek';
```

Wynik: **5 rekordów**. Przykładowe wiersze: `nick` = `Janek`; `nick` = `Krzysiek`; `nick` = `Piotrek`. Bez `ORDER BY` kolejność nie jest gwarantowana.

</details>

## Zadanie 15 - Bez litery A na początku

Wyświetl nicki, które nie zaczynają się od litery `A`.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick
FROM turysci
WHERE nick NOT LIKE 'A%';
```

Wynik: **11 rekordów**. Przykładowe wiersze: `nick` = `Ewa`; `nick` = `Monika`; `nick` = `Janek`. Bez `ORDER BY` kolejność nie jest gwarantowana.

</details>

## Zadanie 16 - Brak opisu

Sprawdź, czy w tabeli `obiekty` istnieją rekordy z wartością `NULL` w kolumnie `opis`. Wyświetl ich identyfikatory i nazwy. Pamiętaj, że `NULL` i pusty tekst to różne wartości.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT idObiekt, nazwa
FROM obiekty
WHERE opis IS NULL;
```

Wynik: **0 rekordów**. W bazie Islandia w kolumnie `opis` są puste teksty, ale nie ma wartości `NULL`.

</details>

## Zadanie 17 - Punkty i początek nicka

Wyświetl nicki i punkty osób, które mają ponad 20 punktów, a ich nick zaczyna się od `P`.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty > 20 AND nick LIKE 'P%';
```

Wynik: **2 rekordy**. Przykładowe wiersze: `nick` = `Paula`, `punkty` = `23`; `nick` = `Piotrek`, `punkty` = `21`. Bez `ORDER BY` kolejność nie jest gwarantowana.

</details>

## Zadanie 18 - Dwa początki nicka

Wyświetl nicki i punkty osób, które mają ponad 20 punktów, a ich nick zaczyna się od `E` lub `P`. Warunek punktów ma dotyczyć obu liter.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty > 20 AND (nick LIKE 'E%' OR nick LIKE 'P%');
```

Wynik: **4 rekordy**. Przykładowe wiersze: `nick` = `Ewa`, `punkty` = `23`; `nick` = `Paula`, `punkty` = `23`; `nick` = `Ela`, `punkty` = `51`. Bez `ORDER BY` kolejność nie jest gwarantowana.

</details>

## Zadanie 19 - Pięciu najlepszych

Pokaż pięciu turystów z największą liczbą punktów. Przy remisie zachowaj kolejność według identyfikatora turysty. Wyświetl nick i punkty.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick, punkty
FROM turysci
ORDER BY punkty DESC, idTurysta ASC
LIMIT 5;
```

Wynik: **5 rekordów**. Przykładowe wiersze: `nick` = `Ela`, `punkty` = `51`; `nick` = `Tomek`, `punkty` = `46`; `nick` = `Grzesiek`, `punkty` = `45`; `nick` = `Ola`, `punkty` = `31`; `nick` = `Ewa`, `punkty` = `23`. To pięć pierwszych rekordów po sortowaniu punktów malejąco; przy remisie decyduje rosnący `idTurysta`.

</details>

## Zadanie 20 - Obiekty z Islandii

Z tabeli `obiekty` wyświetl nazwę oraz nazwę pliku zdjęcia wszystkich obiektów z Islandii. Uporządkuj je według `idObiekt` rosnąco.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nazwa, plik
FROM obiekty
WHERE panstwo = 'Islandia'
ORDER BY idObiekt ASC;
```

Wynik: **9 rekordów**. Przykładowe wiersze: `nazwa` = `Strokkur`, `plik` = `Strokkur.jpg`; `nazwa` = `Skogafoss`, `plik` = `Skogafoss.jpg`; `nazwa` = `Seljalandsfoss`, `plik` = `Seljalandsfoss.jpg`. Kolejność rośnie według `idObiekt`: od Strokkura (46) do Dettifoss (54).

</details>
