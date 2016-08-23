     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Prices Input - Validate and Update')          *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEPRCSVU - SE Prices Input - Validate and update             *
      *                                                               *
      *  Function: This program validates SE Prices transactions for  *
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
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG22153           Date 14Jan09               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG9475            Date 10Jan06               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG4728            Date 05Nov04               *
      *                 BUG4258            Date 13Sep04               *
      *                 CAP084  *CREATE    Date 08Jan04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  BUG22153 - Missing authorization field in repository.        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9475 - Incorrect Net Treasury Price display format        *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG4728 - Serious Midas error with blank timestamp when      *
      *            authorising insert of transaction.                 *
      *  BUG4258- Stopping changes being overwritten by other user    *
      *           when try to amend the record at the same time.      *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SEPRCSC001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes definitions for thefields
      ** #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member.
     D/COPY ZACPYSRC,PROCPARMS
      **--------------------------------------------------------------------------------------------
 
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
 
     D WCmtJobArr      S             10A   DIM(10)
      ** Array for commitment job names
 
      ** Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      ** Incoming Price Record
     D TranInPRCS    E DS                  EXTNAME(SEPRCSPD)
 
      * (Current) Transaction in Screen Format - Main Details
     D CurTrPRCS     E DS                  EXTNAME(SEPRCSPD)
     D                                     PREFIX(@)
 
      ** (Current) Price record in File Format
     D PRCSFilFmt    E DS                  EXTNAME(PRICE)
 
      ** Valid Price layout
     D ValidPRCS     E DS                  EXTNAME(SEVPRCSPD)
     D                                     PREFIX(V_)
 
      ** Valid Extra Data Price validation details layout
     D ValidPRXT     E DS                  EXTNAME(SEVPRXTPD)
 
      ** New Extel Details in file format
     D ValidEXTEL    E DS                  EXTNAME(SEVEXVLPD)
 
      ** Flags to indicate whether Price fields are valid
     D OKFlagsDS     E DS                  EXTNAME(SEEPRCSPD)
 
      * Prices Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(SEPREXPD)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
     D** Security Trading Detail
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Midas Modules details accessed via access program
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure
 
 
      ** 24x7 Status Data Area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** SD Data Area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)
     D  ComitJob               4    103
      ** Midas SC Jobs handling commitment control data area
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Field (500A) to receive the incoming Prices record
     D Trans500        S            500A
 
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0 INZ(0)
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(0)
 
      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0 INZ(0)
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A   INZ('SE')
 
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D REPPRCS         S              1A   inz('N')
 
     D HPPRC           S                   LIKE(PPRC)
     D FCR997          S                   LIKE(@CR997)
 
      ** Switchable Features
     D CAC005          S              1A
     D CAP060          S              1A
     D CAS006          S              1A
     D CSC011          S              1A
     D CSD006          S              1A
     D CSD010          S              1A
     D CGL031          S              1A                                                      CGL031
                                                                                              CGL031
      ** Parameters and Working variables                                                     CGL031
     D ZFLD15          S             15P 0                                                    CGL031
     D ZDECS           S              1P 0                                                    CGL031
     D ZECHAR          S              1A                                                      CGL031
     D ZOUT21          S             21A                                                      CGL031
                                                                                              CGL031
     D WINTP           S             15P 8                                                    CGL031
 
     D HBDPR           S                   LIKE(PRBDPR)
     D HOFPR           S                   LIKE(PROFPR)
     D HCLPR           S                   LIKE(PRCLPR)
 
     D @RDNB           S              1A
     D @SCRN           S              1A
     D PRtCd           S              7A                                                      CGL031
     D POptn           S              7A                                                      CGL031
     D PSard           S              6A                                                      CGL031
 
     D                 DS
     D  WDDFTS                 1     14A
     D  DDTSDT                 3      8A
     D  DDTSTM                 9     14A
 
     D  WDMKPN                       16A   INZ(*BLANKS)
 
     D CSC022          S              1A
 
     D WCommitSkip     S              1A
      ** Commitment Skip Field
                                                                                             BUG9475
     D  ZFIELD         S             16A                                                     BUG9475
     D  ZADEC          S              1  0                                                   BUG9475
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SEPRCSC002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   MOVEL     Trans500      TranInPRCS
     C                   MOVEL     Extdata500    Extdata
 
      ** Reset variables gradually updated
     C                   EXSR      ResetCycle
 
      ** Validate Action Code
     C                   EXSR      ValidateAc
 
      ** If error in validation of action code, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Call defaulting sub-routine
     C                   IF        CAP060 = 'Y'
     C                   EXSR      SRDFT
     C                   ENDIF
 
      ** If error in validation of action code, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      * Default in values for EXTEL fields if they have been omitted from the incoming
      * message, CAP060 is on and the price type and extel fields are set accordingly
     C                   IF        CAP060 = 'Y'
     C                   IF        @DDPSRC<> *BLANKS AND
     C                             DDPSRC = *BLANKS
     C                   MOVEL     @DDPSRC       DDPSRC
     C                   ENDIF
 
     C                   IF        @DDAPND<> *BLANKS AND
     C                             DDAPND = *BLANKS
     C                   MOVEL     @DDAPND       DDAPND
     C                   ENDIF
 
     C                   IF        @DDLPRI<> *BLANKS AND
     C                             DDLPRI = *BLANKS
     C                   MOVEL     @DDLPRI       DDLPRI
     C                   ENDIF
 
     C                   IF        @DDUPRI<> *BLANKS AND
     C                             DDUPRI = *BLANKS
     C                   MOVEL     @DDUPRI       DDUPRI
     C                   ENDIF
 
     C                   IF        @DDPCEN<> *BLANKS AND
     C                             DDPCEN = *BLANKS
     C                   MOVEL     @DDPCEN       DDPCEN
     C                   ENDIF
     C                   ENDIF
 
 
      ** Validate the main details of the transaction
 
      **  Processing depends upon Action Code
 
     C                   SELECT
 
      **  Processing for Inserts
     C                   WHEN      DDACTN = 'I'
     C                   EXSR      ValidateTr
 
      **  Processing for Amends or Changes
     C                   WHEN      DDACTN = 'A' OR
     C                             DDACTN = 'D'
     C                   EXSR      SetupAmd
     C                   EXSR      ValidateTr
 
     C                   ENDSL
 
     C     INVALID       TAG
 
      * Write to database
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      UpdateDB
     C                   ENDIF
 
      ** Set output fields
     C                   MOVEL     DDDFTS        WDDFTS
     C                   IF        DDPSSN <> *BLANKS
     C     DDPSSN        CHAIN     SECTY                              01
     C                   IF        *IN01 = *Off
     C**********         MOVEL     MKPN          WDMKPN                                      BUG9475
                                                                                             BUG9475
     C                   MOVE      *BLANKS       ZFIELD                                      BUG9475
     C                   MOVE      MKPN          ZFIELD                                      BUG9475
     C                   Z-ADD     8             ZADEC                                       BUG9475
     C                   CALLB     'ZEDIT'                                                   BUG9475
     C                   PARM                    ZFIELD                                      BUG9475
     C                   PARM                    ZADEC                                       BUG9475
     C                   MOVE      ZFIELD        WDMKPN                                      BUG9475
                                                                                             BUG9475
     C                   ENDIF
     C                   ENDIF
 
      ** Setup buffer
     C****************   EVAL      Buffer = TranInPRCS + WDMKPN + DDTSDT                     BUG4258
     C                   EVAL      Buffer = TranInPRCS                                       BUG4258
     C                                      + @TimeStamp
     C                                      + WDMKPN + DDTSDT                                BUG4258
     C                                      + DDTSTM
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDFT     - Subroutine for defaulting EXVALD fields IF       *
      *              price type is 'V' and BVEXOP = 'Y'               *
      *                                                               *
      *****************************************************************
 
     C     SRDFT         BEGSR
 
     C                   CALLB     'SEPRCSDFT'
 
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Action Code
     C                   PARM                    DDACTN            1
 
      ** Security Shortname
     C                   PARM                    DDPSSN           10
 
      ** Price Type
     C                   PARM                    DDPPRT            2
 
      ** Price in file format
     C                   PARM                    PRCSFilFmt
 
      ** ICD
     C                   PARM                    BVEXOP
 
      ** Output
      ** Screen Output
 
      ** Price Source
     C                   PARM                    @DDPSRC
 
      ** Auto-Price Indicator
     C                   PARM                    @DDAPND
 
      ** Lower Price Boundary
     C                   PARM                    @DDLPRI
 
      ** Upper Price Boundary
     C                   PARM                    @DDUPRI
 
      ** Percentage
     C                   PARM                    @DDPCEN
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    IDX
 
      ** Security shortname OK flag
     C                   PARM      *BLANK        DDSSNOK
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *              Security short name  supplied.                   *
      *              Implied action code is always 'I', therefore,    *
      *              simply validate that security exists.            *
      *****************************************************************
 
     C     ValidateAc    BEGSR
 
      ** Validate action code versus security short name supplied.
      ** The Prices record in file format from the SE database is
      ** retrieved as well.
 
     C                   RESET                   ReturnCode
     C
     C                   CALLB     'SEPRCSRTV'
 
      ** Inputs
      ** Return code
     C                   PARM      *BLANK        ReturnCode
 
      ** Mode of operation
     C                   PARM      *BLANKS       MODEOFOP          6
 
      ** Response mode
     C                   PARM      'S'           APRESPMODE
 
      ** Front Office Transaction ID
     C                   PARM                    APFOTRANID
 
      ** Action Code
     C     @DDACTN       PARM                    DDACTN            1
 
      ** Key fields
     C     @DDPSSN       PARM                    DDPSSN           10
     C     @DDPCNM       PARM                    DDPCNM           10
     C     @DDPMKT       PARM                    DDPMKT            1
     C     @DDPBRA       PARM                    DDPBRA            3
     C     @DDPBOK       PARM                    DDPBOK            2
     C     @DDPRFC       PARM                    DDPRFC            4
     C     @DDPPRT       PARM                    DDPPRT            2
     C     @DDPTFR       PARM                    DDPTFR            4
 
      ** ICD
      ** Extel Indicator
     C                   PARM                    BVEXOP
 
      ** Output
      ** (Current) deal in file format
     C                   PARM                    PRCSFilFmt
 
      ** If CAC005 is on, this is the book code the user entered on the screen (file format)
     C                   PARM                    PBCD              2
 
      ** If CAC005 is on, this is the pseudo book ( the book stored on file on PRICED )
      ** If CAC005 is off, this is the book the user entered on the screen (file format)
     C                   PARM                    PBOK              2
 
      ** Profit centre, in file format
     C                   PARM                    PRFC              4
 
      ** Customer number in file format
     C                   PARM                    PCNM
 
      ** Current Price retrieved, depending on price type
     C                   PARM                    DDCURP           16
      *
      ** OK flags
     C                   PARM                    DDACTNOK
     C                   PARM                    DDSSNOK
     C                   PARM                    DDPCNMOK
     C                   PARM                    DDPMKTOK
     C                   PARM                    DDPBRAOK
     C                   PARM                    DDPBOKOK
     C                   PARM                    DDPRFCOK
     C                   PARM                    DDPRTOK
     C                   PARM                    DDPTFROK
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM                    WIdx
     C                   PARM      FCR997        @CR997            4
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateTr - Routine to validate the main Prices details      *
      *                                                               *
      *****************************************************************
 
     C     ValidateTr    BEGSR
 
      ** Set up valid fields
     C                   EXSR      SRMVVL
 
     C                   CALLB     'SEPRCSVAL'
 
      **  Response mode (1A), from source system common header
     C                   PARM      'S'           APRespMode
 
      ** Transaction information (DS) from source system
     C                   PARM                    TranInPRCS
     C                   PARM                    ExtData
 
      ** Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
 
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
 
      ** Valid Prices layout (DS) from/to caller
     C                   PARM                    ValidPRCS
     C                   PARM                    ValidEXTEL
     C                   PARM                    ValidPRXT
     C                   PARM                    HPPRC
 
      ** CAC005 switchable feature on (Y / N)
     C                   PARM                    CAC005
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
                                                                                              CGL031
      ** Compute Interest Price for display                                                   CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y' AND                                           CGL031
     C                             DDPRCOK <> 'N' AND                                         CGL031
     C                             DDPEXIOK <> 'N'                                            CGL031
                                                                                              CGL031
     C                   EVAL      WINTP = V_PRPPRC - V_PRPEXI                                CGL031
                                                                                              CGL031
     C                   MOVE      WINTP         ZFLD15                                       CGL031
     C                   Z-ADD     8             ZDECS                                        CGL031
                                                                                              CGL031
     C                   CALLB     'ZSEDIT'                                                   CGL031
     C                   PARM                    ZFLD15                                       CGL031
     C                   PARM                    ZDECS                                        CGL031
     C                   PARM                    ZECHAR                                       CGL031
     C                   PARM                    ZOUT21                                       CGL031
                                                                                              CGL031
     C                   MOVE      ZOUT21        DDINTP                                       CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
 
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
 
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx
 
     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx
 
     C                   RESET                   FldNoArr
 
     C                   MOVE      *ALL'Y'       OKFlagsDS
 
     C                   CLEAR                   ValidPRCS
     C                   CLEAR                   ValidPRXT
 
     C                   CLEAR                   ValidEXTEL
     C                   CLEAR                   CurTrPRCS
 
      * Output only fields
     C                   EVAL      DDCURP = *BLANKS
     C                   EVAL      DDPSRC = *BLANKS
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UpdateDB - Update database                                    *
      *                                                               *
      *****************************************************************
 
     C     UpdateDB      BEGSR
 
     C                   EVAL      V_PRCHTP = DDACTN
 
      * Restore Timestamp from the original record                                           BUG4258
     C                   IF        DDACTN <> 'I'                                             BUG4258
     C                             AND @TimeStamp <> *BLANKS                                 BUG4728
     C                   MOVEL     @TimeStamp    V_PRTMESTMP                                 BUG4258
     C                   ENDIF                                                               BUG4258
                                                                                             BUG4258
     C                   CALLB     'SEPRCSUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ValidPRCS
     C                   PARM                    ValidEXTEL
     C                   PARM                    ValidPRXT
     C                   PARM                    CAC005
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C                   ROLBK
     C     @RTCD         IFNE      '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ELSE
     C                   IF        (CSC022 <> 'Y')
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')
     C                   COMMIT
     C                   ENDIF
     C                   ENDIF
      *
     C** If update not done due to record being updated by another
     C** workstation send message to screen.
     C
     C     @RTCD         IFEQ      '*RECUPD'
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C                   MOVEL     'N'           CLRSCRN
     C
     C                   ENDIF
     C
      * BLANK THE MAIN DETAILS SCREEN
      *
     C                   MOVEL     *BLANK        CurTrPRCS
     C                   MOVEL     *BLANK        DDSTS             8
     C                   MOVEL     'Y'           CLRSCRN           1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SETUPAMD - Set up fields that are needed in the validation   *
      *             of amendments and changes.                        *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR
 
      ** Call program to fill screen fields with data
 
     C                   CALLB     'SEPRCSCVT'
 
      ** Inputs
      ** Return Code
     C                   PARM                    DDSTS
     C                   PARM      *BLANK        ReturnCode
 
      ** Deal in file format
     C                   PARM                    PRCSFilFmt
 
      ** If CAC005 is on, this is the pseudo book ( the book stored on file on PRICED )
      ** If CAC005 is off, this is the book the user entered on the screen (file format)
     C                   PARM                    PBOK
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
 
      ** Outputs
      ** Deal in screen format
     C                   PARM                    CurTrPRCS
     C                   PARM                    HPPRC
 
      ** Switchable feature CSD010 parameters
     C                   PARM                    HBDPR
     C                   PARM                    HOFPR
     C                   PARM                    HCLPR
     C                   PARM                    CSD010
 
     C                   EVAL      DDCURP = @DDCURP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMVVL - MOVE DATABASE FIELDS TO VALID FILE                  *
      *                                                               *
      *****************************************************************
     C     SRMVVL        BEGSR
 
     C                   MOVE      RECI          V_PRRECI
     C                   MOVEL(P)  PSSN          V_PRPSSN
     C                   MOVEL(P)  PPRT          V_PRPPRT
     C                   Z-ADD     PVDT          V_PRPVDT
     C**********         Z-ADD     PCNM          V_PRPCNM                                     CSD027
     C                   EVAL      V_PRPCNM = PCNM                                            CSD027
     C                   MOVEL     PMKT          V_PRPMKT
     C                   MOVEL     PBRA          V_PRPBRA
     C                   MOVEL     PBOK          V_PRPBOK
     C                   Z-ADD     PPRC          V_PRPPRC
     C                   MOVEL     PNTV          V_PRPNTV
     C                   Z-ADD     LCD           V_PRLCD
     C                   MOVE      CHTP          V_PRCHTP
     C                   Z-ADD     TNLU          V_PRTNLU
     C                   MOVE      PSRC          V_PRPSRC
     C                   MOVE      PBWN          V_PRPBWN
     C                   MOVE      PPWN          V_PRPPWN
     C                   MOVEL     PTFR          V_PRPTFR
     C                   Z-ADD     NPXR          V_PRNPXR
     C                   MOVE      NPMD          V_PRNPMD
     C                   MOVE      PRTMST        V_PRTMESTMP
     C                   Z-ADD     PRDFTS        V_PRDFTS
     C                   MOVEL     PRFRNT        V_PRFRNT
     C                   MOVEL     PRAFRT        V_PRAFRT
     C                   MOVEL     PRREPA        V_PRREPA
     C                   MOVEL     PRDTFR        V_PRDTFR
     C                   MOVEL     PRTLEX        V_PRTLEX
     C                   MOVEL     PRFC          V_PRPRFC
     C                   MOVEL     PBCD          V_PRPBCD
     C                   MOVEL(P)  PSSN          EXVSESN
     C                   MOVEL     'D'           EXVRECI
 
      ** If Hedge Accounting Phase B is installed. move Credit Risk
      ** Spread and Liquidity Premium fields to Price Valid File.
 
     C                   IF        CAS006 = 'Y' AND (PPRT = 'V'
     C                             OR PPRT = 'DT' OR PPRT = 'DV')
     C                   EVAL      V_PRCRSK = PRCRSK
     C                   EVAL      V_PRLQPR = PRLQPR
     C                   ENDIF
 
     C                   IF        CSD010 = 'Y'
     C                   Z-ADD     PRBDPR        V_PRBDPR
     C                   Z-ADD     PROFPR        V_PROFPR
     C                   Z-ADD     PRCLPR        V_PRCLPR
     C                   ENDIF
 
     C     ENWDL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      ** Common header information (DS) from source system
     C                   PARM                    HeadIn
      ** Transaction information in a single large field from source system
     C                   PARM                    Trans500
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
     C                   PARM                    @TimeStamp       26                         BUG4258
     C                   PARM                    AAuth             1                        BUG22153
 
      ** Key list for SEVPRCSL1
 
     C     PRCSK1        KLIST
     C                   KFLD                    V_PRPSSN
     C                   KFLD                    V_PRPPRT
     C                   KFLD                    V_PRPVDT
 
      ** Set up the name of the MSGF from which the message handler will
      **  get the messages
     C                   EVAL      MsgFArray(1) = 'SEUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'MEMSG'
     C/COPY WNCPYSRC,SEH00128
 
      ** Set up the name of the module Id used to make the transaction
      ** number unique.
 
     C                   EVAL      ModuleId = 'SE'
 
      ** Access Bank details via access program
      ** (database error handling done in access program)
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Access API ICD via access program
 
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
 
      ** Access SAR details file to determine if CAP060
      ** is switched on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP060'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CAP060            1
     C                   ELSE
     C                   MOVEL     'N'           CAP060
     C                   END
 
      ** Check if CAC005 is on
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAC005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAC005
     C                   ELSE
     C                   MOVE      'N'           CAC005
     C                   ENDIF
 
      ** Check if 24x7 Midas Availability is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   ENDIF
 
      ** Access switchable features file - Collateralised Lending (CSD010)
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSD010'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C
     C     @RTCD         IFEQ      *BLANKS
     C                   EVAL      CSD010 = 'Y'
     C                   ELSE
     C                   EVAL      CSD010 = 'N'
     C                   ENDIF
 
      ** Access switchable features file - Hedge Accounting Phase B (CAS006)
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAS006'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   EVAL      CAS006 = 'Y'
     C                   ELSE
     C                   EVAL      CAS006 = 'N'
     C                   ENDIF
 
      ** Access Module Details
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** Database error
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
 
      ** Check if EXTEL indicator is on, BVEXOP
 
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
 
      *
      ** Access Switchable Feature File, for CSC022
      *
     C                   Eval      CSC022 = 'N'
     C                   CallB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CSC022'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
      *
     C                   If        @RTCD = *Blanks
     C                   Eval      CSC022 = 'Y'
     C                   Eval      WCommitSkip = 'N'
      *
     C                   In        SCCMTJOB
     C                   If        ComitNum > 0
     C                   MoveA     ComitJob      WCmtJobArr
      *
     C     PSJOBNAME     LOOKUP    WCmtJobArr                             87
     C                   If        *IN87 = *ON
     C                   Eval      WCommitSkip = 'Y'
     C                   EndIf
     C                   EndIf
      *
     C                   Else
      *
      ** If return code <> *NRF, call program exception error routine
      *
     C                   If        @RTCD <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSC022'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 5
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   Endif
     C                   Endif
                                                                                              CGL031
      ** Check if CGL031 is enabled.                                                          CGL031
                                                                                              CGL031
     C                   CALLB     'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtCd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSARD                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
                                                                                              CGL031
     C                   EVAL      CGL031 = 'N'                                               CGL031
                                                                                              CGL031
     C                   IF        PRtCd = *BLANKS                                            CGL031
     C                   EVAL      CGL031 = 'Y'                                               CGL031
     C                   ELSE                                                                 CGL031
                                                                                              CGL031
     C                   IF        PRtCd <> '*NRF   '                                         CGL031
     C     *LOCK         IN        LDA                                                        CGL031
     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL031
     C                   EVAL      DBKey = PSARD                                              CGL031
     C                   EVAL      DBase = 101                                                CGL031
     C                   OUT       LDA                                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * The following /COPY contains the standard program status
      * subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   EVAL      APIRETC = '0'
     C                   RETURN
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
