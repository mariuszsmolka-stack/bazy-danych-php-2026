---
title: SQL od zera - Wprowadzenie
---

# SQL od zera - Wprowadzenie

## Uwaga dotycząca kolejności kursu

Ten dział znajduje się tymczasowo na końcu kursu. Jest przeznaczony dla osób, które dopiero zaczynają naukę baz danych i SQL.

W przyszłości dział zostanie przeniesiony na początek ścieżki nauki. Możesz korzystać z niego już teraz. Nie musisz znać PHP.

## Co przechowuje baza danych?

Baza danych przechowuje uporządkowane informacje. W bazie **Islandia** są między innymi informacje o turystach i obiektach turystycznych.

Informacje są zapisane w **tabelach**. Tabela przypomina arkusz z wierszami i kolumnami. Na początek zajrzymy tylko do tabeli `turysci`.

| idTurysta | nick | punkty |
| ---: | --- | ---: |
| 1 | Ewa | 23 |
| 2 | Monika | 4 |
| 3 | Janek | 12 |

Jeden wiersz tabeli to **rekord**. Rekord `1, Ewa, 23` opisuje jedną osobę.

Kolumna mówi, jaki rodzaj informacji zapisujemy. `idTurysta` to numer osoby, `nick` to jej nazwa, a `punkty` to zdobyta liczba punktów.

Kolumny mają określony **typ danych**. `INT` przechowuje liczbę całkowitą, na przykład `23`. `VARCHAR` przechowuje tekst o ograniczonej długości, na przykład `Ewa`.

## Gdzie będziemy pracować?

**XAMPP** pozwala uruchomić serwer bazy danych na Twoim komputerze. W jego panelu uruchom usługę oznaczoną jako **MySQL**. W tym kursie udostępnia ona bazę MariaDB.

Otwórz w przeglądarce `http://localhost/phpmyadmin`. **phpMyAdmin** to strona, na której możesz obejrzeć bazę i wpisywać polecenia SQL.

Jeśli nie masz jeszcze bazy `Islandia`, wykonaj [instrukcję importu bazy Islandia]({{ '/00-organizacja/01-baza-islandia.html' | relative_url }}). Potem wróć tutaj.

W lewej części phpMyAdmin wybierz bazę **Islandia**. Kliknij tabelę `turysci`, aby zobaczyć jej rekordy.

Na górze wybierz zakładkę **SQL**. W następnym kroku wpiszesz tam pierwsze **zapytanie**, czyli pytanie do bazy zapisane językiem SQL. Uruchomisz je przyciskiem **Wykonaj**.

Nie musisz zapamiętywać definicji słowo w słowo. Spróbuj własnymi słowami powiedzieć, czym różni się tabela od jednego rekordu.

**Następny krok:** [SQL 0A - Pierwsze zapytanie SELECT]({{ '/08-sql-od-zera/01-select-podstawy.html' | relative_url }}).
