# Logistique Site

Application web de gestion logistique pour les élèves : suivi des vêtements, distributions et stocks.

## 📁 Structure du projet

```
logistique-site/
├── index.html      ← Page principale avec menu déroulant élèves et sections
├── style.css       ← Styles CSS complets avec design responsive
├── script.js       ← JavaScript avec gestion de la navigation et requêtes AJAX
├── api.php         ← Backend PHP pour gérer les données (CRUD)
├── database.sql    ← Structure SQL et données d'exemple
└── README.md       ← Ce fichier
```

## ✅ Fonctionnalités

- Gestion des élèves (Nom, Prénom, Matricule, RIO, Section, Promotion)
- Gestion des vêtements avec tailles et quantités
- Distribution de vêtements avec suivi de stock
- Historique des distributions
- Menu déroulant pour la sélection des élèves
- Design responsive et moderne

## 🚀 Installation

### Prérequis

- PHP 7.4+
- MySQL 5.7+ ou MariaDB
- Serveur web (Apache/XAMPP)

### Étapes

1. **Cloner le repository**
   ```bash
   git clone https://github.com/Manklyde/logistique-site.git
   cd logistique-site
   ```

2. **Configurer la base de données**
   ```sql
   CREATE DATABASE logistique_db;
   ```
   Puis importer le fichier SQL :
   ```bash
   mysql -u root -p logistique_db < database.sql
   ```

3. **Configurer l'API**
   Modifier les identifiants dans `api.php` :
   ```php
   $host = 'localhost';
   $dbname = 'logistique_db';
   $user = 'root';
   $password = 'votre_mot_de_passe';
   ```

4. **Lancer l'application**
   - Placez les fichiers dans le dossier `htdocs` de XAMPP
   - Accédez à `http://localhost/logistique-site/`

## 🛠️ Technologies utilisées

- **Frontend** : HTML5, CSS3, JavaScript (AJAX)
- **Backend** : PHP
- **Base de données** : MySQL
