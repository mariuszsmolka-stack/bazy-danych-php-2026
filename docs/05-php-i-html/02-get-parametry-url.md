---
title: Lekcja 9 - PHP i GET - parametry w adresie URL
---

# Lekcja 9 - PHP i GET - parametry w adresie URL

Jeśli dopiero poznajesz parametry w adresie, zacznij od [lekcji 9A]({{ '/05-php-i-html/02a-get-podstawy.html' | relative_url }}).

W [lekcji 9B]({{ '/05-php-i-html/02b-get-rekord-z-bazy.html' | relative_url }}) zobaczysz, jak numer z adresu wybiera jeden rekord z MariaDB.

Jak sprawić, żeby ten sam plik pokazywał raz gejzer, a raz wodospad? Przekażemy numer obiektu w adresie. Cel lekcji: wyjaśnić i uruchomić drogę **kliknięcie linku => parametr id => SELECT => szczegóły obiektu**.

Korzystamy z bazy `Islandia` oraz umiejętności z [lekcji 8]({{ '/05-php-i-html/01-generowanie-html-z-bazy.html' | relative_url }}). Najpierw wykonaj część A. Część B dodaje listę linków do tego samego programu.

## Część A - podstawowa, obowiązkowa

### 1. Adres przekazuje informację

`http://localhost/kurs-php/obiekt.php?id=46`

Czytaj go: „Otwórz stronę obiekt.php i przekaż jej informację, że interesuje mnie obiekt numer 46”.

| Fragment | Znaczenie |
| --- | --- |
| `obiekt.php` | Nazwa pliku PHP |
| `?` | Początek parametrów adresu |
| `id` | Nazwa parametru |
| `=` | Oddziela nazwę od wartości |
| `46` | Wartość parametru |

Porównaj adresy `obiekt.php?id=46`, `obiekt.php?id=47` i `obiekt.php?id=52`. Za każdym razem uruchamiany jest **ten sam plik**, ale otrzymuje inną wartość. Parametr jest widoczny w pasku adresu i użytkownik może go zmienić.

**Przewidź:** jaki plik zostanie uruchomiony dla `obiekt.php?id=47`? Co zmieniono względem pierwszego adresu? Na razie nie łączymy się z bazą.

### 2. PHP udostępnia tablicę $_GET

PHP automatycznie umieszcza parametry adresu w tablicy asocjacyjnej `$_GET`. Znasz już klucze tablic: tutaj `id` jest kluczem, a wartość pochodzi z adresu. Odczyt zapisujemy jako `$_GET["id"]`. Dla `?id=46` jest to tekst `"46"`, jeszcze nie sprawdzona liczba.

Ten mały przykład uruchom **z podanym pojedynczym parametrem**, np. `?id=46`:

```php
<?php
echo htmlspecialchars($_GET["id"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
?>
```

Przeglądarka pokaże `46`. Znana z lekcji 8 funkcja `htmlspecialchars()` zapewnia, że wartość wyświetlamy jako tekst, a nie kod HTML. Ten fragment pokazuje sam odczyt przy podanym parametrze. Za chwilę dodamy sprawdzenia, aby obsłużyć też inne adresy.

**Ćwiczenie 1 - parametr w adresie.** Zapisz fragment jako `C:\xampp\htdocs\kurs-php\obiekt.php`. Włącz Apache w XAMPP. Otwórz kolejno `http://localhost/kurs-php/obiekt.php?id=46` oraz ten sam adres z `id=47`. Przewidź wynik przed odświeżeniem.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 1</summary>

Nie zmieniaj pliku. Zmień tylko liczbę po `id=` w pasku adresu.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 1</summary>

Dla `?id=46` otrzymasz `46`, dla `?id=47` otrzymasz `47`. Ten sam odczyt `$_GET["id"]` korzysta z wartości bieżącego żądania.

</details>

### 3. isset() - czy parametr został przekazany?

Co się stanie, jeśli ktoś otworzy samo `obiekt.php`? Klucz `id` nie będzie istniał. Bez sprawdzenia jego odczyt spowoduje ostrzeżenie PHP. Najpierw sprawdź obecność:

```php
<?php
if (isset($_GET["id"])) {
    echo "Parametr id został przekazany.";
} else {
    echo "Brakuje parametru id.";
}
```

