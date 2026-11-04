-- ============================================================
-- Base de données : LogiStock
-- Modèle Logique de Données (MLD) complet mis à jour
-- Compatible avec MySQL / MariaDB (XAMPP / phpMyAdmin)
-- Généré le : 04 Novembre 2026
-- ============================================================

CREATE DATABASE IF NOT EXISTS `logistock` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `logistock`;

-- Suppression des tables si elles existent (dans l'ordre inverse des contraintes FK)
DROP TABLE IF EXISTS `FACTURE`;
DROP TABLE IF EXISTS `LIGNE_VENTE`;
DROP TABLE IF EXISTS `VENTE`;
DROP TABLE IF EXISTS `MOUVEMENT_STOCK`;
DROP TABLE IF EXISTS `CLIENT`;
DROP TABLE IF EXISTS `PRODUIT`;
DROP TABLE IF EXISTS `CATEGORIE`;
DROP TABLE IF EXISTS `UTILISATEUR`;
DROP TABLE IF EXISTS `ROLE`;

-- ------------------------------------------------------------
-- Structure de la table : ROLE
-- ------------------------------------------------------------
CREATE TABLE `ROLE` (
  `id_role` INT AUTO_INCREMENT NOT NULL,
  `libelle_role` VARCHAR(50) NOT NULL UNIQUE,
  `description` TEXT NULL,
  PRIMARY KEY (`id_role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Structure de la table : UTILISATEUR
-- ------------------------------------------------------------
CREATE TABLE `UTILISATEUR` (
  `id_utilisateur` INT AUTO_INCREMENT NOT NULL,
  `nom` VARCHAR(100) NOT NULL,
  `email` VARCHAR(150) NOT NULL UNIQUE,
  `mot_de_passe` VARCHAR(255) NOT NULL,
  `date_creation` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_role` INT NOT NULL,
  PRIMARY KEY (`id_utilisateur`),
  CONSTRAINT `fk_utilisateur_role` FOREIGN KEY (`id_role`) REFERENCES `ROLE` (`id_role`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Structure de la table : CATEGORIE
-- ------------------------------------------------------------
CREATE TABLE `CATEGORIE` (
  `id_categorie` INT AUTO_INCREMENT NOT NULL,
  `nom_categorie` VARCHAR(100) NOT NULL UNIQUE,
  `description` TEXT NULL,
  PRIMARY KEY (`id_categorie`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Structure de la table : PRODUIT
-- ------------------------------------------------------------
CREATE TABLE `PRODUIT` (
  `id_produit` INT AUTO_INCREMENT NOT NULL,
  `reference` VARCHAR(50) NOT NULL UNIQUE,
  `designation` VARCHAR(150) NOT NULL,
  `prix_unitaire` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `quantite_stock` INT NOT NULL DEFAULT 0,
  `seuil_alerte` INT NOT NULL DEFAULT 5,
  `id_categorie` INT NOT NULL,
  PRIMARY KEY (`id_produit`),
  CONSTRAINT `fk_produit_categorie` FOREIGN KEY (`id_categorie`) REFERENCES `CATEGORIE` (`id_categorie`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Structure de la table : MOUVEMENT_STOCK
-- ------------------------------------------------------------
CREATE TABLE `MOUVEMENT_STOCK` (
  `id_mouvement` INT AUTO_INCREMENT NOT NULL,
  `type_mouvement` ENUM('ENTREE', 'SORTIE', 'AJUSTEMENT') NOT NULL,
  `quantite` INT NOT NULL,
  `date_mouvement` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `commentaire` TEXT NULL,
  `id_produit` INT NOT NULL,
  `id_utilisateur` INT NOT NULL,
  PRIMARY KEY (`id_mouvement`),
  CONSTRAINT `fk_mvt_produit` FOREIGN KEY (`id_produit`) REFERENCES `PRODUIT` (`id_produit`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_mvt_utilisateur` FOREIGN KEY (`id_utilisateur`) REFERENCES `UTILISATEUR` (`id_utilisateur`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Structure de la table : CLIENT
-- ------------------------------------------------------------
CREATE TABLE `CLIENT` (
  `id_client` INT AUTO_INCREMENT NOT NULL,
  `nom_raison_sociale` VARCHAR(150) NOT NULL,
  `email` VARCHAR(150) NULL,
  `telephone` VARCHAR(30) NULL,
  `adresse` TEXT NULL,
  PRIMARY KEY (`id_client`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Structure de la table : VENTE
-- ------------------------------------------------------------
CREATE TABLE `VENTE` (
  `id_vente` INT AUTO_INCREMENT NOT NULL,
  `numero_vente` VARCHAR(50) NOT NULL UNIQUE,
  `date_vente` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `statut_vente` VARCHAR(50) NOT NULL DEFAULT 'PAYEE',
  `montant_total` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `id_client` INT NOT NULL,
  `id_utilisateur` INT NOT NULL,
  PRIMARY KEY (`id_vente`),
  CONSTRAINT `fk_vente_client` FOREIGN KEY (`id_client`) REFERENCES `CLIENT` (`id_client`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_vente_utilisateur` FOREIGN KEY (`id_utilisateur`) REFERENCES `UTILISATEUR` (`id_utilisateur`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Structure de la table : LIGNE_VENTE
-- ------------------------------------------------------------
CREATE TABLE `LIGNE_VENTE` (
  `id_vente` INT NOT NULL,
  `id_produit` INT NOT NULL,
  `quantite` INT NOT NULL,
  `prix_unitaire` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id_vente`, `id_produit`),
  CONSTRAINT `fk_lv_vente` FOREIGN KEY (`id_vente`) REFERENCES `VENTE` (`id_vente`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_lv_produit` FOREIGN KEY (`id_produit`) REFERENCES `PRODUIT` (`id_produit`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Structure de la table : FACTURE (Nouveau / Mis à jour)
-- ------------------------------------------------------------
CREATE TABLE `FACTURE` (
  `id_facture` INT AUTO_INCREMENT NOT NULL,
  `numero_facture` VARCHAR(50) NOT NULL UNIQUE,
  `date_emission` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `chemin_pdf` VARCHAR(255) NULL,
  `id_vente` INT NOT NULL,
  PRIMARY KEY (`id_facture`),
  CONSTRAINT `fk_facture_vente` FOREIGN KEY (`id_vente`) REFERENCES `VENTE` (`id_vente`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- JEU DE DONNÉES DE TEST / INSERTS
-- ============================================================

-- Roles
INSERT INTO `ROLE` (`id_role`, `libelle_role`, `description`) VALUES
(1, 'Administrateur', 'Accès complet au système LogiStock'),
(2, 'Gestionnaire de Stock', 'Gestion des produits, catégories et mouvements de stock'),
(3, 'Vendeur', 'Gestion des ventes et factures');

-- Utilisateurs
INSERT INTO `UTILISATEUR` (`id_utilisateur`, `nom`, `email`, `mot_de_passe`, `id_role`) VALUES
(1, 'Oumar Camara', 'oumar.admin@logistock.ml', '$2y$10$e8T/k6v8S9/7E.Zk2vR7u.8aK7B/k9kR5F4S8B1C2D3E4F5G6', 1),
(2, 'Aminata Diallo', 'aminata.stock@logistock.ml', '$2y$10$e8T/k6v8S9/7E.Zk2vR7u.8aK7B/k9kR5F4S8B1C2D3E4F5G6', 2),
(3, 'Moussa Traoré', 'moussa.vente@logistock.ml', '$2y$10$e8T/k6v8S9/7E.Zk2vR7u.8aK7B/k9kR5F4S8B1C2D3E4F5G6', 3);

-- Catégories
INSERT INTO `CATEGORIE` (`id_categorie`, `nom_categorie`, `description`) VALUES
(1, 'Informatique & Ordinateurs', 'Matériels informatiques et PC de bureau/portables'),
(2, 'Périphériques & Accessoires', 'Claviers, souris, câbles et écrans'),
(3, 'Réseau & Connectivité', 'Routeurs, switchs et câbles réseau');

-- Produits
INSERT INTO `PRODUIT` (`id_produit`, `reference`, `designation`, `prix_unitaire`, `quantite_stock`, `seuil_alerte`, `id_categorie`) VALUES
(1, 'REF-HP-001', 'Ordinateur Portable HP Core i5', 350000.00, 15, 3, 1),
(2, 'REF-SOU-002', 'Souris Optique Sans Fil', 7500.00, 50, 10, 2),
(3, 'REF-CLA-003', 'Clavier Mécanique RGB', 25000.00, 25, 5, 2),
(4, 'REF-ECR-004', 'Écran 24 pouces Full HD', 85000.00, 12, 2, 2),
(5, 'REF-CAB-005', 'Câble HDMI 2m', 3500.00, 100, 15, 3);

-- Mouvements de stock
INSERT INTO `MOUVEMENT_STOCK` (`id_mouvement`, `type_mouvement`, `quantite`, `commentaire`, `id_produit`, `id_utilisateur`) VALUES
(1, 'ENTREE', 20, 'Approvisionnement initial', 1, 2),
(2, 'ENTREE', 60, 'Stock initial reçus du fournisseur', 2, 2),
(3, 'SORTIE', 2, 'Vente N° VTE-2026-001', 2, 3);

-- Clients
INSERT INTO `CLIENT` (`id_client`, `nom_raison_sociale`, `email`, `telephone`, `adresse`) VALUES
(1, 'Société Bamako Tech', 'contact@bamakotech.ml', '+223 70 00 00 01', 'Hamdallaye ACI 2000, Bamako'),
(2, 'Ibrahim Koné', 'ibrahim.kone@gmail.com', '+223 66 11 22 33', 'Badalabougou, Bamako'),
(3, 'Client Comptoir', NULL, NULL, 'Vente directe au comptoir');

-- Ventes
INSERT INTO `VENTE` (`id_vente`, `numero_vente`, `date_vente`, `statut_vente`, `montant_total`, `id_client`, `id_utilisateur`) VALUES
(1, 'VTE-2026-001', '2026-11-01 10:30:00', 'PAYEE', 365000.00, 1, 3),
(2, 'VTE-2026-002', '2026-11-02 14:15:00', 'PAYEE', 35500.00, 2, 3),
(3, 'VTE-2026-003', '2026-11-04 09:00:00', 'PAYEE', 170000.00, 3, 1);

-- Lignes de vente
INSERT INTO `LIGNE_VENTE` (`id_vente`, `id_produit`, `quantite`, `prix_unitaire`) VALUES
(1, 1, 1, 350000.00),
(1, 2, 2, 7500.00),
(2, 3, 1, 25000.00),
(2, 5, 3, 3500.00),
(3, 4, 2, 85000.00);

-- Factures (Nouveau)
INSERT INTO `FACTURE` (`id_facture`, `numero_facture`, `date_emission`, `chemin_pdf`, `id_vente`) VALUES
(1, 'FAC-2026-001', '2026-11-01 10:35:00', 'uploads/factures/FAC-2026-001.pdf', 1),
(2, 'FAC-2026-002', '2026-11-02 14:20:00', 'uploads/factures/FAC-2026-002.pdf', 2),
(3, 'FAC-2026-003', '2026-11-04 09:05:00', 'uploads/factures/FAC-2026-003.pdf', 3);
