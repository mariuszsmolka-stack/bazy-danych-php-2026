---
title: DISTINCT i DISTINCTROW - usuwanie powtórzeń w SQL
---

# Lekcja 7 - DISTINCT i DISTINCTROW - usuwanie powtórzeń w SQL

Jeśli dopiero poznajesz `DISTINCT`, zacznij od [krótkiej lekcji 7A]({{ '/04-grupowanie-danych/03a-distinct-podstawy.html' | relative_url }}).

Tutaj znajdziesz też trudniejsze przykłady i dodatkowe ćwiczenia.

**Cel:** wybrać właściwy sposób odpowiedzi na pytanie: potrzebuję listy różnych wartości, ich liczby czy podsumowania każdej grupy?

Pracujemy w phpMyAdmin na bazie `Islandia` z niezmienionego pliku `baza1.sql`. Wykonuj zapytania pojedynczo. Przykłady jedynie odczytują dane. W bazie jest 13 turystów i 25 obiektów.

## 1. Skąd biorą się powtórzenia?

Chcemy obejrzeć wyniki punktowe turystów:

```sql
SELECT punkty FROM turysci ORDER BY punkty;
```

Wynik ma 13 wierszy:

```text
4, 5, 7, 11, 11, 12, 21, 23, 23, 31, 45, 46, 51
```

Każdy wiersz pochodzi od jednej osoby. Jowita i Adam mają po 11 punktów, a Ewa i Paula po 23. Powtórzenie punktów nie oznacza, że zapisano tego samego turystę dwa razy.

**Jak sprawdzić, jakie różne wyniki punktowe występują w tabeli, bez ich wielokrotnego wyświetlania?**

## 2. DISTINCT - lista różnych wartości

```sql
SELECT DISTINCT punkty FROM turysci ORDER BY punkty;
```

| punkty |
| ---: |
| 4 |
| 5 |
| 7 |
| 11 |
| 12 |
| 21 |
| 23 |
| 31 |
| 45 |
| 46 |
| 51 |

Przeczytaj zapytanie krok po kroku:

1. `FROM turysci` wskazuje źródło danych.
2. Wybieramy kolumnę `punkty`.
3. `DISTINCT` pozostawia tylko jeden egzemplarz każdego powtarzającego się wiersza wyniku.
4. `ORDER BY punkty` porządkuje otrzymane wartości rosnąco.

Dlaczego zostało 11 wierszy? Wśród 13 osób występuje 11 różnych liczb punktów. Dwie wartości powtarzały się po dwa razy.

`DISTINCT` **nie usuwa rekordów z tabeli**. W tabeli nadal jest 13 osób. Samo `DISTINCT` nie gwarantuje kolejności i nie oblicza liczności grup. Sortowanie wynika z `ORDER BY`, a nie z usuwania powtórzeń.

## 3. DISTINCT a GROUP BY - trzy różne pytania

### Jakie wyniki punktowe występują?

Potrzebujemy listy, więc wystarczy zapytanie z `DISTINCT` z poprzedniej sekcji. Wynik zawiera 11 wartości, bez informacji o liczbie osób.

### Ilu turystów ma każdą liczbę punktów?

```sql
SELECT punkty, COUNT(*) AS liczbaTurystow
FROM turysci
GROUP BY punkty
ORDER BY punkty;
```

Wynik ma 11 grup. Dla `11` i `23` liczność wynosi `2`, a dla pozostałych wartości `1`. Suma liczności wynosi 13. Tutaj potrzebujemy obliczenia dla każdej grupy, a nie tylko listy bez powtórzeń.

### Które wartości punktów występują więcej niż raz?

```sql
SELECT punkty, COUNT(*) AS liczbaTurystow
FROM turysci
GROUP BY punkty
HAVING COUNT(*) > 1
ORDER BY punkty;
```

| punkty | liczbaTurystow |
| ---: | ---: |
| 11 | 2 |
| 23 | 2 |

Najpierw liczymy osoby w grupach, potem `HAVING` wybiera grupy o liczności większej od jednego. Samo `DISTINCT` nie odpowie na pytanie o liczbę wystąpień.

Możemy również napisać:

