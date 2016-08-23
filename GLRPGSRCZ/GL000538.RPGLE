     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Extract Equation Events')
      *****************************************************************
      *                                                               *
      *  Midas    - General Ledger Module                             *
      *                                                               *
      *  GL000538 - Extract Equation Events                           *
      *                                                               *
      *  Function:  This program Extract Equation Events to Temporary *
      *             Extract File GLEQEXT                              *
      *                                                               *
      *  Called By: GLC000539 - Transfer Events                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG12221           Date 18Oct06               *
      *  Prev Amend No. BUG12232           Date 18Oct06               *
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG12221 - Only events should be extracted from OMPF.  Also  *
      *             change format of report to make it user-friendly  *
      *  BUG12232 - Clean payments are not extracted in transfer      *
      *             events                                            *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *   Use of indicators.                                          *
      *                                                               *
      *   97 -  NRF for file OB10LF                                   *
      *   98 -  EOF for file OM99LF                                   *
      *   99 -  NRF for file P3B10LF                                  *
      *   U7+U8  -  Database Error                                    *
      *                                                               *
      *                                                               *
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR     - Error processing Subroutine                       *
      *  *INZSR  - Initialise                                         *                     BUG12221
      *                                                               *                     BUG12221
      *  The *INZSR subroutine will only get called automatically     *                     BUG12221
      *  on entry to the module the first time it is run              *                     BUG12221
      *  (unless you end the program with LR on).  Similarly          *                     BUG12221
      *  D-spec initialisation only happens the first time.  Use      *                     BUG12221
      *  RESET for subsequent passes.                                 *                     BUG12221
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Extracted Equation Movements File
     FGLEQEXT   O    E             DISK    INFSR(*PSSR)
      *
      ** Equation Deal Type File
     FOB10LF    IF   E           K DISK    INFSR(*PSSR)
      *
      ** Equation Clear Payment File
     FP3B10LF   IF   E           K DISK    INFSR(*PSSR)
      *
      ** Logical over Equation Movements File
     FOM99LF    IF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *                                                                                     BUG12221
      ** Local data area for database error details                                         BUG12221
     D LDA           E DS                  EXTNAME(LDA)                                     BUG12221
      ** *LOCK IN LDA immediately before and OUT LDA immediately                            BUG12221
      ** after each database error handling.                                                BUG12221
      **                                                                                    BUG12221
      **                                    134 141 DBFILE                                  BUG12221
      **       Defines:                     142 170 DBKEY                                   BUG12221
      **                                    171 180 DBPGM                                   BUG12221
      **                                    181 1830DBASE                                   BUG12221
      *                                                                                     BUG12221
 
      *****************************************************************
      /EJECT
      ** +--------------------------------------+                                           BUG12221
      ** ¦ Arrays and Data Structures           ¦                                           BUG12221
      ** ¦ ==========================           ¦                                           BUG12221
      ** +--------------------------------------+                                           BUG12221
      * First DS For Access Programs, Short Data Structure                                  BUG12221
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   BUG12221
      *                                                                                     BUG12221
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                BUG12221
      ** External DS for bank details ICD retrieval                                         BUG12221
                                                                                            BUG12221
      ** +--------------------------------------+                                           BUG12221
      ** ¦ Declared variables                   ¦                                           BUG12221
      ** ¦ ==================                   ¦                                           BUG12221
      ** +--------------------------------------+                                           BUG12221
      **                                                                                    BUG12221
     D RUNDATE         S              5P 0                                                  BUG12221
      **                                                                                    BUG12221
     D EQEDAT          S              5P 0                                                  BUG12221
      *                                                                                     BUG12221
     D W_EDAT1         S              7                                                     BUG12221
      *                                                                                     BUG12221
     D W_EDAT2         S              6                                                     BUG12221
      *                                                                                     BUG12221
     D DateIn          S              6                                                     BUG12221
      *                                                                                     BUG12221
     D DaynoOut        S              5  0                                                  BUG12221
      *                                                                                     BUG12221
     D ErrorFlag       S              1                                                     BUG12221
      *                                                                                     BUG12221
     D @RTCD           S              7                                                     BUG12221
     D @OPTN           S              7                                                     BUG12221
      *****************************************************************
      /EJECT                                                                                BUG12221
      *================================================================                     BUG12221
      *  P R O G R A M   S T A R T                                    *                     BUG12221
      *================================================================                     BUG12221
      *                                                                                     BUG12221
      ** +--- Start of Main processing -----------------------------------+                 BUG12221
      ** ¦                                                                ¦                 BUG12221
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦                 BUG12221
      ** ¦ executed at program activation.                                ¦                 BUG12221
      ** ¦                                                                ¦                 BUG12221
      ** +----------------------------------------------------------------+                 BUG12221
      *                                                                                     BUG12221
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      * Read all Records on OM99LF and process each.
      *
     C     *LOVAL        SETLL     OM99LF
      *
      ** Read OMPFL1 with 98 indicator for EOF
      *
     C                   READ      OM99LF                                 98
     C                   DOW       *IN98 = *OFF
      *
      ** Key list for Clean Payments Basic Details File
      *
     C     P3KEY         KList
     C**********         KFld                    OMAPP                                      BUG12232
     C                   KFld                    OMAPPX            2                        BUG12232
     C                   KFld                    OMDRF
     C                   IF        (OMDTE = 9999999)                                        BUG12221
     C                   EVAL      OMDTE = 1000000                                          BUG12221
     C                   ELSE                                                               BUG12221
     C                   EXSR      CONDAT                                                   BUG12221
     C                   ENDIF                                                              BUG12221
      *
      ** If Application Code is Blanks and not open-dated
      *
     C                   IF        (OMAPP = *BLANKS)
     C                   EVAL      OMAPPX= 'CP'                                             BUG12232
     C     P3KEY         CHAIN     P3B10LF                            99
      *
      ** If Record is found,then it's a clean payment
      *
     C                   IF        (*IN99 = *OFF)
     C                   EVAL      OMAPP = 'CP'
     C                   EVAL      OMPYT = P3PYT
     C                   EVAL      OMRCCY= P3RCCY
     C                   EVAL      OMPCCY= P3PCCY
     C     OMDLP         CHAIN     OB10LF                             97
      *
     C                   IF        (*IN97 = *OFF)
     C                   EVAL      OMTDT = OBTDT
     C                   ENDIF
      **********                                                                            BUG12221
      ***Do*not*extract open-dated events                                                   BUG12221
      **********                                                                            BUG12221
     C**********         IF        (OMDTE <> 9999999)                                       BUG12221
     C                   IF        (EQEDAT > RUNDATE) OR (OMDTE=1000000)                    BUG12221
     C                   WRITE     GLEQEXTD0
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   READ      OM99LF                                 98
     C                   ITER
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C     OMDLP         CHAIN     OB10LF                             97
     C                   IF        (*IN97 = *OFF)
     C                   EVAL      OMTDT = OBTDT
     C                   EVAL      OMPYT = *BLANKS
     C                   EVAL      OMRCCY =*BLANKS
     C                   EVAL      OMPCCY =*BLANKS
     C**********         IF        (OMDTE <> 9999999)                                       BUG12221
     C                   IF        (EQEDAT > RUNDATE) OR (OMDTE=1000000)                    BUG12221
     C                   WRITE     GLEQEXTD0
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      OM99LF                                 98
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
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
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                BUG12221
      *****************************************************************                     BUG12221
      * CONDAT - Converts movement date to midas day number           *                     BUG12221
      *                                                               *                     BUG12221
      * Called by: Main Procedure                                     *                     BUG12221
      *                                                               *                     BUG12221
      * Calls: *PSSR                                                  *                     BUG12221
      *****************************************************************                     BUG12221
     C     CONDAT        BEGSR                                                              BUG12221
      *                                                                                     BUG12221
      ** Convert Movement Date to midas day number by calling ZDATE1                        BUG12221
      *                                                                                     BUG12221
     C                   MOVE      OMDTE         W_EDAT1                                    BUG12221
     C                   EVAL      W_EDAT2 = %SUBST(W_EDAT1:4:2) +                          BUG12221
     C                                       %SUBST(W_EDAT1:6:2) +                          BUG12221
     C                                       %SUBST(W_EDAT1:2:2)                            BUG12221
      *                                                                                     BUG12221
     C                   CALLB     'ZDATE1'                                                 BUG12221
     C                   PARM      W_EDAT2       DateIn                                     BUG12221
     C                   PARM                    DaynoOut                                   BUG12221
     C                   PARM      'M'           BJDFIN                                     BUG12221
     C                   PARM                    ErrorFlag                                  BUG12221
      *                                                                                     BUG12221
     C                   IF        ErrorFlag = 'Y'                                          BUG12221
     C     *LOCK         IN        LDA                                                      BUG12221
     C                   EVAL      DBFILE = 'OM99LF'                                        BUG12221
     C                   EVAL      DBKEY  =  W_EDAT1                                        BUG12221
     C                   EVAL      DBASE  =  902                                            BUG12221
     C                   OUT       LDA                                                      BUG12221
     C                   EXSR      *PSSR                                                    BUG12221
      *                                                                                     BUG12221
     C                   ELSE                                                               BUG12221
      *                                                                                     BUG12221
     C                   EVAL      EQEDAT = DaynoOut                                        BUG12221
     C                   ENDIF                                                              BUG12221
      *                                                                                     BUG12221
     C                   ENDSR                                                              BUG12221
      *                                                                                     BUG12221
      *****************************************************************                     BUG12221
      /EJECT                                                                                BUG12221
      *****************************************************************                     BUG12221
      * *INZSR - Program Initialisation routine                       *                     BUG12221
      *                                                               *                     BUG12221
      * Called by: Implicitly on program activation                   *                     BUG12221
      *                                                               *                     BUG12221
      * Calls: *PSSR                                                  *                     BUG12221
      *****************************************************************                     BUG12221
     C     *INZSR        BEGSR                                                              BUG12221
      *                                                                                     BUG12221
      ** Define LDA Data Area                                                               BUG12221
      *                                                                                     BUG12221
     C     *DTAARA       DEFINE                  LDA                                        BUG12221
      *                                                                                     BUG12221
      ** Access Bank details                                                                BUG12221
      *                                                                                     BUG12221
     C                   CALL      'AOBANKR0'                                               BUG12221
     C                   PARM      *BLANKS       @RTCD                                      BUG12221
     C                   PARM      '*FIRST'      @OPTN                                      BUG12221
     C     SDBANK        PARM                    DSFDY                                      BUG12221
      *                                                                                     BUG12221
      ** If ReturnCode is Non-Blank, generate Database Error.                               BUG12221
      *                                                                                     BUG12221
     C                   IF        @RTCD <> *Blanks                                         BUG12221
     C     *LOCK         IN        LDA                                                      BUG12221
     C                   EVAL      DBFILE = 'SDBANKPD'                                      BUG12221
     C                   EVAL      DBKEY  = @OPTN                                           BUG12221
     C                   EVAL      DBPGM  = 'GL000538'                                      BUG12221
     C                   EVAL      DBASE  = 001                                             BUG12221
     C                   EVAL      DBMOD  = 'GL000538'                                      BUG12221
     C                   EVAL      DBPROC = 'SR/*INZSR'                                     BUG12221
     C                   OUT       LDA                                                      BUG12221
     C                   EXSR      *PSSR                                                    BUG12221
     C                   ELSE                                                               BUG12221
     C                   EVAL      RUNDATE = BJRDNB                                         BUG12221
     C                   ENDIF                                                              BUG12221
      *                                                                                     BUG12221
      *  Read in Installation Data                                                          BUG12221
      *                                                                                     BUG12221
     C                   ENDSR                                                              BUG12221
      *****************************************************************                     BUG12221
