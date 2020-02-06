     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR FRA maintenance insert/display')              *
      *****************************************************************
      *                                                               *
      *  Midas - FRA Deals Display                                    *
      *                                                               *
      *  IRFRADSP  FRA DEALS DISPLAY PROGRAM  - 'FR' DEAL TYPE        *
      *           FORWARD RATE AGREEMENTS                             *
      *                                                               *
      *  Function:  This module displays the main details screen      *
      *             of the forward rate agreements screen input       *
      *             function.                                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG11376           Date 11May06               *
      *                 CDL038             Date 10May05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 30Jul03               *
      *                 CAS006             Date 21Jan03               *
      *                 217684             Date 12May03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 186458             Date 28Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW097             Date 02Dec99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 23Mar98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG11376-Remove the incorrect declaration of STDDECLARE      *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - API wrapper project                                 *
      *         - Re-compile due to change in IRFRAPD                 *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  186458 - Display Confirmation Matching status.  Patterned    *
      *           after fix 179380.                                   *
      *  CIR005 - FRA/IRS Business Day Conventions                    *
      *  CSW097 - SWIFT97 Changes to MT340s and MT360s                *
      *  CAP003 - Conversion of IR inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FIRFRADDF  CF   E             WORKSTN
     FCFFEEDL0  IF   E           K DISK    INFSR(*PSSR)                                       186458
     F/COPY WNCPYSRC,IRH00065
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       01  Work indicator                                      *                       186458
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *                                                               *
      *       66  Display Confirmation Matching status                *                       186458
      *       67  Display Currencies for rate fixing convention       *         CIR005
      *       68  Position cursor on action code (if it is blank)     *
      *       69  Protect deal key fields (action code & deal number) *
      *       70  Protect deal detail fields                          *
      *       71  Enable CF07                                         *
      *       72  Enable CF08                                         *
      *       73  Enable CF10                                         *
      *       74  Enable CF14                                         *
      *       75  Enable CF15                                         *
      *       76  Enable CF19                                         *
      *       76  CAS006 enabled                                      *                       CAS006
      *       79  Highlight deal status                               *
      *                                                               *
      *       80  Not multibranching                                  *
      *       81  Originating branch not used                         *
      *       82  Profit centres not used                             *
      *       83  Portfolio management not installed                  *
      *       84  Australian Brokerage not installed                  *
      *       85  Securities Trading module not installed (repo)      *
      *       86  Enhanced rollover not installed                     *
      *       90  Extended Deal Sub Type not installed                *                       CDL038
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
 
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
     D @NAR            S             40    DIM(2) CTDATA PERRCD(1)
 
     D @EI             S              1    DIM(60)
 
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
 
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
     D IRFRA         E DS                  EXTNAME(IRFRAPD)
     D IREFRA        E DS                  EXTNAME(IREFRAPD)
 
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
     D CSW005          S              1                                                       186458
     D CSW011          S              1                                                       186458
     D PRTCD           S              7                                                       CAS006
     D POPTN           S              7                                                       CAS006
     D PSARD           S              6                                                       CAS006
     D CAS006          S              1                                                       CAS006
                                                                                              186458
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
     C                   MOVEA     IREFRA        @EI
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
      *                                                                         CIR005
      ** Display New Fields if CIR005 = Y.                                      CIR005
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C                   EVAL      *IN67 = '1'                                  CIR005
     C                   ENDIF                                                  CIR005
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
     C                   MOVE      'FR'          SDTYP
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
     C                   IF        CSW011 = 'Y' AND BGCFMT = 'Y' OR                           186458
     C                             CSW005 = 'Y' AND BGCFMT = 'Y'                              186458
                                                                                              186458
     C                   IF        SDLNO <> *BLANKS AND OKDLNO = 'Y' AND                      186458
     C                             SACCD <> *BLANKS AND OKACCD = 'Y' AND                      186458
     C                             SACCD <> 'I'                                               186458
                                                                                              186458
     C                   EVAL      *IN66 = *ON                                                186458
     C                   EXSR      SRFEED                                                     186458
     C                   ELSE                                                                 186458
     C                   EVAL      *IN66 = *OFF                                               186458
     C                   ENDIF                                                                186458
                                                                                              186458
     C                   ELSE                                                                 186458
     C                   EVAL      *IN66 = *OFF                                               186458
     C                   ENDIF                                                                186458
     C/COPY WNCPYSRC,IRH00018
      *
      * WRITE MESSAGE SUBFILE, DETAILS AND FOOTER SCREEN
      *
     C                   TIME                    STIME
     C                   WRITE     IRFRAS0
     C                   WRITE     IRFRAD1
     C                   WRITE     IRFRAF1
      *
      * READ DETAILS SCREEN,
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      IRFRAD1                                99
     C                   ENDIF
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
     C/COPY WNCPYSRC,IRH00054
     C                   CALL      'ZA0440'
     C                   PARM                    ZAMSID           10
     C                   PARM      @MSGDT        ZAMDTA           45
     C/COPY WNCPYSRC,IRH00055
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
     C                   PARM                    IRFRA
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *
      * FIELDS IN ERROR
     C                   PARM                    IREFRA
     C/COPY WNCPYSRC,IRH00019
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
     C                   MOVEL     'IRFRADSP'    DBPGM
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
     C                   MOVEL     '905'         DBASE                                        186458
     C                   MOVEL     @OPTN         DBKEY                                        186458
     C                   EXSR      *PSSR                                                      186458
     C                   ENDIF                                                                186458
      *                                                                                       186458
      ** Access SAR details file to determine if CSW011 is on.                                186458
      *                                                                                       186458
     C                   CALL      'AOSARDR0'                                                 186458
     C                   PARM      *BLANKS       @RTCD                                        186458
     C                   PARM      '*VERIFY'     @OPTN                                        186458
     C                   PARM      'CSW011'      @SARD                                        186458
     C     SCSARD        PARM      SCSARD        DSFDY                                        186458
      *                                                                                       186458
      ** Database Error                                                                       186458
      *                                                                                       186458
     C     @RTCD         IFNE      *BLANKS                                                    186458
     C     @RTCD         ANDNE     '*NRF   '                                                  186458
     C                   MOVEL     'SCSARDPD'    DBFILE                                       186458
     C                   MOVEL     '906'         DBASE                                        186458
     C                   MOVEL     'CSW011'      DBKEY                                        186458
     C                   EXSR      *PSSR                                                      186458
     C                   ENDIF                                                                186458
      *                                                                                       186458
     C     @RTCD         IFEQ      *BLANK                                                     186458
     C                   MOVE      'Y'           CSW011                                       186458
     C                   ELSE                                                                 186458
     C                   MOVE      'N'           CSW011                                       186458
     C                   ENDIF                                                                186458
      *                                                                         CIR005
      **  Access SAR details file to determine if Bus. Day Convention is on.    CIR005
      *                                                                         CIR005
     C                   CALL      'AOSARDR0'                                   CIR005
     C                   PARM      *BLANKS       @RTCD                          CIR005
     C                   PARM      '*VERIFY'     @OPTN                          CIR005
     C                   PARM      'CIR005'      @SARD                          CIR005
     C     SCSARD        PARM      SCSARD        DSFDY                          CIR005
      *                                                                         CIR005
     C     @RTCD         IFNE      *BLANKS                                      CIR005
     C     @RTCD         ANDNE     '*NRF   '                                    CIR005
     C     *LOCK         IN        LDA                                          CIR005
     C                   MOVEL     'SCSARDPD'    DBFILE                         CIR005
     C                   Z-ADD     904           DBASE                          CIR005
     C                   MOVEL     'CIR005'      DBKEY                          CIR005
     C                   OUT       LDA                                          CIR005
     C                   EXSR      *PSSR                                        CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C     @RTCD         IFEQ      *BLANKS                                      CIR005
     C                   MOVEL     'Y'           CIR005            1            CIR005
     C                   ELSE                                                   CIR005
     C                   MOVEL     'N'           CIR005                         CIR005
     C                   ENDIF                                                  CIR005
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
     C                   MOVE      'Y'           CSW005                                       186458
     C                   MOVE      '1'           *IN83                          CSW097
     C                   END                                                    CSW097
     C/COPY WNCPYSRC,IRH00020
      *                                                                                       CAS006
      ** Access SAR details file to determine if Hedge Accounting Phase B is                  CAS006
      ** installed                                                                            CAS006
      *                                                                                       CAS006
     C                   CALL      'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRTCD                                        CAS006
     C                   PARM      '*VERIFY'     POPTN                                        CAS006
     C                   PARM      'CAS006'      PSARD                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
      *                                                                                       CAS006
     C     PRTCD         IFNE      *BLANKS                                                    CAS006
     C     PRTCD         ANDNE     '*NRF   '                                                  CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAS006
     C                   Z-ADD     905           DBASE                                        CAS006
     C                   MOVEL     'CAS006'      DBKEY                                        CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
      *                                                                                       CAS006
     C     PRTCD         IFEQ      *BLANKS                                                    CAS006
     C                   MOVEL     'Y'           CAS006                                       CAS006
     C                   MOVEL     *ON           *IN76                                        CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVEL     'N'           CAS006                                       CAS006
     C                   MOVEL     *OFF          *IN76                                        CAS006
     C                   ENDIF                                                                CAS006
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
     C                   EVAL      *IN90 = *OFF                                               CDL038
     C                   ELSE                                                                 CDL038
     C                   EVAL      *IN90 = *ON                                                CDL038
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
