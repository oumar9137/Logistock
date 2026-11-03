-- ============================================================
-- Base de données : LogiStock
-- Compatible avec MySQL / MariaDB (XAMPP / phpMyAdmin)
-- Généré le : 03 Novembre 2026
-- ============================================================

CREATE DATABASE IF NOT EXISTS `logistock` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `logistock`;

-- ------------------------------------------------------------
-- Structure de la table : ROLE
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `ROLE_PERMISSION`;
DROP TABLE IF EXISTS `LIGNE_VENTE`;
DROP TABLE IF EXISTS `VENTE`;
DROP TABLE IF EXISTS `PRODUIT`;
DROP TABLE IF EXISTS `UTILISATEUR`;
DROP TABLE IF EXISTS `PERMISSION`;
DROP TABLE IF EXISTS `ROLE`;

CREATE TABLE `ROLE` (
  `id_role` INT AUTO_INCREMENT NOT NULL,
  `libelle` VARCHAR(50) NOT NULL UNIQUE,
  PRIMARY KEY (`id_role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Structure de la table : PERMISSION
-- ------------------------------------------------------------
CREATE TABLE `PERMISSION` (
  `id_permission` INT AUTO_INCREMENT NOT NULL,
  `libelle` VARCHAR(100) NOT NULL UNIQUE,
  `description` TEXT NULL,
  PRIMARY KEY (`id_permission`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Structure de la table : UTILISATEUR
-- ------------------------------------------------------------
CREATE TABLE `UTILISATEUR` (
  `id_utilisateur` INT AUTO_INCREMENT NOT NULL,
  `nom` VARCHAR(100) NOT NULL,
  `email` VARCHAR(150) NOT NULL UNIQUE,
  `mot_de_passe` VARCHAR(255) NOT NULL,
  `id_role` INT NOT NULL,
  PRIMARY KEY (`id_utilisateur`),
  CONSTRAINT `fk_utilisateur_role` FOREIGN KEY (`id_role`) REFERENCES `ROLE` (`id_role`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Structure de la table : ROLE_PERMISSION
-- ------------------------------------------------------------
CREATE TABLE `ROLE_PERMISSION` (
  `id_role` INT NOT NULL,
  `id_permission` INT NOT NULL,
  PRIMARY KEY (`id_role`, `id_permission`),
  CONSTRAINT `fk_rp_role` FOREIGN KEY (`id_role`) REFERENCES `ROLE` (`id_role`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_rp_permission` FOREIGN KEY (`id_permission`) REFERENCES `PERMISSION` (`id_permission`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Structure de la table : PRODUIT
-- ------------------------------------------------------------
CREATE TABLE `PRODUIT` (
  `id_produit` INT AUTO_INCREMENT NOT NULL,
  `nom` VARCHAR(150) NOT NULL,
  `quantite_stock` INT NOT NULL DEFAULT 0,
  `seuil_minimum` INT NOT NULL DEFAULT 5,
  `prix_unitaire` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id_produit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Structure de la table : VENTE
-- ------------------------------------------------------------
CREATE TABLE `VENTE` (
  `id_vente` INT AUTO_INCREMENT NOT NULL,
  `date_vente` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_utilisateur` INT NOT NULL,
  PRIMARY KEY (`id_vente`),
  CONSTRAINT `fk_vente_utilisateur` FOREIGN KEY (`id_utilisateur`) REFERENCES `UTILISATEUR` (`id_utilisateur`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Structure de la table : LIGNE_VENTE
-- ------------------------------------------------------------
CREATE TABLE `LIGNE_VENTE` (
  `id_vente` INT NOT NULL,
  `id_produit` INT NOT NULL,
  `quantite` INT NOT NULL,
  `prix_vente` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id_vente`, `id_produit`),
  CONSTRAINT `fk_lv_vente` FOREIGN KEY (`id_vente`) REFERENCES `VENTE` (`id_vente`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_lv_produit` FOREIGN KEY (`id_produit`) REFERENCES `PRODUIT` (`id_produit`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- INSERTS / DONNÉES DE TEST
-- ============================================================

-- Roles
INSERT INTO `ROLE` (`id_role`, `libelle`) VALUES
(1, 'Administrateur'),
(2, 'Gestionnaire de Stock'),
(3, 'Vendeur');

-- Permissions
INSERT INTO `PERMISSION` (`id_permission`, `libelle`, `description`) VALUES
(1, 'Gérer les utilisateurs', 'Accès total à la création et modification des comptes'),
(2, 'Gérer le stock', 'Ajout, modification et suppression des articles en stock'),
(3, 'Effectuer une vente', 'Enregistrement des ventes clients'),
(4, 'Consulter les rapports', 'Voir les statistiques et historiques des ventes');

-- Role_Permission
INSERT INTO `ROLE_PERMISSION` (`id_role`, `id_permission`) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), -- Admin a tout
(2, 2), (2, 4),                 -- Gestionnaire
(3, 3);                         -- Vendeur

-- Utilisateurs (mot de passe hashé fictif/exemple)
INSERT INTO `UTILISATEUR` (`id_utilisateur`, `nom`, `email`, `mot_de_passe`, `id_role`) VALUES
(1, 'Oumar Camara', 'oumar.admin@logistock.ml', '$2y$10$e8T/k6v8S9/7E.Zk2vR7u.8aK7B/k9kR5F4S8B1C2D3E4F5G6', 1),
(2, 'Aminata Diallo', 'aminata.stock@logistock.ml', '$2y$10$e8T/k6v8S9/7E.Zk2vR7u.8aK7B/k9kR5F4S8B1C2D3E4F5G6', 2),
(3, 'Moussa Traoré', 'moussa.vente@logistock.ml', '$2y$10$e8T/k6v8S9/7E.Zk2vR7u.8aK7B/k9kR5F4S8B1C2D3E4F5G6', 3);

-- Produits
INSERT INTO `PRODUIT` (`id_produit`, `nom`, `quantite_stock`, `seuil_minimum`, `prix_unitaire`) VALUES
(1, 'Ordinateur Portable HP Core i5', 15, 3, 350000.00),
(2, 'Souris Optique Sans Fil', 50, 10, 7500.00),
(3, 'Clavier Mécanique RGB', 25, 5, 25000.00),
(4, 'Écran 24 pouces Full HD', 12, 2, 85000.00),
(5, 'Câble HDMI 2m', 100, 15, 3500.00);

-- Ventes
INSERT INTO `VENTE` (`id_vente`, `date_vente`, `id_utilisateur`) VALUES
(1, '2026-11-01 10:30:00', 3),
(2, '2026-11-02 14:15:00', 3),
(3, '2026-11-03 09:00:00', 1);

-- Lignes de Vente
INSERT INTO `LIGNE_VENTE` (`id_vente`, `id_produit`, `quantite`, `prix_vente`) VALUES
(1, 1, 1, 350000.00),
(1, 2, 2, 7500.00),
(2, 3, 1, 25000.00),
(2, 5, 3, 3500.00),
(3, 4, 2, 85000.00);
