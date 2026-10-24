---
title: ZBIÓR ZADAŃ 3 - Klucze i JOIN. 20 zadań
---

# ZBIÓR ZADAŃ 3 - Klucze i JOIN. 20 zadań

Pracuj na niezmienionej bazie `Islandia`. Rozwiązuj zadania samodzielnie w phpMyAdmin. Potem rozwiń odpowiedź i sprawdź wynik.

## Zadanie 1 - Klucze główne

Wskaż klucze główne tabel `turysci`, `obiekty` i `rodzaje`. Wyjaśnij, dlaczego ich wartości nie mogą się powtarzać.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

`turysci.idTurysta`, `obiekty.idObiekt` i `rodzaje.idRodzaj` są kluczami głównymi. Każda wartość klucza wskazuje jeden rekord. Powtórzenie uniemożliwiłoby jednoznaczną identyfikację.

</details>

## Zadanie 2 - Klucze obce obiektów

Tabela `obiekty` zawiera dwa klucze obce. Wskaż je i wyjaśnij, do których tabel prowadzą.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

`obiekty.idRodzaj` wskazuje `rodzaje.idRodzaj`, a `obiekty.idKontynent` wskazuje `kontynenty.idKontynent`. Oba łączą obiekt z rekordem w innej tabeli.

</details>

## Zadanie 3 - Dwa obiekty Wiktorii

W tabeli `obiekty` są dwa rekordy o nazwie Wiktorii. Sprawdź ich identyfikatory. Wyjaśnij, dlaczego sama nazwa nie jest dobrym identyfikatorem rekordu.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT idObiekt, nazwa
FROM obiekty
WHERE nazwa = 'Wiktorii'
ORDER BY idObiekt;
```

Wynik: **2 wiersze**. Pierwsze wartości: `35` / `Wiktorii`; `38` / `Wiktorii`.

Nazwa może się powtarzać. Identyfikator jednoznacznie odróżnia te rekordy.

</details>

## Zadanie 4 - Obiekty Polski i ich rodzaje

Wyświetl nazwy obiektów z Polski oraz nazwy ich rodzajów. Posortuj obiekty alfabetycznie.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT o.nazwa AS obiekt, r.rodzaj
FROM obiekty AS o
INNER JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
WHERE o.panstwo = 'Polska'
ORDER BY o.nazwa, o.idObiekt;
```

Wynik: **4 wiersze**. Pierwsze wartości: `Kamieńczyk` / `wodospad`; `Mała Siklawa` / `wodospad`; `Wielka Siklawa` / `wodospad`.

Łączymy identyfikator rodzaju obiektu z kluczem tabeli `rodzaje`.

</details>

## Zadanie 5 - Obiekty USA i ich rodzaje

Wyświetl nazwy obiektów znajdujących się w USA oraz nazwy ich rodzajów.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT o.nazwa AS obiekt, r.rodzaj
FROM obiekty AS o
INNER JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
WHERE o.panstwo = 'USA'
ORDER BY o.idObiekt;
```

Wynik: **1 wiersz**. Pierwsze wartości: `Yosemite` / `wodospad`.

Warunek państwa dotyczy obiektów, a nazwa rodzaju pochodzi z połączonej tabeli.

</details>

## Zadanie 6 - Siedliska zwierząt

Znajdź wszystkie obiekty, których rodzaj ma nazwę „siedlisko zwierząt”. Wyświetl nazwę obiektu i państwo.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT o.nazwa AS obiekt, o.panstwo
FROM obiekty AS o
INNER JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
WHERE r.rodzaj = 'siedlisko zwierząt'
ORDER BY o.nazwa, o.idObiekt;
```

Wynik: **2 wiersze**. Pierwsze wartości: `Fuglaskoðunarhús` / `Islandia`; `Siedlisko wielorybów` / `Islandia`.

Rodzaj wybieramy po nazwie, bez wpisywania jego numeru na stałe.

</details>

## Zadanie 7 - Wulkany i państwa

