---
title: SQL 0D - Sortowanie i ograniczanie wyników
---

# SQL 0D - Sortowanie i ograniczanie wyników

W poprzednich krokach wybieraliśmy kolumny i rekordy. Teraz ustalimy kolejność wyniku.

Bez `ORDER BY` nie zakładaj określonej kolejności rekordów. Nawet jeśli dziś widzisz Ewę na początku, kolejne wykonanie nie musi dać tej samej kolejności.

## 1. Od największej liczby punktów

Kto zdobył najwięcej punktów? Uporządkuj wynik malejąco:

```sql
SELECT nick, punkty
FROM turysci
ORDER BY punkty DESC;
```

Wynik ma **13 rekordów**. Punkty od góry to `51, 46, 45, 31, 23, 23, 21, 12, 11, 11, 7, 5, 4`. Pierwsza jest Ela (51), a ostatnia Monika (4).

`ORDER BY punkty` ustala kolejność według punktów. `DESC` oznacza od największej wartości. Przy jednakowej liczbie punktów kolejność osób nie jest tu określona.

**Małe pytanie:** Czy Tomek z 46 punktami jest przed Olą z 31 punktami?

## 2. Od najmniejszej liczby punktów

Odwróć kierunek:

```sql
SELECT nick, punkty
FROM turysci
ORDER BY punkty ASC;
```

Wynik nadal ma **13 rekordów**. Punkty od góry to `4, 5, 7, 11, 11, 12, 21, 23, 23, 31, 45, 46, 51`. Pierwsza jest Monika (4), a ostatnia Ela (51).

`ASC` oznacza od najmniejszej wartości. Zmieniła się kolejność, ale nikt nie zniknął z wyniku. Przy remisie w punktach kolejność osób nadal może się różnić.

**Małe pytanie:** Czy `ASC` zmniejszyło liczbę rekordów?

## 3. Pokaż tylko trzy osoby

Jak zobaczyć trzy najwyższe wyniki? Najpierw ustal kolejność, potem ogranicz liczbę rekordów:

```sql
SELECT nick, punkty
FROM turysci
ORDER BY punkty DESC, idTurysta
LIMIT 3;
```

Wynik:

| nick | punkty |
| --- | ---: |
| Ela | 51 |
| Tomek | 46 |
| Grzesiek | 45 |

`LIMIT 3` zwraca najwyżej trzy rekordy. `ORDER BY` decyduje, **które** rekordy będą pierwsze.

Druga nazwa w `ORDER BY` rozstrzyga remis w punktach. Gdy dwie osoby mają tyle samo punktów, wcześniej będzie osoba z mniejszym `idTurysta`.

**Małe pytanie:** Czy samo `LIMIT 3`, bez `ORDER BY`, zawsze pokazałoby trzy najlepsze wyniki?

## 4. Ćwiczenia

Najpierw przewidź wynik. Potem uruchom swoje zapytanie w phpMyAdmin i porównaj z rozwiązaniem.

### Ćwiczenie 1 - trzy najniższe wyniki

Wyświetl `nick` i `punkty` trzech osób z najmniejszą liczbą punktów. Przy remisie użyj `idTurysta`. Kto pojawi się w wyniku?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Użyj `ORDER BY punkty ASC, idTurysta ASC`. Na końcu ogranicz wynik do trzech rekordów.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

```sql
SELECT nick, punkty
FROM turysci
ORDER BY punkty ASC, idTurysta ASC
LIMIT 3;
```

Wynik ma **trzy rekordy**: Monika (4), Krzysiek (5), Ania (7) - w tej kolejności.

</details>

### Ćwiczenie 2 - pięć najwyższych wyników

Wyświetl `nick` i `punkty` pięciu osób z najwyższą liczbą punktów. Przy remisie użyj `idTurysta`. Przewidź piątą osobę.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Najpierw ustaw `punkty DESC`, a potem `idTurysta ASC`. Użyj `LIMIT 5`.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

```sql
SELECT nick, punkty
FROM turysci
ORDER BY punkty DESC, idTurysta ASC
LIMIT 5;
```

Wynik to kolejno: Ela (51), Tomek (46), Grzesiek (45), Ola (31) i Ewa (23). Ewa jest przed Paulą przy remisie, bo ma mniejszy `idTurysta`.

</details>

**Następny krok:** [SQL 0E - LIKE. Znaki % i _]({{ '/08-sql-od-zera/05-like-maski.html' | relative_url }}).
