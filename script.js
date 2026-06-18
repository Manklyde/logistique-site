// Gestion de la navigation
document.addEventListener('DOMContentLoaded', function() {
    const menuLinks = document.querySelectorAll('.menu a');
    const sections = document.querySelectorAll('.section');

    // Charger les données initiales
    chargerDonnees();

    // Gestion de la navigation
    menuLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();

            // Récupérer l'ID de la section à afficher
            const targetId = this.getAttribute('href').substring(1);

            // Masquer toutes les sections
            sections.forEach(section => {
                section.classList.remove('active');
            });

            // Afficher la section ciblée
            const targetSection = document.getElementById(targetId);
            if (targetSection) {
                targetSection.classList.add('active');
                
                // Charger les données spécifiques si nécessaire
                if (targetId === 'distribution') {
                    chargerDistribution();
                } else if (targetId === 'inventaire') {
                    chargerInventaire();
                } else if (targetId === 'eleves-list') {
                    chargerListeEleves();
                }
            }

            // Mettre à jour le style du menu
            menuLinks.forEach(link => {
                link.classList.remove('active');
            });
            this.classList.add('active');
        });
    });

    // Gestion du menu déroulant Élèves
    const menuElevesBtn = document.querySelector('.menu-eleves-btn');
    const submenu = document.getElementById('submenu-eleves');

    if (menuElevesBtn) {
        menuElevesBtn.addEventListener('click', function(e) {
            e.preventDefault();
            submenu.style.display = submenu.style.display === 'block' ? 'none' : 'block';
        });

        document.addEventListener('click', function(e) {
            if (!e.target.closest('.menu-item-eleves')) {
                submenu.style.display = 'none';
            }
        });
    }

    // Activer le premier lien par défaut
    if (menuLinks.length > 0) {
        menuLinks[0].classList.add('active');
    }
});

// Charger les données initiales
function chargerDonnees() {
    chargerEleves();
    chargerVetements();
}

// Charger les élèves
function chargerEleves() {
    fetch('api.php?action=get_eleves')
        .then(response => response.json())
        .then(data => {
            const selectEleve = document.getElementById('eleve-select');
            selectEleve.innerHTML = '<option value="">-- Choisir un élève --</option>';
            data.forEach(eleve => {
                const option = document.createElement('option');
                option.value = eleve.id;
                option.textContent = `${eleve.prenom} ${eleve.nom} (${eleve.matricule})`;
                selectEleve.appendChild(option);
            });
        })
        .catch(error => console.error('Erreur:', error));
}

// Charger les vêtements
function chargerVetements() {
    fetch('api.php?action=get_vetements')
        .then(response => response.json())
        .then(data => {
            const container = document.getElementById('vetements-container');
            container.innerHTML = '';
            data.forEach(vetement => {
                const div = document.createElement('div');
                div.className = 'form-group';
                div.innerHTML = `
                    <label for="vetement-${vetement.id}">${vetement.nom} :</label>
                    <select id="vetement-${vetement.id}" class="vetement-select" data-vetement-id="${vetement.id}">
                        <option value="">-- Choisir une taille --</option>
                        ${vetement.tailles.map(taille => `
                            <option value="${taille.id}" data-quantite="${taille.quantite}">
                                ${taille.taille} (${taille.quantite} disponibles)
                            </option>
                        `).join('')}
                    </select>
                </div>
                `;
                container.appendChild(div);
            });
        })
        .catch(error => console.error('Erreur:', error));
}

// Charger la section Distribution
function chargerDistribution() {
    chargerEleves();
    chargerVetements();
    chargerHistoriqueDistributions();
}

// Charger l'historique des distributions
function chargerHistoriqueDistributions() {
    fetch('api.php?action=get_distributions')
        .then(response => response.json())
        .then(data => {
            const tbody = document.querySelector('#distributions-table tbody');
            tbody.innerHTML = '';
            data.forEach(dist => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>${dist.eleve}</td>
                    <td>${dist.vetement}</td>
                    <td>${dist.taille}</td>
                    <td>${new Date(dist.date_distribution).toLocaleString('fr-FR')}</td>
                `;
                tbody.appendChild(tr);
            });
        })
        .catch(error => console.error('Erreur:', error));
}

// Charger l'inventaire
function chargerInventaire() {
    fetch('api.php?action=get_vetements')
        .then(response => response.json())
        .then(data => {
            const container = document.getElementById('inventaire-container');
            container.innerHTML = '';
            data.forEach(vetement => {
                const div = document.createElement('div');
                div.className = 'vetement-stock';
                div.innerHTML = `
                    <h3>${vetement.nom}</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>Taille</th>
                                <th>Quantité</th>
                            </tr>
                        </thead>
                        <tbody>
                            ${vetement.tailles.map(taille => `
                                <tr>
                                    <td>${taille.taille}</td>
                                    <td>${taille.quantite}</td>
                                </tr>
                            `).join('')}
                        </tbody>
                    </table>
                `;
                container.appendChild(div);
            });
        })
        .catch(error => console.error('Erreur:', error));
}

// Charger la liste des élèves
function chargerListeEleves() {
    fetch('api.php?action=get_eleves')
        .then(response => response.json())
        .then(data => {
            const tbody = document.querySelector('#eleves-table tbody');
            tbody.innerHTML = '';
            data.forEach(eleve => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>${eleve.nom}</td>
                    <td>${eleve.prenom}</td>
                    <td>${eleve.matricule}</td>
                    <td>${eleve.rio || '-'}</td>
                    <td>${eleve.section || '-'}</td>
                    <td>${eleve.promotion || '-'}</td>
                `;
                tbody.appendChild(tr);
            });
        })
        .catch(error => console.error('Erreur:', error));
}

// Gérer l'ajout d'élève
document.addEventListener('DOMContentLoaded', function() {
    const formAddEleve = document.getElementById('form-add-eleve');
    if (formAddEleve) {
        formAddEleve.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            
            fetch('api.php?action=add_eleve', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.succes) {
                    alert(data.message);
                    this.reset();
                    chargerEleves();
                    chargerListeEleves();
                } else {
                    alert('Erreur: ' + data.message);
                }
            })
            .catch(error => console.error('Erreur:', error));
        });
    }

    // Gérer la distribution
    const btnDistribuer = document.getElementById('btn-distribuer');
    if (btnDistribuer) {
        btnDistribuer.addEventListener('click', function() {
            const elevId = document.getElementById('eleve-select').value;
            
            if (!elevId) {
                alert('Veuillez sélectionner un élève');
                return;
            }

            let vetementTailleId = null;
            const vetementSelects = document.querySelectorAll('.vetement-select');
            
            vetementSelects.forEach(select => {
                if (select.value) {
                    vetementTailleId = select.value;
                    return;
                }
            });

            if (!vetementTailleId) {
                alert('Veuillez sélectionner au moins un vêtement et une taille');
                return;
            }

            const formData = new FormData();
            formData.append('eleve_id', elevId);
            formData.append('vetement_taille_id', vetementTailleId);

            fetch('api.php?action=add_distribution', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.succes) {
                    alert(data.message);
                    chargerVetements();
                    chargerHistoriqueDistributions();
                    chargerInventaire();
                } else {
                    alert('Erreur: ' + data.message);
                }
            })
            .catch(error => console.error('Erreur:', error));
        });
    }
});
