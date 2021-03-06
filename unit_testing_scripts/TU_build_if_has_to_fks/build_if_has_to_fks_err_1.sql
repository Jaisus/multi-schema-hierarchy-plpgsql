create or replace procedure unit_tests.build_if_has_to_fks_err_1()
language plpgsql
as $procedure$
---------------------------------------------------------------------------------------------------------------
-- Objet : 
--		Le but de cette procédure est de tester le cas d'erreur 1 de la procédure 'build_if_has_to_fks'
--		Ce test a pour but de :
/*
	Pré-requis :
	Cas nominal 3 OK
	Obtenir les jeux de données suivants dans client_2
	test_1					test_2
	id_test_1	value		id_test_2	id_test_1	value
	1			test		1			4			test
	2			test		2			1			test
	3			test		3			1			test
	
	Action :
	Une nouvelle clé étrangère est créée référençant client_2.test_1.id_test_1 dans client_2.test_2
	
	Résultat attendu :
	Une ligne dans la table common.debugger doit apparaître comme suis :
	'[id], [date_modif], [ip], 'build_if_has_to_fks', 'Impossible de créer les clés étrangères sur client_2. Incohérence de données.', 0'
	La clé étrangère fk_00001 dans master ne doit pas être présente.
	La clé étrangère fk_00001_00001 dans client_1 ne doit pas être présente.
	La clé étrangère fk_00001_00002 dans client_2 ne doit pas être présente.
*/
-- PARTIE PREREQUIS	
-- Quel que soit le résultat de ce test, le dit résultat sera présent dans la table unit_tests.detail_report_table

-- Origines : PostgreSQL v11
---------------------------------------------------------------------------------------------------------------
--	User		Date			Motives
--	JPI			05/04/2019		Création
--	JPI			06/08/2019		Prise en compte du renommage normalisé chiffré.
--
---------------------------------------------------------------------------------------------------------------
begin
	-- Prerequisit 
	INSERT INTO client_2.test_1 (value) VALUES ('test'), ('test'), ('test');
	INSERT INTO client_2.test_2 (value, id_test_1) VALUES ('test', 4), ('test', 1), ('test', 1);	

	-- Action	
	ALTER TABLE master.test_2
	ADD CONSTRAINT fk_tttt
	FOREIGN KEY (id_test_1) REFERENCES master.test_1 (id_test_1);
			
	
	CALL unit_tests.deblog('build_if_has_to_fks_err_1', cast(0 as bit));	
	
	EXCEPTION
		WHEN others THEN
			CALL unit_tests.deblog('build_if_has_to_fks_err_1', cast(1 as bit), CAST(SQLERRM as text));
end;
$procedure$;