```sql
SELECT punkty FROM turysci GROUP BY punkty ORDER BY punkty;
```

W tym prostym przypadku otrzymamy te same 11 wartości co przy `DISTINCT`. Jeśli chodzi wyłącznie o listę różnych wartości, `DISTINCT` wyraża ten zamiar wprost. `GROUP BY` przydaje się do podsumowań grup, takich jak liczba, suma lub średnia. Nie jest uniwersalnym sposobem usuwania powtórzeń.

Nie ma zasady, że `DISTINCT` zawsze działa szybciej. Wydajność zależy m.in. od zapytania, danych, indeksów i planu wykonania.

## 4. Kilka kolumn - liczy się cały wybrany wiersz

**Problem:** jakie nazwy obiektów występują w Tanzanii? Najpierw obejrzyj dane:

```sql
SELECT idObiekt, nazwa, idRodzaj
FROM obiekty
WHERE panstwo = 'Tanzania'
ORDER BY idObiekt;
```

| idObiekt | nazwa | idRodzaj |
| ---: | --- | ---: |
| 34 | Kilimanjaro | 11 |
| 35 | Wiktorii | 12 |
| 38 | Wiktorii | 10 |

Nazwa `Wiktorii` dotyczy dwóch różnych obiektów: jeziora (`12`) i wodospadu (`10`).

### Wybieramy samą nazwę

```sql
SELECT DISTINCT nazwa
FROM obiekty
WHERE panstwo = 'Tanzania'
ORDER BY nazwa;
```

| nazwa |
| --- |
| Kilimanjaro |
| Wiktorii |

W wybranej kolumnie oba napisy `Wiktorii` są takie same, więc wynik ma dwa wiersze.

### Wybieramy nazwę i rodzaj

```sql
SELECT DISTINCT nazwa, idRodzaj
FROM obiekty
WHERE panstwo = 'Tanzania'
ORDER BY nazwa, idRodzaj;
```

| nazwa | idRodzaj |
| --- | ---: |
| Kilimanjaro | 11 |
| Wiktorii | 10 |
| Wiktorii | 12 |

Wynik ma trzy wiersze. Para `Wiktorii + 10` różni się od pary `Wiktorii + 12`. `DISTINCT` porównuje **całą kombinację wybranych kolumn**, a nie tylko pierwszą kolumnę. Nie tworzy też dwóch niezależnych list różnych wartości.

Przed dodaniem kolejnej kolumny zapytaj: co ma oznaczać jeden wiersz wyniku? Sama nazwa czy nazwa razem z rodzajem?

## 5. DISTINCTROW w MariaDB

**Problem:** w napotkanym zapytaniu zamiast `DISTINCT` zapisano `DISTINCTROW`. Czy zmienia to wynik?

**W MariaDB `DISTINCTROW` jest synonimem `DISTINCT`.** Te zapytania są równoważne:

```sql
SELECT DISTINCT nazwa, idRodzaj
FROM obiekty
WHERE panstwo = 'Tanzania'
ORDER BY nazwa, idRodzaj;
```

```sql
SELECT DISTINCTROW nazwa, idRodzaj
FROM obiekty
WHERE panstwo = 'Tanzania'
ORDER BY nazwa, idRodzaj;
```

Oba zwracają tę samą tabelę trzech par z poprzedniej sekcji: `Kilimanjaro + 11`, `Wiktorii + 10`, `Wiktorii + 12`.

`DISTINCTROW` nie sprawdza automatycznie wszystkich kolumn tabeli. Tak samo jak `DISTINCT` dotyczy wybranych kolumn. W tym kursie zwykle zapisujemy `DISTINCT`; drugi zapis warto rozpoznawać podczas czytania kodu MariaDB.

## 6. Dlaczego SELECT DISTINCT * nadal zwraca 13 osób?

**Problem:** spróbuj przewidzieć wynik, zanim uruchomisz:

```sql
SELECT DISTINCT * FROM turysci;
```

Otrzymasz 13 rekordów. Spójrz na kolumnę `idTurysta`: jest kluczem głównym, więc każdy turysta ma inny identyfikator. `*` wybiera również tę kolumnę. Nawet jeśli dwie osoby mają tyle samo punktów, ich całe wiersze nie są jednakowe.

