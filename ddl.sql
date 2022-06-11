SELECT * FROM EMPLOYEES;



-- Tabel valuta


CREATE TABLE GLI_VALUTA (
    simbol VARCHAR2(3) PRIMARY KEY NOT NULL,
    denumire VARCHAR2(50) NOT NULL,
    usd_price NUMBER NOT NULL,
    CONSTRAINT gli_valuta_usd_price_gt_0
        CHECK ( usd_price > 0 )
)


-- Creare tabel tara

CREATE TABLE GLI_TARA (
    denumire_tara VARCHAR2(60) PRIMARY KEY NOT NULL
)

-- Creare tabel oras

CREATE TABLE GLI_ORAS (
    denumire_oras VARCHAR2(100) PRIMARY KEY NOT NULL
)

-- Creare tabel locatie

CREATE TABLE GLI_LOCATIE (
    id NUMBER PRIMARY KEY NOT NULL,
    tara VARCHAR2(60) NOT NULL,
    oras VARCHAR2(100) NOT NULL,
    CONSTRAINT gli_locatie_tara_fk FOREIGN KEY(tara) REFERENCES GLI_TARA(denumire_tara),
    CONSTRAINT gli_locatie_oras_fk FOREIGN KEY(oras) REFERENCES GLI_ORAS(denumire_oras)
)

-- Creare sequence pt ID auto incrementat

CREATE SEQUENCE gli_locatie_pk_seq;


-- Adaugam un trigger la inserarea locatiilor in tabel pentru a
-- adauga id-ul corespunzator


CREATE OR REPLACE TRIGGER gli_locatie_on_insert
    BEFORE INSERT ON GLI_LOCATIE
    FOR EACH ROW
    BEGIN
        SELECT gli_locatie_pk_seq.nextval
            INTO :new.id
        FROM DUAL;
    END;



-- Creare tabel companie


CREATE TABLE GLI_COMPANIE (
    cui VARCHAR2(50) PRIMARY KEY NOT NULL,
    denumire VARCHAR2(50)  NOT NULL,
    evaluare_usd NUMBER NOT NULL,
    cifra_afaceri_usd NUMBER NOT NULL,
        CONSTRAINT gli_companie_evaluare_usd_gt_0 CHECK ( evaluare_usd > 0 ),
        CONSTRAINT gli_companie_ca_usd_gt_0 CHECK ( cifra_afaceri_usd > 0 )
)


-- Creare tabel sediu companie

CREATE TABLE GLI_SEDIU (
    id_locatie NUMBER NOT NULL,
    id_companie VARCHAR2(50) NOT NULL,
    CONSTRAINT gli_sediu_pk PRIMARY KEY (id_locatie, id_companie),
    CONSTRAINT gli_sediu_comp_fk FOREIGN KEY (id_locatie) REFERENCES GLI_LOCATIE(id),
    CONSTRAINT gli_sediu_locatie_fk FOREIGN KEY (id_companie) REFERENCES GLI_COMPANIE(cui)
)


-- Creare tabel manager


CREATE TABLE GLI_MANAGER (
    id NUMBER NOT NULL PRIMARY KEY,
    nume VARCHAR2(50) NOT NULL,
    prenume VARCHAR2(50) NOT NULL,
    ani_experienta NUMBER NOT NULL,
    CONSTRAINT gli_manager_ae_gt0 CHECK ( ani_experienta > 0 )
)



-- Creare sequence pt ID auto incrementat

CREATE SEQUENCE gli_manager_pk_seq;


-- Adaugam un trigger la inserarea managerilor in tabel pentru a
-- adauga id-ul corespunzator


CREATE OR REPLACE TRIGGER gli_manager_on_insert
    BEFORE INSERT ON GLI_MANAGER
    FOR EACH ROW
    BEGIN
        SELECT gli_manager_pk_seq.nextval
            INTO :new.id
        FROM DUAL;
    END;



-- Creare tabel piata bursiera





