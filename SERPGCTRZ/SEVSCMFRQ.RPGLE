     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate compounding frequency')              *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSCMFRQ - Validate Compounding Frequency                   *
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
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 209294             Date 13Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 206957             Date 27Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 14May01               *
      *                 CAP060             Date 14May01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  209294 - Compounding Frequency should default if defined     *
      *           as zero in Investment type.                         *
      *  206957 - Division by zero error experienced on ZYIELD.       *
      *           'Compounding Frequency' should only accept 01-12.   *
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
      ** Securities screen 2 error indicators
     D SEESEC2       E DS                  EXTNAME(SEESEC2PD)
      *
      ** DS to hold coupon/rate days array
     D SCD             S              4A   DIM(12)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Parameters for ZALIGN
     D ZAlignOK        S              1A
     D ZField          S             16A
     D ZADec           S              1P 0
     D ZADig           S              2P 0
      *
      ** Work variables
     D WCmFq           S              2P 0
     D Wx              S              2P 0
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
     C                   EVAL      WCmFq = 0
 
     C                   MOVE      DDCD01        SCD(1)
     C                   MOVE      DDCD02        SCD(2)
     C                   MOVE      DDCD03        SCD(3)
     C                   MOVE      DDCD04        SCD(4)
     C                   MOVE      DDCD05        SCD(5)
     C                   MOVE      DDCD06        SCD(6)
     C                   MOVE      DDCD07        SCD(7)
     C                   MOVE      DDCD08        SCD(8)
     C                   MOVE      DDCD09        SCD(9)
     C                   MOVE      DDCD10        SCD(10)
     C                   MOVE      DDCD11        SCD(11)
     C                   MOVE      DDCD12        SCD(12)
      *
      ** Validate compounding frequency
      *
     C                   EXSR      SRValCMFrq
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKCMFQ = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        OKCMFQ <> 'N'
     C                   Z-ADD     WCmFq         S1CMFQ
     C                   ENDIF
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALCMFRQ - Validation for Compounding Frequency            *
      *                                                               *
      *****************************************************************
     C     SRValCMFrq    BEGSR
      *                                                                                       209294
     C                   IF        DDCMFQ = '00'                                              209294
     C                   MOVE      *BLANKS       DDCMFQ                                       209294
     C                   ENDIF                                                                209294
      *
      ** If blank, default compounding frequebcy to no. of coupons
      ** per year.
      *
     C                   IF        DDCMFQ = *BLANKS
     C                   Z-ADD     0             Wx
 
     C     Wx            DOWLT     12
     C                   ADD       1             Wx
 
     C                   IF        SCD(Wx) = *BLANKS
     C     Wx            SUB       1             WCmFq
     C                   MOVE      WCmFq         DDCMFQ
     C                   Z-ADD     13            Wx
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        Wx = 12 AND
     C                             SCD(Wx) <> *BLANKS
     C                   MOVE      12            DDCMFQ
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      DDCMFQ        ZField
     C                   Z-ADD     2             ZADig
     C                   Z-ADD     0             ZADec
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZAlignOK
     C                   PARM                    ZField
     C                   PARM                    ZADec
     C                   PARM                    ZADig
 
     C                   IF        ZAlignOk = 'Y'
     C                   MOVE      ZField        WCmFq
     C                   ENDIF
 
     C                   IF        ZAlignOk <> 'Y' OR
     C                             WCmFq < 1 OR WCmFq > 12
     C**********         MOVE      'N'           OKSYBS                                       206957
     C                   EVAL      OKCMFQ = 'N'                                               206957
     C                   ADD       1             IDx
     C                   MOVEL     'DDSYBS'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0219'     MsgIdXAr(IDx)
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
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
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
