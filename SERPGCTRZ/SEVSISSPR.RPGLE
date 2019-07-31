     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate issue price')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSISSPR - Validate Issue Price                             *
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
      *                 CSD027             Date 09Dec05               *
      *                 234675             Date 05Jul05               *
      *                 233903             Date 02Jun05               *
      *                 232543             Date 22Mar05               *
      *                 CGL031             Date 05Jul04               *
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
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  234675 - Change control for processing type 4 and Dividend   *
      *           EU tax calculation (Recompile).                     *
      *  233903 - Issue Fiscal Price is mandatory and must not be     *
      *           equal to zero.                                      *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
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
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     D NwSE3ScnFmt   E DS                  EXTNAME(SESEC3PD)
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
      ** Securities Screen 3 error indicators
     D SEESEC3       E DS                  EXTNAME(SEESEC3PD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Parameters for module ZALIGN
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D ZALIGNok        S              1A
      *
      ** Work variable for Issue Price
     D WIssPr          S             15P 8
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
     D CGL031          S              1A                                                      CGL031
                                                                                              CGL031
      ** Processing type                                                                      CGL031
     D PPROT           S              1A                                                      CGL031
                                                                                              232543
      ** Subject to European Tax                                                              232543
     D DDSETX          S              1A                                                      232543
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
     C                   EVAL      Idx = 0
     C                   Z-ADD     *ZEROS        WIssPr
      *
      ** Validate issue price.
      *
     C                   EXSR      SRValIssPrc
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKISSP = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        OKISSP <> 'N'
     C                   Z-ADD     WIssPr        S1ISSP
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValIssPrc - Validation for Issue Price                     *
      *                                                               *
      *****************************************************************
 
     C     SRValIssPrc   BEGSR
 
      ** When taxation of savings income is on, Issue price must not                          CGL031
      ** be blank.                                                                            CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y' AND                                           CGL031
     C                             DDISSP = *Blanks                                           CGL031
     C                   IF        PPROT <> '2' AND                                           CGL031
     C                             PPROT <> '4' AND                                           CGL031
     C**********                   PPROT <> '7'                                        CGL031 232543
     C                             PPROT <> '7' AND                                           232543
     C                             DDSETX = 'Y'                                               232543
     C                   MOVE      'N'           OKISSP                                       CGL031
     C                   ADD       1             Idx                                          CGL031
     C                   MOVEL     'DDISSP'      FldNamXAr(Idx)                               CGL031
     C                   MOVEL     'SEA0902'     MsgIdXAr(Idx)                                CGL031
     C                   ENDIF                                                                CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDISSP        ZFIELD
     C                   Z-ADD     7             ZADIG
     C                   Z-ADD     8             ZADEC
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
     C                   IF        ZALIGNok = 'N'
     C                   MOVE      'N'           OKISSP
     C                   ADD       1             Idx
     C                   MOVEL     'DDISSP'      FldNamXAr(Idx)
     C                   MOVEL     'SEA0102'     MsgIdXAr(Idx)
 
     C                   ELSE
     C                   MOVE      ZFIELD        WIssPr
     C                   ENDIF
                                                                                              233903
     C                   IF        OKISSP <> 'N'                                              233903
                                                                                              233903
     C                   IF        WIssPr = *ZERO AND                                         233903
     C                             CGL031 = 'Y' AND                                           233903
     C                             PPROT <> '2' AND                                           233903
     C                             PPROT <> '4' AND                                           233903
     C                             PPROT <> '7' AND                                           233903
     C                             DDSETX = 'Y'                                               233903
     C                   MOVE      'N'           OKISSP                                       233903
     C                   ADD       1             Idx                                          233903
     C                   MOVEL     'DDISSP'      FldNamXAr(Idx)                               233903
     C                   MOVEL     'SEA0914'     MsgIdXAr(Idx)                                233903
     C                   ENDIF                                                                233903
                                                                                              233903
     C                   ENDIF                                                                233903
 
     C                   ENDSR
 
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
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *                                                                                       232543
      ** Subject to EU Tax                                                                    232543
     C                   PARM                    DDSETX                                       232543
      *
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
                                                                                              CGL031
      ** SWITCHABLE FEATURES                                                                  CGL031
      ** ===================                                                                  CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
                                                                                              CGL031
      ** Processing type, from PF/INVTPD                                                      CGL031
     C                   PARM                    PPROT                                        CGL031
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities Screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
