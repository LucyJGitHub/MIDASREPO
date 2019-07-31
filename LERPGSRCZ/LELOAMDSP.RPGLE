     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Loan amendments display')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LELOAMDSP - LE Loan Amendment Display                        *
      *                                                               *
      *  Function:  This module displays the main details screen of   *
      *             the Loan Amendment screen input function.         *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 22Jun05               *
      *                 CLE034             Date 01Dec03               *
      *                 CLE031             Date 12Jun03               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CLE034   *CREATE   Date 01Dec03               *
      *                 CAP075  *CREATE    Date 12Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CLE106 - Syndications Manager                                *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A(Recompile) *
      *  CLE031 - Lending Enhancements (Recompile)                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A (recompile)*
      *  CAP075 - Lending API enhancements - Loan Amendment           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FLELOAMDDF CF   E             WORKSTN
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *    30-48 Field Error - highlight screen fields                *
      *                                                               *
      *       60  Enable fields for amendment type 'LS'               *
      *       61  Enable "funding spread/rate"                        *
      *       62  Enable fields "default participation"               *
      *       63  Enable the comment "record reversed"                *
      *                                                               *
      *       68  Position cursor on action code (if it is blank)     *
      *       69  Protect key fields (+ action code)                  *
      *       70  Protect detail fields                               *
      *       71  Enable CF07                                         *
      *       72  Enable CF08                                         *
      *       73  Enable CF10                                         *
      *       74  Enable CF14                                         *
      *       75  Enable CF15                                         *
      *       77  Enable CF16                                         *
      *                                                               *
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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
 
      **----------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      **----------------------------------------------------------------
 
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
 
      ** Array to set off error indicators
     D @Z0             S             19    DIM(1) CTDATA PERRCD(1)
 
      ** Array for messages
     D @NAR            S             40    DIM(3) CTDATA PERRCD(1)
 
     D @EI             S             19
     D @EI2            S              5
 
      ** External DS for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for base rate code details
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
 
      ** External DS for loan type/subtype details
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
 
      ** DS for access programs, long DS
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Loan amendment layout file - screen format
     D LOAMScnFmt    E DS                  EXTNAME(LELOAMPD)
 
      ** Loan amendment layout file - file format
     D LOAMFilFmt    E DS                  EXTNAME(LEVLOAMPD)
 
      ** Error inds for loan amendment
     D LOAM_OK       E DS                  EXTNAME(LEELOAMPD)
 
     D                 DS
     D  DDFOTX                 1     40
     D  D#SEQN                28     30
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
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
      * Reset in/outputs
     C                   EXSR      Reset
      *
      * Main processing
     C                   EXSR      MAIN
      *
      * F3 - Exit program
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - Main processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      * Set screen error indicators according to status of 'OK' Flags
     C     'NWY':'110'   XLATE     LOAM_OK:1     @EI
     C                   MOVEA     @EI           *IN(10)
      *
      * Do while error messages found
      * Write error messages (with or without data) to subfile
     C                   Z-ADD     1             C                 2 0
      *
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C     MsgIdArr(C)   IFNE      *BLANKS
     C                   MOVEL     MsgIdArr(C)   ZMSID             7
     C                   MOVEL     MsgDtaArr(C)  ZMSDA
     C                   EXSR      ERRMSG
     C                   ENDIF
     C                   ADD       1             C
     C                   ENDDO
      *
      * Do while warning messages found
      * Write warning messages (with or without data) to subfile
     C                   Z-ADD     1             C
      *
     C     C             DOWLE     ArrayMax
     C     WFldNamArr(C) ANDNE     *BLANKS
     C                   MOVEL     WMsgIdArr(C)  ZMSID             7
     C                   MOVEL     WMsgDtaArr(C) ZMSDA
     C                   EXSR      ERRMSG
     C                   ADD       1             C
     C                   ENDDO
      *
      * Position cursor on action code if it is blank
     C     DDACTN        COMP      *BLANK                                 68
      *
      * Enable key fields
     C     @EKYFD        COMP      'Y'                                6969
      *
      * Enable detail fields
     C     @EDTFD        COMP      'Y'                                7070
     C     @ESPIC        COMP      'Y'                                8080
      *
      * Enable function keys (F3/F12 always enabled)
     C     @EINKG        COMP      'Y'                                    71
     C     @EINKH        COMP      'Y'                                    72
     C     @EINKJ        COMP      'Y'                                    73
     C     @EINKN        COMP      'Y'                                    74
     C     @EINKP        COMP      'Y'                                    75
     C     @EINKQ        COMP      'Y'                                    77
      *
      ** Check if amendment type is 'Loan Sub-type'
     C     DDATYP        COMP      'LS'                                   60
      *
      ** Check if the field "Funding Spread/Rate" is to be displayed
     C     @Funding      COMP      'Y'                                    61
      *
      ** Check if the fields "Default Participation" are to be displayed
     C                   IF        *IN60
     C     @Syndic       COMP      'Y'                                    62
     C                   ELSE
     C                   SETOFF                                       62
     C                   ENDIF
      *
      ** Check if the comment "Record Reversed" is to be displayed
     C     @Reversed     COMP      'Y'                                    63
      *
      * Text = Confirm delete
     C     @EINKJ        IFEQ      'Y'
     C                   MOVEL     @NAR(1)       DDFOTX
     C                   ELSE
      *
      * Text = Confirm authorisation
     C     @EINKQ        IFEQ      'Y'
     C                   MOVEL     @NAR(2)       DDFOTX
     C                   ELSE
     C                   MOVEL     *BLANK        DDFOTX
     C                   ENDIF
     C                   ENDIF
      *
      * On insert, make sure the status is cleared
     C                   IF        DDACTN = 'I'
     C                   Eval      DDSTAT = *Blank
     C                   EndIf
 
      * Display allocated sequence number
     C     WLSNA         IFNE      *BLANKS
     C                   MOVEL     @NAR(3)       DDFOTX
     C                   MOVEL     WLSNA         D#SEQN
     C                   MOVEL     *BLANKS       WLSNA
     C                   ENDIF
      *
      ** Retrieve time
     C                   TIME                    S#TIME
      *
      * Write message subfile, details and footer screen
     C                   WRITE     LELOAMC1
     C                   WRITE     LELOAMF1
     C                   WRITE     LELOAMD1
      *
      * Read details screen, if not write only
     C     WriteOnly     IFNE      'Y'
     C                   READ      LELOAMD1                               99
     C                   ENDIF
      *
      ** If Exit/Previous screen not selected
      ** process user request for data tables with query '?'
     C     *INKC         IFNE      *ON
     C     *INKL         ANDNE     *ON
      *
      ** -- Customer number
     C                   MOVEL     DDCNUM        QRYFLD            1
      *
     C     QRYFLD        IFEQ      '?'
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       AORTCD            7
     C                   PARM      '*KEY   '     AOOPTN            7
     C                   PARM      DDCNUM        AOCUST           10
     C                   PARM      *BLANKS       AOKYST            7
     C     SDCUST        PARM                    DSSDY
      *
     C     AORTCD        IFEQ      *BLANKS
     C                   MOVEL(P)  BBCUST        DDCNUM
     C                   ELSE
     C                   MOVE      *BLANKS       DDCNUM
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** -- Currency code
     C                   MOVEL     DDCURR        QRYFLD            1
      *
     C     QRYFLD        IFEQ      '?'
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        AORTCD            7
     C                   PARM      '*KEY   '     AOOPTN            7
     C                   PARM      DDCURR        AOCURR            3
     C     SDCURR        PARM                    DSSDY
      *
     C     AORTCD        IFEQ      *BLANKS
     C                   MOVEL(P)  A6CYCD        DDCURR
     C                   ELSE
     C                   MOVE      *BLANKS       DDCURR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** -- Base Rate Code
     C                   MOVEL     DDBRAT        QRYFLD            1
      *
     C     QRYFLD        IFEQ      '?'
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANK        AORTCD            7
     C                   PARM      '*KEY   '     AOOPTN            7
     C                   PARM      DDCURR        AOCURR            3
     C                   PARM      DDBRAT        AOBRAT            2
     C     SDBSRT        PARM                    DSSDY
      *
     C     AORTCD        IFEQ      *BLANKS
     C                   MOVEL(P)  BABSRC        DDBRAT
     C                   MOVEL(P)  BACYCD        DDCURR
     C                   ELSE
     C                   MOVE      *BLANKS       DDBRAT
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** -- Loan Sub-Type
     C                   MOVEL     DDSTYP        QRYFLD            1
      *                                                                                       CLE042
      ** -- Loan Class                                                                        CLE042
     C                   MOVEL     DDCLAS        QRYFLD2           1                          CLE042
      *
     C     QRYFLD        IFEQ      '?'
     C     QRYFLD2       OREQ      '?'                                                        CLE042
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANK        AORTCD            7
     C                   PARM      '*KEY   '     AOOPTN            7
     C                   PARM      DDLTYP        AOLNTP            2
     C                   PARM      DDSTYP        AOLNST            2
     C                   PARM      DDCLAS        AOLNCL            4                          CLE042
     C     SDLOAN        PARM                    DSSDY
      *
     C     AORTCD        IFEQ      *BLANKS
     C                   MOVEL(P)  AYLNST        DDSTYP
     C                   MOVEL(P)  AYLNCL        DDCLAS                                       CLE042
     C                   ELSE
     C                   MOVE      *BLANKS       DDSTYP
     C                   MOVE      *BLANKS       DDCLAS                                       CLE042
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** -- Default Participation Loan Type / Sub-Type
     C                   MOVEL     DDDFTP        QRYFLD            1
     C                   MOVEL     DDDFST        QRYFLD2           1
     C                   MOVEL     DDDFCL        QRYFLD3           1                          CLE042
      *
     C     QRYFLD        IFEQ      '?'
     C     QRYFLD2       OREQ      '?'
     C     QRYFLD3       OREQ      '?'                                                        CLE042
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANK        AORTCD            7
     C                   PARM      '*KEY   '     AOOPTN            7
     C                   PARM      DDDFTP        AOLNTP            2
     C                   PARM      DDDFST        AOLNST            2
     C                   PARM      DDDFCL        AOLNCL            4                          CLE042
     C     SDLOAN        PARM                    DSSDY
      *
     C     AORTCD        IFEQ      *BLANKS
     C                   MOVEL(P)  AYLNTY        DDDFTP
     C                   MOVEL(P)  AYLNST        DDDFST
     C                   MOVEL(P)  AYLNCL        DDDFCL                                       CLE042
     C                   ELSE
      *
     C     QRYFLD        IFEQ      '?'
     C                   MOVE      *BLANKS       DDDFTP
     C                   ENDIF
      *
     C     QRYFLD2       IFEQ      '?'
     C                   MOVE      *BLANKS       DDDFST
     C                   ENDIF
                                                                                              CLE042
     C     QRYFLD3       IFEQ      '?'                                                        CLE042
     C                   MOVE      *BLANKS       DDDFCL                                       CLE042
     C                   ENDIF                                                                CLE042
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Clear message subfile
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGMQ        ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
      *
      * Set Screen Error Indicators OFF
     C                   MOVEA     @Z0           *IN(10)
      *
      * Set return keys
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
      *****************************************************************
      *                                                               *
      * ERRMSG  - Output error messages without data                  *
      *                                                               *
      *****************************************************************
     C     ERRMSG        BEGSR
      *
      *  Display error message
     C                   CALL      'Y2SNMGC'
     C                   PARM      'LELOAMDSP'   ZAPGMQ           10
     C                   PARM                    ZAPGRL
     C                   PARM                    ZMSID             7
     C                   PARM                    ZMSGF
     C                   PARM                    ZMSDA           132
     C                   PARM                    ZMSTP             7
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * Reset - Initial processing
      *****************************************************************
     C     Reset         BEGSR
      *
      * Clear outputs
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKG
     C                   MOVE      '0'           @INKH
     C                   MOVE      '0'           @INKJ
     C                   MOVE      '0'           @INKL
     C                   MOVE      '0'           @INKN
     C                   MOVE      '0'           @INKP
     C                   MOVE      '0'           @INKQ
      *
      * If insert, blank out non-key fields unless screen is being
      * redisplayed because of errors
     C                   If        DDACTN = 'I' and
     C                             RetCodeIn = *Blanks
     C                   Clear                   LOAMScnFmt
     C                   MOVE      'I'           DDACTN
     C                   EndIf
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Loan Amendment (in screen format)
     C                   PARM                    LOAMScnFmt
      *
      **  Output only screen fields : Loan type / status
     C**********         PARM                    DDLTYP                                       CLE106
     C                   PARM                    DDLTYPX           2                          CLE106
     C                   PARM                    DDSTAT
     C                   PARM                    WLSNA             3
      *
      * Fields in error
     C                   PARM                    LOAM_OK
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
      * Enabled key & detail fields
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
     C                   PARM                    @ESPIC            1
      *
      * Enabled function keys
      * KG - F7 - Roll backwards
      * KH - F8 - Roll forwards
      * KJ - F10 - Delete
      * KN - F14 - Settlement details
      * KP - F15 - Browse
      * KQ - F16 - Authorise
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKN            1
     C                   PARM                    @EINKP            1
     C                   PARM                    @EINKQ            1
      *
      * Field "Funding Spread/Rate" required
     C                   PARM                    @Funding          1
      *
      * Syndicated Facility
     C                   PARM                    @Syndic           1
      *
      * Reversed loan amendment
     C                   PARM                    @Reversed         1
      *
      * Run date
     C                   PARM                    WRUNDT            7
      *
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      *
      * Output parameters
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
      ** Initialise program name
     C                   MOVEL     'LELOAMDSP'   DBPGM
      *
      ** Set up screen header fields
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     WRUNDT        S#RUNA
      *
      * Message subfile control
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     'LERMSGF   '  ZMSGF            10
 
     C                   EVAL      *IN97 = *ON
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
0000000000000000000
** @NAR
F10=Confirm Reverse
F16=Confirm Authorisation
Sequence number allocated:
