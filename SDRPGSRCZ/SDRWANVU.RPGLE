     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Customer Risk Weighted Assets Details val & upd')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDRWANVU - Customer Risk Weighted Assets Details API         *
      *             validate and update                               *
      *                                                               *
      *  Function: This program validates Customer Risk Weighted      *
      *            Assets Details API details for                     *
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
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD079 - Enhanced Customer Maintenance API                   *
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
 
      ** Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      ** Incoming transaction in screen format
     D TranInRwan    E DS                  EXTNAME(SDRwanPD)
 
      ** Valid file layout
     D ValidRwan     E DS                  EXTNAME(SDVrwanPD)
     D                                     PREFIX(V_)
      ** Large fields to include
      ** - Receive instructions (xxRSTM to xxROCN)
      ** - Pay     instructions (xxPSTM to xxBTB6)
      ** Separate out settlement instructions
 
      ** Current transaction record in file format
     D RwanFilFmt    E DS                  EXTNAME(SDVrwanPD)
      ** Large fields to include
      ** - Receive instructions (xxRSTM to xxROCN)
      ** - Pay     instructions (xxPSTM to xxBTB6)
      ** Separate out settlement instructions
 
      ** Current transaction in screen format
     D CurTrRwan     E DS                  EXTNAME(SDrwanPD)
     D                                     PREFIX(@)
 
      ** Error indicators
     D OKTrrwan      E DS                  EXTNAME(SDErwanPD)
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
 
      ** First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)
 
      ** Index for arrays of error message ids etc in amend validation
     D AmIdx           S              3P 0 INZ(0)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0 INZ(0)
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(0)
 
      ** Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
 
      ** Indices for arrays used to set up corresponding
      ** sequence numbers for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** From Customer Flag
     D From_cust       S              1
 
      ** Entry parameters
     D UpdateYN        S              1A
     D Buffer          S           6000A
     D APIRetC         S              1A
     D PTimeStamp      S             26A
 
     D ModeofOp        S              6A
 
     D RespMode        S              1A
     D PAuthcomp       S              1A
     D PFwdbck         S              1A
     D DDCUST_IN       S              6A
 
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
 
      ** Incoming transaction is broken into 500A fields, so that a
      ** common CL can be used between this module and the one that
      ** reads the MQ queue.  This module needs to break these 500A
      ** fields by loading them into the appropriate (externally
      ** described) data structure.
 
     C                   MOVEL     Trans5001     TranInRwan
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      ** Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
 
      ** Validate action code
 
     C                   EXSR      ValidateAc
 
      ** If error in validation of action code, fail this input
 
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Processing depends upon action code
 
     C                   SELECT
 
      ** Processing for inserts
 
     C                   WHEN      DDACTN = 'I'
     C                   EXSR      ValidateTr
 
      ** Processing for amends or changes
 
     C                   WHEN      DDACTN = 'A'
     C                   EXSR      ValidateTr
     C                   ENDSL
      *
     C     INVALID       TAG
 
      ** Write to database
 
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
     C                   MOVE      DDCUST        DDCUST_In
     C                   CALL      'SDRWANR'
     C                   PARM                    PAuthComp
     C                   PARM                    PFwdBck
     C                   PARM                    DDCUST_In
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
     C                   MOVEL     DDACTN        Buffer
     C                   ELSE
 
      ** Remerge buffer with all relevant data structures
 
     C                   EVAL           Buffer = TranInRwan + PTimeStamp
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
 
      ** Common header information (DS) from source system
 
     C                   PARM                    HeadIn
 
      ** Transaction information
 
     C                   PARM                    Trans5001
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
     C                   PARM                    PTimeStamp
 
      ** Set up the name of the primary and secondary message files
      ** from which the message handler will get the messages
 
     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      ** Hook to enable non-core message files to be included
 
      /COPY WNCPYSRC,SDRwanM01
 
      ** Access bank details via access program
      ** (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Access API ICD via access program
 
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
 
      ** Hook to enable non-core initial processing to be included
 
      /COPY WNCPYSRC,SDRwan01
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateAc - Routine to validate action code versus          *
      *              Customer Number supplied                         *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
 
      ** Validate action code versus Customer Number supplied
      ** The Customer Risk Weighted Assets in file format from the SD
      ** database is retrieved as well
 
     C                   RESET                   ReturnCode
     C                   CALLB     'SDRWANRTV'
 
      ** Ensure correct parameters for this RTV function
      ** INPUTS
      ** Return code
 
     C                   PARM      *BLANK        ReturnCode
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
 
     C                   PARM                    ModeofOp
 
      ** Response mode
 
     C                   PARM      'S'           APRESPMODE
 
      ** Action Code
 
     C                   PARM                    DDACTN
 
      ** Front Office Transaction ID
      ** (Midas) Transaction Number
 
     C                   PARM                    DDCUST
 
      ** From Customer Flag
 
     C                   PARM      'N'           From_Cust
 
      ** Outputs
      ** (Current) Customer Risk Weighted Assets in file format
 
     C                   PARM                    RwanFilFmt
 
      ** OK - Action code
 
     C                   PARM                    DDActnOK
 
      ** OK - Customer Number
 
     C                   PARM                    DDCUSTOK
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Idx
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateTr - Routine to validate the Customer Risk weighted  *
      *              Assets details                                   *
      *                                                               *
      *****************************************************************
     C     ValidateTr    BEGSR
 
      ** Validate Customer Risk weighted Assets details
 
     C                   RESET                   ReturnCode
 
     C                   CALLB     'SDRWANVAL'
 
      ** Inputs
      ** Response mode
 
     C                   PARM      'S'           RespMode
 
      ** Customer Risk Weighted Assets Details
 
     C                   PARM                    TranInRwan
 
      ** Ensure validation module is ready to accept infdata and
      ** extdata
      ** OUTPUTS
      ** Customer Risk Weighted Assets Details OK inds
 
     C                   PARM                    OKTrrwan
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WIdx
 
      ** Valid Customer Risk Weighted Assets (DS) from/to caller
 
     C                   PARM                    ValidRwan
 
      ** Insert correct parameters for this VAL function
      ** - If error in validation, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   EndIf
 
     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RESETCYCLE- Reset error information that is gradually        *
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
 
     C                   CLEAR                   CurTrRwan
     C                   MOVE      *ALL'Y'       OKTrRwan
     C                   CLEAR                   ValidRwan
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Reset error information that is gradually updated*
      *              during each run of this program                  *
      *                                                               *
      *****************************************************************
 
     C     SETUPVALID    BEGSR
 
      ** Set file field(s) that are needed for all action codes
 
     C                   MOVEL     *BLANK        V_RARECI
     C                   MOVEL     DDCUST        V_RACUST
     C                   MOVEL     DDCOD1        V_RACOD1
     C                   MOVEL     DDSET1        V_RASET1
     C                   MOVEL     DDCOD2        V_RACOD2
     C                   MOVEL     DDSET2        V_RASET2
     C                   MOVEL     DDCOD3        V_RACOD3
     C                   MOVEL     DDSET3        V_RASET3
     C                   MOVEL     DDCOD4        V_RACOD4
     C                   MOVEL     DDSET4        V_RASET4
     C                   MOVEL     DDCOD5        V_RACOD5
     C                   MOVEL     DDSET5        V_RASET5
     C                   MOVEL     DDCOD6        V_RACOD6
     C                   MOVEL     DDSET6        V_RASET6
     C                   MOVEL     DDCOD7        V_RACOD7
     C                   MOVEL     DDSET7        V_RASET7
     C                   MOVEL     DDCOD8        V_RACOD8
     C                   MOVEL     DDSET8        V_RASET8
     C                   MOVEL     DDCOD9        V_RACOD9
     C                   MOVEL     DDSET9        V_RASET9
     C                   MOVEL     DDCOD10       V_RACOD10
     C                   MOVEL     DDSET10       V_RASET10
     C                   MOVEL     DDCOD11       V_RACOD11
     C                   MOVEL     DDSET11       V_RASET11
     C                   MOVEL     DDCOD12       V_RACOD12
     C                   MOVEL     DDSET12       V_RASET12
     C                   MOVEL     DDCOD13       V_RACOD13
     C                   MOVEL     DDSET13       V_RASET13
     C                   MOVEL     DDCOD14       V_RACOD14
     C                   MOVEL     DDSET14       V_RASET14
     C                   MOVEL     DDCOD15       V_RACOD15
     C                   MOVEL     DDSET15       V_RASET15
     C                   MOVEL     DDCOD16       V_RACOD16
     C                   MOVEL     DDSET16       V_RASET16
     C                   MOVEL     DDCOD17       V_RACOD17
     C                   MOVEL     DDSET17       V_RASET17
     C                   MOVEL     DDCOD18       V_RACOD18
     C                   MOVEL     DDSET18       V_RASET18
     C                   MOVEL     DDCOD19       V_RACOD19
     C                   MOVEL     DDSET19       V_RASET19
     C                   MOVEL     DDCOD20       V_RACOD20
     C                   MOVEL     DDSET20       V_RASET20
     C                   MOVEL     DDCOD21       V_RACOD21
     C                   MOVEL     DDSET21       V_RASET21
     C                   MOVEL     DDCOD22       V_RACOD22
     C                   MOVEL     DDSET22       V_RASET22
     C                   MOVEL     DDCOD23       V_RACOD23
     C                   MOVEL     DDSET23       V_RASET23
     C                   MOVEL     DDCOD24       V_RACOD24
     C                   MOVEL     DDSET24       V_RASET24
     C                   MOVEL     DDCOD25       V_RACOD25
     C                   MOVEL     DDSET25       V_RASET25
     C                   MOVEL     DDCOD26       V_RACOD26
     C                   MOVEL     DDSET26       V_RASET26
     C                   MOVEL     DDCOD27       V_RACOD27
     C                   MOVEL     DDSET27       V_RASET27
     C                   MOVEL     DDCOD28       V_RACOD28
     C                   MOVEL     DDSET28       V_RASET28
     C                   MOVEL     DDCOD29       V_RACOD29
     C                   MOVEL     DDSET29       V_RASET29
     C                   MOVEL     DDCOD30       V_RACOD30
     C                   MOVEL     DDSET30       V_RASET30
     C                   MOVEL     DDCOD31       V_RACOD31
     C                   MOVEL     DDSET31       V_RASET31
     C                   MOVEL     DDCOD32       V_RACOD32
     C                   MOVEL     DDSET32       V_RASET32
     C                   MOVEL     DDCOD33       V_RACOD33
     C                   MOVEL     DDSET33       V_RASET33
     C                   MOVEL     DDCOD34       V_RACOD34
     C                   MOVEL     DDSET34       V_RASET34
     C                   MOVEL     DDCOD35       V_RACOD35
     C                   MOVEL     DDSET35       V_RASET35
     C                   MOVEL     DDCOD36       V_RACOD36
     C                   MOVEL     DDSET36       V_RASET36
     C                   MOVEL     DDACTN        V_RACHTP
     C                   MOVEL     BJRDNB        V_RALCD
     C                   IF        DDACTN <> 'I'
     C                   MOVEL     PTimeStamp    V_RATMST
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPDATEDB - Update database                                   *
      *                                                               *
      *****************************************************************
 
     C     UPDATEDB      BEGSR
 
      ** Update
 
     C                   RESET                   ReturnCode
      *
     C                   CALLB     'SDRWANUPD'
 
      ** Ensure correct parameters for this UPD function
 
     C                   PARM                    @RTCD
     C                   PARM                    ValidRwan
     C                   PARM      'N'           From_Cust
 
      ** If there were any errors in the update functions, rollback any
      ** updates (done in *PSSR) and end this program. Otherwise commit.
 
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc
     C                   EXSR      *PSSR
     C                   EndIf
 
      ** If update not done due to record being updated by another
      ** workstation send message to screen.
 
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
(c) Finastra International Limited 2007
