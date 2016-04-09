     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade settlements interface controller')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRSMCTL - Security Trade Settlements Interface Controller  *
      *                                                               *
      *  Function: This module validates Trade Settlements input      *
      *            into the Midas database.                           *
      *            Processes to be executed controlled by input       *
      *            Action Code:                                       *
      *            - For I (=INSERT) Validate the Trade Settlement    *
      *            - For A (=AMEND),                                  *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *              - if transaction is valid, call a separate       *
      *                function to check whether it is a valid        *
      *                amendment.                                     *
      *                                                               *
      *            For all Action Codes, the decision as to whether   *
      *            to write to the Valid or Invalid file and the call *
      *            to the Message Handler (ZAMSGHNDLE) will take      *
      *            place in this module.                              *
      *                                                               *
      *  Component of: SETRSMCTL                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG3122            Date 17Jul04               *
      *                 CAP182  *CREATE    Date 13Mar03               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CAP182 - Auto Settlement of Trades                           *
      *         - Conversion of SE Trade Settlement Input maintence   *
      *           function to modular structure to use as APIs.       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Use for chaining to file                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRChkValTran  - Routine to check if valid Trade Settlement   *
      *                  record exist for Front Office Id in the      *
      *                  valid Trade Settlement File.                 *
      *  SRChkValMTran - Routine to check if valid Trade Settlement   *
      *                  record exist for key fields in the valid     *
      *                  Trade Settlement file                        *
      *  SRValAction   - Routine to validate key fields supplied      *
      *  SRValDetails  - Routine to validate Trade Settlement details.*
      *  SRCvtTRSM     - Convert Trade Details from file to screen    *
      *                  format.                                      *
      *  SRDtaSubs     - Data Substitution Routine                    *
      *  SRCheckWrite  - Routine to control checking of error status  *
      *                  and sending of messages/writing to the       *
      *                  database                                     *
      *  SRSetValid    - Routine to set up fields in the valid file   *
      *                  record.                                      *
      *  SRSetInvalid  - Routine to set up fields in the invalid file *
      *                  record.                                      *
      *  SRMsgHdl      - Routine to call the message handling module  *
      *  SRResetFld    - Routine to reset fields                      *
      *  *PSSR         - Error processing                             *
      *  *INZSR        - Initialise                                   *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Valid Trades Settlement File
     FSEVTRSMPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Invalid Trades Settlement File
     FSEITRSMPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Valid Trades Settlement by front office Id
     FSEVTRSML0 IF   E           K DISK    RENAME(SEVTRSMD0:SEVTRSMCHK)
      *
      ** Valid Trades Settlement by key fields and timestamp
     FSEVTRSML1 IF   E           K DISK    RENAME(SEVTRSMD0:SEVTRSMCHM)
      *
      ** Sequence number for input fields
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *
      ** Midas Module Flag file
     FMMODF     IF   E             DISK    INFSR(*PSSR)
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SETRSMC001
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes definition  for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
      *
      /COPY ZACPYSRC,PROCPARMS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
      *
      /COPY ZACPYSRC,APICTLARR
      *
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
      *
      /COPY ZACPYSRC,DTAQCHKDCL
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
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
      ** String for error messages to the operator
     D WProcErr        C                   CONST('Error in module')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Message header details
     D PHeadIn       E DS                  EXTNAME(APHEADPD)
      *
      ** SE Trades Settlement Screen details from incoming transaction -
      ** - screen format
     D NwTS1ScnFmt   E DS                  EXTNAME(SETRSMPD)
      *
      ** SE Trades Settlement for file update - file format
     D NwTSFilFmt    E DS                  EXTNAME(SEVTRSMPD)
      *
      ** SE Trades Settlement Screen details retrieved from file
      ** - screen format
     D CrTS1ScnFmt   E DS                  EXTNAME(SETRSMPD)
     D                                     PREFIX(O)
      *
      ** SE Trade Details information retrieved from file - file format
     D CrTDFilFmt    E DS                  EXTNAME(TRADS)
      *
      ** SE Trades Settlement Screen error indicators
     D SEETRSM       E DS                  EXTNAME(SEETRSMPD)
      *
      ** Externally described DS for security details
     D PSectyd       E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(SE_)
      *
      ** Externally described DS for API ICD details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Externally described DS for securities trading icd details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SLCD          E                     EXTFLD(LCD)
      *
      ** Externally described DS for Securities Customers
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      *
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10
     D  PDBRN                 11     13
     D  PDPPT                 14     16
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  RecNotFnd             01     01
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error messages
     D IDx             S              3P 0
      *
      ** Index for arrays of warning messages
     D WIDx            S              3P 0
      *
      ** Pointer for the indicator array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** Indices for arrays used to set up corresponding sequence numbers
      ** for the fields that are in error
     D W1              S              3P 0
     D W2              S              3P 0
      *
      ** Index for arrays of error message Ids in amend validation
     D AMIDx           S              3P 0
      *
      ** Fields (500A) to receive the incoming transaction
     D PTrans5001      S            500A
      *
      ** Parametes for data substitution program.
     D PIncData        S           2000A
     D PCurData        S           2000A
      *
      ** Field (500A) to receive the incoming extra data
     D PExtData500     S            500A
      *
      ** Timestamp for the transaction
     D PTimestamp      S               Z
      *
      ** Fields to be used on call to module APCALOBJ (Allocate Object API)
     D PObject         S             10A   INZ('SETRSMUPC')
     D PLib            S             10A   INZ('*LIBL')
     D PObjType        S              7A
     D PLockState      S              7A   INZ('*SHRRD')
     D PMember         S             10A
     D PWaitTime       S              6A   INZ('0     ')
     D PDlcObj         S              1A   INZ('Y')
     D PReturn         S              7A
      *
      ** Module Id to be passed to the message handler
     D PModuleId       S              2A   INZ('SE')
      *
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list)
     D PClrPgmMsgQ     S              1A   INZ('Y')
      *
      ** Overall Transaction status, to be passed to the message handler
     D PTranStatus     S              1A
      *
      ** Dummy message Id and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D PDummyMsgId     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     D PMode           S              6A
      *
      ** Work parameters
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D PTranID         S             20A
     D PResetFld       S              1A
     D PAmendOk        S              1A
     D PMQReturn       S             10A
     D PMQErrLong      S            132A
     D KMVDT           S              5P 0
     D PPayCcy         S              3A
     D PPROT           S              1A
     D PSSEQN          S              3  0
      *
      ** Switchable features
     D CSE007          S              1A
     D CEU017          S              1A
      *
      ** Redisplay screen flag
     D PReDsp          S              1A
      *
      ** Edit mode
     D PEdtFld         S              1A
      *
      ** Work variables
     D WSubDE1         S              1A
     D WMQError        S             28A
     D DDACTN          S              1A
      *
      ** Parameters for ZDATE1
     D PDateAIn        S              6A
     D PDayNoOut       S              5P 0
     D PErrorFlag      S              1A
      *
      ** Parameters for AOCURRR0
     D PCyCd           S              3A
      *
     D PSCnum          S              6A
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,SETRSMC002
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      /COPY WNCPYSRC,SETRSMC003
      *
      ** Incoming transaction is in 500A fields, so that a common
      ** CLP can be used between this module and the one that
      ** read the MQ queue.  Break the 500A data by loading
      ** them into the appropriate (externally-described)
      ** data structures.
      *
     C                   MOVEL     PTrans5001    NwTS1ScnFmt
      *
      ** Generate a timestamp for this transaction.
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimestamp
      *
      ** Reset fields.
      *
     C                   EXSR      SrResetFld
      *
      /COPY WNCPYSRC,SETRSMC004
      *
      ** Check if valid Trade Settlement details exists for front office Id
      ** in the valid records file.
      *
     C                   EXSR      SrChkValTran
      *
      ** If valid Trade Settlement does exist even after delay,
      ** fail this input.
      *
     C                   IF        IDx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
      *
      ** Check if valid Trade Settlement exist for the key fileds,
      *
     C                   EXSR      SrChkValMTran
      *
      ** If valid Trade Settlement record does exist even after delay,
      ** fail this input.
      *
     C                   IF        IDx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
      *
      ** Reset fields again in case the details have been corrupted
      ** by previous chain to valid Trade Settlement file.
      *
     C                   EXSR      SrResetFld
      *
      /COPY WNCPYSRC,SETRSMC005
      *
      ** Validate Key fields.
      *
     C                   EXSR      SrValAction
      *
      /COPY WNCPYSRC,SETRSMC006
      *
      ** If errors occurred in the initial validation, fail this input.
      *
     C                   IF        IDx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
      *
      /COPY WNCPYSRC,SETRSMC007
      *
      ** Convert Trade Details from file to screen format
      *
     C                   EXSR      SrCvtTRSM
      *
      /COPY WNCPYSRC,SETRSMC008
      *
      ** Check for the existence of the replacement character; if this is
      ** used, only the changed data has been sent, and all occurrences of
      ** the replacement character must be replaced with the corresponding
      ** character from the original transaction.
      *
     C                   IF        GHSUBS <> *BLANK
 
     C     GHSUBS        SCAN      NwTS1ScnFmt                            99
     C                   IF        *IN99
     C                   MOVE      'Y'           WSubDE1
     C                   ELSE
     C                   MOVE      'N'           WSubDE1
     C                   ENDIF
      *
      ** Do data substitution.
      *
     C                   IF        WSubDE1 = 'Y'
     C                   EXSR      SrDtaSubs
     C                   ENDIF
 
     C                   ENDIF
      *
      /COPY WNCPYSRC,SETRSMC009
      *
      ** Validate incoming Trade Settlement details.
      *
     C                   EXSR      SrValDetails
      *
      /COPY WNCPYSRC,SETRSMC010
      *
     C     INVALID       TAG
      *
      ** Check for exception error from any program lower in the stack.
      ** If error detected, send message to system operator and
      ** return to calling program without updating database or
      ** prompting the database update program.
      *
     C                   IN        APDUMP
      *
      /COPY WNCPYSRC,SETRSMC011
      *
     C                   IF        ARErrMod <> *BLANK
 
     C                   EVAL      PMQErrLong = *BLANK
     C                   MOVEL     WProcErr      WMQError
     C                   MOVE      ARErrMod      WMQError
     C                   MOVEL     WMQError      PMQErrLong
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMQReturn
     C                   PARM                    PMQErrLong
     C                   PARM                    PDummyMsgId
     C                   PARM                    PDummyMsgF
 
     C                   MOVEL     ARErrMod      APRetCode
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARErrMod = *BLANK
     C                   OUT       APDUMP
     C                   RETURN
 
     C                   ELSE
      *
      ** Processing for error checking/write to database.
      *
      /COPY WNCPYSRC,SETRSMC012
 
     C                   EXSR      SrCheckWrite
 
      /COPY WNCPYSRC,SETRSMC013
      *
      ** If valid, send data queue entry to prompt DB update program.
      *
     C                   IF        IDx = 0
     C                   EVAL      PObjType = '*DTAARA'
      *
      ** Check if update program active using Allocate Object API.
      ** No prompting necessary if program is running.
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockState
     C                   PARM                    PMember
     C                   PARM                    PWaitTime
     C                   PARM                    PDlcObj
     C                   PARM      *BLANK        PReturn
 
     C                   IF        PReturn = *BLANK
      *
      ** Check if any messages are already on the data queue.
      ** No need to send duplicate prompt messages.
      *
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'
      ** message to the data queue if there are not.
      *
      /COPY ZACPYSRC,DTAQCHK
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,SETRSMC014
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChkValTran - Routine to check if valid Trade Settlements   *
      *                 record exist for Front Office Id in the       *
      *                 valid Trade Settlements file.                 *
      *                                                               *
      *****************************************************************
      *
     C     SrChkValTran  BEGSR
      *
      ** Check for front office Id in the valid records file.
      ** Run delay program if record found.
      *
     C     APFOTRANID    CHAIN     SEVTRSML0                          01
 
     C                   IF        RecNotFnd = False
      *
      ** Run delay program, then repeat chain.
     C                   CALLB     'ZACDELAY'
 
     C     APFOTRANID    CHAIN     SEVTRSML0                          01
      *
      ** Error if front office Id is still present.
     C                   IF        RecNotFnd = False
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDTRDR'
     C                   EVAL      MsgIDArr(IDx)   = 'APM0900'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChkValMTran - Routine to check if valid Trade Settlement   *
      *                  record exist for key fields in the valid     *
      *                  Trade Settlement Detail File.                *
      *                                                               *
      *****************************************************************
      *
     C     SrChkValMTran BEGSR
      *
      ** Convert event date into numeric format.
      *
     C                   IF        DDMVDT <> '999999'
     C                   EVAL      PDateAIn = DDMVDT
     C                   Exsr      SrZDate1
     C                   IF        PErrorFlag = 'N'
     C                   Z-ADD     PDaynoOut     KMVDT
     C                   ENDIF
 
     C                   ELSE
     C                   Z-ADD     99999         KMVDT
     C                   ENDIF
      *
      ** Check for midas Trade Number, Movement Date, Full Settlement and
      ** Reversal Indicator in the valid record file.
      ** Run delay program if record not found.
      *
     C     KeyTRSM       CHAIN     SEVTRSML1                          01
 
     C                   IF        RecNotFnd = False
      *
      ** Run delay program, then repeat chain.
     C                   CALLB     'ZACDELAY'
 
     C     KeyTRSM       CHAIN     SEVTRSML1                          01
      *
      ** Error if midas back office reference is still present.
     C                   IF        RecNotFnd = False
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDTRDR'
     C                   EVAL      MsgIDArr(IDx) = 'APM0900'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValAction - Routine to validate the supplied key field     *
      *              - The remainning trade details are also          *
      *                retrieve during the validation process         *
      *                                                               *
      *****************************************************************
     C     SrValAction   BEGSR
      *
      ** Record can only be output to the Trade Settlement file. So the
      *  action code is always 'I'.
      ** If insert, set retrieve mode to '*FRONT' (Access using Front
      ** Office Id).
      *
     C                   IF        DDACTN = 'I'
     C                   EVAL      PMode = '*FRONT'
     C                   ELSE
 
     C                   IF        DDTRDR = *BLANK
     C                             AND DDMVDT = *BLANK
     C                             AND DDFSET = *BLANK
     C                             AND DDREVE = *BLANK
     C                   EVAL      PMode = '*FRONT'
     C                   ELSE
     C                   EVAL      PMode = *BLANKS
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate key fields
     C                   EVAL      PEdtFld = 'Y'
      *
     C                   CALLB     'SETRSMRTV'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Retun code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Response mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    APRESPMODE
      *
      ** Front office transaction identifier (20A from caller)
     C                   PARM                    APFOTRANID
      *
      *
      ** Trade Reference
     C                   PARM                    DDTRDR
      *
      ** Movement Date
     C                   PARM                    DDMVDT
      *
      ** Full Settlement
     C                   PARM                    DDFSET
      *
      ** Reversal
     C                   PARM                    DDREVE
      *
      ** Enable detail fields indicator
     C                   PARM                    PEDtFld
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single branch code
     C                   PARM                    BJSBRC
      *
      ** SDBANK - Run day number
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** ZMUSER - Default branch
     C                   PARM                    PDBRN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** OK Trade Reference
     C                   PARM                    OKTRDR
      *
      ** OK Movement Date
     C                   PARM                    OKMVDT
      *
      ** OK Full Settlement
     C                   PARM                    OKFSET
      *
      ** OK Reversal
     C                   PARM                    OKREVE
      *
      ** Security Trade Details retrieved from file - file format
     C                   PARM                    CrTDFilFmt
      *
      ** Externally described DS for Security details
     C                   PARM                    PSectyd
      *
 
      ** For the rest of the processing, set Mode of Operation
      ** to '*FRONT' for the other modules to process the
      ** transaction as coming from an external system.
      *
     C                   MOVEL     '*FRONT'      PMode
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValDetails - Validate main details screen                  *
      *                                                               *
      *****************************************************************
     C     SrValDetails  BEGSR
 
     C                   CLEAR                   NwTSFilFmt
 
      ** Validate entries made on the screen.
     C                   CALLB     'SETRSMVAL'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Response mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    APRESPMODE
      *
      ** SE Trade Settlement screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwTS1ScnFmt
      *
      ** SE Trade Details retrieved from file - file format
     C                   PARM                    CrTDFilFmt
      *
      ** Externally described DS for Security details
     C                   PARM                    PSectyd
      *
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Corporate Action
     C                   PARM                    CSE007
      *
      ** Security Redenomination Euro Changes
     C                   PARM                    CEU017
      *
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** Error indicators
     C                   PARM                    SEETRSM
      *
      ** SE Trade Settlement details for file update - file format
     C                   PARM                    NwTSFilFmt
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCvtTRSM - Converts Security Trade Settlement details from  *
      *              file to screen format.                           *
      *                                                               *
      *****************************************************************
     C     SrCvtTRSM     BEGSR
 
     C                   CALLB     'SETRSMCVT'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Retun code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Enable detail fields indicator
     C                   PARM                    PEdtFld
      *
      ** SE Trade Details retrieved from file - file format
     C                   PARM                    CrTDFilFmt
      *
      ** Externally described DS for Security details
     C                   PARM                    PSectyd
      *
      ** Trade Number
      ** Movement Date
      ** Full Settlement
      ** Reversal
      ** Settlement Sequence Number
     C                   PARM                    DDTRDR
     C                   PARM                    DDMVDT
     C                   PARM                    DDFSET
     C                   PARM                    DDREVE
     C                   PARM                    PSSEQN
      *
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** OUTPUT
      ** ======
      *
      ** SE Trade Settlement screen details from incoming transaction
      ** - screen format
     C                   PARM                    CrTS1ScnFmt
      *
      ** Save all data that are incoming.
     C                   If        DDNOMS <> *BLANKS
     C                   Eval      ODDNOMS = DDNOMS
     C                   EndIF
     C                   If        DDVALS <> *BLANKS
     C                   Eval      ODDVALS = DDVALS
     C                   EndIF
      *
     C                   Eval      ODDSREF = DDSREF
     C                   Eval      ODDNARR = DDNARR
     C                   Eval      ODDNOTM = DDNOTM
     C                   Eval      ODDMSGK = DDMSGK
      *
     C                   Eval      NwTS1ScnFmt = CrTS1ScnFmt
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDtaSubs - Data Substitution Routine                        *
      *                                                               *
      *****************************************************************
      *
     C     SrDtaSubs     BEGSR
      *
      ** Substitute the data for the various parts of the transaction.
      *
     C                   IF        WSUBDE1 = 'Y'
     C                   CLEAR                   PIncData
     C                   CLEAR                   PCurData
 
     C                   CALLB     'APDTASUBS'
      *                             =========
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Substitution character
     C                   PARM                    GHSUBS
      *
      ** Incoming data
     C                   PARM      NwTS1ScnFmt   PIncData
      *
      ** Current data
     C                   PARM      CrTS1ScnFmt   PCurData
 
     C                   MOVEL     PIncData      NwTS1ScnFmt
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCheckWrite - Routine to control checking of error status   *
      *                 and sending of messages/writing to the        *
      *                 database                                      *
      *                                                               *
      *****************************************************************
      *
     C     SrCheckWrite  BEGSR
      *
      ** If no errors were found:
      ** - set up additional data
      ** - write a record to the Valid Records file
      ** - use std message handler to report transaction status
      ** If any errors were found:
      ** - set up additional data
      ** - write a record to the Invalid Records file
      ** - call the message handler to pass the errors back
      ** - use std message handler to report transaction status
      ** The index to the error arrays is checked for presence/absence of
      ** errors.
      *
      ** +--- Note for a later release -------------------------------+
      ** |                                                            |
      ** | At a later date, this routine will have to cater for       |
      ** | warning messages.  The following logic will have to be     |
      ** | inserted before "If no errors were found", in the          |
      ** | above comments (and the code):                             |
      ** |                                                            |
      ** | If 'Ignore warning messages' (from API ICD) is 'N', AND    |
      ** | any warning messages were returned (WIDx <> 0)             |
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
      ** | can probably be implemented unconditionally (i.e. the same |
      ** | logic will apply whether errors exist as well as warnings  |
      ** | or not).  It is shown in the above form for clarity.       |
      ** |                                                            |
      ** +------------------------------------------------------------+
      *
     C     IDx           IFEQ      0
     C                   EXSR      SrSetValid
     C                   WRITE     SEVTRSMD0
     C                   EXSR      SRMsgHdl
     C                   ENDIF
 
     C     IDx           IFGT      0
     C                   EXSR      SrSetInvalid
      *
      ** Only write to invalid file if repair in back office.
     C     APRPRLOCN     IFEQ      'B'
     C                   WRITE     SEITRSMD0
     C                   ENDIF
 
     C                   EXSR      SrMsgHdl
     C                   ENDIF
 
     C                   COMMIT
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSetValid - Routine to set up fields in the valid file      *
      *               record.                                         *
      *                                                               *
      *****************************************************************
      *
     C     SrSetValid    BEGSR
      *
      ** Action is insert.
      ** =================
      *
      ** Update all the remainig data required for file SETLED
      *
     C                   Eval      VTSRECI = 'D'
      *
      ** Trade Reference
     C                   Eval      VTSSTDR = DDTRDR
      *
      ** Settlement Sequence
     C     TSSQ          Add       1             VTSSSQN
      *
      ** Branch Code
     C                   Eval      VTSSBCA = DDBRCD
      *
      ** Movement Date
     C                   Eval      PDateAIn = DDMVDT
     C                   Exsr      SrZDate1
     C                   If        PErrorFlag = 'N'
     C                   Z-Add     PDaynoOut     VTSSEDE
     C                   EndIf
      *
      ** Settlement Indicator
     C                   If        DDFSET = *Blanks
     C                   Eval      VTSSFSI = 'N'
     C                   Else
     C                   Eval      VTSSFSI = DDFSET
     C                   EndIf
      *
      ** Reversal Indicator
     C                   If        DDREVR = *Blanks
     C                   Eval      VTSSRIN = 'N'
     C                   Else
     C                   Eval      VTSSRIN = DDREVR
     C                   EndIf
      *
      ** Reported on Security Ledger
     C                   Eval      VTSSRSL = *Blanks
      *
      ** Value Fully Settled Indicator
     C                   Select
     C     TOSV          WhenGt    0
     C                   Eval      VTSSFSL = 'P'
     C     TOSV          WhenLt    0
     C                   Eval      VTSSFSL = 'O'
     C     TOSV          Wheneq    0
     C                   Eval      VTSSFSL = 'F'
     C                   Endsl
      *
      ** Nominal fully settled indicator
     C                   Select
     C     TOSN          WhenGt    0
     C                   Eval      VTSSNFS = 'P'
     C     TOSN          WhenLt    0
     C                   Eval      VTSSNFS = 'O'
     C     TOSN          Wheneq    0
     C                   Eval      VTSSNFS = 'F'
     C                   Endsl
      *
      ** Over-settlement indicator
     C                   If        TOSV < 0
     C                   Eval      VTSSOSI = 'Y'
     C                   Else
     C                   Eval      VTSSOSI = *Blanks
     C                   EndIf
      *
      ** Discrepancy amount
     C                   If        DDFSET = 'Y'
     C                   Eval      PCyCd = SETC
     C                   Exsr      SrAOCurr
     C                   Z-Add     A6NBDP        ZCDPO
     C                   Eval      PCyCd = TNMC
     C                   Exsr      SrAOCurr
     C                   Z-Add     A6NBDP        ZCDPI
     C                   Z-Add     TCTR          ZAMTCI
     C                   Z-Add     TDER          ZEXCH
     C                   Move      TMDI          ZMD
     C                   Move      TNMC          ZCCYI
     C                   Move      SETC          ZCCYO
     C                   Exsr      SrZconv
     C     TVSN          Add       TVSP          WValSet          15 0
     C     WValSet       Add       TOSV          TotalValSet      15 0
     C     TotalValSet   Sub       ZAMTCO        VTSSDAM
     C                   Else
     C                   Z-Add     0             VTSSDAM
     C                   EndIf
      *
      ** Discrepancy indicator
     C                   If        VTSSDAM <> *Zeros
     C                   Eval      VTSSDSI = 'Y'
     C                   Else
     C                   Eval      VTSSDSI = ' '
     C                   EndIf
      *
      ** Security shortname
     C                   Move      TDSS          VTSSSSN
      ** Counterparty number
     C                   Move      TCNR          VTSSCPN
      ** Market indicator
     C                   Move      TDMI          VTSSMKI
      ** Trade type
     C                   Move      TDTP          VTSSTET
      ** Settlement currency
     C                   Move      SETC          VTSSSCY
      ** Book Code
     C                   Move      TDBK          VTSSBOC
      ** Auto-Settled
     C                   Move      AUTS          VTSAUTS
      ** Last Change Date
     C                   Z-Add     BJRDNB        VTSLCD
      ** Change Type
     C                   Move      'I'           VTSCHTP
      *
      ** Process Agency
     C                   Eval      VTSSPAG = *Blanks
      *
      ** Access Securities Clients Details
     C                   If        DDFSET = 'Y'
     C                             Or DDREVR = 'Y' and TDFS <> 0
     C                   Move      TCNR          PSCnum
     C                   CallB     'AOSECSR0'
     C                   Parm      *BLANKS       PRtcd
     C                   Parm      '*KEY'        POptn
     C                   Parm                    PSCnum
     C     SDSECS        Parm      SDSECS        DSSDY
     C                   If        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   Eval      DBKey = POptn
     C                   Eval      DBFile= 'SDSECSPD'
     C                   Eval      DBase = 005
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   EndIf
      *
     C                   If        BFCLAS = 'M'
     C                   If        ORDE <> *Zeros And ORDE <> 999999
     C                             Or ATRD = 'M'
     C                   If        DDFSET = 'Y'
     C                   Eval      VTSSPAG = 'P'
     C                   Endif
     C                   If        DDREVR = 'Y' and TDFS <> 0
     C                   Eval      VTSSPAG = 'R'
     C                   Endif
     C                   Endif
     C                   Endif
      *
     C                   Endif
      *
      ** Notification Method
     C                   Eval      VTSNOTM = DDNOTM
      *
      ** Message Key
     C                   Eval      VTSMSGK = DDMSGK
      *
      ** Message header details.
     C                   EVAL      VTSFRNT = APFOTRANID
     C                   EVAL      VTSREPA = APRPRLOCN
     C                   EVAL      VTSTMST = PTimestamp
      *
      ** Master files will be updated.
      *
     C                   EVAL      PTranStatus = 'S'
      *
      /COPY WNCPYSRC,SETRSMC015
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSetInvalid - Routine to set up fields in the invalid file  *
      *                 record.                                       *
      *                                                               *
      *****************************************************************
      *
     C     SrSetInvalid  BEGSR
      *
     C                   EVAL      DDFRNT = APFOTRANID
     C                   EVAL      DDREPA = APRPRLOCN
     C                   EVAL      DDTMST = PTimestamp
      *
      ** Transaction needs to be repaired.
      *
     C                   EVAL      PTranStatus = 'F'
      *
      /COPY WNCPYSRC,SETRSMC016
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrMsgHdl - Routine to call the message handling module       *
      *                                                               *
      *****************************************************************
      *
     C     SrMsgHdl      BEGSR
      *
      ** Set up an array of sequence numbers that correspond to the
      ** fields with errors.
      *
     C                   Z-ADD     1             W1
 
     C                   DO        ArrayMax
 
     C                   IF        FldNameArr(W1) <> *BLANKS
     C                   Z-ADD     1             W2
     C     FldNameArr(W1)LOOKUP    FieldArr(W2)                           02
     C                   EVAL      FldNoArr(W1) = FldSeqArr(W2)
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
 
     C                   ADD       1             W1
 
     C                   ENDDO
 
     C                   EVAL      PTranID = DDTRDR + DDMVDT + DDFSET +
     C                                       DDREVE
 
     C                   CALLB     'ZAMSGHNDLE'
      *
      ** Return code (10A, returned to this procedure)
     C                   PARM      *BLANK        ReturnCode
      *
      ** Repair location (1A, from caller)
     C                   PARM                    APRPRLOCN
      *
      ** Confirm validity to front office (1A, from caller)
     C                   PARM                    APCNFVALFO
      *
      ** List of messages (array of message Ids - from caller)
     C                   PARM                    MsgIDArr
      *
      ** List of field numbers (array of unsigned int. from caller)
     C                   PARM                    FldNoArr
      *
      ** List of field names (array of fields names from caller)
     C                   PARM                    FldNameArr
      *
      ** List of message data Entries (Array of <ArrayMax>x45 - from caller)
     C                   PARM                    MsgDtaArr
      *
      ** Front office transaction identifier (20A from caller)
     C                   PARM                    APFOTRANID
      *
      ** Midas module Id (2A)
     C                   PARM                    PModuleId
      *
      ** Midas transaction Id (20A, from caller)
     C                   PARM                    PTranID
      *
      ** Message file (10A, from caller)
     C                   PARM                    #MSGFILE
      *
      ** Action code of transaction (1A, from transaction)
     C                   PARM                    DDACTN
      *
      ** Status of transaction (1A, F=Failure, S=Success)
     C                   PARM                    PTranStatus
      *
      ** Response mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    APRESPMODE
      *
      ** The following three parameters are needed when messages are
      ** to be displayed on a screen
      *
      ** Screen-handling program (10A, from caller)
     C                   PARM                    #ProcPgm
      *
      ** Screen-handling module (10A, from caller)
     C                   PARM                    #ProcMod
      *
      ** Screen-handling procedure (10A, from caller)
     C                   PARM                    #ProcName
      *
      ** The MQ series queue to send replies to
     C                   PARM                    APRPYQUEUE
      *
      ** The transaction's timestamp
     C                   PARM                    PTimestamp
      *
      ** Additional message files to Check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MSGFARRAY
      *
      ** Whether or not clear the program message queue (1A)
     C                   PARM                    PClrPgmMsgQ
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrResetFld - Routine to reset fields                         *
      *                                                               *
      *****************************************************************
     C     SrResetFld    BEGSR
 
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIdArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   IDx
 
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIdArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIDx
 
     C                   RESET                   AMFldNamAr
     C                   RESET                   AMMsgIdArr
     C                   RESET                   AMMsgDtaAr
     C                   RESET                   AMIDx
 
     C                   RESET                   FldNoArr
 
     C                   MOVE      *ALL'Y'       SEETRSM
 
     C                   CLEAR                   CrTS1ScnFmt
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAOCurr - Check currency details                            *
      *                                                               *
      *****************************************************************
     C     SrAOCurr      BEGSR
 
     C                   CallB     'AOCURRR0'
     C                   Parm      *BLANKS       PRtCd
     C                   Parm      '*KEY   '     POptn
     C                   Parm                    PCyCd
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   If        PRtCd <> *BLANKS
     C                   Eval      DBKey = PCyCd
     C                   Eval      DBFile = 'SDCURRPD'
     C                   Z-Add     1             DBASE
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZconv - Convert an amount from one currency to another     *
      *                                                               *
      *****************************************************************
     C     SrZconv       Begsr
 
     C                   CallB     'ZCONV'
     C                   Parm                    ZAMTCI           15 0
     C                   Parm                    ZEXCH            13 8
     C                   Parm                    ZMD               1
     C                   Parm                    ZCCYI             3
     C                   Parm                    ZCCYO             3
     C                   Parm                    ZCDPI             1 0
     C                   Parm                    ZCDPO             1 0
     C                   Parm                    ZAMTCO           15 0
      *
     C                   Endsr
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZDate1 - Validate and convert date to day number           *
      *                                                               *
      *****************************************************************
     C     SrZDate1      BEGSR
      *
     C                   CallB     'ZDATE1'
     C                   Parm                    PDateAIn
     C                   Parm      *ZERO         PDaynoOut
     C                   Parm                    BJDFIN
     C                   Parm      *Blanks       PErrorFlag
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Message header details
     C                   PARM                    PHeadIn
      *
      ** Incoming transaction details
     C                   PARM                    PTrans5001
      *
      ** Incoming transaction extra data
     C                   PARM                    PExtData500
      *
      ** Program details
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
      *
      ** Set up the name of the module Id used to make the transaction
      ** number unique.
      *
     C                   EVAL      PModuleId = 'SE'
      *
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages.
      *
     C                   EVAL      #MSGFILE     = 'SEUSRMSG'
     C                   EVAL      MSGFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'
      *
      ** Set up the name of the server/database updater data queue.
      *
     C                   EVAL      DTAQNAME = 'APTRSMDTQ'
      *
      ** Access bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access API ICD details.
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Database error.
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDAPIPD'
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR file to determine if 'Corporate Actions' feature
      ** is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE007'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtcd = *BLANKS
     C                   MOVEL     'Y'           CSE007
     C                   ELSE
     C                   MOVEL     'N'           CSE007
     C                   ENDIF
      *
      ** Access SAR file to determine if 'Securities Redenomination'
      ** feature is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CEU017'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRtcd = *BLANKS
     C                   MOVEL     'Y'           CEU017
     C                   ELSE
     C                   MOVEL     'N'           CEU017
     C                   ENDIF
      *
      ** Retrieve ICD for securities trading.
     C                   CALLB     'AOSTRDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** Database error.
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDSTRDPD'
     C                   Z-ADD     6             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve Midas Module Flag details
      *
     C                   READ      MMODF                                  01
      *
      ** Retrieve ZMUSER details.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
      ** Record can only be output to the Trade Settlement file, so set
      *  action code to 'I'
     C                   EVAL      DDACTN = 'I'
      *
      ** Key fields for LF/SETRSM
     C     KeyTRSM       KLIST
     C                   KFLD                    DDTRDR
     C                   KFLD                    KMVDT
     C                   KFLD                    DDFSET
     C                   KFLD                    DDREVE
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,SETRSMC017
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
