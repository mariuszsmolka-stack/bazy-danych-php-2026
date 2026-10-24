---
title: ZBIÓR ZADAŃ 3 - Klucze i JOIN. 20 zadań
---

# ZBIÓR ZADAŃ 3 - Klucze i JOIN. 20 zadań

Pracuj na niezmienionej bazie `Islandia`. Rozwiąż każde zadanie samodzielnie, a potem rozwiń odpowiedź.

## Zadanie 1

Wskaż klucze główne pięciu tabel bazy `Islandia`.

<details class="lesson-solution" markdown="1"><summary>Pokaż rozwiązanie</summary>

`kontynenty.idKontynent`, `rodzaje.idRodzaj`, `obiekty.idObiekt`, `turysci.idTurysta` i `osiagniecia.idOsiagniecie`.

Wynik: pięć kluczy głównych, po jednym w każdej tabeli. Każdy identyfikuje jej rekord.

</details>

## Zadanie 2

Wskaż klucze obce tabeli `obiekty` i tabele, do których się odwołują.

<details class="lesson-solution" markdown="1"><summary>Pokaż rozwiązanie</summary>

`obiekty.idRodzaj` wskazuje `rodzaje.idRodzaj`, a `obiekty.idKontynent` wskazuje `kontynenty.idKontynent`.

Wynik: dwa klucze obce. Każdy odwołuje się do klucza głównego innej tabeli.

</details>

## Zadanie 3

Wyjaśnij relację między `rodzaje` i `obiekty`. Wskaż kolumny pozwalające połączyć tabele.

<details class="lesson-solution" markdown="1"><summary>Pokaż rozwiązanie</summary>

To relacja 1:N. Jeden rodzaj może mieć wiele obiektów, a każdy obiekt wskazuje jeden rodzaj. Łączymy `rodzaje.idRodzaj` z `obiekty.idRodzaj`.

Wynik: rodzaj `rzeka` ma zero obiektów, a inne rodzaje mogą mieć ich kilka.

</details>

## Zadanie 4

Wyświetl nazwy obiektów i nazwy ich rodzajów.

<details class="lesson-solution" markdown="1"><summary>Pokaż rozwiązanie</summary>

```sql
SELECT o.nazwa AS obiekt, r.rodzaj
FROM obiekty AS o
INNER JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
ORDER BY o.idObiekt;
```

Wynik: 25 wierszy, na przykład `Skogafoss | wodospad`. `INNER JOIN` zwraca dopasowane obiekty.

</details>

## Zadanie 5

Wyświetl nazwy obiektów i nazwy ich kontynentów.

<details class="lesson-solution" markdown="1"><summary>Pokaż rozwiązanie</summary>

```sql
SELECT o.nazwa AS obiekt, k.nazwa AS kontynent
FROM obiekty AS o
INNER JOIN kontynenty AS k ON o.idKontynent = k.idKontynent
ORDER BY o.idObiekt;
```

Wynik: 25 wierszy, na przykład `Fuji | Azja`. Łączymy odpowiadające sobie identyfikatory kontynentu.

</details>

## Zadanie 6

Wyświetl nazwy obiektów z Islandii oraz nazwy ich rodzajów.

<details class="lesson-solution" markdown="1"><summary>Pokaż rozwiązanie</summary>

```sql
SELECT o.nazwa AS obiekt, r.rodzaj
FROM obiekty AS o
INNER JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
WHERE o.panstwo = 'Islandia'
ORDER BY o.idObiekt;
```

Wynik: 9 wierszy. `WHERE` wybiera obiekty Islandii po dopasowaniu tabel.

</details>

## Zadanie 7

Wyświetl nazwy wodospadów Islandii. Wybierz rodzaj na podstawie nazwy z tabeli `rodzaje`.

<details class="lesson-solution" markdown="1"><summary>Pokaż rozwiązanie</summary>

```sql
SELECT o.nazwa AS wodospad
FROM obiekty AS o
INNER JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
WHERE o.panstwo = 'Islandia' AND r.rodzaj = 'wodospad'
ORDER BY o.idObiekt;
```

Wynik: 4 wiersze - Skogafoss, Seljalandsfoss, Godafoss i Dettifoss. Rodzaj wybieramy po nazwie.

</details>

## Zadanie 8

Dla każdego rodzaju, który ma obiekty, pokaż jego nazwę oraz liczbę obiektów.

<details class="lesson-solution" markdown="1"><summary>Pokaż rozwiązanie</summary>

