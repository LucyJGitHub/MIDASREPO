     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Alternative Names & Addresses - Validate and Upd.')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDALNAVU - Customer Alternative Names & Addresses API        *
      *             Validate and Update                               *
      *                                                               *
      *  Function: This program validates Customer Alternative Names &*
      *            Addresses API details for input into Midas         *
      *            database.                                          *
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
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG22154           Date 14Jan09               *
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG22154 - Missing authorization field in repository.        *
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
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                    error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      ** The following /COPY includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.

     D/COPY ZACPYSRC,PROCPARMS

      **---------------------------------------------------------------
      ** The following /COPY includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API CTL & VU modules.
     D/COPY ZACPYSRC,APICTLARR
      **---------------------------------------------------------------

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
     D TranInAlna    E DS                  EXTNAME(SDAlnaPD)

      * Valid file layout
     D ValidAlna     E DS                  EXTNAME(SDValnaPD)
     D                                     PREFIX(V_)
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)
      * Separate out settlement instructions

      * Current transaction record in file format
     D AlnaFilFmt    E DS                  EXTNAME(SDAltnPD)
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)
      * Separate out settlement instructions

      * Current transaction in screen format
     D CurTrAlna     E DS                  EXTNAME(SDalnaPD)
     D                                     PREFIX(@)


      * Extra data in file format
     D ExtData       E DS                  EXTNAME(SDAlEXPD)

      * Error indicators
     D OKTralna      E DS                  EXTNAME(SDEalnaPD)

      ** EXTERNAL DS FOR Bank Detail
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)

      * External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)

      * External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)


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

     D @AuthComp       S              1A
     D @FwdBck         S              1A
     D DDCUST_In       S              6A
     D DDADCD_In       S              1A
     D APIRetC         S              1A

     D UpdateYN        S              1A
     D Buffer          S           6000A
     D @TimeStamp      S             26A

     D ModeofOp        S              6A

     D RespMode        S              1A

     D AmendOk         S              1A
     D ResetErrs       S              1A

      ** Parameters for AOBANKR0

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
      ** +--- Start of main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: *INZSR is   ¦
      ** ¦ executed at program activation                             ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      * Incoming transaction is broken into 500A fields, so a common CL
      * can be used between this module and the one that read MQ queue.
      * This module needs to break these 500A fields by loading them in
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     TranInAlna
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
     C                   WHEN      DDACTN = 'I'
     C                   EXSR      ValidateTr
      * Processing for amends or changes
     C                   WHEN      DDACTN = 'A'
     C                   EXSR      SetupAmd
     C                   EXSR      ValdateAmd
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
     C                   IF        UpdateYN = 'Y' AND IDX=0  AND
     C                             DDACTN<>'D'
     C                   MOVE      DDCUST        DDCUST_In
     C                   MOVE      DDADCD        DDADCD_In
     C                   CALL      'SDALNAR'
     C                   PARM                    @AuthComp
     C                   PARM                    @FwdBck
     C                   PARM                    DDCUST_In
     C                   PARM                    DDADCD_In
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
     C                   MOVEL     DDACTN        Buffer
     C                   ELSE
      * Remerge buffer with all relevant data structures
     C                   EVAL           Buffer = TranInAlna + @TimeStamp
     C                                       + ExtData
     C                   ENDIF

     C                   RETURN

      *****************************************************************
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
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp
     C                   PARM                    AAuth             1                        BUG22154

      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'

      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,SKAlnaM01
      *
      * Access bank details via access program
      * (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      * Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SKAlna01

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
      * The Alternative Name & Addresses in file format from the
      * SD database is retrieved as well.
     C                   RESET                   ReturnCode
     C                   CALLB     'SDALNARTV'
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
     C                   PARM                    ModeofOp
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE
      *
      * Action Code
     C                   PARM                    DDACTN
      *
      * Front Office Transaction ID
     C                   PARM                    APFOTranID
      *
      * (Midas) Transaction Number
     C                   PARM                    DDCUST
     C                   PARM                    DDADCD
      *
      * Outputs
      *
      * (Current) Alternative Name & Address in file format
     C                   PARM                    AlnaFilFmt
      *
      * OK - Action code
     C                   PARM                    DDActnOK
      *
      * OK - Customer Number
     C                   PARM                    DDCUSTOK
      *
      * OK - Address Code
     C                   PARM                    DDADCDOK

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

      * For amends, put the complete (pre-existing) transaction into
      * the valid file record - fields in this will be updated
      * during processing

     C                   MOVE      AlnaFilFmt    ValidAlna

      * Include all data structures required.
      * If Settle details not included copy FXFXDLVU/MMDEAM
      *

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateTr - Routine to validate the main transaction details *
      *                                                               *
      *****************************************************************
     C     ValidateTr    BEGSR

      * Validate transaction details
     C                   RESET                   ReturnCode

     C                   CALLB     'SDALNAVAL'

      * Inputs

      * Response mode
     C                   PARM      'S'           RespMode

      ** Alternative Name & Address Details
     C                   PARM                    TranInAlna

      * Extra Data
     C                   PARM                    ExtData
      ***********************************
      * Ensure validation module is ready to accept infdata and extdata
      ***********************************

      * Outputs
      *
      ** Alternative Name & Address Details OK inds
     C                   PARM                    OKTralna

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

      * Valid Alternative Name & Address (DS) from/to caller
     C                   PARM                    ValidAlna

      * Insert correct parameters for this VAL function
      *
      *  If error in validation, fail this input
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   EndIf
      *### Check whether any post validation processing is done in SIN
      *### module and if so insert here. Data structures may be needed.

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

      * This subroutine calls a procedure which checks whether it
      * was valid to amend any of the fields which have been
      * changed.  Some are never amendable and some depend upon ICD
      * settings as to whether they are amendable.

      * To determine what fields have changed, the current fields
      * on file must be converted to a 'screen' format.

      * These fields are then compared with the fields on the input
      * transaction.

      * Any errors detected by the called procedure take precedence
      * over any errors found during the validation of the complete
      * transaction.  The errors from the called procedure are kept
      * separately and, if any are found, these errors will REPLACE
      * the normal validation errors.

      * Convert file format to screen format

     C                   RESET                   ReturnCode
     C                   CALLB     'SDALNACVT'
      * Ensure correct parameters for this CVT function
      *
      * Output Parameters
      *
      * Return Code
     C                   PARM      *BLANKS       RetCodeIn
      *
      * Alternative Name & Address Details File Format
     C                   PARM                    AlnaFilFmt
      *

      * Output Parameters

      * Alternative Name & Address Details Screen Format
     C                   PARM                    CurTrAlna

      *
      * Insert correct parameters for this CVT function

     C                   RESET                   ReturnCode

     C                   CALLB     'SDALNAAMD'
      *
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * New Deal in Screen Format (Incoming Transaction)
     C                   PARM                    TranInAlna
      * (Current) Deal in Screen Format
     C                   PARM                    CurTrAlna
      * (Current) Deal in file format
     C                   PARM                    AlnaFilfmt

      * OUTPUTS
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKTralna
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      * Amendments OK
     C                   PARM                    AmendOk
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'N'           ResetErrs


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

     C                   CLEAR                   CurTrAlna
     C                   MOVE      *ALL'Y'       OKTrAlna
     C                   CLEAR                   ValidAlna

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
     C                   MOVEL     DDCUST        V_NACUST
     C                   MOVEL     DDADCD        V_NAADCD
     C                   MOVEL     DDCNA1        V_NACNA1
     C                   MOVEL     DDCNA2        V_NACNA2
     C                   MOVEL     DDCNA3        V_NACNA3
     C                   MOVEL     DDCNA4        V_NACNA4
     C                   MOVEL     DDCRTN        V_NACRTN
     C                   MOVEL     DDCTNB        V_NACTNB
     C                   MOVEL     DDTXNB        V_NATXNB
     C                   MOVEL     DDCNCD        V_NACNCD
     C                   MOVEL     BJRDNB        V_NALCD
     C                   MOVEL     DDACTN        V_NATYLC
      * Include header fields that need to be o/p to the valid file
     C                   EVAL      V_NAFRNT = APFOTranID
     C                   IF        DDACTN <> 'I'
     C                   MOVEL     @TimeStamp    V_NATMST
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
     C                   CALLB     'SDALNAUPD'

      * Ensure correct parameters for this UPD function
     C                   PARM                    @RTCD
     C                   PARM                    ValidAlna
      *
      * If there were any errors in the update functions, rollback any
      * updates (done in *PSSR) and end this program. Otherwise commit.
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc
     C                   EXSR      *PSSR
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
      * subroutine, including a bound call to the DBERRCTL module
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2006
