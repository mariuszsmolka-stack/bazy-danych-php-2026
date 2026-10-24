---
title: SQL 0H - BETWEEN i NOT BETWEEN
---

# SQL 0H - BETWEEN i NOT BETWEEN

Chcemy wybrać turystów, którzy mają **od 11 do 23 punktów**. Pracujemy w phpMyAdmin na tabeli `turysci` z bazy `Islandia`.

## 1. Podaj dwie granice

Znany sposób używa dwóch porównań połączonych przez `AND`:

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty >= 11 AND punkty <= 23;
```

Wynik ma **6 rekordów**: Ewa (23), Paula (23), Piotrek (21), Janek (12), Jowita (11) i Adam (11). Kolejność może być inna.

`>= 11` dopuszcza 11 punktów. `<= 23` dopuszcza 23 punkty. Obie granice należą do wyniku.

**Małe pytanie:** Czy osoba z dokładnie 11 punktami pojawia się w wyniku?

## 2. Zapisz ten sam przedział krócej

Możesz podać początek i koniec przedziału przez `BETWEEN`:

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty BETWEEN 11 AND 23;
```

Wynik jest taki sam: **6 rekordów**. Są w nim także osoby z **11** i **23** punktami.

`BETWEEN 11 AND 23` oznacza „od 11 do 23, razem z granicami”. Tutaj `AND` oddziela początek przedziału od końca.

**Małe pytanie:** Czy Piotrek z 21 punktami mieści się w tym przedziale?

## 3. Wybierz wartości poza przedziałem

Jak znaleźć pozostałych turystów?

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty NOT BETWEEN 11 AND 23;
```

Wynik ma **7 rekordów**: Monika (4), Krzysiek (5), Ania (7), Ola (31), Grzesiek (45), Tomek (46) i Ela (51). Kolejność może być inna.

`NOT BETWEEN` wybiera wartości **spoza** przedziału. Osoby z 11 i 23 punktami nie należą do tego wyniku, bo te wartości są granicami przedziału.

| Warunek | Co wybiera? | Liczba rekordów |
| --- | --- | ---: |
| `BETWEEN 11 AND 23` | Wewnątrz przedziału, razem z granicami. | 6 |
| `NOT BETWEEN 11 AND 23` | Poza przedziałem. | 7 |

**Małe pytanie:** Czy Ela z 51 punktami należy do drugiego wyniku?

## 4. Ćwiczenia

Najpierw przewidź wynik. Potem wykonaj zapytanie w phpMyAdmin i porównaj z rozwiązaniem.

### Ćwiczenie 1 - od 4 do 7

Wyświetl nicki i punkty osób, które mają od 4 do 7 punktów, razem z granicami. Ilu turystów znajdziesz?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Początek przedziału to `4`, a koniec to `7`. Użyj `BETWEEN`.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty BETWEEN 4 AND 7;
```

Wynik ma **3 rekordy**: Monika (4), Krzysiek (5) i Ania (7). Obie granice należą do wyniku.

</details>

### Ćwiczenie 2 - poza przedziałem

Wyświetl nicki i punkty osób **spoza** przedziału od 20 do 30 punktów. Ilu turystów zostanie?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Użyj `NOT BETWEEN 20 AND 30`. Osoby z wynikiem wewnątrz przedziału mają zniknąć.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty NOT BETWEEN 20 AND 30;
```

Wynik ma **10 rekordów**. Nie ma Ewy i Pauli (23) ani Piotrka (21).

</details>

To koniec modułu. Możesz wrócić do [wprowadzenia SQL od zera]({{ '/08-sql-od-zera/index.html' | relative_url }}).
