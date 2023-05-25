CREATE SCHEMA SEPAKBOLA;

SET SEARCH_PATH TO SEPAKBOLA;

CREATE TABLE User_System (
  Username VARCHAR(50) PRIMARY KEY,
  Password VARCHAR(20) NOT NULL
);

CREATE TABLE Tim (
    Nama_Tim VARCHAR(50) PRIMARY KEY,
    Universitas VARCHAR(50) NOT NULL
);

CREATE TABLE Pemain (
  ID_Pemain UUID PRIMARY KEY,
  Nama_Tim VARCHAR(50) REFERENCES Tim(Nama_Tim),
  Nama_Depan VARCHAR(50) NOT NULL,
  Nama_Belakang VARCHAR(50) NOT NULL,
  Nomor_HP VARCHAR(15) NOT NULL,
  Tgl_Lahir DATE NOT NULL,
  Is_Captain BOOLEAN NOT NULL,
  Posisi VARCHAR(50) NOT NULL,
  NPM VARCHAR(20) NOT NULL,
  Jenjang VARCHAR(20) NOT NULL
);

CREATE TABLE Non_Pemain (
  ID UUID PRIMARY KEY,
  Nama_Depan VARCHAR(50) NOT NULL,
  Nama_Belakang VARCHAR(50) NOT NULL,
  Nomor_HP VARCHAR(15) NOT NULL,
  Email VARCHAR(50) NOT NULL,
  Alamat VARCHAR(255) NOT NULL
);

CREATE TABLE Wasit (
  ID_Wasit UUID PRIMARY KEY,
  Lisensi VARCHAR(50) NOT NULL,
  FOREIGN KEY (ID_Wasit) REFERENCES Non_Pemain (ID)
);

CREATE TABLE Status_Non_Pemain (
  ID_Non_Pemain UUID NOT NULL,
  Status VARCHAR(50) NOT NULL,
  PRIMARY KEY (ID_Non_Pemain, Status),
  FOREIGN KEY (ID_Non_Pemain) REFERENCES Non_Pemain (ID)
);

CREATE TABLE Stadium (
  ID_Stadium UUID PRIMARY KEY,
  Nama VARCHAR(50) NOT NULL,
  Alamat VARCHAR(255) NOT NULL,
  Kapasitas INT NOT NULL
);

CREATE TABLE Perlengkapan_Stadium (
    ID_Stadium UUID REFERENCES Stadium(ID_Stadium),
    Item VARCHAR(255) NOT NULL,
    Kapasitas INT NOT NULL,
    PRIMARY KEY (ID_Stadium, Item, Kapasitas)
);

CREATE TABLE Pertandingan (
    ID_Pertandingan UUID PRIMARY KEY,
    Start_Datetime DATE NOT NULL,
    End_Datetime DATE NOT NULL,
    Stadium UUID REFERENCES Stadium(ID_Stadium)
);

CREATE TABLE Peristiwa (
    ID_Pertandingan UUID NOT NULL,
    Datetime TIMESTAMP NOT NULL,
    Jenis VARCHAR(50) NOT NULL,
    ID_Pemain UUID,
    PRIMARY KEY (ID_Pertandingan, Datetime),
    FOREIGN KEY (ID_Pertandingan) REFERENCES Pertandingan(ID_Pertandingan),
    FOREIGN KEY (ID_Pemain) REFERENCES Pemain(ID_Pemain)
);

CREATE TABLE Wasit_Bertugas (
  ID_Wasit UUID REFERENCES Wasit(ID_Wasit),
  ID_Pertandingan UUID REFERENCES Pertandingan(ID_Pertandingan),
  Posisi_Wasit VARCHAR(50) NOT NULL,
  PRIMARY KEY (ID_Wasit, ID_Pertandingan)
);

CREATE TABLE Penonton (
    ID_Penonton UUID PRIMARY KEY,
    Username VARCHAR(50) REFERENCES User_System(Username),
    FOREIGN KEY (ID_Penonton) REFERENCES Non_Pemain(ID)
);

CREATE TABLE Pembelian_Tiket (
  Nomor_Receipt VARCHAR(50) PRIMARY KEY,
  ID_Penonton UUID,
  Jenis_Tiket VARCHAR(50) NOT NULL,
  Jenis_Pembayaran VARCHAR(50) NOT NULL,
  ID_Pertandingan UUID,
  FOREIGN KEY (ID_Penonton) REFERENCES Penonton (ID_Penonton),
  FOREIGN KEY (ID_Pertandingan) REFERENCES Pertandingan (ID_Pertandingan)
);


CREATE TABLE Panitia (
    ID_Panitia UUID PRIMARY KEY REFERENCES Non_Pemain(ID),
    Jabatan VARCHAR(50) NOT NULL,
    Username VARCHAR(50) REFERENCES User_System(Username)
);

CREATE TABLE Pelatih (
   ID_Pelatih UUID PRIMARY KEY,
   Nama_Tim VARCHAR(50) REFERENCES Tim(Nama_Tim),
   FOREIGN KEY (ID_Pelatih) REFERENCES Non_Pemain(ID)
);

CREATE TABLE Spesialisasi_Pelatih (
  ID_Pelatih UUID REFERENCES Pelatih(ID_Pelatih),
  Spesialisasi VARCHAR(50) NOT NULL,
  PRIMARY KEY (ID_Pelatih, Spesialisasi)
);


CREATE TABLE Tim_Pertandingan (
    Nama_Tim VARCHAR(50) REFERENCES Tim(Nama_Tim),
    ID_Pertandingan UUID REFERENCES Pertandingan(ID_Pertandingan),
    Skor VARCHAR(50) NOT NULL,
	PRIMARY KEY (Nama_Tim, ID_Pertandingan)
);

CREATE TABLE Manajer (
  ID_Manajer UUID PRIMARY KEY REFERENCES Non_Pemain(ID),
  Username VARCHAR(50) REFERENCES User_System(Username)
);

CREATE TABLE Tim_Manajer (
    ID_Manajer UUID REFERENCES Manajer(ID_Manajer),
    Nama_Tim VARCHAR(50) REFERENCES Tim(Nama_Tim),
    PRIMARY KEY (ID_Manajer, Nama_Tim)
);

CREATE TABLE Peminjaman (
    ID_Manajer UUID REFERENCES Manajer(ID_Manajer),
    Start_Datetime DATE NOT NULL,
    End_Datetime DATE NOT NULL,
    ID_Stadium UUID REFERENCES Stadium(ID_Stadium),
    PRIMARY KEY (ID_Manajer, Start_Datetime)
);

CREATE TABLE Rapat (
    ID_Pertandingan UUID,
    Datetime TIMESTAMP NOT NULL,
    Perwakilan_Panitia UUID NOT NULL,
    Manajer_Tim_A UUID NOT NULL,
    Manajer_Tim_B UUID NOT NULL,
    Isi_Rapat TEXT NOT NULL,
    PRIMARY KEY (Datetime, Perwakilan_Panitia, Manajer_Tim_A, Manajer_Tim_B),
    FOREIGN KEY (ID_Pertandingan) REFERENCES Pertandingan(ID_Pertandingan),
    FOREIGN KEY (Perwakilan_Panitia) REFERENCES Panitia(ID_Panitia),
    FOREIGN KEY (Manajer_Tim_A) REFERENCES Manajer(ID_Manajer),
    FOREIGN KEY (Manajer_Tim_B) REFERENCES Manajer(ID_Manajer)
);

INSERT INTO User_System (Username, Password) VALUES
	('nportam0', 'qzQb4Y3Wxxq'),
	('msharrocks1', '6twwYTxPpD'),
	('gholdey2', 'sYu3whm2iJf'),
	('jslatter3', 'RnNGcfQ8'),
	('ibresner4', 'ZbASNa4q'),
	('ajumonet5', 'QmyaH4nVLf'),
	('comahony6', 'wF5gPnWg'),
	('zgeering7', 'njSTiohv61'),
	('lgrigorey8', '7tq7Lnq5zh'),
	('bainscough9', 'Hw0Om19dEL'),
	('fblesdilla', '8UlWPJ'),
	('sdiggesb', 'b7wsGrSxan86'),
	('osalandinoc', 'aKLqVkGkMeQL'),
	('gitzhakd', '1KsZD7iEqKS'),
	('felcee', 'IS4RBBsWcFpw'),
	('anorthcottf', 'bvMkVmJH'),
	('rgallehawkg', 'L9GiocRo'),
	('cmacknockerh', 'JoYCsu2'),
	('alingeri', 'Wk27xSnxprr'),
	('tmcchruiterj', 'eVA8mSm'),
	('mtomsak', 'ye6cmKIjYfNJ'),
	('vberefordl', '1wZ7e2'),
	('eriseamm', 'i0cp52ERZ'),
	('klangshawn', 'yHOnQXvTzV'),
	('mlileo', 'V4kXzH'),
	('kmurrowp', 'LUTDv41QOsMM'),
	('gshrigleyq', 'q9WBQvmbW3J'),
	('emcquarterr', 'rGlnyk3E'),
	('sclaraes', '9HROy1A'),
	('mfawket', '65vviH6vY'),
	('rgwalteru', 'Esg5nZ'),
	('rfrankv', '8vPuV81s'),
	('achicchelliw', 'Y7wzYIm'),
	('ijedraszczykx', 'WQYym8vr0xpH'),
	('fmougely', 'tSxbmJZd'),
	('galldisz', 'ITTb8Mz0'),
	('ofyers10', 'KXlRfkdM'),
	('tsimpole11', 'k34f9Nqzq'),
	('gstrond12', 'IuQ49NJ'),
	('atearney13', 'uo7c7aG8H'),
	('rlimpenny14', 'sdlBX4M2X'),
	('momar15', '9y5HFp8l'),
	('jsivyer16', '9Vc3p4Ui'),
	('uibell17', 'I0JIiu9e'),
	('npitway18', 'frNlwrfFK'),
	('candrieux19', 'Z8m1o6axg'),
	('rbloschke1a', 'sPBeJ1AoXL'),
	('rnyssens1b', 'daI6L5CAA07'),
	('fgraybeal1c', 'FXUxtKa'),
	('bhedon1d', 'MCEiP7I8tu');

INSERT INTO Tim  VALUES ('VelocityMax Elite','Cambodia University of Specialties'),
	('Man Untitled','Seokyeong University'),
	('HyperDrive X','Bloomsburg University of Pennsylvania'),
	('PowerShot Prime','Wingate University'),
	('Ac Milan','Universidad NUR'),
	('HyperDrive Y','Ahwaz Jondishapour University of Medical Sciences'),
	('HyperDrive Z','Universidad Peruana Union'),
	('Sapi Go','University of Technology and Life Sciences'),
	('ProdigyStrike Pro','Georgia Baptist College of Nursing'),
	('Real Betis','Puntland State University');

