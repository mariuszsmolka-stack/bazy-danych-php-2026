---
title: Cztery zapytania SQL z arkusza INF.03
mermaid: true
---

# Lekcja 3 - Cztery zapytania SQL z arkusza INF.03

Na egzaminie trzeba przełożyć polecenie na zapytanie SQL. W tej lekcji przećwiczysz cztery takie zapytania na bazie `Islandia` z pliku `baza1.sql`.

Zadania pochodzą z arkusza INF.03-01-26.06-SG, czerwiec 2026, strona 2, część „Operacje na bazie danych”. Ćwiczenia wykorzystują zakres i nazwy pól wskazane w arkuszu. Podane wyniki dotyczą niezmienionych danych z `baza1.sql`.

Otwórz w phpMyAdmin bazę `Islandia`, a potem zakładkę `SQL`. Wykonuj zapytania po kolei. **Nie zmieniaj danych w tabelach.**

## Zapytanie 1 - Obiekty z Islandii

**Zadanie:** W tabeli `obiekty` znajdź rekordy z Islandii. Wyświetl tylko pola `idObiekt`, `plik` i `nazwa`.

To proste filtrowanie jednej tabeli. Wystarczy `SELECT`, `FROM` i `WHERE`.

```sql
SELECT idObiekt, plik, nazwa
FROM obiekty
WHERE panstwo = 'Islandia';
```

**Sprawdź wynik:** zapytanie zwraca 9 wierszy. Jednym z obiektów jest `Strokkur`.

## Zapytanie 2 - Dane obiektu 46

**Zadanie:** Znajdź obiekt o identyfikatorze 46. Z tabeli `obiekty` wybierz pola `plik`, `nazwa`, `nazwaCechy`, `wartoscCechy` i `opis`. Z tabeli `rodzaje` dołącz odpowiadające mu pole `rodzaj`.

Nazwa rodzaju jest w innej tabeli niż dane obiektu. `JOIN` łączy wiersze z obu tabel przez pole `idRodzaj`.

```sql
SELECT o.plik, o.nazwa, o.nazwaCechy, o.wartoscCechy,
       o.opis, r.rodzaj
FROM obiekty AS o
JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
WHERE o.idObiekt = 46;
```

**Sprawdź wynik:** jeden wiersz - `Strokkur`, rodzaj `gorące źródło`, cecha `wysokość`, wartość `30`.

## Zapytanie 3 - Wodospady z Islandii

**Zadanie:** Wybierz obiekty z Islandii, których identyfikator rodzaju to `10`. Wyświetl tylko ich nazwy.

Potrzebujesz dwóch warunków: państwa i rodzaju. Spróbuj samodzielnie napisać SQL.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - jakie warunki są potrzebne?</summary>

- Wybieramy tylko kolumnę `nazwa` z tabeli `obiekty`.
- Warunek pierwszy dotyczy pola `panstwo`.
- Warunek drugi dotyczy pola `idRodzaj`.
- Oba warunki muszą być spełnione jednocześnie. Połącz je przez `AND`.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - zapytanie 3</summary>

```sql
SELECT nazwa
FROM obiekty
WHERE panstwo = 'Islandia' AND idRodzaj = 10;
```

**Sprawdzenie:** 4 nazwy: `Skogafoss`, `Seljalandsfoss`, `Godafoss`, `Dettifoss` (kolejność bez `ORDER BY` nie jest gwarantowana).

</details>

## Zapytanie 4 - Liczba obiektów każdego rodzaju

**Zadanie:** Pokaż nazwy rodzajów z tabeli `rodzaje`. Obok każdej nazwy pokaż liczbę obiektów tego rodzaju. Kolumnę z liczbą nazwij `Liczba obiektów`.

Nazwa rodzaju jest w tabeli `rodzaje`. Obiekty są w tabeli `obiekty`. Najpierw połącz tabele przez `JOIN`.

Potem `GROUP BY` utworzy grupę dla każdego rodzaju. `COUNT(o.idObiekt)` policzy obiekty w każdej grupie. Diagram pokazuje te kroki:

<figure class="lesson-diagram">
<pre class="mermaid-source" hidden>
flowchart TD
    A["Tabela obiekty"] --> C["Połączenie po idRodzaj"]
    B["Tabela rodzaje"] --> C
    C --> D["Grupowanie według rodzaju"]
    D --> E["Zliczenie obiektów w grupie"]
</pre>
<p class="diagram-fallback">JOIN =&gt; GROUP BY =&gt; COUNT</p>
<figcaption>Połączenie tabel, grupowanie i zliczanie obiektów.</figcaption>
</figure>

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź 1 - połączenie tabel</summary>

- Nazwa rodzaju jest w tabeli `rodzaje`.
- Każdy obiekt ma `idRodzaj` w tabeli `obiekty`.
- Tabele połącz za pomocą `JOIN ... ON` i kolumn `idRodzaj`.

</details>

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź 2 - grupowanie i liczba</summary>

- `GROUP BY` tworzy grupy obiektów o danym rodzaju.
- `COUNT(o.idObiekt)` zlicza wiersze w każdej grupie.
- `AS` nadaje kolumnie liczącej alias `Liczba obiektów`. Ponieważ alias ma spację, w MySQL/MariaDB użyj znaków `` ` `` wokół jego nazwy.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - zapytanie 4</summary>

```sql
SELECT r.rodzaj, COUNT(o.idObiekt) AS `Liczba obiektów`
FROM rodzaje AS r
JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
GROUP BY r.idRodzaj, r.rodzaj;
```

**Sprawdzenie:** wyniki dla niezmienionej bazy:

| Rodzaj | Liczba obiektów |
| --- | ---: |
| wodospad | 12 |
| szczyt | 4 |
| jezioro | 1 |
| wulkan | 2 |
| siedlisko zwierząt | 2 |
| gorące źródło | 1 |
| park narodowy | 1 |
| jaskinia | 2 |

Suma wynosi 25 obiektów. Kolejność grup bez `ORDER BY` nie jest gwarantowana. Rodzaj `rzeka` nie wystąpi w tym wyniku, ponieważ w bazie nie ma obiektów tego rodzaju, a zastosowaliśmy zwykłe `JOIN`.

</details>

## Utrwalenie

- Dlaczego w zapytaniu 3 stosujemy `AND`, a nie `OR`?
- Co łączy tabele `obiekty` i `rodzaje`?
- Dlaczego `GROUP BY` jest potrzebne w zapytaniu 4?
- Czym różni się `COUNT()` w SQL od `count()` w PHP?

## Następna lekcja

Wykonamy te same zapytania z poziomu PHP i sprawdzimy ich wyniki: [Lekcja 4 - Wyniki SQL w PHP]({{ '/03-zapytania-inf03/02-wyniki-zapytan-w-php.html' | relative_url }}).

[Ściąga funkcji PHP z arkusza INF.03]({{ '/00-organizacja/02-sciaga-php-inf03.html' | relative_url }})
