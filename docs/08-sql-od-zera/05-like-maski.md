---
title: SQL 0E - LIKE, NOT LIKE i znaki wzorca
---

# SQL 0E - LIKE, NOT LIKE i znaki wzorca

W [SQL 0C]({{ '/08-sql-od-zera/03-warunki-i-like.html' | relative_url }}) używaliśmy `LIKE`. Teraz sprawdzimy dokładnie, jak działają dwa znaki wzorca.

Pracuj w phpMyAdmin na niezmienionej bazie `Islandia`. Wszystkie pytania dotyczą tabeli `turysci`.

Lekcję możesz rozłożyć na dwa spotkania. Najpierw poznaj podstawowe wzorce, a później znaki specjalne.

## Część I - Podstawowe wzorce

### 1. Zaczyna się od J

Jak znaleźć nicki zaczynające się od `J`?

```sql
SELECT nick
FROM turysci
WHERE nick LIKE 'J%';
```

Wynik: **Janek** i **Jowita**. Kolejność może być inna.

Nick musi zaczynać się od `J`. Po tej literze może występować dowolna liczba znaków. Znak `%` dopuszcza także **zero** znaków.

`%` nie oznacza „zawsze co najmniej jeden znak”. Gdyby w tabeli był nick `J`, też pasowałby do `'J%'`. W naszej tabeli go nie ma.

**Małe pytanie:** Czy `Ewa` pasuje do `'J%'`?

### 2. Dokładnie cztery znaki po J

Jak znaleźć nick zaczynający się od `J`, który ma łącznie pięć znaków?

```sql
SELECT nick
FROM turysci
WHERE nick LIKE 'J____';
```

Wynik: **Janek**.

Wzorzec ma literę `J` i cztery znaki `_`. Każdy `_` zastępuje **dokładnie jeden** znak. Dlatego cały nick ma dokładnie pięć znaków.

`_` nie oznacza „jeden lub więcej znaków”. Jowita ma sześć znaków, więc nie pasuje do `'J____'`.

**Małe pytanie:** Ile znaków ma `Janek`?

### 3. Dokładnie pięć znaków po J

Teraz dodaj jeszcze jeden `_`:

```sql
SELECT nick
FROM turysci
WHERE nick LIKE 'J_____';
```

Wynik: **Jowita**.

Po `J` występuje dokładnie pięć znaków. Janek ma po `J` tylko cztery znaki, więc tym razem odpada.

**Małe pytanie:** Czy oba zapytania z `_` mogą zwrócić ten sam nick?

### 4. Dwa dowolne znaki i litera a

Jak znaleźć trzyznakowe nicki kończące się na `a`?

```sql
SELECT nick
FROM turysci
WHERE nick LIKE '__a';
```

Wynik: **Ewa**, **Ela** i **Ola**.

Dwa pierwsze znaki mogą być dowolne. Trzeci musi być literą `a`. Cały nick ma dokładnie trzy znaki.

**Małe pytanie:** Dlaczego `Ania` nie pasuje?

### 5. Kończy się na ek

Jak znaleźć nicki kończące się na `ek`, bez narzucania długości?

```sql
SELECT nick
FROM turysci
WHERE nick LIKE '%ek';
```

Wynik: **Janek**, **Krzysiek**, **Piotrek**, **Tomek** i **Grzesiek**.

Litery przed `ek` mogą być dowolne. Nick musi kończyć się dokładnie na `ek`. Różne długości nicków nie przeszkadzają, bo użyliśmy `%`.

**Małe pytanie:** Czy `Ewa` kończy się na `ek`?

### 6. Fragment w środku

Znak `%` może stać po obu stronach szukanego fragmentu:

```sql
SELECT nick
FROM turysci
WHERE nick LIKE '%ow%';
```

Wynik: **Jowita**.

Szukamy nicka zawierającego `ow`. Przed tym fragmentem i po nim może wystąpić dowolna liczba znaków, także zero.

**Małe pytanie:** Czy `ow` musi być pierwszymi literami nicka?

### 7. Porównaj dwa wzorce

| Wzorzec | Co oznacza? | Pasuje | Nie pasuje i dlaczego |
| --- | --- | --- | --- |
| `LIKE 'J%'` | Zaczyna się od `J`; dalsza długość jest dowolna. | Janek, Jowita | Ewa - nie zaczyna się od `J`. |
| `LIKE 'J____'` | Zaczyna się od `J` i ma dokładnie pięć znaków. | Janek | Jowita - ma sześć znaków. |

