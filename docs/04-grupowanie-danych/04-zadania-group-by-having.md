---
title: ZBIÓR ZADAŃ 2 - GROUP BY I HAVING. 20 zadań
---

# ZBIÓR ZADAŃ 2 - GROUP BY I HAVING. 20 zadań

Dwadzieścia zadań sprawdzi, czy potrafisz samodzielnie obliczać wyniki dla grup. Pracujemy na jednej tabeli naraz.

Wykonaj zadania na niezmienionej bazie `Islandia`. Najpierw napisz własne zapytanie w phpMyAdmin. Potem rozwiń rozwiązanie i porównaj wynik.

## Zadanie 1 - Turyści dla każdego wyniku

Dla każdej występującej liczby punktów pokaż tę liczbę oraz liczbę turystów, którzy ją zdobyli.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT punkty, COUNT(*) AS liczbaTurystow
FROM turysci
GROUP BY punkty
ORDER BY punkty;
```

Wynik: **11 grup**. Przykładowe wiersze: `punkty` = `4`, `liczbaTurystow` = `1`; `punkty` = `11`, `liczbaTurystow` = `2`; `punkty` = `23`, `liczbaTurystow` = `2`. Kolejność wynika z `ORDER BY`.

</details>

## Zadanie 2 - Powtarzające się wyniki

Pokaż tylko takie wyniki punktowe, które zdobyło co najmniej dwóch turystów. Podaj liczbę turystów w każdej grupie.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT punkty, COUNT(*) AS liczbaTurystow
FROM turysci
GROUP BY punkty
HAVING COUNT(*) >= 2
ORDER BY punkty;
```

Wynik: **2 grupy**. Przykładowe wiersze: `punkty` = `11`, `liczbaTurystow` = `2`; `punkty` = `23`, `liczbaTurystow` = `2`. Kolejność wynika z `ORDER BY`.

</details>

## Zadanie 3 - Wyniki występujące raz

Pokaż wyniki punktowe, które występują dokładnie raz. Podaj liczbę turystów dla każdego wyniku.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT punkty, COUNT(*) AS liczbaTurystow
FROM turysci
GROUP BY punkty
HAVING COUNT(*) = 1
ORDER BY punkty;
```

Wynik: **9 grup**. Przykładowe wiersze: `punkty` = `4`, `liczbaTurystow` = `1`; `punkty` = `5`, `liczbaTurystow` = `1`; `punkty` = `7`, `liczbaTurystow` = `1`. Kolejność wynika z `ORDER BY`.

</details>

## Zadanie 4 - Powtarzające się wysokie wyniki

Uwzględnij tylko turystów, którzy mają co najmniej 20 punktów. Wśród ich wyników pokaż te, które powtarzają się co najmniej dwa razy. Podaj liczbę turystów.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT punkty, COUNT(*) AS liczbaTurystow
FROM turysci
WHERE punkty >= 20
GROUP BY punkty
HAVING COUNT(*) >= 2
ORDER BY punkty;
```

Wynik: **1 grupa**. Przykładowe wiersze: `punkty` = `23`, `liczbaTurystow` = `2`. Kolejność wynika z `ORDER BY`.

</details>

## Zadanie 5 - Obiekty w państwach

Policz obiekty osobno dla każdego państwa. Wyświetl państwo i liczbę obiektów.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT panstwo, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY panstwo
ORDER BY panstwo;
```

Wynik: **12 grup**. Przykładowe wiersze: `panstwo` = `Chiny`, `liczbaObiektow` = `1`; `panstwo` = `Islandia`, `liczbaObiektow` = `9`; `panstwo` = `Japonia`, `liczbaObiektow` = `1`. Kolejność wynika z `ORDER BY`.

</details>

## Zadanie 6 - Obiekty według rodzaju

Policz obiekty osobno dla każdego identyfikatora rodzaju `idRodzaj`.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY idRodzaj
ORDER BY idRodzaj;
```

Wynik: **8 grup**. Przykładowe wiersze: `idRodzaj` = `10`, `liczbaObiektow` = `12`; `idRodzaj` = `11`, `liczbaObiektow` = `4`; `idRodzaj` = `12`, `liczbaObiektow` = `1`. Kolejność wynika z `ORDER BY`.

</details>

## Zadanie 7 - Rodzaje obiektów Islandii

Policz obiekty Islandii w poszczególnych rodzajach. Wyświetl `idRodzaj` i liczbę obiektów.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
WHERE panstwo = 'Islandia'
GROUP BY idRodzaj
ORDER BY idRodzaj;
```

Wynik: **5 grup**. Przykładowe wiersze: `idRodzaj` = `10`, `liczbaObiektow` = `4`; `idRodzaj` = `11`, `liczbaObiektow` = `1`; `idRodzaj` = `13`, `liczbaObiektow` = `1`. Kolejność wynika z `ORDER BY`.

</details>

## Zadanie 8 - Rodzaje obiektów Polski

Policz obiekty Polski w poszczególnych rodzajach. Wyświetl `idRodzaj` i liczbę obiektów.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
WHERE panstwo = 'Polska'
GROUP BY idRodzaj
ORDER BY idRodzaj;
```

