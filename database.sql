-- Création de la base de données Logistique
CREATE DATABASE IF NOT EXISTS logistique;
USE logistique;

-- Table des élèves
CREATE TABLE IF NOT EXISTS eleve (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    matricule VARCHAR(50) UNIQUE NOT NULL,
    rio VARCHAR(50),
    section VARCHAR(100),
    promotion INT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table des vêtements
CREATE TABLE IF NOT EXISTS vetement (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    description TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des tailles
CREATE TABLE IF NOT EXISTS taille (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vetement_id INT NOT NULL,
    taille VARCHAR(50) NOT NULL,
    quantite INT DEFAULT 0,
    quantite_minimale INT DEFAULT 10,
    FOREIGN KEY (vetement_id) REFERENCES vetement(id) ON DELETE CASCADE,
    UNIQUE KEY unique_vetement_taille (vetement_id, taille)
);

-- Table des distributions
CREATE TABLE IF NOT EXISTS distribution (
    id INT AUTO_INCREMENT PRIMARY KEY,
    eleve_id INT NOT NULL,
    taille_id INT NOT NULL,
    date_distribution TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    remarques TEXT,
    FOREIGN KEY (eleve_id) REFERENCES eleve(id) ON DELETE CASCADE,
    FOREIGN KEY (taille_id) REFERENCES taille(id) ON DELETE CASCADE
);

-- Table des réceptions
CREATE TABLE IF NOT EXISTS reception (
    id INT AUTO_INCREMENT PRIMARY KEY,
    taille_id INT NOT NULL,
    quantite INT NOT NULL,
    date_reception TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fournisseur VARCHAR(100),
    remarques TEXT,
    FOREIGN KEY (taille_id) REFERENCES taille(id) ON DELETE CASCADE
);

-- Table des utilisateurs administrateurs
CREATE TABLE IF NOT EXISTS administrateur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'Administrateur',
    statut ENUM('Actif', 'Inactif') DEFAULT 'Actif',
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insertion des données d'exemple - Élèves
INSERT INTO eleve (nom, prenom, matricule, rio, section, promotion) VALUES
('Dupont', 'Jean', 'MAT001', 'RIO001', 'Informatique', 2025),
('Martin', 'Marie', 'MAT002', 'RIO002', 'Électronique', 2025),
('Bernard', 'Pierre', 'MAT003', 'RIO003', 'Mécanique', 2026),
('Lefevre', 'Sophie', 'MAT004', 'RIO004', 'Informatique', 2026),
('Durand', 'Luc', 'MAT005', 'RIO005', 'Électricité', 2025);

-- Insertion des données d'exemple - Vêtements
INSERT INTO vetement (nom, description) VALUES
('T-Shirt', 'T-shirt standard de l''établissement'),
('Pantalon', 'Pantalon standard de l''établissement'),
('Veste', 'Veste standard de l''établissement'),
('Chaussures', 'Chaussures standard de l''établissement');

-- Insertion des données d'exemple - Tailles pour T-Shirt
INSERT INTO taille (vetement_id, taille, quantite) VALUES
(1, 'XS', 10),
(1, 'S', 15),
(1, 'M', 19),
(1, 'L', 18),
(1, 'XL', 12);

-- Insertion des données d'exemple - Tailles pour Pantalon
INSERT INTO taille (vetement_id, taille, quantite) VALUES
(2, '36', 8),
(2, '38', 12),
(2, '40', 15),
(2, '42', 10);

-- Insertion des données d'exemple - Tailles pour Veste
INSERT INTO taille (vetement_id, taille, quantite) VALUES
(3, 'S', 5),
(3, 'M', 10),
(3, 'L', 8),
(3, 'XL', 5);

-- Insertion des données d'exemple - Tailles pour Chaussures
INSERT INTO taille (vetement_id, taille, quantite) VALUES
(4, '38', 6),
(4, '39', 8),
(4, '40', 10),
(4, '41', 7),
(4, '42', 9);

-- Insertion des données d'exemple - Administrateur
INSERT INTO administrateur (username, email, password, role, statut) VALUES
('admin', 'admin@logistique.com', 'password_hash_here', 'Administrateur', 'Actif');

-- Insertion des données d'exemple - Distributions
INSERT INTO distribution (eleve_id, taille_id, remarques) VALUES
(1, 3, 'Distribution initiale'),
(2, 8, 'Pantalon taille 40'),
(3, 11, 'Veste taille L');

-- Insertion des données d'exemple - Réceptions
INSERT INTO reception (taille_id, quantite, fournisseur, remarques) VALUES
(1, 50, 'Fournisseur A', 'Réception de 50 T-Shirts XS'),
(2, 75, 'Fournisseur A', 'Réception de 75 T-Shirts S'),
(3, 100, 'Fournisseur B', 'Réception de 100 T-Shirts M'),
(6, 40, 'Fournisseur C', 'Réception de 40 Pantalons 36'),
(7, 50, 'Fournisseur C', 'Réception de 50 Pantalons 38');

-- Création des indexes pour optimiser les requêtes
CREATE INDEX idx_eleve_matricule ON eleve(matricule);
CREATE INDEX idx_eleve_section ON eleve(section);
CREATE INDEX idx_eleve_promotion ON eleve(promotion);
CREATE INDEX idx_taille_vetement ON taille(vetement_id);
CREATE INDEX idx_distribution_eleve ON distribution(eleve_id);
CREATE INDEX idx_distribution_date ON distribution(date_distribution);
CREATE INDEX idx_reception_date ON reception(date_reception);
