---
title: SQL 0J - AND, OR, NOT i kolejność warunków
---

# SQL 0J - AND, OR, NOT i kolejność warunków

W [SQL 0C]({{ '/08-sql-od-zera/03-warunki-i-like.html' | relative_url }}) łączyliśmy dwa warunki. Teraz połączymy więcej warunków w jednym `WHERE`. Pracujemy na tabeli `turysci` z bazy `Islandia`.

## 1. Trzy sposoby łączenia warunków

`AND` wymaga spełnienia obu warunków. `OR` wystarczy jeden. `NOT` zaprzecza warunkowi.

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty > 20 AND nick LIKE 'E%';
```

Wynik: **Ewa (23)** i **Ela (51)**. Obie mają ponad 20 punktów i nick zaczynający się od `E`.

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty < 5 OR nick = 'Adam';
```

Wynik: **Monika (4)** i **Adam (11)**. Adam pojawia się dzięki drugiemu warunkowi.

```sql
SELECT nick, punkty
FROM turysci
WHERE NOT (punkty >= 20);
```

Wynik ma **6 rekordów**. W tych danych to osoby z mniej niż 20 punktami.

## 2. Kolejność: NOT, AND, OR

Gdy nie ma nawiasów, SQL ocenia najpierw `NOT`, potem `AND`, a na końcu `OR`. Sprawdź:

```sql
SELECT nick, punkty
FROM turysci
WHERE nick = 'Ewa' OR nick = 'Ola' AND punkty > 30;
```

SQL odczytuje to tak: `nick = 'Ewa' OR (nick = 'Ola' AND punkty > 30)`. Wynik: **Ewa (23)** i **Ola (31)**. Ewa przechodzi dzięki pierwszemu warunkowi, choć nie ma ponad 30 punktów.

**Małe pytanie:** Czy Ewa znalazłaby się w wyniku, gdyby warunek `punkty > 30` dotyczył obu nicków?

## 3. Nawias zmienia wynik

Jeśli ponad 30 punktów mają mieć **obie** możliwe osoby, obejmij wybór nicków nawiasem:

```sql
SELECT nick, punkty
FROM turysci
WHERE (nick = 'Ewa' OR nick = 'Ola') AND punkty > 30;
```

Wynik: tylko **Ola (31)**. Ewa odpada, bo ma 23 punkty.

| Warunek | Wynik |
| --- | --- |
| `nick = 'Ewa' OR nick = 'Ola' AND punkty > 30` | Ewa i Ola |
| `(nick = 'Ewa' OR nick = 'Ola') AND punkty > 30` | Ola |

Nawias pokazuje, które części pytania traktujemy razem. Dodawaj go, gdy pomaga jednoznacznie zapisać zamiar.

## 4. Połącz AND, OR i NOT

Chcemy turystów z mniej niż 10 punktami lub Adama. Monikę pomijamy:

```sql
SELECT nick, punkty
FROM turysci
WHERE (punkty < 10 OR nick = 'Adam') AND NOT (nick = 'Monika');
```

Wynik: **Krzysiek (5)**, **Ania (7)** i **Adam (11)**. Najpierw wybieramy osoby spełniające co najmniej jeden warunek w nawiasie. Potem wykluczamy Monikę.

Jeśli w danych występuje `NULL`, część warunków może mieć wynik `UNKNOWN`. Takie rekordy nie przechodzą przez `WHERE`, jak pokazaliśmy w [SQL 0I]({{ '/08-sql-od-zera/09-null.html' | relative_url }}).

## 5. Ćwiczenia

Najpierw przewidź wynik. Potem sprawdź swoje zapytanie w phpMyAdmin.

### Ćwiczenie 1 - przewidź wynik

Który turysta pojawi się w wyniku? Wyjaśnij rolę nawiasu.

```sql
SELECT nick, punkty
FROM turysci
WHERE (nick = 'Ewa' OR nick = 'Ola') AND punkty >= 30;
```

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Najpierw zostaw Ewę i Olę. Potem sprawdź, która z nich ma co najmniej 30 punktów.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

Wynik: **Ola (31)**. Ewa ma 23 punkty i nie spełnia drugiej części warunku.

</details>

### Ćwiczenie 2 - dwa początki nicka

Wyświetl nicki i punkty osób, które mają ponad 20 punktów, a ich nick zaczyna się od `E` lub `P`. Ile jest rekordów?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Połącz dwa wzorce nicka w nawiasie. Wymaganie dotyczące punktów ma dotyczyć obu wzorców.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty > 20 AND (nick LIKE 'E%' OR nick LIKE 'P%');
```

Wynik ma **4 rekordy**: Ewa (23), Ela (51), Paula (23) i Piotrek (21). Kolejność może być inna.

</details>

### Ćwiczenie 3 - wybierz sposób połączenia

Wyświetl nicki i punkty osób z mniej niż 10 punktami lub o nicku `Adam`, ale pomiń Monikę. Dobierz warunki i nawiasy tak, aby wykluczenie dotyczyło całego wyniku. Kogo zobaczysz?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 3</summary>

Najpierw połącz dwa sposoby zakwalifikowania osoby. Następnie odrzuć Monikę.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 3</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE (punkty < 10 OR nick = 'Adam') AND NOT (nick = 'Monika');
```

Wynik ma **3 rekordy**: Krzysiek (5), Ania (7) i Adam (11).

</details>

To koniec modułu. Możesz wrócić do [wprowadzenia SQL od zera]({{ '/08-sql-od-zera/index.html' | relative_url }}).

[ZBIÓR ZADAŃ 1 - SELECT. 20 zadań]({{ '/08-sql-od-zera/11-zadania-select.html' | relative_url }}).
