     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Spot Rate interface control')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDSPTRVU - Spot Rate validate and update                     *
      *                                                               *
      *  Function: This program validates spot rates for input into   *
      *            the Midas database.                                *
      *            The action code determines which processes are     *
      *            executed as follows:                               *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the transaction details fields        *
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
      *            whether to write to the valid or invalid file and  *
      *            the call to the message handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CGL165             Date 23Feb15               *
      *  Prev Amend No. CDL094             Date 01Sep14               *
      *                 MD025009B          Date 12May14               *
      *                 CFT147             Date 14Jan13               *
      *                 CER059             Date 19Jul10               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG22196           Date 15Jan09               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CLE031             Date 26Apr05               *
      *                 BUG8205            Date 23Aug05               *
      *                 BUG8130            Date 10Aug05               *
      *                 BUG4469            Date 06Oct04               *
      *                 CDL018             Date 03Feb04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 26Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD025009B - API returned a Serious midas error has occurred  *
      *  CFT147 - Automatic update of payment charges definitions     *
      *           Added hooks: CFT147_040, CFT147_041, CFT147_042,    *
      *           CFT147_043, CFT147_044, CFT147_045                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  BUG22196 - Missing authorization field in repository.        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  BUG8205 - Recompiled due to changes in file SDVSPTRPD        *
      *            Applied fix 209061                                 *
      *  BUG8130- Recompiled as there have been changes to SDVSPTRPD  *
      *  BUG4469- Stopping changes being overwritten by other user    *
      *           when try to amend the record at the same time by    *
      *           passing the Timestamp out to API.                   *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
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
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API CTL & VU modules.
     D/COPY ZACPYSRC,APICTLARR
      **-----------------------------------------------------------------------
 
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
 
      * Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming transaction in screen format
     D SPTRScnFmt    E DS                  EXTNAME(SDSPTRPD)
 
      ** Spot Rate in File Format
     D SPTRFilFmt    E DS                  EXTNAME(SDVSPTRPD)
     D  QQCSCD1      E                     EXTFLD(QQCSCD)                                     CGL029
 
      ** Current Transaction record in file Format
     D TranFilFmt    E DS                  EXTNAME(SDCURRPD)
     D  QQSPAE1      E                     EXTFLD(QQSPAE)                                     CGL029
     D  QQFTAE1      E                     EXTFLD(QQFTAE)                                     CGL029
     D  QQSWAE1      E                     EXTFLD(QQSWAE)                                     CGL029
     D  QQTAC41      E                     EXTFLD(QQTAC4)                                     CGL029
     D  QQTAC51      E                     EXTFLD(QQTAC5)                                     CGL029
 
      * Current Transaction in Screen Format - Main Details
     D CurTrSPTR     E DS                  EXTNAME(SDSPTRPD)
     D                                     PREFIX(@)
 
      ** Spot rate Details Error Indicator File
     D OkTrTran      E DS                  EXTNAME(SDESPTRPD)
 
      * Pay settlement instructions in screen format
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
 
      * Receive settlement instructions in screen format
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
 
      * 24X7 Data area structure
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      * External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      * External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
 
      * First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * Second DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D PCMD            S            100    DIM(4) CTDATA PERRCD(1)
      ** Override Database Table
     D/COPY OFCPYSRCZ,CFT147_040                                                              CFT147
 
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
 
      * Index for arrays of error message ids etc
     D Idx             S              3P 0 INZ(0)
 
      * Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(0)
 
      * Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
     D JavaUser        S             10A
 
     D CSC011          S              1A
     D WRunDay         S                   LIKE(BJRDNB)
 
      ** Define module parameter fields for call to CVT module
     D DDCYNM          S                   LIKE(A6CYNM)
     D DDDCY2          S                   LIKE(A6DLCI)
     D DDDLCY          S                   LIKE(A6DLCI)
     D DDMDI2          S                   LIKE(A6MDIN)
     D DDSPR2          S                   LIKE(DDSPRT)
     D DDSWCY          S                   LIKE(A6SWCY)
     D DDSWC2          S                   LIKE(A6SWCY)
     D DDVSEU          S                   LIKE(A6CYCD)
 
     D PCMDLEN         S             15  5
                                                                                              CSC022
      ** Commitment Control Variables                                                         CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D wSkip           S              1A   INZ('N')                                           CSC022
     D/COPY OFCPYSRCZ,CFT147_041                                                              CFT147
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     SPTRScnFmt
 
      * Reset variables gradually updated
     C                   EXSR      RESETCYCLE
 
      * Validate action code
     C                   EXSR      ValidateAc
      *
      * If error in validation of action code, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
     C                   SELECT
 
      * Processing for amends or changes
     C                   WHEN         DDACTN = 'A'
     C                   EXSR      SetupAmd
     C                   EXSR      ValidateTr
 
     C                   ENDSL
 
      * Write to database
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
     C                   ENDIF
 
      * Remerge buffer with all relevant data structures
     C                   EVAL      Buffer = SPTRScnFmt
     C                                     + @TimeStamp                                      BUG4469
 
     C     INVALID       TAG
     C                   SETON                                        LR
 
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
 
      * Transaction information
     C                   PARM                    Trans5001
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
     C                   PARM                    @TimeStamp       26                         BUG4469
     C                   PARM                    AAuth             1                        BUG22196
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'xxUSRMSG'
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn                              ************
     C                   EVAL      DBFILE =  'SDBANKPD'                         * DBERR 01 *
     C                   EVAL      DBASE  =  001                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if CSC011 is installed
      ** If CSC011 is installed and in switchover mode, use
      ** S1DATE from DTAARA/SC24x7 as the rundate.
 
     C                   EVAL      WRunDay = BJRDNB
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RtCd = *Blanks
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   IF        LIBR = S1SUPP
     C                   EVAL      WRunDay = S1DATE
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   IF        @RtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSC011'                             ************
     C                   EVAL      DBFILE = 'SCSARDPD'                          * DBERR 07 *
     C                   EVAL      DBASE = 007                                  ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 is on.                                CSC022
      *                                                                                       CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      @SARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
      ** Database Error                                                                       CSC022
      *                                                                                       CSC022
     C                   If        @RTCD <> *BLANKS and                                       CSC022
     C                             @RTCD <> '*NRF   '                                         CSC022
     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
     C                   Eval      DBASE = 008                                                CSC022
     C                   Eval      DBKEY = 'CSC022'                                           CSC022
     C                   ExSr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *BLANK                                             CSC022
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
     C/COPY OFCPYSRCZ,CFT147_042                                                              CFT147
      *  Hook to enable non-core initial processing to be included
     D/COPY WNCPYSRC,SDSPTR01
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *              Internal Funding Deal supplied                   *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      * Validate action code versus transaction Spot Rate supplied.
      * The Spot Rate in file format from the database is retrieved
      * as well.
     C                   RESET                   ReturnCode
 
     C                   CALLB     'SDSPTRRTV'
      *
      *
      * Return code
     C                   PARM      *BLANK        ReturnCode
      * INPUTS
      *
      * Mode of operation (front office or not front office)
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE        1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      *
      * (Midas) Transaction Number
     C                   PARM                    DDCYCD            3
      *
      * OUTPUTS
      *
      * (Current) Transaction in file format
     C                   PARM                    SPTRFilFmt
      *
      * OK - Action code
     C                   PARM                    DDActnOK          1
      *
      * OK - Transaction Number
     C                   PARM                    DDCYCDOK          1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *            of amendments.                                     *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR
 
      * For Amends, convert the Spot Rate transaction to screen format
 
     C                   CALLB     'SDSPTRCVT'
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Spot Rates Transaction - file formats
     C                   PARM                    SPTRFilFmt
      *
      * Output parameters
      *
      * Spot Rates Transaction Details - screen formats
     C                   PARM                    CurTrSPTR
 
      * Currency Name
     C                   PARM                    DDCYNM
 
      * Dealing currency
     C                   PARM                    DDDLCY
 
      * SWIFT currency code
     C                   PARM                    DDSWCY
 
      * BKEURO currency
     C                   PARM                    DDVSEU
 
      * Spot Rate against base currency (when DDSPRT is against BKEURO)
      * (output screen field)
     C                   PARM                    DDSPR2
 
      * Multiply divide indicator tied to DDSPR2
      * (output screen field)
     C                   PARM                    DDMDI2
 
      * Dealing currency tied to DDSPR2 (output screen field)
     C                   PARM                    DDDCY2
 
      * Swift currency code tied to DDSPR2 (output screen field)
     C                   PARM                    DDSWC2
 
     C                   MOVE      @DDDFTS       DDDFTS
 
     C                   ENDSR
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
 
      * Validate Internal Funding Deal details
 
     C                   RESET                   RetCodeOut
 
     C                   CALLB     'SDSPTRVAL'
      *
      * INPUTS
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE
      *
      ** Spot Rates  Transaction Details
     C                   PARM                    SPTRScnFmt
      *
      * OUTPUTS
      *
      *
      ** Spot Rates Transaction Details OK inds
     C                   PARM                    OKTrTran
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      * Valid Spot Rates Transaction (DS) from/to caller
     C                   PARM                    SPTRFilFmt
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETCYCLE- Reset error information that is gradually         *
      *             updated during each run of this program           *
      *                                                               *
      *****************************************************************
     C     RESETCYCLE    BEGSR
 
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
 
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIdArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx
 
     C                   CLEAR                   CurTrSPTR
     C                   CLEAR                   SPTRFilFmt
 
     C                   EVAL      OkTrTran = *ALL'Y'
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *              valid file record.                               *
      *                                                               *
      *****************************************************************
 
     C     SETUPVALID    BEGSR
 
      ** Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      AVTYLC = DDACTN
     C                   EVAL      AVCYCD = DDCYCD
 
      ** Include Header fields that need to be o/p to the Valid file
     C                   EVAL      AVFOTRANID = APFOTranID
     C                   EVAL      AVRPRLOCN = APRprLocn
                                                                                             BUG4469
      * Restore Timestamp from the original record                                           BUG4469
     C                   IF        DDACTN <> 'I'                                             BUG4469
     C                             and @TimeStamp <> *BLANK                                  BUG4469
     C                   MOVEL     @TimeStamp    AVTMESTMP                                   BUG4469
     C                   ENDIF                                                               BUG4469
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update database                                    *
      *                                                               *
      *****************************************************************
 
     C     UPDATEDB      BEGSR
 
      ** Override SDCURRL0
 
     C                   Z-ADD     32            PCMDLEN
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCMD(1)
     C                   PARM                    PCMDLEN
 
      ** Override SDCURRL1
 
     C                   Z-ADD     32            PCMDLEN
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCMD(2)
     C                   PARM                    PCMDLEN
 
      ** Spot Rate Transaction Details Updates
 
     C                   CALLB     'SDSPTRUPD'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    SPTRFilFmt
     C/COPY OFCPYSRCZ,CFT147_043                                                              CFT147
 
      ** Delete override of SDCURRL0
 
     C                   Z-ADD     21            PCMDLEN
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCMD(3)
     C                   PARM                    PCMDLEN
 
      ** Delete override of SDCURRL1
 
     C                   Z-ADD     21            PCMDLEN
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCMD(4)
     C                   PARM                    PCMDLEN
      *
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program. Otherwise, commit the updates
      *
     C     @RTCD         IFNE      *BLANK
     C                   IF        @RTCD <> '*RECUPD'                                      MD025009B
     C                   MOVE      '0'           APIRetc                                      CSC022
     C                   ENDIF                                                             MD025009B
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   else                                                                 CSC022
     C                   If        wSkip <> 'Y'                                               CSC022
     C                   Rolbk                                                                CSC022
     C                   else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C     @RTCD         IFNE      '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ELSE
     C/COPY OFCPYSRCZ,CFT147_044                                                              CFT147
     C                   If        CSC022 = 'N' or                                            CSC022
     C                             (wSkip = 'N' and CSC022 = 'Y')                             CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   ENDIF
      *
      ** If update not done due to record being updated by another
      ** workstation send message to screen.
      *
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'SDM0089'     MsgIdArr(1)
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * The following /COPY contains the standard program status
      * subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
** PCMD
OVRDBF FILE(SDCURRL0) SHARE(*NO)
OVRDBF FILE(SDCURRL1) SHARE(*NO)
DLTOVR FILE(SDCURRL0)
DLTOVR FILE(SDCURRL1)
     X/COPY OFCPYSRCZ,CFT147_045                                                              CFT147