CREATE TABLE GLI_PIATA_BURSIERA (
    id NUMBER NOT NULL PRIMARY KEY,
    simbol VARCHAR2(10) NOT NULL ,
    denumire VARCHAR2(50) NOT NULL,
    an_infiintare NUMBER NOT NULL,
    id_locatie NUMBER NOT NULL,
    CONSTRAINT gli_pb_locatie_fk FOREIGN KEY (id_locatie) REFERENCES GLI_LOCATIE(id),
    CONSTRAINT gli_pb_ai_gt1600 CHECK ( an_infiintare > 1600)
)

-- Creare sequence pt ID auto incrementat

CREATE SEQUENCE gli_pb_pk_seq;


-- Adaugam un trigger la inserarea pietelor bursiere in tabel pentru a
-- adauga id-ul corespunzator


CREATE OR REPLACE TRIGGER gli_pb_on_insert
    BEFORE INSERT ON GLI_PIATA_BURSIERA
    FOR EACH ROW
    BEGIN
        SELECT gli_pb_pk_seq.nextval
            INTO :new.id
        FROM DUAL;
    END;



-- Creare tabel actiuni


CREATE TABLE GLI_ACTIUNE (
    simbol VARCHAR2(10) NOT NULL PRIMARY KEY,
    pret_usd NUMBER NOT NULL ,
    id_companie VARCHAR2(50)  NOT NULL,
    id_piata_bursiera NUMBER NOT NULL,
    CONSTRAINT gli_actiune_companie_fk FOREIGN KEY (id_companie) REFERENCES GLI_COMPANIE(cui),
    CONSTRAINT gli_actiune_pb_fk FOREIGN KEY (id_piata_bursiera) REFERENCES GLI_PIATA_BURSIERA(id),
        CONSTRAINT gli_actiune_pret_gt0 CHECK ( pret_usd >= 0 )
)



-- Creare tabel broker



CREATE TABLE GLI_BROKER (
    id NUMBER NOT NULL PRIMARY KEY,
    denumire VARCHAR2(50) NOT NULL,
    an_infiintare NUMBER NOT NULL,
     id_locatie NUMBER NOT NULL,
    CONSTRAINT gli_broker_locatie_fk FOREIGN KEY (id_locatie) REFERENCES GLI_LOCATIE(id),
    CONSTRAINT gli_broker_ai_gt0 CHECK ( an_infiintare > 0 )
)



-- Creare sequence pt ID auto incrementat

CREATE SEQUENCE gli_broker_pk_seq;


-- Adaugam un trigger la inserarea brokerilor in tabel pentru a
-- adauga id-ul corespunzator


CREATE OR REPLACE TRIGGER gli_broker_on_insert
    BEFORE INSERT ON GLI_BROKER
    FOR EACH ROW
    BEGIN
        SELECT gli_broker_pk_seq.nextval
            INTO :new.id
        FROM DUAL;
    END;


-- Creare tabel client

CREATE TABLE GLI_CLIENT (
    id NUMBER PRIMARY KEY NOT NULL ,
    id_manager NUMBER,
    vechime_client NUMBER NOT NULL,
    id_locatie NUMBER NOT NULL,
    CONSTRAINT gli_client_locatie_fk FOREIGN KEY (id_locatie) REFERENCES GLI_LOCATIE(id),
    CONSTRAINT gli_client_manager_fk FOREIGN KEY (id_manager) REFERENCES GLI_MANAGER(id),
    CONSTRAINT gli_client_vc_gte0 CHECK ( vechime_client > 0 )
)

-- Creare sequence pt ID auto incrementat

CREATE SEQUENCE gli_client_pk_seq;


-- Adaugam un trigger la inserarea clientilor in tabel pentru a
-- adauga id-ul corespunzator


CREATE OR REPLACE TRIGGER gli_client_on_insert
    BEFORE INSERT ON GLI_CLIENT
    FOR EACH ROW
    BEGIN
        SELECT gli_client_pk_seq.nextval
            INTO :new.id
        FROM DUAL;
    END;


