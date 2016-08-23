     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Deal display')                                *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  FXFXDLDSP - FX DEALS DISPLAY                                 *
      *                                                               *
      *  Function:  This module displays the main details screen of   *
      *             the foreign exchange deal screen input function.  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. 232756             Date 19Aug14               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CDL038             Date 10May05               *
      *                 CGL029             Date 01Sep03               *
      *                 215637             Date 20Mar03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 196952             Date 06May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 197015             Date 18Jan02               *
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 185612             Date 22May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 193017             Date 08May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 01Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 22Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  232756 - Recompiled over changes done in file FXFXDLDDF.     *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  215637 - Confirmation Matching Status are shown eventhough   *
      *           Confirmation Matching is not switched on.  Used     *
      *           indicators 76 and 77 to be the controlling          *
      *           indicators instead of 66 and 67 as this indicators  *
      *           were used for screen error processing.              *
      *  196952 - Recompiled over changed FXFXDLPD and FXFXDLDDF.     *
      *  197015 - Reverse order of sending out messages in the input  *
      *           maintenance screen: Warning message first before    *
      *           confirmation message MMM1030.                       *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  185612 - Warning for FOREX Limit exceeded.                   *
      *  193017 - Confirmation matching status fields added           *
      *  CDL008 - Continuous Linked Settlement                        *
      *  CPB001 - 'Private Banking' Module                            *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFXFXDLDDF CF   E             WORKSTN
     FCFFEEDL0  IF   E           K DISK                                                       193017
     F/COPY WNCPYSRC,FXH00058
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *                                                               *
      ********66**Non-display*counterparty*info*(if ON)****************                193017 215637
      ********67**Non-display*broker*info*(if ON)**********************                193017 215637
      *       76  Non-display counterparty info (if ON)               *                       215637
      *       77  Non-display broker info (if ON)                     *                       215637
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
      *       83  Portfolio management not installed                  *
      *       84  Margin & Forward Points not installed               *
      *       85  FX Netting not installed                            *
      *       86  Net Manual Matching Not Required                    *
      *       87  Private Banking module not installed                *
      *       88  CLS Settlement not installed                        *
      *       90  Extended Deal Sub Type not installed                *                       CDL038
      *                                                               *
      *       96  Subfile control                                     *
      *       97  Subfile end                                         *
      *       99  Search indicator                                    *                       193017
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
                                                                                              193017
      *   Counterparty and Broker STATUS Codes and associated text                            193017
     D TABA            S              2A   DIM(16) PERRCD(1) CTDATA                           193017
     D TABB            S             15A   DIM(16) ALT(TABA)                                  193017
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULE DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEAL ICD DETAILS
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SWITCHABLE FEATURE DETAILS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CER043
      ** EXTERNAL DS FOR CUSTOMER DETAILS                                                     CER043
                                                                                              CER043
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
 
     D FXFXDL        E DS                  EXTNAME(FXFXDLPD)
     D FXEFXD        E DS                  EXTNAME(FXEFXDLPD)
     D/COPY WNCPYSRC,FXFXDLXD01
 
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
     D CER043          S              1A                                                      CER043
     D PCNum           S             10A                                                      CER043
     D PKey7           S              7A                                                      CER043
 
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
      *                                                                                       215637
      ** Confirmation matching status - if not turned on, do not                              215637
      ** display the fields                                                                   215637
      *                                                                                       215637
     C                   IF        BGCFMT = 'Y'                                               215637
     C                   EVAL      *IN76 = *Off                                               215637
     C                   EVAL      *IN77 = *Off                                               215637
     C                   MOVE      'Y'           CONFM             1                          215637
     C                   ELSE                                                                 215637
     C                   EVAL      *IN76 = *On                                                215637
     C                   EVAL      *IN77 = *On                                                215637
     C                   MOVE      'N'           CONFM                                        215637
     C                   ENDIF                                                                215637
      *                                                                                       185612
      ** Check for confirmation screen message and use to condition                           185612
      ** of MDDR text (inserts and authorisations only)                                       185612
      *                                                                                       185612
     C                   MOVE      '1'           *IN87                                        185612
     C     MsgIdArr(1)   IFEQ      'MMM1030'                                                  185612
     C     DDACTN        ANDEQ     'I'                                                        185612
     C     MsgIdArr(1)   OREQ      'MMM1030'                                                  185612
     C     DDACTN        ANDEQ     'X'                                                        185612
     C                   MOVE      '0'           *IN87                                        185612
     C                   ENDIF                                                                185612
      *
      * MOVE 'OK' FLAGS INTO ARRAY (FOR CHECKING)
      *
     C                   MOVEA     FXEFXD        @EI
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
     C/COPY WNCPYSRC,FXH00194
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
      *                                                                                       193017
      ** Set up the confirmation matching fields, if confirmation matching                    193017
     C/COPY WNCPYSRC,FXFXDLXC01
      ** is turned on.                                                                        193017
      *                                                                                       193017
     C                   IF        CONFM = 'Y'                                                193017
     C                   EXSR      Conf_Match                                                 193017
     C                   ENDIF                                                                193017
      *                                                                                       CER043
      ** Set up additional customer details                                                   CER043
      *                                                                                       CER043
     C                   IF        CER043 = 'Y'                                               CER043
     C                   EVAL      *IN78 = *OFF                                               CER043
     C                   EVAL      PCNum = DDCUST                                             CER043
     C                   EXSR      RtvCustDtls                                                CER043
     C                   ELSE                                                                 CER043
     C                   EVAL      *IN78 = *ON                                                CER043
     C                   ENDIF                                                                CER043
     C/COPY WNCPYSRC,FXH00045
      *
      * WRITE MESSAGE SUBFILE, DETAILS AND FOOTER SCREEN
      *
     C                   TIME                    DDTIME
     C                   WRITE     FXFXDLS0
     C                   WRITE     FXFXDLD1
     C                   WRITE     FXFXDLF1
      *
      * READ DETAILS SCREEN,
      *
      * If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      FXFXDLD1                               99    *
     C                   ENDIF
     C/COPY WNCPYSRC,FXFXDLXC04
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
     C/COPY WNCPYSRC,FXH00054
     C                   CALL      'ZA0440'
     C                   PARM                    ZAMSID           10
     C                   PARM      @MSGDT        ZAMDTA           45
     C/COPY WNCPYSRC,FXH00055
     C*
     C                   ENDSR
     C********************************************************************
      /EJECT                                                                                  193017
      *****************************************************************                       193017
      *                                                               *                       193017
      * Conf_Match - Set up confirmation matching screen info         *                       193017
      *                                                               *                       193017
      *****************************************************************                       193017
     C     Conf_Match    BegSr                                                                193017
      *                                                                                       193017
      ** Do not display both confirmation matching status lines if..                          193017
      *                                                                                       193017
      ** ... mode is insert or no mode selected, or the deal number is                        193017
      ** invalid.                                                                             193017
      *                                                                                       193017
     C                   If        DDACTN = 'I' or DDACTN = *Blanks                           193017
     C                             or *IN11 = *On                                             193017
     C**********         Eval      *IN66 = *On                                         193017 215637
     C**********         Eval      *IN67 = *On                                         193017 215637
     C                   Eval      *IN76 = *On                                                215637
     C                   Eval      *IN77 = *On                                                215637
     C                   EndIf                                                                193017
      *                                                                                       193017
      ** If in enquire, amend, delete or authorise mode...                                    193017
      *                                                                                       193017
     C                   If        DDACTN = 'E' or DDACTN = 'A' or                            193017
     C                             DDACTN = 'D' or DDACTN = 'X'                               193017
      *                                                                                       193017
      ** ... do not display the broker status if the broker is 'PHON'                         193017
      ** 'TELX', 'MAIL' or 'SWAP'.                                                            193017
      *                                                                                       193017
     C                   If        DDBRKR = 'PHON' or DDBRKR = 'TELX' or                      193017
     C                             DDBRKR = 'MAIL' or DDBRKR = 'SWAP'                         193017
     C**********         Eval      *IN67 = *On                                         193017 215637
     C                   Eval      *IN77 = *On                                                215637
     C                   EndIf                                                                193017
      *                                                                                       193017
     C                   EndIf                                                                193017
      *                                                                                       193017
      ** Clear previous information.                                                          193017
      *                                                                                       193017
     C                   Eval      SCTPTY = *Blanks                                           193017
     C                   Eval      SBROKR = *Blanks                                           193017
      *                                                                                       193017
      ** If the confirmation matching details are going to be displayed,                      193017
      ** get the status from file.                                                            193017
      *                                                                                       193017
     C**********         If        *IN66 = *OFF or *IN67 = *OFF                        193017 215637
     C                   If        *IN76 = *OFF or *IN77 = *OFF                               215637
      *                                                                                       193017
      ** Set up key to chain to file                                                          193017
      *                                                                                       193017
     C                   Move      *Blanks       CFFeed_Key       16                          193017
     C                   Move      *Blanks       Work_8            8                          193017
     C                   Move      *Blanks       Work_11          11                          193017
                                                                                              193017
     C                   MoveL     'DL'          Work_8                                       193017
     C                   Move      DDDLNO        Work_8                                       193017
     C                   MoveL     Work_8        Work_11                                      193017
     C                   Move      '999'         Work_11                                      193017
     C                   MoveL     Work_11       CFFeed_Key                                   193017
      *                                                                                       193017
      ** Check file for latest status of deal                                                 193017
      *                                                                                       193017
     C     CFFeed_Key    SetGT     CFFEEDL0                                                   193017
     C                   ReadP     CFFEEDL0                               99                  193017
                                                                                              193017
     C                   If        *IN99 = *Off                                               193017
     C                   MoveL     IMRF          Work8_2           8                          193017
     C     Work_8        Comp      Work8_2                            9999                    193017
     C                   EndIf                                                                193017
      *                                                                                       193017
      ** If no record with deal key set status to 00 - No feedback yet,                       193017
      ** otherwise set up the status as found on file                                         193017
      *                                                                                       193017
     C                   If        *IN99 = *On                                                193017
     C                   Move      '00'          @CPST             2                          193017
     C                   Move      '00'          @BKST             2                          193017
     C                   Else                                                                 193017
     C                   Move      CPSX          @CPST                                        193017
     C                   Move      BKSX          @BKST                                        193017
     C                   EndIf                                                                193017
      *                                                                                       193017
      ** Set up associated status text for counterparty, if required                          193017
      *                                                                                       193017
     C**********         If        *IN66 = *Off                                        193017 215637
     C                   If        *IN76 = *Off                                               215637
     C     @CPST         LookUp    TABA          TABB                     99                  193017
     C                   MoveL     TABB          SCTPTY                                       193017
     C                   EndIf                                                                193017
      *                                                                                       193017
      ** Set up associated status text for broker, if required                                193017
      *                                                                                       193017
     C**********         If        *IN67 = *Off                                        193017 215637
     C                   If        *IN77 = *Off                                               215637
     C     @BKST         LookUp    TABA          TABB                     99                  193017
     C                   MoveL     TABB          SBROKR                                       193017
     C                   EndIf                                                                193017
      *                                                                                       193017
     C                   EndIf                                                                193017
      *                                                                                       193017
     C                   EndSr                                                                193017
      ********************************************************************                    193017
      /EJECT
      *****************************************************************                       CER043
      *                                                               *                       CER043
      * RtvCustDtls - Set up additional customer details              *                       CER043
      *                                                               *                       CER043
      *  Called by: Main                                              *                       CER043
      *                                                               *                       CER043
      *  Calls: None                                                  *                       CER043
      *                                                               *                       CER043
      *****************************************************************                       CER043
     C     RtvCustDtls   BEGSR                                                                CER043
      *                                                                                       CER043
      ** Call AOCUSTR0 to get Customer Details                                                CER043
      *                                                                                       CER043
     C                   CALLB     'AOCUSTR0'                                                 CER043
     C                   PARM      *BLANKS       PRtcd                                        CER043
     C                   PARM      '*KEY   '     POptn                                        CER043
     C                   PARM                    PCNum                                        CER043
     C                   PARM      *BLANKS       PKey7                                        CER043
     C     SDCUST        PARM      SDCUST        DSSDY                                        CER043
                                                                                              CER043
     C                   IF        PRTCD <> *BLANKS AND                                       CER043
     C                             PRTCD <> '*NRF   '                                         CER043
     C     *LOCK         IN        LDA                                                        CER043
     C                   EVAL      DBFILE = 'SDCUSTPD'                                        CER043
     C                   EVAL      DBASE = 910                                                CER043
     C                   EVAL      DBKEY = PCnum                                              CER043
     C                   OUT       LDA                                                        CER043
     C                   EXSR      *PSSR                                                      CER043
     C                   ENDIF                                                                CER043
                                                                                              CER043
     C                   IF        PRTCD = *BLANKS                                            CER043
     C                   EVAL      DDCSSN = BBCSSN                                            CER043
     C                   EVAL      DDCRNM = BBCRNM                                            CER043
     C                   EVAL      DDCRTN = BBCRTN                                            CER043
     C                   EVAL      *IN51 = *OFF                                               CER043
     C                   ELSE                                                                 CER043
     C                   EVAL      DDCSSN = *BLANKS                                           CER043
     C                   EVAL      DDCRNM = *BLANKS                                           CER043
     C                   EVAL      DDCRTN = *BLANKS                                           CER043
     C                   EVAL      *IN51 = *ON                                                CER043
     C                   ENDIF                                                                CER043
                                                                                              CER043
     C                   ENDSR                                                                CER043
      *****************************************************************                       CER043
      /EJECT                                                                                  CER043
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
     C                   PARM                    FXFXDL
      *
      * NET BUY/SELL REFERENCE
     C                   PARM                    DDNBRF
     C                   PARM                    DDNSRF
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
     C/COPY WNCPYSRC,FXH00113
      *
      * FIELDS IN ERROR
     C                   PARM                    FXEFXD
     C/COPY WNCPYSRC,FXH00046
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
      *                                                                                       185612
      ** Maximum Daily Delivery Risk fields:                                                  185612
      *                                                                                       185612
     C                   PARM                    DDMDDR           16                          185612
     C                   PARM                    DDEXP1           16                          185612
     C                   PARM                    DDEXP2           16                          185612
     C                   PARM                    DDLIM1            3                          185612
     C                   PARM                    DDLIM2            3                          185612
     C                   PARM                    DDLIM3            9                          185612
     C/COPY WNCPYSRC,FXFXDLXC02
      *
      ** Initialize program name
      *
     C                   MOVEL     'FXFXDLDSP'   DBPGM
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
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
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
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS MIDAS MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS DEAL ICD DETAILS
      *
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDDEALPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access SAR details file to determine if S01453
      ** (Margin and FX Points in Base Currency) is on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01453'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '905'         DBASE
     C                   MOVEL     'S01453'      DBKEY
     C                   EXSR      *PSSR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01453            1
     C                   ELSE
     C                   MOVEL     'N'           S01453
     C                   END
      *
      ** Check if FX netting on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '906'         DBASE
     C                   MOVEL     'CDL002'      DBKEY
     C                   EXSR      *PSSR
     C                   END
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CDL002            1
     C                   ELSE
     C                   MOVEL     'N'           CDL002
     C                   END
      *                                                                         CDL008
      ** Access SAR details file to determine if CDL008 is on.                  CDL008
      ** (Continuous Linked Settlement)                                         CDL008
      *                                                                         CDL008
     C                   CALLB     'AOSARDR0'                                   CDL008
     C                   PARM      *BLANKS       @RTCD                          CDL008
     C                   PARM      '*VERIFY'     @OPTN                          CDL008
     C                   PARM      'CDL008'      @SARD                          CDL008
     C     SCSARD        PARM      SCSARD        DSFDY                          CDL008
     C     @RTCD         IFNE      *BLANKS                                      CDL008
     C     @RTCD         ANDNE     '*NRF   '                                    CDL008
     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL008
     C                   MOVEL     '907'         DBASE                          CDL008
     C                   MOVEL     'CDL008'      DBKEY                          CDL008
     C                   EXSR      *PSSR                                        CDL008
     C                   ENDIF                                                  CDL008
     C     @RTCD         IFEQ      *BLANKS                                      CDL008
     C                   MOVEL     'Y'           CDL008            1            CDL008
     C                   ELSE                                                   CDL008
     C                   MOVEL     'N'           CDL008                         CDL008
     C                   ENDIF                                                  CDL008
                                                                                              CAS001
      ** Access SAR details file to determine if CAS001 is on.                                CAS001
      ** (Net Present Value Accounting)                                                       CAS001
                                                                                              CAS001
     C                   CALLB     'AOSARDR0'                                                 CAS001
     C                   PARM      *BLANKS       PRTCD                                        CAS001
     C                   PARM      '*VERIFY'     POPTN                                        CAS001
     C                   PARM      'CAS001'      PSARD                                        CAS001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS001
                                                                                              CAS001
     C                   IF        PRTCD <> *BLANKS AND                                       CAS001
     C                             PRTCD <> '*NRF   '                                         CAS001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS001
     C                   EVAL      DBASE = 908                                                CAS001
     C                   EVAL      DBKEY = 'CAS001'                                           CAS001
     C                   EXSR      *PSSR                                                      CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS001
     C                   IF        PRTCD = *BLANKS                                            CAS001
     C                   EVAL      CAS001 = 'Y'                                               CAS001
     C                   EVAL      *IN89 = *ON                                                CAS001
     C                   ELSE                                                                 CAS001
     C                   EVAL      CAS001 = 'N'                                               CAS001
     C                   EVAL      *IN89 = *OFF                                               CAS001
     C                   ENDIF                                                                CAS001
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
                                                                                              CAS001
     C/COPY WNCPYSRC,FXFXDLXC03
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
      ** Margin and FX Points in Base Currency not installed
      *
     C     S01453        IFNE      'Y'
     C                   MOVE      '1'           *IN84
     C                   END
      *
      ** FX netting not installed
      *
     C     CDL002        IFNE      'Y'
     C                   MOVE      '1'           *IN85
     C                   END
      *
      * Net Manual Matching Not Required
     C     CDL002        IFNE      'Y'
     C     BNNMAM        ORNE      'Y'
     C                   MOVE      '1'           *IN86
     C                   END
      *                                                                         CPB001
      ** Private Banking Module not installed (protect portfolio)               CPB001
      *                                                                         CPB001
     C     BGN4ST        IFNE      'Y'                                          CPB001
     C                   MOVE      '1'           *IN87                          CPB001
     C                   END                                                    CPB001
      *                                                                         CDL008
      ** CLS settlement                                                         CDL008
     C                   IF        CDL008 <> 'Y'                                CDL008
     C                   MOVE      *ON           *IN88                          CDL008
     C                   ENDIF                                                  CDL008
      *                                                                                       193017
      ** Confirmation matching status - if not turned on, do not                              193017
      ** display the fields                                                                   193017
      *                                                                                       193017
     C                   IF        BGCFMT = 'Y'                                               193017
     C**********         EVAL      *IN66 = *Off                                        193017 215637
     C**********         EVAL      *IN67 = *Off                                        193017 215637
     C                   EVAL      *IN76 = *Off                                               215637
     C                   EVAL      *IN77 = *Off                                               215637
     C                   MOVE      'Y'           CONFM             1                          193017
     C                   ELSE                                                                 193017
     C**********         EVAL      *IN66 = *On                                         193017 215637
     C**********         EVAL      *IN67 = *On                                         193017 215637
     C                   EVAL      *IN76 = *On                                                215637
     C                   EVAL      *IN77 = *On                                                215637
     C                   MOVE      'N'           CONFM                                        193017
     C                   ENDIF                                                                193017
      *                                                                                       CER043
      ** Call AOSARDR0 to check if CER043 is switched on                                      CER043
      *                                                                                       CER043
     C                   EVAL      CER043 = 'N'                                               CER043
     C                   CALLB     'AOSARDR0'                                                 CER043
     C                   PARM      *BLANKS       PRTCD                                        CER043
     C                   PARM      '*VERIFY'     POPTN                                        CER043
     C                   PARM      'CER043'      PSARD                                        CER043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER043
                                                                                              CER043
     C                   IF        PRTCD <> *BLANKS AND                                       CER043
     C                             PRTCD <> '*NRF   '                                         CER043
     C     *LOCK         IN        LDA                                                        CER043
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER043
     C                   EVAL      DBASE = 909                                                CER043
     C                   EVAL      DBKEY = 'CER043'                                           CER043
     C                   OUT       LDA                                                        CER043
     C                   EXSR      *PSSR                                                      CER043
     C                   ENDIF                                                                CER043
                                                                                              CER043
     C                   IF        PRTCD = *BLANKS                                            CER043
     C                   EVAL      CER043 = 'Y'                                               CER043
     C                   ENDIF                                                                CER043
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
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** @Z0
000000000000000000000000000000000000000000000000000000000000
** @NAR
Deal No. 999999 successfully inserted.
F10=CONFIRM DELETE
** TABA TABB (Counterparty/Broker status AND TEXT)                                            193017
00NO FEEDBACK YET                                                                             193017
01WAITING                                                                                     193017
02TIMED OUT                                                                                   193017
03SPLIT FM PAIR                                                                               193017
50PROPOSED PAIR                                                                               193017
51PAIRED ERROR-O                                                                              193017
52PAIRED ERROR-T                                                                              193017
53PAIRED ERROR-B                                                                              193017
54PROPOSED INVEST                                                                             193017
55DUPLICATE ERROR                                                                             193017
56INVESTIGATION                                                                               193017
91CORRECT                                                                                     193017
92COMPLETE                                                                                    193017
93CANCEL                                                                                      193017
97NONE EXPECTED                                                                               193017
99PAIRED NO ERROR                                                                             193017
