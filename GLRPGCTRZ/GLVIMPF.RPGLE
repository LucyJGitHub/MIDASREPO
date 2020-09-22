     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate JE Item Profit Centre')              *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVIMPF    - Validate Journal Batch Entry Item               *
      *               Profit Centre                                   *
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
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL064             Date 10Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 TCA102             Date 02Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP032  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CGL064 - Associated Customer / Cost Centre Validation Changes*
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  TCA102 - Various errors on Journal Entry input (Recompile).  *
      *  CAP032 - Conversion of Journal Batch Entry inputs into       *
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
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
      ** Valid JE Item (DS) - for file update
     D PVBITP        E DS                  EXTNAME(GLVBITPPD)
      *
      ** Account details (DS)
     D F1ACCT        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(F1)
      *
      ** Externally described DS for Profit Centre details
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
      *
      ** Externally described DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** DS for Access Programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3P 0
      *
      ** Index for arrays of warning message ids, etc.
     D WIx             S              3P 0
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
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIx
      *
      ** Check if Account is existing.
      *
     C     PAccount      IFEQ      *BLANKS
     C     PAccount      OREQ      '*DIFF'
     C     PAccount      OREQ      '*CLSD'
     C                   MOVE      'Y'           PAcntFnd          1
     C                   ELSE
     C                   MOVE      *BLANKS       PAcntFnd
     C                   ENDIF
      *
      ** Validate Profit Centre.
      *
     C                   EXSR      SRProc
      *
     C     DDPrcnOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   EVAL      B2PRCN = DDPRCN
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Process Profit Centre input                         *
      *                                                               *
      *****************************************************************
      *
     C     SRProc        BEGSR
      *
      ** If Profit Centre is not blank, validate value entered.
      ** Otherwise, check if defaulting is possible.
      *
     C     DDPRCN        IFNE      *BLANKS
     C                   EXSR      SRVPrcn
     C                   ELSE
     C                   EXSR      SRCkDft
     C                   ENDIF
      *
      ** If Analytical Accounting is on and Profit Centre is
      ** still blank at this point, then issue an error.
      *
     C     BGN0ST        IFEQ      'Y'
     C     DDPRCN        ANDEQ     *BLANKS
      * Mandatory if posting is to an Expense account                                        CGL064
     C     PCGL064       OREQ      'Y'                                                       CGL064
     C     DDPRCN        ANDEQ     *BLANKS                                                   CGL064
     C     PSection      ANDEQ     'EX'                                                      CGL064
     C                   MOVE      'N'           DDPrcnOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPRCN'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0390'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPrcn - Validate Profit Centre entered                     *
      *                                                               *
      *****************************************************************
      *
     C     SRVPrCn       BEGSR
      *
      ** Check if value entered is question mark.
      *
     C     '?'           SCAN      DDPRCN                                 01
      *
      ** If value entered is '?', then error.
      *
     C     *IN01         IFEQ      *ON
     C                   MOVEL     '*ERROR '     PRTCD
     C                   ELSE
      *
      ** Else, access Profit Centre file for details.
      *
     C                   CALLB     'AOPRFCR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY'        POPTN             7
     C                   PARM      DDPRCN        PPRCN             4
     C     SDPRFC        PARM      SDPRFC        DSSDY
     C                   ENDIF
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDPrcnOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPRCN'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0182'     MsgIdXAr(Idx)
     C                   ELSE
      *
      ** Verify if Profit Centre is equal to Account Profit Centre.
      *
     C                   EXSR      SRAcPrcn
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcPrcn - Verify Profit Centre if equal to Account Profit   *
      *             Centre                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRAcPrcn      BEGSR
      *
      ** If Analytical Accounting is on, Account is found and is
      ** Retail or Nostro, issue a warning if Profit Centre
      ** entered is not equal to the Account Profit Centre.
      *
     C     BGN0ST        IFEQ      'Y'
     C     PAcntFnd      ANDEQ     'Y'
     C     B2ACTY        ANDEQ     'R'
      *
     C     BGN0ST        OREQ      'Y'
     C     PAcntFnd      ANDEQ     'Y'
     C     B2ACTY        ANDEQ     'N'
      *
     C     DDPRCN        IFNE      F1PRFC
     C                   MOVE      'W'           DDPrcnOK
     C                   ADD       1             WIx
     C                   MOVEL     'DDPRCN'      WFldNmXAr(WIx)
     C                   MOVEL     'GLX0391'     WMsgIdXAr(WIx)
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
      *  SRCkDft - Check if Profit Centre Defaulting is possible      *
      *                                                               *
      *****************************************************************
      *
     C     SRCkDft       BEGSR
      *
      ** If Default Profit Centre is used
      *
     C     BKPCDU        IFEQ      'Y'
      *
      ** If Analytical Accounting is on, Account is found and is
      ** Retail or Nostro, default Profit Centre to Account
      ** Profit Centre.
      *
     C     BGN0ST        IFEQ      'Y'
     C     PAcntFnd      ANDEQ     'Y'
     C     B2ACTY        ANDEQ     'R'
      *
     C     BGN0ST        OREQ      'Y'
     C     PAcntFnd      ANDEQ     'Y'
     C     B2ACTY        ANDEQ     'N'
      *
     C                   MOVEL     F1PRFC        DDPRCN
      *
     C                   ELSE
      *
      ** Retrieve Default Profit Centre.
      *
     C                   EXSR      SRGDflt
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
      *  SRGDflt - Get Default Profit Centre                          *
      *                                                               *
      *****************************************************************
      *
     C     SRGDflt       BEGSR
      *
      ** Set up Customer and Account Officer.
      *
     C                   EXSR      SRAcof
      *
     C                   CALL      'AOPRFMR0'
     C                   PARM                    PRETC             1
     C                   PARM      B2BKCD        PBKCD             2
     C                   PARM      B2TRTY        PPCTT             5
     C                   PARM      B2TSTY        PSBTY             2
     C                   PARM      B2IBCA        PBRCD             3
     C                   PARM      *BLANKS       PDPCD             3
     C                   PARM      PSUSER        PUSID            10
     C                   PARM                    PACOC             2
     C                   PARM                    PCUST             6
     C                   PARM      *BLANKS       PPCCD             4
      *
     C                   SELECT
      *
     C     PRETC         WHENEQ    '0'
     C                   MOVEL     PPCCD         DDPRCN
      *
     C     PRETC         WHENEQ    '1'
     C                   MOVEL     *BLANKS       DDPRCN
      *
     C     PRETC         WHENEQ    '2'
     C                   MOVEL     PPCCD         DDPRCN
     C                   MOVE      'N'           DDPrcnOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPRCN'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0182'     MsgIdXAr(Idx)
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcof - Get Account Officer                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRAcof        BEGSR
      *
      ** Use Associated Customer and its A/c Officer if Associated
      ** Customer is set up.  Otherwise, use batch Customer and
      ** its A/c Officer.
      *
     C     PCust2        IFNE      *BLANKS
     C                   MOVEL     PCust2        PCUST
     C                   MOVEL     PAcOf2        PACOC
      *
     C                   ELSE
      *
     C                   MOVEL     PCust1        PCUST
     C                   MOVEL     PAcOf1        PACOC
      *
     C     PACOC         IFEQ      *BLANKS
     C                   MOVEL     PCUST         PACNB
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM                    PACNB            10
     C                   PARM      *BLANKS       PCRST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     BBACOC        PACOC
     C                   ENDIF
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
      ** Profit Centre
     C                   PARM                    DDPRCN            4
      *
      ** Account flag
     C                   PARM                    PAccount          5
      *
      ** Customer for Profit Centre validation
     C                   PARM                    PCust1            6
      *
      ** Customer A/c Officer Code for Profit Centre validation
     C                   PARM                    PAcOf1            2
      *
      ** Associated Customer for Profit Centre validation
     C                   PARM                    PCust2            6
      *
      ** Associated Customer A/c Officer Code for Profit Centre
      ** validation
     C                   PARM                    PAcOf2            2
      *
      ** Account details (DS)
     C                   PARM                    F1ACCT
      *
      ** STANDING DATA
      ** =============
      *
      ** SDGELR - Profit Centre Defaults Used
     C                   PARM                    BKPCDU            1
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST            1
      *                                                                                      CGL064
      ** CGL064 flag                                                                         CGL064
     C                   PARM                    PCGL064           1                         CGL064
      *                                                                                      CGL064
      ** Account section                                                                     CGL064
     C                   PARM                    PSection          2                         CGL064
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Profit Centre - OK indicator
     C                   PARM                    DDPrcnOK          1
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
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
