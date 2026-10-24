---
title: SQL 1C - INNER JOIN
mermaid: true
---

# SQL 1C - INNER JOIN

## Jak znaleźć nazwę rodzaju?

W tabeli `obiekty` mamy `idRodzaj`. Chcemy zobaczyć nazwę rodzaju, a nie jego numer. Nazwa znajduje się w tabeli `rodzaje`.

| obiekty.idObiekt | obiekty.nazwa | obiekty.idRodzaj |
| ---: | --- | ---: |
| 47 | Skogafoss | 10 |
| 46 | Strokkur | 15 |

| rodzaje.idRodzaj | rodzaje.rodzaj |
| ---: | --- |
| 10 | wodospad |
| 15 | gorące źródło |
| 18 | rzeka |

Wspólna wartość `10` łączy Skogafoss z wodospadem. Wartość `15` łączy Strokkur z gorącym źródłem. Rodzaj `rzeka` nie ma w tabeli `obiekty` pasującego rekordu.

<figure class="lesson-diagram">
<pre class="mermaid-source" hidden>
flowchart LR
    A["obiekty: Skogafoss, idRodzaj 10"] --> C["Dopasuj idRodzaj 10"]
    B["rodzaje: 10, wodospad"] --> C
    C --> D["Wynik: Skogafoss, wodospad"]
</pre>
<p class="diagram-fallback">obiekty: Skogafoss, 10 + rodzaje: 10, wodospad =&gt; dopasowanie po idRodzaj =&gt; Skogafoss | wodospad.</p>
<figcaption>INNER JOIN zwraca wiersz, gdy klucze pasują do siebie.</figcaption>
</figure>

## Zapis zapytania

```sql
SELECT o.nazwa, r.rodzaj
FROM obiekty AS o
INNER JOIN rodzaje AS r
ON o.idRodzaj = r.idRodzaj
ORDER BY o.idObiekt;
```

`FROM` wskazuje pierwszą tabelę. `INNER JOIN` dołącza drugą. `ON` określa, które wartości mają być równe. Aliasy `o` i `r` skracają nazwy tabel. Zapis `o.idRodzaj` jednoznacznie wskazuje kolumnę tabeli `obiekty`. Samo `JOIN` bez dodatkowego określenia oznacza tutaj `INNER JOIN`.

Wynik ma **25 wierszy**, po jednym dla każdego dopasowanego obiektu. Wśród nich są `Skogafoss | wodospad` i `Strokkur | gorące źródło`. `rzeka` nie pojawia się, ponieważ nie ma przypisanego obiektu. Kolejność wyznacza `ORDER BY`.

## Ćwiczenia

### Ćwiczenie 1

Znajdź w obu tabelach wartości, które łączą obiekt `Strokkur` z jego rodzajem. Podaj nazwę rodzaju.

<details class="lesson-hint" markdown="1"><summary>Podpowiedź - ćwiczenie 1</summary>

Porównaj kolumny `idRodzaj`.

</details>
<details class="lesson-solution" markdown="1"><summary>Rozwiązanie - ćwiczenie 1</summary>

Obie wartości `idRodzaj` wynoszą `15`. Rodzaj obiektu Strokkur to `gorące źródło`.

</details>

### Ćwiczenie 2

Wyświetl nazwy obiektów i ich rodzajów tylko dla obiektów z Islandii. Ile wierszy otrzymasz?

<details class="lesson-hint" markdown="1"><summary>Podpowiedź - ćwiczenie 2</summary>

Po połączeniu tabel wybierz kraj w `WHERE`.

</details>
<details class="lesson-solution" markdown="1"><summary>Rozwiązanie - ćwiczenie 2</summary>

```sql
SELECT o.nazwa, r.rodzaj
FROM obiekty AS o
INNER JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
WHERE o.panstwo = 'Islandia'
ORDER BY o.idObiekt;
```

Wynik ma **9 wierszy**.

</details>

### Ćwiczenie 3

Wyświetl nazwy obiektów i rodzajów, ale ogranicz wynik do rodzaju `wodospad`. Dlaczego nie otrzymasz rzeki?

<details class="lesson-hint" markdown="1"><summary>Podpowiedź - ćwiczenie 3</summary>

Filtruj po kolumnie `r.rodzaj`.

</details>
<details class="lesson-solution" markdown="1"><summary>Rozwiązanie - ćwiczenie 3</summary>

```sql
SELECT o.nazwa, r.rodzaj
FROM obiekty AS o
INNER JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
WHERE r.rodzaj = 'wodospad'
ORDER BY o.idObiekt;
```

Zapytanie zwraca **12 wodospadów**. Rzeka nie spełnia warunku i nie ma przypisanego obiektu.

</details>

[Dalej: SQL 1D - LEFT JOIN]({{ '/09-klucze-i-zlaczenia/04-left-join.html' | relative_url }}).
