---
title: Lekcja 7B - DISTINCT i DISTINCTROW. Kilka kolumn
---

# Lekcja 7B - DISTINCT i DISTINCTROW. Kilka kolumn

W [lekcji 7A]({{ '/04-grupowanie-danych/03a-distinct-podstawy.html' | relative_url }}) użyliśmy `DISTINCT`, aby otrzymać listę bez powtórzeń. Dane w tabeli się nie zmieniły.

Wybieraliśmy wtedy jedną kolumnę. Teraz sprawdzimy, co dzieje się przy dwóch kolumnach. Pracuj w phpMyAdmin na bazie `Islandia` z pliku `baza1.sql`.

## 1. Dwa obiekty o tej samej nazwie

Jakie nazwy i rodzaje mają obiekty z Tanzanii? Zobaczmy najpierw wszystkie pasujące wiersze.

```sql
SELECT nazwa, idRodzaj
FROM obiekty
WHERE panstwo = 'Tanzania'
ORDER BY nazwa, idRodzaj;
```

| nazwa | idRodzaj |
| --- | ---: |
| Kilimanjaro | 11 |
| Wiktorii | 10 |
| Wiktorii | 12 |

Wynik ma **3 wiersze**. Nazwa `Wiktorii` występuje przy dwóch różnych obiektach. Jeden jest wodospadem, a drugi jeziorem.

## 2. Wybierz tylko nazwy

Chcemy odpowiedzieć na pytanie: jakie różne **nazwy** obiektów występują w Tanzanii?

```sql
SELECT DISTINCT nazwa
FROM obiekty
WHERE panstwo = 'Tanzania'
ORDER BY nazwa;
```

| nazwa |
| --- |
| Kilimanjaro |
| Wiktorii |

Wybraliśmy tylko kolumnę `nazwa`. Oba napisy `Wiktorii` są takie same, więc w wyniku widzimy tę nazwę raz.

Wynik ma **2 wiersze**. Oba obiekty o nazwie `Wiktorii` nadal są w bazie.

## 3. Wybierz nazwę razem z rodzajem

Teraz pytamy o różne **pary nazwy i rodzaju**. Do listy wybieranych kolumn dodajemy `idRodzaj`.

```sql
SELECT DISTINCT nazwa, idRodzaj
FROM obiekty
WHERE panstwo = 'Tanzania'
ORDER BY nazwa, idRodzaj;
```

| nazwa | idRodzaj |
| --- | ---: |
| Kilimanjaro | 11 |
| Wiktorii | 10 |
| Wiktorii | 12 |

Wynik znów ma **3 wiersze**. Para `Wiktorii, 10` różni się od pary `Wiktorii, 12`.

`DISTINCT` porównuje cały zestaw wybranych kolumn. Nie usuwa powtórzeń z każdej kolumny osobno.

Przed napisaniem zapytania zapytaj: czy jeden wiersz ma oznaczać samą nazwę, czy nazwę razem z rodzajem?

## 4. Co oznacza DISTINCTROW?

W MariaDB możesz spotkać także zapis `DISTINCTROW`:

```sql
SELECT DISTINCTROW nazwa, idRodzaj
FROM obiekty
WHERE panstwo = 'Tanzania'
ORDER BY nazwa, idRodzaj;
```

To zapytanie zwraca te same trzy pary co poprzednie. W MariaDB `DISTINCTROW` oznacza to samo co `DISTINCT`.

Oba zapisy porównują wybrane kolumny: tutaj `nazwa` i `idRodzaj`.

## 5. Dlaczego gwiazdka nie pomaga?

Spróbuj przewidzieć liczbę wierszy:

```sql
SELECT DISTINCT *
FROM turysci;
```

Otrzymasz **13 wierszy**. Gwiazdka wybiera wszystkie kolumny, w tym `idTurysta`.

Każdy turysta ma inny identyfikator. Dlatego całe wiersze są różne, nawet jeśli dwie osoby mają tyle samo punktów.

W zapytaniu nie ma `ORDER BY`, więc kolejność wynikowych wierszy nie jest gwarantowana.

## 6. Lista czy jedna liczba?

W lekcji 7A otrzymaliśmy listę 11 różnych wyników punktowych. A jeśli chcemy wiedzieć tylko, **ile** takich wyników występuje?

```sql
SELECT COUNT(DISTINCT punkty)
       AS liczbaRoznychWynikow
FROM turysci;
```

Wynik to **11**. Zapytanie zwraca jeden wiersz z tą liczbą.

`SELECT DISTINCT punkty` daje listę różnych wartości. `COUNT(DISTINCT punkty)` mówi, ile ich jest.

## 7. Ćwiczenia

Najpierw przewidź wynik i spróbuj samodzielnie napisać zapytanie. Potem sprawdź je w phpMyAdmin.

### Ćwiczenie 1 - pary państwo i rodzaj

Wybierz obiekty z Islandii i Polski. Pokaż różne pary `panstwo, idRodzaj`, uporządkowane według państwa i identyfikatora rodzaju.

Ile par otrzymasz? Potem zamień `DISTINCT` na `DISTINCTROW` i porównaj wyniki.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Wybierz obie kolumny po `SELECT DISTINCT`. W `WHERE` podaj Islandię lub Polskę. Zmień tylko słowo po `SELECT`, gdy będziesz porównywać oba zapisy.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

```sql
SELECT DISTINCT panstwo, idRodzaj
FROM obiekty
WHERE panstwo = 'Islandia' OR panstwo = 'Polska'
ORDER BY panstwo, idRodzaj;
```

| panstwo | idRodzaj |
| --- | ---: |
| Islandia | 10 |
| Islandia | 11 |
| Islandia | 13 |
| Islandia | 14 |
| Islandia | 15 |
| Polska | 10 |

Wynik zawiera **6 różnych par**. Polska i Islandia mają obiekty rodzaju `10`, ale są to różne pary, bo państwa się różnią.

Po zamianie zapisu otrzymasz te same 6 par:

```sql
SELECT DISTINCTROW panstwo, idRodzaj
FROM obiekty
WHERE panstwo = 'Islandia' OR panstwo = 'Polska'
ORDER BY panstwo, idRodzaj;
```

</details>

### Ćwiczenie 2 - policz różne rodzaje

Ile różnych identyfikatorów rodzaju występuje wśród obiektów z Islandii? Zwróć **jedną liczbę**, a nie listę identyfikatorów.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Wybierz Islandię przez `WHERE`. Do policzenia różnych wartości `idRodzaj` użyj `COUNT(DISTINCT ...)`.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

```sql
SELECT COUNT(DISTINCT idRodzaj) AS liczbaRodzajow
FROM obiekty
WHERE panstwo = 'Islandia';
```

Wynik to **5**. Tyle różnych identyfikatorów rodzaju występuje wśród islandzkich obiektów.

</details>

## 8. Co warto zapamiętać?

`DISTINCT` porównuje cały wybrany wiersz. Przy dwóch kolumnach porównuje ich parę.

W MariaDB `DISTINCTROW` daje ten sam wynik co `DISTINCT`. `DISTINCT *` nie usunie turystów, których różnią identyfikatory.

`COUNT(DISTINCT kolumna)` zwraca jedną liczbę różnych wartości. Pełne opracowanie lekcji 7 zawiera więcej przykładów.
