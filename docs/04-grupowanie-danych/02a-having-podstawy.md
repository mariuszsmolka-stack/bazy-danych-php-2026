---
title: Lekcja 6A - HAVING. Które grupy chcemy zobaczyć?
---

# Lekcja 6A - HAVING. Które grupy chcemy zobaczyć?

W [lekcji 5A]({{ '/04-grupowanie-danych/01a-group-by-podstawy.html' | relative_url }}) tworzyliśmy grupy przez `GROUP BY`. Za pomocą `COUNT(*)` liczyliśmy osoby w każdej grupie.

Teraz wybierzemy tylko te grupy, które nas interesują. Wykonuj zapytania w phpMyAdmin na bazie `Islandia` z pliku `baza1.sql`.

## 1. Ile osób ma tyle samo punktów?

Najpierw zobaczmy liczbę turystów dla każdej liczby punktów.

```sql
SELECT punkty, COUNT(*) AS liczbaTurystow
FROM turysci
GROUP BY punkty
ORDER BY punkty;
```

Wynik zawiera **11 grup**. Dwie z nich wyglądają tak:

| punkty | liczbaTurystow |
| ---: | ---: |
| 11 | 2 |
| 23 | 2 |

Każda z pozostałych dziewięciu grup zawiera jedną osobę. W tabeli nadal jest **13 turystów**.

## 2. Wybierz grupy większe niż jedna osoba

Chcemy zobaczyć tylko grupy z więcej niż jedną osobą. Nie musimy przeglądać wszystkich 11 grup.

Do poprzedniego zapytania dodajemy jedną linię:

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

`GROUP BY` utworzył 11 grup. `COUNT(*)` policzył osoby w każdej z nich.

`HAVING COUNT(*) > 1` oznacza: pozostaw grupy z więcej niż jedną osobą. Dlatego w wyniku zostały **2 grupy**.

## 3. Co stało się z pozostałymi grupami?

Przed dodaniem `HAVING` wynik miał 11 grup. Po dodaniu warunku pokazuje tylko 2 grupy.

Pozostałe grupy nie spełniają warunku, więc nie pojawiają się w wyniku. `HAVING` nie usuwa rekordów z bazy. Tabela `turysci` nadal zawiera 13 osób.

## 4. Czym różnią się WHERE i HAVING?

`WHERE` wybiera pojedyncze rekordy. `HAVING` wybiera całe grupy po ich utworzeniu.

Nie łączymy jeszcze `WHERE` i `HAVING` w jednym zapytaniu. Zrobimy to później.

## 5. Ćwiczenia

Najpierw przewidź wynik. Potem zmień zapytanie i uruchom je w phpMyAdmin.

### Ćwiczenie 1 - grupy jednoosobowe

Wróć do zapytania z punktu 2. Zmień warunek `HAVING`, aby pokazać grupy z dokładnie jedną osobą.

Sam wybierz znak porównania. Ile grup otrzymasz?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Liczba osób w grupie ma być równa `1`.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

```sql
SELECT punkty, COUNT(*) AS liczbaTurystow
FROM turysci
GROUP BY punkty
HAVING COUNT(*) = 1
ORDER BY punkty;
```

Wynik ma **9 grup**. W każdej `liczbaTurystow` wynosi **1**.

</details>

### Ćwiczenie 2 - rodzaje z co najmniej dwoma obiektami

W tabeli `obiekty` wybierz rodzaje, do których należą co najmniej dwa obiekty. Wykorzystaj znane grupowanie według `idRodzaj`:

```sql
SELECT idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
GROUP BY idRodzaj
ORDER BY idRodzaj;
```

Dodaj do tego zapytania warunek `HAVING`. Umieść go przed `ORDER BY`.

Przewidź liczbę grup. Potem sprawdź wynik w phpMyAdmin.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

„Co najmniej dwa” oznacza liczbę większą lub równą `2`. Sprawdź wynik `COUNT(*)` dla każdej grupy.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

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

Wynik ma **5 grup**. Każda ma co najmniej dwa obiekty.

</details>

`GROUP BY` tworzy grupy, a `HAVING` wybiera te, które spełniają warunek. Zmienia się wynik zapytania, nie dane w tabeli.

Więcej przykładów znajdziesz w [pełnym opracowaniu HAVING]({{ '/04-grupowanie-danych/02-having.html' | relative_url }}).
