---
title: GROUP BY - grupowanie danych krok po kroku
mermaid: true
---

# Lekcja 5 - GROUP BY - grupowanie danych krok po kroku

## Zanim zaczniemy

**Cel:** zrozumieć, czym jest grupa w SQL, kiedy w wyniku pojawia się jeden wiersz, dlaczego niektóre wiersze znikają oraz jak prawidłowo policzyć elementy każdej grupy.

- Pracujemy w phpMyAdmin, na bazie `Islandia` zaimportowanej z pliku `baza1.sql`.
- Używamy prawdziwych tabel `turysci`, `obiekty` i `rodzaje`.
- Znamy już `SELECT`, `FROM`, `WHERE`, `ORDER BY` i podstawy `JOIN`.
- Zapytania wykonujemy pojedynczo w zakładce SQL. Niczego nie dodajemy ani nie usuwamy.
- Podane wyniki odnoszą się do niezmienionego pliku `baza1.sql`.
- Nie uczymy się jeszcze `HAVING`. To będzie osobna lekcja.

**Jedno zdanie do zapamiętania:** `GROUP BY` zbiera wiersze mające tę samą wartość wskazanej kolumny lub ten sam zestaw wskazanych wartości i tworzy jeden wiersz wyniku dla każdej grupy.

## 1. Po co nam grupowanie?

Wyobraź sobie trzynastu turystów. Chcesz ustalić, ile osób zdobyło tyle samo punktów. Nie interesują Cię już nazwiska wszystkich osób, tylko **grupy o tej samej liczbie punktów**.

W tabeli `turysci` występują między innymi takie rekordy:

| nick | punkty |
| --- | ---: |
| Ewa | 23 |
| Paula | 23 |
| Jowita | 11 |
| Adam | 11 |
| Monika | 4 |

Jeżeli grupujemy według pola `punkty`, otrzymujemy między innymi:

```text
23 punkty => Ewa, Paula   => 2 osoby
11 punktów => Jowita, Adam => 2 osoby
 4 punkty => Monika       => 1 osoba
```

`GROUP BY` nie łączy fizycznie turystów w bazie i niczego w niej nie zmienia. Przygotowuje **wynik zapytania**.

## 2. Najprostszy przykład - GROUP BY bez liczenia

### Krok 1 - obejrzyj wszystkie wartości

```sql
SELECT punkty
FROM turysci
ORDER BY punkty;
```

Zapytanie zwraca **13 wierszy**, bo tylu turystów zapisano w tabeli. Widzimy również powtarzające się liczby `11` i `23`.

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

**Co się wydarzyło?**

- W pierwszym zapytaniu widzieliśmy 13 wierszy.
- W drugim widzimy 11 wierszy.
- Każda wartość `punkty` pojawia się tylko raz.
- Powtarzające się wartości `11` i `23` utworzyły po jednej grupie.

**Ważne:** jeżeli wybieramy tylko jedną kolumnę i nie liczymy elementów, taki wynik przypomina `SELECT DISTINCT punkty`. Do poznania prawdziwej siły grupowania potrzebujemy funkcji agregującej, np. `COUNT()`.

<details class="lesson-hint" markdown="1">
<summary>Sprawdź - czy GROUP BY usunęło rekordy z tabeli?</summary>

Nie. Liczba rekordów w tabeli `turysci` nie zmieniła się. Zmienił się tylko sposób prezentacji wyniku zapytania. Po wykonaniu `SELECT * FROM turysci;` nadal zobaczysz 13 turystów.

</details>

## 3. GROUP BY razem z COUNT(*)

Teraz chcemy wiedzieć nie tylko **jakie grupy istnieją**, ale również **ile rekordów należy do każdej z nich**.

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

**Uwaga:** liczba **wierszy wyniku** to `11`, a suma wartości w kolumnie `liczbaTurystow` to `13`. To nie jest sprzeczność: jeden wiersz wyniku opisuje całą grupę.

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

## 4. Jak czytać GROUP BY? Prosty przepis