Wynik: **1 grupa**. Przykładowe wiersze: `idRodzaj` = `10`, `liczbaObiektow` = `4`. Kolejność wynika z `ORDER BY`.

</details>

## Zadanie 9 - Państwa z wieloma obiektami

Wyświetl państwa, w których znajdują się co najmniej dwa obiekty. Podaj liczbę obiektów.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT panstwo, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY panstwo
HAVING COUNT(*) >= 2
ORDER BY panstwo;
```

Wynik: **3 grupy**. Przykładowe wiersze: `panstwo` = `Islandia`, `liczbaObiektow` = `9`; `panstwo` = `Polska`, `liczbaObiektow` = `4`; `panstwo` = `Tanzania`, `liczbaObiektow` = `3`. Kolejność wynika z `ORDER BY`.

</details>

## Zadanie 10 - Państwa z jednym obiektem

Wyświetl państwa, dla których zapisano dokładnie jeden obiekt. Podaj liczbę obiektów.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT panstwo, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY panstwo
HAVING COUNT(*) = 1
ORDER BY panstwo;
```

Wynik: **9 grup**. Przykładowe wiersze: `panstwo` = `Chiny`, `liczbaObiektow` = `1`; `panstwo` = `Japonia`, `liczbaObiektow` = `1`; `panstwo` = `Laos`, `liczbaObiektow` = `1`. Kolejność wynika z `ORDER BY`.

</details>

## Zadanie 11 - Państwo i rodzaj

Policz obiekty dla każdej kombinacji państwa i `idRodzaj`. Wyświetl obie kolumny grupujące oraz liczbę obiektów.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT panstwo, idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY panstwo, idRodzaj
ORDER BY panstwo, idRodzaj;
```

Wynik: **18 grup**. Przykładowe wiersze: `panstwo` = `Chiny`, `idRodzaj` = `17`, `liczbaObiektow` = `1`; `panstwo` = `Islandia`, `idRodzaj` = `10`, `liczbaObiektow` = `4`; `panstwo` = `Islandia`, `idRodzaj` = `11`, `liczbaObiektow` = `1`. Kolejność wynika z `ORDER BY`.

</details>

## Zadanie 12 - Liczniejsze grupy w dwóch państwach

Uwzględnij tylko obiekty Polski i Islandii. Pokaż te kombinacje państwa i rodzaju, które zawierają co najmniej dwa obiekty. Podaj liczebność grup.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT panstwo, idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
WHERE panstwo IN ('Polska', 'Islandia')
GROUP BY panstwo, idRodzaj
HAVING COUNT(*) >= 2
ORDER BY panstwo, idRodzaj;
```

Wynik: **3 grupy**. Przykładowe wiersze: `panstwo` = `Islandia`, `idRodzaj` = `10`, `liczbaObiektow` = `4`; `panstwo` = `Islandia`, `idRodzaj` = `14`, `liczbaObiektow` = `2`; `panstwo` = `Polska`, `idRodzaj` = `10`, `liczbaObiektow` = `4`. Kolejność wynika z `ORDER BY`.

</details>

## Zadanie 13 - Liczba obiektów według cechy

Policz obiekty osobno dla każdej wartości `nazwaCechy`. Wyświetl nazwę cechy i liczbę obiektów.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT nazwaCechy, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY nazwaCechy
ORDER BY nazwaCechy;
```

Wynik: **6 grup**. Przykładowe wiersze: `nazwaCechy` = `długość`, `liczbaObiektow` = `2`; `nazwaCechy` = `powierzchnia`, `liczbaObiektow` = `2`; `nazwaCechy` = `wysokość`, `liczbaObiektow` = `18`. Kolejność wynika z `ORDER BY`.

</details>

## Zadanie 14 - Wysokość w państwach

Uwzględnij tylko obiekty, dla których `nazwaCechy` to `wysokość`. Policz je osobno dla każdego państwa.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT panstwo, COUNT(*) AS liczbaObiektow
FROM obiekty
WHERE nazwaCechy = 'wysokość'
GROUP BY panstwo
ORDER BY panstwo;
```

Wynik: **9 grup**. Przykładowe wiersze: `panstwo` = `Islandia`, `liczbaObiektow` = `6`; `panstwo` = `Japonia`, `liczbaObiektow` = `1`; `panstwo` = `Malezja`, `liczbaObiektow` = `1`. Kolejność wynika z `ORDER BY`.

</details>

## Zadanie 15 - Największa wysokość

