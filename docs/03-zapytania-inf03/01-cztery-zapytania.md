---
title: Cztery zapytania SQL z arkusza INF.03
mermaid: true
---

# Lekcja 3 - Cztery zapytania SQL z arkusza INF.03

**Cel:** odczytać treść polecenia egzaminacyjnego i samodzielnie przygotować zapytanie SQL. Pracujemy na bazie `Islandia` zaimportowanej z `baza1.sql`.

**Źródło zadań:** INF.03-01-26.06-SG, czerwiec 2026, strona 2, część "Operacje na bazie danych". Zachowano zakres i nazwy pól z arkusza. Zapytania i wyniki poniżej dotyczą niezmienionych danych z `baza1.sql`.

W phpMyAdmin wybierz bazę `Islandia`, otwórz zakładkę `SQL` i wykonuj zapytania po kolei. **Nie zmieniaj danych w tabelach.**

## Zapytanie 1 - Obiekty z Islandii

**Treść zadania:** Wybierz jedynie pola `idObiekt`, `plik` i `nazwa` z tabeli `obiekty` dla Islandii.

To proste filtrowanie jednej tabeli. Wystarczy `SELECT`, `FROM` i `WHERE`.

```sql
SELECT idObiekt, plik, nazwa
FROM obiekty
WHERE panstwo = 'Islandia';
```

**Sprawdzenie:** zapytanie zwraca 9 wierszy. Jednym z obiektów jest `Strokkur`.

## Zapytanie 2 - Dane obiektu 46

**Treść zadania:** Wybierz pola `plik`, `nazwa`, `nazwaCechy`, `wartoscCechy`, `opis` z tabeli `obiekty` oraz odpowiadające pole `rodzaj` z tabeli `rodzaje` dla obiektu o identyfikatorze 46. Użyj relacji tabel.

Tutaj łączymy `obiekty` i `rodzaje` za pomocą wspólnego pola `idRodzaj`.

```sql
SELECT o.plik, o.nazwa, o.nazwaCechy, o.wartoscCechy,
       o.opis, r.rodzaj
FROM obiekty AS o
JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
WHERE o.idObiekt = 46;
```

**Sprawdzenie:** jeden wiersz - `Strokkur`, rodzaj `gorące źródło`, cecha `wysokość`, wartość `30`.

## Zapytanie 3 - Wodospady z Islandii

**Treść zadania:** Wybierz jedynie nazwy obiektów z Islandii, których identyfikator rodzaju to `10`.

Zastanów się, z ilu warunków składa się polecenie. Najpierw spróbuj samodzielnie napisać SQL.

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

**Treść zadania:** Wybierz `rodzaj` z tabeli `rodzaje` oraz liczbę obiektów tego rodzaju. Kolumnie z liczbą nadaj alias `Liczba obiektów`. Wykorzystaj relację i grupowanie.

Tu potrzebujemy trzech mechanizmów, dlatego przejdź po nich w tej kolejności:

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