-- Creare tabel client retail

CREATE TABLE GLI_CLIENT_RETAIL (
    cnp VARCHAR2(50) PRIMARY KEY NOT NULL,
    nume VARCHAR2(50) NOT NULL,
    prenume VARCHAR2(50) NOT NULL,
    data_nastere DATE,
    id_entitate_parinte NUMBER NOT NULL,
    CONSTRAINT gli_client_rtp_fk FOREIGN KEY (id_entitate_parinte) REFERENCES GLI_CLIENT(id)
)


-- Creare tabel client corporate


CREATE TABLE GLI_CLIENT_CORPORATE (
    cui VARCHAR2(50) PRIMARY KEY NOT NULL,
    an_infiintare VARCHAR2(4) NOT NULL,
    cifra_afaceri_usd NUMBER,
    numar_angajati NUMBER NOT NULL,
    id_entitate_parinte NUMBER NOT NULL,
    CONSTRAINT gli_client_cpp_fk FOREIGN KEY (id_entitate_parinte) REFERENCES GLI_CLIENT(id)
)


-- Creare tabel portofoliu


CREATE TABLE GLI_PORTOFOLIU (
        id NUMBER PRIMARY KEY NOT NULL,
        denumire VARCHAR2(50) NOT NULL,
        data_creare DATE NOT NULL,
        tip_portofoliu VARCHAR(1) NOT NULL,
        id_client NUMBER NOT NULL,
        CONSTRAINT gli_portofoliu_client_fk FOREIGN KEY (id_client) REFERENCES GLI_CLIENT(id),
        CONSTRAINT gli_portofoliu_valid_type CHECK ( tip_portofoliu IN ('C', 'A', 'O'))
)


-- Creare sequence pt ID auto incrementat

CREATE SEQUENCE gli_portofoliu_pk_seq;


-- Adaugam un trigger la inserarea portofoliilor in tabel pentru a
-- adauga id-ul corespunzator


CREATE OR REPLACE TRIGGER gli_portofoliu_on_insert
    BEFORE INSERT ON GLI_PORTOFOLIU
    FOR EACH ROW
    BEGIN
        SELECT gli_portofoliu_pk_seq.nextval
            INTO :new.id
        FROM DUAL;
    END;



-- Creare tabel portofoliu crypto

CREATE TABLE GLI_PORTOFOLIU_CRYPTO (
    id NUMBER PRIMARY KEY NOT NULL ,
    custodial NUMBER(1) DEFAULT 0 NOT NULL,
    CONSTRAINT gli_pcp_fk FOREIGN KEY (id) REFERENCES GLI_CLIENT(id)
)


-- Creare tabel portofoliu actiuni

CREATE TABLE GLI_PORTOFOLIU_ACTIUNI (
    id NUMBER PRIMARY KEY NOT NULL ,
    grad_risc NUMBER DEFAULT 0 NOT NULL,
    CONSTRAINT gli_pap_fk FOREIGN KEY (id) REFERENCES GLI_CLIENT(id)
)



-- Creare tabel portofoliu obligatiuni

CREATE TABLE GLI_PORTOFOLIU_OBLIGATIUNI (
    id NUMBER PRIMARY KEY NOT NULL ,
    CONSTRAINT gli_pop_fk FOREIGN KEY (id) REFERENCES GLI_CLIENT(id)
)


-- Create tabel blockchain


CREATE TABLE GLI_BLOCKCHAIN (
    id NUMBER PRIMARY KEY NOT NULL,
    denumire VARCHAR2(50),
    an_infiintare VARCHAR2(4),
    tip_protocol VARCHAR2(20)
)


-- Creare sequence pt ID auto incrementat

CREATE SEQUENCE gli_blockchain_pk_seq;


-- Adaugam un trigger la inserarea de blockchain-uri in tabel pentru a
-- adauga id-ul corespunzator


