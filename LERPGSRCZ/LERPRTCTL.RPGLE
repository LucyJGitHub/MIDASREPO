     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Risk participant interface controller')
      *****************************************************************
      *                                                               *
      *  Midas - Module name ILE Module                               *
      *                                                               *
      *  LERPRTCTL - Risk Participant Interface Controller            *
      *                                                               *
      *  Function: This Program Validates LE Risk Participants for    *
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
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 247549             Date 03May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 222373             Date 29Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP069  *CREATE    Date 18Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247549 - Review delay processing.                            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  222373 - Parameter Mismatch                                  *
      *  CAP069 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *****************************************************************
 
      * Valid Transaction file
     FLEVRPRTPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      * Invalid Transactions
     FLEIRPRTPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FLEVRPRTL0 IF   E           K DISK    RENAME(LEVRPRTD0:LEVRPRTCHK)
     F                                     INFSR(*PSSR)
     FLEVRPRTL1 IF   E           K DISK    RENAME(LEVRPRTD0:LEVRPRTCK1)
     F                                     INFSR(*PSSR)
 
     FAPILSETPD O  A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,LERPRTC001
 
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
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
 
      **---------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------------
 
      **---------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **---------------------------------------------------------------------
 
      **---------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **---------------------------------------------------------------------
 
      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+
 
      ** String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')
 
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
 
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming Transaction
     D TranInRPRT    E DS                  EXTNAME(LERPRTPD)
 
      * Valid Customer Securities Details layout
     D ValidRPRT     E DS                  EXTNAME(LEVRPRTPD)
     D                                     PREFIX(V_)
     D  ValidREC              72    140
     D  ValidPAY             141    699
 
 
      * (Current) Transaction record in file Format
     D PARTFilFmt    E DS                  EXTNAME(LEPARTPD)
     D  RPRTFilREC            72    140
     D  RPRTFilPAY           141    699
 
 
      * (Current) Transaction in Screen Format - Main Details
     D CurTrRPRT     E DS                  EXTNAME(LERPRTPD)
     D                                     PREFIX(@)
 
      * Error indicators
     D OKTrRPRT      E DS                  EXTNAME(LEERPRTPD)
 
      ** Data structure for passing a parameter to synon screen
      ** handling program.
     D TranSETLIAB   E DS                  EXTNAME(SETLIAB)
 
      ** Data structure for passing a parameter to synon screen
      ** handling program.
     D TranSETLIAZ   E DS                  EXTNAME(SETLIAZ)
                                                                                              222373
     D Tran@PARM3    E DS                  EXTNAME(SDSETLPD)                                  222373
 
      * File Receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)
 
      * File Payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
     D SCA_TYLC      E                     EXTFLD(TYLC)                                       CLE042
      ** EXTERNAL DS FOR SAR DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
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
 
      ** Indices for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D Object          S             10A   INZ('LERPRTUPC')
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
 
     D CSC011          S              1A   INZ('N')
     D TRANSDTL        S           5800A
     D PDealNo         S             18A
     D PADealNo        S             18A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
 
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
      ** Override Database Table
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)
 
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepRPRT         S              1A   INZ('N')
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      **   Hook for non-core D-specs (all types)   
      **   also any I-specs (if necessary)         
      **   =====================================   
      ** +----------------------------------------+
      /COPY WNCPYSRC,LERPRTC002
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,LERPRTC003
 
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     TranInRPRT
     C                   MOVEL     Trans5002     TranSETLIAB
     C                   MOVEL     Trans5003     TranSETLIAZ
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      * Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,LERPRTC004
 
      *  Check if valid Risk Participant details exists
 
     C                   EXSR      ChkValRPRT
      *
      *  If valid RPRT details does exist (even after delay), fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      *  Check if valid Transaction exists for Midas Transaction Number
 
     C                   EXSR      ChkValMiRp
      *
      *  If valid Transaction does exist (even after delay), fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      * Reset variables again in case the details have been corrupted
      * by previous chain to valid Transaction details file.
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,LERPRTC005
 
      *  Validate Action Code
 
     C                   EXSR      ValidateAc
      *
      /COPY WNCPYSRC,LERPRTC006
 
      *  If error in validation of action code, fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
     C                   WHEN         S#ACTN = 'I'
      *  Processing for Inserts
      /COPY WNCPYSRC,LERPRTC007
     C                   EXSR      ValidateTr
     C                   EXSR      ValidateSt
      /COPY WNCPYSRC,LERPRTC008
 
     C                   WHEN         S#ACTN = 'A'
     C                             OR S#ACTN = 'D'
      *  Processing for Amends or Changes
      /COPY WNCPYSRC,LERPRTC009
      * Check for the existence of the replacement character; if this is
      * used, only the changed data has been sent, and all occurrences of
      * the replacement character must be replaced with the corresponding
      * character from the original transaction.
     C                   IF        S#ACTN = 'A' AND GHSUBS <> *BLANK
 
     C     GHSUBS        SCAN      TranInRPRT                             99
     C                   IF        *in99
     C                   EVAL      RepRPRT = 'Y'
     C                   ENDIF
 
      ** If any of the flags set above is true, do the data
      ** substution subroutine.
     C                   IF        RepRPRT = 'Y'
     C                   EXSR      DtaSubs
     C                   ENDIF
 
     C                   ENDIF
      **                 (End of "if S#ACTN = 'A' AND GHSUBS <> *blank")
 
     C                   EXSR      SetupAmd
      /COPY WNCPYSRC,LERPRTC010
     C                   EXSR      ValidateTr
     C                   EXSR      ValidateSt
      /COPY WNCPYSRC,LERPRTC011
 
     C                   ENDSL
      *
     C     INVALID       TAG
 
      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      *  prompting the database update program
     C                   IN        APDUMP
      /COPY WNCPYSRC,LERPRTC012
 
     C                   IF        ARERRMOD <> *BLANK
     C                   EVAL      MQErrlong  = *blank
     C                   MOVEL     ProcErr       MQError
     C                   MOVE      ARERRMOD      MQError          28
     C                   MOVEL     MQError       MQErrlong
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MQReturn         10
     C                   PARM                    MQErrlong       132
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   MOVEL     ARERRMOD      APRETCODE
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARERRMOD = *BLANK
     C                   OUT       APDUMP
     C                   RETURN
 
     C                   ELSE
 
      *  Processing for Error checking/write to database
      /COPY WNCPYSRC,LERPRTC013
     C                   EXSR      CheckWrite
      /COPY WNCPYSRC,LERPRTC014
 
      *  If valid, send data queue entry to prompt DB update program
     C                   IF        Idx = 0
     C                   EVAL      ObjType = '*DTAARA'
      *  Check if update program active using Allocate Object API
      *  No prompting necessary if program is running
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM      *BLANK        Return
 
     C                   IF        RETURN = *BLANK
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LERPRTC015
 
     C                   RETURN
 
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * ChkValRPRT - Routine to check if valid Transaction details exist *
      *                                                                  *
      ********************************************************************
     C     ChkValRPRT    BEGSR
 
     C     APFOTranID    CHAIN     LEVRPRTL0                          99
 
      * If record found...
     C                   IF        *IN99 = *OFF
 
      * ..delay, then repeat check
     C**********         CALLB     'ZACDELAY'                                                 247549
     C                   Z-ADD     1             COUNT             2 0                        247549
     C     *IN99         DOWEQ     '0'                                                        247549
     C     COUNT         ANDLE     10                                                         247549
     C                   ADD       1             COUNT                                        247549
     C                   CALLB     'ZACDELAY1'                                                247549
 
     C     APFOTranID    CHAIN     LEVRPRTL0                          99
     C                   END                                                                  247549
 
      * Error if still present
     C                   IF        *IN99 = *OFF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'APFOTranID'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Access Primary Facility                                       *
      *****************************************************************
     C     ACSPFA        BEGSR
 
     C                   CALLB     'LE002520'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Primary facility customer, type & number
     C                   PARM                    S#PMFC
     C                   PARM                    S#PMFT
     C                   PARM                    S#PMFN
      *
      * OUTPUTS
      *
 
      * Prime Facility amount
      * Prime Facility branch
      * Prime Facility branch details
      * Prime Facility currency
      * Prime Facility currency decimal places
      * Prime Facility tranche/credit agreement ind
      * Prime Facility credit agreement customer, type & number
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
     C                   PARM                    FctrTRCA          2
     C**********         PARM                    FccaCANM          6 0                        CSD027
     C                   PARM                    FccaCANM          6                          CSD027
     C                   PARM                    FccaCAFT          3 0
     C                   PARM                    FccaCAFN          2 0
 
      * Primary customer name & town
     C                   PARM                    S#PRNM           20
     C                   PARM                    S#PRTN           10
 
      * Agent customer number, name & town
     C                   PARM                    S#ANUM            6
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10
 
      * Primary facility amount edited
     C                   PARM                    S#FAMT           14
 
      * Field OK flags
     C                   PARM                    S#PMFCOK          1
     C                   PARM                    S#PMFTOK          1
     C                   PARM                    S#PMFNOK          1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx               3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         WIdx              3 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValMiRp - Routine to check if valid Transaction Risk       *
      * Participant exists for Midas Transaction number               *
      *                                                               *
      *****************************************************************
 
     C     ChkValMiRp    BEGSR
     C
     C                   IF        S#PMFC <> *BLANKS and S#PMFT <> *BLANKS
     C                             and S#PMFN <> *BLANKS and
     C                             S#CSSN <> *BLANKS
 
      * Access primary facility
 
     C                   EXSR      ACSPFA
 
      * Check for Risk Participant on valid file
     C                   MOVE      FcbrBranch    K#BRCA
     C                   MOVE      S#PMFC        K#PMFC
     C                   MOVE      S#PMFT        K#PMFT
     C                   MOVE      S#PMFN        K#PMFN
     C                   MOVE      S#CSSN        K#CSSN
 
      * Check for Transaction on Valid file
     C     PFCLTK        CHAIN     LEVRPRTL1                          99
 
      * If record found...
     C                   IF        *IN99 = *OFF
 
      * ..delay, then repeat check
     C**********         CALLB     'ZACDELAY'                                                 247549
     C                   Z-ADD     1             COUNT             2 0                        247549
     C     *IN99         DOWEQ     '0'                                                        247549
     C     COUNT         ANDLE     10                                                         247549
     C                   ADD       1             COUNT                                        247549
     C                   CALLB     'ZACDELAY1'                                                247549
 
     C     PFCLTK        CHAIN     LEVRPRTL1                          99
     C                   END                                                                  247549
 
      * Error if still present
     C                   IF        *IN99 = *OFF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'S#PMFC'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    Transaction number supplied                                *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)
      *  if insert
      *  if not insert and Midas transaction ID is not present
      * Otherwise
      *  Set retrieve mode to blank  (Access using Midas transaction ID).
      *
      *  We assume no substitution has been defined for the transaction ID
      *
      ** Check for the existence of the replacement character at the
      ** Transaction Id level.
     C                   IF        GHSUBS <> *blank
     C     GHSUBS        SCAN      TranInRPRT    SubForTRNN        2 0
     C                   ENDIF
     C                   IF        S#ACTN = 'I'
     C                   MOVEL     'B'           P#MODE
     C                   ELSE
     C                   IF        TranInRPRT = *BLANK
     C                             OR SubForTRNN <> 0
     C                   MOVEL     'B'           P#MODE
     C                   ELSE
     C                   MOVEL     ' '           P#MODE
     C                   ENDIF
     C                   ENDIF
 
      * Validate action code versus transaction IDs supplied
      * The Transaction in file format from the LE database is retrieved
      * as well.
 
     C                   CALLB     'LERPRTRTV'
      *
      * Inputs
      *
      * Return code
     C                   PARM      *BLANK        ReturnCode
      *
     C                   PARM                    P#MODE            1
      * Response mode
     C                   PARM                    APRESPMODE
      * Action and assigned to and assigned from customers
     C                   PARM                    S#ACTN
     C                   PARM                    S#CSSN
 
      * Primary facility customer, type & number
     C                   PARM                    S#PMFC
     C                   PARM                    S#PMFT
     C                   PARM                    S#PMFN
 
      * Prime facility branch
     C                   PARM                    FcbrBranch
      *
      * Outputs
      *
      * (Current) Transaction in file format
      * Action and customer OK indicators
     C                   PARM                    PARTFilFmt
      *
     C                   PARM                    S#ACTNok
     C                   PARM                    S#CSSNok
 
      ** Syndicate Member
     C                   PARM                    S#CNUM
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Risk Participant settlement instructions
 
     C                   MOVEL     RPRTFilREC    F_REC
     C                   MOVEL     RPRTFilPAY    F_PAY
     C                   MOVE      CVMR          FLCVMR
     C                   MOVE      OMDB          FLPOBR
     C                   MOVE      OSDB          FLROBR
     C                   MOVE      SCCY          FLPSCY
     C                   MOVE      SCCY          FLRSCY
     C                   MOVE      ICCY          FLIC72
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *    of amendments and changes.                                 *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR
 
      * For Amends, put the complete (pre-existing) Transaction into the Valid
      *  file record - fields in this will be updated during processing
 
     C                   MOVEL     PARTFilFmt    ValidRPRT
 
      * For Amends, convert the Risk Participant transaction to screen format
 
     C                   CALLB     'LERPRTCVT'
      * Inputs
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * Risk Participant Transaction - file formats
     C                   PARM                    ValidRPRT
 
      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    FccyFCCY
     C                   PARM                    FccyNBDP
      *
      * Output parameters
      *
      * Risk Participant Transaction Details - screen formats
     C                   PARM                    CurTrRPRT
 
      * Syndicate member details
     C                   PARM                    S#CNUM            6
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#SRNM           20
     C                   PARM                    S#SRTN           10
 
      * Introducing customer details
     C                   PARM                    S#IRNM           20
     C                   PARM                    S#IRTN           10
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate settlement instructions
      *****************************************************************
     C     ValidateSt    BEGSR
 
      ** Setup the settlement screen fields (SETLIAB/SETLIAZ)
 
     C                   EXSR      SETUP_SSCR
 
      ** Call extended settlements input
 
     C                   CALL      'SD2410'
     C                   PARM                    TranSETLIAB
     C                   PARM                    TranSETLIAZ
     C                   PARM                    Tran@PARM3                                   222373
 
      ** Terminate program if database error returned
 
     C     PMDBSE        IFNE      *ZERO
     C                   MOVEL     PMDBFL        DBFILE
     C                   Z-ADD     PMDBSE        DBASE
     C                   MOVEL     PMDBKY        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If there are errors in the settlement screen
      ** log them
      ** Otherwise, update the file fields with the screen fields
 
     C     PMERCD        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      MsgIDArr(Idx)   = 'LEA1020'
     C                   ELSE
     C                   EXSR      SET_SC2FL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Setup the settlement screen fields (SETLIAB/SETLIAZ)
      *****************************************************************
     C     SETUP_SSCR    BEGSR
 
      ** Set action, customer, currencies and branch for settlement screen
 
     C     TranSETLIAB   IFEQ      *BLANKS
     C                   MOVE      S#ACTN        PMACTC
     C                   MOVE      'LEND'        PMCPGM
     C                   MOVEL     S#CNUM        PMCSNM
     C                   Z-ADD     BJRDNB        PMDTRC
     C                   Z-ADD     BJRDNB        PMDTPY
     C                   MOVE      FccyFCCY      PMRCCY
     C                   MOVE      FccyFCCY      PMPCCY
     C                   MOVE      *BLANK        PMFFND
     C                   MOVE      FcbrBranch    PMBRCA
     C                   MOVE      *BLANK        PMCMDP
     C                   Z-ADD     0             PMDBSE
     C                   MOVE      *BLANKS       PMERCD
     C                   Z-ADD     BJRDNB        PMRUND
 
      ** Set settlement details valid flag
 
     C                   MOVE      'N'           PMSDTV
 
      ** move settlement file fields to screen fields
 
     C                   EXSR      SET_FL2SC
 
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Move settlement file fields to screen fields (SETLIAB/SETLIAZ)*
      *****************************************************************
     C     SET_FL2SC     BEGSR
 
     C                   CALLB     'LESTFL2SC'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeIn
 
      * File Receive instructions
     C                   PARM                    F_REC
 
      * File Payment instructions
     C                   PARM                    F_PAY
      *
      * OUTPUTS
      *
      * Screen receive and payment instructions
     C                   PARM                    TranSETLIAB
     C                   PARM                    TranSETLIAZ
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Move settlement screen fields to file fields                  *
      *****************************************************************
     C     SET_SC2FL     BEGSR
 
     C                   CALLB     'LESTSC2FL'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeIn
 
      * Screen receive and payment instructions
     C                   PARM                    TranSETLIAB
     C                   PARM                    TranSETLIAZ
      *
      * OUTPUTS
      *
 
      * File Receive instructions
     C                   PARM                    F_REC
 
      * File Payment instructions
     C                   PARM                    F_PAY
 
      ** Risk Participant settlement instructions
 
     C                   MOVEL     F_REC         ValidREC
     C                   MOVEL     F_PAY         ValidPAY
     C                   MOVE      FLCVMR        V_ASCVMR
     C                   MOVE      FLPOBR        V_ASOMDB
     C                   MOVE      FLROBR        V_ASOSDB
     C                   MOVE      FLPSCY        V_ASSCCY
     C                   MOVE      FLRSCY        V_ASSCCY
     C                   MOVE      FLIC72        V_ASICCY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
 
      * Validate Risk Participant Transaction details
 
     C                   EXSR      ValdTrRPRT
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrRPRT - Validate Risk Participant Transaction details        *
      *                                                               *
      *****************************************************************
     C     ValdTrRPRT    BEGSR
 
     C                   CALLB     'LERPRTVAL'
 
      * Inputs
 
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
      * Mode
     C                   PARM                    P#MODE            1
 
      ** Risk Participant transaction details
     C                   PARM                    TranInRPRT
 
      * Agent number
     C                   PARM                    S#ANUM
 
      * Prime Facility amount
      * Prime Facility branch
      * Prime Facility branch details
      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
 
      * Front office inputs (if mode = 'B')
     C                   PARM      *BLANKS       R1PCOB            3
     C                   PARM      *BLANKS       R1TNRF           15
 
      * Outputs
 
      *
      ** Risk Participant Transaction Details OK inds
     C                   PARM                    OKTrRPRT
      *
      * Syndicate customer number
     C                   PARM                    S#CNUM            6
      * Syndicate member customer name/town
     C                   PARM                    S#SRNM           20
     C                   PARM                    S#SRTN           10
      * Introducing customer name/town
     C                   PARM                    S#IRNM           20
     C                   PARM                    S#IRTN           10
      *
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
 
      * Valid Risk Participant Transaction (DS) from/to caller
     C                   PARM                    ValidRPRT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Check/Write - Routine to control checking of error status and *
      *    sending of messages/writing to the database                *
      *                                                               *
      *****************************************************************
 
     C     CheckWrite    BEGSR
 
      *  If no errors were found:
      *     - set up additional data
      *     - write a record to the Valid file
      *     - use std message handler to report customer status
      *  If any errors were found:
      *     - write a record to the Invalid file
      *     - call the message handler to pass the errors back
      *     - use std message handler to report trade status
      *  The index to the error arrays is checked for presence/absence of
      *   errors
