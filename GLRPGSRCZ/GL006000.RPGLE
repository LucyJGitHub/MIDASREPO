     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Amounts for Block')                  *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL006000 - Validate Amounts for Block                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. AR1095876          Date 30Sep13               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG4646            Date 17Dec04               *
      *                 BUG4791            Date 22Nov04               *
      *                 BUG3281            Date 17Jun04               *
      *                 CGL014  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG4646- Completion of SIRS api                              *
      *  BUG4791 - Collateral 100% flagged as blocked isn't blocked   *
      *            as expected                                        *
      *  BUG3281 - Discrepancies on sources                           *
      *  CGL014 - Collaterals Processing                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRValidate - Validate amount                                 *
      *  SRConvert  - Convert transaction amount to account currency  *
      *                                                               *
      *  *INZSR    - Initialise                                       *
      *  *PSSR     - Error processing                                 *
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
 
      ** RE Shadow balances file
     FMEMOSL2   IF   E           K DISK    INFSR(*PSSR)
                                                                                             BUG4791
      ** GL Account Extension File                                                           BUG4791
     FGLACNTL3  IF   E           K DISK    INFSR(*PSSR)                                      BUG4791
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
     D LDA           E DS           256    EXTNAME(LDA) DTAARA
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for bank details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
 
      ** External DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** First DS for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs (long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PTR_Amount      S             15  0
     D PTR_Curr        S              3
     D PAC_Branch      S              3
     D PAC_Cust        S              6
     D PAC_Curr        S              3
     D PAC_Code        S             10
     D PAC_Seq         S              2
     D PAC_Retail      S             10  0
     D PRetCode        S              7
     D PRetCodeOut     S              7
     D POption         S              7
     D PAC_RetCHAR     S             10
     D WTR_SPRT        S             13  8
     D WTR_MDIN        S              1
     D WTR_NBDP        S              1  0
     D WAC_SPRT        S             13  8
     D WAC_MDIN        S              1
     D WAC_NBDP        S              1  0
 
      ** Parameters for conversion module ZCCYCN
     D PFrAMNT         S             15  0
     D PFrCCY          S              3
     D PToCCY          S              3
     D PFrSPRT         S             13  8
     D PToSPRT         S             13  8
     D PFrMDIN         S              1
     D PToMDIN         S              1
     D PFrNBDP         S              1  0
     D PToNBDP         S              1  0
     D PToAMNT         S             15  0
     D PCrossRate      S             13  8
     D PCrossMDIN      S              1
 
     D WRun            S              1
     D WAmount         S             15  0
     D WrkCLBLN        S             15  0
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Validate amount
 
     C                   EXSR      SRValidate
 
      ** End program
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidate -  Validate amount                                *
      *                                                               *
      *****************************************************************
 
     C     SRValidate    BEGSR
 
     C                   EVAL      PRetCode = *BLANKS
     C                   IF        PAC_Retail <> 0
     C                   MOVE      PAC_Retail    PAC_RetCHAR
     C                   ELSE
     C                   EVAL      PAC_RetCHAR = *BLANKS
     C                   ENDIF
 
      ** Access account details
 
     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       PRetCodeOut
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PAC_RetCHAR
     C                   PARM                    PAC_Cust
     C                   PARM                    PAC_Curr
     C                   PARM                    PAC_Code
     C                   PARM                    PAC_Seq
     C                   PARM                    PAC_Branch
     C     SDACCT        PARM      SDACCT        DSSDY
      *******************                                                       BUG4646
     C*******************IF        PRetCodeOut <> *BLANKS                       BUG4646
     C******LOCK*********IN        LDA                                          BUG4646
     C*******************EVAL      DBFILE = 'ACCNTAB'                           BUG4646
     C*******************EVAL      DBKEY  = PAC_RetCHAR                         BUG4646
     C*******************EVAL      DBASE  = 1                                   BUG4646
     C*******************OUT       LDA                                          BUG4646
     C*******************EXSR      *PSSR                                        BUG4646
     C*******************ENDIF                                                  BUG4646
 
      ** If record found is retail and a/c is held for collateral, validate amt
 
     C                   IF        PRetCodeOut = *BLANKS  AND  ATYP = 'R'
     C                             AND  COLF = 'Y'
     C                   EVAL      PAC_Curr = CCY
 
      ** Convert transaction amount to account currency if necessary
 
     C                   IF        PTR_Curr <> PAC_Curr
     C                   EXSR      SRConvert
     C                   ENDIF
                                                                                             BUG4791
      ** Access Account extension file to check Blocked Collateral Ind.                      BUG4791
                                                                                             BUG4791
     C     KeyAccnt      CHAIN     GLACNTL3                                                  BUG4791
     C                   IF        %FOUND(GLACNTL3) AND                                      BUG4791
     C                             F1BCIN = 'Y'                                              BUG4791
     C                   EVAL      PRetCode = '*BLKERR'                                      BUG4791
     C                   ENDIF                                                               BUG4791
                                                                                             BUG4791
     C                   IF        PRetCode = *BLANKS                                        BUG4791
 
      ** Access MEMOS for the shadow cleared balance
 
     C     ACNO          CHAIN     MEMOSL2
 
     C                   IF        %FOUND(MEMOSL2)
     C                   Z-SUB     CLBLN         WrkCLBLN
     C                   EVAL      WAmount = WrkCLBLN - PTR_Amount
 
     C                   IF        WAmount < BCOA
     C                   EVAL      PRetCode = '*BLKERR'
     C                   ELSE
 
     C**********         IF        WAmount < MINB                                            BUG3281
     C                   IF        WAmount < COLA                                            BUG3281
     C                   EVAL      PRetCode = '*WARN'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
                                                                                             BUG4791
     C                   ENDIF                                                               BUG4791
                                                                                             BUG4791
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRConvert - Convert transaction amount into account currency *
      *                                                               *
      *****************************************************************
 
     C     SRConvert     BEGSR
 
      ** Get currency details (transaction)
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRetCodeOut
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PTR_Curr
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRetCodeOut <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = PTR_Curr
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      WTR_NBDP = A6NBDP
     C                   EVAL      WTR_SPRT = A6SPRT
     C                   EVAL      WTR_MDIN = A6MDIN
     C                   ENDIF
 
      ** Get currency details (account)
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRetCodeOut
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PAC_Curr
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRetCodeOut <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = PAC_Curr
     C                   EVAL      DBASE  = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      WAC_NBDP = A6NBDP
     C                   EVAL      WAC_SPRT = A6SPRT
     C                   EVAL      WAC_MDIN = A6MDIN
     C                   ENDIF
 
     C                   CALLB     'ZCCYCN'
     C                   PARM      PTR_Amount    PFrAMNT
     C                   PARM      PTR_Curr      PFrCCY
     C                   PARM      PAC_Curr      PToCCY
     C                   PARM      WTR_SPRT      PFrSPRT
     C                   PARM      WAC_SPRT      PToSPRT
     C                   PARM      WTR_MDIN      PFrMDIN
     C                   PARM      WAC_MDIN      PToMDIN
     C                   PARM      WTR_NBDP      PFrNBDP
     C                   PARM      WAC_NBDP      PToNBDP
     C                   PARM      0             PToAMNT
     C                   PARM      0             PCrossRate
     C                   PARM      *BLANK        PCrossMDIN
 
     C                   EVAL      PTR_Amount = PToAMNT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PTR_Amount
     C                   PARM                    PTR_Curr
     C                   PARM                    PAC_Branch
     C                   PARM                    PAC_Cust
     C                   PARM                    PAC_Curr
     C                   PARM                    PAC_Code
     C                   PARM                    PAC_Seq
     C                   PARM                    PAC_Retail
     C                   PARM                    PRetCode
                                                                                             BUG4791
      ** Key list                                                                            BUG4791
                                                                                             BUG4791
     C     KeyAccnt      KLIST                                                               BUG4791
     C                   KFLD                    CNUM                                        BUG4791
     C                   KFLD                    CCY                                         BUG4791
     C                   KFLD                    ACOD                                        BUG4791
     C                   KFLD                    ACSQ                                        BUG4791
     C                   KFLD                    BRCA                                        BUG4791
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
