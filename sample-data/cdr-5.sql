BEGIN TRANSACTION;
CREATE TABLE pbxcdrs (	id		INTEGER PRIMARY KEY,	
			clid		VARCHAR(80),	
			src		VARCHAR(80),	
			dst		VARCHAR(80),	
			dcontext	VARCHAR(80),	
			channel		VARCHAR(80),	
			dstchannel	VARCHAR(80),	
			lastapp		VARCHAR(80),	
			lastdata	VARCHAR(80),	
			start		DATE,
			answer		DATE,
			cend		DATE,
			duration	INTEGER,	
			billsec		INTEGER,	
			disposition	INTEGER,	
			amaflags	INTEGER,	
			accountcode	VARCHAR(20)	,
			uniqueid	VARCHAR(32)	,
			userfield	VARCHAR(255));
INSERT INTO pbxcdrs VALUES(1,
'RTSL1 <6001>',
6001,
5030,
'default',
'SIP/6001-741e',
'SIP/5030-3fe8',
'Hangup',
'',
'2006-02-28 12:31:29',
'2006-02-28 12:31:32',
'2006-02-28 12:31:39',
10,
7,
8,
3,
'',
1141129889.0,
'');
INSERT INTO pbxcdrs VALUES(2,'RTSL1 <6001>',6001,'*12','default','SIP/6001-c58b','','Wait',1,'2006-02-28 12:39:05','2006-02-28 12:39:05','2006-02-28 12:39:07',2,2,8,3,'',1141130345.3,'');
INSERT INTO pbxcdrs VALUES(3,'RTSL1 <6001>',6001,'*123','default','SIP/6001-a458','','VoiceMailMain',6001,'2006-02-28 12:39:11','2006-02-28 12:39:11','2006-02-28 12:39:13',2,2,8,3,'',1141130351.4,'');
INSERT INTO pbxcdrs VALUES(4,'RTSL1 <6001>',6001,'*123','default','SIP/6001-b076','','VoiceMailMain',6001,'2006-02-28 12:39:28','2006-02-28 12:39:28','2006-02-28 12:39:29',1,1,8,3,'',1141130368.5,'');
INSERT INTO pbxcdrs VALUES(5,'Jonathan Boyd <5030>',5030,'*123','default','SIP/5030-4801','','VoiceMailMain',5030,'2006-02-28 12:43:09','2006-02-28 12:43:09','2006-02-28 12:43:11',2,2,8,3,'',1141130589.6,'');
COMMIT;
