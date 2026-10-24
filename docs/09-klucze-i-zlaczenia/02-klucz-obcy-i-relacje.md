---
title: SQL 1B - Klucz obcy i relacje
mermaid: true
---

# SQL 1B - Klucz obcy i relacje

## Dwie tabele, jeden rodzaj

Tabela `rodzaje` przechowuje nazwy rodzajów. Rekord `10 | wodospad` ma klucz główny `rodzaje.idRodzaj = 10`.

W tabeli `obiekty` kolumna `idRodzaj` jest **kluczem obcym** (`FOREIGN KEY`). Wskazuje istniejący rekord tabeli `rodzaje`. Obiekt z `idRodzaj = 10` należy więc do rodzaju `wodospad`.

| Tabela | Kolumna | Rola |
| --- | --- | --- |
| `rodzaje` | `idRodzaj` | Klucz główny. |
| `obiekty` | `idRodzaj` | Klucz obcy wskazujący ten klucz główny. |

Nie trzeba wpisywać słowa `wodospad` przy każdym obiekcie. Nazwa jest zapisana raz w tabeli `rodzaje`. Zmiana nazwy w jednym miejscu nie wymaga poprawiania wielu rekordów obiektów.

Klucz obcy może też wskazywać rekord tej samej tabeli. W bazie `Islandia` używamy tutaj połączeń między różnymi tabelami.

## Ile rekordów może być powiązanych?

- **1:1** - jednemu rekordowi odpowiada co najwyżej jeden rekord po drugiej stronie. Przykład poglądowy: osoba i jej pojedyncza karta identyfikacyjna. To nie jest relacja pokazana w bazie `Islandia`.
- **1:N** - jeden rodzaj może mieć wiele obiektów. Każdy obiekt ma dokładnie jeden `idRodzaj`.
- **N:M** - wielu turystów może odwiedzić wiele obiektów. Takie powiązania można zapisać w tabeli pośredniej `osiagniecia` przez `idTurysta` i `idObiekt`.

Tabela `osiagniecia` jest obecnie pusta. W bazie nie ma zapisanych osiągnięć.

<figure class="lesson-diagram">
<pre class="mermaid-source" hidden>
erDiagram
    RODZAJE ||--o{ OBIEKTY : "idRodzaj"
    KONTYNENTY ||--o{ OBIEKTY : "idKontynent"
    TURYSCI ||--o{ OSIAGNIECIA : "idTurysta"
    OBIEKTY ||--o{ OSIAGNIECIA : "idObiekt"
</pre>
<p class="diagram-fallback">rodzaje.idRodzaj =&gt; obiekty.idRodzaj; kontynenty.idKontynent =&gt; obiekty.idKontynent; turysci.idTurysta =&gt; osiagniecia.idTurysta; obiekty.idObiekt =&gt; osiagniecia.idObiekt.</p>
<figcaption>Powiązania tabel w bazie Islandia. Tabela osiagniecia nie zawiera jeszcze rekordów.</figcaption>
</figure>

**Integralność referencyjna** oznacza, że obowiązujący klucz obcy nie może wskazywać nieistniejącego rekordu. W `baza1.sql` ograniczenia `FOREIGN KEY` są dodawane przez `ALTER TABLE`. Dla tych połączeń zapisano `ON DELETE NO ACTION` i `ON UPDATE NO ACTION`: operacja naruszająca powiązanie nie powinna się powieść. W tej lekcji nie zmieniamy danych.

## Ćwiczenia

### Ćwiczenie 1

Wyjaśnij role obu kolumn `idRodzaj` oraz znaczenie wartości `10`.

<details class="lesson-hint" markdown="1"><summary>Podpowiedź - ćwiczenie 1</summary>

Jedna kolumna identyfikuje rodzaj, druga wskazuje go z tabeli obiektów.

</details>
<details class="lesson-solution" markdown="1"><summary>Rozwiązanie - ćwiczenie 1</summary>

`rodzaje.idRodzaj` jest kluczem głównym, a `obiekty.idRodzaj` kluczem obcym. Wartość `10` wskazuje rodzaj `wodospad`.

</details>

### Ćwiczenie 2

Podaj przykład relacji 1:N w bazie `Islandia`. Wskaż stronę „jeden” i stronę „wiele”.

<details class="lesson-hint" markdown="1"><summary>Podpowiedź - ćwiczenie 2</summary>

Spójrz na rodzaje i obiekty.

</details>
<details class="lesson-solution" markdown="1"><summary>Rozwiązanie - ćwiczenie 2</summary>

`rodzaje` to strona „jeden”, a `obiekty` to strona „wiele”. Jeden rodzaj może opisywać wiele obiektów.

</details>

### Ćwiczenie 3

Jaką rolę pełni tabela `osiagniecia`? Czy można teraz wskazać turystę z zapisanym osiągnięciem?

<details class="lesson-hint" markdown="1"><summary>Podpowiedź - ćwiczenie 3</summary>

Sprawdź, ile rekordów znajduje się w tej tabeli.

</details>
<details class="lesson-solution" markdown="1"><summary>Rozwiązanie - ćwiczenie 3</summary>

Tabela pośrednia łączy turystów z obiektami przez `idTurysta` i `idObiekt`. Ma zero rekordów, więc nie można wskazać zapisanego osiągnięcia.

</details>

[Dalej: SQL 1C - INNER JOIN]({{ '/09-klucze-i-zlaczenia/03-inner-join.html' | relative_url }}).
