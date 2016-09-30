     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Rollover deals retrieve a record')            *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMRODLR   - Rollover Deals Maintenance - Retrieve record     *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. AR701789           Date 26Sep16               *
      *  Prev Amend No. CGL165             Date 23Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR848507           Date 25Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22911           Date 17Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255519             Date 17Jul08               *
      *                 248297             Date 05Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CDL033             Date 10Feb05               *
      *                 BUG5916            Date 16Feb05               *
      *                 CMM105             Date 22Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 BUG2804            Date 20May04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 TCA002             Date 26Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAP084  *CREATE    Date 07Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR701789 - Unable to reject a deal amendment. Add a new      *
      *             parameter to indicate reject transaction.         *
      *             Applied for MD041482                              *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  AR848507 - Actual Interest in rolled over deal defaults to   *
      *             the interest of the original                      *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22911 - Changes for Correct Tax Calculation (Recompile)   *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255519 - Amend the buffer back to its original format,       *
      *           reversed changes made by 248297. Apply fix 254529.  *
      *  248297 - MMRPDLR - Buffer is not in line with MMRODLVU one   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  BUG5916 - Default Rundate in Deal Date for the new           *
      *            (rollover) deal.                                   *
      *  CMM105 - Core changes for GBO005                             *
      *         - Fixed Deposits Held Under Lien                      *
      *         - Upgrade to Midasplus                                *
      *           Core hooks added:MMRODLRD01,MMRODLRC01              *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  BUG2804- Parameter mismatch in MMLDNIRTV caused by CDL016    *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  TCA002 - 10-Digit Account Code Errors - Retrieve a/c details.*
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP084 - API Wrapper project.                                *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDBRTDL1  IF   E           K DISK    INFSR(*PSSR)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------

      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------

      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------

      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      **-----------------------------------------------------------------------
      ** Screen formats
      **-----------------------------------------------------------------------

     D DealScnFmt    E DS                  EXTNAME(MMLDNIPD)
      * Deal in screen format

     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
      * Receive settlement instructions in screen format

     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
      * Pay settlement instructions in screen format

     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS settlement instructions in screen format

      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------

     D DealFilFmt    E DS                  EXTNAME(MMDELDPP)
      ** Loans and Deposits in File Format
     D  DELDRecIns           470    524                                                       TCA002
     D  DELDPayIns           539   1083                                                       TCA002
     D**DELDRecIns***********456    524                                                       TCA002
     D**DELDPayIns***********525   1083                                                       TCA002

     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
     D**FLREC******************1     69                                                       TCA002
     D  FLREC2                21     75                                                       TCA002
      * Receive settlement instructions in file format

     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
     D**FLPAY******************1    559                                                       TCA002
     D  FLPAY2                21    565                                                       TCA002
      * Pay settlement instructions in file format

     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
      * FRA/IRS settlement instructions in file format

     D InfData       E DS                  EXTNAME(MMLDIFPD)
      * MM Extra Data - Classe 1 Data - File (D/B) format
     D                                     PREFIX(IF_)

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS

     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
     D  DL_ACCD      E                     EXTFLD(QQACCD)                                     CGL029

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** EXTERNAL DS FOR BRANCH DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
      **-----------------------------------------------------------------------

      ** Index for arrays of error message IDs, etc.
     D Idx             S              3P 0

      ** Index for arrays of warning message IDs, etc.
     D WIdx            S              3P 0

      ** Front office transaction ID
     D  FOTrID         S                   LIKE(HKFRNT)

      ** Associated front office trasaction ID
     D  FOAsID         S                   LIKE(HKAFRT)
     D/COPY WNCPYSRC,MMRODLRD01
     D ExtData       E DS                  EXTNAME(MMLDEXPD)                                  248297
      *** Ext. data - All Features                                                            248297

     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                             CSF011A
      **-----------------------------------------------------------------------
      **  Start of main processing
      **-----------------------------------------------------------------------

     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDDLNO_In         6
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1

      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'

      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,MMLDNIM01
      *
      ** Initialise program name
      *
     C                   MOVEL     'MMRODLR'     DBPGM
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
     C                   CALL      'AOGELRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDGELR        PARM      SDGELR        DSFDY
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
      ** ACCESS DEALING DETAILS
      *
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDDEALPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access SAR Details file to determine if BRT SAR is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD             6
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     @RTCD         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01383            1
     C                   END
      *
      ** If BRT SAR installed, access BRT installation control data
      *
     C     S01383        IFEQ      'Y'
     C                   MOVE      'D'           BRTKEY            1
     C     BRTKEY        CHAIN     SDBRTDD0                           99
      *
      * DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'SDBRTDPD'    DBFILE
     C                   MOVEL     '905'         DBASE
     C                   MOVEL     BRTKEY        DBKEY
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Access SAR details file to determine if CEU015 is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CEU015'      @SARD             6
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '906'         DBASE
     C                   MOVEL     @RTCD         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU015            1
     C                   ENDIF
                                                                                              CDL033
      ** Verify if Floating Rate CDs Issued enhancement is on.                                CDL033
                                                                                              CDL033
     C                   CALLB     'AOSARDR0'                                                 CDL033
     C                   PARM      *BLANKS       @RTCD                                        CDL033
     C                   PARM      '*VERIFY'     @OPTN                                        CDL033
     C                   PARM      'CDL033'      @SARD                                        CDL033
     C                   SELECT                                                               CDL033
     C                   WHEN      @RTCD = *BLANKS                                            CDL033
     C                   MOVE      'Y'           CDL033            1                          CDL033
     C                   WHEN      @RTCD <> '*NRF   '                                         CDL033
     C     *LOCK         IN        LDA                                                        CDL033
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL033
     C                   EVAL      DBASE = 908                                                CDL033
     C                   EVAL      DBKEY = @SARD                                              CDL033
     C                   OUT       LDA                                                        CDL033
     C                   EXSR      *PSSR                                                      CDL033
     C                   OTHER                                                                CDL033
     C                   MOVE      'N'           CDL033                                       CDL033
     C                   ENDSL                                                                CDL033
      *
      ** ACCESS EURO CURRENCY DECIMAL PLACES
      *
     C     CEU015        IFEQ      'Y'
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BKEURO        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '907'         DBASE
     C                   MOVEL     BKEURO        DBKEY
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     A6NBDP        EuroNBDP          1 0
     C                   END

      **  Get ZMUSER to access default branch.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
      *
      * If the action code is blank, Enquire unless Authorising
     C                   CLEAR                   DealFilFmt
     C     DDACTN        IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           DDACTN
     C                   ELSE
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF
     C                   ENDIF

     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ENDIF
     C                   ENDIF

     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      MMLDNIRED
     C                   ELSE
     C                   MOVEL     DDDLNO_In     @DLRED
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If deal was read and no error message returned
     C                   IF        ReturnCode = *BLANK and
     C                             @DLRED <> *Blank
      *
      * Retrieve deal details (all key fields required for call to RTV module)
     C                   MOVEL     @DLRED        DDDLNO
     C                   EXSR      MMLDNIRTV
      *
     C     Idx           IFEQ      0

      * Convert to screen format
      * ------------------------
      * Deal Details
     C                   EXSR      MMLDNICVT
      * Default rollover details
     C                   EXSR      MMLDNIROD

      * If action (DDRACT) is 'R', blank out DDAMNP as this is only
      * applicable if rolling the deal over to Euro (DDRACT='C').

     C                   IF        DDRACT = 'R'
     C                   EVAL      DDAMNP = *BLANK
     C                   ENDIF

      * Settlement Instructions
     C                   EXSR      ZASETINCVT
     C                   ENDIF

     C                   ENDIF

     C                   IF        ReturnCode <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDDLNO'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF

      * Build buffer with required output
     C                   EVAL                    Buffer = DealScnfmt
     C***                                        + DDRAMN                                     248297
     C***                                        + DDRACT                                     248297
     C**********                                 + InfData                             248297 255519
     C                                           + DDRAMN                                     255519
     C                                           + DDRACT                                     255519
     C                                           + InRecSttmt
     C                                           + InPaySttmt
     C                                           + ExtData                                    248297

     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
     C     MMLDNIRED     BEGSR
      *
     C                   CALLB     'MMLDNIRED'
      * Input parameters
      * ----------------
      * Return code
     C                   PARM      *BLANK        ReturnCode
      * Mode = '*FRONT' (Front office transaction interface)
      * Mode = '      ' (Not front office transaction interface)
     C                   PARM      '      '      @@MODE            6
      * Action code
     C                   PARM                    DDACTN            1
      * Deal number pointer
     C                   PARM      DDDLNO_In     DDDLNO            6
      * Front Office ID
     C                   PARM                    FOTrID
      * Read Forwards
     C                   PARM                    @RDFWD            1
      * Read Backwards
     C                   PARM                    @RDBCK            1
      *
      * Output parameters
      * ------------------
      * Error message
     C                   PARM      *BLANK        @ERRMS            7
      * Deal number read
     C                   PARM      *BLANK        @DLRED            6
      * Front Office ID read
     C                   PARM                    @FTRED           20

     C                   ENDSR
      **********************************************************************
     C     MMLDNIRTV     BEGSR
      *
     C                   CALLB     'MMLDNIRTV'
      * INPUTS
      * ------
      * Return code
     C                   PARM      *BLANK        ReturnCode
      * Mode = '*FRONT' (Front office transaction interface)
      * Mode = '      ' (Not Front office transaction interface)
     C                   PARM      *BLANK        ModeofOp          6
      * Response mode
     C                   PARM      'S'           RespMode          1
      * Action Code
     C                   PARM                    DDACTN
      * Front Office Transaction ID
     C                   PARM                    FOTrID
      * Front Office Associated Transaction ID
     C                   PARM                    FOAsID
      * (Midas) Deal Number
     C                   PARM                    DDDLNO
      * (Midas) Depot Movement Reference
     C                   PARM                    DDDDMR            6
      * (Midas) Associated Deal Number
     C                   PARM                    DDDADN
      * Booking branch
     C                   PARM                    DDBRCA
      * Repo Flag
     C                   PARM                    RepoFlag          1
      *
      * OUTPUTS
      * -------
      * (Current) deal in file format
     C                   PARM                    DealFilFmt
      *                                                                                     AR701789
     C                   PARM                    ACTRJ             1                        AR701789
      * OK - Action code
     C                   PARM      'Y'           DDActnOK          1
      * OK - Deal Number
     C                   PARM      'Y'           DDDlnoOK          1
      * OK - Booking branch
     C                   PARM      'Y'           DDBrsnOK          1
      ** Blocked/Unblock Action                                                              BUG2804
     C                   PARM                    BUACT             1                         BUG2804
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C/COPY WNCPYSRC,MMRODLRC01

     C                   ENDSR
      **********************************************************************
     C     MMLDNICVT     BEGSR

     C                   CALLB     'MMLDNICVT'
      * INPUTS
      * ------
      * Return Code
     C                   PARM      *BLANK        ReturnCode
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt
      * OUTPUTS
      * -------
      * (Current) Deal in screen format
     C                   PARM                    DealScnfmt
      * Deal Status
     C                   PARM                    DDSTS            24
      * Collateral Status
     C                   PARM                    DDCSTS           10

     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     MMLDNIROD     BEGSR

     C                   CALLB     'MMLDNIROD'
      * -------+
      * INPUTS ¦
      * -------+
      * Return Code
     C                   PARM      *BLANK        ReturnCode
      * Rollover action code
     C                   PARM                    DDRACT            1
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt
      * ----+
      * ICD ¦
      * ----+
      * Date format
     C                   PARM                    BJDFIN            1
      * Euro currency code
     C                   PARM                    BKEURO            3
      * Currency decimal separator
     C                   PARM                    BNDCSP            1
      * Hong Kong tax rate
     C                   PARM                    BNHKTR            5 2
      * BRT installed
     C                   PARM                    S01383            1
      * Euro rollover installed
     C                   PARM                    CEU015            1
      * Euro currency decimal places
     C                   PARM                    EuroNBDP          1 0
      * Date Effective From
     C                   PARM                    DEFF              5 0
      * Previous basic rate tax
     C                   PARM                    PBRTR             7 5
      * Basic rate tax
     C                   PARM                    BRTR              7 5
      ** Floating rate CDs issued                                                             CDL033
     C                   PARM                    CDL033                                       CDL033
      * -----------------+
      * OUTPUT PARAMETERS¦
      * -----------------+
      * Action code
     C                   PARM                    DDACTN            1
      * Deal number
     C                   PARM                    DDDLNO            6
      * Rollover Deal Number
     C                   PARM                    DDDADN            6
      * Value Date
     C                   PARM                    DDVDAT            6
      * Maturity Date
     C                   PARM                    DDMDAT            6
      * Currency
     C                   PARM                    DDCCY             3
      * Rollover Amount
     C                   PARM                    DDRAMN           14
      * Base Rate Code
     C                   PARM                    DDBSRC            2
      * Spread/Rate
     C                   PARM                    DDSPRT           12
      * Interest Calc. Method
     C                   PARM                    DDICMT            1
      * Base Currency Rate
     C                   PARM                    DDBRAT           13
      * Total interest
     C                   PARM                    DDTOTI           14
      * Customer shortname
     C                   PARM                    DDCSNM           10
      * Principal amount
     C                   PARM                    DDAMNP           14
      * Old Maturity Date
     C                   PARM                    OldMatDate        5 0
      * Deal Date                                                                            BUG5916
     C                   PARM                    DDDLDT            6                         BUG5916
      * Actual Interest Rate                                                                AR848507
     C                   PARM                    DDAIR            12                        AR848507

     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     ZASETINCVT    BEGSR
      *
      * Set up Payment instructions from deal
     C*******************MOVEL     DELDPayIns    FLPAY                                        TCA002
     C                   MOVEL     HKPSTM        FLPSTM                                       TCA002
     C                   MOVEL     HKPONS        FLPONS                                       TCA002
     C                   MOVEL     DELDPayIns    FLPAY2                                       TCA002
     C                   MOVEL     HKPOBR        FLPOBR
     C                   MOVEL     HKCVMR        FLCVMR
     C                   MOVEL     HKSTCY        FLPSCY
     C                   MOVEL     HKIC72        FLIC72
      *
      * Set up receive instructions from deal
     C*******************MOVEL     DELDRecIns    FLREC                                        TCA002
     C                   MOVEL     HKRSTM        FLRSTM                                       TCA002
     C                   MOVEL     HKRONS        FLRONS                                       TCA002
     C                   MOVEL     DELDRecIns    FLREC2                                       TCA002
     C                   MOVEL     HKROBR        FLROBR
     C                   MOVEL     HKSTCY        FLRSCY
      *
     C                   CALLB     'ZASETINCVT'
      *
      ** Inputs
      ** File payment settlement instruction
     C                   PARM                    DBPaySttmt
      *
      ** File receipt settlement instruction
     C                   PARM                    DBRecSttmt
      *
      ** File FRA/IRS settlement instruction
     C                   PARM      *BLANK        DBFRASttmt
      *
      ** Outputs
      ** Screen payment settlement instruction
     C                   PARM      *BLANK        InPaySttmt
      *
      ** Screen receipt settlement instruction
     C                   PARM      *BLANK        InRecSttmt
      *
      ** Screen FRA/IRS settlement instruction
     C                   PARM      *BLANK        InFRASttmt
     C                   PARM      HKCCY         #TRCCY                                      CSF011A
     C                   PARM      HKCCY         #TPCCY                                      CSF011A
      *
     C                   ENDSR
      **********************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
