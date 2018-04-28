     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Risk Weighted Assets Balances Update')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading                                   *
      *                                                               *
      *  SE001301 - Securities Trading Risk Weighted Assets Balances  *
      *             Update Program                                    *
      *                                                               *
      *  Function:  This module will call the calculation program to  *
      *             calculate the Risk Weighted Balance for all       *
      *             Security Value Date Book Positions.               *
      *             The RWA Balance will be updated on the Own Securi-*
      *             ties balances format on the Midas Export Module.  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CSE071             Date 19Jul05               *
      *                 CGL018  *CREATE    Date 10Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL018 - Risk Weighted Assets                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *    01         EOF for SDRWASL1                                *
      *    02         EOF for BKPHJ3V                                 *
      *    03         EOF for SERWABPD                                *
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
      **
     FSERWABL0  O    E           K DISK
     FSERWABL1  UF   E           K DISK
     F                                     RENAME(SERWABP0:SERWABP1)
     FBKPHJ3V   IF   E           K DISK    INFSR(*PSSR)
     FSDRWASL1  IF   E           K DISK    INFSR(*PSSR)
 
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
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
 
 
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
 
     C                   EXSR      MAIN
 
     C                   EVAL      *INLR = *ON
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main Processing                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     MAIN          BEGSR
      *
      **  Read Risk Weighted Assets File
      *
     C                   READ      SDRWASL1                               01
 
     C     *IN01         DOWEQ     '0'
 
     C     RWRECI        IFNE      '*'
 
     C                   MOVE      RWSETN        WWSetNum
     C                   MOVE      RWCALC        WWCalcMet
 
     C                   EVAL      Count = Count + 1
 
     C                   EXSR      GETBOOKS
 
     C                   MOVE      '1'           *IN20
 
     C                   ENDIF
 
     C                   READ      SDRWASL1                               01
     C                   ENDDO
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * GETBOOKS - Get Book Position of the Securities in the system  *
      *                                                               *
      * Calls: LE001241                                               *
      *                                                               *
      *****************************************************************
 
     C     GETBOOKS      BEGSR
      *
      **  Read BKPHJ3V
      **  Pointer needs to be on the very first record again for the next
      **  Set Number record from SDRWASL1
      *
     C     *IN20         IFEQ      '1'
     C     *LOVAL        SETLL     BKPHJ3V
     C                   ENDIF
 
     C                   READ      BKPHJ3V                                02
 
     C     *IN02         DOWEQ     '0'
 
     C                   MOVEL     BHSC          WWSecRef
     C                   MOVEL     BHBA          WWSecBrca
     C                   MOVEL     BHBK          WWSecBook
     C                   MOVEL     BHMK          WWSecMrkt
     C                   MOVEL     BHTV          WWSecBptv
     C                   Z-ADD     LATD          WWSecPdat
     C                   Z-ADD     NPSN          WWAsetBal        15 0
      *
      ****Chain*to*Securities*file to get the Currency
      *
 
     C                   MOVE      NMCY          WWSecCcy
      *
      ** Call Security Lending Risk Weighted Assets Allocation Program
      *
     C                   CALLB     'SE001302'
     C                   PARM                    WWSecRef
     C                   PARM                    WWSecBrca
     C                   PARM                    WWSecBook
     C                   PARM                    WWSecMrkt
     C                   PARM                    WWSecCcy
     C                   PARM                    WWAsetBal
     C                   PARM                    WWSetNum
     C                   PARM                    WWCalcMet
     C                   PARM                    WWRiskWABal
      *
      ** Update Securities Value Date Balances File from the returned Risk
      ** Weighted Asset Balance figure
      *
     C                   EXSR      UPDATRWASE
 
      ** Initialise RWA Balance variable for the next call
      *
     C                   Z-ADD     *ZERO         WWRiskWABal
 
     C                   READ      BKPHJ3V                                02
     C                   ENDDO
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATRWASE - Updates SERWABL0 for this Security               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     UPDATRWASE    BEGSR
      *
      **  Move field values for accessing record in the Security Risk
      **  Weighted Assets Balances File
      *
     C                   MOVEL     WWSecBrca     WSBrca
     C                   MOVEL     WWSecBook     WSBpbk
     C                   MOVEL     WWSecRef      WSBpsc
     C                   MOVEL     WWSecMrkt     WSBpmk
     C                   MOVEL     WWSecBptv     WSBptv
     C                   Z-ADD     WWSecPdat     WSBppd
 
     C     KSEREC        CHAIN     SERWABP1                           03
 
     C     *IN03         IFEQ      '0'
 
     C                   SELECT
     C     Count         WHENEQ    2
     C                   MOVE      WWSetNum      SBSET02
     C                   Z-ADD     WWRiskWABal   SBAB02
 
     C     Count         WHENEQ    3
     C                   MOVE      WWSetNum      SBSET03
     C                   Z-ADD     WWRiskWABal   SBAB03
 
     C     Count         WHENEQ    4
     C                   MOVE      WWSetNum      SBSET04
     C                   Z-ADD     WWRiskWABal   SBAB04
 
     C     Count         WHENEQ    5
     C                   MOVE      WWSetNum      SBSET05
     C                   Z-ADD     WWRiskWABal   SBAB05
 
     C     Count         WHENEQ    6
     C                   MOVE      WWSetNum      SBSET06
     C                   Z-ADD     WWRiskWABal   SBAB06
 
     C     Count         WHENEQ    7
     C                   MOVE      WWSetNum      SBSET07
     C                   Z-ADD     WWRiskWABal   SBAB07
 
     C     Count         WHENEQ    8
     C                   MOVE      WWSetNum      SBSET08
     C                   Z-ADD     WWRiskWABal   SBAB08
 
     C     Count         WHENEQ    9
     C                   MOVE      WWSetNum      SBSET09
     C                   Z-ADD     WWRiskWABal   SBAB09
 
     C     Count         WHENEQ    10
     C                   MOVE      WWSetNum      SBSET10
     C                   Z-ADD     WWRiskWABal   SBAB10
 
     C     Count         WHENEQ    11
     C                   MOVE      WWSetNum      SBSET11
     C                   Z-ADD     WWRiskWABal   SBAB11
 
     C     Count         WHENEQ    12
     C                   MOVE      WWSetNum      SBSET12
     C                   Z-ADD     WWRiskWABal   SBAB12
 
     C     Count         WHENEQ    13
     C                   MOVE      WWSetNum      SBSET13
     C                   Z-ADD     WWRiskWABal   SBAB13
 
     C     Count         WHENEQ    14
     C                   MOVE      WWSetNum      SBSET14
     C                   Z-ADD     WWRiskWABal   SBAB14
 
     C     Count         WHENEQ    15
     C                   MOVE      WWSetNum      SBSET15
     C                   Z-ADD     WWRiskWABal   SBAB15
 
     C     Count         WHENEQ    16
     C                   MOVE      WWSetNum      SBSET16
     C                   Z-ADD     WWRiskWABal   SBAB16
 
     C     Count         WHENEQ    17
     C                   MOVE      WWSetNum      SBSET17
     C                   Z-ADD     WWRiskWABal   SBAB17
 
     C     Count         WHENEQ    18
     C                   MOVE      WWSetNum      SBSET18
     C                   Z-ADD     WWRiskWABal   SBAB18
 
     C     Count         WHENEQ    19
     C                   MOVE      WWSetNum      SBSET19
     C                   Z-ADD     WWRiskWABal   SBAB19
 
     C     Count         WHENEQ    20
     C                   MOVE      WWSetNum      SBSET20
     C                   Z-ADD     WWRiskWABal   SBAB20
 
     C     Count         WHENEQ    21
     C                   MOVE      WWSetNum      SBSET21
     C                   Z-ADD     WWRiskWABal   SBAB21
 
     C     Count         WHENEQ    22
     C                   MOVE      WWSetNum      SBSET22
     C                   Z-ADD     WWRiskWABal   SBAB22
 
     C     Count         WHENEQ    23
     C                   MOVE      WWSetNum      SBSET23
     C                   Z-ADD     WWRiskWABal   SBAB23
 
     C     Count         WHENEQ    24
     C                   MOVE      WWSetNum      SBSET24
     C                   Z-ADD     WWRiskWABal   SBAB24
 
     C     Count         WHENEQ    25
     C                   MOVE      WWSetNum      SBSET25
     C                   Z-ADD     WWRiskWABal   SBAB25
 
     C     Count         WHENEQ    26
     C                   MOVE      WWSetNum      SBSET26
     C                   Z-ADD     WWRiskWABal   SBAB26
 
     C     Count         WHENEQ    27
     C                   MOVE      WWSetNum      SBSET27
     C                   Z-ADD     WWRiskWABal   SBAB27
 
     C     Count         WHENEQ    28
     C                   MOVE      WWSetNum      SBSET28
     C                   Z-ADD     WWRiskWABal   SBAB28
 
     C     Count         WHENEQ    29
     C                   MOVE      WWSetNum      SBSET29
     C                   Z-ADD     WWRiskWABal   SBAB29
 
     C     Count         WHENEQ    30
     C                   MOVE      WWSetNum      SBSET30
     C                   Z-ADD     WWRiskWABal   SBAB30
 
     C     Count         WHENEQ    31
     C                   MOVE      WWSetNum      SBSET31
     C                   Z-ADD     WWRiskWABal   SBAB31
 
     C     Count         WHENEQ    32
     C                   MOVE      WWSetNum      SBSET32
     C                   Z-ADD     WWRiskWABal   SBAB32
 
     C     Count         WHENEQ    33
     C                   MOVE      WWSetNum      SBSET33
     C                   Z-ADD     WWRiskWABal   SBAB33
 
     C     Count         WHENEQ    34
     C                   MOVE      WWSetNum      SBSET34
     C                   Z-ADD     WWRiskWABal   SBAB34
 
     C     Count         WHENEQ    35
     C                   MOVE      WWSetNum      SBSET35
     C                   Z-ADD     WWRiskWABal   SBAB35
 
     C                   OTHER
     C                   MOVE      WWSetNum      SBSET36
     C                   Z-ADD     WWRiskWABal   SBAB36
 
     C                   ENDSL
 
     C                   UPDATE    SERWABP1
 
      ** If no record in SERWABPD for this security yet (this must be the
      ** first set so write the values in 01 fields)
      *
     C                   ELSE
 
     C                   MOVE      'D'           SBRECI
     C                   MOVEL     WWSecRef      SBBPSC
     C                   MOVEL     WWSecBrca     SBBPBA
     C                   MOVEL     WWSecBook     SBBPBK
     C                   MOVEL     WWSecMrkt     SBBPMK
     C                   MOVEL     WWSecBptv     SBBPTV
     C                   Z-ADD     WWSecPdat     SBBPPD
     C                   MOVE      WWSetNum      SBSET01
     C                   Z-ADD     WWRiskWABal   SBAB01
 
     C                   MOVEL     *BLANKS       SBSET02
     C                   MOVEL     *BLANKS       SBSET03
     C                   MOVEL     *BLANKS       SBSET04
     C                   MOVEL     *BLANKS       SBSET05
     C                   MOVEL     *BLANKS       SBSET06
     C                   MOVEL     *BLANKS       SBSET07
     C                   MOVEL     *BLANKS       SBSET08
     C                   MOVEL     *BLANKS       SBSET09
     C                   MOVEL     *BLANKS       SBSET10
     C                   MOVEL     *BLANKS       SBSET11
     C                   MOVEL     *BLANKS       SBSET12
     C                   MOVEL     *BLANKS       SBSET13
     C                   MOVEL     *BLANKS       SBSET14
     C                   MOVEL     *BLANKS       SBSET15
     C                   MOVEL     *BLANKS       SBSET16
     C                   MOVEL     *BLANKS       SBSET17
     C                   MOVEL     *BLANKS       SBSET18
     C                   MOVEL     *BLANKS       SBSET19
     C                   MOVEL     *BLANKS       SBSET20
     C                   MOVEL     *BLANKS       SBSET21
     C                   MOVEL     *BLANKS       SBSET22
     C                   MOVEL     *BLANKS       SBSET23
     C                   MOVEL     *BLANKS       SBSET24
     C                   MOVEL     *BLANKS       SBSET25
     C                   MOVEL     *BLANKS       SBSET26
     C                   MOVEL     *BLANKS       SBSET27
     C                   MOVEL     *BLANKS       SBSET28
     C                   MOVEL     *BLANKS       SBSET29
     C                   MOVEL     *BLANKS       SBSET30
     C                   MOVEL     *BLANKS       SBSET31
     C                   MOVEL     *BLANKS       SBSET32
     C                   MOVEL     *BLANKS       SBSET33
     C                   MOVEL     *BLANKS       SBSET34
     C                   MOVEL     *BLANKS       SBSET35
     C                   MOVEL     *BLANKS       SBSET36
 
     C                   Z-ADD     *ZERO         SBAB02
     C                   Z-ADD     *ZERO         SBAB03
     C                   Z-ADD     *ZERO         SBAB04
     C                   Z-ADD     *ZERO         SBAB05
     C                   Z-ADD     *ZERO         SBAB06
     C                   Z-ADD     *ZERO         SBAB07
     C                   Z-ADD     *ZERO         SBAB08
     C                   Z-ADD     *ZERO         SBAB09
     C                   Z-ADD     *ZERO         SBAB10
     C                   Z-ADD     *ZERO         SBAB11
     C                   Z-ADD     *ZERO         SBAB12
     C                   Z-ADD     *ZERO         SBAB13
     C                   Z-ADD     *ZERO         SBAB14
     C                   Z-ADD     *ZERO         SBAB15
     C                   Z-ADD     *ZERO         SBAB16
     C                   Z-ADD     *ZERO         SBAB17
     C                   Z-ADD     *ZERO         SBAB18
     C                   Z-ADD     *ZERO         SBAB19
     C                   Z-ADD     *ZERO         SBAB20
     C                   Z-ADD     *ZERO         SBAB21
     C                   Z-ADD     *ZERO         SBAB22
     C                   Z-ADD     *ZERO         SBAB23
     C                   Z-ADD     *ZERO         SBAB24
     C                   Z-ADD     *ZERO         SBAB25
     C                   Z-ADD     *ZERO         SBAB26
     C                   Z-ADD     *ZERO         SBAB27
     C                   Z-ADD     *ZERO         SBAB28
     C                   Z-ADD     *ZERO         SBAB29
     C                   Z-ADD     *ZERO         SBAB30
     C                   Z-ADD     *ZERO         SBAB31
     C                   Z-ADD     *ZERO         SBAB32
     C                   Z-ADD     *ZERO         SBAB33
     C                   Z-ADD     *ZERO         SBAB34
     C                   Z-ADD     *ZERO         SBAB35
     C                   Z-ADD     *ZERO         SBAB36
 
     C                   WRITE     SERWABP0
 
     C                   ENDIF
 
     C                   ENDSR
 
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
 
     C     *LIKE         DEFINE    BHSC          WWSecRef
     C     *LIKE         DEFINE    NMCY          WWSecCcy
     C     *LIKE         DEFINE    BHBA          WSBrca
     C     *LIKE         DEFINE    BHBK          WSBpbk
     C     *LIKE         DEFINE    BHSC          WSBpsc
     C     *LIKE         DEFINE    BHMK          WSBpmk
     C     *LIKE         DEFINE    BHTV          WSBptv
     C     *LIKE         DEFINE    LATD          WSBppd
     C     *LIKE         DEFINE    BHBA          WWSecBrca
     C     *LIKE         DEFINE    BHBK          WWSecBook
     C     *LIKE         DEFINE    BHMK          WWSecMrkt
     C     *LIKE         DEFINE    BHTV          WWSecBptv
     C     *LIKE         DEFINE    LATD          WWSecPdat
     C     *LIKE         DEFINE    RWSETN        WWSetNum
     C     *LIKE         DEFINE    RWCALC        WWCalcMet
     C     *LIKE         DEFINE    SBAB01        WWRiskWABal
 
     C                   MOVE      '0'           *IN20
     C                   Z-ADD     *ZERO         Count             2 0
 
     C     KSEREC        KLIST
     C                   KFLD                    WSBrca
     C                   KFLD                    WSBpbk
     C                   KFLD                    WSBpsc
     C                   KFLD                    WSBpmk
     C                   KFLD                    WSBptv
     C                   KFLD                    WSBppd
 
     C                   ENDSR
      /EJECT
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
 
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
