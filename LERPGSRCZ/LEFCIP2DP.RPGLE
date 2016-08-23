     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility display 2')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEFCIP2DP  - LE Facility Display                             *
      *                                                               *
      *  Function:  This module displays the second details screen    *
      *             of the Facility screen input function.            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *                                                               *
      *  Last Amend No. CSF011A            Date 28Nov11               *
      *  Prev Amend No. CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23786           Date 21Apr09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 243323             Date 10Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239211             Date 31Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE034             Date 05May03               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3723            Date 19Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CLE029             Date 04Sep02               *
      *                 CAP073  *CREATE    Date 180302                *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23786 - Incorrect values in Previous and Penultimate Date *
      *             fields when Facility amended in WIP (Recompile)   *
      *  243323 - Added condition prior to checking of CLE028 such    *
      *           that if @RTCD is equal to *NRF it will not issue    *
      *           database error                                      *
      *  239211 - Recompile over changes in LEFCSPPD.                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager.                               *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A.           *
      *           (Recompiled)                                        *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3723- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CLE029 - Addition of Severity code and Limit ID to FCLTYFM   *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *           use as APIs. Facility input Transaction Details     *
      *                                                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FLEFCIP2DDFCF   E             WORKSTN
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
     D @NAR            S             40    DIM(2) CTDATA PERRCD(1)
      *
     D @EI             S              1    DIM(60)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **   CUSTOMER
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, SHORT data structure
      *
     D CurPriScn     E DS                  EXTNAME(LEFCPPPD)
      *
     D CurSecScn     E DS                  EXTNAME(LEFCSPPD)
     D OKFcSeco      E DS                  EXTNAME(LEEFCISPD)
      *
     D                 DS
     D  DDFOTX                 1     40
     D  DDSIDN                10     15
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
      ***  Move 'OK' flags into array (for checking)
      *
     C                   MOVEA     OKFcSeco      @EI
      *
      ***  Initialize action code
      *
     C                   MOVEL     PActionCode   DDACTN
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
     C                   EXSR      ERRMSG
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
     C                   EXSR      ERRMSG
     C                   ADD       1             C
     C                   END
      *
      ***  Enable detail fields (all fields except action code & fclty ref)
      *
     C     @EDTFD        COMP      'Y'                                7070
      *
      ***  Enable function keys
      *
     C     @EINKJ        COMP      'Y'                                    76    F10
     C     @EINKV        COMP      'Y'                                    77    F21
     C     @EINKW        COMP      'Y'                                    71    F22
     C     @EINKX        COMP      'Y'                                    72    F23
      *
      ***  Text = CONFIRM DELETE
      *
     C     @EINKJ        IFEQ      'Y'
     C                   MOVEL     @NAR(2)       DDFOTX
     C                   ELSE
     C                   MOVEL     *BLANKS       DDFOTX
     C                   END
      *
      ***  Write message sub-file, details and footer screen
      *
     C                   WRITE     LEFCIPD2
     C                   WRITE     LEFCIPF2
     C                   WRITE     LEFCIPC2
      *
      ***  Read details screen,
      *
      ***  If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      LEFCIPD2                               99    *
     C                   ENDIF
      *
      ***  If rolldown set F12 to on
      *
     C     *IN78         IFEQ      '1'
     C                   MOVE      '1'           *INKL
     C                   ENDIF
      *
      ***  Clear message subfile
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGMQ        ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
      *
      ***  Set screen error indicators OFF
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      ***  Set return keys
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKV         @INKV
     C                   MOVE      *INKW         @INKW
     C                   MOVE      *INKX         @INKX
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
     C                   PARM      'LEFCIP2DP'   ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL                         Rel queue
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
      ***  INPUT PARAMETERS
      *
      ***  Return code
     C                   PARM                    RetCodeIn
      *
      ***  Fclty (in screen format 1)
     C                   PARM                    CurPriScn
      *
      ***  Fclty (in screen format 2 )
     C                   PARM                    CurSecScn
      *
      ***  Fields in error
     C                   PARM                    OKFcSeco
      *
      ***  Errors
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
     C                   PARM                    @EINKI            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKN            1
     C                   PARM                    @EINKP            1
     C                   PARM                    @EINKV            1
     C                   PARM                    @EINKW            1
     C                   PARM                    @EINKX            1
      *
      ***  Action code
      *
     C                   PARM                    PActionCode       1
      *
      ***  CLE006
      *
     C                   PARM                    CLE005            1
     C                   PARM                    CLE006            1
     C                   PARM                    CLE008            1
 
      * Participant Facility ind. from FCLTYFM file
     C                   PARM                    H#PRTR            1
      *
      ***  OUTPUT PARAMETERS
      *
      ***  Function keys
      *
     C                   PARM                    @INKC             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
     C                   PARM                    @INKV             1
     C                   PARM                    @INKW             1
     C                   PARM                    @INKX             1
      *
      ***  Write screen with no read indicator
      *
     C                   PARM                    WriteOnly         1
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LEFCIP2DP'   DBPGM
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
      *                                                                                      BUG3723
      ** Access Switchable SAR details for the existence of CLE028                           BUG3723
      *                                                                                      BUG3723
     C                   MOVE      'N'           CLE028            1                         BUG3723
     C                   CALLB     'AOSARDR0'                                                BUG3723
     C                   PARM      *BLANK        @RTCD                                       BUG3723
     C                   PARM      '*VERIFY'     @OPTN                                       BUG3723
     C                   PARM      'CLE028'      @SARD             6                         BUG3723
      *                                                                                      BUG3723
      ***  Database error                                                                    BUG3723
      *                                                                                      BUG3723
     C     @RTCD         IFNE      *BLANKS                                                   BUG3723
     C     @RTCD         ANDNE     '*NRF   '                                                  243323
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************BUG3723
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *BUG3723
     C                   MOVEL     @OPTN         DBKEY                          *************BUG3723
     C                   EXSR      *PSSR                                                     BUG3723
     C                   END                                                                 BUG3723
      *                                                                                      BUG3723
      ** Do not display some fields if CLE028 is off                                         BUG3723
      *                                                                                      BUG3723
     C     @RTCD         IFEQ      *BLANKS                                                   BUG3723
     C                   MOVE      'Y'           CLE028            1                         BUG3723
     C                   MOVE      '1'           *IN81                                       BUG3723
     C                   ELSE                                                                BUG3723
     C                   MOVE      'N'           CLE028                                      BUG3723
     C                   MOVE      '0'           *IN81                                       BUG3723
     C                   ENDIF                                                               BUG3723
      *
      ***  Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     'GBLERMSGF'   ZMSGF            10
      *
      ** Do not display some fields if CLE005 is off
     C     CLE005        IFEQ      'Y'
     C                   MOVE      '1'           *IN82
     C                   ELSE
     C                   MOVE      '0'           *IN82
     C                   END
      *
      ** Do not display some fields if CLE006 is off
     C     CLE006        IFEQ      'Y'
     C                   MOVE      '1'           *IN85
     C                   ELSE
     C                   MOVE      '0'           *IN85
     C                   END
      *
      ** Do not display some fields if CLE008 is off
     C     CLE008        IFEQ      'Y'
     C                   MOVE      '1'           *IN69
     C                   ELSE
     C                   MOVE      '0'           *IN69
     C                   END
      *
      ** Do not display some fields if
      ** Funding or internal facility
      ** or sub-participant or risk participant facility.                                     CLE106
     C     H#PRTR        IFEQ      'P'
     C     H#PRTR        OREQ      'I'
     C     H#PRTR        OREQ      'S'                                                        CLE106
     C     H#PRTR        OREQ      'R'                                                        CLE106
     C                   MOVE      '1'           *IN86
     C                   ELSE
     C                   MOVE      '0'           *IN86
     C                   END
      *
      ** Do not display some fields if
      ** DDMCCY is equal to Y
     C     DDMCCY        IFEQ      'Y'
     C                   MOVE      '1'           *IN87
     C                   ELSE
     C                   MOVE      '0'           *IN87
     C                   ENDIF
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
Loan No. 999999 successfully inserted.
F10=CONFIRM DELETE
