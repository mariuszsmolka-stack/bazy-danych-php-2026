-- Struktura i dane do pustej bazy uczniowie_ZS5 założonej wcześniej w phpMyAdmin.
-- To alternatywa dla importu samych danych, nie kolejny import po nim.

-- Wybierz wcześniej pustą bazę uczniowie_ZS5 w phpMyAdmin.
-- Baza: utf8mb4, utf8mb4_polish_ci. Tabele dziedziczą te ustawienia.

CREATE TABLE klasy (
    id_klasy INT AUTO_INCREMENT PRIMARY KEY,
    oznaczenie VARCHAR(10) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE uczniowie (
    id_ucznia INT AUTO_INCREMENT PRIMARY KEY,
    imie VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(80) NOT NULL,
    id_klasy INT NOT NULL,
    CONSTRAINT fk_uczniowie_klasy
        FOREIGN KEY (id_klasy) REFERENCES klasy(id_klasy)
) ENGINE=InnoDB;

CREATE TABLE sale (
    id_sali INT AUTO_INCREMENT PRIMARY KEY,
    numer_sali VARCHAR(10) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE przedmioty (
    id_przedmiotu INT AUTO_INCREMENT PRIMARY KEY,
    nazwa VARCHAR(80) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE zajecia (
    id_zajec INT AUTO_INCREMENT PRIMARY KEY,
    id_klasy INT NOT NULL,
    id_sali INT NOT NULL,
    id_przedmiotu INT NOT NULL,
    data_zajec DATE NOT NULL,
    godzina_rozpoczecia TIME NOT NULL,
    CONSTRAINT fk_zajecia_klasy
        FOREIGN KEY (id_klasy) REFERENCES klasy(id_klasy),
    CONSTRAINT fk_zajecia_sale
        FOREIGN KEY (id_sali) REFERENCES sale(id_sali),
    CONSTRAINT fk_zajecia_przedmioty
        FOREIGN KEY (id_przedmiotu) REFERENCES przedmioty(id_przedmiotu)
) ENGINE=InnoDB;

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
