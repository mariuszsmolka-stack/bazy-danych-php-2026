---
title: SQL 0C - Kilka warunków i LIKE
---

# SQL 0C - Kilka warunków i LIKE

W [SQL 0B]({{ '/08-sql-od-zera/02-where-podstawy.html' | relative_url }}) używaliśmy jednego warunku. Teraz połączymy dwa proste warunki.

## 1. AND - oba warunki

Kto ma od 20 do 30 punktów? Obie granice mają należeć do wyniku.

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty >= 20 AND punkty <= 30;
```

Wynik ma **trzy rekordy**: Ewa (23), Paula (23) i Piotrek (21). Kolejność może być inna.

`AND` znaczy „i”. Rekord zostaje tylko wtedy, gdy spełnia **oba** warunki.

**Małe pytanie:** Czy Ola z 31 punktami spełnia drugi warunek?

## 2. OR - wystarczy jeden

Jak wybrać Ewę albo Elę? Sprawdź dwa nicki:

```sql
SELECT nick, punkty
FROM turysci
WHERE nick = 'Ewa' OR nick = 'Ela';
```

Wynik ma **dwa rekordy**: Ewa (23) i Ela (51).

`OR` znaczy „lub”. Wystarczy, że rekord spełnia jeden z warunków. Nie łączymy tu więcej warunków.

**Małe pytanie:** Czy Paula pojawi się w wyniku?

## 3. LIKE - fragment tekstu

Jak znaleźć nicki zaczynające się od `E`? Użyj `LIKE`:

```sql
SELECT nick
FROM turysci
WHERE nick LIKE 'E%';
```

Wynik to **Ewa** i **Ela**. Kolejność tych dwóch nicków nie jest ustalona.

`%` oznacza dowolną liczbę znaków, także zero. Zapis `'E%'` pasuje do tekstów zaczynających się od `E`.

Znak `_` oznacza **dokładnie jeden znak**. Sprawdź nicki z literą `A` i trzema kolejnymi znakami:

```sql
SELECT nick
FROM turysci
WHERE nick LIKE 'A___';
```

Wynik to **Ania** i **Adam**. Każdy z tych nicków ma cztery znaki.

`=` sprawdza cały tekst, na przykład `nick = 'Ewa'`. `LIKE 'E%'` szuka tekstów pasujących do wzoru. Bez `%` lub `_` nie wyszukujesz fragmentu nazwy.

## 4. Ćwiczenia

Przewidź wynik przed uruchomieniem zapytania. Potem sprawdź go w phpMyAdmin i porównaj z rozwiązaniem.

### Ćwiczenie 1 - między 10 a 13

Wyświetl `nick` i `punkty` osób, które mają więcej niż 10, ale mniej niż 13 punktów. Kto spełnia oba warunki?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Połącz `punkty > 10` z `punkty < 13` przez `AND`.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty > 10 AND punkty < 13;
```

Wynik ma **trzy rekordy**: Janek (12), Jowita (11) i Adam (11).

</details>

### Ćwiczenie 2 - 4 lub 5 punktów

Wyświetl `nick` i `punkty` osób, które mają 4 lub 5 punktów. Przewidź liczbę rekordów.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Sprawdź `punkty = 4` oraz `punkty = 5`. Wystarczy jeden z tych warunków.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty = 4 OR punkty = 5;
```

Wynik ma **dwa rekordy**: Monika (4) i Krzysiek (5).

</details>

### Ćwiczenie 3 - nick na P

Wyświetl nicki zaczynające się od `P`. Zastanów się, ilu turystów znajdziesz.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 3</summary>

Użyj `LIKE`. Po literze `P` wstaw znak oznaczający dowolną liczbę znaków.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 3</summary>

```sql
SELECT nick
FROM turysci
WHERE nick LIKE 'P%';
```

Wynik ma **dwa rekordy**: Paula i Piotrek. Kolejność nie jest ustalona.

</details>

**Następny krok:** [SQL 0D - Sortowanie i ograniczanie wyników]({{ '/08-sql-od-zera/04-sortowanie-limit.html' | relative_url }}).
