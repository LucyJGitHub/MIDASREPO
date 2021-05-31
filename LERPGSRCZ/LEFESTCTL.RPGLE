     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee settlement controller')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer lending module                              *
      *                                                               *
      *  LEFESTCTL - Fee Settlement Controller                        *
      *                                                               *
      *  Function: This Program Validates LE Fee Settlements for      *
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
      *  Last Amend No. MD054354           Date 23Oct19               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE073             Date 13May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247549             Date 03May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 CDL018             Date 03Feb04               *
      *                 CSC022             Date 24Feb04               *
      *                 222373             Date 29Oct03               *
      *                 CAP084             Date 10Mar03               *
      *                 CLE031             Date 10Feb03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP072  *CREATE    Date 18Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054354 - Settlement of fee accrual for prior period for    *
      *             backdated notional change                         *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CLE073 - Calculated Loan Based Fees                          *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247549 - Review delay processing.                            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Autorisation to the API's            *
      *           without it.                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  222373 - Parameter Mismatch                                  *
      *  CAP084 - Change settlement processing to standard processing *
      *         - Use 24x7 runday                                     *
      *         - Valid file changed to match LEFEEAD.                *
      *         - Missing fields on display                           *
      *         - parms changed for LEFESTVAL                         *
      *  CLE031 - Lending Enhancements.                               *
      *           LEFEED & LEFEEAD changed  - recompile               *
      *  CAP072 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *****************************************************************
 
      * Valid Transaction file
     FLEVFESTPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      * Invalid Transactions
     FLEIFESTPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FLEVFESTL0 IF   E           K DISK    RENAME(LEVFESTD0:LEVFESTCHK)
     F                                     INFSR(*PSSR)
     FLEVFESTL1 IF   E           K DISK    RENAME(LEVFESTD0:LEVFESTCK1)
     F                                     INFSR(*PSSR)
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,LEFESTC001
 
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
 
      *  Array for job name                                                                   CSC022
     D ARRJBNAM        S             10A   DIM(10)                                            CSC022
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming Transaction
     D TranInFEST    E DS                  EXTNAME(LEFESTPD)
 
      * Valid Fee Settlement Details layout
     D ValidFEST     E DS                  EXTNAME(LEVFESTPD)
     D                                     PREFIX(V_)
     D  ValidREC             124    192
     D  ValidPAY             193    751
 
      * (Current) Transaction record in file Format
     D FESTFilFmt    E DS                  EXTNAME(LEFEEAD)
     D  FESTFilREC           124    192
     D  FESTFilPAY           193    751
 
      * (Current) Transaction in Screen Format - Main Details
     D CurTrFEST     E DS                  EXTNAME(LEFESTPD)
     D                                     PREFIX(@)
 
      * Error indicators
     D OKTrFEST      E DS                  EXTNAME(LEEFESTPD)
                                                                                              CAP086
      ** LE Info Data - Classe 1 Data - File (D/B) format                                     CAP086
                                                                                              CAP086
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
 
      ***Data*structure*for*passing*a*parameter*to*synon*screen                               CAP084
      ***handling*program.************************************                                CAP084
     D****** TranSETLIAB   E DS                  EXTNAME(SETLIAB)                             CAP084
                                                                                              CAP084
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)                                  CAP084
      * Pay Settlement Instructions - Input                                                   CAP084
                                                                                              CAP084
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)                                  CAP084
      * Receive Settlement Instructions - Input                                               CAP084
                                                                                              CAP084
     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)                                  CAP084
      * FRA/IRS Settlement Instructions - Input                                               CAP084
      * (needed as a parameter only)                                                          CAP084
                                                                                              CAP084
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)                        CAP084
      * Pay Settlement Instructions - Current                                                 CAP084
                                                                                              CAP084
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)                        CAP084
      * Receive Settlement Instructions - Current                                             CAP084
                                                                                              CAP084
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)                        CAP084
      * FRA/IRS Settlement Instructions - Current                                             CAP084
      * (needed as a parameter only)                                                          CAP084
 
      * File Receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)
 
      * File Payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
                                                                                              CAP084
      * File Fra/irs instructions                                                             CAP084
     D F_FRI         E DS                  EXTNAME(SDESFFPD)                                  CAP084
      * (needed as a parameter only)                                                          CAP084
 
      ***Data*structure for passing a parameter to synon screen                               CAP084
      ***handling program.                                                                    CAP084
     D******TranSETLIAZ   E DS                  EXTNAME(SETLIAZ)                              CAP084
 
      *                                                                                       CSC022
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
     D  COMITNOM               1      3S 0                                                    CSC022
     D  COMITJOB               4    103                                                       CSC022
      *                                                                                       CSC022
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
     DWtran            DS            20
      * For WTRANID
     DWtran1                   1      6
     DWtran2                   7      7
     DWtran3                   8     12
     DWtran4                  13     14
     DWtran5                  15     20
                                                                                              CAP084
      ** Flags to indicate whether Pay Settlement instruction fields                          CAP084
      **  are valid                                                                           CAP084
     D OKPayInsDS      DS                                                                     CAP084
     D  DDPscyOK                      1A   INZ('Y')                                           CAP084
     D  DDPstmOK                      1A   INZ('Y')                                           CAP084
     D  DDPonxOK                      1A   INZ('Y')                                           CAP084
     D  DDRvnoOK                      1A   INZ('Y')                                           CAP084
     D  DDCvmrOK                      1A   INZ('Y')                                           CAP084
     D  DDPocnOK                      1A   INZ('Y')                                           CAP084
     D  DDPobnOK                      1A   INZ('Y')                                           CAP084
     D  DDRcrnOK                      1A   INZ('Y')                                           CAP084
     D  DDRcraOK                      1A   INZ('Y')                                           CAP084
     D  DDPibnOK                      1A   INZ('Y')                                           CAP084
     D  DDPibaOK                      1A   INZ('Y')                                           CAP084
     D  DDAwbnOK                      1A   INZ('Y')                                           CAP084
     D  DDAwbaOK                      1A   INZ('Y')                                           CAP084
     D  DDBennOK                      1A   INZ('Y')                                           CAP084
     D  DDBenaOK                      1A   INZ('Y')                                           CAP084
     D  DDDtp1OK                      1A   INZ('Y')                                           CAP084
     D  DDDtp2OK                      1A   INZ('Y')                                           CAP084
     D  DDDtp3OK                      1A   INZ('Y')                                           CAP084
     D  DDDtp4OK                      1A   INZ('Y')                                           CAP084
     D  DDDchgOK                      1A   INZ('Y')                                           CAP084
     D  DDIc72OK                      1A   INZ('Y')                                           CAP084
     D  DDBtb1OK                      1A   INZ('Y')                                           CAP084
     D  DDBtb2OK                      1A   INZ('Y')                                           CAP084
     D  DDBtb3OK                      1A   INZ('Y')                                           CAP084
     D  DDBtb4OK                      1A   INZ('Y')                                           CAP084
     D  DDBtb5OK                      1A   INZ('Y')                                           CAP084
     D  DDBtb6OK                      1A   INZ('Y')                                           CAP084
     D  DDPmacOK                      1A   INZ('Y')                                           CLE031
     D  DDPexrOK                      1A   INZ('Y')                                           CLE031
     D  DDPexiOK                      1A   INZ('Y')                                           CLE031
                                                                                              CAP084
      ** Flags to indicate whether Receive Settlement instruction fields                      CAP084
      **  are valid                                                                           CAP084
     D OKRecInsDS      DS                                                                     CAP084
     D  DDRscyOK                      1A   INZ('Y')                                           CAP084
     D  DDRstmOK                      1A   INZ('Y')                                           CAP084
     D  DDRonxOK                      1A   INZ('Y')                                           CAP084
     D  DDRocnOK                      1A   INZ('Y')                                           CAP084
     D  DDRobnOK                      1A   INZ('Y')                                           CAP084
     D  DDRibnOK                      1A   INZ('Y')                                           CAP084
     D  DDRibaOK                      1A   INZ('Y')                                           CAP084
     D  DDRmacOK                      1A   INZ('Y')                                           CLE031
     D  DDRexrOK                      1A   INZ('Y')                                           CLE031
     D  DDRexiOK                      1A   INZ('Y')                                           CLE031
                                                                                              CAP084
      ** Flags to indicate whether FRA/IRS instruction fields are valid                       CAP084
     D OKFRAInsDS      DS            22                                                       CAP084
      * (needed as a parameter only)                                                          CAP084
 
      ** +--------------------------------------+                                             CSC022
      **   Use of Indicator                                                                   CSC022
      **   ================                                                                   CSC022
      ** ¶                                      ¶                                             CSC022
      ** ¶ 17      Used by LOOKUP               ¶                                             CSC022
      ** +--------------------------------------+                                             CSC022
                                                                                              CSC022
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
     D***** Trans5002       S            500A                                                 CAP084
     D***** Trans5003       S            500A                                                 CAP084
                                                                                              CAP086
      ** Field (500A) to receive the incoming Extra Data                                      CAP086
                                                                                              CAP086
     D InfData5001     S            500A                                                      CAP086
 
      ** Indices for arrays used to set up corresponding sequence numbers
      ** for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D Object          S             10A   INZ('LEFESTUPC')
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
     D CAP086          S              1A   INZ('N')                                           CAP086
     D WProcDate       S                   LIKE(BJRDNB)                                       CAP084
     D TRANSDTL        S           5800A
     D PDealNo         S             18A
     D PADealNo        S             18A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D InTrCcy         S              3A                                                     CSF011A
     D InTpCcy         S              3A                                                     CSF011A
                                                                                              CSD095
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
 
     D CSC022          S              1A   INZ('N')                                           CSC022
      ** Counter variable                                                                     CSC022
     D WCMT01          S              1A                                                      CSC022
      ** Commitment Flag                                                                      CSC022
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
      ** Override Database Table
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)
 
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepFEST         S              1A   INZ('N')
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      **   Hook for non-core D-specs (all types)   
      **   also any I-specs (if necessary)         
      **   =====================================   
      ** +----------------------------------------+
      /COPY WNCPYSRC,LEFESTC002
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,LEFESTC003
 
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     TranInFEST
     C******             MOVEL     Trans5002     TranSETLIAB                                  CAP084
     C******             MOVEL     Trans5003     TranSETLIAZ                                  CAP084
     C                   EVAL      Infdata = Infdata5001                                      CAP086
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      * Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,LEFESTC004
 
      *  Set user field depending on action
     C                   SELECT
 
     C                   WHEN         S#ACTN = 'I'
     C                   EVAL         F5IUSR = APMIDUSR
     C                   WHEN         S#ACTN = 'X'
     C                   EVAL         F5XUSR = APMIDUSR
     C                   WHEN         S#ACTN = 'A'
     C                   EVAL         F5AUSR = APMIDUSR
 
     C                   ENDSL
 
      *  Check if valid fee settlement details exists
 
     C                   EXSR      ChkValFEST
      *
      *  If valid FEST details does exist (even after delay), fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      *  Check if valid Transaction exists for Midas Transaction Number
 
     C                   EXSR      ChkValMiFs
      *
      *  If valid Transaction does exist (even after delay), fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      * Reset variables again in case the details have been corrupted
      * by previous chain to valid Transaction details file.
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,LEFESTC005
 
      *  Validate Action Code
 
     C                   EXSR      ValidateAc
      *
      /COPY WNCPYSRC,LEFESTC006
 
      *  If error in validation of action code, fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
     C                   WHEN         S#ACTN = 'I'
      *  Processing for Inserts
      /COPY WNCPYSRC,LEFESTC007
     C                   EXSR      ValidateTr
