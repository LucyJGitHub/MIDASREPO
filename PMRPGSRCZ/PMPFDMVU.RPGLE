     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Portfolio Definition Validate and Update')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMPFDMVU - Portfolio Management validate and update          *
      *                                                               *
      *  Function: This program validates Portfolio Definition        *
      *            details for input into the Midas database.         *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Transaction details fields        *
      *            - For A (=AMEND),                                  *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *              - if transaction is valid, call a separate       *
      *                function to check whether it is a valid        *
      *                amendment.                                     *
      *            - For D (=DELETE), call a separate function to     *
      *              process the transaction and bypass the rest of   *
      *              the validation.                                  *
      *                                                               *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 08Sep03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
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
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
      *
      /COPY ZACPYSRC,PROCPARMS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
      *
      /COPY ZACPYSRC,APICTLARR
      *
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
      *
      /COPY ZACPYSRC,DTAQCHKDCL
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
     D MaxChrgArr      C                   CONST(10)
      *
      ** String for error messages to the operator
     D WProcErr        C                   CONST('Error in module')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Incoming Message Header
     D PHeadIn       E DS                  EXTNAME(APHEADPD)
      *
      ** Incoming Transaction
     D PTransIn      E DS                  EXTNAME(PMPFDMPD)
      *
      ** Valid Portfolio Definition Details - for file update
     D PValidPort    E DS                  EXTNAME(PMVPFDMPD)
     D  PInvestInds           81     84
      *
      ** Portfolio Definition Details retrieved from file
      ** - in file format
     D PPortFilFmt   E DS                  EXTNAME(PMVPFDMPD)
     D                                     PREFIX(O)
      *
      ** Portfolio Definition Details retrieved from file
      ** - in screen format
     D PCurPort      E DS                  EXTNAME(PMPFDMPD)
     D                                     PREFIX(C)
      *
      ** Incoming Extra Data
     D PExtData      E DS                  EXTNAME(PMPFEXPD)
      *
      ** Error indicators
     D POKFields     E DS                  EXTNAME(PMEPFDMPD)
     D   OKInds                1     42    DIM(42) INZ('Y')
      *
      ** Externally described DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for General Ledger ICD Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      *
      ** Externally described DS for Midas Modules Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** Externally described DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Externally described DS for Portfolio Details
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      *
      ** Externally described DS for Custody Fees
     D SDSCFE        E DS                  EXTNAME(SDSCFEPD)
      *
      ** Externally described DS for API ICD Details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      *
      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Data Structure for last update
     D WLUP            DS
     D   WDLUP                 1      2  0
     D   WMLUP                 3      5
     D   WYLUP                 6      7  0
      *
      ** The Investment Policy Indicators are input-capable only
      ** on the Screen Input (*SIN) function:
      ** - (DDIPIN) Instrument Investment Policy Indicator
      ** - (DDCYIN) Currency Investment Policy Indicator
      ** - (DDYPIN) Country of Risk Investment Policy Indicator
      ** - (DDNPIN) Industry Investment Policy Indicator
      ** For *CTL and *RPR, since no values are being received
      ** from the MQ Series, they are just defaulted to the file values.
      *
      ** Investment Policy Indicators retrieved from file
      ** - for display
     D PCurInvestI     DS             4
      *
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  wComitjobs             4    103                                                       CSC022
      ** External DS for Commitment Control Data Area                                         CSC022
                                                                                              CSC022
     D wComitarr       S             10A   DIM(10)                                            CSC022
      ** Commitment Control Array                                                             CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message IDs
     D IDx             S              3P 0
      *
      ** Index for arrays of warning messages
     D WIDx            S              3P 0
      *
      ** Indices for arrays used to set up corresponding sequence numbers
      ** for the fields that are in error
      *
     D W1              S              3P 0
     D W2              S              3P 0
      *
      ** Field (500A) to receive the incoming transaction
     D PTrans5001      S            500A
      *
      ** Field (500A) to receive the incoming extra data
     D PExtData500     S            500A
      *
      ** Index for arrays of error message IDs in Amend Validation
     D AMIDx           S              3P 0
      *
      ** Portfolio Charges details array - for file update
     D NwChrgFileArr   S                   DIM(MaxChrgArr)
     D                                     LIKE(PMCHRG)
      *
      ** Externally described DS for Portfolio Charges details
     D PMCHRG        E DS                  EXTNAME(PMCHRGPD)
      *
      ** Commitment Control Variables                                                         CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D wSkip           S              1A   INZ('N')                                           CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      ** Incoming transaction is in a 500A field, so that a common CLP
      ** can be used between this module and the one that read the MQ queue.
      ** This module needs to break that 500A by loading it into the
      ** appropriate (externally described) data structure.
      *
     C                   MOVEL     PTrans5001    PTransIn
     C                   MOVEL     PExtData500   PExtData
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetFld
      *
      ** Validate action code versus the transaction ID supplied.
      ** Original Portfolio Definition Details in file format are
      ** retrieved during the validation process.
      *
     C                   EXSR      SRValAction
      *
      ** If error in validation of action code, fail this input.
      *
     C     IDx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
      *
      ** Processing depends upon Action Code.
      *
     C                   SELECT
      *
      ** INSERT
      ** ======
      *
     C                   WHEN      DDACTN = 'I'
      *
      ** Validate Incoming Portfolio Definition Details.
      *
     C                   EXSR      SRValDetails
      *
      ** AMEND
      ** =====
      *
     C                   WHEN      DDACTN = 'A'
      *
      ** Check for the existence of the replacement character; if this is
      ** used, only the changed data has been sent, and all occurrences of
      ** the replacement character must be replaced with the corresponding
      ** character from the original transaction.
      *
     C                   IF        GHSUBS <> *blank
      *
     C     GHSUBS        SCAN      PTransIn                               99
      *
     C                   IF        *IN99
      *
      ** Do the data substitution subroutine.
      *
     C                   EXSR      SRDtaSubs
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Incoming Portfolio Definition Details.
      *
     C                   EXSR      SRValDetails
      *
      ** Check if amended fields are amendable.
      *
     C                   EXSR      SRValAmend
      *
      ** CLOSURE
      ** =======
      *
     C                   WHEN      DDACTN = 'C'
      *
      ** Validate Incoming Portfolio Definition Details.
      *
     C                   EXSR      SRValDetails
      *
     C                   ENDSL
      *
     C     INVALID       TAG
 
      *  Write to database
 
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      WriteToDB
     C                   ENDIF
 
     C                   SETON                                        LR
 
     C                   EVAL                    Buffer = PCurPort
     C                                           + PCurInvestI + PExtData
 
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetFld - Routine to reset fields                         *
      *                                                               *
      *****************************************************************
      *
     C     SRResetFld    BEGSR
      *
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   IDx
      *
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIdArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIDx
      *
     C                   RESET                   AMFldNamAr
     C                   RESET                   AMMsgIDArr
     C                   RESET                   AMMsgDtaAr
     C                   RESET                   AMIDx
      *
     C                   RESET                   FldNoArr
      *
     C                   RESET                   POKFields
      *
     C                   RESET                   AmendOK
      *
      ** Valid Portfolio Definition Details - for file update
     C                   CLEAR                   PValidPort
      *
     C                   Z-ADD     *ZERO         P1PNPCDP
     C                   Z-ADD     *ZERO         P1PNDPOP
     C                   Z-ADD     *ZERO         P1PNDPCL
     C                   Z-ADD     *ZERO         P1PNVLDM
     C                   Z-ADD     *ZERO         P1PNVLND
     C                   Z-ADD     *ZERO         P1PNPDGS
     C                   Z-ADD     *ZERO         P1PNPDGF
     C                   Z-ADD     *ZERO         P1PNBCGD
     C                   Z-ADD     *ZERO         P1PNCSDP
     C                   Z-ADD     *ZERO         P1PNCASD
     C                   Z-ADD     *ZERO         P1PNCASN
     C                   Z-ADD     *ZERO         P1PNTYSM
     C                   Z-ADD     *ZERO         P1PNPSDT
     C                   Z-ADD     *ZERO         P1PNACSQ
      *
     C                   Z-ADD     *ZERO         P1PNMGTP
     C                   Z-ADD     *ZERO         P1PNINTP
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValAction - Routine to validate action code versus the     *
      *                transaction ID supplied                        *
      *              - Original Portfolio Definition details in file  *
      *                format are retrieved during the validation     *
      *                process                                        *
      *                                                               *
      *****************************************************************
      *
     C     SRValAction   BEGSR
      *
     C                   CALLB     'PMPFDM2RV'
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANK        ReturnCode
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
     C                   PARM      '      '      PModeofOp         6
      *
      ** Response Mode
     C                   PARM      'S'           APRESPMODE
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Front Office Transaction ID
     C                   PARM                    APFOTRANID
      *
      ** Portfolio reference
     C                   PARM                    DDPREF
      *
      ** Customer
      *
     C                   PARM                    DDCSNM
      *
      ** REVIEW FROM key fields to position browse display in
      ** Screen Input function - not used in this function
     C                   PARM      *BLANKS       PREVIEW          10
      *
      ** STANDING DATA
      ** =============
      *
      ** SDPORT - Portfolios Supported
     C                   PARM                    FCPORS
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDMMOD - Portfolio Management
     C                   PARM                    BGPFMG
      *
      ** OUTPUT
      ** ======
      *
      ** Original Portfolio Definition Details in file format
     C                   PARM                    PPortFilFmt
      *
      ** OK - Action Code
     C                   PARM                    OKACTN
      *
      ** OK - Portfolio Reference
     C                   PARM                    OKPREF
      *
      ** OK - Customer
     C                   PARM                    OKCSNM
      *
      ** OK - REVIEW FROM (not used in this function)
     C                   PARM                    POKREVIEW         1
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** SDPLCS - Portfolio Customer's Base Currency
     C                   PARM                    QBCSBY            3
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST            1
      *
      ** SDCUST - Branch Code of incoming customer
     C                   PARM                    BBBRCD            3
      *
      ** SDCUST - Account Officer Code of incoming customer
     C                   PARM                    BBACOC            2
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDetails - Routine to validate incoming Portfolio        *
      *                 Definition Details                            *
      *               - Amended file fields (for update) are set up   *
      *                 during the validation process                 *
      *                                                               *
      *****************************************************************
      *
     C     SRValDetails  BEGSR
      *
      ** For action codes Amend and Closure, put the complete (pre-existing)
      ** Portfolio Definition Details into the Valid File record.  Fields
      ** will be updated during processing.
      *
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'C'
     C                   MOVE      PPortFilFmt   PValidPort
     C                   ENDIF
      *
      ** For Insert, default Date Opened to rundate and blank out
      ** Pledge Start and Finish Dates if Portfolio Lending is on.
      ** Also, if customer is not PM Customer, default mandatory
      ** fields.
      *
     C     DDACTN        IFEQ      'I'
      *
     C                   EVAL      OP1PNDPOP = BJRDNB
     C                   EVAL      P1PNDPOP = BJRDNB
      *
     C     BGLMCR        IFEQ      'Y'
     C                   MOVE      *BLANKS       DDPDGS
     C                   MOVE      *BLANKS       DDPDGF
     C                   ENDIF
      *
     C     PMCUST        IFNE      'Y'
     C                   EVAL      P1PNIPIN = 'N'
     C                   EVAL      P1PNCYIN = 'N'
     C                   EVAL      P1PNYPIN = 'N'
     C                   EVAL      P1PNNPIN = 'N'
     C                   EVAL      P1PNMNGI = 'M'
     C                   EVAL      P1PNRPYP = 'N'
     C                   Z-ADD     99999         P1PNPSDT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   CALLB     'PMPFDM2VL'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Response Mode
     C                   PARM      'S'           APRESPMODE
      *
      ** Incoming Portfolio Definition Details - screen format
     C                   PARM                    PTransIn
      *
      ** Investment Policy Indicators from incoming transaction
      ** - For this function, the values are the same as those
      **   kept on file.
     C                   PARM                    PInvestInds
      *
      ** Incoming Extra Data
     C                   PARM                    PExtData
      *
      ** Original Date Opened
      ** - for insert, rundate
      ** - for other action codes, value retrieved from file
     C                   PARM                    OP1PNDPOP
      *
      ** Original Performance Start Date
     C                   PARM                    OP1PNPSDT
      *
      ** Original Pledge Finish Date
     C                   PARM                    OP1PNPDGF
      *
      ** SDPLCS - Portfolio Customer's Base Currency
     C                   PARM                    QBCSBY
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
     C                   PARM      '      '      PModeOfOp
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST
      *
      ** SDCUST - Branch Code of incoming customer
     C                   PARM                    BBBRCD
      *
      ** SDCUST - Account Officer Code of incoming customer
     C                   PARM                    BBACOC
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY
      *
      ** SDGELR - Profit Centre Defaults Used?
     C                   PARM                    BKPCDU
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDMMOD - Future & Options
     C                   PARM                    BGFUOP
      *
      ** SDMMOD - Portfolio Lending
     C                   PARM                    BGLMCR
      *
      ** SDSCFE - Custody Fees Group for Portfolio
     C                   PARM                    FBFGCP
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Safe Custody Fees feature
     C                   PARM                    S01464
      *
      ** Profit Centre feature
     C                   PARM                    CAC003
      *
      ** OUTPUT
      ** ======
      *
      ** Portfolio Definition Fields OK indicators
     C                   PARM                    POKFields
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** Valid Portfolio Definition Details - for file update
     C                   PARM                    PValidPort
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValAmend - Routine to check whether the fields are         *
      *               amendable                                       *
      *             - This subroutine calls a procedure which checks  *
      *               whether it is valid to amend the fields which   *
      *               have been altered.  To determine what fields    *
      *               have been changed, the current fields on file   *
      *               must be converted to their screen formats.      *
      *               These fields are then compared with the fields  *
      *               on the input transaction.  Any errors detected  *
      *               by the called procedure take precedence over    *
      *               any errors found during the validation of the   *
      *               transaction.  The errors from the called        *
      *               procedure are kept separately and if any are    *
      *               found, these errors will REPLACE the normal     *
      *               validation errors.                              *
      *                                                               *
      *****************************************************************
      *
     C     SRValAmend    BEGSR
      *
      ** Convert the original Portfolio Definition Details to
      ** screen format.
      *
     C                   CALLB     'PMPFDM2CT'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANK        ReturnCode
      *
      ** Portfolio Definition Details retrieved from file
      ** - in file format
     C                   PARM                    PPortFilFmt
      *
      ** Action code from incoming transaction
     C                   PARM                    DDACTN
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDSCFE - Custody Fees Group for Portfolio
     C                   PARM                    FBFGCP
      *
      ** SDMMOD - Futures & Options
     C                   PARM                    BGFUOP
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Safe Custody Fees feature
     C                   PARM                    S01464
      *
      ** Profit Centre feature
     C                   PARM                    CAC003
      *
      ** OUTPUT
      ** ======
      *
      ** Portfolio Definition Details retrieved from file
      ** - in screen format
     C                   PARM                    PCurPort
      *
      ** Investment Policy Indicators retrieved from file
      ** - for display
     C                   PARM                    PCurInvestI
      *
      ** Date Opened retrieved from file - in screen format
     C                   PARM                    PDDDPOP           6
      *
      ** CLOSED/CLOSURE REQUEST narrative - for display
     C                   PARM                    PDDDELT          16
      *
      ** Check if amendment to the file values is valid.
      *
     C                   CALLB     'PMPFDM2AD'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANK        ReturnCode
      *
      ** Portfolio Definition Details from incoming transaction
      ** - in screen format
     C                   PARM                    PTransIn
      *
      ** Portfolio Definition Details retrieved from file
      ** - in screen format
     C                   PARM                    PCurPort
      *
      ** Date Opened retrieved from file
      ** - in screen format
     C                   PARM                    PDDDPOP
      *
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM      'N'           RESETERRS         1
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDMMOD - Portfolio Lending
     C                   PARM                    BGLMCR
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Profit Centre feature
     C                   PARM                    CAC003
      *
      ** OUTPUT
      ** ======
      *
      ** Portfolio Definition Fields OK indicators
     C                   PARM                    POKFields
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AMFldNamAr
     C                   PARM                    AMMsgIDArr
     C                   PARM                    AMMsgDtaAr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    AMIDx
      *
      ** Amendments OK
     C                   PARM                    AmendOK           1
      *
      ** If any errors, overwrite previous error information.
      *
     C                   IF        AMIDx <> 0
     C                   MOVEA     AMMsgIDArr    MsgIDArr
     C                   MOVEA     AMFldNamAr    FldNameArr
     C                   MOVEA     AMMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AMIDx         IDx
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDtaSubs - Data Substitution Routine                        *
      *                                                               *
      *****************************************************************
      *
     C     SRDtaSubs     BEGSR
      *
      ** Convert file fields to screen format.
      *
     C                   CALLB     'PMPFDM2CT'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANK        ReturnCode
      *
      ** Portfolio Definition Details retrieved from file
      ** - in file format
     C                   PARM                    PPortFilFmt
      *
      ** Action code from incoming transaction
     C                   PARM                    DDACTN
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDSCFE - Custody Fees Group for Portfolio
     C                   PARM                    FBFGCP
      *
      ** SDMMOD - Futures & Options
     C                   PARM                    BGFUOP
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Safe Custody Fees feature
     C                   PARM                    S01464
      *
      ** Profit Centre feature
     C                   PARM                    CAC003
      *
      ** OUTPUT
      ** ======
      *
      ** Portfolio Definition Details retrieved from file
      ** - in screen format
     C                   PARM                    PCurPort
      *
      ** Investment Policy Indicators retrieved from file
      ** - for display
     C                   PARM                    PCurInvestI
      *
      ** Date Opened retrieved from file - in screen format
     C                   PARM                    PDDDPOP           6
      *
      ** CLOSED/CLOSURE REQUEST narrative - for display
     C                   PARM                    PDDDELT          16
      *
      ** Substitute the data for the various parts of the transaction.
      *
     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
     C                   RESET                   ReturnCode
      *
     C                   CALLB     'APDTASUBS'
      *                             =========
      *
      ** Return Code
     C                   PARM                    ReturnCode
      *
      ** Substitution character
     C                   PARM                    GHSUBS
      *
      ** Incoming Data
     C                   PARM      PTransIn      IncData        2000
      *
      ** Current Data
     C                   PARM      PCurPort      CurData        2000
      *
     C                   MOVEL     IncDATA       PTransIn
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C     WriteToDB     BEGSR
 
     C     Idx           IFEQ      0
     C                   EXSR      SRSetValid
     C                   EXSR      UpdateDB
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetValid - Routine to set up fields in the Valid File      *
      *               record                                          *
      *                                                               *
      *****************************************************************
      *
     C     SRSetValid    BEGSR
      *
      ** Set Details for Insert.
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     'D'           P1PNRECI
     C                   MOVEL     DDCSNM        P1PNCNUM
     C                   MOVEL     DDPREF        P1PNPTFR
     C                   ENDIF
      *
      ** Set Details for Insert, Amend and Closure.
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      'C'
     C                   EVAL      WLUP = BJMRDT
     C                   EVAL      P1PNDLUP = WDLUP
     C                   EVAL      P1PNMLUP = WMLUP
     C                   EVAL      P1PNYLUP = WYLUP
     C                   EVAL      P1PNTLUP = PSRUNTIME
     C                   EVAL      P1PNLCD  = BJRDNB
     C                   EVAL      P1PNTNLU = *ZERO
     C                   ENDIF
      *
      ** For Enquire, move Portfolio Definition Details directly
      ** to Valid Records file format.
     C     DDACTN        IFEQ      'E'
     C                   MOVEL     PPortFilFmt   PValidPort
     C                   ENDIF
      *
      ** Move action code.
     C                   EVAL      P1PNCHTP = DDACTN
      *
      ** Move header details.
     C                   EVAL      P1PNFRNT = APFOTRANID
     C                   EVAL      P1PNAFRT = APFOASOCID
     C                   EVAL      P1PNREPA = APRPRLOCN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update Database                                    *
      *                                                               *
      *****************************************************************
 
     C     UPDATEDB      BEGSR
      *
      ** Update Portfolio Definitions file.
      *
     C                   CALLB     'PMPFDMUPD'
     C                   PARM      *BLANK        @RTCD
      ** Portfolio Definition Details - for file update
     C                   PARM                    PValidPort
      *
      ** STANDING DATA
      *
      ** SDPORT - Portfolios Supported
     C                   PARM                    FCPORS
      *
      ** SDMMOD - Portfolio Management
     C                   PARM                    BGPFMG
      *
      ** SDMMOD - Private Banking
     C                   PARM                    BGN4ST
      *
      ** If no errors, action code is not Closure and customer is a PM
      ** Customer, then update Portfolio Charges file.
      ** Charges file.
      *
     C     PRTCD         IFEQ      *BLANKS
     C     DDACTN        ANDNE     'C'
     C     PMCUST        ANDEQ     'Y'
      *
     C                   EXSR      SRSetChgUpd
      *
      ** Update Portfolio Charges file.
      *
     C                   CALLB     'PMPFDMUPH'
      *                             =========
      *
      ** INPUT
      *
     C                   PARM      *BLANKS       PRTCD
      *
      ** Charges details array - for file update
     C                   PARM                    NwChrgFileArr
      *
     C                   ENDIF
      *
     C     PRTCD         IFNE      *BLANKS
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   else                                                                 CSC022
     C                   If        wSkip <> 'Y'                                               CSC022
     C                   Rolbk                                                                CSC022
     C                   else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   ELSE
     C                   If        CSC022 = 'N' or                                            CSC022
     C                             (wSkip = 'N' and CSC022 = 'Y')                             CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   ENDIF
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If update not done due to record being updated by another
      *  workstation send message to screen.
     C
     C     @RTCD         IFEQ      '*RECUPD'
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'APM1000'     MsgIdArr(1)
     C
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetChgUpd - Set charges fields for update                  *
      *                                                               *
      *****************************************************************
      *
     C     SRSetChgUpd   BEGSR
      *
     C                   Z-ADD     1             WCntr             2 0
      *
     C     WCntr         DOUGT     MaxChrgArr
      *
     C                   CLEAR                   PMCHRG
     C                   EVAL      PMCHRG = NwChrgFileArr(Wcntr)
      *
     C                   EVAL      PORECI = 'D'
     C                   EVAL      POLCD  = BJRDNB
     C                   EVAL      PODLUP = WDLUP
     C                   EVAL      POMLUP = WMLUP
     C                   EVAL      POYLUP = WYLUP
     C                   EVAL      POTLUP = PSRUNTIME
     C                   EVAL      POTNLU = *ZERO
      *
      ** If key fields (customer, portfolio reference and
      ** sequence) are blanks but Charge Code is not,
      ** record is to be inserted so fill up other
      ** details.
      *
     C*****POCNUM        IFEQ      0                                                          CSD027
     C     POCNUM        IFEQ      *BLANKS                                                    CSD027
     C     POCGCO        ANDNE     *BLANKS
     C     POPTFR        OREQ      *BLANKS
     C     POCGCO        ANDNE     *BLANKS
     C                   MOVEL     'I'           POCHTP
     C                   MOVEL     DDCSNM        POCNUM
     C                   MOVEL     DDPREF        POPTFR
     C                   Z-ADD     Wcntr         POCGSQ
     C                   Z-ADD     0             POCGAD
      *
     C                   EVAL      POCGLD = BJRDNB - 1
      *
     C                   MOVEL     *BLANK        POCSIS
     C                   MOVEL     *BLANKS       POCCSP
     C                   Z-ADD     0             POCSSP
     C                   MOVEL     *BLANK        POCISP
     C                   Z-ADD     0             POCGAJ
     C                   MOVEL     *BLANK        POCGAS
     C                   MOVEL     *BLANKS       POCGAP
     C                   MOVEL     *BLANKS       POCSPR
     C                   Z-ADD     0             POCGAT
     C                   Z-ADD     0             POCSTT
      *
     C                   ELSE
     C                   MOVEL     'A'           POCHTP
     C                   ENDIF
      *
     C                   EVAL      NwChrgFileArr(WCntr) = PMCHRG
      *
     C                   ADD       1             WCntr
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Incoming Header details
     C                   PARM                    PHeadIn
      *
      ** Incoming Transaction details
     C                   PARM                    PTrans5001
      *
      ** Incoming Extra data
     C                   PARM                    PExtData500
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN          1
     C                   PARM                    Buffer         6000
     C                   PARM                    APIRetc           1
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'PMUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,PMPFDMM01
      *
      ** Access Bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSSDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access General Ledger ICD details.
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDGELR        PARM      SDGELR        DSSDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Midas Modules details.
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSSDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     003           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If Portfolio Management is installed, access ICD details.
      *
     C     BGPFMG        IFEQ      'Y'
      *
     C                   CALLB     'AOPORTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDPORT        PARM      SDPORT        DSSDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE
     C                   Z-ADD     004           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Access SAR file to determine if CAC003 (Profit Centre)
      ** is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAC003'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSSDY
      *
      ** An NRF (No Record Found) return code is valid.  Issue database error
      ** only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CAC003'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     005           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Switch on Profit Centre feature if Analytical Accounting is
      ** also switched on.
     C     PRTCD         IFEQ      *BLANK
     C     BGN0ST        ANDEQ     'Y'
     C                   MOVEL     'Y'           CAC003            1
     C                   ELSE
     C                   MOVEL     'N'           CAC003
     C                   ENDIF
      *
      ** Access SAR file to determine if S01464 (Safe Custody Fees)
      ** is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01464'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *
      ** An NRF (No Record Found) return code is valid.  Issue database error
      ** only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01464'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     006           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01464            1
     C                   ELSE
     C                   MOVE      'N'           S01464
     C                   ENDIF
      *
      ** If Safe Custody Fees is installed, access ICD details.
      *
     C     S01464        IFEQ      'Y'
      *
     C                   CALL      'AOSCFER0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDSCFE        PARM      SDSCFE        DSSDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDSCFEPD'    DBFILE
     C                   Z-ADD     007           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Access SAR details file to determine if CSC022 is on.                                CSC022
      *                                                                                       CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       PRTCD                                        CSC022
     C                   Parm      '*VERIFY'     POPTN                                        CSC022
     C                   Parm      'CSC022'      PSARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
      * Database Error                                                                        CSC022
      *                                                                                       CSC022
     C                   If        PRTCD <> *BLANKS and                                       CSC022
     C                             PRTCD <> '*NRF   '                                         CSC022
     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
     C                   Eval      DBASE = 009                                                CSC022
     C                   Eval      DBKEY = 'CSC022'                                           CSC022
     C                   ExSr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   If        PRTCD = *BLANK                                             CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   In        SCCMTJOB                                                   CSC022
      *                                                                                       CSC022
     C                   If        Comitnum > 0                                               CSC022
     C                   MoveA     wComitjobs    wComitarr                                    CSC022
     C     psJobname     Lookup    wComitarr                              10                  CSC022
     C                   If        *IN10                                                      CSC022
     C                   Eval      wSkip = 'Y'                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
                                                                                              CSC022
      ** Access API ICD details.
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDAPIPD '    DBFILE
     C                   Z-ADD     008           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
