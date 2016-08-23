/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MR Write Historic Balances')                     *
/*XBIA*  OVRDBF FILE(MRPCMXL1H) TOFILE(MRPCMXL1) MBR(HIST)            *
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting Module                           *
      *                                                               *
      *  MR000020 -  Write Historic Balances                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CMR001             Date 01Sep04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CMR001 - MidasPlus Reporting                                 *
      *                                                               *
      *****************************************************************
 
     FMRPOSTXL1 IP  AE           K DISK    INFSR(*PSSR)
     FACCBR     IS  AE           K DISK    INFSR(*PSSR)
     FMRPCMXL1H IF   E           K DISK    RENAME(MRPCMXD0:HistMonth)
     F                                     INFSR(*PSSR)
     FMRRPRMPD  IF   E             DISK    INFSR(*PSSR)
     FMRHIBLPD  O    E             DISK    INFSR(*PSSR)
 
     D POWER           S              8  0 DIM(8) CTDATA PERRCD(1)
 
     D SDCUHS        E DS                  EXTNAME(SDCUHSPD)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
 
      * Years/Months
     D #_YM            S              4    DIM(24)
     D #_YMSOPD        S              5S 0 DIM(24)
     D #_YMEOPD        S              5S 0 DIM(24)
     D #_YMACEP        S             18S 3 DIM(24)
     D #_YMBSEP        S             18S 3 DIM(24)
     D #_YMR1EP        S             18S 3 DIM(24)
     D #_YMR2EP        S             18S 3 DIM(24)
     D #_YMACd         S             18S 3 DIM(24)
     D #_YMBSd         S             18S 3 DIM(24)
     D #_YMR1d         S             18S 3 DIM(24)
     D #_YMR2d         S             18S 3 DIM(24)
     D #_YMACc         S             18S 3 DIM(24)
     D #_YMBSc         S             18S 3 DIM(24)
     D #_YMR1c         S             18S 3 DIM(24)
     D #_YMR2c         S             18S 3 DIM(24)
     D #_YMACCH        S             18S 3 DIM(24)
     D #_YMBSCH        S             18S 3 DIM(24)
     D #_YMR1CH        S             18S 3 DIM(24)
     D #_YMR2CH        S             18S 3 DIM(24)
     D #_YMBTFR        S             18S 3 DIM(24)
     D #_YMBTFR1       S             18S 3 DIM(24)
     D #_YMBTFR2       S             18S 3 DIM(24)
     D #_YMFTFAC       S             18S 3 DIM(24)
     D #_YMFTFBS       S             18S 3 DIM(24)
     D #_YMFTFR1       S             18S 3 DIM(24)
     D #_YMFTFR2       S             18S 3 DIM(24)
 
      * Years/Quarters
     D #_YQ            S              4    DIM(8)
     D #_YQSOPD        S              5S 0 DIM(8)
     D #_YQEOPD        S              5S 0 DIM(8)
     D #_YQACEP        S             18S 3 DIM(8)
     D #_YQBSEP        S             18S 3 DIM(8)
     D #_YQR1EP        S             18S 3 DIM(8)
     D #_YQR2EP        S             18S 3 DIM(8)
     D #_YQACd         S             18S 3 DIM(8)
     D #_YQBSd         S             18S 3 DIM(8)
     D #_YQR1d         S             18S 3 DIM(8)
     D #_YQR2d         S             18S 3 DIM(8)
     D #_YQACc         S             18S 3 DIM(8)
     D #_YQBSc         S             18S 3 DIM(8)
     D #_YQR1c         S             18S 3 DIM(8)
     D #_YQR2c         S             18S 3 DIM(8)
     D #_YQACCH        S             18S 3 DIM(8)
     D #_YQBSCH        S             18S 3 DIM(8)
     D #_YQR1CH        S             18S 3 DIM(8)
     D #_YQR2CH        S             18S 3 DIM(8)
     D #_YQBTFR        S             18S 3 DIM(8)
     D #_YQBTFR1       S             18S 3 DIM(8)
     D #_YQBTFR2       S             18S 3 DIM(8)
     D #_YQFTFAC       S             18S 3 DIM(8)
     D #_YQFTFBS       S             18S 3 DIM(8)
     D #_YQFTFR1       S             18S 3 DIM(8)
     D #_YQFTFR2       S             18S 3 DIM(8)
 
      * Years/Half-Years
     D #_YH            S              4    DIM(4)
     D #_YHSOPD        S              5S 0 DIM(4)
     D #_YHEOPD        S              5S 0 DIM(4)
     D #_YHACEP        S             18S 3 DIM(4)
     D #_YHBSEP        S             18S 3 DIM(4)
     D #_YHR1EP        S             18S 3 DIM(4)
     D #_YHR2EP        S             18S 3 DIM(4)
     D #_YHACd         S             18S 3 DIM(4)
     D #_YHBSd         S             18S 3 DIM(4)
     D #_YHR1d         S             18S 3 DIM(4)
     D #_YHR2d         S             18S 3 DIM(4)
     D #_YHACc         S             18S 3 DIM(4)
     D #_YHBSc         S             18S 3 DIM(4)
     D #_YHR1c         S             18S 3 DIM(4)
     D #_YHR2c         S             18S 3 DIM(4)
     D #_YHACCH        S             18S 3 DIM(4)
     D #_YHBSCH        S             18S 3 DIM(4)
     D #_YHR1CH        S             18S 3 DIM(4)
     D #_YHR2CH        S             18S 3 DIM(4)
     D #_YHBTFR        S             18S 3 DIM(4)
     D #_YHBTFR1       S             18S 3 DIM(4)
     D #_YHBTFR2       S             18S 3 DIM(4)
     D #_YHFTFAC       S             18S 3 DIM(4)
     D #_YHFTFBS       S             18S 3 DIM(4)
     D #_YHFTFR1       S             18S 3 DIM(4)
     D #_YHFTFR2       S             18S 3 DIM(4)
 
      * Years
     D #_Y_            S              4    DIM(2)
     D #_Y_SOPD        S              5S 0 DIM(2)
     D #_Y_EOPD        S              5S 0 DIM(2)
     D #_Y_ACEP        S             18S 3 DIM(2)
     D #_Y_BSEP        S             18S 3 DIM(2)
     D #_Y_R1EP        S             18S 3 DIM(2)
     D #_Y_R2EP        S             18S 3 DIM(2)
     D #_Y_ACd         S             18S 3 DIM(2)
     D #_Y_BSd         S             18S 3 DIM(2)
     D #_Y_R1d         S             18S 3 DIM(2)
     D #_Y_R2d         S             18S 3 DIM(2)
     D #_Y_ACc         S             18S 3 DIM(2)
     D #_Y_BSc         S             18S 3 DIM(2)
     D #_Y_R1c         S             18S 3 DIM(2)
     D #_Y_R2c         S             18S 3 DIM(2)
     D #_Y_ACCH        S             18S 3 DIM(2)
     D #_Y_BSCH        S             18S 3 DIM(2)
     D #_Y_R1CH        S             18S 3 DIM(2)
     D #_Y_R2CH        S             18S 3 DIM(2)
     D #_Y_BTFR        S             18S 3 DIM(2)
     D #_Y_BTFR1       S             18S 3 DIM(2)
     D #_Y_BTFR2       S             18S 3 DIM(2)
     D #_Y_FTFAC       S             18S 3 DIM(2)
     D #_Y_FTFBS       S             18S 3 DIM(2)
     D #_Y_FTFR1       S             18S 3 DIM(2)
     D #_Y_FTFR2       S             18S 3 DIM(2)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     D                 DS
     D DayMonthYear            1      6  0
     D Day                     1      2  0
     D Month                   3      4  0
     D Year                    5      6  0
 
 
     IMRPOSTD0      01
     I                                          BRCA          L1M5
     I                                          CNUM          L1M4
     I                                          CCY           L1M3
     I                                          ACOD          L1M2
     I                                          ACSQ          L1M1
 
     IACCNTABF      02
     I                                          BRCA          L1M5
     I                                          CNUM          L1M4
     I                                          CCY           L1M3
     I                                          ACOD          L1M2
     I                                          ACSQ          L1M1
 
     C
     C   01              EXSR      POSTING
     C   01
     CANNMR              SETON                                        20
 
     C   02              SETOFF                                       20
     C   02              EXSR      WRT_ACH
     C   02              EXSR      CLR_TOTS
 
     CL1 20              Z-ADD     *zero         LDBL
     CL1 20              EXSR      WRT_ACH
     CL1 20              EXSR      CLR_TOTS
     CL1                 SETOFF                                       20
      /SPACE 5
     C**********************************************************************************
     C     POSTING       BEGSR
 
      * Update YM totals
 
     C     I#CAFI        IFEQ      'C'
     C                   MOVEL     CY            YM                4
     C                   MOVE      CM            YM
     C                   ELSE
     C                   MOVEL     FY            YM
     C                   MOVE      FM            YM
     C                   ENDIF
     C                   EXSR      UPD_YM
 
      * Update YQ totals
 
     C     I#CAFI        IFEQ      'C'
     C                   MOVEL     CY            YQ                4
     C                   MOVE      CQ            YQ
     C                   ELSE
     C                   MOVEL     FY            YQ
     C                   MOVE      FQ            YQ
     C                   ENDIF
     C                   EXSR      UPD_YQ
 
      * Update YH totals
 
     C     I#CAFI        IFEQ      'C'
     C                   MOVEL     CY            YH                4
     C                   MOVE      CH            YH
     C                   ELSE
     C                   MOVEL     FY            YH
     C                   MOVE      FH            YH
     C                   ENDIF
     C                   EXSR      UPD_YH
 
      * Update Y_ totals
 
     C     I#CAFI        IFEQ      'C'
     C                   MOVEL     CY            Y_                4
     C                   ELSE
     C                   MOVEL     FY            Y_
     C                   ENDIF
     C                   EXSR      UPD_Y_
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     UPD_YM        BEGSR
 
      * Update Year Month totals
 
     C                   Z-ADD     1             X                 2 0
     C     YM            LOOKUP    #_YM(X)                                99
     C     *IN99         IFEQ      *ON
     C     DRCR          IFEQ      0
     C                   ADD       PSTAAC        #_YMACd(X)
     C                   ELSE
     C                   ADD       PSTAAC        #_YMACc(X)
     C                   ENDIF
     C     SPOS          IFEQ      '  GE-XB'
     C     DRCR          IFEQ      0
     C                   ADD       PSTABS        #_YMBTFR(X)
     C                   ADD       PSTAR1        #_YMBTFR1(X)
     C                   ADD       PSTAR2        #_YMBTFR2(X)
     C                   ELSE
     C                   ADD       PSTABS        #_YMBTFR(X)
     C                   ADD       PSTAR1        #_YMBTFR1(X)
     C                   ADD       PSTAR2        #_YMBTFR2(X)
     C                   ENDIF
     C                   ENDIF
     C     SPOS          IFEQ      '  GE-XF'
     C     DRCR          IFEQ      0
     C                   ADD       PSTAAC        #_YMFTFAC(X)
     C                   ADD       PSTABS        #_YMFTFBS(X)
     C                   ADD       PSTAR1        #_YMFTFR1(X)
     C                   ADD       PSTAR2        #_YMFTFR2(X)
     C                   ELSE
     C                   ADD       PSTAAC        #_YMFTFAC(X)
     C                   ADD       PSTABS        #_YMFTFBS(X)
     C                   ADD       PSTAR1        #_YMFTFR1(X)
     C                   ADD       PSTAR2        #_YMFTFR2(X)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     UPD_YQ        BEGSR
 
      * Update Year Quater totals
 
     C                   Z-ADD     1             X                 2 0
     C     YQ            LOOKUP    #_YQ(X)                                99
     C     *IN99         IFEQ      *ON
     C     DRCR          IFEQ      0
     C                   ADD       PSTAAC        #_YQACd(X)
     C                   ADD       PSTABS        #_YQBSd(X)
     C                   ADD       PSTAR1        #_YQR1d(X)
     C                   ADD       PSTAR2        #_YQR2d(X)
     C                   ELSE
     C                   ADD       PSTAAC        #_YQACc(X)
     C                   ADD       PSTABS        #_YQBSc(X)
     C                   ADD       PSTAR1        #_YQR1c(X)
     C                   ADD       PSTAR2        #_YQR2c(X)
     C                   ENDIF
     C     SPOS          IFEQ      '  GE-XB'
     C     DRCR          IFEQ      0
     C                   ADD       PSTABS        #_YQBTFR(X)
     C                   ADD       PSTAR1        #_YQBTFR1(X)
     C                   ADD       PSTAR2        #_YQBTFR2(X)
     C                   ELSE
     C                   ADD       PSTABS        #_YQBTFR(X)
     C                   ADD       PSTAR1        #_YQBTFR1(X)
     C                   ADD       PSTAR2        #_YQBTFR2(X)
     C                   ENDIF
     C                   ENDIF
     C     SPOS          IFEQ      '  GE-XF'
     C     DRCR          IFEQ      0
     C                   ADD       PSTAAC        #_YQFTFAC(X)
     C                   ADD       PSTABS        #_YQFTFBS(X)
     C                   ADD       PSTAR1        #_YQFTFR1(X)
     C                   ADD       PSTAR2        #_YQFTFR2(X)
     C                   ELSE
     C                   ADD       PSTAAC        #_YQFTFAC(X)
     C                   ADD       PSTABS        #_YQFTFBS(X)
     C                   ADD       PSTAR1        #_YQFTFR1(X)
     C                   ADD       PSTAR2        #_YQFTFR2(X)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     UPD_YH        BEGSR
 
      * Update Year Half totals
 
     C                   Z-ADD     1             X                 2 0
     C     YH            LOOKUP    #_YH(X)                                99
     C     *IN99         IFEQ      *ON
     C     DRCR          IFEQ      0
     C                   ADD       PSTAAC        #_YHACd(X)
     C                   ADD       PSTABS        #_YHBSd(X)
     C                   ADD       PSTAR1        #_YHR1d(X)
     C                   ADD       PSTAR2        #_YHR2d(X)
     C                   ELSE
     C                   ADD       PSTAAC        #_YHACc(X)
     C                   ADD       PSTABS        #_YHBSc(X)
     C                   ADD       PSTAR1        #_YHR1c(X)
     C                   ADD       PSTAR2        #_YHR2c(X)
     C                   ENDIF
     C     SPOS          IFEQ      '  GE-XB'
     C     DRCR          IFEQ      0
     C                   ADD       PSTABS        #_YHBTFR(X)
     C                   ADD       PSTAR1        #_YHBTFR1(X)
     C                   ADD       PSTAR2        #_YHBTFR2(X)
     C                   ELSE
     C                   ADD       PSTABS        #_YHBTFR(X)
     C                   ADD       PSTAR1        #_YHBTFR1(X)
     C                   ADD       PSTAR2        #_YHBTFR2(X)
     C                   ENDIF
     C                   ENDIF
     C     SPOS          IFEQ      '  GE-XF'
     C     DRCR          IFEQ      0
     C                   ADD       PSTAAC        #_YHFTFAC(X)
     C                   ADD       PSTABS        #_YHFTFBS(X)
     C                   ADD       PSTAR1        #_YHFTFR1(X)
     C                   ADD       PSTAR2        #_YHFTFR2(X)
     C                   ELSE
     C                   ADD       PSTAAC        #_YHFTFAC(X)
     C                   ADD       PSTABS        #_YHFTFBS(X)
     C                   ADD       PSTAR1        #_YHFTFR1(X)
     C                   ADD       PSTAR2        #_YHFTFR2(X)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     UPD_Y_        BEGSR
 
      * Update Year totals
 
     C                   Z-ADD     1             X                 2 0
     C     Y_            LOOKUP    #_Y_(X)                                99
     C     *IN99         IFEQ      *ON
     C     DRCR          IFEQ      0
     C                   ADD       PSTAAC        #_Y_ACd(X)
     C                   ADD       PSTABS        #_Y_BSd(X)
     C                   ADD       PSTAR1        #_Y_R1d(X)
     C                   ADD       PSTAR2        #_Y_R2d(X)
     C                   ELSE
     C                   ADD       PSTAAC        #_Y_ACc(X)
     C                   ADD       PSTABS        #_Y_BSc(X)
     C                   ADD       PSTAR1        #_Y_R1c(X)
     C                   ADD       PSTAR2        #_Y_R2c(X)
     C                   ENDIF
     C     SPOS          IFEQ      '  GE-XB'
     C     DRCR          IFEQ      0
     C                   ADD       PSTABS        #_Y_BTFR(X)
     C                   ADD       PSTAR1        #_Y_BTFR1(X)
     C                   ADD       PSTAR2        #_Y_BTFR2(X)
     C                   ELSE
     C                   ADD       PSTABS        #_Y_BTFR(X)
     C                   ADD       PSTAR1        #_Y_BTFR1(X)
     C                   ADD       PSTAR2        #_Y_BTFR2(X)
     C                   ENDIF
     C                   ENDIF
     C     SPOS          IFEQ      '  GE-XF'
     C     DRCR          IFEQ      0
     C                   ADD       PSTAAC        #_Y_FTFAC(X)
     C                   ADD       PSTABS        #_Y_FTFBS(X)
     C                   ADD       PSTAR1        #_Y_FTFR1(X)
     C                   ADD       PSTAR2        #_Y_FTFR2(X)
     C                   ELSE
     C                   ADD       PSTAAC        #_Y_FTFAC(X)
     C                   ADD       PSTABS        #_Y_FTFBS(X)
     C                   ADD       PSTAR1        #_Y_FTFR1(X)
     C                   ADD       PSTAR2        #_Y_FTFR2(X)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     WRT_ACH       BEGSR
      * Get Account Currency Details
     C                   CALL      'MR000101'
     C                   PARM      CCY           I#CCY
     C                   PARM                    SDCURR
     C                   Z-ADD     A6NBDP        AcctCDP           1 0
 
     C                   EXSR      SETEPB_YM
     C                   EXSR      SETEPB_YQ
     C                   EXSR      SETEPB_YH
     C                   EXSR      SETEPB_Y_
 
     C                   EXSR      WRT_YM
     C                   EXSR      WRT_YQ
     C                   EXSR      WRT_YH
     C                   EXSR      WRT_Y_
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     SETEPB_YM     BEGSR
 
     C                   Z-ADD     *zero         #_YMACEP
     C                   Z-ADD     *zero         #_YMBSEP
     C                   Z-ADD     *zero         #_YMR1EP
     C                   Z-ADD     *zero         #_YMR2EP
 
     C                   Z-add     25            Y                 2 0
     C                   Z-add     24            X
     C     X             DOWGE     1
 
      * Set first balance to be ledger balance from ACCNTAB.
      * Otherwise, balance = previous balance - previous DR/CR movements
 
     C     X             IFEQ      24
     C     AcctCDP       ADD       1             CA                1 0
     C     LDBL          DIV       POWER(CA)     #_YMACEP(X)
     C                   ELSE
     C     #_YMACEP(Y)   SUB       #_YMACd(Y)    #_YMACEP(X)
     C                   SUB       #_YMACc(Y)    #_YMACEP(X)
     C                   ENDIF
 
      * Get Historic Rates (Account Currency, Reporting Currency 1, Reporting Currency 2)
 
     C                   Z-ADD     #_YMEOPD(X)   HistDate          5 0
     C                   EXSR      GETHistRATES
 
      * Determine Cross Rates from Account Currency -> Reporting Currency 1 and 2
 
     C                   EXSR      DETCrossRATES
 
      * Adjust end of period ledger balance for account currency decimal places
 
     C                   Z-ADD     #_YMACEP(X)   EOPLedgerBal     18 3
     C                   EVAL      CA = AcctCDP + 1
     C                   EVAL      EOPLedgerBal = EOPLedgerBal * POWER(CA)
 
      * Convert EOP LEDGER BALANCE from account currency amount to base currency
 
     C                   Z-ADD     EOPLedgerBal  ZAMTCI
     C                   EXSR      CONV_AC2BS
     C                   Z-ADD     ZAMTCO        #_YMBSEP(X)
     C                   EVAL      CA = BaseCDP + 1
     C                   EVAL      #_YMBSEP(X) = #_YMBSEP(X) / POWER(CA)
 
      * Convert EOP LEDGER BALANCE from account currency amount to reporting currency 1
 
     C                   Z-ADD     EOPLedgerBal  ZAMTCI
     C                   EXSR      CONV_AC2R1
     C                   Z-ADD     ZAMTCO        #_YMR1EP(X)
     C                   EVAL      CA = RpC1CDP + 1
     C                   EVAL      #_YMR1EP(X) = #_YMR1EP(X) / POWER(CA)
 
      * Convert EOP LEDGER BALANCE from account currency amount to reporting currency 2
 
     C                   Z-ADD     EOPLedgerBal  ZAMTCI
     C                   EXSR      CONV_AC2R2
     C                   Z-ADD     ZAMTCO        #_YMR2EP(X)
     C                   EVAL      CA = RpC2CDP + 1
     C                   EVAL      #_YMR2EP(X) = #_YMR2EP(X) / POWER(CA)
 
      * Convert DR MOVES from account currency amount to base currency
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_YMACd(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2BS
     C                   Z-ADD     ZAMTCO        #_YMBSd(X)
     C                   EVAL      CA = BaseCDP + 1
     C                   EVAL      #_YMBSd(X) = #_YMBSd(X) / POWER(CA)
 
      * Convert DR MOVES from account currency amount to reporting currency 1
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_YMACd(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2R1
     C                   Z-ADD     ZAMTCO        #_YMR1d(X)
     C                   EVAL      CA = RpC1CDP + 1
     C                   EVAL      #_YMR1d(X) = #_YMR1d(X) / POWER(CA)
 
      * Convert DR MOVES from account currency amount to reporting currency 2
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_YMACd(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2R2
     C                   Z-ADD     ZAMTCO        #_YMR2d(X)
     C                   EVAL      CA = RpC2CDP + 1
     C                   EVAL      #_YMR2d(X) = #_YMR2d(X) / POWER(CA)
 
      * Convert CR MOVES from account currency amount to base currency
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_YMACc(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2BS
     C                   Z-ADD     ZAMTCO        #_YMBSc(X)
     C                   EVAL      CA = BaseCDP + 1
     C                   EVAL      #_YMBSc(X) = #_YMBSc(X) / POWER(CA)
 
      * Convert CR MOVES from account currency amount to reporting currency 1
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_YMACc(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2R1
     C                   Z-ADD     ZAMTCO        #_YMR1c(X)
     C                   EVAL      CA = RpC1CDP + 1
     C                   EVAL      #_YMR1c(X) = #_YMR1c(X) / POWER(CA)
 
      * Convert CR MOVES from account currency amount to reporting currency 2
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_YMACc(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2R2
     C                   Z-ADD     ZAMTCO        #_YMR2c(X)
     C                   EVAL      CA = RpC2CDP + 1
     C                   EVAL      #_YMR2c(X) = #_YMR2c(X) / POWER(CA)
 
      * Change in balance
      * ACCOUNT
     C     X             IFEQ      1
     C                   Z-ADD     #_YMACEP(X)   #_YMACCH(X)
     C                   ENDIF
     C     Y             IFLE      24
     C     #_YMACEP(Y)   SUB       #_YMACEP(X)   #_YMACCH(Y)
     C                   ENDIF
      * BASE
     C     X             IFEQ      1
     C                   Z-ADD     #_YMBSEP(X)   #_YMBSCH(X)
     C                   ENDIF
     C     Y             IFLE      24
     C     #_YMBSEP(Y)   SUB       #_YMBSEP(X)   #_YMBSCH(Y)
     C                   ENDIF
      * REPORT CCY 1
     C     X             IFEQ      1
     C                   Z-ADD     #_YMR1EP(X)   #_YMR1CH(X)
     C                   ENDIF
     C     Y             IFLE      24
     C     #_YMR1EP(Y)   SUB       #_YMR1EP(X)   #_YMR1CH(Y)
     C                   ENDIF
      * REPORT CCY 2
     C     X             IFEQ      1
     C                   Z-ADD     #_YMR2EP(X)   #_YMR2CH(X)
     C                   ENDIF
     C     Y             IFLE      24
     C     #_YMR2EP(Y)   SUB       #_YMR2EP(X)   #_YMR2CH(Y)
     C                   ENDIF
 
     C                   SUB       1             X
     C                   SUB       1             Y
     C                   ENDDO
 
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     SETEPB_YQ     BEGSR
 
     C                   Z-ADD     *zero         #_YQACEP
     C                   Z-ADD     *zero         #_YQBSEP
     C                   Z-ADD     *zero         #_YQR1EP
     C                   Z-ADD     *zero         #_YQR2EP
 
     C                   Z-add     9             Y
     C                   Z-add     8             X
     C     X             DOWGE     1
 
      * Set first balance to be ledger balance from ACCNTAB.
      * Otherwise, balance = previous balance - previous DR/CR movements
 
     C     X             IFEQ      8
     C     AcctCDP       ADD       1             CA
     C     LDBL          DIV       POWER(CA)     #_YQACEP(X)
     C                   ELSE
     C     #_YQACEP(Y)   SUB       #_YQACd(Y)    #_YQACEP(X)
     C                   SUB       #_YQACc(Y)    #_YQACEP(X)
     C                   ENDIF
 
      * Get Historic Rates (Account Currency, Reporting Currency 1, Reporting Currency 2)
 
     C                   Z-ADD     #_YQEOPD(X)   HistDate
     C                   EXSR      GETHistRATES
 
      * Determine Cross Rates from Account Currency -> Reporting Currency 1 and 2
 
     C                   EXSR      DETCrossRATES
 
      * Adjust end of period ledger balance for account currency decimal places
 
     C                   Z-ADD     #_YQACEP(X)   EOPLedgerBal
     C                   EVAL      CA = AcctCDP + 1
     C                   EVAL      EOPLedgerBal = EOPLedgerBal * POWER(CA)
 
      * Convert EOP LEDGER BALANCE from account currency amount to base currency
 
     C                   Z-ADD     EOPLedgerBal  ZAMTCI
     C                   EXSR      CONV_AC2BS
     C                   Z-ADD     ZAMTCO        #_YQBSEP(X)
     C                   EVAL      CA = BaseCDP + 1
     C                   EVAL      #_YQBSEP(X) = #_YQBSEP(X) / POWER(CA)
 
      * Convert EOP LEDGER BALANCE from account currency amount to reporting currency 1
 
     C                   Z-ADD     EOPLedgerBal  ZAMTCI
     C                   EXSR      CONV_AC2R1
     C                   Z-ADD     ZAMTCO        #_YQR1EP(X)
     C                   EVAL      CA = RpC1CDP + 1
     C                   EVAL      #_YQR1EP(X) = #_YQR1EP(X) / POWER(CA)
 
      * Convert EOP LEDGER BALANCE from account currency amount to reporting currency 2
 
     C                   Z-ADD     EOPLedgerBal  ZAMTCI
     C                   EXSR      CONV_AC2R2
     C                   Z-ADD     ZAMTCO        #_YQR2EP(X)
     C                   EVAL      CA = RpC2CDP + 1
     C                   EVAL      #_YQR2EP(X) = #_YQR2EP(X) / POWER(CA)
 
      * Convert DR MOVES from account currency amount to base currency
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_YQACd(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2BS
     C                   Z-ADD     ZAMTCO        #_YQBSd(X)
     C                   EVAL      CA = BaseCDP + 1
     C                   EVAL      #_YQBSd(X) = #_YQBSd(X) / POWER(CA)
 
      * Convert DR MOVES from account currency amount to reporting currency 1
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_YQACd(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2R1
     C                   Z-ADD     ZAMTCO        #_YQR1d(X)
     C                   EVAL      CA = RpC1CDP + 1
     C                   EVAL      #_YQR1d(X) = #_YQR1d(X) / POWER(CA)
 
      * Convert DR MOVES from account currency amount to reporting currency 2
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_YQACd(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2R2
     C                   Z-ADD     ZAMTCO        #_YQR2d(X)
     C                   EVAL      CA = RpC2CDP + 1
     C                   EVAL      #_YQR2d(X) = #_YQR2d(X) / POWER(CA)
 
      * Convert CR MOVES from account currency amount to base currency
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_YQACc(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2BS
     C                   Z-ADD     ZAMTCO        #_YQBSc(X)
     C                   EVAL      CA = BaseCDP + 1
     C                   EVAL      #_YQBSc(X) = #_YQBSc(X) / POWER(CA)
 
      * Convert CR MOVES from account currency amount to reporting currency 1
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_YQACc(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2R1
     C                   Z-ADD     ZAMTCO        #_YQR1c(X)
     C                   EVAL      CA = RpC1CDP + 1
     C                   EVAL      #_YQR1c(X) = #_YQR1c(X) / POWER(CA)
 
      * Convert CR MOVES from account currency amount to reporting currency 2
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_YQACc(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2R2
     C                   Z-ADD     ZAMTCO        #_YQR2c(X)
     C                   EVAL      CA = RpC2CDP + 1
     C                   EVAL      #_YQR2c(X) = #_YQR2c(X) / POWER(CA)
 
      * Change in balance
      * ACCOUNT
     C     X             IFEQ      1
     C                   Z-ADD     #_YQACEP(X)   #_YQACCH(X)
     C                   ENDIF
     C     Y             IFLE      8
     C     #_YQACEP(Y)   SUB       #_YQACEP(X)   #_YQACCH(Y)
     C                   ENDIF
      * BASE
     C     X             IFEQ      1
     C                   Z-ADD     #_YQBSEP(X)   #_YQBSCH(X)
     C                   ENDIF
     C     Y             IFLE      8
     C     #_YQBSEP(Y)   SUB       #_YQBSEP(X)   #_YQBSCH(Y)
     C                   ENDIF
      * REPORT CCY 1
     C     X             IFEQ      1
     C                   Z-ADD     #_YQR1EP(X)   #_YQR1CH(X)
     C                   ENDIF
     C     Y             IFLE      8
     C     #_YQR1EP(Y)   SUB       #_YQR1EP(X)   #_YQR1CH(Y)
     C                   ENDIF
      * REPORT CCY 2
     C     X             IFEQ      1
     C                   Z-ADD     #_YQR2EP(X)   #_YQR2CH(X)
     C                   ENDIF
     C     Y             IFLE      8
     C     #_YQR2EP(Y)   SUB       #_YQR2EP(X)   #_YQR2CH(Y)
     C                   ENDIF
 
     C                   SUB       1             X
     C                   SUB       1             Y
     C                   ENDDO
 
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     SETEPB_YH     BEGSR
 
     C                   Z-ADD     *zero         #_YHACEP
     C                   Z-ADD     *zero         #_YHBSEP
     C                   Z-ADD     *zero         #_YHR1EP
     C                   Z-ADD     *zero         #_YHR2EP
 
     C                   Z-add     5             Y
     C                   Z-add     4             X
     C     X             DOWGE     1
 
      * Set first balance to be ledger balance from ACCNTAB.
      * Otherwise, balance = previous balance - previous DR/CR movements
 
     C     X             IFEQ      4
     C     AcctCDP       ADD       1             CA
     C     LDBL          DIV       POWER(CA)     #_YHACEP(X)
     C                   ELSE
     C     #_YHACEP(Y)   SUB       #_YHACd(Y)    #_YHACEP(X)
     C                   SUB       #_YHACc(Y)    #_YHACEP(X)
     C                   ENDIF
 
      * Get Historic Rates (Account Currency, Reporting Currency 1, Reporting Currency 2)
 
     C                   Z-ADD     #_YHEOPD(X)   HistDate
     C                   EXSR      GETHistRATES
 
      * Determine Cross Rates from Account Currency -> Reporting Currency 1 and 2
 
     C                   EXSR      DETCrossRATES
 
      * Adjust end of period ledger balance for account currency decimal places
 
     C                   Z-ADD     #_YHACEP(X)   EOPLedgerBal
     C                   EVAL      CA = AcctCDP + 1
     C                   EVAL      EOPLedgerBal = EOPLedgerBal * POWER(CA)
 
      * Convert EOP LEDGER BALANCE from account currency amount to base currency
 
     C                   Z-ADD     EOPLedgerBal  ZAMTCI
     C                   EXSR      CONV_AC2BS
     C                   Z-ADD     ZAMTCO        #_YHBSEP(X)
     C                   EVAL      CA = BaseCDP + 1
     C                   EVAL      #_YHBSEP(X) = #_YHBSEP(X) / POWER(CA)
 
      * Convert EOP LEDGER BALANCE from account currency amount to reporting currency 1
 
     C                   Z-ADD     EOPLedgerBal  ZAMTCI
     C                   EXSR      CONV_AC2R1
     C                   Z-ADD     ZAMTCO        #_YHR1EP(X)
     C                   EVAL      CA = RpC1CDP + 1
     C                   EVAL      #_YHR1EP(X) = #_YHR1EP(X) / POWER(CA)
 
      * Convert EOP LEDGER BALANCE from account currency amount to reporting currency 2
 
     C                   Z-ADD     EOPLedgerBal  ZAMTCI
     C                   EXSR      CONV_AC2R2
     C                   Z-ADD     ZAMTCO        #_YHR2EP(X)
     C                   EVAL      CA = RpC2CDP + 1
     C                   EVAL      #_YHR2EP(X) = #_YHR2EP(X) / POWER(CA)
 
      * Convert DR MOVES from account currency amount to base currency
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_YHACd(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2BS
     C                   Z-ADD     ZAMTCO        #_YHBSd(X)
     C                   EVAL      CA = BaseCDP + 1
     C                   EVAL      #_YHBSd(X) = #_YHBSd(X) / POWER(CA)
 
      * Convert DR MOVES from account currency amount to reporting currency 1
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_YHACd(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2R1
     C                   Z-ADD     ZAMTCO        #_YHR1d(X)
     C                   EVAL      CA = RpC1CDP + 1
     C                   EVAL      #_YHR1d(X) = #_YHR1d(X) / POWER(CA)
 
      * Convert DR MOVES from account currency amount to reporting currency 2
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_YHACd(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2R2
     C                   Z-ADD     ZAMTCO        #_YHR2d(X)
     C                   EVAL      CA = RpC2CDP + 1
     C                   EVAL      #_YHR2d(X) = #_YHR2d(X) / POWER(CA)
 
      * Convert CR MOVES from account currency amount to base currency
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_YHACc(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2BS
     C                   Z-ADD     ZAMTCO        #_YHBSc(X)
     C                   EVAL      CA = BaseCDP + 1
     C                   EVAL      #_YHBSc(X) = #_YHBSc(X) / POWER(CA)
 
      * Convert CR MOVES from account currency amount to reporting currency 1
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_YHACc(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2R1
     C                   Z-ADD     ZAMTCO        #_YHR1c(X)
     C                   EVAL      CA = RpC1CDP + 1
     C                   EVAL      #_YHR1c(X) = #_YHR1c(X) / POWER(CA)
 
      * Convert CR MOVES from account currency amount to reporting currency 2
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_YHACc(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2R2
     C                   Z-ADD     ZAMTCO        #_YHR2c(X)
     C                   EVAL      CA = RpC2CDP + 1
     C                   EVAL      #_YHR2c(X) = #_YHR2c(X) / POWER(CA)
 
      * Change in balance
      * ACCOUNT
     C     X             IFEQ      1
     C                   Z-ADD     #_YHACEP(X)   #_YHACCH(X)
     C                   ENDIF
     C     Y             IFLE      4
     C     #_YHACEP(Y)   SUB       #_YHACEP(X)   #_YHACCH(Y)
     C                   ENDIF
      * BASE
     C     X             IFEQ      1
     C                   Z-ADD     #_YHBSEP(X)   #_YHBSCH(X)
     C                   ENDIF
     C     Y             IFLE      4
     C     #_YHBSEP(Y)   SUB       #_YHBSEP(X)   #_YHBSCH(Y)
     C                   ENDIF
      * REPORT CCY 1
     C     X             IFEQ      1
     C                   Z-ADD     #_YHR1EP(X)   #_YHR1CH(X)
     C                   ENDIF
     C     Y             IFLE      4
     C     #_YHR1EP(Y)   SUB       #_YHR1EP(X)   #_YHR1CH(Y)
     C                   ENDIF
      * REPORT CCY 2
     C     X             IFEQ      1
     C                   Z-ADD     #_YHR2EP(X)   #_YHR2CH(X)
     C                   ENDIF
     C     Y             IFLE      4
     C     #_YHR2EP(Y)   SUB       #_YHR2EP(X)   #_YHR2CH(Y)
     C                   ENDIF
 
     C                   SUB       1             X
     C                   SUB       1             Y
     C                   ENDDO
 
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     SETEPB_Y_     BEGSR
 
     C                   Z-ADD     *zero         #_Y_ACEP
     C                   Z-ADD     *zero         #_Y_BSEP
     C                   Z-ADD     *zero         #_Y_R1EP
     C                   Z-ADD     *zero         #_Y_R2EP
 
     C                   Z-add     3             Y
     C                   Z-add     2             X
     C     X             DOWGE     1
 
      * Set first balance to be ledger balance from ACCNTAB.
      * Otherwise, balance = previous balance - previous DR/CR movements
 
     C     X             IFEQ      2
     C     AcctCDP       ADD       1             CA
     C     LDBL          DIV       POWER(CA)     #_Y_ACEP(X)
     C                   ELSE
     C     #_Y_ACEP(Y)   SUB       #_Y_ACd(Y)    #_Y_ACEP(X)
     C                   SUB       #_Y_ACc(Y)    #_Y_ACEP(X)
     C                   ENDIF
 
      * Get Historic Rates (Account Currency, Reporting Currency 1, Reporting Currency 2)
 
     C                   Z-ADD     #_Y_EOPD(X)   HistDate
     C                   EXSR      GETHistRATES
 
      * Determine Cross Rates from Account Currency -> Reporting Currency 1 and 2
 
     C                   EXSR      DETCrossRATES
 
      * Adjust end of period ledger balance for account currency decimal places
 
     C                   Z-ADD     #_Y_ACEP(X)   EOPLedgerBal
     C                   EVAL      CA = AcctCDP + 1
     C                   EVAL      EOPLedgerBal = EOPLedgerBal * POWER(CA)
 
      * Convert EOP LEDGER BALANCE from account currency amount to base currency
 
     C                   Z-ADD     EOPLedgerBal  ZAMTCI
     C                   EXSR      CONV_AC2BS
     C                   Z-ADD     ZAMTCO        #_Y_BSEP(X)
     C                   EVAL      CA = BaseCDP + 1
     C                   EVAL      #_Y_BSEP(X) = #_Y_BSEP(X) / POWER(CA)
 
      * Convert EOP LEDGER BALANCE from account currency amount to reporting currency 1
 
     C                   Z-ADD     EOPLedgerBal  ZAMTCI
     C                   EXSR      CONV_AC2R1
     C                   Z-ADD     ZAMTCO        #_Y_R1EP(X)
     C                   EVAL      CA = RpC1CDP + 1
     C                   EVAL      #_Y_R1EP(X) = #_Y_R1EP(X) / POWER(CA)
 
      * Convert EOP LEDGER BALANCE from account currency amount to reporting currency 2
 
     C                   Z-ADD     EOPLedgerBal  ZAMTCI
     C                   EXSR      CONV_AC2R2
     C                   Z-ADD     ZAMTCO        #_Y_R2EP(X)
     C                   EVAL      CA = RpC2CDP + 1
     C                   EVAL      #_Y_R2EP(X) = #_Y_R2EP(X) / POWER(CA)
 
      * Convert DR MOVES from account currency amount to base currency
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_Y_ACd(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2BS
     C                   Z-ADD     ZAMTCO        #_Y_BSd(X)
     C                   EVAL      CA = BaseCDP + 1
     C                   EVAL      #_Y_BSd(X) = #_Y_BSd(X) / POWER(CA)
 
      * Convert DR MOVES from account currency amount to reporting currency 1
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_Y_ACd(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2R1
     C                   Z-ADD     ZAMTCO        #_Y_R1d(X)
     C                   EVAL      CA = RpC1CDP + 1
     C                   EVAL      #_Y_R1d(X) = #_Y_R1d(X) / POWER(CA)
 
      * Convert DR MOVES from account currency amount to reporting currency 2
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_Y_ACd(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2R2
     C                   Z-ADD     ZAMTCO        #_Y_R2d(X)
     C                   EVAL      CA = RpC2CDP + 1
     C                   EVAL      #_Y_R2d(X) = #_Y_R2d(X) / POWER(CA)
 
      * Convert CR MOVES from account currency amount to base currency
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_Y_ACc(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2BS
     C                   Z-ADD     ZAMTCO        #_Y_BSc(X)
     C                   EVAL      CA = BaseCDP + 1
     C                   EVAL      #_Y_BSc(X) = #_Y_BSc(X) / POWER(CA)
 
      * Convert CR MOVES from account currency amount to reporting currency 1
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_Y_ACc(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2R1
     C                   Z-ADD     ZAMTCO        #_Y_R1c(X)
     C                   EVAL      CA = RpC1CDP + 1
     C                   EVAL      #_Y_R1c(X) = #_Y_R1c(X) / POWER(CA)
 
      * Convert CR MOVES from account currency amount to reporting currency 2
 
     C                   EVAL      CA = AcctCDP + 1
     C     #_Y_ACc(X)    MULT      POWER(CA)     ZAMTCI
     C                   EXSR      CONV_AC2R2
     C                   Z-ADD     ZAMTCO        #_Y_R2c(X)
     C                   EVAL      CA = RpC2CDP + 1
     C                   EVAL      #_Y_R2c(X) = #_Y_R2c(X) / POWER(CA)
 
      * Change in balance
      * ACCOUNT
     C     X             IFEQ      1
     C                   Z-ADD     #_Y_ACEP(X)   #_Y_ACCH(X)
     C                   ENDIF
     C     Y             IFLE      2
     C     #_Y_ACEP(Y)   SUB       #_Y_ACEP(X)   #_Y_ACCH(Y)
     C                   ENDIF
      * BASE
     C     X             IFEQ      1
     C                   Z-ADD     #_Y_BSEP(X)   #_Y_BSCH(X)
     C                   ENDIF
     C     Y             IFLE      2
     C     #_Y_BSEP(Y)   SUB       #_Y_BSEP(X)   #_Y_BSCH(Y)
     C                   ENDIF
      * REPORT CCY 1
     C     X             IFEQ      1
     C                   Z-ADD     #_Y_R1EP(X)   #_Y_R1CH(X)
     C                   ENDIF
     C     Y             IFLE      2
     C     #_Y_R1EP(Y)   SUB       #_Y_R1EP(X)   #_Y_R1CH(Y)
     C                   ENDIF
      * REPORT CCY 2
     C     X             IFEQ      1
     C                   Z-ADD     #_Y_R2EP(X)   #_Y_R2CH(X)
     C                   ENDIF
     C     Y             IFLE      2
     C     #_Y_R2EP(Y)   SUB       #_Y_R2EP(X)   #_Y_R2CH(Y)
     C                   ENDIF
 
     C                   SUB       1             X
     C                   SUB       1             Y
     C                   ENDDO
 
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     WRT_YM        BEGSR
     C                   Z-add     1             X
     C     X             DOWLE     24
 
     C                   MOVEL     #_YM(X)       YM
 
     C                   MOVEL     I#CAFI        CAFI
     C                   MOVE      'M'           PERTYP
     C                   MOVEL     YM            YR
     C                   MOVE      YM            PR
 
      * Zeroize DR/CR movements to date
      * if first record or if crossing over a year
 
     C     X             IFEQ      1
     C     YR            ORNE      PrevYear
     C                   Z-ADD     *zero         DRM2AC
     C                   Z-ADD     *zero         DRM2BS
     C                   Z-ADD     *zero         DRM2R1
     C                   Z-ADD     *zero         DRM2R2
     C                   Z-ADD     *zero         CRM2AC
     C                   Z-ADD     *zero         CRM2BS
     C                   Z-ADD     *zero         CRM2R1
     C                   Z-ADD     *zero         CRM2R2
     C                   ENDIF
      * PS/PE Dates
     C                   Z-ADD     #_YMSOPD(X)   SPDAT
     C                   Z-ADD     #_YMEOPD(X)   EPDAT
      * PE DR/CR Ind.
     C     #_YMACEP(X)   IFLT      0
     C                   MOVEL     '1'           EPBLDC
     C                   ELSE
     C                   MOVEL     '0'           EPBLDC
     C                   ENDIF
      * PE Bals
     C                   Z-ADD     #_YMACEP(X)   EPBLAC
     C                   Z-ADD     #_YMBSEP(X)   EPBLBS
     C                   Z-ADD     #_YMR1EP(X)   EPBLR1
     C                   Z-ADD     #_YMR2EP(X)   EPBLR2
      * DR/CR movements
     C                   Z-ADD     #_YMACd(X)    DRMAAC
     C                   Z-ADD     #_YMBSd(X)    DRMABS
     C                   Z-ADD     #_YMR1d(X)    DRMAR1
     C                   Z-ADD     #_YMR2d(X)    DRMAR2
     C                   Z-ADD     #_YMACc(X)    CRMAAC
     C                   Z-ADD     #_YMBSc(X)    CRMABS
     C                   Z-ADD     #_YMR1c(X)    CRMAR1
     C                   Z-ADD     #_YMR2c(X)    CRMAR2
      * DR/CR movements to date
     C                   ADD       DRMAAC        DRM2AC
     C                   ADD       DRMABS        DRM2BS
     C                   ADD       DRMAR1        DRM2R1
     C                   ADD       DRMAR2        DRM2R2
     C                   ADD       CRMAAC        CRM2AC
     C                   ADD       CRMABS        CRM2BS
     C                   ADD       CRMAR1        CRM2R1
     C                   ADD       CRMAR2        CRM2R2
      * Change in A/c Balance
     C                   Z-ADD     #_YMACCH(X)   CHBLAC
     C                   Z-ADD     #_YMBSCH(X)   CHBLBS
     C                   Z-ADD     #_YMR1CH(X)   CHBLR1
     C                   Z-ADD     #_YMR2CH(X)   CHBLR2
      * Base Transfer
     C                   Z-ADD     #_YMBTFR(X)   BSTFR
     C                   Z-ADD     #_YMBTFR1(X)  BSTFR1
     C                   Z-ADD     #_YMBTFR2(X)  BSTFR2
      * For.Ccy Transfer
     C                   Z-ADD     #_YMFTFAC(X)  FCTFAC
     C                   Z-ADD     #_YMFTFBS(X)  FCTFBS
     C                   Z-ADD     #_YMFTFR1(X)  FCTFR1
     C                   Z-ADD     #_YMFTFR2(X)  FCTFR2
 
     C     SPDAT         IFGE      LimitDate
     C     SPDAT         ANDLE     BJRDNB
     C                   WRITE     MRHIBLD0
     C                   ENDIF
     C                   Z-ADD     YR            PrevYear          2 0
     C                   ADD       1             X
     C                   ENDDO
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     WRT_YQ        BEGSR
     C                   Z-add     1             X
     C     X             DOWLE     8
 
     C                   MOVEL     #_YQ(X)       YQ
 
     C                   MOVEL     I#CAFI        CAFI
     C                   MOVE      'Q'           PERTYP
     C                   MOVEL     YQ            YR
     C                   MOVE      YQ            PR
 
      * Zeroize DR/CR movements to date
      * if first record or if crossing over a year
 
     C     X             IFEQ      1
     C     YR            ORNE      PrevYear
     C                   Z-ADD     *zero         DRM2AC
     C                   Z-ADD     *zero         DRM2BS
     C                   Z-ADD     *zero         DRM2R1
     C                   Z-ADD     *zero         DRM2R2
     C                   Z-ADD     *zero         CRM2AC
     C                   Z-ADD     *zero         CRM2BS
     C                   Z-ADD     *zero         CRM2R1
     C                   Z-ADD     *zero         CRM2R2
     C                   ENDIF
      * PS/PE Dates
     C                   Z-ADD     #_YQSOPD(X)   SPDAT
     C                   Z-ADD     #_YQEOPD(X)   EPDAT
      * PE DR/CR Ind.
     C     #_YQACEP(X)   IFLT      0
     C                   MOVEL     '1'           EPBLDC
     C                   ELSE
     C                   MOVEL     '0'           EPBLDC
     C                   ENDIF
      * PE Bals
     C                   Z-ADD     #_YQACEP(X)   EPBLAC
     C                   Z-ADD     #_YQBSEP(X)   EPBLBS
     C                   Z-ADD     #_YQR1EP(X)   EPBLR1
     C                   Z-ADD     #_YQR2EP(X)   EPBLR2
      * DR/CR movements
     C                   Z-ADD     #_YQACd(X)    DRMAAC
     C                   Z-ADD     #_YQBSd(X)    DRMABS
     C                   Z-ADD     #_YQR1d(X)    DRMAR1
     C                   Z-ADD     #_YQR2d(X)    DRMAR2
     C                   Z-ADD     #_YQACc(X)    CRMAAC
     C                   Z-ADD     #_YQBSc(X)    CRMABS
     C                   Z-ADD     #_YQR1c(X)    CRMAR1
     C                   Z-ADD     #_YQR2c(X)    CRMAR2
      * DR/CR movements to date
     C                   ADD       DRMAAC        DRM2AC
     C                   ADD       DRMABS        DRM2BS
     C                   ADD       DRMAR1        DRM2R1
     C                   ADD       DRMAR2        DRM2R2
     C                   ADD       CRMAAC        CRM2AC
     C                   ADD       CRMABS        CRM2BS
     C                   ADD       CRMAR1        CRM2R1
     C                   ADD       CRMAR2        CRM2R2
      * Change in A/c Balance
     C                   Z-ADD     #_YQACCH(X)   CHBLAC
     C                   Z-ADD     #_YQBSCH(X)   CHBLBS
     C                   Z-ADD     #_YQR1CH(X)   CHBLR1
     C                   Z-ADD     #_YQR2CH(X)   CHBLR2
      * Base Transfer
     C                   Z-ADD     #_YQBTFR(X)   BSTFR
     C                   Z-ADD     #_YQBTFR1(X)  BSTFR1
     C                   Z-ADD     #_YQBTFR2(X)  BSTFR2
      * For.Ccy Transfer
     C                   Z-ADD     #_YQFTFAC(X)  FCTFAC
     C                   Z-ADD     #_YQFTFBS(X)  FCTFBS
     C                   Z-ADD     #_YQFTFR1(X)  FCTFR1
     C                   Z-ADD     #_YQFTFR2(X)  FCTFR2
 
     C     SPDAT         IFGE      LimitDate
     C     SPDAT         ANDLE     BJRDNB
     C                   WRITE     MRHIBLD0
     C                   ENDIF
     C                   Z-ADD     YR            PrevYear          2 0
     C                   ADD       1             X
     C                   ENDDO
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     WRT_YH        BEGSR
     C                   Z-add     1             X
     C     X             DOWLE     4
 
     C                   MOVEL     #_YH(X)       YH
 
     C                   MOVEL     I#CAFI        CAFI
     C                   MOVE      'H'           PERTYP
     C                   MOVEL     YH            YR
     C                   MOVE      YH            PR
 
      * Zeroize DR/CR movements to date
      * if first record or if crossing over a year
 
     C     X             IFEQ      1
     C     YR            ORNE      PrevYear
     C                   Z-ADD     *zero         DRM2AC
     C                   Z-ADD     *zero         DRM2BS
     C                   Z-ADD     *zero         DRM2R1
     C                   Z-ADD     *zero         DRM2R2
     C                   Z-ADD     *zero         CRM2AC
     C                   Z-ADD     *zero         CRM2BS
     C                   Z-ADD     *zero         CRM2R1
     C                   Z-ADD     *zero         CRM2R2
     C                   ENDIF
      * PS/PE Dates
     C                   Z-ADD     #_YHSOPD(X)   SPDAT
     C                   Z-ADD     #_YHEOPD(X)   EPDAT
      * PE DR/CR Ind.
     C     #_YHACEP(X)   IFLT      0
     C                   MOVEL     '1'           EPBLDC
     C                   ELSE
     C                   MOVEL     '0'           EPBLDC
     C                   ENDIF
      * PE Bals
     C                   Z-ADD     #_YHACEP(X)   EPBLAC
     C                   Z-ADD     #_YHBSEP(X)   EPBLBS
     C                   Z-ADD     #_YHR1EP(X)   EPBLR1
     C                   Z-ADD     #_YHR2EP(X)   EPBLR2
      * DR/CR movements
     C                   Z-ADD     #_YHACd(X)    DRMAAC
     C                   Z-ADD     #_YHBSd(X)    DRMABS
     C                   Z-ADD     #_YHR1d(X)    DRMAR1
     C                   Z-ADD     #_YHR2d(X)    DRMAR2
     C                   Z-ADD     #_YHACc(X)    CRMAAC
     C                   Z-ADD     #_YHBSc(X)    CRMABS
     C                   Z-ADD     #_YHR1c(X)    CRMAR1
     C                   Z-ADD     #_YHR2c(X)    CRMAR2
      * DR/CR movements to date
     C                   ADD       DRMAAC        DRM2AC
     C                   ADD       DRMABS        DRM2BS
     C                   ADD       DRMAR1        DRM2R1
     C                   ADD       DRMAR2        DRM2R2
     C                   ADD       CRMAAC        CRM2AC
     C                   ADD       CRMABS        CRM2BS
     C                   ADD       CRMAR1        CRM2R1
     C                   ADD       CRMAR2        CRM2R2
      * Change in A/c Balance
     C                   Z-ADD     #_YHACCH(X)   CHBLAC
     C                   Z-ADD     #_YHBSCH(X)   CHBLBS
     C                   Z-ADD     #_YHR1CH(X)   CHBLR1
     C                   Z-ADD     #_YHR2CH(X)   CHBLR2
      * Base Transfer
     C                   Z-ADD     #_YHBTFR(X)   BSTFR
     C                   Z-ADD     #_YHBTFR1(X)  BSTFR1
     C                   Z-ADD     #_YHBTFR2(X)  BSTFR2
      * For.Ccy Transfer
     C                   Z-ADD     #_YHFTFAC(X)  FCTFAC
     C                   Z-ADD     #_YHFTFBS(X)  FCTFBS
     C                   Z-ADD     #_YHFTFR1(X)  FCTFR1
     C                   Z-ADD     #_YHFTFR2(X)  FCTFR2
 
     C     SPDAT         IFGE      LimitDate
     C     SPDAT         ANDLE     BJRDNB
     C                   WRITE     MRHIBLD0
     C                   ENDIF
     C                   Z-ADD     YR            PrevYear          2 0
     C                   ADD       1             X
     C                   ENDDO
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     WRT_Y_        BEGSR
     C                   Z-add     1             X
     C     X             DOWLE     2
 
     C                   MOVEL     #_Y_(X)       Y_
 
     C                   MOVEL     I#CAFI        CAFI
     C                   MOVE      'Y'           PERTYP
     C                   MOVEL     Y_            YR
     C                   MOVE      '00'          PR
 
      * Zeroize DR/CR movements to date
      * if first record or if crossing over a year
 
     C     X             IFEQ      1
     C     YR            ORNE      PrevYear
     C                   Z-ADD     *zero         DRM2AC
     C                   Z-ADD     *zero         DRM2BS
     C                   Z-ADD     *zero         DRM2R1
     C                   Z-ADD     *zero         DRM2R2
     C                   Z-ADD     *zero         CRM2AC
     C                   Z-ADD     *zero         CRM2BS
     C                   Z-ADD     *zero         CRM2R1
     C                   Z-ADD     *zero         CRM2R2
     C                   ENDIF
      * PS/PE Dates
     C                   Z-ADD     #_Y_SOPD(X)   SPDAT
     C                   Z-ADD     #_Y_EOPD(X)   EPDAT
      * PE DR/CR Ind.
     C     #_Y_ACEP(X)   IFLT      0
     C                   MOVEL     '1'           EPBLDC
     C                   ELSE
     C                   MOVEL     '0'           EPBLDC
     C                   ENDIF
      * PE Bals
     C                   Z-ADD     #_Y_ACEP(X)   EPBLAC
     C                   Z-ADD     #_Y_BSEP(X)   EPBLBS
     C                   Z-ADD     #_Y_R1EP(X)   EPBLR1
     C                   Z-ADD     #_Y_R2EP(X)   EPBLR2
      * DR/CR movements
     C                   Z-ADD     #_Y_ACd(X)    DRMAAC
     C                   Z-ADD     #_Y_BSd(X)    DRMABS
     C                   Z-ADD     #_Y_R1d(X)    DRMAR1
     C                   Z-ADD     #_Y_R2d(X)    DRMAR2
     C                   Z-ADD     #_Y_ACc(X)    CRMAAC
     C                   Z-ADD     #_Y_BSc(X)    CRMABS
     C                   Z-ADD     #_Y_R1c(X)    CRMAR1
     C                   Z-ADD     #_Y_R2c(X)    CRMAR2
      * DR/CR movements to date
     C                   ADD       DRMAAC        DRM2AC
     C                   ADD       DRMABS        DRM2BS
     C                   ADD       DRMAR1        DRM2R1
     C                   ADD       DRMAR2        DRM2R2
     C                   ADD       CRMAAC        CRM2AC
     C                   ADD       CRMABS        CRM2BS
     C                   ADD       CRMAR1        CRM2R1
     C                   ADD       CRMAR2        CRM2R2
      * Change in A/c Balance
     C                   Z-ADD     #_Y_ACCH(X)   CHBLAC
     C                   Z-ADD     #_Y_BSCH(X)   CHBLBS
     C                   Z-ADD     #_Y_R1CH(X)   CHBLR1
     C                   Z-ADD     #_Y_R2CH(X)   CHBLR2
      * Base Transfer
     C                   Z-ADD     #_Y_BTFR(X)   BSTFR
     C                   Z-ADD     #_Y_BTFR1(X)  BSTFR1
     C                   Z-ADD     #_Y_BTFR2(X)  BSTFR2
      * For.Ccy Transfer
     C                   Z-ADD     #_Y_FTFAC(X)  FCTFAC
     C                   Z-ADD     #_Y_FTFBS(X)  FCTFBS
     C                   Z-ADD     #_Y_FTFR1(X)  FCTFR1
     C                   Z-ADD     #_Y_FTFR2(X)  FCTFR2
 
     C     SPDAT         IFGE      LimitDate
     C     SPDAT         ANDLE     BJRDNB
     C                   WRITE     MRHIBLD0
     C                   ENDIF
     C                   Z-ADD     YR            PrevYear          2 0
     C                   ADD       1             X
     C                   ENDDO
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     CLR_TOTS      BEGSR
     C                   Z-ADD     0             #_YMACd
     C                   Z-ADD     0             #_YMBSd
     C                   Z-ADD     0             #_YMR1d
     C                   Z-ADD     0             #_YMR2d
     C                   Z-ADD     0             #_YMACc
     C                   Z-ADD     0             #_YMBSc
     C                   Z-ADD     0             #_YMR1c
     C                   Z-ADD     0             #_YMBTFR
     C                   Z-ADD     0             #_YMBTFR1
     C                   Z-ADD     0             #_YMBTFR2
     C                   Z-ADD     0             #_YMFTFAC
     C                   Z-ADD     0             #_YMFTFBS
     C                   Z-ADD     0             #_YMFTFR1
     C                   Z-ADD     0             #_YMFTFR2
 
     C                   Z-ADD     0             #_YQR2c
     C                   Z-ADD     0             #_YQACd
     C                   Z-ADD     0             #_YQBSd
     C                   Z-ADD     0             #_YQR1d
     C                   Z-ADD     0             #_YQR2d
     C                   Z-ADD     0             #_YQACc
     C                   Z-ADD     0             #_YQBSc
     C                   Z-ADD     0             #_YQR1c
     C                   Z-ADD     0             #_YQR2c
     C                   Z-ADD     0             #_YQBTFR
     C                   Z-ADD     0             #_YQBTFR1
     C                   Z-ADD     0             #_YQBTFR2
     C                   Z-ADD     0             #_YQFTFAC
     C                   Z-ADD     0             #_YQFTFBS
     C                   Z-ADD     0             #_YQFTFR1
     C                   Z-ADD     0             #_YQFTFR2
 
     C                   Z-ADD     0             #_YHR2c
     C                   Z-ADD     0             #_YHACd
     C                   Z-ADD     0             #_YHBSd
     C                   Z-ADD     0             #_YHR1d
     C                   Z-ADD     0             #_YHR2d
     C                   Z-ADD     0             #_YHACc
     C                   Z-ADD     0             #_YHBSc
     C                   Z-ADD     0             #_YHR1c
     C                   Z-ADD     0             #_YHR2c
     C                   Z-ADD     0             #_YHBTFR
     C                   Z-ADD     0             #_YHBTFR1
     C                   Z-ADD     0             #_YHBTFR2
     C                   Z-ADD     0             #_YHFTFAC
     C                   Z-ADD     0             #_YHFTFBS
     C                   Z-ADD     0             #_YHFTFR1
     C                   Z-ADD     0             #_YHFTFR2
 
     C                   Z-ADD     0             #_Y_R2c
     C                   Z-ADD     0             #_Y_ACd
     C                   Z-ADD     0             #_Y_BSd
     C                   Z-ADD     0             #_Y_R1d
     C                   Z-ADD     0             #_Y_R2d
     C                   Z-ADD     0             #_Y_ACc
     C                   Z-ADD     0             #_Y_BSc
     C                   Z-ADD     0             #_Y_R1c
     C                   Z-ADD     0             #_Y_R2c
     C                   Z-ADD     0             #_Y_BTFR
     C                   Z-ADD     0             #_Y_BTFR1
     C                   Z-ADD     0             #_Y_BTFR2
     C                   Z-ADD     0             #_Y_FTFAC
     C                   Z-ADD     0             #_Y_FTFBS
     C                   Z-ADD     0             #_Y_FTFR1
     C                   Z-ADD     0             #_Y_FTFR2
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Get Historic Rates (Account Currency, Reporting Currency 1, Reporting Currency 2)
      **********************************************************************************
     C     GETHistRATES  BEGSR
 
      * Get Account Currency Historic Rate
     C                   MOVEL     CCY           I#CCY
     C                   Z-ADD     HistDate      I#DATE
     C                   EXSR      GET_RATE
     C                   Z-ADD     G2SPRT        AcctSPRT         13 8
     C                   MOVEL     G2MDIN        AcctMDIN          1
 
      * Get Reporting Currency 1 Historic Rate
     C                   MOVEL     RepCurrency1  I#CCY
     C                   Z-ADD     HistDate      I#DATE
     C                   EXSR      GET_RATE
     C                   Z-ADD     G2SPRT        RpC1SPRT         13 8
     C                   MOVEL     G2MDIN        RpC1MDIN          1
 
      * Get Reporting Currency 2 Historic Rate
     C                   MOVEL     RepCurrency2  I#CCY
     C                   Z-ADD     HistDate      I#DATE
     C                   EXSR      GET_RATE
     C                   Z-ADD     G2SPRT        RpC2SPRT         13 8
     C                   MOVEL     G2MDIN        RpC2MDIN          1
 
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Determine Cross Rates from Account Currency -> Reporting Currency 1 and 2
      **********************************************************************************
     C     DETCrossRATES BEGSR
 
      * Determine cross rate from Account Currency -> Reporting Currency 1
 
     C                   Z-ADD     AcctSPRT      ZRATE1
     C                   MOVE      AcctMDIN      ZMDI1
     C                   Z-ADD     RpC1SPRT      ZRATE2
     C                   MOVE      RpC1MDIN      ZMDI2
     C                   EXSR      CROSS_RATE
     C                   Z-ADD     ZRATEX        RepC1XRATE       13 8
     C                   MOVEL     ZMDIX         RepC1XMDIN        1
 
      * Determine cross rate from Account Currency -> Reporting Currency 2
 
     C                   Z-ADD     AcctSPRT      ZRATE1
     C                   MOVE      AcctMDIN      ZMDI1
     C                   Z-ADD     RpC2SPRT      ZRATE2
     C                   MOVE      RpC2MDIN      ZMDI2
     C                   EXSR      CROSS_RATE
     C                   Z-ADD     ZRATEX        RepC2XRATE       13 8
     C                   MOVEL     ZMDIX         RepC2XMDIN        1
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     CONV_AC2BS    BEGSR
     C                   Z-ADD     AcctSPRT      ZEXCH
     C                   MOVE      AcctMDIN      ZMD
     C                   MOVE      CCY           ZCCYI
     C                   MOVE      BaseCurrency  ZCCYO
     C                   Z-ADD     AcctCDP       ZCDPI
     C                   Z-ADD     BaseCDP       ZCDPO
     C                   EXSR      CONVERT
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     CONV_AC2R1    BEGSR
     C                   Z-ADD     RepC1XRATE    ZEXCH
     C                   MOVE      RepC1XMDIN    ZMD
     C                   MOVE      CCY           ZCCYI
     C                   MOVE      RepCurrency1  ZCCYO
     C                   Z-ADD     AcctCDP       ZCDPI
     C                   Z-ADD     RpC1CDP       ZCDPO
     C                   EXSR      CONVERT
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     CONV_AC2R2    BEGSR
     C                   Z-ADD     RepC2XRATE    ZEXCH
     C                   MOVE      RepC2XMDIN    ZMD
     C                   MOVE      CCY           ZCCYI
     C                   MOVE      RepCurrency2  ZCCYO
     C                   Z-ADD     AcctCDP       ZCDPI
     C                   Z-ADD     RpC2CDP       ZCDPO
     C                   EXSR      CONVERT
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     Cal_SOPDates  BEGSR
 
      * Convert run date to day, month and year
 
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DayMonthYear
 
      * Last day of current year
 
     C                   Z-ADD     31            Day
     C                   Z-ADD     12            Month
     C                   MOVEL     DayMonthYear  ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        LastDayCurYear    5 0
 
      * First day of previous year
 
     C                   Z-ADD     1             Day
     C                   Z-ADD     1             Month
     C                   SUB       1             Year
 
      * Start of Period Dates
      * =====================
 
     C                   Z-ADD     1             X
     C     X             DOWLE     24
 
      * Convery day, month and year to day number
 
     C                   MOVEL     DayMonthYear  ZDATE
     C                   EXSR      ZDATE1
 
      * Calendar Year/Month
 
     C                   MOVEL     Year          YM
     C                   MOVE      Month         YM
     C                   MOVEL     YM            #_YM(X)
     C                   Z-ADD     ZDAYNO        #_YMSOPD(X)
 
     C                   Z-ADD     Month         BaseMonth         2 0
 
      * Calendar Quarter
     C                   EXSR      DET_Quarter
     C                   MOVEL     Year          YQ
     C                   MOVE      Quarter       YQ
     C                   Z-ADD     1             O                 2 0
     C     YQ            LOOKUP    #_YQ(O)                                99
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    #_YQ(O)                                99
     C                   MOVEL     YQ            #_YQ(O)
     C                   Z-ADD     ZDAYNO        #_YQSOPD(O)
     C                   ENDIF
 
      * Calendar Half-Year
     C                   EXSR      DET_Halfyear
     C                   MOVEL     Year          YH
     C                   MOVE      HalfYear      YH
     C                   Z-ADD     1             O
     C     YH            LOOKUP    #_YH(O)                                99
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    #_YH(O)                                99
     C                   MOVEL     YH            #_YH(O)
     C                   Z-ADD     ZDAYNO        #_YHSOPD(O)
     C                   ENDIF
 
      * Calendar Year
     C                   MOVEL     Year          Y_
     C                   Z-ADD     1             O
     C     Y_            LOOKUP    #_Y_(O)                                99
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    #_Y_(O)                                99
     C                   MOVEL     Y_            #_Y_(O)
     C                   Z-ADD     ZDAYNO        #_Y_SOPD(O)
     C                   ENDIF
 
      * Advance to next month
 
     C                   ADD       1             X
     C                   ADD       1             Month
     C     Month         IFGT      12
     C                   Z-ADD     1             Month
     C                   ADD       1             Year
     C                   ENDIF
     C                   ENDDO
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     Fin_SOPDates  BEGSR
 
      * Convert run date to day, month and year
 
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DayMonthYear
 
      * Last day of current year
 
     C     Month         IFGT      3
     C                   ADD       1             Year
     C                   ENDIF
     C                   Z-ADD     31            Day
     C                   Z-ADD     3             Month
     C                   MOVEL     DayMonthYear  ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        LastDayCurYear    5 0
 
      * First day of previous year
 
     C                   Z-ADD     1             Day
     C                   Z-ADD     4             Month
     C                   SUB       2             Year
 
      * Start of Period Dates
      * =====================
 
     C                   Z-ADD     1             X
     C     X             DOWLE     24
 
      * Convery day, month and year to day number
 
     C                   MOVEL     DayMonthYear  ZDATE
     C                   EXSR      ZDATE1
 
      * Financial Year/Month (3 months prior to calendar year/month)
 
     C                   Z-ADD     Year          FY
     C                   Z-ADD     Month         FM
     C                   SUB       3             FM                     9999
     C   99              SUB       1             FY
     C   99              ADD       12            FM
     C                   MOVEL     FY            YM
     C                   MOVE      FM            YM
     C                   MOVEL     YM            #_YM(X)
     C                   Z-ADD     ZDAYNO        #_YMSOPD(X)
 
     C                   Z-ADD     FM            BaseMonth
 
      * Financial Quarter
     C                   EXSR      DET_Quarter
     C                   MOVEL     FY            YQ
     C                   MOVE      Quarter       YQ
     C                   Z-ADD     1             O                 2 0
     C     YQ            LOOKUP    #_YQ(O)                                99
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    #_YQ(O)                                99
     C                   MOVEL     YQ            #_YQ(O)
     C                   Z-ADD     ZDAYNO        #_YQSOPD(O)
     C                   ENDIF
 
      * Financial Half-Year
     C                   EXSR      DET_Halfyear
     C                   MOVEL     FY            YH
     C                   MOVE      HalfYear      YH
     C                   Z-ADD     1             O
     C     YH            LOOKUP    #_YH(O)                                99
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    #_YH(O)                                99
     C                   MOVEL     YH            #_YH(O)
     C                   Z-ADD     ZDAYNO        #_YHSOPD(O)
     C                   ENDIF
 
      * Financial Year
     C                   MOVEL     FY            Y_
     C                   Z-ADD     1             O
     C     Y_            LOOKUP    #_Y_(O)                                99
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    #_Y_(O)                                99
     C                   MOVEL     Y_            #_Y_(O)
     C                   Z-ADD     ZDAYNO        #_Y_SOPD(O)
     C                   ENDIF
 
      * Advance to next month
 
     C                   ADD       1             X
     C                   ADD       1             Month
     C     Month         IFGT      12
     C                   Z-ADD     1             Month
     C                   ADD       1             Year
     C                   ENDIF
     C                   ENDDO
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     EOPDates      BEGSR
 
      * End of Period Dates
      * ===================
 
      * Monthly
     C                   Z-ADD     1             Y
     C                   Z-ADD     2             X
     C     X             DOWLE     24
     C     #_YMSOPD(X)   SUB       1             #_YMEOPD(Y)
     C                   ADD       1             Y
     C                   ADD       1             X
     C                   ENDDO
     C                   Z-ADD     LastDayCurYear#_YMEOPD(Y)
 
      * Quarterly
     C                   Z-ADD     1             Y
     C                   Z-ADD     2             X
     C     X             DOWLE     8
     C     #_YQSOPD(X)   SUB       1             #_YQEOPD(Y)
     C                   ADD       1             Y
     C                   ADD       1             X
     C                   ENDDO
     C                   Z-ADD     LastDayCurYear#_YQEOPD(Y)
 
      * Half-Yearly
     C                   Z-ADD     1             Y
     C                   Z-ADD     2             X
     C     X             DOWLE     4
     C     #_YHSOPD(X)   SUB       1             #_YHEOPD(Y)
     C                   ADD       1             Y
     C                   ADD       1             X
     C                   ENDDO
     C                   Z-ADD     LastDayCurYear#_YHEOPD(Y)
 
      * Yearly
     C                   Z-ADD     1             Y
     C                   Z-ADD     2             X
     C     X             DOWLE     2
     C     #_Y_SOPD(X)   SUB       1             #_Y_EOPD(Y)
     C                   ADD       1             Y
     C                   ADD       1             X
     C                   ENDDO
     C                   Z-ADD     LastDayCurYear#_Y_EOPD(Y)
 
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     GET_RATE      BEGSR
     C                   CALL      'MR000100'
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
     C                   PARM                    SDCUHS
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     CONVERT       BEGSR
     C                   CALL      'ZCONVZ1'
     C                   PARM                    ZAMTCI           15 0
     C                   PARM                    ZEXCH            13 8
     C                   PARM                    ZMD               1
     C                   PARM                    ZCCYI             3
     C                   PARM                    ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM                    ZAMTCO           15 0
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     CROSS_RATE    BEGSR
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1           13 8
     C                   PARM                    ZMDI1             1
     C                   PARM                    ZRATE2           13 8
     C                   PARM                    ZMDI2             1
     C                   PARM                    ZRATEX           13 8
     C                   PARM                    ZMDIX             1
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     ZDATE1        BEGSR
     C                   CALL      'ZDATE1'
     C                   PARM      *blank        ZERR              7            error code
     C                   PARM                    ZDATE             6 0          Value date
     C                   PARM      'D'           ZDATFM            1            Date format ind
     C                   PARM      *zero         ZDAYNO            5 0          Value date
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     ZDATE2        BEGSR
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      'D'           ZDATFM            1            Date format ind
     C                   PARM      *zero         ZDATE             6 0          Value date
     C                   PARM      *blank        ZADATE            7            Run-date in DDM
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     DET_Quarter   BEGSR
     C                   SELECT
     C     BaseMonth     WHENGT    9
     C                   Z-ADD     4             Quarter           2 0
     C     BaseMonth     WHENGT    6
     C                   Z-ADD     3             Quarter
     C     BaseMonth     WHENGT    3
     C                   Z-ADD     2             Quarter
     C                   OTHER
     C                   Z-ADD     1             Quarter
     C                   ENDSL
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     DET_HalfYear  BEGSR
     C                   SELECT
     C     BaseMonth     WHENGT    6
     C                   Z-ADD     2             HalfYear          2 0
     C                   OTHER
     C                   Z-ADD     1             HalfYear
     C                   ENDSL
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     *PSSR         BEGSR
 
     C     W#RUN         IFEQ      *BLANKS
 
     C                   MOVE      'Y'           W#RUN             1
 
     C                   MOVEL     '*ERROR'      I#RTCD            7
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
 
     C                   DUMP
      *
      * If no identified cause of error
      *
     C     I#ERMS        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'UNEXPECTED ERROR'
     C                   ENDIF
      *
      * Log an error on the error log
      *
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = I#ERMS
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER         4000
 
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#CAFI            1
 
      * Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Access reporting parameters
 
     C     1             SETLL     MRRPRMPD
     C                   READ      MRRPRMPD                               99
      * Missing MRRPRMPD record
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'Missing Reporting Parameters'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      BJCYCD        BaseCurrency      3
     C                   MOVE      RPCCY1        RepCurrency1      3
     C                   MOVE      RPCCY2        RepCurrency2      3
      * Base CDP
     C                   CALL      'MR000101'
     C                   PARM      BaseCurrency  I#CCY             3
     C                   PARM                    SDCURR
     C                   Z-ADD     A6NBDP        BaseCDP           1 0
      * RpC1 CDP
     C                   CALL      'MR000101'
     C                   PARM      RepCurrency1  I#CCY
     C                   PARM                    SDCURR
     C                   Z-ADD     A6NBDP        RpC1CDP           1 0
      * Missing currency
     C     A6SPRT        IFEQ      *ZERO
     C                   EVAL      I#ERMS = 'Bad Reporting Currency:' + I#CCY
     C                   EXSR      *PSSR
     C                   ENDIF
      * RpC2 CDP
     C                   CALL      'MR000101'
     C                   PARM      RepCurrency2  I#CCY
     C                   PARM                    SDCURR
     C                   Z-ADD     A6NBDP        RpC2CDP           1 0
      * Missing currency
     C     A6SPRT        IFEQ      *ZERO
     C                   EVAL      I#ERMS = 'Bad Reporting Currency:' + I#CCY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-add     0             CA                1 0
 
      * Determine earliest month in posting history
 
     C     PCMXK         KLIST
     C                   KFLD                    CY
     C                   KFLD                    CM
     C                   Z-ADD     *ZERO         CY
     C                   Z-ADD     *ZERO         CM
     C     PCMXK         SETLL     HistMonth
     C                   READ      HistMonth                              99
     C  N99              Z-ADD     CSMDAT        LimitDate         5 0
     C   99              Z-ADD     *ZERO         LimitDate
 
      * Determine CALENDAR and FINANCIAL Start of Period Dates
 
     C     I#CAFI        IFEQ      'C'
     C                   EXSR      Cal_SOPDates
     C                   ELSE
     C                   EXSR      Fin_SOPDates
     C                   ENDIF
 
      * End of Period Dates
 
     C                   EXSR      EOPDates
 
     C                   MOVE      *BLANK        I#ERMS           50
     C                   ENDSR
     C**********************************************************************************
**  POWER8 - ARRAY OF POWERS FOR CURRENCY CONVERSION
00000001
00000010
00000100
00001000
00010000
00100000
01000000
10000000