Wyświetl wszystkie wulkany wraz z państwami, w których się znajdują. Rodzaj ustal na podstawie nazwy w tabeli `rodzaje`.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT o.nazwa AS obiekt, o.panstwo
FROM obiekty AS o
INNER JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
WHERE r.rodzaj = 'wulkan'
ORDER BY o.nazwa, o.idObiekt;
```

Wynik: **2 wiersze**. Pierwsze wartości: `Fuji` / `Japonia`; `Hekla` / `Islandia`.

Nazwa rodzaju pochodzi z tabeli `rodzaje`.

</details>

## Zadanie 8 - Obiekty Europy

Wyświetl nazwy obiektów znajdujących się w Europie. Obok każdego pokaż nazwę kontynentu. Wybierz Europę po jej nazwie, bez wpisywania numeru kontynentu.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT o.nazwa AS obiekt, k.nazwa AS kontynent
FROM obiekty AS o
INNER JOIN kontynenty AS k ON o.idKontynent = k.idKontynent
WHERE k.nazwa = 'Europa'
ORDER BY o.nazwa, o.idObiekt;
```

Wynik: **13 wierszy**. Pierwsze wartości: `Dettifoss` / `Europa`; `Fuglaskoðunarhús` / `Europa`; `Godafoss` / `Europa`.

Obiekt wskazuje kontynent przez `idKontynent`.

</details>

## Zadanie 9 - Rodzaje obiektów Azji

Dla każdego rodzaju występującego w Azji pokaż jego nazwę i liczbę obiektów. Nie pokazuj rodzajów bez obiektów w Azji.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT r.rodzaj, COUNT(o.idObiekt) AS liczbaObiektow
FROM obiekty AS o
INNER JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
INNER JOIN kontynenty AS k ON o.idKontynent = k.idKontynent
WHERE k.nazwa = 'Azja'
GROUP BY r.idRodzaj, r.rodzaj
ORDER BY r.rodzaj;
```

Wynik: **4 wiersze**. Pierwsze wartości: `jaskinia` / `2`; `szczyt` / `2`; `wodospad` / `1`.

Trzy tabele pozwalają wybrać kontynent po nazwie i policzyć obiekty według rodzaju.

</details>

## Zadanie 10 - Obiekty wszystkich kontynentów

Dla każdego kontynentu policz przypisane obiekty. Pokaż również kontynenty bez obiektów, z wynikiem zero.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT k.nazwa AS kontynent, COUNT(o.idObiekt) AS liczbaObiektow
FROM kontynenty AS k
LEFT JOIN obiekty AS o ON k.idKontynent = o.idKontynent
GROUP BY k.idKontynent, k.nazwa
ORDER BY k.idKontynent;
```

Wynik: **7 wierszy**. Pierwsze wartości: `Azja` / `6`; `Afryka` / `5`; `Ameryka Północna` / `1`. Ameryka Południowa, Antarktyda i Australia mają po **0** obiektów.

Liczymy identyfikatory obiektów, więc wiersz bez dopasowania daje zero.

</details>

## Zadanie 11 - Rodzaje poza Islandią

Dla każdego rodzaju policz obiekty znajdujące się poza Islandią. Podaj też najmniejszy identyfikator takiego obiektu. Zachowaj rodzaje, dla których liczba wynosi zero.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT r.rodzaj, COUNT(o.idObiekt) AS liczbaObiektow,
       MIN(o.idObiekt) AS pierwszyIdObiekt
FROM rodzaje AS r
LEFT JOIN obiekty AS o
    ON r.idRodzaj = o.idRodzaj AND o.panstwo <> 'Islandia'
GROUP BY r.idRodzaj, r.rodzaj
ORDER BY r.idRodzaj;
```

Wynik: **9 wierszy**. Pierwsze wartości: `wodospad` / `8` / `29`; `szczyt` / `3` / `30`; `jezioro` / `1` / `35`.

Warunek państwa w `ON` zachowuje wszystkie rodzaje. Bez dopasowania liczba wynosi zero, a minimum ma wartość `NULL`.

</details>

## Zadanie 12 - Bez obiektów z Polski

Znajdź rodzaje, dla których nie zapisano żadnego obiektu z Polski. Rodzaj może mieć obiekty w innych państwach.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT r.rodzaj
FROM rodzaje AS r
LEFT JOIN obiekty AS o
    ON r.idRodzaj = o.idRodzaj AND o.panstwo = 'Polska'
WHERE o.idObiekt IS NULL
ORDER BY r.idRodzaj;
```

Wynik: **8 wierszy**. Pierwsze wartości: `szczyt`; `jezioro`; `wulkan`.

Po ograniczeniu dopasowania do Polski `NULL` oznacza brak polskiego obiektu, nawet gdy istnieją obiekty z innych państw.

</details>

## Zadanie 13 - Kontynenty bez obiektów od prawej

