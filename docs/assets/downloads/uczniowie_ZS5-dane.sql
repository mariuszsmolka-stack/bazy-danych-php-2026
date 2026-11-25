-- Dane do wcześniej utworzonych pustych tabel bazy uczniowie_ZS5.
-- Wybierz bazę utf8mb4 / utf8mb4_polish_ci. Plik UTF-8 bez BOM.
-- Wszystkie klasy, osoby i terminy są fikcyjne.

INSERT INTO klasy (oznaczenie) VALUES
    ('3TI'),
    ('4TI'),
    ('3TP');

INSERT INTO sale (numer_sali) VALUES
    ('205'),
    ('32'),
    ('32A');

INSERT INTO przedmioty (nazwa) VALUES
    ('Bazy danych'),
    ('Programowanie obiektowe'),
    ('Testowanie aplikacji'),
    ('Aplikacje mobilne');

INSERT INTO uczniowie (imie, nazwisko, id_klasy) VALUES
    ('Łukasz', 'Lis', (SELECT id_klasy FROM klasy WHERE oznaczenie = '3TI')),
    ('Zofia', 'Łoś', (SELECT id_klasy FROM klasy WHERE oznaczenie = '3TI')),
    ('Michał', 'Mak', (SELECT id_klasy FROM klasy WHERE oznaczenie = '3TI')),
    ('Anna', 'Żuk', (SELECT id_klasy FROM klasy WHERE oznaczenie = '4TI')),
    ('Paweł', 'Ćwik', (SELECT id_klasy FROM klasy WHERE oznaczenie = '4TI')),
    ('Julia', 'Śliwa', (SELECT id_klasy FROM klasy WHERE oznaczenie = '3TP')),
    ('Łucja', 'Zając', (SELECT id_klasy FROM klasy WHERE oznaczenie = '3TP')),
    ('Stanisław', 'Żak', (SELECT id_klasy FROM klasy WHERE oznaczenie = '4TI'));

INSERT INTO zajecia (id_klasy, id_sali, id_przedmiotu, data_zajec, godzina_rozpoczecia) VALUES
    ((SELECT id_klasy FROM klasy WHERE oznaczenie = '3TI'), (SELECT id_sali FROM sale WHERE numer_sali = '205'), (SELECT id_przedmiotu FROM przedmioty WHERE nazwa = 'Bazy danych'), '2026-12-01', '08:00:00'),
    ((SELECT id_klasy FROM klasy WHERE oznaczenie = '3TI'), (SELECT id_sali FROM sale WHERE numer_sali = '32'), (SELECT id_przedmiotu FROM przedmioty WHERE nazwa = 'Bazy danych'), '2026-12-03', '09:50:00'),
    ((SELECT id_klasy FROM klasy WHERE oznaczenie = '3TI'), (SELECT id_sali FROM sale WHERE numer_sali = '32A'), (SELECT id_przedmiotu FROM przedmioty WHERE nazwa = 'Programowanie obiektowe'), '2026-12-02', '08:55:00'),
    ((SELECT id_klasy FROM klasy WHERE oznaczenie = '4TI'), (SELECT id_sali FROM sale WHERE numer_sali = '205'), (SELECT id_przedmiotu FROM przedmioty WHERE nazwa = 'Testowanie aplikacji'), '2026-12-02', '10:45:00'),
    ((SELECT id_klasy FROM klasy WHERE oznaczenie = '3TP'), (SELECT id_sali FROM sale WHERE numer_sali = '32'), (SELECT id_przedmiotu FROM przedmioty WHERE nazwa = 'Aplikacje mobilne'), '2026-12-03', '08:00:00'),
    ((SELECT id_klasy FROM klasy WHERE oznaczenie = '4TI'), (SELECT id_sali FROM sale WHERE numer_sali = '32A'), (SELECT id_przedmiotu FROM przedmioty WHERE nazwa = 'Bazy danych'), '2026-12-04', '11:40:00');
