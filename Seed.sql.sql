-- ============================================================
-- Base de données : LogiStock
-- Partie 2 : Jeu de données / Insertions (DML - sans table FACTURE)
-- Compatible avec MySQL / MariaDB (XAMPP / phpMyAdmin)
-- Généré le : 04 Novembre 2026
-- ============================================================

USE `logistock`;

-- Roles
INSERT INTO `ROLE` (`id_role`, `libelle_role`, `description`) VALUES
(1, 'Administrateur', 'Accès complet au système LogiStock'),
(2, 'Gestionnaire de Stock', 'Gestion des produits, catégories et mouvements de stock'),
(3, 'Vendeur', 'Gestion des ventes');

-- Utilisateurs
INSERT INTO `UTILISATEUR` (`id_utilisateur`, `nom`, `email`, `mot_de_passe`, `id_role`) VALUES
(1, 'Oumar Camara', 'oumar.admin@logistock.ml', 'admin@123', 1),
(2, 'Aminata Diallo', 'aminata.stock@logistock.ml', 'stock@123', 2),
(3, 'Moussa Traoré', 'moussa.vente@logistock.ml', 'vente123', 3),
(4, 'Sekou Diakité', 'sekou@vente.logistock.ml', 'vente@123', 3);

-- Catégories
INSERT INTO `CATEGORIE` (`id_categorie`, `nom_categorie`, `description`) VALUES
(1, 'Informatique & Ordinateurs', 'Matériels informatiques et PC de bureau/portables'),
(2, 'Périphériques', 'Claviers, souris, câbles et écrans'),
(3, 'Réseau & Connectivité', 'Routeurs, switchs et câbles réseau'),
(4, 'Accessoires', 'Batteries et écrans');

-- Produits
INSERT INTO `PRODUIT` (`id_produit`, `reference`, `designation`, `prix_unitaire`, `quantite_stock`, `seuil_alerte`, `id_categorie`) VALUES
(1, 'REF-HP-001', 'Ordinateur Portable HP Core i5', 350000.00, 15, 3, 1),
(2, 'REF-SOU-002', 'Souris Optique Sans Fil', 7500.00, 50, 10, 2),
(3, 'REF-CLA-003', 'Clavier Mécanique RGB', 25000.00, 25, 5, 2),
(4, 'REF-ECR-004', 'Écran 24 pouces Full HD', 85000.00, 12, 2, 4),
(5, 'REF-CAB-005', 'Câble HDMI 2m', 3500.00, 100, 15, 3);

-- Mouvements de stock
INSERT INTO `MOUVEMENT_STOCK` (`id_mouvement`, `type_mouvement`, `quantite`, `commentaire`, `id_produit`, `id_utilisateur`) VALUES
(1, 'ENTREE', 20, 'Approvisionnement initial', 1, 2),
(2, 'ENTREE', 60, 'Stock initial reçus du fournisseur', 2, 2),
(3, 'SORTIE', 2, 'Vente N° VTE-2026-001', 2, 3),
(4, 'SORTIE', 1, 'Vente N° VTE-2026-002', 5, 2);

-- Clients
INSERT INTO `CLIENT` (`id_client`, `nom_raison_sociale`, `email`, `telephone`, `adresse`) VALUES
(1, 'Société Bamako Tech', 'contact@bamakotech.ml', '+223 70 00 00 01', 'Hamdallaye ACI 2000, Bamako'),
(2, 'Ibrahim Koné', 'ibrahim.kone@gmail.com', '+223 66 11 22 33', 'Badalabougou, Bamako'),
(3, 'Client Comptoir', NULL, NULL, 'Vente directe au comptoir'),
(4, 'Boubacar Traoré', NULL, NULL, 'Bamako');

-- Ventes
INSERT INTO `VENTE` (`id_vente`, `numero_vente`, `date_vente`, `statut_vente`, `montant_total`, `id_client`, `id_utilisateur`) VALUES
(1, 'VTE-2026-001', '2026-11-01 10:30:00', 'PAYEE', 365000.00, 1, 3),
(2, 'VTE-2026-002', '2026-11-02 14:15:00', 'PAYEE', 35500.00, 2, 3),
(3, 'VTE-2026-003', '2026-11-04 09:00:00', 'PAYEE', 170000.00, 3, 1),
(4, 'VTE-2026-004', '2026-11-04 09:10:00', 'PAYEE', 14000.00, 4, 4);

-- Lignes de vente
INSERT INTO `LIGNE_VENTE` (`id_vente`, `id_produit`, `quantite`, `prix_unitaire`) VALUES
(1, 1, 1, 350000.00),
(1, 2, 2, 7500.00),
(2, 3, 1, 25000.00),
(2, 5, 3, 3500.00),
(3, 4, 2, 85000.00),
(4, 5, 4, 3500.00);
