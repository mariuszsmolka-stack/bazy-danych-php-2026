---
title: SQL 1A - Encja, atrybut i klucz główny
mermaid: true
---

# SQL 1A - Encja, atrybut i klucz główny

## Od osoby do rekordu

**Encja** to pojęcie z modelu danych. Możemy na przykład opisywać turystów. **Atrybut** mówi, jaką cechę zapisujemy: `idTurysta`, `nick` lub `punkty`.

**Wystąpienie encji** to konkretny turysta, na przykład Ewa. W relacyjnej bazie przygotowujemy **tabelę** `turysci` z kolumnami dla atrybutów. **Rekord** to jeden jej wiersz:

| idTurysta | nick | punkty |
| ---: | --- | ---: |
| 1 | Ewa | 23 |

Encja należy do modelu danych. Tabela jest strukturą w relacyjnej bazie. Są ze sobą powiązane, ale nie są tym samym pojęciem.

<figure class="lesson-diagram">
<pre class="mermaid-source" hidden>
flowchart TD
    A["Encja: Turysta"] --> B["Atrybuty"]
    B --> C["idTurysta, nick, punkty"]
    C --> D["Tabela: turysci"]
    D --> E["Rekord: 1, Ewa, 23"]
</pre>
<p class="diagram-fallback">Encja Turysta =&gt; atrybuty idTurysta, nick, punkty =&gt; tabela turysci =&gt; rekord 1 | Ewa | 23.</p>
<figcaption>Od modelu turysty do jego rekordu w tabeli.</figcaption>
</figure>

## Klucz główny

`PRIMARY KEY` jednoznacznie wskazuje rekord. Wartości klucza głównego nie mogą się powtarzać ani być `NULL`.

W bazie `Islandia` kluczami głównymi są między innymi `turysci.idTurysta`, `obiekty.idObiekt` i `rodzaje.idRodzaj`. Dzięki nim dwie osoby o tym samym nicku nadal mogą być odróżnione.

Klucz główny może składać się także z kilku kolumn. Wówczas unikalna musi być ich **kombinacja**. W tej bazie wymienione klucze mają po jednej kolumnie.

`AUTO_INCREMENT` ma inne zadanie: nadaje kolejną wartość liczbową przy dodawaniu rekordu. Sama ta właściwość nie definiuje klucza głównego. W bazie `Islandia` kolumny identyfikatorów mają oba ustawienia.

W phpMyAdmin otwórz tabelę i kartę **Struktura**. Symbol klucza przy kolumnie oraz indeks `PRIMARY` pomagają rozpoznać klucz główny. W pliku `baza1.sql` klucze są dodawane później przez `ALTER TABLE`, więc trzeba sprawdzić także tę część pliku.

## Ćwiczenia

### Ćwiczenie 1

Wskaż encję, trzy atrybuty, jedno wystąpienie i odpowiadający mu rekord z przykładu Ewy.

<details class="lesson-hint" markdown="1"><summary>Podpowiedź - ćwiczenie 1</summary>

Oddziel model turysty od pojedynczego wiersza tabeli.

</details>

<details class="lesson-solution" markdown="1"><summary>Rozwiązanie - ćwiczenie 1</summary>

Encja to Turysta, atrybuty to `idTurysta`, `nick` i `punkty`, a wystąpienie to Ewa. Jej rekord w tabeli `turysci` ma wartości `1 | Ewa | 23`.

</details>

### Ćwiczenie 2

Znajdź w phpMyAdmin klucze główne tabel `obiekty` i `rodzaje`. Co pozwalają odróżnić?

<details class="lesson-hint" markdown="1"><summary>Podpowiedź - ćwiczenie 2</summary>

Sprawdź kartę Struktura i indeks `PRIMARY`.

</details>

<details class="lesson-solution" markdown="1"><summary>Rozwiązanie - ćwiczenie 2</summary>

Są to `obiekty.idObiekt` i `rodzaje.idRodzaj`. Pierwszy wskazuje jeden obiekt, a drugi jeden rodzaj. Nazwa nie musi być unikalna.

</details>

### Ćwiczenie 3

Czy `AUTO_INCREMENT` i `PRIMARY KEY` oznaczają to samo? Wyjaśnij też, czy klucz główny zawsze musi mieć jedną kolumnę.

<details class="lesson-hint" markdown="1"><summary>Podpowiedź - ćwiczenie 3</summary>

Jedno ustawienie nadaje wartość, drugie określa sposób identyfikowania wiersza.

</details>

<details class="lesson-solution" markdown="1"><summary>Rozwiązanie - ćwiczenie 3</summary>

Nie. `AUTO_INCREMENT` nadaje kolejne liczby. `PRIMARY KEY` wymaga jednoznacznej, niepustej wartości. Klucz główny może obejmować kilka kolumn.

</details>

[Dalej: SQL 1B - Klucz obcy i relacje]({{ '/09-klucze-i-zlaczenia/02-klucz-obcy-i-relacje.html' | relative_url }}).
