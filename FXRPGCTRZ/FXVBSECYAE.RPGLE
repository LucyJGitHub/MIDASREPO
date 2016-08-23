     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Validate base currency equivalent')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FXVBSECYAE - Validate Base Currency for Accounting Equivalent*
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD000091           Date 07May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      *                 183759             Date 11Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 08Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  183759 - Allow insert/authorise FX deal even if Base Curr    *
      *           Equivalent exceeds to 20% tolerance range since     *
      *           error msg FXX0421 is only a warning message.        *
      *  CAP002 - Conversion of FX inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
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
 
      ** Include the FX standard declares
     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
     D/COPY ZACPYSRC,STDDECLARE                                                               209009
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Fields with warnings.                                                       183759
     D WFldNmXAr       S             10A   DIM(XArrayMax)                                     183759
                                                                                              183759
      ** Array of warning message IDs                                                         183759
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)                        183759
                                                                                              183759
      ** Array of warning message data.                                                       183759
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)                      183759
 
     D M@MGDA          DS
     D  M@0145                 1     45
     D  M@0115                 1     15
     D  M@1630                16     30
 
 
      ** External data structure for currency codes file
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for access programs (long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
                                                                                              183759
      ** Index for arrays of warning message ids etc                                          183759
     D WIx             S              3P 0                                                    183759
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANK        WFldNmXAr                                    183759
     C                   MOVE      *BLANK        WMsgIDXAr                                    183759
     C                   MOVE      *BLANK        WMsgDtXAr                                    183759
     C                   Z-ADD     0             WIx                                          183759
 
      *
      ** BCEV - BASE CURRENCY EQUIVALENT VALIDATION
      *
     C                   EXSR      BCEV
      *
      ** If base currency equivalent OK so far
      *
     C     DDBceOK       IFEQ      'Y'
     C     DDBccyOK      ANDEQ     'Y'
     C     DDBAmtOK      ANDEQ     'Y'
     C     DDSccyOK      ANDEQ     'Y'
     C     DDSAmtOK      ANDEQ     'Y'
      *
      * Only on insertion or authorization
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'X'
      *
      * If either buy/sell currency is base, use the buy/sell amount
      *
     C     DDBCCY        IFEQ      BJCYCD
     C                   Z-ADD     F3DAM1        F3BCAE
     C                   ELSE
     C     DDSCCY        IFEQ      BJCYCD
     C                   Z-SUB     F3DAM2        F3BCAE
     C                   ELSE
      *
      ** BCEC - BASE CURRENCY EQUIVALENT CALCULATION
      ** (only done if neither currency is base currency for accounting)
      *
     C                   EXSR      BCEC
     C                   END
     C                   END
      *
     C                   END
      *
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDBceOK       IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** BCEV - BASE CURRENCY EQUIVALENT VALIDATION
      *****************************************************************
     C     BCEV          BEGSR
      *
      * If insertion
      *
     C     DDACTN        IFEQ      'I'
      *
      *  Error if base ccy equiv defined and base ccy is involved
      *  (base ccy equiv will be calculated and defaulted)
      *
     C     DDBCCY        IFEQ      BJCYCD
     C     DDBCE         ANDNE     *BLANKS
     C     DDSCCY        OREQ      BJCYCD
     C     DDBCE         ANDNE     *BLANKS
     C                   MOVE      'N'           DDBceOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBCE '      FldNamXAr(Idx)
     C                   MOVEL     'FXM0156'     MsgIdXAr(Idx)
     C     DDBCCY        IFEQ      BJCYCD
     C**********         MOVEL     DDBCCY        MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDBCCY))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDBCCY)                   MD000091
     C                   ELSE
     C**********         MOVEL     DDSCCY        MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDSCCY))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDSCCY)                   MD000091
     C                   END
     C                   END
     C                   END
      *
      * Base ccy equiv is OK and defined
      *
     C     DDBceOK       IFEQ      'Y'
     C     DDBCE         ANDNE     *BLANKS
     C                   Z-ADD     BseCyDecp     @@IDP
     C     13            SUB       BseCyDecp     @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDBCE         @@ALPH
     C                   MOVE      'N'           @@MTID
     C                   EXSR      ZA0840
     C     @@ERCD        IFNE      0
     C                   MOVE      'N'           DDBceOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBCE '      FldNamXAr(Idx)
     C                   MOVEL     'FXM0283'     MsgIdXAr(Idx)
     C                   ELSE
      *
      **  The amount must not be zero.
      *
     C     @@AMT         IFEQ      *ZEROS
     C                   MOVE      'N'           DDBceOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBCE '      FldNamXAr(Idx)
     C                   MOVEL     'FXM0155'     MsgIdXAr(Idx)
     C                   END
     C*
     C                   END
     C                   END
      *
      * update file base ccy equiv
      *
     C     DDBceOK       IFEQ      'Y'
     C     DDBCE         ANDNE     *BLANKS
     C                   MOVE      @@ALPH        DDBCE
     C                   Z-ADD     @@AMT         F3BCAE
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** BCEC - BASE CURRENCY EQUIVALENT CALCULATION
      *****************************************************************
     C     BCEC          BEGSR
      *
      * Only if NEITHER currency is base currency for accounting
      * Calculate Base Currency (for Accounting) Equivalent
      *
     C                   CALLB     'ZACALBEA'
      *
      * INPUTS
      *
      * buy currency: amount, spot rate, ccy dec. places, M/D ind
      *
     C                   PARM      F3DAM1        @@DAM1           15 0          amount
     C                   PARM                    @SPOT1           13 8          spot rate
     C                   PARM                    @CDP1             1 0          no of dec places
     C                   PARM                    @@MDF1            1            mult/div ind
      *
      * sell currency: amount, spot rate, ccy dec. places, M/D ind
      *
     C                   PARM      F3DAM2        @@DAM2           15 0          amount
     C                   PARM                    @SPOT2           13 8          spot rate
     C                   PARM                    @CDP2             1 0          no of dec places
     C                   PARM                    @@MDF2            1            mult/div ind
      *
      * ICD
     C                   PARM                    BJCYCD                         mult/div ind
      *
      * OUTPUTS
      *
      * Base currency for accounting equivalent
     C                   PARM      *ZEROS        @@BCAE           15 0          base ccy a/cing
      *
      * If base currency equivalent is not defined,
      * default it to that just calculated
      *
     C     DDBCE         IFEQ      *BLANKS
     C                   Z-ADD     @@BCAE        F3BCAE
     C                   END
      *
      * If base currency equivalent is defined
      * Check whether it is +/- 20% of that just calculated
      *
     C     DDBCE         IFNE      *BLANKS
      *
     C     @@BCAE        DIV(H)    5             W@BCEL                         20%
     C     @@BCAE        ADD       W@BCEL        W@BCEH           15 0          Highest allowed
     C     @@BCAE        SUB       W@BCEL        W@BCEL           15 0          Lowest allowed
      *
     C     F3BCAE        IFLT      W@BCEL                                       IF  TOO LOW
     C     F3BCAE        ORGT      W@BCEH                                       OR TOO HIGH
      *
     C                   MOVE      *BLANK        M@MGDA                           Message data
     C                   Z-ADD     W@BCEL        @@AMTW                           I:Amount
     C                   Z-ADD     BseCyDecp     @@QECN                           I:Dec.places
     C                   EXSR      ZA0920                                         <Convert>
     C                   MOVE      @@AMTD        M@0115                           O:To msg.data
      *
     C                   Z-ADD     W@BCEH        @@AMTW                           I:Amount
     C                   Z-ADD     BseCyDecp     @@QECN                           I:Dec.places
     C                   EXSR      ZA0920                                         <Convert>
     C                   MOVE      @@AMTD        M@1630                           O:To msg.data
      *
     C                   MOVE      'N'           DDBceOK
     C**********         ADD       1             Idx                                          183759
     C                   ADD       1             WIx                                          183759
     C**********         MOVEL     'DDBCE '      FldNamXAr(Idx)                               183759
     C                   MOVEL     'DDBCE '      WFldNmXAr(WIx)                               183759
     C**********         MOVEL     'FXX0421'     MsgIdXAr(Idx)                                183759
     C                   MOVEL     'FXX0421'     WMsgIdXAr(WIx)                               183759
     C**********         MOVEL     M@MGDA        MsgDtaXAr(Idx)                   I:Msg.data  183759
     C**********         MOVEL     M@MGDA        WMsgDtXAr(WIx)          I:Msg.data  183759 MD000091
     C                   EVAL      BLen = %Len(%Trim(M@MGDA))                               MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(M@MGDA)                   MD000091
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZA0840 - VALIDATE/REFORMAT AMOUNT                             *
      *****************************************************************
     C     ZA0840        BEGSR
     C                   CALLB     'ZA0840'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH           16            Display field
     C                   PARM                    @@IDP             3 0          no.of dec.plcs
     C                   PARM                    @@IINT            3 0          no.of integers
     C                   PARM                    @@MTID            1            Million/Thous.
     C                   PARM      *ZERO         @@ERCD            1 0          Error code
     C                   PARM      *ZERO         @@AMT            15 0          File field
     C                   PARM                    BNDCSP
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZA0920 - EDIT AN AMOUNT INTO AN ALPHA FIELD                  *
      *****************************************************************
     C     ZA0920        BEGSR
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@AMTW           13 0
     C                   PARM                    @@QECN            1 0
     C                   PARM                    BNDCSP
     C                   PARM      *BLANK        @@AMTD           14
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Deal Screen fields
     C                   PARM                    DDBCE            14            base ccy equiv
      *
     C                   PARM                    DDACTN            1            action code
     C                   PARM                    DDBCCY            3            buy ccy
     C                   PARM                    DDSCCY            3            sell ccy
     C                   PARM                    DDBAMT           14            buy amount
     C                   PARM                    DDSAMT           14            sell amount
      *
      ** OK indicators
     C                   PARM                    DDBccyOK          1            Buy ccy error
     C                   PARM                    DDSccyOK          1            Sell ccy error
     C                   PARM                    DDBAmtOK          1            Buy amt error
     C                   PARM                    DDSAmtOK          1            Sell amt error
      *
      ** Buy/sell amts
     C                   PARM                    F3DAM1           15 0          buy amount
     C                   PARM                    F3DAM2           15 0          sell amount
      *
      * Ccy 1 details
     C                   PARM                    @SPOT1           13 8          spot rate
     C                   PARM                    @CDP1             1 0          no of dec places
     C                   PARM                    @@MDF1            1            mult/div ind
      *
      * Ccy 2 details
     C                   PARM                    @SPOT2           13 8          spot rate
     C                   PARM                    @CDP2             1 0          no of dec places
     C                   PARM                    @@MDF2            1            mult/div ind
      *
      * ICD
     C                   PARM                    BJCYCD            3
     C                   PARM                    BNDCSP            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr                                    183759
     C                   PARM                    WMsgIDXAr                                    183759
     C                   PARM                    WMsgDtXAr                                    183759
      *
      ** Base ccy equivalent - OK
     C                   PARM                    DDBceOK           1            base ccy equiv
      *
      ** Deal Base ccy equivalent
     C                   PARM                    F3BCAE           15 0          base ccy equiv
      *
      ** Get the base currency decimal places
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BJCYCD        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 904*
     C                   MOVEL     BJCYCD        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
     C                   Z-ADD     A6NBDP        BseCyDecp         1 0
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
