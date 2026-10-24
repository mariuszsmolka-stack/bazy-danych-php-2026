---
title: SQL 0I - NULL, IS NULL i IS NOT NULL
---

# SQL 0I - NULL, IS NULL i IS NOT NULL

W [SQL 0F]({{ '/08-sql-od-zera/06-in-not-in.html' | relative_url }}) poznaliśmy `NOT IN`. Zobaczmy, co zmienia wartość `NULL`.

Pracuj w phpMyAdmin na niezmienionej bazie `Islandia`. W tabeli `turysci` żaden zapisany nick ani wynik punktowy nie ma wartości `NULL`. Przykłady z `NULL` wykonamy przez `SELECT`, bez dopisywania rekordów.

## 1. Brak wartości to nie zero

`NULL` oznacza, że wartości nie zapisano albo jej nie znamy. To nie jest liczba `0` ani pusty tekst `''`.

```sql
SELECT NULL AS brak_wartosci, 0 AS zero, '' AS pusty_tekst;
```

Wynik ma jeden wiersz z trzema różnymi wartościami. W phpMyAdmin brak wartości jest oznaczony jako `NULL`.

**Małe pytanie:** Czy z braku wyniku punktowego wolno wywnioskować, że turysta zdobył zero punktów?

W tabeli `obiekty` widać różnicę między pustym tekstem a `NULL`. Sprawdź opisy, w których zapisano pusty tekst:

```sql
SELECT idObiekt, nazwa
FROM obiekty
WHERE opis = '';
```

Wynik ma **14 rekordów**. Kolumna `opis` ma w nich wartość `''`, czyli tekst o długości zero.

Teraz sprawdź brak wartości:

```sql
SELECT idObiekt, nazwa
FROM obiekty
WHERE opis IS NULL;
```

Wynik ma **0 rekordów**. W tej kolumnie nie ma wartości `NULL`. Pusty opis nie oznacza braku zapisanej wartości.

## 2. Szukaj przez IS NULL

Sprawdź, czy w rzeczywistej tabeli komuś nie zapisano punktów:

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty IS NULL;
```

Wynik ma **0 rekordów**. W obecnych danych każdy turysta ma punkty.

Warunek odwrotny wybiera rekordy z zapisaną wartością:

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty IS NOT NULL;
```

Wynik ma **13 rekordów**. `IS NOT NULL` oznacza, że wartość jest znana. Nie mówi, czy jest większa od zera.

## 3. Dlaczego nie = NULL?

Zwykłe porównanie z nieznaną wartością także daje nieznany wynik. Sprawdź:

```sql
SELECT NULL = NULL AS rowne, NULL <> NULL AS rozne;
```

Obie kolumny mają wynik `NULL`, czyli **UNKNOWN**. Nie otrzymujemy ani prawdy, ani fałszu. Dlatego do wyszukiwania braku wartości używaj `IS NULL` albo `IS NOT NULL`, a nie `= NULL` czy `<> NULL`.

W ćwiczeniu niżej zobaczysz też `SELECT 5 = NULL AS wynik;`. Taki `SELECT` oblicza samo porównanie, więc nie potrzebuje `FROM`. `AS wynik` nadaje nazwę kolumnie. Jej wartością będzie `NULL`, czyli **UNKNOWN**.

Warunek w `WHERE` przepuszcza tylko rekordy, dla których otrzyma **TRUE**. Odrzuca **FALSE** oraz **UNKNOWN**.

| Wynik warunku | Czy rekord przejdzie przez WHERE? |
| --- | --- |
| `TRUE` - prawda | Tak |
| `FALSE` - fałsz | Nie |
| `UNKNOWN` - nie wiadomo | Nie |

**Małe pytanie:** Czy `WHERE punkty = NULL` znalazłoby brakujące punkty?

## 4. Pułapka NOT IN

Bez `NULL` można sprawdzić, że 1 nie należy do listy `(2, 3)`:

```sql
SELECT 1 NOT IN (2, 3) AS wynik;
```

Wynik to `1`, czyli **TRUE**. Dodaj nieznaną wartość do listy:

```sql
SELECT 1 NOT IN (2, NULL) AS wynik;
```

Wynik to `NULL`, czyli **UNKNOWN**. Wiemy, że 1 jest różne od 2, ale nie możemy sprawdzić, czy jest różne od wartości nieznanej. Gdy taki warunek znajdzie się w `WHERE`, rekord nie przejdzie.

```sql
SELECT nick
FROM turysci
WHERE punkty NOT IN (4, NULL);
```

Wynik ma **0 rekordów**. Nawet dla osób z wynikiem innym niż 4 nie da się rozstrzygnąć porównania z `NULL` na liście. Nie dopisuj `NULL` do listy `NOT IN`, jeśli oczekujesz zwykłego wykluczenia znanych wartości. Brak wartości sprawdzaj osobno przez `IS NULL`.

## 5. Ćwiczenia

Najpierw przewidź wynik. Potem uruchom zapytanie w phpMyAdmin.

### Ćwiczenie 1 - prawda czy nie wiadomo?

Jaki wynik zwróci poniższe wyrażenie: `TRUE`, `FALSE` czy `UNKNOWN`?

```sql
SELECT 5 = NULL AS wynik;
```

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Nie wiemy, jaka liczba kryje się za `NULL`. Czy możemy rozstrzygnąć równość?

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

Wynik to `NULL`, czyli **UNKNOWN**. Porównanie przez `=` nie służy do sprawdzania braku wartości.

</details>

### Ćwiczenie 2 - zapisane punkty

Wyświetl nicki i punkty turystów, dla których zapisano wynik punktowy. Ilu ich jest?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Wybierz rekordy, których `punkty` nie są `NULL`.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty IS NOT NULL;
```

Wynik ma **13 rekordów**. Każdy turysta ma zapisane punkty.

</details>

### Ćwiczenie 3 - brak wyniku

Wyświetl nicki osób, dla których nie zapisano wyniku punktowego. Sam wybierz właściwy warunek. Ilu rekordów się spodziewasz w aktualnej bazie?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 3</summary>

Brak wartości nie jest zerem. Nie używaj zwykłego znaku równości.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 3</summary>

```sql
SELECT nick
FROM turysci
WHERE punkty IS NULL;
```

Wynik ma **0 rekordów**. W danych Islandia wszystkie wyniki punktowe są zapisane.

</details>

**Następny krok:** [SQL 0J - AND, OR, NOT i kolejność warunków]({{ '/08-sql-od-zera/10-warunki-logiczne.html' | relative_url }}).
