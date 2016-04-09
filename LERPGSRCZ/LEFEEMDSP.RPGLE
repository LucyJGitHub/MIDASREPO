     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee Display')                                 *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEFEEMDSP  - LE Fee Display                                  *
      *                                                               *
      *  Function:  This module displays the main details screen      *
      *             of the Fee screen input function.                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CLE139             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CLE106             Date 01Aug04               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAP078   *CREATE   Date 31Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CLE106 - Syndications Manager (Recompile)                    *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP078 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Fee input Transaction Details          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FLEFEEMDDF CF   E             WORKSTN INFSR(*PSSR)
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-41 Field Error - highlight screen fields               *
      *                                                               *
      *       51  Enable CF11                                         *
      *       52  Enable CF14                                         *
      *       53  Enable CF15                                         *
      *       54  Enable CF07-CF08                                    *
      *       56  Enable CF10                                         *
      *                                                               *
      *       61  Profit Center amendable                             *
      *       62  Facility ref is equal to blank                      *
      *       63  Analytical Accounting is installed                  *
      *       68  PC on Action code                                   *
      *       69  Protect Fee key fields (action code & Fee Ref)      *
      *                                                               *
      *       70  Protect Fee detail fields                           *
      *       72  CLE006 is on                                        *
      *       73  Loan ref is equal to blank                          *
      *       79  Rollup                                              *
      *                                                               *
      *       96  Subfile control                                     *
      *       97  Subfile end                                         *
      ********************************************************************
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
     D @Z0             S              1    DIM(50) CTDATA PERRCD(50)
     D @NAR            S             48    DIM(3) CTDATA PERRCD(1)
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
     D CrFeScnFmt    E DS                  EXTNAME(LEFEEMPD)
     D OkFee         E DS                  EXTNAME(LEEFEEMPD)
     D/COPY WNCPYSRC,LEFEEMXD01
      *
     D                 DS
     D  DDFOTX                 1     48
     D  DDFEER                 5     23
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
     C                   MOVEA     OkFee         @EI
      *
      ***  When no error position cursor on the first input field
     C                   MOVEL     '1'           *IN(68)
      *
      ***  Set screen error indicators according to status of 'OK' flags
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C     C             DOUGT     50
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   MOVEL     '0'           *IN(68)
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
      ***  Position cursor on action code if it is blank
      *
     C     DDACTN        IFEQ      *BLANK
     C                   MOVEL     '1'           *IN(68)
     C                   ENDIF
      *
      ***  Enable key fields (action code & Fee ref)
      *
     C     @EKYFD        COMP      'Y'                                6969
      *
      ***  Enable detail fields (all fields except action code & Fee ref)
      *
     C     @EDTFD        COMP      'Y'                                7070
     C/COPY WNCPYSRC,LEFEEMXC04
      *
      ***  Enable function keys
      *
     C     @EINKK        COMP      'Y'                                    51    F11
     C     @EINKN        COMP      'Y'                                    52    F14
     C     @EINKP        COMP      'Y'                                    53    F15
     C     @EINKG        COMP      'Y'                                    54    F07
     C     @EINKH        COMP      'Y'                                    54    F08
     C     @EINKJ        COMP      'Y'                                    56    F10
      *
      ***  Text = SUCCESSFUL INSERT
      *
     C     @SIFEER       IFNE      *BLANK
     C                   MOVEL     @NAR(1)       DDFOTX
     C                   MOVEL     @SIFEER       DDFEER
     C                   MOVEL     *BLANK        @SIFEER
      *
      ***  Set off screen error indicators
     C                   MOVEA     @Z0           *IN(10)
 
     C                   ELSE
      *
      ***  Text = CONFIRM DELETE
      *
     C     @EINKJ        IFEQ      'Y'
     C                   MOVEL     @NAR(2)       DDFOTX
     C                   ELSE
     C                   MOVEL     *BLANKS       DDFOTX
     C                   END
      *
      ***  Text = CONFIRM AUTHORISATION
      *
     C     @EINKK        IFEQ      'Y'
     C                   MOVEL     @NAR(3)       DDFOTX
     C                   ELSE
     C                   MOVEL     *BLANKS       DDFOTX
     C                   END
     C                   END
     C/COPY WNCPYSRC,LEFEEMXC01
      *
      ***  Write message sub-file, details and footer screen
      *
     C                   WRITE     LEFEEMD1
     C                   WRITE     LEFEEMF1
     C                   WRITE     LEFEEMC1
      *
      ***  Read details screen,
      *
      ***  If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      LEFEEMD1                               99
     C                   ENDIF
     C/COPY WNCPYSRC,LEFEEMXC03
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
     C                   MOVE      *INKK         @INKK                          F11
     C                   MOVE      *INKL         @INKL                          F12
     C                   MOVE      *INKN         @INKN                          F14
     C                   MOVE      *INKP         @INKP                          F15
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
      ***  Fee (in screen format)
     C                   PARM                    CrFeScnFmt
      *
      ***  Fields in error
 
     C                   PARM                    OkFee
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
     C                   PARM                    @EINKK            1
     C                   PARM                    @EINKN            1
     C                   PARM                    @EINKP            1
      *
      ***  Succesful insert
      *
     C                   PARM                    @SIFEER          19
      *
      ***  Feature
      *
     C                   PARM                    CLE006            1
      *
      ***  Profit Center amendable
      *
     C                   PARM                    BKPRCA            1
      *
      ***  OUTPUT PARAMETERS
      *
      ***  Function keys
      *
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKK             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKN             1
     C                   PARM                    @INKP             1
     C                   PARM                    WriteOnly         1
     C/COPY WNCPYSRC,LEFEEMXC05
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LEFEEMDSP'   DBPGM
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
     C/COPY WNCPYSRC,LEFEEMXC02
     C*
     C**  Check if Analytical Accounting is installed.
     C*
     C     BGN0ST        IFEQ      'Y'
     C                   MOVE      '1'           *IN63
     C                   ELSE
     C                   MOVE      '0'           *IN63
     C                   ENDIF
      *
      ** Do not display some fields if CLE006 is off
     C     CLE006        IFEQ      'Y'
     C                   MOVE      '1'           *IN72
     C                   ELSE
     C                   MOVE      '0'           *IN72
     C                   END
      *
      ** Check if 'PROFIT CENTRE' amendable
     C     BKPRCA        IFEQ      'N'
     C                   MOVE      *OFF          *IN61
     C                   ELSE
     C                   MOVE      *ON           *IN61
     C                   END
      *
      ** If not Insert mode, display either Facility reference fields or Loan reference field
     C     DDACTN        IFNE      'I'
 
     C     DDFACT        IFEQ      *Zero
     C     DDFACT        OREQ      *Blank
     C                   MOVE      *ON           *IN62
     C                   END
 
     C*****DDLNRF        IFEQ      *Zero                                                      CLE148
     C*****DDLNRF        OREQ      *Blank                                                     CLE148
     C     DDLNRF        IFEQ      *Blank                                                     CLE148
     C                   MOVE      *ON           *IN73
     C                   END
 
     C                   END
      *
      ***  Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     'LEFEEMDSP'   DDPGMQ           10
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
00000000000000000000000000000000000000000000000000
** @NAR
Fee 9999999999999999999 successfully inserted.
F10=CONFIRM DELETE
F11=CONFIRM AUTHORISATION
