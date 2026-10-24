---
title: Lekcja 6B - WHERE i HAVING. Dwa różne warunki
---

# Lekcja 6B - WHERE i HAVING. Dwa różne warunki

W [lekcji 6A]({{ '/04-grupowanie-danych/02a-having-podstawy.html' | relative_url }}) używaliśmy `GROUP BY` do tworzenia grup. `COUNT(*)` liczył rekordy, a `HAVING` wybierał grupy.

Teraz dodamy znane już `WHERE`. Będziemy pracować w phpMyAdmin na bazie `Islandia` z pliku `baza1.sql`.

## 1. Wybierz turystów

Którzy turyści zdobyli co najmniej 20 punktów? Sprawdźmy to bez grupowania.

```sql
SELECT nick, punkty
FROM turysci
WHERE punkty >= 20
ORDER BY punkty, nick;
```

`WHERE` sprawdza punkty każdej osoby. Pozostawia tylko osoby, które mają co najmniej 20 punktów.

Wynik zawiera **7 turystów**. Ich punkty to: **21, 23, 23, 31, 45, 46, 51**.

## 2. Znajdź powtarzający się wynik

Wśród tych siedmiu osób wynik 23 występuje dwa razy. Chcemy znaleźć wyniki punktowe, które się powtarzają.

Do wyboru rekordów dodajemy grupowanie i warunek dla grup:

```sql
SELECT punkty, COUNT(*) AS liczbaTurystow
FROM turysci
WHERE punkty >= 20
GROUP BY punkty
HAVING COUNT(*) > 1
ORDER BY punkty;
```

| punkty | liczbaTurystow |
| ---: | ---: |
| 23 | 2 |

Prześledźmy wynik po kolei:

1. `WHERE` wybiera **7 turystów** z co najmniej 20 punktami.
2. `GROUP BY` tworzy **6 grup** według liczby punktów.
3. `COUNT(*)` liczy osoby w każdej grupie.
4. `HAVING` pozostawia grupy z więcej niż jedną osobą.

Została **jedna grupa**: dwie osoby mają po 23 punkty.

Grupa z 11 punktami nie powstała. `WHERE` wcześniej odrzucił obie osoby z takim wynikiem.

## 3. Dwa warunki, dwa zadania

| Część zapytania | Co robi? |
| --- | --- |
| `WHERE` | Wybiera pojedyncze rekordy. |
| `GROUP BY` | Tworzy grupy z wybranych rekordów. |
| `HAVING` | Wybiera grupy, które spełniają warunek. |
| `ORDER BY` | Ustala kolejność wyniku. |

Możesz zapamiętać ten schemat:

```text
FROM => WHERE => GROUP BY => COUNT => HAVING => ORDER BY
```

Schemat pomaga zrozumieć kolejne etapy pracy z danymi. Nie opisuje wewnętrznego sposobu wykonania zapytania przez bazę danych.

## 4. Wybierz obiekty z Islandii

Które rodzaje obiektów występują w Islandii więcej niż jeden raz? Najpierw wybieramy obiekty z Islandii, a potem liczymy je w grupach.

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

`WHERE` wybiera **9 z 25 obiektów**. `GROUP BY` tworzy z nich **5 grup rodzajów**.

`HAVING` pozostawia **2 grupy**. Pozostałe trzy mają po jednym obiekcie.

## 5. Uważaj na różnicę

`WHERE punkty > 1` sprawdza liczbę punktów jednej osoby. `HAVING COUNT(*) > 1` sprawdza liczbę osób w grupie.

Nie zastępuj drugiego warunku takim zapisem:

```sql
WHERE COUNT(*) > 1
```

To błąd. `WHERE` działa przed utworzeniem grup, więc nie może w ten sposób sprawdzić ich liczności.

## 6. Ćwiczenia

Najpierw przewidź wynik. Potem zmień wskazaną linię w zapytaniu i uruchom je w phpMyAdmin.

### Ćwiczenie 1 - zmień WHERE

Wróć do zapytania o turystów z punktu 2. Zmień `WHERE punkty >= 20` na `WHERE punkty >= 10`.

Pozostaw `HAVING COUNT(*) > 1`. Jakie grupy otrzymasz? Czy zmieni się liczba osób w grupie z 23 punktami?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Teraz do grupowania trafią także osoby z 11 punktami. Sprawdź, czy jest ich więcej niż jedna.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

```sql
SELECT punkty, COUNT(*) AS liczbaTurystow
FROM turysci
WHERE punkty >= 10
GROUP BY punkty
HAVING COUNT(*) > 1
ORDER BY punkty;
```

| punkty | liczbaTurystow |
| ---: | ---: |
| 11 | 2 |
| 23 | 2 |

Wynik ma **2 grupy**. W grupie z 23 punktami nadal są dwie osoby.

</details>

### Ćwiczenie 2 - zmień HAVING

Wróć do zapytania o obiekty Islandii z punktu 4. Zmień tylko `HAVING`, aby pozostały rodzaje z więcej niż dwoma obiektami.

Sam wybierz znak porównania. Ile grup zostanie? Co stanie się z grupą rodzaju 14?

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

„Więcej niż dwa” oznacza `> 2`. Obiekty z Islandii nadal wybiera ten sam warunek `WHERE`.

</details>

<details class="lesson-solution" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>

```sql
SELECT idRodzaj, COUNT(*) AS liczbaObiektow
FROM obiekty
WHERE panstwo = 'Islandia'
GROUP BY idRodzaj
HAVING COUNT(*) > 2
ORDER BY idRodzaj;
```

| idRodzaj | liczbaObiektow |
| ---: | ---: |
| 10 | 4 |

Zostaje **jedna grupa**. Rodzaj 14 ma dwa obiekty, więc nie spełnia warunku `> 2`.

</details>

## 7. Sprawdź, czy rozumiesz

- Co sprawdza `WHERE`, a co sprawdza `HAVING`?
- Dlaczego grupa z 11 punktami nie powstała w przykładzie z punktu 2?
- Co zmieniło się w ćwiczeniu 1 po zmianie `WHERE`?
- Co zmieniło się w ćwiczeniu 2 po zmianie `HAVING`?

`WHERE` wybiera rekordy do grupowania. `HAVING` wybiera grupy z utworzonego wyniku.
