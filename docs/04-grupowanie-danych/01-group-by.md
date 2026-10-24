---
title: GROUP BY - grupowanie danych krok po kroku
mermaid: true
---

# Lekcja 5 - GROUP BY - grupowanie danych krok po kroku

Jeśli dopiero poznajesz `GROUP BY`, zacznij od [krótkiej lekcji 5A]({{ '/04-grupowanie-danych/01a-group-by-podstawy.html' | relative_url }}).

Tutaj znajdziesz więcej przykładów i trudniejsze zadania.

Chcemy sprawdzić, ilu turystów zdobyło tyle samo punktów. Najpierw zobaczysz, czym jest grupa i jak policzyć należące do niej osoby. Potem przejdziesz do obiektów i trudniejszych przykładów.

Ta lekcja ma trzy poziomy. Wybierz je po kolei:

- **Podstawy:** sekcje 1-3 i 5-7 oraz ćwiczenia 1-3. Nauczysz się tworzyć grupy i liczyć rekordy.
- **Dalsza nauka:** sekcje 4, 8-9 i 11 oraz ćwiczenia 4-6. Poznasz inne obliczenia, dwie kolumny i łączenie tabel.
- **Rozszerzenia:** przykłady 2 i 4 w sekcji 4, sekcje 10 i 12 oraz ćwiczenie dodatkowe. Wróć do nich po opanowaniu podstaw.

Pracujemy w phpMyAdmin na bazie `Islandia` z pliku `baza1.sql`. Użyjemy tabel `turysci`, `obiekty` i `rodzaje`. Przydadzą się znane już `SELECT`, `FROM`, `WHERE`, `ORDER BY` i podstawy `JOIN`.

Wykonuj zapytania pojedynczo w zakładce SQL. Nie zmieniaj danych. Podane wyniki dotyczą niezmienionej bazy.

`HAVING` poznamy na następnej lekcji.

## 1. Po co nam grupowanie?

W tabeli `turysci` jest 13 osób. Spójrz na kilka z nich:

| nick | punkty |
| --- | ---: |
| Ewa | 23 |
| Paula | 23 |
| Jowita | 11 |
| Adam | 11 |
| Monika | 4 |

Ewa i Paula mają po 23 punkty. Tworzą jedną grupę. Jowita i Adam mają po 11 punktów, więc tworzą drugą. Monika należy do grupy osób z 4 punktami.

Podzielmy turystów według pola `punkty`:

```text
23 punkty => Ewa, Paula   => 2 osoby
11 punktów => Jowita, Adam => 2 osoby
 4 punkty => Monika       => 1 osoba
```

`GROUP BY` tworzy takie grupy w wyniku zapytania. Rekordy o tej samej liczbie punktów należą do jednej grupy. Dane w tabeli pozostają bez zmian.

## 2. Najprostszy przykład - GROUP BY bez liczenia

### Krok 1 - obejrzyj wszystkie wartości

```sql
SELECT punkty
FROM turysci
ORDER BY punkty;
```

Zapytanie zwraca **13 wierszy** - po jednym dla każdego turysty. Liczby `11` i `23` się powtarzają.

### Krok 2 - pogrupuj wartości

```sql
SELECT punkty
FROM turysci
GROUP BY punkty
ORDER BY punkty;
```

Wynik:

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

Porównaj oba wyniki:

- W pierwszym zapytaniu widzieliśmy 13 wierszy.
- W drugim widzimy 11 wierszy.
- Każda wartość `punkty` pojawia się tylko raz.
- Powtarzające się wartości `11` i `23` utworzyły po jednej grupie.

Każda grupa daje jeden wiersz wyniku. Dlatego 13 turystów dało 11 grup. To nadal 13 rekordów w tabeli.

Gdy wybieramy tylko `punkty` bez liczenia, wynik przypomina `SELECT DISTINCT punkty`. Teraz policzymy osoby w każdej grupie przez `COUNT(*)`.

<details class="lesson-hint" markdown="1">
<summary>Sprawdź - czy GROUP BY usunęło rekordy z tabeli?</summary>

Nie. Liczba rekordów w tabeli `turysci` nie zmieniła się. Zmienił się tylko sposób prezentacji wyniku zapytania. Po wykonaniu `SELECT * FROM turysci;` nadal zobaczysz 13 turystów.

</details>

## 3. GROUP BY razem z COUNT(*)

`GROUP BY` tworzy grupy. `COUNT(*)` liczy rekordy w każdej z nich. Wynik pokaże liczbę osób dla każdej wartości punktów.

```sql
SELECT punkty, COUNT(*) AS liczbaTurystow
FROM turysci
GROUP BY punkty
ORDER BY punkty;
```

Wynik:

| punkty | liczbaTurystow |
| ---: | ---: |
| 4 | 1 |
| 5 | 1 |
| 7 | 1 |
| 11 | 2 |
| 12 | 1 |
| 21 | 1 |
| 23 | 2 |
| 31 | 1 |
| 45 | 1 |
| 46 | 1 |
| 51 | 1 |

Przeczytajmy instrukcje po kolei:

- `FROM turysci` - korzystamy z tabeli turystów.
- `GROUP BY punkty` - tworzymy osobną grupę dla każdej wartości punktów.
- `COUNT(*)` - liczymy **wiersze w każdej grupie**, nie w całej tabeli.
- `AS liczbaTurystow` - nadajemy obliczonej kolumnie czytelną nazwę.
- `ORDER BY punkty` - ustawiamy grupy w kolejności rosnących punktów.

