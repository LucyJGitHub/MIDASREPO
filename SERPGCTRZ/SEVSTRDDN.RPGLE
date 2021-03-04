     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate trade denomination')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSTRDDN - Validate Trade Denomination                      *
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
      *                 CSE071             Date 19Jul05               *
      *                 CGL014             Date 20Oct03               *
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
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL014 - Collaterals Processing (Recompile)                  *
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
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
      *
      ** Securities screen 1 details retrieved from file - screen format
     D CrSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
     D                                     PREFIX(O)
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
      ** Securities screen 1 error indicators
     D SEESEC1       E DS                  EXTNAME(SEESEC1PD)
      *
     D WADNM           S              1    DIM(7)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
     D Wx              S              3P 0
      *
      ** Parameters for ZALIGN
     D ZalignOk        S              1A
     D ZField          S             16A
     D ZADec           S              1P 0
     D ZADig           S              2P 0
      *
      ** Work variable
     D WSDNM           S              7P 0
     D PPROT           S              1A
     D PDTRD           S              7P 0
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
     C                   Z-ADD     *ZEROS        WSDNM
      *
      ** Validate trade denimination
      *
     C                   EXSR      SRValSDNM
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKSDNM = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF

     C                   IF        OKSDNM <> 'N'
     C                   Z-ADD     WSDNM         S1SDNM
     C                   ENDIF

     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALSDNM - Validation for Trade Denomination                *
      *                                                               *
      *****************************************************************
     C     SRValSDNM     BEGSR

     C                   IF        DDSDNM = *BLANKS AND
     C                             (DDINCS = 'C' AND ODDINCS = 'I' OR
     C                             DDINCS = 'C' AND DDACTN = 'I') AND
     C                             PDTRD <> *ZEROS

     C                   MOVE      PDTRD         DDSDNM
     C                   MOVEA     DDSDNM        WADNM
      *
      ** Exclude leading zeros
     C                   Z-ADD     1             Wx
     C                   DOW       Wx < 8 AND (WADNM(Wx) =  ' ' OR
     C                             WADNM(Wx) =  '0')
     C                   EVAL      WADNM(Wx) = ' '
     C                   EVAL      Wx = Wx + 1
     C                   ENDDO

     C                   MOVEA     WADNM         DDSDNM
     C                   ENDIF

     C                   IF        DDSDNM <> *BLANKS
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      DDSDNM        ZField
     C                   Z-ADD     7             ZADig
     C                   Z-ADD     *ZERO         ZADec

     C                   CALLB     'ZALIGN'
     C                   PARM                    ZalignOk
     C                   PARM                    ZField
     C                   PARM                    ZADec
     C                   PARM                    ZADig

     C                   IF        ZalignOk <> 'Y'
      *
      ** The entry is not a valid amount
     C                   MOVE      'N'           OKSDNM
     C                   ADD       1             IDx
     C                   MOVEL     'DDSDNM'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0250'     MsgIdXAr(IDx)
     C                   ELSE
     C                   MOVE      ZField        WSDNM
     C                   ENDIF
      *
      ** Cannot be process if processing type is '7' or '8'
     C                   IF        PPROT = '7' OR PPROT = '8'
     C                   MOVE      'N'           OKSDNM
     C                   ADD       1             IDx
     C                   MOVEL     'DDSDNM'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0251'     MsgIdXAr(IDx)
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
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities screen 1 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Default trade denomination
     C                   PARM                    PDTRD
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
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
