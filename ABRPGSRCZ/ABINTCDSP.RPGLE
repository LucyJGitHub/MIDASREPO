     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Internal contract display')
      *****************************************************************
      *                                                               *
      *  Midas - Internal Contracts (Dealing) Module                  *
      *                                                               *
      *  ABINTCDSP - INTERNAL CONTRACT DISPLAY                        *
      *                                                               *
      *  Function:  This module displays the main details screen of   *
      *             the internal contract screen input function.      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CDL038             Date 10May05               *
      *  Prev Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 196429             Date 21Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 08Sep98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  196429 - Recompiled over changed ABINTDDF                    *
      *  CAP004 - API's Phase 3.                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FABINTCDDF CF   E             WORKSTN
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *                                                               *
      *       68  Position cursor on action code (if it is blank)     *
      *       69  Protect deal key fields (action code & deal numbers)*
      *       70  Protect deal detail fields                          *
      *       71  Enable CF07                                         *
      *       72  Enable CF08                                         *
      *       73  Enable CF10                                         *
      *       74  Enable CF15                                         *
      *       79  Highlight deal status                               *
      *                                                               *
      *       80  Not multibranching                                  *
      *       81  Originating branch not used                         *
      *       82  Profit centres not used                             *
      *       83  Profit centre accounting not used                   *
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
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
     D @NAR            S             46    DIM(2) CTDATA PERRCD(1)
 
     D @EI             S              1    DIM(60)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULE DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL038
      ** EXTERNAL DS FOR SWITCHABLE FEATURE DETAILS                                           CDL038
                                                                                              CDL038
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
 
     D ABINTC        E DS                  EXTNAME(ABINTCPD)
     D ABEINTC       E DS                  EXTNAME(ABEINTCPD)
 
     D                 DS
     D  DDFOTX                 1     46
     D  DDSIDN1                7     12
     D  DDSIDN2               18     23
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
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
     C                   MOVEA     ABEINTC       @EI
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
      * POSITION CURSOR ON ACTION CODE IF IT IS BLANK
      *
     C     DDACTN        COMP      *BLANK                                 68
      *
      * ENABLE KEY FIELDS (ACTION CODE & DEAL NUMBERS)
      *
     C     @EKYFD        COMP      'Y'                                6969
      *
      * ENABLE DETAIL FIELDS (ALL FIELDS EXCEPT ACTION CODE & DEAL NUMBERS)
      *
     C     @EDTFD        COMP      'Y'                                7070
      *
      * ENABLE FUNCTION KEYS
      *
     C     @EINKG        COMP      'Y'                                    71
     C     @EINKH        COMP      'Y'                                    72
     C     @EINKJ        COMP      'Y'                                    73
     C     @EINKP        COMP      'Y'                                    74
      *
      * DEAL STATUS
      *
     C     DDSTS         COMP      *BLANK                             7979
      *
      * TEXT = SUCCESSFUL INSERT
      *
     C     @SIDN1        IFNE      *BLANK
     C                   MOVEL     @NAR(1)       DDFOTX
     C                   MOVEL     @SIDN1        DDSIDN1
     C                   MOVEL     @SIDN2        DDSIDN2
     C                   MOVEL     *BLANK        @SIDN1
     C                   MOVEL     *BLANK        @SIDN2
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
      *
      * WRITE MESSAGE SUBFILE, DETAILS AND FOOTER SCREEN
      *
     C                   TIME                    DDTIME
     C                   WRITE     ABINTCS0
     C                   WRITE     ABINTCD1
     C                   WRITE     ABINTCF1
      *
      * READ DETAILS SCREEN,
      *
      * If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      ABINTCD1                               99    *
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
     C                   CALL      'ZA0440'
     C                   PARM                    ZAMSID           10
     C                   PARM      @MSGDT        ZAMDTA           45
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
     C                   PARM                    ABINTC
      *
      * 2nd Leg Exchange Rate
      * 2nd Leg Buy Currency
      * 2nd Leg Buy Amount
      * 2nd Leg Sell Currency
      * 2nd Leg Sell Amount
      * Loan Interest Amount
      * Deposit Interest Amount
     C                   PARM                    DDL2RT           13
     C                   PARM                    DDL2CB            3
     C                   PARM                    DDL2BA           16
     C                   PARM                    DDL2CS            3
     C                   PARM                    DDL2SA           16
     C                   PARM                    DDLOIA           17
     C                   PARM                    DDDPIA           17
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *
      * FIELDS IN ERROR
     C                   PARM                    ABEINTC
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
      * KP = COMMAND KEY 15 = BROWSE
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKP            1
      *
      * SUCCESFUL INSERT DEALS
     C                   PARM                    @SIDN1            6
     C                   PARM                    @SIDN2            6
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
      *
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      *
      ** Initialize program name
      *
     C                   MOVEL     'ABINTCDSP'   DBPGM
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
                                                                                              CDL038
      ** Access SAR details file to determine if CDL038 is switched on                        CDL038
      ** (Extended Deal Sub Type)                                                             CDL038
                                                                                              CDL038
     C                   Call      'AOSARDR0'                                                 CDL038
     C                   Parm      *Blanks       @RTCD                                        CDL038
     C                   Parm      '*VERIFY'     @OPTN                                        CDL038
     C                   Parm      'CDL038'      @SARD             6                          CDL038
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL038
      *                                                                                       CDL038
     C                   IF        @RTCD = *BLANKS                                            CDL038
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
      * Profit Centre Accounting not used
      *
     C     BGN0ST        IFNE      'Y'
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
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** @Z0
000000000000000000000000000000000000000000000000000000000000
** @NAR
Deals 999999 and 999999 successfully inserted.
F10=CONFIRM DELETE
