     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GL User Access Audit File Purge')                *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000183 - User Access Audit File Purge                      *
      *                                                               *
      *  Function:  This program will drop records from REEAUDPP that *
      *             are outside the defined retention period.         *
      *                                                               *
      *  Called By: GLC000183 - User Access Audit File Purge          *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL183    *Create  Date 09Dec16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL183 - User Access Audit of Account Enquiry functions      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    60         End-of-File Indicator                           *
      *    99         Error Indicator                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  Main routine                                                 *
      *  SRInit    - Initialise                                       *
      *  *PSSR     - Error handling subroutine                        *
      *  SRProcess - Drop records from REEAUDPP that                  *
      *              are outside the defined retention period         *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+


      *****************************************************************
      /EJECT
      *****************************************************************
     D/COPY ZSRSRC,ZDATE9Z1LE
     D/COPY ZSRSRC,ZDATE9Z2LE
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Short data structure for access objects
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** The Following /COPY Line Includes All The Defined Fields In
      ** The PSDS.  They Have Meaningful Names, Prefixed By 'PS'.
     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ Arrays AND Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Local data area for database error details
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D  DBTXT                184    256

      ** Data structure for TIME
     D                 DS
     D TimeStmp                1     26Z
     D DateYYYY                1      4  0
     D DateMM                  6      7  0
     D DateDD                  9     10  0

      ** Data structure for DateYYYYMMDD
     D                 DS
     D DatYYYYMMDD             1      8  0
     D DatYYYY                 1      4  0
     D DatMM                   5      6  0
     D DatDD                   7      8  0

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D P@OP01          S             20
     D P@VL01          S            200
     D P@OP02          S             20
     D P@VL02          S            200
     D P@OP03          S             20
     D P@VL03          S            200
     D P@OP04          S             20
     D P@VL04          S            200
     D P@OP05          S             20
     D P@VL05          S            200
     D P@OP06          S             20
     D P@VL06          S            200
     D P@OP07          S             20
     D P@VL07          S            200
     D P@OP08          S             20
     D P@VL08          S            200
     D P@OP09          S             20
     D P@VL09          S            200
     D P@OP10          S             20
     D P@VL10          S            200

     D WRun            S              1A
     D PRtCd           S              7A
     D POptn           S              7A
     D RtNCode         S              1
     D WRetPrd         S              3
     D WRetPrdN        S              3  0
     D WTranRetPrd     S              5  0
     D CalDate         S              5  0
     D WDatPurge       S              8  0

      *****************************************************************
      /EJECT
      *****************************************************************
      *  MAIN - Processing                                            *
      *****************************************************************

     C/exec SQL
     C+ set option commit = *CHG
     C/end-exec

      ** Perform Initialisation

     C                   Exsr      SRInit

      ** Perform Detail Processing

     C                   Exsr      SRProcess

     C                   Eval      *INLR = *ON
     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcess - Subroutine to drop records from REEAUDPP that     *
      *             are outside the defined retention period          *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRProcess     BEGSR

     C/exec SQL
     C+ Delete from REEAUDPP
     C+ where LG1DAT < :WDatPurge
     C/end-exec

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Subroutine to do Program Initialisation              *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: AOBANKR0, AOSVALR0                                     *
      *                                                               *
      *****************************************************************

     C     SRInit        BEGSR

      ** Read in data area

     C     *DTAARA       Define                  LDA

     C     *LOCK         In        LDA
     C                   Eval      DBPgm  = 'GL000183'
     C                   Eval      DBFile = *Blanks
     C                   Eval      DBKey  = *Blanks
     C                   Eval      DBTxt  = *Blanks
     C                   Eval      DBase  = 0
     C                   Out       LDA

      ** Call Access Program for System Value - UserEnqAccessAuditRt

     C                   EVAL      P@OP01 = 'UserEnqAccessAuditRt'
     C                   Call      'AOSVALR0'
     C                   Parm      *BLANKS       PRtCd
     C                   Parm                    P@OP01
     C                   Parm      *BLANKS       P@VL01
     C                   Parm                    P@OP02
     C                   Parm      *BLANKS       P@VL02
     C                   Parm                    P@OP03
     C                   Parm      *BLANKS       P@VL03
     C                   Parm                    P@OP04
     C                   Parm      *BLANKS       P@VL04
     C                   Parm                    P@OP05
     C                   Parm      *BLANKS       P@VL05
     C                   Parm                    P@OP06
     C                   Parm      *BLANKS       P@VL06
     C                   Parm                    P@OP07
     C                   Parm      *BLANKS       P@VL07
     C                   Parm                    P@OP08
     C                   Parm      *BLANKS       P@VL08
     C                   Parm                    P@OP09
     C                   Parm      *BLANKS       P@VL09
     C                   Parm                    P@OP10
     C                   Parm      *BLANKS       P@VL10

      ** Handle Database Error

     C                   If        PRtCd <> *BLANKS
     C     *LOCK         In        LDA
     C                   Eval      DBASE = 1
     C                   Eval      DBFILE = 'SDSVALPD'
     C                   Eval      DBKEY = P@OP01
     C                   Eval      DBPGM = 'AOSVALR0'
     C                   OUT       LDA
     C                   Exsr      *PSSR

     C                   Else

     C                   If        P@VL01 <> *BLANKS
     C                   EvalR     WRetPrd = %TRIM(P@VL01)
     C                   Endif

     C                   Move      WRetPrd       WRetPrdN
     C                   TIME                    TimeStmp
     C                   Move      DateYYYY      DatYYYY
     C                   Move      DateMM        DatMM
     C                   Move      DateDD        DatDD

     C                   Call      'ZDATE10'
     C                   Parm                    DatYYYYMMDD
     C                   Parm      0             CalDate

     C     CalDate       Sub       WRetPrdN      WTranRetPrd
     C                   z-add     WTranRetPrd   @@DayN            5 0
     C                   z-add     0             @@Vdt             8 0

     C                   Exsr      ZDATE9

     C                   z-add     @@Vdt         DatYYYYMMDD
     C                   Eval      WDatPurge = DatYYYYMMDD

     C                   Endif

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

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON

     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR

      *****************************************************************
     C/COPY ZSRSRC,ZDATE9Z3LE
      *****************************************************************
     X/COPY ZSRSRC,ZDATE9Z4
