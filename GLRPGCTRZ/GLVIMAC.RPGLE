     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate JE Item Account')                    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVIMAC - Validate Journal Batch Entry Item                  *
      *            Account                                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. LUC123             Date 18Jun19               *
      *  Prev Amend No. MD031707           Date 02Jul15               *
      *                 MD024136           Date 08Jan14               *
      *                 CGL135A            Date 20Sep13               *
      *                 MD000091           Date 07May13               *
      *                 AR782538           Date 03Jun11               *
      *                 CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240684             Date 26Jun06               *
      *                 240204             Date 06Jun06               *
      *                 237508             Date 23May06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG11259           Date 21Apr06               *
      *                 237621             Date 11Jan06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG2948            Date 03Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 TCA102             Date 02Apr04               *
      *                 CGL029             Date 10Mar04               *
      *                 CAP084             Date 18Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP032  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC123 - Extend Customer De-Activation to GL and LE          *
      *           Addition of hook LUC123_001                         *
      *           Addition of hook LUC123_002                         *
      *           Addition of hook LUC123_003                         *
      *           Addition of hook LUC123_004                         *
      *           Addition of hook LUC123_005                         *
      *           Addition of hook LUC123_006                         *
      *           Addition of hook LUC123_024                         *
      *  MD031707 - Review account validation type as Customer Number *
      *             may not be numeric anymore.                       *
      *  MD024136 - Accounting Rules program to default 01 to the     *
      *             account seq if blank or 00                        *
      *             Added hook: CGL135_115                            *
      *  CGL135A - Accounting Rules Process                           *
      *            Added hook: CGL135_005, CGL135_006, CGL135_007,    *
      *                        CGL135_008                             *
      *  MD000091 - Event Codes Substitution                          *
      *  AR782538 - Misleading warning message issued when accnt is   *
      *             closed. Changed to more appropriate message       *
      *             (Child: AR782539)                                 *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  240684 - Applied fix 237621. See below.                      *
      *  240204 - Issue warning message if account is flagged for      *
      *           closure in todays COB.                              *
      *  237508 - Issue warning message if the account is flagged for *
      *           closure.                                            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11259-Do not give out error message if header doesn't     *
      *           exist.  Processing for this is in UPD module        *
      *  237621 - Upgrade CGL037 Journal Entry only.
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG2948 - Check multiple branch field.                       *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  TCA102 - Various errors on Journal Entry input (Recompile).  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - If acccount number and associated front office ID   *
      *           are blanks then send an error                       *
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
      ** Accounts file by Front Office Id
     FGLAMADL0  IF   E           K DISK    INFSR(*PSSR)
                                                                                             BUG2948
      ** JE Headers file by Batch number                                                     BUG2948
     FGLJENHL1  IF   E           K DISK    INFSR(*PSSR)                                      BUG2948
     F                                     PREFIX(H_)                                        BUG2948
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
      **    False      logical = *off (for indcator processing)
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
      ** Error message array
     D WMsgArr         S             45    DIM(3) CTDATA PERRCD(1)
      *
      ** Valid JE Item (DS) - for file update
     D PVBITP        E DS                  EXTNAME(GLVBITPPD)
      *
      ** Account details (DS)
     D F1ACCT        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(F1)
      *
      ** Externally described DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Externally described DS for Account Code details
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D SDACODACCD    E                     EXTFLD(QQACCD)                                     CGL029
      *
      ** Externally described DS for Branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** Externally described DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D SDCUSTDFAC    E                     EXTFLD(QQDFAC)                                     CGL029
      *
      ** Externally described DS for Account details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
      *
      ** Externally described DS for Nostro Code details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D SDNOSTACCD    E                     EXTFLD(QQACCD)                                     CGL029
      *
      ** DS for Access Programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      /COPY WNCPYSRC,LUC123_006                                                          LUC123
      ** Work field for Account Identifier
     D WDDACID         DS            10
     D WACF6                   1      6
     D WACF3                   1      3
     D WACF1                   1      1
     D WACA1                   1      1
     D WACA2                   2      2
     D WACA3                   3      3
     D WACM2                   4      5
     D WACL5                   6     10
     D WACL4                   7     10
                                                                                              237621
      ** Data structure for data area ZMITEM                                                  237621
     D ZMITEM        E DS                  EXTNAME(ZMITEM) DTAARA(ZMITEM)                     237621
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3P 0
     D WIdx            S              3P 0                                                    240204
                                                                                              CGL029
     D W2ACCD          S             10                                                       CGL029
     D PKACOD          S             10                                                       CGL029
     D PKACCD          S             10                                                       CGL029
     D DDACCD          S             10                                                       CGL029
      *
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
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
     C                   CLEAR                   WTYPE             7
     C                   CLEAR                   WDDACID          10
     C                   MOVE      'Y'           WReplace          1
      *
      ** Reset output parameters.
      *
     C                   Z-ADD     *ZERO         PNBDP
     C                   MOVE      *BLANK        PINCY
     C                   MOVE      *BLANKS       PLCCD
     C                   MOVE      *BLANKS       PAccount
     C                   MOVE      *BLANKS       PInvAct
     C                   MOVE      *BLANKS       PCust1
     C                   MOVE      *BLANKS       PAcOf1
      *
      ** Initialize account fields
     C                   CLEAR                   F1ACCT
     C                   MOVE      X'00'         F1RETB                                      BUG2948
     C                   Z-ADD     *ZERO         F1RRNM
     C                   Z-ADD     *ZERO         F1DACO
     C                   Z-ADD     *ZERO         F1LDID
     C                   Z-ADD     *ZERO         F1LCID
                                                                                             CGL135A
      /COPY OFCPYSRCZ,CGL135_006                                                             CGL135A
      *
      ** Reset update fields.
      *
     C                   CLEAR                   W2CUST            6
     C                   CLEAR                   W2NNBI            2
     C                   CLEAR                   W2RACN           10 0
     C**********         CLEAR                   W2ACCD            4                          CGL029
     C                   CLEAR                   W2ACCD                                       CGL029
     C                   CLEAR                   W2ACSQ            2
     C                   CLEAR                   W2ACTY            1
     C                   CLEAR                   W2BCBH            3
     C                   CLEAR                   W2RRNM            5 0
     C                   MOVE      'N'           W2RNBE            1
     C                   MOVE      'N'           WHEAD             1                         BUG2948
                                                                                             BUG2948
      ** Get the batch header details                                                        BUG2948
                                                                                             BUG2948
     C     PBTNB         IFNE      *BLANKS                                                   BUG2948
     C     PBTNB         CHAIN     GLJENHL1                           22                     BUG2948
     C     *IN22         IFEQ      '0'                                                       BUG2948
     C                   MOVE      'Y'           WHEAD                                       BUG2948
     C                   ENDIF                                                               BUG2948
     C                   ENDIF                                                               BUG2948
      *
      ** Validate Account.
      *
     C                   EXSR      SRProc
      /COPY WNCPYSRC,LUC123_024                                                            LUC123
      *
     C     DDAcidOK      IFEQ      'N'
     C     DDCycdOK      OREQ      'N'
     C     DDAccdOK      OREQ      'N'
     C     DDAcsnOK      OREQ      'N'
     C     DDIbcaOK      OREQ      'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   EVAL      B2IBCA = DDIBCA
     C                   EVAL      B2CYCD = DDCYCD
     C                   EVAL      B2ACCD = DDACCD
     C                   EVAL      B2ACSN = DDACSN
      *
     C                   EVAL      B2CUST = W2CUST
     C                   EVAL      B2NNBI = W2NNBI
     C                   EVAL      B2RACN = W2RACN
     C                   EVAL      B2ACTY = W2ACTY
     C                   EVAL      B2BCBH = W2BCBH
     C                   EVAL      B2RRNM = W2RRNM
     C                   EVAL      B2RNBE = W2RNBE
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Process Account input                               *
      *                                                               *
      *****************************************************************
      *
     C     SRProc        BEGSR
      *
      ** If Account Id is blank, use Associated Front Office Id to
      ** access Accounts file.
      *
     C     DDACID        IFEQ      *BLANKS
     C                   EVAL      WTYPE = '*AFOID*'
     C                   ELSE
      *
      ** Determine the type of the entry for Account Id.
      *
     C                   EXSR      SrGetType
     C                   ENDIF
      *
      ** Validate Currency.
      *
     C                   EXSR      SRValCcy
      *
      ** Validate Account Code.
      *
     C                   EXSR      SRValAccd
      *
      ** Validate Account Sequence.
      *
     C                   EXSR      SRValAcsn
      *
      ** Validate Input Branch Code.
      *
     C                   EXSR      SRValBranch
      *
      ** Further validation of the Account.
      *
     C                   SELECT
      *
     C     WTYPE         WHENEQ    '*RETAIL'
     C                   EXSR      SRValRetail
      *
     C     WTYPE         WHENEQ    '*NOSTRO'
     C                   EXSR      SRValNostro
      *
     C     WTYPE         WHENEQ    '*CUST**'
     C                   EXSR      SRValFulAcc
      *
     C     WTYPE         WHENEQ    '*AFOID*'
     C                   EXSR      SRValAFOID
      *
     C                   OTHER
      *
      ** If A/c Id in error, set Account flag to '*ACID'.
      *
     C                   MOVEL     '*ACID'       PAccount
      *
     C                   ENDSL
      *
      ** Check if Journal Entry Non-Retail is selected                                        237621
                                                                                              237621
     C     CGL037        IFEQ      'Y'                                                        237621
     C     DDACID        ANDNE     *BLANKS                                                    237621
                                                                                              237621
     C                   IN        ZMITEM                                                     237621
     C                   IF        INDX = '0000002745'                                        237621
      *                                                                                       237621
      ** Retrieve and validate Account details.                                               237621
      *                                                                                       237621
     C                   EXSR      SRResetKey                                                 237621
     C                   MOVEL     DDACID        PKCUST                                       237621
     C                   MOVEL     DDCYCD        PKCYCD                                       237621
     C                   MOVEL     DDACCD        PKACCD                                       237621
     C                   MOVEL     DDACSN        PKACSN                                       237621
     C                   MOVEL     DDIBCA        PKBRCD                                       237621
                                                                                              237621
     C                   EXSR      SrAcAcct                                                   237621
                                                                                              237621
      ** If it is a retail account then error.                                                237621
                                                                                              237621
     C     PRTCD         IFEQ      *BLANKS                                                    237621
     C     ATYP          ANDEQ     'R'                                                        237621
                                                                                              237621
     C     STYP          IFNE      'V'                                                        237621
     C     STYP          ANDNE     'I'                                                        237621
     C                   MOVE      'N'           DDAcidOK                                     237621
     C                   ADD       1             Idx                                          237621
     C                   MOVEL     'DDACID'      FldNamXAr(Idx)                               237621
     C                   MOVEL     'USR9841'     MsgIdXAr(Idx)                                237621
     C                   ENDIF                                                                237621
                                                                                              237621
     C                   ENDIF                                                                237621
     C                   ENDIF                                                                237621
     C                   ENDIF                                                                237621
                                                                                              237621
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGetType - Determine the type of the entry for Account Id   *
      *                                                               *
      *****************************************************************
      *
     C     SrGetType     BEGSR
      *
     C                   MOVE      DDACID        WDDACID
      *
      ** Check for retail account identifier.
      *
     C                   TESTN                   WDDACID              01
     C     *IN01         IFEQ      *ON
     C                   EVAL      WTYPE = '*RETAIL'
      *
     C                   goto      ESrGetType
     C                   ENDIF
      *
      ** Check for nostro.
      *
     C                   TESTN                   WACM2                01
     C     *IN01         IFEQ      *ON
     C     WACA1         ANDLT     '0'
     C     WACA2         ANDLT     '0'
     C     WACA3         ANDLT     '0'
     C     WACF3         ANDNE     *BLANKS
     C     WACL5         ANDEQ     *BLANKS
     C                   EVAL      WTYPE  = '*NOSTRO'
     C                   MOVEL     DDACID        DDCYCD
      *
     C                   goto      ESrGetType
     C                   ENDIF
      *
      ** Check for customer number.
      *
     C**********         TESTN                   WACF6                01                    MD031707
     C******IN01         IFEQ      *ON                                                      MD031707
     C     WACF6         IFNE      *BLANK                                                   MD031707
     C     WACL4         ANDEQ     *BLANK
     C                   EVAL      WTYPE = '*CUST**'
      *
     C                   goto      ESrGetType
     C                   ENDIF
      *
      ** Check for a question mark.
      *
     C     '?'           SCAN      DDACID                                 01
      *
      ** Check for customer shortname.
      *
     C     *IN01         IFEQ      *OFF
     C     WACF1         ANDLT     '0'
     C     WACF1         ANDNE     *BLANK
     C                   EVAL      WTYPE = '*CUST**'
      *
     C                   goto      ESrGetType
     C                   ENDIF
      *
      ** Error if entry is a question mark or other than the
      ** above.  Tag the Account Id as error and save first
      ** 6 characters of the Account Id.
      *
     C                   MOVE      'N'           DDAcidOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACID'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0119'     MsgIdXAr(Idx)
      *
     C                   EVAL      WTYPE = '*ERROR*'
     C                   MOVEL     DDACID        W2CUST
      *
     C     ESrGetType    ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValCcy - Validate Currency                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRValCcy      BEGSR
      *
     C                   Z-ADD     *ZERO         PNBDP
     C                   MOVE      *BLANK        PINCY
      *
     C     DDCYCD        IFEQ      *BLANKS
      *
      ** Field is mandatory if account identifier is a customer.
      *
     C     WTYPE         IFEQ      '*CUST**'
     C                   MOVE      'N'           DDCycdOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCYCD'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0123'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ELSE
      *
     C     '?'           SCAN      DDCYCD                                 01
      *
      ** Question mark has been entered.
      *
     C     *IN01         IFEQ      *ON
     C                   MOVE      'N'           DDCycdOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCYCD'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0999'     MsgIdXAr(Idx)
     C**********         MOVEL     WMsgArr(1)    MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(WMsgArr(1)))                           MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WMsgArr(1))               MD000091
     C                   ELSE
      *
      ** If not question mark, verify if Currency exists in file.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      DDCYCD        PKCCY             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDCycdOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCYCD'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0048'     MsgIdXAr(Idx)
     C                   ELSE
     C                   MOVE      A6NBDP        PNBDP
     C                   MOVE      A6INCY        PINCY
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValAccd - Validate Account Code                            *
      *                                                               *
      *****************************************************************
      *
     C     SRValAccd     BEGSR
      *
     C                   MOVE      *BLANK        W2ACTY
      *
     C     DDACCD        IFEQ      *BLANKS
      *
      ** Field is mandatory if account identifier is a customer.
      *
     C     WTYPE         IFEQ      '*CUST**'
     C                   MOVE      'N'           DDAccdOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACCD'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0124'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   TESTN                   DDACCD               01
     C     '?'           SCAN      DDACCD                                 02
      *
      ** Entry is not a 4-digit input or question mark
      ** has been entered.
      *
     C     *IN01         IFEQ      *OFF
     C     *IN02         OREQ      *ON
     C                   MOVE      'N'           DDAccdOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACCD'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0999'     MsgIdXAr(Idx)
     C**********         MOVEL     WMsgArr(2)    MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(WMsgArr(2)))                           MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WMsgArr(2))               MD000091
     C                   ELSE
      *
      ** Verify if Account Code exists.
      *
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C**********         PARM      DDACCD        PKACOD            4                          CGL029
     C                   PARM      DDACCD        PKACOD                                       CGL029
     C     SDACOD        PARM      SDACOD        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDAccdOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACCD'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0046'     MsgIdXAr(Idx)
     C                   ELSE
     C                   MOVE      A5ACTY        W2ACTY
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValAcsn - Validate Account Sequence                        *
      *                                                               *
      *****************************************************************
      *
     C     SRValAcsn     BEGSR
      *
      ** Field is mandatory if account identifier is a customer.
      *
     C     DDACSN        IFEQ      *BLANKS
     C     WTYPE         ANDEQ     '*CUST**'
     C                   MOVE      'N'           DDAcsnOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACSN'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0125'     MsgIdXAr(Idx)
      /COPY OFCPYSRCZ,CGL135_115                                                            MD024136
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValBranch - Validate Branch                                *
      *                                                               *
      *****************************************************************
      *
     C     SRValBranch   BEGSR
      *
      ** If system is single-branching, default Input Branch Code
      ** and Header Branch to Bank's Single Branch Code.
      *
     C     BJSBRC        IFNE      *BLANKS
     C                   EVAL      DDIBCA = BJSBRC
     C                   EVAL      W2BCBH = BJSBRC
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       PLCCD
      *
     C     DDIBCA        IFEQ      *BLANKS
      *
      ** Field is mandatory if account identifier is a customer.
      *
     C     WTYPE         IFEQ      '*CUST**'
     C                   MOVE      'N'           DDIbcaOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIBCA'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0201'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ELSE
      *
     C     '?'           SCAN      DDIBCA                                 01
      *
      ** Question mark has been entered.
      *
     C     *IN01         IFEQ      *ON
     C                   MOVE      'N'           DDIbcaOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIBCA'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0999'     MsgIdXAr(Idx)
     C**********         MOVEL     WMsgArr(3)    MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(WMsgArr(3)))                           MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WMsgArr(3))               MD000091
     C                   ELSE
      *
      ** If not question mark, access Branch Codes file.
      *
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDIBCA        PKIBCA            3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDIbcaOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIBCA'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0045'     MsgIdXAr(Idx)
     C                   ELSE
     C                   MOVE      A8LCCD        PLCCD
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
                                                                                             BUG2948
      ** Batch header must be multi-branch                                                   BUG2948
      ** OR no batch header found                                                            BUG2948
                                                                                             BUG2948
     C     PACTN         IFEQ      'I'                                                       BUG2948
     C     WHEAD         ANDEQ     'Y'                                                       BUG2948
     C     DDIBCA        ANDNE     *BLANKS                                                   BUG2948
     C     DDIBCA        ANDNE     H_BRBCDA                                                  BUG2948
     C     H_BRMBRB      ANDNE     'Y'                                                       BUG2948
                                                                                             BUG2948
     C*****PACTN         OREQ      'I'                                              BUG2948 BUG11259
     C*****WHEAD         ANDEQ     'N'                                              BUG2948 BUG11259
                                                                                             BUG2948
     C                   MOVE      'N'           DDIbcaOK                                    BUG2948
     C                   ADD       1             Idx                                         BUG2948
     C                   MOVEL     'DDIBCA'      FldNamXAr(Idx)                              BUG2948
     C                   MOVEL     'GLX004A'     MsgIdXAr(Idx)                               BUG2948
     C                   ENDIF                                                               BUG2948
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValRetail - Validate Retail Account                        *
      *                                                               *
      *****************************************************************
      *
     C     SRValRetail   BEGSR
      *
      ** Save Retail details.
      *
     C                   MOVEL     DDACID        W2RACN
     C                   MOVE      'Y'           W2RNBE
      *
      ** Retrieve and validate Account details.
      *
     C                   EXSR      SRResetKey
     C                   MOVE      DDACID        PKACID
     C                   EXSR      SrActDtls
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValNostro - Validate Nostro Code                           *
      *                                                               *
      *****************************************************************
      *
     C     SRValNostro   BEGSR
      *
      ** Save Nostro Number.
      *
     C                   MOVE      WACM2         W2NNBI
      *
      ** Retrieve Nostro details.
      *
     C                   EXSR      SRResetKey
     C                   MOVE      DDCYCD        PKCYCD
     C                   MOVE      WACM2         PKNONB
     C                   EXSR      SRAcNost
      *
     C     PRTCD         IFNE      *BLANKS
      *
      ** Nostro code not existing, set Account flag to no record found.
      *
     C                   MOVEL     '*NRFD'       PAccount
      *
      **---------------------------------------------------------------
      ** Nostro code is not existing.  If CEU013 is on and
      ** In Currency, then only a warning.  Warning is
      ** considered as a real error.
      **---------------------------------------------------------------
      *
     C     CEU013        IFEQ      'Y'
     C     PINCY         ANDEQ     'Y'
      *
      ** Issue warning message for the non-existing Nostro.
      *
     C                   MOVE      'N'           DDAcidOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACID'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0410'     MsgIdXAr(Idx)
      *
      **---------------------------------------------------------------
      ** Nostro code is not existing.  If CEU013 is not on or
      ** not In Currency, then issue an error.
      **---------------------------------------------------------------
      *
     C                   ELSE
      *
      ** Issue error message for the non-existing Nostro.
      *
     C                   MOVE      'N'           DDAcidOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACID'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0065'     MsgIdXAr(Idx)
      *
     C                   ENDIF
     C                   ENDIF
      *
      **---------------------------------------------------------------
      ** Process further the Nostro if it is existing.
      **---------------------------------------------------------------
      *
     C     PRTCD         IFEQ      *BLANKS
      *
      ** Retrieve and validate Account details.
      *
     C                   EXSR      SRResetKey
     C                   MOVEL     A7CUST        PKCUST
     C                   MOVEL     A7CYCD        PKCYCD
     C                   MOVEL     A7ACCD        PKACCD
     C                   MOVEL     A7ACSN        PKACSN
     C                   MOVEL     A7BRCD        PKBRCD
     C                   EXSR      SrActDtls
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValFulAcc - Validate full Account                          *
      *                                                               *
      *****************************************************************
      *
     C     SRValFulAcc   BEGSR
      *
      ** Save Customer.
      *
     C                   MOVEL     DDACID        W2CUST
      *
      ** Check if valid Customer.
      *
      /COPY WNCPYSRC,LUC123_004                                                          LUC123
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDACID        PCUST            10
     C                   PARM      *BLANKS       PKYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      /COPY WNCPYSRC,LUC123_005                                                          LUC123
      *
     C     PRTCD         IFNE      *BLANKS
     C     PKYST         OREQ      '*ERROR '
     C                   MOVE      'N'           DDAcidOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACID'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0084'     MsgIdXAr(Idx)
     C                   ELSE
      /COPY WNCPYSRC,LUC123_001                                                          LUC123
     C                   MOVEL     *BLANKS       DDACID
     C                   MOVEL     BBCUST        DDACID
     C                   MOVEL     BBCUST        W2CUST
     C                   MOVEL     BBCUST        PCust1
     C                   MOVEL     BBACOC        PAcOf1
      /COPY WNCPYSRC,LUC123_003                                                          LUC123
     C                   ENDIF
      *
     C     DDAcidOk      IFEQ      'Y'
     C     DDCycdOk      ANDEQ     'Y'
     C     DDAccdOk      ANDEQ     'Y'
     C     DDAcsnOk      ANDEQ     'Y'
     C     DDIbcaOk      ANDEQ     'Y'
      *
      ** Retrieve and validate Account details.
      *
     C                   EXSR      SRResetKey
     C                   MOVEL     DDACID        PKCUST
     C                   MOVEL     DDCYCD        PKCYCD
     C                   MOVEL     DDACCD        PKACCD
     C                   MOVEL     DDACSN        PKACSN
     C                   MOVEL     DDIBCA        PKBRCD
     C                   EXSR      SRActDtls
      *
     C                   ELSE
      *
      ** Set Account flag to invalid.
      *
     C                   MOVEL     '*INVD'       PAccount
      *
      ** However, if A/c Id is not in error and one of the ffg.
      ** field is blank: Currency, A/c Code, A/c Seq and Input
      ** Branch Code, set Account flag to incomplete.
      ** (This will be used in the validation of Associated
      ** Customer.)
      *
     C     DDAcidOk      IFEQ      'Y'
      *
     C     DDCYCD        IFEQ      *BLANKS
     C     DDACCD        OREQ      *BLANKS
     C     DDACSN        OREQ      *BLANKS
     C     DDIBCA        OREQ      *BLANKS
     C                   MOVEL     '*INCP'       PAccount
     C                   ENDIF
      *
      ** Set account identifier to 'N'
     C                   MOVEL     'N'           DDAcidok
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
      *  SRActDtls - Validate Account details                         *
      *                                                               *
      *****************************************************************
      *
     C     SRActDtls     BEGSR
      *
      ** Retrieve Account details.
      *
     C                   EXSR      SrAcAcct
      *
     C     PRTCD         IFNE      *BLANKS
      *
      ** Account not existing, set account flag to no record found.
      *
     C                   MOVEL     '*NRFD'       PAccount
      *
      **---------------------------------------------------------------
      ** Account is not existing.  If CEU013 is on, In Currency, and
      ** Account is a Retail or a Nostro, then only a warning.
      ** Warning is considered as a real error.
      **---------------------------------------------------------------
      *
     C     CEU013        IFEQ      'Y'
     C     PINCY         ANDEQ     'Y'
     C     W2ACTY        ANDEQ     'R'
      *
     C     CEU013        OREQ      'Y'
     C     PINCY         ANDEQ     'Y'
     C     W2RNBE        ANDEQ     'Y'
      *
     C     CEU013        OREQ      'Y'
     C     PINCY         ANDEQ     'Y'
     C     W2ACTY        ANDEQ     'N'
      *
     C     CEU013        OREQ      'Y'
     C     PINCY         ANDEQ     'Y'
     C     W2NNBI        ANDNE     *BLANKS
      *
      ** Issue warning message for the non-existing Account.
      *
     C                   MOVE      'N'           DDAcidOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACID'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0407'     MsgIdXAr(Idx)
      *
      ** If A/c Id entry is a Retail A/c No. and is not existing,
      ** set Invalid Account flag to '*RETAIL'.
      *
     C     WTYPE         IFEQ      '*RETAIL'
     C                   MOVE      '*RETAIL'     PInvAct
     C                   ENDIF
      *
      ** If A/c Id entry is a Nostro and is not existing,
      ** set Invalid Account flag to '*NOSTRO'.
      *
     C     WTYPE         IFEQ      '*NOSTRO'
     C                   MOVE      '*NOSTRO'     PInvAct
     C                   ENDIF
      *
      **---------------------------------------------------------------
      ** Account is not existing.  If CEU013 is not on or not
      ** In Currency, or Account is not a Retail and not a
      ** Nostro, then issue an error.
      **---------------------------------------------------------------
      *
     C                   ELSE
                                                                                             CGL135A
      /COPY OFCPYSRCZ,CGL135_007                                                             CGL135A
      *
      ** Issue error message for the non-existing Account.
      *
     C                   MOVE      'N'           DDAcidOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACID'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0054'     MsgIdXAr(Idx)
      *
      /COPY OFCPYSRCZ,CGL135_008                                                             CGL135A
                                                                                             CGL135A
     C                   ENDIF
     C                   ENDIF
      *
      **---------------------------------------------------------------
      ** Process further the Account if it is existing.
      **---------------------------------------------------------------
      *
     C     PRTCD         IFEQ      *BLANKS
      *
      ** Save Account details.
      *
     C                   MOVEL     SDACCT        F1ACCT
      *
      ** Set up update fields.
      *
     C                   MOVE      CNUM          W2CUST
     C                   MOVEL     ACNO          W2RACN
     C                   MOVE      RRNM          W2RRNM
     C                   MOVEL     ATYP          W2ACTY
      *
      ** Move account code and account sequence to character variables
      *
     C                   MOVEL     ACOD          W2ACCD
     C                   MOVEL     ACSQ          W2ACSQ
      *
      ** Get Nostro details if A/c Id entry is other than
      ** a Nostro.
      *
     C     WTYPE         IFNE      '*NOSTRO'
     C                   EXSR      SRResetKey
     C                   MOVE      CNUM          PKCUST
     C                   MOVE      CCY           PKCYCD
     C                   MOVE      ACOD          PKACCD
     C                   MOVE      ACSQ          PKACSN
     C                   MOVE      BRCA          PKBRCD
     C                   EXSR      SRAcNost
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     A7NONB        W2NNBI
     C                   ENDIF
     C                   ENDIF
      *
      ** Check if there are differences between file and input
      ** fields if A/c Id entry is a Retail A/c No. or a
      ** Nostro code.
      *
     C     WTYPE         IFEQ      '*RETAIL'
     C     WTYPE         OREQ      '*NOSTRO'
     C                   EXSR      SRFileDif
     C                   ENDIF
      *
     C     ACST          IFEQ      'C'
     C     DACC          ANDLT     BJRDNB
      *
      ** Account closed, set Account flag as closed.
      *
     C                   MOVEL     '*CLSD'       PAccount
      *
      ** Account is closed.  If CEU013 is on, In Currency, and
      ** Account is a Retail or a Nostro, then only a warning.
      ** Warning is considered as a real error.
      *
     C     CEU013        IFEQ      'Y'
     C     PINCY         ANDEQ     'Y'
     C     W2ACTY        ANDEQ     'R'
      *
     C     CEU013        OREQ      'Y'
     C     PINCY         ANDEQ     'Y'
     C     W2ACTY        ANDEQ     'N'
      *
     C                   MOVE      'N'           DDAcidOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACID'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0409'     MsgIdXAr(Idx)
      *
     C                   ELSE
      *
      ** Issue error message for the closed Account.
      *
     C                   MOVE      'N'           DDAcidOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACID'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0126'     MsgIdXAr(Idx)
      *
     C                   ENDIF
     C                   ENDIF
      *                                                                                       237508
     C     ACST          IFEQ      'C'                                                        237508
     C     RECI          ANDEQ     'D'                                                        237508
     C     DACC          ANDEQ     BJRDNB                                                     237508
     C                   ADD       1             Idx                                          237508
     C                   MOVE      'N'           DDAcidOK                                     237508
     C                   MOVEL     'DDACID'      WFldNmXAr(Idx)                               237508
     C**********         MOVEL     'GLX0427'     WMsgIDXAr(Idx)                      237508 AR782538
     C                   MOVEL     'GLX0409'     WMsgIDXAr(Idx)                             AR782538
     C                   ENDIF                                                                237508
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValAFOID - Validate Account using Associated Front Office  *
      *               Id                                              *
      *                                                               *
      *****************************************************************
      *
     C     SrValAFOID    BEGSR
      *
      ** Retrieve Account details.
      *
     C     APFOAsocID    IFNE      *BLANKS                                                    CAP084
     C     APFOAsocId    CHAIN     GLAMADL0                           01
     C                   ELSE                                                                 CAP084
     C                   MOVE      *ON           *IN01                                        CAP084
     C                   ENDIF                                                                CAP084
      *
     C     *IN01         IFEQ      *ON
      *
      ** Account not existing, set account flag to no record found.
      *
     C                   MOVEL     '*NRFD'       PAccount
      *
      **---------------------------------------------------------------
      ** Account is not existing.  If CEU013 is on, In Currency, and
      ** Account is a Retail or a Nostro, then only a warning.
      ** Warning is considered as a real error.
      **---------------------------------------------------------------
      *
     C     CEU013        IFEQ      'Y'
     C     PINCY         ANDEQ     'Y'
     C     W2ACTY        ANDEQ     'R'
      *
     C     CEU013        OREQ      'Y'
     C     PINCY         ANDEQ     'Y'
     C     W2ACTY        ANDEQ     'N'
      *
      ** Issue warning message for the non-existing Account.
      *
     C                   MOVE      'N'           DDAcidOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACID'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0407'     MsgIdXAr(Idx)
      *
      **---------------------------------------------------------------
      ** Account is not existing.  If CEU013 is not on or not
      ** In Currency, or Account is not a Retail and not a
      ** Nostro, then issue an error.
      **---------------------------------------------------------------
      *
     C                   ELSE
      *
      ** Issue error message for the non-existing Account.
      *
     C                   MOVE      'N'           DDAcidOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACID'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0054'     MsgIdXAr(Idx)
      *
     C                   ENDIF
     C                   ENDIF
      *
      **---------------------------------------------------------------
      ** Process further the Account if it is existing.
      **---------------------------------------------------------------
      *
     C     *IN01         IFEQ      *OFF
      *
      ** Save Account details.
      *
     C                   MOVEL     SDACCT        F1ACCT
      *
      ** Set up update fields.
      *
     C                   MOVE      CNUM          W2CUST
     C                   MOVEL     ACNO          W2RACN
     C                   MOVE      RRNM          W2RRNM
     C                   MOVEL     ATYP          W2ACTY
      *
      ** Move account code and account sequence to character variables
      *
     C                   MOVEL     ACOD          W2ACCD
     C                   MOVEL     ACSQ          W2ACSQ
      *
      ** Get Nostro details.
      *
     C                   EXSR      SRResetKey
     C                   MOVE      CNUM          PKCUST
     C                   MOVE      CCY           PKCYCD
     C                   MOVE      ACOD          PKACCD
     C                   MOVE      ACSQ          PKACSN
     C                   MOVE      BRCA          PKBRCD
     C                   EXSR      SRAcNost
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     A7NONB        W2NNBI
     C                   ENDIF
      *
      ** Check if there are differences between file and input
      ** fields.
      *
     C                   EXSR      SRFileDif
      *
     C     ACST          IFEQ      'C'
     C     DACC          ANDLT     BJRDNB
      *
      ** Account closed, set Account flag as closed.
      *
     C                   MOVEL     '*CLSD'       PAccount
      *
      ** Account is closed.  If CEU013 is on, In Currency, and
      ** Account is a Retail or a Nostro, then only a warning.
      ** Warning is considered as a real error.
      *
     C     CEU013        IFEQ      'Y'
     C     PINCY         ANDEQ     'Y'
     C     W2ACTY        ANDEQ     'R'
      *
     C     CEU013        OREQ      'Y'
     C     PINCY         ANDEQ     'Y'
     C     W2ACTY        ANDEQ     'N'
      *
     C                   MOVE      'N'           DDAcidOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACID'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0409'     MsgIdXAr(Idx)
      *
     C                   ELSE
      *
      ** Issue error message for the closed Account.
      *
     C                   MOVE      'N'           DDAcidOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACID'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0126'     MsgIdXAr(Idx)
      *
     C                   ENDIF
     C                   ENDIF
      ** Account flagged for closure today, issue a warning message                           240204
     C     ACST          IFEQ      'C'                                                        240204
     C     DACC          ANDEQ     BJRDNB                                                     240204
     C                   Eval      DDAcidOK = 'W'                                             240204
     C                   Add       1             WIdx                                         240204
     C                   Eval      WFldNmXAr(WIdx) = 'DDACID'                                 240204
     C                   Eval      WMsgIDXAr(WIdx) = 'GLX0409'                                240204
     C                   ENDIF                                                                240204
                                                                                              240204
      *
     C                   ENDIF
      *
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFileDif - Check if there are differences between file      *
      *              and input fields                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRFileDif     BEGSR
      *
     C     DDCYCD        IFNE      *BLANKS
     C     DDCYCD        ANDNE     CCY
     C     DDACCD        ORNE      *BLANKS
     C     DDACCD        ANDNE     W2ACCD
     C     DDACSN        ORNE      *BLANKS
     C     DDACSN        ANDNE     W2ACSQ
     C     DDIBCA        ORNE      *BLANKS
     C     DDIBCA        ANDNE     BRCA
      *
      ** CEU013 if on and In currency, and Account is a Retail
      ** or a Nostro, then only a warning.  Warning is
      ** considered as a real error.
      *
     C     CEU013        IFEQ      'Y'
     C     PINCY         ANDEQ     'Y'
     C     W2ACTY        ANDEQ     'R'
      *
     C     CEU013        OREQ      'Y'
     C     PINCY         ANDEQ     'Y'
     C     W2ACTY        ANDEQ     'N'
      *
     C                   MOVE      'N'           DDAcidOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACID'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0407'     MsgIdXAr(Idx)
      *
     C                   ELSE
      *
      ** Issue error message.
      *
     C                   MOVE      'N'           DDAcidOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACID'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0054'     MsgIdXAr(Idx)
     C                   MOVE      'N'           WReplace
      *
      ** Account details are different from input details,
      ** set Account flag to *DIFF'.
      *
     C                   MOVEL     '*DIFF'       PAccount
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Override input fields with file fields.
      *
     C     WReplace      IFEQ      'Y'
      *
      ** Save A/c Customer for Profit Centre validation.
      *
     C                   MOVEL     CNUM          PCust1
      *
     C     DDACSN        IFNE      W2ACSQ
     C                   MOVE      ACSQ          DDACSN
     C                   ENDIF
      *
     C     DDCYCD        IFNE      CCY
     C                   MOVE      CCY           DDCYCD
     C                   EXSR      SRValCcy
     C                   ENDIF
      *
     C     DDACCD        IFNE      W2ACCD
     C                   MOVE      ACOD          DDACCD
     C                   EXSR      SRValAccd
     C                   ENDIF
      *
     C     DDIBCA        IFNE      BRCA
     C                   MOVE      BRCA          DDIBCA
     C                   EXSR      SRValBranch
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
      *  SRAcAcct - Call access object for Account details            *
      *                                                               *
      *****************************************************************
      *
     C     SRAcAcct      BEGSR
      *
     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKACID
     C                   PARM                    PKCUST
     C                   PARM                    PKCYCD
     C                   PARM                    PKACCD
     C                   PARM                    PKACSN
     C                   PARM                    PKBRCD
     C     SDACCT        PARM      SDACCT        DSSDY
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcNost - Call access object for Nostro details             *
      *                                                               *
      *****************************************************************
      *
     C     SRAcNost      BEGSR
      *
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKCUST
     C                   PARM                    PKCYCD
     C                   PARM                    PKACCD
     C                   PARM                    PKACSN
     C                   PARM                    PKNONB
     C                   PARM                    PKBRCD
     C                   PARM                    PKUCSN
     C                   PARM                    PKPNOI
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetKey - Reset access object fields                      *
      *                                                               *
      *****************************************************************
      *
     C     SRResetKey    BEGSR
      *
     C                   CLEAR                   PKACID           10
     C                   CLEAR                   PKCUST            6
     C                   CLEAR                   PKCYCD            3
     C**********         CLEAR                   PKACCD            4                          CGL029
     C                   CLEAR                   PKACCD                                       CGL029
     C                   CLEAR                   PKACSN            2
     C                   CLEAR                   PKBRCD            3
     C                   CLEAR                   PKNONB            2
     C                   CLEAR                   PKUCSN           10
     C                   CLEAR                   PKPNOI            1
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
      ** Associated Front Office Id
     C                   PARM                    APFOAsocId       20
      *
      ** Account Identifier
     C                   PARM                    DDACID           10
      *
      ** Currency Code
     C                   PARM                    DDCYCD            3
      *
      ** Account Code
     C**********         PARM                    DDACCD            4                          CGL029
     C                   PARM                    DDACCD                                       CGL029
      *
      ** Account Sequence
     C                   PARM                    DDACSN            2
      *
      ** Input Branch Code
     C                   PARM                    DDIBCA            3
                                                                                             BUG2948
      ** Batch number                                                                        BUG2948
     C                   PARM                    PBTNB             3                         BUG2948
                                                                                             BUG2948
      ** Action Code                                                                         BUG2948
     C                   PARM                    PACTN             1                         BUG2948
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB            5 0
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC            3
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU Account Posting Narrative feature
     C                   PARM                    CEU013            1
                                                                                              237621
      ** Account Access Security                                                              237621
     C                   PARM                    CGL037            1                          237621
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Error fields/message IDs/message data (arrays) from/to caller                        240204
     C                   PARM                    WFldNmXAr                                    240204
     C                   PARM                    WMsgIDXAr                                    240204
     C                   PARM                    WMsgDtXAr                                    240204
     C                   PARM                    WIdx                                         240204
      *
      ** Account Identifier - OK indicator
     C                   PARM                    DDAcidOK          1
      *
      ** Currency Code - OK indicator
     C                   PARM                    DDCycdOK          1
      *
      ** Account Code - OK indicator
     C                   PARM                    DDAccdOK          1
      *
      ** Account Sequence - OK indicator
     C                   PARM                    DDAcsnOK          1
      *
      ** Branch Code - OK indicator
     C                   PARM                    DDIbcaOK          1
      *
      ** In Currency flag
     C                   PARM                    PINCY             1
      *
      ** No. of Decimal Places
     C                   PARM                    PNBDP             1 0
      *
      ** Branch Location Code
     C                   PARM                    PLCCD             3
      *
      ** Account flag
     C                   PARM                    PAccount          5
      *
      ** Invalid account flag
     C                   PARM                    PInvAct           7
      *
      ** Customer for Profit Centre validation
     C                   PARM                    PCust1            6
      *
      ** Customer A/c Officer Code for Profit Centre validation
     C                   PARM                    PAcOf1            2
      *
      ** Account details (DS)
     C                   PARM                    F1ACCT
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
                                                                                             CGL135A
      /COPY OFCPYSRCZ,CGL135_005                                                             CGL135A
      *
      /COPY WNCPYSRC,LUC123_002                                                          LUC123
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
(c) Misys International Banking Systems Ltd. 2001
** WMsgArr
Invalid Currency entered.
Invalid Account Code entered.
Invalid Branch Code entered.
