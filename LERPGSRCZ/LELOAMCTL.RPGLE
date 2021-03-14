     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Loan amendments interface controller')        *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LELOAMCTL - Loan Amendments interface controller             *
      *                                                               *
      *  Function: This Program Validates LE Loan Amendments for      *
      *            input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Amendment details fields          *
      *            - For A (=AMEND),                                  *
      *              - if Amendment is a partial amendment, call a    *
      *                separate function to complete the Amendment    *
      *                details.                                       *
      *              - if Amendment is valid, call a separate         *
      *                function to check whether it is a valid        *
      *                amendment.                                     *
      *            - For D (=DELETE), call a separate function to     *
      *              process the Amendment and bypass the rest of     *
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
      *  Prev Amend No. MD029046           Date 27Nov19               *
      *                 CER050             Date 16Jun19               *
      *                 CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248398             Date 11Jun07               *
      *                 247561             Date 19May07               *
      *                 247549             Date 03May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA066             Date 22Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE034             Date 01Dec03               *
      *                 222373             Date 29Oct03               *
      *                 CLE030             Date 01Oct02               *
      *                 CAP075  *CREATE    Date 09Aug02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD029046 - Default Principal Increase settlement from        *
      *             SSI (standard settlement instructions) before     *
      *             trying to default from loan.                      *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding                              *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248398 - Applied core fix 247561.                            *
      *  247561 - Array index out of range on LELOAMVAL when sending  *
      *           transactions via API.                               *
      *  247549 - Review delay processing.                            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it                                          *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA066 - Wrong settlement method and account when enquired.  *
      *  CSC022 - Commitment Control Changes for Midas Plus           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A (recompile)*
      *  222373 - Parameter Mismatch                                  *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP075 - Lending API enhancements - Loan Amendments          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *****************************************************************

      * Valid Amendments file
     FLEVLOAMPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      * Invalid Amendments
     FLEILOAMPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT

     FLEVLOAML1 IF   E           K DISK    RENAME(LEVLOAMD0:LEVLOAMCHK)

     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,LELOAMC001

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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
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

      **----------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **----------------------------------------------------------------

      **----------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **----------------------------------------------------------------

      **----------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **----------------------------------------------------------------

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
     D ProcErr         C                   CONST('Error in LELOAMCTL')

      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+

      * Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)

      * Incoming amendment in screen format
     D TranInLOAM    E DS                  EXTNAME(LELOAMPD)

      * File receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                 21     75                                                       CGL029

      * File payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY                 21    565                                                       CGL029

      * File FRA/IRS instructions (needed as a parameter for call
      * to ZASETINVAL etc)
     D F_FRI         E DS                  EXTNAME(SDESFFPD)

      * Screen receive instructions
     D S_REC         E DS                  EXTNAME(SDESSRPD)

      * Screen payment instructions
     D S_PAY         E DS                  EXTNAME(SDESSPPD)
      *
      *  Screen FRA/IRS instructions
     D S_FRI         E DS                  EXTNAME(SDESSFPD)

      * Valid amendment record in file format
     D ValidLOAM     E DS                  EXTNAME(LEVLOAMPD)
     D                                     PREFIX(V_)

      * Current amendment record in file format
     D CurFilLoam    E DS                  EXTNAME(LEVLOAMPD)
     D  LAREC                335    389                                                       TDA066
     D  LAPAY                404    948                                                       TDA066
     D  LARECEx             1195   1212                                                       TDA066
     D  LAPAYEx             1213   1230                                                       TDA066

      * Current amendment in screen format
     D LoamScnFmt    E DS                  EXTNAME(LELOAMPD)
     D                                     PREFIX(@)
      *
      ***  Loan details 'A' format
     D LoanDetsA     E DS                  EXTNAME(CLOAN:CLOANCLF)
     D                                     PREFIX(LO_)
     D***CLREC**              459    527                                                      CGL029
     D***CLPAY**              528   1086                                                      CGL029
     D  CLREC                473    527                                                       CGL029
     D  CLPAY                542   1086                                                       CGL029
     D  CLRECEx             1597   1614                                                       CGL029
     D  CLPAYEx             1615   1632                                                       CGL029
      *
      ***  Loan details 'B' format
     D LoanDetsB     E DS                  EXTNAME(CLOAN:CLOANCKF)
     D                                     PREFIX(LO_)
     D LB_RECI       E                     EXTFLD(RECI)
     D LB_LNRF       E                     EXTFLD(LNRF)
     D LB_RCDT       E                     EXTFLD(RCDT)
     D LB_MRIN       E                     EXTFLD(MRIN)
     D LB_ORED       E                     EXTFLD(ORED)
     D LB_LCD        E                     EXTFLD(LCD)
     D LB_CHTP       E                     EXTFLD(CHTP)
     D LB_TNLU       E                     EXTFLD(TNLU)
     D LB_FRNT       E                     EXTFLD(FRNT)
     D LB_AFRT       E                     EXTFLD(AFRT)
     D LB_REPA       E                     EXTFLD(REPA)
     D LB_TMST       E                     EXTFLD(TMST)
      *
      ** Facility details 'A' format
     D FacilityA     E DS                  EXTNAME(FCLTY:FCLTYFMF)
     D                                     PREFIX(FA_)
      *
      *  Facility details 'B' format
     D FacilityB     E DS                  EXTNAME(FCLTY:FCLTYFNF)
     D                                     PREFIX(FA_)
     D FB_RECI       E                     EXTFLD(RECI)
     D FB_CNUM       E                     EXTFLD(CNUM)
     D FB_FACT       E                     EXTFLD(FACT)
     D FB_FCNO       E                     EXTFLD(FCNO)
     D FB_RCTP       E                     EXTFLD(RCTP)
     D FB_ORED       E                     EXTFLD(ORED)
     D FB_LCD        E                     EXTFLD(LCD)
     D FB_CHTP       E                     EXTFLD(CHTP)
     D FB_TNLU       E                     EXTFLD(TNLU)
     D FB_FRNT       E                     EXTFLD(FRNT)
     D FB_AFRT       E                     EXTFLD(AFRT)
     D FB_REPA       E                     EXTFLD(REPA)
     D FB_STMP       E                     EXTFLD(STMP)

      * Error indicators
     D LOAM_OK       E DS                  EXTNAME(LEELOAMPD)

      ** Customer lending ICD
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)

      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ***  Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** PCA ICD Details
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)

      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)

      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)

     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
      * LE Extra Data - Classe 1 Data - File (D/B) format                                     CAP086
     D                                     PREFIX(IF_)                                        CAP086
                                                                                              CAP086
      * LE Loan amendment extra data in file (D/B) format
     D ExtData       E DS                  EXTNAME(LELOEXPD)

      * First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      * Second DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      * 24X7 Data area structure
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      *
      * SDSTAT Data area structure
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)

      ** Data structure for data area commitment control                                      CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  ComitJobs              4    103A                                                      CSC022
                                                                                              CSC022
     D JobCmtCtlDS     S             10A   DIM(10)                                            CSC022
      * MIDAS SC Jobs Handling Commitment Control Data Structure                              CSC022
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+

      ** Error message field(s)
     D Msg1            S                   LIKE(#MsgID)

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0

      ** Fields (500A) to receive the incoming Amendment
     D Trans5001       S            500A

      ***  Field (500A) to receive the incoming Extra Data                                    CAP086
     D InfData500      S            500A                                                      CAP086
                                                                                              CAP086
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A

      ** Indices for arrays used to set up corresponding sequence numbers
      ** for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0

      ** Overall Amendment status, to be passed to the Message Handler
     D TranStatus      S              1A

      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A

      ** Timestamp for the Amendment
     D TimeStamp       S               Z

     D Object          S             10A   INZ('LELOAMUPC')
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
      ** each of the various parts of the Amendment
     D RepLOAM         S              1A   INZ('N')
                                                                                              CLE030
      * Work field for CLE030 processing                                                      CLE030
     D W_ASTS          S                   LIKE(V_LAASTS)                                     CLE030
                                                                                              CLE030
      ** Define workfields for Commitment Control Changes for Midas Plus                      CSC022
     D CSC022          S              1A                                                      CSC022
     D WSkpCom         S              1A                                                      CSC022
     D WPos            S              2S 0                                                    CSC022
                                                                                              CSC022
     D CAP086          S              1A                                                      CAP086
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                             CSF011A
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
      /COPY WNCPYSRC,LELOAMC002

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+

      /COPY WNCPYSRC,LELOAMC003

      * Incoming Amendment is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   Eval      TranInLoam = Trans5001
     C                   EVAL      InfData =  InfData500                                      CAP086
     C**********         MOVEL     Extdata500    Extdata                                      CAP086
     C                   MOVEL     ExtData500    ExtData                                      CAP086

      ** Generate a timestamp for this Amendment
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

      * Reset variables gradually updated
     C                   EXSR      RESETCYCLE

      /COPY WNCPYSRC,LELOAMC004

      *  Check if valid amendment details exists
     C                   EXSR      ChkValLOAM
      *
      *  If valid LOAM details does exist (even after delay), fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF

      * Reset variables again in case the details have been corrupted
      * by previous chain to valid Amendment details file.
     C                   EXSR      RESETCYCLE

      /COPY WNCPYSRC,LELOAMC005

      *  Validate action code - also retrieve amendment details if not insert
      *  Retrieve linked loan and facility details
     C                   EXSR      ValidateAc
      *
      /COPY WNCPYSRC,LELOAMC006

      *  If error in validation of action code, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF

      /COPY WNCPYSRC,LELOAMC008

      *  For Amends, convert the retrieved (file format) amendment to
      *  screen format.  If data substitution required, perform it.
     C                   IF           DDACTN = 'A'
     C                   EXSR      SetupAmd
     C                   ENDIF

      *  For Amend or Insert, validate the amendment
      *  Also validate if action code is 'Q' and CLE030 is switched on                        CLE030
     C                   IF           DDACTN = 'A' or
     C                                DDACTN = 'I' or                                         CLE030
     C                                DDACTN = 'Q' and                                        CLE030
     C                                CLE030 = 'Y'                                            CLE030
                                                                                              CLE030
     C                   EXSR      ValidateTr

      *  For Amend or Insert, validate settlement details for
      *  principal increases
     C                   IF           DDATYP = 'PI'
     C                   EXSR      ValSettle
     C                   ENDIF
     C                   ENDIF

      /COPY WNCPYSRC,LELOAMC011

     C     INVALID       TAG

      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      *  prompting the database update program
     C                   IN        APDUMP
      /COPY WNCPYSRC,LELOAMC012

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

      /COPY WNCPYSRC,LELOAMC013

      *  Processing for Error checking/write to database
     C                   EXSR      CheckWrite

      /COPY WNCPYSRC,LELOAMC014

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

      **-----------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **-----------------------------------------------------------------

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LELOAMC015

     C                   RETURN

      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * ChkValLOAM - Routine to check if valid Amendment details exist   *
      *                                                                  *
      ********************************************************************
     C     ChkValLOAM    BEGSR

      * Check for Amendment on Valid file
     C     LAVKEY        CHAIN     LEVLOAML1                          99

      * If record found...
     C                   IF        *IN99 = *OFF

      * ..delay, then repeat check
     C**********         CALLB     'ZACDELAY'                                                 247549
     C                   Z-ADD     1             COUNT             2 0                        247549
     C     *IN99         DOWEQ     '0'                                                        247549
     C     COUNT         ANDLE     10                                                         247549
     C                   ADD       1             COUNT                                        247549
     C                   CALLB     'ZACDELAY1'                                                247549

     C     LAVKEY        CHAIN     LEVLOAML1                          99
     C                   END                                                                  247549

      * Error if still present
     C                   IF        *IN99 = *OFF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'LAVKEY'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *              Transaction number supplied                      *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)
      *  if insert or substitution character exists
      * Otherwise
      *  Set retrieve mode to blank  (Access using Midas loan reference).
      *
      ** Check for the existence of the replacement character
     C                   IF        GHSUBS <> *blank
     C     GHSUBS        SCAN      Trans5001     SubForLNRF        3 0
     C                   ENDIF
     C                   IF        SubForLNRF <> 0
     C                   EVAL      RepLOAM = 'Y'
     C                   ENDIF
     C                   IF        DDACTN = 'I'
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE
     C                   IF        DDLOAN = *BLANKS
     C                             OR SubForLNRF <> 0
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE
     C                   MOVEL     '      '      ModeofOp
     C                   ENDIF
     C                   ENDIF

      * Validate action code versus transaction IDs supplied.
      * The Amendment in file format from the database is retrieved
      * as well (if not an insert).
     C                   CALLB     'LELOAMRTV'
      *
      * Inputs
      * Return code
     C                   PARM      *BLANK        ReturnCode
      *
      * Mode = '*FRONT' (Front office transaction interface)
      * Mode = '      ' (Not front office transaction interface)
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    APRESPMODE        1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      *
      * Loan number / value date / sequence / type
     C                   PARM                    DDLOAN
     C                   PARM                    DDVDAT
     C                   PARM                    DDSEQN
     C                   PARM                    DDATYP

      * Where called from
     C                   PARM      'CTL'         CallModCod        3

      * Features
     C                   PARM                    CEU020
     C                   PARM                    CLE030                                       CLE030

      * Multi-branching/date format indicators
     C                   PARM                    BGMBIN
     C                   PARM                    BJDFIN
      *
      * Outputs
      * Current Loan Amendment in file format, plus Loan/facility details
     C                   PARM                    CurFilLoam
     C                   PARM                    LoanDetsA
     C                   PARM                    LoanDetsB
     C                   PARM                    FacilityA
     C                   PARM                    FacilityB
      *
      * Error Indicators
     C                   PARM                    LOAM_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM                    CurFilLoam                                   CRE073
      *
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

      * For Amends, put the complete (pre-existing) Amendment into the Valid
      * file record - fields in this will be updated during processing
     C                   MOVE      CurFilLoam    ValidLOAM

      * For amends, convert the amendment to screen format
     C                   CALLB     'LELOAMCVT'
      * Inputs
      * Return code
     C                   PARM      *BLANKS       RetCodeIn
      *
      * Amendment - file format
     C                   PARM                    ValidLOAM
      *
      * Date format indicator
     C                   PARM                    BJDFIN
      *
      * Output parameters
      * Amendment details - screen format
     C                   PARM                    LoamScnFmt
      *
      ***  Output only screen field : Loan status (Not used in CTL)
     C                   PARM                    DDSTAT           16
     C                   PARM                    ValidLOAM                                    CRE073
      *
      **  Add the action code
     C                   MOVE      DDACTN        @DDACTN

      * Check for the existence of the replacement character; if this is
      * used, only the changed data has been sent, and all occurrences of
      * the replacement character must be replaced with the corresponding
      * character from the original Amendment.
     C                   IF        RepLOAM = 'Y'

     C                   CLEAR                   IncData
     C                   CLEAR                   CurData

     C                   CALLB     'APDTASUBS'

      * Return Code
     C                   PARM      *BLANK        ReturnCode

      * Substitution character
     C                   PARM                    GHSUBS

      * Incoming Data
     C                   PARM      TranInLOAM    IncData        2000

      * Current Data
     C                   PARM      LoamScnFmt    CurData        2000

     C                   MOVEL     IncDATA       LoamScnFmt

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main Amendment details    *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR

      * Validate Amendment details
     C                   CALLB     'LELOAMVAL'

      ** Transaction information (DS) from source system (screen format)
     C                   PARM                    LoamScnFmt

      ** Current Loan Amendment in file format from caller
     C                   PARM                    CurFilLoam

      * File receive instructions
      * File payment instructions
     C                   PARM                    S_REC
     C                   PARM                    S_PAY

      ** Loan 'A' & 'B' formats
     C                   PARM                    LoanDetsA
     C                   PARM                    LoanDetsB

      ** Facility 'A' & 'B' formats
     C                   PARM                    FacilityA
     C                   PARM                    FacilityB

      ** Front Office Transaction Id., Associated Front Office Transaction Id.
      ** Repair Location
     C                   PARM                    FOTranId         20
     C                   PARM                    FOAssocId        20
     C                   PARM                    RepairLoc         1

      ** Date format indicator / local currency / run day
     C                   PARM                    BJDFIN
     C                   PARM                    BJLCCY
     C                   PARM                    WRNDAY

      ** Analytical Accounting
     C                   PARM                    BGN0ST

      * Authorise amends / authorise principal tfr / base rate change
     C                   PARM                    BPLMAU
     C                   PARM                    BPTPAU
     C                   PARM                    BPBRCF

      * Tolerance for funding rate
     C                   PARM                    FTTFRT

      ** Field OK flags (DS) from/to caller
     C                   PARM                    LOAM_OK

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

      * Calling module code
     C                   PARM      'CTL'         CallModCod        3

      ** Features
     C                   PARM                    CDE002
     C                   PARM                    CLE002
     C                   PARM                    CLE003
     C                   PARM                    CLE005
     C                   PARM                    CLE014
     C                   PARM                    CLE023
     C                   PARM                    CLE030                                       CLE030
     C                   PARM                    CEU004
     C                   PARM                    CEU020

      ** Valid loan amendment layout (DS) from/to caller
     C                   PARM                    ValidLoam

      *  If any errors in validation, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValSettle  - Routine to validate settlement details            *
      *                                                                *
      ******************************************************************
     C     ValSettle     BEGSR

      * Move the customer number to parameter field
     C                   MOVEL     LO_CNUM       ##CSNM

      * Apply default settlement instructions if none supplied
     C                   IF        (S_REC = *blank) and
     C                             (S_PAY = *blank)
     C                   EXSR      DftSettmts
     C                   ENDIF

     C                   RESET                   ReturnCode
     C                   CALLB     'ZASETINVAL'

      ** Return code
     C                   PARM                    ReturnCode

      ** Output:
      ** Calling function type
     C                   PARM      'LOAM'        ##CALP

      ** Payment currency
     C                   PARM      LO_CCY        ##PCCY            3

      ** Receive currency
     C                   PARM      LO_CCY        ##RCCY            3

      ** Customer (shortname or number)
     C                   PARM                    ##CSNM

      ** Deal type
     C                   PARM                    ##TTYP

      ** Federal funds indicator
     C                   PARM                    ##FFND

      ** Booking branch
     C                   PARM      LO_BRCA       ##BRCA            3

      ** Receipt date
     C                   PARM                    ##DATR            5 0

      ** Payment date
     C                   PARM                    ##DATP            5 0

      ** Receipt / payment / FRA settlement instructions in screen
      ** format
     C                   PARM                    S_PAY
     C                   PARM                    S_REC
     C                   PARM                    S_FRI

      * Action code
     C                   PARM                    DDACTN
      * Protect Payment Field                                                                 222373
     C                   PARM                    ##PPAY            1                          222373
      * Protect Receipt Field                                                                 222373
     C                   PARM                    ##PREC            1                          222373

      ** Inputs:
      ** Payment instruction OK flag
     C                   PARM                    OKPayInsDS        1

      ** Receive instruction OK flag
     C                   PARM                    OKRecInsDS        1

      ** FRA/IRS Instruction OK flag
     C                   PARM                    OKFRAInsDS        1

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

      ** Receipt / payment / FRA settlement instructions in file
      ** format
     C                   PARM                    F_PAY
     C                   PARM                    F_REC
     C                   PARM                    F_FRI

      ** Action code used
     C                   PARM      DDACTN        ##ACTN            1

      ** Validation iteration
     C                   PARM      '1ST'         ##ValIter         3

     C     ValSetExit    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DftSettmts - Routine to apply default settlement instructions *
      *    if none have been supplied                                 *
      *                                                               *
      *****************************************************************

     C     DftSettmts    BEGSR
      *
      ** Principal increases for loans and parts purchased need
      ** pay settlements, parts sold need receive settlements
     C                   MOVE      *BLANKS       PTYPE             4
     C     LO_PTYP       IFEQ      66
     C     LO_PTYP       OREQ      67
     C     LO_PTYP       OREQ      69
     C     LO_PTYP       OREQ      72
     C                   MOVE      'PTSO'        PTYPE
     C                   ENDIF
      *
      ** Set up date of receipt/payment
     C                   CALLB     'ZDATE1'
     C                   PARM      DDVDAT        ZDATEA            6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      BJDFIN        DateFmt           1
     C                   PARM                    ErrorFlag         1
     C                   Z-ADD     ZDAYNO        ##DATR            5 0
     C                   Z-ADD     ZDAYNO        ##DATP            5 0
      *                                                                                     MD029046
      ** Default settlement from standard settlement instructions of customer first         MD029046
      ** before trying to default from loan. Placed another call for ZASETINDFT             MD029046
      ** for Principal increase insert.                                                     MD029046
      *                                                                                     MD029046
     C                   IF        DDACTN = 'I'                                             MD029046
     C                             AND DDATYP = 'PI'                                        MD029046
     C                   MOVEL     LO_CNUM       ##CSNM                                     MD029046
     C                   CALLB     'ZASETINDFT'                                             MD029046
      *                                                                                     MD029046
      ** Inputs                                                                             MD029046
      ** Calling program                                                                    MD029046
     C                   PARM      'LEND'        ##CALP                                     MD029046
      *                                                                                     MD029046
      ** Payment currency                                                                   MD029046
     C                   PARM      LO_CCY        ##PCCY                                     MD029046
      *                                                                                     MD029046
      ** Receive currency                                                                   MD029046
     C                   PARM      LO_CCY        ##RCCY                                     MD029046
      *                                                                                     MD029046
      ** Customer shortname                                                                 MD029046
     C                   PARM                    ##CSNM                                     MD029046
      *                                                                                     MD029046
      ** Loan type                                                                          MD029046
     C                   PARM      *BLANKS       ##TTYP                                     MD029046
      *                                                                                     MD029046
      ** Parameters not used in LOAM :                                                      MD029046
      ** Federal funds indicator                                                            MD029046
      ** Version of ISDA rules                                                              MD029046
      ** Type of ISDA agreement                                                             MD029046
      ** Date of ISDA agreement                                                             MD029046
      ** Version of ISDA agreement                                                          MD029046
      ** Version of ISDA agreement century                                                  MD029046
     C                   PARM      *BLANK        ##FFND                                     MD029046
     C                   PARM      *BLANK        BQISDA                                     MD029046
     C                   PARM      *BLANK        BQAGTY                                     MD029046
     C                   PARM      *BLANK        BQAGDT                                     MD029046
     C                   PARM      *BLANK        BQAGVV                                     MD029046
     C                   PARM      *BLANK        Blank2                                     MD029046
                                                                                            MD029046
      ** Deal Subtype                                                                       MD029046
     C                   PARM      *BLANK        BlankSTYP                                  MD029046
                                                                                            MD029046
      ** Branch                                                                             MD029046
     C                   PARM      *BLANK        BlankBRCA                                  MD029046
      *                                                                                     MD029046
      ***  OUTPUTS                                                                          MD029046
      ***  Payment instructions                                                             MD029046
     C                   PARM                    F_PAY                                      MD029046
      *                                                                                     MD029046
      ***  Receive instructions                                                             MD029046
     C                   PARM                    F_REC                                      MD029046
      *                                                                                     MD029046
      ***  FRA/IRS instructions                                                             MD029046
     C                   PARM                    F_FRI                                      MD029046
     C                   ENDIF                                                              MD029046
      *
      ** Set up payment instructions from loan
      ***(on*insertions,*these*fields*will*be*zero/blank)**************                       TDA066
     C                   IF        (DDACTN = 'I')                                             TDA066
     C     PType         IFNE      'PTSO'                                                     TDA066
     C     FLPSTM        ANDEQ     *ZERO                                                    MD029046
     C     ##PPAY        ANDNE     'Y'                                                      MD029046
     C                   MOVEL     CLPAY         FLPAY
     C                   MOVEL     CLPAYEx       FLPONS                                       CGL029
     C                   MOVEL     LO_PSTM       FLPSTM                                       CGL029
     C                   MOVEL     LO_CVMR       FLCVMR
     C                   MOVEL     LO_SCCY       FLPSCY
     C                   MOVEL     LO_ICCY       FLIC72
     C                   MOVE      LO_OMDB       FLPOBR                                       TDA066
      *                                                                                       CLE031
      ** If CLE031 is switched on, move correct settlement currency.                          CLE031
      ** Note do not default exchange rate from CLOANCL.                                      CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   MOVEL     LO_PSCY       FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                TDA066
      *
      ** If part sold, receive branch is our start date branch
     C     PType         IFEQ      'PTSO'
     C     FLRSTM        ANDEQ     *ZERO                                                    MD029046
     C     ##PREC        ANDNE     'Y'                                                      MD029046
     C                   MOVE      LO_OSDB       FLROBR
      *
      ** Set up receive instructions from loan
      ***(on*insertions,*these*fields*will*be*zero/blank)**************                       TDA066
     C                   MOVEL     CLREC         FLREC
     C                   MOVEL     CLRECEx       FLRONS                                       CGL029
     C                   MOVEL     LO_RSTM       FLRSTM                                       CGL029
     C                   MOVEL     LO_SCCY       FLRSCY
     C**********         MOVE      LO_OMDB       FLPOBR                                       TDA066
      *                                                                                       CLE031
      ** If CLE031 is switched on, move correct settlement currency.                          CLE031
      ** Note do not default exchange rate from CLOANCL.                                      CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   MOVEL     LO_SCCY       FLRSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
      *                                                                                       TDA066
      ** On action other than insert, setup setllement instructions                           TDA066
      ** from current loan amendment.                                                         TDA066
     C                   ELSE                                                                 TDA066
     C                   IF        (PType <> 'PTSO')                                          TDA066
     C                   MOVEL     LAPAY         FLPAY                                        TDA066
     C                   MOVEL     LAPAYEx       FLPONS                                       TDA066
     C                   MOVEL     LAPSTM        FLPSTM                                       TDA066
     C                   MOVEL     LACVMR        FLCVMR                                       TDA066
     C                   MOVEL     LAPSCY        FLPSCY                                       TDA066
     C                   MOVEL     LAICCY        FLIC72                                       TDA066
     C                   MOVE      LAOSBR        FLPOBR                                       TDA066
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     LAPEXR        FLPEXR                                       CLE031
     C                   MOVE      LAPEXI        FLPEXI                                       CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   ELSE                                                                 TDA066
     C                   MOVEL     LAREC         FLREC                                        TDA066
     C                   MOVEL     LARECEx       FLRONS                                       TDA066
     C                   MOVE      LAOSBR        FLROBR                                       TDA066
     C                   MOVEL     LARSTM        FLRSTM                                       TDA066
     C                   MOVEL     LASCCY        FLRSCY                                       TDA066
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     LAREXR        FLREXR                                       CLE031
     C                   MOVE      LAREXI        FLREXI                                       CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   ENDIF                                                                TDA066
     C                   ENDIF                                                                TDA066
      *
     C                   CALLB     'ZASETINDFT'
      *
      ** Inputs
      ** Calling program
     C                   PARM      'LOAM'        ##CALP            4
      *
      ** Payment currency
     C                   PARM      LO_CCY        ##PCCY            3
      *
      ** Receive currency
     C                   PARM      LO_CCY        ##RCCY            3
      *
      ** Customer shortname
     C                   PARM                    ##CSNM           10
      *
      ** Loan type
     C                   PARM      *BLANKS       ##TTYP            2
      *
      ** Parameters not used in LOAM :
      ** Federal funds indicator
      ** Version of ISDA rules
      ** Type of ISDA agreement
      ** Date of ISDA agreement
      ** Version of ISDA agreement
      ** Version of ISDA agreement century
     C                   PARM      *BLANK        ##FFND            1
     C                   PARM      *BLANK        BQISDA            4
     C                   PARM      *BLANK        BQAGTY            6
     C                   PARM      *BLANK        BQAGDT            6
     C                   PARM      *BLANK        BQAGVV            2
     C                   PARM      *BLANK        Blank2            2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ***  OUTPUTS
      ***  Payment instructions
     C                   PARM                    F_PAY
      *
      ***  Receive instructions
     C                   PARM                    F_REC
      *
      ***  FRA/IRS instructions
     C                   PARM                    F_FRI
      *
      *
      ***  Convert settlement details from file to screen format
     C                   CALLB     'ZASETINCVT'
      *
      ***  Inputs
      ***  File payment settlement instructions
     C                   PARM                    F_PAY
      *
      ***  File receipt settlement instructions
     C                   PARM                    F_REC
      *
      ***  File FRA/IRS settlement instructions
     C                   PARM      *BLANK        F_FRI
      *
      ***  Outputs
      ***  Screen payment settlement instructions
     C                   PARM      *BLANK        S_PAY
      *
      ***  Screen Receipt settlement instructions
     C                   PARM      *BLANK        S_REC
      *
      ***  Screen FRA/IRS settlement instructions
     C                   PARM      *BLANK        S_FRI
     C                   PARM      LO_CCY        #TRCCY                                      CSF011A
     C                   PARM      LO_CCY        #TPCCY                                      CSF011A

     C     EDFTSETT      ENDSR
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
     C                   EXSR      SetUpValid
     C                   WRITE     LEVLOAMD0
     C                   EXSR      CallMsgHdl
     C                   ENDIF

     C                   If        Idx > 0
     C                   EXSR      SetUpInval
      *
      * Only write to invalid files if repair in back office
     C                   IF        APRprLocn = 'B'
     C                   WRITE     LEILOAMD0
     C                   ENDIF

     C                   EXSR      CallMsgHdl
     C                   ENDIF

     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
     C                   COMMIT
     C                   Endif                                                                CSC022

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

     C                   RESET                   WFldNamArr                                   247561
     C                   RESET                   WMsgIDArr                                    247561
     C                   RESET                   WMsgDtaArr                                   247561
     C                   RESET                   WIdx                                         247561

     C                   RESET                   FldNoArr
     C                   CLEAR                   LoamScnFmt
     C                   MOVE      *ALL'Y'       LOAM_OK
     C                   CLEAR                   ValidLOAM

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetUpInval - Set up additional fields that are needed on the  *
      *              Inalid file record.                              *
      *                                                               *
      *****************************************************************

     C     SetUpInval    BEGSR

      * Include Header fields that need to be o/p to the Invalid files
     C                   EVAL      DDFRNT     = APFOTranID
     C                   EVAL      DDAFRT     = APFOAsocID
     C                   EVAL      DDREPR     = APRprLocn
     C                   MOVE      TimeStamp     DDSTMP
                                                                                              CAP086
      * Setup the Automatic Autorisation Flag                                                 CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      DDAUTH     = IF_AUTH                                       CAP086
     C                   ENDIF                                                                CAP086

     C                   EVAL      TranStatus = 'F'

      /COPY WNCPYSRC,SDSECDC016
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetUpValid - Set up additional fields that are needed on the  *
      *              Valid file record.                               *
      *                                                               *
      *****************************************************************

     C     SETUPVALID    BEGSR
                                                                                              CLE030
      * If CLE030 and action code is Authorise then set work loan                             CLE030
      * status to be same as valid file.                                                      CLE030
     C                   IF        DDACTN = 'X' AND CLE030 = 'Y'                              CLE030
     C                   EVAL      W_ASTS = V_LAASTS                                          CLE030
     C                   ENDIF                                                                CLE030

      * Include Header fields that need to be o/p to the valid file
      * If there is no front office ID, use the PCREF created by LELOAMVAL.
     C     DDFRNT        Ifeq      *Blank
     C                   MOVEL     LAPCRF        LAFRNT
     C                   Else
     C                   MOVEL     DDFRNT        LAFRNT
     C                   EndIf

     C                   EVAL      LAAFRT = DDAFRT
     C                   EVAL      LAREPA = DDREPR
     C                   EVAL      LATMST = DDSTMP
                                                                                              CAP086
      * Automatic Authorisation flag                                                          CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      V_LAAUTH = IF_AUTH                                         CAP086
     C                   ENDIF                                                                CAP086

     C                   EVAL      TranStatus = 'S'

      /COPY WNCPYSRC,SDSECDC017
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

     C                   CALLB     'ZAMSGHNDLE'

      ** Return code (10A, returned to this procedure)
     C                   PARM      *BLANK        ReturnCode

      ** Repair location (1A, from caller)
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

      ** Front office Transaction identifier (20A, from caller)
     C                   PARM                    APFOTranID

      ** Midas module ID (2A)
     C                   Parm                    ModuleID

      ** Midas transaction ID (6A, from caller)
     C                   PARM                    DDLOAN

      ** Message file (10A, from caller)
     C                   PARM                    #MsgFile

      ** Action code of Amendment (1A, from Amendment)
     C                   PARM                    DDACTN

      ** Status of Amendment (1A, F=Failure, S=Success)
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

      ** The Amendment's timestamp
     C                   PARM                    TimeStamp

      ** Additional message files to check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MsgFArray

      ** Whether or not to clear the program message queue (1A)
     C                   PARM                    ClrPgmMsgQ

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
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

      * Amendment information / receive/pay / settlement instructions
     C                   PARM                    Trans5001
     C                   PARM                    InfData500                                   CAP086
     C                   PARM                    S_REC
     C                   PARM                    S_PAY
     C                   PARM                    ExtData500

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

      ** Determine if CDE002 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CDE002            1
     C                   ELSE
     C                   MOVEL     'N'           CDE002
     C                   ENDIF

      ** Determine if CEU004 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CEU004            1
     C                   ELSE
     C                   MOVEL     'N'           CEU004
     C                   ENDIF

      ** Determine if CEU020 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU020'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CEU020            1
     C                   ELSE
     C                   MOVEL     'N'           CEU020
     C                   ENDIF

      ** Determine if CLE002 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CLE002            1
     C                   ELSE
     C                   MOVEL     'N'           CLE002
     C                   END

      ** Determine if CLE003 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE003'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CLE003            1
     C                   ELSE
     C                   MOVEL     'N'           CLE003
     C                   END

      ** Determine if CLE005 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CLE005            1
     C                   ELSE
     C                   MOVEL     'N'           CLE005
     C                   END

      ** Determine if CLE014 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CLE014            1
     C                   ELSE
     C                   MOVEL     'N'           CLE014
     C                   END

      ** Determine if CLE023 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE023'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CLE023            1
     C                   ELSE
     C                   MOVEL     'N'           CLE023
     C                   END

      *                                                                                       CLE030
      ***  Determine if Release authorisation enhancement feature                             CLE030
      ***  is installed                                                                       CLE030
     C                   MOVE      'N'           CLE030            1                          CLE030
     C                   CALLB     'AOSARDR0'                                                 CLE030
     C                   PARM      *BLANKS       @RTCD                                        CLE030
     C                   PARM      '*VERIFY'     @OPTN                                        CLE030
     C                   PARM      'CLE030'      @SARD                                        CLE030
      *                                                                                       CLE030
     C     @RTCD         IFEQ      *BLANKS                                                    CLE030
     C                   MOVE      'Y'           CLE030                                       CLE030
     C                   ELSE                                                                 CLE030
     C     @RTCD         IFEQ      '*NRF'                                                     CLE030
     C                   MOVE      'N'           CLE030                                       CLE030
     C                   ELSE                                                                 CLE030
      *                                                                                       CLE030
      * Database error                                                                        CLE030
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE030
     C                   MOVEL     '902'         DBASE                          * DBERR 902 * CLE030
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE030
     C                   EXSR      *PSSR                                                      CLE030
     C                   ENDIF                                                                CLE030
     C                   ENDIF                                                                CLE030

      ** Determine if CSC011 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CSC011            1
     C                   ELSE
     C                   MOVEL     'N'           CSC011
     C                   ENDIF
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
      *
      ***  Initialise program name
     C                   MOVEL     'LELOAMCTL'   DBPGM

      ** File / Data area Accesses required for calling parameters
      ** Access bank details
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM                    DSFDY

     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   Z-ADD     1             DBASE                          * DBERR 001 *
     C                   MOVEL     @Optn         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve customer lending ICD
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDCLND        PARM                    DSFDY
      *
     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'SDCLNDPD'    DBFILE                         *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   MOVEL     @Optn         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve Midas Module details
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDMMOD        PARM                    DSFDY

     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   Z-ADD     3             DBASE                          * DBERR 003 *
     C                   MOVEL     @Optn         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If Analytical Accounting Module is switched on, access
      ** profit centre accounting details
     C     BGN0ST        IFEQ      'Y'
     C                   CALLB     'AOPCACR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST  '    @Optn
     C     SDPCAC        PARM      SDPCAC        DSFDY
      *
     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'SDPCACPD'    DBFILE                         *************
     C                   Z-ADD     4             DBASE                          * DBERR 004 *
     C                   MOVEL     @Optn         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF

      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      * If CSC011 is installed and in switchover mode, use
      * S1DATE from DTAARA/SC24x7 as the rundate.
     C                   IN        SC24X7
     C                   IN        SDSTAT
      *
     C     CSC011        IFEQ      'Y'
     C     S1SUPP        ANDEQ     LIBR
     C                   Z-ADD     S1DATE        WRNDAY            5 0
     C                   ELSE
     C                   MOVE      BJRDNB        WRNDAY
     C                   ENDIF

      ** Determine if enhancement CSC022 is switched on                                       CSC022
                                                                                              CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRTCD             7                          CSC022
     C                   PARM      '*VERIFY'     POPTN             7                          CSC022
     C                   PARM      'CSC022'      PSARD             6                          CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
      * Initialize work fields                                                                CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   Eval      WSkpCom = 'N'                                              CSC022
      *                                                                                       CSC022
     C                   If        PRTCD = *Blanks                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
      *                                                                                       CSC022
     C                   IN        SCCMTJOB                                                   CSC022
      *                                                                                       CSC022
     C                   If        COMITNUM <> 0                                              CSC022
     C                   MOVEA     Comitjobs     JobCmtctlDS                                  CSC022
     C                   Eval      WPos = %Lookup(PSJOBNAME:JobCmtCtlDS)                      CSC022
     C                   If        WPos > 0                                                   CSC022
     C                   Eval      WSkpCom = 'Y'                                              CSC022
     C                   Endif                                                                CSC022
     C                   Endif                                                                CSC022
     C                   Else                                                                 CSC022
      ** An NRF (No Record Found) return code is valid.                                       CSC022
      ** Issue database error only for error return codes.                                    CSC022
     C                   If        PRTCD <> '*NRF'                                            CSC022
     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
     C                   Eval      DBKEY = 'CSC022'                                           CSC022
     C                   Eval      DBASE = 5                                                  CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
                                                                                              CAP086
      ** Check if enhancement Automatic Authorisation(CAP086) is on                           CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALLB     'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTCD                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C                   EVAL      DBKey  = 'CAP086'                                          CAP086
     C                   EVAL      DBase  = 6                                                 CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APLOAMDTQ'

      ** Initialise keylists
     C**********         MOVE      DDLOAN        KLOAN             6 0                        CLE148
     C                   MOVE      DDLOAN        KLOAN             6                          CLE148
     C                   MOVE      DDVDAT        KVDAT             5 0
     C                   MOVE      DDSEQN        KLASN             3 0
     C                   MOVE      DDATYP        KAMTP             2

     C     LAVKEY        KLIST
     C                   KFLD                    KLOAN
     C                   KFLD                    KVDAT
     C                   KFLD                    KLASN
     C                   KFLD                    KAMTP

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LELOAMC018

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
