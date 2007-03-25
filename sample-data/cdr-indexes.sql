
#CREATE TABLE pbxcdrs (	id		INTEGER PRIMARY KEY,	
#			clid		VARCHAR(80),	
#			src		VARCHAR(80),	
#			dst		VARCHAR(80),	
#			dcontext	VARCHAR(80),	
#			channel		VARCHAR(80),	
#			dstchannel	VARCHAR(80),	
#			lastapp		VARCHAR(80),	
#			lastdata	VARCHAR(80),	
#			start		CHAR(19),	
#			answer		CHAR(19),	
#			end		CHAR(19),	
#			duration	INTEGER,	
#			billsec		INTEGER,	
#			disposition	INTEGER,	
#			amaflags	INTEGER,	
#			accountcode	VARCHAR(20)	,
#			uniqueid	VARCHAR(32)	,
#			userfield	VARCHAR(255));

CREATE INDEX pbxcdrsstart ON pbxcdrs(start);
CREATE INDEX pbxcdrsend ON pbxcdrs(end);
CREATE INDEX pbxcdrsans ON pbxcdrs(answer);
CREATE INDEX pbxcdrsdur ON pbxcdrs(duration);
CREATE INDEX pbxcdrsbs ON pbxcdrs(billsec);
