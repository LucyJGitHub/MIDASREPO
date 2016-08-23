     H DEBUG
     H DATEDIT(*DMYH)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Nostro Balance Update')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPNOSBUPD - Nostro Balance Update                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. AR987769           Date 22Jun22               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG14613           Date 14Sep07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR987769 - Discrepancies on the Projected Nostro Balances    *
      *             enquiry. Updated projections for 6th & 7th day in *
      *             GPNOSBPD based from RSACMTPD.                     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  BUG14613 - Diff in balances on Projected Nostro Java         *
      *             & Web face Enquiry(Apply Fix 242344)              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FGZSDBANKL1IF   E           K DISK    INFSR(*PSSR)
     FGZSDCURRL1IF   E           K DISK    INFSR(*PSSR)
     FGZSDNOSTJ0IF   E           K DISK    INFSR(*PSSR)
     FGPNOSDL0  IF   E           K DISK    INFSR(*PSSR)
     FGPNOSBL0  UF A E           K DISK    INFSR(*PSSR)
     FGPZONEL0  IF   E           K DISK    INFSR(*PSSR)                                     AR987769
     FGPDWNLL0  IF   E           K DISK    INFSR(*PSSR)                                     AR987769
 
      *    Currency
     D X_CCY           S              3    DIM(150) ASCEND
      *    Spot Days
     D X_SPD           S              2  0 DIM(150)
      *    Spot rate
     D X_SPR           S             15  8 DIM(150)
      *    Mutliply/Divide Indicator
     D X_MDI           S              1    DIM(150)
      *    Factors
     D X_FCT           S              7  0 DIM(150)
 
 
      * Incoming Dates & Balances
     D                 DS
     D  PNB                    1     40
     D  PRB                    1     40P 0
     D                                     DIM(5)
     D  PND                   41     55
     D  PRD                   41     55P 0
     D                                     DIM(5) ASCEND
 
 
      * Outgoing Dates & Balances
     D DATArr          DS
     D  DAT                    1    250  0
     D                                     DIM(50)
     D  NBDAT0                 1      5  0
     D  NBDAT1                 6     10  0
     D  NBDAT2                11     15  0
     D  NBDAT3                16     20  0
     D  NBDAT4                21     25  0
     D  NBDAT5                26     30  0
     D  NBDAT6                31     35  0
     D  NBDAT7                36     40  0
     D  NBDAT8                41     45  0
     D  NBDAT9                46     50  0
 
     D BALArr          DS
     D  BAL                    1    170  0
     D                                     DIM(10)
     D  NBBAL0                 1     17  0
     D  NBBAL1                18     34  0
     D  NBBAL2                35     51  0
     D  NBBAL3                52     68  0
     D  NBBAL4                69     85  0
     D  NBBAL5                86    102  0
     D  NBBAL6               103    119  0
     D  NBBAL7               120    136  0
     D  NBBAL8               137    153  0
     D  NBBAL9               154    170  0
 
 
      *    currency/nostro
     D X_CCYNOS        S              5    DIM(999) ASCEND
      *    nostro branches
     D X_NOSBRC        S              3    DIM(999)
 
     D MPhase          S              1A                                                    AR987769
     D K5KeyD          S                   LIKE(DLKEYD)                                     AR987769
     D WAcCd           S             10S 0                                                  AR987769
     D X_Fctr          S              7S 0                                                  AR987769
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * INPUTS
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#CCY             3
     C                   PARM                    I#NOSN            2 0
      * Balances
     C                   PARM                    I#PNB            40
      * Dates
     C                   PARM                    I#PND            15
 
     C                   MOVEL     I#PNB         PNB
     C                   MOVEL     I#PND         PND
 
      * Return if nostro number is 00.
 
     C     I#NOSN        IFEQ      0
     C                   RETURN
     C                   ENDIF
 
      * Get bank details
 
     C     I#ZONE        IFNE      BJZONE
     C                   EXSR      GET_BANK
     C                   MOVE      *BLANK        X_CCY
     C                   Z-ADD     *zero         X_SPD
     C                   Z-ADD     *zero         X_SPR
     C                   MOVE      *BLANK        X_MDI
     C                   Z-ADD     *zero         X_FCT
     C                   MOVE      *BLANK        X_CCYNOS
     C                   MOVE      *BLANK        X_NOSBRC
     C                   ENDIF
 
      * If zone is available
 
     C     Zone_Avail    IFEQ      'Y'
 
      * Access currency details
 
     C                   EXSR      ACS_CURRDT
 
      * Access nostro details
 
     C                   EXSR      ACS_NOSTDT
 
      * Update balances
 
     C                   EXSR      UPD_BAL
     C                   ENDIF
 
     C                   RETURN
 
      /SPACE 5
      *****************************************************************
      * Update balances
      *****************************************************************
     C     UPD_BAL       BEGSR
 
      * Access nostro balances record
 
     C                   MOVEL     X_NOSBRC(#N)  NBBRCA
     C                   MOVEL     I#CCY         NBCCY
     C                   MOVEL     I#NOSN        NBNOSN
 
     C     GPNOSBK       CHAIN     GPNOSBD0                           60        *
 
     C                   Z-ADD     0             BAL
 
      * Move balances into relevant column
 
     C                   Z-ADD     1             X                 3 0
     C                   Z-ADD     1             Y                 3 0
     C                   Z-ADD     PRB(1)        PrevBal          15 0
     C     X             DOUGT     10
     C     DAT(X)        LOOKUP    PRD(Y)                                 99
     C   99              Z-ADD     PRB(Y)        BAL(X)
     C  N99              Z-ADD     PrevBal       BAL(X)
     C                   Z-ADD     BAL(X)        PrevBal
     C**********         DIV       X_FCT(#C)     BAL(X)                                     BUG14613
     C                   DIV (H)   X_FCT(#C)     BAL(X)                                     BUG14613
     C                   ADD       1             X
     C                   ENDDO
 
      *                                                                                     AR987769
      ** Check Midas phase of the day                                                       AR987769
      *                                                                                     AR987769
     C                   EXSR      MPhaseSR                                                 AR987769
      *                                                                                     AR987769
     C                   IF        Mphase = 'A'                                             AR987769
     C                   EXSR      GetProj                                                  AR987769
     C                   ENDIF                                                              AR987769
      *                                                                                     AR987769
      *  Update nostro balances record
      *  (NOT under commitment control)
 
     C  N60              UPDATE    GPNOSBD0
     C   60              WRITE     GPNOSBD0
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Get bank details for zone
      *****************************************************************
     C     GET_BANK      BEGSR
 
     C     I#ZONE        CHAIN     GZSDBANKL1                         99
     C     *IN99         IFEQ      *OFF
     C                   MOVEL     'Y'           Zone_Avail        1
     C                   ELSE
     C                   MOVEL     'N'           Zone_Avail
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Access Currency Details
      *****************************************************************
     C     ACS_CURRDT    BEGSR
 
      * Determine if currency details previously accessed
 
     C                   Z-ADD     1             #C                3 0
     C     I#CCY         LOOKUP    X_CCY(#C)                              99    *
 
      * If not
 
     C     *IN99         IFEQ      *OFF
 
      * Access currency details
 
     C     GZSDCURRK     CHAIN     GZSDCURRL1                         99
 
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'INVALID CURRENCY:' + I#CCY
     C                   EXSR      *PSSR
     C                   END
 
      * Store currency details
 
     C                   Z-ADD     1             #C
     C     *BLANK        LOOKUP    X_CCY(#C)                              99    *
     C                   MOVE      A6CYCD        X_CCY(#C)
 
      * Spot days
     C                   Z-ADD     A6SPDY        X_SPD(#C)
 
     C     A6NBDP        COMP      1                                    5051
     C     A6NBDP        COMP      2                                  53  52
 
      * Spot rate
     C   50              Z-ADD     A6SPRT        X_SPR(#C)
     C     A6MDIN        IFEQ      'M'
     C   51A6SPRT        DIV       10            X_SPR(#C)
     C   52A6SPRT        DIV       100           X_SPR(#C)
     C   53A6SPRT        DIV       1000          X_SPR(#C)
     C                   ELSE
     C   51A6SPRT        MULT      10            X_SPR(#C)
     C   52A6SPRT        MULT      100           X_SPR(#C)
     C   53A6SPRT        MULT      1000          X_SPR(#C)
     C                   END
 
      * Mult/Div
     C                   MOVE      A6MDIN        X_MDI(#C)
 
      * Factor
     C   50              Z-ADD     1000          X_FCT(#C)
     C   51              Z-ADD     10000         X_FCT(#C)
     C   52              Z-ADD     100000        X_FCT(#C)
     C   53              Z-ADD     1000000       X_FCT(#C)
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Access nostro details
      *****************************************************************
     C     ACS_NOSTDT    BEGSR
 
      * Access nostro record
 
     C                   MOVEL     I#CCY         CurrencyNostro    5
     C                   MOVE      I#NOSN        CurrencyNostro
 
      * Determine if nostro previously accessed
 
     C                   Z-ADD     1             #N                3 0
     C     CurrencyNostroLOOKUP    X_CCYNOS(#N)                           99    *
 
      * If not
 
     C     *IN99         IFEQ      *OFF
 
     C                   MOVEL     I#CCY         A7CYCD
     C                   MOVEL     I#NOSN        A7NONB
     C     GZSDNOSTK     SETLL     @NOSTJ0
     C     *IN99         DOUEQ     *ON
     C     GZSDNOSTK     READE     @NOSTJ0                                99    *
     C  N99I#ZONE        COMP      A8ZONE                                 99    *
     C                   ENDDO
 
     C     I#ZONE        IFNE      A8ZONE
     C                   EVAL      I#ERMS = 'INVALID NOSTRO:' + I#ZONE + A7CYCD
     C                                      + A7NONB
     C                   EXSR      *PSSR
     C                   END
 
      * Store nostro details
 
     C                   Z-ADD     1             #N
     C     *BLANK        LOOKUP    X_CCYNOS(#N)                           99    *
     C                   MOVEL     CurrencyNostroX_CCYNOS(#N)
 
      * branch
     C                   MOVEL     A7BRCD        X_NOSBRC(#N)
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                              AR987769
      *****************************************************************                     AR987769
      * Get Projections for 5th and 6th days                          *                     AR987769
      *****************************************************************                     AR987769
     C     GETPROJ       BEGSR                                                              AR987769
      *                                                                                     AR987769
      ** Set up Keys                                                                        AR987769
      *                                                                                     AR987769
     C                   MOVEL     A7ACCD        WAcCd                                      AR987769
     C                   MOVEL     X_Fct(#C)     X_Fctr
      *                                                                                     AR987769
     C                   CALL      'GL005801'                                               AR987769
     C                   PARM                    A7BRCD                                     AR987769
     C                   PARM                    A7CUST                                     AR987769
     C                   PARM                    A7CYCD                                     AR987769
     C                   PARM                    WAcCd                                      AR987769
     C                   PARM                    A7ACSN                                     AR987769
     C                   PARM                    NbDat6                                     AR987769
     C                   PARM                    NbDat7                                     AR987769
     C                   PARM                    X_Fctr                                     AR987769
     C                   PARM                    NbBal5                                     AR987769
     C                   PARM                    NbBal6                                     AR987769
     C                   PARM                    NbBal7                                     AR987769
      *                                                                                     AR987769
      ** Also update balance projection for 8th & 9th day based on 7th day                  AR987769
      *                                                                                     AR987769
     C                   EVAL      Bal(8) = Bal(7)                                          AR987769
     C                   EVAL      Bal(9) = Bal(7)                                          AR987769
     C                   EVAL      Bal(10) = Bal(7)                                         AR987769
      *                                                                                     AR987769
     C                   ENDSR                                                              AR987769
     ******************************************************************                     AR987769
     C/SPACE 5                                                                              AR987769
      *****************************************************************                     AR987769
      * MPhaseSR - Check current Midas Phase of Day                   *                     AR987769
      *****************************************************************                     AR987769
     C     MPhaseSR      BEGSR                                                              AR987769
      *                                                                                     AR987769
     C     A8ZONE        CHAIN     GPZONEL0                                                 AR987769
     C                   IF        %FOUND                                                   AR987769
     C     MPhaseK       SETLL     GPDWNLL0                                                 AR987769
     C     MPhaseK       READE(N)  GPDWNLL0                                                 AR987769
     C                   DOW       NOT %EOF                                                 AR987769
     C                   MOVEL     DLVAL         MPhase                                     AR987769
     C     MPhaseK       READE(N)  GPDWNLL0                                                 AR987769
     C                   ENDDO                                                              AR987769
     C                   ENDIF                                                              AR987769
      *                                                                                     AR987769
     C                   ENDSR                                                              AR987769
      *****************************************************************                     AR987769
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   Z-ADD     99999         DAT
      * Read dates
 
     C     *LOVAL        SETLL     GPNOSDD0
     C                   READ      GPNOSDD0
 
     C                   EVAL      K5KeyD = 'MidasPhaseOfDay'                               AR987769
      * Key lists
 
     C     GZSDNOSTK     KLIST
     C                   KFLD                    A7CYCD
     C                   KFLD                    A7NONB
     C     GZSDCURRK     KLIST
     C                   KFLD                    I#ZONE
     C                   KFLD                    I#CCY
     C     GPNOSBK       KLIST
     C                   KFLD                    NBBRCA
     C                   KFLD                    NBCCY
     C                   KFLD                    NBNOSN
      *                                                                                     AR987769
     C     MPHASEK       KLIST                                                              AR987769
     C                   KFLD                    ZOMSYS                                     AR987769
     C                   KFLD                    K5KeyD                                     AR987769
      *                                                                                     AR987769
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
