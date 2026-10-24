---
title: SQL 1D - LEFT JOIN
mermaid: true
---

# SQL 1D - LEFT JOIN

## Zachowaj wszystkie rodzaje

Chcemy zobaczyć wszystkie rodzaje, także te bez obiektów. `INNER JOIN` pominął rzekę. Ustawiamy więc `rodzaje` po lewej stronie i używamy `LEFT JOIN`.

```sql
SELECT r.rodzaj, o.nazwa
FROM rodzaje AS r
LEFT JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
ORDER BY r.idRodzaj, o.idObiekt;
```

`LEFT JOIN` zachowuje każdy rekord lewej tabeli. Gdy po prawej nie ma dopasowania, kolumny tej tabeli mają w wyniku `NULL`.

| rodzaj | nazwa obiektu |
| --- | --- |
| wodospad | Skogafoss (jeden z wielu) |
| rzeka | `NULL` |

Cały wynik ma **26 wierszy**: 25 obiektów oraz jeden wiersz dla rzeki. Tabela `rodzaje` ma tylko 9 rekordów, ale jeden rodzaj może pasować do wielu obiektów. `LEFT JOIN` nie ogranicza wyniku do dziewięciu wierszy.

<figure class="lesson-diagram">
<pre class="mermaid-source" hidden>
flowchart TD
    A["Lewo: rodzaje, 9 rekordów"] --> B["LEFT JOIN obiekty po idRodzaj"]
    B --> C["25 wierszy z obiektem"]
    C --> D["rzeka: obiekt NULL"]
    D --> E["Razem: 26 wierszy"]
</pre>
<p class="diagram-fallback">rodzaje (lewo) + obiekty (prawo) =&gt; 25 dopasowanych wierszy + rzeka | NULL =&gt; 26 wierszy.</p>
<figcaption>Jeden rodzaj może dać wiele wierszy, a rzeka zostaje zachowana bez obiektu.</figcaption>
</figure>

## Kontynenty bez obiektów

```sql
SELECT k.nazwa AS kontynent, o.nazwa AS obiekt
FROM kontynenty AS k
LEFT JOIN obiekty AS o ON k.idKontynent = o.idKontynent
ORDER BY k.idKontynent, o.idObiekt;
```

Wynik ma **28 wierszy**: 25 obiektów i po jednym wierszu z `NULL` dla trzech kontynentów bez obiektów. Są to Ameryka Południowa, Antarktyda i Australia. Pozostałe kontynenty mogą wystąpić wielokrotnie.

## Ćwiczenia

### Ćwiczenie 1

Wyjaśnij, skąd bierze się wiersz `rzeka | NULL` i dlaczego wynik ma więcej wierszy niż tabela `rodzaje`.

<details class="lesson-hint" markdown="1"><summary>Podpowiedź - ćwiczenie 1</summary>

Zastanów się nad brakiem dopasowania oraz wieloma obiektami jednego rodzaju.

</details>
<details class="lesson-solution" markdown="1"><summary>Rozwiązanie - ćwiczenie 1</summary>

Rzeka zostaje zachowana z lewej tabeli mimo braku obiektu. Inne rodzaje mogą mieć wiele obiektów, więc tworzą wiele wierszy. Razem powstaje 26 wierszy.

</details>

### Ćwiczenie 2

Pokaż identyfikator rodzaju i nazwę obiektu dla wszystkich rodzajów. Posortuj wynik według identyfikatorów.

<details class="lesson-hint" markdown="1"><summary>Podpowiedź - ćwiczenie 2</summary>

Zachowaj `rodzaje` po lewej stronie.

</details>
<details class="lesson-solution" markdown="1"><summary>Rozwiązanie - ćwiczenie 2</summary>

```sql
SELECT r.idRodzaj, o.nazwa
FROM rodzaje AS r
LEFT JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
ORDER BY r.idRodzaj, o.idObiekt;
```

Wynik ma 26 wierszy. Dla identyfikatora 18 nazwa obiektu to `NULL`.

</details>

### Ćwiczenie 3

Wyświetl wszystkie kontynenty i identyfikatory przypisanych im obiektów. Które kontynenty mają `NULL`?

<details class="lesson-hint" markdown="1"><summary>Podpowiedź - ćwiczenie 3</summary>

Tabela `kontynenty` musi pozostać po lewej stronie.

</details>
<details class="lesson-solution" markdown="1"><summary>Rozwiązanie - ćwiczenie 3</summary>

```sql
SELECT k.nazwa, o.idObiekt
FROM kontynenty AS k
LEFT JOIN obiekty AS o ON k.idKontynent = o.idKontynent
ORDER BY k.idKontynent, o.idObiekt;
```

Wynik ma 28 wierszy. `NULL` mają Ameryka Południowa, Antarktyda i Australia.

</details>

[Dalej: SQL 1E - RIGHT JOIN]({{ '/09-klucze-i-zlaczenia/05-right-join.html' | relative_url }}).
