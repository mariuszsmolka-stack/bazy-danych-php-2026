---
title: HAVING - filtrowanie grup danych
mermaid: true
---

# Lekcja 6 - HAVING - filtrowanie grup danych

Jeśli dopiero poznajesz `HAVING`, zacznij od [krótkiej lekcji 6A]({{ '/04-grupowanie-danych/02a-having-podstawy.html' | relative_url }}).

Tutaj znajdziesz więcej przykładów i trudniejsze zadania.

**Cel:** wybrać tylko te grupy, których wynik obliczeń spełnia warunek. Nauczysz się odróżniać filtrowanie rekordów przez `WHERE` od filtrowania grup przez `HAVING`.

Pracujemy w phpMyAdmin na bazie `Islandia`, zaimportowanej z niezmienionego `baza1.sql`. Wykonuj zapytania pojedynczo w zakładce SQL. Wszystkie wyniki dotyczą oryginalnych danych. Niczego nie usuwamy ani nie dopisujemy.

To kontynuacja [lekcji o GROUP BY]({{ '/04-grupowanie-danych/01-group-by.html' | relative_url }}). Potrzebujesz grupowania, `COUNT()`, sortowania i podstaw łączenia tabel.

## 1. Przypomnienie - grupy turystów

**Problem:** ile osób ma każdą z występujących w tabeli liczb punktów?

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

W tabeli jest 13 turystów, ale tylko 11 różnych wartości `punkty`. `GROUP BY punkty` tworzy więc 11 grup. Jowita i Adam mają po 11 punktów, a Ewa i Paula po 23. Te dwie grupy liczą po dwie osoby. Każda z pozostałych wartości występuje u jednej osoby.

`COUNT(*)` liczy wiersze osobno w każdej grupie. Alias `liczbaTurystow` nazywa wynik obliczenia, a `ORDER BY punkty` ustawia grupy rosnąco. Suma liczności wynosi nadal 13.

Zatrzymaj się przy wyniku: wskaż dwie grupy, które nie są jednoosobowe. Za chwilę wybierze je SQL.

## 2. Pierwsze HAVING - pozostaw grupy większe niż jedna osoba

**Problem:** chcemy zobaczyć tylko te liczby punktów, które zdobyła więcej niż jedna osoba.

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

W porównaniu z poprzednim zapytaniem doszła jedna linia: `HAVING COUNT(*) > 1`.

1. Powstają te same 11 grup.
2. Dla każdej grupy obliczana jest liczba turystów.
3. `HAVING` sprawdza tę liczbę. Dla grup jednoosobowych warunek `1 > 1` jest fałszywy. Dla dwóch grup dwuosobowych warunek `2 > 1` jest prawdziwy.
4. W wyniku pozostają dwie grupy, uporządkowane według punktów.

**Żaden turysta nie został usunięty z tabeli.** Zniknęły jedynie wiersze podsumowania, które nie spełniły warunku. Wynik ma dwa wiersze opisujące łącznie cztery osoby.

Samodzielnie zmień warunek na `HAVING COUNT(*) = 1`. Sprawdzenie znajdziesz w ćwiczeniu 1.

## 3. WHERE a HAVING - kiedy sprawdzamy warunek?

**Problem:** interesują nas turyści mający co najmniej 20 punktów. Dopiero wśród nich chcemy szukać powtarzających się wyników.

