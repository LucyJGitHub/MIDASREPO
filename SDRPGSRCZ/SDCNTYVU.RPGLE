     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Country details validate and update')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCNTYVU - Country Details validate and update               *
      *                                                               *
      *  Function: This program validates country detail for          *
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
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BG12120            Date 20Oct06               *
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG12120 - Recompile over changes done in validation programs *
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
     D TranInCnty    E DS                  EXTNAME(SDCntyPD)
     D TranInCnt2    E DS                  EXTNAME(SDCnt2PD)
     D                                     PREFIX(S2_)
     D TranInCnt3    E DS                  EXTNAME(SDCnt3PD)
     D                                     PREFIX(S3_)
 
      * Valid file layout
     D ValidCnty     E DS                  EXTNAME(SDVcntyPD)
     D                                     PREFIX(V_)
     D ValidCnt2     E DS                  EXTNAME(SDVctx2PD)
     D                                     PREFIX(V2_)
     D ValidCnt3     E DS                  EXTNAME(SDVctx1PD)
     D                                     PREFIX(V3_)
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)
      * Separate out settlement instructions
 
      * Current transaction record in file format
     D CntyFilFmt    E DS                  EXTNAME(SDCtryPD)
     D Cnt2FilFmt    E DS                  EXTNAME(SDCtx2PD)
     D Cnt3FilFmt    E DS                  EXTNAME(SDCtx1PD)
      *
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)
      * Separate out settlement instructions
 
      * Current transaction in screen format
     D CurTrCnty     E DS                  EXTNAME(SDcntyPD)
     D                                     PREFIX(@)
     D CurTrCnt2     E DS                  EXTNAME(SDcnt2PD)
     D                                     PREFIX(@S2)
     D CurTrCnt3     E DS                  EXTNAME(SDcnt3PD)
     D                                     PREFIX(@S3)
 
      * Extra data in file format
     D ExtData       E DS                  EXTNAME(SDCtEXPD)
 
      * Error indicators
     D OKTrcnty      E DS                  EXTNAME(SDEcntyPD)
     D OKTrcnt2      E DS                  EXTNAME(SDEcnt2PD)
     D OKTrcnt3      E DS                  EXTNAME(SDEcnt3PD)
 
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
     C                   MOVEL     Trans5001     TranInCnty
     C                   MOVEL     BCLData       TranInCnt3
     C                   MOVEL     EurRepData    TranInCnt2
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
     C                   IF        ULX004 = 'Y'
     C                   EXSR      ValidateTr2
     C                   ENDIF
 
     C                   IF        ULX043 = 'Y'
     C                   EXSR      ValidateTr3
     C                   ENDIF
      * Processing for amends or changes
     C                   WHEN      DDACTN = 'A'
     C                   EXSR      SetupAmd
     C                   EXSR      ValdateAmd
     C                   EXSR      ValidateTr
     C                   IF        ULX004 = 'Y'
     C                   EXSR      ValidateTr2
     C                   ENDIF
 
     C                   IF        ULX043 = 'Y'
     C                   EXSR      ValidateTr3
     C                   ENDIF
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
     C                   IF        UpdateYN='Y' and Idx=0 and DDACTN <> 'D'
     C                   MOVE      DDCNCD        DDCNCD_In
     C                   CALL      'SDCNTYR'
     C                   PARM                    @AuthComp         1
     C                   PARM                    @FwdBck           1
     C                   PARM                    DDCNCD_In         2
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC           1
     C                   MOVEL     DDACTN        Buffer
     C                   ELSE
      * Remerge buffer with all relevant data structures
     C                   EVAL                   Buffer = TranInCnty + TranInCnt3
     C                                                 + TranInCnt2 + @TimeStamp
     C                                                 + Extdata
 
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
     C                   PARM                    BCLData         500
     C                   PARM                    EurRepData      500
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
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,SDCntyM01
     C/COPY WNCPYSRC,SDCnt2M01
     C/COPY WNCPYSRC,SDCnt3M01
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
      * Access SAR details file to determine if CFT004 switchable feature
      * is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFT004'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CFT004            1
     C                   ELSE
     C                   MOVEL     'N'           CFT004
     C                   EndIf
      * Access SAR details file to determine if CGL014 switchable feature
      * is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGL014'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CGL014            1
     C                   ELSE
     C                   MOVEL     'N'           CGL014
     C                   EndIf
      * Access SAR details file to determine if ULX004 switchable feature
      * is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'ULX004'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           ULX004            1
     C                   ELSE
     C                   MOVEL     'N'           ULX004
     C                   EndIf
 
      * Access SAR details file to determine if ULX043 switchable feature
      * is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'ULX043'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           ULX043            1
     C                   ELSE
     C                   MOVEL     'N'           ULX043
     C                   EndIf
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDCnty01
      /COPY WNCPYSRC,SDCnt201
      /COPY WNCPYSRC,SDCnt301
 
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
     C                   CALLB     'SDCNTYRTV'
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
      * (Midas) Transaction Number
     C                   PARM                    DDCNCD            2
      *
      * Outputs
      *
      * (Current) Transaction in file format
     C                   PARM                    CntyFilFmt
      * (Current) Lux BCL Country in file format
     C                   PARM                    Cnt3FilFmt
      * (Current) Lux European Country in file format
     C                   PARM                    Cnt2FilFmt
      * Extdata
     C                   PARM                    Extdata
      *
      * OK - Action code
     C                   PARM                    DDActnOK          1
      *
      * OK - Country Code
     C                   PARM                    DDCNCDOK          1
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
      *    ##########  take straight from CTL ##############
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
 
     C                   MOVE      CntyFilFmt    ValidCnty
     C                   MOVE      Cnt2FilFmt    ValidCnt2
     C                   MOVE      Cnt3FilFmt    ValidCnt3
 
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
 
     C                   CALLB     'SDCNTYVAL'
 
      * Inputs
 
      * Response mode
     C                   PARM      'S'           RespMode          1
 
      ** Country Details
     C                   PARM                    TranInCnty
 
 
      * Extra Data
     C                   PARM                    ExtData
      ***********************************
      * Ensure validation module is ready to accept infdata and extdata
      ***********************************
 
      * Outputs
      *
      ** Country Details OK inds
     C                   PARM                    OKTrcnty
 
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
 
      * Valid country (DS) from/to caller
     C                   PARM                    ValidCnty
 
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
      ******************************************************************
      *                                                                *
      * ValidateTr2 - Routine to validate the main transaction         *
      *               details 2                                        *
      *                                                                *
      ******************************************************************
     C     ValidateTr2   BEGSR
 
      * Validate transaction details2
     C                   RESET                   ReturnCode
 
     C                   CALLB     'SDCNTYVL2'
 
      * Inputs
 
      * Response mode
     C                   PARM      'S'           RespMode          1
 
      ** Country Details (Lux European)
     C                   PARM                    TranInCnt2
      * Extra Data
     C                   PARM                    ExtData
      ***********************************
      * Ensure validation module is ready to accept infdata and extdata
      ***********************************
 
      * Outputs
      *
      ** Country Details(Lux European) OK inds
     C                   PARM                    OKTrcnt2
 
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
 
      * Valid country (Lux European) (DS) from/to caller
     C                   PARM                    ValidCnt2
 
      * Insert correct parameters for this VAL function
      *
      *  If error in validation, fail this input
     C     Idx           IFNE      0
     C                   GOTO      EValidTr2
     C                   EndIf
      * ### Check whether any post validation processing is done in
      *     SIN module
      * ### and if so insert here. Data structures may be needed.
 
     C     EValidTr2     ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr3 - Routine to validate the main transaction         *
      *               details 3                                        *
      *                                                                *
      ******************************************************************
     C     ValidateTr3   BEGSR
 
      * Validate transaction details3
     C                   RESET                   ReturnCode
 
     C                   CALLB     'SDCNTYVL3'
 
      * Inputs
 
      * Response mode
     C                   PARM      'S'           RespMode          1
 
      ** Country Details(Lux BCL)
     C                   PARM                    TranInCnt3
      * Extra Data
     C                   PARM                    ExtData
      ***********************************
      * Ensure validation module is ready to accept infdata and extdata
      ***********************************
 
      * Outputs
      *
      ** Country Details(Lux BCL) OK inds
     C                   PARM                    OKTrcnt3
 
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
 
      * Valid country (Lux BCL) (DS) from/to caller
     C                   PARM                    ValidCnt3
      * Insert correct parameters for this VAL function
      *
      *  If error in validation, fail this input
     C     Idx           IFNE      0
     C                   GOTO      EValidTr3
     C                   EndIf
      * ### Check whether any post validation processing is done in
      * SIN module
      * ### and if so insert here. Data structures may be needed.
 
     C     EValidTr3     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateSt - Routine to validate the settlement instructions  *
      *   ######     include if neccessary - take from CTL     #####
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
     C                   CALLB     'SDCNTYCVT'
      * Ensure correct parameters for this CVT function
      *
      * Output Parameters
      *
      * Return Code
     C                   PARM      *BLANKS       RetCodeIn
      *
      * Country Details File Format
     C                   PARM                    CntyFilFmt
      * Lux BCL Country Details File Format
     C                   PARM                    Cnt3FilFmt
      * Lux Eur Country Details File Format
     C                   PARM                    Cnt2FilFmt
      *
 
      * Output Parameters
 
      * Country Details Screen Format
     C                   PARM                    CurTrCnty
      * Lux BCL Country Details Screen Format
     C                   PARM                    CurTrCnt3
      * Lux Eur Country Details Screen Format
     C                   PARM                    CurTrCnt2
 
      *
      * Insert correct parameters for this CVT function
 
     C                   RESET                   ReturnCode
 
     C                   CALLB     'SDCNTYAMD'
      *
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * New Deal in Screen Format (Incoming Transaction)
     C                   PARM                    TranInCnty
      * (Current) Deal in Screen Format
     C                   PARM                    CurTrCnty
      * (Current) Deal in file format
     C                   PARM                    CntyFilfmt
 
      * OUTPUTS
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKTrcnty
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
 
     C                   CLEAR                   CurTrCnty
     C                   CLEAR                   CurTrCnt2
     C                   CLEAR                   CurTrCnt3
     C                   MOVE      *ALL'Y'       OKTrCnty
     C                   MOVE      *ALL'Y'       OKTrCnt2
     C                   MOVE      *ALL'Y'       OKTrCnt3
     C                   CLEAR                   ValidCnty
     C                   CLEAR                   ValidCnt2
     C                   CLEAR                   ValidCnt3
 
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
     C                   EVAL      V_COTYLC = DDACTN
      * Include header fields that need to be o/p to the valid file
     C                   EVAL      V_COFRNT = APFOTranID
     C                   IF        DDACTN <> 'I'
     C                   MOVEL     @TimeStamp    V_COTMST
     C                   ENDIF
     C                   EVAL      V_COCNCD = DDCNCD
     C                   EVAL      V_CORGCD = DDRGCD
     C                   EVAL      V_COCNNM = DDCNNM
     C                   EVAL      V_COISOC = DDISOC
     C                   MOVEL     DDBBAN        V_COBBAN
     C                   MOVEL     DDBBRL        V_COBBRL
     C                   EVAL      V_COCTAY = DDCTAY
     C                   EVAL      V_COCTZP = DDCTZP
     C                   MOVEL     DDCTWC        V_COCTWC
     C                   MOVEL     DDETXY        V_COETXY
     C                   EVAL      V_CORPFQ=DDRPFQ
     C                   EVAL      V_COTXCY=DDTXCY
     C                   EVAL      V_COJAMG=DDJAMG
     C                   EVAL      V_COCTTX=DDCTTX
 
     C                   EVAL      V2_C2CTRY=S2_DDCNCD
     C                   EVAL      V2_C2ICTR=S2_DDICTR
     C                   EVAL      V2_C2EMUM=S2_DDEMUM
     C                   EVAL      V2_C2ISOC=V_COISOC
 
     C                   EVAL      V3_CXCTRY=S3_DDCNCD
     C                   EVAL      V3_CXEMUZ=S3_DDEMUZ
 
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
     C                   CALLB     'SDCNTYUPD'
 
      * Ensure correct parameters for this UPD function
     C                   PARM      *Blanks       @RTCD
     C                   PARM                    ValidCnty
     C                   PARM                    ValidCnt2
     C                   PARM                    ValidCnt3
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
      * subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2006
