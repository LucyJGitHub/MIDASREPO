     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Assignment controller')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Module name ILE Module                               *
      *                                                               *
      *  LEASGNCTL - Assignments Interface Controller                 *
      *                                                               *
      *  Function: This Program Validates LE Assignments for          *
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
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247549             Date 03May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL018             Date 03Feb04               *
      *                 222373             Date 29Oct03               *
      *                 CAP084             Date 02Jun03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP070  *CREATE    Date 08Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247549 - Review delay processing.                            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  222373 - Parameter Mismatch                                  *
      *  CAP084 - Recompiled over changed LEVASGNPD file.             *
      *           Recompiled over changed LEASGNPD format.            *
      *  CAP070 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *****************************************************************
 
      * Valid Transaction file
     FLEVASGNPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      * Invalid Transactions
     FLEIASGNPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FLEVASGNL0 IF   E           K DISK    RENAME(LEVASGND0:LEVASGNCHK)
     F                                     INFSR(*PSSR)
     FLEVASGNL1 IF   E           K DISK    RENAME(LEVASGND0:LEVASGNCK1)
     F                                     INFSR(*PSSR)
 
     FAPILSETPD O  A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,LEASGNC001
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **--------------------------------------------------------------------------------------------
 
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
     D TranInASGN    E DS                  EXTNAME(LEASGNPD)
 
      * Valid Assignments Details layout
     D ValidASGN     E DS                  EXTNAME(LEVASGNPD)
     D                                     PREFIX(V_)
     D  ValidREC              72    140
     D  ValidPAY             141    699
 
 
      * (Current) Transaction record in file Format
     D ASGNFilFmt    E DS                  EXTNAME(LEPARTPD)
     D  LepartREC             72    140
     D  LepartPAY            141    699
 
 
      * (Current) Transaction in Screen Format - Main Details
     D CurTrASGN     E DS                  EXTNAME(LEASGNPD)
     D                                     PREFIX(@)
 
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
      * Pay Settlement Instructions - Input
 
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
      * Receive Settlement Instructions - Input
 
     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS Settlement Instructions - Input
 
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)
      * Pay Settlement Instructions - Current
 
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)
      * Receive Settlement Instructions - Current
 
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)
      * FRA/IRS Settlement Instructions - Current
 
      * File Receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)
     D  FLREC                  1     69
 
      * File Payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
     D  FLPAY                  1    559
 
      * File Fra/irs instructions
     D F_FRI         E DS                  EXTNAME(SDESFFPD)
 
      * Error indicators
     D OKTrASGN      E DS                  EXTNAME(LEEASGNPD)
 
      ** Flags to indicate whether Pay Settlement instruction fields
      **  are valid
     D OKPayInsDS      DS
     D  DDPscyOK                      1A   INZ('Y')
     D  DDPstmOK                      1A   INZ('Y')
     D  DDPonxOK                      1A   INZ('Y')
     D  DDRvnoOK                      1A   INZ('Y')
     D  DDCvmrOK                      1A   INZ('Y')
     D  DDPocnOK                      1A   INZ('Y')
     D  DDPobnOK                      1A   INZ('Y')
     D  DDRcrnOK                      1A   INZ('Y')
     D  DDRcraOK                      1A   INZ('Y')
     D  DDPibnOK                      1A   INZ('Y')
     D  DDPibaOK                      1A   INZ('Y')
     D  DDAwbnOK                      1A   INZ('Y')
     D  DDAwbaOK                      1A   INZ('Y')
     D  DDBennOK                      1A   INZ('Y')
     D  DDBenaOK                      1A   INZ('Y')
     D  DDDtp1OK                      1A   INZ('Y')
     D  DDDtp2OK                      1A   INZ('Y')
     D  DDDtp3OK                      1A   INZ('Y')
     D  DDDtp4OK                      1A   INZ('Y')
     D  DDDchgOK                      1A   INZ('Y')
     D  DDIc72OK                      1A   INZ('Y')
     D  DDBtb1OK                      1A   INZ('Y')
     D  DDBtb2OK                      1A   INZ('Y')
     D  DDBtb3OK                      1A   INZ('Y')
     D  DDBtb4OK                      1A   INZ('Y')
     D  DDBtb5OK                      1A   INZ('Y')
     D  DDBtb6OK                      1A   INZ('Y')
     D  DDPmacOK                      1A   INZ('Y')                                           CLE031
     D  DDPexrOK                      1A   INZ('Y')                                           CLE031
     D  DDPexiOK                      1A   INZ('Y')                                           CLE031
 
      ** Flags to indicate whether Receive Settlement instruction fields
      **  are valid
     D OKRecInsDS      DS
     D  DDRscyOK                      1A   INZ('Y')
     D  DDRstmOK                      1A   INZ('Y')
     D  DDRonxOK                      1A   INZ('Y')
     D  DDRocnOK                      1A   INZ('Y')
     D  DDRobnOK                      1A   INZ('Y')
     D  DDRibnOK                      1A   INZ('Y')
     D  DDRibaOK                      1A   INZ('Y')
     D  DDRmacOK                      1A   INZ('Y')                                           CLE031
     D  DDRexrOK                      1A   INZ('Y')                                           CLE031
     D  DDRexiOK                      1A   INZ('Y')                                           CLE031
 
      ** Flags to indicate whether FRA/IRS instruction fields are valid
     D OKFRAInsDS      DS
     D  DDDsr1OK                      1A   INZ('Y')
     D  DDDsr2OK                      1A   INZ('Y')
     D  DDDsr3OK                      1A   INZ('Y')
     D  DDDsr4OK                      1A   INZ('Y')
     D  DDDsr5OK                      1A   INZ('Y')
     D  DDDsr6OK                      1A   INZ('Y')
     D  DDSsr1OK                      1A   INZ('Y')
     D  DDSsr2OK                      1A   INZ('Y')
     D  DDSsr3OK                      1A   INZ('Y')
     D  DDSsr4OK                      1A   INZ('Y')
     D  DDSsr5OK                      1A   INZ('Y')
     D  DDSsr6OK                      1A   INZ('Y')
     D  DDCnd1OK                      1A   INZ('Y')
     D  DDCnd2OK                      1A   INZ('Y')
     D  DDCnd3OK                      1A   INZ('Y')
     D  DDCnd4OK                      1A   INZ('Y')
     D  DDCnd5OK                      1A   INZ('Y')
     D  DDCnd6OK                      1A   INZ('Y')
     D  DDIsdaOK                      1A   INZ('Y')
     D  DDAgtyOK                      1A   INZ('Y')
     D  DDAgdtOK                      1A   INZ('Y')
     D  DDAgvvOK                      1A   INZ('Y')
 
 
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
 
     D Object          S             10A   INZ('LEASGNUPC')
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
     D RepASGN         S              1A   INZ('N')
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                              CSD095
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
                                                                                              CSD095
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      **   Hook for non-core D-specs (all types)   
      **   also any I-specs (if necessary)         
      **   =====================================   
      ** +----------------------------------------+
      /COPY WNCPYSRC,LEASGNC002
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,LEASGNC003
 
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     TranInASGN
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      * Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,LEASGNC004
 
      *  Check if valid assignment details exists
 
     C                   EXSR      ChkValASGN
      *
      *  If valid ASGN details does exist (even after delay), fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      *  Check if valid Transaction exists for Midas Transaction Number
 
     C                   EXSR      ChkValMiAs
      *
      *  If valid Transaction does exist (even after delay), fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      * Reset variables again in case the details have been corrupted
      * by previous chain to valid Transaction details file.
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,LEASGNC005
 
      *  Validate Action Code
 
     C                   EXSR      ValidateAc
      *
      /COPY WNCPYSRC,LEASGNC006
 
      *  If error in validation of action code, fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
     C                   WHEN         S#ACTN = 'I'
      *  Processing for Inserts
      /COPY WNCPYSRC,LEASGNC007
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,LEASGNC008
     C                   EXSR      DftSettmts
     C                   EXSR      ValidateSt
 
     C                   WHEN         S#ACTN = 'A'
     C                             OR S#ACTN = 'R'
      *  Processing for Amends or Changes
      /COPY WNCPYSRC,LEASGNC009
      * Check for the existence of the replacement character; if this is
      * used, only the changed data has been sent, and all occurrences of
      * the replacement character must be replaced with the corresponding
      * character from the original transaction.
     C                   IF        S#ACTN = 'A' AND GHSUBS <> *BLANK
 
     C     GHSUBS        SCAN      TranInASGN                             99
     C                   IF        *in99
     C                   EVAL      RepASGN = 'Y'
     C                   ENDIF
 
      ** If any of the flags set above is true, do the data
      ** substution subroutine.
     C                   IF        RepASGN = 'Y'
     C                   EXSR      DtaSubs
     C                   ENDIF
 
     C                   ENDIF
      **                 (End of "if S#ACTN = 'A' AND GHSUBS <> *blank")
 
     C                   EXSR      SetupAmd
      /COPY WNCPYSRC,LEASGNC010
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,LEASGNC011
     C                   EXSR      ValidateSt
     C                   EXSR      ValdateAmd
 
     C                   ENDSL
      *
     C     INVALID       TAG
 
      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      *  prompting the database update program
     C                   IN        APDUMP
      /COPY WNCPYSRC,LEASGNC012
 
     C                   IF        ARERRMOD <> *BLANK
     C                   EVAL      MQErrlong  = *blank
     C                   MOVEL     ProcErr       MQError
     C                   MOVE      ARERRMOD      MQError          28
     C                   MOVEL     MQError       MQErrlong
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM      *BLANK        MQReturn         10
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
      /COPY WNCPYSRC,LEASGNC013
     C                   EXSR      CheckWrite
      /COPY WNCPYSRC,LEASGNC014
 
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
      /COPY WNCPYSRC,LEASGNC015
 
     C                   RETURN
 
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * ChkValASGN - Routine to check if valid Transaction details exist *
      *                                                                  *
      ********************************************************************
     C     ChkValASGN    BEGSR
 
     C     APFOTranID    CHAIN     LEVASGNL0                          99
 
      * If record found...
     C                   IF        *IN99 = *OFF
 
      * ..delay, then repeat check
     C**********         CALLB     'ZACDELAY'                                                 247549
     C                   Z-ADD     1             COUNT             2 0                        247549
     C     *IN99         DOWEQ     '0'                                                        247549
     C     COUNT         ANDLE     10                                                         247549
     C                   ADD       1             COUNT                                        247549
     C                   CALLB     'ZACDELAY1'                                                247549
 
     C     APFOTranID    CHAIN     LEVASGNL0                          99
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
 
     C                   CALLB     'LE002500'
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
      * ChkValMiAs - Routine to check if valid Transaction Assignment *
      *    exists for Midas Transaction number                        *
      *                                                               *
      *****************************************************************
 
     C     ChkValMiAs    BEGSR
     C
     C                   IF        S#PMFC <> *BLANKS and S#PMFT <> *BLANKS
     C                             and S#PMFN <> *BLANKS and
     C                             S#ASTS <> *BLANKS
 
      * Access primary facility
 
     C                   EXSR      ACSPFA
 
      * Check for Assignment on Valid file
     C                   MOVE      FcbrBranch    K#BRCA
     C                   MOVE      S#PMFC        K#PMFC
     C                   MOVE      S#PMFT        K#PMFT
     C                   MOVE      S#PMFN        K#PMFN
     C                   MOVE      S#ASTS        K#ASTS
 
      * Check for Transaction on Valid file
     C     PFCLTK        CHAIN     LEVASGNL1                          99
 
      * If record found...
     C                   IF        *IN99 = *OFF
 
      * ..delay, then repeat check
     C**********         CALLB     'ZACDELAY'                                                 247549
     C                   Z-ADD     1             COUNT             2 0                        247549
     C     *IN99         DOWEQ     '0'                                                        247549
     C     COUNT         ANDLE     10                                                         247549
     C                   ADD       1             COUNT                                        247549
     C                   CALLB     'ZACDELAY1'                                                247549
 
     C     PFCLTK        CHAIN     LEVASGNL1                          99
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
     C     GHSUBS        SCAN      TranInASGN    SubForTRNN        2 0
     C                   ENDIF
     C                   IF        S#ACTN = 'I'
     C                   MOVEL     'B'           P#MODE
     C                   ELSE
     C                   IF        TranInASGN = *BLANK
     C                             OR SubForTRNN <> 0
     C                   MOVEL     'B'           P#MODE
     C                   ELSE
     C                   MOVEL     ' '           P#MODE
     C                   ENDIF
     C                   ENDIF
 
      * Validate action code versus transaction IDs supplied
      * The Transaction in file format from the mm database is retrieved
      * as well.
 
     C                   RESET                   ReturnCode
     C                   CALLB     'LEASGNRTV'
      *
      * Inputs
      *
      * Return code
     C                   PARM                    ReturnCode
      * Mode
     C                   PARM                    P#MODE            1
      * Response mode
     C                   PARM                    APRESPMODE
      * Action and assigned to and assigned from customers
     C                   PARM                    S#ACTN
     C                   PARM                    S#ASTS
     C                   PARM                    S#ASFS
 
      * Primary facility customer, type & number
     C                   PARM                    S#PMFC
     C                   PARM                    S#PMFT
     C                   PARM                    S#PMFN
 
      * Prime facility branch
     C                   PARM                    FcbrBranch
 
      * Value date of change
     C                   PARM      *ZERO         In_VDTC           5 0
      *
      * Outputs
      *
      * (Current) Transaction in file format
     C                   PARM                    ASGNFilFmt
      *
      * Action and customer OK indicators
     C                   PARM                    S#ACTNok
     C                   PARM                    S#ASTSok
     C                   PARM                    S#ASFSok
 
      * Assigned to customer number
     C                   PARM                    S#ASTN            6
 
      * Assigned from customer number
     C                   PARM                    S#ASFN            6
 
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
      * DftSettmts - Routine to apply default settlement instructions *
      *    if none have been supplied                                 *
      *                                                               *
      *****************************************************************
 
     C     DftSettmts    BEGSR
 
      * If ANY of the Settlements fields have been entered, bypass this
      *  routine.
      * Otherwise, use modules which will use Standard Settlement
      *  Instructions to apply defaults.
 
     C                   IF            (InRecSttmt = *blank)
     C                             AND (InPaySttmt = *blank)
 
     C                   CALLB     'ZASETINDFT'
 
      ** Output
      ** Calling function type
     C                   PARM      'LEND'        ##CALP            4
      * Payment currency
     C                   PARM      FccyFCCY      ##PCCY            3
      * Receive currency
     C                   PARM      FccyFCCY      ##RCCY            3
      ** Customer (shortname or number)
     C                   PARM      S#ASTN        ##CSNM           10
      * Transaction Type
     C                   PARM      *BLANKS       ##TTYP            2
      ** Federal Funds Ind.
     C                   PARM      *BLANK        ##FFND            1
      ** ISDA Rules for FRA/IRS deals only
      ** Version of ISDA Rules govern
     C                   PARM                    Blank4            4
      ** Type of ISDA agreement
     C                   PARM                    Blank6            6
      ** Date of ISDA Agreement
     C                   PARM                    Blank6
      ** Version of ISDA Agreement
     C                   PARM                    Blank2            2
      ** Version of ISDA Agreement century
     C                   PARM                    Blank2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ** Return
      ** Defaulted Payment Settlement Instruction in file format
     C                   PARM                    F_PAY
      ** Defaulted Receipt Settlement Instruction in file format
     C                   PARM                    F_REC
      ** Defaulted FRA/IRS Settlement Instruction in file format
     C                   PARM                    F_FRI
 
      *  The defaulted instructions are in file format, but the
      *   Settlements validation requires that they are in the input format.
      *  Therefore run them through a conversion module.
 
     C                   CALLB     'ZASETINCVT'
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    F_PAY
     C                   PARM                    F_REC
     C                   PARM      *BLANK        F_FRI
 
      ** Defaulted Settlement Instruction in input format
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM      FccyFCCY      #TRCCY                                      CSF011A
     C                   PARM      FccyFCCY      #TPCCY                                      CSF011A
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateSt - Routine to validate the settlemnt instructions   *
      *                                                               *
      *****************************************************************
 
     C     ValidateSt    BEGSR
 
      * The called module requires that the customer number/name is valid,
      *  if it is not, exit from this subroutine.
     C                   IF        NOT (S#ASTSOK = 'Y')
     C                   GOTO      ValSetExit
     C                   ENDIF
 
      *
      ** PAYMENT DATE & RECEIVE DATE = RUN DATE
      *
     C                   Z-ADD     BJRDNB        ##DATP
     C                   Z-ADD     BJRDNB        ##DATR
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ZASETINVAL'
 
      ** Return Code
     C                   PARM                    ReturnCode
      ** Following parameters are output to called module
      ** Calling function type
     C                   PARM      'LEND'        ##CALP            4
      ** Transaction Fields
      ** Payment currency (or deal currency if only one currency on deal)
     C                   PARM      FccyFCCY      ##CCY             3
      ** Receive currency (or deal currency if only one currency on deal)
     C                   PARM      FccyFCCY      ##CCY             3
      ** Customer (shortname or number)
     C                   PARM      S#ASTN        ##CSNM           10
      ** Deal type
     C                   PARM      *BLANKS       ##TTYP            2
      ** Federal Funds Ind.
     C                   PARM      *BLANKS       ##FFND            1
      ** Booking Branch
     C                   PARM      FcbrBranch    ##BRCA            3
      ** Receipt Date
     C                   PARM                    ##DATR            5 0
      ** Payment Date
     C                   PARM                    ##DATP            5 0
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
      * Action Code
     C                   PARM      S#ACTN        ##ACTN            1
      * Protect Payment Field                                                                 222373
     C                   PARM                    ##PPAY            1                          222373
      * Protect Receipt Field                                                                 222373
     C                   PARM                    ##PREC            1                          222373
 
      ** Following parameters are returned by called module
      ** Payment Instruction OK flag
     C                   PARM                    OKPayInsDS
      ** Receive Instruction OK flag
     C                   PARM                    OKRecInsDS
      ** FRA/IRS Instruction OK flag
     C                   PARM                    OKFRAInsDS
      * Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning Messages                                                                     222373
     C                   PARM                    WFldNamArr                                   222373
     C                   PARM                    WMsgIdArr                                    222373
     C                   PARM                    WMsgDtaArr                                   222373
     C                   PARM                    WIdx                                         222373
      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    F_PAY
     C                   PARM                    F_REC
     C                   PARM                    F_FRI
      ** Extra Input
      ** Action Code used
     C                   PARM      S#ACTN        ##ACTN            1
      ** Validation Iteration
     C                   PARM      '1ST'         ##ValIter         3
 
     C                   MOVEL     FLREC         ValidREC
     C                   MOVEL     FLPAY         ValidPAY
     C                   MOVE      FLCVMR        V_ASCVMR
     C                   MOVE      FLPOBR        V_ASOMDB
     C                   MOVE      FLROBR        V_ASOSDB
     C                   MOVE      FLPSCY        V_ASSCCY
     C                   MOVE      FLRSCY        V_ASSCCY
     C                   MOVE      FLIC72        V_ASICCY
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        V_ASREXR                                     CLE031
     C                   Z-ADD     FLPEXR        V_ASPEXR                                     CLE031
     C                   MOVE      FLREXI        V_ASREXI                                     CLE031
     C                   MOVE      FLPEXI        V_ASPEXI                                     CLE031
     C                   MOVE      FLRSCY        V_ASSCCY                                     CLE031
     C                   MOVE      FLPSCY        V_ASPSCY                                     CLE031
     C                   ENDIF                                                                CLE031
 
     C     ValSetExit    TAG
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdateAmd - Routine to check whether the fields amended      *
      *    are amendable.                                             *
      *                                                               *
      *****************************************************************
 
     C     ValdateAmd    BEGSR
 
      ** This subroutine calls a procedure which checks whether it
      ** was valid to amend any of the fields which have been
      ** changed.
 
     C                   CALLB     'LEASGNCVT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * Assignment details in file format
     C                   PARM                    ASGNFilFmt
 
      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    FccyFCCY
     C                   PARM                    FccyNBDP
      *
      * OUTPUTS
      *
      * Assignment Details in screen format
     C                   PARM                    CurTrASGN
 
      * Assigned to customer details
     C                   PARM                    S#ASTN            6
     C                   PARM                    S#ASTX           10
     C                   PARM                    S#ATNM           20
     C                   PARM                    S#ATTN           10
 
      * Assigned from customer details
     C                   PARM                    S#ASFN            6
     C                   PARM                    S#ASFX           10
     C                   PARM                    S#AFNM           20
     C                   PARM                    S#AFTN           10
 
      ** AMEND CHECKING
     C                   CALLB     'LEASGNAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * New assignment in Screen Format
     C                   PARM                    TranInASGN
      *
      * Current assignment in Screen Format
     C                   PARM                    CurTrASGN
      *
      * Current assignment in File Format
     C                   PARM                    ASGNFilFmt
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    OkTrASGN
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx             3 0
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'N'           ResetErrs         1
 
      ** If any errors overwrite previous error information
 
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
      * SETUPAMD - Set up fields that are needed in the validation    *
      *    of amendments and changes.                                 *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR
 
      * For Amends, put the complete (pre-existing) Transaction into the Valid
      *  file record - fields in this will be updated during processing
 
     C                   MOVEL     ASGNFilFmt    ValidASGN
 
      * For Amends, convert the Assignments transaction to screen format
 
     C                   CALLB     'LEASGNCVT'
      * Inputs
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * Assignment Transaction - file formats
     C                   PARM                    ASGNFilFmt
 
      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    FccyFCCY
     C                   PARM                    FccyNBDP
      *
      * Output parameters
      *
      * Assignments Transaction Details - screen formats
     C                   PARM                    CurTrASGN
 
      * Assigned to customer details
     C                   PARM                    S#ASTN            6
     C                   PARM                    S#ASTX           10
     C                   PARM                    S#ATNM           20
     C                   PARM                    S#ATTN           10
 
      * Assigned from customer details
     C                   PARM                    S#ASFN            6
     C                   PARM                    S#ASFX           10
     C                   PARM                    S#AFNM           20
     C                   PARM                    S#AFTN           10
 
      ** Assignment settlement instructions
 
     C                   MOVEL     LepartREC     FLREC
     C                   MOVEL     LepartPAY     FLPAY
     C                   MOVE      CVMR          FLCVMR
     C                   MOVE      OMDB          FLPOBR
     C                   MOVE      OSDB          FLROBR
     C                   MOVE      SCCY          FLPSCY
     C                   MOVE      SCCY          FLRSCY
     C                   MOVE      ICCY          FLIC72
 
      *  These instructions are in file format, but the
      *   Settlements validation requires that they are in the input format.
      *  Therefore run them through a conversion module.
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     REXR          FLREXR                                       CLE031
     C                   Z-ADD     PEXR          FLPEXR                                       CLE031
     C                   MOVE      REXI          FLREXI                                       CLE031
     C                   MOVE      PEXI          FLPEXI                                       CLE031
     C                   MOVE      SCCY          FLRSCY                                       CLE031
     C                   MOVE      PSCY          FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
 
     C                   CALLB     'ZASETINCVT'
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    F_PAY
     C                   PARM                    F_REC
     C                   PARM      *BLANK        F_FRI
 
      ** Current Settlement Instruction in input format
     C                   PARM                    CrPaySttmt
     C                   PARM                    CrRecSttmt
     C                   PARM                    CrFRASttmt
     C                   PARM      FccyFCCY      #TRCCY                                      CSF011A
     C                   PARM      FccyFCCY      #TPCCY                                      CSF011A
 
      *  If no Payment or Receive instructions have been supplied
      *  Default them to those currently on the deal.
 
     C                   IF            (InPaySttmt = *blank)
     C                   EVAL      InPaySttmt = CrPaySttmt
     C                   ENDIF
 
     C                   IF            (InRecSttmt = *blank)
     C                   EVAL      InRecSttmt = CrRecSttmt
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
 
      * Validate Assignment Transaction details
 
     C                   EXSR      ValdTrASGN
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
      * ValdTrASGN - Validate Assignments Transaction details         *
      *                                                               *
      *****************************************************************
     C     ValdTrASGN    BEGSR
 
     C                   CALLB     'LEASGNVAL'
 
      * Inputs
 
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      ** Assignments Transaction Details
     C                   PARM                    TranInASGN
 
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
      ** Assignments Transaction Details OK inds
     C                   PARM                    OKTrASGN
      *
      * Assigned to customer number
     C                   PARM                    S#ASTN            6
      *
      * Assigned from customer number
     C                   PARM                    S#ASFN            6
      * Assigned to customer name/town
     C                   PARM                    S#ATNM           20
     C                   PARM                    S#ATTN           10
      * Assigned from customer name/town
     C                   PARM                    S#AFNM           20
     C                   PARM                    S#AFTN           10
 
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
 
      * Valid Assignment Transaction (DS) from/to caller
     C                   PARM                    ValidASGN
 
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
     C                   WRITE     LEVASGND0
 
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
 
 
     C                   WRITE     LEIASGND0
     C                   WRITE     APILSETD0
 
      ** Write all invalid records to the support log file
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
 
     C                   EVAL      TRANSDTL = TranInASGN +
     C                                        InRecSttmt +
     C                                        InPaySttmt
 
     C                   EVAL      APTGTTYPE  = 'LEASGN'
     C                   EVAL      PDealNo = S#PMFC + S#PMFT +
     C                                       S#PMFN + S#ASTS
 
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
 
     C                   CLEAR                   CurTrASGN
 
     C                   MOVE      *ALL'Y'       OKTrASGN
 
     C                   CLEAR                   ValidASGN
 
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
     C                   EVAL      XFOTRID    = APFOTranID
     C                   EVAL      XFOASID    = APFOAsocID
     C                   EVAL      XRPRLN     = APRprLocn
     C                   EVAL      XMSGTYP    = 'LEASGN'
     C                   MOVE      TimeStamp     XTMST
 
     C                   EVAL      TranStatus = 'F'
 
      /COPY WNCPYSRC,LEASGNC016
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
      * If there is no front office ID, use the PCREF created by LEASGNVAL.
     C     APFOTranID    Ifeq      *Blank
     C                   MOVEL     V_ASPCRF      V_ASFRNT
     C                   Else
     C                   EVAL      V_ASFRNT = APFOTranID
     C                   EndIf
     C                   EVAL      V_ASAFRT = APFOAsocID
     C                   EVAL      V_ASREPA = APRprLocn
     C                   EVAL      V_ASSTMP = TimeStamp
 
     C                   EVAL      TranStatus = 'S'
 
      /COPY WNCPYSRC,LEASGNC017
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
     C                             + S#PMFT + S#PMFN + S#ASTS
 
     C                   CALLB     'ZAMSGHNDLE'
      ** Return code (10A, returned to this procedure)
     C                   PARM      *BLANK        ReturnCode
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
     C                   RESET                   RetCodeIn
     C                   CALLB     'LEASGNCVT'
      * Return Code
     C                   PARM                    RetCodeIn
      * Input parameters
      * Assignments Transaction - file formats
     C                   PARM                    ASGNFilFmt
 
      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    FccyFCCY
     C                   PARM                    FccyNBDP
      *
      * Output parameters
      * Assignments Transaction Details - screen formats
     C                   PARM                    CurTrASGN
 
      * Assigned to customer details
     C                   PARM                    S#ASTN            6
     C                   PARM                    S#ASTX           10
     C                   PARM                    S#ATNM           20
     C                   PARM                    S#ATTN           10
 
      * Assigned from customer details
     C                   PARM                    S#ASFN            6
     C                   PARM                    S#ASFX           10
     C                   PARM                    S#AFNM           20
     C                   PARM                    S#AFTN           10
 
      ** Substitute the data for the various parts of the transaction,
      ** dependent on the flags that were set earlier.
 
     C                   IF        RepASGN = 'Y'
 
     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInASGN    IncData        2000
      * Current Data
     C                   PARM      CurTrASGN     CurData        2000
 
     C                   MOVEL     IncDATA       TranInASGN
 
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
      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
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
 
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APASGNDTQ'
 
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
     C     *LIKE         DEFINE    CNUM          K#ASTS
                                                                                              CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
                                                                                              CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       PRTCD                                        CLE031
     C                   PARM      '*VERIFY'     POPTN                                        CLE031
     C                   PARM      'CLE031'      PSARD                                        CLE031
                                                                                              CLE031
     C     PRTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
     C     PRTCD         IFEQ      '*NRF'                                                     CLE031
     C                   MOVE      'N'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
                                                                                              CLE031
      ** Database error                                                                       CLE031
                                                                                              CLE031
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE031
     C                   MOVEL     '008'         DBASE                          * DBERR 008 * CLE031
     C                   MOVEL     POPTN         DBKEY                          ************* CLE031
     C                   EXSR      *PSSR                                                      CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
 
      ** Key lists
 
     C     PFCLTK        KLIST
     C                   KFLD                    K#BRCA
     C                   KFLD                    K#PMFC
     C                   KFLD                    K#PMFT
     C                   KFLD                    K#PMFN
     C                   KFLD                    K#ASTS
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEASGNC018
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
** ##OX1
OVRDBF FILE(LEPARTLR) TOFILE(LEPARTL0) SHARE(*NO)
