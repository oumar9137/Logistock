-- ============================================================
-- Base de données : LogiStock
-- Partie 1 : Structure des tables (DDL - sans table FACTURE)
-- Compatible avec MySQL / MariaDB (XAMPP / phpMyAdmin)
-- Généré le : 04 Novembre 2026
-- ============================================================

CREATE DATABASE IF NOT EXISTS `logistock` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `logistock`;

-- Suppression des tables si elles existent (dans l'ordre inverse des contraintes FK)
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
