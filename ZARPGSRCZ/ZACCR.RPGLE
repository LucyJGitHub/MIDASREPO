     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Calculate interest between two dates')        *
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZACCR   -   Calculate accrued interest between two dates     *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZACCR         *
      *  subroutine.  The subroutine consists of two /COPY members.   *
      *  Each of these has been converted to ILE RPG and copied into  *
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).  The   *
      *  existing code has not been changed except to remove dead     *
      *  lines, and the boundaries of the original /COPY members have *
      *  been marked, to facilitate future maintenance of both the    *
      *  old members and this one.  If this member has to change, the *
      *  change should ALMOST CERTAINLY be implemented by changing    *
      *  the old /COPY member, reconverting it using CVTRPGSRC, and   *
      *  copying it into this member, replacing the existing section. *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11193           Date 02May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG11164           Date 06Apr06               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      *                 211407             Date 06Nov02               *
      *                 209231             Date 03Oct02               *
      *                 CSE035             Date 22Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 149162             Date 07Dec98               *
      *                 CAP002  *CREATE    Date 21Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG11164 - A Serious Midas Error on SETRAD insert/amend      *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  211407 - Correct logic in determining NNX for changes CSE035 *
      *  209231 - Purchase interest not being rounded to specific     *
      *           decimal places. Include CSE037 in int calculation.  *
      *  CSE035 - NX/NNX Coupon Payment Processing.                   *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  149162 - Int. calc. incorrect at end of Feb for 30 day method*
      *           (core fix 102506 changes ZDAYS and ZDYYR)           *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D CDArr                 183    230
     D CRArr                 231    242
 
 
     D POWER8          S              8  4 DIM(8) CTDATA PERRCD(1)
 
 
      ** Input fields
 
      ** Interest Rate
     D IRATE           S             15P 9
      ** Start date
     D ZSDATE          S              5P 0
      ** End date
     D ZEDATE          S              5P 0
      ** Interest days adjustment
     D  DADJN          S              1A
      ** Next Coupon Date
     D**NCD***         S              5P 0                                                    CSE031
     D  NextCoupDate   S              5P 0                                                    CSE031
      ** Nominal currency decimal places
     D NomCcyDec       S              1P 0
      ** Processing type
     D PROT            S              1A
      ** Date format
     D  BJDFIN         S              1A
 
 
      ** Working Variables
 
     D ECD             S              5P 0
     D LCDD5           S              5P 0
 
 
      *** Output ***
 
      ** No. of days in time frame (ZDAYS output)
     D ZDDAYS          S              5P 0
      ** No. of days in interest year (ZDYYR output)
     D ZINTDD          S              5P 0
 
 
      ** +-----------------------------------------------------------------+
 
 
      ** +--- The converted ZACCRZ0 starts here --------------------------+
 
     D IDY             S              5  0 DIM(25)                              INTEREST DAYS
 
      ** +--- The converted ZACCRZ0 ends here ----------------------------+
 
     C/COPY WNCPYSRC,ZACCRC001
                                                                                              CSE035
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSE035
                                                                                              CSE035
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSE035
     D  AULCD        E                     EXTFLD(LCD)                                        CSE035
                                                                                              CSE035
 
      ** Processing required before standard subroutine
 
      ** Nominal currency decimal places
 
     C                   Z-ADD     NomCcyDec     ZCDP
 
      ** Initialise output fields
     C                   Z-ADD     0             ZACCRD                                        E2089
     C                   Z-ADD     0             ZACCXD                                        05542
      *                                                                                       CSE035
     C     CSE035        IFEQ      'Y'                                                        CSE035
     C                   Z-ADD     NextCoupDate  NCDD5                                        CSE035
     C                   END                                                                  CSE035
 
     C/COPY WNCPYSRC,ZACCRC009
 
     C                   EXSR      ZACCR
 
     C                   RETURN
      /EJECT
      ** +--- The converted ZACCRZ1 starts here --------------------------+
 
     C*****************************************************************
     C*                                                               *
     C*  ZACCR - SUBR. TO CALCULATE INTEREST ACCRUED BETWEEN TWO DATES*
     C*                                                               *
     C*  INPUT  - ZSDATE (5,0) START DATE )  FOR ZDAYS SUBROUTINE     *
     C*           ZEDATE (5,0) END DATE   )                           *
     C*           ZAMT   (15,0) PRINCIPAL AMOUNT                      *
     C*           IRATE  (15,9) INTEREST RATE FROM ZRATE              *
     C*           NMDP   (1,0) nominal dec places (SECTYD)            *
     C*           ZCDP   (1,0) NOMINAL CURRENCY DEC. PLACES           *   S01117
     C*           PROT   (1A)  PROCESSING TYPE                        *
     C*           ARRAY 'POWER8'                                      *
     C*                                                               *
     C*  OUTPUT - ZACCRD (15,0) INTEREST ACCRUED                      *
     C*           ZACCXD (15,1) INTEREST ACCRUED                      *   055420
     C*           ZRP (1) 'R' RECEIVABLE, 'P' PAYABLE 'X' ZERO        *
     C*                                                               *
     C*  CALLS - ZDAYS, ZDYYR (ZDATE2)                                *
     C*                                                               *
     C*  LAST AMEND NO. 065301             DATE 06MAY94               *
     C*  PREV AMEND NO. 055420             DATE 24NOV93               *
     C*                 E27934             DATE 22OCT91               *
     C*                 S01117             DATE 22JAN91               *
     C*                 E21214             DATE 26FEB90               *
     C*                 E20890             DATE 23JAN90               *
     C*                 E20196             DATE 08NOV89               *
     C*                 E14496             DATE 20SEP89               *
     C*                                                               *
     C*---------------------------------------------------------------*
     C*                                                               *
     C*  065301 - ZAMT needs to be defined as 15,0 otherwise large    *
     C*           figures are truncated.                              *
     C*  055420 - Rounding problems on MORTGAGE BACKED SECURITIES.    *
     C*  E27934 - Rounding problems on Yen Bonds (Processing type 5)  *
     C*  S01117 - New SD file changes (R10 Multibranching).           *
     C*  E21214 - Rounding Problems.                                  *
     C*  E20890 - Calculating accrued interest on zero coupon rate    *
     C*           causes loop in SE0050.                              *
     C*  E20196 - THE INTEREST ACCRUED FIELD IS TRUNCATED. SO THE     *
     C*           INTEREST AMOUNT IS WRONG ON TRADE FILE              *
     C*  E14496 - Amended for Divisor Basis 5                         *
     C*                                                               *
     C*****************************************************************
     C*
     C     ZACCR         BEGSR                                                  **ZACCR BEGSR**
     C*
     C                   GOTO      TACCR1
     C                   Z-ADD     ZCDP          ZCDP              1 0                         S0111
     C     TACCR1        TAG
      *                                                                                       CSE035
     C/COPY WNCPYSRC,ZACCRC002
      *
     C     CSE035        IFEQ      'Y'                                                        CSE035
      *                                                                                       CSE035
      * Determine last coupon date (may not have been done before)                            CSE035
      *                                                                                       CSE035
     C     DVBS          IFNE      '5'                                                        CSE035
     C                   Z-ADD     ECD           ZVECD             5 0                        CSE035
     C                   Z-ADD     ZZLCD         ZLCDSV            5 0                        CSE035
     C     NextCoupDate  SUB       1             ZECD                                         CSE035
     C                   EXSR      ZLCD                                                       CSE035
     C                   Z-ADD     ZZLCD         ZLCDN5            5 0                        CSE035
     C                   Z-ADD     ZVECD         ECD                                          CSE035
     C                   Z-ADD     ZLCDSV        ZZLCD                                        CSE035
     C                   ENDIF                                                                CSE035
      *                                                                                       CSE035
     C                   END                                                                  CSE035
      *                                                                                       CSE035
     C*                                                                   E20890
     C*  If the Day Basis is '4' the coupon rate is zero. There           E20890
     C*   will be no accrued interest to be calculated.                   E20890
     C*                                                                   E20890
     C     DYBS          IFEQ      '4'                                                         E2089
     C                   Z-ADD     0             ZACCRD                                        E2089
     C                   Z-ADD     0             ZACCXD                                        05542
     C                   MOVE      'X'           ZRP                                           E2089
     C                   GOTO      EZACCR                                                      E2089
     C                   END                                                                   E2089
     C*
     C* DEFINE INPUT AMOUNT
     C*
     C                   Z-ADD     ZAMT          ZAMT             15 0                         06530
     C                   Z-ADD     0             ZACCRD           15 0
     C                   Z-ADD     0             ZACCXD           15 1                         05542
      *
     C/COPY WNCPYSRC,ZACCRC003
      *
     C     CSE035        IFEQ      'Y'                                                        CSE035
     C                   Z-ADD     0             ZAC100           15 8                        CSE035
     C                   MOVE      ' '           NNXSV             1                          CSE035
     C                   END                                                                  CSE035
     C*                                                                   E14496
     C* SAVE ECD                                                          E14496
     C                   Z-ADD     ECD           ZECDSV            5 0                         E1449
     C*
     C* Save Original Start and End Dates                                 E14496
     C*                                                                   E14496
     C                   Z-ADD     ZSDATE        ZVSDAT            5 0                         E1449
     C                   Z-ADD     ZEDATE        ZVEDAT            5 0                         E1449
     C                   Z-ADD     ECD           ZVECD             5 0                         E1449
     C*                                                                   E14496
     C* LOOP TO CALCULATE INTEREST FOR ALL DIV BAS TYPES                  E14496
     C*                                                                   E14496
     C     ZEDATE        DOWGT     ZVSDAT                                                      E1449
     C     ZEDATE        ANDGT     ITLD                                                        E1449
     C                   Z-ADD     ZEDATE        ECD                                           E1449
     C*                                                                   E14496
     C*Find Coupon Dates on either side of Value Date                     E14496
     C*                                                                   E14496
     C                   EXSR      ZDYYR                                                       E1449
      *                                                                                       CSE035
     C/COPY WNCPYSRC,ZACCRC004
      *                                                                                       CSE035
     C     CSE035        IFEQ      'Y'                                                        CSE035
      *                                                                                       CSE035
      ** Get the NCD from the coupon array.                                                   CSE035
      *                                                                                       CSE035
     C                   CALLB     'ZNCD1'                                                    CSE035
      * INPUTS                                                                                CSE035
                                                                                              CSE035
      ** Security details                                                                     CSE035
     C                   PARM                    ITLD                                         CSE035
     C                   PARM                    FCPN                                         CSE035
     C                   PARM                    MATY                                         CSE035
     C                   PARM                    CDArr                                        CSE035
     C                   PARM                    CRArr                                        CSE035
      *                                                                                       CSE035
      ** Event Control Date                                                                   CSE035
      ** Date Format                                                                          CSE035
     C                   PARM                    ECD               5 0                        CSE035
     C                   PARM                    BJDFIN                                       CSE035
      *                                                                                       CSE035
      ** Nominal Currency                                                                     CSE035
      ** Security Investment Type                                                             CSE035
      ** Effect on Holidays on Coupon Dates                                                   CSE035
     C                   PARM                    NMCY              3                          CSE035
     C                   PARM                    SITP              3                          CSE035
     C                   PARM                    BCNV              1                          CSE035
     C                   PARM                    LCPN              5 0                        CSE035
      ** Effect of Holidays on Dates                                                          CSE071
     C                   PARM                    HCY1                                         CSE071
     C                   PARM                    HCY2                                         CSE071
     C                   PARM                    HCY3                                         CSE071
     C                   PARM                    HCY4                                         CSE071
     C                   PARM                    HCY5                                         CSE071
     C                   PARM                    HCY6                                         CSE071
     C                   PARM                    HCY7                                         CSE071
     C                   PARM                    HCY8                                         CSE071
     C                   PARM                    HCY9                                         CSE071
                                                                                              CSE035
      * OUTPUTS                                                                               CSE035
                                                                                              CSE035
      ** Next Coupon Date                                                                     CSE035
     C                   PARM                    NCD1              5 0                        CSE035
                                                                                              CSE035
      *                                                                                       CSE035
      ** Save first the value of ZINTDD to ZINTDD1                                            CSE035
      *                                                                                       CSE035
     C                   MOVE      ZINTDD        ZINTDD1           3 0                        CSE035
                                                                                              CSE035
      *                                                                                       CSE035
      * Adjust days for NX and NNX securities                                                 CSE035
      *                                                                                       CSE035
     C     DVBS          IFEQ      '5'                                                        CSE035
     C     PROT          ANDEQ     '1'                                                        CSE035
     C     SYBS          ANDEQ     'AU'                                                       211407
     C     ZEDATE        ANDLE     FCPN                                                       CSE035
     C     LCDD5         ANDLE     ITLD                                                       CSE035
     C                   Z-ADD     365           ZINTDD                                       CSE035
     C                   ENDIF                                                                CSE035
      *                                                                                       CSE035
      ** If Cum securities, put back the original value of ZINTDD                             CSE035
      *                                                                                       CSE035
     C     DVBS          IFEQ      '5'                                                        CSE035
     C     PROT          ANDEQ     '1'                                                        CSE035
     C     ZEDATE        ANDLE     FCPN                                                       CSE035
     C     LCDD5         ANDEQ     ITLD                                                       CSE035
     C     NCD1          ANDEQ     FCPN                                                       CSE035
     C                   MOVE      ZINTDD1       ZINTDD                                       CSE035
     C                   ENDIF                                                                CSE035
      *                                                                                       CSE035
     C                   END                                                                  CSE035
      *                                                                                       CSE035
     C*                                                                   E14496
     C* Restore original start date after first loop                      E14496
     C*                                                                   E14496
     C                   Z-ADD     ZVSDAT        ZSDATE                                        E1449
     C*                                                                   E14496
     C* Find start date for interest calculations if divisor basis 5      E14496
     C*                                                                   E14496
     C     DVBS          IFEQ      '5'                                                         E1449
     C     LCDD5         ANDGE     ZSDATE                                                      E1449
     C                   Z-ADD     LCDD5         ZSDATE                                        E1449
     C                   END                                                                   E1449
     C*                                                                   E14496
     C     ITLD          IFGE      ZSDATE                                                      E1449
     C                   Z-ADD     ITLD          ZSDATE                                        E1449
     C                   END                                                                   E1449
      *
     C/COPY WNCPYSRC,ZACCRC005
      *
     C     CSE035        IFEQ      'Y'                                                        CSE035
      *                                                                                       CSE035
      * Adjust start and end dates for NNX securities such that it                            CSE035
      * calculates interest as follows:                                                       CSE035
      *     f/d x (1 + f'/182.5) x g/2                                                        CSE035
      * where f  = days from initial date to value date                                       CSE035
      *       f' = days from initial date to "would be" interest date                         CSE035
      *       d  = days from initial date to next coupon (ie. 1st                             CSE035
      *            coupon date)                                                               CSE035
      *       g  = annual coupon rate                                                         CSE035
      * The check on NNX and adjustment of dates should only be done                          CSE035
      * once in the first loop.                                                               CSE035
      *                                                                                       CSE035
     C     PROT          IFEQ      '1'                                                        CSE035
     C     SYBS          ANDEQ     'AU'                                                       211407
     C     NNXSV         IFEQ      ' '                                                        CSE035
     C                   MOVE      ' '           NNX               1                          CSE035
     C*****ZEDATE        IFLE      FCPN                                                CSE035 211407
      *****                                                                            CSE035 211407
     C*****ITLD          IFGE      LCDD5                                               CSE035 211407
     C*****DVBS          ANDEQ     '5'                                                 CSE035 211407
     C*****ITLD          ORGE      ZLCDN5                                              CSE035 211407
     C*****DVBS          ANDNE     '5'                                                 CSE035 211407
      *****                                                                            CSE035 211407
     C*****NCDD5         IFNE      FCPN                                                CSE035 211407
     C*****DVBS          ANDEQ     '5'                                                 CSE035 211407
     C*****NextCoupDate  ORNE      FCPN                                                CSE035 211407
     C*****DVBS          ANDNE     '5'                                                 CSE035 211407
     C*****              MOVE      'Y'           NNX                                   CSE035 211407
     C*****              ELSE                                                          CSE035 211407
     C*****              MOVE      ' '           NNX                                   CSE035 211407
     C*****              END                                                           CSE035 211407
     C*****              ELSE                                                          CSE035 211407
     C*****              MOVE      'Y'           NNX                                   CSE035 211407
     C*****              END                                                           CSE035 211407
     C*****              END                                                           CSE035 211407
     C     ZEDATE        IFLT      FCPN                                         B5            211407
      *                                                                                       211407
      ** Compare the Last Coupon Date got from the array with the ITLD                        211407
      ** to classify it correctly.                                                            211407
      *                                                                                       211407
      ** If Initial date coincides with the regular coupon date, it                           211407
      ** should be CUM.                                                                       211407
      *                                                                                       211407
     C     NCDD5         SUB       1             ECD1              5 0                        211407
     C                   CALLB     'ZLCD1'                                                    211407
                                                                                              211407
      * INPUTS                                                                                211407
                                                                                              211407
      ** Security details                                                                     211407
     C                   PARM                    ISSD                                         211407
     C                   PARM                    ITLD                                         211407
     C                   PARM                    FCPN                                         211407
     C                   PARM                    MATY                                         211407
     C                   PARM                    CDArr                                        211407
     C                   PARM                    CRArr                                        211407
      *                                                                                       211407
      ** Event Control Date                                                                   211407
      ** Date Format                                                                          211407
     C                   PARM                    ECD1                                         211407
     C                   PARM                    BJDFIN                                       211407
      *                                                                                       211407
     C                   PARM                    NMCY              3                          211407
     C                   PARM                    SITP              3                          211407
     C                   PARM                    BCNV              1                          211407
      ** Effect of Holidays on Dates                                                          CSE071
     C                   PARM                    HCY1                                         CSE071
     C                   PARM                    HCY2                                         CSE071
     C                   PARM                    HCY3                                         CSE071
     C                   PARM                    HCY4                                         CSE071
     C                   PARM                    HCY5                                         CSE071
     C                   PARM                    HCY6                                         CSE071
     C                   PARM                    HCY7                                         CSE071
     C                   PARM                    HCY8                                         CSE071
     C                   PARM                    HCY9                                         CSE071
                                                                                              211407
      * OUTPUTS                                                                               211407
                                                                                              211407
      ** Last Coupon Date                                                                     211407
     C                   PARM                    ZZLCD1            5 0                        211407
      *                                                                                       211407
     C     ITLD          IFEQ      ZZLCD1                                       B6            211407
     C     NCDD5         ANDEQ     FCPN                                                       211407
     C                   MOVE      ' '           NNX                                          211407
     C                   ELSE                                                   X6            211407
      *                                                                                       211407
      ** If Initial date greater than calculated LCD, it                                      211407
      ** should be NX (i.e. short first coupon period).                                       211407
      *                                                                                       211407
     C     ITLD          IFGT      ZZLCD1                                       B7            211407
     C                   MOVE      ' '           NNX                                          211407
     C                   ELSE                                                   X7            211407
      *                                                                                       211407
      ** It has a long first coupon period therefore it is                                    211407
      ** NNX.                                                                                 211407
      *                                                                                       211407
     C                   MOVE      'Y'           NNX                                          211407
     C                   ENDIF                                                  E7            211407
     C                   ENDIF                                                  E6            211407
     C                   ENDIF                                                  E5            211407
      *                                                                                       CSE035
     C     NNX           IFEQ      'Y'                                                        CSE035
     C     DVBS          ANDEQ     '5'                                                        CSE035
     C                   MOVE      'Y'           NNXSV                                        CSE035
     C                   Z-ADD     NextCoupDate  ZEDATE                                       CSE035
     C     ITLD          IFLT      LCDD5                                                      CSE035
     C                   Z-ADD     LCDD5         ZSDATE                                       CSE035
     C                   ELSE                                                                 CSE035
     C                   Z-ADD     NCDD5         ZSDATE                                       CSE035
     C                   END                                                                  CSE035
      *                                                                                       CSE035
      * Find the corresponding ZINTDD for the ZEDATE.                                         CSE035
      *                                                                                       CSE035
     C                   Z-ADD     LCDD5         SVLCD5            5 0                        CSE035
     C                   Z-ADD     NCDD5         SVNCD5            5 0                        CSE035
     C                   Z-ADD     ZEDATE        ECD                                          CSE035
     C                   EXSR      ZDYYR                                                      CSE035
     C                   Z-ADD     SVLCD5        LCDD5                                        CSE035
     C                   Z-ADD     SVNCD5        NCDD5             5 0                        CSE035
     C                   END                                                                  CSE035
     C                   END                                                                  CSE035
     C                   END                                                                  CSE035
      *                                                                                       CSE035
     C                   END                                                                  CSE035
      *                                                                                       CSE035
     C*                                                                   E14496
     C* Find no of days between start date and end date                   E14496
     C                   EXSR      ZDAYS
     C                   Z-ADD     ZDDAYS        WDDAYS            5 0
     C*
     C* IF NO OF DAYS IN INTEREST YEAR IS 0
     C*    - INTEREST AMOUNT IS 0
     C     ZINTDD        IFEQ      0
     C                   Z-ADD     0             WACCRD           15 0                         E1449
     C                   Z-ADD     0             WACCXD           15 1                         05542
     C                   MOVE      'X'           ZRP
     C                   GOTO      ZACCR9                                                      E1449
     C                   END
     C*
     C***  Determine index for conversion to Nominal Currency
     C*
     C     ZCDP          SUB       NMDP          DC                                            S0111
     C     DC            ADD       5             DC                1 0
     C*
     C* CALCULATE INTEREST AMOUNT
     C*  (i) For non-Yen Bond,
     C*          PRINCIPAL AMOUNT * INTEREST RATE * DAYS BETWEEN DATES
     C*          -----------------------------------------------------
     C*                    DAYS IN INTEREST YEAR * 100
     C/COPY WNCPYSRC,ZACCRC010
      *                                                                                       CSE035
     C     CSE035        IFEQ      'Y'                                                        CSE035
     C     CSE037        OREQ      'Y'                                                        209231
      *                                                                                       CSE035
      ** Changed to calculate the interest per 100 and rounded                                CSE035
      ** to no. of decimal places required by client                                          CSE035
      *                                                                                       CSE035
     C     IRATE         MULT (H)  WDDAYS        ZWAMT1           15 8                        CSE035
     C     ZWAMT1        DIV  (H)  ZINTDD        ZWAMT1                                       CSE035
     C                   Z-ADD     ZWAMT1        ZINPF            15 8                        CSE035
     C                   Z-ADD     ZINPF         ZOUTF            15 8                        CSE035
      *                                                                                       CSE035
     C                   ENDIF                                                                CSE035
     C*
     C     CSE037        IFEQ      'Y'                                                        209231
      *                                                                                       209231
     C     PROT          IFNE      '5'                                                        209231
      *                                                                                       209231
     C     ZSDATE        IFEQ      LCDD5                                                      209231
     C     ZEDATE        ANDEQ     NCDD5                                                      209231
     C     ZSDATE        OREQ      ZLCDN5                                                     209231
     C     ZEDATE        ANDEQ     NextCoupDate                                               209231
     C     DVBS          ANDNE     '5'                                                        209231
     C     ZSDATE        OREQ      ITLD                                                       209231
     C     ZEDATE        ANDEQ     FCPN                                                       209231
     C                   Z-ADD     ZINPF         ZOUTF            15 8                        209231
     C                   ELSE                                                                 209231
      *                                                                                       209231
      * If NNX & PROT '1', don't adjust no. of dec.place & adjustment                         209231
      * will be done as the last step.                                                        209231
      *                                                                                       209231
     C     NNXSV         IFEQ      'Y'                                                        209231
     C     PROT          ANDEQ     '1'                                                        209231
     C                   Z-ADD     ZINPF         ZOUTF                                        209231
     C                   ELSE                                                                 209231
      *                                                                                       209231
     C                   CALL      'SEADJPRI'                                                 209231
     C                   PARM      *BLANKS       @RTCD                                        209231
     C                   PARM      SESN          @SEKEY                                       209231
     C     ZINPF         PARM      ZINPF         @INAMT                                       209231
     C     ZOUTF         PARM      ZOUTF         @OUAMT                                       209231
     C                   ENDIF                                                                209231
      *                                                                                       209231
     C     NextCoupDate  IFGE      MATY                                                       209231
     C     SYBS          ANDEQ     'AU'                                                       209231
     C                   Z-ADD     ZINPF         ZOUTF                                        209231
     C                   ENDIF                                                                209231
     C                   ENDIF                                                                209231
      *                                                                                       209231
     C     ZAMT          DIV       100           ZWZAMT           15 2                        209231
     C     ZWZAMT        MULT      ZOUTF         ZWACCR           15 3                        209231
     C     ZWACCR        MULT (H)  POWER8(DC)    WACCRD                                       209231
     C     ZWACCR        MULT (H)  POWER8(DC)    WACCXD                                       209231
      *                                                                                       209231
      * If Yen Bond                                                                           209231
      *                                                                                       209231
     C                   ELSE                                                                 209231
      *                                                                                       209231
      * Calc. Factor                                                                          209231
      *                                                                                       209231
     C     IRATE         MULT      WDDAYS        ZFAC1            15 8                        209231
     C     ZFAC1         DIV       ZINTDD        ZFAC1                                        209231
      *                                                                                       209231
      * Adjust no. of decimal places                                                          209231
      *                                                                                       209231
     C                   Z-ADD     ZFAC1         ZINPF                                        209231
      *                                                                                       209231
     C                   CALL      'SEADJPRI'                                                 209231
     C                   PARM      *BLANKS       @RTCD                                        209231
     C                   PARM      SESN          @SEKEY                                       209231
     C     ZINPF         PARM      ZINPF         @INAMT                                       209231
     C     ZOUTF         PARM      ZOUTF         @OUAMT                                       209231
      *                                                                                       209231
     C     NextCoupDate  IFGE      MATY                                                       209231
     C     SYBS          ANDEQ     'AU'                                                       209231
     C                   Z-ADD     ZINPF         ZOUTF                                        209231
     C                   ENDIF                                                                209231
      *                                                                                       209231
      * Calc. Interest                                                                        209231
      *                                                                                       209231
     C     ZAMT          MULT (H)  ZOUTF         ZWACCR           15 3                        209231
      *                                                                                       209231
      *  Allow for ccy Dec Places                                                             209231
      *                                                                                       209231
     C     ZWACCR        MULT (H)  POWER8(DC)    WACCRD                                       209231
     C     WACCRD        DIV  (H)  100           WACCRD                                       209231
     C     ZWACCR        MULT (H)  POWER8(DC)    WACCXD                                       209231
     C     WACCRD        DIV  (H)  100           WACCXD                                       209231
     C                   ENDIF                                                                209231
      *                                                                                       209231
     C                   ELSE                                                                 209231
      *                                                                                       209231
     C     PROT          IFNE      '5'
     C     ZAMT          MULT(H)   IRATE         ZWMLT            15 0                         E2019
     C     ZWMLT         DIV       100           ZWAMT            15 2                         E2019
     C*
     C                   MULT      WDDAYS        ZWAMT                                         E2121
     C*                                                                   E20196
     C*                                                                   E20196
     C     ZINTDD        DIV       POWER8(DC)    ZDIV             15 6                         E2019
     C     ZWAMT         DIV(H)    ZDIV          WACCRD                                        E2121
     C     ZWAMT         DIV(H)    ZDIV          WACCXD                                        05542
     C*
     C* If Yen Bond
     C                   ELSE
     C*  Calc. Factor
     C     IRATE         MULT      WDDAYS        ZFAC             15 7
     C     ZFAC          DIV       ZINTDD        ZFAC
     C*  Calc. Interest
     C     ZAMT          MULT      ZFAC          ZWACCR           15 3                         E2793
     C*  Allow for ccy Dec Places
     C     ZWACCR        MULT      POWER8(DC)    WACCRD                                        E2019
     C     WACCRD        DIV(H)    100           WACCRD                                        E2793
     C     ZWACCR        MULT      POWER8(DC)    WACCXD                                        05542
     C     WACCXD        DIV(H)    100           WACCXD                                        05542
     C                   END
      *                                                                                       209231
     C                   ENDIF                                                                209231
     C*                                                                   E14496
     C* Add interest to accumulated field                                 E14496
     C*                                                                   E14496
     C                   ADD       WACCRD        ZACCRD                                        E1449
     C                   ADD       WACCXD        ZACCXD                                        05542
      *                                                                                       CSE035
      * Add interest per 100 to accumulated field                                             CSE035
      *                                                                                       CSE035
     C     CSE035        IFEQ      'Y'                                                        CSE035
     C                   ADD       ZOUTF         ZAC100                                       CSE035
     C                   END                                                                  CSE035
      *                                                                                       CSE035
     C*                                                                   E14496
     C/COPY WNCPYSRC,ZACCRC006
     C* Make start date new end date and restart loop                     E14496
     C*                                                                   E14496
     C                   Z-ADD     ZSDATE        ZEDATE                                        E1449
     C     ZACCR9        TAG                                                    ** ZACCR9    **E1449
     C                   END                                                                   E1449
      *
     C/COPY WNCPYSRC,ZACCRC007
      *                                                                                       CSE035
     C     CSE035        IFEQ      'Y'                                                        CSE035
      *                                                                                       CSE035
      * For NNX interest, apply factor f/d to ZAC100 (accumulated                             CSE035
      * interest per 100), round to the no. of decimal places required,                       CSE035
      * multiply the result with nominal to get the accrued interest.                         CSE035
      *                                                                                       CSE035
     C     NNXSV         IFEQ      'Y'                                                        CSE035
     C     PROT          ANDEQ     '1'                                                        CSE035
     C                   Z-ADD     ZVSDAT        ZSDATE                                       CSE035
     C                   Z-ADD     ZVEDAT        ZEDATE                                       CSE035
     C                   EXSR      ZDAYS                                                      CSE035
     C                   Z-ADD     ZDDAYS        FNNX              5 0                        CSE035
     C                   Z-ADD     NextCoupDate  ZEDATE                                       CSE035
     C                   EXSR      ZDAYS                                                      CSE035
     C                   Z-ADD     ZDDAYS        DNNX              5 0                        CSE035
     C     ZAC100        MULT      FNNX          ZAC100                                       CSE035
     C     ZAC100        DIV (H)   DNNX          ZAC100                                       CSE035
      *                                                                                       CSE035
      * Adjust no. of decimal places                                                          CSE035
      *                                                                                       CSE035
     C                   Z-ADD     ZAC100        ZINPF            15 8                        CSE035
     C     ZVSDAT        IFEQ      LCDD5                                                      CSE035
     C     ZVEDAT        ANDEQ     NCDD5                                                      CSE035
     C     DVBS          ANDEQ     '5'                                                        CSE035
     C     ZVSDAT        OREQ      ZLCDN5                                                     CSE035
     C     ZVEDAT        ANDEQ     NextCoupDate                                               CSE035
     C     DVBS          ANDNE     '5'                                                        CSE035
     C     ZVSDAT        OREQ      ITLD                                                       CSE035
     C     ZVEDAT        ANDEQ     FCPN                                                       CSE035
     C                   Z-ADD     ZINPF         ZOUTF            15 8                        CSE035
     C                   ELSE                                                                 CSE035
      *                                                                                       CSE035
     C                   CALL      'SEADJPRI'                                                 CSE035
     C                   PARM      *BLANKS       @RTCD             7                          CSE035
     C                   PARM      SESN          @SEKEY           10                          CSE035
     C     ZINPF         PARM      ZINPF         @INAMT           15 8                        CSE035
     C     ZOUTF         PARM      ZOUTF         @OUAMT           15 8                        CSE035
      *                                                                                       CSE035
     C                   ENDIF                                                                CSE035
     C     NextCoupDate  IFGE      MATY                                                       CSE035
     C     SYBS          ANDEQ     'AU'                                                       CSE035
     C                   Z-ADD     ZINPF         ZOUTF                                        CSE035
     C                   END                                                                  CSE035
      *                                                                                       CSE035
      * Calculate interest                                                                    CSE035
      *                                                                                       CSE035
     C     ZAMT          DIV       100           ZWZAMT           15 2                        CSE035
     C     ZWZAMT        MULT (H)  ZOUTF         ZWACCR           15 3                        CSE035
     C     ZWACCR        MULT (H)  POWER8 (DC)   WACCRD                                       CSE035
     C                   Z-ADD     WACCRD        ZACCRD                                       CSE035
     C     ZWACCR        MULT (H)  POWER8 (DC)   WACCXD                                       CSE035
     C                   Z-ADD     WACCRD        ZACCXD                                       CSE035
     C                   END                                                                  CSE035
      *                                                                                       CSE035
     C                   END                                                                  CSE035
      *                                                                                       CSE035
     C*
     C* Set up Pay, Rec, Zero ind
     C     ZACCRD        IFGT      0
     C                   MOVE      'R'           ZRP               1
     C                   ELSE
     C     ZACCRD        IFLT      0
     C                   MOVE      'P'           ZRP
     C                   ELSE
     C                   MOVE      'X'           ZRP
     C                   END
     C                   END
     C*                                                                   E14496
     C* RESTORE ORIGINAL START AND END DATES.                             E14496
     C                   Z-ADD     ZVSDAT        ZSDATE                                        E1449
     C                   Z-ADD     ZVEDAT        ZEDATE                                        E1449
     C                   Z-ADD     ZVECD         ECD                                           E1449
     C*
     C     EZACCR        ENDSR                                                  **EZACCR ENDSR**
     C*
     C*****************************************************************
 
      ** +--- The converted ZACCRZ1 ends here ----------------------------+
 
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZACCR in this module executes another standard subroutine,       *
      *   ZDYYR, which has also been converted to a module.                *
      *  This subroutine is also called ZDYYR and simply does a CALLB to   *
      *   the module that contains subroutine ZDYYR                        *
      *                                                                    *
     C     ZDYYR         BEGSR
 
     C                   CALLB     'ZDYYR'
     C                   PARM                    DYBS
     C                   PARM                    DVBS
     C                   PARM                    ISSD
     C                   PARM                    ITLD
     C                   PARM                    LCPN
     C                   PARM                    FCPN
     C                   PARM                    MATY
     C                   PARM                    IADJ
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    CPNR                           149162
     C                   PARM                    DADJN
     C*****              PARM                    NCD                                          CSE031
     C                   PARM                    NextCoupDate                                 CSE031
     C                   PARM                    ECD
     C                   PARM                    BJDFIN
     C                   PARM                    HCY1                                         CSE071
     C                   PARM                    HCY2                                         CSE071
     C                   PARM                    HCY3                                         CSE071
     C                   PARM                    HCY4                                         CSE071
     C                   PARM                    HCY5                                         CSE071
     C                   PARM                    HCY6                                         CSE071
     C                   PARM                    HCY7                                         CSE071
     C                   PARM                    HCY8                                         CSE071
     C                   PARM                    HCY9                                         CSE071
     C                   PARM                    ZINTDD
     C                   PARM                    LCDD5
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZACCR in this module executes another standard subroutine,       *
      *   ZDAYS, which has also been converted to a module.                *
      *  This subroutine is also called ZDAYS and simply does a CALLB to   *
      *   the module that contains subroutine ZDAYS                        *
      *                                                                    *
     C     ZDAYS         BEGSR
 
     C                   CALLB     'ZDAYS'
     C                   PARM                    ZSDATE
     C                   PARM                    ZEDATE
     C                   PARM                    DYBS
     C                   PARM                    ITLD
     C                   PARM                    LCPN
     C                   PARM                    IADJ
     C                   PARM                    CPNR                           149162
     C                   PARM                    MATY                           149162
     C*****              PARM                    NCD                                   149162 CSE031
     C                   PARM                    NextCoupDate                                 CSE031
     C                   PARM                    DADJN
     C                   PARM                    ZIDNAT            2 0          149162
     C                   PARM                    ZACLT             1            149162
     C                   PARM                    ACLD              1            149162
     C                   PARM                    BJDFIN
     C                   PARM                    ZDDAYS
     C                   PARM                    ZODNAT            2 0          149162
 
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
 
     C     *entry        PLIST
 
      * INPUTS
 
      ** Principal amount  (15P 0)
      ** Interest Rate (15P 9)
      ** Start date (5P 0)
      ** End date (5P 0)
     C                   PARM                    ZAMT
     C                   PARM                    IRATE
     C                   PARM                    ZSDATE
     C                   PARM                    ZEDATE
      *
      ** Security Details
      ** interest days adjustment
      ** Next Coupon Date (5P 0)
      ** Nominal currency decimal places  (1P 0)
      ** Processing type  (1A)
     C                   PARM                    SECTY
     C                   PARM                    DADJN
     C*****              PARM                    NCD                                          CSE031
     C                   PARM                    NextCoupdate                                 CSE031
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
 
      ** System Info
      ** Date format (1A)
     C                   PARM                    BJDFIN
 
      * OUTPUTS
 
      ** Interest Accrued (15,0)
      ** Interest Accrued (15,1)
      ** Pay/Rec/Zero Indicator  (1A)
      ** No. of days in time frame (ZDAYS output)
      ** No. of days in interest year (ZDYYR output)
     C                   PARM                    ZACCRD
     C                   PARM                    ZACCXD
     C                   PARM                    ZRP
     C                   PARM                    ZDDAYS
     C                   PARM                    ZINTDD
      *                                                                                       CSE035
     C                   CALLB     'AOSARDR0'                                                 CSE035
     C                   PARM      *BLANKS       @RTCD             7                          CSE035
     C                   PARM      '*VERIFY'     @OPTN             7                          CSE035
     C                   PARM      'CSE035'      @SARD             6                          CSE035
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE035
      *                                                                                       CSE035
     C     @RTCD         IFEQ      *BLANK                                                     CSE035
     C                   MOVEL     'Y'           CSE035            1                          CSE035
     C                   ELSE                                                                 CSE035
     C                   MOVEL     'N'           CSE035                                       CSE035
     C                   END                                                                  CSE035
      *                                                                                       209231
     C                   CALLB     'AOSARDR0'                                                 209231
     C                   PARM      *BLANKS       @RTCD             7                          209231
     C                   PARM      '*VERIFY'     @OPTN             7                          209231
     C                   PARM      'CSE037'      @SARD             6                          209231
     C     SCSARD        PARM      SCSARD        DSFDY                                        209231
      *                                                                                       209231
     C     @RTCD         IFEQ      *BLANK                                                     209231
     C                   MOVEL     'Y'           CSE037            1                          209231
     C                   ELSE                                                                 209231
     C                   MOVEL     'N'           CSE037                                       209231
     C                   END                                                                  209231
 
     C                   ENDSR
      **********************************************************************                  CSE035
      *                                                                    *                  CSE035
      *  This subroutine is to cater for the fact that standard subroutine *                  CSE035
      *   ZCALCD in this module executes another standard subroutine,      *                  CSE035
      *   ZLCD, which has also been converted to a module.                 *                  CSE035
      *  This subroutine is also called ZLCD and simply does a CALLB to    *                  CSE035
      *   the module that contains subroutine ZLCD                         *                  CSE035
      *                                                                    *                  CSE035
      **********************************************************************                  CSE035
     C     ZLCD          BEGSR                                                                CSE035
                                                                                              CSE035
     C                   CALLB     'ZLCD'                                                     CSE035
     C                   PARM                    ISSD                                         CSE035
     C                   PARM                    ITLD                                         CSE035
     C                   PARM                    FCPN                                         CSE035
     C                   PARM                    MATY                                         CSE035
     C                   PARM                    CDArr                                        CSE035
     C                   PARM                    CRArr                                        CSE035
     C                   PARM                    LCPN                                       BUG11164
     C                   PARM                    ZECD              5 0                        CSE035
     C                   PARM                    BJDFIN                                       CSE035
      *                                                                                       CSE035
      ** Nominal Currency                                                                     CSE035
      ** Security Investment Type                                                             CSE035
      ** Effect on Holidays on Coupon Dates                                                   CSE035
     C                   PARM                    NMCY              3                          CSE035
     C                   PARM                    SITP              3                          CSE035
     C                   PARM                    BCNV              1                          CSE035
      ** Effect of Holidays on Dates                                                          CSE071
     C                   PARM                    HCY1                                         CSE071
     C                   PARM                    HCY2                                         CSE071
     C                   PARM                    HCY3                                         CSE071
     C                   PARM                    HCY4                                         CSE071
     C                   PARM                    HCY5                                         CSE071
     C                   PARM                    HCY6                                         CSE071
     C                   PARM                    HCY7                                         CSE071
     C                   PARM                    HCY8                                         CSE071
     C                   PARM                    HCY9                                         CSE071
     C                   PARM                    ZZLCD             5 0                        CSE035
                                                                                              CSE035
     C                   ENDSR                                                                CSE035
      **********************************************************************                  CSE035
 
     C/COPY WNCPYSRC,ZACCRC008
      *****************************************************************
**  POWER8 - ARRAY OF POWERS FOR CURRENCY CONVERSION
00000001
00000010
00000100
00001000
00010000
00100000
01000000
10000000
