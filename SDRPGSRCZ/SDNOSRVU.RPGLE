     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Nostro Codes - Validate and Update Module')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDNOSRVU - Nostro Codes Details validate and update          *
      *                                                               *
      *  Function: This program validates Nostro Codes details for    *
      *            input into the Midas database.                     *
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
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD048898           Date 27Oct17               *
      *  Prev Amend No. MD038440           Date 27Oct17               *
      *                 MD046248           Date 27Oct17               *
      *                 MD033843           Date 04May16               *
      *                 CDL094C01          Date 01Sep14               *
      *                 CDL094             Date 01Sep14               *
      *                 MD027264           Date 25Jun14               *
      *                 AR920354           Date 09Nov12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15926           Date 15Feb08               *
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD048898 - No valitadion for RSAC txn when deleting nostro   *
      *             revert commented by MD038440.                     *
      *  MD038440 - Nostro Deletion issue. Revised validation process *
      *  MD046248 - Finastra Rebranding                               *
      *  MD033843 - Change how error is thrown so system can process  *
      *             the event codes.                                  *
      *           - Applied for MD-37069.                             *
      *  CDL094C01 - Prevent SWIFT BIC and allow Counterparty Nostro  *
      *              entry (MD-29082) (Recompile)                     *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *  MD027264 - Serious midas error when timestamp is blank.      *
      *             Move timestamp only if not blank.                 *
      *  AR920354 - Nostro attached to Midas transactions can be      *
      *             deleted causing components to fail.               *
      *             Check nostro before deletion against MM, FX, LE   *
      *             and SE transactions. Also against RSACMTPD.       *
      *             Patterned after AR571693. (Child: AR920483)       *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15926 - Database error after confirm authorise            *
      *  CRE026 - Consumer Banking                                    *
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
     D TranInNosr    E DS                  EXTNAME(SDNosrPD)

      * Valid file layout
     D ValidNosr     E DS                  EXTNAME(SDVNosrPD)
     D                                     PREFIX(V_)
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)
      * Separate out settlement instructions

      * Current transaction record in file format
     D NosrFilFmt    E DS                  EXTNAME(SDNostPD)
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)
      * Separate out settlement instructions

      * Current transaction in screen format
     D CurTrNosr     E DS                  EXTNAME(SDNosrPD)
     D                                     PREFIX(@)


      * Extra data in file format
     D ExtData       E DS                  EXTNAME(SDNvEXPD)

      * Error indicators
     D OKTrNosr      E DS                  EXTNAME(SDENosrPD)

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

      * Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A

      * Indices for arrays used to set up corresponding
      * sequence numbers for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0

      * Timestamp for the transaction
     D TimeStamp       S               Z

     D BChar           DS                                                                   MD033843
     D   BLen                  1      2B 0                                                  MD033843
     D   LenStr                1      2                                                     MD033843
      *                                                                                     MD033843
     D MsgDtaTmp       S             99A                                                    MD033843
      *                                                                                     MD033843
     D @@MSG           DS                                                                   MD033843
     D   @@MSG1                1     25                                                     MD033843
     D   @@MSG2               26     45                                                     MD033843
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
     C                   MOVEL     Trans5001     TranInNosr
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
     C                   EXSR      SetupAmd
     C                   EXSR      ValdateAmd
     C                   EXSR      ValidateTr

     C                   WHEN      DDACTN = 'X'
      *  Processing for Authorises
     C                   EXSR      ValidateTr

     C                   ENDSL
      *
     C     INVALID       TAG

      * Write to database
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
     C                   ENDIF
     C                   ENDIF

     C                   SETON                                        LR

      ** If action is for Update, get the correct record information
      ** from file
     C                   IF        UpdateYN = 'Y' AND
     C                             Idx = 0 AND DDACTN <> 'D'
     C                   MOVE      DDCYCD        DDCYCD_In
     C                   MOVE      DDNONB        DDNONB_In
     C                   CALL      'SDNOSRR'
     C                   PARM                    @AuthComp         1
     C                   PARM                    @FwdBck           1
     C                   PARM                    DDCYCD_In         3
     C                   PARM                    DDNONB_In         2
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC           1
     C                   MOVEL     DDACTN        Buffer
     C                   ELSE
      * Remerge buffer with all relevant data structures
     C                   EVAL      Buffer = TranInNosr + @TimeStamp
     C                                                    + EXTDATA
     C                   ENDIF

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
     C                   PARM                    @TimeStamp       26

      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'

      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,SDNosrM01
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
      * Access SAR details file to determine if Continuous Linked Settlement
      * CDL008 switchable feature is switched on.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL008'      @SARD             6
     C                   PARM                    DSFDY
      *
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CDL008            1
     C                   ELSE
     C                   MOVEL     'N'           CDL008
     C                   ENDIF
      *
      * Access SAR details file to determine if Retail Account Balance Check
      * CRE010 switchable feature is switched on.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRE010'      @SARD             6
     C                   PARM                    DSFDY
      *
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CRE010            1
     C                   ELSE
     C                   MOVEL     'N'           CRE010
     C                   EndIf
      ** Access SAR details file to determine if Standing Data Authorisation
      ** CSD012 switchable feature is switched on.
     C                   CallB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CSD012'      @SARD
     C                   Parm                    DSFDY
      *
     C                   If        @RTCD = *BLANKS
     C                   MOVEL     'Y'           CSD012            1
     C                   ELSE
     C                   MOVEL     'N'           CSD012
     C                   EndIf
      *

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDNosr01

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
      * The Transaction in file format from the SD database is retrieved
      * as well.
     C                   RESET                   ReturnCode
     C                   CALLB     'SDNOSRRTV'
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
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      *
      * (Midas) Nostro Currency Code
     C                   PARM                    DDCYCD            3
      * (Midas) Nostro Number
     C                   PARM                    DDNONB            2
      *
      * Outputs
      *
      * (Current) Nostro Codes in file format
     C                   PARM                    NosrFilFmt
      *
      * OK - Action code
     C                   PARM                    DDActnOK          1
      *
      * OK - Nostro Currency Code
     C                   PARM                    DDCycdOK          1
      *
      * OK - Nostro Number
     C                   PARM                    DDNonbOK          1
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx


     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Default settlements - Apply default settlement instructions   *
      *    ##########  take straight from CTL ##############          *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *            of amendments.                                     *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR

      * For amends, put the complete (pre-existing) transaction into the valid
      * file record - fields in this will be updated during processing

     C                   MOVE      NosrFilFmt    ValidNosr

      * Include all data structures required. If Settle details not included copy FXFXDLVU/MMDEAM
      *

     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR

      * Validate transaction details
     C                   RESET                   ReturnCode

     C                   CALLB     'SDNOSRVAL'

      * Inputs

      * Response mode
     C                   PARM      'S'           RespMode          1

      ** Nostro Codes Details
     C                   PARM                    TranInNosr

      * Extra Data
     C                   PARM                    ExtData
      ***********************************
      * Ensure validation module is ready to accept infdata and extdata
      ***********************************

      * Outputs
      *
      ** Nostro Codes Details OK inds
     C                   PARM                    OKTrnosr

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

      * Valid Nostro Codes (DS) from/to caller
     C                   PARM                    ValidNosr

      * Insert correct parameters for this VAL function
      *
      *  If error in validation, fail this input
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   EndIf
      *### Check whether any post validation processing is done in SIN module
      *### and if so insert here. Data structures may be needed.

     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateSt - Routine to validate the settlement instructions  *
      *   ######     include if neccessary - take from CTL     #####  *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdateAmd - Routine to check whether the fields amended      *
      *              are amendable.                                   *
      *                                                               *
      *****************************************************************

     C     ValdateAmd    BEGSR

      * This subroutine calls a procedure which checks whether it     *
      * was valid to amend any of the fields which have been          *
      * changed.  Some are never amendable and some depend upon ICD   *
      * settings as to whether they are amendable.                    *

      * To determine what fields have changed, the current fields     *
      * on file must be converted to a 'screen' format.               *

      * These fields are then compared with the fields on the input   *
      * transaction.                                                  *

      * Any errors detected by the called procedure take precedence   *
      * over any errors found during the validation of the complete   *
      * transaction.  The errors from the called procedure are kept   *
      * separately and, if any are found, these errors will REPLACE   *
      * the normal validation errors.                                 *

      * Convert file format to screen format

     C                   RESET                   ReturnCode
     C                   CALLB     'SDNOSRCVT'
      * Ensure correct parameters for this CVT function
      *
      * Output Parameters
      *
      * Return Code
     C                   PARM      *BLANKS       RetCodeIn
      *
      * Nostro Codes Details File Format
     C                   PARM                    NosrFilFmt
      *

      * Output Parameters

      * Nostro Code Details Screen Format
     C                   PARM                    CurTrNosr

      *
      * Insert correct parameters for this CVT function

     C                   RESET                   ReturnCode

     C                   CALLB     'SDNOSRAMD'
      *
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * New Deal in Screen Format (Incoming Transaction)
     C                   PARM                    TranInNosr
      * (Current) Deal in Screen Format
     C                   PARM                    CurTrNosr
      *
      * OUTPUTS
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKTrnosr
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      * Amendments OK
     C                   PARM                    AmendOk           1
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'N'           ResetErrs         1


      * If any errors overwrite previous error information
     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF

     C                   ENDSR
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

     C                   CLEAR                   CurTrNosr
     C                   MOVE      *ALL'Y'       OKTrNosr
     C                   CLEAR                   ValidNosr

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *              valid file record.                               *
      *                                                               *
      *****************************************************************

     C     SETUPVALID    BEGSR
      *
      * Set file field(s) that are needed for all action codes
     C                   EVAL      V_NVTYLC = DDACTN
     C                   EVAL      V_NVLCD  = BJRDNB
     C                   EVAL      V_NVCYCD = DDCYCD
     C                   EVAL      V_NVNONB = DDNONB
     C                   EVAL      V_NVACCD = DDACCD
     C                   EVAL      V_NVCUST = DDCUST
     C                   MOVE      DDACSN        V_NVACSN
     C                   EVAL      V_NVNOSN = DDNOSN
     C                   EVAL      V_NVOACN = DDOACN
     C                   EVAL      V_NVORAC = DDORAC
     C                   EVAL      V_NVPNOI = DDPNOI
     C                   EVAL      V_NVBRCD = DDBRCD
     C                   EVAL      V_NVCLSD = DDCLSD
     C                   EVAL      V_NVLPR  = DDLPR
     C                   EVAL      V_NVMPGT = DDMPGT
     C                   MOVE      DDPMLT        V_NVPMLT
     C                   EVAL      V_NVBL3C = DDBL3C
     C                   EVAL      V_NVCLSM = DDCLSM
     C                   EVAL      V_NVCLSC = DDCLSC
     C                   EVAL      V_NVASID = DDASID

      * Receive Settlement Instructions                                                       CDL094
     C                   EVAL      V_NVRF56 = DDRF56                                          CDL094
     C                   EVAL      V_NVRA56 = DDRA56                                          CDL094
     C                   EVAL      V_NVRF57 = DDRF57                                          CDL094
     C                   EVAL      V_NVRA57 = DDRA57                                          CDL094
     C                   EVAL      V_NVRF58 = DDRF58                                          CDL094
     C                   EVAL      V_NVRA58 = DDRA58                                          CDL094
      * Include header fields that need to be o/p to the valid file
     C                   EVAL      V_NVFRNT = APFOTranID
      *
     C                   IF        DDACTN <> 'I'
     C                             AND @TimeStamp <> *BLANKS                                MD027264
     C                   MOVEL     @TimeStamp    V_NVTMST
     C                   ENDIF


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
     C                   RESET                   ReturnCode
      *
     C                   CALLB     'SDNOSRUPD'

      * Ensure correct parameters for this UPD function
     C**********         PARM                    @RTCD                                      BUG15926
     C                   PARM      *BLANKS       @RTCD                                      BUG15926
     C                   PARM                    ValidNosr
      *                                                                                     AR920354
      ** Return the ref. no that uses the Nostro account                                    AR920354
      *                                                                                     AR920354
     C**********         PARM                    @@MSG            45               AR920354 MD033843
     C                   PARM                    @@MSG                                      MD033843

      *
      * If there were any errors in the update functions, rollback any
      * updates (done in *PSSR) and end this program. Otherwise commit.
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
      *                                                                                     AR920354
      ** Indicate appropriate error messages                                                AR920354
      *                                                                                     AR920354
     C                   IF        @RTCD = 'R'                                              AR920354
     C**********         MOVEL     '*ANY'        FldNameArr(1)                     AR920354 MD033843
     C**********         MOVEL     @@MSG         MsgDtaArr(1)                      AR920354 MD033843
     C                   MOVEL     'DDNONB'      FldNameArr(1)                              MD033843
     C                   EVAL      BLen = %Len(%Trim(@@MSG1))                               MD033843
     C                   EVAL      MsgDtaTmp = LenStr +%TRIM(@@MSG1)                        MD033843
     C                   EVAL      BLen = %Len(%Trim(@@MSG2))                               MD033843
     C                   EVAL      MsgDtaArr(1) = %TRIM(MsgDtaTmp) + LenStr                 MD033843
     C                                            +%TRIM(@@MSG2)                            MD033843
     C**********         MOVEL     'USR0001'     MsgIdArr(1)                       AR920354 MD038440
     C                   MOVEL     'USS9845'     MsgIdArr(1)                                MD038440
     C**********         ELSEIF    @RTCD = 'P'                                     AR920354 MD038440
     C**********         MOVEL     '*ANY'        FldNameArr(1)                     AR920354 MD033843
     C**********         MOVEL     @@MSG         MsgDtaArr(1)                      AR920354 MD033843
     C**********         MOVEL     'DDNONB'      FldNameArr(1)                     MD033843 MD038440
     C**********         EVAL      BLen = %Len(%Trim(@@MSG1))                      MD033843 MD038440
     C**********         EVAL      MsgDtaTmp = LenStr +%TRIM(@@MSG1)               MD033843 MD038440
     C**********         EVAL      BLen = %Len(%Trim(@@MSG2))                      MD033843 MD038440
     C**********         EVAL      MsgDtaArr(1) = %TRIM(MsgDtaTmp) + LenStr        MD033843 MD038440
     C**********                                  +%TRIM(@@MSG2)                   MD033843 MD038440
     C**********         MOVEL     'USR0002'     MsgIdArr(1)                       AR920354 MD038440
     C**********         ELSEIF    @RTCD = 'Y'                                     AR920354 MD038440
     C**********         MOVEL     '*ANY'        FldNameArr(1)                     AR920354 MD038440
     C**********         MOVEL     'Y2U1033'     MsgIdArr(1)                       AR920354 MD038440
     C**********         MOVEL     '0'           APIRetc                                    MD038440
     C**********         EXSR      *PSSR                                                    MD038440
     C                   ELSEIF    @RTCD = 'Y'                                              MD048898
     C                   MOVEL     '*ANY'        FldNameArr(1)                              MD048898
     C                   MOVEL     'Y2U1033'     MsgIdArr(1)                                MD048898
     C                   EndIf
     C                   ENDIF                                                              AR920354
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
(c) Finastra International Limited 2006
