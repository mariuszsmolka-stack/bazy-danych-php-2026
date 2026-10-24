---
title: SQL 1E - RIGHT JOIN
mermaid: true
---

# SQL 1E - RIGHT JOIN

## Zmień strony złączenia

W poprzedniej lekcji `LEFT JOIN` zachował wszystkie rodzaje ustawione po lewej stronie. `RIGHT JOIN` zachowuje wszystkie rekordy tabeli po **prawej** stronie.

```sql
SELECT r.rodzaj, o.nazwa
FROM obiekty AS o
RIGHT JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
ORDER BY r.idRodzaj, o.idObiekt;
```

Po prawej są `rodzaje`. Wynik ma **26 wierszy**, w tym `rzeka | NULL`. Pozostałe 25 wierszy odpowiada obiektom. Jeden rodzaj nadal może pasować do wielu obiektów.

Ten sam dobór wierszy daje odwrócony zapis:

```sql
SELECT r.rodzaj, o.nazwa
FROM rodzaje AS r
LEFT JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
ORDER BY r.idRodzaj, o.idObiekt;
```

Ogólnie `A LEFT JOIN B` odpowiada `B RIGHT JOIN A`, jeśli odpowiednio przepiszemy `ON` i wybierane kolumny. Bez `ORDER BY` baza nie gwarantuje jednak takiej samej kolejności wierszy. W praktyce `RIGHT JOIN` często można zapisać jako `LEFT JOIN` po zamianie miejsc tabel, lecz trzeba umieć czytać oba zapisy.

## Porównanie tych samych tabel

W poniższym schemacie lewą tabelą są `obiekty`, a prawą `rodzaje`.

<figure class="lesson-diagram">
<pre class="mermaid-source" hidden>
flowchart TD
    A["obiekty po lewej, rodzaje po prawej"] --> B["INNER JOIN: tylko dopasowane, 25"]
    A --> C["LEFT JOIN: wszystkie obiekty, 25"]
    A --> D["RIGHT JOIN: wszystkie rodzaje, 26"]
    D --> E["rzeka, obiekt NULL"]
</pre>
<p class="diagram-fallback">obiekty LEFT + rodzaje RIGHT: INNER JOIN =&gt; 25; LEFT JOIN =&gt; 25; RIGHT JOIN =&gt; 26, w tym rzeka | NULL.</p>
<figcaption>Rodzaj rzeka zostaje zachowany tylko wtedy, gdy złączenie obejmuje wszystkie rodzaje.</figcaption>
</figure>

`LEFT JOIN` w tym konkretnym ustawieniu ma 25 wierszy, bo każdy obiekt ma pasujący rodzaj. Nie jest to ogólna reguła o liczbie wierszy złączenia.

## Ćwiczenia

### Ćwiczenie 1

Wskaż tabelę zachowaną przez `RIGHT JOIN` w pierwszym zapytaniu. Co będzie w kolumnie nazwy obiektu dla rzeki?

<details class="lesson-hint" markdown="1"><summary>Podpowiedź - ćwiczenie 1</summary>

Sprawdź, która tabela stoi po prawej stronie słów `RIGHT JOIN`.

</details>
<details class="lesson-solution" markdown="1"><summary>Rozwiązanie - ćwiczenie 1</summary>

Zachowane są `rodzaje`. Dla rzeki `o.nazwa` ma wartość `NULL`.

</details>

### Ćwiczenie 2

Wyświetl wszystkie kontynenty i ich obiekty, używając `RIGHT JOIN`. Zachowaj kontynenty bez obiektów.

<details class="lesson-hint" markdown="1"><summary>Podpowiedź - ćwiczenie 2</summary>

Kontynenty umieść po prawej stronie złączenia.

</details>
<details class="lesson-solution" markdown="1"><summary>Rozwiązanie - ćwiczenie 2</summary>

```sql
SELECT k.nazwa AS kontynent, o.nazwa AS obiekt
FROM obiekty AS o
RIGHT JOIN kontynenty AS k ON o.idKontynent = k.idKontynent
ORDER BY k.idKontynent, o.idObiekt;
```

Wynik ma 28 wierszy. Trzy kontynenty bez obiektów mają `NULL` w kolumnie `obiekt`.

</details>

### Ćwiczenie 3

Przepisz pierwszy `RIGHT JOIN` tej lekcji jako `LEFT JOIN`. Czy liczba wierszy się zmieni?

<details class="lesson-hint" markdown="1"><summary>Podpowiedź - ćwiczenie 3</summary>

Zamień miejscami tabele. Nadal zachowaj wszystkie rodzaje.

</details>
<details class="lesson-solution" markdown="1"><summary>Rozwiązanie - ćwiczenie 3</summary>

```sql
SELECT r.rodzaj, o.nazwa
FROM rodzaje AS r
LEFT JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
ORDER BY r.idRodzaj, o.idObiekt;
```

Nie. Oba zapytania zwracają 26 wierszy, łącznie z rzeką bez obiektu.

</details>

[Dalej: SQL 1F - Pułapki złączeń SQL]({{ '/09-klucze-i-zlaczenia/06-pulapki-zlaczen.html' | relative_url }}).
