     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Statmts Prod. Requests - Interface Ctrl')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SESTPRCTL - Statement Production Requests              *
      *                  - Interface Controller                       *
      *                                                               *
      *  Function: This Program Validates Statement Production        *
      *            Requests for input into the Midas database.        *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Transaction details fields        *
      *            - For A (=AMEND),                                  *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *            - For D (=DELETE), call a separate function to     *
      *              process the transaction and bypass the rest of   *
      *              the validation.                                  *
      *                                                               *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSE040   *CREATE   Date 27Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSE040 - Securities Statement Processing                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSEVSTPRPD UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SEVSTPRD0:SEVSTPRDD)
     F                                     COMMIT
      ** Valid Statement Production Requests File
 
     FSEISTPRPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Invalid Statement Production Requests File
 
     FSEVSTPRL0 IF   E           K DISK    INFSR(*PSSR)
      ** Valid Statement Production Requests by Front Office Id.
 
     FSEVSTPRL1 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEVSTPRD0:SEVSTPRD1)
      ** Valid Statement Production Requests by Alternative Key (partial) and Timestamp
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      /COPY WNCPYSRC,SESTPRC001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
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
 
     D HeadIn        E DS                  EXTNAME(APHEADPD)
      **Incoming Header
 
     D NewScnIFld    E DS                  EXTNAME(SESTPR1PD)
      ** Incoming Request in screen format - Input/output fields
 
     D NewScnOFld    E DS                  EXTNAME(SESTPR2PD)
      ** Incoming Request in screen format - Output only fields
 
     D ExtData       E DS                  EXTNAME(SESPEXPD)
      ** Incoming Request Extra Data in screen format
 
     D NewSESTPR     E DS                  EXTNAME(SEVSTPRPD)
      ** Valid Statement Production Request layout
 
     D SESTPR        E DS                  EXTNAME(SESTPRPD)
      ** (Current) Statement Production Requests in file format
 
     D CurScnIFld    E DS                  EXTNAME(SESTPR1PD) PREFIX(C_)
      ** (Current) Request in screen format - Input/output fields
 
     D CurScnOFld    E DS                  EXTNAME(SESTPR2PD) PREFIX(C_)
      ** (Current) Request in screen format - Output only fields
 
     D OKStPRFlags   E DS                  EXTNAME(SEESTPRPD)
      ** Error indicators
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access programs - short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access programs - long data structure
 
      ** Split up of the Statement Production Request Reference
     D DDStPRRef       DS
      ** -- Main key (used in SIN function)
     D     DDStPRDATE                 6A
     D     DDStPRRSEQ                 7A
     D   DDStPRMainK           1     13A
      ** -- Alternative key (used in CTL & RPR functions)
     D     DDStPRCUST                 6A
     D     DDStPRTYPE                 2A
     D     DDStPRSNDR                 3A
     D     DDStPRRECP                11A
     D     DDStPRFREQ                 1A
     D   DDStPRAltK           14     36A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
 
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      ** Indicies for arrays used to set up corresponding sequence numbers
      ** for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D Object          S             10A   INZ('SESTPRUPC')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A   INZ('*DTAARA')
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
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      /COPY WNCPYSRC,SESTPRC002
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,SESTPRC003
 
      ** Incoming transaction is broken into 500A fields, so that a common CL
      ** can be used between this module and the one that read the MQ queue.
      ** This module needs to break these 500A fields by loading them into
      ** the appropriate (externally described) data structure.
      *
     C                   MOVEL     Trans5001     NewScnIfld
     C                   MOVEL     Extdata500    Extdata
 
      ** Generate a timestamp for this transaction
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      ** Reset variables gradually updated
      *
     C                   EXSR      ResetCycle
 
      /COPY WNCPYSRC,SESTPRC004
 
      ** Check if valid Statement Production Request details exists (Front Office Id.)
      *
     C                   EXSR      ChkValFrnt
      *
      ** If valid request details does exist (even after delay), fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Check if valid Request details exists (Midas Reference)
      *
     C                   EXSR      ChkValMids
      *
      ** If valid request does exist (even after delay), fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Reset variables again in case the details have been corrupted
      ** by previous chain to valid request details file.
      *
     C                   EXSR      ResetCycle
 
      /COPY WNCPYSRC,SESTPRC005
 
      ** Validate Action Code
      *
     C                   EXSR      ValAction
 
      /COPY WNCPYSRC,SESTPRC006
 
      ** If error in validation of action code, fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Processing depends upon Action Code
      *
     C                   SELECT
      ** Processing for Inserts
     C                   WHEN         DDACTN = 'I'
      *
      /COPY WNCPYSRC,SESTPRC007
      *
     C                   EXSR      ValidatePR
      *
      /COPY WNCPYSRC,SESTPRC008
      *
      ** Processing for Amends or Changes
     C                   WHEN         DDACTN = 'A'
     C                             OR DDACTN = 'D'
      *
      /COPY WNCPYSRC,SESTPRC009
      *
     C                   EXSR      CvtStPR
      *
      ** Check for the existence of the replacement character; if this is
      ** used, only the changed data has been sent, and all occurrences of
      ** the replacement character must be replaced with the corresponding
      ** character from the original transaction.
      *
     C                   IF        DDACTN = 'A' AND GHSUBS <> *BLANK AND
     C                             %Scan(GHSUBS:NewScnIFld) > 0
     C                   EXSR      DtaSubs
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESTPRC010
      *
     C                   EXSR      ValidatePR
      *
      /COPY WNCPYSRC,SESTPRC011
      *
     C                   ENDSL
 
     C     INVALID       TAG
      *
      ** Check for exception error from any program lower in the stack
      ** If error detected, send message to system operator and
      ** return to calling program without updating database or
      ** prompting the database update program
      *
     C                   IN        APDUMP
 
      /COPY WNCPYSRC,SESTPRC012
 
 B1  C                   IF        ARERRMOD <> *BLANK
     C                   EVAL      MQErrLong = 'Error in module ' + ARERRMOD
      *
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MQReturn         10
     C                   PARM                    MQErrlong       132
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
      *
     C                   MOVEL     ARERRMOD      APRETCODE
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARERRMOD = *BLANK
     C                   OUT       APDUMP
     C                   RETURN
      *
 X1  C                   ELSE
      *
      ** Processing for Error checking/write to database
      *
      /COPY WNCPYSRC,SESTPRC013
      *
     C                   EXSR      CheckWrite
      *
      /COPY WNCPYSRC,SESTPRC014
      *
      ** If valid, send data queue entry to prompt DB update program
      *
 B2  C                   IF        Idx = 0
      *
      ** Check if update program active using Allocate Object API
      ** No prompting necessary if program is running
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM      *Blank        Return
      *
 B3  C                   IF        Return = *Blank
      *
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
      /COPY ZACPYSRC,DTAQCHK
      *
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
 
      /COPY WNCPYSRC,SESTPRC015
 
     C                   RETURN
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      * ChkValFrnt - Check if the Front Office Id. already exists in the valid file
      ********************************************************************
     C     ChkValFrnt    BEGSR
      *
     C     APFOTRANID    CHAIN     SEVSTPRD0
      *
      ** If record found...
      *
     C                   IF        %Found(SEVSTPRL0)
      *
      ** ..delay, then repeat check
      *
     C                   CALLB     'ZACDELAY'
      *
     C     APFOTRANID    CHAIN     SEVSTPRD0
      *
      ** Error if still present
      *
     C                   IF        %Found(SEVSTPRL0)
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCUST'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ChkValMids - Check if the Midas Reference already exists in the valid file
      *****************************************************************
     C     ChkValMids    BEGSR
      *
      ** Key list for file SEVSTPRL1
      *
     C     KSEVSTPRL1    KLIST
     C                   KFLD                    DDCUST
     C                   KFLD                    DDTYPE
     C                   KFLD                    DDSNDR
     C                   KFLD                    DDRECP
     C                   KFLD                    DDFREQ
      *
      ** If the key seems Ok
      *
     C                   IF        DDCUST <> *Blanks AND
     C                             DDTYPE <> *Blanks AND
     C                             DDSNDR <> *Blanks AND
     C                             DDRECP <> *Blanks AND
     C                             DDFREQ <> *Blanks
      *
      ** Check for Transaction on Valid file
      *
     C     KSEVSTPRL1    CHAIN     SEVSTPRD1
      *
      ** If record found...
      *
     C                   IF        %Found(SEVSTPRL1)
      *
      ** ..delay, then repeat check
      *
     C                   CALLB     'ZACDELAY'
      *
     C     KSEVSTPRL1    CHAIN     SEVSTPRD1
      *
      ** Error if still present
      *
     C                   IF        %Found(SEVSTPRL1)
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCUST'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ValAction  - Routine to validate action code versus the
      *              Front Office Id. / Midas Reference supplied
      *****************************************************************
     C     ValAction     BEGSR
      *
      ** Set retrieve mode to '*FRONT' (Access using Front Office ID)
      **  if insert
      **  if not insert and Midas Request Reference is not present
      **  (including a check for the existence of the replacement character
      **   at the Midas Request Reference level).
      ** Otherwise
      **  Set retrieve mode to blank  (Access using Midas Request Reference).
      *
      **  We assume no substitution has been defined for the transaction ID
      *
     C                   EVAL      DDStPRDATE = DDDATE
     C                   EVAL      DDStPRRSEQ = DDRSEQ
     C                   EVAL      DDStPRCUST = DDCUST
     C                   EVAL      DDStPRTYPE = DDTYPE
     C                   EVAL      DDStPRSNDR = DDSNDR
     C                   EVAL      DDStPRRECP = DDRECP
     C                   EVAL      DDStPRFREQ = DDFREQ
      *
     C                   CALLB     'ZDATE1'
     C                   PARM      DDDATE        DateIn            6
     C                   PARM                    DaynoOut          5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    ErrorFlag         1
      *
 B1  C                   IF        ErrorFlag = 'Y'
     C                   EVAL      DDStPRDATE = *Blanks
 E1  C                   ENDIF
      *
     C                   MOVEL     DDRSEQ        WWTEST8           8
     C                   MOVE      '0'           WWTEST8
     C                   TESTN                   WWTEST8              9999
     C  N99              EVAL      DDStPRRSEQ = *Blanks
      *
 B1  C                   IF        DDACTN = 'I'
     C                   EVAL      ModeofOp = '*FRONT'
 X1  C                   ELSE
      *
 B2  C                   IF        (DDStPRDATE = *Blanks OR                     Main key
     C                              DDStPRRSEQ = *Blanks OR                       not present
     C                              %Scan(GHSUBS:DDStPRMainK) > 0)
     C                                          AND                               AND
     C                             (DDStPRCUST = *Blanks OR
     C                              DDStPRTYPE = *Blanks OR                     Alternate Key
     C                              DDStPRSNDR = *Blanks OR                       not present
     C                              DDStPRRECP = *Blanks OR
     C                              DDStPRFREQ = *Blanks OR
     C                              %Scan(GHSUBS:DDStPRAltK) > 0)
     C                   EVAL      ModeofOp = '*FRONT'
 X2  C                   ELSE
     C                   EVAL      ModeofOp = *Blanks
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** Validate action code versus Request IDs supplied
      ** The Request in file format from the SE database is retrieved
      ** as well.
      *
     C                   CALLB     'SESTPRRTV'
      ** INPUT PARAMETERS
      ** Return code
     C                   PARM      *Blanks       RetCodeOut
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      ** Response mode (no SPF checking required)
     C                   PARM      *Blank        RespMode          1
      ** Action Code
     C                   PARM                    DDACTN            1
      ** Front Office Transaction ID
     C                   PARM      APFOTRANID    FOTRID           20
      ** (Midas) Statement Production Request Reference
     C                   PARM                    DDStPRRef
      *
      ** OUPUT PARAMETERS
      ** Statement Production Request in file format
     C                   PARM                    SESTPR
      ** OK - Action code and first key field of the request reference
     C                   PARM                    DDACTNOK          1
     C                   PARM                    DDDATEOK          1
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
      * CvtStPR - Convert the current file record into screen fields
      *****************************************************************
     C     CvtStPR       BEGSR
      *
      ** Put the complete (pre-existing) Request into the Valid
      ** file record - fields in this will be updated during processing
      *
     C                   MOVE      SESTPR        NewSESTPR
      *
      ** Convert the Request record to screen format
      *
     C                   CALLB     'SESTPRCVT'
      ** INPUT PARAMETERS
      ** Return Code
     C                   PARM                    RetCodeOut
      ** Statement Production Request in file format
     C                   PARM                    SESTPR
      *
      ** OUTPUT PARAMETERS
      ** (Current) Request in screen format - Input/output fields
     C                   PARM                    CurScnIFld
      ** (Current) Request in screen format - Output only fields
     C                   PARM                    CurScnOFld
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      * ValidatePR - Statement Production Request Details validation
      ******************************************************************
     C     ValidatePR    BEGSR
      *
     C                   CALLB     'SESTPRVAL'
      ** INPUT PARAMETERS
      ** Request Details in screen format
     C                   PARM                    NewScnIFld
      ** Output only Screen Fields (No utility for the CTL function)
     C                   PARM                    NewScnOFld
      ** Current Transaction Details in screen format
     C                   PARM                    CurScnIfld
      ** Calling Module Code (*SIN, *RPR, etc...)
     C                   PARM      '*CTL'        CallerCode        4
      *
      ** OUTPUT PARAMETERS
      ** Transaction Details OK inds
     C                   PARM                    OKStPRFlags
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx               3 0
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx              3 0
      ** Valid Transaction details layout (DS) from/to caller
     C                   PARM                    NewSESTPR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DtaSubs - Data Substitution
      *****************************************************************
     C     DtaSubs       BEGSR
      *
      ** Substitute the data for the various parts of the request,
      *
     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
     C                   RESET                   ReturnCode
      *
     C                   CALLB     'APDTASUBS'
      ** Return Code
     C                   PARM                    ReturnCode
      ** Substitution character
     C                   PARM                    GHSUBS
      ** Incoming Data
     C                   PARM      NewScnIfld    IncData        2000
      ** Current Data
     C                   PARM      CurScnIFld    CurData        2000
      *
     C                   MOVEL     IncData       NewScnIFld
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Check/Write - Routine to control checking of error status and *
      *    sending of messages/writing to the database                *
      *****************************************************************
     C     CheckWrite    BEGSR
      *
      ** If no errors were found:
      **    - set up additional data
      **    - write a record to the Valid file
      **    - use std message handler to report transaction status
      ** If any errors were found:
      **    - write a record to the Invalid file
      **    - call the message handler to pass the errors back
      **    - use std message handler to report transaction status
      ** The index to the error arrays is checked for presence/absence of
      **  errors
      *
      ** +--- Note for a later release -------------------------------+
      ** |                                                            |
      ** | At a later date this routine will have to cater for        |
      ** | warning messages.  The following logic will have to be     |
      ** | inserted before "If no errors were found", in the          |
      ** | above comments (and the code):                             |
      ** |                                                            |
      ** | If 'Ignore warning messages' (from API ICD) is 'N', AND    |
      ** | any warning messages were returned (WIdx <> 0)             |
      ** |                                                            |
      ** | -   If errors exist                                        |
      ** |     -     Add the warning array index to the error array   |
      ** |           index                                            |
      ** |     -     Append the contents of the warning arrays to the |
      ** |           end of the error arrays                          |
      ** | -   Else                                                   |
      ** |     -     Set the error array index equal to the warning   |
      ** |           array index                                      |
      ** |     -     Copy the contents of the warning arrays to the   |
      ** |           error arrays                                     |
      ** | -   Endif                                                  |
      ** |                                                            |
      ** | Endif                                                      |
      ** |                                                            |
      ** | Note that the "If errors exist ... Else ... " block above  |
      ** | can probably be implemented unconditionally (ie the same   |
      ** | logic will apply whether errors exist as well as warnings  |
      ** | or not).  It is shown in the above form for clarity.       |
      ** |                                                            |
      ** +------------------------------------------------------------+
      *
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   WRITE     SEVSTPRDD
     C                   EXSR      CallMsgHdl
     C                   ENDIF
      *
     C     Idx           IFGT      0
     C                   EXSR      SetupInval
      *
      ** Only write to invalid files if repair in back office
      *
     C                   IF        APRPRLOCN = 'B'
     C                   WRITE     SEISTPRD0
     C                   ENDIF
      *
     C                   EXSR      CallMsgHdl
     C                   ENDIF
      *
     C                   COMMIT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ResetCycle- Reset error information that is gradually
      *    updated during each run of this program
      *****************************************************************
     C     ResetCycle    BEGSR
      *
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
      *
     C                   RESET                   FldNoArr
      *
     C                   CLEAR                   NewScnOFld
     C                   CLEAR                   CurScnIFld
     C                   CLEAR                   CurScnOFld
     C                   MOVE      *ALL'Y'       OKStPRFlags
     C                   CLEAR                   NewSESTPR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SetupInval - Set up additional fields that are needed on the
      *        invalid file record.
      *****************************************************************
     C     SetupInval    BEGSR
      *
      ** Include Header fields that need to be o/p to the Invalid files
      *
     C                   EVAL      DDFOTRANID = APFOTRANID
     C                   EVAL      DDFOASOCID = APFOASOCID
     C                   EVAL      DDRPRLOCN  = APRPRLOCN
     C                   MOVE      TimeStamp     DDTMESTMP
      *
      ** Transaction Status and Midas Transaction Reference (Store as much
      ** as possible) for use by the message handler
      *
     C                   EVAL      TranStatus = 'F'
      *
     C                   EVAL      TranRef = DDCUST +
     C                                       DDTYPE +
     C                                       DDSNDR +
     C                                       DDRECP
      *
      /COPY WNCPYSRC,SESTPRC016
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SetupValid - Set up additional fields that are needed on the
      *    Valid file record.
      *****************************************************************
     C     SetupValid    BEGSR
      *
      ** Set Valid file field(s) that are needed for all Action Codes
      *
     C                   EVAL      VSPCHTP = DDACTN
      *
      ** Include Header fields that need to be o/p to the Valid file
      *
     C                   EVAL      VSPFRNT = APFOTRANID
     C                   EVAL      VSPAFRT = APFOASOCID
     C                   EVAL      VSPREPA = APRPRLOCN
      *
      ** Transaction Status and Midas Transaction Reference (Store as much
      ** as possible) for use by the message handler
      *
     C                   EVAL      TranStatus = 'S'
      *
     C                   EVAL      TranRef = VSPCUST +
     C                                       VSPTYPE +
     C                                       VSPSNDR +
     C                                       VSPRECP
      *
      *
      /COPY WNCPYSRC,SESTPRC017
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CallMsgHdl - Call the Message Handling module                 *
      *****************************************************************
     C     CallMsgHdl    BEGSR
      *
      ** Set up an array of sequence numbers that correspond to the fields
      **  with errors
      *
     C     1             DO        ArrayMax      Ix
      *
     C                   IF        FldNameArr(Ix) <> *blanks
     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C   20              EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   RESET                   ReturnCode
      *
     C                   CALLB     'ZAMSGHNDLE'
      ** Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      ** Deal repair location (1A, from caller)
     C                   PARM                    APRPRLOCN
      ** Confirm validity to front office (1A, from caller)
     C                   PARM                    APCNFVALFO
      ** List of messages (Array of <ArrayMax>x7A message ids - from caller )
     C                   PARM                    MsgIDArr
      ** List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
     C                   PARM                    FldNoArr
      ** List of field names (Array of <ArrayMax>x10A names - from caller)
     C                   PARM                    FldNameArr
      ** List of message data entries (Array of <ArrayMax>x45 - from caller)
     C                   PARM                    MsgDtaArr
      ** Front office transaction identifier (20A, from caller)
     C                   PARM                    APFOTRANID
      ** Midas module ID (2A)
     C                   Parm                    ModuleID
      ** Midas transaction ID (20A, from caller)
     C                   PARM                    TranRef          20
      ** Message file (10A, from caller)
     C                   PARM                    #MsgFile
      ** Action code of transaction (1A, from transaction)
     C                   PARM                    DDACTN
      ** Status of transaction (1A, F=Failure, S=Success)
     C                   PARM                    TranStatus
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    APRESPMODE
      ** The following three parameters are needed when messages are to
      ** be displayed on a screen
      ** Screen-handling program (10A, from caller)
     C                   PARM                    #ProcPgm
      ** Screen-handling module (10A, from caller)
     C                   PARM                    #ProcMod
      ** Screen-handling procedure (10A, from caller)
     C                   PARM                    #ProcName
      ** The MQSeries queue to send replies to
     C                   PARM                    APRPYQUEUE
      ** The transaction's timestamp
     C                   PARM                    TimeStamp
      ** Additional message files to check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MsgFArray
      ** Whether or not to clear the program message queue (1A)
     C                   PARM                    ClrPgmMsgQ
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      ** Common header information (DS) from source system
     C                   PARM                    HeadIn
      ** Transaction information
     C                   PARM                    Trans5001
     C                   PARM                    ExtData500
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
      *
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
      *
     C                   EVAL      #MsgFile     = 'SEUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'
      *
      ** Set up the Module ID, used to make the Transaction number unique
      *
     C                   EVAL      ModuleID = 'SE'
      *
      ** Access Bank details via access program
      ** (database error handling done in access program)
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access API ICD via access program
      ** (database error handling done in access program)
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Set up the name of the server/database updater data queue.
      *
     C                   EVAL      DtaQName = 'APSTPRDTQ'
      *
      /COPY WNCPYSRC,SESTPRC018
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2003
