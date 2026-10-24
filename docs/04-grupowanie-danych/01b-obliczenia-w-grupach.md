---
title: Lekcja 5B - SUM, AVG, MIN i MAX
---

# Lekcja 5B - SUM, AVG, MIN i MAX

W [lekcji 5A]({{ '/04-grupowanie-danych/01a-group-by-podstawy.html' | relative_url }}) grupowaliśmy rekordy i liczyliśmy je za pomocą `COUNT(*)`. Wiemy też, że `WHERE` wybiera rekordy przed grupowaniem.

Teraz wykonamy inne obliczenia. Pracuj w phpMyAdmin na bazie `Islandia` z pliku `baza1.sql`.

## 1. Ile punktów zdobyli wszyscy razem?

W tabeli `turysci` są punkty 13 osób. Chcemy dodać je do siebie.

```sql
SELECT SUM(punkty) AS sumaPunktow
FROM turysci;
```

`SUM(punkty)` dodaje wartości z kolumny `punkty`. W tym zapytaniu dodaje punkty wszystkich turystów.

Wynik: **290**.

## 2. Ile punktów zdobył średnio jeden turysta?

Teraz chcemy poznać średnią liczbę punktów.

```sql
SELECT ROUND(AVG(punkty), 2) AS sredniaPunktow
FROM turysci;
```

`AVG(punkty)` oblicza średnią. `ROUND(..., 2)` zaokrągla ją do dwóch miejsc po przecinku.

Wynik: **22.31**.

## 3. Jakie są skrajne wyniki?

Szukamy najmniejszej i największej liczby punktów.

```sql
SELECT MIN(punkty) AS minimum,
       MAX(punkty) AS maksimum
FROM turysci;
```

`MIN(punkty)` znajduje najmniejszą wartość. `MAX(punkty)` znajduje największą.

| minimum | maksimum |
| ---: | ---: |
| 4 | 51 |

Dotąd każde zapytanie obliczało wynik dla wszystkich turystów razem.

## 4. Policz osobno dla każdej grupy

Możemy też wykonać obliczenia osobno dla grup. `GROUP BY` utworzy te grupy, tak jak w lekcji 5A.

Sprawdźmy wysokości wodospadów w Polsce i Islandii. W tabeli `obiekty` wodospad ma `idRodzaj = 10`.

Pole `wartoscCechy` nie zawsze oznacza wysokość. Wybierzemy tylko rekordy z `nazwaCechy = 'wysokość'`.

| Państwo | Zapisane wysokości wodospadów |
| --- | --- |
| Islandia | 60, 60, 30 |
| Polska | 24, 23, 70, 22 |

Najpierw `WHERE` wybierze te wodospady. Potem `GROUP BY panstwo` utworzy grupę dla każdego państwa.

```sql
SELECT
    panstwo,
    COUNT(*) AS liczbaWodospadow,
    MIN(wartoscCechy) AS najmniejszaWysokosc,
    MAX(wartoscCechy) AS najwiekszaWysokosc,
    ROUND(AVG(wartoscCechy), 2) AS sredniaWysokosc
FROM obiekty
WHERE idRodzaj = 10
  AND nazwaCechy = 'wysokość'
  AND panstwo IN ('Islandia', 'Polska')
GROUP BY panstwo
ORDER BY panstwo;
```

Jeden wiersz wyniku opisuje jedno państwo. `MIN`, `MAX` i `AVG` liczą wartości osobno dla każdej grupy.

| panstwo | liczbaWodospadow | najmniejszaWysokosc | najwiekszaWysokosc | sredniaWysokosc |
| --- | ---: | ---: | ---: | ---: |
| Islandia | 3 | 30 | 60 | 50.00 |
| Polska | 4 | 22 | 70 | 34.75 |

Dettifoss też jest wodospadem w Islandii. W jego rekordzie zapisana cecha to jednak przepustowość, a nie wysokość. Dlatego warunek `WHERE` go pomija.

## 5. Ćwiczenia

Najpierw spróbuj samodzielnie zmienić zapytanie. Potem uruchom je w phpMyAdmin i sprawdź wynik.

### Ćwiczenie 1 - wybierz obliczenie

Wróć do zapytań z punktów 1-3. Przygotuj cztery wersje zapytania do tabeli `turysci`. W każdej zmień obliczenie w `SELECT`, aby otrzymać:

1. Łączną liczbę punktów turystów.
2. Średnią liczbę punktów, zaokrągloną do dwóch miejsc po przecinku.
3. Najmniejszą liczbę punktów.
4. Największą liczbę punktów.

Sam wybierz właściwą funkcję dla każdego pytania. Pozostaw `FROM turysci`.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Porównaj pytania z punktami 1-3. W każdym zapytaniu zmieniasz obliczenie w `SELECT`.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

Łączna liczba: `SUM(punkty)` => **290**.

Średnia: `ROUND(AVG(punkty), 2)` => **22.31**.

Najmniejsza wartość: `MIN(punkty)` => **4**.

Największa wartość: `MAX(punkty)` => **51**.

</details>

### Ćwiczenie 2 - tylko Polska

Zmień zapytanie z punktu 4, aby wynik dotyczył tylko Polski. Zmień warunek wyboru państwa i uruchom zapytanie.

Sprawdź, czy najmniejsza wysokość wynosi **22**, a największa **70**.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Zamiast wybierać dwa państwa przez `IN`, użyj warunku `panstwo = 'Polska'`. Pozostałe warunki wyboru zostaw bez zmian.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

```sql
SELECT
    panstwo,
    COUNT(*) AS liczbaWodospadow,
    MIN(wartoscCechy) AS najmniejszaWysokosc,
    MAX(wartoscCechy) AS najwiekszaWysokosc,
    ROUND(AVG(wartoscCechy), 2) AS sredniaWysokosc
FROM obiekty
WHERE idRodzaj = 10
  AND nazwaCechy = 'wysokość'
  AND panstwo = 'Polska'
GROUP BY panstwo
ORDER BY panstwo;
```

Wynik: Polska - 4 wodospady, minimum **22**, maksimum **70**, średnia **34.75**.

</details>

Więcej przykładów znajdziesz w [pełnym opracowaniu GROUP BY]({{ '/04-grupowanie-danych/01-group-by.html' | relative_url }}).
