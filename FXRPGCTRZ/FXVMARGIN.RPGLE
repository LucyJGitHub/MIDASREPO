     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Validate margin and other forward points')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FXVMARGIN - Validate Margin & Other Forward Points           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. 248269             Date 25Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002   *CREATE   Date 08Sep97               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248269 - Use original spot rate in validating the exchange   *
      *           rate of an Option takedown deal.                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
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
 
      ** Array of Fields with warnings.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of warning message data.
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
 
     D*RelDealDts      DS           100                                                       248269
     D RelDealDts      DS           113                                                       248269
      ** Related Deal Details (when deal is option takedown or swap.
      ** Thus related deal will be other leg of swap or option).
     D  RelMGPT               80     86  2                                      opt date - day
     D  RelMGBS               87     87                                         opt date - day
     D  RelDXRT               88    100  8                                      opt date - day
 
 
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
 
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
 
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
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             WIx
 
      *
      * MGINV  - MARGIN POINTS VALIDATION
      *
     C                   EXSR      MGINV
      *
      * MBSIV  - MARGIN BUY/SELL INDICATOR VALIDATION
      *
     C                   EXSR      MBSIV
      *
      * DBSRV  - DEAL BASE SPOT RATE VALIDATION
      *
     C                   EXSR      DBSRV
      *
      * BBFPV - BUY DEAL BASE FWD POINTS VALIDATION
      *
     C                   EXSR      BBFPV
      *
      * BBFSV - BUY DEAL BASE FWD POINTS SIGN VALIDATION
      *
     C                   EXSR      BBFSV
      *
      * SBFPV - SELL DEAL BASE FWD POINTS VALIDATION
      *
     C                   EXSR      SBFPV
      *
      * SBFSV - SELL DEAL BASE FWD POINTS SIGN VALIDATION
      *
     C                   EXSR      SBFSV
      *
      * BSBSXV - DEAL BASE SPOT + BUY/SELL FWD PTS CROSS VALIDATION
      *
     C     DDDbsrOK      IFNE      'N'                                          ie is Y oor W
     C     DDBbfpOK      ANDEQ     'Y'
     C     DDBbfsOK      ANDEQ     'Y'
     C     DDSbfpOK      ANDEQ     'Y'
     C     DDSbfsOK      ANDEQ     'Y'
     C                   EXSR      BSBSXV
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDMginOK      IFEQ      'N'
     C     DDMbsiOK      OREQ      'N'
     C     DDDbsrOK      OREQ      'N'
     C     DDBbfpOK      OREQ      'N'
     C     DDBbfsOK      OREQ      'N'
     C     DDSbfpOK      OREQ      'N'
     C     DDSbfsOK      OREQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * MGINV  - MARGIN POINTS VALIDATION                             *
      *****************************************************************
     C     MGINV         BEGSR
      *
      ** Margin points should be 7 long with 2 decimals
      *
     C                   Z-ADD     2             @@IDP
     C                   Z-ADD     5             @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDMGIN        @@ALPH
     C                   MOVE      'N'           @@MTID
     C                   EXSR      ZA0840
      * error
     C     @@ERCD        IFNE      0
     C                   MOVE      'N'           DDMginOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMGIN'      FldNamXAr(Idx)
     C                   MOVEL     'FXM1047'     MsgIdXAr(Idx)
     C                   ELSE
     C                   MOVE      @@ALPH        DDMGIN
     C     @@AMT         DIV       100           F3MGPT
     C                   END
      *
      ** On insert of an option takedown
      *
     C     DDMginOK      IFEQ      'Y'
     C     DDACTN        ANDEQ     'I'
     C     DDDLTP        ANDEQ     'OT'
      *
      ** If the margin is zero, default to the margin on the 'OP' deal
      *
     C     F3MGPT        IFEQ      *ZEROS
      *
     C                   Z-ADD     RelMGPT       F3MGPT
      *
     C     F3MGPT        MULT      100           @@AMTW
     C                   Z-ADD     2             @@QECN
     C                   EXSR      ZA0920
     C                   MOVE      @@AMTD        DDMGIN
      *
      ** If the margin is not 0 it must equal to that on the 'OP' deal
      *
     C                   ELSE
      *
     C     F3MGPT        IFNE      RelMGPT
     C                   MOVE      'N'           DDMginOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMGIN'      FldNamXAr(Idx)
     C                   MOVEL     'FXM1048'     MsgIdXAr(Idx)
     C                   END
      *
     C                   END                                                    F3MGPT
     C                   END                                                    DDMginOK
     C*
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * MBSIV  - MARGIN BUY/SELL INDICATOR VALIDATION                 *
      *****************************************************************
     C     MBSIV         BEGSR
      *
      ** On insert of an option takedown
      *
     C     DDMbsiOK      IFEQ      'Y'
     C     DDACTN        ANDEQ     'I'
     C     DDDLTP        ANDEQ     'OT'
      *
      ** Default to the value on the original OP deal, if blank
      *
     C     DDMBSI        IFEQ      *BLANK
     C                   MOVE      RelMGBS       DDMBSI
     C                   ELSE
      *
      ** It should be the same as the value in the OP deal
      *
     C     DDMBSI        IFNE      RelMGBS
     C                   MOVE      'N'           DDMbsiOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMBSI'      FldNamXAr(Idx)
     C                   MOVEL     'FXM1050'     MsgIdXAr(Idx)
     C                   END
     C                   END                                                    DDMBSI
     C                   END                                                    DDMbsiOK
      *
      ** If the margin buy/sell ind is OK so far
      *
     C     DDMbsiOK      IFEQ      'Y'
      *
      ** If the margin rate is entered
      ** The margin buy/sell ind must be entered
      *
     C     F3MGPT        IFNE      *ZEROS
     C     DDMBSI        ANDEQ     *BLANK
     C                   MOVE      'N'           DDMbsiOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMBSI'      FldNamXAr(Idx)
     C                   MOVEL     'FXM1051'     MsgIdXAr(Idx)
     C                   END
     C                   END
      *
      ** If the margin buy/sell ind is OK so far
      *
     C     DDMbsiOK      IFEQ      'Y'
      *
      ** It must be 'B' or 'S' or ' '
      *
     C     DDMBSI        IFNE      'B'
     C     DDMBSI        ANDNE     'S'
     C     DDMBSI        ANDNE     ' '
     C                   MOVE      'N'           DDMbsiOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMBSI'      FldNamXAr(Idx)
     C                   MOVEL     'FXM1052'     MsgIdXAr(Idx)
     C                   END
     C                   END
      *
      ** If the margin buy/sell ind is OK
      ** Store in deal
      *
     C     DDMbsiOK      IFEQ      'Y'
     C                   MOVE      DDMBSI        F3MGBS
     C                   END
     C*
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * DBSRV  - DEAL BASE SPOT RATE VALIDATION                       *
      *****************************************************************
     C     DBSRV         BEGSR
      *
      ** DL Base Spot Rate should be 12 long with 8 decimal places
      *
     C                   Z-ADD     8             @@IDP
     C                   Z-ADD     4             @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDDBSR        @@ALPH
     C                   MOVE      'N'           @@MTID
     C                   EXSR      ZA0840
      ** error
     C     @@ERCD        IFNE      0
     C                   MOVE      'N'           DDDbsrOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDBSR'      FldNamXAr(Idx)
     C                   MOVEL     'FXM1054'     MsgIdXAr(Idx)
     C                   ELSE
     C                   MOVE      @@ALPH        DDDBSR
     C                   END
      *
      ** DL Base Spot Rate to be written to the file
      *
     C     @@AMT         DIV       100000000     F3BDBS
      *
      ** If valid margin buy/sell indicator and currency are specified,
      ** additional validation for DL Base spot rate is necessary
      *
     C     DDBccyOK      IFEQ      'Y'
     C     DDSccyOK      ANDEQ     'Y'
     C     DDMbsiOK      ANDEQ     'Y'
     C     DDMBSI        ANDNE     *BLANK
      *
      ** Get the spot rate and mult/div ind of the buy/sell ccy
      *
     C     DDMBSI        IFEQ      'B'
     C                   MOVE      DDBCCY        @AJCD
     C                   ELSE
     C                   MOVE      DDSCCY        @AJCD
     C                   END
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR'      @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   Z-ADD     A6SPRT        BySlSpot         13 8
     C                   MOVE      A6MDIN        BySlMdin          1
      *
      * Calculate cross rate between base currency & buy/sell currency
      *
     C     BySlMdin      IFEQ      DlBsMdin
     C     DlBsSpot      IFNE      *ZEROS
     C     BySlSpot      DIV       DlBsSpot      CrossRate        13 8
     C                   ELSE
     C                   Z-ADD     *ZEROS        CrossRate
     C                   END
     C                   ELSE
     C     BySlSpot      MULT      DlBsSpot      CrossRate
     C                   END
      *
      ** Determine the rate to dealing base currency of the buy or sell ccy
      *
     C     CrossRate     DIV(H)    10            W@BSRT           13 8
     C     CrossRate     ADD(H)    W@BSRT        W@BRHI           13 8
     C     CrossRate     SUB(H)    W@BSRT        W@BRLO           13 8
      *
      ** DL Base Spot Rate must be within 10% of the tolerance
      *
     C     F3BDBS        IFGT      W@BRHI
     C     F3BDBS        ORLT      W@BRLO
     C     DDDbsrOK      IFNE      'N'
     C                   MOVE      'W'           DDDbsrOK
     C                   END                                                    F3BDBS
     C                   ADD       1             WIx
     C                   MOVEL     'DDDBSR'      WFldNmXAr(WIx)
     C                   MOVEL     'FXX0422'     WMsgIdXAr(WIx)
     C                   END                                                    F3BDBS
     C                   END                                                    DDBccyOK
     C*
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * BBFPV - BUY DEAL BASE FWD POINTS VALIDATION
      *****************************************************************
     C     BBFPV         BEGSR
      *
      ** DL Buy Base Fwd Points should be 7 long with 2 decimal places
      *
     C                   Z-ADD     2             @@IDP
     C                   Z-ADD     5             @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDBBFP        @@ALPH
     C                   MOVE      'N'           @@MTID
     C                   EXSR      ZA0840
      * error
     C     @@ERCD        IFNE      0
     C                   MOVE      'N'           DDBbfpOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBBFP'      FldNamXAr(Idx)
     C                   MOVEL     'FXM1056'     MsgIdXAr(Idx)
     C                   ELSE
     C                   MOVE      @@ALPH        DDBBFP
     C     @@AMT         DIV       100           F3BDBF
     C                   END
     C*
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * BBFSV - BUY DEAL BASE FWD POINTS SIGN VALIDATION
      *****************************************************************
     C     BBFSV         BEGSR
      *
      ** DL Buy Base Forward Points sign should not be entered
      *
     C     F3BDBF        IFEQ      *ZEROS
     C     DDBBFS        IFNE      ' '
     C     DDBBFS        ANDNE     '+'
     C                   MOVE      'N'           DDBbfsOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBBFS'      FldNamXAr(Idx)
     C                   MOVEL     'FXM1057'     MsgIdXAr(Idx)
     C                   END
     C                   END
      *
      ** DL Buy Base Forward Points sign should be entered
      *
     C     DDBbfsOK      IFEQ      'Y'
     C     F3BDBF        IFNE      *ZEROS
     C     DDBBFS        ANDEQ     *BLANK
     C                   MOVE      'N'           DDBbfsOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBBFS'      FldNamXAr(Idx)
     C                   MOVEL     'FXM1058'     MsgIdXAr(Idx)
     C                   END
     C                   END
      *
      ** DL Buy Base Forward Points sign should be '+' or '-'
      *
     C     DDBbfsOK      IFEQ      'Y'
     C     F3BDBF        IFNE      *ZEROS
     C     DDBBFS        IFNE      '+'
     C     DDBBFS        ANDNE     '-'
     C                   MOVE      'N'           DDBbfsOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBBFS'      FldNamXAr(Idx)
     C                   MOVEL     'FXM1059'     MsgIdXAr(Idx)
     C                   END
     C                   END
     C                   END
      *
      ** Reflect sign in deal - DL Buy forward points
      *
     C     DDBbfpOK      IFEQ      'Y'
     C     DDBbfsOK      ANDEQ     'Y'
     C     DDBBFS        IFEQ      '+'
     C                   Z-ADD     F3BDBF        F3BDBF
     C                   ELSE
     C                   Z-SUB     F3BDBF        F3BDBF
     C                   END
     C                   END
     C*
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SBFPV - SELL DEAL BASE FWD POINTS VALIDATION
      *****************************************************************
     C     SBFPV         BEGSR
      *
      ** DL Sell Base Fwd Points should be 7 long with 2 decimal places
      *
     C                   Z-ADD     2             @@IDP
     C                   Z-ADD     5             @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDSBFP        @@ALPH
     C                   MOVE      'N'           @@MTID
     C                   EXSR      ZA0840
      * error
     C     @@ERCD        IFNE      0
     C                   MOVE      'N'           DDSbfpOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSBFP'      FldNamXAr(Idx)
     C                   MOVEL     'FXM1060'     MsgIdXAr(Idx)
     C                   ELSE
     C                   MOVE      @@ALPH        DDSBFP
     C     @@AMT         DIV       100           F3SDBF
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SBFSV - SELL DEAL BASE FWD POINTS SIGN VALIDATION
      *****************************************************************
     C     SBFSV         BEGSR
      *
      ** DL Sell Base Forward Points sign should not be entered
      *
     C     F3SDBF        IFEQ      *ZEROS
     C     DDSBFS        IFNE      ' '
     C     DDSBFS        ANDNE     '+'
     C                   MOVE      'N'           DDSbfsOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSBFS'      FldNamXAr(Idx)
     C                   MOVEL     'FXM1061'     MsgIdXAr(Idx)
     C                   END
     C                   END
      *
      ** DL Sell Base Forward Points sign should be entered
      *
     C     DDSbfsOK      IFEQ      'Y'
     C     F3SDBF        IFNE      *ZEROS
     C     DDSBFS        ANDEQ     *BLANK
     C                   MOVE      'N'           DDSbfsOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSBFS'      FldNamXAr(Idx)
     C                   MOVEL     'FXM1062'     MsgIdXAr(Idx)
     C                   END
     C                   END
      *
      ** DL Sell Base Forward Points sign should be '+' or '-'
      *
     C     DDSbfsOK      IFEQ      'Y'
     C     F3SDBF        IFNE      *ZEROS
     C     DDSBFS        IFNE      '+'
     C     DDSBFS        ANDNE     '-'
     C                   MOVE      'N'           DDSbfsOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSBFS'      FldNamXAr(Idx)
     C                   MOVEL     'FXM1063'     MsgIdXAr(Idx)
     C                   END
     C                   END
     C                   END
      *
      ** Reflect sign in deal - DL Sell forward points
      *
     C     DDSbfpOK      IFEQ      'Y'
     C     DDSbfsOK      ANDEQ     'Y'
     C     DDSBFS        IFEQ      '+'
     C                   Z-ADD     F3SDBF        F3SDBF
     C                   ELSE
     C                   Z-SUB     F3SDBF        F3SDBF
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * BSBSXV - DEAL BASE SPOT + BUY/SELL FWD PTS CROSS VALIDATION
      *****************************************************************
     C     BSBSXV        BEGSR
      *
      ** If base ccy for DL = buy/sell ccy
      *
     C     BNCYDL        IFEQ      DDBCCY
     C     BNCYDL        OREQ      DDSCCY
      *
      ** Deal base spot rate, buy deal base fwd points (+ sign)
      ** and sell deal base fwd points (+ sign) must not be entered
      *
     C     F3BDBS        IFNE      *ZEROS
     C                   MOVE      'N'           DDDbsrOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDBSR'      FldNamXAr(Idx)
     C                   MOVEL     'FXM1053'     MsgIdXAr(Idx)
     C                   END
 
     C     F3BDBF        IFNE      *ZEROS
     C                   MOVE      'N'           DDBbfpOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBBFP'      FldNamXAr(Idx)
     C                   MOVEL     'FXM1053'     MsgIdXAr(Idx)
     C                   END
 
     C     DDBBFS        IFNE      *BLANKS
     C     DDBBFS        ANDNE     '+'
     C                   MOVE      'N'           DDBbfsOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBBFS'      FldNamXAr(Idx)
     C                   MOVEL     'FXM1053'     MsgIdXAr(Idx)
     C                   END
 
     C     F3SDBF        IFNE      *ZEROS
     C                   MOVE      'N'           DDSbfpOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSBFP'      FldNamXAr(Idx)
     C                   MOVEL     'FXM1053'     MsgIdXAr(Idx)
     C                   END
 
     C     DDSBFS        IFNE      *BLANKS
     C     DDSBFS        ANDNE     '+'
     C                   MOVE      'N'           DDSbfsOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSBFS'      FldNamXAr(Idx)
     C                   MOVEL     'FXM1053'     MsgIdXAr(Idx)
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ZA0840 - VALIDATE AN AMOUNT IN AN ALPHA FIELD & CONVERT TO NUM*
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
     C                   PARM                    DDACTN            1            Action Code
     C                   PARM                    DDDLTP            2            Deal Type
     C                   PARM                    DDBCCY            3            Buy CCy
     C                   PARM                    DDSCCY            3            Sell Ccy
      *
     C                   PARM                    DDMGIN            8            Margin Pts
     C                   PARM                    DDMBSI            1            Margin B/S
     C                   PARM                    DDDBSR           13            Dealt Base Rate
     C                   PARM                    DDBBFP            8            Buy Fwd Pts
     C                   PARM                    DDBBFS            1            Buy Fwd Pts sign
     C                   PARM                    DDSBFP            8            Sell Fwd Pts
     C                   PARM                    DDSBFS            1            Sell Fwd Pts sign
      *
      ** Related deal details
     C                   PARM                    RelDealDts                     SW/OP branch
      *
      ** Buy & Sell Ccy OK
     C                   PARM                    DDBccyOK          1            Buy CCy
     C                   PARM                    DDSccyOK          1            Sell Ccy
      *
      * ICD
     C                   PARM                    BNCYDL            3
     C                   PARM                    BNDCSP            1
      *
      * OUTPUTS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Margin - OK
      ** Margin Buy/sell ind - OK
      ** Deal Base Spot rate - OK
      ** Buy DL Base Fwd points - OK
      ** Buy DL Base Fwd points sign - OK
      ** Sell DL Base Fwd points - OK
      ** Sell DL Base Fwd points sign - OK
      *
     C                   PARM                    DDMginOK          1            Margin Pts
     C                   PARM                    DDMbsiOK          1            Margin B/S
     C                   PARM                    DDDbsrOK          1            Dealt Base Rate
     C                   PARM                    DDBbfpOK          1            Buy Fwd Pts
     C                   PARM                    DDBbfsOK          1            Buy Fwd Pts sign
     C                   PARM                    DDSbfpOK          1            Sell Fwd Pts
     C                   PARM                    DDSbfsOK          1            Sell Fwd Pts sign
      *
      ** Margin
      ** Margin Buy/sell ind
      ** Deal Base Spot rate
      ** Buy DL Base Fwd points
      ** Sell DL Base Fwd points
      *
     C                   PARM                    F3MGPT            7 2          Margin Pts
     C                   PARM                    F3MGBS            1            Margin B/S
     C                   PARM                    F3BDBS           13 8          Dealt Base Rate
     C                   PARM                    F3BDBF            7 2          Buy Fwd Pts
     C                   PARM                    F3SDBF            7 2          Sell Fwd Pts
      *
      ** Get the rate and multiply/divide indicator of dealing base ccy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BNCYDL        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 904*
     C                   MOVEL     BNCYDL        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
     C                   Z-ADD     A6SPRT        DlBsSpot         13 8
     C                   MOVE      A6MDIN        DlBsMdin          1
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
