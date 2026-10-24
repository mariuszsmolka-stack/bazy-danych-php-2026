---
title: Lekcja 5A - GROUP BY. Tworzymy grupy i liczymy rekordy
---

# Lekcja 5A - GROUP BY. Tworzymy grupy i liczymy rekordy

W tej lekcji podzielisz rekordy na grupy.

Potem policzysz rekordy w każdej grupie.

Pracuj w phpMyAdmin na bazie `Islandia` z pliku `baza1.sql`.

Uruchamiaj zapytania pojedynczo w zakładce SQL.

## 1. Spójrz na punkty turystów

| Turysta | Punkty |
| --- | ---: |
| Ewa | 23 |
| Paula | 23 |
| Monika | 4 |

Ewa i Paula mają tyle samo punktów.

Należą do jednej grupy.

Monika ma 4 punkty.

Należy do innej grupy.

## 2. Zobacz wszystkie liczby punktów

Najpierw wyświetl punkty wszystkich turystów:

```sql
SELECT punkty
FROM turysci
ORDER BY punkty;
```

Wynik ma **13 wierszy**.

Liczby `11` i `23` występują po dwa razy.

## 3. Utwórz grupy

Dodaj `GROUP BY punkty`:

```sql
SELECT punkty
FROM turysci
GROUP BY punkty
ORDER BY punkty;
```

Teraz wynik ma **11 wierszy**.

Każda liczba punktów pojawia się tylko raz:

`4, 5, 7, 11, 12, 21, 23, 31, 45, 46, 51`

`GROUP BY punkty` tworzy grupę dla każdej liczby punktów.

Każda grupa daje jeden wiersz wyniku.

Dlaczego grup jest 11, a turystów 13?

Liczba `11` występuje dwa razy, ale tworzy jedną grupę.

Tak samo jest z liczbą `23`.

Rekordy nie zniknęły z tabeli.

Zmienił się tylko wynik zapytania.

## 4. Policz turystów w każdej grupie

Dodaj `COUNT(*)`:

```sql
SELECT punkty, COUNT(*) AS liczbaTurystow
FROM turysci
GROUP BY punkty
ORDER BY punkty;
```

`GROUP BY` tworzy grupy.

`COUNT(*)` liczy rekordy w każdej grupie.

`AS liczbaTurystow` nadaje nazwę kolumnie z liczbą osób.

Zobacz część wyniku:

| punkty | liczbaTurystow |
| ---: | ---: |
| 4 | 1 |
| 11 | 2 |
| 23 | 2 |

Wiersz `23 | 2` oznacza, że dwie osoby mają po 23 punkty.

Jeden wiersz wyniku opisuje jedną grupę.

Wynik nadal ma **11 wierszy**, bo jest 11 grup.

## 5. Najpierw wybierz rekordy, potem je pogrupuj

W tabeli `obiekty` są obiekty z różnych państw.

Podzielmy je według kolumny `idRodzaj`:

```sql
SELECT idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
WHERE panstwo = 'Islandia'
GROUP BY idRodzaj
ORDER BY idRodzaj;
```

Najpierw `WHERE` wybiera obiekty z Islandii.

Potem `GROUP BY` tworzy grupy rodzajów.

Na końcu `COUNT(*)` liczy obiekty w każdej grupie.

Wynik ma **5 grup**.

Liczby obiektów w tych grupach dają razem **9**.

## 6. Sprawdź samodzielnie

W każdym ćwiczeniu najpierw przewidź wynik.

Potem uruchom wskazane zapytanie w phpMyAdmin.

Na końcu porównaj wynik z przewidywaniem.

### Ćwiczenie 1 - ile będzie grup?

Zapytanie z punktu 2 pokazuje 13 wierszy.

Ile wierszy pokaże zapytanie z punktu 3? Dlaczego?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź</summary>

Sprawdź, które liczby punktów się powtarzają.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie</summary>

Wynik ma 11 wierszy. Liczby `11` i `23` występują po dwa razy. Każda z nich tworzy jedną grupę.

</details>

### Ćwiczenie 2 - ilu turystów ma 23 punkty?

Przewidź wartość `liczbaTurystow` dla 23 punktów.

Sprawdź ją zapytaniem z punktu 4.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź</summary>

Spójrz na punkty Ewy i Pauli.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie</summary>

Wartość wynosi 2. Ewa i Paula mają po 23 punkty.

</details>

### Ćwiczenie 3 - ile grup obiektów powstanie?

Przewidź liczbę grup dla obiektów z Islandii.

Sprawdź ją zapytaniem z punktu 5.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź</summary>

W wyniku jeden wiersz odpowiada jednej wartości `idRodzaj`.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie</summary>

Powstaje 5 grup. Obejmują razem 9 obiektów z Islandii.

</details>

Więcej przykładów znajdziesz w [pełnym opracowaniu GROUP BY]({{ '/04-grupowanie-danych/01-group-by.html' | relative_url }}).