```sql
SELECT r.rodzaj, COUNT(o.idObiekt) AS liczbaObiektow
FROM rodzaje AS r
INNER JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
GROUP BY r.idRodzaj, r.rodzaj
ORDER BY r.idRodzaj;
```

Wynik: 8 grup. Rzeka nie ma obiektów, więc `INNER JOIN` ją pomija.

</details>

## Zadanie 9

Wyświetl nazwę obiektu, nazwę rodzaju i nazwę kontynentu.

<details class="lesson-solution" markdown="1"><summary>Pokaż rozwiązanie</summary>

```sql
SELECT o.nazwa AS obiekt, r.rodzaj, k.nazwa AS kontynent
FROM obiekty AS o
INNER JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
INNER JOIN kontynenty AS k ON o.idKontynent = k.idKontynent
ORDER BY o.idObiekt;
```

Wynik: 25 wierszy, na przykład `Fuji | wulkan | Azja`. Potrzebne są dwa złączenia.

</details>

## Zadanie 10

Pokaż wszystkie rodzaje oraz nazwy przypisanych im obiektów. Nie pomijaj rodzajów bez obiektów.

<details class="lesson-solution" markdown="1"><summary>Pokaż rozwiązanie</summary>

```sql
SELECT r.rodzaj, o.nazwa AS obiekt
FROM rodzaje AS r
LEFT JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
ORDER BY r.idRodzaj, o.idObiekt;
```

Wynik: 26 wierszy, w tym `rzeka | NULL`. Lewa tabela pozostaje w wyniku.

</details>

## Zadanie 11

Pokaż wszystkie kontynenty oraz nazwy znajdujących się na nich obiektów. Nie pomijaj kontynentów bez obiektów.

<details class="lesson-solution" markdown="1"><summary>Pokaż rozwiązanie</summary>

```sql
SELECT k.nazwa AS kontynent, o.nazwa AS obiekt
FROM kontynenty AS k
LEFT JOIN obiekty AS o ON k.idKontynent = o.idKontynent
ORDER BY k.idKontynent, o.idObiekt;
```

Wynik: 28 wierszy. Dla Ameryki Południowej, Antarktydy i Australii obiekt to `NULL`.

</details>

## Zadanie 12

Znajdź rodzaje, dla których nie istnieje żaden obiekt.

<details class="lesson-solution" markdown="1"><summary>Pokaż rozwiązanie</summary>

```sql
SELECT r.rodzaj
FROM rodzaje AS r
LEFT JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
WHERE o.idObiekt IS NULL
ORDER BY r.idRodzaj;
```

Wynik: jeden wiersz - `rzeka`. Brak dopasowania daje `NULL` w kluczu obiektu.

</details>

## Zadanie 13

Znajdź kontynenty, do których nie przypisano obiektów.

<details class="lesson-solution" markdown="1"><summary>Pokaż rozwiązanie</summary>

```sql
SELECT k.nazwa AS kontynent
FROM kontynenty AS k
LEFT JOIN obiekty AS o ON k.idKontynent = o.idKontynent
WHERE o.idObiekt IS NULL
ORDER BY k.idKontynent;
```

Wynik: trzy wiersze - Ameryka Południowa, Antarktyda i Australia.

</details>

## Zadanie 14

Zastosuj `RIGHT JOIN`, aby uzyskać również rodzaje bez przypisanych obiektów.

<details class="lesson-solution" markdown="1"><summary>Pokaż rozwiązanie</summary>

```sql
SELECT r.rodzaj, o.nazwa AS obiekt
FROM obiekty AS o
RIGHT JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
ORDER BY r.idRodzaj, o.idObiekt;
```

Wynik: 26 wierszy, w tym `rzeka | NULL`. Zachowujemy prawą tabelę `rodzaje`.

</details>

## Zadanie 15

Policz obiekty każdego rodzaju. Uwzględnij także rodzaj bez obiektów. Dla niego liczba ma wynosić zero.

<details class="lesson-solution" markdown="1"><summary>Pokaż rozwiązanie</summary>

```sql
SELECT r.rodzaj, COUNT(o.idObiekt) AS liczbaObiektow
FROM rodzaje AS r
LEFT JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
GROUP BY r.idRodzaj, r.rodzaj
ORDER BY r.idRodzaj;
```

Wynik: 9 grup, dla rzeki `0`. `COUNT(o.idObiekt)` nie liczy `NULL`.

</details>

## Zadanie 16

