---
title: SQL 1F - Pułapki złączeń SQL
mermaid: true
---

# SQL 1F - Pułapki złączeń SQL

## 1. Warunek w ON albo w WHERE

Chcemy policzyć obiekty Islandii dla **każdego** rodzaju, także dla rodzajów z wynikiem zero. Warunek dotyczący prawej tabeli umieszczamy w `ON`:

```sql
SELECT r.rodzaj, COUNT(o.idObiekt) AS liczbaObiektow
FROM rodzaje AS r
LEFT JOIN obiekty AS o
  ON r.idRodzaj = o.idRodzaj AND o.panstwo = 'Islandia'
GROUP BY r.idRodzaj, r.rodzaj
ORDER BY r.idRodzaj;
```

Wynik ma **9 grup**. Rodzaje bez obiektów Islandii pozostają z liczbą `0`. Teraz przenieśmy filtr do `WHERE`:

```sql
SELECT r.rodzaj, COUNT(o.idObiekt) AS liczbaObiektow
FROM rodzaje AS r
LEFT JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
WHERE o.panstwo = 'Islandia'
GROUP BY r.idRodzaj, r.rodzaj
ORDER BY r.idRodzaj;
```

Gdy brak pasującego obiektu, `o.panstwo` jest `NULL`. Warunek `WHERE o.panstwo = 'Islandia'` nie jest wtedy spełniony. Odpadają też wiersze obiektów z innych państw. Zostają tylko rodzaje mające obiekty Islandii.

<figure class="lesson-diagram">
<pre class="mermaid-source" hidden>
flowchart TD
    A["rodzaje LEFT JOIN obiekty"] --> B["ON: 9 grup"]
    A --> C["WHERE: 5 grup"]
</pre>
<p class="diagram-fallback">Dwa osobne zapytania: LEFT JOIN + filtr w ON =&gt; 9 grup, także z zerem; LEFT JOIN + filtr w WHERE =&gt; 5 grup.</p>
<figcaption>Dwa osobne zapytania. Miejsce warunku zmienia liczbę grup w wyniku.</figcaption>
</figure>

## 2. Co liczy COUNT?

```sql
SELECT r.rodzaj, COUNT(*) AS liczbaWierszy,
       COUNT(o.idObiekt) AS liczbaObiektow
FROM rodzaje AS r
LEFT JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
GROUP BY r.idRodzaj, r.rodzaj
ORDER BY r.idRodzaj;
```

Dla rzeki `COUNT(*)` daje **1**, bo złączenie utworzyło wiersz `rzeka | NULL`. `COUNT(o.idObiekt)` daje **0**, bo ta kolumna ma `NULL`. Pierwsza funkcja liczy wiersze wyniku, a druga tylko niepuste wartości wskazanej kolumny.

## 3. Znajdź brak dopasowania

```sql
SELECT r.rodzaj
FROM rodzaje AS r
LEFT JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
WHERE o.idObiekt IS NULL
ORDER BY r.idRodzaj;
```

Otrzymasz jeden wiersz: `rzeka`. Klucz główny `o.idObiekt` nie może być `NULL` w istniejącym obiekcie, więc `NULL` w wyniku wskazuje brak dopasowania.

## 4. Sprawdź kolumny w ON

Poprawne połączenie to `r.idRodzaj = o.idRodzaj`. Porównanie `r.idRodzaj = o.idObiekt` zestawiałoby identyfikator rodzaju z identyfikatorem **obiektu**. Te liczby opisują różne rzeczy. Zapytanie mogłoby pominąć prawidłowe powiązania lub przypadkowo połączyć niewłaściwe wiersze. Przed uruchomieniem zapytania sprawdź klucz obcy i klucz, na który wskazuje.

## Ćwiczenia

### Ćwiczenie 1

Policz obiekty Islandii dla każdego rodzaju, także gdy wynik wynosi zero. W której części złączenia umieścisz filtr państwa?

<details class="lesson-hint" markdown="1"><summary>Podpowiedź - ćwiczenie 1</summary>

Filtr nie może odrzucić wierszy bez obiektu.

</details>
<details class="lesson-solution" markdown="1"><summary>Rozwiązanie - ćwiczenie 1</summary>

```sql
SELECT r.rodzaj, COUNT(o.idObiekt) AS liczbaObiektow
FROM rodzaje AS r
LEFT JOIN obiekty AS o
  ON r.idRodzaj = o.idRodzaj AND o.panstwo = 'Islandia'
GROUP BY r.idRodzaj, r.rodzaj
ORDER BY r.idRodzaj;
```

Filtr jest w `ON`. Wynik ma 9 grup, w tym rodzaje z zerem.

</details>

### Ćwiczenie 2

Wyjaśnij dwie różne wartości funkcji `COUNT` dla rzeki w zapytaniu z punktu 2.

<details class="lesson-hint" markdown="1"><summary>Podpowiedź - ćwiczenie 2</summary>

Wiersz z rzeką istnieje, ale identyfikator obiektu ma `NULL`.

</details>
<details class="lesson-solution" markdown="1"><summary>Rozwiązanie - ćwiczenie 2</summary>

`COUNT(*) = 1` liczy wiersz rzeki. `COUNT(o.idObiekt) = 0` pomija wartość `NULL`.

</details>

### Ćwiczenie 3

Znajdź kontynenty bez obiektów za pomocą złączenia zewnętrznego i sprawdzenia `NULL`.

<details class="lesson-hint" markdown="1"><summary>Podpowiedź - ćwiczenie 3</summary>

Zachowaj wszystkie kontynenty. Wybierz te bez identyfikatora obiektu.

</details>
<details class="lesson-solution" markdown="1"><summary>Rozwiązanie - ćwiczenie 3</summary>

```sql
SELECT k.nazwa
FROM kontynenty AS k
LEFT JOIN obiekty AS o ON k.idKontynent = o.idKontynent
WHERE o.idObiekt IS NULL
ORDER BY k.idKontynent;
```

Wynik: Ameryka Południowa, Antarktyda i Australia.

</details>

[Dalej: SQL 1G - Łączenie trzech tabel]({{ '/09-klucze-i-zlaczenia/07-trzy-tabele.html' | relative_url }}).
