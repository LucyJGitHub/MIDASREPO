     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/deposits display')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMLDNIDSP - LOANS/DEPOSITS & NAS ISSUED DISPLAY              *
      *                                                               *
      *  Function:  This module displays the main details screen      *
      *             of the loans and deposits screen input function.  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 23Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23926           Date 07May09               *
      *                 CER020             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CDL038             Date 10May05               *
      *                 203502             Date 25Sep02               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS005             Date 16Dec02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 208051             Date 02Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 197015             Date 18Jan02               *
      *                 CAS001             Date 23Nov01               *
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 03Apr00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006             Date 07May99               *
      *                 CDL007             Date 05Oct99               *
      *                 CPB001             Date 02Sep99               *
      *                 CGL011             Date 20Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 22Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23926 - Implementation Issues (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CDL038 - Extended Deal Sub Type                              *
      *  203502 - Interest settlement account is not correct          *
      *           Recompiled due to change of DSPF MMLDNIDDF          *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
      *           (Recompile)                                         *
      *  CDL016 - Autumatic Rollover of Fixed Term Loan/Deposit       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  208051 - Recompiled over chnged MMLDNIDDF display file.      *
      *  197015 - Reverse order of sending out messages in the input  *
      *           maintenance screen: Warning message first before    *
      *           confirmation message MMM1030.                       *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  CAP067 - Repurchase Agreements API.                          *
      *  CDE002 - Revenue Analysis                                    *
      *  CSE006 - Repurchase Agreement Enhancements                   *
      *  CDL007 - Deposit Breakdown Penalty                           *
      *  CPB001 - 'Private Banking' Module                            *
      *  CGL011 - Collateral Processing for Midas                     *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FMMLDNIDDF CF   E             WORKSTN
     F/COPY WNCPYSRC,MMH00126
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *                                                               *
      ********66**Deposit*Breakdown*Penalty*not*installed**************                CDL007 CAS001
      ********67**Collateral Status field displayed********************                CGL011 CAS005
      *       93  Collateral Status field displayed                   *                       CAS005
      ********68**Position cursor on action code (if it is blank)******                       CAS005
      *       94  Position cursor on action code (if it is blank)     *                       CAS005
      ********69**Protect deal key fields (action code & deal number) *                       CDL038
      *       08  Extended Deal Sub Type not installed                *                       CDL038
      *       09  Protect deal key fields (action code & deal number) *                       CDL038
      *       70  Protect deal detail fields                          *
      *       71  Enable CF07                                         *
      *       72  Enable CF08                                         *
      *       73  Enable CF10                                         *
      *       74  Enable CF14                                         *
      *       75  Enable CF15                                         *
      *       76  Enable CF19                                         *
      *       78  Repos on                                            *                       CSE006
      *       79  Highlight deal status                               *
      *                                                               *
      *       80  Not multibranching                                  *
      *       81  Originating branch not used                         *
      *       82  Profit centres not used                             *
      *       83  Portfolio management not installed                  *
      *       84  Australian Brokerage not installed                  *
      *       85  Securities Trading module not installed (repo)      *
      *       86  Enhanced rollover not installed                     *
      *       87  Profit Centre Accounting not installed              *
      *           and Revenue Alanysis is not installed               *         CDE002
      *       88  EMU and Enhanced rollover not installed             *
      *       89  Private Banking Module not installed                *         CPB001
      *       91  Buy/Our Yield Curve displayed                       *                       CAS001
      *       92  Collateral Status field displayed                   *                       CAS001
      *                                                               *
      *       96  Subfile control                                     *
      *       97  Subfile end                                         *
      ********************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
     D @NAR            S             40    DIM(2) CTDATA PERRCD(1)

     D @EI             S              1    DIM(60)

     D CGL011          S              1A   IMPORT                                             CGL011
                                                                                              CGL011
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULE DETAILS

     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CDE002
      ** External DS for SAR details                                            CDE002
                                                                                CDE002
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
     D MMLDNI        E DS                  EXTNAME(MMLDNIPD)
     D MMELDN        E DS                  EXTNAME(MMELDNIPD)
     D/COPY WNCPYSRC,MMLDNIXD01

     D                 DS
     D  DDFOTX                 1     40
     D  DDSIDN                10     15

      ** External DS for Customer Details                                                     CER043
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CER043
                                                                                              CER043
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                              CAS001
      ** Define fields used in CAS001                                                         CAS001
                                                                                              CAS001
     D CAS001          S              1A                                                      CAS001
     D PRTCD           S              7A                                                      CAS001
     D POPTN           S              7A                                                      CAS001
     D PSARD           S              6A                                                      CAS001

      ** Define fields used in CAS005                                                         CAS005
                                                                                              CAS005
     D CAS005          S              1A                                                      CAS005
                                                                                              CAS005
     D CER020          S              1A                                                      CER020
      *                                                                                       CER020
      ** Define fields used in CER043                                                         CER043
     D CER043          S              1A                                                      CER043
     D PCust           S             10A                                                      CER043
     D PStkey          S              7A                                                      CER043
                                                                                              CER043
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      * Main processing
      *
     C                   EXSR      MAIN
      *
      * Return
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   END
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C* MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      * MOVE 'OK' FLAGS INTO ARRAY (FOR CHECKING)
      *
     C                   MOVEA     MMELDN        @EI
      *
      * SET SCREEN ERROR INDICATORS ACCORDING TO STATUS OF 'OK' FLAGS
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C     C             DOUGT     60
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
     C/COPY WNCPYSRC,MMLDNIXC06
      *
      *  DO WHILE ERROR MESSAGES FOUND
      *  WRITE ERROR MESSAGES (WITH OR WITHOUT DATA) TO SUBFILE
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C     MsgIdArr(C)   ANDNE     'MMM1030'                                                  197015
     C                   MOVEL     MsgIdArr(C)   @MSGID            7
     C                   MOVEL     MsgDtaArr(C)  @MSGDT           45
     C/COPY WNCPYSRC,MMLDNIXC07
     C     @MSGDT        IFEQ      *BLANKS
     C                   EXSR      ERRWOD
     C                   ELSE
     C                   EXSR      ERRWID
     C                   END
     C                   ADD       1             C
     C                   END
      *
      *  DO WHILE WARNING MESSAGES FOUND
      *  WRITE WARNING MESSAGES (WITH OR WITHOUT DATA) TO SUBFILE
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     WFldNamArr(C) ANDNE     *BLANKS
     C                   MOVEL     WMsgIdArr(C)  @MSGID            7
     C                   MOVEL     WMsgDtaArr(C) @MSGDT           45
     C     @MSGDT        IFEQ      *BLANKS
     C                   EXSR      ERRWOD
     C                   ELSE
     C                   EXSR      ERRWID
     C                   END
     C                   ADD       1             C
     C                   END
      *
      *  WRITE MSG ID MMM1030 (If There is) TO SUBFILE                                        197015
      *                                                                                       197015
     C     MsgIdArr(1)   IFEQ      'MMM1030'                                                  197015
     C                   MOVEL     MsgIdArr(1)   @MSGID            7                          197015
     C                   MOVEL     MsgDtaArr(1)  @MSGDT           45                          197015
     C     @MSGDT        IFEQ      *BLANKS                                                    197015
     C                   EXSR      ERRWOD                                                     197015
     C                   ELSE                                                                 197015
     C                   EXSR      ERRWID                                                     197015
     C                   END                                                                  197015
     C                   END                                                                  197015
      *                                                                                       197015
      * POSITION CURSOR ON ACTION CODE IF IT IS BLANK
      *
     C*****DDACTN        COMP      *BLANK                                 68                  CAS005
     C     DDACTN        COMP      *BLANK                                 94                  CAS005
      *
      * ENABLE KEY FIELDS (ACTION CODE & DEAL NUMBER)
      *
     C*****@EKYFD********COMP******'Y'                                6969                    CDL038
     C     @EKYFD        COMP      'Y'                                0909                    CDL038
      *
      * ENABLE DETAIL FIELDS (ALL FIELDS EXCEPT ACTION CODE & DEAL NUMBER)
      *
     C     @EDTFD        COMP      'Y'                                7070
     C/COPY WNCPYSRC,MMLDNIXC04
      *                                                                                       CER020
      ** Set Screen Error Indicators according to the status                                  CER020
      ** of 'OK' Flags                                                                        CER020
      *                                                                                       CER020
     C                   IF        CER020 = 'Y'                                               CER020
      *                                                                                       CER020
      ** Check if Initial Start Date is Invalid                                               CER020
      *                                                                                       CER020
     C                   IF        ((OKISDT = 'N') OR                                         CER020
     C                             (OKISDT = 'W'))                                            CER020
     C                   EVAL      *IN05 = *ON                                                CER020
     C                   ELSE                                                                 CER020
      *                                                                                       CER020
     C                   EVAL      *IN05 = *OFF                                               CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
      ** Check if Final Maturity Date is Invalid                                              CER020
      *                                                                                       CER020
     C                   IF        ((OKFMDT = 'N') OR                                         CER020
     C                             (OKFMDT = 'W'))                                            CER020
     C                   EVAL      *IN06 = *ON                                                CER020
     C                   ELSE                                                                 CER020
      *                                                                                       CER020
     C                   EVAL      *IN06 = *OFF                                               CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
      ** Check if Original Deal Number is Invalid                                             CER020
      *                                                                                       CER020
     C                   IF        OKORDN = 'N'                                               CER020
     C                   EVAL      *IN02  = *ON                                               CER020
     C                   ELSE                                                                 CER020
      *                                                                                       CER020
     C                   EVAL      *IN02  = *OFF                                              CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *
      * ENABLE FUNCTION KEYS
      *
     C     @EINKG        COMP      'Y'                                    71
     C     @EINKH        COMP      'Y'                                    72
     C     @EINKJ        COMP      'Y'                                    73
     C     @EINKN        COMP      'Y'                                    74
     C     @EINKP        COMP      'Y'                                    75
     C     @EINKT        COMP      'Y'                                    76
      *
      * DEAL STATUS
      *
     C     DDSTS         COMP      *BLANK                             7979
      *                                                                                       CDL007
      ** Set on indicator to no display Penalty amount                                        CDL007
      *                                                                                       CDL007
     C     CDL007        IfNe      'Y'                                                        CDL007
     C**********         Move      *On           *IN66                                 CDL007 CAS001
     C                   Move      *On           *IN92                                        CAS001
     C                   EndIf                                                                CDL007
      *                                                                                       CGL011
      ** Set on indicator to display Collateral Status field                                  CGL011
      *                                                                                       CGL011
     C     CGL011        IfEq      'Y'                                                        CGL011
     C     DDCSTS        AndNe     *BLANKS                                                    CGL011
     C**********         MOVE      *On           *IN67                                 CGL011 CAS005
     C                   MOVE      *On           *IN93                                        CAS005
     C                   EndIf                                                                CGL011
      *
      * TEXT = SUCCESSFUL INSERT
      *
     C     @SIDN         IFNE      *BLANK
     C                   MOVEL     @NAR(1)       DDFOTX
     C                   MOVEL     @SIDN         DDSIDN
     C                   MOVEL     *BLANK        @SIDN
     C                   ELSE
      *
      * TEXT = CONFIRM DELETE
      *
     C     @EINKJ        IFEQ      'Y'
     C                   MOVEL     @NAR(2)       DDFOTX
     C                   ELSE
     C                   MOVEL     *BLANK        DDFOTX
     C                   END
     C                   END
     C/COPY WNCPYSRC,MMLDNIXC01
      *                                                                                       CDL016
      * Display the Blocked/Unblock Action                                                    CDL016
     C     CDL016        IFEQ      'Y'                                                        CDL016
     C     DDACTN        ANDEQ     'A'                                                        CDL016
      *                                                                                       CDL016
     C     BUACT         IFEQ      'B'                                                        CDL016
     C     BUACT         OREQ      'U'                                                        CDL016
     C                   MOVE      BUACT         DDACTN                                       CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL016
     C                   ENDIF                                                                CDL016
      *
      * WRITE MESSAGE SUBFILE, DETAILS AND FOOTER SCREEN
      *
     C                   TIME                    DDTIME
     C                   WRITE     MMLDNIS0
     C                   WRITE     MMLDNID1
     C                   WRITE     MMLDNIF1
      *
      * READ DETAILS SCREEN,
      *
      * If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      MMLDNID1                               99    *
     C                   ENDIF
     C/COPY WNCPYSRC,MMLDNIXC03
      *                                                                                       CDL016
      * Revert back to the original Action code                                               CDL016
     C     CDL016        IFEQ      'Y'                                                        CDL016
      *                                                                                       CDL016
     C     DDACTN        IFEQ      'B'                                                        CDL016
     C     DDACTN        OREQ      'U'                                                        CDL016
     C                   MOVE      DDACTN        BUACT                                        CDL016
     C                   MOVE      'A'           DDACTN                                       CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL016
     C                   ENDIF                                                                CDL016
      *
      * Clear message subfile
      *
     C                   CALL      'ZA0250'
      *
      * SET SCREEN ERROR INDICATORS OFF
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      * SET RETURN KEYS
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKG         @INKG
     C                   MOVE      *INKH         @INKH
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKN         @INKN
     C                   MOVE      *INKP         @INKP
     C                   MOVE      *INKT         @INKT
      *
     C                   If        CER043 = 'Y'                                               CER043
     C                   Eval      *IN87 = *Off                                               CER043
     C                   Eval      PCust = DDCUST                                             CER043
      *                                                                                       CER043
      ** Call AOCUSTR0 to get Customer Details                                                CER043
      *                                                                                       CER043
     C                   CALLB     'AOCUSTR0'                                                 CER043
     C                   PARM      *BLANKS       PRtcd                                        CER043
     C                   PARM      '*KEY   '     POptn                                        CER043
     C                   PARM                    PCust                                        CER043
     C                   PARM      *BLANKS       PStKey                                       CER043
     C     SDCUST        PARM      SDCUST        DSSDY                                        CER043
                                                                                              CER043
     C                   If        PRtcd <> *Blanks and PRtcd <> '*NRF'                       CER043
     C     *Lock         In        LDA                                                        CER043
     C                   Eval      DBKEY = PCust                                              CER043
     C                   Eval      DBASE = 910                                                CER043
     C                   Eval      DBFILE= 'SDCUSTPD'                                         CER043
     C                   Eval      DBPGM = 'MMLDNIDSP'                                        CER043
     C                   Out       LDA                                                        CER043
     C                   Exsr      *PSSR                                                      CER043
     C                   EndIf                                                                CER043
      *                                                                                       CER043
     C                   If        PRtcd = *Blanks                                            CER043
     C                   Eval      DDCRNM = BBCRNM                                            CER043
     C                   Eval      DDCRTN = BBCRTN                                            CER043
     C                   Eval      DDCSSN = BBCSSN                                            CER043
     C                   Else                                                                 CER043
     C                   Eval      *IN66  = *On                                               CER043
     C                   Eval      DDCRNM = *Blanks                                           CER043
     C                   Eval      DDCRTN = *Blanks                                           CER043
     C                   Eval      DDCSSN = *Blanks                                           CER043
     C                   EndIf                                                                CER043
      *                                                                                       CER043
     C                   Else                                                                 CER043
     C                   Eval      *IN87 = *On                                                CER043
     C                   EndIf                                                                CER043
      *                                                                                       CER043
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* ERRWOD  - OUTPUT ERROR MESSAGES WITHOUT DATA                  *
     C*                                                               *
     C*****************************************************************
     C     ERRWOD        BEGSR
     C*
     C*  Display error message
     C*
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     @MSGID        ZAMSID
     C                   CALL      'ZA0240'
     C                   PARM                    ZAMSID           10
     C*
     C                   ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* ERRWID  - OUTPUT ERROR MESSAGES WITH DATA                     *
     C*                                                               *
     C*****************************************************************
     C     ERRWID        BEGSR
     C*
     C*  Display error message
     C*
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     @MSGID        ZAMSID
     C/COPY WNCPYSRC,MMH00114
     C                   CALL      'ZA0440'
     C                   PARM                    ZAMSID           10
     C                   PARM      @MSGDT        ZAMDTA           45
     C/COPY WNCPYSRC,MMH00115
     C*
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM                    RetCodeIn
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    MMLDNI
     C/COPY WNCPYSRC,MMLDNIXC08
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *                                                                                       CGL011
      ** Collateral Status                                                                    CGL011
      *                                                                                       CGL011
     C                   PARM                    DDCSTS           10                          CGL011
      *
      * FIELDS IN ERROR
     C                   PARM                    MMELDN
     C/COPY WNCPYSRC,MMH00072
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      * ENABLED FUNCTION KEYS
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KN = COMMAND KEY 14 = SETTLEMENT DETAILS
      * KP = COMMAND KEY 15 = BROWSE
      * KT = COMMAND KEY 19 = FUNDING INFO
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKN            1
     C                   PARM                    @EINKP            1
     C                   PARM                    @EINKT            1
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN             6
      *                                                                                       CAP067
      * CALLING PGM                                                                           CAP067
     C                   PARM                    CPGM             10                          CAP067
      *                                                                                       CDL016
      * Blocked/Unblock Action                                                                CDL016
     C                   PARM                    BUACT             1                          CDL016
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKN             1
     C                   PARM                    @INKP             1
     C                   PARM                    @INKT             1
      *
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
     C                   PARM                    RepoFlag          1            CSE006
     C/COPY WNCPYSRC,MMLDNIXC05
      *
      ** Initialize program name
      *
     C                   MOVEL     'MMLDNIDSP'   DBPGM
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     DDWID
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C                   CALLB     'AOGELRR0'
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS MIDAS MODULE DETAILS
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '903'         DBASE                          * DBERR 903*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Check if Australian Brokerage is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'AUS007'      @SARD             6
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           AUS007            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           AUS007
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '904'         DBASE                          * DBERR 904*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Check if Enhanced Rollover is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'S01434'      @SARD             6
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01434            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           S01434
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '905'         DBASE                          * DBERR 905*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Check if EMU dealing settlement currency conversion is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU003'      @SARD
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU003            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CEU003
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '906'         DBASE                          * DBERR 905*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *                                                                         CSE006
      ** Check if Repurchase Agreement Enhancements is installed                CSE006
      *                                                                         CSE006
     C                   CALLB     'AOSARDR0'                                   CSE006
     C                   PARM      *BLANKS       @RTCD                          CSE006
     C                   PARM      '*VERIFY'     @OPTN                          CSE006
     C                   PARM      'CSE006'      @SARD                          CSE006
     C                   PARM                    DSFDY                          CSE006
     C     @RTCD         IFEQ      *BLANK                                       CSE006
     C                   MOVEL     'Y'           CSE006            1            CSE006
     C                   ELSE                                                   CSE006
     C     @RTCD         IFEQ      '*NRF'                                       CSE006
     C                   MOVE      'N'           CSE006                         CSE006
     C                   ELSE                                                   CSE006
      *                                                                         CSE006
      * DATABASE ERROR                                                          CSE006
      *                                                                         CSE006
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSE006
     C                   MOVEL     '907'         DBASE                          CSE006
     C                   MOVEL     @OPTN         DBKEY                          CSE006
     C                   EXSR      *PSSR                                        CSE006
     C                   END                                                    CSE006
     C                   END                                                    CSE006
                                                                                CDE002
      ** Access SAR details file to determine if CDE002 is switched on          CDE002
                                                                                CDE002
     C                   CallB     'AOSARDR0'                                   CDE002
     C                   Parm      *Blanks       PRTCD             7            CDE002
     C                   Parm      '*VERIFY'     POPTN             7            CDE002
     C                   Parm      'CDE002'      PSARD             6            CDE002
     C     SCSARD        Parm      SCSARD        DSFDY                          CDE002
      *                                                                         CDE002
     C                   Move      'N'           CDE002            1            CDE002
     C                   If        PRTCD = *Blanks                              CDE002
     C                   Eval      CDE002 = 'Y'                                 CDE002
     C                   Endif                                                  CDE002
     C/COPY WNCPYSRC,MMLDNIXC02
      *
      * Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
      * SET SCREEN PROTECT/NON-DISPLY INDICATORS
      *
      *
      * Single-branching (protect booking branch)
      *
     C     BJSBRC        IFNE      *BLANK
     C                   MOVE      '1'           *IN80
     C                   END
      *
      * Originating Branches not used
      *
     C     BKOBRU        IFNE      'Y'
     C     BJSBRC        ORNE      *BLANK
     C                   MOVE      '1'           *IN81
     C                   END
      *
      * Profit Centres not used (protect profit centre)
      *
     C     BKPRCU        IFNE      'Y'
     C                   MOVE      '1'           *IN82
     C                   END
      *
      ** Portfolio Management not installed (protect portfolio)
      *
     C     BGPFMG        IFNE      'Y'
     C                   MOVE      '1'           *IN83
     C                   END
      *
      * Australian Brokerage not installed (protect rate field)
      *
     C     AUS007        IFNE      'Y'
     C                   MOVE      '1'           *IN84
     C                   END
      *
      ** Securities Trading not installed (protect repo inds)
      *
     C     BGSECS        IFNE      'Y'
     C                   MOVE      '1'           *IN85
     C                   END
      *
      * Enhanced rollover installed (protect various fields)
      *
     C     S01434        IFNE      'Y'
     C                   MOVE      '1'           *IN86
     C                   END
      *
      ** Profit Centre Accounting not installed (protect funding fields)
      ** and Revenue Analysis not installed                                     CDE002
      *
     C     BGN0ST        IFNE      'Y'
     C     CDE002        ANDNE     'Y'                                          CDE002
     C                   MOVE      '1'           *IN87
     C                   END
      *
      * EMU dealing settlement currency conversion and
      * enhanced rollover installed (protect various fields)
      *
     C     S01434        IFNE      'Y'
     C     CEU003        ORNE      'Y'
     C                   MOVE      '1'           *IN88
     C                   END
      *                                                                         CSE006
      * If RepoFlag is on set indicator to display transaction type             CSE006
      * field.                                                                  CSE006
      *                                                                         CSE006
     C     RepoFlag      IFEQ      'Y'                                          CSE006
     C                   MOVE      '1'           *IN78                          CSE006
     C                   ELSE                                                   CSE006
      *                                                                         CSE006
      * Non-Display Repo Details if this is input through Loans and             CSE006
      * Deposits and switch is on.                                              CSE006
      *                                                                         CSE006
     C                   IF        CSE006 = 'Y'                                 CSE006
     C                   MOVE      '1'           *IN77                          CSE006
     C                   ENDIF                                                  CSE006
     C                   END                                                    CSE006
      *                                                                         CPB001
      ** Private Banking Module not installed (protect portfolio)               CPB001
      *                                                                         CPB001
     C     BGN4ST        IFNE      'Y'                                          CPB001
     C                   MOVE      '1'           *IN89                          CPB001
     C                   ENDIF                                                  CPB001
      *                                                                         CDL007
      ** Check if Deposit Breakdown Penalty is installed                        CDL007
      *                                                                         CDL007
     C                   CALLB     'AOSARDR0'                                   CDL007
     C                   PARM      *BLANKS       @RTCD                          CDL007
     C                   PARM      '*VERIFY'     @OPTN                          CDL007
     C                   PARM      'CDL007'      @SARD                          CDL007
     C                   PARM                    DSFDY                          CDL007
     C     @RTCD         IFEQ      *BLANK                                       CDL007
     C                   MOVEL     'Y'           CDL007            1            CDL007
     C                   ELSE                                                   CDL007
     C**********         MOVE      *ON           *IN66                                 CDL007 CAS001
     C                   MOVE      *ON           *IN92                                        CAS001
     C                   ENDIF                                                  CDL007
                                                                                              CAS001
      ** Access SAR details file to determine if CAS001 is on.                                CAS001
      ** (Net Present Value Accounting)                                                       CAS001
                                                                                              CAS001
     C                   CALLB     'AOSARDR0'                                                 CAS001
     C                   PARM      *BLANKS       PRTCD                                        CAS001
     C                   PARM      '*VERIFY'     POPTN                                        CAS001
     C                   PARM      'CAS001'      PSARD                                        CAS001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS001
     C                   IF        PRTCD <> *BLANKS AND                                       CAS001
     C                             PRTCD <> '*NRF   '                                         CAS001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS001
     C                   EVAL      DBASE = 908                                                CAS001
     C                   EVAL      DBKEY = 'CAS001'                                           CAS001
     C                   EXSR      *PSSR                                                      CAS001
     C                   ENDIF                                                                CAS001
     C                   IF        PRTCD = *BLANKS                                            CAS001
     C                   EVAL      CAS001 = 'Y'                                               CAS001
     C                   EVAL      *IN91 = *ON                                                CAS001
     C                   ELSE                                                                 CAS001
     C                   EVAL      CAS001 = 'N'                                               CAS001
     C                   EVAL      *IN91 = *OFF                                               CAS001
     C                   ENDIF                                                                CAS001
      *
     C     CPGM          IFEQ      'MMREPORPR '                                               CAP067
     C                   MOVE      *ON           *IN90                                        CAP067
     C                   ELSE                                                                 CAP067
     C                   MOVE      *OFF          *IN90                                        CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
      ** Access SAR details file to determine if CAS005 is on.                                CAS005
      ** (Enhancements to CAS001, CAS002 and CAS004)                                          CAS005
                                                                                              CAS005
     C                   CALLB     'AOSARDR0'                                                 CAS005
     C                   PARM      *BLANKS       PRTCD                                        CAS005
     C                   PARM      '*VERIFY'     POPTN                                        CAS005
     C                   PARM      'CAS005'      PSARD                                        CAS005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS005
                                                                                              CAS005
     C                   IF        PRTCD <> *BLANKS AND                                       CAS005
     C                             PRTCD <> '*NRF   '                                         CAS005
     C     *LOCK         IN        LDA                                                        CAS005
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS005
     C                   EVAL      DBASE = 909                                                CAS005
     C                   EVAL      DBKEY = 'CAS005'                                           CAS005
     C                   OUT       LDA                                                        CAS005
     C                   EXSR      *PSSR                                                      CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        PRTCD = *BLANKS                                            CAS005
     C                   EVAL      *IN95 = *OFF                                               CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      *IN95 = *ON                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Access SAR details file to determine if CDL016 is switched on                        CDL016
      ** (Autumatic Rollover of Fixed Term Loan/Deposit)                                      CDL016
                                                                                              CDL016
     C                   CallB     'AOSARDR0'                                                 CDL016
     C                   Parm      *Blanks       PRTCD                                        CDL016
     C                   Parm      '*VERIFY'     POPTN                                        CDL016
     C                   Parm      'CDL016'      PSARD                                        CDL016
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL016
      *                                                                                       CDL016
     C                   Move      'N'           CDL016            1                          CDL016
     C                   Eval      *IN98 = *ON                                                CDL016
     C                   If        PRTCD = *Blanks                                            CDL016
     C                   Eval      CDL016 = 'Y'                                               CDL016
     C                   Eval      *IN98 = *OFF                                               CDL016
     C                   Endif                                                                CDL016
                                                                                              CDL038
      ** Access SAR details file to determine if CDL038 is switched on                        CDL038
      ** (Extended Deal Sub Type)                                                             CDL038
                                                                                              CDL038
     C                   CallB     'AOSARDR0'                                                 CDL038
     C                   Parm      *Blanks       PRTCD                                        CDL038
     C                   Parm      '*VERIFY'     POPTN                                        CDL038
     C                   Parm      'CDL038'      PSARD                                        CDL038
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL038
      *                                                                                       CDL038
     C                   IF        PRTCD = *BLANKS                                            CDL038
     C                   EVAL      *IN08 = *OFF                                               CDL038
     C                   ELSE                                                                 CDL038
     C                   EVAL      *IN08 = *ON                                                CDL038
     C                   ENDIF                                                                CDL038
                                                                                              CDL017
      *                                                                                       CER020
      ** Access SAR details file to determine if CER020 is installed                          CER020
      *                                                                                       CER020
     C                   CALLB     'AOSARDR0'                                                 CER020
     C                   PARM      *BLANKS       PRtcd                                        CER020
     C                   PARM      '*VERIFY'     POptn                                        CER020
     C                   PARM      'CER020'      PSard                                        CER020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER020
      *                                                                                       CER020
     C                   IF        PRtcd = *BLANKS                                            CER020
      *                                                                                       CER020
     C                   EVAL      CER020  = 'Y'                                              CER020
     C                   EVAL      *IN04 = *ON                                                CER020
      *                                                                                       CER020
     C                   ELSE                                                                 CER020
      *                                                                                       CER020
     C                   EVAL      CER020  = 'N'                                              CER020
     C                   EVAL      *IN04 = *OFF                                               CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
      *                                                                                       CER043
      ** Check if CER043 is switched on                                                       CER043
                                                                                              CER043
     C                   Call      'AOSARDR0'                                                 CER043
     C                   Parm      *BLANKS       PRtcd                                        CER043
     C                   Parm      '*VERIFY'     POptn                                        CER043
     C                   Parm      'CER043'      PSARD             6                          CER043
     C     SCSARD        Parm      SCSARD        DSFDY                                        CER043
                                                                                              CER043
     C                   If        PRtcd = *BLANKS                                            CER043
     C                   Eval      CER043 = 'Y'                                               CER043
     C                   Else                                                                 CER043
     C                   Eval      CER043 = 'N'                                               CER043
                                                                                              CER043
     C                   If        PRtcd <> '*NRF'                                            CER043
     C     *Lock         IN        LDA                                                        CER043
     C                   Eval      DBKEY = 'CER043'                                           CER043
     C                   Eval      DBFILE = 'SCSARDPD'                                        CER043
     C                   Eval      DBASE = 911                                                CER043
     C                   OUT       LDA                                                        CER043
     C                   Exsr      *PSSR                                                      CER043
     C                   EndIf                                                                CER043
                                                                                              CER043
     C                   EndIf                                                                CER043
                                                                                              CER043
     C/COPY WNCPYSRC,MMH00073
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** @Z0
000000000000000000000000000000000000000000000000000000000000
** @NAR
Deal No. 999999 successfully inserted.
F10=CONFIRM DELETE
