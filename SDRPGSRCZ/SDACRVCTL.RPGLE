     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Account Review Interface Controller')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDACRVCTL - SD Account Review Interface Controller           *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD092  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD092 - Account Review                                      *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Valid Account Review
     FSDVACRVPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Midas SD Invalid Account Review
     FSDIACRVPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Midas SD Valid Account Review by Front Office ID
     FSDVACRVL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDVACRVD0:SDACRVFOID)
 
      ** ZA Sequence numbbers for input fields
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      /COPY ZACPYSRC,STD_D_SPEC
 
      /COPY ZACPYSRC,PSDS
 
      /COPY ZACPYSRC,PROCPARMS
 
      /COPY ZACPYSRC,ERR_ARRAYS
 
      /COPY ZACPYSRC,APICTLARR
 
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
     D ProcErr         C                   CONST('Error in module')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Incoming Header
     D PHeadIn       E DS                  EXTNAME(APHEADPD)
 
      ** Incoming Details
     D NwArScnFmt    E DS                  EXTNAME(SDACRFPD)
 
     D CrARFilFmt    E DS                  Extname(SDACRVPD)
     D                                     Prefix(C)
 
      ** Valid Details
     D NwArFilFmt    E DS                  EXTNAME(SDVACRVPD)
 
      ** Current Details in Screen Format
     D CrArScnFmt    E DS                  EXTNAME(SDACRFPD)
     D                                     PREFIX(Cr)
 
      ** Error Indicator File
     D OkFlags       E DS                  EXTNAME(SDEACRVPD)
 
      ** First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Define work field Return code
     D W0RTN           S              7
      ** Define work field Work Screen Date
     D WUWSDT          S              6  0
      ** Define work field Date format flag
     D WUDFF           S              1
      ** Define work field Work File Date
     D WUWFDT          S              5  0
 
     D PRTCD           S              7A
     D POPTN           S              7A
 
      ** Mode of Operation
     D PModeofop       S              6A
 
      ** Index for arrays of error message ids etc
     D PIdx            S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Field (500A) to receive the incoming transaction
     D PTrans5001      S            500A
     D PTrans5002      S            500A
 
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
     D PObject         S             10A   INZ('SDACRVUPC')
     D PLib            S             10A   INZ('*LIBL')
     D PObjType        S              7A
     D PLockState      S              7A   INZ('*SHRRD')
     D PMember         S             10A
     D PWaitTime       S              6A   INZ('0     ')
     D PDlcobj         S              1A   INZ('Y')
     D PReturn         S              7A
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D PDummyMsgID     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A
 
      ** Timestamp for the transaction
     D PTimeStamp      S               Z
 
      ** Midas Transaction ID
     D PTranID         S             20A
 
     D PCustNum        S              6A
     D WDCOMP          S              1A
 
     D WWMODE          S              6A
     D WWRSMD          S              1A
     D DDCUSN          S              6A
     D DDSCDT          S              5P 0
     D DDFOID          S             20A
     D OKACTN          S              1A
     D OKCUST          S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EVAL      NwArScnFmt = PTrans5001 + PTrans5002
 
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
     C                   ENDIF
 
      ** Transaction Details Data Substitution
 
     C                   IF        GHSUBS <> *Blanks
     C     GHSUBS        SCAN      NwArScnFmt                             01
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
 
     C                   IF        ARERRMOD <> *BLANK
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
     C                   EVAL      ARERRMOD = *BLANK
     C                   OUT       APDUMP
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
     C                   PARM      *BLANK        PReturn
 
     C                   IF        PReturn = *Blanks
 
      ** Check if any messages are already on the data queue
      ** No need to send duplicate prompt messages
 
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends 'GO'
      ** message to the data queue if there are not.
 
      /COPY ZACPYSRC,DTAQCHK
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValRec - Check if valid record exists for Front Office ID   *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRValRec      BEGSR
 
     C                   MOVE      DDSCDF        WUWSDT
     C                   CALL      'ZDATE1'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUWSDT        PARM                    WUWSDT
     C     WUDFF         PARM      BJDFIN        WUDFF
     C     WUWFDT        PARM      *ZERO         WUWFDT
 
     C                   CALLB     'SDACRVRTV'
 
      ** INPUTS :
      ** Return code
      ** Mode = '*FRONT' (Front Office transaction interface)
      ** Mode = '      ' (Not Front Office transaction interface)
      ** Response mode
      ** Action Code
      ** Account review
      ** Front Office Transaction ID
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      '*FRONT '     WWMODE
     C                   PARM      'S'           WWRSMD
     C                   PARM                    DDACTN
     C                   PARM      DDCUST        DDCUSN
     C                   PARM      WUWFDT        DDSCDT
     C                   PARM                    DDSEQN
     C                   PARM      APFOTRANID    DDFOID
     C                   PARM                    WDCOMP
 
      ** OUTPUTS :
      ** (Current) Account Review in file format
      ** OK - Action code
      ** OK - Customer Reference
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    CrARFilFmt
     C                   PARM      *BLANK        OKACTN
     C                   PARM      *BLANK        OKCUST
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    PIdx
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValDet - Validate Main Details                              *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRValDet      BEGSR
 
     C                   MOVE      *All'Y'       OkFlags
 
     C                   CALLB     'SDACRV1VL'
 
      ** Return Code
     C                   PARM      *BLANK        APRESPMODE
 
      ** New Details in Screen Format
     C                   PARM                    NwArScnFmt
     C                   PARM                    WDCOMP
 
      ** Output Parameters
      ** =================
 
      ** Screen error indicators
     C                   PARM                    OkFlags
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    PIdx
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      ** New Details in File Format
     C                   PARM                    NwArFilFmt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSubsDtas - Transaction Details Data Substitution            *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
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
     C                   PARM      NwArScnFmt    PIncDATA
     C                   PARM      CrArScnFmt    PCurDATA
 
     C                   EVAL      NwArScnFmt = PIncDATA
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkWrite  - Controls the checking of error status and       *
      *               sending of messages/writing to the database     *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls: SRCallMsgH, SRSetInval                                 *
      *                                                               *
      *****************************************************************
 
     C     SRChkWrite    BEGSR
 
     C                   IF        PIdx = 0
 
      ** Write to Valid file
 
     C                   EXSR      SRSetValid
 
     C                   WRITE     SDVACRVD0
     C                   EXSR      SRCallMsgH
 
     C                   ENDIF
 
      ** If Record is invalid
 
     C                   IF        PIdx > 0
     C                   EXSR      SRSetInval
 
      ** Only write to invalid files if repair in back office
 
     C                   IF        APRPRLOCN = 'B'
     C                   WRITE     SDIACRVD0
     C                   ENDIF
 
     C                   EXSR      SRCallMsgH
     C                   ENDIF
 
     C                   COMMIT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReset   - Reset error information that is gradually         *
      *             updated during each run of this program           *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRReset       BEGSR
 
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   PIdx
 
     C                   RESET                   FldNoArr
 
     C                   RESET                   OKFlags
 
     C                   CLEAR                   NwArFilFmt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetInval - Set up Invalid Record                            *
      *                                                               *
      * Called by: SRChkWrite                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRSetInval    BEGSR
 
     C                   EVAL      DDFOTRANID = APFOTRANID
     C                   EVAL      DDRPRLOCN = APRPRLOCN
     C                   MOVE      PTimeStamp    DDTMESTMP
 
     C                   EVAL      PTranStatus = 'F'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetValid - Set up Valid Record                              *
      *                                                               *
      * Called by: SRChkWrite                                         *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRSetValid    BEGSR
 
     C                   IF        DDACTN = 'A'
     C                   MOVE      DDSEQN        AVSEQN
     C                   ENDIF
     C                   EVAL      AVCUST = DDCUST
     C                   EVAL      AVPURP = DDPUR1 + DDPUR2 +
     C                                      DDPUR3 + DDPUR4
 
     C                   EVAL      AVACDT = *ZERO
     C                   IF        DDACDF <> *BLANKS
     C                   MOVE      DDACDF        WUWSDT
     C                   CALL      'ZDATE1'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUWSDT        PARM                    WUWSDT
     C     WUDFF         PARM      BJDFIN        WUDFF
     C     WUWFDT        PARM      *ZERO         WUWFDT
 
     C                   IF        *IN90 = *ON
     C                   EVAL      DBKEY = PCustNum
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        W0RTN = '*ERROR*'
     C                   EVAL      DBKEY = PCustNum
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      WUWFDT        AVACDT
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      AVSCDT = *ZERO
     C                   MOVE      DDSCDF        WUWSDT
     C                   CALL      'ZDATE1'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUWSDT        PARM                    WUWSDT
     C     WUDFF         PARM      BJDFIN        WUDFF
     C     WUWFDT        PARM      *ZERO         WUWFDT
 
     C                   IF        *IN90 = *ON
     C                   EVAL      DBKEY = PCustNum
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        W0RTN = '*ERROR*'
     C                   EVAL      DBKEY = PCustNum
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      WUWFDT        AVSCDT
     C                   ENDIF
 
     C                   EVAL      AVCOMM = DDCOM1 + DDCOM2 +
     C                                      DDCOM3 + DDCOM4
     C                   EVAL      AVACRF = DDACRF
 
     C                   EVAL      AVNSDT = *ZERO
     C                   IF        DDNSDF <> *BLANKS
     C                   MOVE      DDNSDF        WUWSDT
     C                   CALL      'ZDATE1'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUWSDT        PARM                    WUWSDT
     C     WUDFF         PARM      BJDFIN        WUDFF
     C     WUWFDT        PARM      *ZERO         WUWFDT
 
     C                   IF        *IN90 = *ON
     C                   EVAL      DBKEY = PCustNum
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        W0RTN = '*ERROR*'
     C                   EVAL      DBKEY = PCustNum
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      WUWFDT        AVNSDT
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      AVCOMP = DDCOMP
     C                   EVAL      AVMAGE = 'M'
     C                   EVAL      AVLTYP = DDACTN
     C                   MOVE      PTimeStamp    AVTMST
     C                   EVAL      AVLUSR = PSUSER
     C                   EVAL      AVREPA = APRPRLOCN
     C                   EVAL      AVFOID = APFOTRANID
 
     C                   EVAL      PTranStatus = 'S'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCallMsgH - Call the Message Handling module                 *
      *                                                               *
      * Called by: SRChkWrite                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
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
 
     C                   EVAL      PTranID = DDCUST
 
     C                   CALLB     'ZAMSGHNDLE'
 
      ** Return code (10A, returned to this procedure)
      ** Repair location (1A, from caller)
      ** Confirm validity to front office (1A, from caller)
 
     C                   PARM                    ReturnCode
     C                   PARM                    APRPRLOCN
     C                   PARM                    APCNFVALFO
 
     C                   PARM                    MsgIDArr
 
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
      ** Response mode (1A, from caller
      ** (A=Asynchronous, S=Synchronous))
 
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
 
     C     *ENTRY        PLIST
 
      ** Common header information (DS) from source system
 
     C                   PARM                    PHeadIn
 
     C                   PARM                    PTrans5001
     C                   PARM                    PTrans5002
     C                   PARM                    PExtData500
 
      ** Ultimate calling Program/Module/Procedure
 
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      ** Set up the name of the MSGF from which the message handler
      ** will get the messages
 
     C                   EVAL      #MsgFile = 'SDUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'
 
      ** Set up the Module ID, used to make the Transaction
      ** number unique
 
     C                   EVAL      PModuleID = 'SD'
 
      ** Set up the name of the server/database updater data queue.
 
     C                   EVAL      DtaQName = 'APACRVDTQ'
 
      ** Access Bank details via access program
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access API ICD via access program
 
     C                   CALLB     'AOAPIR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDAPIPD '
     C                   Z-ADD     3             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2014
