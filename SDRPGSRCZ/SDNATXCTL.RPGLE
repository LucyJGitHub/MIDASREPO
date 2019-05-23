     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-A/c Holder by Country of Tax Ctl')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNATXCTL - SD Non-a/c Holder by Country of Tax Controller   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 236137             Date 21Sep05               *
      *                 CGL032  *Create    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  236137 - Change Control for CGL031 (Recompile)               *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas SD Valid Non-a/c Holders by Country of Tax
     FSDVNATXPD UF A E             Disk    Infsr(*PSSR)
     F                                     Commit

      ** Midas SD Invalid Non-a/c Holders by Country of Tax
     FSDINATXPD UF A E             Disk    Infsr(*PSSR)
     F                                     Commit

      ** Midas SD Valid NATX by Front Office ID
     FSDVNATXL0 IF   E           K Disk    Infsr(*PSSR)
     F                                     Rename(SDVNATXD0:SDVNATXCHK)

      ** ZA Sequence numbbers for input fields
     FZAFLDNPD  IT   F   15        Disk    Infsr(*PSSR)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

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

      /COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      /COPY ZACPYSRC,PSDS

      ** The following /COPY line includes definition  for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.

      /COPY ZACPYSRC,PROCPARMS

      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.

      /COPY ZACPYSRC,ERR_ARRAYS

      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.

      /COPY ZACPYSRC,APICTLARR

      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.

      /COPY ZACPYSRC,DTAQCHKDCL

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

      ** String for error messages to the operator
     D ProcErr         C                   Const('Error in module')

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      * Incoming Header
     D PHeadIn       E DS                  Extname(APHEADPD)

      * Incoming Details
     D NwDlScnFmt    E DS                  Extname(SDNATXPD)

      ** Valid Details
     D NwDlFilFmt    E DS                  Extname(SDVNATXPD)

      ** Current Details in Screen Format
     D CrDlScnFmt    E DS                  Extname(SDNATXPD)
     D                                     Prefix(Cr)

      ** Error Indicator File
     D OkFlags       E DS                  Extname(SDENATXPD)

      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      * First DS for Access programs - short data structure
     D DSFDY         E DS                  Extname(DSFDY)

      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)

      ** External DS for API ICD
     D SDAPI         E DS                  Extname(SDAPIPD)

      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)

      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PRTCD           S              7A
     D POPTN           S              7A
     D PSard           S              6A

      ** Mode of Operation
     D PModeofop       S              6A

      ** Index for arrays of error message ids etc
     D PIdx            S              3P 0

      ** Field (500A) to receive the incoming transaction
     D PTrans500       S            500A

      ** Field (500A) to receive the incoming Extra Data
     D PExtData500     S            500A

      ** Indicies for arrays used to set up corresponding sequence numbers
      ** for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0

      ** Substitution Character
     D PSubsChar       S              1A

      ** Incoming Data
     D PIncDATA        S           2000A

      ** Current Data
     D PCurDATA        S           2000A

      ** Overall Transaction status, to be passed to the Message Handler
     D PTranStatus     S              1A

      ** Whether or not to clear the program message queue
     D PClrPgmMsgQ     S              1A

      ** Module ID, to be passed to the Message Handler
     D PModuleID       S              2A

      ** Work Variables
     D WMQError        S             28A
     D PMQErrLong      S            132A
     D PMQReturn       S             10A

      ** Parameters for APCALCOBJ
     D PObject         S             10A   INZ('SDNATXUPC')
     D PLib            S             10A   INZ('*LIBL')
     D PObjType        S              7A
     D PLockState      S              7A   INZ('*SHRRD')
     D PMember         S             10A
     D PWaitTime       S              6A   INZ('0     ')
     D PDlcobj         S              1A   INZ('Y')
     D PReturn         S              7A

      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D PDummyMsgID     S                   Like(#MsgID)
     D PDummyMsgF      S             10A

      ** Timestamp for the transaction
     D PTimeStamp      S               Z

      ** Midas Transaction ID
     D PTranID         S             20A

     D CSC011          S              1A
     D TransDtl        S           5800A
     D PnahoNum        S             18A
     D PANahoNo        S             18A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

      ** Incoming transaction is in a 500A field, so that a common CLP
      ** can be used between this module and the one that read the MQ queue.
      ** This module needs to break that 500A by loading it into the
      ** appropriate (externally described) data structure.

     C                   EVAL      NwDlScnFmt = PTrans500

      ** Generate a timestamp for this transaction

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimeStamp

      ** Reset variables gradually updated

     C                   EXSR      SRReset

      ** Check if valid record exists for Front Office ID

     C                   EXSR      SRValRec

      ** If valid record does exist (even after delay), fail this input

     C                   IF        PIdx <> 0
     C                   GOTO      INVALID
     C                   END

      ** Transaction Details Data Substitution

     C                   IF        GHSUBS <> *Blanks
     C     GHSUBS        SCAN      NwDlScnFmt                             01
     C                   IF        *IN01 = *On
     C                   EXSR      SRSubsDtas
     C                   ENDIF
     C                   ENDIF

      ** Validate Main Details

     C                   EXSR      SRValDet

     C     INVALID       TAG

      ** Check for exception error from any program lower in the stack
      ** If error detected, send message to system operator and
      ** return to calling program without updating database or
      ** prompting the database update program

     C                   IN        APDUMP

     C                   IF        ARERRMOD <> *Blanks
     C                   EVAL      PMQErrLong = *Blanks
     C                   EVAL      WMQError = ProcErr
     C                   EVAL      WMQError = ARERRMOD
     C                   EVAL      PMQErrLong = WMQError

     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMQReturn
     C                   PARM                    PMQErrLong
     C                   PARM                    PDummyMsgID
     C                   PARM                    PDummyMsgF

     C                   MOVEL     ARERRMOD      APRETCODE
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARERRMOD = *Blanks
     C                   OUT       APDUMP
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ELSE

      ** Processing for Error checking/write to database

     C                   EXSR      SRChkWrite

      ** If valid, send data queue entry to prompt DB update program

     C                   IF        PIdx = 0
     C                   EVAL      PObjType = '*DTAARA'

      ** Check if update program active using Allocate Object API
      ** No prompting necessary if program is running

     C                   CALLB     'APCALCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockState
     C                   PARM                    PMember
     C                   PARM                    PWaitTime
     C                   PARM                    PDlcobj
     C                   PARM      *Blanks       PReturn

     C                   IF        PReturn = *Blanks

      ** Check if any messages are already on the data queue
      ** No need to send duplicate prompt messages

      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.

      /COPY ZACPYSRC,DTAQCHK

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRValRec - Check if valid record exists for Front Office ID   *
      *****************************************************************
     C     SRValRec      BEGSR

      ** Check for front office Id in the valid records file.
      ** Run delay program if record found.

     C     APFOTRANID    CHAIN     SDVNATXL0                          02

      ** If record found...

     C                   IF        *IN02 = *Off

      ** ..delay, then repeat check

     C                   CALLB     'ZACDELAY'

     C     APFOTRANID    CHAIN     SDVNATXL0                          02

      ** Error if still present

     C                   IF        *IN02 = *Off
     C                   ADD       1             PIdx
     C                   EVAL      FldNameArr(PIdx) = 'DDNAHO'
     C                   EVAL      MsgIDArr(PIdx) = 'APM0900'
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRValDet - Validate Main Details                              *
      *****************************************************************
     C     SRValDet      BEGSR

     C                   MOVE      *All'Y'       OkFlags

     C                   CALLB     'SDNATXVAL'

      * Input Parameters :

      ** Return Code
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
      ** New Details in Screen Format
     C                   PARM      *Blanks       RetCodeOut
     C                   PARM                    PModeOfOp
     C                   PARM                    APRESPMODE
     C                   PARM                    NwDlScnFmt

      * Output Parameters :

      ** Screen error indicators
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** New Details in File Format
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    PIdx
     C                   PARM                    NwDlFilFmt

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSubsDtas - Transaction Details Data Substitution            *
      *****************************************************************
     C     SRSubsDtas    BEGSR

      ** Data Substitution

     C                   RESET                   ReturnCode
     C                   CLEAR                   PIncDATA
     C                   CLEAR                   PCurDATA
     C                   CALLB     'APDTASUBS'

      ** Return Code
      ** Substitution character
      ** Incoming Data
      ** Current Data

     C                   PARM                    ReturnCode
     C                   PARM      GHSUBS        PSubsChar
     C                   PARM      NwDlScnFmt    PIncDATA
     C                   PARM      CrDlScnFmt    PCurDATA

     C                   EVAL      NwDlScnFmt = PIncDATA

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRChkWrite  - Controls the checking of error status and       *
      *               sending of messages/writing to the database     *
      *****************************************************************
     C     SRChkWrite    BEGSR

     C                   IF        PIdx = 0

      ** Write to Valid file

     C                   EXSR      SRSetValid

     C                   WRITE     SDVNATXD0
     C                   EXSR      SRCallMsgH

     C                   ENDIF

      ** If Record is invalid

     C                   IF        PIdx > 0
     C                   EXSR      SRSetInval

      ** Only write to invalid files if repair in back office

     C                   IF        APRPRLOCN = 'B'
     C                   WRITE     SDINATXD0
     C                   ENDIF

      ** If support system is active, write invalid transaction to
      ** log file via APLOGTRAN standard module.

     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)

     C                   EVAL      TransDtl = NwDlScnFmt + PExtData500
     C                   EVAL      APTGTTYPE = 'SDNATX'
     C                   EVAL      PNahoNum = NTNaho

     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    PHeadIn
     C                   PARM                    TransDtl
     C                   PARM                    PTimestamp
     C                   PARM                    PNahoNum
     C                   PARM      *BLANKS       PANahoNo

     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      DBKEY = PNahoNum
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 002
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDIF

     C                   EXSR      SRCallMsgH
     C                   ENDIF

     C                   COMMIT

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRReset   - Reset error information that is gradually         *
      *             updated during each run of this program           *
      *****************************************************************
     C     SRReset       BEGSR

     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   PIdx

     C                   RESET                   FldNoArr

     C                   RESET                   OKFlags

     C                   CLEAR                   NwDlFilFmt

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSetInval - Set up Invalid Record                            *
      *****************************************************************
     C     SRSetInval    BEGSR

     C                   EVAL      DDFRNT = APFOTRANID
     C                   EVAL      DDREPA  = APRPRLOCN
     C                   MOVE      PTimeStamp    DDTMST

     C                   EVAL      PTranStatus = 'F'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSetValid - Set up Valid Record                              *
      *****************************************************************
     C     SRSetValid    BEGSR

     C                   EVAL      NTNAHO = DDNAHO
     C                   EVAL      NTCTTX = DDCTTX
     C                   EVAL      NTFRNT = APFOTRANID
     C                   EVAL      NTREPA = APRPRLOCN
     C                   EVAL      NTTMST = PTimeStamp

     C                   EVAL      PTranStatus = 'S'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCallMsgH - Call the Message Handling module                 *
      *****************************************************************
     C     SRCallMsgH    BEGSR

      ** Set up an array of sequence numbers that correspond to the fields
      **  with errors

     C                   Z-ADD     1             Ix
     C                   DO        ArrayMax

     C                   IF        FldNameArr(Ix) <> *Blanks
     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)

     C                   ELSE
     C                   LEAVE
     C                   ENDIF

     C                   ADD       1             Ix
     C                   ENDDO

     C                   RESET                   ReturnCode

     C                   EVAL      PTranID = DDNAHO

     C                   CALLB     'ZAMSGHNDLE'

      ** Return code (10A, returned to this procedure)
      ** Deal repair location (1A, from caller)
      ** Confirm validity to front office (1A, from caller)

     C                   PARM                    ReturnCode
     C                   PARM                    APRPRLOCN
     C                   PARM                    APCNFVALFO

      ** List of messages (Array of <ArrayMax>x7A message ids - from caller )

     C                   PARM                    MsgIDArr

      ** List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
      ** List of field names (Array of <ArrayMax>x10A names - from caller)
      ** List of message data entries (Array of <ArrayMax>x45 - from caller)

     C                   PARM                    FldNoArr
     C                   PARM                    FldNameArr
     C                   PARM                    MsgDtaArr

      ** Front office transaction identifier (20A, from caller)
      ** Midas module ID (2A)
      ** Midas transaction ID (20A, from caller)
      ** Message file (10A, from caller)

     C                   PARM                    APFOTRANID
     C                   PARM                    PModuleID
     C                   PARM                    PTranID
     C                   PARM                    #MsgFile

      ** Action code of transaction (1A, from transaction)
      ** Status of transaction (1A, F=Failure, S=Success)
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))

     C                   PARM                    DDACTN
     C                   PARM                    PTranStatus
     C                   PARM                    APRESPMODE

      ** The following three parameters are needed when messages are to
      ** be displayed on a screen
      ** Screen-handling program (10A, from caller)
      ** Screen-handling module (10A, from caller)
      ** Screen-handling procedure (10A, from caller)

     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName

      ** The MQSeries queue to send replies to
      ** The transaction's timestamp
      ** Additional Message files to check
      ** Whether or not to clear the program message queue.

     C                   PARM                    APRPYQUEUE
     C                   PARM                    PTimeStamp
     C                   PARM                    MsgFArray
     C                   PARM                    PClrPgmMsgQ

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *Entry        PLIST

      ** Common header information (DS) from source system

     C                   PARM                    PHeadIn

      ** Transaction information in a single large field from source system

     C                   PARM                    PTrans500
     C                   PARM                    PExtData500

      ** Ultimate calling Program/Module/Procedure

     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName

      ** Set up the name of the MSGF from which the message handler will
      **  get the messages

     C                   EVAL      #MsgFile = 'SDUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'

      ** Set up the Module ID, used to make the Transaction number unique

     C                   EVAL      PModuleID = 'SD'

      ** Set up the name of the server/database updater data queue.

     C                   EVAL      DtaQName = 'APNATXDTQ'

      ** Access Bank details via access program

     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRTCD <> *Blanks
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access API ICD via access program

     C                   CALLB     'AOAPIR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY

     C                   IF        PRTCD <> *Blanks
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDAPIPD '
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check if CSC011 is installed

     C                   EVAL      CSC011 = 'N'

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

      ** Database error

     C                   IF        (PRtCd <> *BLANKS) and
     C                             (PRtCd <> '*NRF   ')
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SDSTAT
     C                   IN        SC24X7
     C                   ENDIF

      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.

      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************

      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.

     C/COPY ZACPYSRC,PSSR_ILE

      ********************************************************************
      *
**  CPY@
(c) Finastra International Limited 2004
