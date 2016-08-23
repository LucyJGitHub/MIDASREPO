     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Work with extract data - rollover')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEWRKEZRO - Work with Extract Data (Rollover)                *
      *                                                               *
      *  Component of: DEWRKEDTA                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 212721             Date 11Nov02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *  Last Amend No. CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  212721 - Loan capitalized interest differences in Revenue    *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D E#NCDP          S              1S 0
     D E#NMDP          S              1S 0
 
     D P#NCDP          S              1S 0
     D P#NMDP          S              1S 0
                                                                                212721
      ** External DS for Midas Modules details                                  212721
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                    212721
      **  Short data structure                                                  212721
     D DSFDY         E DS                  EXTNAME(DSFDY)                       212721
 
      * Set Position Fields
 
     C                   EXSR      SET_POSN
 
      * Return to calling function
 
     C                   RETURN
 
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * SET POSITION FIELDS
      ********************************************************************
     C     SET_POSN      BEGSR
 
      ***TAKE*NEW BASE RATE, IF PRESENT                                         212721
      **********                                                                212721
     C*****E#BRTE        IFNE      0                                            212721
     C**********         Z-ADD     E#BRTE        P#BRTE                         212721
     C**********         ENDIF                                                  212721
 
      ** TAKE NEW INTEREST RATE DETAILS, IF PRESENT
 
     C     E#IRCH        IFEQ      'Y'
     C     BGN0ST        OREQ      'N'                                          212721
     C                   Z-ADD     E#BRTE        P#BRTE                         212721
     C                   Z-ADD     E#RTSP        P#RTSP
     C                   MOVE      E#SPIN        P#SPIN
     C                   MOVE      E#ICMT        P#ICMT
     C                   ENDIF
 
      ** UPDATE INTEREST RATE
 
     C                   EXSR      UPD_IRAT
 
      ** TAKE NEW COST OF FUNDS RATE DETAILS, IF PRESENT
 
     C     E#CRCH        IFEQ      'Y'
     C                   Z-ADD     E#FSRP        P#FSRP
     C                   MOVE      E#FSGN        P#FSGN
     C                   ENDIF
 
      ** UPDATE COST OF FUNDS RATE
 
     C                   EXSR      UPD_CRAT
 
      ** TAKE NEW NOMINAL & CURRENCY, IF PRESENT
 
     C     E#NOML        IFNE      0
     C     E#CCY         ANDNE     *BLANK
     C                   Z-ADD     E#NOML        P#NOML
     C                   MOVE      E#CCY         P#CCY
     C                   Z-ADD     E#NCDP        P#NCDP
     C                   Z-ADD     E#NMDP        P#NMDP
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      ** UPDATE CURRENT EFFECTIVE INTEREST RATE
      *********************************************************************
     C     UPD_IRAT      BEGSR
      *
     C                   SELECT
      *
     C     P#SPIN        WHENEQ    ' '
     C     P#SPIN        OREQ      'A'
     C     P#BRTE        ADD       P#RTSP        P#IRAT
      *
     C     P#SPIN        WHENEQ    'S'
     C     P#BRTE        SUB       P#RTSP        P#IRAT
      *
     C     P#SPIN        WHENEQ    'P'
     C     P#RTSP        DIV       100           W#W119           11 9
     C     P#BRTE        MULT(H)   W#W119        P#IRAT
      *
     C                   ENDSL
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** UPDATE CURRENT EFFECTIVE COST OF FUNDS RATE
      *********************************************************************
     C     UPD_CRAT      BEGSR
      *
     C                   SELECT
      *
     C     P#FSGN        WHENEQ    ' '
     C                   Z-ADD     P#FSRP        P#CRAT
      *
     C     P#FSGN        WHENEQ    '+'
     C     P#IRAT        ADD       P#FSRP        P#CRAT
      *
     C     P#FSGN        WHENEQ    '-'
     C     P#IRAT        SUB       P#FSRP        P#CRAT
      *
     C                   ENDSL
      *
     C                   ENDSR
      *********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    Ret_Code          7
     C                   PARM                    Err_Mess         30
      *
      * INPUTS
      ** Base Rate
      ** Rate/Spread
      ** Spread Ind
      ** Interest Rate Change
      ** Funding Rate/Spread
      ** Funding Sign
      ** Cost of Funds Rate Change
      ** Int Calculation Method
      ** Nominal
      ** Currency
      ** Ccy Dec Places
      ** Nom Dec Places
     C                   PARM                    E#BRTE           11 7
     C                   PARM                    E#RTSP           11 7
     C                   PARM                    E#SPIN            1
     C                   PARM                    E#IRCH            1
     C                   PARM                    E#FSRP           11 7
     C                   PARM                    E#FSGN            1
     C                   PARM                    E#CRCH            1
     C                   PARM                    E#ICMT            7
     C                   PARM                    E#NOML           15 0
     C                   PARM                    E#CCY             3
     C                   PARM                    E#NCDP            1 0
     C                   PARM                    E#NMDP            1 0
      *
      * OUTPUTS
      ** Nominal/Principal
      ** Currency
      ** Nominal Ccy Dec Places
      ** Nominal Dec Places
      ** Base Rate
      ** Rate/Spread
      ** Spread Ind
      ** Interest/Discount Rate
      ** Funding Rate/Spread
      ** Funding Sign
      ** Cost of Funds Rate
      ** Int Calc Method
     C                   PARM                    P#NOML           15 0
     C                   PARM                    P#CCY             3
     C                   PARM                    P#NCDP            1 0
     C                   PARM                    P#NMDP            1 0
     C                   PARM                    P#BRTE           11 7
     C                   PARM                    P#RTSP           11 7
     C                   PARM                    P#SPIN            1
     C                   PARM                    P#IRAT           11 7
     C                   PARM                    P#FSRP           11 7
     C                   PARM                    P#FSGN            1
     C                   PARM                    P#CRAT           11 7
     C                   PARM                    P#ICMT            7
      *                                                                         212721
      ** Access MIDAS Modules details via access program                        212721
      *                                                                         212721
     C                   CALL      'AOMMODR0'                                   212721
     C                   PARM      '       '     @RTCD             7            212721
     C                   PARM      '*FIRST '     @OPTN             7            212721
     C     SDMMOD        PARM      SDMMOD        DSFDY                          212721
 
     C                   ENDSR
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR_WK
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