CREATE OR REPLACE TRIGGER gli_blockchain_on_insert
    BEFORE INSERT ON GLI_BLOCKCHAIN
    FOR EACH ROW
    BEGIN
        SELECT gli_blockchain_pk_seq.nextval
            INTO :new.id
        FROM DUAL;
    END;


-- Creare tabel criptomoneda



CREATE TABLE GLI_CRIPTOMONEDA (
    simbol VARCHAR2(5) PRIMARY KEY NOT NULL,
    pret_usd NUMBER NOT NULL,
    id_blockchain NUMBER NOT NULL ,
    data_update_pret DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT gli_cb_fk FOREIGN KEY (id_blockchain) REFERENCES GLI_BLOCKCHAIN(id),
    CONSTRAINT gli_cp_gte0 CHECK ( pret_usd >= 0 )
)


-- Creare tabel obligatiune

CREATE TABLE GLI_OBLIGATIUNE (
    simbol VARCHAR2(5) PRIMARY KEY NOT NULL,
    pret_usd NUMBER NOT NULL
    CONSTRAINT gli_op_gte0 CHECK ( pret_usd >= 0 )
)

-- Creare tabel tranzactie

CREATE TABLE GLI_TRANZACTIE (
    id NUMBER NOT NULL PRIMARY KEY ,
    tip_activ_tranzactionat VARCHAR2(1) NOT NULL ,
    tip_tranzactie VARCHAR2(10) NOT NULL,
    cantitate_activ NUMBER NOT NULL,
    pret_activ NUMBER NOT NULL ,
    simbol_valuta VARCHAR2(2) NOT NULL ,
    taxa_procesare NUMBER NOT NULL ,
    id_broker NUMBER NOT NULL,
    CONSTRAINT gli_tranzactie_valuta_fk FOREIGN KEY (simbol_valuta) REFERENCES GLI_VALUTA(simbol),
    CONSTRAINT gli_tranzactie_broker_fk FOREIGN KEY (id_broker) REFERENCES GLI_BROKER(id),
    CONSTRAINT gli_tranzactie_qty_gt0 CHECK ( cantitate_activ > 0 ),
    CONSTRAINT gli_tranzactie_price_gt0 CHECK ( pret_activ > 0 ),
    CONSTRAINT gli_tranzactie_tp_gt0 CHECK ( taxa_procesare > 0 ),
    CONSTRAINT gli_tat_valid_type CHECK ( tip_activ_tranzactionat IN ('C', 'A', 'O')),
    CONSTRAINT gli_tt_valid_type CHECK ( tip_tranzactie IN ('SELL', 'BUY', 'STAKE', 'UNSTAKE'))
)



-- Creare sequence pt ID auto incrementat

CREATE SEQUENCE gli_tranzactie_pk_seq;


-- Adaugam un trigger la inserarea de tranzactii in tabel pentru a
-- adauga id-ul corespunzator


CREATE OR REPLACE TRIGGER gli_tranzactie_on_insert
    BEFORE INSERT ON GLI_TRANZACTIE
    FOR EACH ROW
    BEGIN
        SELECT gli_tranzactie_pk_seq.nextval
            INTO :new.id
        FROM DUAL;
    END;



-- Creare tabel tranzactie crypto



CREATE TABLE GLI_TRANZACTIE_CRYPTO (
    id NUMBER NOT NULL PRIMARY KEY,
    simbol_criptomoneda VARCHAR2(5) NOT NULL,
    taxa_procesare_blockchain NUMBER  DEFAULT  0 NOT NULL,
    link_tranzactie_blockchain VARCHAR2(500),
    CONSTRAINT gli_tc_sc_fk FOREIGN KEY (simbol_criptomoneda) REFERENCES GLI_CRIPTOMONEDA(simbol),
    CONSTRAINT gli_tc_tpb_gte0 CHECK ( taxa_procesare_blockchain >= 0 ),
    CONSTRAINT gli_tc_id_fk FOREIGN KEY (id) REFERENCES GLI_TRANZACTIE(id)
)