`isset()` sprawdza, czy wartość istnieje i jest różna od `null`. Dla `?id=46` wykona się pierwsza gałąź; bez parametru druga. **Obecność nie oznacza poprawności:** `?id=abc` i `?id=` również spełniają ten test. Nie wiemy jeszcze, czy otrzymaliśmy poprawny identyfikator.

### 4. Ćwiczenie 2 - wartość albo komunikat

W swoim `obiekt.php` połącz odczyt z kontrolą obecności. W rozwiązaniu znajdziesz również gotowy wzorzec techniczny `is_string()`, który sprawdza, czy otrzymaliśmy pojedynczy tekst; nie musisz go samodzielnie budować. Dla `?id=46` oraz `?id=47` pokaż wartość, a bez `id` komunikat. Nie używaj jeszcze bazy.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 2</summary>

W gałęzi udanego `isset()` umieść odczyt z kroku 2. W `else` zostaw komunikat o braku parametru.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 2</summary>


```php
<?php
if (isset($_GET["id"])) {
    if (is_string($_GET["id"])) {
        echo htmlspecialchars($_GET["id"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    } else {
        echo "Oczekiwano pojedynczej wartości id.";
    }
} else {
    echo "Brakuje parametru id.";
}
?>
```

W tym rozwiązaniu `is_string()` jest gotową kontrolą: pozwala wyświetlić pojedynczy tekst. Skopiuj ją wraz z kodem. Na razie skup się na dwóch drogach: parametr jest obecny => pokazujemy wartość; parametru nie ma => pokazujemy komunikat. Szczegóły dodatkowej kontroli znajdują się w części B.


</details>

Po tym ćwiczeniu umiesz rozróżnić brak parametru od przekazanej wartości. Dopiero teraz użyjemy wartości do wyboru rekordu.

### 5. Parametr wskazuje rekord

Znasz zapytanie ze stałą liczbą:

```sql
SELECT nazwa, panstwo, opis
FROM obiekty
WHERE idObiekt = 46;
```

W kursowej bazie otrzymamy Strokkur. Teraz liczbę wybierze użytkownik przez adres:

`obiekt.php?id=46 => idObiekt = 46 => Strokkur`

`id` jest nazwą parametru adresu, a `idObiekt` nazwą kolumny tabeli. Nie muszą nazywać się tak samo. PHP połączy te dwa miejsca przez zmienną `$idObiekt`.

| Parametr | Obiekt w bazie | Państwo |
| --- | --- | --- |
| `id=46` | Strokkur | Islandia |
| `id=47` | Skogafoss | Islandia |
| `id=52` | Hekla | Islandia |

**Mały krok:** wskaż część zapytania SQL, która musi się zmienić, aby pobrać Heklę. Pozostałe kolumny i tabela pozostają takie same.

### 6. Najpierw sprawdź identyfikator

Użytkownik może wpisać dowolny adres. Dlatego przed SQL stosujemy gotowy wzorzec:

```php
$idObiekt = filter_input(INPUT_GET, "id", FILTER_VALIDATE_INT);
```

Ta instrukcja odczytuje `id` z adresu i sprawdza, czy jest liczbą całkowitą. Traktuj `filter_input()` wraz z argumentami jako gotowy wzorzec, nie materiał do zapamiętania. Nasz cel: przepuścić do zapytania tylko poprawny numer obiektu.

Poniższy gotowy blok sprawdza brak parametru, poprawność liczby oraz to, czy jest większa od zera. Skopiuj go w całości; jego szczegóły omówimy w części B:

```php
$idObiekt = filter_input(INPUT_GET, "id", FILTER_VALIDATE_INT);
if ($idObiekt === null) {
    exit("Brakuje parametru id.");
}
if ($idObiekt === false || $idObiekt <= 0) {
    exit("Niepoprawny identyfikator.");
}
```

Jeśli brakuje parametru albo numer jest niepoprawny, blok pokazuje komunikat i kończy program. Dopiero poprawna dodatnia liczba pozwala przejść dalej. Nie musisz jeszcze analizować każdego operatora - sprawdź działanie na adresach z tabeli.

