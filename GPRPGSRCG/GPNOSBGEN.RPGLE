     H DEBUG
     H DATEDIT(*DMYH)
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Nostro Balance Generation')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPNOSBGEN - Nostro Balance Generation                        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 AR987769           Date 22Jun12               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG14613           Date 14Sep07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG3999            Date 17Aug04               *
      *                 BUG2314            Date 30Apr04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR987769 - Discrepancies on the Projected Nostro Balances    *
      *             enquiry. Updated projections for 6th & 7th day in *
      *             GPNOSBPD based from RSACMTPD.                     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  BUG14613 - Diff in balances on Projected Nostro Java         *
      *             & Web face Enquiry(Apply Fix 242344)              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3999 - Duplicate dates in file GPNOSDPD (Nostro balance   *
      *            dates)                                             *
      *  BUG2314 - Records on GPNOSDPD with date of 99999.            *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FGZSDBRCHL1IF   E           K DISK    INFSR(*PSSR)
     FGZSDBANKL1IF   E           K DISK    INFSR(*PSSR)
     FGZSDCURRL1IF   E           K DISK    INFSR(*PSSR)
     FGZSDNOSTL1IF   E           K DISK    INFSR(*PSSR)
     FGZPRONOL1 IF   E           K DISK    INFSR(*PSSR)
     FGPNOSBL0  UF A E           K DISK    INFSR(*PSSR)
     FGPNOSDL0  UF A E           K DISK    INFSR(*PSSR)
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
 
 
      * Outgoing Dates & Balances                                                            BUG2314
     D  U_DAT                  1    250  0                                                   BUG2314
     D                                     DIM(50)                                           BUG2314
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
 
     D MPhase          S              1A                                                    AR987769
     D K5KeyD          S                   LIKE(DLKEYD)                                     AR987769
     D WAcCd           S             10S 0                                                  AR987769
     D X_Fctr          S              7S 0                                                  AR987769
 
      /SPACE 5
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * INPUTS
     C                   PARM                    I#ZONE           10
 
      * If one zone required
 
     C     I#ZONE        IFNE      *BLANK
 
      * Read branches in zone
 
     C     GZSDBRCHK     SETLL     SDBRCHD0
     C     GZSDBRCHK     READE     SDBRCHD0                               99
 
      * For each branch
     C     *IN99         DOWEQ     *OFF
 
      * Extract
     C                   EXSR      EXTRACT
 
      * Read next branch in zone
     C     GZSDBRCHK     READE     SDBRCHD0                               99
     C                   ENDDO
 
     C                   ELSE
 
      * If all zones required
 
      * Read all branches
     C     *LOVAL        SETLL     SDBRCHD0
     C                   READ      SDBRCHD0                               99
 
      * For each branch
     C     *IN99         DOWEQ     *OFF
 
      * Extract
     C                   EXSR      EXTRACT
 
      * Read next branch
     C                   READ      SDBRCHD0                               99
     C                   ENDDO
 
     C                   ENDIF
 
     C                   SETON                                        LR
     C                   RETURN
 
      /SPACE 5
      *****************************************************************
      * Extract
      *****************************************************************
     C     EXTRACT       BEGSR
 
      * Remove existing nostro balances for this branch
 
     C                   EXSR      REMOVE_NOSB
 
      * Get bank details
 
     C                   EXSR      GET_BANK
 
      * If zone is available
 
     C     Zone_Avail    IFEQ      'Y'
 
      * Load currency details
 
     C                   EXSR      LOAD_CURRDT
 
      * Update balances for this branch
 
     C                   EXSR      UPD_BAL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Remove existing nostro balances for this branch
      *****************************************************************
     C     REMOVE_NOSB   BEGSR
 
     C     GPNOSBK       SETLL     GPNOSBD0
     C     GPNOSBK       READE     GPNOSBD0                               99
     C     *IN99         DOWEQ     *OFF
     C                   DELETE    GPNOSBD0
     C     GPNOSBK       READE     GPNOSBD0                               99
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Update balances for this branch
      *****************************************************************
     C     UPD_BAL       BEGSR
 
     C     A8BRCD        SETLL     SDNOSTD0
 
     C     A8BRCD        READE     SDNOSTD0                               99
 
     C     *IN99         DOWEQ     *OFF
 
     C                   MOVEL     A7NONB        NostroNumber      2 0
     C     GZPRONOK      CHAIN     GZPRONOL1                          99
 
     C                   Z-ADD     0             BAL
     C     *IN99         IFEQ      *OFF
 
      * Get currency details
     C                   Z-ADD     1             #C                3 0
     C     CCY           LOOKUP    X_CCY(#C)                              99
 
      * Move balances into relevant column
 
     C                   Z-ADD     1             X
     C                   Z-ADD     1             Y
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
     C                   IF        MPhase <> 'A'                                            AR987769
     C                   EXSR      GetProj                                                  AR987769
     C                   ENDIF                                                              AR987769
      *    Write To file
 
     C                   MOVEL     A8BRCD        NBBRCA
     C                   MOVEL     CCY           NBCCY
     C                   MOVEL     NOSN          NBNOSN
     C                   WRITE     GPNOSBD0
     C                   ENDIF
 
     C     A8BRCD        READE     SDNOSTD0                               99
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Get bank details for zone
      *****************************************************************
     C     GET_BANK      BEGSR
 
     C     A8ZONE        CHAIN     SDBANKD0                           99
     C     *IN99         IFEQ      *OFF
     C                   MOVEL     'Y'           Zone_Avail        1
     C                   ELSE
     C                   MOVEL     'N'           Zone_Avail
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Load Currency Details
      *****************************************************************
     C     LOAD_CURRDT   BEGSR
 
     C                   MOVE      *BLANK        X_CCY
     C                   Z-ADD     *zero         X_SPD
     C                   Z-ADD     *zero         X_SPR
     C                   MOVE      *BLANK        X_MDI
     C                   Z-ADD     *zero         X_FCT
 
     C                   Z-ADD     0             #C                3 0
 
      *  Read All Records In The Currency Code File And Build
      *  Program Arrays Of Currency/Spot Rate and Factor.
 
     C     A8ZONE        SETLL     GZSDCURRL1
     C     *IN40         DOUEQ     '1'
     C     A8ZONE        READE     GZSDCURRL1                             40
 
     C     *IN40         IFEQ      '0'
     C     A6DLCI        ANDEQ     'Y'
 
     C                   ADD       1             #C
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
     C                   END
     C                   ENDDO
 
     C                   Z-ADD     #C            CurrencyCount     3 0
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Load All Available Dates
      *****************************************************************
     C     LOAD_AVLDAT   BEGSR
 
      * Read all dates from projected nostro balances
 
     C     *LOVAL        SETLL     GZPRONOL1
 
     C                   READ      GZPRONOL1                              99
 
     C     *IN99         DOWEQ     *OFF
 
      * Move dates
 
     C                   Z-ADD     1             X                 3 0
     C     X             DOUGT     5
     C                   Z-ADD     1             Y                 3 0
     C     PRD(X)        LOOKUP    DAT(Y)                                 99
     C     *IN99         IFEQ      *OFF
     C     99999         LOOKUP    DAT(Y)                                 99
     C   99              Z-ADD     PRD(X)        DAT(Y)
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
 
     C                   READ      GZPRONOL1                              99
 
     C                   ENDDO
                                                                                             BUG2314
      * Set unallocated dates                                                                BUG2314
                                                                                             BUG2314
     C                   SORTA     DAT                                                       BUG3999
     C                   EXSR      SET_UNALDAT                                               BUG2314
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                               BUG2314
      *****************************************************************                      BUG2314
      * Set Unallocated Dates                                                                BUG2314
      *****************************************************************                      BUG2314
     C     SET_UNALDAT   BEGSR                                                               BUG2314
     C                   Z-ADD     99999         CFDate            5 0                       BUG2314
     C                   Z-ADD     1             Y                                           BUG2314
     C     Y             DOWLE     10                                                        BUG2314
     C     DAT(Y)        IFEQ      99999                                                     BUG2314
     C                   ADD       1             CFDate                                      BUG2314
     C     CFDate        DIV       7             WRK153           15 3                       BUG2314
     C                   MOVE      WRK153        WRK30             3 0                       BUG2314
      * Holiday?                                                                             BUG2314
     C     WRK30         DOWEQ     142                                                       BUG2314
     C     WRK30         OREQ      285                                                       BUG2314
     C                   ADD       1             CFDate                                      BUG2314
     C     CFDate        DIV       7             WRK153                                      BUG2314
     C                   MOVE      WRK153        WRK30                                       BUG2314
     C                   ENDDO                                                               BUG2314
      * Set date                                                                             BUG2314
     C                   Z-ADD     CFDate        DAT(Y)                                      BUG2314
     C                   ELSE                                                                BUG2314
     C                   Z-ADD     DAT(Y)        CFDate                                      BUG2314
     C                   ENDIF                                                               BUG2314
     C                   ADD       1             Y                                           BUG2314
     C                   ENDDO                                                               BUG2314
     C                   ENDSR                                                               BUG2314
      *****************************************************************                      BUG2314
      /SPACE 5                                                                              AR987769
      *****************************************************************                     AR987769
      *  GetProj - Get Projections for 5th and 6th day                *                     AR987769
      *****************************************************************                     AR987769
     C     GetProj       BEGSR                                                              AR987769
      *                                                                                     AR987769
      ** Set up Keys                                                                        AR987769
      *                                                                                     AR987769
     C                   MOVEL     A7ACCD        WAcCd                                      AR987769
     C                   MOVEL     X_Fct(#C)     X_Fctr                                     AR987769
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
      ** Also update balance projection beyond 6th day                                      AR987769
      *                                                                                     AR987769
     C                   EVAL      Bal(8) = Bal(7)                                          AR987769
     C                   EVAL      Bal(9) = Bal(7)                                          AR987769
     C                   EVAL      Bal(10) = Bal(7)                                         AR987769
      *                                                                                     AR987769
     C                   ENDSR                                                              AR987769
      *****************************************************************                     AR987769
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
 
      * Load All Available Dates
 
     C                   EXSR      LOAD_AVLDAT
 
     C                   SORTA     DAT
 
      * Write (first 10) Nostro Dates
 
     C                   MOVE      DAT           U_DAT                                       BUG2314
     C     GPNOSDK       CHAIN     GPNOSDD0                           99
     C                   MOVE      U_DAT         DAT                                         BUG2314
     C     *IN99         IFEQ      *ON
     C                   WRITE     GPNOSDD0
     C                   ELSE
     C                   UPDATE    GPNOSDD0
     C                   ENDIF
 
     C                   EVAL      K5KeyD = 'MidasPhaseOfDay'                               AR987769
      * Key lists
 
     C     GPNOSDK       KLIST
     C                   KFLD                    NBKEY
     C     GPNOSBK       KLIST
     C                   KFLD                    A8BRCD
     C     GZPRONOK      KLIST
     C                   KFLD                    A8ZONE
     C                   KFLD                    A7CYCD
     C                   KFLD                    NostroNumber
     C     GZSDBRCHK     KLIST
     C                   KFLD                    I#ZONE
      *                                                                                     AR987769
     C     MPhaseK       KLIST                                                              AR987769
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
