     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Collateral Details validate and update')      *
      *****************************************************************
      *                                                               *
      *  Midas - Module name ILE Module                               *
      *                                                               *
      *  GLCOLLVU - Collaterals validate and update                   *
      *                                                               *
      *  Function: This Program Validates GL Collaterals for          *
      *            Input into the Midas database.                     *
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
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL072             Date 10Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8550            Date 05Oct05               *
      *                 BUG4482            Date 29Sep04               *
      *                 223193             Date 19Nov03               *
      *                 CAP084  *CREATE    Date 16Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CGL072 - Allow GL Accounts as Collateral                     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  BUG4482 - Authorise should call Validate to show all the     *
      *            warning errors.                                    *
      *  223193 - Recompiled over changed GLVCOLLPD.                  *
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
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
 
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming Transaction
     D TranInCOLL    E DS                  EXTNAME(GLCOLDPD)
     D   TranInInit            1     64
     D   TranInFirst          65    306
     D   TranInSecond        307    654
     D   TranInThird         655    740
      *
      * Valid Customer Securities Details layout
     D ValidCOLL     E DS                  EXTNAME(GLVCOLLPD)
     D                                     PREFIX(V_)
 
      * (Current) Transaction record in file Format
     D COLLFilFmt    E DS                  EXTNAME(GLCOLLPD)
 
      * (Current) Transaction in Screen Format - Main Details
     D CurTrCOLL     E DS                  EXTNAME(GLCOLDPD)
     D                                     PREFIX(@)
 
 
      * Error indicators
     D OKGLCOLL      E DS                  EXTNAME(GLECOLPD)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure
      ** DS for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10
     D  PDBRN                 11     13
     D  PDPPT                 14     16
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
     D Trans5002       S            500A
     D Trans5003       S            500A
     D Trans5004       S            500A
 
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      ** Indices for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D Object          S             10A   INZ('GLCOLLUPD')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
 
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepCOLL         S              1A   INZ('N')
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
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Retrieve ZMUSER details.                                                            BUG8550
                                                                                             BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
                                                                                             BUG8550
      ** Set Front Office ID = User ID                                                       BUG8550
     C                   EVAL      APFOTranID = %SUBST(PUSRID:1:3)                           BUG8550
 
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     TranInInit
     C                   MOVEL     Trans5002     TranInFirst
     C                   MOVEL     Trans5003     TranInSecond
     C                   MOVEL     Trans5004     TranInThird
 
      * Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
      *
      *  If valid COLL details does exist (even after delay), fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      *  Validate Action Code
 
     C                   EXSR      ValidateAc
      *
      *  If error in validation of action code, fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
      *  Processing for Inserts
     C                   WHEN         DDACTN = 'I'
     C                   EXSR      ValidateTr
 
      *  Processing for Inserts, Amends or Changes
     C                   WHEN         DDACTN = 'A'
     C                   EXSR      SetupAmd
     C                   EXSR      ValidateTr
                                                                                             BUG4482
     C                   WHEN      DDACTN = 'X'                                              BUG4482
      *  Processing for Authorises                                                           BUG4482
     C                   EXSR      ValidateTr                                                BUG4482
 
     C                   ENDSL
      *
     C     INVALID       TAG
 
      *  Write to database
 
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      WriteToDB
     C                   ENDIF
 
     C                   SETON                                        LR
 
      * Remerge buffer with all relevant data structures
     C                   EVAL                    Buffer = TranInCOLL
     C                                                    +V_CDCOPT
 
 
     C                   RETURN
 
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    Transaction number supplied                                *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      * Validate action code versus transaction IDs supplied
      * The Transaction in file format from the mm database is retrieved
      * as well.
 
     C                   CALLB     'GLCOLLRTV'
      *
      ** INPUT PARAMETERS:
      *
      ** Initial screen fields
     C                   PARM                    DDACTN
     C                   PARM                    DDCREF
     C                   PARM                    DDREVF
     C                   PARM                    DDREQR
     C                   PARM                    DDSENT
     C                   PARM                    DDSCMP
     C                   PARM                    DDSBRC
     C                   PARM                    DDSCOL
     C                   PARM                    DDSCNU
     C                   PARM                    DDSCCY
     C                   PARM                    DDSVAL
     C                   PARM                    DDSGNS
      *
     C                   PARM                    CGL012
      *
      ** Mode of operation
     C                   PARM      *BLANKS       ModeOp            6
      *
      ** Response Mode
     C                   PARM      'S'           RespMode          1
      *
      ** Front Office Id
     C                   PARM      *BLANKS       APFOTranID       20
      *
      ** OUTPUT PARAMETERS:
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Collateral details (file format)
     C                   PARM      *BLANKS       COLLFilFmt
      *
      ** OK Flags
     C                   PARM      *BLANK        DDACTNOK          1
     C                   PARM      *BLANK        DDCREFOK          1
     C                   PARM      *BLANK        DDREVFOK          1
     C                   PARM      *BLANK        DDREQROK          1
     C                   PARM      *BLANK        DDSENTOK          1
     C                   PARM      *BLANK        DDSCMPOK          1
     C                   PARM      *BLANK        DDSBRCOK          1
     C                   PARM      *BLANK        DDSCOLOK          1
     C                   PARM      *BLANK        DDSCNUOK          1
     C                   PARM      *BLANK        DDSCCYOK          1
     C                   PARM      *BLANK        DDSVALOK          1
     C                   PARM      *BLANK        DDSGNSOK          1
 
 
     C                   ENDSR
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *    of amendments.                                             *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR
 
      * For Amends, put the complete (pre-existing) Transaction into the Valid
      *  file record - fields in this will be updated during processing
 
     C                   MOVE      COLLFilFmt    ValidCOLL
 
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
 
      * Validate Collateral Primary details
 
     C                   EXSR      ValdCoPrim
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
      * Validate Customer Base Rate Tax Details
 
 
     C                   EXSR      ValdCoSecn
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   ENDIF
 
     C                   EXSR      ValdCOThird
 
 
     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdCoPrim - Routine to validate the primary screen           *
      *                                                               *
      *****************************************************************
     C     ValdCoPrim    BEGSR
 
     C                   CALLB     'GLCOLL1VL'
      *
      ** Transaction Screen Format
     C                   PARM                    TranInCOLL
      *
      ** Transaction Status
     C                   PARM                    TransStat
      *
      ** Mode of Operation
     C                   PARM      'S'           RespMode
      *
      ** New Collateral Record
     C                   PARM                    ValidCOLL
      *
      ** Validation program requires new and old record the same used here
      ** Old Collateral Record
     C                   PARM                    ValidCOLL
      *
      ** Fields OK indicators
     C                   PARM      *ALL'Y'       OKGLCOLL
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANKS       FldNameArr
     C                   PARM      *BLANKS       MsgIdArr
     C                   PARM      *BLANKS       MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM      *Zero         Idx
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM      *Zero         WIdx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdCoSecn - Routine to validate the primary screen           *
      *                                                               *
      *****************************************************************
     C     ValdCoSecn    BEGSR
 
     C                   CALLB     'GLCOLL2VL'
      *
      ** Transaction Screen Format
     C                   PARM                    TranInCOLL
      *
      ** Transaction Status
     C                   PARM                    TransStat         7
      *
      ** Mode of Operation
     C                   PARM      'S'           RespMode
      *
      ** New Collateral Record
     C                   PARM                    ValidCOLL
      *
      ** Fields OK indicators
     C                   PARM      *ALL'Y'       OKGLCOLL
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANKS       FldNameArr
     C                   PARM      *BLANKS       MsgIdArr
     C                   PARM      *BLANKS       MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM      *Zero         Idx
     C                   PARM                    CGL072            1                         CGL072
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM      *Zero         WIdx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdCoThird - Routine to validate the primary screen          *
      *                                                               *
      *****************************************************************
     C     ValdCoThird   BEGSR
 
      ** Call the third detail screen validation module
     C                   CALLB     'GLCOLL3VL'
      *
      ** Transaction Screen Format
     C                   PARM                    TranInCOLL
      *
      ** Transaction Status
     C                   PARM                    TransStat
      *
      ** Mode of Operation
     C                   PARM      'S'           RespMode
      *
      ** New Collateral Record
     C                   PARM                    ValidCOLL
      *
      ** Fields OK indicators
     C                   PARM      *ALL'Y'       OKGLCOLL
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANKS       FldNameArr
     C                   PARM      *BLANKS       MsgIdArr
     C                   PARM      *BLANKS       MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM      *Zero         Idx
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM      *Zero         WIdx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     WriteToDB     BEGSR
 
     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETCYCLE- Reset error information that is gradually         *
      *    updated during each run of this program                    *
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
 
 
     C                   RESET                   FldNoArr
 
     C                   CLEAR                   CurTrCOLL
 
     C                   MOVE      *ALL'Y'       OKGLCOLL
 
     C                   CLEAR                   ValidCOLL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************
 
     C     SETUPVALID    BEGSR
 
      * Set Valid file field for a delete.
     C                   IF        DDACTN = 'D'
     C                             OR DDACTN = 'X'
     C                   EVAL      ValidCOLL = COLLFilFmt
     C                   ENDIF
      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      V_CDTYLC = DDACTN
     C                   EVAL      V_CDCREF = DDCREF
 
      * Include Header fields that need to be o/p to the Valid file
     C                   EVAL      V_CDFRNT = APFOTranID
     C                   EVAL      V_CDREPA = APRprLocn
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGENREFNO - Generate Reference Number processing            *
      *                                                               *
      *****************************************************************
     C     SRGENREFNO    BEGSR
      *
      ** Call the generate reference module
     C                   CALLB     'GLCOLLGEN'
      *
      ** INPUT PARAMETERS:
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Module
     C                   PARM      'GL'          PMODULE           2
      *
      ** Transaction Type
     C                   PARM      'C'           PTTYPE            1
      *
      ** Front Office Id
     C                   PARM      *BLANKS       APFOTranID
      *
      ** OUTPUT PARAMETER:
      *
      ** Generated Reference
     C                   PARM      *BLANKS       PGENREF          10
      *
     C     RetCodeOut    IFNE      *BLANKS
     C                   ROLBK
     C                   MOVEL     *BLANKS       DBKEY
     C                   MOVEL     'GLCOLLGEN   'DBFILE
     C                   Z-ADD     007           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update Database                                    *
      *                                                               *
      *****************************************************************
 
     C     UPDATEDB      BEGSR
 
      *
      * UPDATE VALID DEAM: DEAL NUMBER
      *
     C                   MOVEL     DDCREF        V_CDCREF
      *
      * Set up reference number
     C     DDCREF        IFEQ      *BLANKS
     C                   EXSR      SRGENREFNO
     C                   MOVEL     PGENREF       V_CDCREF
     C                   ENDIF
      *
      * UPDATE VALID DEAM: LAST ACTION CODE
      *
     C                   MOVEL     DDACTN        V_CDTYLC
      *
      * MONEY MARKET UPDATES
      *
     C                   CALLB     'GLCOLLUPD'
     C                   PARM      *BLANK        ReturnCode       10
     C                   PARM                    ValidCOLL
     C                   PARM                    CGL012
      *
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     ReturnCode    IFNE      *BLANK
     C     ReturnCode    ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   COMMIT
     C                   END
      *
      ** If update not done due to record being updated by another
      ** workstation send message to screen.
 
     C     @RTCD         IFEQ      '*RECUPD'
 
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
 
     C                   END
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
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
      ** Ultimate calling Program/Module/Procedure
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
     C                   EVAL      MsgFArray(1) = 'GLUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,GLCOLA02
 
      *  Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'GL'
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Access SAR details file to determine if MDF Switchable feature
      ** is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CSD006'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CSD006            1
     C                   ELSE
     C                   MOVEL     'N'           CSD006
     C                   END
 
      ** Access SAR details file to determine if CGL012
      ** (Collateral Authorisations) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CGL012'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CGL012'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     003           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     'N'           CGL012
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CGL012            1
     C                   ENDIF
                                                                                             CGL072
      ** Check if CGL072 is installed                                                        CGL072
                                                                                             CGL072
     C                   CALL      'AOSARDR0'                                                CGL072
     C                   PARM      *BLANKS       PRTCD                                       CGL072
     C                   PARM      '*VERIFY'     POPTN                                       CGL072
     C                   PARM      'CGL072'      PSARD                                       CGL072
     C     SCSARD        PARM      SCSARD        DSFDY                                       CGL072
                                                                                             CGL072
     C                   IF        PRTCD = *BLANKS                                           CGL072
     C                   EVAL      CGL072 = 'Y'                                              CGL072
     C                   ELSE                                                                CGL072
     C                   EVAL      CGL072 = 'N'                                              CGL072
     C                   ENDIF                                                               CGL072
      *
      ** Retrieve ZMUSER details.
      *
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
 
      ** Set Front Office ID = User ID
     C**********         EVAL      APFOTranID = %SUBST(PUSRID:1:3)                           BUG8550
 
      *  Hook to enable non-core initial processing to be included
 
     C                   ENDSR
      *****************************************************************