Nie jest to awaria `DISTINCT`. Wybrano więcej informacji niż w zapytaniu o same punkty. Aby uzyskać listę różnych punktów, wybierz tylko `punkty`. Kolejność pełnych rekordów bez `ORDER BY` nie jest określona.

## 7. WHERE, DISTINCT i ORDER BY - rodzaje na Islandii

**Problem:** jakie rodzaje obiektów występują na Islandii, niezależnie od liczby obiektów każdego rodzaju?

```sql
SELECT DISTINCT idRodzaj
FROM obiekty
WHERE panstwo = 'Islandia'
ORDER BY idRodzaj;
```

| idRodzaj |
| ---: |
| 10 |
| 11 |
| 13 |
| 14 |
| 15 |

`WHERE` wybiera 9 islandzkich obiektów. Z ich identyfikatorów rodzaju `DISTINCT` tworzy listę 5 różnych wartości. `ORDER BY` sortuje tę listę. Nie policzyliśmy tu, ile obiektów ma każdy rodzaj.

### Nazwy rodzajów dzięki JOIN

Chcemy czytelnych nazw zamiast numerów:

```sql
SELECT DISTINCT r.rodzaj
FROM obiekty AS o
JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
WHERE o.panstwo = 'Islandia'
ORDER BY r.rodzaj;
```

| rodzaj |
| --- |
| gorące źródło |
| siedlisko zwierząt |
| szczyt |
| wodospad |
| wulkan |

`JOIN` dołącza nazwę do każdego obiektu. Przed usunięciem powtórzeń słowo `wodospad` występuje cztery razy, a `siedlisko zwierząt` dwa razy. `DISTINCT` pozostawia każdą z wybranych nazw raz.

Tutaj nazwy pięciu rodzajów są różne. Gdyby różne identyfikatory miały taką samą nazwę, wybór samej nazwy połączyłby je w jednym wierszu wyniku. Gdy ważna jest tożsamość rodzaju, wybieraj identyfikator wraz z nazwą.

## 8. Krótkie rozszerzenie - COUNT(DISTINCT ...)

**Problem:** potrzebujemy jednej liczby informującej, ile różnych wyników punktowych występuje, zamiast całej listy.

```sql
SELECT COUNT(DISTINCT punkty) AS liczbaRoznychWynikow
FROM turysci;
```

Wynik: jeden wiersz z liczbą `11`.

- `SELECT DISTINCT punkty` daje listę 11 wartości.
- `COUNT(DISTINCT punkty)` daje jedną liczbę: 11.
- `GROUP BY punkty` z `COUNT(*)` daje liczność każdej z 11 grup.

`COUNT(DISTINCT kolumna)` pomija `NULL`. Natomiast `SELECT DISTINCT kolumna` może pokazać jeden wiersz `NULL`, jeśli takie wartości występują. `NULL` oznacza brak wartości, nie zero ani pusty tekst. W polu `punkty` w danych kursowych nie ma `NULL`.

Porównania tekstów zależą od reguł porównywania używanych przez kolumnę w bazie, m.in. od rozróżniania wielkich i małych liter. Nie zakładaj, że różnica w zapisie zawsze oznacza dwie różne wartości dla SQL.

## 9. Typowe błędy

| Błędne założenie | Jak rozumować poprawnie? |
| --- | --- |
| Każdą listę bez powtórzeń trzeba tworzyć przez GROUP BY | Jeśli potrzebujesz tylko różnych wybranych wierszy, użyj DISTINCT. Grupowanie wybierz, gdy podsumowujesz grupy. |
| DISTINCT dotyczy pierwszej kolumny | Porównuje cały zestaw wybranych wartości. |
| DISTINCT * usunie osoby z takimi samymi punktami | Różne identyfikatory sprawiają, że całe wiersze są różne. |
| DISTINCT zastępuje COUNT(*) dla grup | Usunięcie powtórzeń nie oblicza liczności każdej grupy. |
| DISTINCT zawsze sortuje | Wymaganą kolejność zapisz przez ORDER BY. |

### Słowo DISTINCT w złym miejscu

