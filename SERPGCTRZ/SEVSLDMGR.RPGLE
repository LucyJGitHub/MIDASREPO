     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate lead manager')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSLDMGR - Validate Lead Manager                            *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSCTL                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
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
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
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
      ** Externally described DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Externally described DS for Securities Clients details
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for Access Objects - very long data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Parameters for module AOSECSR0
     D PRtcd           S              7A
     D POptn           S              7A
     D PKey            S              6A
      *
      ** Parameters for AOCUSTR1
     D PKey1           S             10A
     D PKeyst          S              7A
      *
      ** Mode of processing
     D PMode           S              6A
      *
      ** Redisplay screen indicator
     D PReDsp          S              1A
      *
      ** Work variable for Lead Manager
     D*WLdMgr***       S              6P 0                                                    CSD027
     D WLdMgr          S              6A                                                      CSD027
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
     C**********         Z-ADD     *ZEROS        WLdMgr                                       CSD027
     C                   EVAL      WLdMgr = *BLANKS                                           CSD027
      *
      ** Validate lead manager.
      *
     C                   EXSR      SRValLdMgr
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKLMGR = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        OKLMGR <> 'N'
     C**********         Z-ADD     WLdMgr        S1LMGR                                       CSD027
     C                   EVAL      S1LMGR = WLdMgr                                            CSD027
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValLdMgr - Validation for Lead Manager                     *
      *                                                               *
      *****************************************************************
 
     C     SRValLdMgr    BEGSR
 
     C                   IF        DDLMGR <> *BLANKS
      *
      ** Check if question mark is entered.
      *
     C     '?'           SCAN      DDLMGR                                 01
 
     C                   IF        *IN01 = *ON
      *
      ** Question mark is valid only on repair and i/c screens input.
      *
     C                   IF        PMode = '*FRONT'
     C                   MOVE      'N'           OKLMGR
     C                   ADD       1             Idx
     C                   MOVEL     'DDLMGR'      FldNamXAr(Idx)
     C                   MOVEL     'SEA0103'     MsgIdXAr(Idx)
     C                   GOTO      EValLdMgr
     C                   ENDIF
 
     C                   EVAL      PReDsp = 'Y'
 
     C                   CALLB     'AOSECSR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDLMGR        PKey
     C     SDSECS        PARM      SDSECS        DSSDY
 
     C                   EVAL      DDLMGR = *BLANKS
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      DDLMGR = *BLANKS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDLMGR        PKey1
     C                   PARM      *BLANKS       PKeyst
     C     SDCUST        PARM      SDCUST        DSLDY
 
     C                   IF        PRtCd <> *BLANKS
     C                   MOVE      'N'           OKLMGR
     C                   ADD       1             Idx
     C                   MOVEL     'DDLMGR'      FldNamXAr(Idx)
     C                   MOVEL     'SEA0103'     MsgIdXAr(Idx)
     C                   ELSE
     C                   MOVEL     BBCUST        WLdMgr
     C                   ENDIF
 
     C                   ENDIF
 
     C     EValLdMgr     ENDSR
 
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
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (Screen input function)
      ** Mode = '*RPR  ' (Repair function)
     C                   PARM                    PMode
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
      ** Redisplay screen flag
     C                   PARM                    PReDsp
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
(c) Misys International Banking Systems Ltd. 2001
