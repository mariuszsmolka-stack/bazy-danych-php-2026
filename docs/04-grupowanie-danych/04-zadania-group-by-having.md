---
title: ZBIÓR ZADAŃ 3 - GROUP BY I HAVING. 20 zadań
---

# ZBIÓR ZADAŃ 3 - GROUP BY I HAVING. 20 zadań

Pracuj na niezmienionej bazie `Islandia`. Najpierw napisz własne zapytanie w phpMyAdmin. Potem rozwiń rozwiązanie i sprawdź wynik. Możesz dojść do poprawnego wyniku także innym zapytaniem.

## Zadanie 1 - Cechy obiektów

Policz obiekty osobno dla każdej wartości `nazwaCechy`. Wyświetl nazwę cechy i liczbę obiektów. Posortuj wynik malejąco według liczby obiektów.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nazwaCechy, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY nazwaCechy
ORDER BY liczbaObiektow DESC, nazwaCechy;
```

Wynik: **6 grup**. Pierwsze wartości: `wysokość` / `18`; `długość` / `2`; `powierzchnia` / `2`.

</details>

## Zadanie 2 - Wyniki od 10 punktów

Uwzględnij turystów mających co najmniej 10 punktów. Dla każdej występującej wartości punktów podaj liczbę turystów, którzy ją zdobyli.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT punkty, COUNT(*) AS liczbaTurystow
FROM turysci
WHERE punkty >= 10
GROUP BY punkty
ORDER BY punkty;
```

Wynik: **8 grup**. Pierwsze wartości: `11` / `2`; `12` / `1`; `21` / `1`.

</details>

## Zadanie 3 - Państwa z trzema obiektami

Wyświetl państwa, dla których zapisano co najmniej trzy obiekty. Podaj liczbę obiektów oraz najmniejszy identyfikator obiektu w każdym z tych państw.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT panstwo, COUNT(*) AS liczbaObiektow, MIN(idObiekt) AS pierwszyIdObiekt
FROM obiekty
GROUP BY panstwo
HAVING COUNT(*) >= 3
ORDER BY panstwo;
```

Wynik: **3 grupy**. Pierwsze wartości: `Islandia` / `9` / `46`; `Polska` / `4` / `42`; `Tanzania` / `3` / `34`.

</details>

## Zadanie 4 - Suma wysokości według rodzaju

Dla obiektów z cechą `wysokość` oblicz sumę wartości tej cechy osobno dla każdego `idRodzaj`.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT idRodzaj, SUM(wartoscCechy) AS sumaWysokosci
FROM obiekty
WHERE nazwaCechy = 'wysokość'
GROUP BY idRodzaj
ORDER BY idRodzaj;
```

Wynik: **4 grupy**. Pierwsze wartości: `10` / `1937`; `11` / `23818`; `13` / `5267`.

</details>

## Zadanie 5 - Najmniejsza i największa wysokość

Dla obiektów z cechą `wysokość` wyświetl najmniejszą i największą wartość osobno dla każdego państwa.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT panstwo, MIN(wartoscCechy) AS minimum, MAX(wartoscCechy) AS maksimum
FROM obiekty
WHERE nazwaCechy = 'wysokość'
GROUP BY panstwo
ORDER BY panstwo;
```

Wynik: **9 grup**. Pierwsze wartości: `Islandia` / `30` / `1491`; `Japonia` / `3776` / `3776`; `Malezja` / `700` / `700`.

</details>

## Zadanie 6 - Średnia wysokość według rodzaju

Oblicz średnią wysokość dla poszczególnych `idRodzaj`. Uwzględnij wyłącznie obiekty z cechą `wysokość`. Zaokrąglij średnią do dwóch miejsc po przecinku.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT idRodzaj, ROUND(AVG(wartoscCechy), 2) AS sredniaWysokosc
FROM obiekty
WHERE nazwaCechy = 'wysokość'
GROUP BY idRodzaj
ORDER BY idRodzaj;
```

Wynik: **4 grupy**. Pierwsze wartości: `10` / `176.09`; `11` / `5954.50`; `13` / `2633.50`.

</details>

## Zadanie 7 - Rodzaje poza Islandią

Pomiń obiekty z Islandii. Dla każdego `idRodzaj` policz pozostałe obiekty i podaj najmniejszy identyfikator obiektu w grupie. Pokaż tylko rodzaje, dla których pozostały co najmniej dwa obiekty.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT idRodzaj, COUNT(*) AS liczbaObiektow, MIN(idObiekt) AS pierwszyIdObiekt
FROM obiekty
WHERE panstwo <> 'Islandia'
GROUP BY idRodzaj
HAVING COUNT(*) >= 2
ORDER BY idRodzaj;
```

Wynik: **3 grupy**. Pierwsze wartości: `10` / `8` / `29`; `11` / `3` / `30`; `17` / `2` / `32`.

</details>

## Zadanie 8 - Liczniejsze pary państwo–rodzaj

Uwzględnij obiekty z Islandii, Polski i Tanzanii. Policz obiekty osobno dla każdej pary państwo–`idRodzaj`. Pokaż tylko pary z co najmniej dwoma obiektami.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT panstwo, idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
WHERE panstwo IN ('Islandia', 'Polska', 'Tanzania')
GROUP BY panstwo, idRodzaj
HAVING COUNT(*) >= 2
ORDER BY panstwo, idRodzaj;
```

