---
title: Lekcja 7A - DISTINCT. Lista bez powtórzeń
---

# Lekcja 7A - DISTINCT. Lista bez powtórzeń

Jakie liczby punktów zdobyli turyści z bazy `Islandia`? Sprawdźmy najpierw wszystkie zapisane wyniki. Pracuj w phpMyAdmin na danych z pliku `baza1.sql`.

## 1. Zobacz powtarzające się wartości

```sql
SELECT punkty
FROM turysci
ORDER BY punkty;
```

Wynik zawiera **13 wierszy**:

```text
4, 5, 7, 11, 11, 12, 21, 23, 23, 31, 45, 46, 51
```

Liczba 11 pojawia się dwa razy. Tak samo jest z liczbą 23.

To nie są błędne dane. Różni turyści mogli zdobyć tyle samo punktów.

## 2. Pokaż każdą wartość tylko raz

Chcemy zobaczyć listę wyników punktowych bez powtórzeń. Do zapytania dodajemy `DISTINCT`:

```sql
SELECT DISTINCT punkty
FROM turysci
ORDER BY punkty;
```

Otrzymujemy **11 wierszy**:

```text
4, 5, 7, 11, 12, 21, 23, 31, 45, 46, 51
```

`DISTINCT` pozostawia każdą różną wartość tylko raz w wyniku zapytania. Nie usuwa rekordów z tabeli.

W bazie nadal jest **13 turystów**. Dwie osoby nadal mają po 11 punktów, a kolejne dwie po 23.

## 3. Lista czy liczenie?

Zanim napiszesz zapytanie, przeczytaj pytanie. Te dwa pytania wymagają różnych odpowiedzi:

| Pytanie | Czego potrzebujesz? |
| --- | --- |
| Jakie różne liczby punktów występują w bazie? | Listy wartości bez powtórzeń - `DISTINCT`. |
| Ilu turystów zdobyło każdą liczbę punktów? | Liczby osób dla każdej wartości - `GROUP BY` i `COUNT(*)`. |

Na pierwsze pytanie odpowiedziało zapytanie z punktu 2. Dało listę 11 różnych wartości.

Na drugie pytanie odpowie znane zapytanie:

```sql
SELECT punkty, COUNT(*) AS liczbaTurystow
FROM turysci
GROUP BY punkty
ORDER BY punkty;
```

Wynik ma **11 grup**. Przy punktach 11 i 23 kolumna `liczbaTurystow` pokazuje `2`. Przy pozostałych wartościach pokazuje `1`.

`DISTINCT` daje listę różnych wartości. `GROUP BY` z `COUNT(*)` mówi, ile rekordów należy do każdej grupy.

## 4. Rodzaje obiektów z Islandii

Jakie rodzaje obiektów występują w Islandii? W tabeli `obiekty` rodzaj jest zapisany jako `idRodzaj`.

```sql
SELECT DISTINCT idRodzaj
FROM obiekty
WHERE panstwo = 'Islandia'
ORDER BY idRodzaj;
```

| idRodzaj |
| ---: |
| 10 |
| 11 |
| 13 |
| 14 |
| 15 |

W Islandii jest **9 obiektów**, ale tylko **5 różnych identyfikatorów rodzaju**. `DISTINCT` pokazuje każdy identyfikator raz.

## 5. Ćwiczenia

Najpierw wybierz sposób rozwiązania. Potem uruchom swoje zapytanie w phpMyAdmin.

### Ćwiczenie 1 - państwa bez powtórzeń

Wyświetl alfabetyczną listę różnych wartości pola `panstwo` z tabeli `obiekty`. Ile wierszy otrzymasz?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Potrzebujesz listy różnych wartości, a nie liczby obiektów w każdym państwie. Uporządkuj wynik według `panstwo`.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

```sql
SELECT DISTINCT panstwo
FROM obiekty
ORDER BY panstwo;
```

Wynik zawiera **12 różnych wartości**. Jedną z nich jest `Nairobi` - tak zapisano tę wartość w bazie.

</details>

### Ćwiczenie 2 - wybierz właściwe zapytanie

Rozważ dwa pytania dotyczące tabeli `obiekty`:

- A: Jakie rodzaje obiektów występują w bazie?
- B: Ile obiektów należy do każdego rodzaju?

Zapisz osobne zapytanie dla każdego pytania. Przewidź, co pokaże wynik każdego z nich.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Pytanie A wymaga listy identyfikatorów bez powtórzeń. Pytanie B wymaga policzenia obiektów w każdej grupie.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

Pytanie A - lista różnych identyfikatorów:

```sql
SELECT DISTINCT idRodzaj
FROM obiekty
ORDER BY idRodzaj;
```

Wynik zawiera **8 różnych identyfikatorów rodzaju**: `10, 11, 12, 13, 14, 15, 16, 17`.

Pytanie B - liczba obiektów każdego rodzaju:

```sql
SELECT idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY idRodzaj
ORDER BY idRodzaj;
```

Wynik także ma **8 wierszy**, ale podaje dodatkowo liczbę obiektów. Na przykład rodzaj `10` ma ich `12`, a rodzaj `11` ma `4`.

</details>

## 6. Co warto zapamiętać?

`DISTINCT` pozostawia różne wartości w wyniku. Nie usuwa rekordów z tabeli.

Gdy potrzebujesz samej listy, użyj `DISTINCT`. Gdy musisz policzyć rekordy w grupach, użyj `GROUP BY` z `COUNT(*)`.

Więcej przykładów znajdziesz w [pełnym opracowaniu lekcji 7]({{ '/04-grupowanie-danych/03-distinct-i-distinctrow.html' | relative_url }}).
