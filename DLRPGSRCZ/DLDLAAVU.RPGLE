     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Adjustment Accrued Int Validate & Update')    *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLDLAAVU - Midas DL Adjustment Accrued Interest Validate     *
      *             and update                                        *
      *                                                               *
      *  Function: This program validates DLAA     transactions for   *
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
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. AR1096788          Date 18Mar13               *
      *  Prev Amend No. CAP210  *CREATE    Date 28Sep12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1096788 - DLAA details should be written in core STRANF    *
      *              file instead of the new DLSTRANFPD file          *
      *  CAP210 - Adjustment to Accrued Interests API                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      *
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Array for STRANFL0 override                                                       AR1096788
     D PCMD            S             50A   DIM(2) CTDATA PERRCD(1)                         AR1096788
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
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
      *
      ** Valid Accrued Interest Adjustment layout
      *
     D ValidDlaa     E DS                  EXTNAME(DLVDLAAPD)
      *
      ** (Current) Transaction record in file Format
      *
     D*DlaaFilFmt    E DS                  EXTNAME(DLSTRANFPD)                             AR1096788
     D DlaaFilFmt    E DS                  EXTNAME(STRANF)                                 AR1096788
      *
      ** (Current) Transaction in Screen Format - Main Details
      *
     D CurTrDlaa     E DS                  EXTNAME(DLDLAAPD)
     D                                     PREFIX(@)
      *
      ** Error indicators
      *
     D OKTrdlaa      E DS                  EXTNAME(DLEDLAAPD)
      *
      ** First DS for access programs - short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for access programs - long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DLAA in screen format
      *
     D DLAAScnFmt    E DS                  EXTNAME(DLDLAAPD)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Error message field(s)
      *
     D     Msg1        S                   LIKE(#MsgID)
      *
      ** Index for arrays of error message ids etc
      *
     D Idx             S              3P 0 INZ(0)
      *
      ** Index for arrays of warning message ids etc
      *
     D WIdx            S              3P 0 INZ(0)
      *
      ** Fields (500A) to receive the incoming transaction
      *
     D Trans5001       S            500A
      *
      ** Indices for arrays used to set up corresponding
      ** sequence numbers for the fields that are in error
      *
     D Ix              S              3P 0
     D Iy              S              3P 0
      *
      ** Timestamp for the transaction
      *
     D TimeStamp       S               Z
      *
     D UpdateYN        S              1
     D Buffer          S           6000
     D APIRetc         S              1
     D ModeofOp        S              6
     D RespMode        S              1
     D @@RTCD          S              7
     D IncData         S           2000
     D CurData         S           2000
      *
     D PCMDLEN         S             15  5                                                 AR1096788
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Incoming transaction is broken into 500A fields, so that a common CL
      ** can be used between this module and the one that read the MQ queue.
      ** This module needs to break these 500A fields by loading them into
      ** the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     DLAAScnFmt
      *
      ** Generate a timestamp for this transaction
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
      ** Reset variables gradually updated
      *
     C                   EXSR      RESETCYCLE
      *
      ** Validate action code
      *
     C                   EXSR      ValidateAc
      *
      ** If error in validation of action code, fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
      *
      ** Processing depends upon action code
      *
     C                   SELECT
      *
      ** Processing for inserts
      *
     C                   WHEN         DDACTN = 'I'
     C                   EXSR      ValidateTr
      *
      ** Processing for Amend, Delete and Authorize
      *
     C                   WHEN         DDACTN = 'A'
     C                             OR DDACTN = 'D'
     C                             OR DDACTN = 'X'
     C                   EXSR      SetupAmd
     C                   EXSR      ValidateTr
      *
     C                   ENDSL
      *
     C     INVALID       TAG
      *
      ** Write to database
      *
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
     C                   ENDIF
      *
     C                   SETON                                        LR
      *
      ** Remerge buffer with all relevant data structures
      *
     C                   EVAL      Buffer = DLAAScnFmt
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Common header information (DS) from source system
      *
     C                   PARM                    HeadIn
      *
      ** Transaction information
      *
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
      *
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
      *
     C                   EVAL      MsgFArray(1) = 'DLUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
      *
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
      ** Set retrieve mode to '*FRONT' (Access using Front Office ID)
      **  if insert
      **  if not insert and Midas transaction ID is not present
      ** Otherwise
      **  Set retrieve mode to blank  (Access using Midas transaction ID).
      *
     C                   IF        DDACTN = 'I'
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE
     C                   IF        DDTRNN = *BLANK
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE
     C                   MOVEL     '      '      ModeofOp
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        APFOTRANID <> *BLANKS AND
     C                             DDACTN = 'I'
     C                   EVAL      ModeOfOp = '*FRONT'
     C                   ELSE
     C                   MOVEL     '      '      ModeofOp
     C                   ENDIF
      *
      ** Validate action code versus transaction IDs supplied
      ** The Transaction in file format from the mm database is retrieved
      ** as well.
      *
     C                   RESET                   ReturnCode
     C                   CALLB     'DLDLAARTV'
      *
      ** Inputs
      *
      ** Return code
      *
     C                   PARM      *BLANK        ReturnCode
      *
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp
      ** Response mode
     C                   PARM                    APRESPMODE
      ** Action Code
     C                   PARM                    DDACTN
      ** Front Office Transaction ID
     C                   PARM                    APFOTranID
      ** (Midas) Transaction Number
     C                   PARM                    DDTRNN
      *
      ** Outputs
      *
      ** (Current) Transaction in file format
      *
     C                   PARM                    DlaaFilFmt
      ** OK - Action code
     C                   PARM                    DDActnOK
      ** OK - Transaction Number
     C                   PARM                    DDTrnnOK
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *            of amendments.                                     *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR
      *
      ** For Amends, put the complete (pre-existing) Transaction into the Valid
      **  file record - fields in this will be updated during processing
      *
     C                   MOVEL     DlaaFilFmt    ValidDlaa
      *
      ** For Amends, convert the transaction to screen format
      *
     C                   CALLB     'DLDLAACVT'
      *
      ** Inputs
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Transaction - file formats
      *
     C                   PARM                    ValidDlaa
      *
      ** Output parameters
      *
      ** Adjustment Transaction Details - screen formats
      *
     C                   PARM                    CurTrDlaa
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
      *
      ** Validate Adjustment Transaction details
      *
     C                   EXSR      ValdTrDlaa
      *
      ** If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
      *
     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrDlaa - Validate Adjustment Transaction details          *
      *                                                               *
      *****************************************************************
     C     ValdTrDlaa    BEGSR
      *
     C                   CALLB     'DLDLAAVAL'
      *
      ** Inputs
      *
      ** Response mode
     C                   PARM                    RespMode
      ** Transaction Details
     C                   PARM                    DLAAScnFmt
      *
      ** Outputs
      *
      ** Transaction Details OK inds
      *
     C                   PARM                    OKTrdlaa
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      ** Valid Transaction (DS) from/to caller
     C                   PARM                    ValidDlaa
      *
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
      *
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
     C                   RESET                   FldNoArr
     C                   CLEAR                   CurTrDlaa
     C                   MOVE      *ALL'Y'       OKTrDlaa
     C                   CLEAR                   ValidDlaa
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *              valid file record.                               *
      *                                                               *
      *****************************************************************
      *
     C     SETUPVALID    BEGSR
      *
      ** Set Valid file field(s) that are needed for all Action Codes
      *
     C                   EVAL      VFTYLC = DDACTN
     C                   MOVEL     DDTRNN        VFTRNN
      *
      ** Include Header fields that need to be o/p to the Valid file
      *
     C                   EVAL      VFFRNT = APFOTranID
     C                   EVAL      VFAFRT = APFOAsocID
     C                   EVAL      VFREPA = APRprLocn
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update database                                    *
      *                                                               *
      *****************************************************************
      *
     C     UPDATEDB      BEGSR
      *                                                                                    AR1096788
      ** Override LEPDUELB                                                                 AR1096788
      *                                                                                    AR1096788
     C                   Z-ADD     32            PCMDLEN                                   AR1096788
     C                   CALL      'QCMDEXC'                                               AR1096788
     C                   PARM                    PCMD(1)                                   AR1096788
     C                   PARM                    PCMDLEN                                   AR1096788
      *
      ** Database Update
      *
     C                   CALLB     'DLDLAAUPD'
     C                   PARM      *BLANK        @@RTCD
     C                   PARM                    ValidDlaa
      *
      ** Comit Updates if No Error
      *
     C                   IF        @@RTCD = '*ERROR ' OR
     C                             @@RTCD = '*RECUPD'
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   COMMIT
      ** If action is Insert, return the Transaction Number
     C                   IF        DDACTN = 'I'
     C                   EVAL      DDTRNN = VFTRNN
     C                   ENDIF
     C                   ENDIF
      *                                                                                    AR1096788
      ** Delete override of LEPDUELB                                                       AR1096788
      *                                                                                    AR1096788
     C                   Z-ADD     21            PCMDLEN                                   AR1096788
     C                   CALL      'QCMDEXC'                                               AR1096788
     C                   PARM                    PCMD(2)                                   AR1096788
     C                   PARM                    PCMDLEN                                   AR1096788
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DtaSubs - Data Substitution                                   *
      *                                                               *
      *****************************************************************
      *
     C     DtaSubs       BEGSR
      *
      ** Convert file fields to screen format
      *
     C                   RESET                   ReturnCode
     C                   CALLB     'DLDLAACVT'
      ** Return Code
     C                   PARM                    ReturnCode
      ** Input parameters
      ** Transaction - file formats
     C                   PARM                    DlaaFilFmt
      *
      ** Output parameters
      ** Adjustments Transaction Details - screen formats
      *
     C                   PARM                    CurTrDlaa
      *
     C                   ENDSR
      *
      *****************************************************************
      * The following /COPY contains the standard program status
      * subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
** PCMD                                                                                    AR1096788
OVRDBF FILE(STRANFL0) SHARE(*NO)                                                           AR1096788
DLTOVR FILE(STRANFL0)                                                                      AR1096788
