     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('User Def + Menu Items details valid And Upd-RPG')
      *****************************************************************
      *                                                               *
      *  Midas - Security Profile Function ILE Module                 *
      *                                                               *
      *  SFAMUSVU - User Definition + Menu Items Details              *
      *             validate and update                               *
      *                                                               *
      *  Function: This program validates User Definition + Menu      *
      *            Items details for input into the Midas database.   *
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
      *  Prev Amend No. CRE026B            Date 28Dec06               *
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026B - User Security Profile                              *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      *
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
      * External DS for incoming data from General Ledger ICD File
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      * Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming transaction in screen format
      * Screen File Layout for User Defn + Menu Items
     D TranInAMUS    E DS                  EXTNAME(SFAMUSPD)
      *
     D AMUSTranIn      DS
     D TransIn1                1    500
      * Screen File Layout for Booking Branches
     D TranInBBRC    E DS                  EXTNAME(SFBBRCPD)
     D                                     PREFIX(BB_)
      *
     D BBRCTranIn      DS
     D TransIn2                1    500
     D TransIn3              501   1000
     D TransIn4             1001   1500
     D TransIn5             1501   2000
     D TransIn6             2001   2500
     D TransIn7             2501   3000
     D TransIn8             3001   3500
     D TransIn9             3501   4000
      * Screen File Layout for Originating Branches
     D TranInOBRC    E DS                  EXTNAME(SFOBRCPD)
     D                                     PREFIX(OB_)
      *
     D OBRCTranIn      DS
     D  TransIn10              1    500
     D  TransIn11            501   1000
     D  TransIn12           1001   1500
     D  TransIn13           1501   2000
     D  TransIn14           2001   2500
     D  TransIn15           2501   3000
     D  TransIn16           3001   3500
     D  TransIn17           3501   4000
      * Screen File Layout for Companies
     D TranInCOMP    E DS                  EXTNAME(SFCOMPPD)
     D                                     PREFIX(CO_)
      *
     D COMPTranIn      DS
     D  TransIn18              1    500
      *
 
      * Valid file layout
     D ValidAMUS     E DS                  EXTNAME(SFVAMUSPD)
     D                                     PREFIX(V_)
      * Valid File Layout for User Defn + Menu Items
     D ValidBBRC     E DS                  EXTNAME(SFVBBRCPD)
     D                                     PREFIX(V_)
      * Valid File Layout for Booking Branches
     D ValidOBRC     E DS                  EXTNAME(SFVOBRCPD)
     D                                     PREFIX(V_)
      * Valid File Layout for Originating Branches
     D ValidCOMP     E DS                  EXTNAME(SFVCOMPPD)
     D                                     PREFIX(V_)
      * Valid File Layout for Companies
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)
      * Separate out settlement instructions
 
      * Current transaction record in file format
      * Current User Defn + Menu Items in File Format
     D AMUSFilFmt    E DS                  EXTNAME(MUSERDD)
      * Current Booking Branches in File Format
     D BBRCFilFmt    E DS                  EXTNAME(MBRBSDD)
     D                                     PREFIX(B_)
      * Current Originating Branches in File Format
     D OBRCFilFmt    E DS                  EXTNAME(MBROSDD)
     D                                     PREFIX(O_)
      * Current Companies in File Format
     D COMPFilFmt    E DS                  EXTNAME(MCMPSDD)
     D                                     PREFIX(C_)
      *
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)
      * Separate out settlement instructions
 
      * Current transaction in screen format
      * Current User Defn + Menu Items in Screen Format
     D CurTrAMUS     E DS                  EXTNAME(SFAMUSPD)
     D                                     PREFIX(@)
      * Current Booking Branches in Screen Format
     D CurTrBBRC     E DS                  EXTNAME(SFBBRCPD)
     D                                     PREFIX(B_)
      * Current Originating Branches in File Format
     D CurTrOBRC     E DS                  EXTNAME(SFOBRCPD)
     D                                     PREFIX(O_)
      * Current Companies in File Format
     D CurTrCOMP     E DS                  EXTNAME(SFCOMPPD)
     D                                     PREFIX(C_)
      *
 
 
      * Extra data in file format
     D ExtData       E DS                  EXTNAME(SFUsEXPD)
 
      * Error indicators
     D OKTrAMUS      E DS                  EXTNAME(SFEAMUSPD)
      * Error Definition File Layout for User Defn + Menu Items
     D OKTrBBRC      E DS                  EXTNAME(SFEBBRCPD)
      * Error Definition File Layout for Booking Branches
     D OKTrOBRC      E DS                  EXTNAME(SFEOBRCPD)
     D                                     PREFIX(O_)
      * Error Definition File Layout for Originating Branches
     D OKTrCOMP      E DS                  EXTNAME(SFECOMPPD)
     D                                     PREFIX(C_)
      * Error Definition File Layout for Companies
 
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
      * Fields to receive the incoming Transaction
     D Trans5002       S            500A
      *
     D Trans5003       S            500A
      *
     D Trans5004       S            500A
      *
     D Trans5005       S            500A
      *
     D Trans5006       S            500A
      *
     D Trans5007       S            500A
      *
     D Trans5008       S            500A
      *
     D Trans5009       S            500A
      *
     D Trans5010       S            500A
      *
     D Trans5011       S            500A
      *
     D Trans5012       S            500A
      *
     D Trans5013       S            500A
      *
     D Trans5014       S            500A
      *
     D Trans5015       S            500A
      *
     D Trans5016       S            500A
      *
     D Trans5017       S            500A
      *
     D Trans5018       S            500A
      *
     D BufferX         S          10000A
      *
 
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
     C                   MOVEL     Trans5001     TransIn1
     C                   MOVEL     Trans5002     TransIn2
     C                   MOVEL     Trans5003     TransIn3
     C                   MOVEL     Trans5004     TransIn4
     C                   MOVEL     Trans5005     TransIn5
     C                   MOVEL     Trans5006     TransIn6
     C                   MOVEL     Trans5007     TransIn7
     C                   MOVEL     Trans5008     TransIn8
     C                   MOVEL     Trans5009     TransIn9
     C                   MOVEL     Trans5010     TransIn10
     C                   MOVEL     Trans5011     TransIn11
     C                   MOVEL     Trans5012     TransIn12
     C                   MOVEL     Trans5013     TransIn13
     C                   MOVEL     Trans5014     TransIn14
     C                   MOVEL     Trans5015     TransIn15
     C                   MOVEL     Trans5016     TransIn16
     C                   MOVEL     Trans5017     TransIn17
     C                   MOVEL     Trans5018     TransIn18
     C                   MOVEL     AMUSTranIn    TranInAMUS
     C                   MOVEL     BBRCTranIn    TranInBBRC
     C                   MOVEL     OBRCTranIn    TranInOBRC
     C                   MOVEL     COMPTranIn    TranInCOMP
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
     C                             Idx = 0  AND DDACTN <> 'D'
     C                   MOVE      DDUSRP        DDUSRP_In
     C                   CALL      'SFAMUSR'
     C                   PARM                    @AuthComp         1
     C                   PARM                    @FwdBck           1
     C                   PARM                    DDUSRP_In        10
     C                   PARM                    Buffer
     C                   PARM                    Buffer2
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC           1
     C                   MOVEL     DDACTN        Buffer
     C                   ELSE
      * Remerge buffer with all relevant data structures
      *
     C                   EVAL      BufferX = TranInAmus + TranInBBRC
     C                                      + TranInOBRC + TranInCOMP
     C                                      + @TimeStamp + EXTDATA
      *
     C                   EVAL           Buffer = %SUBST(BufferX:1:6000)
     C                   EVAL           Buffer2 = %SUBST(BufferX:6001:3999)
     C                   ENDIF
      *                                                                                      CRE026B
      ** If no error,Update Equation Unit Access Security File - KAPSEC                      CRE026B
      *                                                                                      CRE026B
     C                   IF        Idx = 0 AND UpdateYN = 'Y'                                CRE026B
      *                                                                                      CRE026B
     C                   CALLB     'SFAMUSUPD2'                                              CRE026B
     C                   PARM                    DDACTN                                      CRE026B
     C                   PARM                    DDUSRP                                      CRE026B
     C                   PARM                    FldNameArr                                  CRE026B
     C                   PARM                    MsgIDArr                                    CRE026B
     C                   PARM                    MsgDtaArr                                   CRE026B
     C                   PARM                    WFldNamArr                                  CRE026B
     C                   PARM                    WMsgIDArr                                   CRE026B
     C                   PARM                    WMsgDtaArr                                  CRE026B
     C                   PARM                    MsgFArray                                   CRE026B
      *                                                                                      CRE026B
     C                   ENDIF                                                               CRE026B
      *                                                                                      CRE026B
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
     C                   PARM                    Trans5003
     C                   PARM                    Trans5004
     C                   PARM                    Trans5005
     C                   PARM                    Trans5006
     C                   PARM                    Trans5007
     C                   PARM                    Trans5008
     C                   PARM                    Trans5009
     C                   PARM                    Trans5010
     C                   PARM                    Trans5011
     C                   PARM                    Trans5012
     C                   PARM                    Trans5013
     C                   PARM                    Trans5014
     C                   PARM                    Trans5015
     C                   PARM                    Trans5016
     C                   PARM                    Trans5017
     C                   PARM                    Trans5018
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
     C                   PARM                    Buffer2        3999
     C                   PARM                    APIRetc           1
     C                   PARM                    @TimeStamp       26
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'SFUSRMSG'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,SFAmusM01
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
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SFAmus01
 
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
     C                   CALLB     'SFAMUSRTV'
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
      * (Midas) User Profile
     C                   PARM                    DDUSRP           10
      *
      * User Security Level
     C                   PARM                    DDSECL            4
      * Outputs
      *
      * (Current) User Definition + Menu Items in file format
     C                   PARM                    AMUSFilFmt
      * (Current) Booking Branch in file format
     C                   PARM                    BBRCFilFmt
      * (Current) Originating Branch in file format
     C                   PARM                    OBRCFilFmt
      * (Current) Companies in file format
     C                   PARM                    COMPFilFmt
      *
      * OK - Action code
     C                   PARM                    DDActnOK          1
      *
      * OK - User Profile
     C                   PARM                    DDUSRPOK          1
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
 
     C                   MOVE      AMUSFilFmt    ValidAMUS
     C                   MOVE      BBRCFilFmt    ValidBBRC
     C                   MOVE      OBRCFilFmt    ValidOBRC
     C                   MOVE      COMPFilFmt    ValidCOMP
 
      *
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateTr - Routine to validate the main tranaction details  *
      *                                                               *
      *****************************************************************
 
     C     ValidateTr    BEGSR
      *
      * Validate User Definition + Menu Items Details
      *
     C                   EXSR      ValidUDMI
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   ENDIF
      *
      * Validate Booking Branches only if Booking Branch Indicator is 'Y'
      *
     C                   IF        DDBRBS = 'Y'
     C                   EXSR      ValidBRBS
     C                   ENDIF
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   ENDIF
      *
      *
      ** Validate Originating Branches only if Orig. Branch Indicator is 'Y'
      *
     C                   IF        DDBROS = 'Y'
     C                   CALL      'AOGELRR1'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDGELR        PARM      SDGELR        DSSDY
      *
      * If Orig. Branch User Validation Required Indicator is 'Y'
     C                   IF        BKOBUV = 'Y'
      *
      *
     C                   EXSR      ValidBROS
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   ENDIF
      *
      *  Validate Companies only if Companies indicator is 'Y'
      *
     C                   IF        DDCMPS = 'Y'
     C                   EXSR      ValidCMPS
     C                   ENDIF
      *
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
     C                   CALLB     'SFAMUSCVT'
      * Ensure correct parameters for this CVT function
      *
      * Output Parameters
      *
      * Return Code
     C                   PARM      *BLANKS       RetCodeIn
      *
      * User Definition + Menu Items Details File Format
     C                   PARM                    AMUSFilFmt
      * Booking Branches Details File Format
     C                   PARM                    BBRCFilFmt
      * Originating Branches Details File Format
     C                   PARM                    OBRCFilFmt
      * Companies Details File Format
     C                   PARM                    COMPFilFmt
      *
      * Output Parameters
      *
      * User Definition + Menu Items Details Screen Format
     C                   PARM                    CurTrAMUS
      * Booking Branches Details Screen Format
     C                   PARM                    CurTrBBRC
      * Originating Branches Details Screen Format
     C                   PARM                    CurTrOBRC
      * Companies Details File Screen Format
     C                   PARM                    CurTrCOMP
      *
 
      *
      * Insert correct parameters for this CVT function
 
     C                   RESET                   ReturnCode
 
     C                   CALLB     'SFAMUSAMD'
      *
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * New Deal in Screen Format (Incoming Transaction)
      * (New) User Definitions + Menu Items in Screen Format
     C                   PARM                    TranInAMUS
      * (New) Booking Branches in Screen Format
     C                   PARM                    TranInBBRC
      * (New) Originating Branches in Screen Format
     C                   PARM                    TranInOBRC
      * (New) Companies in Screen Format
     C                   PARM                    TranInCOMP
      *
      * (Current) User Definitions + Menu Items in Screen Format
     C                   PARM                    CurTrAMUS
      * (Current) Booking Branches in Screen Format
     C                   PARM                    CurTrBBRC
      * (Current) Originating Branches in Screen Format
     C                   PARM                    CurTrOBRC
      * (Current) Companies in Screen Format
     C                   PARM                    CurTrCOMP
      *
      *
      * OUTPUTS
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKTrAMUS
     C                   PARM                    OKTrBBRC
     C                   PARM                    OKTrOBRC
     C                   PARM                    OKTrCOMP
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
 
     C                   CLEAR                   CurTrAMUS
     C                   CLEAR                   CurTrBBRC
     C                   CLEAR                   CurTrOBRC
     C                   CLEAR                   CurTrCOMP
      *
     C                   MOVE      *ALL'Y'       OKTrAMUS
     C                   MOVE      *ALL'Y'       OKTrBBRC
     C                   MOVE      *ALL'Y'       OKTrOBRC
     C                   MOVE      *ALL'Y'       OKTrCOMP
      *
     C                   CLEAR                   ValidAMUS
     C                   CLEAR                   ValidBBRC
     C                   CLEAR                   ValidOBRC
     C                   CLEAR                   ValidCOMP
 
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
      * set up valid fields for User Definitions + Menu Items
     C                   TIME                    TIMEP             6 0
      *
     C                   EVAL      V_USRECI  = 'D'
     C                   EVAL      V_USCHTP  = DDACTN
     C                   EVAL      V_USLCD   = BJRDNB
     C                   EVAL      V_USLCT   = TIMEP
     C                   EVAL      V_USUSRP  = DDUSRP
     C                   EVAL      V_USUSER1 = DDUSER1
     C                   MOVE      DDSECL        V_USSECL
     C                   EVAL      V_USMULT  = DDMULT
     C                   EVAL      V_USDPPT  = DDDPPT
     C                   EVAL      V_USACFA  = DDACFA
     C                   EVAL      V_USDBRN  = DDDBRN
     C                   EVAL      V_USPAUT  = DDPAUT
     C                   EVAL      V_USROUF  = DDROUF
     C                   EVAL      V_USAURF  = DDAURF
     C                   MOVE      DDREFP        V_USREFP
     C                   EVAL      V_USCOBAUT= DDCOBU
     C                   EVAL      V_USTLID  = DDTLID
     C                   EVAL      V_USROUT  = DDROUT
     C                   EVAL      V_USDIRID = DDDIRID
     C                   EVAL      V_USDIRAD = DDDIRAD
     C                   EVAL      V_USOUTQ  = DDOUTQ
     C                   EVAL      V_USCOUTQ = DDCOUTQ
     C                   EVAL      V_USMUREP = DDMUREP
     C                   EVAL      V_USALACOD= DDJEAA
     C                   EVAL      V_USMBREP = DDMBREP
     C                   EVAL      V_USREFUSR= DDREFU
     C                   EVAL      V_USUSRLVL= DDALVL
     C                   EVAL      V_USBANK  = DDBANK
     C                   EVAL      V_USBRBS  = DDBRBS
     C                   EVAL      V_USBROS  = DDBROS
     C                   EVAL      V_USCMPS  = DDCMPS
      * Setup valid fields for Booking Branches
     C                   EVAL      V_BBRECI  = 'D'
     C                   EVAL      V_BBUSRP  = DDUSRP
     C                   EVAL      V_BBNOBR  = %LEN(%TRIM(BB_DDSLCT))
     C                   EVAL      V_BBLCD   = BJRDNB
     C                   EVAL      V_BBCHTP  = DDACTN
     C                   EVAL      V_BBLCT   = TIMEP
     C                   EVAL      V_BBVBRX  = BB_DDVBRX
      * Setup valid fields for Originating Branches
     C                   EVAL      V_OBRECI  = 'D'
     C                   EVAL      V_OBUSRP  = DDUSRP
     C                   EVAL      V_OBNOBR  = %LEN(%TRIM(OB_DDSLCT))
     C                   EVAL      V_OBLCD   = BJRDNB
     C                   EVAL      V_OBCHTP  = DDACTN
     C                   EVAL      V_OBLCT   = TIMEP
     C                   EVAL      V_OBVBRX  = OB_DDVBRX
      * Setup valid fields for Companies
     C                   EVAL      V_CMRECI  = 'D'
     C                   EVAL      V_CMUSRP  = DDUSRP
     C                   EVAL      V_CMNOOC  = %LEN(%TRIM(CO_DDSLCT))
     C                   EVAL      V_CMLCD   = BJRDNB
     C                   EVAL      V_CMCHTP  = DDACTN
     C                   EVAL      V_CMLCT   = TIMEP
     C                   EVAL      V_CMVCMP  = CO_DDVCMP
      *
 
      * Include header fields that need to be o/p to the valid file
     C                   EVAL      V_USFRNT = APFOTranID
      *
     C                   IF        DDACTN <> 'I'
     C                   MOVEL     @TimeStamp    V_USTMST
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
     C                   CALLB     'SFAMUSUPD'
 
      * Ensure correct parameters for this UPD function
     C                   PARM                    @RTCD
     C                   PARM                    ValidAMUS
     C                   PARM                    ValidBBRC
     C                   PARM                    ValidOBRC
     C                   PARM                    ValidCOMP
 
      *
      * If there were any errors in the update functions, rollback any
      * updates (done in *PSSR) and end this program.
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
 
     C                   EVAL      MsgIdArr(1) = 'SFM0447'
 
     C                   EndIf
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      * ValidUDMI - Validate User Definition + Menu Item              *
      *                                                               *
      *****************************************************************
     C     ValidUDMI     BEGSR
      *
     C                   CALLB     'SFAMUS1VL'
      *
      * INPUTS
      *
      * Response mode
     C                   PARM      'S'           RespMode          1
      *
      ** User Definition + Menu Item Details
     C                   PARM                    TranInAMUS
      * User Definition + Menu Item Extra Data file data
     C                   PARM                    ExtData
      *
      * OUTPUTS
      *
      ** User Definition + Menu Item Details OK inds
     C                   PARM                    OKTrAmus
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
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      * Valid User Definition + Menu Item layout (DS) from/to caller
     C                   PARM                    ValidAmus
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidBRBS - Validate Booking Branches                         *
      *                                                               *
      *****************************************************************
     C     ValidBRBS     BEGSR
      *
     C                   CALLB     'SFAMUS2VL'
      *
      * INPUTS
      *
      * Response mode
     C                   PARM      'S'           RespMode          1
      *
      ** Booking Branches Details
     C                   PARM                    TranInBBRC
      *
      * OUTPUTS
      *
      ** Booking Branches Details OK inds
     C                   PARM                    OKTrBBRC
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
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      * Valid Booking Branches layout (DS) from/to caller
     C                   PARM                    ValidBBRC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidBROS - Validate Originating Branches                     *
      *                                                               *
      *****************************************************************
     C     ValidBROS     BEGSR
      *
     C                   CALLB     'SFAMUS3VL'
      *
      * INPUTS
      *
      * Response mode
     C                   PARM      'S'           RespMode          1
      *
      ** Originating Branches Details
     C                   PARM                    TranInOBRC
      *
      * OUTPUTS
      *
      ** Originating Branches Details OK inds
     C                   PARM                    OKTrOBRC
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
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      * Valid Originating Branches layout (DS) from/to caller
     C                   PARM                    ValidOBRC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidCMPS - Validate Companies                                *
      *                                                               *
      *****************************************************************
     C     ValidCMPS     BEGSR
      *
     C                   CALLB     'SFAMUS4VL'
      *
      * INPUTS
      *
      * Response mode
     C                   PARM      'S'           RespMode          1
      *
      ** Companies Details
     C                   PARM                    TranInCOMP
      *
      * OUTPUTS
      *
      ** Companies Details OK inds
     C                   PARM                    OKTrCOMP
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
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      * Valid Companies layout (DS) from/to caller
     C                   PARM                    ValidCOMP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      * The following /COPY contains the standard program status
      * subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2006
