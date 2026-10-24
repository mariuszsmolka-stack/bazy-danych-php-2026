---
title: Lekcja 6C - HAVING i JOIN. Pokazujemy nazwy rodzajów
---

# Lekcja 6C - HAVING i JOIN. Pokazujemy nazwy rodzajów

Umiemy już znaleźć rodzaje obiektów, które występują w Islandii więcej niż raz. Wynik pokazuje jednak numery rodzajów. Jak zastąpić je nazwami, które zrozumie czytelnik?

W [lekcji 5C]({{ '/04-grupowanie-danych/01c-group-by-i-join.html' | relative_url }}) poznaliśmy `JOIN`, a w [lekcji 6B]({{ '/04-grupowanie-danych/02b-where-i-having.html' | relative_url }}) połączyliśmy `WHERE` z `HAVING`. Teraz użyjemy tych samych instrukcji razem.

Pracuj w phpMyAdmin na bazie `Islandia` z pliku `baza1.sql`.

## 1. Wynik z numerami

Które rodzaje obiektów występują w Islandii więcej niż jeden raz? Zacznijmy od znanego zapytania.

```sql
SELECT idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
WHERE panstwo = 'Islandia'
GROUP BY idRodzaj
HAVING COUNT(*) > 1
ORDER BY idRodzaj;
```

| idRodzaj | liczbaObiektow |
| ---: | ---: |
| 10 | 4 |
| 14 | 2 |

Wynik jest poprawny, ale zamiast nazw widzimy numery. Jak pokazać nazwy **wodospad** i **siedlisko zwierząt**?

## 2. Dołącz nazwy rodzajów

Tabela `obiekty` zawiera `idRodzaj`. Tabela `rodzaje` zawiera ten sam identyfikator i nazwę w kolumnie `rodzaj`.

Połączmy te tabele przez `idRodzaj`. Pozostałe warunki nadal odpowiadają na to samo pytanie.

```sql
SELECT r.rodzaj,
       COUNT(o.idObiekt) AS liczbaObiektow
FROM rodzaje AS r
JOIN obiekty AS o
ON r.idRodzaj = o.idRodzaj
WHERE o.panstwo = 'Islandia'
GROUP BY r.idRodzaj, r.rodzaj
HAVING COUNT(o.idObiekt) > 1
ORDER BY r.idRodzaj;
```

| rodzaj | liczbaObiektow |
| --- | ---: |
| wodospad | 4 |
| siedlisko zwierząt | 2 |

Teraz wynik pokazuje nazwy. Liczby obiektów są takie same jak w poprzednim zapytaniu.

Prześledź kolejne kroki:

1. `JOIN` łączy obiekty z nazwami ich rodzajów.
2. `WHERE` wybiera **9 obiektów** z Islandii.
3. `GROUP BY` tworzy **5 grup** rodzajów.
4. `COUNT` liczy obiekty w każdej grupie.
5. `HAVING` pozostawia **2 grupy** z więcej niż jednym obiektem.

## 3. Jak czytać zapytanie?

`r` oznacza tabelę `rodzaje`, a `o` oznacza tabelę `obiekty`. Dzięki temu możemy napisać krótko `r.rodzaj` i `o.panstwo`.

`ON r.idRodzaj = o.idRodzaj` wskazuje, które wiersze połączyć. Każdy obiekt otrzymuje nazwę swojego rodzaju.

`GROUP BY r.idRodzaj, r.rodzaj` tworzy grupy według identyfikatora i jego nazwy. W wyniku możemy wyświetlić nazwę grupy.

`COUNT(o.idObiekt)` liczy obiekty w każdej grupie. Przy tym zwykłym `JOIN` zapis `COUNT(*)` dałby takie same liczby.

## 4. Ćwiczenie 1 - dokładnie jeden obiekt

Wróć do zapytania z punktu 2. Pokaż nazwy rodzajów, które mają w Islandii **dokładnie jeden obiekt**.

Zmień tylko warunek `HAVING`. Sam wybierz znak porównania. Przewidź liczbę grup i sprawdź wynik w phpMyAdmin.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Porównaj `COUNT(o.idObiekt)` z liczbą `1`. Warunek `WHERE` nadal ma wybierać Islandię.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

```sql
SELECT r.rodzaj,
       COUNT(o.idObiekt) AS liczbaObiektow
FROM rodzaje AS r
JOIN obiekty AS o
ON r.idRodzaj = o.idRodzaj
WHERE o.panstwo = 'Islandia'
GROUP BY r.idRodzaj, r.rodzaj
HAVING COUNT(o.idObiekt) = 1
ORDER BY r.idRodzaj;
```

| rodzaj | liczbaObiektow |
| --- | ---: |
| szczyt | 1 |
| wulkan | 1 |
| gorące źródło | 1 |

Wynik ma **3 grupy**. Każda zawiera jeden obiekt z Islandii.

</details>

## 5. Ćwiczenie 2 - inne państwo

Wróć do podstawowego zapytania z punktu 2. Zamiast Islandii wybierz **Polskę**.

Zmień tylko `WHERE`. Pozostaw `HAVING COUNT(o.idObiekt) > 1`. Jakie rodzaje pozostaną w wyniku?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

W warunku `WHERE o.panstwo = 'Islandia'` zmień tylko nazwę państwa. W tabeli są cztery obiekty z Polski.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

```sql
SELECT r.rodzaj,
       COUNT(o.idObiekt) AS liczbaObiektow
FROM rodzaje AS r
JOIN obiekty AS o
ON r.idRodzaj = o.idRodzaj
WHERE o.panstwo = 'Polska'
GROUP BY r.idRodzaj, r.rodzaj
HAVING COUNT(o.idObiekt) > 1
ORDER BY r.idRodzaj;
```

| rodzaj | liczbaObiektow |
| --- | ---: |
| wodospad | 4 |

Wynik ma **jedną grupę**. Wszystkie cztery obiekty z Polski są wodospadami.

</details>

## 6. Co warto umieć?

Potrafisz wyjaśnić, skąd pochodzi nazwa rodzaju? Która część zapytania wybiera państwo, a która wybiera grupy według ich liczności?

`JOIN` daje nam nazwę z drugiej tabeli. `GROUP BY` tworzy grupy, a `HAVING` pozostawia te, które spełniają warunek.