Dla obiektów z cechą `wysokość` wyświetl największą wartość `wartoscCechy` osobno dla każdego państwa.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT panstwo, MAX(wartoscCechy) AS najwiekszaWysokosc
FROM obiekty
WHERE nazwaCechy = 'wysokość'
GROUP BY panstwo
ORDER BY panstwo;
```

Wynik: **9 grup**. Przykładowe wiersze: `panstwo` = `Islandia`, `najwiekszaWysokosc` = `1491`; `panstwo` = `Japonia`, `najwiekszaWysokosc` = `3776`; `panstwo` = `Malezja`, `najwiekszaWysokosc` = `700`. Kolejność wynika z `ORDER BY`.

</details>

## Zadanie 16 - Najmniejsza wysokość

Dla obiektów z cechą `wysokość` wyświetl najmniejszą wartość `wartoscCechy` osobno dla każdego państwa.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT panstwo, MIN(wartoscCechy) AS najmniejszaWysokosc
FROM obiekty
WHERE nazwaCechy = 'wysokość'
GROUP BY panstwo
ORDER BY panstwo;
```

Wynik: **9 grup**. Przykładowe wiersze: `panstwo` = `Islandia`, `najmniejszaWysokosc` = `30`; `panstwo` = `Japonia`, `najmniejszaWysokosc` = `3776`; `panstwo` = `Malezja`, `najmniejszaWysokosc` = `700`. Kolejność wynika z `ORDER BY`.

</details>

## Zadanie 17 - Średnia wysokość

Dla obiektów z cechą `wysokość` wyświetl średnią wartość `wartoscCechy` osobno dla każdego państwa. Zaokrąglij średnią do dwóch miejsc po przecinku.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT panstwo, ROUND(AVG(wartoscCechy), 2) AS sredniaWysokosc
FROM obiekty
WHERE nazwaCechy = 'wysokość'
GROUP BY panstwo
ORDER BY panstwo;
```

Wynik: **9 grup**. Przykładowe wiersze: `panstwo` = `Islandia`, `sredniaWysokosc` = `355.67`; `panstwo` = `Japonia`, `sredniaWysokosc` = `3776.00`; `panstwo` = `Malezja`, `sredniaWysokosc` = `700.00`. Kolejność wynika z `ORDER BY`.

</details>

## Zadanie 18 - Suma wysokości

Dla obiektów z cechą `wysokość` oblicz sumę `wartoscCechy` osobno dla każdego państwa. Nie łącz wartości różnych cech.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT panstwo, SUM(wartoscCechy) AS sumaWysokosci
FROM obiekty
WHERE nazwaCechy = 'wysokość'
GROUP BY panstwo
ORDER BY panstwo;
```

Wynik: **9 grup**. Przykładowe wiersze: `panstwo` = `Islandia`, `sumaWysokosci` = `2134`; `panstwo` = `Japonia`, `sumaWysokosci` = `3776`; `panstwo` = `Malezja`, `sumaWysokosci` = `700`. Kolejność wynika z `ORDER BY`.

</details>

## Zadanie 19 - Państwa ze średnią powyżej 1000

Dla obiektów z cechą `wysokość` pokaż państwa, dla których średnia `wartoscCechy` przekracza 1000. Wyświetl państwo i średnią zaokrągloną do dwóch miejsc po przecinku.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT panstwo, ROUND(AVG(wartoscCechy), 2) AS sredniaWysokosc
FROM obiekty
WHERE nazwaCechy = 'wysokość'
GROUP BY panstwo
HAVING AVG(wartoscCechy) > 1000
ORDER BY panstwo;
```

Wynik: **4 grupy**. Przykładowe wiersze: `panstwo` = `Japonia`, `sredniaWysokosc` = `3776.00`; `panstwo` = `Nepal`, `sredniaWysokosc` = `8849.00`; `panstwo` = `Pakistan`, `sredniaWysokosc` = `8611.00`; `panstwo` = `Tanzania`, `sredniaWysokosc` = `3001.50`. Kolejność wynika z `ORDER BY`.

</details>

## Zadanie 20 - Wybrane rodzaje w dwóch państwach

Uwzględnij obiekty Polski i Islandii o `idRodzaj` równym 10 lub 11. Pogrupuj je jednocześnie według państwa i rodzaju. Pokaż wyłącznie grupy liczące co najmniej dwa obiekty. Wyświetl państwo, `idRodzaj` i liczbę obiektów.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT panstwo, idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
WHERE panstwo IN ('Polska', 'Islandia') AND idRodzaj IN (10, 11)
GROUP BY panstwo, idRodzaj
HAVING COUNT(*) >= 2
ORDER BY panstwo, idRodzaj;
```

Wynik: **2 grupy**. Przykładowe wiersze: `panstwo` = `Islandia`, `idRodzaj` = `10`, `liczbaObiektow` = `4`; `panstwo` = `Polska`, `idRodzaj` = `10`, `liczbaObiektow` = `4`. Kolejność wynika z `ORDER BY`.

</details>
