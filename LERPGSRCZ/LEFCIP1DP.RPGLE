     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility display 1')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEFCIP1DP  - LE Facility Display                             *
      *                                                               *
      *  Function:  This module displays the main details screen      *
      *             of the Facility screen input function.            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *                                                               *
      *  Last Amend No. CSF011A            Date 28Nov11               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG23786           Date 21Apr09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CLE034             Date 05May03               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CLE029             Date 04Sep02               *
      *                 CAP073  *CREATE    Date 180302                *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23786 - Incorrect values in Previous and Penultimate Date *
      *             fields when Facility amended in WIP (Recompile)   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A.           *
      *           (Recompiled)                                        *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CLE029 - Addition of Severity code and Limit ID to FCLTYFM   *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *           use as APIs. Facility input Transaction Details     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FLEFCIP1DDFCF   E             WORKSTN INFSR(*PSSR)
      *
      *****************************************************************
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
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
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
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
     D @NAR            S             48    DIM(2) CTDATA PERRCD(1)
      *
     D @EI             S              1    DIM(60)
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  Midas modules details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **   CUSTOMER
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, SHORT data structure
      *
     D CurPriScn     E DS                  EXTNAME(LEFCPPPD)
     D OKFcPrim      E DS                  EXTNAME(LEEFCIPPD)
      *
     D                 DS
     D  DDFOTX                 1     48
     D  DDFACR                15     25
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
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
      ***  Main processing
      *
     C                   EXSR      MAIN
      *
      ***  Return
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   END
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing                                        *
      *****************************************************************
     C     MAIN          BEGSR
      *
      ** Set up Customer Shortname as DDCSSN should contain the Customer number
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      DDCSSN        @KEY1            10
     C                   PARM                    @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     *BLANK        DDNAME
     C                   MOVEL     BBCSSN        DDNAME
     C                   ELSE
     C                   MOVEL     *BLANK        DDNAME
     C                   ENDIF
      *
      ***  Move 'OK' flags into array (for checking)
      *
     C                   MOVEA     OKFcPrim      @EI
      *
      ***  Set screen error indicators according to status of 'OK' flags
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
      ***  Do while error messages found
      ***  write error messages (with or without data) to sub-file
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     MsgIdArr(C)   ZMSID
     C                   MOVEL     MsgDtaArr(C)  ZMSDA
      *
     C                   EXSR      ERRMSG
      *
     C                   ADD       1             C
     C                   END
      *
      ***  Do while warning messages found
      ***  Write warning messages (with or without data) to sub-file
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     WFldNamArr(C) ANDNE     *BLANKS
     C                   MOVEL     WMsgIdArr(C)  ZMSID
     C                   MOVEL     WMsgDtaArr(C) ZMSDA
      *
     C                   EXSR      ERRMSG
      *
     C                   ADD       1             C
     C                   END
      *
      ***  Do not display the field 'Rev. CR changed' if blank
      *
     C     DDRVCD        COMP      *BLANK                                 59
      *
      ***  Position cursor on action code if it is blank
      *
     C     DDACTN        COMP      *BLANK                                 68
      *
      ***  Enable key fields (action code & Fclty ref)
      *
     C     @EKYFD        COMP      'Y'                                6969
      *
      ***  Enable detail fields (all fields except action code & Fclty ref)
      *
     C     @EDTFD        COMP      'Y'                                7070
      *
      ***  Enable function keys
      *
     C     @EINKP        COMP      'Y'                                    73    F15
     C     @EINKG        COMP      'Y'                                    74    F07
     C     @EINKH        COMP      'Y'                                    74    F08
     C     @EINKJ        COMP      'Y'                                    76    F10
     C     @EINKV        COMP      'Y'                                    77    F21
     C     @EINKW        COMP      'Y'                                    71    F22
     C     @EINKX        COMP      'Y'                                    72    F23
      *
      ***  Text = SUCCESSFUL INSERT
      *
     C     @SIFACR       IFNE      *BLANK
     C                   MOVEL     @NAR(1)       DDFOTX
     C                   MOVEL     @SIFACR       DDFACR
     C                   MOVEL     *BLANK        @SIFACR
     C                   ELSE
      *
      ***  Text = CONFIRM REVERSE or CLOSE
      *
     C     @EINKJ        IFEQ      'Y'
     C                   MOVEL     @NAR(2)       DDFOTX
     C                   ELSE
     C                   MOVEL     *BLANKS       DDFOTX
     C                   END
     C                   END
      *
      ***  Write message sub-file, details and footer screen
      *
     C                   WRITE     LEFCIPD1
     C                   WRITE     LEFCIPF1
     C                   WRITE     LEFCIPC1
      *
      ***  Read details screen,
      *
      ***  If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      LEFCIPD1                               99
     C                   ENDIF
      *
      ***  Clear message subfile
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGMQ        ZAPGMQ
     C                   PARM                    ZAPGRL
      *
      ***  Set screen error indicators OFF
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      ***  Set return keys
      *
     C                   MOVE      *INKC         @INKC                          F03
     C                   MOVE      *INKG         @INKG                          F07
     C                   MOVE      *INKH         @INKH                          F08
     C                   MOVE      *INKJ         @INKJ                          F10
     C                   MOVE      *INKL         @INKL                          F12
     C                   MOVE      *INKP         @INKP                          F15
     C                   MOVE      *INKV         @INKV                          F21
     C                   MOVE      *INKW         @INKW                          F22
     C                   MOVE      *INKX         @INKX                          F23
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ERRMSG  - Output error messages                               *
      *****************************************************************
     C     ERRMSG        BEGSR
      *
      ***  Display error message
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM      DDPGMQ        ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZMSID             7            Message Id.
     C                   PARM                    ZMSGF                          Message file.
     C                   PARM                    ZMSDA           132            Message data.
     C                   PARM                    ZMSTP             7            Message type.
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing.                                  *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Parameters
      *
     C     *ENTRY        PLIST
      *
      *
      ***  INPUT PARAMETERS
      *
      ***  Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ***  Fclty (in screen format)
     C                   PARM                    CurPriScn
      *
      ***  Fields in error
 
     C                   PARM                    OkFcPrim
      *
      ***  Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Enabled key & detail fields
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      ***  Enabled function keys
      *
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKP            1
     C                   PARM                    @EINKV            1
     C                   PARM                    @EINKW            1
     C                   PARM                    @EINKX            1
      *
      ***  Succesful insert
      *
     C                   PARM                    @SIFACR          11
      *
      * General ledger details used for Profit center validation
     C                   PARM                    BKPRCU            1
     C                   PARM                    BKPRCA            1
      *
      ***  CLE005
     C                   PARM                    CLE005            1
      *
      ***  CLE006
     C                   PARM                    CLE006            1
      *
      ***  CLE007
     C                   PARM                    CLE007            1
      *
      ***  OUTPUT PARAMETERS
      *
      ***  Function keys
      *
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
     C                   PARM                    @INKV             1
     C                   PARM                    @INKW             1
     C                   PARM                    @INKX             1
     C                   PARM                    WriteOnly         1
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LEFCIP1DP'   DBPGM
      *
      ***  Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Retrieve midas module details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
     C     BGMBIN        IFEQ      'Y'
     C                   MOVE      *ON           *IN81
     C                   ENDIF
      *
      ** Do not display some fields if CLE005 is off
     C     CLE005        IFEQ      'Y'
     C                   MOVE      '1'           *IN82
     C                   ELSE
     C                   MOVE      '0'           *IN82
     C                   END
      *
      **  CHECK IF 'PROFIT CENTRE USED'
     C     BKPRCU        IFEQ      'N'
     C                   MOVE      *ON           *IN84
     C                   MOVE      *ON           *IN58
     C                   ELSE
     C                   MOVE      *OFF          *IN84
     C                   MOVE      *OFF          *IN58
     C                   ENDIF
      *
      **    CHECK IF 'PROFIT CENTRE AMENDABLE'
     C     BKPRCA        IFEQ      'N'
     C                   MOVE      *ON           *IN84
     C                   ELSE
     C                   MOVE      *OFF          *IN84
     C                   END
      *
      ** Do not display some fields if CLE006 is off
     C     CLE006        IFEQ      'Y'
     C                   MOVE      '1'           *IN85
     C                   ELSE
     C                   MOVE      '0'           *IN85
     C                   END
      *
      ** Do not display some fields if CLE007 is off
     C     CLE007        IFEQ      'Y'
     C                   MOVE      '1'           *IN88
     C                   ELSE
     C                   MOVE      '0'           *IN88
     C                   END
      *
      ***  Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     'LEFCIP1DP'   DDPGMQ           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     'GBLERMSGF'   ZMSGF            10
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
** @Z0
000000000000000000000000000000000000000000000000000000000000
** @NAR
Facility Ref. 99999999999 successfully inserted.
F10=CONFIRM REVERSE/CLOSE
