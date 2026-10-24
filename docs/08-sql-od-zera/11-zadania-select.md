---
title: ZBIÓR ZADAŃ 1 - SELECT. 20 zadań
---

# ZBIÓR ZADAŃ 1 - SELECT. 20 zadań

Dwadzieścia zadań sprawdzi, czy potrafisz samodzielnie dobrać instrukcje SQL. Rozwiązuj je po kolei na niezmienionej bazie `Islandia`.

Najpierw napisz własne zapytanie w phpMyAdmin. Sprawdź wynik. Dopiero potem rozwiń rozwiązanie. Możesz otrzymać poprawny wynik także innym zapytaniem.

## Zadanie 1 - Turyści według nicka

Wyświetl identyfikatory i nicki wszystkich turystów. Posortuj ich alfabetycznie według nicka.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT idTurysta, nick
FROM turysci
ORDER BY nick;
```

Wynik: **13 rekordów**. Pierwsze wartości: `13` / `Adam`; `6` / `Ania`; `7` / `Ela`.

</details>

## Zadanie 2 - Obiekty i państwa

Wyświetl nazwy obiektów i państwa, w których się znajdują. Uporządkuj wynik rosnąco według identyfikatora obiektu.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nazwa, panstwo
FROM obiekty
ORDER BY idObiekt;
```

Wynik: **25 rekordów**. Pierwsze wartości: `Fuji` / `Japonia`; `Kadamaian` / `Malezja`; `Mount Everest` / `Nepal`.

</details>

## Zadanie 3 - Punkty Moniki

Wyświetl identyfikator i punkty turystki o nicku Monika.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT idTurysta, punkty
FROM turysci
WHERE nick = 'Monika';
```

Wynik: **1 rekord**. Pierwsze wartości: `2` / `4`.

</details>

## Zadanie 4 - Najwyżej 12 punktów

Wyświetl nicki i punkty wszystkich turystów mających najwyżej 12 punktów. Posortuj ich według punktów rosnąco, a przy remisie według `idTurysta`.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty <= 12
ORDER BY punkty, idTurysta;
```

Wynik: **6 rekordów**. Pierwsze wartości: `Monika` / `4`; `Krzysiek` / `5`; `Ania` / `7`.

</details>

## Zadanie 5 - Od 20 do 46 punktów

Wyświetl nicki i punkty turystów mających od 20 do 46 punktów włącznie.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty BETWEEN 20 AND 46;
```

Wynik: **6 rekordów**. Pierwsze wartości: `Ewa` / `23`; `Paula` / `23`; `Piotrek` / `21`. Bez `ORDER BY` kolejność wierszy nie jest gwarantowana.

</details>

## Zadanie 6 - Poza przedziałem

Wyświetl nicki i punkty turystów, których wyniki znajdują się poza przedziałem od 5 do 45 punktów włącznie.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty NOT BETWEEN 5 AND 45;
```

Wynik: **3 rekordy**. Pierwsze wartości: `Monika` / `4`; `Ela` / `51`; `Tomek` / `46`. Bez `ORDER BY` kolejność wierszy nie jest gwarantowana.

</details>

## Zadanie 7 - Trzy wyniki

Wyświetl nicki i punkty osób mających 7, 12 albo 31 punktów.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty IN (7, 12, 31);
```

Wynik: **3 rekordy**. Pierwsze wartości: `Janek` / `12`; `Ania` / `7`; `Ola` / `31`. Bez `ORDER BY` kolejność wierszy nie jest gwarantowana.

</details>

## Zadanie 8 - Pomiń trzy wyniki

Wyświetl nicki i punkty osób, które nie mają żadnej z wartości: 4, 11, 23.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty NOT IN (4, 11, 23);
```

Wynik: **8 rekordów**. Pierwsze wartości: `Janek` / `12`; `Krzysiek` / `5`; `Ania` / `7`. Bez `ORDER BY` kolejność wierszy nie jest gwarantowana.

</details>

## Zadanie 9 - Nick kończy się na a

Wyświetl wszystkie nicki kończące się literą `a`.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick
FROM turysci
WHERE nick LIKE '%a';
```

Wynik: **7 rekordów**. Pierwsze wartości: `Ewa`; `Monika`; `Paula`. Bez `ORDER BY` kolejność wierszy nie jest gwarantowana.

</details>

## Zadanie 10 - Pięć znaków i a na końcu

Wyświetl nicki mające dokładnie pięć znaków i kończące się na `a`.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick
FROM turysci
WHERE nick LIKE '____a';
```

Wynik: **1 rekord**. Pierwsze wartości: `Paula`.

</details>

## Zadanie 11 - Fragment la