Wynik ma **11 wierszy** - po jednym dla każdej grupy. Suma liczb w kolumnie `liczbaTurystow` wynosi **13**, bo tylu turystów jest w tabeli. Liczba grup nie jest liczbą turystów.

### Porównanie - COUNT(*) bez GROUP BY

```sql
SELECT COUNT(*) AS liczbaTurystow
FROM turysci;
```

Wynik: **jedna liczba - 13**. Liczymy wszystkie wiersze razem, ponieważ nie wskazaliśmy grup.

```text
COUNT(*) bez GROUP BY => jeden wynik dla całej tabeli
COUNT(*) z GROUP BY   => osobny wynik dla każdej grupy
```

## 4. Funkcje agregujące - obliczenia na wielu rekordach

To dalsza część nauki. Jeśli dopiero poznajesz `GROUP BY`, wróć do niej po opanowaniu `COUNT(*)`.

### Po co są funkcje agregujące?

Zwykły `SELECT` pokazuje dane z kolejnych wierszy. `COUNT(*)` daje jedną liczbę: ile tych wierszy jest. Możemy też wykonać inne obliczenia na wartościach:

- Ilu turystów znajduje się w bazie?
- Ile punktów zdobyli łącznie?
- Jaka jest średnia liczba punktów?
- Jaka jest najmniejsza i największa liczba punktów?
- Ile obiektów znajduje się w każdym państwie?

Takie obliczenia wykonują **funkcje agregujące**. `SUM()` dodaje liczby, a `AVG()` oblicza średnią. `MIN()` i `MAX()` znajdują najmniejszą i największą wartość.

| Funkcja | Co oblicza? | Jakie dane możemy podać? |
| --- | --- | --- |
| `COUNT(*)` | Liczbę wierszy | Wszystkie wiersze, bez wskazywania kolumny |
| `COUNT(kolumna)` | Liczbę wartości różnych od `NULL` | Kolumny dowolnego typu, także tekstowe |
| `SUM(kolumna)` | Sumę | Dane liczbowe |
| `AVG(kolumna)` | Średnią arytmetyczną | Dane liczbowe |
| `MIN(kolumna)` | Najmniejszą wartość | Liczby, teksty, daty |
| `MAX(kolumna)` | Największą wartość | Liczby, teksty, daty |

`SUM()` i `AVG()` mają sens dla danych liczbowych. `MIN()` i `MAX()` mogą też porównywać teksty lub daty. `COUNT()` nie musi dotyczyć liczb.

Dla dat `MIN()` wskazuje najwcześniejszą, a `MAX()` najpóźniejszą datę.

Dla tekstu `MIN()` i `MAX()` porównują wartości według reguł sortowania używanych przez bazę. Nie sumujemy nazw turystów ani nie obliczamy średniej z nazw.

### Przykład 1 - wszystkie funkcje na tabeli turysci

W phpMyAdmin wybierz bazę `Islandia` i wykonaj:

```sql
SELECT
    COUNT(*) AS liczbaTurystow,
    SUM(punkty) AS sumaPunktow,
    ROUND(AVG(punkty), 2) AS sredniaPunktow,
    MIN(punkty) AS najmniejPunktow,
    MAX(punkty) AS najwiecejPunktow
FROM turysci;
```

Wynik na niezmienionej bazie:

| liczbaTurystow | sumaPunktow | sredniaPunktow | najmniejPunktow | najwiecejPunktow |
| ---: | ---: | ---: | ---: | ---: |
| 13 | 290 | 22.31 | 4 | 51 |

Dlaczego w wyniku pojawił się tylko **jeden wiersz**?

- Nie zastosowaliśmy `GROUP BY`.
- Wszystkich 13 turystów potraktowano jako jeden zbiór do obliczeń.
- Każda funkcja zwróciła jedną wartość podsumowującą ten zbiór.
- `ROUND(AVG(punkty), 2)` zaokrągla średnią do dwóch miejsc po przecinku.

To pierwszy ważny wniosek: **funkcje agregujące działają także bez `GROUP BY`**.

### Przykład 2 - COUNT(*) a COUNT(kolumna)

```sql
SELECT COUNT(*) AS wszystkieWiersze,
       COUNT(nick) AS nickiNieNull
FROM turysci;
```

W naszej bazie wynik to `13` i `13`.

- `COUNT(*)` liczy wszystkie wiersze.
- `COUNT(nick)` liczy tylko te wiersze, w których `nick` nie ma wartości `NULL`.
- Pusty tekst `''` nie jest wartością `NULL`, więc `COUNT(nick)` uwzględniłby taki pusty tekst.

`NULL` oznacza brak wartości, a nie zero. `SUM()`, `AVG()`, `MIN()` i `MAX()` pomijają takie wartości. `AVG()` dzieli sumę przez liczbę wartości różnych od `NULL`, nie przez liczbę wszystkich wierszy.

Jeśli nie ma wartości do obliczenia, te cztery funkcje zwracają `NULL`. `COUNT()` zwraca wtedy zero.

Oba wyniki są tutaj identyczne, ponieważ żaden z 13 rekordów nie ma wartości `NULL` w polu `nick`.

### Przykład 3 - GROUP BY zmienia zakres obliczeń

Bez `GROUP BY` funkcja podsumowuje wszystkie wybrane rekordy razem. Z `GROUP BY` oblicza wynik dla każdej grupy osobno. Zobacz to na wysokościach wodospadów. Prostsze liczenie obiektów według państw znajdziesz w sekcji 6.

