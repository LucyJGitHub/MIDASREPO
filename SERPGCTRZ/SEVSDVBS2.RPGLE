     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate divisor basis 2')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSDVBS2 - Validate Divisor Basis 2                         *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSCTL                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 14May01               *
      *                 CAP060             Date 14May01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE074 - Const. Yld Amort. Upgrade to MidasPlus (Recompile)  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSD006 - Market Data Feeds (recompile)                       *
      *  CAP060 - Midas APIs, Security Prices Full API (recompile)    *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
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
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     D NwSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
      ** Securities retreved from file - file format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
      *
      ** Securities screen 2 error indicators
     D SEESEC2       E DS                  EXTNAME(SEESEC2PD)
      *
      ** Warning array for SE0041
     D PErrs           S              3    DIM(9)
      *
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
      ** Parameteres for SE0041
     D PVREQ           S              1A
     D PDate           S              5P 0
     D PCcy            S              3A
      *
     D PCpnRt          S             15P 0
      *
      ** Switchable features
     D CSE007          S              1A
     D CEU017          S              1A
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
      ** Initialise work variables.
     C                   EVAL      IDx = 0
     C                   EVAL      WIx = 0
      *
      ** Validate divisor basis 2
      *
     C                   EXSR      SRValDivBs
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKDVBS2 <> 'Y'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        OKDVBS2 <> 'N'
     C                   MOVE      DDDVBS2       S1DVBS
     C                   ENDIF
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALDIVBS - Validation for Divisor Basis 2                  *
      *                                                               *
      *****************************************************************
     C     SRValDivBs    BEGSR
 
     C                   IF        DDDVBS2 = *BLANKS
 
     C                   IF        S1INCS = 'C' AND
     C                             DDDYBS2 <> *ZEROS
     C                   MOVE      'N'           OKDVBS2
     C                   ADD       1             IDx
     C                   MOVEL     'DDDVBS2'     FldNamXAr(IDx)
     C                   MOVEL     'SEA0169'     MsgIdXAr(IDx)
     C                   ENDIF
      *
      ** Zero coupon bonds with yield basis of 'DA' or 'A' are possible
      ** if the day basis is NOT '4' and the divisor basis IS specified
      *
     C                   IF        PCpnRt = *ZEROS
 
     C                   IF        DDSYBS = 'DA' OR
     C                             DDSYBS = 'A '
     C                   MOVE      'N'           OKDVBS2
     C                   ADD       1             IDx
     C                   MOVEL     'DDDVBS2'     FldNamXAr(IDx)
     C                   MOVEL     'SEA0170'     MsgIdXAr(IDx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        DDDVBS2 <> '1' AND
     C                             DDDVBS2 <> '2' AND
     C                             DDDVBS2 <> '3' AND
     C                             DDDVBS2 <> '5'
     C                   MOVE      'N'           OKDVBS2
     C                   ADD       1             IDx
     C                   MOVEL     'DDDVBS2'     FldNamXAr(IDx)
     C                   MOVEL     'SEA0171'     MsgIdXAr(IDx)
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Zero coupon yield based securities are only possible if the
      ** yield basis is 'DA' or 'A'
      *
     C                   IF        PCpnRt = *ZEROS AND
     C                             S1STBS = 'Y' AND
     C                             DDSYBS <> 'DA' AND
     C                             DDSYBS <> 'A' AND
     C                             DDSYBS <> 'AU'
     C                   MOVE      'N'           OKDVBS2
     C                   ADD       1             IDx
     C                   MOVEL     'DDDVBS2'     FldNamXAr(IDx)
     C                   MOVEL     'SEA0172'     MsgIdXAr(IDx)
     C                   ENDIF
      *
      ** If day basis or divisor basis is amended, additional check
      *
     C                   IF        CSE007 = 'Y' OR
     C                             CEU017 = 'Y'
     C                   IF        DDDYBS2 <> DYBS AND
     C                             DDDYBS2 <> *BLANKS OR
     C                             DDDVBS2 <> DVBS AND
     C                             DDDVBS2 <> *BLANKS
     C                   CALL      'SE0041'
     C                   PARM      'B'           PVREQ
     C                   PARM                    S1SESN
     C                   PARM      *BLANKS       PCCY
     C                   PARM      LCPN          PDate
     C                   PARM      *BLANKS       PErrs
 
     C     'W06'         LOOKUP    PErrs                                  01
     C                   IF        *IN01 = *ON
     C                   MOVE      'W'           OKDVBS2
     C                   ADD       1             WIx
     C                   MOVEL     'DDDVBS2'     WFldNmXAr(WIx)
     C                   MOVEL     'SEA0173'     WMsgIDxAr(WIx)
     C                   ENDIF
 
     C     'W07'         LOOKUP    PErrs                                  01
     C                   IF        *IN01 = *ON
     C                   MOVE      'W'           OKDVBS2
     C                   ADD       1             WIx
     C                   MOVEL     'DDDVBS2'     WFldNmXAr(WIx)
     C                   MOVEL     'SEA0174'     WMsgIDxAr(WIx)
     C                   ENDIF
 
     C     'W08'         LOOKUP    PErrs                                  01
     C                   IF        *IN01 = *ON
     C                   MOVE      'W'           OKDVBS2
     C                   ADD       1             WIx
     C                   MOVEL     'DDDVBS2'     WFldNmXAr(WIx)
     C                   MOVEL     'SEA0175'     WMsgIDxAr(WIx)
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
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
      *
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
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Securities retreved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Coupon rate
     C                   PARM                    PCpnRt
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Corporate actions
     C                   PARM                    CSE007
      *
      ** Securities redenomination
     C                   PARM                    CEU017
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
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
**  CPY@
(c) Finastra International Limited 2001
