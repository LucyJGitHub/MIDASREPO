     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  ALWNULL(*USRCTL)                                             *
/*EXI *  TEXT('Midas UP Action File conflict rpt. for T_GRMENUL')     *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP1728 - Action file compatibilty report for UPGMULPD        *
      *                                                               *
      *  Function:  This program compares the differences between     *
      *             Action file delivered and the system.             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CUP021             Date 16Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CUP031  *CREATE    Date 14Jan05               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP021 - Rewrite of Action File processing                   *
      *  CUP031 - Creation of new set of Action File utilities.       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    30         Error on Read                                   *
      *    31         EOF on Read                                     *
      *    32         Chain Fail on Insert routine                    *
      *    33         Chain Fail on Delete routine or on Move routine *
      *    34         Record there on chain but different             *
      *    35         Chain Fail on Amend routine                     *
      *    36         Record there on Chain but different             *
      *    37         Compare Indicator for Delete                    *
      *    38         Compare Indicator for Amend Routine             *
      *    39         Switched on if a record is found on file(Delete)*
      *    40         Conflicts detected                              *
      *    41         First line of record written                    *
      *    42         Same Record in Sys and UP for Insert            *
      *    45         Insert                                          *
      *    46         Move                                            *
      *    47         To print column heading lines in UP1728P1       *
      *    51         Null indicator for field KEY_MLGRPID            *
      *    52         Null indicator for field KEY_MLMENUCODE         *
      *    53         Null indicator for field SGRPID                 *
      *    54         Null indicator for field SMENUCODE              *
      *    55         Same value for fields allowing null values      *
      *    56         Positional data not found in GPGMULL0/UPGMULL0. *
      *    57         Saved record not found in UPGMULL0.             *
      *    58         Missing positional data reported                *
      *    60         Do not run report if error on Amends            *
      *    70         Error on Write                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FUPGMULL0  IF   E           K DISK    INFSR(*PSSR) Prefix(UP_)  USROPN
     FGPGMULL0  IF   E           K DISK    INFSR(*PSSR) Prefix(SYS_) USROPN
     FUP0803P1  O    E             PRINTER INFSR(*PSSR) INFDS(SPOOL)
     FUP1728P1  O    E             PRINTER INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
     D ACTIONFDTA     UDS           256
     D SYSFIL                  1     10
     D UPDFIL                 31     40
      *
      ** Data Area in QTEMP giving report header data
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY GPCPYSRCG,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D Header          C                   'Report of the differences between -
     D                                     the Existing System Record and the -
     D                                     Replacement Record'
 
     D Counter         C                   '---------+---------+---------+------
     D                                     ----+---------+---------+---------+--
     D                                     --------+---------+---------+'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D UpdatArray      S              1A   DIM(93)
 
     D SysArray        S              1A   DIM(93)
 
     D ErrorArray      S              1A   DIM(93)
 
      ** Data Structure for the Update file
     D                 DS
     D UP_MLHYID
     D NCU_MLID                      10
     D NCU_MLENDID                   10
     D UP_MLGRPID
     D UP_MLLEVEL
     D UP_MLPARENT
     D UP_MLMENUCODE
     D  Updfield               1     93A
     D  UPDLIN1                1     93A
 
      ** Data Structure for the Core file
     D                 DS
     D SYS_MLHYID
     D NCS_MLID                      10
     D NCS_MLENDID                   10
     D SYS_MLGRPID
     D SYS_MLLEVEL
     D SYS_MLPARENT
     D SYS_MLMENUCODE
     D  CoreFld                1     93A
     D  SYSLIN1                1     93A
 
      ** Output Data Structure for the Update file
     D                 DS
     D UP_MLHYID_O                    9
     D UP_MLID_O                           LIKE(NCU_MLID)
     D UP_MLENDID_O                        LIKE(NCU_MLENDID)
     D UP_MLGRPID_O                  20
     D UP_MLLEVEL_O                   4
     D UP_MLPARENT_O                 20
     D UP_MLMENUCOD_O                      LIKE(UP_MLMENUCODE)
     D  UPDLIN1_O              1     93A
 
      ** Output Data Structure for the Core file
     D                 DS
     D SYS_MLHYID_O                   9
     D SYS_MLID_O                          LIKE(NCS_MLID)
     D SYS_MLENDID_O                       LIKE(NCS_MLENDID)
     D SYS_MLGRPID_O                 20
     D SYS_MLLEVEL_O                  4
     D SYS_MLPARENT_O                20
     D SYS_MLMENUCO_O                      LIKE(SYS_MLMENUCODE)
     D  SYSLIN1_O              1     93A
 
      ** Data Structure for the Error indicators
     D                 DS            93
     D  Indfld                 1     93A
     D  INDLIN1                1     93A
 
     DSPOOL            DS
     D SFILE                  83     92
     D SFNUM                 123    124B 0
     D OFLLN                 188    189B 0
     D PRTLN                 367    368B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D KEY_MLHYID      S                   LIKE(UP_MLHYID)                      key field in KEY
     D KEY_MLGRPID     S                   LIKE(UP_MLGRPID)                     key field in KEY
     D KEY_MLLEVEL     S                   LIKE(UP_MLLEVEL)                     key field in KEY
     D KEY_MLPARENT    S                   LIKE(UP_MLPARENT)                    key field in KEY
     D KEY_MLMENUCODE  S                   LIKE(UP_MLMENUCODE)                  key field in KEY
     D SACTC           S                   LIKE(UP_MLACTC)
     D SHYID           S                   LIKE(UP_MLHYID)
     D SID             S                   LIKE(UP_MLID)
     D SGRPID          S                   LIKE(UP_MLGRPID)
     D SLEVEL          S                   LIKE(UP_MLLEVEL)
     D SPARENT         S                   LIKE(UP_MLPARENT)
     D SMENUCODE       S                   LIKE(UP_MLMENUCODE)
     D UPK_MLACTC      S                   LIKE(UP_MLACTC)                      key field in UP_Key
     D UPK_MLHYID      S                   LIKE(UP_MLHYID)                      key field in UP_Key
     D UPK_MLGRPID     S                   LIKE(UP_MLGRPID)                     key field in UP_Key
     D UPK_MLLEVEL     S                   LIKE(UP_MLLEVEL)                     key field in UP_Key
     D UPK_MLPARENT    S                   LIKE(UP_MLPARENT)                    key field in UP_Key
     D UPK_MLMENUCODE  S                   LIKE(UP_MLMENUCODE)                  key field in UP_Key
     D X               S              5  0
     D ACTION          S              7
     D RMLN            S              2  0
     D Amends          S              5  1
     D COUNT           S            100
     D WAmends         S              5  1
     D Remainder       S              1
     D LineCount       S              2  0                                      for UP1728P1
     D #GRPID20        S             20                                         #RGPID in 20A.
     D #KGRPID20       S             20                                         #KRGPID in 20A.
     D PrintedActC     S                   LIKE(UP_MLACTC)                      Action code Printed
     D PosDataExist    S              1                                         Y, Pos. Data Exist
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      * Fill fields not to be compared with '='s, so that they  will not be
      * any different between the system file and the update file.
     C                   EVAL      NCU_MLID    = '=========='
     C                   EVAL      NCS_MLID    = '=========='
     C                   EVAL      NCU_MLENDID = '=========='
     C                   EVAL      NCS_MLENDID = '=========='
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Sub Routine to check that there are an equal number or Amends
      ** before running reports.
      *
     C                   EXSR      CHKA
 
      *There was no problem with an Odd number of Amends
     C                   IF        *IN60 = '0'
      * Set up key list to access GPGMULL0
     C     KEY           KLIST
     C                   KFLD                    KEY_MLHYID
     C                   KFLD      *IN51         KEY_MLGRPID
     C                   KFLD                    KEY_MLLEVEL
     C                   KFLD                    KEY_MLPARENT
     C                   KFLD      *IN52         KEY_MLMENUCODE
      *
      * Set up key list to access UPGMULL0
     C     UP_Key        KLIST
     C                   KFLD                    UPK_MLACTC
     C                   KFLD                    UPK_MLHYID
     C                   KFLD      *IN51         UPK_MLGRPID
     C                   KFLD                    UPK_MLLEVEL
     C                   KFLD                    UPK_MLPARENT
     C                   KFLD      *IN52         UPK_MLMENUCODE
      *
     C                   READ      UPGMULL0                             3031
      *
      * If an Error or End of file reached
     C                   IF        *IN30 = '1'
      *
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'UPGMULL0'
     C                   MOVE      UP_MLID       DBKEY
     C                   MOVEL     UP_MLHYID     DBKEY
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/MAIN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *
     C                   WRITE     HEADH                                70
     C                   EVAL      LineCount = 0
     C                   EVAL      PrintedActC  = *BLANK
      *
      * Do while a record exists
     C                   DOW       *IN31 = '0'
     C                   EVAL      ACTION = *BLANKS
     C                   EVAL      Indfld = *BLANKS
      *
      * If Action Code is Insert
     C                   IF        UP_MLACTC = 'I'
     C                   EVAL      KEY_MLHYID      = UP_MLHYID
     C                   EVAL      KEY_MLGRPID     = UP_MLGRPID
     C                   EVAL      KEY_MLLEVEL     = UP_MLLEVEL
     C                   EVAL      KEY_MLPARENT    = UP_MLPARENT
     C                   EVAL      KEY_MLMENUCODE  = UP_MLMENUCODE
      *
     C                   EVAL      *IN51  = %NULLIND(UP_MLGRPID)
     C                   EVAL      *IN52  = %NULLIND(UP_MLMENUCODE)
      *
     C     KEY           CHAIN     GPGMULL0                           32
      *
      * If a record is found on the chain then print out a message
     C                   IF        *IN32 = '0'
      *
      * If the two records are different - Move along Character by Character indicating
      * differences on the third Array (ErrorArray) ELSE the record saying Identical
     C                   IF        CoreFld <> Updfield
     C                   MOVEA     Updfield      UpdatArray
     C                   MOVEA     CoreFld       SysArray
     C                   CLEAR                   ErrorArray
     C                   Z-ADD     1             X
     C                   DOU       X > 93
     C     SysArray(X)   COMP      UpdatArray(X)                          43
      *
     C                   IF        *IN43 = '0'                                  Difference spotted
     C                   EVAL      *IN39 = '1'
     C                   MOVEA     '*'           ErrorArray(X)
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
      * Move error indicator array to field for output
     C                   MOVEA     ErrorArray    IndFld
      *
     C                   MOVEL     'INSERT'      ACTION
     C                   EXSR      REPORT
     C                   EVAL      *IN40 = '1'
     C                   ELSE
     C                   EVAL      *IN42 = '1'
     C                   MOVEL     'INSERT'      ACTION
     C                   EXSR      REPORT
     C                   EVAL      *IN40 = '1'
     C                   ENDIF
     C                   ENDIF                                                  FI *IN32 = '0'
      *
      * Check if the positional data of the insert record is on file GPGMULL0.
     C                   EXSR      ChkPosDExist
      *
     C                   ENDIF                                                  FI UP_MLACTC = 'I'
      *
      * If Action Code is Delete
     C                   IF        UP_MLACTC = 'D'
     C                   EVAL      KEY_MLHYID      = UP_MLHYID
     C                   EVAL      KEY_MLGRPID     = UP_MLGRPID
     C                   EVAL      KEY_MLLEVEL     = UP_MLLEVEL
     C                   EVAL      KEY_MLPARENT    = UP_MLPARENT
     C                   EVAL      KEY_MLMENUCODE  = UP_MLMENUCODE
      *
     C                   EVAL      *IN51  = %NULLIND(UP_MLGRPID)
     C                   EVAL      *IN52  = %NULLIND(UP_MLMENUCODE)
      *
     C     KEY           CHAIN     GPGMULL0                           33
      *
      * If a file is not found on the chain print out a message
     C                   IF        *IN33 = '1'
     C                   MOVEL     'DELETE'      ACTION
     C                   EXSR      REPORT
     C                   EVAL      *IN40 = '1'
     C                   ELSE
      *
      * If the two records are different - Move along Character by Character indicating
      * differences on the third Array (ErrorArray)
     C                   IF        Corefld <> Updfield
     C                   MOVEA     Updfield      UpdatArray
     C                   MOVEA     CoreFld       SysArray
     C                   CLEAR                   ErrorArray
     C                   Z-ADD     1             X
     C                   DOU       X > 93
     C     SysArray(X)   COMP      UpdatArray(X)                          36
      *
     C                   IF        *IN36 = '0'
     C                   EVAL      *IN34 = '1'
     C                   MOVEA     '*'           ErrorArray(X)
     C                   EndIf
     C                   ADD       1             X
     C                   EndDo
      * Move error indicator array to field for output
     C                   MOVEA     ErrorArray    IndFld
      *
      * Write out all three data structures with the indicator showing
      * where the error is
     C                   MOVEL     'DELETE'      ACTION
     C                   EXSR      REPORT
     C                   EVAL      *IN40 = '1'
     C                   ENDIF                                                  FI Corefld<>Updfield
     C                   ENDIF                                                  FI *IN33 = '1'
     C                   ENDIF                                                  FI UP_MLACTC = 'D'
      *
      * If Action Code is Move
     C                   IF        UP_MLACTC = 'M'
      *
     C                   EVAL      KEY_MLHYID      = UP_MLHYID
     C                   EVAL      KEY_MLGRPID     = UP_MLGRPID
     C                   EVAL      KEY_MLLEVEL     = UP_MLLEVEL
     C                   EVAL      KEY_MLPARENT    = UP_MLPARENT
     C                   EVAL      KEY_MLMENUCODE  = UP_MLMENUCODE
      *
     C                   EVAL      *IN51  = %NULLIND(UP_MLGRPID)
     C                   EVAL      *IN52  = %NULLIND(UP_MLMENUCODE)
      *
     C     KEY           CHAIN     GPGMULL0                           33
      *
      * If the record is not found on the chain print out a message
     C                   IF        *IN33 = '1'
     C                   MOVEL     'MOVE'        ACTION
     C                   EXSR      REPORT
     C                   EVAL      *IN40 = '1'
     C                   ELSE
      *
      * If the two records are different - Move along Character by Character indicating
      * differences on the third Array (ErrorArray)
     C                   IF        Corefld <> Updfield
     C                   MOVEA     Updfield      UpdatArray
     C                   MOVEA     CoreFld       SysArray
     C                   CLEAR                   ErrorArray
     C                   Z-ADD     1             X
     C                   DOU       X > 93
     C     SysArray(X)   COMP      UpdatArray(X)                          36
      *
     C                   IF        *IN36 = '0'
     C                   EVAL      *IN34 = '1'
     C                   MOVEA     '*'           ErrorArray(X)
     C                   EndIf
     C                   ADD       1             X
     C                   EndDo
      * Move error indicator array to field for output
     C                   MOVEA     ErrorArray    IndFld
      *
      * Write out all three data structures with the indicator showing
      * where the error is
     C                   MOVEL     'MOVE'        ACTION
     C                   EXSR      REPORT
     C                   EVAL      *IN40 = '1'
     C                   ENDIF                                                  FI Corefld<>Updfield
     C                   ENDIF                                                  FI *IN33 = '1'
      *
      * Check if the positional data for the move record is on file GPGMULL0.
     C                   EXSR      ChkPosDExist
      *
     C                   ENDIF                                                  FI UP_MLACTC = 'M'
      *
     C                   IF        UP_MLACTC = 'A'
     C                   EVAL      KEY_MLHYID      = UP_MLHYID
     C                   EVAL      KEY_MLGRPID     = UP_MLGRPID
     C                   EVAL      KEY_MLLEVEL     = UP_MLLEVEL
     C                   EVAL      KEY_MLPARENT    = UP_MLPARENT
     C                   EVAL      KEY_MLMENUCODE  = UP_MLMENUCODE
      *
     C                   EVAL      *IN51  = %NULLIND(UP_MLGRPID)
     C                   EVAL      *IN52  = %NULLIND(UP_MLMENUCODE)
      *
     C     KEY           CHAIN     GPGMULL0                           35
      *
      * If a file is not found on the chain print out a message
     C                   IF        *IN35 = '1'
     C                   MOVEL     'AMEND'       ACTION
     C                   EXSR      REPORT
     C                   EVAL      *IN40 = '1'
      * Because amends come in pairs read the after image of amend.
     C                   READ      UPGMULL0                               31
     C                   ELSE
      *
      * If the before image record and core record are different, read
      * the after amend image record and compare it with the core record.
     C                   IF        CoreFld <> Updfield             OR
     C                             %NULLIND(SYS_MLGRPID) <> *IN51  OR
     C                             %NULLIND(SYS_MLMENUCODE) <> *IN52
      *
     C                   READ      UPGMULL0                               31
      *
     C                   EVAL      *IN51  = %NULLIND(UP_MLGRPID)
     C                   EVAL      *IN52  = %NULLIND(UP_MLMENUCODE)
      *
      * If The two records are different - Move along Character by Character indicating
      * differences on the third Array (ErrorArray)
     C                   IF        CoreFld <> Updfield             OR
     C                             %NULLIND(SYS_MLGRPID) <> *IN51  OR
     C                             %NULLIND(SYS_MLMENUCODE) <> *IN52
     C                   MOVEA     Updfield      UpdatArray
     C                   MOVEA     CoreFld       SysArray
     C                   CLEAR                   ErrorArray
     C                   Z-ADD     1             X
     C                   DOU       X > 93
     C     SysArray(X)   COMP      UpdatArray(X)                          38
      *
     C                   IF        ((X > 45) and (X < 64)) OR                   Pos. of MLGRPID
     C                             ((X > 85) and (X < 96))                      Pos of MLMENUCOD
     C   38              EXSR      ChkFldWithNull
     C   38              EVAL      *IN38 = *IN55
     C                   ENDIF
     C                   IF        *IN38 = '0'
     C                   EVAL      *IN36 = '1'
     C                   MOVEA     '*'           ErrorArray(X)
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
      * Move error indicator array to field for output
     C                   MOVEA     ErrorArray    IndFld
      *
      * Write out all three data structures with the indicator showing
      *  where the error is.
      * Write the after image data.
     C                   MOVEL     'AMEND'       ACTION
     C                   EXSR      REPORT
     C                   EVAL      *IN40 = '1'
     C                   ENDIF
     C                   ELSE
      *  If the before image record is same as core record,
      *  read the after image record but nothing is done.
     C                   READ      UPGMULL0                               31
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                  FI MLACTC = 'A'
      *
     C                   MOVEA     '000000000'   *IN(30)
     C                   MOVEA     '0'           *IN(39)
     C                   MOVEA     '00'          *IN(41)
      *
     C                   READ      UPGMULL0                             3031
      *
      * If an Error
     C                   IF        *IN30 = '1'
      *
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'UPGMULL0'
     C                   MOVE      UP_MLID       DBKEY
     C                   MOVEL     UP_MLHYID     DBKEY
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/MAIN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      * If there are no differences between the two files UP and Sys
      * Print No Differences ...
     C                   IF        *IN40 = '0'
     C                   WRITE     NODIFS                               70
     C                   ENDIF
      *
      * If all positional data for insert/move link menu found, print no details to report.
     C                   IF        *IN58 = *OFF
     C                   WRITE     HEADHNP
     C                   WRITE     NORECNP
     C                   ENDIF
      *
      * ... else Error in No of Amend Records
     C                   ELSE
     C                   WRITE     HEADH
     C                   WRITE     AMENDERR
     C                   ENDIF
      *
     C                   WRITE     TRAILP                               70
     C                   WRITE     TRAILPNP
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkPosDExist - Check if the positional data will be on file   *
      *                GPGMULL0 when inserting/moving a record.       *
      *                If not, report to UP1728P1.                    *
      *                                                               *
      * Called by: Main Prcessing for each insert and move link rec   *
      *                                                               *
      * Calls:     ChkIfInsDel                                        *
      *                                                               *
      *****************************************************************
 
     C     ChkPosDExist  BEGSR
      *
      *   Set up key list (KEY) to access GPGMULL0.
     C                   EVAL      KEY_MLHYID      = UP_MLKHYID
     C                   EVAL      KEY_MLGRPID     = UP_MLKGRPID
     C                   EVAL      KEY_MLLEVEL     = UP_MLKLEVEL
     C                   EVAL      KEY_MLPARENT    = UP_MLKPARENT
     C                   EVAL      KEY_MLMENUCODE  = UP_MLKMENUCOD
      *
     C                   EVAL      *IN51  = %NULLIND(UP_MLKGRPID)
     C                   EVAL      *IN52  = %NULLIND(UP_MLKMENUCOD)
      *
     C     KEY           CHAIN     GPGMULL0                           56        RNF
      *
      * Check if the positional record will be inserted or deleted on
      * UPGMULL0.
     C                   EXSR      ChkIfInsDel
      *
      * If the positional data will be exist on file GPGMULL0, exit this subroutine.
     C                   IF        PosDataExist = 'Y'
     C                   GOTO      ChkPosDExistE
     C                   ENDIF                                                  FI PosDataExist =Y
      *
      * Report no positional data:
      *
      * Set on positional data reported indicator
     C                   EVAL      *IN58 = *ON
      *
      * Set up report lines
     C                   EVAL      #HYID       = UP_MLHYID
     C*
     C                   IF        %NULLIND(UP_MLGRPID)
     C                   EVAL      #GRPID      =  '= null value'
     C                   ELSE
     C                   EVAL      #GRPID20    = %EDITC(UP_MLGRPID:'3')
     C                   MOVE      #GRPID20      #GRPID
     C                   ENDIF
      *
     C                   EVAL      #LEVEL      =  UP_MLLEVEL
     C                   EVAL      #PARENT     = UP_MLPARENT
      *
     C                   IF        %NULLIND(UP_MLMENUCODE)
     C                   EVAL      #MENUCODE   = '= null value'
     C                   ELSE
     C                   EVAL      #MENUCODE   = UP_MLMENUCODE
     C                   ENDIF
      *
     C                   MOVE      UP_MLPOS      #POS
     C                   EVAL      #KHYID       = UP_MLKHYID
      *
     C                   IF        %NULLIND(UP_MLKGRPID)
     C                   EVAL      #KGRPID      =  '= null value'
     C                   ELSE
     C                   EVAL      #KGRPID20    = %EDITC(UP_MLKGRPID:'3')
     C                   MOVE      #KGRPID20     #KGRPID
     C                   ENDIF
      *
     C                   EVAL      #KLEVEL     = UP_MLKLEVEL
     C                   EVAL      #KPARENT    = UP_MLKPARENT
      *
     C                   IF        %NULLIND(UP_MLKMENUCOD)
     C                   EVAL      #KMENUCODE  = '= null value'
     C                   ELSE
     C                   EVAL      #KMENUCODE  = UP_MLKMENUCOD
     C                   ENDIF
      *
      * Print no position data record to UP1728P1:
      *
      * If full page already printed or new action, start a new page and
      * set indicator to print column heading.
     C                   IF        LineCount > 55   OR
     C                             PrintedActC <> UP_MLACTC
     C                   WRITE     HEADHNP
     C                   EVAL      LineCount = 5
     C                   EVAL      *IN47     = *ON                              To print col. head
     C                   ENDIF
      *
      * Set indicators to print 'Moved' or 'Inserted' records heading.
     C                   IF        UP_MLACTC  = 'I'
     C                   EVAL      *IN45  = *ON                                 Insert
     C                   EVAL      *IN46  = *OFF
     C                   ENDIF
      *
     C                   IF        UP_MLACTC  = 'M'
     C                   EVAL      *IN45  = *OFF
     C                   EVAL      *IN46  = *ON
     C                   ENDIF
      *
     C                   WRITE     DTLNP
      *
     C                   IF        *IN47 = *ON                                  To print col. head
     C                   EVAL      LineCount = LineCount + 7
     C                   EVAL      *IN47     = *OFF
     C                   EVAL      PrintedActC = UP_MLACTC
     C                   ELSE
     C                   EVAL      LineCount = LineCount + 2
     C                   ENDIF
      *
     C     ChkPosDExistE ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkIfInsDel: Check if the positinal data will be inserted     *
      *              or deleted record on UPGMULL0 before this insert *
      *              or move.                                         *
      *                                                               *
      * Called by:   ChkPosDExist                                     *
      *                                                               *
      * Calls:       None.                                            *
      *                                                               *
      *****************************************************************
 
     C     ChkIfInsDel   BEGSR
      *
     C                   EVAL      PosDataExist    = ' '
      *
      *   Save key fields of the action file record being processed.
     C                   EVAL      SACTC           = UP_MLACTC
     C                   EVAL      SHYID           = UP_MLHYID
     C                   EVAL      SID             = UP_MLID
     C                   EVAL      SGRPID          = UP_MLGRPID
     C                   EVAL      SLEVEL          = UP_MLLEVEL
     C                   EVAL      SPARENT         = UP_MLPARENT
     C                   EVAL      SMENUCODE       = UP_MLMENUCODE
     C                   EVAL      *IN53           = %NULLIND(UP_MLGRPID)
     C                   EVAL      *IN54           = %NULLIND(UP_MLMENUCODE)
      *
      *   Set up key list (UP_KEY) to access UPGMULL0:
      *
      *     No record found in GPGMULL0.  Check if the positional data record will
      *     be inserted in the action file.
     C                   IF        *IN56 = *ON
     C                   EVAL      UPK_MLACTC   = 'I'
     C                   ELSE
      *     Record found in GPGMULL0.  Check for any delete action of the positional
      *     data record.
     C                   EVAL      UPK_MLACTC   = 'D'
     C                   ENDIF
      *
     C                   EVAL      UPK_MLHYID      = UP_MLKHYID
     C                   EVAL      UPK_MLGRPID     = UP_MLKGRPID
     C                   EVAL      UPK_MLLEVEL     = UP_MLKLEVEL
     C                   EVAL      UPK_MLPARENT    = UP_MLKPARENT
     C                   EVAL      UPK_MLMENUCODE  = UP_MLKMENUCOD
      *
     C                   EVAL      *IN51  = %NULLIND(UP_MLKGRPID)
     C                   EVAL      *IN52  = %NULLIND(UP_MLKMENUCOD)
      *
     C     UP_KEY        CHAIN     UPGMULL0                           56        RNF
      *
     C                   IF        *IN56       = *ON
     C                   IF        UPK_MLACTC  = 'D'                            No 'D' action rec
     C                   EVAL      PosDataExist  = 'Y'
     C                   ELSE                                                   No 'I' action rec
     C                   EVAL      PosDataExist  = 'N'
     C                   ENDIF                                                  FI UPK_MLACTC  = 'D'
      *
     C                   ELSE
     C                   IF        UPK_MLACTC    = 'D'                          'D' action rec found
     C                   EVAL      PosDataExist  = 'N'
     C                   ELSE                                                   'I' action rec found
     C                   EVAL      PosDataExist  = 'Y'
      * But if the inserted positional data will be done after this insert, still
      * no positional data.
     C                   IF        SACTC    = 'I'
     C                   IF        (UP_MLHYID = SHYID  AND
     C                             UP_MLID >= SID) OR
     C                             UP_MLHYID > SHYID
     C                   EVAL      PosDataExist  = 'N'
     C                   ENDIF                                                  FI UP_MLHYID=SHYID..
     C                   ENDIF                                                  FI SHYID = 'I'
      *
     C                   ENDIF                                                  FI UPK_MLACTC='D'
      *
     C                   ENDIF                                                  FI *IN56 = *ON
      *
      * Set the pointer back to the saved action file record being processed.
     C                   EVAL      UPK_MLACTC      = SACTC
     C                   EVAL      UPK_MLHYID      = SHYID
     C                   EVAL      UPK_MLGRPID     = SGRPID
     C                   EVAL      UPK_MLLEVEL     = SLEVEL
     C                   EVAL      UPK_MLPARENT    = SPARENT
     C                   EVAL      UPK_MLMENUCODE  = SMENUCODE
      *
     C                   EVAL      *IN51  = *IN53
     C                   EVAL      *IN52  = *IN54
      *
     C     UP_KEY        CHAIN     UPGMULL0                           57        RNF
     C   57              EXSR      *PSSR
      *
     C     ChkIfInsDelE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkFldWithNull - Compare the null field indicators for the    *
      *                  fields which allow null values.              *
      *                  If difference, set *IN55 off.                *
      *                                                               *
      * Called by: Main Prcessing                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     ChkFldWithNullBEGSR
      *
     C                   EVAL      *IN55 = *ON
      *
      * Check for the null values of MHDELETED and MHDEFAULT
     C                   SELECT
      *
     C                   WHEN      ((X > 45) and (X < 64))                      Pos of MLGRPID
     C                   IF        %NULLIND(SYS_MLGRPID) <> *IN51
     C                   EVAL      *IN55 = *OFF
     C                   ENDIF
      *
     C                   WHEN      ((X > 85) and (X < 96))                      Pos of MLMENUCOD
     C                   IF        %NULLIND(SYS_MLMENUCODE) <> *IN52
     C                   EVAL      *IN55 = *OFF
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * REPORT - WRITE To the printer file                            *
      *                                                               *
      * Called by: Main Prcessing                                     *
      *                                                               *
      * Calls: CvtUpdFile                                             *
      *        CvtSysFile                                             *
      *                                                               *
      *****************************************************************
 
     C     REPORT        BEGSR
      *
      *
     C                   IF        (*IN33 = '1') OR
     C                             (*IN35 = '1') OR
     C                             (*IN42 = '1')
      * Overflow check for an Insert that exists or an Amend/Delete that is missing
     C                   EXSR      OFLOW
      *
      * Convert data structure of the update file to output format
     C                   EXSR      CvtUpdFile
      *
      * Write the record
     C                   MOVEL     *BLANKS       UPDLIN
     C                   MOVEL     *BLANKS       COUNT
     C                   MOVEL     UPDLIN1_O     UPDLIN
     C                   MOVEL     Counter       COUNT
     C                   WRITE     DTL1                                 70
      * Set Off *IN41
     C                   EVAL      *IN41 ='0'
     C                   ENDIF
      *
     C                   IF        (*IN34 = '1') OR
     C                             (*IN36 = '1') OR
     C                             (*IN39 = '1')
      *
      * Overflow check for an Insert that exists or an Amend/Delete that is missing
     C                   EXSR      OFLOW2
      *
      * Convert data structure of the update file to output format
     C                   EXSR      CvtUpdFile
      * Convert data structure of the system file to output format
     C                   EXSR      CvtSysFile
      *
      * Write the record
     C                   MOVEL     *BLANKS       SYSLIN
     C                   MOVEL     *BLANKS       UPDLIN
     C                   MOVEL     *BLANKS       INDLIN
     C                   MOVEL     *BLANKS       COUNT
     C                   MOVEL     UPDLIN1_O     UPDLIN
     C                   MOVEL     INDLIN1       INDLIN
     C                   MOVEL     SYSLIN1_O     SYSLIN
     C                   MOVEL     Counter       COUNT
     C                   WRITE     DTL2                                 70
      * Set Off *IN41
     C                   EVAL      *IN41 ='0'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CvtUpdFile - Convert the data structure of update file        *
      *              (UPDLIN1) to be in output format (UPDLIN1_O).    *
      *              The leading zero of numeric fields is suppressed *
      *              to blank.                                        *
      *                                                               *
      * Called by: REPORT                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     CvtUpdFile    BEGSR
      *
     C                   EVAL      UP_MLHYID_O     = %EDITC(UP_MLHYID:'3')
     C                   EVAL      UP_MLID_O       = NCU_MLID
     C                   EVAL      UP_MLENDID_O    = NCU_MLENDID
     C                   EVAL      UP_MLGRPID_O    = %EDITC(UP_MLGRPID:'Z')
     C                   EVAL      UP_MLLEVEL_O    = %EDITC(UP_MLLEVEL:'3')
     C                   EVAL      UP_MLPARENT_O   = %EDITC(UP_MLPARENT:'3')
     C                   EVAL      UP_MLMENUCOD_O  = UP_MLMENUCODE
 
     C     CvtUpdFileE   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CvtSysFile - Convert the data structure of system file        *
      *              (SYSLIN1) to be in output format (SYSLIN1_O).    *
      *              The leading zero of numeric fields is converted  *
      *              to blank.                                        *
      *                                                               *
      * Called by: REPORT                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     CvtSysFile    BEGSR
      *
     C                   EVAL      SYS_MLHYID_O     = %EDITC(SYS_MLHYID:'3')
     C                   EVAL      SYS_MLID_O       = NCS_MLID
     C                   EVAL      SYS_MLENDID_O    = NCS_MLENDID
     C                   EVAL      SYS_MLGRPID_O    = %EDITC(SYS_MLGRPID:'Z')
     C                   EVAL      SYS_MLLEVEL_O    = %EDITC(SYS_MLLEVEL:'3')
     C                   EVAL      SYS_MLPARENT_O   = %EDITC(SYS_MLPARENT:'3')
     C                   EVAL      SYS_MLMENUCO_O   = SYS_MLMENUCODE
 
     C     CvtSysFileE   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * OFLOW - OVERFLOW Processing  for fields that                  *
      *                 For Inserts that are there and Amends and     *
      *                 Deletes that are missing                      *
      *                                                               *
      * Called by: Main Prcessing                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     OFLOW         BEGSR
      *
     C     OFLLN         SUB       PRTLN         RMLN
     C                   IF        RMLN <= 8
     C                   WRITE     HEADH                                70
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * OFLOW2- OVERFLOW Processing for differences on >200 chars     *
      *         with file differences                                 *
      *                                                               *
      * Called by: Main Prcessing                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     OFLOW2        BEGSR
      *
     C     OFLLN         SUB       PRTLN         RMLN
     C                   IF        RMLN <= 14
     C                   WRITE     HEADH                                70
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CHKA  - Check there are an even number of Amend Records       *
      *         with file differences                                 *
      *                                                               *
      * Called by: Main Prcessing                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     CHKA          BEGSR
      *
     C                   READ      UPGMULL0                               70
     C                   DOW       *IN70 = '0'
     C                   IF        UP_MLACTC = 'A'
     C                   ADD       1             Amends
     C                   ENDIF
     C                   READ      UPGMULL0                               70
     C                   ENDDO
      *
      * Check to see if the No. of Amends is divisible by 2 and not equal 0
     C                   IF        Amends <> 0
     C     Amends        DIV       2             WAmends
     C                   MOVE      WAmends       Remainder
      * If the remainder is ='5' Set on indicator to stop File processing
     C                   IF        REMAINDER ='5'
     C                   EVAL      *IN60 = '1'
     C                   ENDIF
     C                   ENDIF
     C     *START        SETLL     UPGMULL0
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
      * Initialise program name
      *
     C                   MOVEL     'UP1728'      DBPGM
      *
     C                   MOVEL     HEADER        HEAD
      * Open files
     C                   OPEN      UPGMULL0
     C                   OPEN      GPGMULL0
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
