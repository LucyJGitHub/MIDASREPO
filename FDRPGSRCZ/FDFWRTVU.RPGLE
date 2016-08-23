     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD Forward Rates Validate and update')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing ILE Module                                   *
      *                                                               *
      *  FDFWRTVU - FD Forward Rates Validate and update              *
      *                                                               *
      *  Function: This program validates Forward Rates Input into    *
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
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. 255602             Date 23Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 241919             Date 22Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242215             Date 13Sep06               *
      *                 241066             Date 23Aug06               *
      *                 BUG8233            Date 23Aug05               *
      *                 BUG8141            Date 11Aug05               *
      *                 238595 (Reopen)    Date 03Apr06               *
      *                 BUG3704            Date 28Feb05               *
      *                 BUG1056            Date 06May04               *
      *                 CAP084  *CREATE    Date 05Jan04               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255602 - Recompiled due to changes in FDFWRTUPD              *
      *  241919 - Recompiled due to changes done to FDVFWRTPD.        *
      *  242215 - The first forward rate is always defaulted to zero  *
      *           when feature S01432 is off. Amended subr/SRDFT to   *
      *           remove the initialisation of field DDRTE1 to blank. *
      *  241066  - Default first forward rate to spot regardless      *
      *            of the status of CAP059.                           *
      *  BUG8233- Error in Forward Rates upload via File Adapter API  *
      *           (Recompile)                                         *
      *  BUG8141- Recompiled due to changes to FDVFWRTPD              *
      *  238595 (Reopen) - Forward rates for 'Out' ccy recalculated   *
      *           twice.  Previous rates passed as blanks.            *
      *  BUG3704 - Cannot Amend Forward Rates                         *
      *  BUG1056 - Midas Plus API development.                        *
      *            Added Commitment Control Changes for Midas Plus.   *
      *  CAP084 - Synchronous calling of APIs                         *
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
     D TranInFwrt    E DS                  EXTNAME(FDFwrtPD)
     D  TranIn1                1    500
     D  TranIn2              501    550
 
      * Valid file layout
     D ValidFWRT     E DS                  EXTNAME(FDVFwrtPD)
     D                                     PREFIX(V_)
 
      * Current transaction record in file format
     D FWRTFilFmt    E DS                  EXTNAME(FWDRTFE)
 
      * Current transaction in screen format
     D CurTrFwrt     E DS                  EXTNAME(FDFwrtPD)
     D                                     PREFIX(@)
 
      * Extra data in file format
     D ExtData       E DS                  EXTNAME(FDFREXPD)
 
      * Previous Forward Rates Detail in File Format
     D PrvFRFilFmt   E DS                  EXTNAME(FDVFWRTPD)
     D                                     PREFIX(P)
 
      * Error indicators
     D OKTrFwrt      E DS                  EXTNAME(FDEFwrtPD)
 
      * External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      * External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      * External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
 
      * First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * Second DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status data area
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
      ** Data structure for data area commitment control                                     BUG1056
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                BUG1056
     D  ComitJobs              4    103A                                                     BUG1056
                                                                                             BUG1056
     D JobCmtCtlDS     S             10A   DIM(10)                                           BUG1056
      * MIDAS SC Jobs Handling Commitment Control Data Structure                             BUG1056
                                                                                             BUG1056
      * Forward rates in screen format                                                       BUG3704
     D FwrtScnFmt    E DS                  EXTNAME(FDFwrtPD)                                 BUG3704
     D                                     PREFIX(X)                                         BUG3704
                                                                                             BUG3704
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
      ** Define workfields for Commitment Control Changes for Midas Plus                     BUG1056
     D CSC022          S              1A                                                     BUG1056
     D WSkpCom         S              1A                                                     BUG1056
     D WPos            S              2S 0                                                   BUG1056
      ** Fields defined for BUG3704                                                          BUG3704
     D WDDACTN         S                   LIKE(DDACTN)                                      BUG3704
     D DDCCY_In        S                   LIKE(DDCCY)                                       BUG3704
     D AuthComp        S              1A                                                     BUG3704
     D FwdBck          S              1A                                                     BUG3704
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
     C                   EXSR      RetPrvScn                                                 BUG3704
      *
      * If error in validation of action code, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      * Call defaulting sub-routine
     C**********         IF        CAP059 = 'Y'                                               241066
     C                   IF        DDACTN = 'I'
     C                   EVAL      @DDACTN = DDACTN
     C                   EVAL      @DDCCY  = DDCCY
     C                   ENDIF
     C                   EXSR      SRDFT
     C**********         ENDIF                                                                241066
      *
      *  If error in validation of action code, fail this input
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
      *
     C                   IF        CAP059 = 'N'
     C                   EXSR      ValidateTr
     C                   ENDIF
      *
      * Processing depends upon action code
      *
     C                   IF        CAP059 = 'Y'
     C                   SELECT
 
      * Processing for inserts
     C                   WHEN         DDACTN = 'I'
     C                   EXSR      ValidateTr
 
      * Processing for amends or changes
     C                   WHEN         DDACTN = 'A'
     C                   EXSR      ValidateTr
 
      * Processing for deletes
     C                   WHEN         DDACTN = 'D'
     C                   CLEAR                   ValidFWRT
     C                   MOVEL     FWRTFilFmt    ValidFWRT
     C                   EVAL      V_FWCHTP = DDACTN
     C                   EVAL      V_FWLCD  = BJRDNB
 
     C                   ENDSL
     C                   ENDIF
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
     C                   EVAL      Buffer = TranIn1 + TranIn2 + Extdata
 
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
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,FDFWRTM02
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
      ** Access SAR details file to determine if Forward Rates API
      ** Switchable feature is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP059'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CAP059            1
     C                   ELSE
     C                   MOVEL     'N'           CAP059
     C                   ENDIF
      *
      * Access SAR details file to determine if MDF (CSD006) switchable
      * feature is switched on
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
      *
      ** Check if CSC011 is installed
      *
     C                   CALLB     'AOSARDR0'
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
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Determine if enhancement CSC022 is switched on                                      BUG1056
                                                                                             BUG1056
     C                   CALLB     'AOSARDR0'                                                BUG1056
     C                   PARM      *BLANKS       PRTCD             7                         BUG1056
     C                   PARM      '*VERIFY'     POPTN             7                         BUG1056
     C                   PARM      'CSC022'      PSARD             6                         BUG1056
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG1056
      * Initialize work fields                                                               BUG1056
     C                   Eval      CSC022 = 'N'                                              BUG1056
     C                   Eval      WSkpCom = 'N'                                             BUG1056
      *                                                                                      BUG1056
     C                   If        PRTCD = *Blanks                                           BUG1056
     C                   Eval      CSC022 = 'Y'                                              BUG1056
      *                                                                                      BUG1056
     C                   IN        SCCMTJOB                                                  BUG1056
      *                                                                                      BUG1056
     C                   If        COMITNUM <> 0                                             BUG1056
     C                   MOVEA     Comitjobs     JobCmtctlDS                                 BUG1056
     C                   Eval      WPos = %Lookup(PSJOBNAME:JobCmtCtlDS)                     BUG1056
     C                   If        WPos > 0                                                  BUG1056
     C                   Eval      WSkpCom = 'Y'                                             BUG1056
     C                   Endif                                                               BUG1056
     C                   Endif                                                               BUG1056
     C                   Else                                                                BUG1056
      ** An NRF (No Record Found) return code is valid.                                      BUG1056
      ** Issue database error only for error return codes.                                   BUG1056
     C                   If        PRTCD <> '*NRF'                                           BUG1056
     C                   Eval      DBFILE = 'SCSARDPD'                                       BUG1056
     C                   Eval      DBKEY = 'CSC022'                                          BUG1056
     C                   Eval      DBASE = 001                                               BUG1056
     C                   EXSR      *PSSR                                                     BUG1056
     C                   EndIf                                                               BUG1056
     C                   EndIf                                                               BUG1056
      *  Hook to enable non-core initial processing to be included
     D/COPY WNCPYSRC,FDFWRT01
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *              transaction number supplied                      *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      * Validate action code versus transaction IDs supplied
      * The Transaction in file format from the FD database is retrieved
      * as well.
     C                   RESET                   ReturnCode
      *
     C                   MOVEL     *BLANKS       FWRTFilFmt
     C                   MOVEL     *BLANKS       PrvFRFilFmt
 
     C                   CALLB     'FDFWRTRTV'
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
      * Currency
     C                   PARM                    DDCCY             3
      *
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      *
      * Outputs
      *
      * (Current) Transaction in file format
     C                   PARM                    FWRTFilFmt
      *
      * OK - Action code
     C                   PARM                    DDActnOK          1
      *
      * OK - Currency
     C                   PARM                    DDCcyOK           1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Save previous rate details
     C                   MOVEL     FWRTFilFMT    PrvFRFilFmt
 
     C                   ENDSR
                                                                                             BUG3704
      *****************************************************************                      BUG3704
      /EJECT                                                                                 BUG3704
      *****************************************************************                      BUG3704
      *                                                               *                      BUG3704
      * RetPrvScn - Routine to retrieve previous screen format        *                      BUG3704
      *                                                               *                      BUG3704
      *****************************************************************                      BUG3704
     C     RetPrvScn     BEGSR                                                               BUG3704
                                                                                             BUG3704
     C                   MOVEL     DDACTN        WDDACTN                                     BUG3704
     C                   MOVEL     DDCCY         DDCCY_In                                    BUG3704
                                                                                             BUG3704
     C                   CALL      'FDFWRTR'                                                 BUG3704
     C                   PARM                    AuthComp                                    BUG3704
     C                   PARM                    FwdBck                                      BUG3704
     C                   PARM                    DDCCY_In                                    BUG3704
     C                   PARM                    FwrtScnFmt                                  BUG3704
     C                   PARM                    FldNameArr                                  BUG3704
     C                   PARM                    MsgIDArr                                    BUG3704
     C                   PARM                    MsgDtaArr                                   BUG3704
     C                   PARM                    MsgFArray                                   BUG3704
     C                   PARM                    APIRetC                                     BUG3704
                                                                                             BUG3704
      ** Save previous screen format                                                         BUG3704
                                                                                             BUG3704
     C                   MOVEL     FwrtScnFmt    CURTRFWRT                                   BUG3704
     C                   MOVEL     WDDACTN       DDACTN                                      BUG3704
     C                   MOVEL     Trans5001     TranIn1                                     BUG3704
     C                   MOVEL     Trans5002     TranIn2                                     BUG3704
                                                                                             BUG3704
     C                   ENDSR                                                               BUG3704
                                                                                             BUG3704
 
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
 
     C                   MOVEL     WDDACTN       @DDACTN                                     BUG3704
     C                   RESET                   ReturnCode
 
     C                   IF         DDACTN = 'A' OR DDACTN = 'I'
 
     C                   CALLB     'FDFWRTAMD'
     C                   PARM                    RetCodeIn
     C                   PARM                    CURTRFWRT
     C                   PARM                    TranInFwrt
     C                   PARM                    OKTrFwrt
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    AmendOk           1
     C                   PARM      'N'           ResetErrs         1
 
     C                   ENDIF
                                                                                             BUG3704
      *  If error in validation, fail this input                                             BUG3704
     C     Idx           IFNE      0                                                         BUG3704
     C                   GOTO      EValidTr                                                  BUG3704
     C                   EndIf                                                               BUG3704
 
      * Validate transaction details
     C                   RESET                   ReturnCode
 
      ** Return previous rate details                                                         238595
     C                   MOVEL     FWRTFilFMT    PrvFRFilFmt                                  238595
                                                                                              238595
     C                   CALLB     'FDFWRTVAL'
 
      * Inputs
 
      * Response mode
     C                   PARM      'S'           RespMode          1
 
      ** Forward Rates Transaction Details
     C                   PARM                    TranInFwrt
 
      * Extra Data
     C                   PARM                    ExtData
     C                   PARM                    PrvFRFilFmt
 
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKTrFwrt
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
     C                   PARM                    WIdx
      * Valid Forward Rates layout (DS) from/to caller
     C                   PARM                    ValidFWRT
      * Update Y/N?                                                                           238595
     C                   PARM                    UpdateYN                                     238595
 
      ***If*error*in*validation,*fail*this*input                                             BUG3704
     C*****Idx**         IFNE      0                                                         BUG3704
     C**********         GOTO      EValidTr                                                  BUG3704
     C**********         EndIf                                                               BUG3704
 
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
 
     C                   CLEAR                   CurTrFwrt
 
     C                   MOVE      *ALL'Y'       OKTrFwrt
 
     C                   CLEAR                   ValidFWRT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update database                                    *
      *                                                               *
      *****************************************************************
 
     C     UPDATEDB      BEGSR
      *
      * Update
      *
     C                   CALLB     'FDFWRTUPD'
 
      * Ensure correct parameters for this UPD function
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ValidFWRT
 
      *
      * If there were any errors in the update functions, rollback any
      * updates (done in *PSSR) and end this program. Otherwise commit.
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc
     C                   EXSR      *PSSR
     C                   ELSE
     C                   If        CSC022 = 'N'                                              BUG1056
     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                       BUG1056
     C                   COMMIT
     C                   Endif                                                               BUG1056
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
      *                                                               *
      * SRDFT - Default first rate                                    *
      *                                                               *
      *****************************************************************
     C     SRDFT         BEGSR
 
      ** Call Retrieve Module
 
     C**********         IF        DDACTN = 'I'                                               242215
     C**********         MOVE      *BLANKS       DDRTE1                                       242215
     C**********         ENDIF                                                                242215
 
     C                   CALLB     'FDFWRTDFT'
      * Return Code
     C                   PARM                    RetCodeIn
      ** Action Code
     C                   PARM                    DDACTN            1
      ** Currency Code
     C                   PARM                    DDCCY             3
      ** First Rate
     C                   PARM                    DDRTE1           14
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKTrFwrt
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
      *
     C                   PARM                    Idx
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1
      *
     C                   IF        IDX = 0  AND
     C                             DDACTN = 'I'
     C                   EVAL      @DDRTE1 = DDRTE1
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * The following /COPY contains the standard program status
      * subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C***/COPY*ZACPYSRC,PSSR_ILE****                                                         BUG1056
     C/COPY ZACPYSRC,PSSR_ILENE                                                              BUG1056
     C                   EVAL      APIRETC = '0'                                             BUG1056
     C                   RETURN                                                              BUG1056
     C                   ENDSR                                                               BUG1056
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