Znajdź kontynenty bez przypisanych obiektów. Rozpocznij zapytanie od tabeli `obiekty`; nie zamieniaj miejscami tabel w `FROM`. Sam dobierz złączenie.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT k.nazwa AS kontynent
FROM obiekty AS o
RIGHT JOIN kontynenty AS k ON o.idKontynent = k.idKontynent
WHERE o.idObiekt IS NULL
ORDER BY k.idKontynent;
```

Wynik: **3 wiersze**. Pierwsze wartości: `Ameryka Południowa`; `Antarktyda`; `Australia`.

Złączenie zachowuje wszystkie kontynenty po prawej, a warunek wybiera brak obiektu.

</details>

## Zadanie 14 - Dwa równoważne złączenia

Wyświetl wszystkie rodzaje i przypisane im obiekty, także gdy obiekt nie istnieje. Zapisz dwa równoważne zapytania: jedno z `LEFT JOIN`, drugie z `RIGHT JOIN`. Porównaj wyniki.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

**LEFT JOIN:**

```sql
SELECT r.idRodzaj, r.rodzaj, o.nazwa AS obiekt
FROM rodzaje AS r
LEFT JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
ORDER BY r.idRodzaj, o.idObiekt;
```

Wynik: **26 wierszy**. Pierwsze wartości: `10` / `wodospad` / `Kadamaian`; `10` / `wodospad` / `Wiktorii`; `10` / `wodospad` / `Ouzoud`.

**RIGHT JOIN:**

```sql
SELECT r.idRodzaj, r.rodzaj, o.nazwa AS obiekt
FROM obiekty AS o
RIGHT JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
ORDER BY r.idRodzaj, o.idObiekt;
```

Wynik: **26 wierszy**. Pierwsze wartości: `10` / `wodospad` / `Kadamaian`; `10` / `wodospad` / `Wiktorii`; `10` / `wodospad` / `Ouzoud`.

Oba warianty zachowują tabelę `rodzaje`. Dla rzeki nazwa obiektu ma wartość `NULL`.

</details>

## Zadanie 15 - Wysokość dla każdego rodzaju

Dla każdego rodzaju policz obiekty, których `nazwaCechy` ma wartość `wysokość`. Uwzględnij wszystkie rodzaje, również z wynikiem zero.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT r.rodzaj, COUNT(o.idObiekt) AS liczbaObiektow
FROM rodzaje AS r
LEFT JOIN obiekty AS o
    ON r.idRodzaj = o.idRodzaj AND o.nazwaCechy = 'wysokość'
GROUP BY r.idRodzaj, r.rodzaj
ORDER BY r.idRodzaj;
```

Wynik: **9 wierszy**. Pierwsze wartości: `wodospad` / `11`; `szczyt` / `4`; `jezioro` / `0`. Rodzaj `rzeka` również ma wynik **0**.

Warunek cechy należy do dopasowania, aby nie usunąć rodzajów z zerem.

</details>

## Zadanie 16 - Osiągnięcia turystów

Dla każdego turysty wyświetl nick i liczbę zapisanych osiągnięć. Uwzględnij osoby bez osiągnięć.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT t.nick, COUNT(a.idOsiagniecie) AS liczbaOsiagniec
FROM turysci AS t
LEFT JOIN osiagniecia AS a ON t.idTurysta = a.idTurysta
GROUP BY t.idTurysta, t.nick
ORDER BY t.idTurysta;
```

Wynik: **13 wierszy**. Pierwsze wartości: `Ewa` / `0`; `Monika` / `0`; `Janek` / `0`.

Tabela `osiagniecia` jest pusta, więc każdy turysta pozostaje w wyniku z zerem.

</details>

## Zadanie 17 - Dopasowane i wszystkie obiekty

Porównaj dwa zapytania łączące obiekty i rodzaje. Pierwsze ma zachować tylko dopasowane rekordy, drugie wszystkie obiekty. Napisz oba i wyjaśnij, dlaczego w tej bazie zwracają tyle samo wierszy.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

**Tylko dopasowane:**

```sql
SELECT o.idObiekt, o.nazwa, r.rodzaj
FROM obiekty AS o
INNER JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
ORDER BY o.idObiekt;
```

Wynik: **25 wierszy**. Pierwsze wartości: `28` / `Fuji` / `wulkan`; `29` / `Kadamaian` / `wodospad`; `30` / `Mount Everest` / `szczyt`.

**Wszystkie obiekty:**

```sql
SELECT o.idObiekt, o.nazwa, r.rodzaj
FROM obiekty AS o
LEFT JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
ORDER BY o.idObiekt;
```

Wynik: **25 wierszy**. Pierwsze wartości: `28` / `Fuji` / `wulkan`; `29` / `Kadamaian` / `wodospad`; `30` / `Mount Everest` / `szczyt`.

Każdy obiekt ma pasujący rodzaj, więc oba złączenia pokazują te same obiekty.

</details>

## Zadanie 18 - Polskie obiekty a miejsce warunku

Dla każdego rodzaju policz obiekty z Polski, także gdy wynik wynosi zero. Pokaż też liczbę wierszy złączenia. Następnie przenieś ograniczenie państwa do `WHERE` po złączeniu. Porównaj liczbę grup i oba rodzaje liczników.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

**Warunek w ON:**

```sql
SELECT r.rodzaj, COUNT(*) AS liczbaWierszy,
       COUNT(o.idObiekt) AS liczbaObiektow