`%` i `_` są znakami wzorca używanego przez `LIKE`. W zwykłym porównaniu przez `=` nie działają w ten sposób. Sprawdź:

```sql
SELECT nick
FROM turysci
WHERE nick = 'J%';
```

Wynik: **0 rekordów**. W tabeli nie ma nicka zapisanego dosłownie jako `J%`.

**Małe pytanie:** Którego zapisu użyjesz, gdy chcesz znaleźć początek nicka: `=` czy `LIKE`?

Gdy chcesz wybrać nicki **niepasujące** do wzorca, użyj `NOT LIKE`:

```sql
SELECT nick
FROM turysci
WHERE nick NOT LIKE 'J%';
```

Wynik ma **11 rekordów**. Nie ma Janka ani Jowity.

## Część II - Przypadki szczególne

### 8. Dosłowne znaki % i _

Gdy szukasz znaku `%` jako części tekstu, poprzedź go znakiem ucieczki. Po `ESCAPE` podaj ten znak. Tutaj jest nim `!`:

```sql
SELECT nick
FROM turysci
WHERE nick LIKE '%!%%' ESCAPE '!';
```

Pierwszy i ostatni `%` oznaczają dowolne znaki. Zapis `!%` oznacza dosłowny znak procentu. Wynik to **0 rekordów**, bo żaden nick go nie zawiera.

Możesz sprawdzić samą zasadę bez zmiany tabeli:

```sql
SELECT '50%' LIKE '%!%%' ESCAPE '!' AS pasuje;
```

Wynik to `1`, czyli prawda.

`SELECT` może obliczyć wyrażenie bez pobierania danych z tabeli. Dlatego nie ma tu `FROM`.
Porównujemy tekst `50%` z podanym wzorcem.
`AS pasuje` nadaje nazwę kolumnie z wynikiem.

Tak samo wyszukasz dosłowny znak `_`:

```sql
SELECT nick
FROM turysci
WHERE nick LIKE '%!_%' ESCAPE '!';
```

Zapis `!_` oznacza znak podkreślenia, a nie jedno dowolne miejsce. Wynik to **0 rekordów**.

```sql
SELECT 'a_b' LIKE '%!_%' ESCAPE '!' AS pasuje;
```

Wynik to `1`. Tekst `a_b` zawiera dosłowny znak `_`.

Porównywanie tekstów zależy też od ustawień kolumny. `nick` w bazie Islandia ma ustawienie `utf8_polish_ci`, które nie rozróżnia wielkości liter. Dlatego w tej bazie `LIKE 'j%'` znajduje także Janka i Jowitę:

```sql
SELECT nick
FROM turysci
WHERE nick LIKE 'j%';
```

W innej bazie wynik może być inny. Nie zakładaj, że `LIKE` zawsze odróżnia małą literę od wielkiej.

## Ćwiczenia

Najpierw przewidź wynik. Potem uruchom swoje zapytanie w phpMyAdmin i porównaj z rozwiązaniem.

### Ćwiczenie 1 - początek M

Wyświetl nicki zaczynające się od `M`. Dalsza długość ma być dowolna. Kogo znajdziesz?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Po literze `M` użyj znaku oznaczającego dowolną liczbę znaków.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

```sql
SELECT nick
FROM turysci
WHERE nick LIKE 'M%';
```

Wynik: **Monika** - jeden rekord.

</details>

### Ćwiczenie 2 - dokładnie trzy znaki

Wyświetl wszystkie nicki mające dokładnie trzy znaki. Przewidź, ile ich jest.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Potrzebujesz trzech miejsc. Każde ma oznaczać dokładnie jeden znak.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

```sql
SELECT nick
FROM turysci
WHERE nick LIKE '___';
```

Wynik: **Ewa**, **Ela** i **Ola** - trzy rekordy.

</details>

### Ćwiczenie 3 - wybierz właściwy znak

Znajdź nicki zaczynające się od `A` i mające dokładnie cztery znaki. Sam zdecyduj, czy potrzebujesz `%`, czy `_`.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 3</summary>

Po literze `A` mają być dokładnie trzy miejsca. Długość nie może być dowolna.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 3</summary>

```sql
SELECT nick
FROM turysci
WHERE nick LIKE 'A___';
```

Wynik: **Ania** i **Adam** - dwa rekordy. Każdy `_` oznacza jeden znak.

</details>

**Następny krok:** [SQL 0F - IN oraz NOT IN]({{ '/08-sql-od-zera/06-in-not-in.html' | relative_url }}).