| Adres | Co otrzymaliśmy? | Decyzja |
| --- | --- | --- |
| Bez `id` | Brak parametru | Komunikat o braku parametru |
| `?id=abc` | Tekst zamiast liczby | Niepoprawny identyfikator |
| `?id=-1` | Liczba -1 | Niepoprawny identyfikator |
| `?id=0` | Liczba 0 | Niepoprawny identyfikator |
| `?id=46` | Liczba 46 | Można wykonać SELECT |
| `?id=999` | Liczba 999 | Można wykonać SELECT; rekordu może nie być |

Dopiero **po przejściu obu kontroli** budujemy zapytanie:

```php
$zapytanie = "SELECT nazwa, panstwo, opis FROM obiekty WHERE idObiekt = " . $idObiekt;
```

W tym jednym wzorcu do SQL trafia wyłącznie zweryfikowana dodatnia liczba całkowita. Nigdy nie wstawiaj surowego `$_GET["id"]` do SQL. `htmlspecialchars()` służy do wyświetlania HTML, nie do ochrony zapytań. W tym przykładzie bezpieczeństwo zapytania zależy od wcześniejszego sprawdzenia numeru.

### 7. Jeden program szczegółów - obiekt.php

Zastąp dotychczasowy mały przykład poniższym programem. Początkowe kontrole i obsługa błędów są przygotowanym wzorcem technicznym. Nie pisz ich od nowa. Śledź przede wszystkim drogę: `$idObiekt` => warunek SELECT => `$rekord` => wyświetlany obiekt. Uruchom Apache i MariaDB, przygotuj bazę `Islandia` z `baza/baza1.sql`. Zapisz plik w UTF-8 w tym samym katalogu `C:\xampp\htdocs\kurs-php`. Używaj adresu `http://localhost/kurs-php/obiekt.php?id=46`, nie ścieżki pliku na dysku.

Konto `root` bez hasła jest przeznaczone wyłącznie do lokalnego stanowiska XAMPP. GitHub Pages publikuje tę lekcję, ale nie wykonuje PHP.

```php
<?php
$idObiekt = filter_input(INPUT_GET, "id", FILTER_VALIDATE_INT);
if ($idObiekt === null) {
    exit("Brakuje parametru id.");
}
if ($idObiekt === false || $idObiekt <= 0) {
    exit("Niepoprawny identyfikator.");
}
mysqli_report(MYSQLI_REPORT_OFF);
$polaczenie = mysqli_connect("localhost", "root", "", "Islandia");
if (!$polaczenie) {
    exit("Nie udało się połączyć z bazą.");
}
if (!mysqli_set_charset($polaczenie, "utf8mb4")) {
    mysqli_close($polaczenie);
    exit("Nie udało się ustawić kodowania.");
}
$zapytanie = "SELECT nazwa, panstwo, opis FROM obiekty WHERE idObiekt = " . $idObiekt;
$wynik = mysqli_query($polaczenie, $zapytanie);
if (!$wynik) {
    mysqli_close($polaczenie);
    exit("Nie udało się wykonać zapytania.");
}
$rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC);
mysqli_close($polaczenie);
if ($rekord === false) {
    exit("Nie udało się odczytać rekordu.");
}
if ($rekord === null) {
    exit("Nie znaleziono obiektu.");
}
?>
<!doctype html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Szczegóły obiektu</title>
</head>
<body>
<?php
echo "<h1>" . htmlspecialchars($rekord["nazwa"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8") . "</h1>";
echo "<p>Państwo: " . htmlspecialchars($rekord["panstwo"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8") . "</p>";
echo "<p>" . htmlspecialchars($rekord["opis"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8") . "</p>";
?>
</body>
</html>
```

Czytaj program od góry:

1. Sprawdzenie parametru kończy pracę dla brakującej lub niepoprawnej wartości.
2. Znany z lekcji 8 blok łączy z bazą i ustawia `utf8mb4`. `MYSQLI_REPORT_OFF` oznacza, że sami sprawdzamy powodzenie operacji.
3. `mysqli_query()` wykonuje SELECT z poprawną liczbą. Niepowodzenie kończy pracę po zamknięciu połączenia.
4. `mysqli_fetch_array(..., MYSQLI_ASSOC)` pobiera jeden rekord z kluczami `nazwa`, `panstwo`, `opis`. Nie potrzebujemy pętli: szukamy po unikalnym identyfikatorze.
5. Po pobraniu zamykamy połączenie. Tablica `$rekord` nadal jest dostępna w PHP. Gotowe kontrole zatrzymują program, gdy odczyt się nie udał lub obiektu nie znaleziono.
6. `htmlspecialchars()` przygotowuje każdą wartość tekstową do HTML. Zachowaj podane argumenty; nie musisz ich teraz zapamiętywać. Nagłówek pokazuje nazwę, a akapity państwo i opis.

