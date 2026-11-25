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