Wynik: **3 grupy**. Pierwsze wartości: `Islandia` / `10` / `4`; `Islandia` / `14` / `2`; `Polska` / `10` / `4`.

</details>

## Zadanie 9 - Największa wysokość ponad 500

Dla obiektów z cechą `wysokość` znajdź największą wartość w każdym państwie. Pokaż tylko państwa, w których ta wartość przekracza 500.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT panstwo, MAX(wartoscCechy) AS maksimum
FROM obiekty
WHERE nazwaCechy = 'wysokość'
GROUP BY panstwo
HAVING MAX(wartoscCechy) > 500
ORDER BY panstwo;
```

Wynik: **7 grup**. Pierwsze wartości: `Islandia` / `1491`; `Japonia` / `3776`; `Malezja` / `700`.

</details>

## Zadanie 10 - Najmniejsza wysokość poniżej 50

Dla obiektów z cechą `wysokość` znajdź najmniejszą wartość w każdym państwie. Pokaż tylko państwa, w których ta wartość jest mniejsza niż 50.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT panstwo, MIN(wartoscCechy) AS minimum
FROM obiekty
WHERE nazwaCechy = 'wysokość'
GROUP BY panstwo
HAVING MIN(wartoscCechy) < 50
ORDER BY panstwo;
```

Wynik: **2 grupy**. Pierwsze wartości: `Islandia` / `30`; `Polska` / `22`.

</details>

## Zadanie 11 - Średnia wysokość ponad 500

Dla obiektów z cechą `wysokość` oblicz średnią wysokość osobno dla każdego państwa. Pokaż tylko państwa ze średnią ponad 500. Zaokrąglij wynik do dwóch miejsc.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT panstwo, ROUND(AVG(wartoscCechy), 2) AS sredniaWysokosc
FROM obiekty
WHERE nazwaCechy = 'wysokość'
GROUP BY panstwo
HAVING AVG(wartoscCechy) > 500
ORDER BY panstwo;
```

Wynik: **6 grup**. Pierwsze wartości: `Japonia` / `3776.00`; `Malezja` / `700.00`; `Nepal` / `8849.00`.

</details>

## Zadanie 12 - Suma wysokości ponad 2000

Dla obiektów z cechą `wysokość` oblicz sumę wartości osobno dla każdego `idRodzaj`. Pokaż tylko rodzaje z sumą ponad 2000.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT idRodzaj, SUM(wartoscCechy) AS sumaWysokosci
FROM obiekty
WHERE nazwaCechy = 'wysokość'
GROUP BY idRodzaj
HAVING SUM(wartoscCechy) > 2000
ORDER BY idRodzaj;
```

Wynik: **2 grupy**. Pierwsze wartości: `11` / `23818`; `13` / `5267`.

</details>

## Zadanie 13 - Liczba i suma wysokości

Dla obiektów z cechą `wysokość` pokaż państwa z co najmniej dwoma takimi obiektami. Wyświetl liczbę obiektów i sumę ich wysokości.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT panstwo, COUNT(*) AS liczbaObiektow, SUM(wartoscCechy) AS sumaWysokosci
FROM obiekty
WHERE nazwaCechy = 'wysokość'
GROUP BY panstwo
HAVING COUNT(*) >= 2
ORDER BY panstwo;
```

Wynik: **3 grupy**. Pierwsze wartości: `Islandia` / `6` / `2134`; `Polska` / `4` / `139`; `Tanzania` / `2` / `6003`.

</details>

## Zadanie 14 - Trzy miary wysokości

Dla każdego `idRodzaj` oblicz najmniejszą, największą i średnią wysokość. Pokaż tylko grupy z co najmniej dwoma obiektami o cesze `wysokość`. Zaokrąglij średnią do dwóch miejsc.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT idRodzaj, MIN(wartoscCechy) AS minimum, MAX(wartoscCechy) AS maksimum,
       ROUND(AVG(wartoscCechy), 2) AS sredniaWysokosc
FROM obiekty
WHERE nazwaCechy = 'wysokość'
GROUP BY idRodzaj
HAVING COUNT(*) >= 2
ORDER BY idRodzaj;
```

Wynik: **3 grupy**. Pierwsze wartości: `10` / `22` / `730` / `176.09`; `11` / `463` / `8849` / `5954.50`; `13` / `1491` / `3776` / `2633.50`.

