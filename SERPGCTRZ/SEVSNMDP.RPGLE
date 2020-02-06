     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate nominal decimal places')             *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSNMDP - Validate Nominal Decimal Places                   *
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
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL014             Date 20Oct03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 14May01               *
      *                 CAP060             Date 14May01               *
      *                 186556             Date 07Mar01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSD006 - Market Data Feeds (recompile)                       *
      *  CAP060 - Midas APIs, Security Prices Full API (recompile)    *
      *  186556 - Replaced validation against PROT 7 & 8.             *
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
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
      ** Securities screen 1 error indicators
     D SEESEC1       E DS                  EXTNAME(SEESEC1PD)
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  186556
      ** Currency details                                                                     186556
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     186556
      ** Long Data Structure                                                                  186556
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Work parameters
     D PNMDP           S              1P 0
     D PPROT           S              1A
      *
      ** Switchable feature
     D CEU018          S              1A
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
      *
     C                   EVAL      IDx = 0
      *
      ** Default value if field is blank.
      *
     C                   IF        DDNMDP = *BLANK AND
     C                             PPROT <> '7' AND PPROT <> '8'
     C                   MOVE      *ZERO         DDNMDP
     C                   ENDIF
      *
      ** Validate nominal decimal places if feature CEU018 is present.
      *
     C                   IF        CEU018 = 'Y'
     C                   EXSR      SRValNMDP
     C                   ENDIF
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKNMDP = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        OKNMDP <> 'N'
 
     C                   SELECT
      *
      ** If processing type is '7', field must be equal to '4'.
      *
     C                   WHEN      PPROT = '7'
     C                   Z-ADD     4             S1NMDP
      *
      ** If processing type is '8', field is equal to nominal ccy's
      ** number of decimal places.
      *
     C                   WHEN      PPROT = '8'
     C                   Z-ADD     PNMDP         S1NMDP
 
     C                   OTHER
 
     C                   IF        CEU018 = 'Y'
     C                   MOVE      DDNMDP        S1NMDP
     C                   ELSE
     C                   Z-ADD     *ZERO         S1NMDP
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALNMDP - Validation for Nominal Decimal Places            *
      *                                                               *
      *****************************************************************
     C     SRValNMDP     BEGSR
      *
      ***DDNMDP*must*be*blank*for processing Types 7 or 8...                                  186556
      ** (field already protected if in amend mode )
      *
      *   Check processing type for security and if necessary default                         186556
      *   number decimal places.                                                              186556
      *                                                                                       186556
      **  Nominal decimal places - 4  if processing type = 7                                  186556
      **       - Obtain from SDCURRPD if processing type = 8                                  186556
      *                                                                                       186556
     C                   IF        PPROT = '7' OR
     C                             PPROT = '8'
 
      ** If processing type is '7', field must be equal to '4'.                               186556
      *                                                                                       186556
     C                   IF        PPROT = '7'                                                186556
     C                   Z-ADD     4             S1NMDP                                       186556
     C                   END                                                                  186556
      *                                                                                       186556
      ** If processing type is '8', field is equal to nominal ccy's                           186556
      ** number of decimal places.                                                            186556
      *                                                                                       186556
     C                   IF        PPROT = '8'                                                186556
     C                   Z-ADD     PNMDP         S1NMDP                                       186556
     C                   END                                                                  186556
                                                                                              186556
     C***********        IF        DDNMDP <> *BLANK AND                                       186556
     C***********                  DDACTN <> 'A'                                              186556
     C***********        MOVE      'N'           OKNMDP                                       186556
     C***********        ADD       1             IDx                                          186556
     C***********        MOVEL     'DDNMDP'      FldNamXAr(IDx)                               186556
     C***********        MOVEL     'SEA0139'     MsgIdXAr(IDx)                                186556
     C***********        ENDIF                                                                186556
      *
      ** else entry is optional and must be between 0 and 4.
     C                   ELSE
 
     C                   IF        DDNMDP <> *BLANK
     C                   IF        DDNMDP < '0' OR
     C                             DDNMDP > '4'
     C                   MOVE      'N'           OKNMDP
     C                   ADD       1             IDx
     C                   MOVEL     'DDNMDP'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0140'     MsgIdXAr(IDx)
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
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Nominal number of decimal places
     C                   PARM                    PNMDP
      *
      ** SWITCHABLE FEATURE
      ** ==================
      *
      ** Decimals on nominals
     C                   PARM                    CEU018
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
