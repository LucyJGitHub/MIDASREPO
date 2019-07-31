     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Trigger for RSACMTPD')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE007011 - Trigger for RSACMTPD                              *
      *                                                               *
      *  Function:  This program updates the log file GLPDCLTD for    *
      *             each insert to RSACMTPD.                          *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. MD022132 *CREATE   Date 09Mar18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD022132 - Triggers don't pick up Rollback deletes of ABC    *
      *             files.                                            *
      *           - Applied for MD-35969.                             *
      *                                                               *
      *****************************************************************
      *                                                               *
     FGLPDCLTD  O    E             DISK    COMMIT
      ** Midas GL PDC ID Log File

      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR      - Error processing                                 *
      * *INZSR     - Initialise                                       *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

     D GPRESERVID      DS
      ** Data Area containing PDC ID
     D  RESERVID               1     15

     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D PARM1           DS
      ** First entry parameter

     D  PFlName                1     10
      ** Physical file name

     D  MbrName               21     30
      ** Member name

     D  TrgEvent              31     31
      ** Trigger event 1=Insert, 2=Delete, 3=Update, 4=Read

     D  TrgTime               32     32
      ** Trigger time  1=After, 2=Before

     D  BOff                  49     52B 0
      ** Offset to the before image of the record

     D  BLen                  53     56B 0
      ** Length of the before image of the record

     D  AOff                  65     68B 0
      ** Offset to the after image of the record

     D  ALen                  69     72B 0
      ** Length of the after image of the record

     D  EntryData            117  10117A
      ** Images

     D PARM2           DS
      ** Second entry parameter

     D  Leng                   1      4B 0

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WRun            S              1
     D Pos             S              5U 0
     D Pos2            S              5U 0
     D Rsvsav          S             15

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Retrieve PDC ID from Data Area and write it to Log File

     C                   IN        GPRESERVID

     C                   EVAL      Pos = %SCAN(' ' : RESERVID)

     C                   IF        Pos = 0
     C                   EVAL      PDCLID = RESERVID
     C                   ELSE
     C                   EVAL      Pos2 = 17 - Pos
     C                   EVAL      Pos = Pos - 1
     C                   EVAL      Rsvsav = '000000000000000'
     C                   EVAL      %SUBST(Rsvsav : Pos2 : Pos) = RESERVID
     C                   EVAL      PDCLID = Rsvsav
     C                   ENDIF
     C                   WRITE     GLPDCLT0

      ** Terminate Program

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2

      ** Read in data areas

     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE                  GPRESERVID

     C                   ENDSR

      *****************************************************************
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

     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      *****************************************************************