Ten przykład jest **celowo niepoprawny**:

```sql
SELECT punkty DISTINCT FROM turysci;
```

W prostym zapytaniu zapisujemy `DISTINCT` po `SELECT`, przed listą kolumn, jak w sekcji 2. Nie dopisujemy go osobno przy każdej kolumnie. Zapis `COUNT(DISTINCT punkty)` to inny kontekst: argument funkcji liczącej różne wartości.

## 10. Ćwiczenia

Najpierw spróbuj samodzielnie. Podpowiedzi i rozwiązania są oddzielnie zwinięte. Wszystkie zadania dotyczą niezmienionej bazy `Islandia`.


### Ćwiczenie 1 - Różne punkty

Napisz zapytanie z DISTINCT pokazujące różne liczby punktów malejąco.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Wybierz tylko punkty. Kierunek sortowania zmienisz przez DESC.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie 1</summary>

```sql
SELECT DISTINCT punkty
FROM turysci
ORDER BY punkty DESC;
```

11 wierszy: `51, 46, 45, 31, 23, 21, 12, 11, 7, 5, 4`.

</details>


### Ćwiczenie 2 - Drugi zapis

Zapisz rozwiązanie zadania 1 przy użyciu DISTINCTROW. Czy wynik się zmieni?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

W MariaDB oba słowa mają takie samo znaczenie.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie 2</summary>

```sql
SELECT DISTINCTROW punkty
FROM turysci
ORDER BY punkty DESC;
```

Te same 11 wierszy, w tej samej kolejności.

</details>


### Ćwiczenie 3 - Lista państw

Przygotuj alfabetyczną listę państw występujących w tabeli obiekty. Każdą wartość pokaż raz. Sam wybierz konstrukcję.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 3</summary>

Potrzebujesz listy, nie liczby obiektów dla każdego państwa.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie 3</summary>

```sql
SELECT DISTINCT panstwo
FROM obiekty
ORDER BY panstwo;
```

12 wartości: Chiny, Islandia, Japonia, Laos, Malezja, Maroko, Nairobi, Nepal, Pakistan, Polska, Tanzania, USA. `Nairobi` to rzeczywista wartość w źródłowej kolumnie; nie poprawiamy danych.

</details>


### Ćwiczenie 4 - Obiekty w państwach

Dla każdego państwa podaj liczbę obiektów. Uporządkuj wynik według państwa. Sam wybierz konstrukcję.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 4</summary>

Jeden wiersz ma opisywać państwo oraz wynik obliczenia dla jego obiektów.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie 4</summary>

```sql
SELECT panstwo, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY panstwo
ORDER BY panstwo;
```

12 grup. Islandia ma 9 obiektów, Polska 4, Tanzania 3, a każde z pozostałych państw po 1. Suma wynosi 25.

</details>


### Ćwiczenie 5 - Dwie kolumny z Tanzanii

Wyświetl różne pary nazwa i idRodzaj dla obiektów z Tanzanii. Sortuj według nazwy, potem identyfikatora rodzaju. Wyjaśnij, dlaczego Wiktorii pojawia się dwa razy.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 5</summary>

Najpierw ogranicz państwo. Porównuj całe pary wybranych wartości.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie 5</summary>

```sql
SELECT DISTINCT nazwa, idRodzaj
FROM obiekty
WHERE panstwo = 'Tanzania'
ORDER BY nazwa, idRodzaj;
```

3 pary: `Kilimanjaro + 11`, `Wiktorii + 10`, `Wiktorii + 12`. Różne rodzaje oznaczają różne wybrane wiersze.

</details>


### Ćwiczenie 6 - Rodzaje z Islandii

Wyświetl alfabetycznie różne nazwy rodzajów obiektów występujących na Islandii. Nie pokazuj liczby obiektów.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 6</summary>

Nazwa rodzaju znajduje się w tabeli rodzaje. Połączenie tabel może powtarzać tę samą nazwę dla wielu obiektów.

</details>

<details class="lesson-hint" markdown="1">
<summary>Druga podpowiedź - ćwiczenie 6</summary>

Dopasuj tabele po idRodzaj, wybierz państwo i pozostaw różne nazwy.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie 6</summary>

