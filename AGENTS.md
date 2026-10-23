# Zasady pracy nad kursem

- Repozytorium nadrzędne: `mariuszsmolka-stack/bazy-danych-php-2026` na GitHub. Gałąź publikacji: `main`. Stan lokalny nie stanowi zakończonej publikacji.
- Lokalny katalog repozytorium: `C:\2026GitHub\bazy-danych-php-2026`. Główny folder repozytoriów użytkownika to `C:\2026GitHub`.
- Przed pracą sprawdź stan lokalny i aktualny `origin/main`. Nie nadpisuj niezapisanych zmian użytkownika ani historii zdalnej.
- W etapie 1 są tylko dwie zatwierdzone lekcje. Zachowuj ich wyjaśnienia, kod, ćwiczenia i tempo. Nie dodawaj kolejnych lekcji bez zlecenia.
- Używaj polszczyzny, zwykłego myślnika, schematów `=>` i polskich nazw zmiennych w camelCase. Przyszłe rozwiązania ćwiczeń umieszczaj w zwijanych sekcjach.
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
