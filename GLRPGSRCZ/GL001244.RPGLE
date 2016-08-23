     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas Netting program')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001244 - Netting program                                   *
      *                                                               *
      *  Function:  This program is to net the balance for all        *
      *             accounts in each netting group and add netted     *
      *             balance to the prinary account.
      *                                                               *
      *  Called By: mmCnnnn - (program name)                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CGL029             Date 01Sep03               *
      *                 CGL018  *CREATE    Date 01Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL018 - Risk Weighted Assets                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    90         EOF of GLNETGL6                                 *
      *    91         CHAIN to accntl0                                *
      *    92         UPDATE glnetgl4, secondary balance              *
      *    93                                                         *
      *    94                                                         *
      *    95         EOF of glnetgl6                                 *
      *    96         READ glnetgl4                                   *
      *    97         UPDATE glnetgl4, netting balance                *
      *    98         CHAIN glnetgl4                                  *
      *    99         UPDATE glnetgl4, netting balance                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * DbErr - Database error handler                               *
      * EndRout - End pgm routine
      *
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
      *
     **  Risk Weighted Asset Netting Group by Primary Group, Confirmed
      *
     FGLNETGL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L6)
     F                                     RENAME(GLNETGD0:GLNETGD6)
      *
     **  Risk Weighted Asset Netting Group Master File Update, Confirmed
      *
     FGLNETGL4  UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L4)
     F                                     RENAME(GLNETGD0:GLNETGD4)
      *
      ** Midas GL Account details - full a/c number
      *
     FACCNTL0   IF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     ** First DS for Access Programs, Short Data Structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D PrAccBal        S             15P 0
     D File            S              8
     D Key             S             29
     D DbNr            S              3  0
      *
     D*wcust****       S              6S 0                                                    CSD027
     D wcust           S              6A                                                      CSD027
     D wccy            S              3A
     D***wacod**         S              4S 0                                                  CGL029
     D wacod           S             10S 0                                                    CGL029
     D wacsq           S              2S 0
     D wbrca           S              3A
      *
     D l4brca          S              3A
     D*l4cust***       S              6S 0                                                    CSD027
     D l4cust          S              6A                                                      CSD027
     D l4ccy           S              3A
     D***l4acod*         S              4S 0                                                  CGL029
     D l4acod          S             10S 0                                                    CGL029
     D l4acsq          S              2S 0
 
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
      * Update secondary account balance
      *
     C                   READ      glnetgl4                               90
      *
     C                   DOW       not(*in90)
     C                   EVAL      BRCA = L4RWBRCA                              build key to accntl0
     C                   EVAL      CNUM = L4RWCUST
     C                   EVAL      CCY = L4RWCCY
     C                   EVAL      ACOD = L4RWACOD
     C                   EVAL      ACSQ = L4RWACSQ
      *
     C     ackey         CHAIN     accntl0                            9191
     C                   IF        *in91
     C                   EVAL      File = 'ACCNTAB'
     C**********         EVAL      Key = BRCA + %CHAR(CNUM) + CCY +                           CSD027
     C                   EVAL      Key = BRCA + CNUM + CCY +                                  CSD027
     C                             %CHAR(ACOD) + %CHAR(ACSQ)
     C                   EVAL      DbNr = 1
     C                   EXSR      DbErr
     C                   ENDIF
      *
     C                   EVAL      L4RWSBAL = LDBL
      *
     C                   UPDATE    glnetgd4                             92      update sec. balance
     C                   IF        *in92
     C                   EVAL      File = 'GLNETGPD'
     C**********         EVAL      Key = l4brca + %CHAR(l4cust) + l4ccy +                     CSD027
     C                   EVAL      Key = l4brca + l4cust + l4ccy +                            CSD027
     C                             %CHAR(l4acod) + %CHAR(l4acsq)
     C                   EVAL      DbNr = 2
     C                   EXSR      DbErr
     C*                  ENDIF
      *
     C                   ENDIF
     C                   READ      glnetgl4                               90    read next record
     C                   ENDDO
      *
      * Update primary account balance
      *
     C     *loval        SETLL     glnetgl6
     C                   READ      glnetgl6                               95
     C                   EVAL      wbrca = L6RWPBRCA                            store a key
     C                   EVAL      wcust = L6RWPCUST
     C                   EVAL      wccy =  L6RWPCCY
     C                   EVAL      wacod = L6RWPACOD
     C                   EVAL      wacsq = L6RWPACSQ
      *
     C                   DOW       not(*in95)
     C                   IF        not(                                         if new pri. a/c
     C                             wbrca = L6RWPBRCA  AND
     C                             wcust = L6RWPCUST  AND
     C                             wccy =  L6RWPCCY   AND
     C                             wacod = L6RWPACOD  AND
     C                             wacsq = L6RWPACSQ
     C                             )
     C                   EVAL      l4brca = wbrca                               build a key for
     C                   EVAL      l4cust = wcust                               update
     C                   EVAL      l4ccy =  wccy
     C                   EVAL      l4acod = wacod
     C                   EVAL      l4acsq = wacsq
     C                   EVAL      wbrca = L6RWPBRCA                            store a new pri. key
     C                   EVAL      wcust = L6RWPCUST
     C                   EVAL      wccy =  L6RWPCCY
     C                   EVAL      wacod = L6RWPACOD
     C                   EVAL      wacsq = L6RWPACSQ
      *
     C     l4key         SETLL     glnetgl4
     C     l4key         READE     glnetgl4                             96      read pri. a/c
      *
     C                   EVAL      L4RWPBAL = PrAccBal
      *
     C                   UPDATE    glnetgd4                             97      update pri. balance
     C                   IF        *in97
     C                   EVAL      File = 'GLNETGPD'
     C**********         EVAL      Key = l4brca + %CHAR(l4cust) + l4ccy +                     CSD027
     C                   EVAL      Key = l4brca + l4cust + l4ccy +                            CSD027
     C                             %CHAR(l4acod) + %CHAR(l4acsq)
     C                   EVAL      DbNr = 3
     C                   EXSR      DbErr
     C                   ENDIF
      *
     C                   EVAL      PrAccBal = L6RWSBAL                          new total for next
     C                   ELSE                                                   netting group
     C                   EVAL      PrAccBal = PrAccBal + L6RWSBAL               add to netting ba-
     C                   ENDIF                                                  lance
     C                   READ      glnetgl6                               95    read next record
     C                   ENDDO
      *
      * Last update
     C                   IF        not(
     C                             L6RWPBRCA = *blanks and
     C**********                   L6RWPCUST = *zeros  and                                    CSD027
     C                             L6RWPCUST = *blanks and                                    CSD027
     C                             L6RWPCCY  = *blanks and
     C                             L6RWPACOD = *zeros  and
     C                             L6RWPACSQ = *zeros
     C                             )
     C                   EVAL      l4brca = L6RWPBRCA
     C                   EVAL      l4cust = L6RWPCUST
     C                   EVAL      l4ccy =  L6RWPCCY
     C                   EVAL      l4acod = L6RWPACOD
     C                   EVAL      l4acsq = L6RWPACSQ
      *
     C     l4key         CHAIN     glnetgl4                           9898
     C                   IF        *in98
     C                   EVAL      File = 'GLNETGPD'
     C**********         EVAL      Key = l4brca + %CHAR(l4cust) + l4ccy +                     CSD027
     C                   EVAL      Key = l4brca + l4cust + l4ccy +                            CSD027
     C                             %CHAR(l4acod) + %CHAR(l4acsq)
     C                   EVAL      DbNr = 4
     C                   EXSR      DbErr
     C                   ENDIF
      *
     C                   EVAL      L4RWPBAL = PrAccBal
      *
     C                   UPDATE    glnetgd4                             99
     C                   IF        *in99
     C                   EVAL      File = 'GLNETGPD'
     C**********         EVAL      Key = l4brca + %CHAR(l4cust) + l4ccy +                     CSD027
     C                   EVAL      Key = l4brca + l4cust + l4ccy +                            CSD027
     C                             %CHAR(l4acod) + %CHAR(l4acsq)
     C                   EVAL      DbNr = 5
     C                   EXSR      DbErr
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      PrAccBal = 0
      *
     C                   EXSR      EndRout
      *
      *
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
      *
     C     ackey         KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    BRCA
      *
     C     l4key         KLIST
     C                   KFLD                    L4BRCA
     C                   KFLD                    L4CUST
     C                   KFLD                    L4CCY
     C                   KFLD                    L4ACOD
     C                   KFLD                    L4ACSQ
      *
      **  Initialise LDA field.
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'GL001244  '  DBPGM
     C                   OUT       LDA
      *
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * DbErr  - For each database error                              *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     DbErr         BEGSR
      ** Data base error in file (file)
      *
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  File
     C                   EVAL      DBKEY  =  key
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  DbNr
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  PSRoutine
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDSR
      *
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
     C                   CALL      'DBERRCTL'
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
      /EJECT
      *****************************************************************
      *                                                               *
      * EndRout - End routine                                         *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     EndRout       BEGSR
     C                   EVAL      *inlr = *on
     C                   RETURN
     C                   ENDSR
 