Najpierw obejrzyj rekordy:

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty >= 20
ORDER BY punkty, nick;
```

Otrzymasz 7 osób. Wartości punktów w kolejnych wierszach to `21, 23, 23, 31, 45, 46, 51`. `WHERE` sprawdza punkty każdej osoby, zanim utworzymy grupy.

Teraz podsumuj wybrane rekordy i pozostaw tylko grupy większe niż jedna osoba:

```sql
SELECT punkty, COUNT(*) AS liczbaTurystow
FROM turysci
WHERE punkty >= 20
GROUP BY punkty
HAVING COUNT(*) > 1
ORDER BY punkty;
```

Wynik: `23 => 2 osoby`. Z siedmiu rekordów powstaje sześć grup. Tylko grupa z 23 punktami ma więcej niż jedną osobę. Grupa z 11 punktami nie powstaje, bo tych turystów odrzucił już `WHERE`.

| Klauzula | Pytanie, na które odpowiada |
| --- | --- |
| `WHERE` | Które pojedyncze rekordy biorą udział w obliczeniach? |
| `GROUP BY` | Które rekordy należą do tej samej grupy? |
| `HAVING` | Które obliczone grupy mają pozostać w wyniku? |
| `ORDER BY` | W jakiej kolejności pokazać wynik? |

### Dlaczego COUNT(*) w WHERE jest błędem?

Poniższy przykład jest **celowo niepoprawny**:

```sql
SELECT punkty, COUNT(*)
FROM turysci
WHERE COUNT(*) > 1
GROUP BY punkty;
```

`WHERE` ocenia pojedynczy rekord wejściowy. W tym momencie nie ma jeszcze podziału na grupy ani liczby osób w każdej grupie. Nie da się więc użyć tutaj `COUNT(*)` do wyboru grup. Warunek oparty na tej liczbie trzeba przenieść do `HAVING`, po `GROUP BY`.

Nie zastępuj go przez `WHERE punkty > 1`. Taki warunek pyta o liczbę punktów osoby, a nie o liczbę osób z tym samym wynikiem.

## 4. HAVING na tabeli obiekty

**Problem:** pokaż rodzaje, do których należą co najmniej dwa obiekty.

```sql
SELECT idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY idRodzaj
HAVING COUNT(*) >= 2
ORDER BY idRodzaj;
```

| idRodzaj | liczbaObiektow |
| ---: | ---: |
| 10 | 12 |
| 11 | 4 |
| 13 | 2 |
| 14 | 2 |
| 17 | 2 |

Grupujemy wszystkie 25 obiektów według rodzaju. Z poprzedniej lekcji wiemy, że powstaje 8 grup. `HAVING` pozostawia pięć z nich. Rodzaje `12`, `15` i `16` mają po jednym obiekcie, więc nie spełniają warunku.

W porównaniu z grupowaniem bez `HAVING` liczności grup nie zmieniły się. Ograniczyliśmy tylko zestaw pokazywanych grup.

**Różnica między `> 2` i `>= 2`:**

- `>= 2` oznacza co najmniej dwa, więc uwzględnia także grupy dwuobiektowe.
- `> 2` oznacza więcej niż dwa. Po takiej zmianie pozostaną tylko `10 => 12` i `11 => 4`.

Wypróbuj tę zmianę. Nie zmieniaj jednocześnie kolumny grupującej, aby zobaczyć wpływ samego warunku.

## 5. WHERE + GROUP BY + HAVING - tylko Islandia

**Problem:** które rodzaje mają w Islandii więcej niż jeden obiekt?

```sql
SELECT idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
WHERE panstwo = 'Islandia'
GROUP BY idRodzaj
HAVING COUNT(*) > 1
ORDER BY idRodzaj;
```

Prześledź dane na każdym etapie:

1. `FROM obiekty` wskazuje tabelę z 25 rekordami.
2. `WHERE panstwo = 'Islandia'` wybiera 9 obiektów: Strokkur, Skogafoss, Seljalandsfoss, Fuglaskoðunarhús, kirkjuffell, Siedlisko wielorybów, Hekla, Godafoss i Dettifoss. Nazwy zachowujemy tak, jak zapisano je w bazie. Obiekty z innych państw nie uczestniczą w dalszym liczeniu.
3. `GROUP BY idRodzaj` tworzy pięć grup. Ich liczności przedstawia tabela poniżej.
4. `HAVING COUNT(*) > 1` pozostawia grupy `10` i `14`.
5. `ORDER BY idRodzaj` ustawia pozostałe grupy rosnąco według identyfikatora.

| idRodzaj | Liczność po WHERE i GROUP BY | Czy przechodzi HAVING? |
| ---: | ---: | --- |
| 10 | 4 | Tak: 4 > 1 |
| 11 | 1 | Nie: 1 nie jest większe od 1 |
| 13 | 1 | Nie: 1 nie jest większe od 1 |
| 14 | 2 | Tak: 2 > 1 |
| 15 | 1 | Nie: 1 nie jest większe od 1 |

Końcowy wynik:

| idRodzaj | liczbaObiektow |
| ---: | ---: |
| 10 | 4 |
| 14 | 2 |

W poprzednim przykładzie rodzaj `10` miał 12 obiektów na całym świecie. Tutaj ma 4, ponieważ `WHERE` ograniczył dane wejściowe do Islandii. Samo `HAVING` nie zmniejsza liczności grupy - wybiera ją albo odrzuca.

<figure class="lesson-diagram">
<pre class="mermaid-source" hidden>
flowchart TD
    A["FROM obiekty: 25 rekordów"] --> B["WHERE: tylko Islandia, 9 rekordów"]
    B --> C["GROUP BY idRodzaj: 5 grup"]
    C --> D["COUNT: liczności 4, 1, 1, 2, 1"]
    D --> E["HAVING COUNT(*) &gt; 1: zostają 2 grupy"]
    E --> F["ORDER BY idRodzaj: 10 ma 4, 14 ma 2"]
</pre>
<p class="diagram-fallback">FROM: 25 rekordów =&gt; WHERE: 9 rekordów =&gt; GROUP BY: 5 grup =&gt; COUNT =&gt; HAVING: 2 grupy =&gt; ORDER BY</p>
<figcaption>Najpierw wybieramy obiekty, potem liczymy i wybieramy grupy.</figcaption>
</figure>

## 6. HAVING z JOIN - nazwy zamiast numerów

**Problem:** wynik jest poprawny, ale odbiorca chce przeczytać nazwy rodzajów. Znajdują się one w tabeli `rodzaje`.

```sql
SELECT r.rodzaj, COUNT(o.idObiekt) AS liczbaObiektow
FROM rodzaje AS r
JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
WHERE o.panstwo = 'Islandia'
GROUP BY r.idRodzaj, r.rodzaj
HAVING COUNT(o.idObiekt) > 1
ORDER BY r.idRodzaj;
```

| rodzaj | liczbaObiektow |
| --- | ---: |
| wodospad | 4 |
| siedlisko zwierząt | 2 |

- `r` i `o` są krótkimi aliasami tabel, tak jak w poprzedniej lekcji.
- `JOIN` łączy obiekty z opisującymi je rodzajami.
- `ON r.idRodzaj = o.idRodzaj` wskazuje dopasowanie przez identyfikator rodzaju. Każdy obiekt dostaje nazwę swojego rodzaju.
- `WHERE` pozostawia obiekty z Islandii.
- `GROUP BY r.idRodzaj, r.rodzaj` tworzy grupy według identyfikatora i nazwy rodzaju. Wyświetlana nazwa jednoznacznie opisuje grupę.
- `COUNT(o.idObiekt)` liczy dopasowane identyfikatory obiektów w grupie.
- `HAVING` pozostawia grupy z liczbą większą od 1.

W porównaniu z poprzednim zapytaniem otrzymaliśmy te same liczności. Dołączyliśmy nazwy, aby wynik był czytelny. Przy tym wewnętrznym `JOIN` użycie `COUNT(*)` dałoby te same liczby.

## 7. Jeszcze dwa zastosowania

### Państwa mające co najmniej trzy obiekty

**Problem:** zamiast rodzaju grupujemy według państwa, a następnie wybieramy grupy liczące co najmniej trzy rekordy.

```sql
SELECT panstwo, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY panstwo
HAVING COUNT(*) >= 3
ORDER BY panstwo;
```

| panstwo | liczbaObiektow |
| --- | ---: |
| Islandia | 9 |
| Polska | 4 |
| Tanzania | 3 |

Zmieniła się kolumna grupująca. Bez `HAVING` otrzymalibyśmy 12 grup państw. Pozostałe dziewięć ma po jednym obiekcie, dlatego nie przechodzi warunku. Tanzania zostaje, bo `>= 3` obejmuje również dokładnie trzy obiekty.

### Rozszerzenie - rodzaje bez obiektów

Ten przykład rozwija znany z poprzedniej lekcji `LEFT JOIN`. Nie jest potrzebny do wykonania podstawowych ćwiczeń.

**Problem:** znajdź rodzaje zapisane w tabeli `rodzaje`, do których nie przypisano żadnego obiektu.

```sql
SELECT r.rodzaj, COUNT(o.idObiekt) AS liczbaObiektow
FROM rodzaje AS r
LEFT JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
GROUP BY r.idRodzaj, r.rodzaj
HAVING COUNT(o.idObiekt) = 0
ORDER BY r.idRodzaj;
```

Wynik: `rzeka => 0`.

`LEFT JOIN` zachowuje każdy rodzaj. Dla rzek nie znajduje obiektu, więc tworzy wiersz z nazwą rodzaju i wartościami `NULL` po stronie obiektu. `COUNT(o.idObiekt)` pomija `NULL`, oblicza zero i ta grupa przechodzi `HAVING`.

Porównaj oba sposoby liczenia dla tej samej grupy:

```sql
SELECT r.rodzaj, COUNT(*) AS liczbaWierszy,
       COUNT(o.idObiekt) AS liczbaObiektow
