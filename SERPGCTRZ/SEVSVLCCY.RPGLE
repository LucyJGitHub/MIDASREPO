     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate value currency')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSVLCCY - Validate Value Currency                          *
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
      ** Securities screen 1 details retrieved from file
      ** - screen format
     D CrSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
     D                                     PREFIX(O)
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
      ** Securities screen 1 error indicators
     D SEESEC1       E DS                  EXTNAME(SEESEC1PD)
      *
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
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
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     D PMode           S              6A
      *
     D PReDsp          S              1A
      *
      ** Warning array for SE0041
     D PErrs           S              3    DIM(9)
      *
      ** Work parameters
     D PVREQ           S              1A
     D PDate           S              5P 0
     D PRtcd           S              7A
     D POptn           S              7A
     D PCcy            S              3A
     D PDVCY           S              3A
     D PRate1          S             13P 8
     D PRate2          S             13P 8
     D PRateX          S             13P 8
     D PMDI1           S              1A
     D PMDI2           S              1A
     D PMDIX           S              1A
     D PNMDP           S              1P 0
     D PVLDP           S              1P 0
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
     C                   EVAL      PVLDP = 0
      *
      ** Validate value currency
      *
     C                   EXSR      SRValVLCY
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKVLCY <> 'Y'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        OKVLCY <> 'N'
 
     C                   IF        DDVLCY <> *BLANKS
     C                   MOVEL     DDVLCY        S1VLCY
     C                   Z-ADD     A6NBDP        PVLDP
     C                   ELSE
     C                   IF        OKNMCY <> 'N'
     C                   MOVEL     DDNMCY        S1VLCY
     C                   Z-ADD     PNMDP         PVLDP
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        OKNMCY <> 'N'
     C                   CALLB     'ZXRATE'
     C                   PARM                    PRATE1
     C                   PARM                    PMDI1
     C                   PARM                    PRATE2
     C                   PARM                    PMDI2
     C                   PARM      *ZEROS        PRATEX
     C                   PARM      *BLANKS       PMDIX
 
     C                   Z-ADD     PRATEX        S1SEXR
     C                   MOVE      PMDIX         S1SMDI
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALVLCY - Validation for Value Currency                    *
      *                                                               *
      *****************************************************************
     C     SRValVLCY     BEGSR
      *
      ** Default value currency if field is blank.
      *
     C                   IF        DDVLCY = *BLANKS
     C                   IF        PDVCY = *BLANKS
     C                   MOVE      DDNMCY        DDVLCY
     C                   ELSE
     C                   MOVE      PDVCY         DDVLCY
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDVLCY <> *BLANKS
      *
      ** Question mark is valid only on repair and i/c screens input.
      *
     C     '?'           SCAN      DDVLCY                                 01
 
     C                   IF        *IN01 = *ON
 
     C                   IF        PMODE = '*FRONT'
     C                   MOVE      'N'           OKVLCY
     C                   ADD       1             IDx
     C                   MOVEL     'DDVLCY'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0248'     MsgIdXAr(IDx)
     C                   MOVEL     DDVLCY        MsgDtaXAr(IDx)
     C                   GOTO      EValVLCY
     C                   ENDIF
 
     C                   EVAL      PReDsp = 'Y'
     C                   ENDIF
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDVLCY        PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtcd <> *BLANKS
 
     C                   IF        PRtcd = '*NOSEL '
     C                   EVAL      DDVLCY = *BLANKS
     C                   GOTO      EValVLCY
     C                   ENDIF
 
     C                   MOVE      'N'           OKVLCY
     C                   ADD       1             IDx
     C                   MOVEL     'DDVLCY'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0113'     MsgIdXAr(IDx)
 
     C                   ELSE
 
     C                   MOVEL     A6CYCD        DDVLCY
     C                   Z-ADD     A6SPRT        PRATE2
     C                   IF        A6MDIN = 'D'
     C                   MOVE      'D'           PMDI2
     C                   ELSE
     C                   MOVE      'M'           PMDI2
     C                   ENDIF
      *
      ** Must be a valid dealing currency
      *
     C                   IF        A6DLCI <> 'Y'
     C                   MOVE      'N'           OKVLCY
     C                   ADD       1             IDx
     C                   MOVEL     'DDVLCY'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0114'     MsgIdXAr(IDx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** If action code is amend, perform extra validation
      *
     C                   IF        CSE007 = 'Y' OR
     C                             CEU017 = 'Y'
 
     C                   IF        DDVLCY <> ODDVLCY
 
     C                   CALL      'SE0041'
     C                   PARM      'V'           PVREQ
     C                   PARM                    DDSESN
     C                   PARM      DDVLCY        PCCY
     C                   PARM      *ZEROS        PDate
     C                   PARM      *BLANKS       PErrs
 
     C     'W05'         LOOKUP    PErrs                                  01
     C                   IF        *IN01 = *ON
     C                   MOVE      'W'           OKVLCY
     C                   ADD       1             WIx
     C                   MOVEL     'DDVLCY'      WFldNmXAr(WIx)
     C                   MOVEL     'SEA0115'     WMsgIDxAr(WIx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     EValVLCY      ENDSR
 
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
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities screen 1 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Redisplay screen
     C                   PARM                    PReDsp
      *
      ** Default value currency from, PF/INVTPD
     C                   PARM                    PDVCY
      *
      ** Spot rate for nominal currency
     C                   PARM                    PRate1
      *
      ** Multiply/divide indicator for nominal currency
     C                   PARM                    PMDI1
      *
      ** Nominal currency's no. of decimal places
     C                   PARM                    PNMDP
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
     C                   Parm                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Value currency's no. of decimal places
     C                   PARM                    PVLDP
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