```sql
SELECT DISTINCT r.rodzaj
FROM obiekty AS o
JOIN rodzaje AS r ON o.idRodzaj = r.idRodzaj
WHERE o.panstwo = 'Islandia'
ORDER BY r.rodzaj;
```

5 nazw: gorące źródło, siedlisko zwierząt, szczyt, wodospad, wulkan.

</details>


### Ćwiczenie 7 - Ile różnych rodzajów?

Zwróć jedną liczbę: ile różnych identyfikatorów rodzaju występuje wśród islandzkich obiektów?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 7</summary>

Ogranicz rekordy według państwa. Potem policz różne wartości kolumny, zamiast wypisywać ich listę.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie 7</summary>

```sql
SELECT COUNT(DISTINCT idRodzaj) AS liczbaRodzajow
FROM obiekty
WHERE panstwo = 'Islandia';
```

Jeden wiersz z liczbą `5`. Nie jest to liczba obiektów: tych jest 9.

</details>


### Ćwiczenie 8 - Wybierz sposób podsumowania

Pokaż państwa mające więcej niż jeden obiekt i liczbę ich obiektów. Wynik uporządkuj malejąco według liczby obiektów, a przy remisie według państwa. Sam wybierz konstrukcję.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 8</summary>

Warunek dotyczy obliczonej liczby obiektów, a nie właściwości pojedynczego rekordu.

</details>

<details class="lesson-hint" markdown="1">
<summary>Druga podpowiedź - ćwiczenie 8</summary>

Utwórz grupy państw. Warunek na ich liczność należy do HAVING.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie 8</summary>

```sql
SELECT panstwo, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY panstwo
HAVING COUNT(*) > 1
ORDER BY liczbaObiektow DESC, panstwo;
```

3 wiersze: `Islandia => 9`, `Polska => 4`, `Tanzania => 3`.

</details>


### Ćwiczenie 9 - Pełne wiersze

Przewidź liczbę wierszy SELECT DISTINCT * FROM turysci. Następnie sprawdź wynik i wyjaśnij rolę klucza głównego.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 9</summary>

Sprawdź, czy dwa wybrane wiersze mogą mieć taki sam idTurysta.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie 9</summary>

```sql
SELECT DISTINCT * FROM turysci;
```

13 wierszy. Każdy ma inny klucz główny, więc nie ma dwóch identycznych pełnych wierszy. Kolejność bez ORDER BY nie jest określona.

</details>

## 11. Jak wybrać konstrukcję?

| Konstrukcja | Co otrzymasz? | Kiedy jej użyć? |
| --- | --- | --- |
| `DISTINCT` | Różne wiersze wybranych kolumn | Potrzebujesz listy bez powtórzeń. |
| `DISTINCTROW` | To samo co DISTINCT w MariaDB | Czytasz lub zapisujesz równoważną składnię MariaDB. |
| `COUNT(DISTINCT kolumna)` | Liczbę różnych wartości z pominięciem NULL | Potrzebujesz liczby, nie listy. |
| `GROUP BY` | Grupy, dla których możesz obliczyć COUNT, SUM, AVG itd. | Potrzebujesz podsumowania każdej grupy; HAVING może wybrać część grup. |

Przed pisaniem SQL powiedz własnymi słowami, co ma oznaczać jeden wiersz odpowiedzi. Dobierz wybrane kolumny i konstrukcję do tego pytania.

## Materiały odniesienia

- [GROUP BY - grupowanie danych]({{ '/04-grupowanie-danych/01-group-by.html' | relative_url }}).
- [HAVING - filtrowanie grup]({{ '/04-grupowanie-danych/02-having.html' | relative_url }}).
- [MariaDB - SELECT, DISTINCT i DISTINCTROW](https://mariadb.com/docs/server/reference/sql-statements/data-manipulation/selecting-data/select#distinct).
- [MariaDB - COUNT DISTINCT](https://mariadb.com/docs/server/reference/sql-functions/aggregate-functions/count-distinct).
- [MariaDB - GROUP BY](https://mariadb.com/docs/server/reference/sql-statements/data-manipulation/selecting-data/group-by).
