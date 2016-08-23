     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate JE Item Associated Customer')        *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVIMCS - Validate Journal Batch Entry Item                  *
      *            Associated Customer                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD000091           Date 07May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. 243965             Date 23Nov06               *
      *                 242224             Date 28Oct06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL064             Date 19Jun06               *
      *                 CSD031             Date 10Apr06               *
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
      *  MD000091 - Event Codes Substitution                          *
      *  243965 - Do not compare associated customer number with      *
      *           customer number if System Val GLJRNECmpAssCust = 'N'*
      *  242224 - Associated Customer number corrupted                *
      *  CGL064 - Associated Customer / Cost Centre Validation Changes*
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
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
     D CmpAssCust      S              1A   IMPORT                                             243965
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
      ** Error message array
     D WMsgArr         S             45    DIM(1) CTDATA PERRCD(1)
      *
      ** Valid JE Item (DS) - for file update
     D PVBITP        E DS                  EXTNAME(GLVBITPPD)
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
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D MsgDtaTmp                     99                                                     MD000091
      *                                                                                     MD000091
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
      *
     C                   MOVE      *BLANKS       PCust2
     C                   MOVE      *BLANKS       PAcOf2
      *
      ** Validate Associated Customer.
      *
     C                   EXSR      SRProc
      *
     C     DDAcnbOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   EVAL      B2ACNB = DDACNB
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Process Associated Customer input                   *
      *                                                               *
      *****************************************************************
      *
     C     SRProc        BEGSR
      *
     C     DDACNB        IFNE      *BLANKS
      *
      ** Check if value entered is question mark.
      *
     C     '?'           SCAN      DDACNB                                 01
      *
     C     *IN01         IFEQ      *ON
     C                   MOVE      '*ERROR '     PRTCD
     C                   ELSE
      *
      ** Check if valid Customer.
      *
     C                   MOVE      *BLANKS       PACNB                                        242224
     C                   MOVEL     DDACNB        PACNB
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM                    PACNB            10
     C                   PARM      *BLANKS       PKYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
     C                   ENDIF
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDAcnbOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACNB'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0198'     MsgIdXAr(Idx)
     C                   ELSE
      *
     C                   MOVE      *BLANKS       DDACNB                                       242224
     C                   MOVEL     BBCUST        DDACNB
      *
      ** Compare Associated Customer with A/c Customer only
      ** if Account is acceptable and there are no non-
      ** overrideable RE/GL errors, or A/c Customer is
      ** acceptable and A/c details entered are
      ** incomplete (i.e. one of the following fields
      ** is blank: Ccy, A/c Code, A/c Seq and Input Branch
      ** Code).
      *
     C     PAccount      IFEQ      *BLANKS
     C     POVERRIDE     ANDEQ     *BLANKS
     C     PAccount      OREQ      '*INCP'
      *
     C     B2CUST        IFEQ      BBCUST
     C     CmpAssCust    ANDNE     'N'                                                        243965
     C                   MOVE      'N'           DDAcnbOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACNB'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0999'     MsgIdXAr(Idx)
     C**********         MOVEL     WMsgArr(1)    MsgDtaXAr(Idx)                             MD000091
     C**********         MOVEL     BBCUST        MsgDtaXAr(Idx)                             MD000091
     C                   MOVEL     WMsgArr(1)    MsgDtaTmp                                  MD000091
     C                   MOVEL     BBCUST        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
      *
     C                   ELSE
      *
      ** Save Associated Customer and Customer A/c Officer
      ** for Profit Centre validation.
      *
     C                   MOVEL     BBCUST        PCust2
     C                   MOVEL     BBACOC        PAcOf2
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE                                                                CGL064
     C     PCGL064       IFEQ      'Y'                                                       CGL064
      *                                                                                      CGL064
      * Mandatory if posting is to an Income account                                         CGL064
     C     DDACNB        IFEQ      *BLANKS                                                   CGL064
     C     PSection      ANDEQ     'IN'                                                      CGL064
     C                   MOVE      'N'           DDAcnbOK                                    CGL064
     C                   ADD       1             Idx                                         CGL064
     C                   MOVEL     'DDACNB'      FldNamXAr(Idx)                              CGL064
     C                   MOVEL     'CGL0025'     MsgIdXAr(Idx)                               CGL064
     C                   ENDIF                                                               CGL064
      *                                                                                      CGL064
     C                   ENDIF                                                               CGL064
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
      ** Associated Customer
     C                   PARM                    DDACNB           10
      *
      ** Account flag
     C                   PARM                    PAccount          5
      *
      ** Non-overrideable flag
     C                   PARM                    POverride         1
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
      ** Associated Customer - OK indicator
     C                   PARM                    DDAcnbOK          1
      *
      ** Associated Customer for Profit Centre validation
     C                   PARM                    PCust2            6
      *
      ** Associated Customer A/c Officer Code for Profit Centre
      ** validation
     C                   PARM                    PAcOf2            2
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
** CPY@
(c) Misys International Banking Systems Ltd. 2001
** WMsgArr
XXXXXX Ass. Cust. cant be eq to Account Cust.