-- Creare tabel tranzactie actiuni


CREATE TABLE GLI_TRANZACTIE_ACTIUNI (
    id NUMBER NOT NULL PRIMARY KEY,
    simbol_actiune VARCHAR2(5) NOT NULL,
    CONSTRAINT gli_ta_ia_fk FOREIGN KEY (simbol_actiune) REFERENCES GLI_ACTIUNE(simbol),
    CONSTRAINT gli_ta_id_fk FOREIGN KEY (id) REFERENCES GLI_TRANZACTIE(id)
)

-- Creare tabel tranzactie obligatiuni


CREATE TABLE GLI_TRANZACTIE_OBLIGATIUNI (
    id NUMBER NOT NULL PRIMARY KEY,
    simbol_obligatiune VARCHAR2(5) NOT NULL,
    CONSTRAINT gli_to_so_fk FOREIGN KEY (simbol_obligatiune) REFERENCES GLI_OBLIGATIUNE(simbol),
    CONSTRAINT gli_to_id_fk FOREIGN KEY (id) REFERENCES GLI_TRANZACTIE(id)
)

-- Creare tabel semnatura tranzactie crypto


CREATE TABLE GLI_SEM_TRANZACTIE_CRYPTO (
    id NUMBER NOT NULL PRIMARY KEY,
    id_portofoliu NUMBER NOT NULL,
    tip_activ_tranzactionat VARCHAR2(1) NOT NULL,
    tip_portofoliu VARCHAR2(1) NOT NULL,
        CONSTRAINT gli_stc_id_fk FOREIGN KEY (id) REFERENCES GLI_TRANZACTIE(id),
        CONSTRAINT gli_stc_ip_fk FOREIGN KEY (id_portofoliu) REFERENCES GLI_PORTOFOLIU(id),
        CONSTRAINT gli_stc_valid_tattype CHECK ( tip_activ_tranzactionat IN ('C')),
        CONSTRAINT gli_stc_ccy CHECK (tip_activ_tranzactionat = tip_portofoliu)
)



-- Creare tabel semnatura tranzactie actiuni




CREATE TABLE GLI_SEM_TRANZACTIE_ACTIUNI (
    id NUMBER NOT NULL PRIMARY KEY,
    id_portofoliu NUMBER NOT NULL,
    tip_activ_tranzactionat VARCHAR2(1) NOT NULL,
    tip_portofoliu VARCHAR2(1) NOT NULL,
        CONSTRAINT gli_sta_id_fk FOREIGN KEY (id) REFERENCES GLI_TRANZACTIE(id),
        CONSTRAINT gli_sta_ip_fk FOREIGN KEY (id_portofoliu) REFERENCES GLI_PORTOFOLIU(id),
        CONSTRAINT gli_sta_valid_tattype CHECK ( tip_activ_tranzactionat IN ( 'A')),
        CONSTRAINT gli_sta_ccy CHECK (tip_activ_tranzactionat = tip_portofoliu)
)


-- Creare tabel semnatura tranzactie obligatiuni




CREATE TABLE GLI_SEM_TRANZACTIE_OBLIGATIUNI (
    id NUMBER NOT NULL PRIMARY KEY,
    id_portofoliu NUMBER NOT NULL,
    tip_activ_tranzactionat VARCHAR2(1) NOT NULL,
    tip_portofoliu VARCHAR2(1) NOT NULL,
        CONSTRAINT gli_sto_id_fk FOREIGN KEY (id) REFERENCES GLI_TRANZACTIE(id),
        CONSTRAINT gli_sto_ip_fk FOREIGN KEY (id_portofoliu) REFERENCES GLI_PORTOFOLIU(id),
        CONSTRAINT gli_sto_valid_tattype CHECK ( tip_activ_tranzactionat IN ( 'O')),
        CONSTRAINT gli_sto_ccy CHECK (tip_activ_tranzactionat = tip_portofoliu)
)