```sql
SELECT kolumnaGrupujaca, COUNT(*) AS liczba
FROM nazwaTabeli
GROUP BY kolumnaGrupujaca;
```

Przepis ma trzy podstawowe czynności:

1. Wybieramy kolumnę, według której podzielimy rekordy.
2. Tworzymy grupy wierszy o takiej samej wartości tej kolumny.
3. Dla każdej grupy obliczamy wynik, np. liczbę wierszy.

Wybór kolumny ma znaczenie. Jeżeli każdy rekord ma inny identyfikator, to grupowanie po unikatowym identyfikatorze utworzy tyle grup, ile rekordów. Nie uzyskamy wtedy ciekawego podsumowania.

## 5. Przykład z obiektami - ile obiektów jest w każdym państwie?

Przechodzimy do tabeli `obiekty`. Wykonaj:

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

- Tabela zawiera 25 obiektów, a wynik tylko 12 wierszy.
- Dla Islandii istnieje grupa 9 obiektów.
- Dla Polski istnieje grupa 4 obiektów.
- Wartość `Nairobi` pojawia się dlatego, że właśnie taki tekst znajduje się w polu `panstwo` jednego rekordu źródłowego. SQL nie ocenia, czy ta wartość jest nazwą państwa. **Nie poprawiamy danych na potrzeby ćwiczenia.**

### Dlaczego nie ma tutaj nazw obiektów?

Ponieważ pytamy o liczbę obiektów **w państwie**, a nie o listę poszczególnych obiektów. Jedna grupa może zawierać wiele różnych nazw. Ich wszystkich nie da się uczciwie pokazać w jednej zwykłej kolumnie `nazwa` bez określenia, co z nimi zrobić.

## 6. WHERE działa przed GROUP BY

A co, jeśli interesuje nas tylko Islandia? Najpierw wybierzmy te rekordy, a następnie je pogrupujmy.

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

Wyjaśnienie:

1. Z tabeli `obiekty` wybieramy tylko rekordy, w których `panstwo = 'Islandia'` - zostaje **9 rekordów**.
2. Dzielimy te dziewięć rekordów na grupy według `idRodzaj` - powstaje **5 grup**.
3. `COUNT(*)` liczy elementy każdej grupy - otrzymujemy `4 + 1 + 1 + 2 + 1 = 9`.

### Co jeśli grupujemy tylko po państwie, ale wybraliśmy już Islandię?

```sql
SELECT panstwo, COUNT(*) AS liczbaObiektow
FROM obiekty
WHERE panstwo = 'Islandia'
GROUP BY panstwo;
```

Wynik to **jeden wiersz: `Islandia => 9`**. Po `WHERE` wszystkie pozostałe rekordy mają taką samą wartość pola `panstwo`, więc powstaje dokładnie jedna grupa.

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

## 7. Grupowanie według dwóch kolumn

Czasami jedna kolumna nie wystarczy. Chcemy na przykład policzyć **każdy rodzaj obiektu osobno w każdym państwie**.

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

Dwa wiersze należą do tej samej grupy tylko wtedy, gdy mają taki sam **cały zestaw wskazanych wartości**.

To bardzo przydatne, gdy w zadaniu pojawiają się słowa **"w każdym państwie i dla każdego rodzaju"**.

## 8. GROUP BY z JOIN - zadanie z INF.03

W arkuszu **INF.03-01-26.06-SG** trzeba podać rodzaj obiektu i liczbę obiektów każdego rodzaju. Nazwa rodzaju znajduje się w tabeli `rodzaje`, a obiekty w tabeli `obiekty`.

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

Na tym etapie w wyniku pojawia się **25 wierszy**. Wiele wierszy ma tę samą nazwę rodzaju: `wodospad`, `szczyt`, `wulkan` itd.

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

Suma: **25 obiektów**. Wynik ma **8 grup**.