INSERT INTO Pemain VALUES
('2573e19e-396e-4ab7-92ac-bbb48f5186bd','VelocityMax Elite','Clara','Hadlington','808-641-3731','2020-03-15','FALSE','Goalkeeper',1801048969,'S1'),
('263f7ee1-c1fe-4d78-a621-dcc925c44549','Man Untitled','Katey','Tough','566-385-9476','2020-01-29','TRUE','Right back',1801048969,'S2'),
('1c055fc5-e20f-4db8-9c4b-0ac3b191b1ed','HyperDrive X','Sonny','Peery','234-497-2949','2017-11-06','TRUE','Center back',1801048969,'S3'),
('a09b10fa-207f-434c-b8fb-efd707b5a1bd','PowerShot Prime','Cleve','Milverton','103-530-4666','2006-11-13','TRUE','Left back',1781620452,'S1'),
('7112e944-ab70-4857-8cf0-14f27e3ef611','Ac Milan','Sanford','Eliez','436-406-0524','2006-09-15','TRUE','Defensive midfielder',1781620452,'S2'),
('9aa5985d-b415-4d8d-835a-71d98cfd949b','HyperDrive Y','Claretta','Jenno','625-946-4428','2019-09-27','FALSE','Central midfielder',1781620452,'S3'),
('95f9c6c0-8a91-4d3a-989e-460508905def','HyperDrive Z','Anette','Dundredge','272-233-8530','2018-10-08','TRUE','Attacking midfielder',1551970076,'S1'),
('187fcff4-8b57-43df-97c8-578b738963ce','Sapi Go','Ezmeralda','Bulstrode','934-325-4389','2001-02-17','FALSE','Right winger',1551970076,'S2'),
('4f3530c8-a7ec-4c80-a64d-ef18b111c066','ProdigyStrike Pro','Annice','Merrikin','150-579-3565','2013-07-29','TRUE','Center forward',1551970076,'S3'),
('9da9dd52-4859-462e-95de-6812ee70c907','Real Betis','Fernanda','Pevie','243-334-7538','2020-04-14','FALSE','Left winger',1737939684,'S1'),
('c7b36394-f191-4603-a2cc-a72c1269224b','VelocityMax Elite','Gris','Wrigglesworth','898-939-4063','2014-05-12','TRUE','Second striker',1737939684,'S2'),
('2573d527-c4e2-4205-b997-679c9a65eb23','Man Untitled','Ari','Aime','268-536-1297','2015-01-24','TRUE','Goalkeeper',1737939684,'S3'),
('b610e1a7-308f-409a-9351-1fa8154dbd6b','HyperDrive X','Vonnie','Diemer','414-396-7675','2002-10-19','TRUE','Right back',1611054745,'S1'),
('4675b77b-5390-4504-be4e-c665891a1741','PowerShot Prime','Hyacinthie','Girone','236-200-0401','2012-12-24','FALSE','Center back',1611054745,'S2'),
('7d3461a8-ee83-4652-8037-fc32b071def3','Ac Milan','Loralyn','Brantl','944-805-8849','2008-04-06','FALSE','Left back',1611054745,'S3'),
('73fc4a8f-4229-4ddb-bb63-4cc1d256d1c8','HyperDrive Y','Philbert','Tunno','606-588-0523','2000-06-14','FALSE','Defensive midfielder',1582114595,'S1'),
('a05d9c7c-7d39-45e4-bc2e-20f1d128117c','HyperDrive Z','Meridel','Lingfoot','935-646-3742','2012-07-31','FALSE','Central midfielder',1582114595,'S2'),
('67616395-ccd7-4686-ba0f-2891e53e3035','Sapi Go','Halley','Hurler','524-551-6910','2001-08-14','FALSE','Attacking midfielder',1582114595,'S3'),
('959e208f-f876-4c04-bf60-7e3debfca2cc','ProdigyStrike Pro','Robers','Pau','870-190-5394','2004-02-01','TRUE','Right winger',1626724593,'S1'),
('bf54a3e2-a613-425b-9906-f3c623e85b2a','Real Betis','Ursa','O''Kelly','602-495-7489','2012-06-20','TRUE','Center forward',1626724593,'S2'),
('2ab93462-9b9e-4edb-bd2b-44bd09ff3d77','VelocityMax Elite','Waldon','Doman','643-649-2937','2014-12-12','FALSE','Left winger',1626724593,'S3'),
('9fbe8dc1-ad7a-416b-9b69-c7486b68a584','Man Untitled','Eldridge','Drakeford','661-513-1753','2016-06-22','TRUE','Second striker',1599995942,'S1'),
('bb33664e-7e55-4e7d-8a55-12a0f64654a4','HyperDrive X','Gerti','Heinle','738-620-2521','2015-12-21','FALSE','Goalkeeper',1599995942,'S2'),
('c77e2dc9-1140-4bd3-a789-53c0c2dcfe56','PowerShot Prime','Maryjo','Porte','195-940-3695','2007-12-28','TRUE','Right back',1599995942,'S3'),
('02171fb9-a422-4c40-87bc-4399174bb774','Ac Milan','Essa','Murfill','950-371-1963','2000-07-23','TRUE','Center back',2155489704,'S1'),
('536b631f-c230-4832-ab21-7069f5a43321','HyperDrive Y','Gale','McKevitt','963-675-7698','2002-03-14','TRUE','Left back',2155489704,'S2'),
('cf85aa39-d31a-4f36-b72d-3dbffeb50f53','HyperDrive Z','Hannis','Braxton','638-242-6720','2012-12-18','TRUE','Defensive midfielder',2155489704,'S3'),
('ca59099f-ff2e-4c29-bce7-c9634b762e44','Sapi Go','Malva','Gossage','585-400-5622','2001-06-22','FALSE','Central midfielder',2254492459,'S1'),
('c486e76a-0f87-4dc8-9d12-2efe6b14c4f9','ProdigyStrike Pro','Morlee','Klaes','440-660-4594','2016-02-17','FALSE','Attacking midfielder',2254492459,'S2'),
('23f9ceea-b2c0-4b15-8070-112733d191e6','Real Betis','Ozzie','Jedras','345-273-3294','2011-10-12','TRUE','Right winger',2254492459,'S3'),
('4b6cbf32-2c9b-488c-9d57-ddefe8064c8a','VelocityMax Elite','Ciro','Dabnor','939-812-2606','2004-05-05','TRUE','Center forward',1552778725,'S1'),
('5b62602f-1d8c-43a9-b5da-3988baa87aac','Man Untitled','Annamarie','Ferrick','897-107-2975','2017-06-11','FALSE','Left winger',1552778725,'S2'),
('12287945-ba6f-4faf-b2d6-aea9b7bc1d29','HyperDrive X','Tansy','Lancetter','479-590-1416','2018-04-10','FALSE','Second striker',1552778725,'S3'),
('9cf89df4-dc11-4a83-96c2-095516f2c9b9','PowerShot Prime','Lorrie','Demange','182-416-7156','2011-02-03','TRUE','Goalkeeper',1752213114,'S1'),
('c6f54988-aca7-453d-9b99-eb42f8ada64d','Ac Milan','Barnaby','Edrich','744-841-8273','2002-07-13','FALSE','Right back',1752213114,'S2'),
('d276ad31-0c7a-4096-8799-4d418863ff34','HyperDrive Y','Roseanne','Camden','227-281-4822','2006-12-03','FALSE','Center back',1752213114,'S3'),
('9f306a42-761a-4635-bcbc-12650cc88cac','HyperDrive Z','Nappy','Scothorne','586-333-7671','2001-12-17','FALSE','Left back',1565238074,'S1'),
('b87f7e81-f148-4a1d-95e3-86e49811411a','Sapi Go','Jojo','Maddy','976-258-4059','2001-07-26','TRUE','Defensive midfielder',1565238074,'S2'),
('90894448-2f9d-4789-86c2-acd2a29969bc','ProdigyStrike Pro','Prudy','Dyball','490-494-4458','2018-08-29','TRUE','Central midfielder',1565238074,'S3'),
('53a2aa40-7790-421b-8acf-c9cea93b9b3d','Real Betis','Colas','McCard','264-364-8334','2015-04-16','TRUE','Attacking midfielder',2239710522,'S1'),
('5ad1f260-4731-401d-87b2-40c0265904e8','VelocityMax Elite','Agnella','Dinnies','638-916-5299','2018-09-11','FALSE','Right winger',2239710522,'S2'),
('15daa4d0-d135-49e4-8fd7-8e461f24cc8b','Man Untitled','Vivien','Tilby','584-746-9216','2003-03-01','TRUE','Center forward',2239710522,'S3'),
('82c89ba5-0c6c-41c7-b5fd-b76341527fad','HyperDrive X','Beniamino','Liell','101-187-8426','2012-07-21','FALSE','Left winger',2241264918,'S1'),
('188191cf-8c72-4de3-95fe-a5ca3a030f2c','PowerShot Prime','Olvan','Gannicleff','708-612-0151','2017-09-13','TRUE','Second striker',2241264918,'S2'),
('ad12a89d-3290-41f1-a1ca-bc5563b9d6fc','Ac Milan','Gisella','Kellogg','642-691-3035','2004-02-06','TRUE','Goalkeeper',2241264918,'S3'),
('d5d6c0e5-8f02-412c-951c-f37f95f04bb5','HyperDrive Y','Fleming','Dulen','748-257-7494','2004-02-22','TRUE','Right back',1901757573,'S1'),
('561670c5-bdfd-4ad4-912a-c4c0825d5c84','HyperDrive Z','Haley','Seiller','150-836-1517','2005-01-30','FALSE','Center back',1901757573,'S2'),
('351fb7a9-748e-4530-acfc-5b2a485877c7','Sapi Go','Risa','Simmonds','911-740-4374','2002-04-05','TRUE','Left back',1901757573,'S3'),
('bb87e5cb-3ff9-4c88-ad72-3af3132b5594','ProdigyStrike Pro','Martie','Studdal','419-692-6857','2005-10-31','FALSE','Defensive midfielder',1907648484,'S1'),
('e4a5638f-b230-4132-8e1a-957b46b86b23','Real Betis','Stanton','Iannini','192-738-0041','2007-01-14','TRUE','Central midfielder',1907648484,'S2'),
('afd2c064-5a95-47da-ac7f-2eca009b6f57','VelocityMax Elite','Mitchael','Iskowitz','410-852-9372','2005-09-24','TRUE','Attacking midfielder',1907648484,'S3'),
('0a9983f7-dea9-4872-87b7-f423d5d449fc','Man Untitled','Averell','Mation','325-793-2230','2016-05-31','TRUE','Right winger',1954455272,'S1'),
('c19d11c3-0979-4d35-9393-c25fd322d636','HyperDrive X','Grayce','Huby','974-471-5774','2006-06-23','TRUE','Center forward',1954455272,'S2'),
('269bc386-27bf-4b40-a7a7-f30181667612','PowerShot Prime','Vanessa','Norfolk','399-834-7912','2011-11-28','TRUE','Left winger',1954455272,'S3'),
('c3f86352-dda2-474d-8604-48019fe15ab3','Ac Milan','Mycah','Meates','505-525-9626','2007-11-04','FALSE','Second striker',1839334909,'S1'),
('62597ad4-2f14-4362-b4da-8c5c695ee041','HyperDrive Y','Morgen','Assiter','560-190-2789','2016-10-14','FALSE','Goalkeeper',1839334909,'S2'),
('ddf22ef9-85df-4e9f-b0a5-4bb7fa21c876','HyperDrive Z','Maynard','Stirman','995-385-9953','2001-12-05','FALSE','Right back',1839334909,'S3'),
('6b182d0d-6188-4512-bbc7-44aae725376b','Sapi Go','Loise','Mease','448-460-6801','2000-08-19','FALSE','Center back',2181565027,'S1'),
('62314c9c-ba2b-4fb5-bcfa-3425f4921999','ProdigyStrike Pro','Rae','Morad','339-546-2831','2008-04-09','FALSE','Left back',2181565027,'S2'),
('00055366-d72b-4d28-b264-91bb83601702','Real Betis','Randene','Craigs','218-636-3713','2000-10-17','TRUE','Defensive midfielder',2181565027,'S3'),
('ec2bef53-d9d0-47a0-9c9f-b65997d56d47','VelocityMax Elite','Ilse','Moulton','196-475-3786','2014-04-22','TRUE','Central midfielder',1736158351,'S1'),
('03e1d7ea-da2d-476b-9f4a-45f88d13a046','Man Untitled','Karlen','Raubheim','740-163-5689','2015-11-24','FALSE','Attacking midfielder',1736158351,'S2'),
('7d2f85cb-f262-44d0-bed7-e98b108fdfad','HyperDrive X','Helge','Mahmood','117-998-6915','2004-03-09','TRUE','Right winger',1736158351,'S3'),
('5357d606-086a-42f8-aaa8-b0ff319b1f7f','PowerShot Prime','Clareta','Vance','702-715-6425','2006-04-25','FALSE','Center forward',1580459147,'S1'),
('eddbfefc-71b7-49ce-a733-b82ec1f1b095','Ac Milan','Giles','Bertenshaw','376-341-5792','2006-06-05','TRUE','Left winger',1580459147,'S2'),
('88edd832-5451-4416-8a31-40cd85806a71','HyperDrive Y','Cody','Nijs','362-899-9939','2004-08-25','TRUE','Second striker',1580459147,'S3'),
('ee373dfd-0218-46f9-bcff-5c65cf11deed','HyperDrive Z','Corrine','Dagwell','860-559-5759','2016-10-16','TRUE','Goalkeeper',1766154451,'S1'),
('539eeb6a-4c6d-4683-9270-8853e2a0d7d2','Sapi Go','Jorey','Berthon','954-965-4589','2016-12-11','FALSE','Right back',1766154451,'S2'),
('e7e84ce0-5636-46c7-b5bd-0d47d9fa11d3','ProdigyStrike Pro','Harmony','Lashbrook','787-401-2906','2003-08-16','TRUE','Center back',1766154451,'S3'),
('aa292b71-6806-4b48-96f4-93946a395829','Real Betis','Carmella','Davidowsky','305-397-9229','2000-07-02','TRUE','Left back',1936585832,'S1'),
('6148c9cb-e7b6-441a-866b-f04b00ab7040','VelocityMax Elite','Modesta','Matterface','508-385-3338','2006-05-08','TRUE','Defensive midfielder',1936585832,'S2'),
('5615bbd2-d7aa-4e62-ad02-08b7228d8a8f','Man Untitled','Elisha','Iacomelli','224-919-3716','2019-08-03','TRUE','Central midfielder',1936585832,'S3'),
('864d7b63-42e7-41db-9160-848e34590837','HyperDrive X','Massimiliano','Wilshire','434-871-5952','2005-07-19','TRUE','Attacking midfielder',1698515849,'S1'),
('c682f87e-e61a-4618-9449-4712f3543b0f','PowerShot Prime','Deni','Askam','727-890-7127','2008-11-13','FALSE','Right winger',1698515849,'S2'),
('52640129-1f1c-4741-860c-0607c78e8bf4','Ac Milan','Ruperta','Wrack','589-492-8415','2012-02-28','FALSE','Center forward',1698515849,'S3'),
('d230f391-6aba-4c88-b216-ce4688278235','HyperDrive Y','Zolly','Bowdidge','135-854-3119','2019-04-17','FALSE','Left winger',2016947395,'S1'),
('4791b0a1-252a-4877-8091-5a62d0ae316c','HyperDrive Z','Herb','Ferber','391-830-8906','2003-06-19','FALSE','Second striker',2016947395,'S2'),
('6e39eb01-b500-40fd-9a05-8820285096af','Sapi Go','Lianna','Orth','460-579-8784','2015-05-15','TRUE','Goalkeeper',2016947395,'S3'),
('fdc87f7f-c43b-4ae5-bfb2-b24d9cd1eeb0','ProdigyStrike Pro','Roderic','Redhole','447-477-7873','2001-07-03','TRUE','Right back',1631931500,'S1'),
('8bda8cfd-78d3-4bd7-a125-34241a83c27e','Real Betis','Ira','Trevaskis','451-511-0167','2016-07-15','TRUE','Center back',1631931500,'S2'),
('0a205d60-b329-491c-981f-a7b8fc59edd7','VelocityMax Elite','Cyrus','Knagges','312-642-6057','2020-04-07','FALSE','Left back',1631931500,'S3'),
('8232c319-4a8a-4d48-9c1a-a83ae27ddf5d','Man Untitled','Harris','Cellier','784-887-4070','2001-12-18','TRUE','Defensive midfielder',1847983395,'S1'),
('c19900cd-5083-4f2b-89b6-50abfda9099f','HyperDrive X','Tommy','Prestage','338-341-4272','2004-10-20','FALSE','Central midfielder',1847983395,'S2'),
('6491fc58-8c01-430f-93d3-9c8fe2a2e5ba','PowerShot Prime','Cicely','Gallally','392-921-8506','2010-04-09','FALSE','Attacking midfielder',1847983395,'S3'),
('1aa78c66-ebdc-46c1-b755-6ae10d6fb998','Ac Milan','Pat','Heselwood','633-829-5723','2008-11-21','TRUE','Right winger',1888751782,'S1'),
('267f0c28-f8a0-4163-9ff3-fda28d2b07af','HyperDrive Y','Wittie','Skett','272-225-0562','2019-11-07','TRUE','Center forward',1888751782,'S2'),
('26f00331-9bbd-4efd-bdc2-c0155b2fd205','HyperDrive Z','Bert','Rembrant','217-203-9537','2017-04-15','TRUE','Left winger',1888751782,'S3'),
('c1ef22be-390d-4a13-be44-6f662b5c5835','Sapi Go','Robb','Sherston','757-580-7311','2018-06-10','TRUE','Second striker',2208106437,'S1'),
('aa3ff3c7-e0d0-4fd8-9da7-29affd68d59c','ProdigyStrike Pro','Miranda','Kobpac','894-109-2659','2009-02-22','FALSE','Goalkeeper',2208106437,'S2'),
('001e4577-84ed-43b9-ac9a-602f809d5c50','Real Betis','Ricoriki','Woolpert','457-697-4707','2019-04-28','TRUE','Right back',2208106437,'S3'),
('788f1e36-6244-4a00-a1b0-be71e72a647e','VelocityMax Elite','Hilliard','Lampbrecht','614-409-6211','2007-06-14','TRUE','Center back',2232246131,'S1'),
('b812dfb1-acdb-4b03-bd07-bb4cd7aa4b40','Man Untitled','Diandra','Stilliard','290-813-3989','2005-09-24','TRUE','Left back',2232246131,'S2'),
('9eb1eb23-5639-4bc7-bd5a-fed37aa16d24','HyperDrive X','Case','Gustus','351-209-9666','2006-01-18','FALSE','Defensive midfielder',2232246131,'S3'),
('90bbfcbf-0480-41eb-accb-4914135a1ffe','PowerShot Prime','Annette','Ewdale','137-529-9389','2004-06-22','FALSE','Central midfielder',2092297438,'S1'),
('70f2a161-50bb-42d9-9aa7-d2ba61913b01','Ac Milan','Maryl','Piburn','973-562-4456','2017-01-27','TRUE','Attacking midfielder',2092297438,'S2'),
('bc86792b-02d8-4b73-82b1-c7a9a7c29357','HyperDrive Y','Kirsten','Boyles','633-387-2714','2010-10-05','FALSE','Right winger',2092297438,'S3'),
('f43f3fb8-563a-4d02-ae8f-ac3cf9718199','HyperDrive Z','Sigismondo','Karpeev','286-414-8377','2017-09-12','FALSE','Center forward',1765112050,'S1'),
('73425020-eea5-47b0-9ed6-7a175e7bc481','Sapi Go','Anny','Grocott','761-769-1428','2015-02-24','FALSE','Left winger',1765112050,'S2'),
('595a3ed7-89ad-4d89-9c3d-2ded56e24c47','ProdigyStrike Pro','Emmi','Jeacocke','634-391-6854','2016-06-01','FALSE','Second striker',1765112050,'S3'),
('465594eb-f86f-4d05-a6ef-4cf5a59b49f8','Real Betis','Abramo','Roskilly','907-359-3476','2007-04-02','FALSE','Goalkeeper',1946166927,'S1'),
('d46b5881-56b7-465e-8545-d561931ca1e8','VelocityMax Elite','Ciro','Greenway','724-742-0470','2006-12-21','FALSE','Right back',1946166927,'S2'),
('1415ff90-ffaf-432b-b566-fb64f829e5e1','Man Untitled','Gian','Bigmore','313-334-8875','2011-10-19','TRUE','Center back',1946166927,'S3'),
('6c4c1f83-d45d-467f-bda2-5f1dc134e452','HyperDrive X','Budd','Crossfield','746-171-0254','2016-11-27','TRUE','Left back',1835726036,'S1'),
('d209b4a1-0520-464d-b12c-24bcaf215617','PowerShot Prime','Ingar','Vater','822-556-8670','2004-05-03','FALSE','Defensive midfielder',1835726036,'S2'),
('6a2091dc-9998-4eed-8bed-cc8f66f16f97','Ac Milan','Tony','Bauld','214-686-5832','2007-06-12','FALSE','Central midfielder',1835726036,'S3'),
('5d6fe08d-cea3-4fd0-a9b0-a6e33b54bb8b','HyperDrive Y','Dolli','Obee','131-111-2525','2004-09-07','TRUE','Attacking midfielder',1559905139,'S1'),
('ab4ee70c-9670-4a1d-aac7-b81209198f09','HyperDrive Z','Vergil','Cozens','606-148-5516','2008-08-23','TRUE','Right winger',1559905139,'S2'),
('551e32d2-99b4-425c-be8a-38ef1564a99c','Sapi Go','Korney','Konrad','744-800-2729','2006-04-25','FALSE','Center forward',1559905139,'S3'),
('ad2b700b-cbea-471a-852e-e1d6e2f2f534','ProdigyStrike Pro','Lilah','Choules','451-858-6326','2017-12-10','FALSE','Left winger',1708169954,'S1'),
('51997285-77c7-4f03-97af-c6b462a0f2f3','Real Betis','Judye','Meatyard','341-182-4392','2002-12-19','TRUE','Second striker',1708169954,'S2'),
('fdbac8b0-939f-4f9f-9b37-9a5561987921',NULL,'Morlee','Muldrew','498-109-2376','2007-03-03','TRUE','Goalkeeper',1708169954,'S3'),
('f648c494-95e2-48af-8d47-d0d6e0786e09',NULL,'Abbott','Vannucci','144-704-9618','2006-03-04','TRUE','Right back',1970993627,'S1'),
('cbde3958-40f4-46fa-987b-463582f48fde',NULL,'Devonna','Wynes','715-635-5726','2008-05-13','TRUE','Center back',1970993627,'S2'),
('328bdf3f-464a-4a27-8878-391f3db34cf3',NULL,'Florrie','Davidwitz','520-638-9137','2011-01-28','FALSE','Left back',1970993627,'S3'),
('aa940932-9419-40a1-8231-97b700fa40b3',NULL,'Rosette','Burwood','937-104-6158','2008-01-17','FALSE','Defensive midfielder',1965841235,'S1'),
('2faa890a-980e-4939-8da3-a7b1b9d7dbbf',NULL,'Margarethe','Ginnell','630-596-3790','2016-03-12','TRUE','Central midfielder',1965841235,'S2'),
('8e301d7e-0f85-415f-aa2f-8a7914d06839',NULL,'Claudetta','Pagelsen','874-499-6266','2008-12-15','TRUE','Attacking midfielder',1965841235,'S3'),
('80529947-63d2-45bb-820e-29b936c2b8dc',NULL,'Meryl','Davitt','607-261-5405','2020-01-11','TRUE','Right winger',2289156064,'S1'),
('aa3a6718-35ca-4a96-9226-44b739a6a19c',NULL,'Marybeth','Pinch','664-699-4490','2014-09-21','FALSE','Center forward',2289156064,'S2'),
('1e722bd9-035d-4b8b-8d3a-b9d650cecbed',NULL,'Hastie','Attock','260-798-9258','2006-11-05','FALSE','Left winger',2289156064,'S3'),
('b9d8d3f1-f6e3-467a-9cf6-700fac2740a1',NULL,'Grayce','Alvarez','556-103-4197','2008-03-11','FALSE','Second striker',1920509987,'S1'),
('ea0be9bb-4409-4ffc-bf0d-28c4a45c1da7',NULL,'Alyssa','Baselli','777-115-9111','2001-07-18','TRUE','Goalkeeper',1920509987,'S2'),
('511b0842-1cba-4154-abd7-ed861910e232',NULL,'Karel','Hearnshaw','687-409-9623','2012-12-15','FALSE','Right back',1920509987,'S3'),
('ca861004-adae-4747-8987-50787e5d091d',NULL,'Gisella','Tittletross','941-535-0310','2015-06-20','FALSE','Center back',2167778794,'S1'),
('82da99f6-5414-48f0-ae4c-34ef36815c6e',NULL,'Normand','Bearfoot','355-816-6373','2015-01-14','TRUE','Left back',2167778794,'S2'),
('8cbc7896-71aa-49e1-9e95-798a6af693b5',NULL,'Jacquelynn','Gallyhaock','577-583-6634','2005-03-17','TRUE','Defensive midfielder',2167778794,'S3'),
('ef6f4c7b-52d8-4290-b9fe-334fc8cdcc39',NULL,'Lorinda','Redbourn','633-193-2636','2006-12-19','TRUE','Central midfielder',1702738947,'S1'),
('16401407-1c72-4780-a9c4-3b4b92cd92f6',NULL,'Ryan','Chatell','574-699-6373','2012-12-22','FALSE','Attacking midfielder',1702738947,'S2'),
('451f70b4-ceb4-4e4b-90af-2470f92d2e53',NULL,'Harp','Lyvon','964-168-0617','2018-04-17','FALSE','Right winger',1702738947,'S3'),
('84bd03b0-831f-47ca-863c-0521260fd6ef',NULL,'Deva','Oppery','565-912-1715','2014-06-23','FALSE','Center forward',2166048189,'S1'),
('d57482ab-be2a-499e-99a7-6949431a4d91',NULL,'Rockie','Doran','268-707-7778','2017-02-05','TRUE','Left winger',2166048189,'S2'),
('b2dc5d35-e4b3-456f-be66-54d1271f88ce',NULL,'Jemima','Hazel','942-761-5257','2018-09-06','FALSE','Second striker',2166048189,'S3'),
('48ee5170-34be-41c4-8828-c19983268f83',NULL,'Goldie','Hubbuck','248-283-8797','2007-11-29','TRUE','Goalkeeper',1529659456,'S1'),
('95cc2fd3-12b8-4e87-b074-e171e43895ea',NULL,'Enrika','Maude','870-143-2648','2001-12-30','TRUE','Right back',1529659456,'S2'),
('8a4478bb-2adf-4b56-8137-faccffef6f72',NULL,'Lanette','Harewood','276-565-0894','2012-09-29','TRUE','Center back',1529659456,'S3'),
('20c7535e-4f7a-4c45-a1e7-7c4e5aff8d3f',NULL,'Maurise','Clothier','205-861-2657','2018-11-26','FALSE','Left back',2131076547,'S1'),
('78e0e495-40c6-42a5-905a-a01295f7e140',NULL,'Raychel','Swancott','874-703-2809','2018-09-04','FALSE','Defensive midfielder',2131076547,'S2'),
('27ac24b1-fc7d-4136-b64b-11c1d09b919c',NULL,'Bram','Zmitrichenko','862-604-7181','2019-07-01','TRUE','Central midfielder',2131076547,'S3'),
('73fd86e7-f775-4669-9724-f271f72ed8f7',NULL,'Netty','Joberne','275-307-1175','2000-12-08','FALSE','Attacking midfielder',1766150433,'S1'),
('54b8da2f-5f60-436b-94c8-84a333c2cc11',NULL,'Cyrill','Riggey','293-226-2362','2017-01-14','FALSE','Right winger',1766150433,'S2'),
('0e04f610-3bc7-4261-84d7-b10482c3f63f',NULL,'Marietta','Kilpatrick','569-473-5029','2019-10-30','TRUE','Center forward',1766150433,'S3'),
('19d32014-665c-405f-b89e-4a67eed81cc9',NULL,'Rolfe','Eckels','570-232-9652','2005-07-12','FALSE','Left winger',2191644073,'S1'),
('ce74705a-a4cc-411f-b233-891ddee6d18a',NULL,'Abner','Iwanowski','983-778-8789','2010-08-04','FALSE','Second striker',2191644073,'S2'),
('330ec1d9-a4c8-4ea0-b582-c003b11f55fa',NULL,'Michal','Hardeman','560-290-6904','2019-07-12','FALSE','Goalkeeper',2191644073,'S3'),
('cdf20d84-2c25-47f0-9fb5-1419ea53496d',NULL,'Carlene','ducarme','967-646-0395','2009-02-09','TRUE','Right back',2101063718,'S1'),
('d5e114b7-b658-428b-bf66-c400aac864a0',NULL,'Tynan','Dahlen','597-262-5961','2018-04-11','TRUE','Center back',2101063718,'S2'),
('121db6ce-21fc-488f-b505-339072da0df4',NULL,'Alfreda','Kirsop','278-857-2492','2010-08-08','FALSE','Left back',2101063718,'S3'),
('46469800-74f5-4e3c-80d0-1769b1e39e49',NULL,'Eugenia','O''Cahsedy','184-488-2819','2004-06-02','TRUE','Defensive midfielder',2032932703,'S1'),
('8f895e1a-2d75-4658-bc8d-567cd6231777',NULL,'Amanda','Buxsy','942-229-4804','2005-03-21','FALSE','Central midfielder',2032932703,'S2'),
('c1b75a74-7e33-429c-b34b-5fa62570f668',NULL,'Verile','Lantaff','597-547-5056','2011-05-17','FALSE','Attacking midfielder',2032932703,'S3'),
('b7eb787d-3874-4fb3-a7f1-939cc2b40ca4',NULL,'Shelagh','Coast','733-967-6248','2014-02-21','TRUE','Right winger',1813796287,'S1'),
('6c80a3f8-0c06-4a54-8e50-a28bde30dcc2',NULL,'Sasha','Dearl','401-413-8132','2005-11-03','FALSE','Center forward',1813796287,'S2'),
('b41fba7f-fa14-4ec8-88fa-17b62d81681e',NULL,'Kata','McLeoid','467-849-5523','2018-03-20','FALSE','Left winger',1813796287,'S3'),
('d145b7d0-4cc9-487a-b9e0-fe1e64abcda5',NULL,'Fairlie','Peirazzi','754-539-0741','2017-10-05','FALSE','Second striker',2219737191,'S1'),
('85349248-a4f5-4104-8afb-200a3d5f10fd',NULL,'Arne','Croxon','405-107-1489','2018-05-14','TRUE','Goalkeeper',2219737191,'S2'),
('35e8d8de-baca-4440-a01d-c54522cc262a',NULL,'Irwinn','Scapelhorn','276-808-4001','2012-10-06','FALSE','Right back',2219737191,'S3'),
('c2115208-c0b7-408e-933f-acb5dc777ae1',NULL,'Derby','Issac','516-285-7012','2012-03-19','FALSE','Center back',2210462657,'S1'),
('6a6d2a02-53ef-4b40-adbd-818696d4a207',NULL,'Northrup','Nealey','804-555-6574','2014-02-01','FALSE','Left back',2210462657,'S2'),
('f34f3472-1169-4d98-92b4-f3aaac1dc85f',NULL,'Lorelei','Charity','799-331-1091','2013-08-05','FALSE','Defensive midfielder',2210462657,'S3'),
('47fa869a-f78f-4c75-bdb2-382f237f660a',NULL,'Herta','Janauschek','746-150-3738','2011-03-22','FALSE','Central midfielder',1642065315,'S1'),
('c4a76de9-010d-46b5-a0ba-cc4303797340',NULL,'Marysa','Oakton','430-753-2752','2005-03-02','FALSE','Attacking midfielder',1642065315,'S2'),
('29411428-c1a3-4dc4-8f4a-7726956f8352',NULL,'Matthaeus','Hanshaw','846-460-9342','2020-04-30','FALSE','Right winger',1642065315,'S3'),
('d6b984d8-e751-43e8-9c4c-2885237a3467',NULL,'Rip','Scurr','185-839-6764','2000-03-10','TRUE','Center forward',2165927494,'S1'),
('b8c95d3c-4e78-4b2f-a9c5-2beefdb1bae7',NULL,'Phaedra','Seamark','618-726-9924','2005-09-25','TRUE','Left winger',2165927494,'S2'),
('9821f4a1-853b-4a21-9fa5-b6e6aeaec5d9',NULL,'Tracey','Smillie','132-533-9279','2009-03-29','TRUE','Second striker',2165927494,'S3'),
('f2550ed7-e971-4b4a-9399-62bc9886ebed',NULL,'Austin','Struthers','305-931-9722','2011-01-26','TRUE','Goalkeeper',2233938557,'S1'),
('267c1eb9-5604-4690-ae04-878a613ea90a',NULL,'Melli','Keinrat','820-127-2636','2001-09-17','TRUE','Right back',2233938557,'S2'),
('3dd1f425-f8d8-4548-b25e-cbe26403ad1d',NULL,'Cherice','Blythe','837-979-1753','2001-06-19','FALSE','Center back',2233938557,'S3'),
('e526ed7f-a83a-4ab8-8af0-3e9cb7168025',NULL,'Worthy','MacGorrie','485-722-4889','2000-06-15','TRUE','Left back',1760524213,'S1'),
('e28fe8b5-e6cc-43f1-b071-c3f6734fb498',NULL,'Raf','Betho','410-597-5494','2006-06-08','TRUE','Defensive midfielder',1760524213,'S2'),
('201420b7-f5e7-4a00-a4bd-fc830a6ab70e',NULL,'Florina','Fisby','788-623-2500','2008-12-04','TRUE','Central midfielder',1760524213,'S3'),
('4383f2da-e795-4c8d-b29b-a5e57ed58fae',NULL,'Em','Broomfield','729-367-5418','2006-01-17','TRUE','Attacking midfielder',1963708997,'S1'),
('c68dbd91-4273-495c-b462-242e7147009d',NULL,'Larissa','Kleynermans','107-450-9339','2003-06-10','TRUE','Right winger',1963708997,'S2'),
('41ce18ac-e991-4466-a964-dff92b520661',NULL,'Allyn','Markie','588-992-5515','2017-01-01','FALSE','Center forward',1963708997,'S3'),
('cae4a8d9-2319-4405-bea4-5da66bec6568',NULL,'Jennette','Soughton','752-946-3796','2011-07-04','FALSE','Left winger',2158804852,'S1'),
('351cc5de-0be9-4751-8748-eb44057aa22c',NULL,'Guy','Keyes','971-948-0918','2015-10-18','TRUE','Second striker',2158804852,'S2'),
('0460b99d-ab46-4700-b95d-04152f92e610',NULL,'Jud','Broome','348-274-1349','2013-11-01','FALSE','Goalkeeper',2158804852,'S3'),
('ec40c838-a43c-4b61-8672-67e0de011287',NULL,'Carlye','Maddrell','980-901-9105','2012-11-07','FALSE','Right back',2292828438,'S1'),
('a9c090ec-e484-43ae-833b-3aa7b9d1dd98',NULL,'Tybie','D''Ambrogio','355-363-8017','2005-02-18','FALSE','Center back',2292828438,'S2'),
('fccb9df1-d5ab-4354-b2c8-83400736c29e',NULL,'Winfield','Singers','768-251-1944','2009-04-14','FALSE','Left back',2292828438,'S3'),
('bf886ef7-2dc9-4bd6-8e3f-3d63ca422e7a',NULL,'Nannie','Chern','484-406-2413','2012-10-24','TRUE','Defensive midfielder',2088149499,'S1'),
('847bc83b-111a-4fc8-bb63-3346f40e3970',NULL,'Zachary','Brownsea','752-411-4334','2012-10-12','FALSE','Central midfielder',2088149499,'S2'),
('f8b109ea-1faf-4ded-940a-fd7829fc4205',NULL,'Morrie','Jakubowsky','399-182-5355','2012-05-17','FALSE','Attacking midfielder',2088149499,'S3'),
('6481fd7e-6962-4092-9073-9bd2010fe3e7',NULL,'Arliene','Knutton','467-847-5824','2007-11-27','FALSE','Right winger',2000957894,'S1'),
('fe7f3ca9-cd24-4585-a6b3-e603e90b0c94',NULL,'Risa','Dwyer','898-744-3725','2005-02-20','FALSE','Center forward',2000957894,'S2'),
('429993df-3a4a-427d-92f9-0ed03f5c94d6',NULL,'Arlina','Blaxlande','411-271-8501','2011-08-05','TRUE','Left winger',2000957894,'S3'),
('826f490b-72f6-4659-a888-3020dafe3305',NULL,'Cristina','Stothard','608-926-3234','2000-07-25','FALSE','Second striker',2259588261,'S1'),
('e4850311-ae95-4233-b2bf-976cb7da9eef',NULL,'Oren','Darbishire','904-612-9946','2019-07-29','TRUE','Goalkeeper',2259588261,'S2'),
('a3b70613-dd7b-49cd-94a6-ef84dad7304b',NULL,'Ibbie','Dealy','916-652-8258','2008-01-12','TRUE','Right back',2259588261,'S3'),
('21be90e8-41a0-4f50-83c1-8d5717c60df4',NULL,'Orlan','Fransoni','495-585-8045','2012-02-04','TRUE','Center back',1744784109,'S1'),
('e2cd83f4-3d7b-4cfb-82d2-057c130edede',NULL,'Amil','MacIlwrick','942-658-2395','2003-10-18','FALSE','Left back',1744784109,'S2'),
('84f0abb0-5142-43fb-9b1a-823b2464cc0e',NULL,'Chris','de Merida','421-801-4412','2011-01-23','FALSE','Defensive midfielder',1744784109,'S3'),
('a4408e1d-c9f9-4eb1-938a-116858c3eaab',NULL,'Shermy','Instone','399-988-4855','2000-08-01','TRUE','Central midfielder',2257239774,'S1'),
('615d7841-f7e7-43b3-b3e9-97c00f253e74',NULL,'Dorise','Gueinn','169-903-9377','2010-03-05','TRUE','Attacking midfielder',2257239774,'S2'),
('afe9a478-7599-4f62-a6a5-a8487504d54f',NULL,'Bessie','Turk','505-526-2671','2008-05-10','TRUE','Right winger',2257239774,'S3'),
('a3b9b6f1-f925-4156-a43e-3b52c6e31a57',NULL,'Charmian','Lambeth','465-642-5849','2017-01-09','FALSE','Center forward',1609971820,'S1'),
('cb20418c-4bdd-4124-a152-0415c2d378be',NULL,'Madeline','Scobie','903-175-5635','2014-12-21','FALSE','Left winger',1609971820,'S2'),
('89036f9b-a5b0-4cbd-a498-1073caa89989',NULL,'Damita','De Caroli','832-842-1942','2015-08-30','FALSE','Second striker',1609971820,'S3'),
('a0ef1a99-4660-4673-b6ea-56158ce53350',NULL,'Zonda','Proback','547-309-7555','2019-10-15','FALSE','Goalkeeper',1816919978,'S1'),
('7ab5cacc-6f2f-44e5-a6fc-2a359472d327',NULL,'Cash','Marzele','132-572-3918','2010-07-13','FALSE','Right back',1816919978,'S2'),
('265ecda3-ae8b-4d6e-815c-9f6447729412',NULL,'Pasquale','Cregeen','542-780-6449','2009-11-27','FALSE','Center back',1816919978,'S3'),
('b26d0ae2-6418-44a6-8d7c-2a28e847a5f9',NULL,'Wheeler','Garey','529-686-2320','2017-09-18','TRUE','Left back',1642964181,'S1'),
('7d9fea9f-0534-4e1d-be3e-ceda53f85495',NULL,'Natalya','Scrace','708-439-1365','2012-06-21','FALSE','Defensive midfielder',1642964181,'S2'),
('46e77b36-d555-4c6d-9971-c2626dbb27c3',NULL,'Darius','Philippard','964-611-0701','2008-06-11','TRUE','Central midfielder',1642964181,'S3'),
('bf0c1ed7-812a-4d51-a7c0-e49ebd5e5f4f',NULL,'Rustie','Corbet','845-170-3325','2016-06-22','FALSE','Attacking midfielder',1660819137,'S1'),
('53ed553a-66c3-4520-8bad-7cf9ee9623b9',NULL,'Francisca','Surplice','192-871-1102','2005-04-18','TRUE','Right winger',1660819137,'S2'),
('f3f832fe-556b-4403-a846-40b7a2ab5ff4',NULL,'Clarinda','Di Biasi','538-347-5163','2008-03-01','FALSE','Center forward',1660819137,'S3'),
('165c238a-52b1-483f-8bf8-d7f30235d376',NULL,'Lavinie','McRonald','684-728-4218','2002-03-14','TRUE','Left winger',2217054188,'S1'),
('f5bf5c7a-9d5c-40a7-b0ff-888a217a25ff',NULL,'Nicolas','Faichnie','180-707-4778','2015-10-25','FALSE','Second striker',2217054188,'S2'),
('31720e40-0369-4bfc-bbe7-10388fa1ddf2',NULL,'Buck','McGrann','423-689-8198','2019-07-17','FALSE','Goalkeeper',2217054188,'S3'),
('e19d0d17-3e61-4a03-8e33-ad0f68ffb145',NULL,'Muriel','Atkins','344-175-1636','2003-08-02','TRUE','Right back',1963481326,'S1'),
('87a585fa-ffc1-4aeb-bef2-9bb41b558630',NULL,'Jodie','Wellbank','742-352-0528','2013-01-06','TRUE','Center back',1963481326,'S2'),
('ffbc99ae-48bc-464a-af84-2f84368191be',NULL,'Vincents','Skeates','392-189-5556','2017-12-22','FALSE','Left back',1963481326,'S3'),
('25596669-9707-4253-b42f-441f7bfe2df0',NULL,'Tera','Hattersley','451-691-0805','2013-05-08','FALSE','Defensive midfielder',1536330391,'S1'),
('266ce998-c0be-41cb-8e26-573d2136d5e1',NULL,'Jeramie','Longhorne','488-687-6930','2004-01-13','FALSE','Central midfielder',1536330391,'S2'),
('c24292d3-757a-497b-9a1f-a05bb8de9380',NULL,'Blondy','Trowbridge','580-937-0430','2009-09-10','FALSE','Attacking midfielder',1536330391,'S3'),
('251fb0d7-7d8e-4ff2-a080-33932d314b07',NULL,'Christoffer','Bloyes','271-319-2993','2017-05-28','TRUE','Right winger',1921423146,'S1'),
('6d0517a7-a204-4afd-9c54-1ae32a0c3e44',NULL,'Leslie','Rexworthy','878-499-9086','2003-11-03','FALSE','Center forward',1921423146,'S2'),
('8bff4582-6396-4cc1-a652-01c84814d37d',NULL,'Tallie','Shilburne','774-170-3834','2008-08-08','FALSE','Left winger',1921423146,'S3'),
('1d9ccbeb-ad5c-4b3b-9c11-f8640078f5d2',NULL,'Barnard','Lampaert','504-891-2329','2016-01-20','TRUE','Second striker',1573373076,'S1'),
('fc6257cf-109e-4b4f-ab9a-7c4dd0a8d7a6',NULL,'Ingmar','Atherton','450-787-2419','2012-01-18','TRUE','Goalkeeper',1573373076,'S2'),
('a7afa7dc-64f5-4f21-9fcf-ba02c08865f3',NULL,'Gael','Gouldsmith','288-476-3131','2000-05-07','TRUE','Right back',1573373076,'S3'),
('6a8a885b-acd9-4cf8-9c86-1c08b9923cbf',NULL,'Ysabel','Balstone','257-243-1448','2005-08-22','TRUE','Center back',2287912531,'S1'),
('b8af58f1-cbe2-4dc5-966c-554812033dbe',NULL,'Velvet','Rickarsey','136-557-4313','2018-04-03','TRUE','Left back',2287912531,'S2'),
('963997e5-c84d-4022-9e8d-696068118334',NULL,'Hamilton','Tregust','223-505-6687','2017-08-29','TRUE','Defensive midfielder',2287912531,'S3'),
('f29e9116-1ebd-43b6-a82c-1abf6f65951a',NULL,'Early','Coping','922-684-7125','2010-04-28','FALSE','Central midfielder',2066179246,'S1'),
('0cbcd974-b27e-4dab-ae35-4b1a9ac0f143',NULL,'Brion','Keets','784-973-5126','2007-08-27','TRUE','Attacking midfielder',2066179246,'S2'),
('97c0c226-3b3d-4570-bcd3-3eb30120620f',NULL,'Keefe','McKie','309-398-3133','2000-09-05','FALSE','Right winger',2066179246,'S3'),
('752b3062-1f49-4b25-b15d-648fe7df1fac',NULL,'My','Oddboy','196-837-2508','2000-09-29','TRUE','Center forward',2012257674,'S1'),
('ef2f0cb3-6d73-46c9-85a2-df31e7e12ce3',NULL,'Craggy','Willerstone','694-789-0137','2005-11-12','TRUE','Left winger',2012257674,'S2'),
('f91f5416-711c-4d9b-829c-3aa6029371b5',NULL,'Diann','Hartzogs','461-917-2013','2011-11-02','FALSE','Second striker',2012257674,'S3'),
('9d0ff582-37c7-4cc7-b661-cb587395ce81',NULL,'Armand','Strelitzer','806-296-9864','2001-12-29','TRUE','Goalkeeper',1923894086,'S1'),
('f8353e3a-8ed7-4eba-ab69-4f94f898d136',NULL,'Merilee','Fullstone','194-620-0478','2004-01-01','TRUE','Right back',1923894086,'S2'),
('8f4a4b58-5243-4075-875c-f75e385288e4',NULL,'Hannie','Flagg','913-485-2554','2005-09-29','FALSE','Center back',1923894086,'S3'),
('7eaedb64-db46-4bb2-a97d-488b837b09a4',NULL,'Fan','Webling','820-171-8134','2016-12-29','FALSE','Left back',1948760809,'S1'),
('1ec83e0f-8a41-45bd-ae5d-0513c883d6e6',NULL,'Eilis','Ingon','585-937-7589','2011-01-26','TRUE','Defensive midfielder',1948760809,'S2'),
('f215b886-0011-44eb-aca5-235d4f1f5d06',NULL,'Ashley','Meindl','745-838-6780','2002-03-23','FALSE','Central midfielder',1948760809,'S3'),
('c3da46ad-ef78-4d6a-a1ed-1e68fd21eec2',NULL,'Davita','Duckels','866-866-2980','2019-06-16','FALSE','Attacking midfielder',2005617680,'S1'),
('d6f35f70-8791-4539-a91a-88ec1c784bdd',NULL,'Karel','Squibbes','377-278-0572','2014-02-07','FALSE','Right winger',2005617680,'S2'),
('f2c7ba5d-b027-4845-974d-a8d573ded961',NULL,'Stanly','Barette','986-702-0671','2000-12-01','FALSE','Center forward',2005617680,'S3'),
('c50f5f68-0e02-4205-aaed-60ae7be66de3',NULL,'Royce','Elliff','985-150-2352','2016-01-03','FALSE','Left winger',1678262697,'S1'),
('388212e2-bed7-4f6b-896e-e787ba3cbf47',NULL,'Cyrill','MacDearmid','201-306-1889','2015-07-30','FALSE','Second striker',1678262697,'S2'),
('f4afd8a3-31e0-43e1-8fd5-9ee1b8aac5da',NULL,'Marleah','Matzke','674-607-9808','2017-03-14','FALSE','Goalkeeper',1678262697,'S3'),
('22f7b51b-b2e3-4f3a-9dff-aaf7d6ecf0f0',NULL,'Hunt','Kellitt','924-415-1930','2001-07-12','FALSE','Right back',2135919890,'S1'),
('b23cd48d-9508-4f2b-9ec3-d95eb4652ae2',NULL,'Raffarty','Force','232-647-6559','2014-09-14','FALSE','Center back',2135919890,'S2'),
('e9511835-80e9-4372-94fc-9dad0dbbea67',NULL,'Ernesto','Kimbrey','972-187-8283','2016-06-01','TRUE','Left back',2135919890,'S3'),
('efe10f7e-95af-43d9-86b2-1ccd9d9c0e99',NULL,'Otha','Perrelli','453-107-4739','2011-06-15','TRUE','Defensive midfielder',2222849710,'S1'),
('ac52a87c-9540-43f5-8162-a5d1ebc5cbe3',NULL,'Shelagh','Guillotin','136-163-0073','2009-09-25','TRUE','Central midfielder',2222849710,'S2'),
('a6194b43-07d0-4433-a73e-db1e8a9b70e8',NULL,'Tedi','Beagrie','647-572-3505','2010-07-15','FALSE','Attacking midfielder',2222849710,'S3'),
('7432f6df-f1d1-42cb-9d48-cdc196eabcc6',NULL,'Gabrielle','Bulley','612-790-7586','2004-10-26','TRUE','Right winger',1705672938,'S1'),
('ad7adfc8-87b1-4cb8-8447-dbf37856f64e',NULL,'Rayner','Selman','228-269-0600','2004-03-31','TRUE','Center forward',1705672938,'S2'),
('22712fcb-818b-464c-aff3-199d89eb31a1',NULL,'Fayina','Swyer','559-273-8968','2018-06-17','FALSE','Left winger',1705672938,'S3'),
('3a7f26d2-2313-435a-9164-1b858925ed9d',NULL,'Ruttger','Fogel','254-470-5668','2010-02-05','FALSE','Second striker',2093637644,'S1'),
('d5afc1a0-dcc8-44f1-8e52-aab403c56dd6',NULL,'Lynda','Baroche','997-827-8465','2015-04-07','TRUE','Goalkeeper',2093637644,'S2'),
('749fb13f-4005-4ff5-ae91-91a62703d666',NULL,'Coop','Ricardo','260-643-2299','2012-03-05','TRUE','Right back',2093637644,'S3'),
('cf1e421e-27b7-4638-97ed-f3214e32897d',NULL,'Gertrudis','Filipiak','555-941-8047','2019-08-25','FALSE','Center back',2054952531,'S1'),
('af3270d2-54d2-44f8-819e-6f29b53f1dfd',NULL,'Tanner','Denziloe','457-388-7601','2008-08-22','TRUE','Left back',2054952531,'S2'),
('c2c59c6f-4def-4a2d-adf1-be5fa8af5e97',NULL,'Bidget','Hyams','575-145-4972','2015-08-30','TRUE','Defensive midfielder',2054952531,'S3'),
('6d4c55db-c899-47ad-972f-8004075e440a',NULL,'Dannie','Laflin','526-983-4899','2001-11-01','FALSE','Central midfielder',2170955138,'S1'),
('743749cc-a4c6-472f-a5d6-e29c39b1c3dc',NULL,'Tory','Roblin','391-781-4258','2004-05-09','TRUE','Attacking midfielder',2170955138,'S2'),
('7bee24e2-092c-4085-ae3e-7e3f09b68ffd',NULL,'Ebonee','Snead','597-507-7957','2011-11-08','FALSE','Right winger',2170955138,'S3'),
('dfb2b946-ccd1-4375-9144-dad610e114bc',NULL,'Marketa','Clampton','731-411-9085','2017-12-21','FALSE','Center forward',1827280408,'S1'),
('5d96e6ba-1179-4d4b-bc6d-5e8d9bc3469e',NULL,'Lora','Bearfoot','620-976-4389','2017-07-23','TRUE','Left winger',1827280408,'S2'),
('3c879d95-d821-415e-950e-57241983bf34',NULL,'Forster','Luddy','299-543-3229','2016-07-22','FALSE','Second striker',1827280408,'S3'),
('b858a110-59d8-42e1-a59a-3976d4895a94',NULL,'Farra','Farnaby','938-112-8071','2000-01-24','FALSE','Goalkeeper',1639946858,'S1'),
('24f55e2a-0962-43dc-a15a-05160b6a6559',NULL,'Deirdre','Musto','958-184-2307','2014-12-24','FALSE','Right back',1639946858,'S2'),
('12504af9-2911-4cc2-8f95-3b97823de3c6',NULL,'Levin','Benet','865-946-4342','2002-06-27','TRUE','Center back',1639946858,'S3'),
('35d0bf21-1a83-441f-bf8a-cba7b5b81135',NULL,'Delmor','Leber','830-309-1092','2012-01-18','TRUE','Left back',1970151163,'S1'),
('632fd8cc-0804-4fc4-819d-cae76fd0f943',NULL,'Hastie','Duckworth','177-569-2702','2017-12-21','FALSE','Defensive midfielder',1970151163,'S2'),
('68fd7086-0df8-477b-a401-3033b8cb209a',NULL,'Bertie','McVity','604-226-7503','2011-08-12','TRUE','Central midfielder',1970151163,'S3'),
('828de2ee-76ae-47e3-9261-4de6a972987f',NULL,'Tabina','Schukraft','803-356-2353','2020-03-15','TRUE','Attacking midfielder',2087773430,'S1'),
('f85ecca5-1ff0-45a3-8a1d-629eb2390e20',NULL,'Dulcia','Nellis','803-495-2480','2020-03-10','FALSE','Right winger',2087773430,'S2'),
('5a058321-8b59-43c6-9197-c58c59d2ca63',NULL,'Coralie','Georg','409-369-4527','2019-10-05','FALSE','Center forward',2087773430,'S3'),
('c1d2c497-082d-42fd-acb6-9395a2c40e6f',NULL,'Marianne','Tallach','630-918-5222','2007-03-12','FALSE','Left winger',1529759401,'S1'),
('2921d7bf-a0a9-41e4-9e1e-0d8fc7ee6ff5',NULL,'Nessa','Koppen','601-786-8288','2001-05-23','FALSE','Second striker',1529759401,'S2'),
('b1d01a14-af6a-47de-bd26-4c986d71b6d9',NULL,'Aubrey','Yegorovnin','411-253-2602','2003-03-26','FALSE','Goalkeeper',1529759401,'S3'),
('a6b94edc-8036-4cc9-bdf2-03d288e26fd4',NULL,'Zara','Papaccio','304-356-0439','2009-09-21','TRUE','Right back',1614857148,'S1'),
('c6393854-c448-4c07-8bec-637dbdb59b5b',NULL,'Galvin','Laundon','207-962-6882','2014-07-10','TRUE','Center back',1614857148,'S2'),
('5588f89a-f2dd-4171-a911-f39ba1cce916',NULL,'Elfie','Duck','278-439-7109','2009-01-25','FALSE','Left back',1614857148,'S3'),
('59019136-e150-4eb9-b6af-2c204c956d58',NULL,'Kaitlynn','Comins','597-580-7398','2015-02-08','TRUE','Defensive midfielder',1825739006,'S1'),
('8f520efa-dd27-4324-8ed6-0e2a837787cb',NULL,'Raphaela','Munson','431-810-9869','2006-11-07','FALSE','Central midfielder',1825739006,'S2'),
('a237c2d4-0fc4-42e8-9c58-58c7a0fc8e5d',NULL,'Barbette','Terbeck','952-462-4280','2007-04-15','TRUE','Attacking midfielder',1825739006,'S3'),
('6e17ae62-715c-4afc-9251-8cb6b3eac690',NULL,'Trina','Wyer','538-681-5851','2019-11-26','FALSE','Right winger',2165544937,'S1'),
('48e33614-b450-4e2e-a549-2ddf2de611cb',NULL,'Harman','Heinsius','289-411-4780','2018-03-21','FALSE','Center forward',2165544937,'S2'),
('bb67c841-e386-4d25-a8db-c67a582a615d',NULL,'Odelle','Gadeaux','194-917-4515','2011-05-07','TRUE','Left winger',2165544937,'S3'),
('2c5ceeba-9853-44b4-a7c0-6295003a431c',NULL,'Tonye','Wilbor','145-287-4559','2005-03-08','FALSE','Second striker',2296364759,'S1'),
('77820244-ebf6-41fc-bc2b-9eab8605b1a8',NULL,'Janela','Piatto','577-281-0402','2007-06-29','TRUE','Goalkeeper',2296364759,'S2'),
('b04655b2-f1cb-4460-b5c6-34c29d3a96dc',NULL,'Etti','Lomond','571-135-5210','2012-08-15','FALSE','Right back',2296364759,'S3'),
('fa1059ee-05e2-4dd0-8a22-3b7eaf62f725',NULL,'Ferguson','Shearer','687-822-7194','2014-10-12','FALSE','Center back',1522290193,'S1'),
('e84388fe-31ef-4a30-bcb5-8c36a4b973f1',NULL,'Libbey','Kurth','195-989-7650','2011-10-13','FALSE','Left back',1522290193,'S2'),
('fd65c023-0f21-4852-b953-d25d67aaddf3',NULL,'Renard','Vasic','394-922-0859','2015-05-05','TRUE','Defensive midfielder',1522290193,'S3'),
('d1a57d6b-ee74-40d2-984a-000cae946be7',NULL,'Fabio','Mariette','936-937-4639','2007-10-12','FALSE','Central midfielder',1554382086,'S1'),
('11b2c765-0d8e-41a0-bef3-173e5c47dd88',NULL,'Gwyneth','Gouldthorp','189-592-9046','2015-12-05','FALSE','Attacking midfielder',1554382086,'S2'),
('5450c987-1e3f-433b-8eec-9f49d5a300ff',NULL,'Basia','Truckell','169-426-8790','2004-11-06','TRUE','Right winger',1554382086,'S3'),
('974512a0-4e2c-4bad-99bc-851249fee854',NULL,'Adella','Mankor','145-528-7906','2017-11-09','FALSE','Center forward',1512038875,'S1'),
('77d9c119-9beb-4640-b280-4dae84c82d16',NULL,'Tabor','Handy','258-272-7542','2016-03-03','TRUE','Left winger',1512038875,'S2'),
('02865538-525a-4943-909e-e0e8d110f356',NULL,'Rab','Eastmond','961-607-4755','2001-05-28','FALSE','Second striker',1512038875,'S3'),
('ffc6a821-3a76-4849-b99d-6865db075e4e',NULL,'Jobye','Ottosen','242-915-9557','2004-03-06','FALSE','Goalkeeper',1677230051,'S1'),
('390f35e9-9197-405f-a318-ffaa8d128984',NULL,'Cathyleen','Chastelain','601-783-6728','2008-06-02','FALSE','Right back',1677230051,'S2'),
('40485fd2-b59b-41ca-86a8-59bc784ebf04',NULL,'Arnaldo','Chamney','310-863-1510','2011-12-04','TRUE','Center back',1677230051,'S3'),
('813d60c3-cb89-41df-90bc-b2b96405eeb7',NULL,'Oriana','Bloschke','349-896-3650','2002-02-21','TRUE','Left back',1586410394,'S1'),
('a9863cc3-2d7b-4f72-8a17-81b3ff25bb1d',NULL,'Ynes','Blackeby','371-737-1686','2000-08-29','FALSE','Defensive midfielder',1586410394,'S2'),
('fb986ed6-08e1-4053-a6e5-a97c4e147f03',NULL,'Tome','Heinreich','341-566-1921','2011-06-24','FALSE','Central midfielder',1586410394,'S3'),
('7a293b4d-e51a-4e8a-803e-d6dc99b9c75a',NULL,'Jordain','Blackborow','373-402-0070','2009-12-29','FALSE','Attacking midfielder',2045576052,'S1'),
('3f97cbdb-b527-4677-b9c9-51c892724c5c',NULL,'Ange','Primarolo','183-201-8927','2004-03-06','TRUE','Right winger',2045576052,'S2'),
('92494b36-c906-434c-a55a-21f8e8a17e96',NULL,'Ban','Yockley','242-845-9144','2010-11-02','FALSE','Center forward',2045576052,'S3'),
('3e2a59c3-7510-45a7-b5b6-86c0cd2fe749',NULL,'Siusan','Wiltshear','309-371-9526','2011-09-04','FALSE','Left winger',1777572451,'S1'),
('5ded227a-fd1d-46c8-a753-7c529526d1ab',NULL,'Kassia','Nezey','114-752-3112','2006-06-04','FALSE','Second striker',1777572451,'S2'),
('49008219-5e19-4fbd-96aa-928ab1a7e661',NULL,'Anya','Bauldrey','125-545-6480','2018-06-13','FALSE','Goalkeeper',1777572451,'S3'),
('eb9eb967-bcbf-4c64-aa2d-1cc52709d343',NULL,'Eva','Shaw','308-708-4185','2019-04-02','TRUE','Right back',2157601666,'S1'),
('ce7ac7e4-c1e5-4d75-9dd5-dcaf2cb962ac',NULL,'Kimble','Trase','751-487-4023','2011-05-21','TRUE','Center back',2157601666,'S2'),
('900649bd-43f8-49e2-bb89-dcf2ba1648b5',NULL,'Kipp','Dalgardno','205-459-4843','2010-11-30','FALSE','Left back',2157601666,'S3'),
('c0ffcb3b-c12a-499c-b4ea-d9e7e8e88274',NULL,'Pippa','Guiraud','367-151-5842','2020-01-09','TRUE','Defensive midfielder',2250832303,'S1'),
('b2f052c4-ff30-4a95-ba7c-c66bf2817c1a',NULL,'Aleda','Stannard','446-494-3283','2015-02-02','TRUE','Central midfielder',2250832303,'S2'),
('29525de9-ae22-4d91-95fe-62eeeeb0be11',NULL,'Aliza','Seabridge','276-823-7102','2014-10-29','TRUE','Attacking midfielder',2250832303,'S3'),
('07a45801-11d2-49cf-8f27-8c94da307836',NULL,'Adel','Glackin','926-544-3294','2016-06-16','FALSE','Right winger',1631588392,'S1'),
('cf97f4f1-6945-496e-a770-b7672d1614f9',NULL,'Sapphire','Leven','855-317-1439','2017-07-22','TRUE','Center forward',1631588392,'S2'),
('87e46314-65c2-4eb0-99cf-563c30d24f1a',NULL,'Thaddeus','Laidlow','495-537-4687','2002-06-14','TRUE','Left winger',1631588392,'S3'),
('8d6e226d-615e-4c6f-a791-f932468531ca',NULL,'Hunt','Tinker','346-295-4892','2018-05-10','TRUE','Second striker',2212140040,'S1'),
('59f2b8ea-7e24-410f-8974-995edbb089ac',NULL,'Othilia','Amies','137-815-3683','2016-12-01','TRUE','Goalkeeper',2212140040,'S2'),
('762682ab-803b-4791-842f-c71e8ecf4793',NULL,'Kristos','McGirr','486-565-3362','2003-02-03','TRUE','Right back',2212140040,'S3'),
('f16ec06c-cfd2-45d0-ba6c-92b6853b6d60',NULL,'Victoir','Mandrier','630-771-4781','2014-11-23','TRUE','Center back',2260268911,'S1'),
('1d423e38-e83d-4ce7-bd7b-af59900995c8',NULL,'Ashia','Dewire','815-292-4530','2019-01-29','FALSE','Left back',2260268911,'S2'),
('29bfddc3-1807-4e1a-a30b-0694718870cd',NULL,'Marney','Philippou','822-195-2736','2009-05-29','TRUE','Defensive midfielder',2260268911,'S3'),
('1b842bab-61e3-4c4e-92a0-57aae4163bf3',NULL,'Thor','Milley','380-845-3123','2011-07-31','FALSE','Central midfielder',1622342174,'S1'),
('3cf28dbf-a4c8-4404-937a-3d046de38c54',NULL,'Violante','Petronis','550-823-1929','2007-02-19','FALSE','Attacking midfielder',1622342174,'S2'),
('b1d2e753-b506-4812-9c0a-271622997747',NULL,'Alva','Blackadder','888-215-0726','2020-01-22','FALSE','Right winger',1622342174,'S3'),
('f31241b0-9ba6-42af-b0fd-fe41c8c9ceb9',NULL,'Cully','Tippler','140-952-4015','2013-04-18','FALSE','Center forward',1842071961,'S1'),
('8b397829-cd73-424f-b494-7c09bc52e26e',NULL,'Julio','Swiffan','762-763-7944','2018-05-25','TRUE','Left winger',1842071961,'S2'),
('a4273928-3f0b-4d25-b65b-9585c3a85ef7',NULL,'Barri','Devorill','468-546-2384','2007-10-11','FALSE','Second striker',1842071961,'S3'),
('0742ddf5-c121-4c2a-a5b0-fda8f48ddbe4',NULL,'Karry','Kloska','471-551-4148','2019-07-09','TRUE','Goalkeeper',2151884359,'S1'),
('3c99cdaa-b80d-4cfd-9bef-bee27b42dc6c',NULL,'Amabelle','Averay','296-221-2670','2005-08-30','TRUE','Right back',2151884359,'S2'),
('0a189a1a-ab46-42fb-abe7-4eee7c03ace0',NULL,'Pierson','De Stoop','673-737-6730','2003-07-24','TRUE','Center back',2151884359,'S3'),
('c8c8cec1-3bc2-4d02-955e-4cc04462b7ca',NULL,'Rora','Thormann','790-864-0758','2004-03-21','TRUE','Left back',1918928088,'S1'),
('51258934-1af4-449a-a375-6abeb9f6a149',NULL,'Charlton','Helling','718-143-7167','2012-01-20','TRUE','Defensive midfielder',1918928088,'S2'),
('ca647300-36dc-480a-8e00-7f58955bf3c4',NULL,'Brynna','Innes','240-100-7151','2005-04-22','FALSE','Central midfielder',1918928088,'S3'),
('0dea7bdb-5885-418d-bcc6-c65ac4b40e16',NULL,'Janaye','Goomes','377-714-5169','2019-09-01','TRUE','Attacking midfielder',1781332315,'S1'),
('8aa0d557-ac5d-42b5-9c6e-fcc58ea9761e',NULL,'Romeo','Pentin','668-717-9665','2001-04-28','TRUE','Right winger',1781332315,'S2'),
('82916b56-c4c0-4051-8e89-bec0db198669',NULL,'Talbert','Ashforth','946-141-9189','2004-12-21','FALSE','Center forward',1781332315,'S3'),
('b65edf93-6eae-4db3-af6c-667e09473847',NULL,'Richy','Kisar','599-330-5493','2009-10-01','FALSE','Left winger',1624291912,'S1'),
('c6bbd82a-9ffd-493b-a1e5-e567250cb5e7',NULL,'Levon','Sivior','936-127-4057','2012-04-28','FALSE','Second striker',1624291912,'S2'),
('fb6948e8-e7a2-493b-b43b-d32f0e7c7c44',NULL,'Sela','Martland','734-240-2764','2015-11-08','TRUE','Goalkeeper',1624291912,'S3'),
('36adcad9-d4ae-45e1-b9f9-0fe4f1f8db28',NULL,'Adrianna','Billsberry','208-150-1556','2011-03-01','FALSE','Right back',1749560449,'S1'),
('39622e77-4902-48bf-b7ae-91c103e25555',NULL,'Byrom','Bosson','648-324-2760','2007-10-11','FALSE','Center back',1749560449,'S2'),
('9ca6509e-e8d5-49dd-869b-74eac96dcfca',NULL,'Milicent','Ingleton','871-490-9764','2014-11-07','FALSE','Left back',1749560449,'S3'),
('4b51c709-cd5b-4f0b-9502-cef73004e637',NULL,'Aloise','Greave','200-285-8225','2003-11-16','FALSE','Defensive midfielder',2080758881,'S1'),
('5b825c45-3e7b-4a34-a9be-85045b10502b',NULL,'Burt','Sapwell','482-987-0857','2005-02-23','FALSE','Central midfielder',2080758881,'S2'),
('4accc333-bca7-43e0-af0d-21f7f113dc0a',NULL,'Norby','Bicknell','489-620-7815','2019-10-22','FALSE','Attacking midfielder',2080758881,'S3'),
('84de6a35-3fb0-41a7-8698-c840738c1ec5',NULL,'Giraud','Rosenbaum','831-912-0483','2002-10-01','TRUE','Right winger',1667717162,'S1'),
('4d64cdd6-3516-4322-9277-7d15a2be204d',NULL,'Granville','Stickney','201-487-9155','2019-05-03','FALSE','Center forward',1667717162,'S2'),
('65c88feb-46fb-406a-b8eb-86c291108419',NULL,'Lezlie','Fellona','757-117-2631','2002-04-29','FALSE','Left winger',1667717162,'S3'),
('963d05d3-57d8-46b9-9863-d60467387e7b',NULL,'Jeana','Yakunin','782-186-4901','2001-06-27','TRUE','Second striker',2192559900,'S1'),
('2bca3eb9-bc74-4362-85ca-67e1d4e0c39e',NULL,'Ky','Ferraro','812-220-2760','2015-08-13','TRUE','Goalkeeper',2192559900,'S2'),
('ac117ffe-5a52-4d9b-a508-667592f46631',NULL,'Rodi','Coners','515-746-4936','2001-03-23','TRUE','Right back',2192559900,'S3'),
('fa3738c7-ba82-46e0-9a18-d38f590e2824',NULL,'Cecil','Roundtree','146-532-3545','2014-11-05','TRUE','Center back',2255769066,'S1'),
('f1dc0f0d-e2ef-4c3b-b0f7-336e21bf6c3a',NULL,'Mame','Mc Caughan','731-654-0074','2018-02-02','FALSE','Left back',2255769066,'S2'),
('24284d8e-6e93-4327-ba01-75fd8ac0962e',NULL,'Barb','Schoolfield','996-334-3685','2016-11-14','TRUE','Defensive midfielder',2255769066,'S3'),
('90edf5db-77d2-414a-b65c-5da7e9683f74',NULL,'Darya','Tibbles','139-516-9162','2015-03-18','FALSE','Central midfielder',1979704321,'S1'),
('90dd13cd-b797-431c-b1c1-0b6a22ee474e',NULL,'Niall','Stainson','626-759-7975','2017-02-09','TRUE','Attacking midfielder',1979704321,'S2'),
('3798e5a6-bfbd-47d9-8503-fedb0851f0ee',NULL,'Batholomew','McEneny','469-507-5296','2012-01-16','FALSE','Right winger',1979704321,'S3'),
('50b9b5f0-76e9-4dbb-8c5a-85425eaa2d4a',NULL,'Fredra','Rignoldes','836-320-2757','2016-05-17','FALSE','Center forward',1548962759,'S1'),
('a7671376-d5f2-4159-a5f9-db5dc812251a',NULL,'Rachel','Atkirk','816-301-8831','2017-07-29','TRUE','Left winger',1548962759,'S2'),
('be90008c-c4ab-4bc9-b908-e6395cb97642',NULL,'Chadd','Absolom','520-480-2445','2015-03-09','TRUE','Second striker',1548962759,'S3'),
('47cf0bcb-d336-49e8-9444-b1386af25ea5',NULL,'Carolynn','Newitt','408-316-3180','2002-07-10','FALSE','Goalkeeper',1677123083,'S1'),
('009dac6d-be3a-45e9-b2c5-d83d7f53c7e7',NULL,'Creight','Canter','496-309-4355','2009-03-26','TRUE','Right back',1677123083,'S2'),
('2714945d-1f52-49c8-9cc0-c5ec7a423002',NULL,'Vallie','Studders','328-420-2178','2017-05-17','FALSE','Center back',1677123083,'S3'),
('e05094a9-bc7e-4aa6-a6d6-28bf08ff7d6e',NULL,'Celia','Collicott','715-959-1996','2013-06-28','FALSE','Left back',1872014926,'S1'),
('40e30d61-6968-4316-a99e-8f3fe832b825',NULL,'Gunar','Hallatt','318-739-4190','2020-02-15','FALSE','Defensive midfielder',1872014926,'S2'),
('ec00a086-eaa0-4696-9c8e-50e74e955727',NULL,'Kyle','Bottoner','417-113-1367','2006-02-09','TRUE','Central midfielder',1872014926,'S3'),
('3fa5d906-e0a5-4d1e-bf7d-61d11acbbf35',NULL,'Jarrod','Echallier','837-758-7863','2012-12-13','TRUE','Attacking midfielder',1942077921,'S1'),
('83524aba-8243-4d6c-ad51-a2481b7b9f41',NULL,'Karlis','Silver','999-741-1084','2007-01-18','FALSE','Right winger',1942077921,'S2'),
('09ce0737-19c1-4f3d-9ed9-1815b340500a',NULL,'Collin','Piggot','877-879-2370','2000-03-08','FALSE','Center forward',1942077921,'S3'),
('75828615-cc55-401b-9329-11887c613144',NULL,'Roch','Voak','458-100-1043','2017-09-29','FALSE','Left winger',2272300223,'S1'),
('7aa04991-c4a3-44a4-85d1-ac3726b372ff',NULL,'Donia','Helin','155-962-3028','2006-02-09','TRUE','Second striker',2272300223,'S2'),
('fd4d4d02-cd85-4d82-bc2d-a672f7b9618f',NULL,'Colby','Woodthorpe','947-736-2480','2011-05-22','TRUE','Goalkeeper',2272300223,'S3'),
('51a32685-2974-47ac-b0b1-8fcacc4c9b54',NULL,'Yalonda','Troy','909-909-8523','2017-03-24','FALSE','Right back',2166859810,'S1'),
('77928e30-2a6d-4802-94ff-a00293f5cb3b',NULL,'Rosemarie','Tunbridge','828-364-6257','2011-02-27','TRUE','Center back',2166859810,'S2'),
('8189b500-0d07-41da-a169-ec407b8b6285',NULL,'Raf','Boliver','167-758-3130','2019-10-24','FALSE','Left back',2166859810,'S3'),
('11c03ced-df34-4dff-883c-8c68aa56e8f5',NULL,'Harley','Bothbie','978-679-8795','2004-02-23','FALSE','Defensive midfielder',1741957184,'S1'),
('f47b124d-d08c-456e-bbd9-505f33bcf233',NULL,'Bella','Wakerley','668-548-1789','2016-10-21','FALSE','Central midfielder',1741957184,'S2'),
('e1da6972-35e8-4f2e-b83b-cfff50b46e3a',NULL,'Birdie','Bresland','694-348-3812','2007-04-07','FALSE','Attacking midfielder',1741957184,'S3'),
('0bfb6c98-bba7-4f35-b5ab-9b2a98b4a585',NULL,'Josefa','Grimley','571-636-4992','2002-07-16','FALSE','Right winger',2077858444,'S1'),
('40575d63-f122-4fab-bb30-c383acceb52d',NULL,'Mariquilla','Backhurst','398-147-1851','2014-07-05','TRUE','Center forward',2077858444,'S2'),
('262f9c38-1c29-495f-92d6-46f029e5b8f8',NULL,'Joannes','Madine','571-756-6387','2008-12-28','FALSE','Left winger',2077858444,'S3'),
('debbd95d-d045-4bdb-82e3-6150edb6608b',NULL,'Kelcie','Bartoleyn','657-214-9461','2006-07-01','TRUE','Second striker',2095882332,'S1'),
('ed0a0c85-00cd-4dad-80fc-3ca23cc0da41',NULL,'Zara','Arndtsen','779-560-7384','2017-06-01','FALSE','Goalkeeper',2095882332,'S2'),
('55da6d05-c986-4cc9-9879-57107ef72f56',NULL,'Syd','Curthoys','188-529-8875','2002-03-27','TRUE','Right back',2095882332,'S3'),
('449f9404-be43-4541-8946-41b6c731bc63',NULL,'Vale','Fardon','345-991-6295','2009-06-18','FALSE','Center back',2243854150,'S1'),
('3d5ffafa-28b5-4898-bb6d-582c3b4156e5',NULL,'Avrit','Cockren','520-684-7518','2014-10-10','TRUE','Left back',2243854150,'S2'),
('27454b64-72f7-4b48-968f-6e0dd4e819ec',NULL,'Charmian','Isaaksohn','953-602-1633','2004-08-03','TRUE','Defensive midfielder',2243854150,'S3'),
('795d4868-c6be-4a22-be8d-ab017a4f39f0',NULL,'Adriane','Skym','166-370-8962','2011-02-28','FALSE','Central midfielder',2123577363,'S1'),
('eb76579c-ce96-451e-a2ff-82e96c88e661',NULL,'Erick','Whooley','194-640-6995','2008-01-15','FALSE','Attacking midfielder',2123577363,'S2'),
('d11954e5-1052-4708-9410-4325a38f8739',NULL,'Braden','Shwalbe','116-906-3158','2005-03-07','FALSE','Right winger',2123577363,'S3'),
('07ccc55d-f2ad-4205-81ef-fb209e8ce1c9',NULL,'Evelina','Duesberry','283-634-1706','2004-07-17','FALSE','Center forward',2024810718,'S1'),
('bfadfece-e004-403c-9405-f27b54c55df2',NULL,'Annabel','Leser','989-256-6269','2010-09-13','TRUE','Left winger',2024810718,'S2'),
('f0932911-3f19-4b1a-ba46-a5f435e018fa',NULL,'Sheree','Muckle','531-479-0066','2011-09-15','FALSE','Second striker',2024810718,'S3'),
('47069212-6ccc-4e15-b0ed-e706672fb521',NULL,'Carlyle','Sindell','864-528-0059','2020-01-13','TRUE','Goalkeeper',1525459528,'S1'),
('2a68185b-1e10-4e10-85d9-4dfc0a68a5c9',NULL,'Felita','Isakov','777-773-1187','2006-07-10','FALSE','Right back',1525459528,'S2'),
('ac30172e-4582-467f-b700-26ec0b8d6d10',NULL,'Chere','Matyja','775-845-9649','2006-10-22','FALSE','Center back',1525459528,'S3'),
('dddfff26-1eae-4539-a261-b8c390ac5b1b',NULL,'Gregorius','Longhurst','693-278-0009','2019-03-23','FALSE','Left back',2031657249,'S1'),
('df605b48-fabd-4728-8a48-97e652ea2a06',NULL,'Jordan','Gascard','143-252-4560','2011-08-29','FALSE','Defensive midfielder',2031657249,'S2'),
('ea5e23ec-a9aa-456a-a286-b3f2c2db98ab',NULL,'Aubry','O''Gavin','337-768-9227','2000-11-01','TRUE','Central midfielder',2031657249,'S3'),
('70eeb5e9-d97d-4c91-85f8-b3b40e78e304',NULL,'Easter','Leyfield','314-400-0137','2004-01-30','FALSE','Attacking midfielder',1632198996,'S1'),
('72889705-b0cc-4caa-8207-1a913ce59816',NULL,'Heinrik','Read','910-355-5647','2011-03-06','TRUE','Right winger',1632198996,'S2'),
('309b0a59-9514-4f06-b1d9-839ba272b03a',NULL,'Winston','Kayser','910-447-4594','2002-07-21','TRUE','Center forward',1632198996,'S3'),
('1aad9d62-b2bd-42fb-b446-0fb9977982ca',NULL,'Derron','Broszkiewicz','919-362-9377','2018-09-16','TRUE','Left winger',2263935503,'S1'),
('05f59540-e57d-4923-abc2-4ff43151aee7',NULL,'Maggi','Verdon','613-746-7886','2000-03-08','TRUE','Second striker',2263935503,'S2'),
('1f510ee0-d86b-4f5b-af61-79a8f7507a73',NULL,'Cross','McGuggy','585-581-4704','2014-04-08','FALSE','Goalkeeper',2263935503,'S3'),
('521ebfe2-8f10-46ee-97e7-17236f9af464',NULL,'Dari','Coushe','895-979-9067','2014-10-05','FALSE','Right back',1948840568,'S1'),
('c0d9295a-ad24-4afa-90df-bc46dcbab3a9',NULL,'See','Frohock','575-372-7856','2003-04-20','TRUE','Center back',1948840568,'S2'),
('0297a1c3-ff00-458f-a057-26d278d4ff56',NULL,'Ginevra','Mitham','182-833-1434','2004-11-17','FALSE','Left back',1948840568,'S3'),
('8921bebe-56f1-4901-a522-e7b4740fecb1',NULL,'Marven','Keysel','956-305-0610','2018-12-26','FALSE','Defensive midfielder',2091619272,'S1'),
('d4ee4ff6-3330-4e81-9b59-5b7a4bd5a77a',NULL,'Ashley','Gunn','567-796-7129','2020-02-20','FALSE','Central midfielder',2091619272,'S2'),
('22beece8-0f04-4e85-8394-16436d263933',NULL,'Rustin','Ashpital','911-569-4683','2005-04-04','TRUE','Attacking midfielder',2091619272,'S3'),
('1818b113-4022-4288-b907-437e88d312cf',NULL,'Orlando','Gurko','110-497-5146','2015-01-06','TRUE','Right winger',2093236841,'S1'),
('b599beaa-ff82-4396-af3b-548fdc651f47',NULL,'Cecilla','Woodfine','560-796-2042','2006-10-07','FALSE','Center forward',2093236841,'S2'),
('d971868d-8e68-403a-932f-90f7fceeb1d2',NULL,'Brice','Kelloway','223-480-7776','2000-02-08','FALSE','Left winger',2093236841,'S3'),
('c65ee574-8680-4221-bee5-7440b13b13fd',NULL,'Erick','Drust','774-833-5532','2017-06-20','FALSE','Second striker',1886402943,'S1'),
('2523e25f-cc02-4ad1-9eb2-0f6e4734dbf1',NULL,'Shoshanna','Baybutt','848-783-8098','2007-08-08','TRUE','Goalkeeper',1886402943,'S2'),
('33b94dc4-a8e6-40d5-9581-39fd575961dd',NULL,'Rhianna','Castellino','233-605-2878','2001-06-25','FALSE','Right back',1886402943,'S3'),
('491afcbb-7674-4e41-9e8b-9441998405a6',NULL,'Bobbe','Cadamy','562-518-5789','2018-03-04','FALSE','Center back',2084051554,'S1'),
('193b6d22-f452-43cd-a418-7374e1e3c5c1',NULL,'Peter','Hollows','255-667-6311','2003-10-20','FALSE','Left back',2084051554,'S2'),
('3e563db9-f866-40e0-8226-200f0a0faacb',NULL,'Tymon','Gregs','112-123-1392','2002-01-29','FALSE','Defensive midfielder',2084051554,'S3'),
('706e81e9-2db8-45d5-9856-5eb6c96949a1',NULL,'Hadrian','Corrie','581-681-7572','2018-09-01','TRUE','Central midfielder',1632970755,'S1'),
('b9d9fd0d-755c-4172-89c5-8c84e0dd42ad',NULL,'Swen','Innman','248-550-5905','2019-03-27','FALSE','Attacking midfielder',1632970755,'S2'),
('48bc2de9-7ba9-4bea-b443-9ed9c6fcc3fb',NULL,'Izabel','Nell','623-312-3344','2013-10-11','TRUE','Right winger',1632970755,'S3'),
('0ea56a7f-e0f8-4788-a0bf-c96204257f79',NULL,'Lin','Geertsen','821-713-0063','2014-03-25','TRUE','Center forward',2045863349,'S1'),
('5707a1b4-7b2f-40ad-b46b-1be18d67dd79',NULL,'Pablo','Glanester','275-841-6318','2018-07-25','FALSE','Left winger',2045863349,'S2'),
('0d6e78c1-0eb5-4ef5-bbe3-66cbdb41650e',NULL,'Spence','Allsobrook','186-151-4967','2008-03-07','FALSE','Second striker',2045863349,'S3'),
('e7610bd1-f93b-4592-ad72-17cf4234da89',NULL,'Nell','Ruggiero','518-189-3423','2000-08-24','TRUE','Goalkeeper',2095799638,'S1'),
('dc86c70a-dc93-4df3-b64b-61b7a72d7a1a',NULL,'Giovanna','Dodson','413-975-6069','2016-02-20','FALSE','Right back',2095799638,'S2'),
('fbfa8dc8-66eb-4480-9195-66aac2604e56',NULL,'Drusilla','Jinkin','304-865-8945','2001-05-25','FALSE','Center back',2095799638,'S3'),
('5d91775e-8475-4b48-8311-a570c0b514d2',NULL,'Davidde','Greguoli','889-892-6247','2003-05-04','FALSE','Left back',1529472480,'S1'),
('a06cad79-052c-42e5-90a1-b9c599ed1548',NULL,'Emili','McCullock','410-870-7724','2003-01-11','TRUE','Defensive midfielder',1529472480,'S2'),
('9c4261aa-d9ec-4d19-8a71-a2c1cbf71c12',NULL,'Holly-anne','Drowsfield','389-123-3258','2013-06-25','TRUE','Central midfielder',1529472480,'S3'),
('5388a0bd-f5d6-497e-a4a7-120ab1517dd7',NULL,'Mitchell','Hazleton','177-586-3460','2010-01-10','TRUE','Attacking midfielder',2137112831,'S1'),
('a5cbe284-852d-45c5-94f4-bb31967b3ae2',NULL,'Archaimbaud','Eddis','771-499-7395','2019-01-15','TRUE','Right winger',2137112831,'S2'),
('71ca2784-cf40-4d35-b086-37dfd120983e',NULL,'Elaine','Toolin','351-342-4393','2001-12-04','FALSE','Center forward',2137112831,'S3'),
('fed3706c-3830-4616-bbee-a37be2c62bef',NULL,'Louisa','Radleigh','964-547-6273','2014-02-01','TRUE','Left winger',1787317083,'S1'),
('3b387a2d-80a3-4a2f-8106-08bbbc81be55',NULL,'Dru','Josipovic','800-713-5069','2008-11-12','FALSE','Second striker',1787317083,'S2'),
('37676e17-3e1f-4450-a1fe-9c4a4daa4568',NULL,'Anselm','Jelly','237-365-9627','2012-05-22','TRUE','Goalkeeper',1787317083,'S3'),
('6c9490e3-25c9-4fae-96eb-6ea6168a8da0',NULL,'Baxter','Farlowe','724-472-0254','2016-03-16','TRUE','Right back',1957593831,'S1'),
('1e8bf09d-0549-405f-8049-e89ab4ac7884',NULL,'Ody','Larkkem','949-526-9987','2002-09-08','FALSE','Center back',1957593831,'S2'),
('bbf78bce-9b71-471c-be50-6bf7c8164776',NULL,'Daisie','Moon','849-269-4020','2010-02-03','TRUE','Left back',1957593831,'S3'),
('382765c6-3b92-4c89-a730-336682a564dd',NULL,'Marchelle','Wisdom','458-435-2906','2004-09-17','TRUE','Defensive midfielder',1614289823,'S1'),
('a71b7de4-bfe7-4f1e-8fac-75d91a86d22e',NULL,'Blondie','Curgenven','684-687-2733','2015-03-27','FALSE','Central midfielder',1614289823,'S2'),
('b1c719b1-d160-4820-b59d-2f4c63702bb2',NULL,'Uta','Dunlea','213-939-3876','2012-03-30','TRUE','Attacking midfielder',1614289823,'S3'),
('a3643fa6-9c94-45c9-b207-bba016d10e67',NULL,'Georgianna','Spriggen','767-920-1487','2014-02-13','FALSE','Right winger',2111990126,'S1');

