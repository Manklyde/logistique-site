-- Table pour les élèves
CREATE TABLE eleves (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    matricule VARCHAR(50) UNIQUE NOT NULL,
    rio VARCHAR(50),
    section VARCHAR(100),
    promotion VARCHAR(50)
);

-- Table pour les vêtements
CREATE TABLE vetements (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL,
    description TEXT
);

-- Table pour les tailles de vêtements
CREATE TABLE vetement_tailles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    vetement_id INT NOT NULL,
    taille VARCHAR(20) NOT NULL,
    quantite INT DEFAULT 0,
    FOREIGN KEY (vetement_id) REFERENCES vetements(id) ON DELETE CASCADE,
    UNIQUE KEY unique_vetement_taille (vetement_id, taille)
);

-- Table pour l'attribution des vêtements aux élèves
CREATE TABLE distributions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    eleve_id INT NOT NULL,
    vetement_taille_id INT NOT NULL,
    date_distribution DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (eleve_id) REFERENCES eleves(id) ON DELETE CASCADE,
    FOREIGN KEY (vetement_taille_id) REFERENCES vetement_tailles(id) ON DELETE CASCADE
);

-- Données d'exemple
INSERT INTO eleves (nom, prenom, matricule, rio, section, promotion) VALUES
('Dupont', 'Jean', 'MAT001', 'RIO001', 'Informatique', '2025'),
('Martin', 'Marie', 'MAT002', 'RIO002', 'Électronique', '2025'),
('Bernard', 'Pierre', 'MAT003', 'RIO003', 'Mécanique', '2026');

INSERT INTO vetements (nom, description) VALUES
('T-Shirt', 'T-shirt standard'),
('Pantalon', 'Pantalon de travail'),
('Veste', 'Veste de protection'),
('Chaussures', 'Chaussures de sécurité');

INSERT INTO vetement_tailles (vetement_id, taille, quantite) VALUES
(1, 'XS', 10), (1, 'S', 15), (1, 'M', 20), (1, 'L', 18), (1, 'XL', 12),
(2, '36', 8), (2, '38', 12), (2, '40', 15), (2, '42', 10),
(3, 'S', 5), (3, 'M', 10), (3, 'L', 8), (3, 'XL', 5),
(4, '38', 6), (4, '39', 8), (4, '40', 10), (4, '41', 7), (4, '42', 9);
