     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD MM Int. Rates Validate/Update')               *
      *****************************************************************
      *                                                               *
      *  Midas - Module name ILE Module                               *
      *                                                               *
      *  FDINTRVU - MM Interest Rates validate and update             *
      *                                                               *
      *  Function: This program validates MM Interest Rates Input     *
      *            into the Midas database.                           *
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
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG8164            Date 19Sep05               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG4469            Date 06Oct04               *
      *                 BUG1625            Date 05May04               *
      *                 CAP084  *CREATE    Date 06Jan04               *
      *                         *CREATE    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  BUG8164 - Cannot enter MM interest rates                     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG4469- Stopping changes being overwritten by other user    *
      *           when try to amend the record at the same time by    *
      *           passing the Timestamp out to API.                   *
      *  BUG1625 - Commitment Control Changes for MidasPlus           *
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
     D TranInIntr    E DS                  EXTNAME(FDINTRPD)
     D TranIn1                 1    500
     D TranIn2               501    670
 
      * Valid file layout
     D ValidIntr     E DS                  EXTNAME(FDVINTRPD)
     D                                     PREFIX(V_)
      * Current transaction record in file format
     D IntrFilFmt    E DS                  EXTNAME(FDVINTRPD)
 
      * Current transaction in screen format
     D CurTrIntr     E DS                  EXTNAME(FDINTRPD)
     D                                     PREFIX(@)
 
     D ValWrkFlds    E DS                  EXTNAME(FDWINTRPD)
      ** Interest Rates Validation Workfields
 
      ** Previous Interest Rates Detail in File Format
     D PrvIRFilFmt   E DS                  EXTNAME(FDVINTRPD)
     D                                     PREFIX(P)
 
      * Pay settlement instructions in screen format
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
 
      * Receive settlement instructions in screen format
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
 
      * FRA/IRS settlement instructions in screen format
     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
 
      * Pay settlement instructions - current
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)
 
      * Receive settlement instructions - current
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)
 
      * FRA/IRS settlement instructions - current
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)
 
      * Pay settlement instructions in file format
     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
 
      * Receive settlement instructions in file format
     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
 
      * FRA/IRS settlement instructions in file format
     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
 
      * Extra data in file format
     D ExtData       E DS                  EXTNAME(FDIREXPD)
 
      * Error indicators
     D OKTrIntr      E DS                  EXTNAME(FDEINTRPD)
 
      * External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      * External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      * External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      * First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * Second DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status data area
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                BUG1625
     D  wComitjobs             4    103                                                      BUG1625
      ** External DS for Commitment Control Data Area                                        BUG1625
                                                                                             BUG1625
     D wComitarr       S             10A   DIM(10)                                           BUG1625
      ** Commitment Control Array                                                            BUG1625
                                                                                             BUG1625
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)
 
      * Index for arrays of error message ids etc in amend validation
     D AmIdx           S              3P 0 INZ(0)
 
      * Index for arrays of error message ids etc
     D Idx             S              3P 0 INZ(0)
 
      * Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(0)
 
      * Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
 
      * Field (500A) to receive the incoming transaction
     D Trans5002       S            500A
 
      * Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      * Indices for arrays used to set up corresponding
      * sequence numbers for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      * Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** Fields defined for CSC011
 
     D CSC011          S              1A
     D TRANSDTL        S           5800A
     D PDealNum        S             18A
     D PADealNo        S             18A
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
                                                                                             BUG1625
      ** Commitment Control Variables                                                        BUG1625
     D CSC022          S              1A   INZ('N')                                          BUG1625
     D wSkip           S              1A   INZ('N')                                          BUG1625
 
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
     C                   MOVEL     Trans5001     TranIn1
     C                   MOVEL     Trans5002     TranIn2
     C                   MOVEL     Extdata500    Extdata
 
      ** Generate a timestamp for this transaction
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      * Reset variables gradually updated
     C                   EXSR      RESETCYCLE
 
      * Validate action code
     C                   EXSR      ValidateAc
      *
      * If error in validation of action code, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      * Processing depends upon action code
     C                   SELECT
 
      * Processing for inserts
     C                   WHEN         DDACTN = 'I'
     C                   EXSR      ValidateTr
 
      * Processing for amends or changes
     C                   WHEN         DDACTN = 'A'
     C                   EXSR      ValidateTr
 
      * Processing for deletes
     C                   WHEN         DDACTN = 'D'
     C                   CLEAR                   ValidIntr
     C                   MOVEL     IntrFilFmt    ValidIntr
     C                   EVAL      V_FYCHTP = DDACTN
     C                   EVAL      V_FYLCD  = BJRDNB
 
     C                   ENDSL
      *
     C     INVALID       TAG
 
      * Write to database
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C     Idx           IFEQ      0
     C                   EXSR      UpdateDB
     C                   ENDIF
     C                   ENDIF
 
     C                   SETON                                        LR
 
      * Remerge buffer with all relevant data structures
     C****************   EVAL      Buffer = TranIn1 + TranIn2 + Extdata                      BUG4469
     C                   EVAL      Buffer = TranIn1 + TranIn2                                BUG4469
     C                                      + @TimeStamp                                     BUG4469
     C                                      + Extdata                                        BUG4469
 
     C                   RETURN
 
      ********************************************************************
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
     C                   PARM                    Trans5002
     C                   PARM                    ExtData500
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
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,FDINTRM02
      *
      * Access bank details via access program
      * (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      * Access SAR details file to determine if CSD006 is switchable feature
      * is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSD006'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CSD006            1
     C                   ELSE
     C                   MOVEL     'N'           CSD006
     C                   EndIf
 
      ** Access SAR details file to see if CAP058 is installed.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP058'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CAP058            1
     C                   ELSE
     C                   MOVEL     'N'           CAP058
     C                   EndIf
 
      ** Check if CSC011 is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd = *Blanks
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
 
     C                   IF        PRtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Access SAR details file to determine if CSC022 is on.                               BUG1625
      *                                                                                      BUG1625
     C                   CallB     'AOSARDR0'                                                BUG1625
     C                   Parm      *BLANKS       @RTCD                                       BUG1625
     C                   Parm      '*VERIFY'     @OPTN                                       BUG1625
     C                   Parm      'CSC022'      @SARD                                       BUG1625
     C     SCSARD        Parm      SCSARD        DSFDY                                       BUG1625
      *                                                                                      BUG1625
      ** Database Error                                                                      BUG1625
      *                                                                                      BUG1625
     C                   If        @RTCD <> *BLANKS and                                      BUG1625
     C                             @RTCD <> '*NRF   '                                        BUG1625
     C                   Eval      DBFILE = 'SCSARDPD'                                       BUG1625
     C                   Eval      DBASE = 2                                                 BUG1625
     C                   Eval      DBKEY = 'CSC022'                                          BUG1625
     C                   ExSr      *PSSR                                                     BUG1625
     C                   EndIf                                                               BUG1625
      *                                                                                      BUG1625
     C                   If        @RTCD = *BLANK                                            BUG1625
     C                   Eval      CSC022 = 'Y'                                              BUG1625
     C                   In        SCCMTJOB                                                  BUG1625
      *                                                                                      BUG1625
     C                   If        Comitnum > 0                                              BUG1625
     C                   MoveA     wComitjobs    wComitarr                                   BUG1625
     C     psJobname     Lookup    wComitarr                              10                 BUG1625
     C                   If        *IN10                                                     BUG1625
     C                   Eval      wSkip = 'Y'                                               BUG1625
     C                   EndIf                                                               BUG1625
     C                   EndIf                                                               BUG1625
     C                   EndIf                                                               BUG1625
      *  Hook to enable non-core initial processing to be included
 
     D/COPY WNCPYSRC,FDINTR01
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *              currency code supplied                           *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      * Validate action code versus currency code supplied
      * The Transaction in file format from the FD database is retrieved
      * as well.
     C                   RESET                   ReturnCode
      *
     C                   MOVEL     *BLANKS       IntrFilFmt
     C                   MOVEL     *BLANKS       PrvIRFilFmt
 
     C                   CALLB     'FDINTRRTV'
      * Ensure correct parameters for this RTV function
      *
      * Inputs
      *
      * Return code
     C                   PARM      *BLANK        ReturnCode
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE        1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Currency Code
     C                   PARM                    DDCCY             3
      *
      * Currency name
     C                   PARM                    DDCYNM           32
      *
      * Front Office Transaction ID
 
     C                   PARM                    APFOTranID       20
      *
      * Outputs
      *
      * (Current) MM Interest Rate in file format
     C                   PARM                    IntrFilFmt
      *
      * OK - Action code
     C                   PARM                    DDActnOK          1
      *
      * OK - Currency Code
     C                   PARM                    DDCycdOK          1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Validation workfields
 
     C                   PARM                    ValWrkFlds
 
      ** Save previous interest rate details
 
     C                   MOVEL     INTRFilFMT    PrvIRFilFmt
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
 
      * Validate interest record details
     C                   RESET                   ReturnCode
 
 
     C                   CALLB     'FDINTRVAL'
 
      * Inputs
 
      * Response mode
     C                   PARM      'S'           RespMode          1
 
     C                   PARM                    ModeOfOp          6
 
      ** MM Interest Details
     C                   PARM                    TranInIntr
 
     C                   PARM                    ExtData
 
     C                   PARM                    PrvIRFilFmt
      * Outputs
      *
      ** MM Interest Details OK inds
     C                   PARM                    OKTrIntr
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx              3 0
 
      * Valid MM Interest Rates layout (DS) from/to caller
     C                   PARM                    ValidIntr
 
     C                   PARM                    ValWrkFlds
 
      *  If error in validation, fail this input
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   EndIf
 
     C     EValidTr      ENDSR
      *****************************************************************
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
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx
 
     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx
 
 
     C                   RESET                   FldNoArr
 
     C                   CLEAR                   CurTrIntr
 
     C                   MOVE      *ALL'Y'       OKTrIntr
 
     C                   CLEAR                   ValidIntr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update database                                    *
      *                                                               *
      *****************************************************************
 
     C     UPDATEDB      BEGSR
                                                                                             BUG4469
      * Restore Timestamp from the original record                                           BUG4469
     C                   IF        DDACTN <> 'I'                                             BUG4469
     C                             and @TimeStamp <> *BLANK                                  BUG4469
     C                   MOVEL     @TimeStamp    V_FYTMESTMP                                 BUG4469
     C                   ENDIF                                                               BUG4469
      *
      * Update
 
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'FDINTRUPD'
 
      * Ensure correct parameters for this UPD function
     C                   PARM                    @RTCD
     C                   PARM                    ValidIntr
     C                   PARM                    ValWrkFlds
 
     C                   ENDIF
      *
      * If there were any errors in the update functions, rollback any
      * updates (done in *PSSR) and end this program. Otherwise commit.
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc
     C                   EXSR      *PSSR
     C                   ELSE
     C                   If        CSC022 = 'N' or                                           BUG1625
     C**********                   (wSkip = 'N' and CSC022 = 'Y')                    BUG1625 BUG8164
     C                             (wSkip = 'Y' and CSC022 = 'Y')                            BUG8164
     C                   COMMIT
     C                   EndIf                                                               BUG1625
     C                   EndIf
      *
      * If update not done due to record being updated by another
      * workstation send message to screen.
 
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'USR0015'     MsgIdArr(1)
 
     C                   EndIf
 
     C                   ENDSR
      *****************************************************************
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
(c) Finastra International Limited 2004