INSERT INTO Stadium VALUES
('64582552-d73b-45e9-a996-720f5d43b689','Anfield','1414 Birch St',100000),
('8c731d67-57dd-47ff-b1a3-129566c658d5','Stamford Bridge','Anytown USA',30000),
('074e3090-8de9-4cb2-bbc7-d9d3937ce14b','Old Trafford','Anytown USA',85000),
('6c3a9056-7954-4a80-a6f0-11af7238a33f','Signal Iduna Park','Anytown USA',60000),
('97d7b485-03c6-4866-bcd4-80207534e219','Santiago Berdebu','1616 Spruce St',43800),
('afdd7273-5311-4aed-ba2f-18c44c7f1733','Camp Nou','Anytown USA',60000),
('f0b479c1-86f1-4958-b51d-15128cdd2cb6','Santiago Bernabeu','1919 Chestnut St',73000),
('99e5ea80-ab39-4d89-a47d-3e3cf6e5de88','Kanjuruhan','12 Kalimalang ',35000),
('88b98df2-784c-48cb-90c7-17378dd51248','Gelora Bung Karno','123 Jakarta',80000),
('348bc921-c74d-4d6c-8d75-cfdedc218556','Serame','1010 Lahat',300);


INSERT INTO Non_Pemain VALUES
('a8ebf01a-89c9-4c70-bd8e-0ec4b7db46c5','Randolph','Wimpenny',1639094045,'rwimpenny0@google.ru','94 Roth Park'),
('8baedc8b-254f-412d-a774-99e0a7e2fab5','Coralyn','Adan',2114632411,'cadan1@thetimes.co.uk','543 Roxbury Road'),
('5a855e64-2aed-4574-baa6-13c6296995f2','Vanya','Corrao',7945910028,'vcorrao2@java.com','4 Nelson Crossing'),
('fb99e8af-6cc3-4e97-ab5f-10ef83a5ac08','Celka','Hunston',6546440603,'chunston3@wisc.edu','426 Northland Street'),
('7abab725-ac56-4b2e-a917-da1890150483','Ivar','Shegog',9196781562,'ishegog4@theatlantic.com','77 Harper Drive'),
('d071abd3-2a6f-438d-bf2f-c76db7295b61','Jay','Geleman',5816555951,'jgeleman5@godaddy.com','36946 Dexter Plaza'),
('29584fbb-a04f-4c7e-8460-8e5b3ed30c04','Melisenda','Skitral',7003363920,'mskitral6@independent.co.uk','3110 Bluestem Plaza'),
('764b0fe6-bbc3-4077-8be3-092908bbe4d8','Bevin','Glentworth',8065949160,'bglentworth7@vk.com','1 Clarendon Street'),
('35418e19-0489-44d2-9b0c-4578e0f8e0a9','Maximilien','Bascomb',6341062633,'mbascomb8@cbsnews.com','76 Swallow Avenue'),
('42414d4b-75ed-4073-b2a1-356d9516c407','Curran','Zannuto',8124374271,'czannuto9@mail.ru','5591 Bartillon Circle'),
('0eed62be-73ab-4690-999e-c8f4f3f3d5d7','Anabal','Wash',7044451363,'awasha@csmonitor.com','2100 Muir Court'),
('32503599-4345-4654-bd21-b6b3dd1cc8bf','Roxana','Marchi',4372458036,'rmarchib@pbs.org','802 8th Terrace'),
('889577de-9896-4468-8c3c-d296f2163b09','Selene','Counsell',7957957470,'scounsellc@alibaba.com','77 Michigan Lane'),
('ebe0a3f6-ff57-43a7-b747-563d161a2614','Lyle','Twinbourne',8561178641,'ltwinbourned@alexa.com','7390 Bay Alley'),
('ebd6d18e-1198-464e-812b-7e0abaef1398','Mollie','Grob',7816653072,'mgrobe@dion.ne.jp','30160 Steensland Center'),
('734e2f08-915a-48cb-bcae-0af0889187b4','Vivian','Meadus',6972905044,'vmeadusf@ifeng.com','679 Arrowood Terrace'),
('20e24a0f-3995-48c2-9a7d-ba3db75ed26e','Karil','Sustin',6786686563,'ksusting@webs.com','4 Stone Corner Junction'),
('0eb68093-6dc0-42d2-92e2-886138889e66','Eben','Gridley',8238800711,'egridleyh@mozilla.com','1 Briar Crest Alley'),
('dc91d00e-6702-4e56-8c32-2196ecf400b7','Corabella','Crosher',2942825680,'ccrosheri@instagram.com','8 Arapahoe Pass'),
('bc420020-b2b8-4602-bad5-2639d6197e6e','Pierre','Collard',7092445008,'pcollardj@rambler.ru','69032 Northport Point'),
('4125894c-30b7-4573-bdf2-0010383b9dde','Nichols','Strutley',8747944907,'nstrutleyk@barnesandnoble.com','22994 Independence Pass'),
('7fa78084-62ec-438e-9fc9-6688ac974f6b','Dallas','Duplan',8599320606,'dduplanl@tinypic.com','26967 Katie Avenue'),
('783dfa30-50c7-4cda-87cb-783a2db041c0','Barrie','Ilyinykh',8889590768,'bilyinykhm@e-recht24.de','2232 Union Plaza'),
('52470659-dab4-438c-a4d4-dd6b83ea4ed3','Adolphus','Walsh',2022902687,'awalshn@accuweather.com','2 Loeprich Junction'),
('95c88ed0-928d-4915-ac17-00ef7ebd10ed','Edith','Toupe',5863867925,'etoupeo@fema.gov','9 Northport Plaza'),
('cdc4af22-d220-49a4-a666-864fdd1e9390','Linus','Scudder',4438145532,'lscudderp@mozilla.com','27186 Atwood Street'),
('7e4f33b1-e5cf-4497-81f3-52f15b7afcac','Paige','Terbrugge',9724405301,'pterbruggeq@dedecms.com','00 Towne Way'),
('20c9ac05-204b-49e5-85a2-b72444c3618d','Elvera','Michieli',5301229945,'emichielir@microsoft.com','700 Fairview Way'),
('725f7c98-255f-470c-9b41-44d0073c8c25','Barbie','Ayre',8075474975,'bayres@wp.com','90657 Buhler Circle'),
('d182a8bc-46da-499d-b3ee-793d18fe782b','Jacynth','Tibbs',6019294228,'jtibbst@nih.gov','99728 Thompson Court'),
('cce8d12f-3154-4c61-8218-60e859594f7d','Mord','Neward',5212940880,'mnewardu@blogs.com','834 Moland Point'),
('2268ac77-6d84-4a04-8bfc-4a689110e0a5','Armin','Lerego',2024000612,'aleregov@npr.org','68 Dawn Center'),
('ac2c5d33-3255-4e3a-8ad3-0afabf5ba498','Sigfried','Martinet',2662714321,'smartinetw@google.fr','23 Troy Park'),
('400e45bf-4222-4470-9991-540cd632f2e5','Saxe','Pardew',2051559827,'spardewx@aol.com','1523 Clarendon Parkway'),
('2c56d64f-418d-4bf6-a5c3-fd43a8ee193d','Reinwald','Reisen',1012092057,'rreiseny@360.cn','3 Oak Valley Lane'),
('930a63ad-9e44-4780-83da-6bd146ebbd6b','Jean','Tice',1187278405,'jticez@twitter.com','14481 Meadow Valley Street'),
('15d068a6-d9ee-4f93-941f-1a0419d42b62','Beau','Yarrow',8879229017,'byarrow10@census.gov','99 Debs Lane'),
('654fb47a-ea13-45c9-9cde-778cd0fba489','Salaidh','Twidell',3204955393,'stwidell11@github.com','2354 Thierer Road'),
('a2908651-66f0-44c9-8e37-e5165b5619f6','Jaquelyn','Faux',9837401677,'jfaux12@bbc.co.uk','2 Esker Plaza'),
('a0b4eced-8df8-44f6-aac6-2a74c1adc1f1','Edmund','Oslar',2142705673,'eoslar13@mysql.com','8 Rutledge Way'),
('a3393b61-d377-4f18-a2ce-6718020f142d','Tucky','Roseburgh',7182152414,'troseburgh14@dmoz.org','176 Grayhawk Drive'),
('3ca2d5c5-8ce0-4879-bcb4-526a12c03ed7','Armin','Syred',2058401208,'asyred15@berkeley.edu','8 Summit Hill'),
('2b3f57e2-ac79-44b8-ab35-4aa7ee0c9f30','Gerti','McNirlin',7546862531,'gmcnirlin16@sun.com','9926 Hallows Circle'),
('a4d439c1-3cbf-4381-87ec-3553ce2ff449','Christen','Romayne',4736418871,'cromayne17@topsy.com','3834 Hollow Ridge Alley'),
('9b86b1fb-9c14-41a6-bc20-efff310ece99','Atalanta','Whyley',4675370460,'awhyley18@toplist.cz','12 Maywood Parkway'),
('26cd4e3d-d6f2-4919-8714-f7a0b12ed48a','Blane','Christall',2806414642,'bchristall19@usnews.com','1160 Hovde Way'),
('970cec71-4200-4976-8ed1-71e29d830710','Aurel','Boow',5777197473,'aboow1a@upenn.edu','110 Mccormick Lane'),
('39e939c1-6c07-4c1f-a629-76006063c065','Britteny','Harbron',6965485747,'bharbron1b@wikia.com','12196 Randy Way'),
('86c2b67e-3f83-48dc-bda1-929987d0702a','Charla','Sigsworth',8932471872,'csigsworth1c@bbc.co.uk','2 Waywood Park'),
('887f96a7-e237-4fca-8c4b-8c632ed3a38a','Calla','Ferrillio',9835787858,'cferrillio1d@vkontakte.ru','6619 Nova Crossing'),
('41f6504b-7a59-4156-a81a-d6ea21aa7769','Judie','Dulin',3087779091,'jdulin1e@amazon.co.uk','9 Maryland Road'),
('99102c9c-9aed-437d-a348-0c685b71c269','Trescha','Astell',6063101763,'tastell1f@pen.io','03033 Claremont Drive'),
('630f3e29-846a-4d47-bcee-6b0af806e022','Barbe','Foulgham',2948122852,'bfoulgham1g@fastcompany.com','53099 Kedzie Junction'),
('d71daab8-e9bb-4bb5-a4d0-21de4471766c','Katti','McCrea',8238162870,'kmccrea1h@123-reg.co.uk','3 Susan Park'),
('e7096669-ac75-47e0-8c7c-b7312f08ccf3','Suzanna','Thorlby',2193932093,'sthorlby1i@mit.edu','8 Randy Hill'),
('6ca0b77e-df09-41d0-9e67-18bd5cb4ad18','Christen','Clemmitt',5936173427,'cclemmitt1j@un.org','15 Texas Hill'),
('9804bc51-fe1a-4d25-b913-1d742f8db2e5','Jorrie','Pifford',9658289041,'jpifford1k@admin.ch','129 Karstens Center'),
('524589c7-8af2-49e2-bfe9-ce75011b5a2f','Deanna','Gabits',3237128834,'dgabits1l@washingtonpost.com','6 Southridge Crossing'),
('fe00fe90-7ea5-4796-a2f0-13e97b109852','Baxy','Pydcock',8707181065,'bpydcock1m@themeforest.net','73198 Northview Road'),
('6b582fa6-4fd0-4a56-8347-f8b8b1042c6f','Aurthur','Harradine',7347140399,'aharradine1n@fema.gov','31422 Westport Place'),
('984854fa-8517-40d2-b808-b9f1443e32fb','Dulcinea','Rayer',4891333513,'drayer1o@delicious.com','41 Milwaukee Park'),
('24746a7a-2978-46a1-9860-379e75ea3df6','Ashia','Quillinane',1709788420,'aquillinane1p@cbslocal.com','66438 Muir Drive'),
('d47bd827-3b9c-4cd7-8fec-77898b1b0f26','Ly','McNab',7757580933,'lmcnab1q@foxnews.com','685 Eggendart Plaza'),
('5ecd65b9-d35d-47c4-84c6-3d33d87e2980','Xenos','Frankish',3376785644,'xfrankish1r@bbb.org','32139 Manley Crossing'),
('fbf08c6f-f614-4194-a0ef-b5c6e28505f8','Jillane','Laurenson',3421199937,'jlaurenson1s@rediff.com','59302 Mockingbird Court'),
('e2a418c4-d2b4-44f7-92c3-4ae7e5143c98','Netti','Lathey',8698056937,'nlathey1t@bloglovin.com','02363 Sommers Crossing'),
('5a3848d3-b59e-45b1-870e-0b9c3e682f1e','Dorelle','Waskett',8422645544,'dwaskett1u@ftc.gov','44 Glacier Hill Road'),
('45c81a74-2250-442a-a9b9-73e6129bdae0','Gardie','Mackleden',4573274408,'gmackleden1v@macromedia.com','69 Fieldstone Road'),
('53698d6a-f35e-4021-9597-4c37c75516ff','Anders','Dorro',6751778881,'adorro1w@columbia.edu','70 Gateway Point'),
('a7845143-8936-4a25-bf04-cfaa7b41e177','Dallas','Treat',1149168262,'dtreat1x@yelp.com','3509 Golden Leaf Hill'),
('7119e13c-9fa8-457c-b4d6-d2f9eca63536','Kelsey','McAneny',1987566486,'kmcaneny1y@weibo.com','8 Hoard Court'),
('c0477038-9837-4674-b881-6e19f192c082','Morie','Abdy',6188618031,'mabdy1z@ucoz.com','7 Hermina Lane'),
('b608f340-6e1e-4d2d-a8f9-ba24e222308f','Corty','Griswood',8463533652,'cgriswood20@biglobe.ne.jp','3 Mayfield Pass'),
('5285fdcc-ce38-420e-98bd-e4926e18adba','Gena','Dewhurst',8886471320,'gdewhurst21@squidoo.com','2 Crownhardt Road'),
('a032c5eb-6c83-46b9-8059-b471b0420843','Frederik','Buske',2387703496,'fbuske22@multiply.com','4146 Bunting Hill'),
('3543e2e4-e1a3-4046-b1ef-787fe1844db5','Reinaldos','Waggett',3684942652,'rwaggett23@drupal.org','503 Lyons Way'),
('054fa3f4-f097-4941-8d9b-91d238dd1781','Gracia','Segges',9639914644,'gsegges24@ca.gov','2683 Waxwing Road'),
('591d8bb1-5209-4abb-9e32-a9e96a94743c','Vinita','Lardge',1187667119,'vlardge25@spiegel.de','08748 Twin Pines Street'),
('c291f928-e836-4270-beb5-1fd33270ac97','Dulce','Haggath',1906120602,'dhaggath26@mac.com','23 Old Shore Trail'),
('a66a633d-9dd5-434d-b575-9a0ce72f81c2','Nerty','Lurcock',5725102027,'nlurcock27@cam.ac.uk','22057 Fairview Junction'),
('ae1f7798-8462-4c0e-a8c8-110c751717b8','Lind','Smewin',2568954456,'lsmewin28@seesaa.net','7 Packers Place'),
('2f8c635a-d014-493e-912e-c46eb7600501','Darci','Varran',3038626005,'dvarran29@virginia.edu','358 Spaight Junction'),
('6704604b-5cc7-4edc-930a-009eb2dc92bf','Henderson','Seabridge',4481058353,'hseabridge2a@prlog.org','849 Beilfuss Park'),
('42841a07-fb51-4c0f-8288-750ce6c46bc0','Pavlov','Fitzmaurice',3305219345,'pfitzmaurice2b@java.com','797 Daystar Place'),
('e6b11a66-ad24-4db5-a331-90d70ecaf522','Ginger','Wollaston',5126343590,'gwollaston2c@github.com','0 Harper Lane'),
('014c1a64-5339-4c5b-901e-c09821aef9db','Florenza','Aiers',8241631152,'faiers2d@redcross.org','81463 Meadow Vale Hill'),
('08ce310c-4827-444d-9689-3b7b350f6ee8','Carling','Rockey',9725905939,'crockey2e@hexun.com','3995 Westerfield Parkway'),
('acf6ca55-4a4f-4573-bd67-c4cd2d6dff93','Didi','Dell Casa',2947106084,'ddellcasa2f@abc.net.au','2892 Quincy Terrace'),
('3c14f2d3-6362-4088-b644-ce59b3595fb1','Ricky','Callow',1751556609,'rcallow2g@google.pl','231 Warrior Pass'),
('fa201bee-59a7-48b9-b5e1-9585aba4d0aa','Papagena','McCullogh',5323727264,'pmccullogh2h@google.ca','39 Kropf Junction'),
('c8166551-cbd8-40a1-a5b5-65351ac5b25d','Fair','Felgate',1465111709,'ffelgate2i@state.tx.us','18716 Thompson Hill'),
('644c1097-17b7-46f3-9733-84fd57be1017','Salmon','Chaucer',1537839132,'schaucer2j@craigslist.org','5640 Bobwhite Parkway'),
('557bdf6c-1920-486c-9a67-f5ce65bcf7bf','Drusie','Annear',1005039905,'dannear2k@istockphoto.com','3075 Novick Crossing'),
('62c9d3fb-7c87-498f-8571-3690d315b410','Joycelin','Woodings',7256991251,'jwoodings2l@omniture.com','99 Rutledge Circle'),
('dbf19229-2aeb-4e07-b6c7-6e6a0f5ccef8','Albie','Ostridge',1675203600,'aostridge2m@live.com','00 Almo Trail'),
('a809439d-ef80-482c-b533-201600dfc4fc','Gloria','Kenwyn',3306819227,'gkenwyn2n@tripod.com','2 Arizona Trail'),
('eda17527-15d8-43ae-95fd-1bc49a79741a','Dorena','Mulryan',5189535922,'dmulryan2o@noaa.gov','65 Lerdahl Crossing'),
('facc6c60-2653-4fe2-970f-827907bff0cf','Martin','Allsup',6965654128,'mallsup2p@hp.com','8691 Hermina Lane'),
('9e902910-a6d9-4019-910b-186e566d2848','Reynard','Deeming',8961918244,'rdeeming2q@dot.gov','9 Buhler Hill'),
('ca16e331-2c21-4c92-b504-55a14c3b8e76','Alden','Barkway',1433049793,'abarkway2r@gnu.org','8378 Gina Alley'),
('cee4ea6a-aacd-4814-9a7b-6c7d5fca3fe8','Roxane','O''Concannon',1655072956,'roconcannon2s@twitpic.com','325 Roxbury Crossing'),
('8b8665ef-2517-4ded-a80b-d5235b33a1f1','Shellie','Ferencz',4892737660,'sferencz2t@tuttocitta.it','40947 Porter Circle'),
('e17e2062-50a7-448a-91f9-31b4df3bffe6','Mirabelle','Nuzzetti',6892666732,'mnuzzetti2u@geocities.jp','82295 Clemons Park'),
('d9b01732-cb0c-43ed-9812-7be0aed68f58','Shurlocke','Purvey',9883509328,'spurvey2v@buzzfeed.com','03234 Macpherson Parkway'),
('bd1c3919-93ed-407b-8400-d0d27d9a1a7b','Blisse','Simonot',5825610536,'bsimonot2w@hao123.com','6 Reinke Alley'),
('2984281a-3ba1-4dbf-8ab5-04d6c9d985ca','Corliss','Fuster',3059602077,'cfuster2x@mlb.com','68127 Graedel Trail'),
('1f311594-8d5c-4483-9815-b7c1ce5b0b32','Danna','Loveland',8464904088,'dloveland2y@princeton.edu','977 Utah Parkway'),
('87e31564-d926-494b-b88c-e04dca50cb87','Jessika','Lumsdaine',7618985511,'jlumsdaine2z@ca.gov','57985 Manufacturers Way'),
('77b06662-5b51-44eb-afee-4eaad53b0553','Tine','Sculpher',9965791177,'tsculpher30@bravesites.com','4410 Miller Junction'),
('943c0b3d-bb59-44d4-a765-3562b0c8a793','Aryn','Pethick',1488904758,'apethick31@salon.com','9 Briar Crest Plaza'),
('8088c2ec-4d79-4b9a-9a4f-04fc1c1ee1ab','Marsha','Beminster',3537558104,'mbeminster32@redcross.org','4 Dryden Point'),
('1a25b456-948f-45fc-a2d6-7e630d0c5fba','Agnese','Ell',5095469570,'aell33@redcross.org','45903 Monterey Court'),
('a6d142de-86ec-4494-b367-d56258f41d26','Meade','Hainey',8499590400,'mhainey34@state.tx.us','7224 Nova Pass'),
('2da51285-9c7a-4c32-bbc0-9b70eb9565d8','Jacki','Nickell',2803629290,'jnickell35@hatena.ne.jp','699 Buhler Circle'),
('5269dd16-6354-4e1e-95e3-bc76e4ab478f','Merissa','Kinkaid',9247241928,'mkinkaid36@disqus.com','05 Chinook Avenue'),
('d5708e88-2fe9-4b5e-ad5b-2ea20e35f70e','Rahel','McCraw',2546507417,'rmccraw37@macromedia.com','34611 Sage Park'),
('39bd3a17-6575-40fb-9d55-7fb4a8133816','Lenette','Abrahami',4723355456,'labrahami38@shop-pro.jp','98107 Ridge Oak Point'),
('454b0de4-e463-4d59-97d2-7f2ba34eeb01','Taffy','Willmer',6746944503,'twillmer39@netlog.com','0 Arrowood Circle'),
('2994a497-8aee-4359-a7c5-6b2f97dc8712','Christel','Terrans',1126695610,'cterrans3a@dmoz.org','3303 Glendale Way'),
('aeef7f1c-f6cb-48cb-a134-e08a3f50063a','Barny','Lesley',9987618406,'blesley3b@issuu.com','98149 Brown Crossing'),
('04d998ea-24bb-4603-a940-d6913588ef72','Renato','Henze',6191444491,'rhenze3c@etsy.com','68949 Bobwhite Court'),
('6dfec61e-957b-4b4e-91a9-f44324bb8bf4','Meghan','Harner',1186973084,'mharner3d@oracle.com','202 Loeprich Park'),
('a3945b8b-62b8-4b4d-b3dd-5c7976b3bf06','Arleen','Mulkerrins',1249280543,'amulkerrins3e@tripod.com','19019 Sycamore Pass'),
('1199c17d-14ce-4fa3-95c4-19d99f02bfec','Casie','Ralestone',1675193701,'cralestone3f@jugem.jp','4333 Schurz Lane'),
('cb5b1caf-dd52-424d-91a1-45f346b05a60','Killy','Cornewell',9699210658,'kcornewell0@nps.gov','2547 Comanche Trail'),
('1eb72616-d65d-4403-a917-89d87e7833e1','Valaria','Gurner',4642635754,'vgurner1@tripod.com','42 Vahlen Lane'),
('1abe85d1-77df-43bf-9add-4e923927f0d7','Petronilla','Nolleth',6761474864,'pnolleth2@redcross.org','54 Ridge Oak Street'),
('e54c3a09-5e07-4142-a4a7-2021ecaee412','Carney','Snartt',7633325017,'csnartt3@behance.net','757 Coleman Point'),
('500c7525-e18d-429f-89c7-d3cf27bbe031','Ursala','Levings',1356598343,'ulevings4@live.com','2 Nobel Trail'),
('02f04748-8b8c-4809-8e90-9e6e4d23c0c6','Sullivan','Levens',6475296626,'slevens5@shareasale.com','792 Helena Drive'),
('c6730c43-619b-42c0-8102-87765c62e38a','Lonnard','Scotting',8544492015,'lscotting6@latimes.com','535 Holmberg Alley'),
('eb160790-8470-4a01-a40b-aff54cb357ad','Nefen','De Biasi',9077787944,'ndebiasi7@bigcartel.com','24 Darwin Circle'),
('a3557b0d-2236-4416-aa09-6e471243194e','Huntley','Kepp',8629394237,'hkepp8@nih.gov','98876 Fremont Drive'),
('cdfb8227-39bc-4625-bda5-9344c902c55a','Mitchael','Kohnen',8914824339,'mkohnen9@pen.io','8 Iowa Lane');