### MIN, MAX, AVG i SUM w grupach

W tabeli `obiekty` pole `wartoscCechy` może oznaczać wysokość, długość lub powierzchnię. Te wielkości mają różne jednostki. Nie należy liczyć z nich jednej średniej.

Dlatego wybierzemy tylko **wodospady, dla których zapisana cecha to wysokość**, i porównamy Polskę oraz Islandię:

```sql
SELECT
    panstwo,
    COUNT(*) AS liczbaWodospadow,
    MIN(wartoscCechy) AS najmniejszaWysokosc,
    MAX(wartoscCechy) AS najwiekszaWysokosc,
    ROUND(AVG(wartoscCechy), 2) AS sredniaWysokosc,
    SUM(wartoscCechy) AS sumaWysokosci
FROM obiekty
WHERE idRodzaj = 10
  AND nazwaCechy = 'wysokość'
  AND panstwo IN ('Islandia', 'Polska')
GROUP BY panstwo
ORDER BY panstwo;
```

Oczekiwany wynik:

| panstwo | liczbaWodospadow | najmniejszaWysokosc | najwiekszaWysokosc | sredniaWysokosc | sumaWysokosci |
| --- | ---: | ---: | ---: | ---: | ---: |
| Islandia | 3 | 30 | 60 | 50.00 | 150 |
| Polska | 4 | 22 | 70 | 34.75 | 139 |

Dlaczego wynik pokazuje trzy islandzkie wodospady, choć w bazie są cztery? Dla `Dettifoss` pole `nazwaCechy` ma wartość `przepustowość metry sześcienne`, a nie `wysokość`. Warunek `WHERE` pomija ten rekord przed grupowaniem.

Teraz odczytajmy działanie zapytania:

```text
FROM obiekty
    => WHERE: tylko wodospady o zapisanej wysokości z Islandii i Polski
    => GROUP BY panstwo: dwie grupy
    => MIN / MAX / AVG: obliczenia osobno dla każdej grupy
    => SELECT: wynik dla każdego państwa
    => ORDER BY: ustalenie kolejności wyników
```

`SUM(wartoscCechy)` liczy sumę **osobno dla każdej grupy**. Sumowanie wysokości różnych wodospadów jest tu tylko ćwiczeniem rachunkowym. Zwykle nie jest użytecznym wskaźnikiem geograficznym, choć zapytanie SQL jest poprawne.

### Przykład 4 - funkcja MIN lub MAX dla tekstu

```sql
SELECT MIN(nick) AS pierwszyAlfabetycznie,
       MAX(nick) AS ostatniAlfabetycznie
FROM turysci;
```

W tej bazie otrzymujemy `Adam` i `Tomek`. To przykład użycia funkcji agregującej na kolumnie tekstowej. `MIN()` i `MAX()` wybierają wartości zgodnie z regułami porównywania tekstu w bazie, a nie według liczby znaków w nicku.

### Ćwiczenia - funkcje agregujące

#### Ćwiczenie A1 - punkty turystów

Policz turystów z tabeli `turysci`. Oblicz sumę ich punktów. Pokaż też średnią zaokrągloną do dwóch miejsc po przecinku.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie A1</summary>

Wystarczy jedna tabela. Użyj `COUNT(*)`, `SUM(punkty)` i `AVG(punkty)`. Nie potrzebujesz `GROUP BY`.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie A1</summary>

```sql
SELECT COUNT(*) AS liczbaTurystow,
       SUM(punkty) AS sumaPunktow,
       ROUND(AVG(punkty), 2) AS sredniaPunktow
FROM turysci;
```

Wynik: `13`, `290`, `22.31`.

</details>

#### Ćwiczenie A2 - liczba obiektów w poszczególnych państwach

Policz obiekty w każdym państwie. Uporządkuj państwa alfabetycznie.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie A2</summary>

Grupuj po `panstwo` i licz wiersze przez `COUNT(*)`.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie A2</summary>

```sql
SELECT panstwo, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY panstwo
ORDER BY panstwo;
```

Wynik ma 12 wierszy. Islandia ma 9 obiektów, Polska 4, Tanzania 3.

</details>

#### Ćwiczenie A3 - najniższe i najwyższe wodospady

Wybierz wodospady z Polski i Islandii, dla których podano wysokość. W każdym państwie znajdź najmniejszą i największą wysokość.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie A3</summary>

Zastosuj `WHERE` do wybrania właściwych rekordów. Następnie `GROUP BY panstwo` i funkcje `MIN()` oraz `MAX()`.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie A3</summary>

```sql
SELECT panstwo,
       MIN(wartoscCechy) AS minimumWysokosci,
       MAX(wartoscCechy) AS maksimumWysokosci
FROM obiekty
WHERE idRodzaj = 10
  AND nazwaCechy = 'wysokość'
  AND panstwo IN ('Islandia', 'Polska')
GROUP BY panstwo
ORDER BY panstwo;
```

Wynik: Islandia `30` i `60`, Polska `22` i `70`.

</details>

## 5. Jak czytać GROUP BY? Prosty przepis

```sql
SELECT kolumnaGrupujaca, COUNT(*) AS liczba
FROM nazwaTabeli
GROUP BY kolumnaGrupujaca;
```

Przepis ma trzy podstawowe czynności:

