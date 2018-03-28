     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee settlement interface controller')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFESTVU - Fee settlements validate and update               *
      *                                                               *
      *  Function: This program validates fee settlements for input   *
      *            into the Midas database.                           *
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
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 MD022254           Date 19Sep13               *
      *                 CLE148             Date 23Jul12               *
      *                 AR919997           Date 26Feb12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 CLE073             Date 13May08               *
      *                 262843             Date 20Nov09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG9518            Date 07Dec05               *
      *                 BUG8459            Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 19May05               *
      *                 CLE034             Date 05May03               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG1849            Date 15Apr04               *
      *                 CDL018             Date 03Feb04               *
      *                 TCA094             Date 31Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 222373             Date 29Oct03               *
      *                 CAP084  *CREATE    Date 06Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  MD022254 - BankFusion_Customer Lending: Account in           *
      *             "Write off"                                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR919997 - Customer or shortname must be live however        *
      *             customer used is already live                     *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *          - CCR016: Settlement Allocation                      *
      *  CSF011 - Customer Name on Inputs                             *
      *  CLE073 - Calculated Loan Based Fees                          *
      *  262843 - Apply CORE fix 258669.                              *
      *  258669 - Default fee events settlement instruction first from*
      *           Fees Master if found, otherwise retrieve from       *
      *           Extended Settlement file.                           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9518- Incorrect position of InfData in BUFFER.            *
      *  BUG8459- Error message "Our nostro (receipt) invalid" upon   *
      *           click <complete> button
      *  CLE106 - Syndications Manager                                *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  BUG1849- need to send data back from RTV module to screen    *
      *           (via buffer) even if an error has occured.          *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TCA094 - Wrong update on settlement instructions             *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  222373 - Parameter Mismatch                                  *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
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
 
      *                                                                                       CSC022
      ** Program Status Data Structure                                                        CSC022
      ** =============================                                                        CSC022
      ** The following /COPY line includes all the defined fields in the                      CSC022
      ** PSDS.  They have meaningful names, prefixed by 'PS'.                                 CSC022
      *                                                                                       CSC022
     D/COPY ZACPYSRC,PSDS                                                                     CSC022
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
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
 
      *  Array for job name                                                                   CSC022
     D ARRJBNAM        S             10A   DIM(10)                                            CSC022
      * Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming transaction in screen format
     D FESTScnFmt    E DS                  EXTNAME(LEFESTPD)
 
      * Incoming transaction 2 in screen format                                               CLE106
     D FES2ScnFmt    E DS                  EXTNAME(LEFES2PD)                                  CLE106
                                                                                              CLE106
      * Valid file layout
     D ValidFEST     E DS                  EXTNAME(LEVFESTPD)
     D                                     PREFIX(V_)
     D***ValidREC             124    192                                                      TCA094
     D***ValidPAY             193    751                                                      TCA094
     D  ValidREC             138    192                                                       TCA094
     D  ValidPAY             207    751                                                       TCA094
      * Large fields to include
      * - Receive instructions (STRSTM to STROCN)
      * - Pay     instructions (STPSTM to STBTB6)
 
      * Current fee settlement in file format
     D FESTFilFmt    E DS                  EXTNAME(LEFEEAD)
     D                                     PREFIX(FA_)
 
      * Pay settlement instructions in screen format
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
 
      * Receive settlement instructions in screen format
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
 
      * FRA/IRS settlement instructions in screen format
     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
 
      * Pay settlement instructions in file format
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
     D  F_PAY1                21    565                                                       TCA094
 
      * Receive settlement instructions in file format
     D F_REC         E DS                  EXTNAME(SDESFRPD)
     D  F_REC1                21     75                                                       TCA094
 
      * FRA/IRS settlement instructions in file format
     D F_FRI         E DS                  EXTNAME(SDESFFPD)
      * (needed as a parameter only)
 
      * Error indicators
     D FESTOkInd     E DS                  EXTNAME(LEEFESTPD)
 
      * 24X7 Data area structure
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      *                                                                                       CSC022
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
     D  COMITNOM               1      3S 0                                                    CSC022
     D  COMITJOB               4    103                                                       CSC022
      *                                                                                       CSC022
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      * Flags to indicate whether Pay Settlement instruction fields
      * are valid
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
 
      * Flags to indicate whether Receive Settlement instruction fields
      * are valid
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
 
      * Flags to indicate whether FRA/IRS instruction fields are valid
      * (needed as a parameter only)
     D OKFRAInsDS      DS            22
 
      * External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      * External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      * First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                              CSF011
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSF011
      ** Second DS for Access programs - long data structure                                  CSF011
                                                                                              CAP086
      ** Interface Data Format Definition File format                                         CAP086
                                                                                              CAP086
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
 
      ** +--------------------------------------+                                             CSC022
      ** ¦ Use of Indicator                     ¦                                             CSC022
      ** ¦ ================                     ¦                                             CSC022
      ** |                                      |                                             CSC022
      ** | 17      Used by LOOKUP               |                                             CSC022
      ** +--------------------------------------+                                             CSC022
                                                                                              CSC022
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSF011
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Index for arrays of error message ids etc
     D Idx             S              3P 0 INZ(0)
 
      * Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(0)
 
      * Field to receive the incoming fee settlement
     D Trans5001       S            500A
                                                                                              CAP086
      ** Field (500A) to receive the incoming Interface Data                                  CAP086
                                                                                              CAP086
     D InfData500      S            500A                                                      CAP086
 
      ** Fields (500A) to receive the fee settlement data 2                                   CLE106
     D Trans5002       S            500A                                                      CLE106
                                                                                              CLE106
      * Actual rundate (24x7)
     D WProcDate       S                   LIKE(BJRDNB)
 
      ** Java user information
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)
 
     D CLE106          S              1A   INZ('N')                                           CLE106
     D CSC022          S              1A   INZ('N')                                           CSC022
      ** Counter variable                                                                     CSC022
     D WCMT01          S              1A                                                      CSC022
      ** Commitment Flag                                                                      CSC022
                                                                                              CAP086
     D CAP086          S              1A   INZ('N')                                           CAP086
                                                                                              CAP086
     D WCustomer       S             10                                                       CSF011
     D C#KYST          S              7                                                       CSF011
     D InTrCcy         S              3A                                                     CSF011A
     D InTpCcy         S              3A                                                     CSF011A
                                                                                              CSD095
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
                                                                                              CSD095
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      ** +--- Start of main processing ---------------------------------+
      ** ¦                                                              ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is ¦
      ** ¦ executed at program activation.                              ¦
      ** ¦                                                              ¦
      ** +--------------------------------------------------------------+
 
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     FESTScnFmt
     C                   MOVEL     Trans5002     FES2ScnFmt                                   CLE106
                                                                                              CAP086
     C                   MOVEL     InfData500    InfData                                      CAP086
 
      * If the user is connected via a browser, the job user name is the data
      * source conection name - the actual user name is stored in ZMUSER
     C                   IN        ZMUSER
 
      * Get the user name from ZMUSER
     C                   SELECT
     C                   WHEN         S#ACTN = 'I'
     C                   EVAL         F1IUSR = USRID
     C                   WHEN         S#ACTN = 'X'
     C                   EVAL         F1XUSR = USRID
     C                   WHEN         S#ACTN = 'A'
     C                   EVAL         F1AUSR = USRID
     C                   ENDSL
 
      * Reset variables gradually updated
     C                   EXSR      RESETCYCLE
 
      * Validate action code and retrieve transaction
     C                   EXSR      ValidateAc
      *
      * If error in validation of action code,end here
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   EndIf
 
      * Default settlement details if required
     C                   EXSR      DftSettmts
 
      * Validate transaction
     C                   EXSR      ValidateTr
     C                   EVAL      S#EUTN = V_STPCRF                                          CLE106
     C                   EXSR      ValidateSt
     C     INVALID       TAG                                                                  CSF011
                                                                                              CSF011
      ** Populate Customer or Account Details                                                 CSF011
                                                                                              CSF011
     C                   EXSR      SrCustName                                                 CSF011
                                                                                              CSF011
      *
      * Write to database
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
      * Set up the Valid record
     C**********         MOVEL     F_REC         ValidREC                                     TCA094
     C**********         MOVEL     F_PAY         ValidPAY                                     TCA094
     C                   MOVEL     F_REC1        ValidREC                                     TCA094
     C                   MOVEL     F_PAY1        ValidPAY                                     TCA094
     C                   MOVE      FLCVMR        V_STCVMR
     C                   MOVE      FLPOBR        V_STOMDB
     C                   MOVE      FLROBR        V_STOSDB
     C                   MOVE      FLPSCY        V_STSCCY
     C                   MOVE      FLRSCY        V_STSCCY
     C                   MOVE      FLIC72        V_STICCY
     C                   Eval      V_STMETH = FLRSTM
     C                   Eval      V_STOURS = FLRONS
     C                   Eval      V_STOSBR = FLROBR
     C                   EVAL      V_STRSTM = FLRSTM                                          TCA094
     C                   EVAL      V_STRONS = FLRONS                                          TCA094
     C                   EVAL      V_STPSTM = FLPSTM                                          TCA094
     C                   EVAL      V_STPONS = FLPONS                                          TCA094
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        V_STREXR                                     CLE031
     C                   Z-ADD     FLPEXR        V_STPEXR                                     CLE031
     C                   MOVE      FLREXI        V_STREXI                                     CLE031
     C                   MOVE      FLPEXI        V_STPEXI                                     CLE031
     C                   MOVE      FLRSCY        V_STSCCY                                     CLE031
     C                   MOVE      FLPSCY        V_STPSCY                                     CLE031
     C                   ENDIF                                                                CLE031
     C                   Eval      FESTFilFmt = ValidFEST
     C                   EXSR      UpdateDB
     C                   ENDIF
 
     C*** need to preserve data from rtv module and send it back to             BUG1849
     C*** screen                                                                BUG1849
     C*****INVALID       TAG                                                          BUG1849 CSF011
      * Remerge buffer with all relevant data structures
     C**********         EVAL      Buffer = FESTScnFmt + S#STAT                               CLE106
     C**********                   + S#FTYP + S#FCOD + S#FENV                                 CLE106
     C**********                   + S#DUPD + InRecSttmt + InPaySttmt                         CLE106
     C                   EVAL      Buffer = FESTScnFmt + FES2ScnFmt                           CLE106
     C**********                   + InfData                                          CAP086 BUG9518
     C**********                            + InRecSttmt + InPaySttmt                 CLE106 BUG9518
     C                             + InRecSttmt + InPaySttmt + InfData                       BUG9518
                                                                                              CLE106
     C*****INVALID*******TAG                                                    BUG1849
     C                   SETON                                        LR
     C
     C                   RETURN
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
 
      * Fee settlement information
     C                   PARM                    Trans5001
     C                   PARM                    Trans5002                                    CLE106
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InfData500                                   CAP086
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN          1
     C                   PARM                    Buffer         6000
     C                   PARM                    APIRetc           1
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'LERMSGF'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      * Hook to enable non-core Message files to be included
     D/COPY WNCPYSRC,LEFESTVM01
      *
      * Access bank details via access program
      * (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      *
      * Access SAR details file to determine if CSC011
      * is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CSC011            1
     C                   ELSE
     C                   MOVEL     'N'           CSC011
     C                   EndIf
      *
      * If CSC011 is installed and in switchover mode, use S1DATE
      * from DTAARA/SC24x7 as the rundate.
     C                   IN        SC24X7
     C                   IN        SDSTAT
      *
     C     CSC011        IFEQ      'Y'
     C     S1SUPP        ANDEQ     LIBR
     C                   Z-ADD     S1DATE        WRNDAY            5 0
     C                   ELSE
     C                   MOVE      BJRDNB        WRNDAY
     C                   ENDIF
                                                                                              CLE106
      * Access SAR details file to determine if CLE106 is available                           CLE106
                                                                                              CLE106
     C                   EVAL      CLE106 = 'N'                                               CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *Blanks       @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE106
                                                                                              CLE106
     C                   IF        @RTCD = *Blanks                                            CLE106
     C                   EVAL      CLE106 = 'Y'                                               CLE106
     C                   ENDIF                                                                CLE106
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
 
      * Key lists
     C     KFEST         KLIST
     C                   KFLD                    @@CUSN            6 0
     C                   KFLD                    @@FACL            5 0
     C**********         KFLD                    @@LOAN            6 0                        CLE148
     C                   KFLD                    @@LOAN            6                          CLE148
     C                   KFLD                    @@FSEQ            2 0
     C                   KFLD                    @@VDAT            5 0
 
      *  Hook to enable non-core initial processing to be included
     D/COPY WNCPYSRC,LEFESTV001
 
      * Determine if CSC022 is switched on                                                    CSC022
                                                                                              CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       @RTCD                                        CSC022
     C                   PARM      '*VERIFY'     @OPTN                                        CSC022
     C                   PARM      'CSC022'      @SARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
     C                   IF        @RTCD = *BLANK                                             CSC022
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
     C                   IF        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBPGM = 'LEFESTVU'                                         CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE ='SCSARDPD'                                         CSC022
     C                   EVAL      DBASE  = 905                                               CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
                                                                                              CAP086
      ** Access SAR details file to determine if                                              CAP086
      ** Automatic Authorisation is installed                                                 CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALL      'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTCD                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
      *                                                                                       CAP086
     C                   IF        @RTCD = *BLANK                                             CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
      ** Set Auto Authorise flag for transactions from Interface                              CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      V_STAUTH   = IF_AUTH                                       CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *              fee settlement supplied                          *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      * Validate action code versus fee settlement supplied
      * The fee settlement in file format from the database is retrieved
      * as well.
     C                   RESET                   ReturnCode
 
     C                   CALLB     'LEFESTRTV'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    ReturnCode
 
      * Mode
     C                   PARM      ' '           P#MODE            1
 
      * Response Code
     C                   PARM      'S'           RESPMODE          1
 
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
     C                   PARM                    InRecSttmt                                   258669
     C                   PARM                    InPaySttmt                                   258669
     C                   PARM                    F_REC                                        258669
     C                   PARM                    F_PAY                                        258669
 
      * Action, customer, facility type, facility number,
      * fee sequence number and value date OK indicators
     C                   PARM                    S#ACTNok          1
     C                   PARM                    S#CSSNok          1
     C                   PARM                    S#FACTok          1
     C                   PARM                    S#FCNOok          1
     C                   PARM                    S#FSEQok          1
     C                   PARM                    S#VDATok          1
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
 
      * Settlement adjustment due date
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
     C                   PARM                    Idx
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      * Save the TNLU
     C                   Eval      TNLU = FA_FATNLU
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Default settlements - Apply default settlement instructions   *
      *                                                               *
      *****************************************************************
     C     DftSettmts    BEGSR
 
      **If*ANY*of*the*Settlements*fields*have*been*entered,*bypass*this                       258669
      **routine.*******************************************************                       258669
      *                                                                                       258669
      ** If ANY of the Settlements fields have been entered or if                             258669
      ** settlement retrieval is successful, bypass defaulting.                               258669
      * Otherwise, use modules which will use Standard Settlement
      * Instructions to apply defaults.
      *                                                                                       258669
     C                   IF            (InRecSttmt = *blank)
     C                             AND (InPaySttmt = *blank)
     C                             AND (FLPSTM = 0)                                           258669
     C                             AND (FLRSTM = 0)                                           258669
     C                             AND (S#TYPE <> 'W')                                      MD022254
     C                             AND (S#TYPE <> ' ')                                      MD022254
 
     C                   CALLB     'ZASETINDFT'
 
      * Output
      * Calling function type
     C                   PARM      'LEND'        ##CALP            4
      * Payment currency
     C***********        PARM      FccyFCCY      ##PCCY            3                         BUG8459
     C                   PARM      S#FCCY        ##PCCY            3                         BUG8459
 
      * Receive currency
     C***********        PARM      FccyFCCY      ##RCCY            3                         BUG8459
     C                   PARM      S#FCCY        ##RCCY            3                         BUG8459
 
      * Customer (shortname or number)
     C                   PARM      S#CNUM        ##CSNM           10
 
      * Deal type
     C                   PARM      *BLANKS       ##TTYP            2
 
      * Federal Funds Ind.
     C                   PARM      *BLANK        ##FFND            1
 
      * ISDA Rules for FRA/IRS deals only
      * Version of ISDA Rules govern
     C                   PARM                    Blank4            4
 
      * Type of ISDA agreement
     C                   PARM                    Blank6            6
 
      * Date of ISDA Agreement
     C                   PARM                    Blank6X           6
 
      * Version of ISDA Agreement
     C                   PARM                    Blank2            2
      *
      * Version century of ISDA Agreement
     C                   PARM                    Blank2X           2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      * Return
      * Defaulted Payment Settlement Instruction in file format
     C                   PARM                    F_Pay
 
      * Defaulted Receipt Settlement Instruction in file format
     C                   PARM                    F_Rec
 
      * Defaulted FRA/IRS Settlement Instruction in file format
     C                   PARM                    F_FRI
 
      * The defaulted instructions are in file format, but the
      * Settlements validation requires that they are in the input format.
      * Therefore run them through a conversion module.
 
     C                   CALLB     'ZASETINCVT'
 
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    F_Pay
     C                   PARM                    F_Rec
     C                   PARM      *BLANK        F_FRI
 
      ** Defaulted Settlement Instruction in input format
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM      S#FCCY        InTrCcy                                     CSF011A
     C                   PARM      S#FCCY        InTpCcy                                     CSF011A
 
     C                   ELSE                                                                 258669
      *                                                                                       258669
      ** If no settlement details entered, but retrieval from Fees                            258669
      ** Master is successful.                                                                258669
      *                                                                                       258669
     C                   IF            (InRecSttmt = *blank)                                  258669
     C                             AND (InPaySttmt = *blank)                                  258669
     C                             AND (F_PAY <> *blank)                                      258669
     C                             AND (F_REC <> *blank)                                      258669
     C                             AND (S#TYPE <> 'W')                                      MD022254
     C                             AND (S#TYPE <> ' ')                                      MD022254
      *                                                                                       258669
      ** The defaulted instructions are in file format, but the                               258669
      ** Settlements validation requires that they are in the input                           258669
      ** format. Therefore run them through a conversion module.                              258669
      *                                                                                       258669
     C                   CALLB     'ZASETINCVT'                                               258669
      *                                                                                       258669
      ** Defaulted Settlement Instructions in file format                                     258669
      *                                                                                       258669
     C                   PARM                    F_Pay                                        258669
     C                   PARM                    F_Rec                                        258669
     C                   PARM      *BLANK        F_FRI                                        258669
      *                                                                                       258669
      ** Defaulted Settlement Instruction in input format                                     258669
      *                                                                                       258669
     C                   PARM                    InPaySttmt                                   258669
     C                   PARM                    InRecSttmt                                   258669
     C                   PARM                    InFRASttmt                                   258669
     C                   PARM      S#FCCY        InTrCcy                                     CSF011A
     C                   PARM      S#FCCY        InTpCcy                                     CSF011A
      *                                                                                       258669
     C                   ENDIF                                                                258669
      *                                                                                       258669
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main fee settlement       *
      *              details                                           *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
 
     C                   IF        CLE106 = 'Y'                                               CLE106
     C                   EVAL      F5TNRF = S#EUTN                                            CLE106
     C                   ENDIF                                                                CLE106
 
      * Validate fee settlement details
 
     C                   CALLB     'LEFESTVAL'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Fee Settlement Details in screen format
     C                   PARM                    FESTScnFmt
 
      * Fee currency and decimal places
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
     C                   PARM                    F1IUSR           10
     C                   PARM                    F1XUSR           10
     C                   PARM                    F1AUSR           10
     C                   PARM                    FESTFilFmt
      *
      * OUTPUTS
 
      * Status
     C                   PARM                    S#STAT           10
      * Fee Type
     C                   PARM                    S#FTYP           10
      * Fee Code
     C                   PARM                    S#FCOD            2
      * Fee Code description
     C                   PARM                    S#FENV           20
      * Fee Amount Due/Past Due
     C                   PARM                    S#DUPD           18
      * Field OK flags
     C                   PARM                    FESTOkInd
 
      * Settlement amount
     C                   PARM                    W#SADJ           13 0
 
      * Settlement amount edited
     C                   PARM                    S#SADE           19
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
     C                   PARM                    WIdx
 
      * Valid Fee Settlement
     C                   PARM                    ValidFEST
 
                                                                                             CSF011A
      ** If Syndications Manager is off, override UTN with PC Ref value                      CSF011A
                                                                                             CSF011A
     C                   IF        CLE106 <> 'Y'                                             CSF011A
     C                   IF        UpdateYN = 'Y'                                            CSF011A
     C                   EVAL      V_STPCRF = S#EUTN                                         CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C     S#ACTN        IFNE      'D'                                                      AR919997
     C     S#ACTN        ANDNE     'X'                                                      AR919997
                                                                                            AR919997
     C                   EVAL      FESTFilFmt = ValidFEST                                   AR919997
                                                                                            AR919997
      ** Get the fee event type                                                             AR919997
                                                                                            AR919997
     C                   EVAL      S#RECI = V_STRECI                                        AR919997
                                                                                            AR919997
     C                   ENDIF                                                              AR919997
                                                                                            AR919997
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateSt - Routine to validate the settlement instructions  *
      *                                                               *
      *****************************************************************
     C     ValidateSt    BEGSR
      *
      ** Set up customer
     C                   MOVEL     S#CNUM        ##CSNM
      *
      * Dates should be set to value date
     C                   Eval      ##DATR = W#VDAT
     C                   Eval      ##DATP = W#VDAT
     C
      *
      * If no dates entered, use today's date
     C                   If        ##DATR = 0
     C                   Eval      ##DATR = WProcDate
     C                   EndIf
     C                   If        ##DATP = 0
     C                   Eval      ##DATP = WProcDate
     C                   EndIf
 
      ** Remove settlements if Settlement Allocation is available                             CLE034
                                                                                              CLE034
     C                   IF        S#STAL = 'Y'                                               CLE034
     C                   EVAL      InPaySttmt = *Blanks                                       CLE034
     C                   EVAL      InRecSttmt = *Blanks                                       CLE034
     C                   EVAL      DDPSTM = '00'                                              CLE034
     C                   EVAL      DDRSTM = '00'                                              CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   RESET                   ReturnCode
     C                   CALLB     'ZASETINVAL'
 
      ** Return Code
     C                   PARM                    ReturnCode
      ** Following parameters are output to called module
      ** Calling function type
     C                   PARM      'LEND'        ##CALP            4
      ** Transaction Fields
      ** Payment currency
     C***********        PARM      FccyFCCY      ##CCY             3                         BUG8459
     C                   PARM      S#FCCY        ##CCY             3                         BUG8459
      ** Receive currency
     C***********        PARM      FccyFCCY      ##CCY             3                         BUG8459
     C                   PARM      S#FCCY        ##CCY             3                         BUG8459
      ** Customer (shortname or number)
     C                   PARM                    ##CSNM           10
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
 
      * Protect Payment Field
     C                   PARM                    ##PPAY            1
      * Protect Receipt Field
     C                   PARM                    ##PREC            1
 
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
                                                                                              CAP086
      ** Set Auto Authorise flag for transactions from Interface                              CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      V_STAUTH   = IF_AUTH                                       CAP086
     C                   ENDIF                                                                CAP086
      *
     C                   IF        S#STAL = 'Y'                                               CLE034
     C                   EVAL      InPaySttmt = *Blanks                                       CLE034
     C                   EVAL      InRecSttmt = *Blanks                                       CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   ENDSR
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * SrCustname - Get the Customer details                         *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     SrCustName    BEGSR                                                               CSF011A
                                                                                             CSF011A
      ** Initialise Customer name fields                                                     CSF011A
                                                                                             CSF011A
     C                   EVAL      S#CNSN = *BLANKS                                          CSF011A
     C                   EVAL      S#CNNM = *BLANKS                                          CSF011A
     C                   EVAL      S#CNTN = *BLANKS                                          CSF011A
                                                                                             CSF011A
     C                   IF        S#CSSN <> *BLANKS                                         CSF011A
     C                   EVAL      WCustomer = S#CSSN                                        CSF011A
     C                   EXSR      ACCUST                                                    CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      S#CNSN = BBCSSN                                           CSF011A
     C                   EVAL      S#CNNM = BBCRNM                                           CSF011A
     C                   EVAL      S#CNTN = BBCRTN                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * ACCUST - ACCESS CUSTOMER DETAILS                              *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
                                                                                             CSF011A
     C     ACCUST        BEGSR                                                               CSF011A
     C                   CALL      'AOCUSTR0'                                                CSF011A
     C                   PARM      *BLANKS       @RTCD                                       CSF011A
     C                   PARM      '*KEY'        @OPTN                                       CSF011A
     C                   PARM                    WCustomer                                   CSF011A
     C                   PARM      *BLANKS       C#KYST                                      CSF011A
     C     SDCUST        PARM      SDCUST        DSSDY                                       CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETCYCLE- Reset error information that is gradually         *
      *             updated during each run of this program           *
      *                                                               *
      *****************************************************************
     C     RESETCYCLE    BEGSR
 
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
 
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx
 
     C                   MOVE      *ALL'Y'       FESTOkInd
 
     C                   CLEAR                   ValidFEST
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update database                                    *
      *                                                               *
      *****************************************************************
 
     C     UPDATEDB      BEGSR
      *
      * Update
     C                   RESET                   ReturnCode
     C                   CALLB     'LEFESTUPD'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    ReturnCode
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Action Code
     C                   PARM                    S#ACTN            1
 
      * Fee Settlement Details in file format
     C                   PARM                    FESTFilFmt
 
      * File Receive instructions
     C                   PARM                    F_Rec
 
      * File Payment instructions
     C                   PARM                    F_Pay
 
      * Fee currency
     C                   PARM                    S#FCCY            3
 
      * Value date
     C                   PARM                    W#VDAT            5 0
 
      * Settlement amount
     C                   PARM                    W#SADJ           13 0
 
      * Settlement adjustment due date
     C                   PARM                    W#SADD            5 0
 
      * Participant Fee Indicator
     C                   PARM                    W#PTFI            1
 
      * TNLU of fee settlement record on LEFEEAD
     C                   PARM                    TNLU              5 0
 
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
 
      * Front office inputs (if mode = 'B')
     C                   PARM                    F5PCOB
     C                   PARM                    F5TNRF
     C                   PARM                    F1IUSR
     C                   PARM                    F1XUSR
     C                   PARM                    F1AUSR
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    FESTOkInd
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
     C                   PARM                    WIdx
      *
      * If there were any errors in the update functions, rollback any
      * updates (done in *PSSR) and end this program. Otherwise commit.
     C                   If        ReturnCode <> *Blank
     C                   EXSR      *PSSR
     C                   ELSE
     C     CSC022        IFEQ      'N'                                                        CSC022
     C     WCMT01        OREQ      'N'                                                        CSC022
     C     CSC022        ANDEQ     'Y'                                                        CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
     C                   EndIf
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * The following /COPY contains the standard program status
      * subroutine, excluding a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   EVAL      APIRETC = '0'
     C                   RETURN
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