INSERT INTO Wasit VALUES
('a8ebf01a-89c9-4c70-bd8e-0ec4b7db46c5','REF3K5H2Y8P7F9R'),
('8baedc8b-254f-412d-a774-99e0a7e2fab5','RFR9G6E1D3P5B2J'),
('5a855e64-2aed-4574-baa6-13c6296995f2','LCR5V7N4F2C9Z6Q'),
('fb99e8af-6cc3-4e97-ab5f-10ef83a5ac08','RFR2M6T7J5L1C8D'),
('7abab725-ac56-4b2e-a917-da1890150483','LCR9N4J5Z1B2P9Q'),
('d071abd3-2a6f-438d-bf2f-c76db7295b61','REF7H5J3N8D6F2R'),
('29584fbb-a04f-4c7e-8460-8e5b3ed30c04','RFR1E9P8B4M6V5P'),
('764b0fe6-bbc3-4077-8be3-092908bbe4d8','LCR8C6B3Q2Z9F5K'),
('35418e19-0489-44d2-9b0c-4578e0f8e0a9','REF4P2T6D1K8V7G'),
('42414d4b-75ed-4073-b2a1-356d9516c407','RFR6J9N4C7V2L3H'),
('0eed62be-73ab-4690-999e-c8f4f3f3d5d7','LCR3K6H7G1N2Q9D'),
('32503599-4345-4654-bd21-b6b3dd1cc8bf','REF8F7V4T2H6J1N'),
('889577de-9896-4468-8c3c-d296f2163b09','RFR5G1M9V7T4B2C'),
('ebe0a3f6-ff57-43a7-b747-563d161a2614','LCR1D5J8F6N7V2P'),
('ebd6d18e-1198-464e-812b-7e0abaef1398','REF2Z9Q5H7F3G1M'),
('734e2f08-915a-48cb-bcae-0af0889187b4','RFR7B3K1L5N9Z6Q'),
('20e24a0f-3995-48c2-9a7d-ba3db75ed26e','LCR9F5G2C8V3J6H'),
('0eb68093-6dc0-42d2-92e2-886138889e66','REF6N2Z3P9Q1K5H'),
('dc91d00e-6702-4e56-8c32-2196ecf400b7','RFR4T8P6J1N2C7V'),
('bc420020-b2b8-4602-bad5-2639d6197e6e','LCR2H5J8D6N7B1K');