1. Wybieramy kolumnę, według której podzielimy rekordy.
2. Tworzymy grupy wierszy o takiej samej wartości tej kolumny.
3. Dla każdej grupy obliczamy wynik, np. liczbę wierszy.

Wybór kolumny ma znaczenie. Każdy obiekt ma inny identyfikator. Grupowanie po nim utworzy więc tyle grup, ile jest obiektów. Taki wynik nie pomoże nam policzyć obiektów w państwach.

## 6. Przykład z obiektami - ile obiektów jest w każdym państwie?

Teraz policzmy obiekty w każdym państwie. Użyjemy tabeli `obiekty`:

```sql
SELECT panstwo, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY panstwo
ORDER BY panstwo;
```

Wynik na danych kursowych:

| panstwo | liczbaObiektow |
| --- | ---: |
| Chiny | 1 |
| Islandia | 9 |
| Japonia | 1 |
| Laos | 1 |
| Malezja | 1 |
| Maroko | 1 |
| Nairobi | 1 |
| Nepal | 1 |
| Pakistan | 1 |
| Polska | 4 |
| Tanzania | 3 |
| USA | 1 |

**Co warto zauważyć?**

- Tabela zawiera 25 obiektów, ale wynik ma 12 wierszy - po jednym dla każdej wartości pola `panstwo`.
- Dla Islandii istnieje grupa 9 obiektów.
- Dla Polski istnieje grupa 4 obiektów.
- W polu `panstwo` jednego obiektu zapisano `Nairobi`. SQL pokazuje tę wartość jako osobną grupę. Nie sprawdza, czy jest to nazwa państwa. **Nie zmieniamy danych na potrzeby ćwiczenia.**

### Dlaczego nie ma tutaj nazw obiektów?

Pytamy o liczbę obiektów **w państwie**, a nie o ich nazwy. Jedna grupa może zawierać wiele nazw. Nie można wybrać jednej wartości `nazwa` bez ustalenia, którą z nich pokazać.

## 7. WHERE działa przed GROUP BY

Chcemy policzyć rodzaje obiektów tylko w Islandii. Najpierw wybieramy obiekty z Islandii. Potem dzielimy je na grupy według rodzaju.

```sql
SELECT idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
WHERE panstwo = 'Islandia'
GROUP BY idRodzaj
ORDER BY idRodzaj;
```

Wynik:

| idRodzaj | liczbaObiektow |
| ---: | ---: |
| 10 | 4 |
| 11 | 1 |
| 13 | 1 |
| 14 | 2 |
| 15 | 1 |

Czytaj zapytanie krok po kroku:

1. `WHERE` wybiera obiekty z Islandii. Zostaje **9 rekordów**.
2. `GROUP BY` tworzy grupy według `idRodzaj`. Powstaje **5 grup**.
3. `COUNT(*)` liczy rekordy w każdej grupie. Razem jest ich `4 + 1 + 1 + 2 + 1 = 9`.

### Co jeśli grupujemy tylko po państwie, ale wybraliśmy już Islandię?

```sql
SELECT panstwo, COUNT(*) AS liczbaObiektow
FROM obiekty
WHERE panstwo = 'Islandia'
GROUP BY panstwo;
```

Wynik to **jeden wiersz: `Islandia => 9`**. Po użyciu `WHERE` zostały tylko rekordy z Islandii. Wszystkie należą do jednej grupy według pola `panstwo`.

<figure class="lesson-diagram">
<pre class="mermaid-source" hidden>
flowchart TD
    A["Tabela obiekty - 25 rekordów"] --> B["WHERE panstwo = Islandia"]
    B --> C["Pozostało 9 rekordów"]
    C --> D["GROUP BY idRodzaj"]
    D --> E["Powstało 5 grup"]
    E --> F["COUNT - liczba rekordów w każdej grupie"]
    F --> G["ORDER BY idRodzaj - kolejność wyniku"]
</pre>
<p class="diagram-fallback">FROM => WHERE => GROUP BY => COUNT => ORDER BY</p>
<figcaption>Przepływ danych dla zapytania grupującego obiekty z Islandii.</figcaption>
</figure>

**Nie myl dwóch pytań:**

- `WHERE panstwo = 'Islandia'` - **które pojedyncze rekordy mają w ogóle brać udział w obliczeniach?**
- `GROUP BY idRodzaj` - **według czego pogrupować pozostałe rekordy?**

Nie próbuj w tym miejscu filtrować grup według wyniku `COUNT()`. Temat filtrowania gotowych grup omówimy osobno.

## 8. Grupowanie według dwóch kolumn

To dalsza część nauki. Czasami jedna kolumna nie wystarczy. Chcemy policzyć **każdy rodzaj obiektu osobno w każdym państwie**.

```sql
SELECT panstwo, idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
WHERE panstwo IN ('Islandia', 'Polska')
GROUP BY panstwo, idRodzaj
ORDER BY panstwo, idRodzaj;
```

Wynik:

| panstwo | idRodzaj | liczbaObiektow |
| --- | ---: | ---: |
| Islandia | 10 | 4 |
| Islandia | 11 | 1 |
| Islandia | 13 | 1 |
| Islandia | 14 | 2 |
| Islandia | 15 | 1 |
| Polska | 10 | 4 |

**Jak SQL tworzy grupy?**

- `Islandia` + `10` to jedna grupa.
- `Islandia` + `11` to inna grupa.
- `Polska` + `10` to jeszcze inna grupa.

Dwa wiersze trafią do tej samej grupy, jeśli mają to samo państwo **i** ten sam rodzaj.