</details>

## Zadanie 15 - Dwa warunki dla średniej

Dla obiektów z cechą `wysokość` pokaż państwa z co najmniej dwoma takimi obiektami i średnią wysokością ponad 300. Wyświetl państwo, liczbę obiektów i średnią zaokrągloną do dwóch miejsc.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT panstwo, COUNT(*) AS liczbaObiektow,
       ROUND(AVG(wartoscCechy), 2) AS sredniaWysokosc
FROM obiekty
WHERE nazwaCechy = 'wysokość'
GROUP BY panstwo
HAVING COUNT(*) >= 2 AND AVG(wartoscCechy) > 300
ORDER BY panstwo;
```

Wynik: **2 grupy**. Pierwsze wartości: `Islandia` / `6` / `355.67`; `Tanzania` / `2` / `3001.50`.

</details>

## Zadanie 16 - Państwa poza Islandią

Pomiń obiekty z Islandii. Wyświetl państwa, w których pozostały co najmniej dwa obiekty. Pokaż liczbę obiektów i posortuj malejąco według tej liczby.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT panstwo, COUNT(*) AS liczbaObiektow
FROM obiekty
WHERE panstwo <> 'Islandia'
GROUP BY panstwo
HAVING COUNT(*) >= 2
ORDER BY liczbaObiektow DESC, panstwo;
```

Wynik: **2 grupy**. Pierwsze wartości: `Polska` / `4`; `Tanzania` / `3`.

</details>

## Zadanie 17 - Pary występujące raz

Uwzględnij tylko Islandię, Polskę i Tanzanię. Dla każdej pary państwo–`idRodzaj` pokaż kombinacje występujące dokładnie raz.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT panstwo, idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
WHERE panstwo IN ('Islandia', 'Polska', 'Tanzania')
GROUP BY panstwo, idRodzaj
HAVING COUNT(*) = 1
ORDER BY panstwo, idRodzaj;
```

Wynik: **6 grup**. Pierwsze wartości: `Islandia` / `11` / `1`; `Islandia` / `13` / `1`; `Islandia` / `15` / `1`.

</details>

## Zadanie 18 - Cechy i rodzaje z wieloma obiektami

Dla każdej pary `nazwaCechy`–`idRodzaj` policz obiekty. Pokaż pary występujące przy co najmniej dwóch obiektach. Posortuj od najliczniejszej pary.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nazwaCechy, idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY nazwaCechy, idRodzaj
HAVING COUNT(*) >= 2
ORDER BY liczbaObiektow DESC, nazwaCechy, idRodzaj;
```

Wynik: **4 grupy**. Pierwsze wartości: `wysokość` / `10` / `11`; `wysokość` / `11` / `4`; `długość` / `17` / `2`.

</details>

## Zadanie 19 - Liczne rodzaje z wysokim maksimum

Dla obiektów z cechą `wysokość` pokaż `idRodzaj` z co najmniej dwoma takimi obiektami i największą wysokością ponad 1000. Wyświetl identyfikator rodzaju, liczbę obiektów, minimum i maksimum.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT idRodzaj, COUNT(*) AS liczbaObiektow, MIN(wartoscCechy) AS minimum,
       MAX(wartoscCechy) AS maksimum
FROM obiekty
WHERE nazwaCechy = 'wysokość'
GROUP BY idRodzaj
HAVING COUNT(*) >= 2 AND MAX(wartoscCechy) > 1000
ORDER BY idRodzaj;
```

Wynik: **2 grupy**. Pierwsze wartości: `11` / `4` / `463` / `8849`; `13` / `2` / `1491` / `3776`.

</details>

## Zadanie 20 - Pełne zestawienie wysokości

Dla obiektów z cechą `wysokość` przygotuj zestawienie według państw. Uwzględnij państwa z co najmniej dwoma takimi obiektami i sumą wysokości ponad 2000. Pokaż państwo, liczbę obiektów, sumę, średnią, minimum i maksimum. Zaokrąglij średnią do dwóch miejsc i posortuj malejąco według niej.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT panstwo, COUNT(*) AS liczbaObiektow, SUM(wartoscCechy) AS sumaWysokosci,
       ROUND(AVG(wartoscCechy), 2) AS sredniaWysokosc,
       MIN(wartoscCechy) AS minimum, MAX(wartoscCechy) AS maksimum
FROM obiekty
WHERE nazwaCechy = 'wysokość'
GROUP BY panstwo
HAVING COUNT(*) >= 2 AND SUM(wartoscCechy) > 2000
ORDER BY sredniaWysokosc DESC, panstwo;
```

Wynik: **2 grupy**. Pierwsze wartości: `Tanzania` / `2` / `6003` / `3001.50` / `108` / `5895`; `Islandia` / `6` / `2134` / `355.67` / `30` / `1491`.

</details>
