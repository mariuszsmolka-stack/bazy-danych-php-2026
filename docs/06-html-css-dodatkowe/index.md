---
title: HTML i CSS - materiały dodatkowe INF.03
---

# HTML i CSS - materiały dodatkowe INF.03

Ten dział jest **uzupełnieniem dla zainteresowanych uczniów**, a nie obowiązkową częścią kursu SQL, MariaDB i PHP. Powstał na podstawie arkusza praktycznego **INF.03-01-26.06-SG - Portal turystyczny Islandii** oraz zasad jego oceniania.

W głównym kursie uczymy się pracy z bazą danych i programowania w PHP. Tutaj pokazujemy, **jak przygotować strukturę i wygląd strony**, do której w kolejnych lekcjach będzie można dodać skrypty PHP.

Zdjęcia nie są publikowane w tym kursie ani w ZIP-ie przykładów. [Pobierz oryginalne załączniki egzaminacyjne](https://arkusze.pl/zawodowy/inf03-2026-czerwiec-egzamin-zawodowy-praktyczny-zalaczniki.zip). Po rozpakowaniu umieść dziewięć zdjęć obok plików HTML i CSS, zachowując ich nazwy. Podgląd online pokazuje układ i style bez fotografii; pełny podgląd ze zdjęciami uruchom lokalnie.

## Opracowania

1. [HTML - budujemy szkielet portalu Islandii](01-html-portal-islandii.html) - wspólne bloki, listy, obrazy, linki, struktura dwóch stron.
2. [CSS - odtwarzamy wygląd portalu Islandii](02-css-portal-islandii.html) - wszystkie wymagane właściwości z arkusza, przykład działającego arkusza stylów.

**[Pobierz pliki HTML i CSS (ZIP)](portal-islandii-html-css.zip)** - pliki HTML i CSS bez zdjęć.

## Uruchom gotowe przykłady

- [Podgląd galerii Islandii](przyklady/islandia.html)
- [Podgląd strony szczegółów](przyklady/obiekty.html)
- [Arkusz stylów - plik styl.css](przyklady/styl.css)

Przykłady są **statycznymi stronami HTML**. Zdjęcia i listy zostały wpisane do kodu wyłącznie po to, aby było widać wygląd portalu bez uruchamiania PHP i MariaDB. Kliknięcie miniatury przenosi na adres z parametrem `id`, ale treść przykładowej strony szczegółów **jeszcze nie zmienia się według parametru**. Takie działanie dodamy w części PHP.

## Skąd pochodzą zdjęcia?

Dziewięć zdjęć do pobrania osobno to pliki z **załączników do zadania INF.03-01-26.06-SG**. W przykładach używamy oryginalnych nazw, m.in. `Strokkur.jpg`, `Skogafoss.jpg` i `godafoss.jpg`, ponieważ takie nazwy znajdują się również w kolumnie `plik` tabeli `obiekty`.

Źródło zadania i paczki `pliki1.7z`: [Portal turystyczny Islandii - INF.03-01-26.06-SG](https://zawodowe.edu.pl/arkusze-praktyczne/inf-03/inf03-2026-czerwiec-01/). Hasło do oryginalnego archiwum egzaminacyjnego jest podane w arkuszu zadania. **Zdjęć nie przedstawiamy jako własnych fotografii ani nie przypisujemy im licencji kursowych tekstów.**

## Jak korzystać lokalnie?

1. Pobierz pliki HTML i CSS z katalogu `przyklady` oraz zdjęcia ze wskazanych wyżej załączników. Zachowaj je **razem w jednym folderze**, bez zmiany wielkości liter w nazwach zdjęć.
2. Otwórz `islandia.html` w przeglądarce. Zobacz galerię i najedź na miniaturę.
3. Kliknij zdjęcie - otworzy się przykładowa strona `obiekty.html` z parametrem w adresie.
4. Otwórz `styl.css` i przejdź do lekcji o CSS, aby zrozumieć wygląd poszczególnych bloków.

Możesz również umieścić wszystkie pliki w `C:\xampp\htdocs\inf03-islandia` i otworzyć `http://localhost/inf03-islandia/islandia.html`.

**Uwaga egzaminacyjna:** prawdziwy arkusz wymaga plików `islandia.php` i `obiekty.php` oraz skryptów SQL/PHP. Nasze pliki `*.html` to **podgląd i punkt startowy**, a nie gotowe rozwiązanie zadania egzaminacyjnego.

[Wróć do głównego spisu treści]({{ '/' | relative_url }})