INSERT INTO Perlengkapan_Stadium VALUES ('64582552-d73b-45e9-a996-720f5d43b689','Bola',20),
	('8c731d67-57dd-47ff-b1a3-129566c658d5','Kostum tim',30),
	('074e3090-8de9-4cb2-bbc7-d9d3937ce14b','Kaus kaki',50),
	('6c3a9056-7954-4a80-a6f0-11af7238a33f','Bola',15),
	('97d7b485-03c6-4866-bcd4-80207534e219','Kostum wasit',5),
	('afdd7273-5311-4aed-ba2f-18c44c7f1733','Cone',20),
	('f0b479c1-86f1-4958-b51d-15128cdd2cb6','Kostum tim',25),
	('99e5ea80-ab39-4d89-a47d-3e3cf6e5de88','Bola',15),
	('88b98df2-784c-48cb-90c7-17378dd51248','Kaus kaki',40),
	('348bc921-c74d-4d6c-8d75-cfdedc218556','Kostum wasit',5),
	('64582552-d73b-45e9-a996-720f5d43b689','Cone',15),
	('8c731d67-57dd-47ff-b1a3-129566c658d5','Pita pengaman',30),
	('074e3090-8de9-4cb2-bbc7-d9d3937ce14b','Bola',20),
	('6c3a9056-7954-4a80-a6f0-11af7238a33f','Kostum tim',30),
	('97d7b485-03c6-4866-bcd4-80207534e219','Pita pengaman',25),
	('afdd7273-5311-4aed-ba2f-18c44c7f1733','Kaus kaki',50),
	('f0b479c1-86f1-4958-b51d-15128cdd2cb6','Cone',20),
	('99e5ea80-ab39-4d89-a47d-3e3cf6e5de88','Pita pengaman',30),
	('88b98df2-784c-48cb-90c7-17378dd51248','Kaus kaki',35),
	('348bc921-c74d-4d6c-8d75-cfdedc218556','Bola',10);


