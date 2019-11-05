     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Work with extract data - securities')         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOWRKEDTS - Work with Extract Data (Securities)              *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. 258638             Date 30Aug19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD032884           Date 09Jun15               *
      *                 261324             Date 24Apr13               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG14267           Date 16Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11817           Date 03Aug06               *
      *                 BUG11830           Date 01Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CGL035             Date 01Mar05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG5221            Date 14Dec04               *
      *                 BUG3860            Date 11Aug04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *   258638 - GOC0020 00011 failed with various dumps due to     *
      *            blank Interest Calculation Method.                 *
      *          - Applied for MD-53803.                              *
      *  MD046248 - Finastra Rebranding                               *
      *  MD032884 - Performance enhancement for GOCXCLTS. Recompiled  *
      *             due to change in GOCASHPD, GOPOSNPD & GOWEVNTPD.  *
      *  261324 - GOC0020 ended in error during COB. Corrected core   *
      *           fix incorporation.                                  *
      *         - Applied for AR1063996 (Child: AR1063998).           *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG14267 - Apply Fix in GEMS 248214 and 246728.              *
      *  248284 - Don't do ACCRUALS if all dates are 0.               *
      *  246728 - Skip processing imported events rather than         *
      *           invoking *PSSR when record is not found in          *
      *           GOWEVNTPD - Midas GO Work Events file.              *
      *  BUG11817 - Risk Customer Alpha (C_RCSA) field in GPCASHPD    *
      *             is empty.                                         *
      *  BUG11830 - Move T_RCBR to C_SETB field before writing to     *
      *             GPCASHPD.                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CGL035 - EUSD Upgrade to Midasplus (Recompile)               *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG5221 - Additional fields added to GPCASHPD/GOCASHPD       *
      *  BUG3860 - (recompile)                                        *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

     FGOWEVNTL0 UF   E           K DISK    INFSR(*PSSR)
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
     D***C_SETD*               42     61                                                      CGL029
     D  C_SETD                42     67                                                       CGL029


      ** P O S I T I O N    D E T A I L S
     D P_POSN        E DS                  EXTNAME(GOWPOSNPD)
      ** E V E N T    D E T A I L S
     D E_EVNT        E DS                  EXTNAME(GOWEVNTPD)
     D***E_SETD*              179    198                                                      CGL029
     D  E_SETD               185    210                                                       CGL029


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


      * ARRAYS OF MORGAGE PAYMENT DATES AND DATA
     D #arevdt_mp    E DS                  EXTNAME(DEEVDTPD)
     D                                     PREFIX(MP)
     D #_mpdat                 1   1800  0
     D                                     DIM(ArrSizDet) ASCEND
     D #_mpdta              1801   7200
     D                                     DIM(ArrSizDet) ASCEND


      * ARRAYS OF PART PAYMENT DATES AND DATA
     D #arevdt_pp    E DS                  EXTNAME(DEEVDTPD)
     D                                     PREFIX(PP)
     D #_ppdat                 1   1800  0
     D                                     DIM(ArrSizDet) ASCEND
     D #_ppdta              1801   7200
     D                                     DIM(ArrSizDet) ASCEND


      ** EVENT TYPES/SEQUENCES
     D TABTYP          S              2    DIM(8) CTDATA PERRCD(1)
     D TABSEQ          S              2  0 DIM(8) ALT(TABTYP)


     D SECTY         E DS                  EXTNAME(SECTYD) PREFIX(SE_)
     D PRICE         E DS                  EXTNAME(PRICED) PREFIX(PR_)


     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                 BUG5221
                                                                                             BUG5221
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
      * SECURITY
     C                   PARM                    SECTY
      * PRICE
     C                   PARM                    PRICE
      * PROCESSING TYPE
     C                   PARM                    IN_PROT           1

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
     C                   Z-ADD     *ZERO         Cur_V_AITD       15 0
     C                   ENDIF

      * Clear date and data arrays
     C                   CLEAR                   #_ipdat
     C                   CLEAR                   #_ipdta
     C                   CLEAR                   #_irdat
     C                   CLEAR                   #_irdta
     C                   CLEAR                   #_mpdat
     C                   CLEAR                   #_mpdta
     C                   CLEAR                   #_ppdat
     C                   CLEAR                   #_ppdta

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
      ** IMPORT EVENT
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
     C                   Z-ADD     P_NMDP        E_NMDP
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
      *                                                                                     BUG14267
      ** Initialize flags for With Records found and Deleted records in                     BUG14267
      ** Midas GO Work Events File.                                                         BUG14267
      *                                                                                     BUG14267
     C                   MOVE      'N'           Flag_Wrec         1                        BUG14267
     C                   MOVE      'N'           Flag_Drec         1                        BUG14267
     C                   MOVEL     'N'           dateflg           1                        BUG14267

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
     C                   MOVE      'Y'           Flag_Wrec                                  BUG14267

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
     C                   MOVEL     'IP'          W#TYPE
     C                   MOVEL     #arevdt_ip    #arevdt_WK
     C                   EXSR      LOG_EVDT
     C                   MOVEL     #arevdt_WK    #arevdt_ip
     C                   MOVEL     'Y'           dateflg           1                        BUG14267
     C                   ENDIF

      * If event is a rate change date
      * or if event is a maturity date
      * log date in interest rate change dates array
     C     E_EVTP        IFEQ      'IR'
     C     E_EVTP        OREQ      'MT'
     C     E_PRDT        IFLT      T_TDAT
     C                   EXSR      RATECHG
     C                   ENDIF
     C                   MOVEL     'IR'          W#TYPE
     C                   MOVEL     #arevdt_ir    #arevdt_WK
     C                   EXSR      LOG_EVDT
     C                   MOVEL     #arevdt_WK    #arevdt_ir
     C                   ENDIF

      * If event is a part payment date
      * log date in part payment dates array
     C     E_EVTP        IFEQ      'PP'
     C     E_PRDT        IFLT      T_TDAT
     C                   EXSR      PARTPAY
     C                   ENDIF
     C                   MOVEL     'PP'          W#TYPE
     C                   MOVEL     #arevdt_pp    #arevdt_WK
     C                   EXSR      LOG_EVDT
     C                   MOVEL     #arevdt_WK    #arevdt_pp
     C                   ENDIF

      * If event is a mortgage payment date
      * log date in mortgage payment dates array
     C     E_EVTP        IFEQ      'MP'
     C     E_PRDT        IFLT      T_TDAT
     C                   EXSR      MORTPAY
     C                   ENDIF
     C                   MOVEL     'MP'          W#TYPE
     C                   MOVEL     #arevdt_mp    #arevdt_WK
     C                   EXSR      LOG_EVDT
     C                   MOVEL     #arevdt_WK    #arevdt_mp
     C                   ENDIF

      * If the event date is after the projections cut-off date
      * or prior to the transaction date
      *  Remove it
     C     E_PRDT        IFGT      ProjCO_Dat
     C     E_PRDT        ORLT      T_TDAT
     C**********         MOVE      'Y'           Flag_Wrec                           BUG14267 261324
     C                   MOVE      'Y'           Flag_Drec                                    261324
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

      * Initialise for interest calculation

     C                   MOVEL     '*INIT     '  W#MODE
     C     P_ICMT        IFNE      *BLANKS                                                    258638
     C                   EXSR      CAL_INTM
     C                   ELSE                                                                 258638
     C                   Z-ADD     0             P_AITD                                       258638
     C                   ENDIF                                                                258638
      *
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
      *                                                                                     BUG14267
      ** Skip processing when no valid records read due to record                           BUG14267
      ** deletion that takes place during validation of events.                             BUG14267
      *                                                                                     BUG14267
     C     *IN99         IFEQ      *ON                                                      BUG14267
     C     Flag_Wrec     ANDEQ     'Y'                                                      BUG14267
     C     Flag_Drec     ANDEQ     'Y'                                                      BUG14267
      *                                                                                     BUG14267
      ** Introduce *NOREC return code for no valid events record read.                      BUG14267
      *                                                                                     BUG14267
     C                   MOVEL     '*NOREC'      Ret_Code                                   BUG14267
      *                                                                                     BUG14267
      ** Prepare error message 'NO VALID EVENTS READ FOR:' with the                         BUG14267
      ** transaction key fields information.                                                BUG14267
      *                                                                                     BUG14267
     C                   MOVE      *BLANKS       Err_Msg         256                        BUG14267
     C                   MOVE      *BLANKS       C_CNUM            6                        BUG14267
     C                   MOVEL     E_CNUM        C_CNUM                                     BUG14267
     C                   EVAL      Err_Msg  = 'NO VALID EVENTS READ FOR: '                  BUG14267
     C                                        + E_ZONE + E_MOD + E_SMOD                     BUG14267
     C                                        + C_CNUM + E_PTFR + E_BRCA                    BUG14267
     C                                        + E_BOOK + E_SESN + E_MKTI                    BUG14267
     C                                        + E_TREF + E_TVDI                             BUG14267
      *                                                                                     BUG14267
      ** Issue error message to message queue MOPERQ.                                       BUG14267
      *                                                                                     BUG14267
     C                   CALL      'AOCREPT'                            9999                BUG14267
     C                   PARM      'MEM5050'     #MSGID            7                        BUG14267
     C                   PARM      'GBMIDAS '    #MSGF            10                        BUG14267
     C                   PARM      *BLANKS       #MSGFL           10                        BUG14267
     C                   PARM      Err_Msg       #MSGDT          256                        BUG14267
     C                   PARM      '*PRV '       #MSGR             5                        BUG14267
     C                   PARM      '*'           #PRGM            10                        BUG14267
     C                   PARM      'MOPERQ '     #MSGQ            10                        BUG14267
     C                   PARM      '*INFO  '     #MSGT             7                        BUG14267
     C                   ELSE                                                               BUG14267

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

      * If position date <> an interest payment date
      *  Do accruals
     C     Trade_Value   IFEQ      'V'
     C     P_PDAT        LOOKUP    #_ipdat                                99
     C     dateflg       IFEQ      'Y'                                                        261324
     C  N99              EXSR      DO_ACCRUALS
     C                   ENDIF                                                                261324
     C                   ENDIF

      * Write a position
     C                   EXSR      WRT_POSN

      * Update previous date
     C                   Z-ADD     E_PRDT        P@PRDT

     C                   ENDIF

      * Process the event
     C     E_EVTP        CASEQ     'TP'          TRADE
     C     E_EVTP        CASEQ     'TS'          TRADE
     C     E_EVTP        CASEQ     'IP'          INTPAY
     C     E_EVTP        CASEQ     'IR'          RATECHG
     C     E_EVTP        CASEQ     'PP'          PARTPAY
     C     E_EVTP        CASEQ     'MP'          MORTPAY
     C     E_EVTP        CASEQ     'PE'          PERDEND
     C     E_EVTP        CASEQ     'MT'          MATURITY
     C                   ENDCS

      * Read next event
     C     GOWEVNTK      READE     GOWEVNTD0                              99
     C                   ENDDO

      * Set position details
     C                   EXSR      SET_POSD

      * If position date <> an interest payment date
      *  Do accruals
     C     Trade_Value   IFEQ      'V'
     C     P_PDAT        LOOKUP    #_ipdat                                99
     C     dateflg       IFEQ      'Y'                                                      BUG14267
     C  N99              EXSR      DO_ACCRUALS
     C                   ENDIF                                                              BUG14267
     C                   ENDIF

      * Write a position
     C                   EXSR      WRT_POSN
     C                   ENDIF                                                              BUG14267

     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** TRADE (PURCHASE OR SALE)
      *********************************************************************
     C     TRADE         BEGSR

      *  Update the nominal and ex-coupon nominal

     C     E_EVTP        IFEQ      'TP'
     C                   ADD       E_NOML        P_NOML
     C     E_ACIN        IFEQ      'X'
     C                   ADD       E_NOML        P_ONOM
     C                   ENDIF
     C                   ELSE
     C                   SUB       E_NOML        P_NOML
     C     E_ACIN        IFEQ      'X'
     C                   SUB       E_NOML        P_ONOM
     C                   ENDIF
     C                   ENDIF

      * Set output cashflow fields

     C     E_SSET        IFNE      'Y'
     C                   CLEAR                   C_CASH

      * countervalue
     C                   MOVEL     'C'           C_CATG
     C                   MOVEL     E_SETC        C_CCY
     C                   Z-ADD     E_TAMT        C_AMNT
      * in/out
     C     E_EVTP        IFEQ      'TP'
     C                   MOVEL     'O'           C_IO
     C                   ELSE
     C                   MOVEL     'I'           C_IO
     C                   ENDIF

      * settlement instructions
     C                   MOVEL     E_SETD        C_SETD

      * Write a cashflow record

     C                   EXSR      WRT_CASH
     C                   ENDIF
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** INTEREST PAYMENT
      *********************************************************************
     C     INTPAY        BEGSR

      * CALCULATE INTEREST TO PAYMENT DATE

     C                   MOVEL     *BLANK        W#MODE
     C                   Z-ADD     E_PRDT        W#EDAT                         * START DATE
     C                   MOVEL     'L'           #LNIPERIOD
     C     P_ICMT        IFNE      *BLANKS                                                    258638
     C                   EXSR      CAL_INTM
     C                   Z-ADD(H)  W#TINT        P_AITD
     C                   ELSE                                                                 258638
     C                   Z-ADD     0             P_AITD                                       258638
     C                   ENDIF                                                                258638

      * Set output cashflow fields

     C     P_AITD        IFNE      *ZERO
     C                   CLEAR                   C_CASH

      * countervalue
     C                   MOVEL     'I'           C_CATG
     C                   Z-ADD     P_AITD        C_AMNT
      * in/out
     C     P_NOML        IFLT      *ZERO
     C                   MOVEL     'O'           C_IO
     C                   ELSE
     C                   MOVEL     'I'           C_IO
     C                   ENDIF

      * settlement instructions
     C                   MOVEL     E_SETD        C_SETD

      * Write a cashflow record

     C                   EXSR      WRT_CASH
     C                   ENDIF
      *
     C     INTEND        ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** RATE CHANGE
      *********************************************************************
     C     RATECHG       BEGSR

      ** UPDATE RATE

     C                   Z-ADD     E_IRAT        P_IRAT
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      **  PART PAYMENT EVENT(S)
      *********************************************************************
     C     PARTPAY       BEGSR

     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      **  MORTGAGE PAYMENT EVENT(S)
      ********************************************************************
     C     MORTPAY       BEGSR

      * Update current factor

     C                   Z-ADD     E_CFCT        P_CFCT

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
      *
      * DEFINED NOMINAL AT MATURITY
      *
     C     E_NOML        IFNE      *ZERO
     C                   Z-ADD     E_NOML        P_NOML
     C                   ENDIF

      * Set output cashflow fields

     C     P_NOML        IFNE      *ZERO
     C     E_SSET        ANDNE     'Y'
     C                   CLEAR                   C_CASH

      * principal
     C                   MOVEL     'P'           C_CATG
     C                   Z-ADD     P_NOML        C_AMNT
      * in/out
     C     P_NOML        IFLT      *ZERO
     C                   MOVEL     'O'           C_IO
     C                   ELSE
     C                   MOVEL     'I'           C_IO
     C                   ENDIF

      * settlement instructions
     C                   MOVEL     E_SETD        C_SETD

      * Write a cashflow record

     C                   EXSR      WRT_CASH
     C                   ENDIF

      * SET 'MATURITY DATE PROCESSED' INDICATOR

     C                   MOVEL     'Y'           MatDat_P
      *
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
     C                   MOVEL     'M'           P_PSTP
     C                   ELSE
     C                   MOVEL     'C'           P_PSTP
     C                   Z-ADD     Cur_V_AITD    P_AITD
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     *BLANK        P_PSTP
     C                   ENDIF
     C                   ENDIF

      * 1 value date record written for each change in position

     C     Trade_Value   IFEQ      'V'
     C     P_PDAT        IFLT      Run_Date
     C                   MOVEL     'H'           P_PSTP
     C                   ELSE
     C     P_PDAT        IFEQ      Run_Date
     C                   MOVEL     'C'           P_PSTP
     C                   Z-ADD     P_AITD        Cur_V_AITD
     C                   ELSE
     C                   MOVEL     'F'           P_PSTP
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C     P_PSTP        IFEQ      'C'
      * Market price & value
     C     SE_MKPR       IFNE      *ZERO
     C                   Z-ADD     SE_MKPR       Security_Price   15 8
     C                   EXSR      CAL_MKVL
     C                   Z-ADD     Security_PriceP_MKPR
     C                   Z-ADD     ZCONS         P_MKVL
     C                   Z-ADD     ZCONS         T_MKVL
     C                   ENDIF
      * Bid price & value
     C     PR_PRBDPR     IFNE      *ZERO
     C                   Z-ADD     PR_PRBDPR     Security_Price
     C                   EXSR      CAL_MKVL
     C                   Z-ADD     Security_PriceP_MKPB
     C                   Z-ADD     ZCONS         P_MKVB
     C                   ENDIF
      * Offer price & value
     C     PR_PROFPR     IFNE      *ZERO
     C                   Z-ADD     PR_PROFPR     Security_Price
     C                   EXSR      CAL_MKVL
     C                   Z-ADD     Security_PriceP_MKPO
     C                   Z-ADD     ZCONS         P_MKVO
     C                   ENDIF
     C                   MOVEL     P_CCY         P_VCCY
     C                   ENDIF

      * Set asset/liabiity indicator(s)

     C     P_NOML        IFLT      0
     C                   MOVEL     'L'           P_ASLI
     C                   Z-SUB     P_NOML        P_NOML
     C                   Z-SUB     P_AITD        P_AITD
     C                   Z-SUB     P_MKVL        P_MKVL
     C                   Z-SUB     P_MKVB        P_MKVB
     C                   Z-SUB     P_MKVO        P_MKVO
     C                   ELSE
     C                   MOVEL     'A'           P_ASLI
     C                   ENDIF
     C     P_ONOM        IFLT      0
     C                   MOVEL     'L'           P_OASL
     C                   Z-SUB     P_ONOM        P_ONOM
     C                   ELSE
     C                   MOVEL     'A'           P_OASL
     C                   ENDIF
     C     P_ONOM        IFNE      0
     C                   MOVE      P_CCY         P_OCCY
     C                   ELSE
     C                   MOVE      *BLANK        P_OCCY
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

      * Reset position fields

     C     P_ASLI        IFEQ      'L'
     C                   Z-SUB     P_NOML        P_NOML
     C                   ENDIF
     C     P_OASL        IFEQ      'L'
     C                   Z-SUB     P_ONOM        P_ONOM
     C                   ENDIF

     C                   Z-ADD     *ZERO         P_AITD
     C                   Z-ADD     *ZERO         P_MKPR
     C                   Z-ADD     *ZERO         P_MKVL
     C                   Z-ADD     *ZERO         P_MKPB
     C                   Z-ADD     *ZERO         P_MKVB
     C                   Z-ADD     *ZERO         P_MKPO
     C                   Z-ADD     *ZERO         P_MKVO
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
     C     E_NIND        IFNE      *ZERO
     C                   MOVEL     E_NIND        C_DATE
     C                   ELSE
     C                   MOVEL     E_PRDT        C_DATE
     C                   ENDIF
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
     C     Location      IFEQ      'GLOB'
     C                   WRITE     GPCASHD0
     C                   ELSE
     C                   WRITE     GOCASHD0
     C                   ENDIF
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
      *
     C     ESETPOSD      ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * DO ACCRUALS
      *********************************************************************
     C     DO_ACCRUALS   BEGSR

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

     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** ACCRUE INTEREST
      *********************************************************************
     C     ACCRUE_INT    BEGSR

      * CALCULATE INTEREST TO POSITION DATE

     C                   MOVEL     *BLANK        W#MODE
     C                   Z-ADD     P_PDAT        W#EDAT                         * START DATE
     C                   MOVEL     'N'           #LNIPERIOD
     C     P_ICMT        IFNE      *BLANKS                                                    258638
     C                   EXSR      CAL_INTM
     C                   Z-ADD(H)  W#TINT        P_AITD
     C                   ELSE                                                                 258638
     C                   Z-ADD     0             P_AITD                                       258638
     C                   ENDIF                                                                258638

     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * CALCULATE INTEREST FOR MANY PERIODS
      *********************************************************************
     C     CAL_INTM      BEGSR

     C                   CALLB     'GOCALINTM'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           50
     C                   PARM                    W#MODE           10

     C                   PARM      P_NCDP        W#NCDP            1 0          * NOM. CCY DEC.P.
     C                   PARM      P_NMDP        W#NMDP            1 0          * NOM.DEC.PLCS

     C                   PARM      P_ICMT        W#ICMT            7            * INT CAL MTHD
     C                   PARM      P_IPY         W#IPY             2 0          * INT PAY PER YR

     C                   PARM      P_YBON        W#YBON            1            * YEN BOND ?
     C                   PARM      P_MORT        W#MORT            1            * YEN BOND ?
     C                   PARM      P_PART        W#PART            1            * YEN BOND ?
     C                   PARM      P_FUPP        W#FUPP           15 0          * NOMINAL
     C                   PARM      P_ACUR        W#ACUR            1 0          * ACCURACY

     C                   PARM      P_NOML        W#NOML           15 0          * NOMINAL
     C                   PARM      *ZERO         W#SDAT            5 0
     C                   PARM                    W#EDAT            5 0
      * Event dates & data
     C                   PARM                    #arevdt_ip
     C                   PARM                    #arevdt_ir
     C                   PARM                    #arevdt_mp
     C                   PARM                    #arevdt_pp

      * LAST/NEXT INTEREST PERIOD?
     C                   PARM                    #LNIPERIOD        1
      * Outputs
     C                   PARM      *ZERO         W#TINT           15 2          * INTEREST
     C                   PARM      *ZERO         W#TINTP          15 9          * INTEREST %
     C                   PARM      *ZERO         W#TINTF          15 9          * INTEREST FACTOR

     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO GOCALINTM'
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
      /SPACE 5
      *********************************************************************
      * CALCULATE MARKET VALUE
      *********************************************************************
     C     CAL_MKVL      BEGSR
      *
      * If this is a price traded security, the market price is as defined
      *
     C     SE_STBS       IFEQ      'P'
     C                   Z-ADD     Security_PriceZPRC
      *
      * Otherwise, if this is a yield or discount traded security
      *
     C                   ELSE
      *
      ** Calculate PI as a fraction of Nominal
     C                   Z-ADD     0             WrkPI
      *
      ** Calculate % price from yield/discount
      *
     C                   CALLB     'ZPRCI'                              9999
     C                   PARM      Security_PriceZPRCIN           15 8
     C                   PARM      Run_Date      ZFDATE            5 0
     C                   PARM                    SECTY
     C                   PARM      P_NCDP        NomCcyDec         1 0
     C                   PARM      IN_PROT       ZPROT             1
     C                   PARM      P_NOML        ZNOML            15 0
     C                   PARM                    WrkPI            15 9
     C                   PARM      'C'           SCUMEX            1
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        ZYLDOk            1
     C                   PARM      *ZERO         ZPRCOT           15 8

     C                   Z-ADD     ZPRCOT        ZPRC

     C                   ENDIF
      *
     C                   CALLB     'ZCNSD'
     C                   PARM      P_NOML        ZNOML            15 0
     C                   PARM                    ZPRC             16 9
     C                   PARM      P_SPBS        Z#SPBS            1
     C                   PARM      P_NMDP        Z#NMDP            1 0
     C                   PARM      P_NCDP        Z#NCDP            1 0
     C                   PARM      *ZERO         ZCONS            15 0
      *
     C                   ENDSR
      *********************************************************************
     C/SPACE 5
      ********************************************************************
      * Initialize position fields
      ********************************************************************
     C     INIT_POSN     BEGSR
      * Zone, module, sub module, customer, portfolio, booking branch,
      * book, security, market
     C                   MOVEL     T_ZONE        P_ZONE
     C                   MOVEL     T_MOD         P_MOD
     C                   MOVEL     T_SMOD        P_SMOD
     C                   MOVEL     T_CNUM        P_CNUM
     C                   MOVEL     T_PTFR        P_PTFR
     C                   MOVEL     T_BRCA        P_BRCA
     C                   MOVEL     T_BOOK        P_BOOK
     C                   MOVEL     T_SESN        P_SESN
     C                   MOVEL     T_MKTI        P_MKTI
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
      * Zone, module, sub module, customer, portfolio, booking branch,
      * book, security, market
     C                   MOVEL     T_ZONE        E_ZONE
     C                   MOVEL     T_MOD         E_MOD
     C                   MOVEL     T_SMOD        E_SMOD
     C                   MOVEL     T_CNUM        E_CNUM
     C                   MOVEL     T_PTFR        E_PTFR
     C                   MOVEL     T_BRCA        E_BRCA
     C                   MOVEL     T_BOOK        E_BOOK
     C                   MOVEL     T_SESN        E_SESN
     C                   MOVEL     T_MKTI        E_MKTI
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
(c) Finastra International Limited 2003
** TABTYP / TABSEQ
PP05
MP20
IP30
TP40
TS40
IR50
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
