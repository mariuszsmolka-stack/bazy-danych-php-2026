---
title: SQL 0F - IN i NOT IN
---

# SQL 0F - IN i NOT IN

W [SQL 0C]({{ '/08-sql-od-zera/03-warunki-i-like.html' | relative_url }}) łączyliśmy warunki przez `OR`. Teraz sprawdzimy kilka możliwych wartości **jednej kolumny**.

Pracuj w phpMyAdmin na bazie `Islandia`, w tabeli `turysci`.

## 1. Cztery albo pięć punktów

Chcemy znaleźć turystów, którzy mają 4 albo 5 punktów. Potrafisz już użyć `OR`:

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty = 4 OR punkty = 5;
```

Wynik: **Monika - 4** i **Krzysiek - 5**.

To samo pytanie można zapisać krócej:

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty IN (4, 5);
```

Wynik: **Monika - 4** i **Krzysiek - 5**.

`IN` sprawdza, czy wartość należy do podanego zestawu. Tutaj punkty muszą mieć wartość `4` **lub** `5`.

W nawiasie podajesz możliwe wartości, oddzielone przecinkiem. Nie trzeba powtarzać nazwy `punkty` w dwóch warunkach `OR`.

**Małe pytanie:** Czy osoba z 7 punktami należy do zestawu `(4, 5)`?

## 2. Dwa nicki

`IN` działa także z tekstem. Wybierz Ewę i Elę:

```sql
SELECT nick
FROM turysci
WHERE nick IN ('Ewa', 'Ela');
```

Wynik: **Ewa** i **Ela**.

Liczby `4` i `5` zapisaliśmy bez apostrofów. Tekst `Ewa` i `Ela` zapisujemy w apostrofach. Wartości w zestawie oddzielamy przecinkami.

**Małe pytanie:** Dlaczego `Ewa` ma apostrofy, a `4` ich nie ma?

## 3. Pomiń wskazane punkty

Jak wybrać wszystkich **poza** osobami z 4 lub 5 punktami?

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty NOT IN (4, 5);
```

Wynik ma **11 rekordów**. Nie ma w nim Moniki (4) ani Krzyśka (5).

`NOT IN` wybiera rekordy, których wartość **nie należy** do wskazanego zestawu.

| Warunek | Co robi? |
| --- | --- |
| `IN (4, 5)` | Wybiera osoby z 4 lub 5 punktami. |
| `NOT IN (4, 5)` | Pomija osoby z 4 i 5 punktami. |

`IN` służy do sprawdzenia wartości z podanego zestawu. Nie zastępuje każdego rodzaju warunku SQL.

## 4. Ćwiczenia

Najpierw przewidź wynik. Potem wykonaj zapytanie w phpMyAdmin i sprawdź rozwiązanie.

### Ćwiczenie 1 - OR i IN

Znajdź osoby z 11 lub 12 punktami. Zapisz zapytanie raz z `OR`, a raz z `IN`. Czy wyniki będą takie same?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Z `OR` sprawdź osobno `punkty = 11` i `punkty = 12`. Z `IN` podaj obie liczby w nawiasie.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty = 11 OR punkty = 12;
```

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty IN (11, 12);
```

Oba zapytania zwracają **trzy rekordy**: Janek (12), Jowita (11) i Adam (11). Kolejność może się różnić.

</details>

### Ćwiczenie 2 - wartości tekstowe

Wyświetl nicki `Ania` i `Adam` za pomocą `IN`. Przewidź liczbę rekordów.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Każdy nick zapisz w apostrofach. Oddziel nicki przecinkiem.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

```sql
SELECT nick
FROM turysci
WHERE nick IN ('Ania', 'Adam');
```

Wynik: **Ania** i **Adam** - dwa rekordy.

</details>

### Ćwiczenie 3 - pomiń dwa wyniki

Wyświetl nicki i punkty osób, które **nie mają** ani 11, ani 23 punktów. Ile osób zostanie?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 3</summary>

Użyj `NOT IN` z dwiema liczbami w nawiasie.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 3</summary>

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty NOT IN (11, 23);
```

Wynik ma **9 rekordów**. Odpadają Ewa i Paula (23) oraz Jowita i Adam (11).

</details>

**Następny krok:** [SQL 0G - NOT i nierówności]({{ '/08-sql-od-zera/07-not-i-nierownosci.html' | relative_url }}).
