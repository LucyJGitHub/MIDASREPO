     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Rollover Instructions Display')               *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LELERIDSP - LE Rollover Instructions Display                 *
      *                                                               *
      *  Function:  This module displays the main details screen of   *
      *             the Rollover Instructions screen input function.  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD028338           Date 25Nov14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CLE106             Date 01Aug04               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG2579            Date 07Jun04               *
      *                 BUG827             Date 05May04               *
      *                 CAP084             Date 12Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP076  *CREATE    Date 15Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD028338 - Interest calculation has rounding difference for  *
      *             Rollover of Facility Exchange Rate only. Recompile*
      *             due to changes on LELERIPD and LELERI2PD.         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - CCR016: Settlement Allocation                      *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE106 - Syndications Manager (Recompile)                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  BUG2579 - Lending Facility History Improvements (CLE023)     *
      *  BUG827 - Missing CASxxx changes from LE2070.                 *
      *           CAS001 - Net Present Value (NPV) Accounting.        *
      *  CAP084 - API wrapper project                                 *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FLELERIDDF CF   E             WORKSTN
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *                                                               *
      *       60  BLI Lending Enhancement (S01465)                    *
      *       61  Multi-currency allowed by Loan facility             *
      *       62  Enable Analytical Accounting fields-Funding details *
      *       63  CLE011 is switched on                               *
      *       64  CLE011, Display Rollover Fixed Rate                 *
      *       65  Display Forward Yield Curve when CAS001 = *ON       *                       BUG827
      *                                                               *
      *       68  Position cursor on action code (if it is blank)     *
      *       69  Protect Loan key fields (action code & Loan number) *
      *       70  Protect Loan detail fields                          *
      *       71  Enable CF07                                         *
      *       72  Enable CF08                                         *
      *       73  Enable CF10                                         *
      *       74  Enable CF14                                         *
      *       75  Enable CF15                                         *
      *       77  Enable CF16 Authorise                               *
      *                                                               *
      *       80  Not multibranching                                  *
      *       81  Originating branch not used                         *
      *                                                               *
      *       96  Subfile control                                     *
      *       97  Subfile end                                         *
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
      ******True*******logical*=**on*(for*indcator*processing)*********                       CAP084
      ******False******logical*=**off*(for*indcator*processing)********                       CAP084
      **    True       logical = *on (for indicator processing)                               CAP084
      **    False      logical = *off (for indicator processing)                              CAP084
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
 
     D @Z0             S              1    DIM(50) CTDATA PERRCD(50)
     D @NAR            S             40    DIM(3) CTDATA PERRCD(1)
 
     D @EI             S              1    DIM(50)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank Details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for General Ledger Details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for Midas Module Details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for SAR details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for AccessProgramsS, Short DS
 
     D NwRoScnFmt    E DS                  EXTNAME(LELERIPD)
      ** Rollover Instructions Layout file
 
     D LERI_OK       E DS                  EXTNAME(LEELERIPD)
      ** Error inds for Rollover Instructions
 
     D NwRoScnFmt2   E DS                  EXTNAME(LELERI2PD)
      ** Rollover Instructions Work fields
 
     D                 DS
     D  DDFOTX                 1     40
     D  DDSIDN                10     15
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
      * Move 'OK' Flags into array
      *
     C                   MOVEA     LERI_OK       @EI
      *
      * Set Screen error indicators according to status of 'OK' Flags
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C     C             DOUGT     50
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
      *
      *  Do While error messages found
      *  Write error messages (with or without data) to subfile
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     MsgIdArr(C)   ZMSID             7
     C                   MOVEL     MsgDtaArr(C)  ZMSDA
     C                   EXSR      ERRMSG
     C                   ADD       1             C
     C                   END
      *
      *  Do While warning messages found
      *  Write warning messages (with or without data) to subfile
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     WFldNamArr(C) ANDNE     *BLANKS
     C                   MOVEL     WMsgIdArr(C)  ZMSID             7
     C                   MOVEL     WMsgDtaArr(C) ZMSDA
     C                   EXSR      ERRMSG
     C                   ADD       1             C
     C                   END
      *
      * Position cursor on Action Code if it is blank
      *
     C     DDACTN        COMP      *BLANK                                 68
      *
      * Enable key fields (Action Code & Loan Number)
      *
     C     @EKYFD        COMP      'Y'                                6969
      *
      * Enable detail fields (all fields except Action Code & Loan Number)
      *
     C     @EDTFD        COMP      'Y'                                7070
 
     C                   MOVE      '0'           *IN78                                        CAP084
     C     @EDTFD        IFNE      'Y'                                                        CAP084
     C     DDACTN        ANDNE     'A'                                                        CAP084
     C                   MOVE      '1'           *IN78                                        CAP084
     C                   ENDIF                                                                CAP084
      *
      * Enable Function Keys
      *
     C     @EINKG        COMP      'Y'                                    71
     C     @EINKH        COMP      'Y'                                    72
     C     @EINKJ        COMP      'Y'                                    73
     C     @EINKN        COMP      'Y'                                    74
     C     @EINKP        COMP      'Y'                                    75
     C     @EINKQ        COMP      'Y'                                    77
      *
      ** Check if BLI Lending Enhancements feature is installed
      *
     C     S01465        COMP      'Y'                                    60
      *
      *  Check if Multi-currency allowed by Loan facility
      *
     C     @MULTI        COMP      'Y'                                    61
                                                                                             BUG2579
      ** Check if New Facility Exchange Rate is to be displayed (CLE023)                     BUG2579
                                                                                             BUG2579
     C     @FCXRATE      IFEQ      'Y'                                                       BUG2579
     C                   MOVE      '1'           *IN67                                       BUG2579
     C                   ELSE                                                                BUG2579
     C                   MOVE      '0'           *IN67                                       BUG2579
     C                   ENDIF                                                               BUG2579
      *
      *  Check if Funding Details are required
      *
     C     @FUNDING      COMP      'Y'                                    62
                                                                                              BUG827
      ** Check if New Forward Yield Curve is to be displayed                                  BUG827
                                                                                              BUG827
     C     @FYIELD       IFEQ      'Y'                                                        BUG827
     C                   MOVE      '1'           *IN65                                        BUG827
     C                   ELSE                                                                 BUG827
     C                   MOVE      '0'           *IN65                                        BUG827
     C                   ENDIF                                                                BUG827
      *
      ** Check if Rollover rate fixing day enhancement - CLE011
      *  feature is installed
      *
     C     CLE011        COMP      'Y'                                    63
      *
      ** Check if Rollover rate need to be displayed
      *
     C     DDRFRT        COMP      *BLANKS                            6464
      *
      * Text = SUCCESSFUL INSERT
      *
     C     @SIDN         IFNE      *BLANK
     C                   MOVEL     @NAR(1)       DDFOTX
     C                   MOVEL     @SIDN         DDSIDN
     C                   MOVEL     *BLANK        @SIDN
     C                   ELSE
      *
      * Text = CONFIRM DELETE
      *
     C     @EINKJ        IFEQ      'Y'
     C                   MOVEL     @NAR(2)       DDFOTX
     C                   ELSE
     C                   MOVEL     *BLANK        DDFOTX
     C                   END
      *
      * Text = CONFIRM AUTHORISATION
      *
     C     @EINKQ        IFEQ      'Y'
     C                   MOVEL     @NAR(3)       DDFOTX
     C                   ELSE
     C                   MOVEL     *BLANK        DDFOTX
     C                   END
      *
     C                   END
      *
      * Write message subfile, details and footer screen
      *
     C                   TIME                    DDTIME
     C                   WRITE     LELERIC1
     C                   WRITE     LELERID1
     C                   WRITE     LELERIF1
      *
      * Read Details Screen,
      *
      * If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      LELERID1                               99
     C                   ENDIF
      *
      ** If Exit/Previous screen not selected
      ** process user request for data tables with query '?'
      *
     C     @INKC         IFNE      *ON
     C     @INKL         ANDNE     *ON
      *
      * Base Rate Code
     C                   MOVEL     DDNBRAB       QRYFLD            1
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD0170S'
     C                   PARM                    RETURN            7
     C                   PARM      *blank        WCCY              3
     C                   PARM                    DDNBRAB
     C                   ENDIF
      *
      * New Currency
     C                   MOVEL     DDNCCY        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD0020S'
     C                   PARM                    RETURN
     C                   PARM                    DDNCCY
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Clear message subfile
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGMQ        ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
      *
      * Set Screen Error Indicators OFF
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      * Set Return Keys
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKG         @INKG
     C                   MOVE      *INKH         @INKH
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKN         @INKN
     C                   MOVE      *INKP         @INKP
     C                   MOVE      *INKQ         @INKQ
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* ERRWOD  - OUTPUT ERROR MESSAGES WITHOUT DATA                  *
     C*                                                               *
     C*****************************************************************
     C     ERRMSG        BEGSR
     C*
     C*  Display error message
     C*
     C                   CALL      'Y2SNMGC'
     C                   PARM      'LELERIDSP'   ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL                         Rel queue
     C                   PARM                    ZMSID             7            Message Id.
     C                   PARM                    ZMSGF                          Message file.
     C                   PARM                    ZMSDA           132            Message data.
     C                   PARM                    ZMSTP             7            Message type.
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
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Rollover (in screen format)
     C                   PARM                    NwRoScnFmt
      *
      * Fields in error
     C                   PARM                    LERI_OK
      *
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * Enabled Key & Detail Fields
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      * Enabled Function Keys
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KN = COMMAND KEY 14 = SETTLEMENT DETAILS
      * KP = COMMAND KEY 15 = BROWSE
      * KQ = COMMAND KEY 16 = AUTHORISE
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKN            1
     C                   PARM                    @EINKP            1
     C                   PARM                    @EINKQ            1
      *
      * Succesful Insert Loan
     C                   PARM                    @SIDN             6
      *
      * Multi-currency allowed by Loan facility
     C                   PARM                    @MULTI            1
                                                                                             BUG2579
      ** New Facility xrate required for CLE023                                              BUG2579
     C                   PARM                    @FCXRATE          1                         BUG2579
      *
      * Funding Details required
     C                   PARM                    @FUNDING          1
                                                                                              BUG827
      ** Display Forward Yield                                                                BUG827
     C                   PARM                    @FYIELD           1                          BUG827
      *
      * Rollover Work Fields (fields ending with B)
     C                   PARM                    NwRoScnFmt2
      *
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      *
      * Features
     C                   PARM                    CLE002            1
     C                   PARM                    CLE003            1
     C                   PARM                    CLE005            1
     C                   PARM                    CEU020            1
     C                   PARM                    CLE011            1
     C                   PARM                    S01465            1
      *
      * OUTPUT PARAMETERS
      *
      * Function Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKN             1
     C                   PARM                    @INKP             1
     C                   PARM                    @INKQ             1
      *
      ** Initialize program name
      *
     C                   MOVEL     'LELERIDSP'   DBPGM
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER
     C                   TIME                    DDTIME
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
      * Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     'GBLERMSGF'   ZMSGF            10
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
(c) Finastra International Limited 2002
** @Z0
000000000000000000000000000000000000000000000000000000000000
** @NAR
Loan No. 999999 successfully inserted.
F10=CONFIRM DELETE
F16=CONFIRM AUTHORISATION