Wyświetl nicki zawierające ciąg znaków `la`.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick
FROM turysci
WHERE nick LIKE '%la%';
```

Wynik: **3 rekordy**. Pierwsze wartości: `Paula`; `Ela`; `Ola`. Bez `ORDER BY` kolejność wierszy nie jest gwarantowana.

</details>

## Zadanie 12 - Bez M i J na początku

Wyświetl nicki, które nie zaczynają się ani od `M`, ani od `J`.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick
FROM turysci
WHERE nick NOT LIKE 'M%' AND nick NOT LIKE 'J%';
```

Wynik: **10 rekordów**. Pierwsze wartości: `Ewa`; `Krzysiek`; `Paula`. Bez `ORDER BY` kolejność wierszy nie jest gwarantowana.

</details>

## Zadanie 13 - Punkty i początek nicka

Wyświetl nicki i punkty osób, które mają od 20 do 45 punktów włącznie, ale ich nick nie zaczyna się od `E`.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty BETWEEN 20 AND 45 AND nick NOT LIKE 'E%';
```

Wynik: **4 rekordy**. Pierwsze wartości: `Paula` / `23`; `Piotrek` / `21`; `Grzesiek` / `45`. Bez `ORDER BY` kolejność wierszy nie jest gwarantowana.

</details>

## Zadanie 14 - Niskie lub wysokie wyniki

Wyświetl nicki i punkty osób, które mają mniej niż 10 lub więcej niż 45 punktów.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty < 10 OR punkty > 45;
```

Wynik: **5 rekordów**. Pierwsze wartości: `Monika` / `4`; `Krzysiek` / `5`; `Ania` / `7`. Bez `ORDER BY` kolejność wierszy nie jest gwarantowana.

</details>

## Zadanie 15 - Cztery najniższe wyniki

Spośród turystów mających co najmniej 10 punktów wyświetl cztery osoby z najniższą liczbą punktów. Przy remisie pierwszeństwo ma mniejszy `idTurysta`. Pokaż nick i punkty.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty >= 10
ORDER BY punkty, idTurysta
LIMIT 4;
```

Wynik: **4 rekordy**. Pierwsze wartości: `Jowita` / `11`; `Adam` / `11`; `Janek` / `12`.

</details>

## Zadanie 16 - Pusty tekst w kolumnie plik

Z tabeli `obiekty` wyświetl identyfikatory i nazwy obiektów, które mają pusty tekst w kolumnie `plik`.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT idObiekt, nazwa
FROM obiekty
WHERE plik = '';
```

Wynik: **12 rekordów**. Pierwsze wartości: `28` / `Fuji`; `29` / `Kadamaian`; `30` / `Mount Everest`. Bez `ORDER BY` kolejność wierszy nie jest gwarantowana.

</details>

## Zadanie 17 - Brak wartości w kolumnie plik

Sprawdź, czy istnieją obiekty, dla których kolumna `plik` ma wartość `NULL`. Wyświetl ich identyfikatory i nazwy.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT idObiekt, nazwa
FROM obiekty
WHERE plik IS NULL;
```

Wynik: **0 rekordów**. Żaden rekord nie spełnia warunku.

</details>

## Zadanie 18 - Wysokie obiekty

Wyświetl nazwy i wartości cechy dla obiektów, których cechą jest wysokość, a jej wartość wynosi co najmniej 1000. Uporządkuj wynik malejąco według `wartoscCechy`.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nazwa, wartoscCechy
FROM obiekty
WHERE nazwaCechy = 'wysokość' AND wartoscCechy >= 1000
ORDER BY wartoscCechy DESC;
```

Wynik: **5 rekordów**. Pierwsze wartości: `Mount Everest` / `8849`; `K2` / `8611`; `Kilimanjaro` / `5895`.

</details>

## Zadanie 19 - Różne wyniki od 20 punktów

Wyświetl różne wartości punktów turystów mających co najmniej 20 punktów. Nie pokazuj powtórzeń. Posortuj wartości malejąco.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT DISTINCT punkty
FROM turysci
WHERE punkty >= 20
ORDER BY punkty DESC;
```

Wynik: **6 rekordów**. Pierwsze wartości: `51`; `46`; `45`.

</details>

## Zadanie 20 - Różne pary państwa i rodzaju

Wyświetl wszystkie różne kombinacje państwa i `idRodzaj` dla obiektów z Polski i Islandii. Każdą kombinację pokaż tylko raz. Posortuj wynik według państwa oraz identyfikatora rodzaju.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT DISTINCT panstwo, idRodzaj
FROM obiekty
WHERE panstwo IN ('Polska', 'Islandia')
ORDER BY panstwo, idRodzaj;
```

Wynik: **6 rekordów**. Pierwsze wartości: `Islandia` / `10`; `Islandia` / `11`; `Islandia` / `13`.

</details>