Wszystkie kontrole są przed dokumentem HTML, więc zakończenie po błędzie nie zostawia otwartych elementów strony. Dla `46` zobaczysz nagłówek Strokkur, państwo Islandia i opis gejzeru z bazy.

**Poprawny identyfikator nie daje automatycznie prawa dostępu do rekordu.** W tej bazie ćwiczeniowej pokazujemy wyłącznie publiczne informacje turystyczne.

#### Ćwiczenie 3 - trzy obiekty

Korzystając z programu wyjściowego, otwórz adresy z `id=46`, `id=47` i `id=52`. Zapisz nazwę, państwo i sprawdź zmianę opisu. Nie zmieniaj programu.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 3</summary>

Zmienia się tylko liczba w adresie. SQL korzysta ze zmiennej `$idObiekt`.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 3</summary>

Otrzymasz kolejno Strokkur, Skogafoss i Heklę. Wszystkie trzy mają państwo Islandia, ale różne opisy: gejzeru, wodospadu i wulkanu. To ten sam plik i te same trzy instrukcje wyświetlania.

</details>

#### Ćwiczenie 4 - błędna wartość czy brak rekordu?

Sprawdź samo `obiekt.php`, a potem `?id=abc`, `?id=-1` i `?id=999`. Przewidź, które adresy dotrą do zapytania SQL. Nie usuwaj żadnych danych z bazy.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 4</summary>

Oddziel sprawdzenie liczby od szukania rekordu. `999` jest dodatnią liczbą, choć nie występuje w kursowej tabeli.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 4</summary>

| Adres | Komunikat | Czy wykonano SELECT? |
| --- | --- | --- |
| Bez parametru | Brakuje parametru id. | Nie |
| `?id=abc` | Niepoprawny identyfikator. | Nie |
| `?id=-1` | Niepoprawny identyfikator. | Nie |
| `?id=999` | Nie znaleziono obiektu. | Tak, jeśli połączenie i zapytanie się powiodły |

Niepoprawna wartość jest odrzucana przed bazą. Poprawna liczba bez rekordu daje poprawny, ale pusty wynik SELECT.

</details>

## Część B - rozszerzenie

Przejdź tutaj po wykonaniu czterech ćwiczeń części A. Program `obiekt.php` już działa; dodamy do niego wejście przez listę linków.

### Gotowe kontrole z części A - jak działają?

Do wykonania ćwiczeń podstawowych wystarczyło korzystać z przygotowanych kontroli. Teraz możesz przyjrzeć się ich szczegółom.

**Pojedynczy tekst czy tablica?** Zwykłe `?id=46` daje tekst. Nietypowy zapis `?id[]=46` przekazuje tablicę. `is_string()` w rozwiązaniu ćwiczenia 2 sprawdza, czy wartość jest tekstem, zanim przekażemy ją do `htmlspecialchars()`. Dzięki temu tablica nie trafia do funkcji oczekującej tekstu. Ta kontrola nie sprawdza jeszcze, czy tekst jest poprawnym numerem.

**Jak działa walidacja numeru?** W `filter_input(INPUT_GET, "id", FILTER_VALIDATE_INT)` pierwszy argument wskazuje parametry adresu, drugi nazwę `id`, a trzeci sprawdzenie liczby całkowitej. W użytym wzorcu funkcja zwraca liczbę po udanej walidacji, `null` przy braku parametru i `false` dla niepoprawnej wartości, w tym tablicy. Potem osobno odrzucamy liczby mniejsze od 1.

- `===` porównuje wartość i typ, więc odróżnia `false`, `null` i liczbę `0`.
- `||` oznacza „lub”: wystarczy nieudana walidacja albo liczba nie większa od zera, aby odrzucić parametr.
- `exit()` wyświetla komunikat i kończy wykonywanie programu. Dlatego błędny parametr nie dociera do SQL.