INSERT INTO Pelatih VALUES
('7119e13c-9fa8-457c-b4d6-d2f9eca63536','VelocityMax Elite'),
('c0477038-9837-4674-b881-6e19f192c082','Man Untitled'),
('b608f340-6e1e-4d2d-a8f9-ba24e222308f','HyperDrive X'),
('5285fdcc-ce38-420e-98bd-e4926e18adba','PowerShot Prime'),
('a032c5eb-6c83-46b9-8059-b471b0420843','Ac Milan'),
('3543e2e4-e1a3-4046-b1ef-787fe1844db5','HyperDrive Y'),
('054fa3f4-f097-4941-8d9b-91d238dd1781','HyperDrive Z'),
('591d8bb1-5209-4abb-9e32-a9e96a94743c','Sapi Go'),
('c291f928-e836-4270-beb5-1fd33270ac97','ProdigyStrike Pro'),
('a66a633d-9dd5-434d-b575-9a0ce72f81c2','Real Betis'),
('ae1f7798-8462-4c0e-a8c8-110c751717b8','VelocityMax Elite'),
('2f8c635a-d014-493e-912e-c46eb7600501','Man Untitled'),
('6704604b-5cc7-4edc-930a-009eb2dc92bf','HyperDrive X'),
('42841a07-fb51-4c0f-8288-750ce6c46bc0','PowerShot Prime'),
('e6b11a66-ad24-4db5-a331-90d70ecaf522','Ac Milan'),
('014c1a64-5339-4c5b-901e-c09821aef9db','HyperDrive Y'),
('08ce310c-4827-444d-9689-3b7b350f6ee8','HyperDrive Z'),
('acf6ca55-4a4f-4573-bd67-c4cd2d6dff93','Sapi Go'),
('3c14f2d3-6362-4088-b644-ce59b3595fb1','ProdigyStrike Pro'),
('fa201bee-59a7-48b9-b5e1-9585aba4d0aa','Real Betis'),
('c8166551-cbd8-40a1-a5b5-65351ac5b25d',NULL),
('644c1097-17b7-46f3-9733-84fd57be1017',NULL),
('557bdf6c-1920-486c-9a67-f5ce65bcf7bf',NULL),
('62c9d3fb-7c87-498f-8571-3690d315b410',NULL),
('dbf19229-2aeb-4e07-b6c7-6e6a0f5ccef8',NULL),
('a809439d-ef80-482c-b533-201600dfc4fc',NULL),
('eda17527-15d8-43ae-95fd-1bc49a79741a',NULL),
('facc6c60-2653-4fe2-970f-827907bff0cf',NULL),
('9e902910-a6d9-4019-910b-186e566d2848',NULL),
('ca16e331-2c21-4c92-b504-55a14c3b8e76',NULL),
('cee4ea6a-aacd-4814-9a7b-6c7d5fca3fe8',NULL),
('8b8665ef-2517-4ded-a80b-d5235b33a1f1',NULL),
('e17e2062-50a7-448a-91f9-31b4df3bffe6',NULL),
('d9b01732-cb0c-43ed-9812-7be0aed68f58',NULL),
('bd1c3919-93ed-407b-8400-d0d27d9a1a7b',NULL),
('2984281a-3ba1-4dbf-8ab5-04d6c9d985ca',NULL),
('1f311594-8d5c-4483-9815-b7c1ce5b0b32',NULL),
('87e31564-d926-494b-b88c-e04dca50cb87',NULL),
('77b06662-5b51-44eb-afee-4eaad53b0553',NULL),
('943c0b3d-bb59-44d4-a765-3562b0c8a793',NULL),
('8088c2ec-4d79-4b9a-9a4f-04fc1c1ee1ab',NULL),
('1a25b456-948f-45fc-a2d6-7e630d0c5fba',NULL),
('a6d142de-86ec-4494-b367-d56258f41d26',NULL),
('2da51285-9c7a-4c32-bbc0-9b70eb9565d8',NULL),
('5269dd16-6354-4e1e-95e3-bc76e4ab478f',NULL),
('d5708e88-2fe9-4b5e-ad5b-2ea20e35f70e',NULL),
('39bd3a17-6575-40fb-9d55-7fb4a8133816',NULL),
('454b0de4-e463-4d59-97d2-7f2ba34eeb01',NULL),
('2994a497-8aee-4359-a7c5-6b2f97dc8712',NULL),
('aeef7f1c-f6cb-48cb-a134-e08a3f50063a',NULL),
('04d998ea-24bb-4603-a940-d6913588ef72',NULL),
('6dfec61e-957b-4b4e-91a9-f44324bb8bf4',NULL),
('a3945b8b-62b8-4b4d-b3dd-5c7976b3bf06',NULL),
('1199c17d-14ce-4fa3-95c4-19d99f02bfec',NULL),
('cb5b1caf-dd52-424d-91a1-45f346b05a60',NULL),
('1eb72616-d65d-4403-a917-89d87e7833e1',NULL),
('1abe85d1-77df-43bf-9add-4e923927f0d7',NULL),
('e54c3a09-5e07-4142-a4a7-2021ecaee412',NULL),
('500c7525-e18d-429f-89c7-d3cf27bbe031',NULL),
('02f04748-8b8c-4809-8e90-9e6e4d23c0c6',NULL),
('c6730c43-619b-42c0-8102-87765c62e38a',NULL),
('eb160790-8470-4a01-a40b-aff54cb357ad',NULL),
('a3557b0d-2236-4416-aa09-6e471243194e',NULL),
('cdfb8227-39bc-4625-bda5-9344c902c55a',NULL);

