     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Work with extract data - spread change')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEWRKEZSC - Work with Extract Data (Spread Change)           *
      *                                                               *
      *  Component of: DEWRKEDTA                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 212721             Date 11Dec02               *
      *  Prev Amend No. 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  212721 - Loan capitalized interest differences in Revenue    *
      *  208221 - Cost of Funds should not be set up if Interest Rate *
      *           is zero                                             *
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
      *
      ** IF INTEREST RATE CHANGE
      *
     C     E#IRCH        IFEQ      'Y'
     C     BGN0ST        OREQ      'N'                                          212721
     C     E#CRCH        ORNE      'Y'
      *
      ** UPDATE (INTEREST) SPREAD RATE
      *
     C                   Z-ADD     E#RTSP        P#RTSP
      *
      ** UPDATE INTEREST RATE
      *
     C                   EXSR      UPD_IRAT
 
     C                   ENDIF
      *
      ** IF COST OF FUNDS RATE CHANGE
      *
     C     E#CRCH        IFEQ      'Y'
      *
      ** UPDATE FUNDING SPREAD RATE
      *
     C                   Z-ADD     E#FSRP        P#FSRP
      *
      ** UPDATE COST OF FUNDS RATE
      *
     C                   EXSR      UPD_CRAT
 
     C                   ENDIF
      *
 
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
     C     P#IRAT        IFNE      0                                                          208221
     C     P#IRAT        ADD       P#FSRP        P#CRAT
     C                   ELSE                                                                 208221
     C                   Z-ADD     0             P#CRAT                                       208221
     C                   ENDIF                                                                208221
      *
     C     P#FSGN        WHENEQ    '-'
     C     P#IRAT        IFNE      0                                                          208221
     C     P#IRAT        SUB       P#FSRP        P#CRAT
     C                   ELSE                                                                 208221
     C                   Z-ADD     0             P#CRAT                                       208221
     C                   ENDIF                                                                208221
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
      ** Spread Ind
      ** Funding Sign
     C                   PARM                    P#BRTE           11 7
     C                   PARM                    P#SPIN            1
     C                   PARM                    P#FSGN            1
      ** Rate/Spread
      ** Funding Rate/Spread
      ** Interest Rate Change
      ** Cost of Funds Rate Change
     C                   PARM                    E#RTSP           11 7
     C                   PARM                    E#FSRP           11 7
     C                   PARM                    E#IRCH            1
     C                   PARM                    E#CRCH            1
      *
      * OUTPUTS
      ** Rate/Spread
      ** Funding Rate/Spread
      ** Interest/Discount Rate
      ** Cost of Funds Rate
     C                   PARM                    P#RTSP           11 7
     C                   PARM                    P#FSRP           11 7
     C                   PARM                    P#IRAT           11 7
     C                   PARM                    P#CRAT           11 7
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