Dla każdego rodzaju wyświetl nazwę, `COUNT(*)` oraz `COUNT(o.idObiekt)`. Wyjaśnij różnicę dla rzeki.

<details class="lesson-solution" markdown="1"><summary>Pokaż rozwiązanie</summary>

```sql
SELECT r.rodzaj, COUNT(*) AS liczbaWierszy,
       COUNT(o.idObiekt) AS liczbaObiektow
FROM rodzaje AS r
LEFT JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
GROUP BY r.idRodzaj, r.rodzaj
ORDER BY r.idRodzaj;
```

Wynik: 9 grup. Dla rzeki liczba wierszy to `1`, a liczba obiektów to `0`: istnieje wiersz złączenia, lecz `o.idObiekt` ma `NULL`.

</details>

## Zadanie 17

Dla każdego rodzaju policz obiekty znajdujące się w Islandii. Zachowaj także rodzaje, które w Islandii nie występują.

<details class="lesson-solution" markdown="1"><summary>Pokaż rozwiązanie</summary>

```sql
SELECT r.rodzaj, COUNT(o.idObiekt) AS liczbaObiektow
FROM rodzaje AS r
LEFT JOIN obiekty AS o
  ON r.idRodzaj = o.idRodzaj AND o.panstwo = 'Islandia'
GROUP BY r.idRodzaj, r.rodzaj
ORDER BY r.idRodzaj;
```

Wynik: 9 grup. Liczby dla `wodospad`, `szczyt`, `wulkan`, `siedlisko zwierząt` i `gorące źródło` to odpowiednio `4`, `1`, `1`, `2`, `1`; pozostałe mają `0`. Filtr w `ON` zachowuje każdy rodzaj.

</details>

## Zadanie 18

Pokaż, jak warunek dotyczący Islandii w `WHERE` zamiast w `ON` wpływa na wynik poprzedniego złączenia. Porównaj liczby grup.

<details class="lesson-solution" markdown="1"><summary>Pokaż rozwiązanie</summary>

Warunek w `ON`:

```sql
SELECT r.rodzaj, COUNT(o.idObiekt) AS liczbaObiektow
FROM rodzaje AS r
LEFT JOIN obiekty AS o
  ON r.idRodzaj = o.idRodzaj AND o.panstwo = 'Islandia'
GROUP BY r.idRodzaj, r.rodzaj
ORDER BY r.idRodzaj;
```

Warunek w `WHERE`:

```sql
SELECT r.rodzaj, COUNT(o.idObiekt) AS liczbaObiektow
FROM rodzaje AS r
LEFT JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
WHERE o.panstwo = 'Islandia'
GROUP BY r.idRodzaj, r.rodzaj
ORDER BY r.idRodzaj;
```

Wynik: pierwsze zapytanie ma 9 grup, drugie 5. `WHERE` odrzuca wiersze, w których `o.panstwo` jest `NULL`, oraz obiekty spoza Islandii.

</details>

## Zadanie 19

Wyświetl nazwy obiektów Islandii, nazwy ich rodzajów oraz nazwę kontynentu. Połącz trzy odpowiednie tabele.

<details class="lesson-solution" markdown="1"><summary>Pokaż rozwiązanie</summary>

```sql
SELECT o.nazwa AS obiekt, r.rodzaj, k.nazwa AS kontynent
FROM obiekty AS o
INNER JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
INNER JOIN kontynenty AS k ON o.idKontynent = k.idKontynent
WHERE o.panstwo = 'Islandia'
ORDER BY o.idObiekt;
```

Wynik: 9 wierszy, wszystkie z kontynentem `Europa`. Każde złączenie używa właściwego klucza obcego.

</details>

## Zadanie 20

Wyświetl wszystkich turystów oraz nazwy obiektów powiązanych z nimi przez tabelę `osiagniecia`. Zachowaj także turystów bez zapisanych osiągnięć.

<details class="lesson-solution" markdown="1"><summary>Pokaż rozwiązanie</summary>

```sql
SELECT t.nick, o.nazwa AS obiekt
FROM turysci AS t
LEFT JOIN osiagniecia AS a ON t.idTurysta = a.idTurysta
LEFT JOIN obiekty AS o ON a.idObiekt = o.idObiekt
ORDER BY t.idTurysta, a.idOsiagniecie;
```

Wynik: 13 wierszy, po jednym dla każdego turysty. Każda nazwa obiektu to `NULL`, ponieważ tabela `osiagniecia` jest pusta. Oba `LEFT JOIN` zachowują turystów.

</details>
