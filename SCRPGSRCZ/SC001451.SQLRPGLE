     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas RZ Developments Archiving Procedure')            *
      *****************************************************************
      *                                                               *
      *  Midas - RZ Developments                                      *
      *                                                               *
      *  SC001451 - Run Archiving Procedure                           *
      *                                                               *
      *  Function:  This SQL script call MMM Archiving                *
      *                                                               *
      *  Called By: Manually on command line using RUNSQLSTM          *
      *  Note:                                                        *
      *        Replace all gg with the MMM system's correct           *
      *        global prefix before executing on the command line.    *
      *                                                               *
      *   Last Amend No. MD057372  *Create    Date 10Sep21            *
      *                                                               *
      *---------------------------------------------------------------*
      *  MD057372 - Automate MPM dbase and archiving during CoB       *
      *                                                               *
      *****************************************************************

      ** Declare Variables from HOSTGROUPARCHIVE table

     D HostGrpArchive  DS
     D  SignalString                100A
     D  RecCount                     10I 0
     D  HostGroupVar                  4S 0
     D  ArchiveSuc                    1A
     D  ArchiveRun                    8A

     D HostGroupChar                  4A
     D PurgeVarChar                   8A
     D RecCountVar                   10A

      ** Parameter Variables to call 'AOSVALR0'
     D PRtncd          S              7A   INZ(*BLANKS)
     D WRun            S              1A
     D PSValK1         S             20A
     D PSValK2         S             20A
     D PSValK3         S             20A
     D PSValK4         S             20A
     D PSValK5         S             20A
     D PSValK6         S             20A
     D PSValK7         S             20A
     D PSValK8         S             20A
     D PSValK9         S             20A
     D PSValK10        S             20A
     D PSVal1          S            200A
     D PSVal2          S            200A
     D PSVal3          S            200A
     D PSVal4          S            200A
     D PSVal5          S            200A
     D PSVal6          S            200A
     D PSVal7          S            200A
     D PSVal8          S            200A
     D PSVal9          S            200A
     D PSVal10         S            200A

      * +-------------------------+
      * ¦ Other standalone fields ¦
      * +-------------------------+
     D MPMLibName      S             75A
     D MPMArcName      S             75A
     D HostGrpArcMPM   S             30A
     D ArchiveMPM      S             30A
     D HostGrpMPM      S             30A
     D MessagesMPM     S             30A
     D HostSystemMPM   S             30A
     D UserOptsMPM     S             30A
     D ExtRefKeyMPM    S             30A
     D AuditsMPM       S             30A
     D MsgNotesMPM     S             30A
     D HostGrpArcARC   S             30A
     D ArchiveARC      S             30A
     D HostGrpARC      S             30A
     D MessagesARC     S             30A
     D HostSystemARC   S             30A
     D UserOptsARC     S             30A
     D ExtRefKeyARC    S             30A
     D AuditsARC       S             30A
     D MsgNotesARC     S             30A
     D File1           C                   CONST('HOSTGRPARC')
     D File2           C                   CONST('ARCHIVEKEY')
     D File3           C                   CONST('HOSTGROUP')
     D File4           C                   CONST('MESSAGES')
     D File5           C                   CONST('HOSTSYSTEM')
     D File6           C                   CONST('USEROPTS')
     D File7           C                   CONST('EXTREFKEYS')
     D File8           C                   CONST('AUDITS')
     D File9           C                   CONST('MSGNOTES')

      ** SQL Statement For Library Execution

     D SqlStm1         S           2000A
     D SqlStm2         S           2000A
     D SqlStm3         S           2000A
     D SqlStm4         S           2000A
     D SqlStm5         S           2000A
     D SqlStm6         S           2000A
     D SqlStm7         S           2000A
     D SqlStm8         S           2000A
     D SqlStm9         S           2000A
     D SqlStm10        S           2000A
     D SqlStm11        S           2000A
     D SqlStm12        S           2000A
     D SqlStm13        S           2000A
     D SqlStm14        S           2000A
     D SqlStm15        S           2000A

      ** SQL Statement For Diagnostics

     D SqlDiag1        S           2000A
     D SqlDiag2        S           2000A
     D SqlDiag3        S           2000A
     D SqlDiag4        S           2000A
     D SqlDiag5        S           2000A

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C                   EVAL      HostGroupVar = 1000
     C                   Z-ADD     0             RecCount

      ** Set Zoned Decimal and Time Types to Character

     C                   MOVEL     HostGroupVar  HostGroupChar

      ** Retrieve MMM Libraries from System Values

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtncd
     C                   PARM      'MPMLibName'  PSValK1
     C                   PARM                    PSVal1
     C                   PARM      'MPMArcName'  PSValK2
     C                   PARM                    PSVal2
     C                   PARM      *BLANKS       PSValK3
     C                   PARM                    PSVal3
     C                   PARM      *BLANKS       PSValK4
     C                   PARM                    PSVal4
     C                   PARM      *BLANKS       PSValK5
     C                   PARM                    PSVal5
     C                   PARM      *BLANKS       PSValK6
     C                   PARM                    PSVal6
     C                   PARM      *BLANKS       PSValK7
     C                   PARM                    PSVal7
     C                   PARM      *BLANKS       PSValK8
     C                   PARM                    PSVal8
     C                   PARM      *BLANKS       PSValK9
     C                   PARM                    PSVal9
     C                   PARM      *BLANKS       PSValK10
     C                   PARM                    PSVal10
      *
     C                   IF        PRtncd <> *Blanks
     C                             AND PRtncd <> '*NRF   '
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      MPMLibName = PSVal1
     C                   EVAL      MPMArcName = PSVal2
     C                   ENDIF

      ** Setup Path Name (MPM Library + File Name)

     C                   EVAL      HostGrpArcMPM = MPMLibName + '/' + File1
     C                   EVAL      ArchiveMPM = MPMLibName + '/' + File2
     C                   EVAL      HostGrpMPM = MPMLibName + '/' + File3
     C                   EVAL      MessagesMPM = MPMLibName + '/' + File4
     C                   EVAL      HostSystemMPM = MPMLibName + '/' + File5
     C                   EVAL      UserOptsMPM = MPMLibName + '/' + File6
     C                   EVAL      ExtRefKeyMPM = MPMLibName + '/' + File7
     C                   EVAL      AuditsMPM = MPMLibName + '/' + File8
     C                   EVAL      MsgNotesMPM = MPMLibName + '/' + File9

      ** Setup Path Name (ARC Library + File Name)

     C                   EVAL      HostGrpArcARC = MPMArcName + '/' + File1
     C                   EVAL      ArchiveARC = MPMArcName + '/' + File2
     C                   EVAL      HostGrpARC = MPMArcName + '/' + File3
     C                   EVAL      MessagesARC = MPMArcName + '/' + File4
     C                   EVAL      HostSystemARC = MPMArcName + '/' + File5
     C                   EVAL      UserOptsARC = MPMArcName + '/' + File6
     C                   EVAL      ExtRefKeyARC = MPMArcName + '/' + File7
     C                   EVAL      AuditsARC = MPMArcName + '/' + File8
     C                   EVAL      MsgNotesARC = MPMArcName + '/' + File9

      ** Execute SQL Statements
     C                   EXSR      HOSTGRPSR
     C                   EXSR      ARCHKEYSR
     C                   EXSR      PURGEDATE
     C                   EXSR      INSKEYARC
     C                   EXSR      RETAINREC
     C                   EXSR      INSDATARC 	
     C                   EXSR      INSEXTKEY 	
     C                   EXSR      INSAUDITS 	 	
     C                   EXSR      INSMSGNOT
     C                   EXSR      REMOVEDTA
     C                   EXSR      UPDATEREC	
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  HOSTGRPSR - Clear Table HostGroupArchive                     *
      *                                                               *
      *****************************************************************
     C     HOSTGRPSR     BEGSR
	
      ** CLEAR ANY LEFTOVER RECORDS FROM THE WORK FILE.

     C                   EVAL      SqlStm1 =
     C                             'DELETE FROM ' + HostGrpArcMPM
     C

     C/EXEC SQL
     C+ PREPARE HostGrpClear
     C+   FROM :SqlStm1
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE HostGrpClear
     C/END-EXEC

      ** INSERT VALUES TO HOSTGROUPARCHIVE

     C                   EVAL      SqlStm2 =
     C                             'INSERT INTO ' + HostGrpArcMPM +
     C                             ' VALUES (1, 1000, 1, Null, Null)'

     C/EXEC SQL
     C+ PREPARE HostGrpInsert
     C+   FROM :SqlStm2
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE HostGrpInsert
     C/END-EXEC

     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  ARCHKEYSR - Clear Table ArchiveKey                           *
      *                                                               *
      *****************************************************************
     C     ARCHKEYSR     BEGSR

      ** CLEAR VALUES FROM ARCHIVEKEY

     C                   EVAL      SqlStm3 =
     C                             'DELETE FROM ' + ArchiveMPM
     C

     C/EXEC SQL
     C+ PREPARE ArchKeyClear
     C+   FROM :SqlStm3
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE ArchKeyClear
     C/END-EXEC
	
     C                   EXSR      DIAG1

     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  PURGEDATE - Clear Table ArchiveKey                           *
      *                                                               *
      *****************************************************************
     C     PURGEDATE     BEGSR


      ** SELECT PURGING DATE TO USE.

     C                   EVAL      SqlStm4 =
     C                             'SELECT (TIMESTAMP(Current_Date' + ','
     C                             + ' Current_Time) - ArchiveOffSet Days)' +
     C                             ' INTO ' + PurgeVarChar + ' FROM ' +
     C                             HostGrpMPM + ' Where HostGroupID = ' +
     C                             HostGroupChar

     C/EXEC SQL
     C+ PREPARE SelectPurge
     C+   FROM :SqlStm4
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE SelectPurge
     C/END-EXEC

     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  INSKEYARC - Insert Keys to be Archived                       *
      *                                                               *
      *****************************************************************
     C     INSKEYARC     BEGSR

      ** INSERT ALL KEYS FOR MESSAGES.

     C                   EVAL      SqlStm5 =
     C                             'INSERT INTO ' + ArchiveMPM +
     C                             ' ( MessageID, HostGroupID) ' +
     C                             ' SELECT MessageID, ' + HostGroupChar +
     C                             ' FROM ' + MessagesMPM +
     C                             ' WHERE HOSTID IN ( SELECT HOSTID '
     C                             + 'FROM ' + HostSystemMPM +
     C                             ' WHERE HOSTGROUPID = ' + HostGroupChar
     C                             + ' AND QUEUE NOT IN ' + '( SELECT ' +
     C                             'OPTIONVALUE FROM ' + UserOptsMPM +
     C                             ' WHERE USERNAME = ''SYSTEM'' ' +
     C                             'AND CUSTOMERID = 1 ' + 'AND ' +
     C                             'OPTIONPARAMETER LIKE ' +
     C                             '''preventArchiveQueue%''' + ') ' + 'AND ( ('
     C                             + 'MESSAGESTATUS <> ''U''' +
     C                             ' AND ' + 'DIRECTION = ''0''' + ' AND ' +
     C                             'INTERNALMESSAGETYPE <> ''P''' +
     C                             ' AND ' + 'INTERNALMESSAGETYPE <> ''R''' +
     C                             ' AND ' + 'SYSTEMARRIVALTIME <= ' +
     C                             PurgeVarChar + ') ' + 'OR ' + '( ' +
     C                             'MESSAGESTATUS <> ''U''' + ' AND '
     C                             + 'DIRECTION = ''0''' + ' AND ' +
     C                             '( INTERNALMESSAGETYPE = ''P'''
     C                             + ' OR ' + 'INTERNALMESSAGETYPE = ''R'''
     C                             + ') ' + 'AND ' + 'TIMESTAMP' +
     C                             '(VALUEDATE || ''235959'') ' + '<= ' +
     C                             PurgeVarChar + ' ' + ')' + ' ' + ')'

     C/EXEC SQL
     C+ PREPARE InsertArcKey
     C+   FROM :SqlStm5
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE InsertArcKey
     C/END-EXEC

     C                   EXSR      DIAG1

     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  RETAINREC - Retain Archive Records That Already Exist in     *
      *              Archive Library                                  *
      *                                                               *
      *****************************************************************
     C     RETAINREC     BEGSR

      ** DELETE KEYS THAT DOES NOT EXIST IN ARCHIVE LIBRARY

     C                   EVAL      SqlStm6 =
     C                             'DELETE FROM ' + ArchiveMPM +
     C                             ' a ' + 'WHERE EXISTS ' +
     C                             '(SELECT MessageID,HostGroupID ' +
     C                             'FROM ' + MessagesARC + ' b ' +
     C                             'WHERE ' + 'a.MessageId = ' +
     C                             'b.MessageId)'

     C/EXEC SQL
     C+ PREPARE RetainArch
     C+   FROM :SqlStm6
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE RetainArch
     C/END-EXEC

     C                   EXSR      DIAG1   	

     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  INSDATARC - Insert Data into Archive Database based on the   *
      *              ArchiveKey Table.                                *
      *                                                               *
      *****************************************************************
     C     INSDATARC     BEGSR

     C                   EVAL      SqlStm7 =
     C                             'INSERT INTO ' + MessagesARC +
     C                             'SELECT * FROM ' + MessagesMPM + ' a '
     C                             + 'WHERE EXISTS ( SELECT MessageId ' +
     C                             'FROM ' + ArchiveMPM + ' b ' +
     C                             'WHERE ' + 'a.MessageId = ' +
     C                             'b.MessageId)'

     C/EXEC SQL
     C+ PREPARE InsertDataArc
     C+   FROM :SqlStm7
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE InsertDataArc
     C/END-EXEC

     C                   EXSR      DIAG2
	
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  INSEXTKEY - Insert Into External Reference Keys              *
      *                                                               *
      *****************************************************************
     C     INSEXTKEY     BEGSR


     C                   EVAL      SqlStm8 =
     C                             'INSERT INTO ' + ExtRefKeyARC +
     C                             'SELECT * FROM ' + ExtRefKeyMPM + ' a '
     C                             + 'WHERE EXISTS ( SELECT MessageId ' +
     C                             'FROM ' + ArchiveMPM + ' b ' +
     C                             'WHERE ' + 'a.MessageId = ' +
     C                             'b.MessageId)'

     C/EXEC SQL
     C+ PREPARE InsertExtArc
     C+   FROM :SqlStm8
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE InsertExtArc
     C/END-EXEC

     C                   EXSR      DIAG3

     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  INSAUDITS - Insert Message IDs to Audits File                *
      *                                                               *
      *****************************************************************
     C     INSAUDITS     BEGSR

     C                   EVAL      SqlStm9 =
     C                             'INSERT INTO ' + AuditsARC +
     C                             'SELECT * FROM ' + AuditsMPM + ' a '
     C                             + 'WHERE EXISTS ( SELECT MessageId ' +
     C                             'FROM ' + ArchiveMPM + ' b ' +
     C                             'WHERE ' + 'a.MessageId = ' +
     C                             'b.MessageId)'

     C/EXEC SQL
     C+ PREPARE InsertAudArc
     C+   FROM :SqlStm9
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE InsertAudArc
     C/END-EXEC

     C                   EXSR      DIAG4

     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  INSMSGNOT - Insert Into MessageNotes                         *
      *                                                               *
      *****************************************************************
     C     INSMSGNOT     BEGSR

     C                   EVAL      SqlStm10 =
     C                             'INSERT INTO ' + MsgNotesARC +
     C                             'SELECT * FROM ' + MsgNotesMPM + ' a '
     C                             + 'WHERE EXISTS ( SELECT MessageId ' +
     C                             'FROM ' + ArchiveMPM + ' b ' +
     C                             'WHERE ' + 'a.MessageId = ' +
     C                             'b.MessageId)'

     C/EXEC SQL
     C+ PREPARE InsertMNTArc
     C+   FROM :SqlStm10
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE InsertMNTArc
     C/END-EXEC

     C                   EXSR      DIAG5

     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  REMOVEDTA - Delete Data Inserted from Archive Library        *
      *                                                               *
      *****************************************************************
     C     REMOVEDTA     BEGSR

      ** DELETE DATA FROM AUDITS FILE.

     C                   EVAL      SqlStm11 =
     C                             'DELETE FROM ' + AuditsMPM + ' a '
     C                             + 'WHERE EXISTS ( SELECT MessageId ' +
     C                             'FROM ' + ArchiveMPM + ' b ' +
     C                             'WHERE ' + 'a.MessageId = ' +
     C                             'b.MessageId)'

     C/EXEC SQL
     C+ PREPARE DelAudMPM
     C+   FROM :SqlStm11
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE DelAudMPM
     C/END-EXEC

     C                   EXSR      DIAG4

      ** DELETE DATA FROM EXTERNALREFERENCEKEYS.

     C                   EVAL      SqlStm12 =
     C                             'DELETE FROM ' + ExtRefKeyMPM + ' a '
     C                             + 'WHERE EXISTS ( SELECT MessageId ' +
     C                             'FROM ' + ArchiveMPM + ' b ' +
     C                             'WHERE ' + 'a.MessageId = ' +
     C                             'b.MessageId)'

     C/EXEC SQL
     C+ PREPARE DelExtMPM
     C+   FROM :SqlStm12
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE DelExtMPM
     C/END-EXEC
	
     C                   EXSR      DIAG3

      ** DELETE DATA FROM MESSAGENOTES

     C                   EVAL      SqlStm13 =
     C                             'DELETE FROM ' + MsgNotesMPM + ' a '
     C                             + 'WHERE EXISTS ( SELECT MessageId ' +
     C                             'FROM ' + ArchiveMPM + ' b ' +
     C                             'WHERE ' + 'a.MessageId = ' +
     C                             'b.MessageId)'

     C/EXEC SQL
     C+ PREPARE DelMNTMPM
     C+   FROM :SqlStm13
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE DelMNTMPM
     C/END-EXEC

     C                   EXSR      DIAG5

      ** DELETE DATA FROM MESSAGES

     C                   EVAL      SqlStm14 =
     C                             'DELETE FROM ' + MessagesMPM + ' a '
     C                             + 'WHERE EXISTS ( SELECT MessageId ' +
     C                             'FROM ' + ArchiveMPM + ' b ' +
     C                             'WHERE ' + 'a.MessageId = ' +
     C                             'b.MessageId)'

     C/EXEC SQL
     C+ PREPARE DelMsgMPM
     C+   FROM :SqlStm14
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE DelMsgMPM
     C/END-EXEC

     C                   EXSR      DIAG2
	
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  UPDATEREC - Update the row in the HOSTGROUPARCHIVE table     *
      *                                                               *
      *****************************************************************
     C     UPDATEREC     BEGSR


     C                   EVAL      SqlStm15 =
     C                             'UPDATE ' + HostGrpArcMPM +
     C                             'SET ' + ArchiveSuc + ' = 2,' +
     C                             ArchiveRun + ' = TIMESTAMP(CURRENT_DATE,' +
     C                             ' CURRENT_TIME), ' + 'Comments = '' ' +
     C                             'WHERE HostGroupId = ' + HostGroupChar +
     C                             ' AND ' + ArchiveSuc + ' = 1 ' +
     C                             'AND ' + ArchiveRun + ' IS NULL'

     C/EXEC SQL
     C+ PREPARE UpdHstGrpArcMPM
     C+   FROM :SqlStm15
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE UpdHstGrpArcMPM
     C/END-EXEC

     C/EXEC SQL
     C+ COMMIT
     C/END-EXEC

     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  DIAG1 - Get Diagnostics from previous SQL Statement          *
      *          (ArchiveKey)                                         *
      *                                                               *
      *****************************************************************
     C     DIAG1         BEGSR

      ** GET ROW COUNT FROM PREVIOUS SQL STATEMENT

     C/EXEC SQL
     C+           GET DIAGNOSTICS :RecCount = Row_Count
     C/END-EXEC

      ** SET MESSAGE FROM PREVIOUS SQL STATEMENT

     C/EXEC SQL
     C+           SET :SignalString = :RecCount
     C/END-EXEC

      ** Set Integer Type to Character

     C                   MOVEL     RecCount      RecCountVar

     C                   EVAL      SqlDiag1 =
     C                             'SET' + ' ' + SignalString + ' ' + '=' +
     C                             ' ' + RecCountVar + ' ' + '||' +  ' ' +
     C                             'rows deleted from' + ArchiveMPM

     C/EXEC SQL
     C+ PREPARE Diagnostics1
     C+   FROM :SqlDiag1
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE Diagnostics1
     C/END-EXEC

      ** When cursor operation conflict, set Message Text Value
      ** equal to Signal String

     C/EXEC SQL
     C+     Signal SqlState '01001'
     C+     Set Message_Text = :SignalString
     C/END-EXEC

     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  DIAG2 - Get Diagnostics from previous SQL Statement          *
      *          (Messages)                                           *
      *                                                               *
      *****************************************************************
     C     DIAG2         BEGSR

      ** GET ROW COUNT FROM PREVIOUS SQL STATEMENT

     C/EXEC SQL
     C+           GET DIAGNOSTICS :RecCount = Row_Count
     C/END-EXEC

      ** SET MESSAGE FROM PREVIOUS SQL STATEMENT

     C/EXEC SQL
     C+           SET :SignalString =  :RecCount
     C/END-EXEC

      ** Set Integer Type to Character

     C                   MOVEL     RecCount      RecCountVar

     C                   EVAL      SqlDiag2 =
     C                             'SET' + ' ' + SignalString + ' ' + '=' +
     C                             ' ' + RecCountVar + ' ' + '||' +  ' ' +
     C                             'rows deleted from' + MessagesMPM

     C/EXEC SQL
     C+ PREPARE Diagnostics2
     C+   FROM :SqlDiag2
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE Diagnostics2
     C/END-EXEC
	
      ** When cursor operation conflict, set Message Text Value
      ** equal to Signal String

     C/EXEC SQL
     C+     Signal SqlState '01001'
     C+     Set Message_Text = :SignalString
     C/END-EXEC

     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  DIAG3 - Get Diagnostics from previous SQL Statement          *
      *          (ExternalReferenceKeys)                              *
      *                                                               *
      *****************************************************************
     C     DIAG3         BEGSR

      ** GET ROW COUNT FROM PREVIOUS SQL STATEMENT

     C/EXEC SQL
     C+           GET DIAGNOSTICS :RecCount = Row_Count
     C/END-EXEC

      ** SET MESSAGE FROM PREVIOUS SQL STATEMENT

     C/EXEC SQL
     C+           SET :SignalString =  :RecCount
     C/END-EXEC

      ** Set Integer Type to Character

     C                   MOVEL     RecCount      RecCountVar

     C                   EVAL      SqlDiag3 =
     C                             'SET' + ' ' + SignalString + ' ' + '=' +
     C                             ' ' + RecCountVar + ' ' + '||' +  ' ' +
     C                             'rows deleted from' + ExtRefKeyMPM

     C/EXEC SQL
     C+ PREPARE Diagnostics3
     C+   FROM :SqlDiag3
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE Diagnostics3
     C/END-EXEC
	
      ** When cursor operation conflict, set Message Text Value
      ** equal to Signal String

     C/EXEC SQL
     C+     Signal SqlState '01001'
     C+     Set Message_Text = :SignalString
     C/END-EXEC

     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  DIAG4 - Get Diagnostics from previous SQL Statement          *
      *          (Audits)                                             *
      *                                                               *
      *****************************************************************
     C     DIAG4         BEGSR

      ** GET ROW COUNT FROM PREVIOUS SQL STATEMENT

     C/EXEC SQL
     C+           GET DIAGNOSTICS :RecCount = Row_Count
     C/END-EXEC

      ** SET MESSAGE FROM PREVIOUS SQL STATEMENT

     C/EXEC SQL
     C+           SET :SignalString =  :RecCount
     C/END-EXEC

      ** Set Integer Type to Character

     C                   MOVEL     RecCount      RecCountVar

     C                   EVAL      SqlDiag4 =
     C                             'SET' + ' ' + SignalString + ' ' + '=' +
     C                             ' ' + RecCountVar + ' ' + '||' +  ' ' +
     C                             'rows deleted from' + MessagesMPM

     C/EXEC SQL
     C+ PREPARE Diagnostics4
     C+   FROM :SqlDiag4
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE Diagnostics4
     C/END-EXEC
	
      ** When cursor operation conflict, set Message Text Value
      ** equal to Signal String

     C/EXEC SQL
     C+     Signal SqlState '01001'
     C+     Set Message_Text = :SignalString
     C/END-EXEC

     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  DIAG5 - Get Diagnostics from previous SQL Statement          *
      *          (MessageNotes)                                       *
      *                                                               *
      *****************************************************************
     C     DIAG5         BEGSR

      ** GET ROW COUNT FROM PREVIOUS SQL STATEMENT

     C/EXEC SQL
     C+           GET DIAGNOSTICS :RecCount = Row_Count
     C/END-EXEC

      ** SET MESSAGE FROM PREVIOUS SQL STATEMENT

     C/EXEC SQL
     C+           SET :SignalString =  :RecCount
     C/END-EXEC

      ** Set Integer Type to Character

     C                   MOVEL     RecCount      RecCountVar


     C                   EVAL      SqlDiag5 =
     C                             'SET' + ' ' + SignalString + ' ' + '=' +
     C                             ' ' + RecCountVar + ' ' + '||' +  ' ' +
     C                             'rows deleted from' + MsgNotesMPM

     C/EXEC SQL
     C+ PREPARE Diagnostics5
     C+   FROM :SqlDiag5
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE Diagnostics5
     C/END-EXEC
	
      ** When cursor operation conflict, set Message Text Value
      ** equal to Signal String

     C/EXEC SQL
     C+     Signal SqlState '01001'
     C+     Set Message_Text = :SignalString
     C/END-EXEC

     C                   ENDSR
     *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************

     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      ********************************************************************
