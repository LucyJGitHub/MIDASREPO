     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas MR MBI Incremental Extract Exit Program')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting Module                           *
      *                                                               *
      *  MR001002 - Midas MR MBI Incremental Extract Exit Program     *
      *                                                               *
      *  Function: This program will be called as an exit program     *
      *            for RCVJRNE during MBI incremental extract.        *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR864564           Date 15Nov11               *
      *                 AR863616           Date 11Nov11               *
      *                 AR828013 *CREATE   Date 30Sep11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR864564 - Primary key violation AU_BAL.                     *
      *  AR863616 - Incorrect incremental record for DEALSDB.         *
      *  AR828013 - Incremental database for MBI (CCR036)             *
      *                                                               *
      *****************************************************************

      ** Midas MR MBI Extract Key Details File

     FMRKEYDPD  IF A E           K DISK


      ** Entry Type *TYPE1

     D JournalEnt      DS
     D  Filler01                      5A
     D  JrnSeqn                      10A
     D  JrnCode                       1A
     D  JrnEntType                    2A
     D  Filler02                     12A
     D  JobName                      10A
     D  Filler03                     16A
     D  Program                      10A
     D  Object                       10A
     D  Library                      10A
     D  Member                       10A
     D  Filler04                     29A

      ** The journal entry

     D  Entry                      2000A

     D ControlInf      DS
     D  CTRLInfo1                     1
     D  CTRLInfo2                     1

     D                 DS                                                                   AR864564
     D  DStr                   1     32A                                                    AR864564
     D  DPac                   1     32P 0                                                  AR864564
     D WPStr           S             64A                                                    AR864564
     D ExtLibr         S             10    DTAARA('EXTRLIB')

     D WCmd            S            100A
     D WLen            S             15  5
     D WIx             S              3  0

     D DELSTM          S            200A
     D DELSTM1         S            200A
     D DELSTM2         S            200A
     D DELSTM3         S            200A
     D INSSTM          S            200A
     D UPDSTM          S            200A
     D WHERECL         S            200A

     D PFile           S             10A
     D PAction         S              1A
     D PCLeared        S             10A   DIM(300) INZ(*BLANKS)

     C     *ENTRY        PLIST
     C                   PARM                    JournalEnt
     C                   PARM                    ControlInf

     C                   IF        CTRLInfo1  = '0'  OR
     C                             JrnEntType = '00'
     C                   EVAL      CTRLInfo1  = '9'
     C                   EVAL      *INLR      = *ON
     C                   ELSE
     C                   EXSR      SRPROCESS
     C                   ENDIF
     C                   RETURN
     C
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  *INZSR --- INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR

      ** Create Dummy Flat File

     C/EXEC SQL
     C+  CREATE TABLE QTEMP/MBIEXTR
     C+         (DUMMY CHAR(2000) NOT NULL WITH DEFAULT)
     C/END-EXEC

     C/EXEC SQL
     C+  INSERT INTO QTEMP/MBIEXTR VALUES(' ') WITH NC
     C/END-EXEC

     C                   IN        ExtLibr

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRPROCESS - Process Journal Entries
      *****************************************************************
     C     SRPROCESS     BEGSR

     C                   EVAL      PFile      = Object                                      AR863616
     C                   IF        JrnEntType = 'PT' OR
     C                             JrnEntType = 'PX' OR
     C                             JrnEntType = 'UP' OR
     C                             JrnEntType = 'DL'

     C**********         EVAL      PFile      = Object                                      AR863616
     C/EXEC SQL
     C+  UPDATE QTEMP/MBIEXTR SET DUMMY = :Entry WITH NC
     C/END-EXEC

     C                   EVAL      WCmd = 'CPYF FROMFILE(MBIEXTR) ' +
     C                                    'TOFILE(QTEMP/' +
     C                                    %TRIMR(Object)  +
     C                                    ') MBROPT(*REPLACE) ' +
     C                                    'FMTOPT(*NOCHK)'
     C                   EVAL      WLen = %LEN(%TRIM(WCmd))

     C                   CALL      'QCMDEXC'
     C                   PARM                    WCmd
     C                   PARM                    WLen

      ** Set Action field

     C                   SELECT
     C                   WHEN      JrnEntType = 'PT' OR
     C                             JrnEntType = 'PX'
     C                   EVAL      PAction    = '1'
     C                   WHEN      JrnEntType = 'UP'
     C                   EVAL      PAction    = '2'
     C                   WHEN      JrnEntType = 'DL'
     C                   EVAL      PAction    = '3'
     C                   ENDSL
     C                   IF        %LOOKUP(Object:PCleared) = 0
     C                   EVAL      UPDSTM = 'UPDATE QTEMP/' +
     C                                      %TRIMR(Object) +
     C                                      ' SET ACTION = ''' +
     C                                      PAction + '''' +
     C                                      ' WITH NC'
     C                   ELSE
     C                   EVAL      UPDSTM = 'UPDATE QTEMP/' +
     C                                      %TRIMR(Object) +
     C                                      ' SET ACTION = '' ''' +
     C                                      ' WITH NC'
     C                   ENDIF

     C/EXEC SQL
     C+ PREPARE U1 FROM :UPDSTM
     C/END-EXEC
     C/EXEC SQL
     C+ EXECUTE U1
     C/END-EXEC

      ** Build WHERE condition from the Key File

     C                   EXSR      SRGETKEY

     C                   SELECT
     C                   WHEN      PAction = '1'
     C                   IF        %LOOKUP(Object:PCleared) = 0
     C                   EVAL      DELSTM3 = 'DELETE FROM ' +
     C                                       %TRIMR(ExtLibr) + '/' +
     C                                       %TRIMR(PFile) +
     C                                       ' WHERE ACTION = ''3''' +
     C                                       ' AND ' +
     C                                       %TRIMR(WHERECL) +
     C                                       ' WITH NC'
     C/EXEC SQL
     C+ PREPARE D3 FROM :DELSTM3
     C/END-EXEC

      ** Delete record that exist.

     C/EXEC SQL
     C+ EXECUTE D3
     C/END-EXEC
     C                   IF        SQLCOD  = 0
     C                   EVAL      UPDSTM  = 'UPDATE QTEMP/' +
     C                                       %TRIMR(PFile) +
     C                                       ' SET ACTION = ''2''' +
     C                                       ' WITH NC'
     C/EXEC SQL
     C+ PREPARE U1 FROM :UPDSTM
     C/END-EXEC

      ** Change Action to '2' if inserted record is previously deleted.

     C/EXEC SQL
     C+ EXECUTE U1
     C/END-EXEC
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      INSSTM  = 'INSERT INTO ' +
     C                                       %TRIMR(ExtLibr) + '/' +
     C                                       %TRIMR(PFile) +
     C                                       ' SELECT * FROM ' +
     C                                       'QTEMP/' +
     C                                       %TRIMR(PFile) + ' WITH NC'
     C/EXEC SQL
     C+ PREPARE I1 FROM :INSSTM
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE I1
     C/END-EXEC
     C                   WHEN      PAction = '2'
     C                   IF        %LOOKUP(Object:PCleared) = 0
     C                   EVAL      DELSTM1 = 'DELETE FROM ' +
     C                                       %TRIMR(ExtLibr) + '/' +
     C                                       %TRIMR(PFile) +
     C                                       ' WHERE ACTION = ''1''' +
     C                                       ' AND ' +
     C                                       %TRIMR(WHERECL) +
     C                                       ' WITH NC'
     C/EXEC SQL
     C+ PREPARE D1 FROM :DELSTM1
     C/END-EXEC

      ** Delete record that exist.

     C/EXEC SQL
     C+ EXECUTE D1
     C/END-EXEC
     C                   IF        SQLCOD  = 0
     C                   EVAL      UPDSTM  = 'UPDATE QTEMP/' +
     C                                       %TRIMR(PFile) +
     C                                       ' SET ACTION = ''1''' +
     C                                       ' WITH NC'
     C/EXEC SQL
     C+ PREPARE U1 FROM :UPDSTM
     C/END-EXEC

      ** Change Action to '1' if updated record is previously inserted.

     C/EXEC SQL
     C+ EXECUTE U1
     C/END-EXEC
     C                   ELSE
     C                   EVAL      DELSTM2 = 'DELETE FROM ' +
     C                                       %TRIMR(ExtLibr) + '/' +
     C                                       %TRIMR(PFile) +
     C                                       ' WHERE ACTION = ''2''' +
     C                                       ' AND ' +
     C                                       %TRIMR(WHERECL) +
     C                                       ' WITH NC'
     C/EXEC SQL
     C+ PREPARE D2 FROM :DELSTM2
     C/END-EXEC

      ** Delete record that exist.

     C/EXEC SQL
     C+ EXECUTE D2
     C/END-EXEC
     C                   ENDIF
     C                   ELSE

      ** If refreshed data is update,

     C                   EVAL      DELSTM  = 'DELETE FROM ' +
     C                                       %TRIMR(ExtLibr) + '/' +
     C                                       %TRIMR(PFile) +
     C                                       ' WHERE ' +
     C                                       %TRIMR(WHERECL) +
     C                                       ' WITH NC'
     C/EXEC SQL
     C+ PREPARE D1 FROM :DELSTM
     C/END-EXEC

      ** Delete previously added record.

     C/EXEC SQL
     C+ EXECUTE D1
     C/END-EXEC
     C                   ENDIF
     C                   EVAL      INSSTM  = 'INSERT INTO ' +
     C                                       %TRIMR(ExtLibr) + '/' +
     C                                       %TRIMR(PFile) +
     C                                       ' SELECT * FROM QTEMP/' +
     C                                       %TRIMR(PFile) + ' WITH NC'
     C/EXEC SQL
     C+ PREPARE I1 FROM :INSSTM
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE I1
     C/END-EXEC
     C                   WHEN      PAction = '3'
     C                   IF        %LOOKUP(Object:PCleared) = 0
     C                   EVAL      DELSTM1 = 'DELETE FROM ' +
     C                                       %TRIMR(ExtLibr) + '/' +
     C                                       %TRIMR(PFile) +
     C                                       ' WHERE ACTION = ''1''' +
     C                                       ' AND ' +
     C                                       %TRIMR(WHERECL) +
     C                                       ' WITH NC'
     C/EXEC SQL
     C+ PREPARE D1 FROM :DELSTM1
     C/END-EXEC

      ** Delete record that exist.

     C/EXEC SQL
     C+ EXECUTE D1
     C/END-EXEC
     C                   IF        SQLCOD  = 100
     C                   EVAL      UPDSTM  = 'UPDATE ' +
     C                                       %TRIMR(ExtLibr) + '/' +
     C                                       %TRIMR(PFile) +
     C                                       ' SET ACTION = ''3''' +
     C                                       ' WHERE ' +
     C                                       %TRIMR(WHERECL) +
     C                                       ' WITH NC'
     C/EXEC SQL
     C+ PREPARE U1 FROM :UPDSTM
     C/END-EXEC

      ** Change Action to '3' if deleted record is previously updated.

     C/EXEC SQL
     C+ EXECUTE U1
     C/END-EXEC
     C                   IF        SQLCOD  = 100
     C                   EVAL      INSSTM  = 'INSERT INTO ' +
     C                                       %TRIMR(ExtLibr) + '/' +
     C                                       %TRIMR(PFile) +
     C                                       ' SELECT * FROM ' +
     C                                       'QTEMP/' +
     C                                       %TRIMR(PFile) + ' WITH NC'
     C/EXEC SQL
     C+ PREPARE I1 FROM :INSSTM
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE I1
     C/END-EXEC
     C                   ENDIF
     C                   ENDIF
     C                   ELSE

      ** If refreshed data is deleted,

     C                   EVAL      DELSTM  = 'DELETE FROM ' +
     C                                       %TRIMR(ExtLibr) + '/' +
     C                                       %TRIMR(PFile) +
     C                                       ' WHERE ' +
     C                                       %TRIMR(WHERECL) +
     C                                       ' WITH NC'
     C/EXEC SQL
     C+ PREPARE D1 FROM :DELSTM
     C/END-EXEC

      ** Delete previously added record.

     C/EXEC SQL
     C+ EXECUTE D1
     C/END-EXEC
     C                   ENDIF
     C                   ENDSL

     C                   ELSE

      ** Refresh if File is cleared

     C                   IF        JrnEntType = 'CR'
     C                   IF        %LOOKUP(Object:PCleared) = 0
     C                   EVAL      PCleared(%LOOKUP(' ':PCleared)) =
     C                             Object
     C                   ENDIF
     C                   EVAL      DELSTM  = 'DELETE FROM ' +
     C                                       %TRIMR(ExtLibr) + '/' +
     C                                       %TRIMR(PFile) +
     C                                       ' WITH NC'
     C/EXEC SQL
     C+ PREPARE D1 FROM :DELSTM
     C/END-EXEC

      ** Delete all previous changes to the file.

     C/EXEC SQL
     C+ EXECUTE D1
     C/END-EXEC
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRGETKEY - Get Keys from Key File to Build the WHERE condition
      *****************************************************************
     C     SRGETKEY      BEGSR

      ** Get the Key fields from the Key File

     C                   EVAL      WHERECL = *BLANKS
     C     PFile         SETLL     MRKEYDPD
     C     PFile         READE     MRKEYDPD

     C                   DOW       NOT %EOF()
     C                   EVAL      WPStr = %SUBST(Entry:MKFLDP:MKFLDL)                      AR864564
     C                   IF        MKFLDL < 33                                              AR864564
                                                                                            AR864564
      ** Check if key value is Packed Numeric.                                              AR864564
                                                                                            AR864564
     C                   EVAL      DPac  = 0                                                AR864564
     C                   EVAL      %SUBST(DStr:33-MKFLDL) =                                 AR864564
     C                             %SUBST(Entry:MKFLDP:MKFLDL)                              AR864564
     C                   IF        %BITAND(%SUBST(DStr:32):X'0F') = X'0F' OR                AR864564
     C                             %BITAND(%SUBST(DStr:32):X'0D') = X'0D'                   AR864564
     C                   MOVE      DPac          WPStr                                      AR864564
     C                   EVAL      WPStr = %SUBST(WPStr:65-MKFLDL*2)                        AR864564
     C                   ENDIF                                                              AR864564
     C                   ENDIF                                                              AR864564
                                                                                            AR864564
     C                   EVAL      WHERECL = %TRIMR(WHERECL) + ' ' +
     C                                %TRIMR(MKFLDN) + '=''' +
     C**********                      %SUBST(Entry:MKFLDP:MKFLDL)+''''                      AR864564
     C                                %TRIM(WPStr) + ''''                                   AR864564
     C     PFile         READE     MRKEYDPD
     C                   IF        NOT %EOF()
     C                   EVAL      WHERECL = %TRIMR(WHERECL) + ' AND'
     C                   ENDIF
     C                   ENDDO

     C                   ENDSR
