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

**XAMPP** uruchamia potrzebne usługi na Twoim komputerze. Apache obsługuje stronę phpMyAdmin. Usługa oznaczona w panelu jako **MySQL** uruchamia serwer bazy MariaDB. W standardowej konfiguracji kursu obie usługi muszą działać, aby korzystać z phpMyAdmin.

Jeśli nie masz jeszcze bazy `Islandia`, wykonaj [instrukcję importu bazy Islandia]({{ '/00-organizacja/01-baza-islandia.html' | relative_url }}). Potem wróć tutaj.

1. Uruchom panel XAMPP.
2. Uruchom **Apache**.
3. Uruchom **MySQL**.
4. Otwórz w przeglądarce `http://localhost/phpmyadmin`.
5. Wybierz bazę **Islandia**.
6. Otwórz tabelę `turysci`.
7. Przejdź do zakładki **SQL**.

Wpiszesz tam pierwsze **zapytanie**, czyli pytanie do bazy zapisane językiem SQL. Uruchomisz je przyciskiem **Wykonaj**.

Nie musisz zapamiętywać definicji słowo w słowo. Spróbuj własnymi słowami powiedzieć, czym różni się tabela od jednego rekordu.

## Kolejność w tym dziale

1. [SQL 0A - Pierwsze zapytanie SELECT]({{ '/08-sql-od-zera/01-select-podstawy.html' | relative_url }}).
2. [SQL 0B - WHERE. Wybieramy rekordy]({{ '/08-sql-od-zera/02-where-podstawy.html' | relative_url }}).
3. [SQL 0C - Kilka warunków i LIKE]({{ '/08-sql-od-zera/03-warunki-i-like.html' | relative_url }}).
4. [SQL 0D - Sortowanie i ograniczanie wyników]({{ '/08-sql-od-zera/04-sortowanie-limit.html' | relative_url }}).
5. [SQL 0E - LIKE, NOT LIKE i znaki wzorca]({{ '/08-sql-od-zera/05-like-maski.html' | relative_url }}).
6. [SQL 0F - IN oraz NOT IN]({{ '/08-sql-od-zera/06-in-not-in.html' | relative_url }}).
7. [SQL 0G - Operatory porównania i NOT]({{ '/08-sql-od-zera/07-not-i-nierownosci.html' | relative_url }}).
8. [SQL 0H - BETWEEN i NOT BETWEEN]({{ '/08-sql-od-zera/08-between.html' | relative_url }}).
9. [SQL 0I - NULL, IS NULL i IS NOT NULL]({{ '/08-sql-od-zera/09-null.html' | relative_url }}).
10. [SQL 0J - AND, OR, NOT i kolejność warunków]({{ '/08-sql-od-zera/10-warunki-logiczne.html' | relative_url }}).
11. [SQL 0K - DISTINCT. Usuwamy powtórzenia]({{ '/08-sql-od-zera/12-distinct.html' | relative_url }}).

- [ZBIÓR ZADAŃ 1 - SELECT. 20 zadań]({{ '/08-sql-od-zera/11-zadania-select.html' | relative_url }}).

**Następny krok:** [SQL 0A - Pierwsze zapytanie SELECT]({{ '/08-sql-od-zera/01-select-podstawy.html' | relative_url }}).
