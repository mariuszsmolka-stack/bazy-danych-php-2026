---
title: Baza Islandia
---

# Baza Islandia - przygotowanie do ćwiczeń

Baza ćwiczeniowa nazywa się **`Islandia`**. Korzystamy z niezmienionego pliku `baza1.sql`.

[Pobierz baza1.sql](https://raw.githubusercontent.com/mariuszsmolka-stack/bazy-danych-php-2026/main/baza/baza1.sql). Jeśli przeglądarka wyświetli tekst, zapisz go przez `Ctrl + S` jako `baza1.sql`, bez dopisywania rozszerzenia `.txt`.

## Import w phpMyAdmin

1. Uruchom Apache i MySQL w panelu XAMPP. Usługa oznaczona jako MySQL udostępnia MariaDB.
2. Otwórz `http://localhost/phpmyadmin`.
3. Utwórz pustą bazę `Islandia`, wybierając porównywanie napisów `utf8_unicode_ci`.
4. Wybierz bazę `Islandia`, następnie kartę **Import** i plik `baza1.sql`.
5. Wykonaj import i sprawdź, czy pojawiło się pięć tabel wymienionych poniżej.

Import wykonuj do pustej bazy. Plik tworzy tabele, ale nie tworzy ani nie wybiera bazy poleceniem `USE`. Historyczna nazwa w komentarzu zrzutu nie zmienia wybranej bazy. W połączeniach PHP używamy nazwy `Islandia`.

## Pięć tabel

Klucz główny jednoznacznie wskazuje wiersz tabeli. Klucz obcy odwołuje się do wiersza w innej tabeli.

| Tabela | Zawartość | Klucz główny | Klucze obce |
| --- | --- | --- | --- |
| `kontynenty` | Nazwy kontynentów (`nazwa`) | `idKontynent` | Brak |
| `rodzaje` | Rodzaje obiektów, np. wodospad lub szczyt (`rodzaj`) | `idRodzaj` | Brak |
| `obiekty` | Nazwa i opis miejsca, plik ilustracji, cecha i jej wartość oraz państwo | `idObiekt` | `idKontynent`, `idRodzaj` |
| `turysci` | Nick i punkty turysty | `idTurysta` | Brak |
| `osiagniecia` | Powiązania turystów z obiektami; w zrzucie tabela jest pusta | `idOsiagniecie` | `idTurysta`, `idObiekt` |

Wszystkie klucze główne mają `AUTO_INCREMENT`. Tabela `turysci` zawiera 13 wierszy; pierwsze trzy według `idTurysta` to Ewa (23 punkty), Monika (4) i Janek (12).

## Relacje zapisane w SQL

Strzałka prowadzi od klucza obcego do wskazywanego klucza głównego:

```text
obiekty.idKontynent  => kontynenty.idKontynent
obiekty.idRodzaj     => rodzaje.idRodzaj
osiagniecia.idTurysta => turysci.idTurysta
osiagniecia.idObiekt  => obiekty.idObiekt
```

Jeden kontynent może mieć wiele obiektów. Jeden rodzaj może opisywać wiele obiektów. Tabela `osiagniecia` łączy turystów i obiekty: turysta może mieć wiele osiągnięć, a obiekt może występować w osiągnięciach wielu turystów.

Wszystkie cztery klucze obce mają `ON DELETE NO ACTION` i `ON UPDATE NO ACTION`. Nie usuwamy ani nie zmieniamy identyfikatora wskazywanego rekordu, gdy istnieją zależne od niego rekordy. W ćwiczeniach tego etapu tylko odczytujemy dane.

## Odniesienie do INF.03

Arkusz CKE **INF.03-01-26.06-SG** (egzamin praktyczny, czerwiec 2026) dotyczy portalu turystycznego. Zadanie egzaminacyjne wykorzystuje tabele `kontynenty`, `rodzaje` i `obiekty`. Baza danych zawiera również tabele `turysci` i `osiagniecia`. W lekcji 2 ćwiczymy odczyt na tabeli `turysci`.

Arkusz podaje nazwę bazy `islandia` małymi literami. W tym kursie zgodnie z przyjętą konfiguracją używamy `Islandia`; twórz bazę i zapisuj połączenia konsekwentnie z tą samą nazwą. PDF pozostaje materiałem odniesienia i nie jest tu publikowany.