FROM rodzaje AS r
LEFT JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
GROUP BY r.idRodzaj, r.rodzaj
HAVING COUNT(o.idObiekt) = 0
ORDER BY r.idRodzaj;
```

| rodzaj | liczbaWierszy | liczbaObiektow |
| --- | ---: | ---: |
| rzeka | 1 | 0 |

`COUNT(*)` liczy także wiersz bez dopasowanego obiektu. Gdybyśmy warunek zmienili na `HAVING COUNT(*) = 0`, nie otrzymalibyśmy żadnego wiersza. Każdy rodzaj zachowany przez `LEFT JOIN` ma w wyniku połączenia co najmniej jeden wiersz. Dlatego do szukania brakujących obiektów liczymy ich identyfikatory.

## 8. Ćwiczenia samodzielne

Najpierw zapisz zapytanie samodzielnie. Otwórz podpowiedź dopiero wtedy, gdy jej potrzebujesz. Rozwiązanie i wynik są schowane osobno od podpowiedzi.

### Ćwiczenie 1 - grupy jednoosobowe

Wyświetl wartości punktów zdobyte przez dokładnie jednego turystę oraz liczność każdej grupy. Uporządkuj wynik rosnąco według punktów.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Grupuj po punktach. Warunek dotyczy liczby osób w grupie, a nie liczby punktów. Potrzebujesz porównania z jedynką.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie 1</summary>

```sql
SELECT punkty, COUNT(*) AS liczbaTurystow
FROM turysci
GROUP BY punkty
HAVING COUNT(*) = 1
ORDER BY punkty;
```

Wynik: 9 wierszy. Punkty: `4, 5, 7, 12, 21, 31, 45, 46, 51`. Każda liczność wynosi `1`.

</details>

### Ćwiczenie 2 - więcej niż dwa obiekty

Wyświetl identyfikatory rodzajów mających więcej niż dwa obiekty i ich liczności. Uporządkuj wynik według identyfikatora rodzaju.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

Korzystasz tylko z tabeli `obiekty`. Zwróć uwagę, czy treść dopuszcza grupę mającą dokładnie dwa obiekty.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie 2</summary>

```sql
SELECT idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY idRodzaj
HAVING COUNT(*) > 2
ORDER BY idRodzaj;
```

Wynik: `10 => 12`, `11 => 4`.

</details>

### Ćwiczenie 3 - państwa z co najmniej czterema obiektami

Wyświetl państwa mające co najmniej cztery obiekty i ich liczności. Uporządkuj wynik malejąco według liczby obiektów, a przy remisie rosnąco według państwa.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 3</summary>

Grupą jest państwo. „Co najmniej” obejmuje wartość graniczną. W `ORDER BY` możesz użyć aliasu obliczonej kolumny.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie 3</summary>

```sql
SELECT panstwo, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY panstwo
HAVING COUNT(*) >= 4
ORDER BY liczbaObiektow DESC, panstwo;
```

Wynik w tej kolejności: `Islandia => 9`, `Polska => 4`.

</details>

### Ćwiczenie 4 - powtarzające się wyniki od 20 punktów

Uwzględnij tylko turystów mających co najmniej 20 punktów. Wyświetl wartości punktów występujące u więcej niż jednej z tych osób oraz ich liczności. Posortuj według punktów.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 4</summary>

Są dwa warunki. Pierwszy można sprawdzić dla pojedynczego turysty. Drugi wymaga policzenia grupy. Umieść je w różnych klauzulach.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie 4</summary>

```sql
SELECT punkty, COUNT(*) AS liczbaTurystow
FROM turysci
WHERE punkty >= 20
GROUP BY punkty
HAVING COUNT(*) > 1
ORDER BY punkty;
```

Wynik: jeden wiersz `23 => 2`.

</details>

### Ćwiczenie 5 - jeden obiekt danego rodzaju w Islandii

Wyświetl identyfikatory rodzajów występujących w Islandii dokładnie raz oraz ich liczności. Sortuj według identyfikatora rodzaju. Nie licz obiektów z pozostałych państw.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 5</summary>

Najpierw ogranicz państwo przez `WHERE`. Dopiero po grupowaniu sprawdź, czy liczność wynosi jeden.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie 5</summary>

```sql
SELECT idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
WHERE panstwo = 'Islandia'
GROUP BY idRodzaj
HAVING COUNT(*) = 1
ORDER BY idRodzaj;
```

Wynik: `11 => 1`, `13 => 1`, `15 => 1`.

</details>

### Ćwiczenie 6 - rozwinięcie zadania INF.03

W [czterech zapytaniach INF.03]({{ '/03-zapytania-inf03/01-cztery-zapytania.html' | relative_url }}) ćwiczyliśmy połączenie tabel i liczenie obiektów każdego rodzaju. Rozwiń ten pomysł: wyświetl nazwy rodzajów oraz liczby obiektów tylko z Islandii, pozostawiając rodzaje mające więcej niż jeden obiekt. Kolumnę liczącą nazwij `liczbaObiektow`, a wynik uporządkuj według identyfikatora rodzaju. To ćwiczenie rozszerzające, nie dosłowna treść arkusza.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź 1 - ćwiczenie 6</summary>

Nazwy są w tabeli `rodzaje`, a państwo i identyfikatory obiektów w `obiekty`. Dopasuj tabele po identyfikatorze rodzaju.

</details>

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź 2 - ćwiczenie 6</summary>

Po wyborze państwa grupuj według identyfikatora i nazwy rodzaju. Policz identyfikatory obiektów i dopiero wtedy sprawdź liczność grupy.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie 6</summary>

```sql
SELECT r.rodzaj, COUNT(o.idObiekt) AS liczbaObiektow
FROM rodzaje AS r
JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
WHERE o.panstwo = 'Islandia'
GROUP BY r.idRodzaj, r.rodzaj
HAVING COUNT(o.idObiekt) > 1
ORDER BY r.idRodzaj;
```

Wynik: `wodospad => 4`, `siedlisko zwierząt => 2`.

</details>

### Ćwiczenie dodatkowe - brak dopasowania

Wyświetl nazwę każdego rodzaju bez przypisanych obiektów oraz liczbę tych obiektów. Wyjaśnij, dlaczego potrzebujesz `LEFT JOIN` i dlaczego nie liczysz przez `COUNT(*)`.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie dodatkowe</summary>

Zachowaj wszystkie rodzaje z lewej tabeli. Policz kolumnę identyfikatora z prawej tabeli, która przy braku dopasowania ma `NULL`.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie i wynik - ćwiczenie dodatkowe</summary>

```sql
SELECT r.rodzaj, COUNT(o.idObiekt) AS liczbaObiektow
FROM rodzaje AS r
LEFT JOIN obiekty AS o ON r.idRodzaj = o.idRodzaj
GROUP BY r.idRodzaj, r.rodzaj
HAVING COUNT(o.idObiekt) = 0
ORDER BY r.idRodzaj;
```

Wynik: `rzeka => 0`. Zwykły `JOIN` pominąłby rzekę. `COUNT(*)` policzyłby wiersz utworzony przez `LEFT JOIN`, mimo braku obiektu.

</details>

## 9. Co powinieneś umieć?

- Odróżnić warunek dotyczący rekordu od warunku dotyczącego liczności grupy.
- Wyjaśnić, dlaczego odrzucona grupa nie oznacza usunięcia danych.
- Zapisać klauzule w kolejności `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`.
- Rozróżnić „więcej niż” od „co najmniej”.
- Połączyć tabele, policzyć obiekty i wybrać grupy spełniające warunek.

Schemat myślenia:

```text
FROM / JOIN => WHERE: wybierz rekordy => GROUP BY: utwórz grupy
=> COUNT: policz => HAVING: wybierz grupy => ORDER BY: uporządkuj
```

## Materiały odniesienia

- [GROUP BY - poprzednia lekcja]({{ '/04-grupowanie-danych/01-group-by.html' | relative_url }}).
- [Baza Islandia - przygotowanie danych]({{ '/00-organizacja/01-baza-islandia.html' | relative_url }}).
- [MariaDB - GROUP BY i HAVING](https://mariadb.com/docs/server/reference/sql-statements/data-manipulation/selecting-data/group-by).
- [MariaDB - COUNT](https://mariadb.com/docs/server/reference/sql-functions/aggregate-functions/count).