†††††
††††† ** +--- Note for a later release -------------------------------+
††††† ** ¶                                                            ¶
††††† ** ¶ At a later date this routine will have to cater for        ¶
††††† ** ¶ warning messages.  The following logic will have to be     ¶
††††† ** ¶ inserted before "If no errors were found", in the          ¶
††††† ** ¶ above comments (and the code):                             ¶
††††† ** ¶                                                            ¶
††††† ** ¶ If 'Ignore warning messages' (from API ICD) is 'N', AND    ¶
††††† ** ¶ any warning messages were returned (WIdx <> 0)             ¶
††††† ** ¶                                                            ¶
††††† ** ¶ -†††If errors exist                                        ¶
††††† ** ¶†††††-†††††Add the warning array index to the error array   ¶
††††† ** ¶†††††††††††index                                            ¶
††††† ** ¶†††††-†††††Append the contents of the warning arrays to the ¶
††††† ** ¶†††††††††††end of the error arrays                          ¶
††††† ** ¶ -†††Else                                                   ¶
††††† ** ¶ ††††-†††††Set the error array index equal to the warning   ¶
††††† ** ¶†††††††††††array index                                      ¶
††††† ** ¶†††††-†††††Copy the contents of the warning arrays to the   ¶
††††† ** ¶†††††††††††error arrays                                     ¶
††††† ** ¶ -†††Endif                                                  ¶
††††† ** ¶                                                            ¶
††††† ** ¶ Endif                                                      ¶
††††† ** ¶                                                            ¶
††††† ** ¶ Note that the "If errors exist ... Else ... " block above  ¶
††††† ** ¶ can probably be implemented unconditionally (ie the same   ¶
††††† ** ¶ logic will apply whether errors exist as well as warnings  ¶
††††† ** ¶ or not).  It is shown in the above form for clarity.       ¶
††††† ** ¶                                                            ¶
††††† ** +------------------------------------------------------------+
 
     C                   IF        Idx = 0
 
     C                   EXSR      SETUPVALID
     C                   WRITE     LEVRPRTD0
 
     C                   EXSR      CallMsgHdl
 
     C                   ENDIF
 
     C     Idx           IFGT      0
     C                   EXSR      SETUPINVAL
      *
      * Only write to invalid files if repair in back office
     C                   IF        APRprLocn = 'B'
      *
      * Get next repair number if back office repair
 
     C                   CALL      'LEC0215'
     C                   PARM                    XREPN
 
     C                   WRITE     LEIRPRTD0
     C                   WRITE     APILSETD0
 
      ** Write all invalid records to the support log file
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
 
     C                   EVAL      TRANSDTL = TranInRPRT +
     C                                        TranSETLIAB +
     C                                        TranSETLIAZ
 
     C                   EVAL      APTGTTYPE  = 'LERPRT'
     C                   EVAL      PDealNo = S#PMFC + S#PMFT +
     C                                       S#PMFN
 
     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    HeadIn
     C                   PARM                    TRANSDTL
     C                   PARM                    Timestamp
     C                   PARM                    PDealNo
     C                   PARM      *BLANKS       PADealNo
 
      ** Database error
 
     C                   IF        RetCodeOut <> *BLanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PDealNo
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 901
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EXSR      CallMsgHdl
 
     C                   ENDIF
 
     C                   COMMIT
 
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
 
 
     C                   RESET                   FldNoArr
 
     C                   CLEAR                   CurTrRPRT
 
     C                   MOVE      *ALL'Y'       OKTrRPRT
 
     C                   CLEAR                   ValidRPRT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPINVAL - Set up additional fields that are needed on the  *
      *        invalid file record.                                   *
      *                                                               *
      *****************************************************************
 
     C     SETUPINVAL    BEGSR
 
      * Include Header fields that need to be o/p to the Invalid files
     C                   EVAL      DDFRNT     = APFOTranID
     C                   EVAL      DDAFRT     = APFOAsocID
     C                   EVAL      DDREPA     = APRprLocn
     C                   MOVE      TimeStamp     XTMST
 
     C                   EVAL      XMSGTYP = 'LERPRT'
     C                   EVAL      XFOTRID = APFOTranID
     C                   EVAL      XFOASID = APFOAsocID
     C                   EVAL      XRPRLN  = APRprLocn
 
     C                   EVAL      TranStatus = 'F'
 
      /COPY WNCPYSRC,LERPRTC016
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
 
      * Set Valid file field(s) that are needed for all Action Codes
      * Include Header fields that need to be o/p to the Valid file
      * If there is no front office ID, use the PCREF created by LEASGNVAL.
     C     APFOTranID    Ifeq      *Blank
     C                   MOVEL     V_ASPCRF      V_ASFRNT
     C                   Else
     C                   EVAL      V_ASFRNT = APFOTranID
     C                   EndIf
     C                   EVAL      V_ASAFRT = APFOAsocID
     C                   EVAL      V_ASREPA = APRprLocn
     C                   EVAL      V_ASSTMP = TimeStamp
     C                   EVAL      V_ASTYLC = S#ACTN
 
     C                   EVAL      TranStatus = 'S'
 
      /COPY WNCPYSRC,LERPRTC017
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CallMsgHdl - Call the Message Handling module                 *
      *                                                               *
      *****************************************************************
 
     C     CallMsgHdl    BEGSR
 
      ** Set up an array of sequence numbers that correspond to the fields
      **  with errors
 
     C                   Z-ADD     1             Ix
     C                   DO        ArrayMax
 
     C                   IF        FldNameArr(Ix) <> *blanks
 
     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
 
     C                   ELSE
 
     C                   LEAVE
 
     C                   ENDIF
 
     C                   ADD       1             Ix
 
     C                   ENDDO
 
     C                   RESET                   ReturnCode
     C                   EVAL      WTRANSID = FcbrBranch + S#PMFC
     C                             + S#PMFT + S#PMFN + S#CSSN
 
     C                   CALLB     'ZAMSGHNDLE'
      ** Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      ** Deal repair location (1A, from caller)
     C                   PARM                    APRprLocn
      ** Confirm validity to front office (1A, from caller)
     C                   PARM                    APCnfValFO
      ** List of messages (Array of <ArrayMax>x7A message ids - from caller )
     C                   PARM                    MsgIDArr
      ** List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
     C                   PARM                    FldNoArr
      ** List of field names (Array of <ArrayMax>x10A names - from caller)
     C                   PARM                    FldNameArr
      ** List of message data entries (Array of <ArrayMax>x45 - from caller)
     C                   PARM                    MsgDtaArr
      ** Front office transaction identifier (20A, from caller)
     C                   PARM                    APFOTranID
      ** Midas module ID (2A)
     C                   Parm                    ModuleID
      ** Midas transaction ID (20A, from caller)
     C                   PARM                    WTRANSID         20
      ** Message file (10A, from caller)
     C                   PARM                    #MsgFile
      ** Action code of transaction (1A, from transaction)
     C                   PARM                    S#ACTN
      ** Status of transaction (1A, F=Failure, S=Success)
     C                   PARM                    TranStatus
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    APRespMode
      ** The following three parameters are needed when messages are to
      ** be displayed on a screen
      ** Screen-handling program (10A, from caller)
     C                   PARM                    #ProcPgm
      ** Screen-handling module (10A, from caller)
     C                   PARM                    #ProcMod
      ** Screen-handling procedure (10A, from caller)
     C                   PARM                    #ProcName
      ** The MQSeries queue to send replies to
     C                   PARM                    APRpyQueue
      ** The transaction's timestamp
     C                   PARM                    TimeStamp
      ** Additional message files to check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MsgFArray
      ** Whether or not to clear the program message queue (1A)
     C                   PARM                    ClrPgmMsgQ
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DtaSubs - Data Substitution                                   *
      *                                                               *
      *****************************************************************
 
     C     DtaSubs       BEGSR
 
      ** Convert file fields to screen format
     C                   CALLB     'LERPRTCVT'
      * Return Code
     C                   PARM      *BLANK        RetCodeIn
      * Input parameters
      * Risk Participant Transaction - file formats
     C                   PARM                    PARTFilFmt
 
      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    FccyFCCY
     C                   PARM                    FccyNBDP
      *
      * Output parameters
      * Risk Participant Transaction Details - screen formats
     C                   PARM                    CurTrRPRT
 
      * Syndicate member details
     C                   PARM                    S#CNUM            6
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#SRNM           20
     C                   PARM                    S#SRTN           10
 
      * Introducing customer details
     C                   PARM                    S#IRNM           20
     C                   PARM                    S#IRTN           10
 
      ** Substitute the data for the various parts of the transaction,
      ** dependent on the flags that were set earlier.
 
     C                   IF        RepRPRT = 'Y'
 
     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInRPRT    IncData        2000
      * Current Data
     C                   PARM      CurTrRPRT     CurData        2000
 
     C                   MOVEL     IncDATA       TranInRPRT
 
     C                   ENDIF
 
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
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      #MsgFile     = 'LERMSGF '
     C                   EVAL      MsgFArray(1) = 'DRSMM'
 
      *  Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'LE'
 
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
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APRPRTDTQ'
 
      * Override LEPARTLR
     C                   Z-ADD     50            MESLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
 
      ** Check if CSC011 is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD = *Blanks
 
     C                   EVAL      CSC011 = 'Y'
 
     C                   IN        SC24X7
     C                   IN        SDSTAT
 
     C                   ELSE
 
      ** Database error
 
     C                   IF        PRTCD <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 900
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C     *LIKE         DEFINE    BRCA          K#BRCA
     C     *LIKE         DEFINE    CNUM          K#PMFC
     C     *LIKE         DEFINE    FACT          K#PMFT
     C     *LIKE         DEFINE    FCNO          K#PMFN
     C     *LIKE         DEFINE    CNUM          K#CSSN
 
      ** Key lists
 
     C     PFCLTK        KLIST
     C                   KFLD                    K#BRCA
     C                   KFLD                    K#PMFC
     C                   KFLD                    K#PMFT
     C                   KFLD                    K#PMFN
     C                   KFLD                    K#CSSN
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LERPRTC018
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
** ##OX1
OVRDBF FILE(LEPARTLR) TOFILE(LEPARTL0) SHARE(*NO)
