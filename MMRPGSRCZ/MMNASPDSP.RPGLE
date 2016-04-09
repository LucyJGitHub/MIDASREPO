     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NA''s Purchased Display  ')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMNASPDSP - NEGOTIABLE ASSETS PURCHASED DISPLAY              *
      *                                                               *
      *  Function:  This module displays the main details screen      *
      *             of the NA's purchased screen input function.      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR814519           Date 10Mar15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CDL049             Date 11Jul06               *
      *                 CDL038             Date 10May05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS005             Date 16Dec02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 197015             Date 18Jan02               *
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 14Dec99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 04Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR814519 - Allow negative base rate. Apply fix 226835.       *
      *             Applied for MD033488                              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  197015 - Reverse order of sending out messages in the input  *
      *           maintenance screen: Warning message first before    *
      *           confirmation message MMM1030.                       *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  CDE002 - Revenue Analysis                                    *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FMMNASPDDF CF   E             WORKSTN
     F/COPY WNCPYSRC,MMH00127
      *****************************************************************
      *                                                               *
      * FUNCTION OF INDICATORS                                        *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *                                                               *
      *       68  Position cursor on action code (if it is blank)     *
      *       69  Protect deal key fields (action code & deal number) *
      *       70  Protect deal detail fields                          *
      *       71  Enable CF07                                         *
      *       72  Enable CF08                                         *
      *       73  Enable CF10                                         *
      *       74  Enable CF14                                         *
      *       75  Enable CF15                                         *
      *       79  Highlight deal status                               *
      *                                                               *
      *       80  Not multibranching                                  *
      *       81  Originating branch not used                         *
      *       82  Profit centres not used                             *
      *       83  Profit Centre Accounting not installed              *
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CDE002
      ** External DS for SAR details                                            CDE002
                                                                                CDE002
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D MMNASP        E DS                  EXTNAME(MMNASPPD)
     D MMELDN        E DS                  EXTNAME(MMENASPPD)
 
     D                 DS
     D  DDFOTX                 1     40
     D  DDSIDN                10     15
 
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
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
                                                                                              CAS001
 
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
      * MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *                                                                                     AR814519
      ** Set DDNEGV.                                                                        AR814519
      *                                                                                     AR814519
     C                   MOVE      ' '           DDNEGV                                     AR814519
     C                   MOVE      '0'           *IN85                                      AR814519
     C                   MOVE      '0'           *IN86                                      AR814519
     C     OKINTR        IFEQ      'Y'                                                      AR814519
     C     OKMTTI        ANDEQ     'Y'                                                      AR814519
     C     '-'           SCAN      DDMTTI                                 85                AR814519
     C     '-'           SCAN      DDINTR                                 86                AR814519
     C     *IN85         IFEQ      '1'                                                      AR814519
     C     *IN86         OREQ      '1'                                                      AR814519
     C                   MOVE      'Y'           DDNEGV                                     AR814519
     C                   ELSE                                                               AR814519
     C                   MOVE      'N'           DDNEGV                                     AR814519
     C                   ENDIF                                                              AR814519
     C                   ENDIF                                                              AR814519
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
     C     DDACTN        COMP      *BLANK                                 68
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
     C/COPY WNCPYSRC,MMH00074
      *
      * WRITE MESSAGE SUBFILE, DETAILS AND FOOTER SCREEN
      *
     C                   TIME                    DDTIME
     C                   WRITE     MMNASPS0
     C                   WRITE     MMNASPD1
     C                   WRITE     MMNASPF1
      *
      * READ DETAILS SCREEN,
      *
      * If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      MMNASPD1                               99    *
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
      *****************************************************************
      *                                                               *
      * ERRWOD  - OUTPUT ERROR MESSAGES WITHOUT DATA                  *
      *                                                               *
      *****************************************************************
     C     ERRWOD        BEGSR
      *
      *  Display error message
      *
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     @MSGID        ZAMSID
     C                   CALL      'ZA0240'
     C                   PARM                    ZAMSID           10
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ERRWID  - OUTPUT ERROR MESSAGES WITH DATA                     *
      *                                                               *
      *****************************************************************
     C     ERRWID        BEGSR
      *
      *  Display error message
      *
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     @MSGID        ZAMSID
     C/COPY WNCPYSRC,MMH00116
     C                   CALL      'ZA0440'
     C                   PARM                    ZAMSID           10
     C                   PARM      @MSGDT        ZAMDTA           45
     C/COPY WNCPYSRC,MMH00117
      *
     C                   ENDSR
      ********************************************************************
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
     C                   PARM                    MMNASP
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *
      * FIELDS IN ERROR
     C                   PARM                    MMELDN
     C/COPY WNCPYSRC,MMH00075
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
      *
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      *
      ** Initialize program name
      *
     C                   MOVEL     'MMNASPDSP'   DBPGM
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     DDWID
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
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
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
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
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 900 *
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR                                        *************
     C                   END
      *                                                                         CDE002
      ** Access SAR details file to determine if CDE002 is switched on          CDE002
      *                                                                         CDE002
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
     C                   EVAL      DBASE = 904                                                CAS001
     C                   EVAL      DBKEY = 'CAS001'                                           CAS001
     C                   EXSR      *PSSR                                                      CAS001
     C                   ENDIF                                                                CAS001
     C                   IF        PRTCD = *BLANKS                                            CAS001
     C                   EVAL      CAS001 = 'Y'                                               CAS001
     C                   EVAL      *IN84 = *ON                                                CAS001
     C                   ELSE                                                                 CAS001
     C                   EVAL      CAS001 = 'N'                                               CAS001
     C                   EVAL      *IN84 = *OFF                                               CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS005
      ** Access SAR details file to determine if CAS005 is on.                                CAS005
      ** (Enhancements to CAS001, CAS002 and CAS004)                                          CAS005
                                                                                              CAS005
     C                   CALLB     'AOSARDR0'                                                 CAS005
     C                   PARM      *BLANKS       PRTCD                                        CAS005
     C                   PARM      '*VERIFY'     POPTN                                        CAS005
     C                   PARM      'CAS005'      PSARD                                        CAS005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS005
     C                   IF        PRTCD <> *BLANKS AND                                       CAS005
     C                             PRTCD <> '*NRF   '                                         CAS005
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS005
     C                   EVAL      DBASE = 905                                                CAS005
     C                   EVAL      DBKEY = 'CAS005'                                           CAS005
     C                   EXSR      *PSSR                                                      CAS005
     C                   ENDIF                                                                CAS005
     C                   IF        PRTCD = *BLANKS                                            CAS005
     C                   EVAL      *IN85 = *ON                                                CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      *IN85 = *OFF                                               CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CDL038
      ** Access SAR details file to determine if CDL038 is on.                                CDL038
      ** (Extended Deal Sub Type)                                                             CDL038
                                                                                              CDL038
     C                   CALLB     'AOSARDR0'                                                 CDL038
     C                   PARM      *BLANKS       PRTCD                                        CDL038
     C                   PARM      '*VERIFY'     POPTN                                        CDL038
     C                   PARM      'CDL038'      PSARD                                        CDL038
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL038
     C                   IF        PRTCD = *BLANKS                                            CDL038
     C                   EVAL      *IN90 = *OFF                                               CDL038
     C                   ELSE                                                                 CDL038
     C                   EVAL      *IN90 = *ON                                                CDL038
     C                   ENDIF                                                                CDL038
                                                                                CDE002
     C/COPY WNCPYSRC,MMH00076
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
     C                   MOVE      '1'           *IN81
     C                   END
      *
      * Profit Centres not used (protect profit centre)
      *
     C     BKPRCU        IFNE      'Y'
     C                   MOVE      '1'           *IN82
     C                   END
      *
      ** Profit Centre Accounting not installed (protect funding fields)
      ** and Revenue Analysis not installed                                     CDE002
      *
     C     BGN0ST        IFNE      'Y'
     C     CDE002        ANDNE     'Y'                                          CDE002
     C                   MOVE      '1'           *IN83
     C                   END
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
(c) Misys International Banking Systems Ltd. 2001
** @Z0
000000000000000000000000000000000000000000000000000000000000
** @NAR
Deal No. 999999 successfully inserted.
F10=CONFIRM DELETE
