# Plan następnej lekcji - HAVING

To plan przyszłej lekcji, a nie materiał do publikacji zamiast gotowej lekcji. Nie wstawiamy jeszcze `HAVING` do lekcji o `GROUP BY`.

## Cel

Uczeń rozumie różnicę:

- `WHERE` - wybiera pojedyncze rekordy przed grupowaniem.
- `GROUP BY` - tworzy grupy rekordów.
- `HAVING` - wybiera grupy po obliczeniu wyników dla tych grup.

## Przebieg przyszłej lekcji

1. Przypomnienie: `GROUP BY punkty` i `COUNT(*)` w tabeli `turysci` - wyniki 11 grup, w tym punkty `11` i `23` po 2 osoby.
2. Pierwsze `HAVING COUNT(*) > 1` na tabeli `turysci` - wynik tylko grupy `11 => 2` i `23 => 2`.
3. To samo w tabeli `obiekty`: `GROUP BY idRodzaj HAVING COUNT(*) >= 2` - 5 grup (10, 11, 13, 14, 17).
4. Połączenie `WHERE` + `GROUP BY` + `HAVING` - wybieramy Islandię, następnie tylko rodzaje mające więcej niż 1 obiekt. Wynik: `10 => 4`, `14 => 2`.
5. Różnica `WHERE panstwo = 'Islandia'` i `HAVING COUNT(*) > 1` - przed i po grupowaniu. Jeden diagram Mermaid wystarczy.
6. Typowy błąd: `WHERE COUNT(*) > 1` - wyjaśnić, dlaczego to niepoprawne.
7. Wariant z `JOIN rodzaje` - wyświetlenie nazw rodzajów, a nie numerów, oraz filtrowanie ich liczności.
8. Ćwiczenia samodzielne w układzie: treść => podpowiedź ukryta => rozwiązanie ukryte. Podpowiedzi naprowadzają, ale nie zastępują kodu ucznia.

## Oczekiwane umiejętności

- Odróżnianie filtrowania wierszy od filtrowania grup.
- Zapisywanie `HAVING COUNT(*) > 1`.
- Poprawne umieszczanie `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY` w zapytaniu.
- Czytanie treści zadań INF.03 i wybieranie właściwej klauzuli.

## Warunki redakcyjne

- Osobny plik Markdown, nie dopisujemy `HAVING` do bieżącej lekcji.
- Używamy wyłącznie rzeczywistych danych bazy `Islandia`.
- Nie wprowadzamy nowych tabel, nie modyfikujemy `baza1.sql`.
- Prosty język, małe kroki, wyjaśnienia wyników, pojedyncze przydatne diagramy Mermaid.
- Używamy zwykłego myślnika `-`; w prostych schematach `=>`.
- Plik należy dodać do nawigacji dopiero po jego napisaniu i sprawdzeniu.
