---
title: SQL 0A - Pierwsze zapytanie SELECT
---

# SQL 0A - Pierwsze zapytanie SELECT

Masz już bazę `Islandia` w phpMyAdmin? Wybierz ją po lewej stronie, a potem otwórz zakładkę **SQL**.

Zapytanie SQL prosi bazę o wynik. Dzisiaj wybierzemy dane z tabeli `turysci`.

## 1. Zobacz całą tabelę

Jak zobaczyć wszystkie kolumny tabeli? Wpisz i uruchom:

```sql
SELECT * FROM turysci;
```

`SELECT` mówi, że wybierasz dane. Gwiazdka `*` oznacza wszystkie kolumny. `FROM turysci` wskazuje tabelę.

Wynik ma **13 rekordów** i trzy kolumny:

| idTurysta | nick | punkty |
| ---: | --- | ---: |
| 1 | Ewa | 23 |
| 2 | Monika | 4 |
| 3 | Janek | 12 |
| 4 | Krzysiek | 5 |
| 5 | Paula | 23 |
| 6 | Ania | 7 |
| 7 | Ela | 51 |
| 8 | Piotrek | 21 |
| 9 | Tomek | 46 |
| 10 | Grzesiek | 45 |
| 11 | Ola | 31 |
| 12 | Jowita | 11 |
| 13 | Adam | 11 |

W tabeli wynikowej widzisz numer osoby, jej nick i punkty. Kolejność rekordów na Twoim ekranie może być inna. Bez polecenia porządkowania SQL nie obiecuje stałej kolejności.

**Małe pytanie:** Ile kolumn zobaczysz po użyciu `*`?

## 2. Wybierz jedną kolumnę

Co zrobić, gdy potrzebujesz tylko nicków? Zamiast gwiazdki wpisz nazwę kolumny:

```sql
SELECT nick FROM turysci;
```

Wynik ma **13 rekordów** i jedną kolumnę `nick`. Zawiera: Ewa, Monika, Janek, Krzysiek, Paula, Ania, Ela, Piotrek, Tomek, Grzesiek, Ola, Jowita i Adam. Kolejność na ekranie może być inna.

Zmieniła się liczba kolumn, a nie liczba osób. Baza nadal odczytała rekordy wszystkich 13 turystów.

**Małe pytanie:** Czy w tym wyniku zobaczysz liczbę punktów?

## 3. Wybierz dwie kolumny

Jak zobaczyć nick i punkty, ale bez numeru osoby? Wymień obie nazwy po przecinku:

```sql
SELECT nick, punkty FROM turysci;
```

Wynik ma **13 rekordów** i dwie kolumny:

| nick | punkty |
| --- | ---: |
| Ewa | 23 |
| Monika | 4 |
| Janek | 12 |
| Krzysiek | 5 |
| Paula | 23 |
| Ania | 7 |
| Ela | 51 |
| Piotrek | 21 |
| Tomek | 46 |
| Grzesiek | 45 |
| Ola | 31 |
| Jowita | 11 |
| Adam | 11 |

Teraz widzisz dwie wybrane kolumny. Numer `idTurysta` nie pojawia się w wyniku. Kolejność rekordów może być inna niż w tabeli powyżej.

**Małe pytanie:** Co trzeba wpisać między nazwami dwóch kolumn?

`*` wybiera wszystkie kolumny. Nazwa jednej kolumny wybiera jedną. Nazwy oddzielone przecinkiem wybierają kilka kolumn.

## 4. Ćwiczenia

Najpierw przewidź liczbę kolumn i rekordów. Potem wykonaj własne zapytanie w phpMyAdmin i porównaj wynik.

### Ćwiczenie 1 - same punkty

Wyświetl tylko kolumnę `punkty` z tabeli `turysci`. Ile będzie kolumn, a ile rekordów?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Zamiast `*` wpisz jedną nazwę kolumny po `SELECT`.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

```sql
SELECT punkty FROM turysci;
```

Wynik ma **jedną kolumnę** i **13 rekordów**. Wśród wartości są `23`, `4` i `51`. Kolejność nie jest ustalona.

</details>

### Ćwiczenie 2 - numer i nick

Wyświetl `idTurysta` oraz `nick` każdego turysty. Przewidź, czy zobaczysz punkty.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Wpisz dwie nazwy kolumn po `SELECT`. Oddziel je przecinkiem.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

```sql
SELECT idTurysta, nick FROM turysci;
```

Wynik ma **dwie kolumny** i **13 rekordów**. Pokazuje na przykład parę `1, Ewa`. Nie pokazuje punktów.

</details>

**Następny krok:** [SQL 0B - WHERE. Wybieramy rekordy]({{ '/08-sql-od-zera/02-where-podstawy.html' | relative_url }}).