To bardzo przydatne, gdy w zadaniu pojawiają się słowa **"w każdym państwie i dla każdego rodzaju"**.

## 9. GROUP BY z JOIN - zadanie z INF.03

Ile obiektów mamy każdego rodzaju? Takie pytanie występuje w arkuszu **INF.03-01-26.06-SG**.

Nazwa rodzaju jest w tabeli `rodzaje`. Dane obiektów są w tabeli `obiekty`. Potrzebujemy więc obu tabel.

Przypomnienie relacji:

```text
rodzaje.idRodzaj (klucz główny)
    => obiekty.idRodzaj (klucz obcy)
```

### Krok 1 - połącz tabele i obejrzyj dane

```sql
SELECT r.rodzaj, o.nazwa
FROM rodzaje AS r
JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
ORDER BY r.idRodzaj, o.idObiekt;
```

Po połączeniu tabel wynik ma **25 wierszy**. Nazwy rodzajów się powtarzają, na przykład `wodospad` i `szczyt`.

### Krok 2 - zamiast nazw pojedynczych obiektów policz grupy

```sql
SELECT r.rodzaj, COUNT(o.idObiekt) AS `Liczba obiektów`
FROM rodzaje AS r
JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
GROUP BY r.idRodzaj, r.rodzaj
ORDER BY r.idRodzaj;
```

Wynik:

| rodzaj | Liczba obiektów |
| --- | ---: |
| wodospad | 12 |
| szczyt | 4 |
| jezioro | 1 |
| wulkan | 2 |
| siedlisko zwierząt | 2 |
| gorące źródło | 1 |
| park narodowy | 1 |
| jaskinia | 2 |

Wynik ma **8 grup**. Łącznie jest w nich **25 obiektów**.

`GROUP BY r.idRodzaj, r.rodzaj` tworzy grupę dla każdego rodzaju. Grupujemy zarówno po jego identyfikatorze, jak i nazwie. Dzięki temu nazwa `rodzaj` jest określona dla każdej grupy. Nie jest wybierana przypadkowo.

W tym zapytaniu z `JOIN` zapisy `COUNT(o.idObiekt)` i `COUNT(*)` dają tę samą liczbę. Przy `LEFT JOIN` będzie inaczej. To trudniejszy przykład z następnej sekcji.

### Co się stało z rodzajem `rzeka`?

W tabeli `rodzaje` jest **9 rodzajów**, w tym `rzeka` (`idRodzaj = 18`). Wynik zapytania pokazuje tylko **8 rodzajów**.

W tabeli `obiekty` **nie ma rekordu** z `idRodzaj = 18`. Zwykły `JOIN` pokazuje tylko rodzaje, do których pasuje co najmniej jeden obiekt. Dlatego nie widzimy rzeki.

## 10. Kiedy chcemy zobaczyć również grupę z zerem?

To rozszerzenie. Nie musisz znać go przy pierwszym ćwiczeniu z `GROUP BY`. Pokazuje, jak otrzymać w wyniku rodzaj, do którego nie należy żaden obiekt.

Zmień `JOIN` na `LEFT JOIN`:

```sql
SELECT r.rodzaj, COUNT(o.idObiekt) AS `Liczba obiektów`
FROM rodzaje AS r
LEFT JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
GROUP BY r.idRodzaj, r.rodzaj
ORDER BY r.idRodzaj;
```

Teraz wynik zawiera **9 rodzajów**, a ostatni wiersz wygląda tak:

| rodzaj | Liczba obiektów |
| --- | ---: |
| rzeka | 0 |

**Dlaczego?**

- `LEFT JOIN` zachowuje wszystkie rekordy z lewej tabeli `rodzaje`.
- Gdy nie ma dopasowanego obiektu, pola z tabeli `obiekty` mają wartość `NULL`.
- `COUNT(o.idObiekt)` liczy niepuste wartości `idObiekt`, więc dla rzek otrzymamy `0`.

### Pułapka - COUNT(*) w LEFT JOIN

Uruchom:

```sql
SELECT r.rodzaj, COUNT(*) AS liczbaWierszy
FROM rodzaje AS r
LEFT JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
GROUP BY r.idRodzaj, r.rodzaj
ORDER BY r.idRodzaj;
```

Dla rodzaju `rzeka` zobaczysz **1**, a nie 0.

Wynik `1` nie oznacza, że znaleziono rzekę. `LEFT JOIN` zachowuje **jeden wiersz z danymi rodzaju**, mimo że pola obiektu są puste. `COUNT(*)` liczy ten wiersz.

```text
LEFT JOIN + COUNT(*)          => liczy wiersze wyniku, także bez obiektu
LEFT JOIN + COUNT(o.idObiekt) => liczy tylko rzeczywiście dopasowane obiekty
```

To jedna z najważniejszych pułapek przy łączeniu tabel i grupowaniu.

## 11. ORDER BY - w jakiej kolejności pojawią się grupy?

`GROUP BY` odpowiada za **tworzenie grup**. `ORDER BY` odpowiada za **ustalenie kolejności wyniku**.

```sql
SELECT idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY idRodzaj
ORDER BY liczbaObiektow DESC, idRodzaj ASC;
```

Najpierw zobaczysz grupę `10` z **12 obiektami**. Potem pojawi się grupa `11` z **4 obiektami**. Dalej będą grupy z **2 obiektami**. Dla grup o tej samej liczbie obiektów kolejność ustala `idRodzaj ASC`.

