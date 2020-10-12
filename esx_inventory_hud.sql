USE `es_extended`;


-- Só não posso esquecer de colocar que é preciso alterar o commom.lua:29 do es_extended para puxar essa info do banco e no server do es_extended
ALTER TABLE `items`
	ADD COLUMN `icon` VARCHAR(16) NULL DEFAULT NULL;
