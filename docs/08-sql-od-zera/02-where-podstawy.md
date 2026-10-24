---
title: SQL 0B - WHERE. Wybieramy rekordy
---

# SQL 0B - WHERE. Wybieramy rekordy

W [SQL 0A]({{ '/08-sql-od-zera/01-select-podstawy.html' | relative_url }}) wybieraliśmy kolumny. Teraz wybierzemy również rekordy.

`SELECT` wskazuje potrzebne kolumny. `WHERE` pozostawia tylko te rekordy, które spełniają warunek.

## 1. Znajdź jedną osobę

Jak znaleźć Ewę? Wybierz `nick` i `punkty`, a potem sprawdź jej nick:

```sql
SELECT nick, punkty
FROM turysci
WHERE nick = 'Ewa';
```

Wynik to **jeden rekord**:

| nick | punkty |
| --- | ---: |
| Ewa | 23 |

Znak `=` oznacza „jest równe”. `Ewa` jest tekstem, więc w zapytaniu ujmujemy go w apostrofy: `'Ewa'`.

**Małe pytanie:** Czy w wyniku widać pozostałych 12 turystów?

## 2. Porównaj liczby

Możesz też sprawdzić liczbę punktów. Liczby w tym przykładzie nie wymagają apostrofów:

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty = 23;
```

Wynik ma **dwa rekordy**: Ewa ma 23 punkty i Paula ma 23 punkty. Obie spełniają warunek `punkty = 23`.

**Małe pytanie:** Dlaczego tym razem otrzymujesz dwie osoby?

Teraz znajdź osoby z co najmniej 20 punktami:

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty >= 20;
```

Wynik ma **7 rekordów**: Ewa (23), Paula (23), Ela (51), Piotrek (21), Tomek (46), Grzesiek (45) i Ola (31). Ich kolejność nie jest ustalona.

`>=` znaczy „większe lub równe”. Osoba z dokładnie 20 punktami też spełniłaby ten warunek. W naszej tabeli nie ma takiej osoby.

**Małe pytanie:** Czy Monika z 4 punktami pojawi się w wyniku?

## 3. Większe i mniejsze

Do porównań liczb służą też `>` i `<`. Zapis `punkty > 20` oznacza więcej niż 20. Zapis `punkty < 20` oznacza mniej niż 20.

`<=` oznacza mniejsze lub równe. Na przykład `punkty <= 5` wybierze Monikę (4) i Krzyśka (5).

Zwróć uwagę na granicę. Przy `punkty > 5` osoba z 5 punktami odpada. Przy `punkty >= 5` zostaje.

## 4. Ćwiczenia

Najpierw przewidź wynik. Napisz zapytanie, uruchom je w phpMyAdmin i porównaj z rozwiązaniem.

### Ćwiczenie 1 - Paula

Wyświetl `nick` i `punkty` turysty o nicku `Paula`. Ile rekordów otrzymasz?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Sprawdzasz tekst w kolumnie `nick`. Użyj `=` i apostrofów.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE nick = 'Paula';
```

Wynik ma **jeden rekord**: Paula, 23 punkty.

</details>

### Ćwiczenie 2 - najwyżej 5 punktów

Wyświetl `nick` i `punkty` osób, które mają najwyżej 5 punktów. Przewidź, kto się pojawi.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

„Najwyżej 5” obejmuje także 5. Użyj `<=`.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty <= 5;
```

Wynik ma **dwa rekordy**: Monika (4) i Krzysiek (5).

</details>

### Ćwiczenie 3 - więcej niż 45 punktów

Wyświetl `nick` i `punkty` osób z wynikiem większym niż 45. Czy osoba z 45 punktami się pojawi?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 3</summary>

„Więcej niż” zapiszesz przez `>`. Wartość graniczna nie należy do wyniku.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 3</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty > 45;
```

Wynik ma **dwa rekordy**: Ela (51) i Tomek (46). Grzesiek ma dokładnie 45 punktów, więc nie spełnia warunku.

</details>

**Następny krok:** [SQL 0C - Kilka warunków i LIKE]({{ '/08-sql-od-zera/03-warunki-i-like.html' | relative_url }}).