MariaDB może czasem pokazać grupy w kolejności grupowanych wartości. Nie polegaj na tym układzie. **Jeśli kolejność ma znaczenie, użyj `ORDER BY`.**

## 12. Typowe błędy i pułapki

To rozszerzenie. Wróć do niego, gdy potrafisz już tworzyć grupy i liczyć rekordy.

### Błąd 1 - wybieranie kolumny, której nie pogrupowaliśmy

Grupowanie według państwa daje dla Islandii jeden wiersz z liczbą `9`. Rozważ teraz celowo niejednoznaczne zapytanie:

```sql
SELECT panstwo, nazwa, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY panstwo;
```

W grupie `Islandia` jest dziewięć obiektów o różnych nazwach. Wynik ma pokazać jeden wiersz dla tego państwa. Którą nazwę miałby wybrać SQL?

- `panstwo` jest jednoznaczne, ponieważ określa grupę.
- `COUNT(*)` jest jednoznaczne, ponieważ liczy elementy całej grupy.
- `nazwa` nie jest jednoznaczna, ponieważ wewnątrz grupy ma wiele różnych wartości.

Dlatego w prostych zapytaniach grupujących **wybieramy kolumny, według których grupujemy, oraz wyrażenia zagregowane**.

Uwaga dotycząca MariaDB:

- Przy włączonym `ONLY_FULL_GROUP_BY` takie zapytanie jest odrzucane jako nieprawidłowe.
- Bez tego trybu serwer może zwrócić nieokreśloną nazwę jednego obiektu. Nie wolno zakładać, którą.
- Nie należy wyłączać mechanizmu kontroli po to, aby niejednoznaczne zapytanie zaczęło działać.

**Poprawka 1 - chcemy tylko liczby obiektów w każdym państwie.** Usuń `nazwa` z `SELECT`:

```sql
SELECT panstwo, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY panstwo;
```

**Poprawka 2 - chcemy osobną grupę dla każdego państwa i każdej nazwy obiektu.** Dodaj `nazwa` do grupowania:

```sql
SELECT panstwo, nazwa, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY panstwo, nazwa
ORDER BY panstwo, nazwa;
```

To odpowiada na **inne pytanie**. Teraz grupę określa para `panstwo + nazwa`, a nie samo państwo. Dwa obiekty o nazwie `Wiktorii` w Tanzanii należą do jednej grupy.

**Poprawka 3 - chcemy jedną, jednoznacznie wybraną nazwę na grupę.** Można zastosować `MIN(nazwa)` lub `MAX(nazwa)`, ale otrzymamy nazwę wybraną według reguł porównywania tekstu, a nie listę wszystkich nazw.

```sql
SELECT panstwo,
       MIN(nazwa) AS pierwszaNazwa,
       COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY panstwo;
```

Nie dopisuj kolumn do `GROUP BY` tylko po to, by usunąć błąd. **Najpierw ustal, co ma oznaczać jeden wiersz wyniku.**

### Ćwiczenia - znaczenie jednego wiersza wyniku

#### Ćwiczenie B1 - czy rozumiesz problem z kolumną nazwa?

Wyjaśnij, dlaczego poniższe zapytanie jest niejednoznaczne:

```sql
SELECT panstwo, nazwa, COUNT(*)
FROM obiekty
GROUP BY panstwo;
```

Napisz poprawne zapytanie odpowiadające na pytanie: ile obiektów jest w każdym państwie?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie B1</summary>

Jedna grupa może zawierać wiele nazw obiektów. `nazwa` nie wskazuje wartości wspólnej dla całej grupy.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie B1</summary>

```sql
SELECT panstwo, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY panstwo;
```

Kolumnę `nazwa` usunięto, ponieważ wynik ma zawierać liczbę obiektów dla całego państwa, a nie nazwę pojedynczego obiektu.

</details>

#### Ćwiczenie B2 - poprawa grupowania

Zmień poprzednie zapytanie. Utwórz osobną grupę dla każdej pary `panstwo + nazwa`. Wyjaśnij, dlaczego wynik różni się od grupowania tylko po państwie.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie B2</summary>

Obydwie zwykłe kolumny z `SELECT` powinny teraz określać grupę.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie B2</summary>

```sql
SELECT panstwo, nazwa, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY panstwo, nazwa
ORDER BY panstwo, nazwa;
```

Wynik ma 24 grupy, ponieważ dwa obiekty z Tanzanii mają tę samą nazwę `Wiktorii`.

</details>

### Błąd 2 - próba liczenia w WHERE

```sql
SELECT idRodzaj, COUNT(*)
FROM obiekty
WHERE COUNT(*) > 2
GROUP BY idRodzaj;
```

Ten kod jest nieprawidłowy. `WHERE` działa na wierszach **przed utworzeniem grup**, więc nie może tutaj używać `COUNT(*)` do wyboru grup.

**Jak ograniczać grupy na podstawie ich liczby?** To temat następnej lekcji - `HAVING`. Nie mieszamy go teraz z nauką `GROUP BY`.

### Błąd 3 - grupowanie po unikatowym identyfikatorze

```sql
SELECT idObiekt, COUNT(*) AS liczba
FROM obiekty
GROUP BY idObiekt;
```

Zapytanie jest **poprawne składniowo**, ale mało użyteczne w tym zadaniu: `idObiekt` jest unikatowy, więc powstanie 25 grup po jednym obiekcie i każda liczba będzie wynosiła `1`.

