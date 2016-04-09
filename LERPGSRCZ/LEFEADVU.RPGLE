     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee adjustment interface controller')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFEADVU - Fee adjustments validate and update               *
      *                                                               *
      *  Function: This program validates fee adjustments for input   *
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
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 CLE073             Date 13May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10626           Date 22Feb06               *
      *                 BUG9573 (Reopen)   Date 21Dec05               *
      *                 BUG9573            Date 15Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CAP086             Date 21Jun05               *
      *                 CSC022             Date 24Feb04               *
      *                 BUG1367            Date 05Mar04               *
      *                 BUG1304            Date 02Mar04               *
      *                 BUG1218            Date 01Mar04               *
      *                 BUG1306            Date 01Mar04               *
      *                 CAP084  *CREATE    Date 06Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *  CSF011 - Customer Name on Inputs                             *
      *  CLE073 - Calculated Loan Based Fees                          *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10626 - Confirmation page has details in Filler field     *
      *  BUG9573 - Pass the UTN values.                               *
      *  BUG9573 - Ensure that fee event type field is not blank.     *
      *  CLE106 - Syndications Manager                                *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it                                          *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  BUG1367- Delete and authorise functions not working          *
      *  BUG1304- Missing fee fields                                  *
      *  BUG1218- Status not shown                                    *
      *  BUG1306- Recompile due to change in signature of SP8LE0002   *
      *           due to change in parms for LEFESTVAL.               *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
                                                                                              CSC022
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
     D FEADScnFmt    E DS                  EXTNAME(LEFEADPD)
 
      *                                                                                       CLE106
      ** Incoming transaction 2 in screen format                                              CLE106
      *                                                                                       CLE106
     D FEA2ScnFmt    E DS                  EXTNAME(LEFEA2PD)                                  CLE106
                                                                                              CLE106
      * Valid file layout
     D ValidFEAD     E DS                  EXTNAME(LEVFEADPD)
     D                                     PREFIX(V_)
 
      * Current fee adjustment in file format
     D FEADFilFmt    E DS                  EXTNAME(LEFEEAD)
     D                                     PREFIX(FA_)
 
      * Error indicators
     D FEADOkInd     E DS                  EXTNAME(LEEFEADPD)
 
      *                                                                                       CSC022
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
     D  COMITNOM               1      3S 0                                                    CSC022
     D  COMITJOB               4    103                                                       CSC022
      *                                                                                       CSC022
      ** First DS for access programs, short data structure                                   CSC022
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSC022
      *                                                                                       CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
      * EXTERNAL DS FOR SAR DETAILS                                                           CSC022
                                                                                              CSF011
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSF011
      ** External DS for Customer Details                                                     CSF011
                                                                                              CAP086
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
      ** LE Info Data - Classe 1 Data - File (D/B) format                                     CAP086
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSF011
      ** Second DS for Access programs - long data structure                                  CSF011
      *                                                                                       CSC022
      ** +--------------------------------------+                                             CSC022
      ** ¦ Use of Indicator                     ¦                                             CSC022
      ** ¦ ================                     ¦                                             CSC022
      ** |                                      |                                             CSC022
      ** | 17      Used by LOOKUP               |                                             CSC022
      ** +--------------------------------------+                                             CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D CLE106          S              1A   INZ('N')                                           CLE106
     D CSC022          S              1A   INZ('N')                                           CSC022
      ** Counter variable                                                                     CSC022
     D WCMT01          S              1A                                                      CSC022
      ** Commitment Flag                                                                      CSC022
      * Index for arrays of error message ids etc
     D Idx             S              3P 0 INZ(0)
 
      * Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(0)
 
     D CAP086          S              1A   INZ('N')                                           CAP086
      ** Auto Authorisation flag                                                              CAP086
                                                                                              CAP086
      * Field to receive the incoming fee adjustment
     D Trans5001       S            500A
                                                                                              CAP086
     D InfData5001     S            500A                                                      CAP086
      ** Field (500A) to receive the incoming Interface Data                                  CAP086
 
      *                                                                                       CLE106
      ** Field to receive the incoming fee adjustment details 2                               CLE106
      *                                                                                       CLE106
     D Trans5002       S            500A                                                      CLE106
                                                                                              CSF011
     D PRtcd           S              7A                                                      CSF011
     D POptn           S              7A                                                      CSF011
     D PCNum           S             10A                                                      CSF011
     D PKey7           S              7A                                                      CSF011
      ** Parameters for Calling AOCUSTR0                                                      CSF011
                                                                                              CSF011
      ** Java user information
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)
 
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
     C                   MOVEL     Trans5001     FEADScnFmt
     C                   MOVEL     Trans5002     FEA2ScnFmt                                  BUG9573
     C                   MOVEL     InfData5001   InfData                                      CAP086
 
      ** Set Auto Authorise flag for transactions from Interface                              CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      V_ADAUTH = IF_AUTH                                         CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
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
      * If error in validation of action code, end here
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   EndIf
 
      * Validate transaction
     C                   EXSR      ValidateTr
     C     INVALID       TAG                                                                  CSF011
                                                                                              CSF011
      ** Population of Fee Adjustment Customer Details                                        CSF011
     C                   EXSR      SrPopCust                                                  CSF011
                                                                                              CSF011
      *
      * Write to database
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
                                                                                              CAP086
      ** Set Auto Authorise flag for transactions from Interface                              CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      FA_AUTH = IF_AUTH                                          CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   EXSR      UpdateDB
     C                   ENDIF
 
      * Remerge buffer with all relevant data structures
     C*******************EVAL      Buffer = FEADScnFmt                                       BUG1218
     C**********         EVAL      Buffer = FEADScnFmt + S#STAT                       BUG1218 CLE106
     C**********                   + S#FTYP + S#FCOD + S#FENV                         BUG1304 CLE106
     C**********                   + S#ACCD                                           BUG1304 CAP086
     C                   EVAL      Buffer = FEADScnFmt + FEA2ScnFmt                           CLE106
     C**********                   + S#ACCD + InfData                                CAP086 BUG10626
     C                                      + InfData                                       BUG10626
     C*****INVALID       TAG                                                                  CSF011
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
 
      * Fee adjustment information
     C                   PARM                    Trans5001
     C                   PARM                    Trans5002                                    CLE106
     C                   PARM                    InfData5001                                  CAP086
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
     D/COPY WNCPYSRC,LEFEADVM01
      *                                                                                       CLE106
      ** Determine if CLE106 is switched on                                                   CLE106
      *                                                                                       CLE106
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
      *
      * Key lists
     C     KFEAD         KLIST
     C                   KFLD                    @@CUSN            6 0
     C                   KFLD                    @@FACL            5 0
     C**********         KFLD                    @@LOAN            6 0                        CLE148
     C                   KFLD                    @@LOAN            6                          CLE148
     C                   KFLD                    @@FSEQ            2 0
     C                   KFLD                    @@VDAT            5 0
 
      *  Hook to enable non-core initial processing to be included
     D/COPY WNCPYSRC,LEFEADV001
 
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
     C                   EVAL      DBPGM = 'LEFEADVU'                                         CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE ='SCSARDPD'                                         CSC022
     C                   EVAL      DBASE  = 905                                               CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
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
                                                                                              CAP086
     C                   IF        @RTCD <> *BLANKS AND                                       CAP086
     C                             @RTCD <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBPGM = 'LEFEADVU'                                         CAP086
     C                   EVAL      DBKEY = 'CAP086'                                           CAP086
     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP086
     C                   EVAL      DBASE  = 906                                               CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANK                                             CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
      *                                                                                       CSC022
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *              fee adjustment supplied                          *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      * Validate action code versus fee adjustment supplied
      * The fee adjustment in file format from the database is retrieved
      * as well.
     C                   RESET                   ReturnCode
 
     C                   CALLB     'LEFEADRTV'
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
      * and fee sequence number
     C                   PARM                    S#ACTN            1
     C                   PARM                    S#CSSN           10
     C                   PARM                    S#FACT            3
     C                   PARM                    S#FCNO            2
     C                   PARM                    S#FSEQ            2
     C                   PARM                    S#LOAN            6                          CLE073
      *
      * OUTPUTS
 
      * Fee adjustment Details in file format
     C                   PARM                    FEADFilFmt
 
      * Action, customer, facility type, facility number,
      * and fee sequence number OK indicators
     C                   PARM                    S#ACTNok          1
     C                   PARM                    S#CSSNok          1
     C                   PARM                    S#FACTok          1
     C                   PARM                    S#FCNOok          1
     C                   PARM                    S#FSEQok          1
     C                   PARM                    S#LOANok          1                          CLE073
 
      * Customer number
     C                   PARM                    S#CNUM            6
 
      * Fee currency and decimal places
     C                   PARM                    S#FCCY            3
     C                   PARM                    FecyNBDP          1 0
 
      * Fee type, fee code, fee narrative, total fee accrued to date
     C                   PARM                    S#FTYP           10
     C                   PARM                    S#FCOD            2
     C                   PARM                    S#FENV           20
     C                   PARM                    S#ACCD           18
 
      * Settlement adjustment due date
     C                   PARM                    W#SADD            5 0
 
      * Participant Fee Indicator
     C                   PARM                    W#PTFI            1
 
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
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main fee adjustment       *
      *              details                                           *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
      *                                                                                       CLE106
     C                   IF        CLE106 = 'Y'                                               CLE106
     C                   EVAL      F5TNRF = S#EUTN                                            CLE106
     C                   ENDIF                                                                CLE106
 
      * Validate fee adjustment details
 
     C                   CALLB     'LEFEADVAL'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Fee adjustment Details in screen format
     C                   PARM                    FEADScnFmt
 
      * Fee currency and decimal places
     C                   PARM                    FecyNBDP          1 0
 
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
      *
      * OUTPUTS
 
      * Status                                                                  BUG1218
     C                   PARM                    S#STAT           10            BUG1218
      * Adjustment amount
     C                   PARM                    W#SADJ           13 0
 
      * Adjustment amount edited
     C                   PARM                    S#SADE           19
 
      * Field OK flags
     C                   PARM                    FEADOkInd
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
 
      * Valid Fee adjustment
     C                   PARM                    ValidFEAD
 
      * Don't really want to do this if we are deleting as FEADFilFmt                        BUG1367
      * has data in which is used to set up key fields for deleting the                      BUG1367
      * record and ValidFEAD is blank. Same appears to be true for                           BUG1367
      * authorising.                                                                         BUG1367
     C     S#ACTN        IFNE      'D'                                                       BUG1367
     C     S#ACTN        ANDNE     'X'                                                       BUG1367
     C                   Eval      FEADFilFmt = ValidFEAD
      * Get the fee event type                                                               BUG9573
     C                   EVAL      S#RECI = V_ADRECI                                         BUG9573
     C                   Endif                                                               BUG1367
      **Get*the*fee*event*type*****************************************              BUG9573 BUG9573
     C**********         EVAL      S#RECI = V_ADRECI                                 BUG9573 BUG9573
 
     C                   ENDSR
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
 
     C                   MOVE      *ALL'Y'       FEADOkInd
 
     C                   CLEAR                   ValidFEAD
 
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
      * Set up defaults
      *
      * Update
     C                   RESET                   ReturnCode
     C                   CALLB     'LEFEADUPD'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    ReturnCode
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Action Code
     C                   PARM                    S#ACTN            1
 
      * Fee adjustment details in file format
     C                   PARM                    FEADFilFmt
 
      * Fee currency
     C                   PARM                    S#FCCY            3
 
      * Adjustment amount
     C                   PARM                    W#SADJ           13 0
 
      * Settlement adjustment due date
     C                   PARM                    W#SADD            5 0
 
      * Participant Fee Indicator
     C                   PARM                    W#PTFI            1
 
      * TNLU of fee adjustment record on LEFEEAD
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
     C                   PARM                    F1IUSR           10
     C                   PARM                    F1XUSR           10
     C                   PARM                    F1AUSR           10
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    FEADOkInd
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
     C                   If        ReturnCode <> *Blank and
     C                             ReturnCode <> '*RECUPD' or
     C                             *INU7 = '1' or *INU8 = '1'
     C                   MOVEL     '0'           APIRetc
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
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      *  SrPopCust - Subroutine to Populate Customer Name Details     *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
      *                                                                                       CSF011
     C     SrPopCust     BEGSR                                                                CSF011
                                                                                              CSF011
      ** Retrieve Customer Details                                                            CSF011
                                                                                              CSF011
     C                   EVAL      S#CNSN  = *BLANKS                                         CSF011A
     C                   EVAL      S#CNNM  = *BLANKS                                         CSF011A
     C                   EVAL      S#CNTN  = *BLANKS                                         CSF011A
     C                   IF        S#CSSN <> *BLANKS                                          CSF011
     C                   EVAL      PCNum = S#CSSN                                             CSF011
      *                                                                                       CSF011
     C                   EXSR      SrRtvCust                                                  CSF011
     C                   IF        PRtcd = *BLANKS                                            CSF011
     C                   EVAL      S#CNSN  = BBCSSN                                          CSF011A
     C                   EVAL      S#CNNM  = BBCRNM                                          CSF011A
     C                   EVAL      S#CNTN  = BBCRTN                                          CSF011A
     C                   ENDIF                                                                CSF011
      *                                                                                       CSF011
     C                   ENDIF                                                                CSF011
      *                                                                                       CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************                       CSF011
      /EJECT                                                                                  CSF011
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      *  SrRtvCust - Subroutine to Retrieve Customer Details          *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrRtvCust     BEGSR                                                                CSF011
                                                                                              CSF011
      ** Call AOCUSTR0 to get Customer Name Details                                           CSF011
                                                                                              CSF011
     C                   CALL      'AOCUSTR0'                                                 CSF011
     C                   PARM      *BLANKS       PRtcd                                        CSF011
     C                   PARM      '*KEY   '     POptn                                        CSF011
     C                   PARM                    PCNum                                        CSF011
     C                   PARM      *BLANKS       PKey7                                        CSF011
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSF011
      *                                                                                       CSF011
     C                   ENDSR                                                                CSF011
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
(c) Misys International Banking Systems Ltd. 2003
