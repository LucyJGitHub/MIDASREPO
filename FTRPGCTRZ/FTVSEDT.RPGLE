     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate settle date')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVSEDT  - Validate Settle Date                              *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1032299          Date 17Nov12               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 261593             Date 23Oct09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 248631             Date 23Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG7455            Date 03Jun05               *
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
      *  MD046248 - Finastra Rebranding                               *
      *  AR1032299 - System allows settle value date to be equal to   *
      *              rundate for payment type RP. Added additional    *
      *              validation such that settle value date cannot be *
      *              equal to rundate for RP. (Child: AR1032300)      *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  261593 - Default settle value date even if CFT009 is ON.     *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  248631 - No warning message for outbound FT on a holiday.    *
      *           Patterned after fix 223018 which added a new        *
      *           warning message when the date for settlement        *
      *           currency falls on a holiday.                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG7455 - Incorrect date format of :32A: in MT202 message as *
      *           fields PVDTD3/SLDTD3 are not updated properly with  *
      *           YYMMDD format if BJDFIN='M'. Pattern updating       *
      *           format of these fields from non-API program.        *
      *           Applied fix 219955.                                 *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT. (Recompiled)            *
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
 
      * Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY1PD)
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      * External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      * First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D WDATE           DS             6
     D  ODD                    1      2
     D  OMM                    3      4
     D  OYY                    5      6
 
     D                 DS
     D ZDATE                   1      6  0
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
     D WDATEL          S              7P 0
     D WDATES          S              6A
 
     D ZDATIN          S              6A
     D ZDAYNO          S              5P 0
     D ZLOC            S              3A
     D ZCCY            S              3A
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
 
      * Validate Override Flag
     C                   Exsr      VSETDAT
      *
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKOrc1 = 'N' or
     C                             OKOrbk = 'N' or
     C                             OKPydt = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   End
 
      * RETURN
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VSETDAT - SETTLE DATE VALIDATION
      *****************************************************************
     C*
     C     VSETDAT       BEGSR
 
     C                   If        SPYDT = *Blank
     C                   Eval      ZDAYNO = BJRDNB
     C                   Eval      ZDATE = @RUNN
     C**********         IF        @CFT009 = 'N'                                       CFT009 261593
     C                   Move      @RUNN         SPYDT
     C**********         ENDIF                                                         CFT009 261593
 
     C                   Else
     C                   Eval      ZERR = 'N'
      * Check date is numeric
     C                   Movel     SPYDT         WDATEL
     C                   Movel     WDATEL        WDATES
 
     C                   If        SPYDT <> WDATES
     C                   Move      'N'           OKPydt
     C                   Move      ' '           ZERR
 
     C                   Else
     C                   Eval      ZDATIN = SPYDT
     C                   Eval      @PYDT = SPYDT
 
     C                   CALLB     'ZDATE1'
     C                   Parm      SPYDT         ZDATIN
     C                   Parm      0             ZDAYNO
     C                   Parm                    BJDFIN
     C                   Parm      ' '           ZERR
     C                   Move      ZDATIN        ZDATE
 
      * The settle date must not be a holiday in local currency
     C                   Eval      ZCCY = BJLCCY
     C                   CALLB     'ZCHKH'
     C                   Parm                    ZDAYNO
     C                   Parm                    ZCCY
     C                   Parm                    ZLOC
     C                   Parm      ' '           ZHIND
 
      ** if ZHIND = 'H' then the date is a holiday - send warning
     C                   If        ZHIND = 'H'
     C                   Move      'W'           OKPydt
     C                   Add       1             WIx
     C                   Movel     'SPYDT'       WFldNmXAr(WIx)
     C**********         Movel     'MMA0970'     WMsgIdXAr(WIx)                               248631
     C                   MOVEL     'MMA3002'     WMsgIdXAr(WIx)                               248631
     C                   End
      *                                                                                       248631
      ** Warning error if date is a holiday in settle currency                                248631
      *                                                                                       248631
     C                   MOVE      SSMCY         ZCCY                                         248631
     C                   CALLB     'ZCHKH'                                                    248631
     C                   PARM                    ZDAYNO                                       248631
     C                   PARM                    ZCCY                                         248631
     C                   PARM                    ZLOC                                         248631
     C                   PARM      ' '           ZHIND                                        248631
      *                                                                                       248631
      ** if ZHIND = 'H' then the date is a holiday - send warning                             248631
      *                                                                                       248631
     C     ZHIND         IFEQ      'H'                                                        248631
     C                   MOVE      'W'           OKPydt                                       248631
     C                   ADD       1             WIx                                          248631
     C                   MOVEL     'SPYDT'       WFldNmXAr(WIx)                               248631
     C                   MOVEL     'MMA3003'     WMsgIdXAr(WIx)                               248631
     C                   ENDIF                                                                248631
 
     C                   End
     C                   End
 
     C                   If        OKPydt = 'N' or
     C                             ZERR = 'Y'
      * Send error to screen
     C                   Move      'N'           OKPydt
     C                   Add       1             Idx
     C                   Movel     'SPYDT'       FldNamXAr(Idx)
     C                   Movel     'MMA0971'     MsgIdXAr(Idx)
 
     C                   Else
     C                   If         SACTION = 'I' and
     C                              ZDAYNO < BJRDNB and
     C                              SPYTP = 'RP'
      * Send error to screen
     C                   Move      'N'           OKPydt
     C                   Add       1             Idx
     C                   Movel     'SPYDT'       FldNamXAr(Idx)
     C                   Movel     'MMA0972'     MsgIdXAr(Idx)
     C                   End
 
      *                                                                                    AR1032299
      ** Additional validation so that settlement value date cannot be                     AR1032299
      ** equal to rundate for RP.                                                          AR1032299
      *                                                                                    AR1032299
     C                   IF         SACTION = 'I' AND                                      AR1032299
     C                              ZDAYNO = BJRDNB AND                                    AR1032299
     C                              SPYTP = 'RP' OR                                        AR1032299
     C                              SACTION = 'A' AND                                      AR1032299
     C                              ZDAYNO = BJRDNB AND                                    AR1032299
     C                              SPYTP = 'RP'                                           AR1032299
      *                                                                                    AR1032299
      ** Send error to screen                                                              AR1032299
      *                                                                                    AR1032299
     C                   MOVE      'N'           OKPydt                                    AR1032299
     C                   ADD       1             Idx                                       AR1032299
     C                   MOVEL     'SPYDT'       FldNamXAr(Idx)                            AR1032299
     C                   MOVEL     '5045868'     MsgIdXAr(Idx)                             AR1032299
     C                   ENDIF                                                             AR1032299
      *                                                                                    AR1032299
     C                   Eval      @SLDTD1 = ZDATE
     C                   Eval      @SLDT = ZDAYNO
 
      * Format Date for D3
     C                   If        BJDFIN <> 'M'
     C                   Eval      OYY = ZDD
     C                   Eval      OMM = ZMM
     C                   Eval      ODD = ZYY
     C                   Else
     C**********         Eval      ODD = ZDD                                                 BUG7455
     C                   Eval      ODD = ZYY                                                 BUG7455
     C**********         Eval      OMM = ZMM                                                 BUG7455
     C                   Eval      OMM = ZDD                                                 BUG7455
     C**********         Eval      OYY = ZYY                                                 BUG7455
     C                   Eval      OYY = ZMM                                                 BUG7455
     C                   End
 
     C                   Move      WDATE         @SLDTD3
 
      * Find century
     C                   If             ZYN < 72
     C                   Eval           @SLDTD2 = 20
     C                   Else
     C                   Eval           @SLDTD2 = 19
     C                   End
     C                   End
 
      *  Check if settle date is in the future and if the
      *  account is closing today
 
     C                   If        @SLDT > BJRDNB and
     C                             @ACST3 = 'C'
      * Send error to screen
     C                   Move      'N'           OKOrc1
     C                   Add       1             Idx
     C                   Movel     'SORC1'       FldNamXAr(Idx)
     C                   Movel     'MMA0973'     MsgIdXAr(Idx)
     C                   End
      *
     C                   If        @SLDT > BJRDNB and
     C                             @ACST4 = 'C'
      * Send error to screen
     C                   Move      'N'           OKOrbk
     C                   Add       1             Idx
     C                   Movel     'SORBK'       FldNamXAr(Idx)
     C                   Movel     'MMA0974'     MsgIdXAr(Idx)
     C                   End
 
     C                   If        SPYTP <> 'RP'
 
      * For back value if retail open date will be non-zero
     C                   If        @OBOPN = 0
 
     C                   If        @OCOPN <> 0
 
     C                   If        @SLDT < @OCOPN
      * Send error to screen
     C                   Move      'N'           OKOrc1
     C                   Add       1             Idx
     C                   Movel     'SORC1'       FldNamXAr(Idx)
     C                   Movel     'MMA0975'     MsgIdXAr(Idx)
     C                   End
 
     C                   If        @SLDT < @BVLD
      * Send error to screen
     C                   Move      'N'           OKOrc1
     C                   Add       1             Idx
     C                   Movel     'SORC1'       FldNamXAr(Idx)
     C                   Movel     'MMA0976'     MsgIdXAr(Idx)
     C                   End
 
     C                   End
 
     C                   Else
     C                   If        @SLDT < @OBOPN
      * Send error to screen
     C                   Move      'N'           OKPydt
     C                   Add       1             Idx
     C                   Movel     'SPYDT'       FldNamXAr(Idx)
     C                   Movel     'MMA0977'     MsgIdXAr(Idx)
     C                   End
 
     C                   If        @SLDT < @BVLD
      * Send error to screen
     C                   Move      'N'           OKOrbk
     C                   Add       1             Idx
     C                   Movel     'SPYDT'       FldNamXAr(Idx)
     C                   Movel     'MMA0978'     MsgIdXAr(Idx)
     C                   End
 
     C                   End
     C                   End
 
     C                   If        SNDCY <> *Blanks and
     C                             @NTPSD > @SLDT
      * Send error to screen
     C                   Move      'N'           OKPydt
     C                   Add       1             Idx
     C                   Movel     'SPYDT'       FldNamXAr(Idx)
     C                   Movel     'MMA0979'     MsgIdXAr(Idx)
     C                   End
 
     C                   ENDSR
     C*
     C************************************************************
     C* END OF SETTLE DATE VALIDATION
     C************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * INPUTS
      ** Return Code
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
 
      *
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
(c) Finastra International Limited 2001
