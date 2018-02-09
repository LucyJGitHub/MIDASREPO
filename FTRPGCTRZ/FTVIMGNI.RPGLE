     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP margin information')              *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIMGNI - Validate Margin Information                       *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 25Aug03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 202895             Date 22Jul02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Thin Client API Wrappers                            *
      *           Recompiled over changed FTIPY6PD.                   *
      *  202895 - Check module indicator to condition calling of      *
      *           Access Object programs.                             *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
      *
      ***Incoming*Payments*Lvl*2*Scrn*3*details*from*incoming*transaction       CFT014
      ***-*screen*format***********************************************         CFT014
     D*NwIP4ScnFmt***E DS                  EXTNAME(FTIPY4PD)                    CFT014
      *                                                                         CFT014
      ** Incoming Payments Margin info screen format definition file            CFT014
     D NwIP6ScnFmt   E DS                  EXTNAME(FTIPY6PD)                    CFT014
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ***Incoming*Payments*Lvl*2*Scrn*2*error*indicators***************         CFT014
     D*FTEIPY3***    E DS                  EXTNAME(FTEIPY3PD)                   CFT014
      ** Incoming Payments Margin Info error indicators                         CFT014
     D FTEIPY5       E DS                  EXTNAME(FTEIPY5PD)                   CFT014
      *
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** External DS for Dealing ICD Details Access Program
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      *
      ** External DS for Profit Centre Accounting Access Program
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)
      *
      ** DS for access programs - Short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs - Long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  202895
      ** External DS For MIDAS Module Details                                                 202895
      *                                                                                       202895
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Index for arrays of warning message ids, etc.
     D WIx             S              3P 0
      *
      ** Array for Margin Points / Amounts calculation
     D AP              S             10  0 DIM(10) CTDATA PERRCD(1)
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialise work variables for file update.
     C                   Z-ADD     0             WFXMP             7 2
     C                   MOVE      'N'           WDeftsUsd         1
      *
      ** Initialise work variables.
     C                   EVAL      Idx = 0
      *
      ** Validate Margin Informations.
      *
     C                   EXSR      SRVMgnInfo
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKMBSI = 'N' or
     C                             OKMSIG = 'N' or
     C                             OKFXMP = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ELSE
      *
     C                   If        DDMBSI = 'S'
     C                   EVAL      IPMBSI = 'B'
     C                   EndIf
     C                   If        DDMBSI = 'P'
     C                   EVAL      IPMBSI = 'S'
     C                   EndIf
      *
     C                   IF        IPPCCY <> IPSMCY
     C                   Z-ADD     IPMDIN        IPFXMD
     C                   MOVEL     DDMSIG        IPMSIG
     C                   Z-ADD     WMAMT         IPMAMT
     C                   Z-ADD     WFXMP         IPFXMP
     C                   ELSE
     C                   Z-ADD     *ZERO         IPFXMD
     C                   MOVEL     *BLANK        IPMBSI
     C                   MOVEL     *BLANK        IPMSIG
     C                   Z-ADD     *ZERO         IPMAMT
     C                   Z-ADD     *ZERO         IPFXMP
     C                   ENDIF
      *
      ** Format FX Margin Points.
      ** Execute FMTAMT to format the points, using 2 decimal places
      ** and adjusting the file figure to have only implied decimal
      ** places.
      *
     C                   IF        WFXMP = 0
     C                   MOVE      *Blanks       DDFXMP
      *
      ** Set DDFXMP to 0.00                                                                   CAP084
     C                   IF        IPPCCY <> IPSMCY                                           CAP084
     C                   MOVE      '0.00'        DDFXMP                                       CAP084
     C                   ENDIF                                                                CAP084
      *
     C                   ELSE
     C     WFXMP         MULT      100           P0AMTW
     C                   Z-ADD     2             P0QECN
     C                   EXSR      SRFmtAmt
     C                   MOVE      P0AMTD        DDFXMP
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVMGNINFO - Validate Margin Informations                  *
      *                                                               *
      *****************************************************************
     C     SRVMgnInfo    BEGSR
      *
      **  If Purchase Currency is equal to Sell Currency, display error
      **  message "Margin information is not allowed if the settle and
      **  and pay currencies are the same".
     C                   IF        IPPCCY = IPSMCY
      *
     C                   IF        (DDFXMP <> *BLANKS OR
     C                             DDMBSI <> *BLANK OR
     C                             DDMSIG <> *BLANK)
      *
     C                   IF        DDFXMP <> *BLANK
     C                   MOVE      'N'           OKFXMP
     C                   ENDIF
     C                   IF        DDMBSI <> *BLANK
     C                   MOVE      'N'           OKMBSI
     C                   ENDIF
     C                   IF        DDMSIG <> *BLANK
     C                   MOVE      'N'           OKMSIG
     C                   ENDIF
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDFXMP'      FldNamXAr(Idx)
     C                   MOVEL     'AAM0008'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   GOTO      EValMgnInf
     C                   ENDIF
      *
      ** Setup defaults fields
     C                   EXSR      SRDefaults
      *
      ** Validate Margin Points
     C                   EXSR      SRValMgnPts
      *
      ** Validate Margin P/S Indicator
     C                   EXSR      SRValMgnPSI
      *
      ** Validate Margin Sign
     C                   EXSR      SRValMgnSgn
      *
      ** If no errors calculate Margin Amount.
      *
     C     OKFXMP        IFNE      'N'
     C     OKMSIG        ANDNE     'N'
     C     OKMBSI        ANDNE     'N'
     C                   EXSR      SRMAMT
     C                   ENDIF
      *
     C     EValMgnInf    ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDEFAULTS - Setup default fields                            *
      *                                                               *
      *****************************************************************
     C     SRDefaults    BEGSR
      *
      ** Get Settlement and Pay Currencies Details.
      *
     C                   EXSR      SRCURR
      *
      ** Move data into screen fields.
      *
     C                   EXSR      SRMOVF
      *
      ** Get Default Cross-Currency Rate.
      *
     C                   EXSR      SRDRAT
      *
      ** Get Normally-Quoted Decimal Places.
      *
     C                   EXSR      SRNQDP
      *
      ** Calculate for Default FX Margin Points and Sign.
      ** Deflt FX Marg Pts = (Xccy rate - Trans Rate) * 10**Quoted DP
      *
     C     ZRATEX        IFGE      IPRATE
     C     ZRATEX        SUB       IPRATE        WDFXMR           13 8
     C                   ELSE
     C     IPRATE        SUB       ZRATEX        WDFXMR
     C                   ENDIF
      *
     C     ZRATEX        IFGE      IPRATE
     C     ZRATEX        ANDGT     1
     C     WWPYAM        ANDGE     WWSMAM
     C     ZRATEX        ORGE      IPRATE
     C     ZRATEX        ANDLT     1
     C     WWPYAM        ANDLE     WWSMAM
     C     ZRATEX        ORLE      IPRATE
     C     ZRATEX        ANDGT     1
     C     WWPYAM        ANDLE     WWSMAM
     C     ZRATEX        ORLE      IPRATE
     C     ZRATEX        ANDLT     1
     C     WWPYAM        ANDGE     WWSMAM
     C                   MOVE      '+'           WDMSIG            1
     C                   ELSE
     C                   MOVE      '-'           WDMSIG
     C                   ENDIF
      *
     C     ZNQDPX        ADD       1             ZA                1 0
     C     WDFXMR        MULT(H)   AP(ZA)        WDFXMP            7 2
      *
      ** Compute the maximum margin points allowed.
      ** Maximum Marg Pts = Xccy rate * Tolerance * 10**Quoted DP
      *
     C     FTTMRT        DIV       100           W1                3 2
     C     W1            MULT(H)   IPRATE        W2               13 8
     C     W2            MULT(H)   AP(ZA)        WMAXPT            7 2
      *
      ** If the Default FX Margin Points is greater than the maximum,
      ** use the maximum as the default.
      *
     C     WDFXMP        IFGT      WMAXPT
     C                   Z-ADD     WMAXPT        WDFXMP
     C                   ENDIF
      *
      ** Format Default FX Margin Points.
      *
     C                   MOVE      *Blanks       ZFIELD
     C                   MOVE      WDFXMP        ZFIELD
     C                   Z-ADD     2             ZADEC
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   MOVE      ZFIELD        SDFXMP            8
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALMGNPTS - Validation of Margin Points                    *
      *                                                               *
      *****************************************************************
      *
     C     SRValMgnPts   BEGSR
      *
      ** If FX Margin Points is not entered, default it
      *
     C     DDFXMP        IFEQ      *Blanks
      *
     C     DDMSIG        IFEQ      *BLANKS
     C                   Z-ADD     WDFXMP        WFXMP
     C                   MOVE      SDFXMP        DDFXMP
     C                   MOVE      WDMSIG        DDMSIG
     C                   MOVE      'Y'           WDeftsUsd
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If FX Margin Points is not valid, display error message
      ** "Invalid FX Margin Points entry. Must be entered with a
      ** maximum of 5 integers and 2 decimals."
      *
     C                   Z-ADD     0             WFXMP
     C                   MOVE      *Blanks       ZFIELD
      *
     C                   MOVE      DDFXMP        ZFIELD
     C                   Z-ADD     5             ZADIG
     C                   Z-ADD     2             ZADEC
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   MOVE      ZFIELD        WFXMP
      *
     C     ZALIGNok      IFEQ      'N'
     C                   MOVE      'N'           OKFXMP
     C                   ADD       1             Idx
     C                   MOVEL     'DDFXMP'      FldNamXAr(Idx)
     C                   MOVEL     'AAM0009'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If FX Margin points is valid, check if equivalent exchange
      ** rate is within the defined tolerance.
      *
     C     OKFXMP        IFNE      'N'
     C     WDeftsUsd     ANDEQ     'N'
      *
      ** If the entered margin points is greater than the maximum
      ** allowed, display warning message "Warning - Effective deal
      ** funding rate must be within tolerance level defined."
      *
     C     WFXMP         IFGT      WMAXPT
     C                   MOVE      'W'           OKFXMP
     C                   ADD       1             WIx
     C                   MOVEL     'DDFXMP'      WFldNmXAr(WIx)
     C                   MOVEL     'AAM0014'     WMsgIdXAr(WIx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALMGNPSI - Validation of Margin P/S Indicator             *
      *                                                               *
      *****************************************************************
     C     SRValMgnPSI   BEGSR
      *
      ** Validate Margin P/S Indicator.
      ** If the Margin P/S Indicator is not entered, default it.
      *
     C     DDMBSI        IFEQ      *Blanks
     C                   MOVEL     PMBSD         DDMBSI
     C                   ELSE
      *
      ** If the Margin P/S Indicator is not 'P' nor 'S', display error
      ** message "Margin P/S Indicator should be 'P' or 'S'".
      *
     C     DDMBSI        IFNE      'P'
     C     DDMBSI        ANDNE     'S'
     C                   MOVE      'N'           OKMBSI
     C                   ADD       1             Idx
     C                   MOVEL     'DDMBSI'      FldNamXAr(Idx)
     C                   MOVEL     'AAM0013'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALMGNSGN - Validation of Margin Sign                      *
      *                                                               *
      *****************************************************************
     C     SRValMgnSgn   BEGSR
      *
      ** If the Margin Sign is not entered, default it.
      *
     C     DDMSIG        IFEQ      *Blanks
     C                   MOVE      WDMSIG        DDMSIG
     C                   MOVE      'Y'           WDeftsUsd
     C                   GOTO      EMgnSgn
     C                   ENDIF
      *
      ** If the FX Margin points field has not been entered, display
      ** error message 'Margin Sign entry invalid if no FX Margin
      ** Points have been defined."
      *
     C     DDFXMP        IFEQ      *Blanks
     C                   MOVE      'N'           OKMSIG
     C                   ADD       1             Idx
     C                   MOVEL     'DDMSIG'      FldNamXAr(Idx)
     C                   MOVEL     'AAM0010'     MsgIdXAr(Idx)
     C                   GOTO      EMgnSgn
     C                   ENDIF
      *
      ** If the Margin Sign is not the same as the default, display
      ** error message "Margin Sign should be '+'/'-'".
      *
     C     DDMSIG        IFNE      WDMSIG
      *
     C     WDMSIG        IFEQ      '+'
     C                   ADD       1             Idx
     C                   MOVEL     'AAM0016'     MsgIdXAr(Idx)
     C                   ELSE
     C                   ADD       1             Idx
     C                   MOVEL     'AAM0017'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   MOVE      'N'           OKMSIG
     C                   MOVEL     'DDMSIG'      FldNamXAr(Idx)
     C                   ENDIF
      *
     C     EMgnSgn       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMAMT - Calculate Margin Amount                             *
      *                                                               *
      *****************************************************************
      *
     C     SRMAmt        BEGSR
      *
     C     WFXMP         DIV(H)    AP(ZA)        WFXMR            13 8
      *
      ** Set up factoring to adjust for decimal places.
      *
     C     DDMBSI        IFEQ      'P'
     C     ZNBDP1        SUB       ZNBDP2        ZNBDPX            1 0
     C                   ELSE
     C     ZNBDP2        SUB       ZNBDP1        ZNBDPX
     C                   ENDIF
      *
     C     ZNBDPX        IFGE      0
     C     ZNBDPX        ADD       1             ZB                1 0
     C     1             MULT      AP(ZB)        ZFACTR            7 3
     C                   ELSE
     C                   Z-SUB     ZNBDPX        ZNBDPX
     C     ZNBDPX        ADD       1             ZB
     C     1             DIV       AP(ZB)        ZFACTR
     C                   ENDIF
      *
      ** If the Margin P/S Indicator is 'P'...
      **    If the Purchase amount is greater than the sale amount and
      **            the exchage rate is greater than 1  OR
      **    If the Purchase amount is less than the sale amount and
      **            the exchage rate is less than 1  THEN
      **    the Margin amount is calculated as:
      **
      **       IMAR (Margin Amt) = SAMT (Sale amt) x MRAT (Margin rate)
      **
      **    ELSE the Margin amount is calculated as:
      **    If a profit (margin sign is '+') :
      **                            SAMT (Sale Amt)
      **       IMAR (Margin Amt) = ----------------- - PAMT (Purch Amt)
      **                              XRAT - MRAT
      **    If a loss (margin sign is '-') :
      **                                               SAMT (Sale Amt)
      **       IMAR (Margin Amt) = PAMT (Purch Amt) - -----------------
      **                                                 XRAT + MRAT
      *
     C     DDMBSI        IFEQ      'P'
      *
     C     WWPYAM        IFGT      WWSMAM
     C     IPRATE        ANDGT     1
     C     WWPYAM        ORLT      WWSMAM
     C     IPRATE        ANDLT     1
      *
     C     IPSMAM        MULT(H)   WFXMR         WMAMT            16 3
     C                   DIV(H)    ZFACTR        WMAMT
      *
     C                   ELSE
      *
     C     DDMSIG        IFEQ      '+'
     C     IPRATE        SUB       WFXMR         WRATE            13 8
     C                   ELSE
     C     IPRATE        ADD       WFXMR         WRATE
     C                   ENDIF
      *
     C     IPSMAM        DIV(H)    WRATE         WCPYAM           16 3
     C                   DIV(H)    ZFACTR        WCPYAM
      *
     C     DDMSIG        IFEQ      '+'
     C     WCPYAM        SUB       IPPYAM        WMAMT
     C                   ELSE
     C     IPPYAM        SUB       WCPYAM        WMAMT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If the Margin P/S Indicator is 'S'...
      **    If the Sale amount is greater than the purchase amount and
      **            the exchage rate is greater than 1  OR
      **    If the Sale amount is less than the purchase amount and
      **            the exchage rate is less than 1  THEN
      **    the Margin amount is calculated as:
      **
      **       IMAR (Margin Amt) = PAMT (Purc amt) x MRAT (Margin rate)
      **
      **    ELSE the Margin amount is calculated as:
      **    If a profit (margin sign is '+') :
      **                                              PAMT (Purch Amt)
      **       IMAR (Margin Amt) = SAMT (Sale Amt) - ------------------
      **                                                XRAT + MRAT
      **    If a loss (margin sign is '-') :
      **                            PAMT (Purch Amt)
      **       IMAR (Margin Amt) = ------------------ - SAMT (Sale Amt)
      **                               XRAT - MRAT
      *
     C     DDMBSI        IFEQ      'S'
      *
     C     WWSMAM        IFGT      WWPYAM
     C     IPRATE        ANDGT     1
     C     WWSMAM        ORLT      WWPYAM
     C     IPRATE        ANDLT     1
      *
     C     IPPYAM        MULT(H)   WFXMR         WMAMT
     C                   DIV(H)    ZFACTR        WMAMT
      *
     C                   ELSE
      *
     C     DDMSIG        IFEQ      '+'
     C     IPRATE        ADD       WFXMR         WRATE
     C                   ELSE
     C     IPRATE        SUB       WFXMR         WRATE
     C                   ENDIF
      *
     C     IPPYAM        DIV(H)    WRATE         WCSMAM           16 3
     C                   DIV(H)    ZFACTR        WCSMAM
      *
     C     DDMSIG        IFEQ      '+'
     C     IPSMAM        SUB       WCSMAM        WMAMT
     C                   ELSE
     C     WCSMAM        SUB       IPSMAM        WMAMT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFMTAMT - Format amount for display                         *
      *                                                               *
      *****************************************************************
     C     SRFmtAmt      BEGSR
      *
     C                   CALLB     'ZA0920'
     C                   PARM      *Blanks       P0RETC           10
     C                   PARM                    P0AMTW           13 0
     C                   PARM                    P0QECN            1 0
     C                   PARM      '.'           BNDCSP            1
     C                   PARM      *Blanks       P0AMTD           14
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCURR - Get Settlement and Pay Currencies Details           *
      *                                                               *
      *****************************************************************
     C     SRCURR        BEGSR
      *
      ** Get Settlement Currency Details.
      *
     C                   MOVE      DDSMCY        P0CURR
     C                   CALLB     'AOCURRR0'    PCURR
     C                   Z-ADD     A6NBDP        ZNBDP1            1 0
     C                   Z-ADD     A6NQDP        ZNQDP1            1 0
     C                   Z-ADD     A6SPRT        ZRATE1           13 8
     C                   MOVE      A6MDIN        ZMDI1             1
      *
      ** Get Pay Currency Details.
      *
     C                   MOVE      DDPCCY        P0CURR
     C                   CALLB     'AOCURRR0'    PCURR
     C                   Z-ADD     A6NBDP        ZNBDP2            1 0
     C                   Z-ADD     A6NQDP        ZNQDP2            1 0
     C                   Z-ADD     A6SPRT        ZRATE2           13 8
     C                   MOVE      A6MDIN        ZMDI2             1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMOVF - Calculate Pay/Settle amounts                        *
      *                                                               *
      *****************************************************************
      *
     C     SRMOVF        BEGSR
      *
     C     ZNBDP1        ADD       1             ZB
     C     IPSMAM        DIV       AP(ZB)        WWSMAM           16 3
     C     ZNBDP2        ADD       1             ZB
     C     IPPYAM        DIV       AP(ZB)        WWPYAM           16 3
      *
     C                   IF        WWSMAM >= WWPYAM
     C                   MOVE      'S'           PMBSD             1
     C                   ELSE
     C                   MOVE      'P'           PMBSD
     C                   ENDIF
      *
     C                   IF        DDACTN = 'I' and
     C                             DDMBSI = *BLANKS or
     C                             DDACTN = 'A' and
     C                             DDMBSI = *BLANKS
     C                   EVAL      DDMBSI = PMBSD
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDRAT - Get Default Cross-Currency Rate                     *
      *                                                               *
      *****************************************************************
     C     SRDRAT        BEGSR
      *
      **  Obtain cross-exchange rate between settlement and pay ccys.
      *
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1           13 8
     C                   PARM                    ZMDI1             1
     C                   PARM                    ZRATE2           13 8
     C                   PARM                    ZMDI2             1
     C                   PARM                    ZRATEX           13 8
     C                   PARM                    ZMDIX             1
      *
     C     IPRATE        IFGT      1
     C     ZRATEX        ANDLT     1
     C     IPRATE        ORLT      1
     C     ZRATEX        ANDGT     1
     C     1             DIV(H)    ZRATEX        ZRATEX
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNQDP - Get Normally-Quoted Decimal Places                  *
      *                                                               *
      *****************************************************************
     C     SRNQDP        BEGSR
      *
      ** --------------------------------------------------------------
      **  If either the settlement or pay currency is the base currency
      **  obtain the number of normally-quoted decimal places for the
      **  other currency. Otherwise:
      **      A)  If ZNQDP1 =  ZNQDP2 =  5       :   ZNQDPX = 5
      **      B)  If ZNQDP1 =  ZNQDP2 <> 5  or
      **             ZNQDP1 <> ZNQDP2
      **             1)  If Rate >= 100          :   ZNQDPX = 2
      **             2)  If 100 > Rate >= 20     :   ZNQDPX = 3
      **             3)  If 20  > Rate >= 1      :   ZNQDPX = 4
      **             4)  If 1   > Rate           :   ZNQDPX = 5
      **---------------------------------------------------------------
      *
     C                   SELECT
      *
     C     DDSMCY        WHENEQ    BNCYDL
     C                   Z-ADD     ZNQDP2        ZNQDPX            1 0
      *
     C     DDPCCY        WHENEQ    BNCYDL
     C                   Z-ADD     ZNQDP1        ZNQDPX
      *
     C     ZNQDP1        WHENEQ    ZNQDP2
     C     ZNQDP1        ANDEQ     5
     C                   Z-ADD     5             ZNQDPX
      *
     C     IPRATE        WHENEQ    100
     C                   Z-ADD     2             ZNQDPX
      *
     C     IPRATE        WHENLT    100
     C     IPRATE        ANDGE     20
     C                   Z-ADD     3             ZNQDPX
      *
     C     IPRATE        WHENLT    20
     C     IPRATE        ANDGE     1
     C                   Z-ADD     4             ZNQDPX
      *
     C     IPRATE        WHENLT    1
     C                   Z-ADD     5             ZNQDPX
      *
     C                   ENDSL
      *
     C     SRNQD9        ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ***Incoming*Payments*Lvl*2*Scrn*2*details*from*incoming*transaction       CFT014
      ***-*screen*format***********************************************         CFT014
     C*****              PARM                    NwIP4ScnFmt                    CFT014
      *                                                                         CFT014
      ** Incoming Payments Margin info screen format definition file            CFT014
     C                   PARM                    NwIP6ScnFmt                    CFT014
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode             6
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ***Incoming*Payments*Lvl*2*Scrn*2*error*indicators***************         CFT014
     C*****              PARM                    FTEIPY3                        CFT014
      ** Incoming Payments Margin Info error indicators                         CFT014
     C                   PARM                    FTEIPY5                        CFT014
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Access MIDAS Modules details via access program                                      202895
      *  (database error handling done in access program)                                     202895
     C                   CALLB     'AOMMODR0'                                                 202895
     C                   PARM      '*DBERR '     P0RTCD            7                          202895
     C                   PARM      '*FIRST '     P0OPTN            7                          202895
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        202895
      *                                                                                       202895
      **  Parameter list for program 'AOCURRR0'.
      *
     C     PCURR         PLIST
     C                   PARM      '*DBERR  '    P0RTCD            7
     C                   PARM      '*KEY    '    P0OPTN            7
     C                   PARM                    P0CURR            3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **  Parameter list for program 'AODEALR0'.
      *
     C     PDEAL         PLIST
     C                   PARM      '*DBERR  '    P0RTCD
     C                   PARM      '*FIRST  '    P0OPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      **  Parameter list for program 'AOPCACR0'.
      *
     C     PPCAC         PLIST
     C                   PARM      '*DBERR '     P0RTCD
     C                   PARM      '*FIRST '     P0OPTN
     C     SDPCAC        PARM      SDPCAC        DSFDY
      *
      **  Access Dealing ICD Details File.
      *
     C**********         CALLB     'AODEALR0'    PDEAL                                        CGL029
     C                   CALLB     'AODEALR1'    PDEAL                                        CGL029
      *
      **  Access Profit Centre Accounting details.
      *
     C     BGN0ST        IFEQ      'Y'                                                        202895
     C                   CALLB     'AOPCACR0'    PPCAC
     C                   END                                                                  202895
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
** CTDATA CPY@
(c) Finastra International Limited 2001
** CTDATA AP
0000000001
0000000010
0000000100
0000001000
0000010000
0000100000
0001000000
0010000000
0100000000
1000000000
