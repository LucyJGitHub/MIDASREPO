     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Single ccy IRS insert/display')               *
      *****************************************************************
      *                                                               *
      *  Midas - IRS Deals Display                                    *
      *                                                               *
      *  IRSIRSDSP  IRS DEALS DISPLAY PROGRAM  - 'RS' DEAL TYPE       *
      *             SINGLE CURRENCY INTEREST RATE SWAPS               *
      *                                                               *
      *  Function:  This module displays the main details screen      *
      *             of the single ccy interest rate swaps screen      *
      *             input function.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CIR017             Date 10Apr14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11376           Date 11May06               *
      *                 CDL038             Date 10May05               *
      *                 BUG6472            Date 22Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS005             Date 16Dec02               *
      *                 218641             Date 10Jun03               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209167             Date 23Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 186458             Date 28Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW097             Date 02Dec99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 27Apr98               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CIR017 - SIRS Business Day Conventions for both Legs         *
      *           (Recompile)                                         *
      *  BUG11376-Remove the incorrect declaration of STDDECLARE      *
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG6472- Added a sign field to short term rate (Recompile)   *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CLE025 - Credit Lines                                        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  218641 - Adjust Yield Curve field position in the definition *
      *           file                                                *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  209167 - Recompiled due to changes in IRSIRSDDF.             *
      *  CAS001 - Net Present Value (NPV) Accounting.                 *
      *  186458 - Display Confirmation Matching status.  Patterned    *
      *           after fix 179380.                                   *
      *  CIR005 - FRA/IRS Business Day Conventions (Recompiled)       *
      *  CSW097 - SWIFT 97 changes to MT340s and MT360s               *
      *  CAP003 - Conversion of IR inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FIRSIRSDDF CF   E             WORKSTN
     FCFFEEDL0  IF   E           K DISK    INFSR(*PSSR)                                       186458
     F/COPY WNCPYSRC,IRH00066
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       01  Work indicator                                      *                       186458
      *       08  Extended Deal Sub Type not installed                *                       CDL038
      *       09  Error in Class                                      *                       CDL038
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *                                                               *
      *       67  Display Confirmation Matching status                *                       186458
      *       68  Position cursor on action code (if it is blank)     *
      *       69  Protect deal key fields (action code & deal number) *
      *       70  Protect deal detail fields                          *
      *       71  Enable CF07                                         *
      *       72  Enable CF08                                         *
      *       73  Enable CF10                                         *
      *       74  Enable CF14                                         *
      *       75  Enable CF15                                         *
      *       76  Enable CF19                                         *
      *       79  Highlight deal status                               *
      *                                                               *
      *       80  Not multibranching                                  *
      *       81  Originating branch not used                         *
      *       82  Profit centres not used                             *
      *       86  Net Present Value(NPV) Accounting feature present   *                       CAS001
      *       87  Enhancement CAS005 feature present                  *                       CAS005
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
 
      ** Include the FRA/IRS standard declares
     D***/COPY IRCPYSRC,STDDECLARE                                                          BUG11376
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D*@Z0******       S              1    DIM(60) CTDATA PERRCD(60)                          CLE025
     D @Z0             S              1    DIM(62) CTDATA PERRCD(62)                          CLE025
     D @NAR            S             40    DIM(2) CTDATA PERRCD(1)
 
     D*@EI******       S              1    DIM(60)                                            CLE025
     D @EI             S              1    DIM(62)                                            CLE025
 
     D CPBKTxt         S             17    DIM(2) PERRCD(1) CTDATA                            186458
      ** Array for counterparty and broker fields narratives                                  186458
                                                                                              186458
     D TAB1            S              2  0 DIM(16) PERRCD(1) CTDATA                           186458
     D TAB2            S             15    DIM(16) ALT(TAB1)                                  186458
      ** Array for counterparty and broker status codes/narratives                            186458
                                                                                              186458
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
                                                                                CSW097
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CSW097
      ** EXTERNAL DS FOR SWITCHABLE FEATURE DETAILS                             CSW097
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  186458
      ** External DS for Midas Modules Details                                                186458
                                                                                              186458
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D IRSIRS        E DS                  EXTNAME(IRSIRSPD)
     D IRESIRS       E DS                  EXTNAME(IRESIRSPD)
 
     D                 DS
     D  DDFOTX                 1     40
     D  DDSIDN                10     15
 
      ** CFFEEDL0 key                                                                         186458
     D  WCFKY          DS            16                                                       186458
     D  WTST1                  1      8                                                       186458
     D  WKEY1                  1      2                                                       186458
     D  WKEY2                  3      8                                                       186458
     D  WKEY3                  9     11                                                       186458
                                                                                              186458
      ** Work variables                                                                       186458
                                                                                              186458
     D WTST2           S              8                                                       186458
     D CCF003          S              1                                                       186458
                                                                                              186458
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                              CAS001
      ** Variables defined for CAS001                                                         CAS001
                                                                                              CAS001
     D CAS001          S              1A                                                      CAS001
     D PRTCD           S              7A                                                      CAS001
     D POPTN           S              7A                                                      CAS001
     D PSARD           S              6A                                                      CAS001
                                                                                              CAS005
      ** Variables defined for CAS005                                                         CAS005
                                                                                              CAS005
     D CAS005          S              1A                                                      CAS005
     D CLE025          S              1A                                                      CLE025
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
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
     C                   MOVEA     IRESIRS       @EI
      *
      * SET SCREEN ERROR INDICATORS ACCORDING TO STATUS OF 'OK' FLAGS
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C*****C****         DOUGT     60                                                         CLE025
     C     C             DOUGT     62                                                         CLE025
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
                                                                                              CDL038
     C     OKCLAS        comp      'N'                                    09                  CDL038
                                                                                              CDL038
      **********                                                                       CAS001 218641
      ***If*CAS001*is*On,*highlight*fields*our/their*yield*curve*if*in*error****       CAS001 218641
      **********                                                                       CAS001 218641
     C**********         IF        CAS001 = 'Y'                                        CAS001 218641
      **********                                                                       CAS001 218641
     C**********         IF        OKOYLC = 'N' OR OKOYLC = 'W'                        CAS001 218641
     C**********         EVAL      *IN56 = *ON                                         CAS001 218641
     C**********         ENDIF                                                         CAS001 218641
      **********                                                                       CAS001 218641
     C**********         ENDIF                                                         CAS001 218641
      *
      *  DO WHILE ERROR MESSAGES FOUND
      *  WRITE ERROR MESSAGES (WITH OR WITHOUT DATA) TO SUBFILE
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     MsgIdArr(C)   @MSGID            7
     C                   MOVEL     MsgDtaArr(C)  @MSGDT           45
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
      * POSITION CURSOR ON DEAL NUMBER CODE IF IT IS BLANK
      *
     C     SDLNO         COMP      *BLANK                                 68
      *
      * ENABLE KEY FIELDS (ACTION CODE & DEAL NUMBER)
      *
     C     @EKYFD        COMP      'Y'                                6969
      *
      * ENABLE DETAIL FIELDS (ALL FIELDS EXCEPT ACTION CODE & DEAL NUMBER)
      *
     C     @EDTFD        COMP      'Y'                                7070
      *
      * ENABLE FUNCTION KEYS
      *
     C     @EINKG        COMP      'Y'                                    71
     C     @EINKH        COMP      'Y'                                    72
     C     @EINKJ        COMP      'Y'                                    73
     C     @EINKN        COMP      'Y'                                    74
     C     @EINKP        COMP      'Y'                                    75
      *
      * DEAL STATUS
      *
     C     DDSTS         COMP      *BLANK                             7979
     C                   MOVE      'RS'          SDTYP
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
                                                                                              186458
      ** Confirmation matching feedback information                                           186458
                                                                                              186458
     C                   IF        BGCFMT = 'Y' AND *IN83 = *ON                               186458
     C                             AND CCF003 = 'Y'                                           186458
     C                             AND SDLNO <> *BLANKS AND OKDLNO = 'Y'                      186458
     C                             AND SACCD <> *BLANKS AND OKACCD = 'Y'                      186458
     C                             AND SACCD <> 'I'                                           186458
     C                   EVAL      *IN67 = *ON                                                186458
     C                   EXSR      SRFEED                                                     186458
     C                   ELSE                                                                 186458
     C                   EVAL      *IN67 = *OFF                                               186458
     C                   ENDIF                                                                186458
     C/COPY WNCPYSRC,IRH00032
      *
      * WRITE MESSAGE SUBFILE, DETAILS AND FOOTER SCREEN
      *
     C                   TIME                    STIME
     C                   WRITE     IRSIRSS0
     C                   WRITE     IRSIRSD1
     C                   WRITE     IRSIRSF1
      *
      * READ DETAILS SCREEN,
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      IRSIRSD1                               99
     C                   ENDIF
      *
      * Clear message subfile
      *
     C                   CALL      'ZA0250'
      *
      * SET SCREEN ERROR INDICATORS OFF
      *
     C                   MOVEA     @Z0           *IN(10)
                                                                                              CDL038
     C                   SETOFF                                       09                      CDL038
                                                                                              CDL038
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
      *
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
     C/COPY WNCPYSRC,IRH00056
     C                   CALL      'ZA0440'
     C                   PARM                    ZAMSID           10
     C                   PARM      @MSGDT        ZAMDTA           45
     C/COPY WNCPYSRC,IRH00057
     C*
     C                   ENDSR
     C********************************************************************
      /EJECT                                                                                  186458
      *****************************************************************                       186458
      * SRFEED - Extract feedback information (Confirmation Matching)                         186458
      * Called From - MAIN                                                                    186458
      * Calls       - None                                                                    186458
      *****************************************************************                       186458
     C     SRFEED        BEGSR                                                                186458
                                                                                              186458
      ** If Confirmation Matching present, get C/P and Broker Status.                         186458
                                                                                              186458
     C                   EVAL      SCPTX = *BLANKS                                            186458
     C                   EVAL      SCPST = *BLANKS                                            186458
     C                   EVAL      SBKTX = *BLANKS                                            186458
     C                   EVAL      SBKST = *BLANKS                                            186458
     C                   EVAL      WKEY1 = 'FI'                                               186458
     C                   EVAL      WKEY2 = SDLNO                                              186458
     C                   EVAL      WKEY3 = '999'                                              186458
                                                                                              186458
     C     WCFKY         SETGT     CFFEEDL0                                                   186458
     C                   READP     CFFEEDL0                               01                  186458
     C                   MOVEL     IMRF          WTST2                                        186458
                                                                                              186458
      ** If no record found or feedback is for different deal, use                            186458
      ** default "NO FEEDBACK YET".                                                           186458
                                                                                              186458
     C                   IF        *IN01 = *ON                                                186458
     C                             OR WTST1 <> WTST2                                          186458
     C                   EVAL      CPSX = *ZERO                                               186458
     C                   EVAL      BKSX = *ZERO                                               186458
     C                   ENDIF                                                                186458
                                                                                              186458
      ** Counterparty Status                                                                  186458
                                                                                              186458
     C                   EVAL      SCPTX = CPBKTxt(1)                                         186458
     C     CPSX          LOOKUP    TAB1          TAB2                     01                  186458
     C                   EVAL      SCPST = TAB2                                               186458
                                                                                              186458
      ** Broker involved?                                                                     186458
                                                                                              186458
     C                   IF        SBRKC <> 'PHON' AND SBRKC <> 'TELX'                        186458
     C                             AND SBRKC <> 'MAIL' AND SBRKC <> 'SWAP'                    186458
     C                   EVAL      SBKTX = CPBKTxt(2)                                         186458
     C     BKSX          LOOKUP    TAB1          TAB2                     01                  186458
     C                   EVAL      SBKST = TAB2                                               186458
     C                   ENDIF                                                                186458
                                                                                              186458
     C                   ENDSR                                                                186458
      *****************************************************************                       186458
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
     C                   PARM                    IRSIRS
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *
      * FIELDS IN ERROR
     C                   PARM                    IRESIRS
     C/COPY WNCPYSRC,IRH00033
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
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKN            1
     C                   PARM                    @EINKP            1
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN             6
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
     C                   PARM                    WriteOnly         1
      *
      ** Initialize program name
      *
     C                   MOVEL     'IRSIRSDSP'   DBPGM
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     SWSID
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
      *                                                                                       186458
      ** Access Module Details.                                                               186458
      *                                                                                       186458
     C                   CALL      'AOMMODR0'                                                 186458
     C                   PARM      *BLANKS       @RTCD                                        186458
     C                   PARM      '*FIRST '     @OPTN                                        186458
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        186458
      *                                                                                       186458
      ** Database Error                                                                       186458
      *                                                                                       186458
     C     @RTCD         IFNE      *BLANKS                                                    186458
     C                   MOVEL     'SDMMODPD'    DBFILE                                       186458
     C                   MOVEL     '906'         DBASE                                        186458
     C                   MOVEL     @OPTN         DBKEY                                        186458
     C                   EXSR      *PSSR                                                      186458
     C                   ENDIF                                                                186458
      *                                                                         CSW097
      ** Access SAR details file to determine if IRS Msg Gen Feature is on      CSW097
      *                                                                         CSW097
     C                   CALL      'AOSARDR0'                                   CSW097
     C                   PARM      *BLANKS       @RTCD                          CSW097
     C                   PARM      '*VERIFY'     @OPTN                          CSW097
     C                   PARM      'CSW005'      @SARD                          CSW097
     C     SCSARD        PARM      SCSARD        DSFDY                          CSW097
     C     @RTCD         IFNE      *BLANKS                                      CSW097
     C     @RTCD         ANDNE     '*NRF   '                                    CSW097
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSW097
     C                   MOVEL     '903'         DBASE                          CSW097
     C                   MOVEL     'CSW005'      DBKEY                          CSW097
     C                   EXSR      *PSSR                                        CSW097
     C                   END                                                    CSW097
     C     @RTCD         IFEQ      *BLANK                                       CSW097
     C                   MOVE      '1'           *IN83                          CSW097
     C                   END                                                    CSW097
      *                                                                                       186458
      ** Access SAR details file to determine if CCF003 is on.                                186458
      *                                                                                       186458
     C                   CALL      'AOSARDR0'                                                 186458
     C                   PARM      *BLANKS       @RTCD                                        186458
     C                   PARM      '*VERIFY'     @OPTN                                        186458
     C                   PARM      'CCF003'      @SARD                                        186458
     C     SCSARD        PARM      SCSARD        DSFDY                                        186458
      *                                                                                       186458
      ** Database Error                                                                       186458
      *                                                                                       186458
     C     @RTCD         IFNE      *BLANKS                                                    186458
     C     @RTCD         ANDNE     '*NRF   '                                                  186458
     C                   MOVEL     'SCSARDPD'    DBFILE                                       186458
     C                   MOVEL     '905'         DBASE                                        186458
     C                   MOVEL     'CCF003'      DBKEY                                        186458
     C                   EXSR      *PSSR                                                      186458
     C                   ENDIF                                                                186458
      *                                                                                       186458
     C     @RTCD         IFEQ      *BLANK                                                     186458
     C                   MOVE      'Y'           CCF003                                       186458
     C                   ELSE                                                                 186458
     C                   MOVE      'N'           CCF003                                       186458
     C                   ENDIF                                                                186458
      *                                                                                       CAS001
      ** Access SAR details file to determine if Net Present Value (NPV)                      CAS001
      ** Accounting, CAS001 is installed                                                      CAS001
      *                                                                                       CAS001
     C                   CALL      'AOSARDR0'                                                 CAS001
     C                   PARM      *BLANKS       PRTCD                                        CAS001
     C                   PARM      '*VERIFY'     POPTN                                        CAS001
     C                   PARM      'CAS001'      PSARD                                        CAS001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS001
                                                                                              CAS001
     C     PRTCD         IFNE      *BLANKS                                                    CAS001
     C     PRTCD         ANDNE     '*NRF   '                                                  CAS001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAS001
     C                   MOVEL     '907'         DBASE                                        CAS001
     C                   MOVEL     'CAS001'      DBKEY                                        CAS001
     C                   EXSR      *PSSR                                                      CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS001
     C     PRTCD         IFEQ      *BLANK                                                     CAS001
     C                   EVAL      CAS001 = 'Y'                                               CAS001
     C                   EVAL      *IN86  = *ON                                               CAS001
     C                   ELSE                                                                 CAS001
     C                   EVAL      CAS001 = 'N'                                               CAS001
     C                   EVAL      *IN86  = *OFF                                              CAS001
     C                   ENDIF                                                                CAS001
     C/COPY WNCPYSRC,IRH00034
                                                                                              CAS005
      ** Access SAR details file to determine if CAS005 is installed                          CAS005
                                                                                              CAS005
     C                   CALL      'AOSARDR0'                                                 CAS005
     C                   PARM      *BLANKS       PRTCD                                        CAS005
     C                   PARM      '*VERIFY'     POPTN                                        CAS005
     C                   PARM      'CAS005'      PSARD                                        CAS005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS005
                                                                                              CAS005
     C     PRTCD         IFNE      *BLANKS                                                    CAS005
     C     PRTCD         ANDNE     '*NRF   '                                                  CAS005
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAS005
     C                   MOVEL     '908'         DBASE                                        CAS005
     C                   MOVEL     'CAS005'      DBKEY                                        CAS005
     C                   EXSR      *PSSR                                                      CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C     PRTCD         IFEQ      *BLANK                                                     CAS005
     C                   EVAL      CAS005 = 'Y'                                               CAS005
     C                   EVAL      *IN87  = *ON                                               CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      CAS005 = 'N'                                               CAS005
     C                   EVAL      *IN87  = *OFF                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CLE025
      ** Access SAR details file to determine if CLE025 is installed                          CLE025
                                                                                              CLE025
     C                   CALL      'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       PRTCD                                        CLE025
     C                   PARM      '*VERIFY'     POPTN                                        CLE025
     C                   PARM      'CLE025'      PSARD                                        CLE025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE025
                                                                                              CLE025
     C     PRTCD         IFNE      *BLANKS                                                    CLE025
     C     PRTCD         ANDNE     '*NRF   '                                                  CLE025
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE025
     C                   MOVEL     '909'         DBASE                                        CLE025
     C                   MOVEL     'CLE025'      DBKEY                                        CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C     PRTCD         IFEQ      *BLANK                                                     CLE025
     C                   EVAL      CLE025 = 'Y'                                               CLE025
     C                   EVAL      *IN88  = *ON                                               CLE025
     C                   ELSE                                                                 CLE025
     C                   EVAL      CLE025 = 'N'                                               CLE025
     C                   EVAL      *IN88  = *OFF                                              CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CDL038
      ** Access SAR details file to determine if CDL038 is switched on                        CDL038
      ** (Extended Deal Sub Type)                                                             CDL038
                                                                                              CDL038
     C                   Call      'AOSARDR0'                                                 CDL038
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
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** @Z0
000000000000000000000000000000000000000000000000000000000000
** @NAR
Deal No. 999999 successfully inserted.
F10=CONFIRM DELETE
** CPBKTxt - COUNTERPARTY AND BROKER FIELD NARRATIVE                                          186458
Counterparty Conf                                                                             186458
Broker Conf                                                                                   186458
** (TAB1/TAB2) - COUNTERPARTY AND BROKER STATUS CODES/NARRATIVES                              186458
00NO FEEDBACK YET                                                                             186458
01WAITING                                                                                     186458
02TIMED OUT                                                                                   186458
03SPLIT FM PAIR                                                                               186458
50PROPOSED PAIR                                                                               186458
51PAIRED ERROR-O                                                                              186458
52PAIRED ERROR-T                                                                              186458
53PAIRED ERROR-B                                                                              186458
54PROPOSED INVEST                                                                             186458
55DUPLICATE ERROR                                                                             186458
56INVESTIGATION                                                                               186458
91CORRECT                                                                                     186458
92COMPLETE                                                                                    186458
93CANCEL                                                                                      186458
97NONE EXPECTED                                                                               186458
99PAIRED NO ERROR                                                                             186458