INSERT INTO Status_Non_Pemain VALUES
('a8ebf01a-89c9-4c70-bd8e-0ec4b7db46c5','Dosen'),
('8baedc8b-254f-412d-a774-99e0a7e2fab5','Dosen'),
('5a855e64-2aed-4574-baa6-13c6296995f2','Alumni'),
('fb99e8af-6cc3-4e97-ab5f-10ef83a5ac08','Dosen'),
('7abab725-ac56-4b2e-a917-da1890150483','Tenaga didik'),
('d071abd3-2a6f-438d-bf2f-c76db7295b61','Tenaga didik'),
('29584fbb-a04f-4c7e-8460-8e5b3ed30c04','Mahasiswa'),
('764b0fe6-bbc3-4077-8be3-092908bbe4d8','Tenaga didik'),
('35418e19-0489-44d2-9b0c-4578e0f8e0a9','Alumni'),
('42414d4b-75ed-4073-b2a1-356d9516c407','Alumni'),
('0eed62be-73ab-4690-999e-c8f4f3f3d5d7','Mahasiswa'),
('32503599-4345-4654-bd21-b6b3dd1cc8bf','Dosen'),
('889577de-9896-4468-8c3c-d296f2163b09','Alumni'),
('ebe0a3f6-ff57-43a7-b747-563d161a2614','Dosen'),
('ebd6d18e-1198-464e-812b-7e0abaef1398','Dosen'),
('734e2f08-915a-48cb-bcae-0af0889187b4','Mahasiswa'),
('20e24a0f-3995-48c2-9a7d-ba3db75ed26e','Umum'),
('0eb68093-6dc0-42d2-92e2-886138889e66','Tenaga didik'),
('dc91d00e-6702-4e56-8c32-2196ecf400b7','Alumni'),
('bc420020-b2b8-4602-bad5-2639d6197e6e','Dosen'),
('4125894c-30b7-4573-bdf2-0010383b9dde','Umum'),
('7fa78084-62ec-438e-9fc9-6688ac974f6b','Dosen'),
('783dfa30-50c7-4cda-87cb-783a2db041c0','Umum'),
('52470659-dab4-438c-a4d4-dd6b83ea4ed3','Tenaga didik'),
('95c88ed0-928d-4915-ac17-00ef7ebd10ed','Mahasiswa'),
('cdc4af22-d220-49a4-a666-864fdd1e9390','Mahasiswa'),
('7e4f33b1-e5cf-4497-81f3-52f15b7afcac','Mahasiswa'),
('20c9ac05-204b-49e5-85a2-b72444c3618d','Umum'),
('725f7c98-255f-470c-9b41-44d0073c8c25','Dosen'),
('d182a8bc-46da-499d-b3ee-793d18fe782b','Alumni'),
('cce8d12f-3154-4c61-8218-60e859594f7d','Dosen'),
('2268ac77-6d84-4a04-8bfc-4a689110e0a5','Tenaga didik'),
('ac2c5d33-3255-4e3a-8ad3-0afabf5ba498','Mahasiswa'),
('400e45bf-4222-4470-9991-540cd632f2e5','Dosen'),
('2c56d64f-418d-4bf6-a5c3-fd43a8ee193d','Alumni'),
('930a63ad-9e44-4780-83da-6bd146ebbd6b','Mahasiswa'),
('15d068a6-d9ee-4f93-941f-1a0419d42b62','Tenaga didik'),
('654fb47a-ea13-45c9-9cde-778cd0fba489','Mahasiswa'),
('a2908651-66f0-44c9-8e37-e5165b5619f6','Tenaga didik'),
('a0b4eced-8df8-44f6-aac6-2a74c1adc1f1','Mahasiswa'),
('a3393b61-d377-4f18-a2ce-6718020f142d','Mahasiswa'),
('3ca2d5c5-8ce0-4879-bcb4-526a12c03ed7','Tenaga didik'),
('2b3f57e2-ac79-44b8-ab35-4aa7ee0c9f30','Umum'),
('a4d439c1-3cbf-4381-87ec-3553ce2ff449','Alumni'),
('9b86b1fb-9c14-41a6-bc20-efff310ece99','Tenaga didik'),
('26cd4e3d-d6f2-4919-8714-f7a0b12ed48a','Alumni'),
('970cec71-4200-4976-8ed1-71e29d830710','Umum'),
('39e939c1-6c07-4c1f-a629-76006063c065','Tenaga didik'),
('86c2b67e-3f83-48dc-bda1-929987d0702a','Mahasiswa'),
('887f96a7-e237-4fca-8c4b-8c632ed3a38a','Dosen'),
('41f6504b-7a59-4156-a81a-d6ea21aa7769','Mahasiswa'),
('99102c9c-9aed-437d-a348-0c685b71c269','Tenaga didik'),
('630f3e29-846a-4d47-bcee-6b0af806e022','Umum'),
('d71daab8-e9bb-4bb5-a4d0-21de4471766c','Umum'),
('e7096669-ac75-47e0-8c7c-b7312f08ccf3','Umum'),
('6ca0b77e-df09-41d0-9e67-18bd5cb4ad18','Umum'),
('9804bc51-fe1a-4d25-b913-1d742f8db2e5','Alumni'),
('524589c7-8af2-49e2-bfe9-ce75011b5a2f','Dosen'),
('fe00fe90-7ea5-4796-a2f0-13e97b109852','Mahasiswa'),
('6b582fa6-4fd0-4a56-8347-f8b8b1042c6f','Tenaga didik'),
('984854fa-8517-40d2-b808-b9f1443e32fb','Umum'),
('24746a7a-2978-46a1-9860-379e75ea3df6','Tenaga didik'),
('d47bd827-3b9c-4cd7-8fec-77898b1b0f26','Mahasiswa'),
('5ecd65b9-d35d-47c4-84c6-3d33d87e2980','Tenaga didik'),
('fbf08c6f-f614-4194-a0ef-b5c6e28505f8','Umum'),
('e2a418c4-d2b4-44f7-92c3-4ae7e5143c98','Tenaga didik'),
('5a3848d3-b59e-45b1-870e-0b9c3e682f1e','Umum'),
('45c81a74-2250-442a-a9b9-73e6129bdae0','Umum'),
('53698d6a-f35e-4021-9597-4c37c75516ff','Alumni'),
('a7845143-8936-4a25-bf04-cfaa7b41e177','Umum'),
('7119e13c-9fa8-457c-b4d6-d2f9eca63536','Dosen'),
('c0477038-9837-4674-b881-6e19f192c082','Dosen'),
('b608f340-6e1e-4d2d-a8f9-ba24e222308f','Umum'),
('5285fdcc-ce38-420e-98bd-e4926e18adba','Mahasiswa'),
('a032c5eb-6c83-46b9-8059-b471b0420843','Umum'),
('3543e2e4-e1a3-4046-b1ef-787fe1844db5','Alumni'),
('054fa3f4-f097-4941-8d9b-91d238dd1781','Dosen'),
('591d8bb1-5209-4abb-9e32-a9e96a94743c','Alumni'),
('c291f928-e836-4270-beb5-1fd33270ac97','Mahasiswa'),
('a66a633d-9dd5-434d-b575-9a0ce72f81c2','Umum'),
('ae1f7798-8462-4c0e-a8c8-110c751717b8','Dosen'),
('2f8c635a-d014-493e-912e-c46eb7600501','Dosen'),
('6704604b-5cc7-4edc-930a-009eb2dc92bf','Dosen'),
('42841a07-fb51-4c0f-8288-750ce6c46bc0','Umum'),
('e6b11a66-ad24-4db5-a331-90d70ecaf522','Alumni'),
('014c1a64-5339-4c5b-901e-c09821aef9db','Alumni'),
('08ce310c-4827-444d-9689-3b7b350f6ee8','Tenaga didik'),
('acf6ca55-4a4f-4573-bd67-c4cd2d6dff93','Alumni'),
('3c14f2d3-6362-4088-b644-ce59b3595fb1','Mahasiswa'),
('fa201bee-59a7-48b9-b5e1-9585aba4d0aa','Alumni'),
('c8166551-cbd8-40a1-a5b5-65351ac5b25d','Umum'),
('644c1097-17b7-46f3-9733-84fd57be1017','Mahasiswa'),
('557bdf6c-1920-486c-9a67-f5ce65bcf7bf','Alumni'),
('62c9d3fb-7c87-498f-8571-3690d315b410','Mahasiswa'),
('dbf19229-2aeb-4e07-b6c7-6e6a0f5ccef8','Tenaga didik'),
('a809439d-ef80-482c-b533-201600dfc4fc','Dosen'),
('eda17527-15d8-43ae-95fd-1bc49a79741a','Umum'),
('facc6c60-2653-4fe2-970f-827907bff0cf','Tenaga didik'),
('9e902910-a6d9-4019-910b-186e566d2848','Tenaga didik'),
('ca16e331-2c21-4c92-b504-55a14c3b8e76','Alumni'),
('cee4ea6a-aacd-4814-9a7b-6c7d5fca3fe8','Dosen'),
('8b8665ef-2517-4ded-a80b-d5235b33a1f1','Umum'),
('e17e2062-50a7-448a-91f9-31b4df3bffe6','Mahasiswa'),
('d9b01732-cb0c-43ed-9812-7be0aed68f58','Alumni'),
('bd1c3919-93ed-407b-8400-d0d27d9a1a7b','Mahasiswa'),
('2984281a-3ba1-4dbf-8ab5-04d6c9d985ca','Umum'),
('1f311594-8d5c-4483-9815-b7c1ce5b0b32','Alumni'),
('87e31564-d926-494b-b88c-e04dca50cb87','Mahasiswa'),
('77b06662-5b51-44eb-afee-4eaad53b0553','Umum'),
('943c0b3d-bb59-44d4-a765-3562b0c8a793','Tenaga didik'),
('8088c2ec-4d79-4b9a-9a4f-04fc1c1ee1ab','Mahasiswa'),
('1a25b456-948f-45fc-a2d6-7e630d0c5fba','Tenaga didik'),
('a6d142de-86ec-4494-b367-d56258f41d26','Umum'),
('2da51285-9c7a-4c32-bbc0-9b70eb9565d8','Dosen'),
('5269dd16-6354-4e1e-95e3-bc76e4ab478f','Dosen'),
('d5708e88-2fe9-4b5e-ad5b-2ea20e35f70e','Alumni'),
('39bd3a17-6575-40fb-9d55-7fb4a8133816','Umum'),
('454b0de4-e463-4d59-97d2-7f2ba34eeb01','Tenaga didik'),
('2994a497-8aee-4359-a7c5-6b2f97dc8712','Tenaga didik'),
('aeef7f1c-f6cb-48cb-a134-e08a3f50063a','Alumni'),
('04d998ea-24bb-4603-a940-d6913588ef72','Dosen'),
('6dfec61e-957b-4b4e-91a9-f44324bb8bf4','Tenaga didik'),
('a3945b8b-62b8-4b4d-b3dd-5c7976b3bf06','Dosen'),
('1199c17d-14ce-4fa3-95c4-19d99f02bfec','Dosen'),
('cb5b1caf-dd52-424d-91a1-45f346b05a60','Mahasiswa'),
('1eb72616-d65d-4403-a917-89d87e7833e1','Alumni'),
('1abe85d1-77df-43bf-9add-4e923927f0d7','Alumni'),
('e54c3a09-5e07-4142-a4a7-2021ecaee412','Tenaga didik'),
('500c7525-e18d-429f-89c7-d3cf27bbe031','Tenaga didik'),
('02f04748-8b8c-4809-8e90-9e6e4d23c0c6','Mahasiswa'),
('c6730c43-619b-42c0-8102-87765c62e38a','Dosen'),
('eb160790-8470-4a01-a40b-aff54cb357ad','Dosen'),
('a3557b0d-2236-4416-aa09-6e471243194e','Alumni'),
('cdfb8227-39bc-4625-bda5-9344c902c55a','Umum');


INSERT INTO Pertandingan VALUES ('9d0f6d47-ba24-4b11-a8a1-6811c55b6bc2','2023-06-05 15:00:00','2023-06-05 17:00:00','074e3090-8de9-4cb2-bbc7-d9d3937ce14b'),
	('551fc7a2-727d-44e9-9ce9-cd3e9421eb23','2023-06-11 18:30:00','2023-06-11 20:30:00','6c3a9056-7954-4a80-a6f0-11af7238a33f'),
	('7a820b29-1091-4c33-bc2b-f9c91270cbe5','2023-06-17 12:45:00','2023-06-17 14:45:00','97d7b485-03c6-4866-bcd4-80207534e219'),
	('63f365c5-8f0e-4ec3-b7b3-88e56ac7c34e','2023-06-24 16:00:00','2023-06-24 18:00:00','afdd7273-5311-4aed-ba2f-18c44c7f1733'),
	('3fbb569e-f794-4378-84c3-4abf9074b4d4','2023-06-30 20:15:00','2023-06-30 22:15:00','f0b479c1-86f1-4958-b51d-15128cdd2cb6');

INSERT INTO Wasit_Bertugas VALUES
('a8ebf01a-89c9-4c70-bd8e-0ec4b7db46c5','9d0f6d47-ba24-4b11-a8a1-6811c55b6bc2','Center Referee'),
('8baedc8b-254f-412d-a774-99e0a7e2fab5','551fc7a2-727d-44e9-9ce9-cd3e9421eb23','Assistant Referee 1'),
('5a855e64-2aed-4574-baa6-13c6296995f2','7a820b29-1091-4c33-bc2b-f9c91270cbe5','Assistant Referee 2'),
('fb99e8af-6cc3-4e97-ab5f-10ef83a5ac08','63f365c5-8f0e-4ec3-b7b3-88e56ac7c34e','Fourth Official'),
('7abab725-ac56-4b2e-a917-da1890150483','3fbb569e-f794-4378-84c3-4abf9074b4d4','Video Assistant Referee (VAR)'),
('d071abd3-2a6f-438d-bf2f-c76db7295b61','9d0f6d47-ba24-4b11-a8a1-6811c55b6bc2','Assistant VAR 1'),
('29584fbb-a04f-4c7e-8460-8e5b3ed30c04','551fc7a2-727d-44e9-9ce9-cd3e9421eb23','Assistant VAR 2'),
('764b0fe6-bbc3-4077-8be3-092908bbe4d8','7a820b29-1091-4c33-bc2b-f9c91270cbe5','Referee Observer'),
('35418e19-0489-44d2-9b0c-4578e0f8e0a9','63f365c5-8f0e-4ec3-b7b3-88e56ac7c34e','Referee Assessor'),
('42414d4b-75ed-4073-b2a1-356d9516c407','3fbb569e-f794-4378-84c3-4abf9074b4d4','Referee Coach');


INSERT INTO Penonton VALUES
('4125894c-30b7-4573-bdf2-0010383b9dde','rgwalteru'),
('7fa78084-62ec-438e-9fc9-6688ac974f6b','rfrankv'),
('783dfa30-50c7-4cda-87cb-783a2db041c0','achicchelliw'),
('52470659-dab4-438c-a4d4-dd6b83ea4ed3','ijedraszczykx'),
('95c88ed0-928d-4915-ac17-00ef7ebd10ed','fmougely'),
('cdc4af22-d220-49a4-a666-864fdd1e9390','galldisz'),
('7e4f33b1-e5cf-4497-81f3-52f15b7afcac','ofyers10'),
('20c9ac05-204b-49e5-85a2-b72444c3618d','tsimpole11'),
('725f7c98-255f-470c-9b41-44d0073c8c25','gstrond12'),
('d182a8bc-46da-499d-b3ee-793d18fe782b','atearney13'),
('cce8d12f-3154-4c61-8218-60e859594f7d','rlimpenny14'),
('2268ac77-6d84-4a04-8bfc-4a689110e0a5','momar15'),
('ac2c5d33-3255-4e3a-8ad3-0afabf5ba498','jsivyer16'),
('400e45bf-4222-4470-9991-540cd632f2e5','uibell17'),
('2c56d64f-418d-4bf6-a5c3-fd43a8ee193d','npitway18'),
('930a63ad-9e44-4780-83da-6bd146ebbd6b','candrieux19'),
('15d068a6-d9ee-4f93-941f-1a0419d42b62','rbloschke1a'),
('654fb47a-ea13-45c9-9cde-778cd0fba489','rnyssens1b'),
('a2908651-66f0-44c9-8e37-e5165b5619f6','fgraybeal1c'),
('a0b4eced-8df8-44f6-aac6-2a74c1adc1f1','bhedon1d');    

INSERT INTO Pembelian_Tiket VALUES
('R0001','4125894c-30b7-4573-bdf2-0010383b9dde','VIP','Paypal','9d0f6d47-ba24-4b11-a8a1-6811c55b6bc2'),
('R0002','7fa78084-62ec-438e-9fc9-6688ac974f6b','Main East','Shopee Pay','551fc7a2-727d-44e9-9ce9-cd3e9421eb23'),
('R0003','783dfa30-50c7-4cda-87cb-783a2db041c0','Kategori 1','Gopay','7a820b29-1091-4c33-bc2b-f9c91270cbe5'),
('R0004','52470659-dab4-438c-a4d4-dd6b83ea4ed3','Kategori 2','Transfer Rekening','63f365c5-8f0e-4ec3-b7b3-88e56ac7c34e'),
('R0005','95c88ed0-928d-4915-ac17-00ef7ebd10ed','VIP','Debit Rekening','3fbb569e-f794-4378-84c3-4abf9074b4d4');