**Po co `GROUP BY r.idRodzaj, r.rodzaj`?** Grupujemy według identyfikatora i nazwy rodzaju. Dzięki temu wszystkie wyświetlane zwykłe kolumny są jednoznacznie związane z grupą, a nazwa `rodzaj` nie jest wybierana przypadkowo.

**Po co `COUNT(o.idObiekt)` zamiast `COUNT(*)`?** W tym zapytaniu z wewnętrznym `JOIN` oba zapisy dadzą tę samą liczbę. W następnym przykładzie ta różnica będzie bardzo ważna.

### Co się stało z rodzajem `rzeka`?

Sprawdź tabelę `rodzaje`: zawiera **9 rodzajów**, w tym `rzeka` (`idRodzaj = 18`). Tymczasem powyższy wynik ma tylko **8 rodzajów**.

To nie jest błąd. W tabeli `obiekty` **nie ma ani jednego rekordu** z `idRodzaj = 18`. Zwykły `JOIN` zwraca tu tylko rodzaje mające pasujący obiekt.

## 9. Kiedy chcemy zobaczyć również grupę z zerem?

To przykład rozszerzający. Nie jest konieczny do pierwszego zapamiętania `GROUP BY`, ale bardzo dobrze wyjaśnia różnicę między brakiem grupy a grupą z liczbą zero.

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

Nie oznacza to, że pojawiła się rzeka. `LEFT JOIN` tworzy w wyniku **jeden wiersz z danymi rodzaju i pustymi polami obiektu**, a `COUNT(*)` liczy ten wiersz.

```text
LEFT JOIN + COUNT(*)          => liczy wiersze wyniku, także bez obiektu
LEFT JOIN + COUNT(o.idObiekt) => liczy tylko rzeczywiście dopasowane obiekty
```

To jedna z najważniejszych pułapek przy łączeniu tabel i grupowaniu.

## 10. ORDER BY - w jakiej kolejności pojawią się grupy?

`GROUP BY` odpowiada za **tworzenie grup**. `ORDER BY` odpowiada za **ustalenie kolejności wyniku**.

```sql
SELECT idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY idRodzaj
ORDER BY liczbaObiektow DESC, idRodzaj ASC;
```

Najpierw zobaczysz grupę `10` z **12 obiektami**, potem grupę `11` z **4 obiektami**, a następnie grupy mające po **2 obiekty**. `idRodzaj ASC` ustala kolejność grup o tej samej liczbie obiektów.

W MariaDB `GROUP BY` może w prostych przypadkach domyślnie porządkować wynik według grupowanych wyrażeń, ale nie należy mylić tego z wymaganiem na kolejność prezentacji. **Jeśli konkretna kolejność jest istotna, zapisz `ORDER BY` jawnie.**

## 11. Typowe błędy i pułapki

### Błąd 1 - wybieranie kolumny, której nie pogrupowaliśmy

```sql
SELECT panstwo, nazwa, COUNT(*)
FROM obiekty
GROUP BY panstwo;
```

**Dlaczego to błąd logiczny?** Islandia ma dziewięć różnych obiektów. Którą pojedynczą `nazwa` baza miałaby pokazać obok informacji `Islandia - 9`?

- Przy włączonym `ONLY_FULL_GROUP_BY` serwer może odrzucić takie zapytanie.
- Bez tej kontroli MariaDB może zwrócić jedną nieokreśloną nazwę z grupy. Wyniku nie wolno traktować jako przewidywalnego.

Poprawna wersja do liczenia obiektów w państwach:

```sql
SELECT panstwo, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY panstwo;
```

**Zasada:** w zwykłym zapytaniu grupującym wyświetlaj kolumny określające grupę i wartości obliczone dla całej grupy (`COUNT`, `SUM`, `MIN`, `MAX`, `AVG`). Nie dodawaj dowolnych kolumn pojedynczego rekordu.

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

## 12. Kiedy podejrzewać GROUP BY w treści zadania?

W zadaniach egzaminacyjnych szukaj sformułowań:

