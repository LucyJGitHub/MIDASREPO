     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming Payments Support Log Setup')         *
      *****************************************************************
      *                                                               *
      *  Misys - Funds Transfer ILE Module                            *
      *                                                               *
      *  FTIPAYLOG - Incoming Payments Support Log Setup Module       *
      *                                                               *
      *  Function:  This module will convert fields of FT Incoming    *
      *             Payments Details file into screen format to be    *
      *             used in writing records to the log file.          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT162             Date 08Sep17               *
      *  Prev Amend No. CFT157             Date 29Aug14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 25Aug03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT162 - MT900 and MT910 Message Generation (Recompile)      *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *            (Recompile)                                        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAP084 - Thin Client API Wrappers                            *
      *           Recompiled over changed FTIPY6PD.                   *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      * SRPROC - Detail Processing                                    *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      * Called by: FTIPAYUPD module                                   *
      *                                                               *
      * Calls:     FTIPAYCVT module                                   *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------+
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------+

      **--------------------------------------------------------------+
      **--------------------------------------------------------------+
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
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


      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D IPAYFilFmt    E DS                  EXTNAME(INPAYDD)
      ** Incoming Payments in File Format

     D IPAYFilFmtx   E DS                  EXTNAME(INPAYXPD)
      ** Incoming Payments Extension in File Format

     D IPAYScnFmt1   E DS                  EXTNAME(FTIPY1PD)
      ** Incoming Payments in Screen Format (Level 1 Screen 1)

     D IPAYScnFmt1a  E DS                  EXTNAME(FTIPY1APD)
      ** Incoming Payments in Screen Format (Level 1 Screen 1)

     D IPAYScnFmt2   E DS                  EXTNAME(FTIPY2PD)
      ** Incoming Payments in Screen Format (Level 2 Screen 1)

     D IPAYScnFmt3   E DS                  EXTNAME(FTIPY3PD)
      ** Incoming Payments in Screen Format (Level 2 Screen 1)

     D IPAYScnFmt4   E DS                  EXTNAME(FTIPY4PD)
      ** Incoming Payments in Screen Format (Level 2 Screen 1)

     D IPAYScnFmt4a  E DS                  EXTNAME(FTIPY4APD)
      ** Incoming Payments in Screen Format (Level 2 Screen 2)

     D IPAYScnFmt5   E DS                  EXTNAME(FTIPY5PD)
      ** Incoming Payments in Screen Format (Level 2 Screen 3)

     D IPAYScnFmt6   E DS                  EXTNAME(FTIPY6PD)
      ** Incoming Payments in Screen Format (Margin Info)
                                                                                              CSW209
     D IPAYScnFmt7   E DS                  EXTNAME(FTIPY7PD)                                  CSW209
      ** Incoming Payments in Screen Format (Level 2 Screen 7)                                CSW209
                                                                                              CSW209
     D IPAYScnFmt8   E DS                  EXTNAME(FTIPY8PD)                                  CSW209
      ** Incoming Payments in Screen Format (Level 2 Screen 8)                                CSW209

     D IPAYScnFmt6A  E DS                  EXTNAME(FTIPY6APD)                                 CER030
      *                                                                                       CER030
      ** Incoming Payments in Screen Format (Extended Narratives)                             CER030
      *                                                                                       CER030
     D ExtDataDS     E DS                  EXTNAME(FTIPEXPD)
      ** IP Extension data

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General Ledger Details

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Module Details

     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
      ** Funds Transfer Details

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Switchable Features Details
     D  SCLCD        E                     EXTFLD(LCD)

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs - short data structure

     D PAddInfm        DS           196
      ** Parameter to CVT module

     D PCharges        DS           196
      ** Parameter to CVT module

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Define variable for switchable features
     D S01494          S              1A
     D S01499          S              1A
     D CFT014          S              1A
     D CFT009          S              1A
     D CFT010          S              1A
     D CEU006          S              1A
     D CGL009          S              1A

      ** Transaction details
     D TRANSDTL        S           5800A

      ** Action code
     D PACTN           S              1A

      ** Access Object parameter fields
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A

      ** Additional parameters for CVT
     D PDSWTN          S             28A
     D PDSEQNO         S              2A
     D PSTATUS         S             10A
     D PPTYP           S              2A
     D PICCY           S              3A
     D POCCY           S              3A
     D PINBDP          S              1  0
     D PONBDP          S              1  0
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
     C
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      ** Execute detail processing

     C                   EXSR      SRPROC

      ** Return to *CALLER

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPROC   - Detail Processing                                  *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: FTIPAYCVT - Incoming Payment Convert Module            *
      *                                                               *
      *****************************************************************

     C     SRPROC        BEGSR

      ** Initialise transaction detail field

     C                   EVAL      TRANSDTL = *BLANK

      ** Initialise screen fields

     C                   EVAL      IPAYScnFmt1 = *BLANK
     C                   EVAL      IPAYScnFmt1a = *BLANK
     C                   EVAL      IPAYScnFmt2 = *BLANK
     C                   EVAL      IPAYScnFmt3 = *BLANK
     C                   EVAL      IPAYScnFmt4 = *BLANK
     C                   EVAL      IPAYScnFmt4a = *BLANK
     C                   EVAL      IPAYScnFmt5 = *BLANK
     C                   EVAL      IPAYScnFmt6 = *BLANK
     C                   EVAL      IPAYScnFmt7 = *BLANKS                                      CSW209
     C                   EVAL      IPAYScnFmt8 = *BLANKS                                      CSW209
     C                   EVAL      IPAYScnFmt6A = *BLANK                                      CER030

      ** Convert IP detail from file to screen format

     C                   CALLB     'FTIPAYCVT'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    IPAYFilFmt
     C                   PARM                    IPAYFilFmtx
     C                   PARM                    PACTN
     C                   PARM                    BJSBRC
     C                   PARM                    BJDFIN
     C                   PARM                    BJCYCD
     C                   PARM                    BJLCCY
     C                   PARM                    BKPRCU
     C                   PARM                    BKOBRU
     C                   PARM                    BGN0ST
     C                   PARM                    BTCHCY
     C                   PARM                    FCHCCY
     C                   PARM                    CEU006
     C                   PARM                    S01494
     C                   PARM                    S01499
     C                   PARM                    CGL009
     C                   PARM                    CFT014
     C                   PARM                    CFT009
     C                   PARM                    CFT010
     C                   PARM                    IPAYScnFmt1
     C                   PARM                    IPAYScnFmt1a
     C                   PARM                    IPAYScnFmt2
     C                   PARM                    IPAYScnFmt3
     C                   PARM                    IPAYScnFmt4
     C                   PARM                    IPAYScnFmt4a
     C                   PARM                    IPAYScnFmt5
     C                   PARM                    IPAYScnFmt6
     C                   PARM                    IPAYScnFmt7                                  CSW209
     C                   PARM                    IPAYScnFmt8                                  CSW209
     C                   PARM                    IPAYScnFmt6A                                 CER030
     C                   PARM                    PAddInfm
     C                   PARM                    PDSWTN
     C                   PARM                    PDSEQNO
     C                   PARM                    PSTATUS
     C                   PARM                    PPTYP
     C                   PARM                    PCHARGES
     C                   PARM                    PICCY
     C                   PARM                    POCCY
     C                   PARM                    PINBDP
     C                   PARM                    PONBDP

      ** No error on conversion, format TRANSDTL field

     C                   IF        RetCodeOut = *BLANK

      ** Blank out payment reference

     C                   EVAL      DDPREF = *BLANKS

     C                   EVAL      TRANSDTL = IPAYScnFmt1 + IPAYScnFmt1a +
     C                                        IPAYScnFmt2 + IPAYScnFmt3 +
     C                                        IPAYScnFmt4 + IPAYScnFmt4a +
     C                                        IPAYScnFmt5 + IPAYScnFmt6 +
     C                                        IPAYScnFmt7 + IPAYScnFmt8 +                     CSW209
     C                                        IPAYScnFmt6A +                                  CER030
     C                                        ExtDataDS
     C                   ELSE
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0 - Bank details                                *
      *        AOMMODR0 - Modules switched on                         *
      *        AOGELRR0 - Dealing ICD                                 *
      *        AOPORTR0 - Portfolio mgmt ICD                          *
      *        AOSARDR0 - Switchable Features details                 *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    IPAYFilFmt
     C                   PARM                    IPAYFilFmtx
     C                   PARM                    PACTN
     C                   PARM                    S01494
     C                   PARM                    S01499
     C                   PARM                    CFT014
     C                   PARM                    CFT009
     C                   PARM                    CFT010
     C                   PARM                    TRANSDTL

      **--------------------------------------------------------------+
      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------+

      ** Access Bank details via access program

     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Get the module flags

     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY

      ** Database error

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 2
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access General Ledger details

     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029

      ** Database error

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 3
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Get Funds Transfer details

     C                   CALLB     'AOFTFRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST'      POPTN
     C     SDFTFR        PARM      SDFTFR        DSFDY

      ** Database error

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDFTFRPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 4
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check if CEU006 is on

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CEU006'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

      ** Database error

     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY = 'CEU006'
     C                   EVAL      DBASE = 5
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRTCD = *BLANK
     C                   EVAL      CEU006 = 'Y'
     C                   ELSE
     C                   EVAL      CEU006 = 'N'
     C                   ENDIF

      ** Check if CGL009 is on

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGL009'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

      ** Database error

     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY = 'CGL009'
     C                   EVAL      DBASE = 6
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRTCD = *BLANK
     C                   EVAL      CGL009 = 'Y'
     C                   ELSE
     C                   EVAL      CGL009 = 'N'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      **-------------------------------------------------------------------+
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **-------------------------------------------------------------------+
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