c    C                   EXSR      DftSettmts                                                 CAP084
     C                   EXSR      ValidateSt
      /COPY WNCPYSRC,LEFESTC008
 
     C                   WHEN         S#ACTN = 'A'
     C                             OR S#ACTN = 'D'
      *  Processing for Amends or Changes
      /COPY WNCPYSRC,LEFESTC009
      * Check for the existence of the replacement character; if this is
      * used, only the changed data has been sent, and all occurrences of
      * the replacement character must be replaced with the corresponding
      * character from the original transaction.
     C                   IF        S#ACTN = 'A' AND GHSUBS <> *BLANK
 
     C     GHSUBS        SCAN      TranInFEST                             99
     C                   IF        *in99
     C                   EVAL      RepFEST = 'Y'
     C                   ENDIF
 
      ** If any of the flags set above is true, do the data
      ** substution subroutine.
     C                   IF        RepFEST = 'Y'
     C                   EXSR      DtaSubs
     C                   ENDIF
 
     C                   ENDIF
      **                 (End of "if S#ACTN = 'A' AND GHSUBS <> *blank")
 
     C                   EXSR      SetupAmd
      /COPY WNCPYSRC,LEFESTC010
     C                   EXSR      ValidateTr
     C                   EXSR      ValidateSt
      /COPY WNCPYSRC,LEFESTC011
 
     C                   ENDSL
      *
     C     INVALID       TAG
 
      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      *  prompting the database update program
     C                   IN        APDUMP
      /COPY WNCPYSRC,LEFESTC012
 
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
      /COPY WNCPYSRC,LEFESTC013
     C                   EXSR      CheckWrite
      /COPY WNCPYSRC,LEFESTC014
 
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
      /COPY WNCPYSRC,LEFESTC015
 
     C                   RETURN
 
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * ChkValFEST - Routine to check if valid Transaction details exist *
      *                                                                  *
      ********************************************************************
     C     ChkValFEST    BEGSR
 
     C     APFOTranID    CHAIN     LEVFESTL0                          99
 
      * If record found...
     C                   IF        *IN99 = *OFF
 
      * ..delay, then repeat check
     C**********         CALLB     'ZACDELAY'                                                 247549
     C                   Z-ADD     1             COUNT             2 0                        247549
     C     *IN99         DOWEQ     '0'                                                        247549
     C     COUNT         ANDLE     10                                                         247549
     C                   ADD       1             COUNT                                        247549
     C                   CALLB     'ZACDELAY1'                                                247549
 
     C     APFOTranID    CHAIN     LEVFESTL0                          99
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
      *                                                               *
      * ChkValMiFs - Routine to check if valid Transaction Fees       *
      *    Settlements exists for Midas Transaction number            *
      *                                                               *
      *****************************************************************
 
     C     ChkValMiFs    BEGSR
 
      * Check for Transaction on Valid file
     C                   MOVEL     S#CSSN        K#CNUM
     C                   MOVEL     S#FACT        K#FACL
     C                   MOVE      S#FCNO        K#FACL
     C                   IF        CLE073 = 'N'                                               CLE073
     C**********         Z-ADD     0             K#LOAN                                       CLE148
     C                   MOVEL     *BLANK        K#LOAN                                       CLE148
     C                   ELSE                                                                 CLE073
     C                   MOVEL     S#LOAN        K#LOAN                                       CLE073
     C                   ENDIF                                                                CLE073
     C                   MOVE      S#FSEQ        K#FSEQ
     C                   MOVE      S#VDAT        K#VDAT
 
     C     KFSTL1        CHAIN     LEVFESTL1                          99
 
      * If record found...
     C                   IF        *IN99 = *OFF
 
      * ..delay, then repeat check
     C**********         CALLB     'ZACDELAY'                                                 247549
     C                   Z-ADD     1             COUNT             2 0                        247549
     C     *IN99         DOWEQ     '0'                                                        247549
     C     COUNT         ANDLE     10                                                         247549
     C                   ADD       1             COUNT                                        247549
     C                   CALLB     'ZACDELAY1'                                                247549
 
     C     KFSTL1        CHAIN     LEVFESTL1                          99
     C                   END                                                                  247549
 
      * Error if still present
     C                   IF        *IN99 = *OFF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDLOAN'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
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
     C     GHSUBS        SCAN      TranInFEST    SubForTRNN        2 0
     C                   ENDIF
     C                   IF        S#ACTN = 'I'
     C                   MOVEL     'B'           P#MODE
     C                   ELSE
     C                   IF        TranInFEST = *BLANK
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
     C                   CALLB     'LEFESTRTV'
      *
      * Inputs
      *
      * Return code
     C                   PARM                    ReturnCode
      * Mode
     C                   PARM                    P#MODE            1
      * Response Code
     C                   PARM      ' '           RESPMODE          1
      *
      * Action, customer, facility type, facility number,
      * fee sequence number and value date
     C                   PARM                    S#ACTN            1
     C                   PARM                    S#CSSN           10
     C                   PARM                    S#FACT            3
     C                   PARM                    S#FCNO            2
     C                   PARM                    S#FSEQ            2
     C                   PARM                    S#VDAT            6
     C                   PARM                    S#LOAN            6                          CLE073
      *
      * OUTPUTS
 
      * Fee Settlement Details in file format
     C                   PARM                    FESTFilFmt
 
      * Action, customer, facility type, facility number,
      * fee sequence number and value date OK indicators
     C                   PARM                    S#ACTNok
     C                   PARM                    S#CSSNok
     C                   PARM                    S#FACTok
     C                   PARM                    S#FCNOok
     C                   PARM                    S#FSEQok
     C                   PARM                    S#VDATok
     C                   PARM                    S#LOANok          1                          CLE073
 
      * Customer number
     C                   PARM                    S#CNUM            6
 
      * Fee currency and decimal places
     C                   PARM                    S#FCCY            3
     C                   PARM                    FecyNBDP          1 0
 
      * Fee type, fee code, fee narrative, fee amount due/past due
     C                   PARM                    S#FTYP           10
     C                   PARM                    S#FCOD            2
     C                   PARM                    S#FENV           20
     C                   PARM                    S#DUPD           18
 
      * Value date
     C                   PARM                    W#VDAT            5 0
 
      * Settlement settlement due date
     C                   PARM                    W#SADD            5 0
 
      * Participant Fee Indicator
     C                   PARM                    W#PTFI            1
 
      * Fee amount past due
     C                   PARM                    W#CPAM           13 0
 
      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx               3 0
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx              3 0
 
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
 
     C                   MOVEL     FESTFilFmt    ValidFEST
 
      * For Amends, convert the Fee Settlement transaction to screen format
 
     C                   CALLB     'LEFESTCVT'
      * Inputs
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * Fee Settlement Transaction - file formats
     C                   PARM                    FESTFilFmt
      *
      * Output parameters
      *
      * Fee Settlement Transaction Details - screen formats
     C                   PARM                    CurTrFEST
 
      * Customer details
     C                   PARM                    S#CNUM            6
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10
 
      * Fee currency and decimal places
     C*******            PARM                    S#FCCY            3                          CAP084
     C                   PARM                    FecyNBDP          1 0
 
      * Value date (alpha)
     C                   PARM                    S#VDTA            7
 
      * Settlement amount edited
     C                   PARM                    S#SADE           19
 
      * Record status
     C                   PARM                    S#STAT           10
      * Fee Amount Sign                                                                     MD054354
     C                   PARM                    P_SIGN            1                        MD054354
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
 
      * Validate Fees Settlement Transaction details
 
     C                   EXSR      ValdTrFEST
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
     C     EValidTr      ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************                       CAP084
      *                                                               *                       CAP084
      * DftSettmts - Routine to apply default settlement instructions *                       CAP084
      *    if none have been supplied                                 *                       CAP084
      *                                                               *                       CAP084
      *****************************************************************                       CAP084
                                                                                              CAP084
     C     DftSettmts    BEGSR                                                                CAP084
      *                                                                                       CAP084
      * If ANY of the Settlements fields have been entered, bypass this                       CAP084
      * routine.                                                                              CAP084
      * Otherwise, use modules which will use Standard Settlement                             CAP084
      * Instructions to apply defaults.                                                       CAP084
     C                   IF            (InRecSttmt = *blank)                                  CAP084
     C                             AND (InPaySttmt = *blank)                                  CAP084
                                                                                              CAP084
     C                   CALLB     'ZASETINDFT'                                               CAP084
                                                                                              CAP084
      ** Output                                                                               CAP084
      ** Calling function type                                                                CAP084
     C                   PARM      'LEND'        ##CALP            4                          CAP084
      * Payment currency                                                                      CAP084
     C                   PARM      FccyFCCY      ##PCCY            3                          CAP084
      * Receive currency                                                                      CAP084
     C                   PARM      FccyFCCY      ##RCCY            3                          CAP084
      ** Customer (shortname or number)                                                       CAP084
     C                   PARM      S#CNUM        ##CSNM           10                          CAP084
      * Transaction Type                                                                      CAP084
     C                   PARM      *BLANKS       ##TTYP            2                          CAP084
      ** Federal Funds Ind.                                                                   CAP084
     C                   PARM      *BLANK        ##FFND            1                          CAP084
      ** ISDA Rules for FRA/IRS deals only                                                    CAP084
      ** Version of ISDA Rules govern                                                         CAP084
     C                   PARM                    Blank4            4                          CAP084
      ** Type of ISDA agreement                                                               CAP084
     C                   PARM                    Blank6            6                          CAP084
      ** Date of ISDA Agreement                                                               CAP084
     C                   PARM                    Blank6                                       CAP084
      ** Version of ISDA Agreement                                                            CAP084
     C                   PARM                    Blank2            2                          CAP084
      ** Version of ISDA Agreement century                                                    CAP084
     C                   PARM                    Blank2                                       CAP084
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *                                                                                       CAP084
      ** Return                                                                               CAP084
      ** Defaulted Payment Settlement Instruction in file format                              CAP084
     C                   PARM                    F_PAY                                        CAP084
      ** Defaulted Receipt Settlement Instruction in file format                              CAP084
     C                   PARM                    F_REC                                        CAP084
      ** Defaulted FRA/IRS Settlement Instruction in file format                              CAP084
     C                   PARM                    F_FRI                                        CAP084
                                                                                              CAP084
      *  The defaulted instructions are in file format, but the                               CAP084
      *  Settlements validation requires that they are in the input format.                   CAP084
      *  Therefore run them through a conversion module.                                      CAP084
                                                                                              CAP084
     C                   CALLB     'ZASETINCVT'                                               CAP084
      ** Defaulted Settlement Instructions in file format                                     CAP084
     C                   PARM                    F_PAY                                        CAP084
     C                   PARM                    F_REC                                        CAP084
     C                   PARM      *BLANK        F_FRI                                        CAP084
                                                                                              CAP084
      ** Defaulted Settlement Instruction in input format                                     CAP084
     C                   PARM                    InPaySttmt                                   CAP084
     C                   PARM                    InRecSttmt                                   CAP084
     C                   PARM                    InFRASttmt                                   CAP084
     C                   PARM      S#FCCY        InTrCcy                                     CSF011A
     C                   PARM      S#FCCY        InTpCcy                                     CSF011A
                                                                                              CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C                   ENDSR                                                                CAP084
      *****************************************************************                       CAP084
      * Validate settlement instructions
      *****************************************************************
     C     ValidateSt    BEGSR
      *                                                                                       CAP084
      ** Set up customer                                                                      CAP084
     C                   MOVEL     S#CNUM        ##CSNM                                       CAP084
      *                                                                                       CAP084
      * If no dates entered, use today's date                                                 CAP084
     C                   If        ##DATR = 0                                                 CAP084
     C                   Eval      ##DATR = WProcDate                                         CAP084
     C                   EndIf                                                                CAP084
     C                   If        ##DATP = 0                                                 CAP084
     C                   Eval      ##DATP = WProcDate                                         CAP084
     C                   EndIf                                                                CAP084
                                                                                              CAP084
     C                   RESET                   ReturnCode                                   CAP084
     C                   CALLB     'ZASETINVAL'                                               CAP084
                                                                                              CAP084
      ** Return Code                                                                          CAP084
     C                   PARM                    ReturnCode                                   CAP084
      ** Following parameters are output to called module                                     CAP084
      ** Calling function type                                                                CAP084
     C                   PARM      'LEND'        ##CALP            4                          CAP084
      ** Transaction Fields                                                                   CAP084
      ** Payment currency                                                                     CAP084
     C                   PARM      FccyFCCY      ##CCY             3                          CAP084
      ** Receive currency                                                                     CAP084
     C                   PARM      FccyFCCY      ##CCY             3                          CAP084
      ** Customer (shortname or number)                                                       CAP084
     C                   PARM                    ##CSNM           10                          CAP084
      ** Deal type                                                                            CAP084
     C                   PARM      *BLANKS       ##TTYP            2                          CAP084
      ** Federal Funds Ind.                                                                   CAP084
     C                   PARM      *BLANKS       ##FFND            1                          CAP084
      ** Booking Branch                                                                       CAP084
     C                   PARM      FcbrBranch    ##BRCA            3                          CAP084
      ** Receipt Date                                                                         CAP084
     C                   PARM                    ##DATR            5 0                        CAP084
      ** Payment Date                                                                         CAP084
     C                   PARM                    ##DATP            5 0                        CAP084
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction                  CAP084
     C                   PARM                    InPaySttmt                                   CAP084
     C                   PARM                    InRecSttmt                                   CAP084
     C                   PARM                    InFRASttmt                                   CAP084
      * Action Code                                                                           CAP084
     C                   PARM      S#ACTN        ##ACTN            1                          CAP084
                                                                                              CAP084
      * Protect Payment Field                                                                 CAP084
     C                   PARM                    ##PPAY            1                          CAP084
      * Protect Receipt Field                                                                 CAP084
     C                   PARM                    ##PREC            1                          CAP084
                                                                                              CAP084
      ** Following parameters are returned by called module                                   CAP084
      ** Payment Instruction OK flag                                                          CAP084
     C                   PARM                    OKPayInsDS                                   CAP084
      ** Receive Instruction OK flag                                                          CAP084
     C                   PARM                    OKRecInsDS                                   CAP084
      ** FRA/IRS Instruction OK flag                                                          CAP084
     C                   PARM                    OKFRAInsDS                                   CAP084
      * Error fields/message IDs (arrays) from/to caller                                      CAP084
     C                   PARM                    FldNameArr                                   CAP084
     C                   PARM                    MsgIDArr                                     CAP084
      * Array index (3P0) from/to caller                                                      CAP084
     C                   PARM                    Idx                                          CAP084
      ** Warning Messages                                                                     222373
     C                   PARM                    WFldNamArr                                   222373
     C                   PARM                    WMsgIdArr                                    222373
     C                   PARM                    WMsgDtaArr                                   222373
     C                   PARM                    WIdx                                         222373
      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction                            CAP084
     C                   PARM                    F_PAY                                        CAP084
     C                   PARM                    F_REC                                        CAP084
     C                   PARM                    F_FRI                                        CAP084
      ** Extra Input                                                                          CAP084
      ** Action Code used                                                                     CAP084
     C                   PARM      S#ACTN        ##ACTN            1                          CAP084
      ** Validation Iteration                                                                 CAP084
     C                   PARM      '1ST'         ##ValIter         3                          CAP084
                                                                                              CAP084
     C                   MOVEL     F_REC         ValidREC                                     CAP084
     C                   MOVEL     F_PAY         ValidPAY                                     CAP084
     C                   MOVE      FLCVMR        V_STCVMR                                     CAP084
     C                   MOVE      FLPOBR        V_STOMDB                                     CAP084
     C                   MOVE      FLROBR        V_STOSDB                                     CAP084
     C                   MOVE      FLPSCY        V_STSCCY                                     CAP084
     C                   MOVE      FLRSCY        V_STSCCY                                     CAP084
     C                   MOVE      FLIC72        V_STICCY                                     CAP084
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        V_STREXR                                     CLE031
     C                   Z-ADD     FLPEXR        V_STPEXR                                     CLE031
     C                   MOVE      FLREXI        V_STREXI                                     CLE031
     C                   MOVE      FLPEXI        V_STPEXI                                     CLE031
     C                   MOVE      FLRSCY        V_STSCCY                                     CLE031
     C                   MOVE      FLPSCY        V_STPSCY                                     CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CAP084
     C     ValSetExit    TAG                                                                  CAP084
      *********                                                                               CAP084
      *********                                                                               CAP084
      ***Setup*the settlement screen fields (SETLIAB/SETLIAZ)                                 CAP084
      *********                                                                               CAP084
     C*********          EXSR      SETUP_SSCR                                                 CAP084
      *********                                                                               CAP084
      ***Call*extended settlements input                                                      CAP084
      *********                                                                               CAP084
     C*********          CALL      'SD2410'                                                   CAP084
     C*********          PARM                    TranSETLIAB                                  CAP084
     C*********          PARM                    TranSETLIAZ                                  CAP084
      *********                                                                               CAP084
      ***Terminate program if database error returned                                         CAP084
      *********                                                                               CAP084
     C*****PMDBSE        IFNE      *ZERO                                                      CAP084
     C*********          MOVEL     PMDBFL        DBFILE                                       CAP084
     C*********          Z-ADD     PMDBSE        DBASE                                        CAP084
     C*********          MOVEL     PMDBKY        DBKEY                                        CAP084
     C*********          EXSR      *PSSR                                                      CAP084
     C*********          ENDIF                                                                CAP084
      *********                                                                               CAP084
      ***If*there are errors in the settlement screen                                         CAP084
      ***log*them                                                                             CAP084
      ***Otherwise, update the file fields with the screen fields                             CAP084
      *********                                                                               CAP084
     C*****PMERCD        IFNE      *BLANKS                                                    CAP084
     C*********          ADD       1             Idx                                          CAP084
     C*********          EVAL      FldNameArr(Idx) = '*ANY'                                   CAP084
     C*********          EVAL      MsgIDArr(Idx)   = 'LEA1020'                                CAP084
     C*********          ELSE                                                                 CAP084
     C*********          EXSR      SET_SC2FL                                                  CAP084
     C*********          ENDIF                                                                CAP084
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      **Setup*the settlement screen fields (SETLIAB/SETLIAZ)                                  CAP084
      *****************************************************************                       CAP084
     C*****SETUP_SSCR    BEGSR                                                                CAP084
      *********                                                                               CAP084
      ***Set*action, customer, currencies and branch for settlement screen                    CAP084
      *********                                                                               CAP084
     C*****TranSETLIAB   IFEQ      *BLANKS                                                    CAP084
     C*********          MOVE      S#ACTN        PMACTC                                       CAP084
     C*********          MOVE      'LEND'        PMCPGM                                       CAP084
     C*********          MOVEL     S#CNUM        PMCSNM                                       CAP084
     C*********          Z-ADD     BJRDNB        PMDTRC                                       CAP084
     C*********          Z-ADD     BJRDNB        PMDTPY                                       CAP084
     C*********          MOVE      FccyFCCY      PMRCCY                                       CAP084
     C*********          MOVE      FccyFCCY      PMPCCY                                       CAP084
     C*********          MOVE      *BLANK        PMFFND                                       CAP084
     C*********          MOVE      FcbrBranch    PMBRCA                                       CAP084
     C*********          MOVE      *BLANK        PMCMDP                                       CAP084
     C*********          Z-ADD     0             PMDBSE                                       CAP084
     C*********          MOVE      *BLANKS       PMERCD                                       CAP084
     C*********          Z-ADD     BJRDNB        PMRUND                                       CAP084
      *********                                                                               CAP084
      ***Set*settlement details valid flag                                                    CAP084
      *********                                                                               CAP084
     C*********          MOVE      'N'           PMSDTV                                       CAP084
     C*********          ENDIF                                                                CAP084
      *********                                                                               CAP084
     C*********          ENDSR                                                                CAP084
      *****************************************************************                       CAP084
      ********SPACE*5*                                                                        CAP084
      *****************************************************************                       CAP084
      **Move*settlement file fields to screen fields (SETLIAB/SETLIAZ)*                       CAP084
      *****************************************************************                       CAP084
     C*****SET_FL2SC     BEGSR                                                                CAP084
      *********                                                                               CAP084
     C*********          CALLB     'LESTFL2SC'                                                CAP084
      *********                                                                               CAP084
      **INPUTS*                                                                               CAP084
      *********                                                                               CAP084
      **Return*Code                                                                           CAP084
     C*********          PARM                    RetCodeIn                                    CAP084
      *********                                                                               CAP084
      **File*Receive instructions                                                             CAP084
     C*********          PARM                    F_REC                                        CAP084
      *********                                                                               CAP084
      **File*Payment instructions                                                             CAP084
     C*********          PARM                    F_PAY                                        CAP084
      *********                                                                               CAP084
      **OUTPUTS                                                                               CAP084
      *********                                                                               CAP084
      **Screen*receive and payment instructions                                               CAP084
     C*********          PARM                    TranSETLIAB                                  CAP084
     C*********          PARM                    TranSETLIAZ                                  CAP084
      *********                                                                               CAP084
     C*********          ENDSR                                                                CAP084
      *****************************************************************                       CAP084
      *******/SPACE*5*                                                                        CAP084
      *****************************************************************                       CAP084
      **Move*settlement screen fields to file fields                  *                       CAP084
      *****************************************************************                       CAP084
     C*****SET_SC2FL     BEGSR                                                                CAP084
      *********                                                                               CAP084
     C*********          CALLB     'LESTSC2FL'                                                CAP084
      *********                                                                               CAP084
      **INPUTS*                                                                               CAP084
      *********                                                                               CAP084
      **Return*Code                                                                           CAP084
     C*********          PARM                    RetCodeIn                                    CAP084
      *********                                                                               CAP084
      **Screen*receive and payment instructions                                               CAP084
     C*********          PARM                    TranSETLIAB                                  CAP084
     C*********          PARM                    TranSETLIAZ                                  CAP084
      *********                                                                               CAP084
      **OUTPUTS                                                                               CAP084
      *********                                                                               CAP084
      *********                                                                               CAP084
      **File*Receive instructions                                                             CAP084
     C*********          PARM                    F_REC                                        CAP084
      *********                                                                               CAP084
      **File*Payment instructions                                                             CAP084
     C*********          PARM                    F_PAY                                        CAP084
      *********                                                                               CAP084
      ***Funding Participant settlement instructions                                          CAP084
      *********                                                                               CAP084
     C*********          MOVEL     F_REC         ValidREC                                     CAP084
     C*********          MOVEL     F_PAY         ValidPAY                                     CAP084
     C*********          MOVE      FLCVMR        V_STCVMR                                     CAP084
     C*********          MOVE      FLPOBR        V_STOMDB                                     CAP084
     C*********          MOVE      FLROBR        V_STOSDB                                     CAP084
     C*********          MOVE      FLPSCY        V_STSCCY                                     CAP084
     C*********          MOVE      FLRSCY        V_STSCCY                                     CAP084
     C*********          MOVE      FLIC72        V_STICCY                                     CAP084
      *********                                                                               CAP084
     C*********          ENDSR                                                                CAP084
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrFEST - Validate Fee Settlement Transaction details      *
      *                                                               *
      *****************************************************************
     C     ValdTrFEST    BEGSR
 
     C                   CALLB     'LEFESTVAL'
 
      * Inputs
 
      * Return Code
     C                   PARM      *BLANK        RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      ** Fees Settlement Transaction Details
     C                   PARM                    TranInFEST
 
      * Fee currency and decimal places
     C*******            PARM                    S#FCCY            3                          CAP084
     C                   PARM                    FecyNBDP          1 0
 
      * Value date
     C                   PARM                    W#VDAT            5 0
 
      * Settlement settlement due date
     C                   PARM                    W#SADD            5 0
 
      * Participant Fee Indicator
     C                   PARM                    W#PTFI            1
 
      * Fee amount past due
     C                   PARM                    W#CPAM           13 0
 
      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
 
      * Front Office Inputs (if mode = 'B')
     C                   PARM                    F5PCOB            3
     C                   PARM                    F5TNRF           15
     C                   PARM                    F5IUSR           10
     C                   PARM                    F5XUSR           10
     C                   PARM                    F5AUSR           10
     C                   PARM                    FESTFilFmt                                 MD054354
     C                   PARM                    P_SIGN                                     MD054354
      * Outputs
      *
      * Status                                                                                CAP084
     C                   PARM                    S#STAT           10                          CAP084
      * Fee Type                                                                              CAP084
     C                   PARM                    S#FTYP           10                          CAP084
      * Fee Code                                                                              CAP084
     C                   PARM                    S#FCOD            2                          CAP084
      * Fee Code description                                                                  CAP084
     C                   PARM                    S#FENV           20                          CAP084
      * Fee Amount Due/Past Due                                                               CAP084
     C                   PARM                    S#DUPD           18                          CAP084
      ** Fees Settlement  Transaction Details OK inds
     C                   PARM                    OKTrFEST
 
      * Settlement amount
     C                   PARM                    W#SADJ           13 0
 
      * Settlement amount edited
     C                   PARM                    S#SADE           19
 
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
 
      * Valid Fee Settlements Transaction (DS) from/to caller
     C                   PARM                    ValidFEST
 
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
     C                   WRITE     LEVFESTD0
 
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
 
     C                   WRITE     LEIFESTD0
 
      ** Write all invalid records to the support log file
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
 
     C                   EVAL      TRANSDTL = TranInFEST +
     C                             InPaySttmt +                                               CAP084
     C                             InRecSttmt                                                 CAP084
     C*********                               TranSETLIAB +                                   CAP084
     C*********                               TranSETLIAZ                                     CAP084
 
     C                   EVAL      APTGTTYPE  = 'LEFEST'
     C                   IF        S#FACT  <> *BLANKS                                         CLE073
     C                   EVAL      PDealNo = S#CSSN + S#FACT +
     C                                       S#FCNO + S#FSEQ +
     C                                       S#VDAT
     C                   ELSE                                                                 CLE073
     C                   EVAL      PDealNo = S#CSSN + S#LOAN +                                CLE073
     C                                       S#FSEQ + S#VDAT                                  CLE073
     C                   ENDIF                                                                CLE073
 
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
 
     C     CSC022        IFEQ      'N'                                                        CSC022
     C     WCMT01        OREQ      'N'                                                        CSC022
     C     CSC022        ANDEQ     'Y'                                                        CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
 
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
 
     C                   CLEAR                   CurTrFEST
 
     C                   MOVE      *ALL'Y'       OKTrFEST
 
     C                   CLEAR                   ValidFEST
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPINVAL - Set up additional fields that are needed on the  *
      *      invalid file record.                                     *
      *                                                               *
      *****************************************************************
 
     C     SETUPINVAL    BEGSR
 
      * Include Header fields that need to be o/p to the Invalid files
     C                   EVAL      DDFRNT     = APFOTranID
     C                   EVAL      DDAFRT     = APFOAsocID
     C                   EVAL      DDREPA     = APRprLocn
     C                   MOVE      TimeStamp     XTMST
                                                                                              CAP086
      ** Setup the Automatic Autorisation Flag                                                CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      F5AUTH = IF_AUTH                                           CAP086
     C                   ENDIF                                                                CAP086
 
     C                   EVAL      TranStatus = 'F'
 
      /COPY WNCPYSRC,LEFESTC016
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
     C                   MOVEL     V_STPCRF      V_STFRNT
     C                   Else
     C                   EVAL      V_STPCRF = APFOTranID
     C                   EndIf
     C                   EVAL      V_STAFRT = APFOAsocID
     C                   EVAL      V_STREPA = APRprLocn
     C                   EVAL      V_STSTMP = TimeStamp
                                                                                              CAP086
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      STAUTH = IF_AUTH                                           CAP086
     C                   ENDIF                                                                CAP086
 
     C                   EVAL      TranStatus = 'S'
 
      /COPY WNCPYSRC,LEFESTC017
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
 
      ** Setup WTRANSID through data structure
     C                   MOVE      K#CNUM        Wtran1
     C                   IF        K#FACL <> 0
     C                   MOVE      'F'           Wtran2
     C                   MOVE      K#FACL        Wtran3
     C                   ENDIF
     C**********         IF        K#LOAN <> 0                                                CLE148
     C                   IF        K#LOAN <> *BLANK                                           CLE148
     C                   MOVEL     K#LOAN        Wtran2
     C                   MOVE      K#LOAN        Wtran3
     C                   ENDIF
     C                   MOVE      K#FSEQ        Wtran4
     C                   MOVEL     K#VDAT        Wtran5
     C                   EVAL      WTRANSID = Wtran
 
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
     C                   RESET                   RetCodeIn
     C                   CALLB     'LEFESTCVT'
      * Return Code
     C                   PARM                    RetCodeIN
      * Input parameters
      * FEE Settlement Transaction - file formats
     C                   PARM                    FESTFilFmt
      *
      * Output parameters
      * Fee Settlement Transaction Details - screen formats
     C                   PARM                    CurTrFEST
 
      * Customer details
     C                   PARM                    S#CNUM            6
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10
 
      * Fee currency and decimal places
     C*******            PARM                    S#FCCY            3                          CAP084
     C                   PARM                    FecyNBDP          1 0
 
      * Value date (alpha)
     C                   PARM                    S#VDTA            7
 
      * Settlement amount edited
     C                   PARM                    S#SADE           19
 
      * Record status
     C                   PARM                    S#STAT           10
      * Fee Amount Sign                                                                     MD054354
     C                   PARM                    P_SIGN            1                        MD054354
      ** Substitute the data for the various parts of the transaction,
      ** dependent on the flags that were set earlier.
 
     C                   IF        RepFEST = 'Y'
 
     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInFEST    IncData        2000
      * Current Data
     C                   PARM      CurTrFEST     CurData        2000
 
     C                   MOVEL     IncDATA       TranInFEST
 
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
     C******             PARM                    Trans5002                                    CAP084
     C******             PARM                    Trans5002                                    CAP084
     C                   PARM                    InfData5001                                  CAP086
     C                   PARM                    InPaySttmt                                   CAP084
     C                   PARM                    InRecSttmt                                   CAP084
     C                   PARM                    InFraSttmt                                   CAP084
     C                   PARM                    P_SIGN                                     MD054354
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      #MsgFile     = 'LERMSGF'
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
     C                   EVAL      DtaQName = 'APFESTDTQ'
 
     C* Override LEFESTLR
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
                                                                                              CAP084
      ** If 24X7 Midas availability is installed and support system is                        CAP084
      ** active, used processing date from dataarea SC24X7 as the                             CAP084
      ** rundate.                                                                             CAP084
     C                   IF        CSC011 = 'Y' AND                                           CAP084
     C                             S1SUPP = LIBR                                              CAP084
     C                   EVAL      WProcDate = S1DATE                                         CAP084
     C                   ELSE                                                                 CAP084
     C                   EVAL      WProcDate = BJRDNB                                         CAP084
     C                   ENDIF                                                                CAP084
 
      ** Key lists
 
      ** Key list for file LEVFESTL1
     C     *LIKE         DEFINE    STCNUM        K#CNUM
     C     *LIKE         DEFINE    STFACL        K#FACL
     C     *LIKE         DEFINE    STLOAN        K#LOAN
     C     *LIKE         DEFINE    STFSEQ        K#FSEQ
     C     *LIKE         DEFINE    STVDAT        K#VDAT
 
     C     KFSTL1        KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACL
     C                   KFLD                    K#LOAN
     C                   KFLD                    K#FSEQ
     C                   KFLD                    K#VDAT
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEFESTC018
 
      * Determine if CSC022 is switched on                                                    CSC022
                                                                                              CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRTCD                                        CSC022
     C                   PARM      '*VERIFY'     POPTN                                        CSC022
     C                   PARM      'CSC022'      PSARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
     C                   IF        PRTCD = *BLANK                                             CSC022
     C                   EVAL      CSC022 ='Y'                                                CSC022
     C                   EVAL      WCMT01 ='N'                                                CSC022
      * SCCMTJOB data area                                                                    CSC022
     C                   IN        SCCMTJOB                                                   CSC022
      * Move data area to commitment array                                                    CSC022
     C                   IF        COMITNOM > 0                                               CSC022
     C                   MOVEA     COMITJOB      ARRJBNAM                                     CSC022
      *                                                                                       CSC022
      * Check if PSJOBNAME exist.                                                             CSC022
     C     PSJOBNAME     LOOKUP    ARRJBNAM                               17                  CSC022
     C                   IF        *IN17 = *ON                                                CSC022
     C                   EVAL      WCMT01= 'Y'                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                       CSC022
     C                   ELSE                                                                 CSC022
      * @rtcd not found                                                                       CSC022
     C                   IF        PRTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBPGM = 'LEFESTCTL'                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE ='SCSARDPD'                                         CSC022
     C                   EVAL      DBASE  = 902                                               CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
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
     C                   MOVEL     '908'         DBASE                          * DBERR 008 * CLE031
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE031
     C                   EXSR      *PSSR                                                      CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CSC022
                                                                                              CAP086
      ** Access SAR details file to determine if                                              CAP086
      ** Automatic Authorisation (LE Part) is installed                                       CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALL      'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       PRTCD                                        CAP086
     C                   PARM      '*VERIFY'     POPTN                                        CAP086
     C                   PARM      'CAP086'      PSARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        PRTCD <> *BLANKS AND                                       CAP086
     C                             PRTCD <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBPGM = 'LEFESTCTL'                                        CAP086
     C                   EVAL      DBKEY = 'CAP086'                                           CAP086
     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP086
     C                   EVAL      DBASE  = 903                                               CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        PRTCD = *BLANK                                             CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
      ** Check if CLE083 - Calculation of loan based fees is installed                        CLE073
                                                                                              CLE073
     C                   CALL      'AOSARDR0'                                                 CLE073
     C                   PARM      *BLANKS       @RTCD                                        CLE073
     C                   PARM      '*KEY    '    @OPTN                                        CLE073
     C                   PARM      'CLE073'      @SARD             6                          CLE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE073
                                                                                              CLE073
     C     @RTCD         IFEQ      *BLANKS                                                    CLE073
     C                   MOVEL     'Y'           CLE073                                       CLE073
     C                   ELSE                                                                 CLE073
     C                   MOVEL     'N'           CLE073            1                          CLE073
     C                   ENDIF                                                                CLE073
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
** ##OX1
OVRDBF FILE(LEFESTLR) TOFILE(LEFESTL0) SHARE(*NO)