| Treść polecenia | Co to sugeruje? |
| --- | --- |
| „Ile obiektów każdego rodzaju?” | `GROUP BY idRodzaj` i `COUNT(*)` |
| „Liczba obiektów w poszczególnych państwach” | `GROUP BY panstwo` i `COUNT(*)` |
| „Ile osób ma tyle samo punktów?” | `GROUP BY punkty` i `COUNT(*)` |
| „Ile obiektów każdego rodzaju w Islandii?” | Najpierw `WHERE panstwo = 'Islandia'`, potem `GROUP BY idRodzaj` |
| „Każdy rodzaj obiektu w każdym państwie” | `GROUP BY panstwo, idRodzaj` |

Szczególnie uważaj na różnicę między pytaniami **„ile rekordów”** a **„ile różnych wartości”**. Zanim napiszesz SQL, spróbuj powiedzieć własnymi słowami, co ma oznaczać jeden wiersz wyniku.

## 13. Ćwiczenia samodzielne

Wykonuj je w phpMyAdmin, na bazie `Islandia`. Każde zadanie ma ukrytą podpowiedź i rozwiązanie. Najpierw spróbuj sam.

### Ćwiczenie 1 - różne wartości punktów

Wyświetl wszystkie różne liczby punktów występujące w tabeli `turysci`. Wynik uporządkuj rosnąco. Użyj `GROUP BY`, a nie `DISTINCT`.

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

Policz obiekty dla każdego `idKontynent` w tabeli `obiekty`. Wyświetl identyfikator i liczbę obiektów, a wynik uporządkuj według identyfikatora kontynentu.

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

Policz obiekty każdego rodzaju tylko dla Polski. Wyświetl identyfikator rodzaju oraz jego liczność.

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

Tabela `rodzaje` zawiera rodzaj `rzeka`. Wyjaśnij, dlaczego zwykłe grupowanie tabeli `obiekty` według `idRodzaj` nie pokazuje grupy 18. Nie zmieniaj danych.

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

Dla Islandii i Polski wyświetl liczbę obiektów w każdym połączeniu wartości `panstwo` i `idRodzaj`. Wynik uporządkuj według obu tych kolumn.

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

Wyświetl nazwy rodzajów obiektów z tabeli `rodzaje` oraz liczbę obiektów należących do każdego rodzaju. Kolumnie z liczbą nadaj alias `Liczba obiektów`. Wykorzystaj relację tabel `rodzaje` i `obiekty`, a następnie grupowanie.

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

Zmodyfikuj ostatnie zapytanie tak, aby w wyniku pojawiała się również `rzeka` z liczbą `0`. Następnie wyjaśnij, dlaczego w tym przypadku użycie `COUNT(*)` może wprowadzać w błąd.

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

## 14. Podsumowanie - co powinieneś umieć?

- Wyjaśnić, dlaczego `GROUP BY` zwraca mniej wierszy niż zwykły `SELECT`.
- Odróżnić liczbę grup od liczby rekordów należących do grup.
- Używać `GROUP BY` razem z `COUNT(*)`.
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

## 15. Co będzie w następnej lekcji?

**HAVING - wybieranie grup na podstawie obliczonego wyniku.** Poznamy je dopiero po opanowaniu przykładów z tej lekcji. Nie wprowadzamy jeszcze `HAVING` do bieżących zapytań.

## Materiały odniesienia

- Baza: [baza1.sql](https://github.com/mariuszsmolka-stack/bazy-danych-php-2026/blob/main/baza/baza1.sql).
- [Cztery zapytania SQL z arkusza INF.03]({{ '/03-zapytania-inf03/01-cztery-zapytania.html' | relative_url }}).
- Arkusz egzaminacyjny INF.03-01-26.06-SG, czerwiec 2026, strona 2 - zapytanie 4.
- MariaDB - GROUP BY: https://mariadb.com/docs/server/reference/sql-statements/data-manipulation/selecting-data/group-by
- MariaDB - COUNT(): https://mariadb.com/docs/server/reference/sql-functions/aggregate-functions/count
