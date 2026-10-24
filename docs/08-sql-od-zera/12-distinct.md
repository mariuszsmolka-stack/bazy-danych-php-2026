---
title: SQL 0K - DISTINCT. Usuwamy powtórzenia
---

# SQL 0K - DISTINCT. Usuwamy powtórzenia

Pracuj w phpMyAdmin na niezmienionej bazie `Islandia`.

## Jedna kolumna

Wyświetl punkty wszystkich turystów:

```sql
SELECT punkty
FROM turysci;
```

Wynik ma **13 wierszy**. Niektóre wartości się powtarzają. Punkty `11` i `23` występują więcej niż raz.

Jeśli chcesz zobaczyć każdą wartość tylko raz, użyj `DISTINCT`:

```sql
SELECT DISTINCT punkty
FROM turysci;
```

Wynik ma **11 wierszy**. `DISTINCT` usuwa powtarzające się wiersze z wyniku zapytania. Nie usuwa danych z tabeli.

## Dwie kolumny

Sprawdź różne pary państwa i rodzaju obiektu:

```sql
SELECT DISTINCT panstwo, idRodzaj
FROM obiekty
ORDER BY panstwo, idRodzaj;
```

Teraz `DISTINCT` porównuje **całą parę**: `panstwo` oraz `idRodzaj`. To samo państwo może wystąpić w kilku wierszach, jeśli rodzaje obiektów są różne. Powtórzona para pojawi się tylko raz.

W MariaDB `DISTINCTROW` jest synonimem `DISTINCT`. Działa tak samo; do tych przykładów wystarczy `DISTINCT`.

`DISTINCT` usuwa powtarzające się wiersze. `GROUP BY` tworzy grupy, na których można wykonywać obliczenia. Nie musisz używać `GROUP BY`, gdy chcesz tylko usunąć powtórzenia.

W późniejszych [lekcjach 7A]({{ '/04-grupowanie-danych/03a-distinct-podstawy.html' | relative_url }}) i [7B]({{ '/04-grupowanie-danych/03b-distinct-wiele-kolumn.html' | relative_url }}) poznasz więcej przykładów.

## Ćwiczenia

Najpierw napisz zapytanie i sprawdź wynik w phpMyAdmin. Dopiero potem rozwiń rozwiązanie.

### Ćwiczenie 1

Wyświetl państwa zapisane w tabeli `obiekty`. Każde państwo pokaż tylko raz. Posortuj wynik alfabetycznie.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Wybierz jedną kolumnę i usuń powtarzające się wiersze.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

```sql
SELECT DISTINCT panstwo
FROM obiekty
ORDER BY panstwo;
```

Wynik zawiera **12 państw**, w tym Islandię i Polskę.

</details>

### Ćwiczenie 2

Pokaż różne wyniki punktowe turystów. Posortuj je od największego do najmniejszego. Ile wartości otrzymasz?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Wybierz kolumnę `punkty`. Użyj sortowania malejącego.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

```sql
SELECT DISTINCT punkty
FROM turysci
ORDER BY punkty DESC;
```

Wynik ma **11 różnych wartości**.

</details>

### Ćwiczenie 3

Wyświetl różne pary `panstwo` i `idRodzaj` tylko dla obiektów z Islandii. Posortuj pary według identyfikatora rodzaju. Ile ich jest?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 3</summary>

Wybierz dwie kolumny. Warunkiem ogranicz wynik do jednego państwa.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 3</summary>

```sql
SELECT DISTINCT panstwo, idRodzaj
FROM obiekty
WHERE panstwo = 'Islandia'
ORDER BY idRodzaj;
```

Wynik zawiera **5 różnych par**.

</details>

**Następny krok:** [ZBIÓR ZADAŃ 1 - SELECT. 20 zadań]({{ '/08-sql-od-zera/11-zadania-select.html' | relative_url }}).
