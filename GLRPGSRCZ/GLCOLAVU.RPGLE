     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Collateral allocations valid and update')     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLAVU - Collateral Allocations validate and update        *
      *                                                               *
      *  Function: This program validates Collateral Alocations for   *
      *            input into the Midas database.                     *
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
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11623           Date 27Jun06               *
      *                 CGL072             Date 10Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL018             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 23Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *            (Recompile)                                        *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  BUG11623 - Sequence No. column should be included (Recompile)*
      *  CGL072 - Allow GL Accounts as Collateral                     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      * Hook to enable non-core files to be included
 
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
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API CTL & VU modules.
     D/COPY ZACPYSRC,APICTLARR
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
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
 
      ** String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming transaction in screen format
     D TranInCOLA    E DS                  EXTNAME(GLSCLAPD)
 
      * Valid file layout
     D ValidCOLA     E DS                  EXTNAME(GLCOLAPD)
     D                                     PREFIX(V_)
 
     D PaySttmt      E DS                  EXTNAME(SDESSPPD)
      * Pay Settlement Instructions
     D RecSttmt      E DS                  EXTNAME(SDESSRPD)
      * Receive Settlement Instructions
 
      * Current transaction record in file format
     D COLAFilFmt    E DS                  EXTNAME(GLCOLAPD)
 
      ** Deal in File Format from the file where original transactions are written to
     D COLLFilFmt    E DS                  EXTNAME(GLCOLLPD)
     D QQSAC1        E                     EXTFLD(QQSACD)                                     CGL029
 
      * Error indicators
     D OKGLCOLA      E DS                  EXTNAME(GLECLAPD)
 
      * External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      * External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      * External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
 
      * First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * Second DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** 24X7 status dataarea
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** DS for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10
     D  PDBRN                 11     13
     D  PDPPT                 14     16
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)
 
      * Index for arrays of error message ids etc in amend validation
     D AmIdx           S              3P 0 INZ(0)
 
      * Index for arrays of error message ids etc
     D Idx             S              3P 0 INZ(0)
 
      * Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(0)
 
      ** Override Database Table
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)
 
      * Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
 
      * Field (500A) to receive the incoming Extra Data
     D InfData500      S            500A
 
      * Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      * Indices for arrays used to set up corresponding
      * sequence numbers for the fields that are in error
     D*Ix*******       S              3P 0
     D*Iy*******       S              3P 0
 
     D Object          S             10A   INZ('GLCOLAUPD')
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
     D WProcDate       S                   LIKE(BJRDNB)
     D PRTCD           S              7A
 
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
 
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepCOLA         S              1A   INZ('N')
 
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
      /EJECT
      *****************************************************************
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * Incoming transaction is broken into 500A fields - load them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     TranInCOLA
 
      * Reset variables gradually updated
     C                   EXSR      RESETCYCLE
 
      * Validate action code
     C                   EXSR      ValidateAc
      *
      * If error in validation of action code, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      * Processing depends upon action code
     C                   SELECT
 
      * Processing for inserts
     C                   WHEN         ADACTN = 'I'
     C                   EXSR      ValidateTr
 
      * Processing for amends or changes
     C                   WHEN         ADACTN = 'A'
     C                   EXSR      SetupAmd
     C                   EXSR      ValidateTr
 
      * Processing for deletes
     C                   WHEN         ADACTN = 'D'
     C                   EXSR      SetupAmd
 
     C                   ENDSL
      *
     C     INVALID       TAG
 
      * Write to database
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      UpdateDB
     C                   ENDIF
 
     C                   SETON                                        LR
 
      * Remerge buffer with all relevant data structures
     C                   EVAL                    Buffer = TranInCOLA
 
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
 
      * Transaction information
     C                   PARM                    Trans5001
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    ReservID         10
     C                   PARM                    ExtData500
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
     C                   EVAL      MsgFArray(1) = 'GLUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,GLCOLA02
      *
      * Access bank details via access program
      * (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      * Access SAR details file to determine if CSC011 switchable feature
      * is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD = *Blanks
 
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
 
      ** If 24X7 Midas availability is installed and support system is
      ** active, used processing date from dataarea SC24X7 as the
      ** rundate.
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
     C                   EVAL      WProcDate = S1DATE
     C                   ELSE
     C                   EVAL      WProcDate = BJRDNB
     C                   ENDIF
 
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
 
      ** Check if Collateral Authorisations is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGL012'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD <> *BLANKS AND
     C                             @RTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 901
     C                   EVAL      DBKEY = @SARD
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CGL012 = 'Y'
     C                   ELSE
     C                   EVAL      CGL012 = 'N'
     C                   ENDIF
                                                                                             CGL072
      ** Check if CGL072 is installed                                                        CGL072
                                                                                             CGL072
     C                   CALL      'AOSARDR0'                                                CGL072
     C                   PARM      *BLANKS       @RTCD                                       CGL072
     C                   PARM      '*VERIFY'     @OPTN                                       CGL072
     C                   PARM      'CGL072'      @SARD                                       CGL072
     C     SCSARD        PARM      SCSARD        DSFDY                                       CGL072
                                                                                             CGL072
     C                   IF        @RTCD = *BLANKS                                           CGL072
     C                   EVAL      CGL072 = 'Y'                                              CGL072
     C                   ELSE                                                                CGL072
     C                   EVAL      CGL072 = 'N'                                              CGL072
     C                   ENDIF                                                               CGL072
      *
      * Overrride GLCOLAL0
      *
     C                   Z-ADD     50            MESLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
      *
      *  Hook to enable non-core initial processing to be included
     D/COPY WNCPYSRC,GLCOLA01
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *              transaction number supplied                      *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      * Validate action code versus transaction IDs supplied
      * The Transaction in file format from the Sk database is retrieved
      * as well.
     C                   RESET                   RetCodeIn
 
     C                   CALLB     'GLCOLARTV'
      *
      * INPUTS
      ** Return Code
     C                   PARM                    RetCodeIn
      * Mode
     C                   PARM                    P#MODE            1
      * Response mode
     C                   PARM      'S'           RESPMODE          1
 
      * Action and screen fields
     C                   PARM                    ADACTN            1
     C                   PARM                    ADBRCA            3
     C                   PARM                    ADCUSN           10
     C                   PARM                    ADMODI            2
     C                   PARM                    ADFCTY           11
     C                   PARM                    ADLNLM            6
     C**********         PARM                    ADREAC           18                          CGL029
     C                   PARM                    ADREAC           24                          CGL029
     C                   PARM                    ADCREF           10
      *
      * OUTPUTS
      * Assignment Details in file format
     C                   PARM                    COLAFilFmt
 
      * Action and customer OK indicators
     C                   PARM                    S#ACTNok          1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Access Collateral Details to get the Collateral Currency code.
      * (use field values from TranInCola)
      *
     C     Idx           IFEQ      0
     C                   MOVE      'E'           DDACTN
     C                   MOVE      ADCREF        DDCREF
     C                   MOVE      CAFRNT        DDFRTN
     C                   EXSR      GLCOLLRTV
      *
      * Move value of collateral currency here for subsequent processing
      *
     C                   MOVE      CDCCY         PColCur
     C                   ENDIF
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      **********************************************************************
 
     C     GLCOLLRTV     BEGSR
      *
     C                   CALLB     'GLCOLLRTV'
      ** INPUT PARAMETERS:
      *  ----------------
      ** Initial screen fields
     C                   PARM                    DDACTN            1
     C                   PARM                    DDCREF           10
     C                   PARM                    DDREVF           10
     C                   PARM      *BLANK        DDREQR            1
     C                   PARM      *BLANK        DDSENT            1
     C                   PARM      *BLANK        DDSCMP            3
     C                   PARM      *BLANK        DDSBRC            3
     C                   PARM      *BLANK        DDSCOL            5
     C                   PARM      *BLANK        DDSCNU           10
     C                   PARM      *BLANK        DDSCCY            3
     C                   PARM      *BLANK        DDSVAL           16
     C                   PARM      *BLANK        DDSGNS            1
      *
     C                   PARM                    CGL012            1
      *
      ** Mode of operation
     C                   PARM      *BLANK        ModeOp            6
      *
      ** Response Mode
     C                   PARM      'S'           RespMode          1
      *
      ** Front Office Id
     C                   PARM                    DDFRTN           20
      *
      ** OUTPUT PARAMETERS:
      *  -----------------
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Collateral details (file format)
     C                   PARM      *BLANKS       COLLFilFmt
      *
      ** OK Flags
     C                   PARM      *BLANK        DDACTNOK          1
     C                   PARM      *BLANK        DDCREFOK          1
     C                   PARM      *BLANK        DDREVFOK          1
     C                   PARM      *BLANK        DDREQROK          1
     C                   PARM      *BLANK        DDSENTOK          1
     C                   PARM      *BLANK        DDSCMPOK          1
     C                   PARM      *BLANK        DDSBRCOK          1
     C                   PARM      *BLANK        DDSCOLOK          1
     C                   PARM      *BLANK        DDSCNUOK          1
     C                   PARM      *BLANK        DDSCCYOK          1
     C                   PARM      *BLANK        DDSVALOK          1
     C                   PARM      *BLANK        DDSGNSOK          1
      *
      ** Set FldNameArr errors to ADCREF for highlighting collateral reference.
      ** For errors COL0011, COL0004 and COL0006 from GLCOLLRTV.
     C                   Z-ADD     1             I                 3 0
     C                   MOVEL     'DDACTN    '  TEST             10
     C     TEST          LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'ADCREF    '  FldNameArr(I)
      *
     C                   ELSE
     C                   Z-ADD     1             I
     C                   MOVEL     'DDCREF    '  TEST
     C     TEST          LOOKUP    FldNameArr(I)                          89
     C     *IN89         IFEQ      '1'
     C                   MOVEL     'ADCREF    '  FldNameArr(I)
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *            of amendments. Also needed for deletes to be       *
      *            passed to update module (GLCOLAUPD).               *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR
 
      * For amends or deletes, put the complete (pre-existing) transaction
      * file record.
 
     C                   MOVE      COLAFilFmt    ValidCOLA
 
      * Ensure that CHTP is correctly set for amends and deletes.
 
     C                   EVAL      V_CACHTP = ADACTN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
 
      * Validate transaction details
     C                   RESET                   ReturnCode
 
     C                   CALLB     'GLCOLAVAL'
 
      * Inputs
 
      * Response mode
     C                   PARM      'S'           RespMode          1
 
      ** Collateral Allocations Details
     C                   PARM                    TranInCOLA
      * Outputs
      *
      ** Collateral Allocations Details OK inds
     C                   PARM                    OKGLCOLA
 
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
 
      * Valid Collateral Allocations (DS) from/to caller
     C                   PARM                    ValidCOLA
 
     C                   PARM                    PColRef          10
     C                   PARM                    PColCur           3
     C                   PARM                    SBlank            1
     C                   PARM                    WchgDel           1
     C                   PARM                    CGL072            1                          CGL072
      *
      *  For an Insert Ensure Collateral Reference chosen is of a General type.
     C                   IF           ADACTN = 'I'
     C     CDCOPT        IFNE      'G'
     C                   MOVEL     'ADCREF'      FldNameArr(1)
     C                   MOVEL     'COL0132'     MsgIdArr(1)
     C                   Add       1             Idx
     C                   Endif
     C                   ENDIF
      *
      *  If error in validation, fail this input
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   EndIf
 
     C     EValidTr      ENDSR
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
 
     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx
 
 
     C                   RESET                   FldNoArr
 
     C                   MOVE      *ALL'Y'       OKGLCOLA
 
     C                   CLEAR                   ValidCOLA
 
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
     C                   CALLB     'GLCOLAUPD'
 
      * Ensure correct parameters for this UPD function
     C                   PARM      *BLANK        @RTCD
     C                   PARM                    ValidCOLA
     C                   PARM                    PColCur
      *
      * If there were any errors in the update functions, rollback any
      * updates (done in *PSSR) and end this program. Otherwise commit.
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C     @RTCD         ANDNE     'Y2U0032'
     C                   MOVEL     '0'           APIRetc
     C                   EXSR      *PSSR
     C                   EndIf
      *
      * If update not done due to record being updated by another
      * workstation send message to screen.
 
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'APM1000'     MsgIdArr(1)
 
     C                   EndIf
 
      * If duplicate access path occurred during update, send message
      * to screen indicating record already exist.
 
     C     @RTCD         IFEQ      'Y2U0032'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'CSF9143'     MsgIdArr(1)
     C                   Add       1             Idx
     C                   Endif
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * The following /COPY contains the standard program status
      * subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
** ##OX1
OVRDBF FILE(GLCOLAX0) TOFILE(GLCOLAL0) SHARE(*NO)
