<?php
// Connexion à la base de données
$serveur = 'localhost';
$utilisateur = 'root';
$motdepasse = '';
$basedonnees = 'logistique_db';

try {
    $connexion = new PDO("mysql:host=$serveur;dbname=$basedonnees;charset=utf8", $utilisateur, $motdepasse);
    $connexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['erreur' => 'Erreur de connexion : ' . $e->getMessage()]);
    exit();
}

// Déterminer l'action demandée
$action = isset($_GET['action']) ? $_GET['action'] : '';

// Répondre aux demandes AJAX
header('Content-Type: application/json');

if ($action === 'get_vetements') {
    // Récupérer tous les vêtements avec leurs tailles
    $sql = "SELECT v.id, v.nom, v.description FROM vetements v";
    $resultat = $connexion->query($sql);
    $vetements = $resultat->fetchAll(PDO::FETCH_ASSOC);
    
    foreach ($vetements as &$vetement) {
        $sql_tailles = "SELECT id, taille, quantite FROM vetement_tailles WHERE vetement_id = ? ORDER BY taille";
        $stmt = $connexion->prepare($sql_tailles);
        $stmt->execute([$vetement['id']]);
        $vetement['tailles'] = $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    
    echo json_encode($vetements);
} 
elseif ($action === 'get_eleves') {
    // Récupérer tous les élèves
    $sql = "SELECT id, nom, prenom, matricule, rio, section, promotion FROM eleves ORDER BY nom, prenom";
    $resultat = $connexion->query($sql);
    $eleves = $resultat->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode($eleves);
}
elseif ($action === 'add_distribution') {
    // Ajouter une distribution de vêtement
    $eleve_id = isset($_POST['eleve_id']) ? $_POST['eleve_id'] : null;
    $vetement_taille_id = isset($_POST['vetement_taille_id']) ? $_POST['vetement_taille_id'] : null;
    
    if ($eleve_id && $vetement_taille_id) {
        try {
            // Vérifier que la quantité est disponible
            $sql_verif = "SELECT quantite FROM vetement_tailles WHERE id = ?";
            $stmt = $connexion->prepare($sql_verif);
            $stmt->execute([$vetement_taille_id]);
            $vetement = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if ($vetement && $vetement['quantite'] > 0) {
                // Ajouter la distribution
                $sql_dist = "INSERT INTO distributions (eleve_id, vetement_taille_id) VALUES (?, ?)";
                $stmt = $connexion->prepare($sql_dist);
                $stmt->execute([$eleve_id, $vetement_taille_id]);
                
                // Diminuer la quantité
                $sql_update = "UPDATE vetement_tailles SET quantite = quantite - 1 WHERE id = ?";
                $stmt = $connexion->prepare($sql_update);
                $stmt->execute([$vetement_taille_id]);
                
                echo json_encode(['succes' => true, 'message' => 'Vêtement distribué avec succès']);
            } else {
                echo json_encode(['succes' => false, 'message' => 'Stock insuffisant']);
            }
        } catch (PDOException $e) {
            echo json_encode(['succes' => false, 'message' => 'Erreur : ' . $e->getMessage()]);
        }
    } else {
        echo json_encode(['succes' => false, 'message' => 'Données manquantes']);
    }
}
elseif ($action === 'add_eleve') {
    // Ajouter un nouvel élève
    $nom = isset($_POST['nom']) ? $_POST['nom'] : null;
    $prenom = isset($_POST['prenom']) ? $_POST['prenom'] : null;
    $matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;
    $rio = isset($_POST['rio']) ? $_POST['rio'] : null;
    $section = isset($_POST['section']) ? $_POST['section'] : null;
    $promotion = isset($_POST['promotion']) ? $_POST['promotion'] : null;
    
    if ($nom && $prenom && $matricule) {
        try {
            $sql = "INSERT INTO eleves (nom, prenom, matricule, rio, section, promotion) VALUES (?, ?, ?, ?, ?, ?)";
            $stmt = $connexion->prepare($sql);
            $stmt->execute([$nom, $prenom, $matricule, $rio, $section, $promotion]);
            echo json_encode(['succes' => true, 'message' => 'Élève ajouté avec succès']);
        } catch (PDOException $e) {
            echo json_encode(['succes' => false, 'message' => 'Erreur : ' . $e->getMessage()]);
        }
    } else {
        echo json_encode(['succes' => false, 'message' => 'Données obligatoires manquantes']);
    }
}
elseif ($action === 'get_distributions') {
    // Récupérer l'historique des distributions
    $sql = "SELECT d.id, CONCAT(e.prenom, ' ', e.nom) as eleve, v.nom as vetement, vt.taille, d.date_distribution 
            FROM distributions d
            JOIN eleves e ON d.eleve_id = e.id
            JOIN vetement_tailles vt ON d.vetement_taille_id = vt.id
            JOIN vetements v ON vt.vetement_id = v.id
            ORDER BY d.date_distribution DESC";
    $resultat = $connexion->query($sql);
    $distributions = $resultat->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode($distributions);
}
else {
    echo json_encode(['erreur' => 'Action non reconnue']);
}
?>
