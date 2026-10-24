---
title: Lekcja 5C - GROUP BY z dwiema kolumnami i JOIN
---

# Lekcja 5C - GROUP BY z dwiema kolumnami i JOIN

W [lekcji 5A]({{ '/04-grupowanie-danych/01a-group-by-podstawy.html' | relative_url }}) tworzyliśmy grupy i liczyliśmy rekordy. Teraz utworzymy grupy według dwóch kolumn.

Potem połączymy dwie tabele, aby zamiast numerów rodzajów zobaczyć ich nazwy. Pracuj w phpMyAdmin na bazie `Islandia` z pliku `baza1.sql`.

## 1. Państwo i rodzaj obiektu

Ile obiektów każdego rodzaju znajduje się w Polsce i Islandii?

Samo `GROUP BY panstwo` dałoby tylko jedną grupę dla każdego państwa. Potrzebujemy osobnej grupy dla każdego rodzaju w każdym państwie.

```sql
SELECT panstwo, idRodzaj,
       COUNT(*) AS liczbaObiektow
FROM obiekty
WHERE panstwo IN ('Islandia', 'Polska')
GROUP BY panstwo, idRodzaj
ORDER BY panstwo, idRodzaj;
```

| panstwo | idRodzaj | liczbaObiektow |
| --- | ---: | ---: |
| Islandia | 10 | 4 |
| Islandia | 11 | 1 |
| Islandia | 13 | 1 |
| Islandia | 14 | 2 |
| Islandia | 15 | 1 |
| Polska | 10 | 4 |

Wynik ma **6 grup**. Liczby w ostatniej kolumnie dają razem **13 obiektów**.

Grupę określają teraz dwie wartości: państwo i numer rodzaju. Dwa obiekty należą do tej samej grupy, gdy obie wartości są takie same.

## 2. Co oznacza numer rodzaju?

Widzimy numery `10`, `11`, `13`, `14` i `15`. Co oznacza na przykład numer `10`?

W tabeli `obiekty` jest kolumna `idRodzaj`. Nazwa rodzaju znajduje się w tabeli `rodzaje`.

Połączmy te tabele i obejrzyjmy nazwy kilku obiektów:

```sql
SELECT r.rodzaj, o.nazwa
FROM rodzaje AS r
JOIN obiekty AS o
ON r.idRodzaj = o.idRodzaj
ORDER BY r.idRodzaj, o.idObiekt;
```

Wybrane wiersze wyniku:

| rodzaj | nazwa |
| --- | --- |
| wodospad | Kadamaian |
| wodospad | Kamieńczyk |
| szczyt | Mount Everest |

Numer `idRodzaj = 10` oznacza `wodospad`.

`r` to krótka nazwa tabeli `rodzaje`. `o` to krótka nazwa tabeli `obiekty`.

`JOIN` łączy rekordy o tym samym `idRodzaj`. Dlatego obok nazwy obiektu możemy pokazać nazwę jego rodzaju.

Cały wynik ma **25 wierszy** - po jednym dla każdego dopasowanego obiektu. Nazwy rodzajów się powtarzają.

## 3. Policz obiekty według nazwy rodzaju

Ile obiektów mamy każdego rodzaju? Połączmy tabele jak wcześniej, a potem utwórzmy grupy.

```sql
SELECT r.rodzaj,
       COUNT(o.idObiekt) AS liczbaObiektow
FROM rodzaje AS r
JOIN obiekty AS o
ON r.idRodzaj = o.idRodzaj
GROUP BY r.idRodzaj, r.rodzaj
ORDER BY r.idRodzaj;
```

| rodzaj | liczbaObiektow |
| --- | ---: |
| wodospad | 12 |
| szczyt | 4 |
| jezioro | 1 |
| wulkan | 2 |
| siedlisko zwierząt | 2 |
| gorące źródło | 1 |
| park narodowy | 1 |
| jaskinia | 2 |

Wynik ma **8 grup**, a liczby obiektów dają razem **25**.

`JOIN` pozwala pobrać nazwę rodzaju. `GROUP BY` tworzy grupę dla każdego rodzaju. `COUNT(o.idObiekt)` liczy identyfikatory obiektów w tej grupie.

Grupujemy po `r.idRodzaj` i `r.rodzaj`. Dzięki temu każda grupa ma wskazany numer i odpowiadającą mu nazwę.

W tabeli `rodzaje` jest też `rzeka`. W tabeli `obiekty` nie ma jednak obiektu tego rodzaju. Zwykły `JOIN` nie pokazuje więc rzeki w wyniku.

## 4. Ćwiczenia

Najpierw przewidź wynik. Potem zmień zapytanie i uruchom je w phpMyAdmin.

### Ćwiczenie 1 - tylko Polska

Wróć do zapytania z punktu 1. Zmień `WHERE`, aby wybrać tylko Polskę. Nie zmieniaj `GROUP BY`.

Ile grup otrzymasz? Sprawdź liczbę obiektów w wyniku.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Zastąp warunek z `IN` warunkiem `panstwo = 'Polska'`.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

```sql
SELECT panstwo, idRodzaj,
       COUNT(*) AS liczbaObiektow
FROM obiekty
WHERE panstwo = 'Polska'
GROUP BY panstwo, idRodzaj
ORDER BY panstwo, idRodzaj;
```

Powstaje **jedna grupa**: Polska, `idRodzaj = 10`, **4 obiekty**.

</details>

### Ćwiczenie 2 - nazwy rodzajów w Islandii

Wróć do zapytania z punktu 3. Dodaj warunek `WHERE o.panstwo = 'Islandia'` we właściwym miejscu. Zachowaj nazwy rodzajów w wyniku.

Ile grup otrzymasz? Ile obiektów jest w nich razem?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Umieść `WHERE` po `ON`, a przed `GROUP BY`.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

```sql
SELECT r.rodzaj,
       COUNT(o.idObiekt) AS liczbaObiektow
FROM rodzaje AS r
JOIN obiekty AS o
ON r.idRodzaj = o.idRodzaj
WHERE o.panstwo = 'Islandia'
GROUP BY r.idRodzaj, r.rodzaj
ORDER BY r.idRodzaj;
```

| rodzaj | liczbaObiektow |
| --- | ---: |
| wodospad | 4 |
| szczyt | 1 |
| wulkan | 1 |
| siedlisko zwierząt | 2 |
| gorące źródło | 1 |

To **5 grup** obejmujących razem **9 obiektów**.

</details>

Dwie kolumny w `GROUP BY` pozwalają określić grupę przez dwie wartości. `JOIN` daje nam nazwę rodzaju, a grupowanie i liczenie pokazują, ile obiektów do niego należy.

Więcej przykładów znajdziesz w [pełnym opracowaniu GROUP BY]({{ '/04-grupowanie-danych/01-group-by.html' | relative_url }}).
