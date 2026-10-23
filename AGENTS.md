# Zasady pracy nad kursem

- Repozytorium nadrzędne: `mariuszsmolka-stack/bazy-danych-php-2026` na GitHub. Gałąź publikacji: `main`. Stan lokalny nie stanowi zakończonej publikacji.
- Lokalny katalog repozytorium: `C:\2026GitHub\bazy-danych-php-2026`. Główny folder repozytoriów użytkownika to `C:\2026GitHub`.
- Przed pracą sprawdź stan lokalny i aktualny `origin/main`. Nie nadpisuj niezapisanych zmian użytkownika ani historii zdalnej.
- W etapie 1 są tylko dwie zatwierdzone lekcje. Zachowuj ich wyjaśnienia, kod, ćwiczenia i tempo. Nie dodawaj kolejnych lekcji bez zlecenia.
- Używaj polszczyzny, zwykłego myślnika, schematów `=>` i polskich nazw zmiennych w camelCase. W tym etapie nie publikuj pełnych rozwiązań ćwiczeń.
- Ucz proceduralnego `mysqli` i pracy w lokalnym XAMPP. Nazwa bazy ćwiczeniowej: `Islandia`.
- Nie zmieniaj struktury ani danych `baza/baza1.sql`; zachowaj plik bajt w bajt. Oryginalny komentarz w zrzucie pozostaje bez zmian.
- Arkusz CKE INF.03-01-26.06-SG jest materiałem odniesienia; nie publikuj pełnego PDF ani nie przypisuj kursowi autorstwa arkusza.
- GitHub Pages udostępnia materiały, nie wykonuje PHP. Publikuj z `main`, katalogu `/docs`.
- Nawigację zapisuj w `docs/_data/navigation.yml`, wyłącznie do istniejących stron. Zachowuj mechanizm szablonu, mobilny spis treści i przejścia między gotowymi lekcjami.
- Nie publikuj sekretów, lokalnej konfiguracji, plików tymczasowych ani wyników budowania. Konto `root` bez hasła w przykładach dotyczy wyłącznie lokalnego laboratorium.

## Polecenia i kontrola

Polecenia wykonuj w PowerShell. Dla cytowanej ścieżki programu używaj operatora `&`:

```powershell
Set-Location 'C:\2026GitHub\bazy-danych-php-2026'
git status --short
git fetch origin
git diff
& 'C:\xampp\php\php.exe' -l 'sciezka-do-sprawdzanego-przykladu.php'
git add README.md AGENTS.md docs baza .gitattributes .gitignore
git commit -m 'Zaktualizowano materiały kursu'
git push origin main
git ls-remote origin refs/heads/main
gh api repos/mariuszsmolka-stack/bazy-danych-php-2026/pages
```

Komunikaty commitów pisz po polsku i bezosobowo. Sprawdzaj kompletne przykłady przez `php -l`; nie wykonuj bez kontekstu fragmentów pokazujących celowe błędy.

Przed zakończeniem porównaj lokalny i zdalny SHA, sprawdź wynik budowania Pages oraz opublikowaną stronę główną, obie lekcje, stronę bazy i pobieranie SQL. Sprawdź mobilny spis treści, przejścia Poprzednia/Następna i brak ślepych linków. Podaj adres repozytorium, adres Pages, końcowy SHA i rzeczywiście wykonane testy. Gdy publikację blokuje brak uprawnień, podaj konkretny błąd; nie deklaruj sukcesu na podstawie samych plików lokalnych.

## Podpowiedzi i diagramy

- W lekcji GROUP BY zachowuj małe kroki, kolejność ćwiczeń i wyjaśnienia wyników na rzeczywistych danych. Odróżniaj liczbę grup od liczby rekordów, COUNT(*) od COUNT(kolumna) i brak grupy od wyniku zero. HAVING pozostaje planem w `planowanie/PLAN_HAVING.md` do czasu osobnego zlecenia.

- Pod każdym ćwiczeniem stosuj krótką podpowiedź w natywnym `<details class="lesson-hint" markdown="1">` z `<summary>Podpowiedź</summary>`. Zostaw puste wiersze wokół treści Markdown i bloków kodu. Sprawdzaj wyrenderowany HTML Kramdown.
- Podpowiedź wskazuje kierunek, nie zawiera pełnego rozwiązania. Przy złożonym zadaniu można dodać drugą, bardziej konkretną wskazówkę.
- Wyniki zdradzające odpowiedź umieszczaj w osobnym `Sprawdź wynik`. Dane potrzebne do wykonania polecenia pozostaw widoczne. Sekcje mają być domyślnie zamknięte.
- Styl podpowiedzi ograniczaj do `.course-main details.lesson-hint` i jego `summary`; nie zmieniaj `.mobile-toc`.
- Mermaid stosuj tylko do użytecznych diagramów przepływu lub relacji. Nie powielaj diagramów ani nie dodawaj ich dekoracyjnie. Używaj prostego `flowchart TD`, strzałek `-->` i cytowanych etykiet ze znakami specjalnymi. W schematach tekstowych pozostaw `=>`.
- Dla strony z diagramem ustaw `mermaid: true`. Korzystaj z istniejącego `docs/assets/js/diagrams.js`, ukrytego źródła `.mermaid-source` i czytelnego `.diagram-fallback`. Biblioteka jest przypięta do konkretnej wersji CDN; nie instaluj frameworków.
- Sprawdź publiczne Pages: SVG zamiast surowej składni, czytelne etykiety, wąski ekran, otwieranie podpowiedzi i formatowanie kodu. Awaria lub brak JavaScript nie może blokować lekcji, podpowiedzi ani tekstowej wersji schematu.
- Sprawdź też menu mobilne oraz Poprzednia/Następna. Wykonaj lokalny commit i `git push origin main`, następnie porównaj SHA. Nie ogłaszaj zakończenia przed kontrolą publicznej strony.
