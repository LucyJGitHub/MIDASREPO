     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Work with extract data')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOWRKEDTA - Work with Extract Data                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD032884           Date 09Jun15               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER016             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245230             Date 24Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242258A            Date 03Oct06               *
      *                 242258             Date 22Sep06               *
      *                 BUG11817           Date 03Aug06               *
      *                 BUG11830           Date 01Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG5221            Date 14Dec04               *
      *                 BUG3860            Date 11Aug04               *
      *                 TDA102             Date 28Mar04               *
      *                 BG1272             Date 24Feb04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD032884 - Performance enhancement for GOCXCLTS. Recompiled  *
      *             due to change in GOCASHPD, GOPOSNPD & GOWEVNTPD.  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER016 - German Interest Calculation: Upgrade of FGE059      *
      *           to Midas Plus                                       *
      *  245230 - Change GOWEVNTL0 to be opened under user control    *
      *           else if it's locked *PSSR is not invoked and        *
      *           GOC0020 will not report in the cob that its failed  *
      *  242258A- Supress generation of 'MT' cashflow for FRA/IRS also*
      *  242258 - Supress generation of 'VD' cashflow for FRA/IRS     *
      *  BUG11817 - Risk Customer Alpha (C_RCSA) field in GPCASHPD    *
      *             is empty.                                         *
      *  BUG11830 - Move T_RCBR to C_SETB field before writing to     *
      *             GPCASHPD.                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG5221 - Additional fields added to GPCASHPD/GOCASHPD       *
      *  BUG3860 - (recompile)                                        *
      *  TDA102 - 10-digit a/c code error. GO* programs dump.         *
      *  BG1272 - Omit invalid forward date positions                 *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     F*****GOWEVNTL0 UF   E           K DISK    INFSR(*PSSR)                                  245230
     FGOWEVNTL0 UF   E           K DISK    INFSR(*PSSR) USROPN                                245230
     FGOWEVNTPD O    E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GOWEVNTD0:GOWEVNTWRT)
 
     FGOWPOSNPD O    E           K DISK    INFSR(*PSSR) USROPN
 
     FGPPOSNPD  O    E           K DISK    INFSR(*PSSR) USROPN  COMMIT
     F                                     RENAME(GOPOSND0:GPPOSND0)
     FGPCASHPD  O    E           K DISK    INFSR(*PSSR) USROPN  COMMIT
     F                                     RENAME(GOCASHD0:GPCASHD0)
 
     FGOPOSNPD  O    E           K DISK    INFSR(*PSSR) USROPN
     FGOCASHPD  O    E           K DISK    INFSR(*PSSR) USROPN
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
      ** C A S H F L O W    D E T A I L S
     D C_CASH        E DS                  EXTNAME(GPCASHPD)
     D**C_SETD****************42     61                                                       TDA102
     D  C_SETD                42     67                                                       TDA102
 
 
      ** P O S I T I O N    D E T A I L S
     D P_POSN        E DS                  EXTNAME(GOWPOSNPD)
      ** E V E N T    D E T A I L S
     D E_EVNT        E DS                  EXTNAME(GOWEVNTPD)
     D**E_SETD***************179    198                                                       TDA102
     D  E_SETD               185    210                                                       TDA102
 
 
      ** The size of the detail arrays
     D ArrSizDet       C                   CONST(360)
 
      * WORK ARRAYS OF EVENT DATES AND DATA
     D #arevdt_WK    E DS                  EXTNAME(DEEVDTPD) PREFIX(WK)
     D #_WKdat                 1   1800  0 DIM(ArrSizDet) ASCEND
     D #_WKdta              1801   7200    DIM(ArrSizDet) ASCEND
 
      * ARRAYS OF INTEREST PAYMENT DATES AND DATA
     D #arevdt_ip    E DS                  EXTNAME(DEEVDTPD) PREFIX(IP)
     D #_ipdat                 1   1800  0 DIM(ArrSizDet) ASCEND
     D #_ipdta              1801   7200    DIM(ArrSizDet) ASCEND
 
      * ARRAYS OF INTEREST RATE CHANGE DATES AND DATA
     D #arevdt_ir    E DS                  EXTNAME(DEEVDTPD) PREFIX(IR)
     D #_irdat                 1   1800  0 DIM(ArrSizDet) ASCEND
     D #_irdta              1801   7200    DIM(ArrSizDet) ASCEND
 
 
      ** EVENT TYPES/SEQUENCES
     D TABTYP          S              2    DIM(16) CTDATA PERRCD(1)
     D TABSEQ          S              2  0 DIM(16) ALT(TABTYP)
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                 BUG5221
 
      ** Array for manipulating decimal positions                                            BUG5221
     D POWER8          S              8  7 DIM(8) CTDATA PERRCD(1)                           BUG5221
 
      **
      **   ENTRY PARAMETER LIST
      **
     C     *ENTRY        PLIST
     C                   PARM                    Ret_Code          7
     C                   PARM                    Err_Mess         50
     C                   PARM                    Mode_of_Op       10
     C                   PARM                    Location          4
     C                   PARM                    Run_Date          5 0
     C                   PARM                    Date_NWD          5 0
     C                   PARM                    ProjCO_Dat        5 0
     C                   PARM                    Trade_Value       1
      * Diagnostics?
     C                   PARM                    Diagnostics       1
      * TRANSACTION
     C                   PARM                    T_TRAP
      * POSITION
     C                   PARM                    P_POSN
      * EVENT
     C                   PARM                    E_EVNT
 
      * Import opening balance
 
     C                   SELECT
     C     Mode_of_Op    WHENEQ    '*IMPOPBL'
     C                   EXSR      IMP_OPBL
 
      * Import an event
 
     C     Mode_of_Op    WHENEQ    '*IMPEVNT'
     C                   EXSR      IMP_EVNT
 
      * Process imported events
 
     C     Mode_of_Op    WHENEQ    '*PROCSIM'
     C                   EXSR      VAL_EVNTS
     C                   EXSR      RED_EVNTS
     C                   ENDSL
 
      * RETURN
     C                   RETURN
 
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Import opening balance
      *********************************************************************
     C     IMP_OPBL      BEGSR
 
      * Initialize position fields
     C                   EXSR      INIT_POSN
 
      * Set the initial position date
      * (It can't be zero)
     C                   Z-ADD     P_PDAT        InitialPDAT       5 0
     C     InitialPDAT   IFEQ      *ZERO
     C                   EVAL      Err_Mess = 'BAD INITIAL POSITION DATE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Initialise previous (event) date
     C                   Z-ADD     *ZERO         P@PRDT            5 0
 
      * Initialize 'current' value date accrued interest
     C     Trade_Value   IFEQ      'V'
     C     T_MATI        OREQ      'Y'
     C     T_ID          IFNE      P@T_ID
     C                   Z-ADD     *ZERO         Cur_V_A_AITD     15 0
     C                   Z-ADD     *ZERO         Cur_V_L_AITD     15 0
     C                   Z-ADD     T_ID          P@T_ID           15 0
     C                   ENDIF
     C                   ENDIF
 
      * Clear date and data arrays
     C                   CLEAR                   #_ipdat
     C                   CLEAR                   #_ipdta
     C                   CLEAR                   #_irdat
     C                   CLEAR                   #_irdta
 
      * Reset 'Maturity Date Processed' indicator
     C                   MOVEL     *BLANK        MatDat_P          1
 
      * Initialize work event fields
     C                   EXSR      INIT_WEVNT
 
      * Clear events
     C     Location      IFEQ      'GLOB'
     C     GOWEVNTK      SETLL     GOWEVNTD0
     C     GOWEVNTK      READE     GOWEVNTD0                              99
     C     *IN99         DOWEQ     *OFF
     C                   DELETE    GOWEVNTD0
     C     GOWEVNTK      READE     GOWEVNTD0                              99
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Import an event
      *********************************************************************
     C     IMP_EVNT      BEGSR
 
      * Initialize work event fields
     C                   EXSR      INIT_WEVNT
 
      * Check that event type is valid
     C     E_EVTP        LOOKUP    TABTYP        TABSEQ                   99
     C     *IN99         IFEQ      '0'
     C                   EVAL      Err_Mess = 'EVENT TYPE IS INVALID'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Set processing sequence if needed
     C     E_PRSQ        IFEQ      *ZERO
     C                   MOVEL     TABSEQ        E_PRSQ
     C                   ENDIF
 
      * Check that processing date is valid
     C     E_PRDT        IFLE      *ZERO
     C                   EVAL      Err_Mess = 'PROCESSING DATE IS INVALID'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Set number of currency decimal places
     C     E_CCY         IFEQ      *BLANK
     C                   Z-ADD     P_NCDP        E_NCDP
     C                   ENDIF
 
      * If processing date is <= the projection cut-off date + 1 year
      *  Write work event
     C     E_PRDT        IFLE      ProjCO_Dat_1Yr
     C                   WRITE     GOWEVNTWRT
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Validate events (as they are read into the events array)
      *********************************************************************
     C     VAL_EVNTS     BEGSR
 
      * Initialize work event fields
     C                   EXSR      INIT_WEVNT
 
      * Read first event
     C     GOWEVNTK      SETLL     GOWEVNTD0
     C     GOWEVNTK      READE     GOWEVNTD0                              99
 
      * No event, so '*IMPEVNT' never invoked
     C     *IN99         IFEQ      *ON
     C                   EVAL      Err_Mess = '*IMPEVNT NEVER INVOKED'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Read all events
     C     *IN99         DOWEQ     *OFF
 
      * Check that if there is a maturity event
      * it has a date >= the initial position date
     C     E_EVTP        IFEQ      'MT'
     C     E_PRDT        ANDLT     InitialPDAT
     C                   EVAL      Err_Mess = 'INVALID MATURITY DATE EVENT'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If event is an interest payment date
      * or if event is a maturity date
      * log date in interest payment dates array
     C     E_EVTP        IFEQ      'IP'
     C     E_EVTP        OREQ      'MT'
 
      ** If first interest payment date > the initial position date
      **   set interest payment date 1 = the initial position date
     C     #_ipdat(1)    IFEQ      *ZERO
     C     E_PRDT        ANDGT     InitialPDAT
     C                   Z-ADD     InitialPDAT   #_ipdat(1)
     C                   ENDIF
 
     C                   MOVEL     'IP'          W#TYPE
     C                   MOVEL     #arevdt_ip    #arevdt_WK
     C                   EXSR      LOG_EVDT
     C                   MOVEL     #arevdt_WK    #arevdt_ip
     C                   ENDIF
 
      * If event is a rate change date
      * or if event is a maturity date
      * log date in interest rate change dates array
     C     E_EVTP        IFEQ      'SC'
     C     E_EVTP        OREQ      'BC'
     C     E_EVTP        OREQ      'RO'
     C     E_EVTP        OREQ      'MT'
 
      ** If first interest rate change date > the initial position date
      **   set interest rate change date 1 = the initial position date
     C     #_irdat(1)    IFEQ      *ZERO
     C     E_PRDT        ANDGT     InitialPDAT
     C                   Z-ADD     InitialPDAT   #_irdat(1)
     C                   ENDIF
 
     C                   MOVEL     'IR'          W#TYPE
     C                   MOVEL     #arevdt_ir    #arevdt_WK
     C                   EXSR      LOG_EVDT
     C                   MOVEL     #arevdt_WK    #arevdt_ir
     C                   ENDIF
 
      * If the event date is after the projections cut-off date
      *  Remove it
     C     E_PRDT        IFGT      ProjCO_Dat
     C                   DELETE    GOWEVNTD0
     C                   ELSE
 
      ** Set previous (event) date =
      ** event date of first event to be processed
     C     P@PRDT        IFEQ      *ZERO
     C                   Z-ADD     E_PRDT        P@PRDT
     C                   ENDIF
     C                   ENDIF
 
      * Read next event
     C     GOWEVNTK      READE     GOWEVNTD0                              99
     C                   ENDDO
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Read events (and process them)
      *********************************************************************
     C     RED_EVNTS     BEGSR
 
      * Reset event sequence
     C                   Z-ADD     *ZERO         EvntSeq           3 0
 
      * Read first event
     C     GOWEVNTK      SETLL     GOWEVNTD0
     C     GOWEVNTK      READE     GOWEVNTD0                              99
 
      * No event, so no valid events were passed in
     C     *IN99         IFEQ      *ON
     C                   EVAL      Err_Mess = 'NO VALID EVENTS READ'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Read all events
     C     *IN99         DOWEQ     *OFF
     C     MatDat_P      ANDNE     'Y'
 
      * Reset event sequence
     C     E_PRDT        IFNE      P@PRDT
     C                   Z-ADD     *ZERO         EvntSeq
     C                   ENDIF
 
      * Set event reference if not present
     C     E_EVTP        IFNE      'PE'
     C     E_EVRF        ANDEQ     *BLANK
     C                   ADD       1             EvntSeq
     C                   MOVE      EvntSeq       E_EVRF
     C                   ENDIF
 
      * On change of date (current date <> previous date)
     C     E_PRDT        IFNE      P@PRDT
 
      * Set position details
     C                   EXSR      SET_POSD
 
      * If previous event date >= the initial position date
      *  Do accruals
     C     Trade_Value   IFEQ      'V'
     C     P@PRDT        IFGE      InitialPDAT
     C                   EXSR      DO_ACC
     C                   ENDIF
     C                   ENDIF
 
      * Write a position
     C                   EXSR      WRT_POSN
 
      * Update previous date
     C                   Z-ADD     E_PRDT        P@PRDT
 
     C                   ENDIF
 
      * Process the event
     C     E_EVTP        CASEQ     'DD'          DEALDAT
     C     E_EVTP        CASEQ     'VD'          VALUEDAT
     C     E_EVTP        CASEQ     'FE'          FEE
     C     E_EVTP        CASEQ     'MI'          MANADJINT
     C     E_EVTP        CASEQ     'SA'          STOPACC
     C     E_EVTP        CASEQ     'PI'          PRININC
     C     E_EVTP        CASEQ     'PD'          PRINDEC
     C     E_EVTP        CASEQ     'IP'          INTPAY
     C     E_EVTP        CASEQ     'OD'          OVERDUE
     C     E_EVTP        CASEQ     'RE'          REPAY
     C     E_EVTP        CASEQ     'MR'          MANREP
     C     E_EVTP        CASEQ     'SC'          SPRDCHG
     C     E_EVTP        CASEQ     'BC'          BASECHG
     C     E_EVTP        CASEQ     'RO'          ROLLOVER
     C     E_EVTP        CASEQ     'PE'          PERDEND
     C     E_EVTP        CASEQ     'MT'          MATURITY
     C                   ENDCS
 
      * Read next event
     C     GOWEVNTK      READE     GOWEVNTD0                              99
     C                   ENDDO
 
      * If there was no change of date (current event date = previous date)
      * or if the current position date < latest event date
     C     E_PRDT        IFEQ      P@PRDT
     C     P_PDAT        ORLT      E_PRDT
 
      * Set position details
     C                   EXSR      SET_POSD
 
      * If previous event date >= the initial position date
      *  Do accruals
     C     Trade_Value   IFEQ      'V'
     C     P@PRDT        IFGE      InitialPDAT
     C                   EXSR      DO_ACC
     C                   ENDIF
     C                   ENDIF
 
      * Write a position
     C                   EXSR      WRT_POSN
 
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** DEAL DATE
      *********************************************************************
     C     DEALDAT       BEGSR
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** VALUE DATE
      *********************************************************************
     C     VALUEDAT      BEGSR
 
      * If interest is amortised
      *    If the next interest amount is not supplied on the event
      *    (as well as the next interest date)
      *       Determine the next interest amount
      *       on the next interest payment date
      *    Set the position next interest date = event next interest date
      *    Set the position next interest amnt = event next interest amnt
      *    (interest due at the next interest payment date)
 
     C     P_AMIN        IFEQ      'Y'
     C     E_NINA        IFEQ      *ZERO
     C                   EXSR      DETNxtIntPay
     C                   ENDIF
     C                   Z-ADD     E_NIND        P_NIND
     C                   Z-ADD     E_NINA        P_NINA
     C                   ENDIF
 
      * Set output cashflow fields
 
     C                   CLEAR                   C_CASH
 
      * countervalue
     C     E_TAMT        IFNE      *ZERO
     C                   Z-ADD     E_TAMT        C_AMNT
     C                   ELSE
      * interest
     C     E_INTA        IFNE      *ZERO
     C                   Z-ADD     E_INTA        C_AMNT
     C                   ELSE
      * principal
     C                   Z-ADD     P_NOML        C_AMNT
     C                   ENDIF
     C                   ENDIF
      * in/out
     C     E_IO          IFEQ      *BLANK
     C     P_ASLI        IFEQ      'A'
     C                   MOVEL     'O'           C_IO
     C                   ELSE
     C                   MOVEL     'I'           C_IO
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     E_IO          C_IO
     C                   ENDIF
 
      * settlement instructions
     C                   MOVEL     E_SETD        C_SETD
 
      * Write a cashflow record
 
     C                   EXSR      WRT_CASH
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** FEE PAYMENT DATE
      *********************************************************************
     C     FEE           BEGSR
 
      * Set output cashflow fields
 
     C                   CLEAR                   C_CASH
 
     C                   MOVEL     E_SETC        C_CCY
     C                   Z-ADD     E_FEE         C_AMNT
      * in/out
     C                   MOVEL     E_IO          C_IO
      * settlement instructions
     C                   MOVEL     E_SETD        C_SETD
 
      * Write a cashflow record
 
     C                   EXSR      WRT_CASH
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** MANUAL ADJUSTMENT TO ACCRUED INTEREST
      *********************************************************************
     C     MANADJINT     BEGSR
 
      * Add manual adjustment of interest
      * to accrued interest adjustments total
 
     C                   ADD       E_INTA        P_AIAD
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** STOP/START ACCRUALS
      *********************************************************************
     C     STOPACC       BEGSR
 
      * Stop or start accruals
 
     C                   MOVE      E_STAC        P_STAC
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** PRINCIPAL INCREASE
      *********************************************************************
     C     PRININC       BEGSR
 
      * Update current principal
 
     C                   ADD       E_PRAM        P_NOML
 
      * Set output cashflow fields
 
     C                   CLEAR                   C_CASH
      * countervalue
     C     E_TAMT        IFNE      *ZERO
     C                   MOVEL     'C'           C_CATG
     C                   Z-ADD     E_TAMT        C_AMNT
     C                   ELSE
      * principal
     C                   MOVEL     'P'           C_CATG
     C                   Z-ADD     E_PRAM        C_AMNT
     C                   ENDIF
      * in/out
     C     P_ASLI        IFEQ      'A'
     C                   MOVEL     'O'           C_IO
     C                   ELSE
     C                   MOVEL     'I'           C_IO
     C                   ENDIF
      * settlement instructions
     C                   MOVEL     E_SETD        C_SETD
 
      * Write a cashflow record
 
     C                   EXSR      WRT_CASH
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** PRINCIPAL DECREASE
      *********************************************************************
     C     PRINDEC       BEGSR
 
      * Update Current Principal
 
     C                   SUB       E_PRAM        P_NOML
 
      * Set output cashflow fields
 
     C                   CLEAR                   C_CASH
 
      * countervalue
     C     E_TAMT        IFNE      *ZERO
     C                   MOVEL     'C'           C_CATG
     C                   Z-ADD     E_TAMT        C_AMNT
     C                   ELSE
      * principal
     C                   MOVEL     'P'           C_CATG
     C                   Z-ADD     E_PRAM        C_AMNT
     C                   ENDIF
      * in/out
     C     P_ASLI        IFEQ      'A'
     C                   MOVEL     'I'           C_IO
     C                   ELSE
     C                   MOVEL     'O'           C_IO
     C                   ENDIF
      * settlement instructions
     C                   MOVEL     E_SETD        C_SETD
 
      * Write a cashflow record
 
     C                   EXSR      WRT_CASH
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** INTEREST PAYMENT
      *********************************************************************
     C     INTPAY        BEGSR
 
      * If interest is accrued & payable up-front on a yield/discount basis
      *  If the interest is not supplied on the event
      *     Calculate the interest due
      *     from this int pay date to the next int pay date
      *  Set total interest   = event interest amount (int due on this date)
      *  Set accrued interest = event interest amount (int due on this date)
 
     C     P_ACIN        IFEQ      'Y'
     C     P_INPM        IFEQ      'Y'
     C     P_INPM        OREQ      'D'
     C     E_INTA        IFEQ      *ZERO
     C                   EXSR      CAL_INT_UF
     C                   ENDIF
     C                   Z-ADD     E_INTA        P_TOTI
     C                   Z-ADD     E_INTA        P_AITD
     C                   ENDIF
     C                   ENDIF
 
      * If interest is amortised
      *    If the next interest amount is not supplied on the event
      *    (as well as the next interest date)
      *       Determine the next interest amount
      *       on the next interest payment date
      *    Set the position next interest date = event next interest date
      *    Set the position next interest amnt = event next interest amnt
      *    (interest due at the next interest payment date)
      *    Set the position accrued interest = event interest amount
      *    (interest due at this interest payment date)
 
     C     P_AMIN        IFEQ      'Y'
     C     E_NINA        IFEQ      *ZERO
     C                   EXSR      DETNxtIntPay
     C                   ENDIF
     C                   Z-ADD     E_NIND        P_NIND
     C                   Z-ADD     E_NINA        P_NINA
     C                   Z-ADD     E_INTA        P_AITD
     C                   ENDIF
 
      **   Update current principal if interest to be capitalised
 
     C     E_INTC        IFEQ      'Y'
     C     P_INTC        OREQ      'Y'
     C                   ADD       P_AITD        P_NOML
     C                   ENDIF
 
      **   Update interest paid or interest capitalised to date
 
     C     E_INTC        IFEQ      'Y'
     C     P_INTC        OREQ      'Y'
     C                   ADD       P_AITD        P_ICTD
     C                   ELSE
     C                   ADD       P_AITD        P_IPRD
     C                   ENDIF
 
      * Set output cashflow fields
 
     C                   CLEAR                   C_CASH
 
      * interest
     C                   MOVEL     'I'           C_CATG
     C                   Z-ADD     P_AITD        C_AMNT
      * in/out
     C     P_ASLI        IFEQ      'A'
     C                   MOVEL     'I'           C_IO
     C                   ELSE
     C                   MOVEL     'O'           C_IO
     C                   ENDIF
      * settlement instructions
     C                   MOVEL     E_SETD        C_SETD
 
      * Write a cashflow record
 
     C                   EXSR      WRT_CASH
 
      * If interest is accrued & payable up-front on a yield/discount basis
      * or interest is amortised
      *    Zeroise accrued interest to date
     C     P_ACIN        IFEQ      'Y'
     C     P_INPM        ANDEQ     'Y'
     C     P_ACIN        OREQ      'Y'
     C     P_INPM        ANDEQ     'D'
     C     P_AMIN        OREQ      'Y'
     C                   Z-ADD     *ZERO         P_AITD
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** OVERDUE PAYMENT
      *********************************************************************
     C     OVERDUE       BEGSR
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      **  GENERATE REPAYMENT EVENT(S)
      *********************************************************************
     C     REPAY         BEGSR
 
      **   REPAYMENT TYPE '1'
 
     C     P_REPT        IFEQ      1
 
      * REPAYMENT OF PRINCIPAL
 
     C                   Z-ADD     E_PRAM        W#PRIN           13 0
 
      * REPAYMENT OF INTEREST
 
     C                   Z-ADD     P_AITD        W#INTR           13 0
     C                   ENDIF
 
      **   REPAYMENT TYPE '2'
 
     C     P_REPT        IFEQ      2
 
      * REPAYMENT OF PRINCIPAL
 
     C                   Z-ADD     E_TAMT        W#PRIN
 
      * REPAYMENT OF INTEREST
 
     C                   Z-ADD     0             W#INTR
     C                   ENDIF
 
      **   REPAYMENT TYPE '3'
 
     C     P_REPT        IFEQ      3
 
      * TOTAL REPAYMENT AMOUNT
 
     C     P_NOML        IFLT      0
     C                   Z-ADD     0             W#TOTL           13 0
     C                   ELSE
     C     P_NOML        IFLT      E_TAMT
     C                   Z-ADD     P_NOML        W#TOTL
     C                   ELSE
     C                   Z-ADD     E_TAMT        W#TOTL
     C                   END
     C                   END
 
      * REPAYMENT OF PRINCIPAL AND INTEREST
 
     C     P_AITD        IFLE      W#TOTL
     C                   Z-ADD     P_AITD        W#INTR
     C     W#TOTL        SUB       P_AITD        W#PRIN
     C                   ELSE
     C                   Z-ADD     W#TOTL        W#INTR
     C                   Z-ADD     0             W#PRIN
     C                   ENDIF
     C                   ENDIF
 
      * NO PRINCIPAL REPAYMENT IF PRINCIPAL IS NEGATIVE
 
     C     P_NOML        IFLT      0
     C                   Z-ADD     0             W#PRIN
     C                   END
 
      * CAN'T REPAY MORE THAN THE CURRENT PRINCIPAL
 
     C     P_NOML        IFLT      W#PRIN
     C                   Z-ADD     P_NOML        W#PRIN
     C                   END
 
      **   UPDATE CURRENT PRINCIPAL
 
     C                   SUB       W#PRIN        P_NOML
 
      **   UPDATE INTEREST PAID TO DATE
 
     C                   ADD       W#INTR        P_IPRD
 
      **   REDUCE CURRENT INTEREST DUE
 
     C                   SUB       W#INTR        P_AITD
 
      * Set output cashflow fields
 
     C                   CLEAR                   C_CASH
 
      * PRINCIPAL REPAID
      * ----------------
 
     C     W#PRIN        IFNE      *ZERO
      * principal
     C                   MOVEL     'P'           C_CATG
     C                   Z-ADD     W#PRIN        C_AMNT
      * in/out
     C     P_ASLI        IFEQ      'A'
     C                   MOVEL     'I'           C_IO
     C                   ELSE
     C                   MOVEL     'O'           C_IO
     C                   ENDIF
      * settlement instructions
     C                   MOVEL     E_SETD        C_SETD
      * Write a cashflow record
     C                   EXSR      WRT_CASH
 
     C                   ENDIF
 
      * INTEREST REPAID
      * ---------------
 
     C     W#INTR        IFNE      *ZERO
      * interest
     C                   MOVEL     'I'           C_CATG
     C                   Z-ADD     W#INTR        C_AMNT
      * in/out
     C     P_ASLI        IFEQ      'A'
     C                   MOVEL     'I'           C_IO
     C                   ELSE
     C                   MOVEL     'O'           C_IO
     C                   ENDIF
      * settlement instructions
     C                   MOVEL     E_SETD        C_SETD
      * Write a cashflow record
     C                   EXSR      WRT_CASH
 
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      **  MANUAL REPAYMENT EVENT(S)
      ********************************************************************
     C     MANREP        BEGSR
 
      * UPDATE CURRENT PRINCIPAL WITH PRINCIPAL REPAID
 
     C                   SUB       E_PRAM        P_NOML
 
      * UPDATE INTEREST PAID TO DATE WITH INTEREST REPAID
 
     C                   ADD       E_INTA        P_IPRD
 
      * Set output cashflow fields
 
     C                   CLEAR                   C_CASH
 
      * PRINCIPAL REPAID
      * ----------------
 
     C     E_PRAM        IFNE      *ZERO
      * principal
     C                   MOVEL     'P'           C_CATG
     C                   Z-ADD     E_PRAM        C_AMNT
      * in/out
     C     P_ASLI        IFEQ      'A'
     C                   MOVEL     'I'           C_IO
     C                   ELSE
     C                   MOVEL     'O'           C_IO
     C                   ENDIF
      * settlement instructions
     C                   MOVEL     E_SETD        C_SETD
      * Write a cashflow record
     C                   EXSR      WRT_CASH
 
     C                   ENDIF
 
      * INTEREST REPAID
      * ----------------
 
     C     E_INTA        IFNE      *ZERO
      * interest
     C                   MOVEL     'I'           C_CATG
     C                   Z-ADD     E_INTA        C_AMNT
      * in/out
     C     P_ASLI        IFEQ      'A'
     C                   MOVEL     'I'           C_IO
     C                   ELSE
     C                   MOVEL     'O'           C_IO
     C                   ENDIF
      * settlement instructions
     C                   MOVEL     E_SETD        C_SETD
      * Write a cashflow record
     C                   EXSR      WRT_CASH
 
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** SPREAD CHANGE
      *********************************************************************
     C     SPRDCHG       BEGSR
 
      ** UPDATE (INTEREST) SPREAD RATE
 
     C                   Z-ADD     E_RTSP        P_RTSP
 
      ** UPDATE INTEREST RATE
 
     C                   EXSR      UPD_IRAT
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** BASE RATE CHANGE OR BASE RATE CODE CHANGE
      *********************************************************************
     C     BASECHG       BEGSR
 
      * Update Base Rate Code
 
     C                   MOVE      E_BRTT        P_BRTT
 
      ** If interest rate type signifies current base rate
 
     C     E_IRTP        IFEQ      'C'
 
      ** Update Base Rate
 
     C                   Z-ADD     E_BRTE        P_BRTE
 
      ** Update interest rate
 
     C                   EXSR      UPD_IRAT
     C                   ENDIF
 
      ** If interest rate type signifies actual interest rate
 
     C     E_IRTP        IFEQ      'A'
 
      ** Update interest rate
 
     C                   Z-ADD     E_IRAT        P_IRAT
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** ROLLOVER EVENT
      *********************************************************************
     C     ROLLOVER      BEGSR
 
      ** TAKE NEW BASE RATE, IF PRESENT
 
     C     E_BRTE        IFNE      0
     C                   Z-ADD     E_BRTE        P_BRTE
     C                   ENDIF
 
      ** TAKE NEW INTEREST RATE DETAILS, IF PRESENT
 
     C     E_IRCH        IFEQ      'Y'
     C                   Z-ADD     E_RTSP        P_RTSP
     C                   MOVE      E_SPIN        P_SPIN
     C                   MOVE      E_ICMT        P_ICMT
     C                   ENDIF
 
      ** UPDATE INTEREST RATE
 
     C                   EXSR      UPD_IRAT
 
      ** TAKE NEW NOMINAL & CURRENCY, IF PRESENT
 
     C     E_NOML        IFNE      0
     C     E_CCY         ANDNE     *BLANK
     C                   Z-ADD     E_NOML        P_NOML
     C                   MOVE      E_CCY         P_CCY
     C                   Z-ADD     E_NCDP        P_NCDP
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** PERIOD END
      *********************************************************************
     C     PERDEND       BEGSR
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** MATURITY
      *********************************************************************
     C     MATURITY      BEGSR
 
      * DEFINED NOMINAL AT MATURITY
 
     C     E_NOML        IFNE      *ZERO
     C                   Z-ADD     E_NOML        P_NOML
     C                   ENDIF
 
      * Set output cashflow fields
 
     C                   CLEAR                   C_CASH
 
      * countervalue
     C     E_TAMT        IFNE      *ZERO
     C                   MOVEL     'C'           C_CATG
     C                   Z-ADD     E_TAMT        C_AMNT
     C                   ELSE
      * principal
     C                   MOVEL     'P'           C_CATG
     C                   Z-ADD     P_NOML        C_AMNT
     C                   ENDIF
      * in/out
     C     E_IO          IFEQ      *BLANK
     C     P_ASLI        IFEQ      'A'
     C                   MOVEL     'I'           C_IO
     C                   ELSE
     C                   MOVEL     'O'           C_IO
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     E_IO          C_IO
     C                   ENDIF
      * settlement instructions
     C                   MOVEL     E_SETD        C_SETD
      * Write a cashflow record
     C                   EXSR      WRT_CASH
 
      ** SET 'MATURITY DATE PROCESSED' INDICATOR
 
     C                   MOVEL     'Y'           MatDat_P
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * UPDATE CURRENT EFFECTIVE INTEREST RATE
      *********************************************************************
     C     UPD_IRAT      BEGSR
 
     C                   SELECT
 
     C     P_SPIN        WHENEQ    ' '
     C     P_SPIN        OREQ      'A'
     C     P_BRTE        ADD       P_RTSP        P_IRAT
 
     C     P_SPIN        WHENEQ    'S'
     C     P_BRTE        SUB       P_RTSP        P_IRAT
 
     C     P_SPIN        WHENEQ    'P'
     C     P_RTSP        DIV       100           W#W119           11 9
     C     P_BRTE        MULT(H)   W#W119        P_IRAT
 
     C                   ENDSL
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Write a position position
      *********************************************************************
     C     WRT_POSN      BEGSR
 
      * Only 1 trade date record ever written
 
     C     Trade_Value   IFEQ      'T'
     C     P_PDAT        IFEQ      Run_Date
     C     T_MATI        IFEQ      'Y'
     C     T_RLDO        OREQ      'Y'
     C                   MOVEL     'M'           P_PSTP
     C                   ELSE
     C                   MOVEL     'C'           P_PSTP
     C     P_ASLI        IFEQ      'A'
     C                   Z-ADD     Cur_V_A_AITD  P_AITD
     C                   ELSE
     C                   Z-ADD     Cur_V_L_AITD  P_AITD
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     *BLANK        P_PSTP
     C                   ENDIF
     C                   ENDIF
 
      * 1 value date record written for each change in position
      * (not before run date)
 
     C     Trade_Value   IFEQ      'V'
     C     P_PDAT        ANDGE     Run_Date
     C     T_RLDO        IFEQ      'Y'
     C                   MOVEL     *BLANK        P_PSTP
     C                   ELSE
     C     P_PDAT        IFEQ      Run_Date
     C     T_SDAT        ANDLT     Date_NWD
     C                   MOVEL     'C'           P_PSTP
     C     P_ASLI        IFEQ      'A'
     C                   Z-ADD     P_AITD        Cur_V_A_AITD
     C                   ELSE
     C                   Z-ADD     P_AITD        Cur_V_L_AITD
     C                   ENDIF
     C                   ELSE
     C     P_PDAT        IFGE      T_SDAT                                                     BG1272
     C                   MOVEL     'F'           P_PSTP
     C                   ENDIF                                                                BG1272
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Market price & value
     C     P_PSTP        IFEQ      'C'
     C     T_SMOD        IFEQ      'LOAN'
     C     T_SMOD        OREQ      'LDNI'
     C     T_SMOD        OREQ      'NASP'
     C     T_SMOD        OREQ      'CFCO'
     C                   Z-ADD     1             P_MKPR
     C                   Z-ADD     P_NOML        P_MKVL
     C                   MOVEL     P_CCY         P_VCCY
     C                   ELSE
     C                   Z-ADD     T_MKVL        P_MKVL
     C                   MOVEL     T_VCCY        P_VCCY
     C                   ENDIF
     C                   ENDIF
 
      * Write a position record
 
     C     P_PSTP        IFNE      *BLANK
     C     Location      IFEQ      'GLOB'
     C                   WRITE     GPPOSND0
     C                   ELSE
     C                   WRITE     GOPOSND0
     C                   ENDIF
     C                   ENDIF
 
      * Diagnostic output
     C     Diagnostics   IFEQ      'Y'
     C                   WRITE     GOWPOSND0
     C                   ENDIF
 
      *  Update accrued interest to control date
 
     C     P_ACIN        IFEQ      'Y'
     C     P_INPM        ANDNE     'Y'
     C     P_INPM        ANDNE     'D'
     C                   ADD       P_INAC        P_AITC
     C                   ENDIF
 
      * Update next interest amount (unamortised)
 
     C     P_AMIN        IFEQ      'Y'
     C                   SUB       P_INAC        P_NINA
     C                   ELSE
     C                   Z-ADD     *ZERO         P_NINA
     C                   ENDIF
 
      * Update accrued interest to date
 
     C     Trade_Value   IFEQ      'V'
     C     P_ACIN        IFEQ      'Y'
     C     P_INPM        ANDNE     'Y'
     C     P_INPM        ANDNE     'D'
     C     P_AITC        ADD       P_AIAD        P_AITD
     C                   SUB       P_IPRD        P_AITD
     C                   SUB       P_ICTD        P_AITD
     C                   SUB       P_IWOD        P_AITD
     C                   ELSE
     C                   ADD       P_INAC        P_AITD
     C                   ENDIF
     C                   ENDIF
 
     C                   Z-ADD     *ZERO         P_MKPR
     C                   Z-ADD     *ZERO         P_MKVL
     C                   MOVEL     *BLANK        P_VCCY
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Write a cashflow record
      *********************************************************************
     C     WRT_CASH      BEGSR
      * Identifier
     C                   MOVEL     P_ID          C_ID
      * Asset/liability indicator
     C                   MOVEL     P_ASLI        C_ASLI
 
      * Date, event type, event ref
     C                   MOVEL     E_PRDT        C_DATE
     C                   MOVEL     E_EVTP        C_EVTP
     C                   MOVEL     E_EVRF        C_EVRF
 
      * Currency
     C     C_CCY         IFEQ      *BLANK
     C                   MOVEL     P_CCY         C_CCY
     C                   ENDIF
 
      * Due indicator
     C     C_DATE        IFGE      Run_Date
     C     C_DATE        ANDLT     Date_NWD
     C                   MOVE      'Y'           C_DUEI
     C                   ENDIF
                                                                                             BUG5221
      * Populate additional new fields                                                       BUG5221
     C                   MOVE      T_MOD         C_MOD                                       BUG5221
     C                   MOVE      T_ZONE        C_ZONE                                      BUG5221
     C                   MOVE      T_TRTP        C_TRTP                                      BUG5221
     C*******************MOVE      T_RCSA        C_RCSA                             BUG5221 BUG11817
     C                   MOVE      T_RCST        C_RCSA                                     BUG11817
     C                   MOVE      T_TRST        C_TRST                                      BUG5221
      * Get Ccy decimal place                                                                BUG5221
     C                   MOVEL     C_CCY         I#LFD1                                      BUG5221
     C                   CALLB     'MXACSCURR'                                               BUG5221
     C/COPY MXCPYSRC,MXACSPRME                                                               BUG5221
                                                                                             BUG5221
     C                   EVAL      SDCURR = InData                                           BUG5221
                                                                                             BUG5221
     C     1             ADD       A6NBDP        @Dec              1 0                       BUG5221
     C     C_AMNT        MULT      POWER8(@Dec)  C_AMTDEC                                    BUG5221
     C                   MOVE      T_RCBR        C_SETB                                     BUG11830
 
      * Write a cashflow if the amount is <>0 & the date is not in the past
 
     C     Trade_Value   IFEQ      'V'
     C     C_AMNT        IFNE      *ZERO
     C     C_DATE        ANDGE     Run_Date
      *                                                                                       242258
      * Don't write a cash flow record if FRAIRS and Suppress settlement on                   242258
      *                                                                                       242258
     C                   MOVEL     'N'           WSUPPR            1                          242258
     C     E_SSET        IFEQ      'Y'                                                        242258
     C     C_MOD         ANDEQ     'DL'                                                       242258
     C     C_TRTP        IFEQ      'FR'                                                       242258
     C     C_EVTP        ANDEQ     'VD'                                                       242258
     C     C_TRTP        OREQ      'FR'                                                      242258A
     C     C_EVTP        ANDEQ     'MT'                                                      242258A
     C                   MOVEL     'Y'           WSUPPR                                       242258
     C                   ENDIF                                                                242258
     C     C_TRTP        IFEQ      'RS'                                                       242258
     C     C_EVTP        ANDEQ     'VD'                                                       242258
     C     C_TRTP        OREQ      'RS'                                                      242258A
     C     C_EVTP        ANDEQ     'MT'                                                      242258A
     C                   MOVEL     'Y'           WSUPPR                                       242258
     C                   ENDIF                                                                242258
     C     C_TRTP        IFEQ      'RX'                                                       242258
     C     C_EVTP        IFEQ      'VD'                                                       242258
     C     C_EVTP        OREQ      'PI'                                                       242258
     C     C_EVTP        OREQ      'PD'                                                       242258
     C     C_EVTP        OREQ      'MT'                                                       242258
     C                   MOVEL     'Y'           WSUPPR                                       242258
     C                   ENDIF                                                                242258
     C                   ENDIF                                                                242258
     C                   ENDIF                                                                242258
      *                                                                                       242258
     C     WSUPPR        IFEQ      'N'                                                        242258
      *                                                                                       242258
     C     Location      IFEQ      'GLOB'
     C                   WRITE     GPCASHD0
     C                   ELSE
     C                   WRITE     GOCASHD0
     C                   ENDIF
     C                   ENDIF                                                                242258
     C                   ENDIF
     C                   ENDIF
 
     C     E_WRT_CASH    ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * SET POSITION DETAILS
      *********************************************************************
     C     SET_POSD      BEGSR
 
      ** Set position date
 
     C                   Z-ADD     P@PRDT        P_PDAT                         * POSITION DATE
 
      ** Set start date and end date
 
     C                   Z-ADD     P@PRDT        P_SDAT                         * START DATE
     C                   Z-ADD     E_PRDT        P_EDAT                         * END DATE
 
      * Bypass if non interest bearing
 
     C     P_ICMT        IFEQ      *BLANK
     C     P_EDAT        SUB       P_SDAT        P_NDYS                         * NO. OF DAYS
     C                   Z-ADD     *ZERO         P_YBAS                         * YEAR BASIS
     C                   GOTO      ESETPOSD
     C                   ENDIF
 
      ** Calculate number of days between start date and end date
 
     C                   Z-ADD     P_SDAT        W#SDAT                         * START DATE
     C                   Z-ADD     P_EDAT        W#EDAT                         * END DATE
     C                   EXSR      CAL_NDYS
     C                   Z-ADD     W#NDYS        P_NDYS                         * NO. OF DAYS
 
      * GET LAST & NEXT INT DATES STRADDLING THE EVENT DATE(W#LIDT & W#NIDT)
 
     C                   EXSR      GET_LNIPDT
 
      ** CALCULATE YEAR BASIS (GIVEN W#LIDT AND W#NIDT)
 
     C                   EXSR      CAL_YBAS
     C                   Z-ADD     W#YBAS        P_YBAS                         * YEAR BASIS
 
     C     ESETPOSD      ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * DO ACCRUALS
      *********************************************************************
     C     DO_ACC        BEGSR
 
      ** RESET INTEREST ACCRUED
 
     C                   Z-ADD     *ZERO         P_INAC
 
      * ACCRUE INTEREST
 
     C     P_ACIN        IFEQ      'Y'
     C     P_STAC        ANDNE     'Y'
     C     P_NOML        IFGT      0
     C     P_NOML        ORLT      0
     C     P_ACNG        ANDEQ     'Y'
     C                   EXSR      ACCRUE_INT
     C                   ENDIF
     C                   ENDIF
 
      * AMORTISE INTEREST
 
     C     P_AMIN        IFEQ      'Y'
     C     P_NINA        ANDNE     *ZERO
     C                   EXSR      AMORTISE_INT
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** ACCRUE INTEREST
      *********************************************************************
     C     ACCRUE_INT    BEGSR
 
      * CALCULATE INTEREST
 
     C                   Z-ADD     P_NDYS        W#NDYS                         * NO. OF DAYS
     C                   Z-ADD     P_YBAS        W#YBAS                         * YEAR BASIS
     C                   Z-ADD     P_NOML        W#NOML                         * NOMINAL
     C     P_INPM        IFEQ      'Y'
     C                   SUB       P_TOTI        W#NOML                         * NOMINAL
     C                   ENDIF
     C                   Z-ADD     P_IRAT        W#IRAT                         * INT.RATE
     C                   EXSR      CAL_INTA
 
      ** SET INTEREST ACCRUED
      ** (ACCORDING TO ROUND DOWN FACILITY)
 
     C     P_RDFC        IFEQ      'Y'
     C                   Z-ADD     W#INT         P_INAC
     C                   ELSE
     C                   Z-ADD(H)  W#INT         P_INAC
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** AMORTISE INTEREST
      *********************************************************************
     C     AMORTISE_INT  BEGSR
 
      ** CALCULATE NUMBER OF DAYS REMAINING
      ** (BETWEEN POSITION START DATE AND NEXT INTEREST PAYMENT DATE)
 
     C     P_NIND        SUB       P_SDAT        w#ndys_rem        5 0
 
      ** Amortise interest
 
     C     P_NDYS        IFLT      w#ndys_rem
     C     w#ndys_rem    ANDGT     *ZERO
     C     P_NINA        MULT      P_NDYS        w#accrual        15 2
     C                   DIV(H)    w#ndys_rem    w#accrual
     C                   ELSE
     C                   Z-ADD     P_NINA        w#accrual
     C                   ENDIF
     C                   Z-ADD(H)  w#accrual     P_INAC
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** CALCULATE INTEREST PAID UP FRONT
      *********************************************************************
     C     CAL_INT_UF    BEGSR
 
      ** RESET INTEREST UP FRONT AMOUNT
 
     C                   Z-ADD     *ZERO         E_INTA
 
      * GET NEXT INT PAYMENT DATE AFTER THIS INT PAYMENT DATE
 
     C                   Z-ADD     1             #I                3 0
     C     E_PRDT        LOOKUP    #_ipdat(#I)                            99     *
     C                   ADD       1             #I
 
      ** SET START DATE AND END DATE
 
     C                   Z-ADD     E_PRDT        W#SDAT                         * START DATE
     C                   Z-ADD     #_ipdat(#I)   W#EDAT                          * END DATE
 
      * BYPASS IF NOMINAL -VE OR ZERO
      * OR IF START DATE >= END DATE
 
     C     P_NOML        IFLE      0
     C     W#SDAT        ORGE      W#EDAT
     C                   GOTO      ECALINTUF
     C                   ENDIF
 
      ** CALCULATE NUMBER OF DAYS BETWEEN START DATE AND END DATE
 
     C                   EXSR      CAL_NDYS
 
      ** CALCULATE YEAR BASIS (GIVEN W#LIDT AND W#NIDT)
 
     C                   Z-ADD     W#SDAT        W#LIDT                         * LAST INT DATE
     C                   Z-ADD     W#EDAT        W#NIDT                         * NEXT INT DATE
     C                   EXSR      CAL_YBAS
 
      * CALCULATE INTEREST (FOR NUMBER OF DAYS W#NDYS & YEAR BASIS W#YBAS)
 
     C                   Z-ADD     P_NOML        W#NOML                         * NOMINAL
     C     P_INPM        IFEQ      'Y'
     C                   Z-ADD     P_IRAT        W#YRAT                         * INT.RATE
     C                   EXSR      CAL_YLDA
     C                   ELSE
     C                   Z-ADD     P_IRAT        W#IRAT                         * INT.RATE
     C                   EXSR      CAL_INTA
     C                   ENDIF
 
      **  SET INTEREST UP FRONT AMOUNT
      **  CHECK FOR ROUND DOWN FACILITY.
 
     C     P_RDFC        IFEQ      'Y'
     C                   Z-ADD     W#INT         E_INTA
     C                   ELSE
     C                   Z-ADD(H)  W#INT         E_INTA
     C                   END
 
     C     ECALINTUF     ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** DETERMINE NEXT INTEREST PAYMENT DATE AND AMOUNT
      *********************************************************************
     C     DETNxtIntPay  BEGSR
 
      ** RESET NEXT INTEREST PAYMENT DATE AND AMOUNT
 
     C                   Z-ADD     *ZERO         E_NIND
     C                   Z-ADD     *ZERO         E_NINA
 
      * GET NEXT INT PAYMENT DATE AFTER THE CURRENT EVENT DATE
 
     C                   Z-ADD     1             #I
     C     E_PRDT        LOOKUP    #_ipdat(#I)                            99     *
     C                   ADD       1             #I
 
      ** NEXT INTEREST PAYMENT DATE AND AMOUNT
 
     C     #_ipdta(#I)   IFNE      *BLANK
     C                   Z-ADD     #_ipdat(#I)   E_NIND
     C                   MOVE      #_ipdta(#I)   E_NINA
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** CALCULATE NUMBER OF DAYS (BETWEEN P_SDAT AND P_EDAT)
      *********************************************************************
     C     CAL_NDYS      BEGSR
 
     C                   CALLB     'GOCALNDYS'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
     C                   PARM      P_ICMT        W#ICMT            7            * INT CAL MTHD
     C                   PARM                    W#SDAT            5 0          * START DATE
     C                   PARM                    W#EDAT            5 0          * END DATE
     C                   PARM      *ZERO         W#NDYS            5 0          * NO. OF DAYS
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO GOCALNDYS'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** CALCULATE YEAR BASIS (GIVEN W#LIDT AND W#NIDT)
      *********************************************************************
     C     CAL_YBAS      BEGSR
 
     C                   CALLB     'GOCALYBAS'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
     C                   PARM      P_ICMT        W#ICMT            7            * INT CAL MTHD
     C                   PARM      P_IPY         W#IPY             2 0          * INT PAY PER YR
     C                   PARM                    W#LIDT            5 0          * LAST INT DATE
     C                   PARM                    W#NIDT            5 0          * NEXT INT DATE
     C                   PARM      *ZERO         W#YBAS            5 0          * YEAR BASIS
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO GOCALYBAS'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * CALCULATE INTEREST (FOR NUMBER OF DAYS W#NDYS & YEAR BASIS W#YBAS)
      *********************************************************************
     C     CAL_INTA      BEGSR
 
     C                   CALLB     'GOCALINTA'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
     C                   PARM                    W#NDYS            5 0          * NO. OF DAYS
     C                   PARM                    W#YBAS            5 0          * YEAR BASIS
     C                   PARM                    W#NOML           15 0          * NOMINAL
     C                   PARM      P_NCDP        W#NCDP            1 0          * NOM. CCY DEC.P.
     C                   PARM      P_NCDP        W#NMDP            1 0          * NOM.DEC.PLCS
     C                   PARM      E_ICMT        W#ICMT                                       CER016
     C                   PARM                    W#IRAT           11 7          * INT.RATE
     C                   PARM      P_CLRT        W#CLRT           11 7          * INT.RATE
     C                   PARM      P_FLRT        W#FLRT           11 7          * INT.RATE
     C                   PARM      'N'           W#YBON            1            * YEN BOND ?
     C                   PARM      9             W#ACUR            1 0          * ACCURACY
     C                   PARM      *ZERO         W#INT            15 2          * INTEREST
     C                   PARM      *ZERO         W#INTP           15 9          * INTEREST %
     C                   PARM      *ZERO         W#INTF           15 9          * INTEREST FACTOR
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO GOCALINTA'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * CALCULATE YIELD AMT (FOR NUMBER OF DAYS W#NDYS & YEAR BASIS W#YBAS)
      *********************************************************************
     C     CAL_YLDA      BEGSR
 
     C                   CALLB     'GOCALYLDA'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
     C                   PARM                    W#NDYS            5 0          * NO. OF DAYS
     C                   PARM                    W#YBAS            5 0          * YEAR BASIS
     C                   PARM                    W#NOML           15 0          * NOMINAL
     C                   PARM      P_NCDP        W#NCDP            1 0          * NOM. CCY DEC.P.
     C                   PARM      P_NCDP        W#NMDP            1 0          * NOM.DEC.PLCS
     C                   PARM                    W#YRAT           11 7          * YIELD RATE
     C                   PARM      9             W#ACUR            1 0          * ACCURACY
     C                   PARM      *ZERO         W#INT            15 2          * INTEREST
     C                   PARM      *ZERO         W#INTP           15 9          * INTEREST %
     C                   PARM      *ZERO         W#INTF           15 9          * INTEREST FACTOR
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO GOCALYLDA'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** GET LAST AND NEXT INT PAYMENT DATES STRADDLING THIS DATE
      *********************************************************************
     C     GET_LNIPDT    BEGSR
 
      ** GET LAST AND NEXT EVENT DATE
 
     C                   CALLB     'GOMNTEVDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           50
     C                   PARM      '*GETLNEVDT'  W#MODE           10
     C                   PARM      *BLANK        W#TYPE            2
 
      * EVENT
     C                   PARM                    E_EVNT
 
      * EVENT DATA ARRAY
     C                   PARM                    #arevdt_ip
 
      * LAST/NEXT PERIOD?
     C                   PARM                    #LN_PERIOD        1
 
      * LAST DATE
      * NEXT DATE
     C                   PARM      *ZERO         W#LIDT            5 0
     C                   PARM      *ZERO         W#NIDT            5 0
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO GOMNTEVDT'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** LOG EVENT DATES
      *********************************************************************
     C     LOG_EVDT      BEGSR
 
      ** LOG EVENT DATE
 
     C                   CALLB     'GOMNTEVDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           50
     C                   PARM      '*LOGEVDT  '  W#MODE           10
     C                   PARM                    W#TYPE            2
 
      * EVENT
     C                   PARM                    E_EVNT
 
      * EVENT DATA ARRAY
     C                   PARM                    #arevdt_WK
 
      * LAST/NEXT PERIOD?
     C                   PARM                    #LN_PERIOD        1
 
      * LAST DATE
      * NEXT DATE
     C                   PARM      *ZERO         #LASTDT           5 0
     C                   PARM      *ZERO         #NEXTDT           5 0
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO GOMNTEVDT'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *********************************************************************
     C/SPACE 5
      ********************************************************************
      * Initialize position fields
      ********************************************************************
     C     INIT_POSN     BEGSR
      * Zone, module, sub module
     C                   MOVEL     T_ZONE        P_ZONE
     C                   MOVEL     T_MOD         P_MOD
     C                   MOVEL     T_SMOD        P_SMOD
      * Transaction reference
     C                   MOVEL     T_TREF        P_TREF
      * Identifier
     C                   MOVEL     T_ID          P_ID
      * Trade/Value Date
     C                   MOVEL     Trade_Value   P_TVDI
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Initialize work event fields
      ********************************************************************
     C     INIT_WEVNT    BEGSR
      * Zone, module, sub module
     C                   MOVEL     T_ZONE        E_ZONE
     C                   MOVEL     T_MOD         E_MOD
     C                   MOVEL     T_SMOD        E_SMOD
      * Transaction reference
     C                   MOVEL     T_TREF        E_TREF
      * Trade/Value Date
     C                   MOVEL     Trade_Value   E_TVDI
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Open files
     C     Location      IFEQ      'GLOB'
     C                   OPEN      GPPOSNPD
     C                   OPEN      GPCASHPD
     C                   ELSE
     C                   OPEN      GOPOSNPD
     C                   OPEN      GOCASHPD
     C                   ENDIF
 
      * Diagnostic output
     C     Diagnostics   IFEQ      'Y'
     C                   OPEN      GOWPOSNPD
     C                   ENDIF
                                                                                              245230
      * Open GOWEVNTL0                                                                        245230
     C                   OPEN      GOWEVNTL0                                                  245230
 
      * Projection Cut-off Date + 1 year
     C     ProjCO_Dat    ADD       370           ProjCO_Dat_1Yr    5 0
 
      * Key lists
     C     GOWEVNTK      KLIST
     C                   KFLD                    E_ZONE
     C                   KFLD                    E_MOD
     C                   KFLD                    E_SMOD
     C                   KFLD                    E_CNUM
     C                   KFLD                    E_PTFR
     C                   KFLD                    E_BRCA
     C                   KFLD                    E_BOOK
     C                   KFLD                    E_SESN
     C                   KFLD                    E_MKTI
     C                   KFLD                    E_TREF
     C                   KFLD                    E_TVDI
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR_WK
      *****************************************************************
      /SPACE 5
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
** TABTYP / TABSEQ
DD01
VD02
FE03
MI12
SA12
PI15
PD15
IP21
OD21
RE24
MR25
SC37
BC38
RO39
PE98
MT99
**  POWER8 - ARRAY OF POWERS FOR CURRENCY CONVERSION                                         BUG5221
10000000                                                                                     BUG5221
01000000                                                                                     BUG5221
00100000                                                                                     BUG5221
00010000                                                                                     BUG5221
00001000                                                                                     BUG5221
00000100                                                                                     BUG5221
00000010                                                                                     BUG5221
00000001                                                                                     BUG5221
