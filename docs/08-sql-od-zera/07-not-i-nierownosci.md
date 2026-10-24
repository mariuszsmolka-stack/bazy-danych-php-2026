---
title: SQL 0G - Operatory porównania i NOT
---

# SQL 0G - Operatory porównania i NOT

Jak wybrać rekordy, które **nie** spełniają warunku? Sprawdzimy to na tabeli `turysci` z bazy `Islandia`.

## 1. Zaprzecz warunkowi

Najpierw wybierz osoby z co najmniej 20 punktami:

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty >= 20;
```

Wynik ma **7 rekordów**.

Teraz zaprzecz temu warunkowi:

```sql
SELECT nick, punkty
FROM turysci
WHERE NOT (punkty >= 20);
```

Wynik ma **6 rekordów**: Monika (4), Janek (12), Krzysiek (5), Ania (7), Jowita (11) i Adam (11). Kolejność może być inna.

`NOT` oznacza zaprzeczenie. Nawias pokazuje, **który** warunek odwracamy. Osoby z wynikiem 20 lub wyższym nie pojawiają się w drugim wyniku.

Ten sam wynik otrzymasz przez `WHERE punkty < 20`:

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty < 20;
```

Oba warunki dają **6 rekordów**. Dla każdej zapisanej liczby zaprzeczenie `>= 20` oznacza `< 20`. Gdy `punkty` ma wartość `NULL`, żaden z tych warunków nie wybierze rekordu: wynik porównania jest wtedy nieznany. Wyjaśnimy to w [SQL 0I]({{ '/08-sql-od-zera/09-null.html' | relative_url }}).

**Małe pytanie:** Czy Ela z 51 punktami spełnia `NOT (punkty >= 20)`?

## 2. Różne od jednej liczby

Jak pominąć osoby z dokładnie 23 punktami?

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty <> 23;
```

Wynik ma **11 rekordów**. Nie ma w nim Ewy ani Pauli. Obie mają 23 punkty.

`<>` oznacza „różne od”. Sprawdza jedną liczbę podaną po prawej stronie.

W MariaDB możesz również zapisać tę samą nierówność przez `!=`:

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty != 23;
```

Wynik jest taki sam: **11 rekordów**. W tych przykładach `<>` i `!=` służą do tego samego porównania.

**Małe pytanie:** Czy Tomek z 46 punktami pozostanie w wyniku?

## 3. Nicki, które nie pasują

Najpierw zobacz nicki zaczynające się od `A`:

```sql
SELECT nick
FROM turysci
WHERE nick LIKE 'A%';
```

Wynik: **Ania** i **Adam**.

Teraz wybierz pozostałe nicki:

```sql
SELECT nick
FROM turysci
WHERE nick NOT LIKE 'A%';
```

Wynik ma **11 rekordów**. Nie ma w nim Ani ani Adama.

`LIKE` wybiera nicki pasujące do wzorca. `NOT LIKE` wybiera te, które do wzorca **nie pasują**.

| Warunek | Co wybiera? |
| --- | --- |
| `LIKE 'A%'` | Nicki zaczynające się od `A`. |
| `NOT LIKE 'A%'` | Nicki niezaczynające się od `A`. |

**Małe pytanie:** Czy `Ewa` pasuje do drugiego warunku?

## 4. Wybierz właściwe porównanie

| Zapis | Pytanie o punkty | Przykład dla wartości 23 |
| --- | --- | --- |
| `punkty = 23` | Czy są równe 23? | Tak |
| `punkty <> 23` lub `punkty != 23` | Czy są różne od 23? | Nie |
| `punkty > 23` | Czy są większe od 23? | Nie |
| `punkty < 23` | Czy są mniejsze od 23? | Nie |
| `punkty >= 23` | Czy są większe lub równe 23? | Tak |
| `punkty <= 23` | Czy są mniejsze lub równe 23? | Tak |

Najpierw zdecyduj, czy wartość graniczna ma należeć do wyniku. Na przykład `punkty > 23` pomija Ewę i Paulę, a `punkty >= 23` je uwzględnia.

## 5. Ćwiczenia

Najpierw przewidź wynik. Potem wpisz zapytanie w phpMyAdmin i porównaj z rozwiązaniem.

### Ćwiczenie 1 - zaprzecz porównaniu

Wyświetl nicki i punkty osób, które **nie mają mniej niż 10** punktów. Ilu turystów pozostanie?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Zapisz `punkty < 10` w nawiasie. Przed nawiasem dodaj `NOT`.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE NOT (punkty < 10);
```

Wynik ma **10 rekordów**. Odpadają Monika (4), Krzysiek (5) i Ania (7).

</details>

### Ćwiczenie 2 - nie 11

Wyświetl nicki i punkty osób z wynikiem innym niż 11. Kogo zabraknie?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Użyj jednego znaku nierówności omówionego w tej lekcji.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty <> 11;
```

Wynik ma **11 rekordów**. Nie ma Jowity ani Adama, bo oboje mają 11 punktów.

</details>

### Ćwiczenie 3 - bez litery J na początku

Wyświetl nicki, które **nie** zaczynają się od `J`. Ilu nicków nie zobaczysz?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 3</summary>

Wzorzec początku nicka to `'J%'`. Zaprzecz jego dopasowaniu.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 3</summary>

```sql
SELECT nick
FROM turysci
WHERE nick NOT LIKE 'J%';
```

Wynik ma **11 rekordów**. Brakuje Janka i Jowity.

</details>

**Następny krok:** [SQL 0H - BETWEEN i NOT BETWEEN]({{ '/08-sql-od-zera/08-between.html' | relative_url }}).