FROM rodzaje AS r
LEFT JOIN obiekty AS o
    ON r.idRodzaj = o.idRodzaj AND o.panstwo = 'Polska'
GROUP BY r.idRodzaj, r.rodzaj
ORDER BY r.idRodzaj;
```

Wynik: **9 wierszy**. Pierwsze wartości: `wodospad` / `4` / `4`; `szczyt` / `1` / `0`; `jezioro` / `1` / `0`.

**Warunek w WHERE:**

```sql
SELECT r.rodzaj, COUNT(*) AS liczbaWierszy,
       COUNT(o.idObiekt) AS liczbaObiektow
FROM rodzaje AS r
LEFT JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
WHERE o.panstwo = 'Polska'
GROUP BY r.idRodzaj, r.rodzaj
ORDER BY r.idRodzaj;
```

Wynik: **1 wiersz**. Pierwsze wartości: `wodospad` / `4` / `4`.

Filtr w `WHERE` usuwa rodzaje bez polskiego obiektu; filtr w `ON` je zachowuje. Przy wyniku zero `COUNT(*)` liczy wiersz z `NULL`, a `COUNT(o.idObiekt)` go pomija.

</details>

## Zadanie 19 - Obiekty Afryki w trzech tabelach

Wyświetl nazwę obiektu, jego rodzaju i kontynentu. Uwzględnij wyłącznie obiekty w Afryce. Posortuj alfabetycznie według nazwy obiektu.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT o.nazwa AS obiekt, r.rodzaj, k.nazwa AS kontynent
FROM obiekty AS o
INNER JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
INNER JOIN kontynenty AS k ON o.idKontynent = k.idKontynent
WHERE k.nazwa = 'Afryka'
ORDER BY o.nazwa, o.idObiekt;
```

Wynik: **5 wierszy**. Pierwsze wartości: `Kilimanjaro` / `szczyt` / `Afryka`; `Nakuru` / `park narodowy` / `Afryka`; `Ouzoud` / `wodospad` / `Afryka`.

Trzy tabele dostarczają nazwy obiektu, rodzaju i kontynentu.

</details>

## Zadanie 20 - Obiekty i wodospady na kontynentach

Dla każdego kontynentu pokaż jego nazwę, liczbę wszystkich obiektów i liczbę wodospadów. Rodzaj wodospad wybierz po nazwie, bez wpisywania numeru. Zachowaj kontynenty bez obiektów; dla nich obie liczby mają wynosić zero.

<details class="lesson-solution" markdown="1">
<summary>Pokaż rozwiązanie</summary>

```sql
SELECT k.nazwa AS kontynent, COUNT(o.idObiekt) AS liczbaObiektow,
       COUNT(r.idRodzaj) AS liczbaWodospadow
FROM kontynenty AS k
LEFT JOIN obiekty AS o ON k.idKontynent = o.idKontynent
LEFT JOIN rodzaje AS r
    ON o.idRodzaj = r.idRodzaj AND r.rodzaj = 'wodospad'
GROUP BY k.idKontynent, k.nazwa
ORDER BY k.idKontynent;
```

Wynik: **7 wierszy**. Pierwsze wartości: `Azja` / `6` / `1`; `Afryka` / `5` / `2`; `Ameryka Północna` / `1` / `1`. Ameryka Południowa, Antarktyda i Australia mają w obu kolumnach liczbowych **0**.

Drugie złączenie dopasowuje tylko wodospady. `COUNT` pomija brak dopasowania.

</details>