To przykład różnicy między kodem poprawnym a zapytaniem, które odpowiada na właściwe pytanie.

### Błąd 4 - niepoprawna kolejność klauzul

```sql
SELECT panstwo, COUNT(*)
FROM obiekty
GROUP BY panstwo
WHERE panstwo = 'Islandia';
```

W tym miejscu `WHERE` jest za późno, więc wystąpi błąd składni. Prawidłowa kolejność:

```sql
SELECT panstwo, COUNT(*) AS liczbaObiektow
FROM obiekty
WHERE panstwo = 'Islandia'
GROUP BY panstwo;
```

### Pułapka 5 - pusty tekst to nie NULL

W niektórych wierszach bazy pole `opis` jest pustym tekstem `''`. To **nie to samo co `NULL`**.

```sql
SELECT COUNT(*) AS wszystkieRekordy,
       COUNT(opis) AS rekordyZWartosciaOpis
FROM obiekty;
```

W tej bazie otrzymasz **25 i 25**, mimo że część opisów jest pustym tekstem. `COUNT(opis)` pomija `NULL`, ale nie pomija pustych tekstów. Tego typu różnica może być źródłem błędnych wniosków.

### Pułapka 6 - pusta tabela i zero

Tabela `osiagniecia` jest pusta w oryginalnym pliku.

```sql
SELECT COUNT(*) AS liczbaOsiagniec
FROM osiagniecia;
```

Wynik to **jeden wiersz z liczbą `0`**.

```sql
SELECT idTurysta, COUNT(*) AS liczbaOsiagniec
FROM osiagniecia
GROUP BY idTurysta;
```

To zapytanie zwraca **zero wierszy**, ponieważ nie istnieje żadna grupa. Zapamiętaj różnicę między jednym wynikiem `0` a brakiem wierszy wyniku.

## 13. Kiedy podejrzewać GROUP BY w treści zadania?

W zadaniach egzaminacyjnych szukaj sformułowań:

| Treść polecenia | Co to sugeruje? |
| --- | --- |
| „Ile obiektów każdego rodzaju?” | `GROUP BY idRodzaj` i `COUNT(*)` |
| „Liczba obiektów w poszczególnych państwach” | `GROUP BY panstwo` i `COUNT(*)` |
| „Ile osób ma tyle samo punktów?” | `GROUP BY punkty` i `COUNT(*)` |
| „Ile obiektów każdego rodzaju w Islandii?” | Najpierw `WHERE panstwo = 'Islandia'`, potem `GROUP BY idRodzaj` |
| „Każdy rodzaj obiektu w każdym państwie” | `GROUP BY panstwo, idRodzaj` |

Szczególnie uważaj na różnicę między pytaniami **„ile rekordów”** a **„ile różnych wartości”**. Zanim napiszesz SQL, spróbuj powiedzieć własnymi słowami, co ma oznaczać jeden wiersz wyniku.

## 14. Ćwiczenia samodzielne

Wykonuj ćwiczenia w phpMyAdmin na bazie `Islandia`. Każde ma ukrytą podpowiedź i rozwiązanie. Najpierw spróbuj sam.

Ćwiczenia 1-3 utrwalają podstawy. Ćwiczenia 4-6 są na dalszą naukę. Ostatnie ćwiczenie jest dodatkowe.

### Ćwiczenie 1 - różne wartości punktów

Pokaż różne liczby punktów z tabeli `turysci`. Uporządkuj je rosnąco. Użyj `GROUP BY`, a nie `DISTINCT`.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Wybierz tylko kolumnę `punkty`. Grupuj i sortuj według tej samej kolumny.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i sprawdzenie - ćwiczenie 1</summary>

```sql
SELECT punkty
FROM turysci
GROUP BY punkty
ORDER BY punkty;
```

Oczekiwany wynik: **11 wierszy**.

</details>

### Ćwiczenie 2 - liczba obiektów na kontynentach

W tabeli `obiekty` policz obiekty dla każdego `idKontynent`. Pokaż identyfikator i liczbę obiektów. Uporządkuj wynik według `idKontynent`.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

To jedna tabela. Zastosuj `GROUP BY idKontynent` i `COUNT(*)`.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i sprawdzenie - ćwiczenie 2</summary>

```sql
SELECT idKontynent, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY idKontynent
ORDER BY idKontynent;
```

Wynik: `1 => 6`, `2 => 5`, `3 => 1`, `6 => 13`. Razem 25 obiektów. Pozostałe kontynenty nie pojawią się, ponieważ nie mają obiektów w tej tabeli.

</details>

### Ćwiczenie 3 - rodzaje obiektów z Polski

Wybierz obiekty z Polski. Policz je według `idRodzaj`. Pokaż identyfikator rodzaju i liczbę obiektów.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 3</summary>

Najpierw `WHERE panstwo = 'Polska'`, później `GROUP BY idRodzaj`.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i sprawdzenie - ćwiczenie 3</summary>

```sql
SELECT idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
WHERE panstwo = 'Polska'
GROUP BY idRodzaj;
```

Wynik: jeden wiersz `idRodzaj = 10`, `liczbaObiektow = 4`.

</details>

### Ćwiczenie 4 - czego brakuje w wyniku?

Tabela `rodzaje` zawiera rodzaj `rzeka`. Sprawdź, dlaczego grupowanie tabeli `obiekty` według `idRodzaj` nie pokazuje grupy 18. Nie zmieniaj danych.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 4</summary>

