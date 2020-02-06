     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Security diary events interface cntroller')   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESEDECTL - Security Diary Events Interface Controller       *
      *                                                               *
      *  Function: This module validates Security Diary Events input  *
      *            into the Midas database.                           *
      *            Processes to be executed controlled by input       *
      *            Action Code:                                       *
      *            - For I (=INSERT) or A (=AMEND), validate the      *
      *              Security Diary Events.                           *
      *            - For A (=AMEND),                                  *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *              - if transaction is valid, call a separate       *
      *                function to check whether it is a valid        *
      *                amendment.                                     *
      *            - For D (=DELETE) and E (=Enquire), call a         *
      *              seperate function to process the transaction and *
      *              bypass the rest of the validation.               *
      *                                                               *
      *            For all Action Codes, the decision as to whether   *
      *            to write to the Valid or Invalid file and the call *
      *            to the Message Handler (ZAMSGHNDLE) will take      *
      *            place in this module.                              *
      *                                                               *
      *  Component of: SESEDECTL                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE065             Date 06Dec04               *
      *                 CSE071             Date 19Jul05               *
      *                 CSE072             Date 05Apr05               *
      *                 BUG2064            Date 29May04               *
      *                 BUG2604            Date 18May04               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 09Nov01               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      *                 CAP140  *CREATE    Date 17Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSE072 - INT-CC3 - Brazilian C-Bonds                         *
      *  BUG2064 - Initialization of CSC022.                          *
      *  BUG2604 - Commitment Control Changes for MidasPlus. (CSC022) *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CSE031 - Coupon Fixing for Floating Rate Notes               *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
      *           modular structure to use as APIs.                   *
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
      *  SRChkValTran - Routine to check if valid security diary      *
      *                 events exist for Front Office Id in the       *
      *                 valid security diary events file.             *
      *  SRChkValMTran - Routine to check if valid security diary     *
      *                  events exist for security shortname, event   *
      *                  date and event type in the valid security    *
      *                  diary events file.                           *
      *  SRValAction - Routine to validate Action Code for the        *
      *                security shortname, event date and event type  *
      *                supplied                                       *
      *  SRValDetails - Routine to validate Security Diary Events Det.*
      *  SRDefault1 - Defaulting for screen 1                         *
      *  SRVScrn1  - Validate screen 1 details                        *
      *  SRCvtSeDE - Convert security diary events details from file  *
      *              to screen format                                 *
      *  SRDtaSubs - Data Substitution Routine                        *
      *  SRValAmend - Routine to check whether the fields are         *
      *               amendable                                       *
      *  SRCheckWrite - Routine to control checking of error status   *
      *                 and sending of messages/writing to the        *
      *                 database                                      *
      *  SRSetValid - Routine to set up fields in the valid file      *
      *               record.                                         *
      *  SRSetInvalid - Routine to set up fields in the invalid file  *
      *                 record.                                       *
      *  SRMsgHdl - Routine to call the message handling module       *
      *  SRResetFld - Routine to reset fields                         *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
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
      ** Valid security diary events
     FSEVSEDEPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Invalid security diary events
     FSEISEDEPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Valid security diary events by front office Id
     FSEVSEDEL0 IF   E           K DISK    RENAME(SEVSEDED0:SEVSEDECHK)
      *
      ** Valid security diary events by key fields and timestamp
     FSEVSEDEL1 IF   E           K DISK    RENAME(SEVSEDED0:SEVSEDECHM)
      *
      ** Sequence number for input fields
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *
      ** Midas Module Flag file
     FMMODF     IF   E             DISK    INFSR(*PSSR)
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SESEDEC001
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
      * Array to hold Commitment Job Names                                                   BUG2604
     D CmtJobNArr      S             10A   DIM(10)                                           BUG2604
                                                                                             BUG2604
      ** Commitment Control Data Area                                                        BUG2604
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                BUG2604
     D  wComitJob              4    103                                                      BUG2604
                                                                                             BUG2604
      ** Message header details
     D PHeadIn       E DS                  EXTNAME(APHEADPD)
      *
      ** SE Diary Events Screen details from incoming transaction -
      ** - screen format
     D NwDE1ScnFmt   E DS                  EXTNAME(SESEDEPD)
      *
      ** SE Diary Events for file update - file format
     D NwDEFilFmt    E DS                  EXTNAME(SEVSEDEPD)
     D NwDEFilFmt1             1    231                                                       CSE065
      *
      ** SE Diary Events Screen details retrieved from file
      ** - screen format
     D CrDE1ScnFmt   E DS                  EXTNAME(SESEDEPD)
     D                                     PREFIX(O)
      *
      ** Security diary events retrieved from file - file format
     D CrDEFilFmt    E DS                  EXTNAME(SEDEVD)
     D CrDEFilFmt1             1    231                                                       CSE065
      *
      ** SE Diary Events screen error indicators
     D SEESEDE       E DS                  EXTNAME(SEESEDEPD)
      *
      ** Security Diary Events extra data
     D PExtData      E DS                  EXTNAME(SESDEXPD)
      *
      ** Externally described DS for security details
     D PSectyd       E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(D1)
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for API ICD details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      *
      ** Externally described DS for securities trading icd details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SLCD          E                     EXTFLD(LCD)
      *
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                              CSC011
      ** Data structure for data area SC24X7                                                  CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** Data structure for data area SDSTAT                                                  CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
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
     D PObject         S             10A   INZ('SESEDEUPC')
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
     D PEvtDno         S              5P 0
     D PPayCcy         S              3A
     D PPROT           S              1A
      *
      ** Switchable features
     D CSE010          S              1A
     D S01509          S              1A
     D S01510          S              1A
     D CSE031          S              1A                                                      CSE031
     D CAS006          S              1A                                                      CAS006
     D CSC022          S              1A                                                     BUG2064
     D CSE072          S              1A                                                      CSE072
     D CSE065          S              1A                                                      CSE065
     D CGL031          S              1A                                                      CGL031
      *
      ** Redisplay screen flag
     D PReDsp          S              1A
      *
      ** Work variables
     D WSubDE1         S              1A
     D WMQError        S             28A
     D WEvtDno         S              5P 0
     D DDCUCR          S             12A
     D DDSEXR          S             14A
      *
      ** Parameters for ZDATE1
     D PDateIn         S              6A
     D PDayNoOut       S              5P 0
     D PErrorFlag      S              1A
                                                                                              CSC011
      ** CSC011 enhancement                                                                   CSC011
     D CSC011          S              1A   INZ('N')                                           CSC011
                                                                                              CSC011
      ** Define parameter to be passed to APLOGTRAN.                                          CSC011
     D TRANSDTL        S           5800A   INZ(*BLANKS)                                       CSC011
                                                                                              CSC011
      ** Transaction number to be pass to APLOGTRAN.                                          CSC011
     D PDealNo         S             18A   INZ(*BLANKS)                                       CSC011
                                                                                              CSC011
      ** Associated transaction number                                                        CSC011
     D PADealNo        S             18A   INZ(*BLANKS)                                       CSC011
                                                                                              CSC011
      ** Work variable for Diary event date -alpha                                            CSC011
     D WSDED           S              5A                                                      CSC011
                                                                                              CSC011
      ** Processing date                                                                      CSC011
     D WRDAY           S                   LIKE(BJRDNB)                                       CSC011
      *
      ** Work variables forBUG2604                                                           BUG2604
     DBUG2604          S              1A   INZ('N')                                          BUG2604
     D wCommitSkip     S              1A   INZ('N')                                          BUG2604
                                                                                             BUG2604
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,SESEDEC002
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
      /COPY WNCPYSRC,SESEDEC003
      *
      ** Incoming transaction is in 500A fields, so that a common
      ** CLP can be used between this module and the one that
      ** read the MQ queue.  Break the 500A data by loading
      ** them into the appropriate (externally-described)
      ** data structures.
      *
     C                   MOVEL     PTrans5001    NwDE1ScnFmt
     C                   MOVEL     PExtData500   PExtData
      *
      ** Generate a timestamp for this transaction.
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimestamp
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetFld
      *
      /COPY WNCPYSRC,SESEDEC004
      *
      ** Check if valid security diary events exists for front office Id
      ** in the valid records file.
      *
     C                   EXSR      SRChkValTran
      *
      ** If valid security diary events does exist even after delay,
      ** fail this input.
      *
     C                   IF        IDx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
      *
      ** Check if valid security diary event exist for security shortname,
      ** event date and event type.
      *
     C                   EXSR      SRChkValMTran
      *
      ** If valid security diary event does exist even after delay,
      ** fail this input.
      *
     C                   IF        IDx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
      *
      ** Reset fields again in case the details have been corrupted
      ** by previous chain to valid security diary event file.
      *
     C                   EXSR      SRResetFld
      *
      /COPY WNCPYSRC,SESEDEC005
      *
      ** Validate action code versus the security shortname, event date
      ** and event type supplied. Original security diary events details
      ** are retrieved during the validation process.
      *
     C                   EXSR      SRValAction
      *
      /COPY WNCPYSRC,SESEDEC006
      *
      ** If errors occurred in the initial validation, fail this input.
      *
     C                   IF        IDx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
      *
      ** Processing depends upon action code.
      *
     C                   SELECT
      *
      ** Insert
      ** ======
      *
     C                   WHEN      DDACTN = 'I'
      *
      /COPY WNCPYSRC,SESEDEC007
      *
      ** Validate incoming Security Diary Event details.
      *
     C                   EXSR      SRValDetails
      *
      /COPY WNCPYSRC,SESEDEC008
      *
      ** Check if amended fields are amendable.
      *
     C                   EXSR      SRValAmend
      *
      /COPY WNCPYSRC,SESEDEC009
      *
      ** Amend
      ** =====
      *
     C                   WHEN      DDACTN = 'A'
      *
      /COPY WNCPYSRC,SESEDEC010
      *
      ** Convert original security diary events details from file
      ** to screen format.
      *
     C                   EXSR      SRCvtSeDE
      *
      /COPY WNCPYSRC,SESEDEC011
      *
      ** Check for the existence of the replacement character; if this is
      ** used, only the changed data has been sent, and all occurrences of
      ** the replacement character must be replaced with the corresponding
      ** character from the original transaction.
      *
     C                   IF        GHSUBS <> *BLANK
 
     C     GHSUBS        SCAN      NwDE1ScnFmt                            99
     C                   IF        *IN99
     C                   MOVE      'Y'           WSubDE1
     C                   ELSE
     C                   MOVE      'N'           WSubDE1
     C                   ENDIF
      *
      ** Do data substitution.
      *
     C                   IF        WSubDE1 = 'Y'
     C                   EXSR      SRDtaSubs
     C                   ENDIF
 
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESEDEC012
      *
      ** Validate incoming Security Diary Event details.
      *
     C                   EXSR      SRValDetails
      *
      /COPY WNCPYSRC,SESEDEC013
      *
      ** Check if amended fields are amendable.
      *
     C                   EXSR      SRValAmend
      *
      /COPY WNCPYSRC,SESEDEC014
      *
     C                   ENDSL
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
      /COPY WNCPYSRC,SESEDEC015
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
      /COPY WNCPYSRC,SESEDEC016
 
     C                   EXSR      SRCheckWrite
 
      /COPY WNCPYSRC,SESEDEC017
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
      /COPY WNCPYSRC,SESEDEC018
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkValTran - Routine to check if valid security diary      *
      *                 events exist for Front Office Id in the       *
      *                 valid security diary events file.             *
      *                                                               *
      *****************************************************************
      *
     C     SRChkValTran  BEGSR
      *
      ** Check for front office Id in the valid records file.
      ** Run delay program if record found.
      *
     C     APFOTRANID    CHAIN     SEVSEDEL0                          01
 
     C                   IF        RecNotFnd = False
      *
      ** Run delay program, then repeat chain.
     C                   CALLB     'ZACDELAY'
 
     C     APFOTRANID    CHAIN     SEVSEDEL0                          01
      *
      ** Error if front office Id is still present.
     C                   IF        RecNotFnd = False
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDSDSN'
     C                   EVAL      MsgIDArr(IDx)   = 'APM0900'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkValMTran - Routine to check if valid security diary     *
      *                  events exist for security shortname, event   *
      *                  date and event type in the valid security    *
      *                  diary events file.                           *
      *                                                               *
      *****************************************************************
      *
     C     SRChkValMTran BEGSR
      *
      ** Convert event date into numeric format.
      *
     C                   IF        DDSDED <> '999999'
     C                   EVAL      PDateIn = DDSDED
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDateIn
     C                   PARM      *ZERO         PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        PErrorFlag
 
     C                   Z-ADD     PDaynoOut     WEvtDno
 
     C                   ELSE
     C                   Z-ADD     99999         WEvtDno
     C                   ENDIF
      *
      ** Check for midas security shortname, event date and event type
      ** in the valid record file. Run delay program if record found.
      *
     C     KDEVKA        CHAIN     SEVSEDEL1                          01
 
     C                   IF        RecNotFnd = False
      *
      ** Run delay program, then repeat chain.
     C                   CALLB     'ZACDELAY'
 
     C     KDEVKA        CHAIN     SEVSEDEL1                          01
      *
      ** Error if midas back office reference is still present.
     C                   IF        RecNotFnd = False
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDSDSN'
     C                   EVAL      MsgIDArr(IDx) = 'APM0900'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValAction - Routine to validate Action Code for the        *
      *                security shortname, event date and event type  *
      *                supplied                                       *
      *              - Original Security Diary Events details are     *
      *                retrieve during the validation process         *
      *                                                               *
      *****************************************************************
     C     SRValAction   BEGSR
      *
      ** If insert, set retrieve mode to '*FRONT' (Access using Front
      ** Office Id).  Otherwise, if not insert and midas security shortname,
      ** event date or event type is present, set retrive mode to blank
      ** (Access using Midas Security shortname).
      *
     C                   IF        DDACTN = 'I'
     C                   EVAL      PMode = '*FRONT'
     C                   ELSE
 
     C                   IF        DDSDSN = *BLANK
     C                             AND DDSDED = *BLANK
     C                             AND DDSDET = *BLANK
     C                   EVAL      PMode = '*FRONT'
     C                   ELSE
     C                   EVAL      PMode = *BLANKS
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CSC011
     C                   EVAL      WRDAY = BJRDNB                                             CSC011
                                                                                              CSC011
      ** If CSC011 is present and CTL is still running in the support                         CSC011
      ** system, set the rundate to processing date in dtaara SC24X7,                         CSC011
      ** to be used by RTV module.                                                            CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
     C                   EVAL      WRDAY = S1DATE                                             CSC011
     C                   ENDIF                                                                CSC011
 
     C                   CALLB     'SESEDERTV'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Retun Code
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
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Front office transaction identifier (20A from caller)
     C                   PARM                    APFOTRANID
      *
      ** Security Shortname
     C                   PARM                    DDSDSN
      *
      ** Event Date
     C                   PARM                    DDSDED
      *
      ** Event Type
     C                   PARM                    DDSDET
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDBANK - Run day number
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRDAY                                        CSC011
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDSTRD - Back value period
     C                   PARM                    BVBVP
      *
      ** ZMUSER - Default Branch
     C                   PARM                    PDBRN
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** SE Transaction Enhancement
     C                   PARM                    CSE010
      *
      ** value Ccy to be Ccy of Issuer Payment
     C                   PARM                    S01509
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes                                                CSE031
     C                   PARM                    CSE031                                       CSE031
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
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
     C                   PARM                    WIdx
      *
      ** OK Action Code
     C                   PARM                    OKACTN
      *
      ** OK Security Shortname
     C                   PARM                    OKSDSN
      *
      ** OK Event Date
     C                   PARM                    OKSDED
      *
      ** OK Event Type
     C                   PARM                    OKSDET
      *
      ** Security Diary Events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Event date (Day Number)
     C                   PARM                    PEvtDno
      *
      ** Redisplay screen
     C                   PARM      *BLANK        PReDsp
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
      *  SRValDetails - Routine to validate Security Diary Events Det.*
      *               - Amended file fields (for update) are set up   *
      *                 during the validation process                 *
      *                                                               *
      *****************************************************************
     C     SRValDetails  BEGSR
      *
      ** Move Security Diary Event details retrieved from the midas
      ** database file into the update file record.  If no
      ** record has been retrieved (i.e. in Insert), fields
      ** contain initial values (zeros, blanks).
      *
     C**********         MOVEL     CrDEFilFmt    NwDEFilFmt                                   CSE065
     C                   MOVEL     CrDEFilFmt1   NwDEFilFmt1                                  CSE065
      *                                                                                       CSE065
     C                   IF        CSE065 = 'Y'                                               CSE065
     C                   Z-ADD     SDAL          S2SDAL                                       CSE065
     C                   ELSE                                                                 CSE065
     C                   Z-ADD     *ZEROS        S2SDAL                                       CSE065
     C                   ENDIF                                                                CSE065
      *
      ** Setup defaults on screen 1.
      *
     C                   EXSR      SRDefault1
      *
      ** Validate screen 1 details.
      *
     C                   EXSR      SRVScrn1
 
     C     EValDetails   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDefault1 - Defaulting for screen 1                         *
      *                                                               *
      *****************************************************************
     C     SRDefault1    BEGSR
 
     C                   CALLB     'SESEDE1DT'
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Diary events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** Event date (Day Number)
     C                   PARM                    PEvtDno
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Dividend payments
     C                   PARM                    S01510
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
                                                                                              CSE065
      *                                                                                       CGL031
      ** Taxation on Savings Income                                                           CGL031
     C                   PARM                    CGL031                                       CGL031
      *                                                                                       CGL031
      *
      ** OUTPUT
      ** ======
      *
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** Pay currency
     C                   PARM                    PPayCcy
      *
      ** Cumulative coupon rate
     C                   PARM                    DDCUCR
      *
      ** Current exchange rate
     C                   PARM                    DDSEXR
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVScrn1  - Validate screen 1 details                        *
      *                                                               *
      *****************************************************************
     C     SRVScrn1      BEGSR
 
     C                   CALLB     'SESEDE1VL'
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     C                   PARM                    PMode
      *
      ** Response mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    APRESPMODE
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** Security Diary Events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Event date (Day Number)
     C                   PARM                    PEvtDno
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** SE Transactions Enhancement
     C                   PARM                    CSE010
      *
      ** Value CCY to be CCY of Issuer Payment
     C                   PARM                    S01509
      *
      ** Dividend Payments Base on EX-Date
     C                   PARM                    S01510
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
                                                                                              CSE072
      ** Brazilian C Bonds                                                                    CSE072
     C                   PARM                    CSE072                                       CSE072
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
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
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
      *
      ** Redisplay screen
     C                   PARM      *BLANK        PReDsp
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtSeDE - Convert security diary events details from file  *
      *              to screen format                                 *
      *                                                               *
      *****************************************************************
     C     SRCvtSeDE     BEGSR
 
     C                   CALLB     'SESEDECVT'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Diary events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Action code
     C                   PARM                    DDACTN
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
      *
      ** Dividend payments
     C                   PARM                    S01510
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
                                                                                              CSE065
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** OUTPUT
      ** ======
      *
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     C                   PARM                    CrDE1ScnFmt
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDtaSubs - Data Substitution Routine                        *
      *                                                               *
      *****************************************************************
      *
     C     SRDtaSubs     BEGSR
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
     C                   PARM      NwDE1ScnFmt   PIncData
      *
      ** Current data
     C                   PARM      CrDE1ScnFmt   PCurData
 
     C                   MOVEL     PIncData      NwDE1ScnFmt
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValAmend - Routine to check whether the fields are         *
      *               amendable                                       *
      *             - This subroutine calls a procedure which checks  *
      *               whether it is valid to amend the fields which   *
      *               have been altered.  To determine what fields    *
      *               have been changed, the current fields on file   *
      *               must be converted first to their screen formats.*
      *               These fields are then compared with the fields  *
      *               on the input transaction.  Any errors detected  *
      *               by the called procedure take precedence over    *
      *               any errors found during the validation of the   *
      *               transaction.  The errors from the called        *
      *               procedure are kept separately and if any are    *
      *               found, these errors will REPLACE the normal     *
      *               validation errors.                              *
      *                                                               *
      *****************************************************************
     C     SRValAmend    BEGSR
 
     C                   CALLB     'SESEDE1MD'
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** SE Diary events screen details retrieved from file
      ** - screen format
     C                   PARM                    CrDE1ScnFmt
      *
      ** SE Diary events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Reset of fields in error required (Y/N)
     C                   PARM      'N'           PResetFld
      *
      ** Pay currency
     C                   PARM                    PPayCcy
      *
      ** STANDING DATA
      ** =============
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
      *
      ** Dividend payments
     C                   PARM                    S01510
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    AMFldNamAr
     C                   PARM                    AMMsgIdArr
     C                   PARM                    AMMsgDtaAr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    AMIDx
      *
      ** SE Diary events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** OK Amendments field
     C                   PARM                    PAmendOK
      *
      ** If errors occurred, overwrite previous error information.
      *
     C                   IF        AMIDx <> 0
     C                   MOVEA     AMFldNamAr    FldNameArr
     C                   MOVEA     AMMsgIdArr    MsgIdArr
     C                   MOVEA     AMMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AMIDx         IDx
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCheckWrite - Routine to control checking of error status   *
      *                 and sending of messages/writing to the        *
      *                 database                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRCheckWrite  BEGSR
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
     C                   EXSR      SRSetValid
     C                   WRITE     SEVSEDED0
     C                   EXSR      SRMsgHdl
     C                   ENDIF
 
     C     IDx           IFGT      0
     C                   EXSR      SRSetInvalid
      *
      ** Only write to invalid file if repair in back office.
     C     APRPRLOCN     IFEQ      'B'
     C                   WRITE     SEISEDED0
                                                                                              CSC011
      ** If CSC011 is present and CTL is still running in the support                         CSC011
      ** system, write invalid details to support log file                                    CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
     C                   EXSR      SRWriteLog                                                 CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF
 
     C                   EXSR      SRMsgHdl
     C                   ENDIF
 
     C                   If        (CSC022 = 'N')                                            BUG2604
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                 BUG2604
     C                   COMMIT
     C                   EndIf                                                               BUG2604
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetValid - Routine to set up fields in the valid file      *
      *               record.                                         *
      *                                                               *
      *****************************************************************
      *
     C     SRSetValid    BEGSR
      *
      ** Action is delete.
      ** =================
      *
     C                   IF        DDACTN = 'D'
      *
      ** Move security diary events details retrieved from file
      ** directly to the valid record data structure.
      *
     C**********         EVAL      NwDEFilFmt = CrDEFilFmt                                    CSE065
     C                   EVAL      NwDEFilFmt1 = CrDEFilFmt1                                  CSE065
      *                                                                                       CSE065
     C                   IF        CSE065 = 'Y'                                               CSE065
     C                   Z-ADD     SDAL          S2SDAL                                       CSE065
     C                   ELSE                                                                 CSE065
     C                   Z-ADD     *ZEROS        S2SDAL                                       CSE065
     C                   ENDIF                                                                CSE065
      *
      ** Record Id - update to 'C'.
     C                   EVAL      S2RECI = 'C'
     C                   ENDIF
      *
      ** Action is enquire.
      ** ==================
      *
     C                   IF        DDACTN = 'E'
      *
      ** Move security diary events details retrieved from file
      ** directly to the valid record data structure.
      *
     C**********         EVAL      NwDEFilFmt = CrDEFilFmt                                    CSE065
     C                   EVAL      NwDEFilFmt1 = CrDEFilFmt1                                  CSE065
      *                                                                                       CSE065
     C                   IF        CSE065 = 'Y'                                               CSE065
     C                   Z-ADD     SDAL          S2SDAL                                       CSE065
     C                   ELSE                                                                 CSE065
     C                   Z-ADD     *ZEROS        S2SDAL                                       CSE065
     C                   ENDIF                                                                CSE065
      *                                                                                       CSE065
     C                   ENDIF
      *
      ** Action is insert.
      ** =================
      *
     C                   IF        DDACTN = 'I'
      *
      ** Record Id.
     C                   MOVEL     'D'           S2RECI
      *
      ** Nominal currency.
     C                   MOVEL     D1NMCY        S2NMCY
      *
     C                   ENDIF
      *
      ** Security shortname
      *
     C                   EVAL      S2SDSN = DDSDSN
      *
      ** Event Date
      *
     C                   EVAL      S2SDED = WEvtDno
      *
      ** Event Type
      *
     C                   EVAL      S2SDET = DDSDET
      *
      ** Last change type
      *
     C                   MOVEL     DDACTN        S2CHTP
      *
      ** Message header details.
      *
     C                   EVAL      S2FRNT = APFOTRANID
     C                   EVAL      S2REPA = APRPRLOCN
     C                   EVAL      S2TMST = PTimestamp
      *
      ** Master files will be updated.
      *
     C                   EVAL      PTranStatus = 'S'
      *
      /COPY WNCPYSRC,SESEDEC019
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetInvalid - Routine to set up fields in the invalid file  *
      *                 record.                                       *
      *                                                               *
      *****************************************************************
      *
     C     SRSetInvalid  BEGSR
      *
     C                   EVAL      DDFRNT = APFOTRANID
     C                   EVAL      DDREPA = APRPRLOCN
     C                   EVAL      DDTMST = PTimestamp
      *
      ** Transaction needs to be repaired.
      *
     C                   EVAL      PTranStatus = 'F'
      *
      /COPY WNCPYSRC,SESEDEC020
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMsgHdl - Routine to call the message handling module       *
      *                                                               *
      *****************************************************************
      *
     C     SRMsgHdl      BEGSR
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
 
     C                   EVAL      PTranID = DDSDSN + DDSDED + DDSDET
 
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
      *  SRResetFld - Routine to reset fields                         *
      *                                                               *
      *****************************************************************
     C     SRResetFld    BEGSR
 
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
 
     C                   MOVE      *ALL'Y'       SEESEDE
 
     C                   CLEAR                   CrDE1ScnFmt
 
     C                   ENDSR
      *
      *****************************************************************                       CSC011
      /EJECT                                                                                  CSC011
      *****************************************************************                       CSC011
      *                                                               *                       CSC011
      *  SRWriteLog - Setup data to be written to standard support    *                       CSC011
      *               log file                                        *                       CSC011
      *                                                               *                       CSC011
      *  Called by:  SRCheckWrite                                     *                       CSC011
      *                                                               *                       CSC011
      *  Calls: APLOGTRAN - API standard Log module                   *                       CSC011
      *                                                               *                       CSC011
      *****************************************************************                       CSC011
                                                                                              CSC011
     C     SRWriteLog    BEGSR                                                                CSC011
                                                                                              CSC011
      ** Setup value of TRANSDTL                                                              CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = NwDE1ScnFmt + PExtData                          CSC011
                                                                                              CSC011
      ** Initialise Deal no to pass                                                           CSC011
     C                   MOVE      WEvtDno       WSDED                                        CSC011
     C                   EVAL      PDealNo = DDSDSN + WSDED + DDSDET                          CSC011
                                                                                              CSC011
      ** Call program that will write to API standard log file.                               CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       ReturnCode                                   CSC011
     C                   PARM                    PHeadIn                                      CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    PTimestamp                                   CSC011
     C                   PARM                    PDealNo                                      CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
      ** If error occurred, perform abnormal termination                                      CSC011
     C     ReturnCode    IFNE      *BLANKS                                                    CSC011
     C                   EVAL      DBASE = 8                                                  CSC011
     C                   EVAL      DBFILE = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBKEY = '*CALL'                                            CSC011
     C                   EXSR      *pssr                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDSR                                                                CSC011
                                                                                              CSC011
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
     C                   EVAL      DTAQNAME = 'APSEDEDTQ'
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
      *
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
      ** Access SAR file to determine if CSE010
      ** (SE Transaction Enhancement) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSE010'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY = 'CSE010'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     3             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSE010 = 'Y'
     C                   ELSE
     C                   EVAL      CSE010 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if S01509
      ** (Value Ccy to be Ccy of Issuer Payment) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01509'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY = 'S01509'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     4             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      S01509 = 'Y'
     C                   ELSE
     C                   EVAL      S01509 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if S01510
      ** (Dividend Payments) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01510'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY = 'S01510'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     5             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      S01510 = 'Y'
     C                   ELSE
     C                   EVAL      S01510 = 'N'
     C                   ENDIF
                                                                                              CGL031
      ** Access SAR file to determine if Taxation on Savings                                  CGL031
      ** Income is installed.                                                                 CGL031
                                                                                              CGL031
     C                   CALLB     'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtcd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSarD                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
                                                                                              CGL031
      ** An NRF (No Record Found) return code is valid.                                       CGL031
      ** Issue database error only for error return codes.                                    CGL031
                                                                                              CGL031
     C                   IF        PRtcd <> *BLANKS AND                                       CGL031
     C                             PRtcd <> '*NRF   '                                         CGL031
     C                   EVAL      DBKEY = 'CGL031'                                           CGL031
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL031
     C                   Z-ADD     10            DBASE                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   IF        PRtcd = *BLANKS                                            CGL031
     C                   MOVEL     'Y'           CGL031                                       CGL031
     C                   ELSE                                                                 CGL031
     C                   MOVEL     'N'           CGL031                                       CGL031
     C                   ENDIF                                                                CGL031
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
                                                                                              CSC011
      ** Determine if 24x7 Midas availability is installed                                    CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
      ** An NRF (No Record Found) return code is valid.                                       CSC011
      ** Issue database error only for error return codes.                                    CSC011
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBASE = 7                                                  CSC011
     C                   EXSR      *pssr                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CSE031
      ** Access SAR file to determine if CSE031                                               CSE031
      ** (Coupon Fixing for Floating Rate Notes) is installed.                                CSE031
      *                                                                                       CSE031
     C                   CALLB     'AOSARDR0'                                                 CSE031
     C                   PARM      *BLANKS       PRTCD                                        CSE031
     C                   PARM      '*VERIFY'     POPTN                                        CSE031
     C                   PARM      'CSE031'      PSARD                                        CSE031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE031
      *                                                                                       CSE031
      ** An NRF (No Record Found) return code is valid.                                       CSE031
      ** Issue database error only for error return codes.                                    CSE031
      *                                                                                       CSE031
     C                   IF        PRTCD <> *BLANKS AND                                       CSE031
     C                             PRTCD <> '*NRF   '                                         CSE031
     C                   EVAL      DBKEY = 'CSE031'                                           CSE031
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSE031
     C                   Z-ADD     8             DBASE                                        CSE031
     C                   EXSR      *PSSR                                                      CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   IF        PRTCD = *BLANKS                                            CSE031
     C                   EVAL      CSE031 = 'Y'                                               CSE031
     C                   ELSE                                                                 CSE031
     C                   EVAL      CSE031 = 'N'                                               CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSC011
      ** Access SAR file to determine if 'Hedge Accounting                                    CAS006
      ** Phase B(CAS006)' is installed.                                                       CAS006
                                                                                              CAS006
     C                   CALLB     'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRtcd                                        CAS006
     C                   PARM      '*VERIFY'     POptn                                        CAS006
     C                   PARM      'CAS006'      PSarD                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
      ** An NRF (No Record Found) return code is valid.                                       CAS006
      ** Issue database error only for error return codes.                                    CAS006
     C                   IF        PRtcd <> *BLANKS AND                                       CAS006
     C                             PRtcd <> '*NRF   '                                         CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBKey = 'CAS006'                                           CAS006
     C                   EVAL      DBFile= 'SCSARDPD'                                         CAS006
     C                   EVAL      DBase = 009                                                CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        PRtcd = *BLANKS                                            CAS006
     C                   MOVEL     'Y'           CAS006                                       CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVEL     'N'           CAS006                                       CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CSE072
      ** Access SAR file to determine if 'Brazilian C-Bonds                                   CSE072
      ** (CSE072)' is installed.                                                              CSE072
                                                                                              CSE072
     C                   CALLB     'AOSARDR0'                                                 CSE072
     C                   PARM      *BLANKS       PRtcd                                        CSE072
     C                   PARM      '*VERIFY'     POptn                                        CSE072
     C                   PARM      'CSE072'      PSarD                                        CSE072
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE072
                                                                                              CSE072
      ** An NRF (No Record Found) return code is valid.                                       CSE072
      ** Issue database error only for error return codes.                                    CSE072
     C                   IF        PRtcd <> *BLANKS AND                                       CSE072
     C                             PRtcd <> '*NRF   '                                         CSE072
     C     *LOCK         IN        LDA                                                        CSE072
     C                   EVAL      DBKey = 'CSE072'                                           CSE072
     C                   EVAL      DBFile= 'SCSARDPD'                                         CSE072
     C                   EVAL      DBase = 009                                                CSE072
     C                   OUT       LDA                                                        CSE072
     C                   EXSR      *PSSR                                                      CSE072
     C                   ENDIF                                                                CSE072
                                                                                              CSE072
     C                   IF        PRtcd = *BLANKS                                            CSE072
     C                   MOVEL     'Y'           CSE072                                       CSE072
     C                   ELSE                                                                 CSE072
     C                   MOVEL     'N'           CSE072                                       CSE072
     C                   ENDIF                                                                CSE072
                                                                                              CSE065
      ** Access SAR file to determine if CSE065 is installed                                  CSE065
                                                                                              CSE065
     C                   CALL      'AOSARDR0'                                                 CSE065
     C                   PARM      *BLANKS       PRtcd                                        CSE065
     C                   PARM      '*VERIFY'     POptn                                        CSE065
     C                   PARM      'CSE065'      PSarD                                        CSE065
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE065
                                                                                              CSE065
      ** An NRF (No Record Found) return code is valid.                                       CSE065
      ** Issue database error only for error return codes.                                    CSE065
                                                                                              CSE065
     C                   IF        PRtcd <> *BLANKS AND                                       CSE065
     C                             PRtcd <> '*NRF   '                                         CSE065
     C     *LOCK         IN        LDA                                                        CSE065
     C                   EVAL      DBKey = 'CSE065'                                           CSE065
     C                   EVAL      DBFile= 'SCSARDPD'                                         CSE065
     C                   EVAL      DBase = 010                                                CSE065
     C                   OUT       LDA                                                        CSE065
     C                   EXSR      *PSSR                                                      CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSE065
     C                   IF        PRtcd = *BLANKS                                            CSE065
     C                   MOVEL     'Y'           CSE065                                       CSE065
     C                   ELSE                                                                 CSE065
     C                   MOVEL     'N'           CSE065                                       CSE065
     C                   ENDIF                                                                CSE065
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
      ** Key fields for LF/SEDEV
     C     KDEVKA        KLIST
     C                   KFLD                    DDSDSN
     C                   KFLD                    WEvtDno
     C                   KFLD                    DDSDET
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,SESEDEC021
      *
      ** Access SAR details file to determine if Commitment Control                          BUG2604
      ** Changes is switched on.                                                             BUG2604
      *                                                                                      BUG2604
     C                   CallB     'AOSARDR0'                                                BUG2604
     C                   Parm      *BLANKS       PRTCD                                       BUG2604
     C                   Parm      '*VERIFY'     POPTN                                       BUG2604
     C                   Parm      'CSC022'      PSARD                                       BUG2604
     C     SCSARD        Parm      SCSARD        DSFDY                                       BUG2604
                                                                                             BUG2604
     C                   If        PRTCD = *BLANKS                                           BUG2604
      *                                                                                      BUG2604
     C                   Eval      CSC022 = 'Y'                                              BUG2604
     C                   In        SCCMTJOB                                                  BUG2604
     C                   If        ComitNum > 0                                              BUG2604
      *                                                                                      BUG2604
      ** Check if Current Job exists in the Commitment Job Names                             BUG2604
      ** Data Area.                                                                          BUG2604
      *                                                                                      BUG2604
     C                   MoveA     wComitJob     CmtJobNArr                                  BUG2604
     C     PSJOBNAME     LookUp    CmtJobNArr                             20                 BUG2604
     C                   If        *IN20                                                     BUG2604
     C                   Eval      wCommitSkip = 'Y'                                         BUG2604
     C                   EndIf                                                               BUG2604
     C                   EndIf                                                               BUG2604
      *                                                                                      BUG2604
     C                   Else                                                                BUG2604
      *                                                                                      BUG2604
      ** Database error                                                                      BUG2604
      *                                                                                      BUG2604
     C                   If        PRTCD <> '*NRF'                                           BUG2604
     C     *LOCK         In        LDA                                                       BUG2604
     C                   Eval      DBKey = 'CSC022'                                          BUG2604
     C                   Eval      DBPgm = 'SESEDECTL'                                       BUG2604
     C                   Eval      DBFile = 'SCSARDPD'                                       BUG2604
     C                   Eval      DBase = 10                                                BUG2604
     C                   Out       LDA                                                       BUG2604
     C                   ExSr      *PSSR                                                     BUG2604
     C                   EndIf                                                               BUG2604
      *                                                                                      BUG2604
     C                   EndIf                                                               BUG2604
      *                                                                                      BUG2604
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
(c) Finastra International Limited 2001
