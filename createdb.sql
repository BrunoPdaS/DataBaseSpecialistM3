

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema ecommerce
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `ecommerce` ;

-- -----------------------------------------------------
-- Schema ecommerce
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ecommerce` DEFAULT CHARACTER SET utf8 ;
USE `ecommerce` ;

-- -----------------------------------------------------
-- Table `ecommerce`.`categoria_produto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ecommerce`.`categoria_produto` ;

CREATE TABLE IF NOT EXISTS `ecommerce`.`categoria_produto` (
  `idcategoria` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idcategoria`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`produto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ecommerce`.`produto` ;

CREATE TABLE IF NOT EXISTS `ecommerce`.`produto` (
  `idProduto` INT NOT NULL AUTO_INCREMENT,
  `Categoria` INT NULL DEFAULT NULL,
  `Descricao` VARCHAR(45) NULL DEFAULT NULL,
  `Valor` FLOAT NULL DEFAULT NULL,
  `categoria_produto` INT NOT NULL,
  PRIMARY KEY (`idProduto`),
  INDEX `fk_produto_categoria_produto1_idx` (`categoria_produto` ASC) VISIBLE,
  CONSTRAINT `fk_produto_categoria_produto1`
    FOREIGN KEY (`categoria_produto`)
    REFERENCES `ecommerce`.`categoria_produto` (`idcategoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`endereco_entrega`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ecommerce`.`endereco_entrega` ;

CREATE TABLE IF NOT EXISTS `ecommerce`.`endereco_entrega` (
  `idEntrega` INT NOT NULL AUTO_INCREMENT,
  `endereco` VARCHAR(45) NULL DEFAULT NULL,
  `cidade` VARCHAR(45) NULL DEFAULT NULL,
  `estado` CHAR(2) NULL DEFAULT NULL,
  `cep` VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`idEntrega`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`pessoa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ecommerce`.`pessoa` ;

CREATE TABLE IF NOT EXISTS `ecommerce`.`pessoa` (
  `idPessoa` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NULL DEFAULT NULL,
  `Identificacao` VARCHAR(8) NULL DEFAULT 'Juridica',
  `Endereco` VARCHAR(45) NULL DEFAULT NULL,
  `Cpf_cnpj` VARCHAR(14) NULL DEFAULT NULL,
  `email` VARCHAR(50) NOT NULL,
  `password` VARCHAR(45) NULL,
  `endereco_entrega` INT NOT NULL,
  `tipo_pessoa` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`idPessoa`),
  UNIQUE INDEX `Cpf_cnpj_UNIQUE` (`Cpf_cnpj` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  INDEX `fk_Pessoa_endereco_entrega1_idx` (`endereco_entrega` ASC) VISIBLE,
  CONSTRAINT `fk_Pessoa_endereco_entrega`
    FOREIGN KEY (`endereco_entrega`)
    REFERENCES `ecommerce`.`endereco_entrega` (`idEntrega`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`tipo_pedido`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ecommerce`.`tipo_pedido` ;

CREATE TABLE IF NOT EXISTS `ecommerce`.`tipo_pedido` (
  `idtipo_pedido` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(45) NULL DEFAULT NULL,
  `ativo` INT NULL DEFAULT NULL,
  PRIMARY KEY (`idtipo_pedido`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`pedido_entrega`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ecommerce`.`pedido_entrega` ;

CREATE TABLE IF NOT EXISTS `ecommerce`.`pedido_entrega` (
  `idEntrega` INT NOT NULL AUTO_INCREMENT,
  `id_pedido` INT NULL DEFAULT NULL,
  `previsao` DATE NULL DEFAULT NULL,
  `Status` CHAR(1) NULL DEFAULT NULL,
  `data_status` TIMESTAMP NULL DEFAULT NULL,
  `cod_rastreio` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`idEntrega`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`status_pedido`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ecommerce`.`status_pedido` ;

CREATE TABLE IF NOT EXISTS `ecommerce`.`status_pedido` (
  `idstatus_pedido` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idstatus_pedido`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`pedido`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ecommerce`.`pedido` ;

CREATE TABLE IF NOT EXISTS `ecommerce`.`pedido` (
  `idPedido` INT NOT NULL AUTO_INCREMENT,
  `Status` CHAR(1) NULL DEFAULT NULL,
  `Descricao` VARCHAR(45) NULL DEFAULT NULL,
  `pessoa_idPessoa` INT NOT NULL,
  `tipo_pedido_idtipo_pedido` INT NOT NULL,
  `Frete` FLOAT NULL DEFAULT NULL,
  `Entrega_idEntrega` INT NOT NULL,
  `valor_pedido` DECIMAL(18,2) NOT NULL DEFAULT 0,
  `valor_total` DECIMAL(18,2) NOT NULL,
  `status_pedido` INT NOT NULL,
  PRIMARY KEY (`idPedido`, `pessoa_idPessoa`, `status_pedido`),
  INDEX `fk_Pedido_Cliente1_idx` (`pessoa_idPessoa` ASC) VISIBLE,
  INDEX `fk_Pedido_tipo_pedido1_idx` (`tipo_pedido_idtipo_pedido` ASC) VISIBLE,
  INDEX `fk_Pedido_Entrega1_idx` (`Entrega_idEntrega` ASC) VISIBLE,
  INDEX `fk_pedido_status_pedido1_idx` (`status_pedido` ASC) VISIBLE,
  CONSTRAINT `fk_Pedido_Pessoa`
    FOREIGN KEY (`pessoa_idPessoa`)
    REFERENCES `ecommerce`.`pessoa` (`idPessoa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedido_tipo_pedido`
    FOREIGN KEY (`tipo_pedido_idtipo_pedido`)
    REFERENCES `ecommerce`.`tipo_pedido` (`idtipo_pedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedido_Entrega`
    FOREIGN KEY (`Entrega_idEntrega`)
    REFERENCES `ecommerce`.`pedido_entrega` (`idEntrega`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pedido_status_pedido`
    FOREIGN KEY (`status_pedido`)
    REFERENCES `ecommerce`.`status_pedido` (`idstatus_pedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`fornecedor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ecommerce`.`fornecedor` ;

CREATE TABLE IF NOT EXISTS `ecommerce`.`fornecedor` (
  `idfornecedor` INT NOT NULL AUTO_INCREMENT,
  `razao_social` VARCHAR(45) NULL DEFAULT NULL,
  `cnpj` VARCHAR(20) NULL DEFAULT NULL,
  `endereco` VARCHAR(45) NULL,
  `cidade` VARCHAR(45) NULL,
  `estado` CHAR(2) NULL,
  `cep` VARCHAR(10) NULL,
  PRIMARY KEY (`idfornecedor`),
  UNIQUE INDEX `CNPJ_UNIQUE` (`cnpj` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`produto_fornecedor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ecommerce`.`produto_fornecedor` ;

CREATE TABLE IF NOT EXISTS `ecommerce`.`produto_fornecedor` (
  `idfornecedor` INT NOT NULL,
  `idProduto` INT NOT NULL,
  PRIMARY KEY (`idfornecedor`, `idProduto`),
  INDEX `fk_fornecedor_has_Produto_Produto1_idx` (`idProduto` ASC) VISIBLE,
  INDEX `fk_fornecedor_has_Produto_fornecedor_idx` (`idfornecedor` ASC) VISIBLE,
  CONSTRAINT `fk_fornecedor_has_Produto_fornecedor`
    FOREIGN KEY (`idfornecedor`)
    REFERENCES `ecommerce`.`fornecedor` (`idfornecedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fornecedor_has_Produto_Produto`
    FOREIGN KEY (`idProduto`)
    REFERENCES `ecommerce`.`produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`estoque`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ecommerce`.`estoque` ;

CREATE TABLE IF NOT EXISTS `ecommerce`.`estoque` (
  `idEstoque` INT NOT NULL AUTO_INCREMENT,
  `localizacao` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`idEstoque`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`produto_Estoque`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ecommerce`.`produto_Estoque` ;

CREATE TABLE IF NOT EXISTS `ecommerce`.`produto_Estoque` (
  `Produto_idProduto` INT NOT NULL,
  `Estoque_idEstoque` INT NOT NULL,
  `Quantidade` INT NULL DEFAULT NULL,
  PRIMARY KEY (`Produto_idProduto`, `Estoque_idEstoque`),
  INDEX `fk_Produto_has_Estoque_Estoque1_idx` (`Estoque_idEstoque` ASC) VISIBLE,
  INDEX `fk_Produto_has_Estoque_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  CONSTRAINT `fk_Produto_has_Estoque_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `ecommerce`.`produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Produto_has_Estoque_Estoque1`
    FOREIGN KEY (`Estoque_idEstoque`)
    REFERENCES `ecommerce`.`estoque` (`idEstoque`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`produto_pedido`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ecommerce`.`produto_pedido` ;

CREATE TABLE IF NOT EXISTS `ecommerce`.`produto_pedido` (
  `Produto_idProduto` INT NOT NULL,
  `Pedido_idPedido` INT NOT NULL,
  `Quantidade` INT NULL DEFAULT NULL,
  PRIMARY KEY (`Produto_idProduto`, `Pedido_idPedido`),
  INDEX `fk_Produto_has_Pedido_Pedido1_idx` (`Pedido_idPedido` ASC) VISIBLE,
  INDEX `fk_Produto_has_Pedido_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  CONSTRAINT `fk_Produto_has_Pedido_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `ecommerce`.`produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Produto_has_Pedido_Pedido1`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `ecommerce`.`pedido` (`idPedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`forma_pagamento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ecommerce`.`forma_pagamento` ;

CREATE TABLE IF NOT EXISTS `ecommerce`.`forma_pagamento` (
  `idforma_pagamento` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`idforma_pagamento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`pedido_pagamento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ecommerce`.`pedido_pagamento` ;

CREATE TABLE IF NOT EXISTS `ecommerce`.`pedido_pagamento` (
  `idpedido_pagamento` INT NOT NULL AUTO_INCREMENT,
  `vencimento` DATETIME NULL DEFAULT NULL,
  `parcela` INT NULL DEFAULT NULL,
  `valor` DECIMAL(18,2) NULL DEFAULT NULL,
  `documento` VARCHAR(45) NULL DEFAULT NULL,
  `Pedido_idPedido` INT NOT NULL,
  `Pedido_Pessoa_idPessoa` INT NOT NULL,
  `Pedido_tipo_pagamento_idtipo_pagamento` INT NOT NULL,
  `forma_pagamento` INT NOT NULL,
  PRIMARY KEY (`idpedido_pagamento`, `Pedido_idPedido`, `Pedido_Pessoa_idPessoa`, `Pedido_tipo_pagamento_idtipo_pagamento`, `forma_pagamento`),
  INDEX `fk_pedido_pagamento_Pedido1_idx` (`Pedido_idPedido` ASC, `Pedido_Pessoa_idPessoa` ASC, `Pedido_tipo_pagamento_idtipo_pagamento` ASC) VISIBLE,
  INDEX `fk_pedido_pagamento_forma_pagamento1_idx` (`forma_pagamento` ASC) VISIBLE,
  CONSTRAINT `fk_pedido_pagamento_pedido`
    FOREIGN KEY (`Pedido_idPedido` , `Pedido_Pessoa_idPessoa`)
    REFERENCES `ecommerce`.`pedido` (`idPedido` , `pessoa_idPessoa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pedido_pagamento_forma_pagamento`
    FOREIGN KEY (`forma_pagamento`)
    REFERENCES `ecommerce`.`forma_pagamento` (`idforma_pagamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