Przy odczycie wyniku `mysqli_fetch_array()` wartości te mają inne znaczenie: `null` oznacza brak kolejnego rekordu, a `false` błąd odczytu. Sprawdzamy je dopiero po udanym zapytaniu.

**Dwie różne kontrole bezpieczeństwa.** Walidacja dopuszcza do naszego SQL tylko dodatnią liczbę całkowitą. `htmlspecialchars()` przygotowuje tekst do HTML i nie zabezpiecza SQL. Ogólnym rozwiązaniem dla wartości przekazywanych do SQL są zapytania parametryzowane; nie wprowadzamy tutaj nowej rodziny funkcji, aby nie przesłonić tematu GET. Zachowaj cały wzorzec walidacji, a nie tylko rzutowanie wartości na liczbę.

### 8. Zwykły link zamiast ręcznego wpisywania adresu

```html
<a href="obiekt.php?id=46">Strokkur</a>
```

`href` wskazuje adres docelowy, a tekst między znacznikami to widoczna nazwa linku. Kliknięcie wywołuje `obiekt.php` z parametrem `id=46`. Względny adres szuka pliku w tym samym katalogu.

Oba pliki lokalne będą w `C:\xampp\htdocs\kurs-php`: `lista_obiektow.php` i `obiekt.php`. Otwieraj listę pod `http://localhost/kurs-php/lista_obiektow.php`.

### 9. PHP tworzy link dla każdego rekordu

Najpierw pobierz identyfikator i nazwę:

```sql
SELECT idObiekt, nazwa FROM obiekty
WHERE panstwo = 'Islandia' ORDER BY idObiekt;
```

W znanej pętli z lekcji 8 połączymy numer z adresem, a nazwę wyświetlimy jako tekst:

```php
echo "<ul>";
while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
    $idObiekt = (int)$rekord["idObiekt"];
    $nazwa = htmlspecialchars($rekord["nazwa"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    echo '<li><a href="obiekt.php?id=' . $idObiekt . '">' . $nazwa . '</a></li>';
}
echo "</ul>";
```

`idObiekt` pochodzi z całkowitoliczbowej kolumny bazy; `(int)` zapewnia zapis liczby w adresie. Nazwę kodujemy do HTML. Apostrofy w `echo` otaczają tekst PHP, a cudzysłowy wewnątrz są częścią atrybutu `href`. Kropki sklejają trzy części: początek linku, numer i jego dalszą część z nazwą.

Dla pierwszego rekordu powstanie:

```html
<li><a href="obiekt.php?id=46">Strokkur</a></li>
```

Następny rekord utworzy link Skogafoss z `id=47`. **Jedna iteracja => jeden link.** Nie budujemy nazw tabel ani parametrów tekstowych z adresu.

Poniżej kompletny program listy. To drugi plik aplikacji, nie nowa wersja pliku szczegółów. Zapisz go jako `lista_obiektow.php`:

```php
<?php
mysqli_report(MYSQLI_REPORT_OFF);
$polaczenie = mysqli_connect("localhost", "root", "", "Islandia");
if (!$polaczenie) {
    exit("Nie udało się połączyć z bazą.");
}
if (!mysqli_set_charset($polaczenie, "utf8mb4")) {
    mysqli_close($polaczenie);
    exit("Nie udało się ustawić kodowania.");
}
$zapytanie = "SELECT idObiekt, nazwa FROM obiekty WHERE panstwo = 'Islandia' ORDER BY idObiekt;";
$wynik = mysqli_query($polaczenie, $zapytanie);
if (!$wynik) {
    mysqli_close($polaczenie);
    exit("Nie udało się wykonać zapytania.");
}
?>
<!doctype html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Obiekty Islandii</title>
</head>
<body>
<h1>Obiekty Islandii</h1>
<?php
echo "<ul>";
while ($rekord = mysqli_fetch_array($wynik, MYSQLI_ASSOC)) {
    $idObiekt = (int)$rekord["idObiekt"];
    $nazwa = htmlspecialchars($rekord["nazwa"], ENT_QUOTES | ENT_SUBSTITUTE, "UTF-8");
    echo '<li><a href="obiekt.php?id=' . $idObiekt . '">' . $nazwa . '</a></li>';
}
echo "</ul>";
mysqli_close($polaczenie);
?>
</body>
</html>
```

