     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate next payment date')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVNXPY  - Validate Next Payment Date                        *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. CFT120             Date 28Sep12
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 AR702741           Date 02Feb11               *
      *                 CRE067             Date 05Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 06Jul06               *
      *                 CGL014             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 CFT007             Date 23Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CAP031  *CREATE    Date 06Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.  (Recompiled)           *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CFT007 - Recompiled for BIC Database Plus Integration        *
      *  CFT004 - Recompiled for IBAN (International Bank A/C No.)    *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
 
      ** Array of Warning in error.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of Warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of Warning message data.
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY1PD)
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      * External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for General Ledger ICD Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      * First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D#DATE            DS             6
     D ODD                     1      2
     D OMM                     3      4
     D OYY                     5      6
     D                 DS
     D WZDATE                  1      6  0
     D  ZDD                    1      2
     D  ZMM                    3      4
     D  ZYY                    5      6
     D  ZYN                    5      6  0
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
 
      * This prog only
     D WDATE           S              6P 0
     D ZDATIN          S              6A
     D ZDAYNO          S              5P 0
     D ZDATE           S              6P 0
     D ZADATE          S              7A
     D ZLOC            S              3A
     D ZCCY            S              3A
     D ZFREQ           S              1A
     D ZMDAY           S              2P 0
     D ZERR            S              1A
     D ZHIND           S              1A
 
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
 
     C                   Eval      RetCodeIn = *Blanks
     C                   Eval      FldNamXAr = *Blanks
     C                   Eval      MsgIDXAr  = *Blanks
     C                   Eval      MsgDtaXAr = *Blanks
     C                   Eval      WFldNmXAr = *Blanks
     C                   Eval      WMsgIDXAr  = *Blanks
     C                   Eval      WMsgDtaXAr = *Blanks
     C                   Eval      Idx = 0
     C                   Eval      WIx = 0
 
      * Validate Final Payment date
     C                   Exsr      VNXTDAT
      *
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKNdat = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   End
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VNXTDAT - NEXT PAYMENT DATE VALIDATION
      *****************************************************************
     C*
     C* MANDATORY IF REGULAR PAYMENT
     C* IF  BLANK  AND AN INSERT, DEFAULTS TO SETTLE DATE IF
     C* THIS IS GREATER THAN THE RUN DATE; THE RUN DATE PLUS
     C* ONE WORKING DAY IN THE SETTLE CURRENCY OTHERWISE.
     C* THE NEXT PAYMENT DATE MUST BE GREATER THAN THE RUN DATE
     C* AND LESS THAN THE FINAL DATE.
     C*
     C*
     C     VNXTDAT       BEGSR
 
     C                   If        SPYTP = 'RP'
 
     C                   If        SNDAT = *Blanks or
     C                             SNDAT = *All'0'
 
     C                   If        SACTION = 'I'
     C                   Eval      SNDAT = SPYDT
 
      *  Next payment date not set up if settle value date blank and
      *  pay value date entered
     C                   If        @SLDT <= BJRDNB
     C                   Eval      ZDAYNO =  BJRDNB
     C                   Eval      ZCCY = SSMCY
     C                   Eval      ZFREQ = 'D'
 
     C                   CALLB     'ZFREQB'
     C                   Parm      ' '           ZERR
     C                   Parm                    ZFREQ
     C                   Parm                    ZDAYNO
     C                   Parm                    ZCCY
     C                   Parm                    ZLOC                                       AR702741
     C                   Parm                    ZMDAY
     C                   Parm                    BJDFIN
     C     SDGELR        Parm                    SDGELR
 
     C                   Eval      @NPDT = ZDAYNO
 
     C                   CALLB     'ZDATE2'
     C                   Parm                    ZDAYNO
     C                   Parm                    BJDFIN
     C                   Parm                    ZDATE
     C                   Parm                    ZADATE
 
     C                   Eval      @NPDTD1 = ZDATE
     C                   Eval      WZDATE = ZDATE
 
      * Format Date
     C                   If        BJDFIN <> 'M'
     C                   Eval      OYY = ZDD
     C                   Eval      OMM = ZMM
     C                   Eval      ODD = ZYY
     C                   Else
     C                   Eval      OMM = ZDD
     C                   Eval      OYY = ZMM
     C                   Eval      ODD = ZYY
     C                   End
 
     C                   Move      #DATE         WDATE
     C                   Eval      @NPDTD3 = WDATE
 
     C                   If        ZYN < 72
     C                   Eval      @NPDTD2 = 20
     C                   Else
     C                   Eval      @NPDTD2 = 19
     C                   End
 
     C                   Else
     C                   Eval      @NPDT = @SLDT
     C                   Eval      @NPDTD1 = @SLDTD1
     C                   Eval      @NPDTD2 = @SLDTD2
     C                   Eval      @NPDTD3 = @SLDTD3
     C                   End
     C*
     C                   Move      @NPDTD1       SNDAT
 
     C                   Else
      * Send error to screen
     C                   Move      'N'           OKNdat
     C                   Add       1             Idx
     C                   Movel     'SNDAT'       FldNamXAr(Idx)
     C                   Movel     'MMA1005'     MsgIdXAr(Idx)
     C                   End
 
      * If date not blank
     C                   Else
     C                   Eval      @NDAT = SNDAT
 
     C                   CALLB     'ZDATE1'
     C                   Parm      SNDAT         ZDATIN
     C                   Parm      0             ZDAYNO
     C                   Parm                    BJDFIN
     C                   Parm      'N'           ZERR
 
      * The next payment date must not be a holiday in local currency
     C                   Eval      ZCCY = BJLCCY
     C                   CALLB     'ZCHKH'
     C                   Parm                    ZDAYNO
     C                   Parm                    ZCCY
     C                   Parm      @PLOC         ZLOC
     C                   Parm      ' '           ZHIND
      *
      *
      ** if ZHIND = 'H' then the date is a holiday
     C*
     C                   If        ZHIND = 'H'
     C                   Move      'W'           OKNdat
     C                   Add       1             WIx
     C                   Movel     'SNDAT'       WFldNmXAr(WIx)
     C                   Movel     'MMA1006'     WMsgIdXAr(WIx)
     C                   End
 
     C                   If        ZERR = 'Y'
      * Send error to screen
     C                   Move      'N'           OKNdat
     C                   Add       1             Idx
     C                   Movel     'SNDAT'       FldNamXAr(Idx)
     C                   Movel     'MMA1007'     MsgIdXAr(Idx)
 
     C                   Else
     C                   If        ZDAYNO <= BJRDNB or
     C                             ZDAYNO > @FDAT
      * Send error to screen
     C                   Move      'N'           OKNdat
     C                   Add       1             Idx
     C                   Movel     'SNDAT'       FldNamXAr(Idx)
     C                   Movel     'MMA1008'     MsgIdXAr(Idx)
     C                   End
     C                   End
 
     C                   If        OKNdat <> 'N'
 
     C                   Move      ZDATIN        ZDATE
     C                   Eval      @NPDTD1 = ZDATE
     C                   Eval      WZDATE = ZDATE
     C                   Eval      @NPDT = ZDAYNO
 
      * Format Date for D3
     C                   If        BJDFIN <> 'M'
     C                   Eval      OYY = ZDD
     C                   Eval      OMM = ZMM
     C                   Eval      ODD = ZYY
     C                   Else
     C                   Eval      OMM = ZDD
     C                   Eval      OYY = ZMM
     C                   Eval      ODD = ZYY
     C                   End
 
     C                   Move      #DATE         WDATE
     C                   Eval      @NPDTD3 = WDATE
 
      * Find Century
     C                   If        ZYN < 72
     C                   Eval      @NPDTD2 = 20
     C                   Else
     C                   Eval      @NPDTD2 = 19
     C                   End
     C                   End
     C                   End
 
      * If this is a non-regular payment, Next Payment date must be blank
     C                   Else
     C                   If        SPYTP = 'OP'
     C                   If        SNDAT <> *Blanks and
     C                             SNDAT <> *All'0'
      * Send error to screen
     C                   Move      'N'           OKNdat
     C                   Add       1             Idx
     C                   Movel     'SNDAT'       FldNamXAr(Idx)
     C                   Movel     'MMA1009'     MsgIdXAr(Idx)
 
     C                   Else
     C                   Clear                   @NPDT
     C                   Clear                   @NPDTD1
     C                   Clear                   @NPDTD2
     C                   Clear                   @NPDTD3
      *
     C                   End
 
     C                   End
     C                   End
 
     C                   ENDSR
     C*
     C************************************************************
     C* END OF NEXT PAYMENT DATE VALIDATION
     C************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeIn
 
      *  Screen fields
     C                   Parm                    TranInPrim
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtaXAr
 
      *  OK Flags
     C                   Parm                    OKFlagsDS
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
 
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** =================================================================
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