INSERT INTO Panitia VALUES
('a3393b61-d377-4f18-a2ce-6718020f142d','Koordinator Konsumsi','fblesdilla'),
('3ca2d5c5-8ce0-4879-bcb4-526a12c03ed7','Koordinator Lapangan','sdiggesb'),
('2b3f57e2-ac79-44b8-ab35-4aa7ee0c9f30','Wakil Ketua Panitia','osalandinoc'),
('a4d439c1-3cbf-4381-87ec-3553ce2ff449','Ketua Panitia','gitzhakd'),
('9b86b1fb-9c14-41a6-bc20-efff310ece99','Koordinator Lapangan','felcee'),
('26cd4e3d-d6f2-4919-8714-f7a0b12ed48a','Koordinator Konsumsi','anorthcottf'),
('970cec71-4200-4976-8ed1-71e29d830710','Bendahara','rgallehawkg'),
('39e939c1-6c07-4c1f-a629-76006063c065','Wakil Ketua Panitia','cmacknockerh'),
('86c2b67e-3f83-48dc-bda1-929987d0702a','Koordinator Perlengkapan','alingeri'),
('887f96a7-e237-4fca-8c4b-8c632ed3a38a','Koordinator Konsumsi','tmcchruiterj'),
('41f6504b-7a59-4156-a81a-d6ea21aa7769','Sekretaris','mtomsak'),
('99102c9c-9aed-437d-a348-0c685b71c269','Koordinator Lapangan','vberefordl'),
('630f3e29-846a-4d47-bcee-6b0af806e022','Koordinator Lapangan','eriseamm'),
('d71daab8-e9bb-4bb5-a4d0-21de4471766c','Sekretaris','klangshawn'),
('e7096669-ac75-47e0-8c7c-b7312f08ccf3','Koordinator Lapangan','mlileo'),
('6ca0b77e-df09-41d0-9e67-18bd5cb4ad18','Koordinator Konsumsi','kmurrowp'),
('9804bc51-fe1a-4d25-b913-1d742f8db2e5','Koordinator Konsumsi','gshrigleyq'),
('524589c7-8af2-49e2-bfe9-ce75011b5a2f','Bendahara','emcquarterr'),
('fe00fe90-7ea5-4796-a2f0-13e97b109852','Koordinator Perlengkapan','sclaraes'),
('6b582fa6-4fd0-4a56-8347-f8b8b1042c6f','Sekretaris','mfawket');


INSERT INTO Spesialisasi_Pelatih VALUES
('7119e13c-9fa8-457c-b4d6-d2f9eca63536','tendangan'),
('c0477038-9837-4674-b881-6e19f192c082','tendangan'),
('c0477038-9837-4674-b881-6e19f192c082','serangan'),
('b608f340-6e1e-4d2d-a8f9-ba24e222308f','serangan'),
('5285fdcc-ce38-420e-98bd-e4926e18adba','sundulan'),
('a032c5eb-6c83-46b9-8059-b471b0420843','tendangan'),
('3543e2e4-e1a3-4046-b1ef-787fe1844db5','serangan'),
('054fa3f4-f097-4941-8d9b-91d238dd1781','tendangan'),
('591d8bb1-5209-4abb-9e32-a9e96a94743c','pertahanan'),
('591d8bb1-5209-4abb-9e32-a9e96a94743c','sundulan'),
('c291f928-e836-4270-beb5-1fd33270ac97','tangkapan'),
('a66a633d-9dd5-434d-b575-9a0ce72f81c2','tendangan'),
('ae1f7798-8462-4c0e-a8c8-110c751717b8','pertahanan'),
('2f8c635a-d014-493e-912e-c46eb7600501','tangkapan'),
('6704604b-5cc7-4edc-930a-009eb2dc92bf','pertahanan'),
('42841a07-fb51-4c0f-8288-750ce6c46bc0','sundulan'),
('e6b11a66-ad24-4db5-a331-90d70ecaf522','sundulan'),
('014c1a64-5339-4c5b-901e-c09821aef9db','sundulan'),
('014c1a64-5339-4c5b-901e-c09821aef9db','pertahanan'),
('08ce310c-4827-444d-9689-3b7b350f6ee8','sundulan'),
('acf6ca55-4a4f-4573-bd67-c4cd2d6dff93','tendangan'),
('3c14f2d3-6362-4088-b644-ce59b3595fb1','tendangan'),
('3c14f2d3-6362-4088-b644-ce59b3595fb1','tangkapan'),
('fa201bee-59a7-48b9-b5e1-9585aba4d0aa','tendangan'),
('c8166551-cbd8-40a1-a5b5-65351ac5b25d','sundulan'),
('644c1097-17b7-46f3-9733-84fd57be1017','serangan'),
('557bdf6c-1920-486c-9a67-f5ce65bcf7bf','serangan'),
('62c9d3fb-7c87-498f-8571-3690d315b410','sundulan'),
('62c9d3fb-7c87-498f-8571-3690d315b410','pertahanan'),
('dbf19229-2aeb-4e07-b6c7-6e6a0f5ccef8','sundulan'),
('a809439d-ef80-482c-b533-201600dfc4fc','tendangan'),
('eda17527-15d8-43ae-95fd-1bc49a79741a','pertahanan'),
('facc6c60-2653-4fe2-970f-827907bff0cf','pertahanan'),
('9e902910-a6d9-4019-910b-186e566d2848','pertahanan'),
('9e902910-a6d9-4019-910b-186e566d2848','tendangan'),
('ca16e331-2c21-4c92-b504-55a14c3b8e76','pertahanan'),
('cee4ea6a-aacd-4814-9a7b-6c7d5fca3fe8','tangkapan'),
('8b8665ef-2517-4ded-a80b-d5235b33a1f1','serangan'),
('e17e2062-50a7-448a-91f9-31b4df3bffe6','serangan'),
('d9b01732-cb0c-43ed-9812-7be0aed68f58','serangan'),
('bd1c3919-93ed-407b-8400-d0d27d9a1a7b','sundulan'),
('2984281a-3ba1-4dbf-8ab5-04d6c9d985ca','tendangan'),
('1f311594-8d5c-4483-9815-b7c1ce5b0b32','tendangan'),
('87e31564-d926-494b-b88c-e04dca50cb87','tangkapan'),
('77b06662-5b51-44eb-afee-4eaad53b0553','tangkapan'),
('943c0b3d-bb59-44d4-a765-3562b0c8a793','serangan'),
('8088c2ec-4d79-4b9a-9a4f-04fc1c1ee1ab','sundulan'),
('1a25b456-948f-45fc-a2d6-7e630d0c5fba','tendangan'),
('a6d142de-86ec-4494-b367-d56258f41d26','serangan'),
('2da51285-9c7a-4c32-bbc0-9b70eb9565d8','serangan'),
('5269dd16-6354-4e1e-95e3-bc76e4ab478f','pertahanan'),
('d5708e88-2fe9-4b5e-ad5b-2ea20e35f70e','tendangan'),
('39bd3a17-6575-40fb-9d55-7fb4a8133816','serangan'),
('454b0de4-e463-4d59-97d2-7f2ba34eeb01','tendangan'),
('2994a497-8aee-4359-a7c5-6b2f97dc8712','tangkapan'),
('aeef7f1c-f6cb-48cb-a134-e08a3f50063a','sundulan'),
('04d998ea-24bb-4603-a940-d6913588ef72','pertahanan'),
('6dfec61e-957b-4b4e-91a9-f44324bb8bf4','tendangan'),
('a3945b8b-62b8-4b4d-b3dd-5c7976b3bf06','tangkapan'),
('1199c17d-14ce-4fa3-95c4-19d99f02bfec','tangkapan'),
('cb5b1caf-dd52-424d-91a1-45f346b05a60','sundulan'),
('1eb72616-d65d-4403-a917-89d87e7833e1','pertahanan'),
('1abe85d1-77df-43bf-9add-4e923927f0d7','pertahanan'),
('e54c3a09-5e07-4142-a4a7-2021ecaee412','serangan'),
('500c7525-e18d-429f-89c7-d3cf27bbe031','serangan'),
('02f04748-8b8c-4809-8e90-9e6e4d23c0c6','pertahanan'),
('c6730c43-619b-42c0-8102-87765c62e38a','tangkapan'),
('eb160790-8470-4a01-a40b-aff54cb357ad','tendangan'),
('a3557b0d-2236-4416-aa09-6e471243194e','sundulan'),
('cdfb8227-39bc-4625-bda5-9344c902c55a','serangan');

INSERT INTO Tim_Pertandingan VALUES ('VelocityMax Elite','9d0f6d47-ba24-4b11-a8a1-6811c55b6bc2',4),
	('Man Untitled','551fc7a2-727d-44e9-9ce9-cd3e9421eb23',1),
	('HyperDrive X','7a820b29-1091-4c33-bc2b-f9c91270cbe5',3),
	('PowerShot Prime','63f365c5-8f0e-4ec3-b7b3-88e56ac7c34e',3),
	('Ac Milan','3fbb569e-f794-4378-84c3-4abf9074b4d4',4),
	('HyperDrive Y','9d0f6d47-ba24-4b11-a8a1-6811c55b6bc2',2),
	('HyperDrive Z','551fc7a2-727d-44e9-9ce9-cd3e9421eb23',4),
	('Sapi Go','7a820b29-1091-4c33-bc2b-f9c91270cbe5',1),
	('ProdigyStrike Pro','63f365c5-8f0e-4ec3-b7b3-88e56ac7c34e',3),
	('Real Betis','3fbb569e-f794-4378-84c3-4abf9074b4d4',3);


INSERT INTO Manajer VALUES ('984854fa-8517-40d2-b808-b9f1443e32fb','nportam0'),
	('24746a7a-2978-46a1-9860-379e75ea3df6','msharrocks1'),
	('d47bd827-3b9c-4cd7-8fec-77898b1b0f26','gholdey2'),
	('5ecd65b9-d35d-47c4-84c6-3d33d87e2980','jslatter3'),
	('fbf08c6f-f614-4194-a0ef-b5c6e28505f8','ibresner4'),
	('e2a418c4-d2b4-44f7-92c3-4ae7e5143c98','ajumonet5'),
	('5a3848d3-b59e-45b1-870e-0b9c3e682f1e','comahony6'),
	('45c81a74-2250-442a-a9b9-73e6129bdae0','zgeering7'),
	('53698d6a-f35e-4021-9597-4c37c75516ff','lgrigorey8'),
	('a7845143-8936-4a25-bf04-cfaa7b41e177','bainscough9');


INSERT INTO Tim_Manajer VALUES ('984854fa-8517-40d2-b808-b9f1443e32fb','VelocityMax Elite'),
	('24746a7a-2978-46a1-9860-379e75ea3df6','Man Untitled'),
	('d47bd827-3b9c-4cd7-8fec-77898b1b0f26','HyperDrive X'),
	('5ecd65b9-d35d-47c4-84c6-3d33d87e2980','PowerShot Prime'),
	('fbf08c6f-f614-4194-a0ef-b5c6e28505f8','Ac Milan'),
	('e2a418c4-d2b4-44f7-92c3-4ae7e5143c98','HyperDrive Y'),
	('5a3848d3-b59e-45b1-870e-0b9c3e682f1e','HyperDrive Z'),
	('45c81a74-2250-442a-a9b9-73e6129bdae0','Sapi Go'),
	('53698d6a-f35e-4021-9597-4c37c75516ff','ProdigyStrike Pro'),
	('a7845143-8936-4a25-bf04-cfaa7b41e177','Real Betis');


INSERT INTO Peminjaman VALUES ('984854fa-8517-40d2-b808-b9f1443e32fb','2022-01-01 08:00:00','2022-01-01 09:30:00','64582552-d73b-45e9-a996-720f5d43b689'),
	('24746a7a-2978-46a1-9860-379e75ea3df6','2022-02-15 10:30:00','2022-02-15 12:45:00','8c731d67-57dd-47ff-b1a3-129566c658d5'),
	('d47bd827-3b9c-4cd7-8fec-77898b1b0f26','2022-03-10 14:15:00','2022-03-10 16:00:00','074e3090-8de9-4cb2-bbc7-d9d3937ce14b'),
	('5ecd65b9-d35d-47c4-84c6-3d33d87e2980','2022-04-05 09:45:00','2022-04-05 11:15:00','6c3a9056-7954-4a80-a6f0-11af7238a33f'),
	('fbf08c6f-f614-4194-a0ef-b5c6e28505f8','2022-05-20 13:00:00','2022-05-20 14:30:00','97d7b485-03c6-4866-bcd4-80207534e219');

INSERT INTO Rapat VALUES ('9d0f6d47-ba24-4b11-a8a1-6811c55b6bc2','2022-11-19 22:34:49','a3393b61-d377-4f18-a2ce-6718020f142d','984854fa-8517-40d2-b808-b9f1443e32fb','e2a418c4-d2b4-44f7-92c3-4ae7e5143c98','pembahasan mengenai pemain baru yang akan direkrut'),
	('551fc7a2-727d-44e9-9ce9-cd3e9421eb23','2022-06-10 14:44:44','3ca2d5c5-8ce0-4879-bcb4-526a12c03ed7','24746a7a-2978-46a1-9860-379e75ea3df6','5a3848d3-b59e-45b1-870e-0b9c3e682f1e','membahas mengenai persiapan pertandingan'),
	('7a820b29-1091-4c33-bc2b-f9c91270cbe5','2023-04-05 00:08:42','2b3f57e2-ac79-44b8-ab35-4aa7ee0c9f30','d47bd827-3b9c-4cd7-8fec-77898b1b0f26','45c81a74-2250-442a-a9b9-73e6129bdae0','Rapat membahas tentang hasil pertandingan sebelumnya antara Tim C dan Tim D'),
	('63f365c5-8f0e-4ec3-b7b3-88e56ac7c34e','2022-10-04 01:58:24','a4d439c1-3cbf-4381-87ec-3553ce2ff449','5ecd65b9-d35d-47c4-84c6-3d33d87e2980','53698d6a-f35e-4021-9597-4c37c75516ff','Rapat membahas persiapan pertandingan derby antara Tim E dan Tim F di Stadion MNO'),
	('3fbb569e-f794-4378-84c3-4abf9074b4d4','2023-05-03 19:20:16','9b86b1fb-9c14-41a6-bc20-efff310ece99','fbf08c6f-f614-4194-a0ef-b5c6e28505f8','a7845143-8936-4a25-bf04-cfaa7b41e177','Rapat membahas tentang kesiapan fasilitas stadion ketersediaan tiket dan pengamanan');


INSERT INTO Peristiwa VALUES
('9d0f6d47-ba24-4b11-a8a1-6811c55b6bc2','2023-02-25 19:46:28','Kartu kuning','2573e19e-396e-4ab7-92ac-bbb48f5186bd'),
('551fc7a2-727d-44e9-9ce9-cd3e9421eb23','2023-02-25 19:46:29','Gol','263f7ee1-c1fe-4d78-a621-dcc925c44549'),
('7a820b29-1091-4c33-bc2b-f9c91270cbe5','2023-02-25 19:46:26','Kartu merah','1c055fc5-e20f-4db8-9c4b-0ac3b191b1ed'),
('63f365c5-8f0e-4ec3-b7b3-88e56ac7c34e','2023-02-25 19:46:21','Kartu merah','a09b10fa-207f-434c-b8fb-efd707b5a1bd'),
('3fbb569e-f794-4378-84c3-4abf9074b4d4','2023-02-25 19:46:22','Kartu merah','7112e944-ab70-4857-8cf0-14f27e3ef611'),
('9d0f6d47-ba24-4b11-a8a1-6811c55b6bc2','2023-02-25 19:46:23','Kartu merah','9aa5985d-b415-4d8d-835a-71d98cfd949b'),
('551fc7a2-727d-44e9-9ce9-cd3e9421eb23','2023-02-25 19:46:24','Kartu kuning','95f9c6c0-8a91-4d3a-989e-460508905def'),
('7a820b29-1091-4c33-bc2b-f9c91270cbe5','2023-02-25 19:46:25','Kartu kuning','187fcff4-8b57-43df-97c8-578b738963ce'),
('63f365c5-8f0e-4ec3-b7b3-88e56ac7c34e','2023-02-25 19:46:26','Gol','4f3530c8-a7ec-4c80-a64d-ef18b111c066'),
('3fbb569e-f794-4378-84c3-4abf9074b4d4','2023-02-25 19:46:27','Gol','9da9dd52-4859-462e-95de-6812ee70c907');

UPDATE Pemain 
SET is_captain = FALSE
WHERE is_captain = TRUE;



-- Create a function to perform the username check
CREATE OR REPLACE FUNCTION check_username_exists()
  RETURNS TRIGGER AS
$BODY$
BEGIN
  IF EXISTS (SELECT 1 FROM user_system WHERE username = NEW.username) THEN
    RAISE EXCEPTION 'Username already exists';
  END IF;

  RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

-- Create a trigger to call the function before inserting a new row
CREATE TRIGGER username_check_trigger
BEFORE INSERT ON user_system
FOR EACH ROW
EXECUTE FUNCTION check_username_exists();

CREATE OR REPLACE FUNCTION remove_captain()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.is_captain THEN
        UPDATE PEMAIN
        SET is_captain = FALSE
        WHERE nama_tim = NEW.nama_tim AND is_captain = TRUE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER change_captain_trigger
BEFORE INSERT OR UPDATE ON PEMAIN
FOR EACH ROW
EXECUTE FUNCTION remove_captain();

-- create trigger to perform spesialisasi check Apabila sudah ada 1 pelatih, maka perlu dipastikan bahwa pelatih baru memiliki spesialisasi yang berbeda. Apabila sama, maka berikan pesan error. Apabila sudah ada 2 pelatih, maka juga berikan pesan error
CREATE OR REPLACE FUNCTION cek_pelatih()
  RETURNS TRIGGER AS
$BODY$
DECLARE
  pelatih_count INTEGER;
BEGIN
  -- Count the number of coaches for the specified team
  SELECT COUNT(*) INTO pelatih_count
  FROM pelatih
  WHERE nama_tim = NEW.nama_tim;

  IF pelatih_count = 0 THEN
    -- No coaches yet, allow the new coach to be registered
    RETURN NEW;
  ELSIF pelatih_count = 1 THEN
    -- Check if the new coach has a different specialization
    IF EXISTS (
      SELECT 1
      FROM spesialisasi_pelatih
      WHERE id_pelatih = NEW.id_pelatih
        AND spesialisasi IN (
          SELECT spesialisasi
          FROM spesialisasi_pelatih
          WHERE id_pelatih IN (
            SELECT id_pelatih
            FROM pelatih
            WHERE nama_tim = NEW.nama_tim
          )
        )
    ) THEN
      -- New coach has the same specialization as the existing coach, raise an exception
      RAISE EXCEPTION 'Pelatih baru memiliki spesialisasi yang sama dengan pelatih lain di tim';
    END IF;
  ELSIF pelatih_count = 2 THEN
    -- Already 2 coaches, raise an exception
    RAISE EXCEPTION 'Tim sudah memiliki dua pelatih';
  END IF;

  RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER cek_spesialisasi_pelatih_trigger
BEFORE INSERT OR UPDATE ON pelatih
FOR EACH ROW
EXECUTE FUNCTION cek_pelatih();




CREATE TRIGGER check_stadium_availability
BEFORE INSERT ON Pertandingan
FOR EACH ROW
BEGIN
    -- Check if the selected stadium is already booked for the chosen date and time
    IF EXISTS (
        SELECT 1
        FROM Peminjaman
        WHERE ID_Stadium = NEW.Stadium
        AND Start_Datetime <= NEW.Start_Datetime
        AND End_Datetime >= NEW.End_Datetime
    ) THEN
        -- Stadium is already booked, disable the "Next" button
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stadium telah dipesan pada tanggal dan jam ini';
    END IF;
END;

CREATE TRIGGER insert_match
AFTER INSERT ON Pertandingan
FOR EACH ROW
BEGIN
    -- Insert new match data into the Pertandingan table
    INSERT INTO Pertandingan (ID_Pertandingan, Start_Datetime, End_Datetime, Stadium)
    VALUES (NEW.ID_Pertandingan, NEW.Start_Datetime, NEW.End_Datetime, NEW.Stadium);
END;

CREATE TRIGGER update_match
AFTER UPDATE ON Pertandingan
FOR EACH ROW
BEGIN
    -- Update match data in the Pertandingan table
    UPDATE Pertandingan
    SET Start_Datetime = NEW.Start_Datetime, End_Datetime = NEW.End_Datetime, Stadium = NEW.Stadium
    WHERE ID_Pertandingan = NEW.ID_Pertandingan;
END;

CREATE TRIGGER delete_match
BEFORE DELETE ON Pertandingan
FOR EACH ROW
BEGIN
    -- Check if the match has already started, if yes, prevent deletion
    IF NEW.Start_Datetime <= NOW() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tidak dapat dihapus, pertandingan telah dimulai.';
    END IF;
END;
