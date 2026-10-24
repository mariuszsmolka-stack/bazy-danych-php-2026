---
title: SQL 1G - Łączenie trzech tabel
mermaid: true
---

# SQL 1G - Łączenie trzech tabel

## Trzy nazwy w jednym wierszu

Chcemy wyświetlić nazwę obiektu, jego rodzaj i kontynent. Nazwy są w trzech tabelach: `obiekty.nazwa`, `rodzaje.rodzaj` i `kontynenty.nazwa`.

Zaczynamy od jednej tabeli:

```sql
SELECT o.nazwa
FROM obiekty AS o
ORDER BY o.idObiekt;
```

Teraz dołączamy rodzaj przez `idRodzaj`:

```sql
SELECT o.nazwa, r.rodzaj
FROM obiekty AS o
INNER JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
ORDER BY o.idObiekt;
```

Na końcu dołączamy kontynent przez **inną** parę kolumn: `idKontynent`.

```sql
SELECT o.nazwa AS obiekt, r.rodzaj, k.nazwa AS kontynent
FROM obiekty AS o
INNER JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
INNER JOIN kontynenty AS k ON o.idKontynent = k.idKontynent
ORDER BY o.idObiekt;
```

Każde `INNER JOIN` ma własny, właściwy warunek `ON`. Nie porównujemy identyfikatorów tylko dlatego, że są liczbami.

| obiekt | rodzaj | kontynent |
| --- | --- | --- |
| Fuji | wulkan | Azja |
| Skogafoss | wodospad | Europa |

Pełny wynik ma **25 wierszy**. Pokazane dwa wiersze są przykładami z tej bazy. Kolejność pełnego wyniku określa `ORDER BY o.idObiekt`.

<figure class="lesson-diagram">
<pre class="mermaid-source" hidden>
flowchart TD
    A["obiekty: nazwa i klucze obce"] --> B["Dołącz rodzaje po idRodzaj"]
    B --> C["Dołącz kontynenty po idKontynent"]
    C --> D["Wynik: obiekt, rodzaj, kontynent"]
</pre>
<p class="diagram-fallback">obiekty.idRodzaj =&gt; rodzaje.idRodzaj; obiekty.idKontynent =&gt; kontynenty.idKontynent; wynik: obiekt | rodzaj | kontynent.</p>
<figcaption>Dwa połączenia prowadzą od obiektu do nazw rodzaju i kontynentu.</figcaption>
</figure>

## Turyści i pusta tabela pośrednia

Tabela `osiagniecia` łączy turystów z obiektami. Teraz nie ma w niej żadnego wiersza. Dwa `INNER JOIN` nie znajdą więc dopasowania:

```sql
SELECT t.nick, o.nazwa AS obiekt
FROM turysci AS t
INNER JOIN osiagniecia AS a ON t.idTurysta = a.idTurysta
INNER JOIN obiekty AS o ON a.idObiekt = o.idObiekt
ORDER BY t.idTurysta, a.idOsiagniecie;
```

Wynik jest pusty. Jeśli chcemy zachować wszystkich turystów, używamy dwóch `LEFT JOIN`:

```sql
SELECT t.nick, o.nazwa AS obiekt
FROM turysci AS t
LEFT JOIN osiagniecia AS a ON t.idTurysta = a.idTurysta
LEFT JOIN obiekty AS o ON a.idObiekt = o.idObiekt
ORDER BY t.idTurysta, a.idOsiagniecie;
```

Wynik ma **13 wierszy**. Każdy turysta występuje raz, a kolumna `obiekt` ma `NULL`, bo nie zapisano osiągnięć. Gdyby jeden turysta miał wiele powiązań, mógłby pojawić się w wielu wierszach.

## Ćwiczenia

### Ćwiczenie 1

Wskaż tabele i dwie pary kolumn potrzebne do pokazania nazwy obiektu, rodzaju i kontynentu.

<details class="lesson-hint" markdown="1"><summary>Podpowiedź - ćwiczenie 1</summary>

Zacznij od tabeli `obiekty`. Sprawdź jej dwa klucze obce.

</details>
<details class="lesson-solution" markdown="1"><summary>Rozwiązanie - ćwiczenie 1</summary>

Potrzebne są `obiekty`, `rodzaje` i `kontynenty`. Łączymy `o.idRodzaj = r.idRodzaj` oraz `o.idKontynent = k.idKontynent`.

</details>

### Ćwiczenie 2

Wyświetl nazwy obiektów Islandii wraz z nazwą rodzaju i kontynentu. Ile wierszy otrzymasz?

<details class="lesson-hint" markdown="1"><summary>Podpowiedź - ćwiczenie 2</summary>

Połącz trzy tabele, a potem wybierz państwo w `WHERE`.

</details>
<details class="lesson-solution" markdown="1"><summary>Rozwiązanie - ćwiczenie 2</summary>

```sql
SELECT o.nazwa AS obiekt, r.rodzaj, k.nazwa AS kontynent
FROM obiekty AS o
INNER JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
INNER JOIN kontynenty AS k ON o.idKontynent = k.idKontynent
WHERE o.panstwo = 'Islandia'
ORDER BY o.idObiekt;
```

Wynik ma 9 wierszy. Każdy z tych obiektów leży w Europie.

</details>

### Ćwiczenie 3

Dlaczego złączenie turystów przez tabelę `osiagniecia` daje teraz zero wierszy przy `INNER JOIN`, a 13 przy dwóch `LEFT JOIN`?

<details class="lesson-hint" markdown="1"><summary>Podpowiedź - ćwiczenie 3</summary>

Sprawdź liczbę wierszy tabeli pośredniej.

</details>
<details class="lesson-solution" markdown="1"><summary>Rozwiązanie - ćwiczenie 3</summary>

`osiagniecia` jest pusta. `INNER JOIN` wymaga dopasowania i zwraca zero wierszy. Dwa `LEFT JOIN` zachowują 13 turystów, ale dla każdego nazwa obiektu to `NULL`.

</details>

[Dalej: ZBIÓR ZADAŃ 3 - Klucze i JOIN]({{ '/09-klucze-i-zlaczenia/08-zadania-klucze-i-join.html' | relative_url }}).