W porównaniu z lekcją 8 zmieniły się zapytanie i zawartość `li`. Połączenie oraz obsługa zapytania mają znany układ. Oryginalne dane dają 9 linków do obiektów Islandii.

### 10. Dwa ćwiczenia dodatkowe

#### Ćwiczenie 5 - lista linków

Uruchom `lista_obiektow.php`. Sprawdź, czy lista zawiera wszystkie 9 obiektów Islandii i czy pierwsze dwa linki wskazują odpowiednie identyfikatory.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 5</summary>

Sprawdź `href` w źródle strony lub najeżdżając na link. Numer pochodzi z rekordu, nie z pozycji na liście.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 5</summary>

Lista powstaje z programu w kroku 9. Pierwsze linki to `obiekt.php?id=46` (Strokkur) i `obiekt.php?id=47` (Skogafoss). Nie trzeba przepisywać programu szczegółów.

</details>

#### Ćwiczenie 6 - lista => szczegóły => lista

Kliknij Strokkur, potem sprawdź Skogafoss. Do pliku `obiekt.php` dodaj link powrotny do listy, bez zmieniania zapytania i kontroli parametru.

<details class="lesson-hint" markdown="1">
<summary>Podpowiedź - ćwiczenie 6</summary>

Wstaw zwykły HTML po zamykającym `?>`, przed `</body>`. Link powinien wskazywać plik listy w tym samym katalogu.

</details>

<details class="lesson-hint" markdown="1">
<summary>Rozwiązanie - ćwiczenie 6</summary>


```html
<p><a href="lista_obiektow.php">Powrót do listy obiektów</a></p>
```

Kliknięcie nazwy wysyła id do programu szczegółów, a link powrotny otwiera listę. Nie potrzebujemy formularza ani nowego zapytania w pliku szczegółów.

</details>

### 11. Typowe błędy

| Problem | Jak poprawić |
| --- | --- |
| Brak `?` | Zamiast `obiekt.phpid=46` wpisz `obiekt.php?id=46`. |
| `idObiekt` zamiast `id` w adresie | Program czyta parametr `id`. Kolumna SQL nazywa się `idObiekt`. Użyj `?id=46`. |
| Odczyt nieistniejącego klucza | Najpierw użyj `isset()` albo obsłuż `null` z `filter_input()`. |
| Niepoprawny identyfikator | `abc`, liczby ujemne i zero nie przechodzą naszej walidacji. Podaj dodatnią liczbę całkowitą. |
| Brak rekordu | `999` może przejść walidację, lecz nie występuje w oryginalnej bazie. To nie błąd składni SQL. |
| Surowe GET w SQL | Używaj wyłącznie `$idObiekt` po sprawdzeniach z kroku 6. Kodowanie HTML nie zastępuje walidacji dla SQL. |
| Uszkodzony `href` | Zamknij cudzysłów, np. `href="obiekt.php?id=46"`. Sprawdź wygenerowany HTML. |
| Ścieżka dyskowa zamiast HTTP | `C:\xampp\htdocs\kurs-php\obiekt.php` to plik. Uruchamiaj `http://localhost/kurs-php/obiekt.php?id=46`. |

### 12. Podsumowanie i INF.03

Kliknięcie linku `id=46` uruchamia plik szczegółów. PHP odczytuje i sprawdza parametr, SELECT wybiera rekord o `idObiekt = 46`, a HTML pokazuje Strokkur. **Adres wybiera wartość, SQL wybiera rekord, PHP tworzy widok.**

`isset()` znajduje się w [ściądze funkcji INF.03]({{ '/00-organizacja/02-sciaga-php-inf03.html' | relative_url }}). Przekazywanie GET opisano w analizowanym arkuszu osobno. Nie oznacza to, że cały program ani każdy wzorzec walidacji z tej lekcji został podany w arkuszu.

Dokumentacja PHP: [$_GET](https://www.php.net/manual/en/reserved.variables.get.php), [isset()](https://www.php.net/manual/en/function.isset.php), [filter_input()](https://www.php.net/manual/en/function.filter-input.php).