`GROUP BY` tworzy grupy tylko z wierszy, które faktycznie znalazły się w danych wejściowych zapytania. Sprawdź, czy istnieje obiekt z `idRodzaj = 18`.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i sprawdzenie - ćwiczenie 4</summary>

```sql
SELECT idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY idRodzaj
ORDER BY idRodzaj;
```

Wynik ma **8 grup** i nie zawiera `18`, ponieważ nie ma żadnego takiego obiektu. Rodzaj może istnieć w tabeli `rodzaje`, ale nie musi występować w tabeli `obiekty`.

</details>

### Ćwiczenie 5 - dwa kryteria grupowania

Wybierz obiekty z Islandii i Polski. Policz je dla każdej pary `panstwo` i `idRodzaj`. Uporządkuj wynik według obu kolumn.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 5</summary>

W `WHERE` zastosuj `IN ('Islandia', 'Polska')`. W `GROUP BY` wymień dwie kolumny, oddzielając je przecinkiem.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i sprawdzenie - ćwiczenie 5</summary>

```sql
SELECT panstwo, idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
WHERE panstwo IN ('Islandia', 'Polska')
GROUP BY panstwo, idRodzaj
ORDER BY panstwo, idRodzaj;
```

Wynik: **6 wierszy**. Islandia tworzy 5 grup, Polska jedną.

</details>

### Ćwiczenie 6 - zadanie egzaminacyjne INF.03

Połącz tabele `rodzaje` i `obiekty`. Pokaż nazwę każdego rodzaju i liczbę należących do niego obiektów. Kolumnę z liczbą nazwij `Liczba obiektów`. Użyj grupowania.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź 1 - ćwiczenie 6</summary>

Połącz tabele po `idRodzaj`, korzystając z `JOIN ... ON`.

</details>

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź 2 - ćwiczenie 6</summary>

Policz identyfikatory obiektów przez `COUNT(o.idObiekt)`. Grupuj po `r.idRodzaj` i `r.rodzaj`.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i sprawdzenie - ćwiczenie 6</summary>

```sql
SELECT r.rodzaj, COUNT(o.idObiekt) AS `Liczba obiektów`
FROM rodzaje AS r
JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
GROUP BY r.idRodzaj, r.rodzaj
ORDER BY r.idRodzaj;
```

Wynik: **8 rodzajów, łącznie 25 obiektów**. Brak wiersza `rzeka` jest prawidłowy przy takim rodzaju połączenia.

</details>

### Ćwiczenie dodatkowe - co oznacza zero?

Zmień ostatnie zapytanie, aby wynik zawierał też `rzeka => 0`. Wyjaśnij, dlaczego `COUNT(*)` może tu pokazać mylącą liczbę.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie dodatkowe</summary>

Zastosuj `LEFT JOIN`. Licz kolumnę `o.idObiekt`, a nie wiersze wyniku.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie dodatkowe</summary>

```sql
SELECT r.rodzaj, COUNT(o.idObiekt) AS `Liczba obiektów`
FROM rodzaje AS r
LEFT JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
GROUP BY r.idRodzaj, r.rodzaj
ORDER BY r.idRodzaj;
```

Wynik: **9 grup**, w tym `rzeka => 0`.

</details>

## 15. Podsumowanie - co powinieneś umieć?

- Wyjaśnić, dlaczego `GROUP BY` zwraca mniej wierszy niż zwykły `SELECT`.
- Odróżnić liczbę grup od liczby rekordów należących do grup.
- Używać `GROUP BY` razem z `COUNT(*)`, `SUM()`, `AVG()`, `MIN()` i `MAX()`.
- Odróżnić agregację całego zbioru od obliczeń w każdej grupie.
- Wybrać porównywalne wielkości przed obliczeniem sumy lub średniej.
- Wytłumaczyć, dlaczego `WHERE` działa przed grupowaniem.
- Grupować według jednej i dwóch kolumn.
- Rozpoznać, kiedy `JOIN` pomija rodzaje bez obiektów.
- Zrozumieć różnicę między `COUNT(*)` i `COUNT(o.idObiekt)` przy `LEFT JOIN`.
- Rozpoznać błędne lub niejednoznaczne kolumny w zapytaniu grupującym.
- Używać `ORDER BY`, gdy zależy Ci na określonej kolejności wyników.

**Najkrótszy schemat:**

```text
FROM / JOIN => WHERE => GROUP BY => obliczenia COUNT => SELECT => ORDER BY
```

## 16. Co będzie w następnej lekcji?

**HAVING - wybieranie grup na podstawie obliczonego wyniku.** Poznamy je dopiero po opanowaniu przykładów z tej lekcji. Nie wprowadzamy jeszcze `HAVING` do bieżących zapytań.

## Materiały odniesienia

- Baza: [baza1.sql](https://github.com/mariuszsmolka-stack/bazy-danych-php-2026/blob/main/baza/baza1.sql).
- [Cztery zapytania SQL z arkusza INF.03]({{ '/03-zapytania-inf03/01-cztery-zapytania.html' | relative_url }}).
- Arkusz egzaminacyjny INF.03-01-26.06-SG, czerwiec 2026, strona 2 - zapytanie 4.
- MariaDB - GROUP BY: https://mariadb.com/docs/server/reference/sql-statements/data-manipulation/selecting-data/group-by
- MariaDB - COUNT(): https://mariadb.com/docs/server/reference/sql-functions/aggregate-functions/count
