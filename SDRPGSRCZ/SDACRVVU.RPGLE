     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Account Review')                              *
      *****************************************************************
      *                                                               *
      *  Midas - Module name ILE Module                               *
      *                                                               *
      *  SDACRVVU - Account Review Validate and Update                *
      *                                                               *
      *  Function: This program validates account review for          *
      *            input into the Midas database.                     *
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
      *                                                               *
      *            For all action codes, the decision to as to        *
      *            whether to write to the valid or invalid file and  *
      *            the call to the message handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD092  *CREATE    Date 01May14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD092 - Account Review                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
     D                                     PREFIX(@_)
 
      * Incoming Account Review in screen format
     D ActRevScnF    E DS                  EXTNAME(SDACRFPD)
 
      * Valid file layout
     D ValdActRev    E DS                  EXTNAME(SDVACRVPD)
     D                                     PREFIX(V_)
 
      * Current account e record in file format
     D AcrvFilFmt    E DS                  EXTNAME(SDACRVPD)
 
      * SD Extra data in file (D/B) format
     D ExtData       E DS                  EXTNAME(SDACEXPD)
 
      * Current transaction in screen format
     D CurTrACRV     E DS                  EXTNAME(SDACRFPD)
     D                                     PREFIX(@)
 
      * Error indicators
     D OKTrACRV      E DS                  EXTNAME(SDEACRVPD)
 
      * External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      * External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      * External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
 
      ** External DS for Midas modules
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      * First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * First DS for access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)
     D  wComitjobs             4    103
      ** External DS for Commitment Control Data Area
 
     D wComitarr       S             10A   DIM(10)
      ** Commitment Control Array
 
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
 
      ** Field (500A) to receive the incoming base rate
     D AcrDt500        S           1000A
 
      * Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      * Indices for arrays used to set up corresponding
      * sequence numbers for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      * Fields defined for CSD012
     D CSD012          S              1A
 
      **  Data Structure for AOSVALR0 string
     DSVAL1            DS           200
     DSVAL11                   1      1
 
      ** Commitment Control Variables
     D CSC022          S              1A   INZ('N')
     D wSkip           S              1A   INZ('N')
 
     D WDCOMP          S              1A
     D #1TESTN         S              1A
     D PICUST          S              6A
     D PISCDT          S              6A
     D PINSEQ          S              3A
     D PINTYP          S              1A
     D PINMOD          S              1A
     D PIREFN          S             10A
     D DDACTNOK        S              1A
     D DDCUSTOK        S              1A
     D DDSCDAOK        S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      /EJECT
      *****************************************************************
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * Incoming base rate is in a 500A field.
      * This module needs to break the 500A field by loading it into
      * the appropriate (externally described) data structure.
 
      * Copy the header into the screen format
     C                   Eval      ActRevScnF = AcrDt500
     C                   MOVEL     Extdata500    Extdata
      *
      * If private banking is installed, the Java browser will only return
      * the base rate code; we need to get the base rate name separately.
     C*                  If        BGN4ST = 'Y' and
     C*                            DDACTN <> 'I'
     C*    BABSRC        CHAIN     PBTOBSL0
     C*                  Eval      BABSRN = AOBANA
     C*                  EndIf
 
      * Reset variables gradually updated
     C                   EXSR      RESETCYCLE
 
      * Validate action code
     C                   Eval      APRespMode = 'S'
     C                   EXSR      ValAction
      *
      * If error in validation of action code, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      * Processing depends upon action code
     C                   SELECT
 
      * Processing for inserts
     C                   WHEN         DDACTN = 'I'
     C                   EXSR      ValActRev
 
      * Processing for amends or changes
     C                   WHEN         DDACTN = 'A'
     C                   EXSR      ValActRev
 
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
     C                   EVAL                    Buffer = ActRevScnF
     C                                                    + @TimeStamp
     C                                                    + ExtData
 
     C                   RETURN
 
      *****************************************************************
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
     C                   PARM                    AcrDt500
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
     C                   PARM                    @TimeStamp       26
 
      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      *
      * Access bank details via access program
      * (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   Z-ADD     BJRDNB        RunDayNbr         5 0
 
      * Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Access Modules details
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM                    @RTCD
     C                   PARM                    @OPTN
     C     SDMMOD        PARM                    DSFDY
 
      *
      ** Access SAR details file to determine if CSC022 is on.
      *
     C                   CallB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CSC022'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
      *
      ** Database Error
      *
     C                   If        @RTCD <> *BLANKS and
     C                             @RTCD <> '*NRF   '
     C                   Eval      DBFILE = 'SCSARDPD'
     C                   Eval      DBASE = 2
     C                   Eval      DBKEY = 'CSC022'
     C                   ExSr      *PSSR
     C                   EndIf
      *
     C                   If        @RTCD = *BLANK
     C                   Eval      CSC022 = 'Y'
     C                   In        SCCMTJOB
      *
     C                   If        Comitnum > 0
     C                   MoveA     wComitjobs    wComitarr
     C     psJobname     Lookup    wComitarr                              10
     C                   If        *IN10
     C                   Eval      wSkip = 'Y'
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValAction - Routine to validate action code versus the        *
      *             account review details supplied                   *
      *                                                               *
      *****************************************************************
     C     ValAction     BEGSR
      *
     C                   RESET                   ReturnCode
 
     C                   CALLB     'SDACRVRTV'
 
      * Inputs
      * Return code
     C                   PARM                    ReturnCode
 
      * Mode = '*FRONT' (Front office transaction interface)
      * Mode = '      ' (Not front office transaction interface)
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    APRESPMODE        1
 
      * Action code
     C                   PARM                    DDACTN            1
 
      ** Account Review
     C                   PARM      DDCUST        PICUST
     C                   PARM      DDSCDF        PISCDT
     C                   PARM      DDSEQN        PINSEQ
 
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
     C                   PARM                    WDCOMP
 
      * Outputs
     C                   PARM                    AcrvFilFmt
 
      * OK - Action code
     C                   PARM                    DDActnOK
 
      * OK - Customer
     C                   PARM                    DDCustOK
     C                   PARM                    DDSCDAOK
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValDocmnt   - Routine to validate the base rate details       *
      *                                                               *
      *****************************************************************
 
     C     ValActRev     BEGSR
 
     C                   CLEAR                   ValdActRev
      *
      * Initialise valid file with format output by the RTV API
      * Some fields may be overwritten by the validation.
     C                   MOVEL     ACRVFilFmt    ValdActRev
      *
     C                   CALLB     'SDACRV1VL'
 
      * Response mode (1A), from source system common header
     C                   PARM                    APRespMode
 
      * Base rate information (DS) from source system
     C                   PARM                    ActRevScnF
     C                   PARM                    WDCOMP
 
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKTrACRV
 
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
 
     C                   PARM                    ValdActRev
 
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
 
     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx
 
 
     C                   RESET                   FldNoArr
 
     C                   CLEAR                   CurTrACRV
 
     C                   MOVE      *ALL'Y'       OKTrACRV
 
     C                   CLEAR                   ValdActRev
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update database                                    *
      *                                                               *
      *****************************************************************
 
     C     UPDATEDB      BEGSR
 
      * Restore Timestamp from the original record
     C                   IF        DDACTN <> 'I'
     C                             and @TimeStamp <> *BLANKs
     C                   MOVEL     @TimeStamp    V_AVTMST
     C                   ENDIF
 
     C                   EVAL      V_AVLTYP = DDACTN
     C                   EVAL      V_AVCUST = DDCUST
     C                   EVAL      V_AVTMST = *BLANKS
     C                   EVAL      V_AVMAGE = DDMAGE
     C                   EVAL      V_AVCOMM = DDCOM1 + DDCOM2 +
     C                                        DDCOM3 + DDCOM4
      *
      * Update
     C                   CALLB     'SDACRVUPD'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    ValdActRev
 
      *
      * If there were any errors in the update functions, rollback any
      * updates (done in *PSSR) and end this program. Otherwise commit.
     C     ReturnCode    IFNE      *BLANK
     C     ReturnCode    ANDNE     '*RECUPD'
     C                   EXSR      *PSSR
     C                   ELSE
     C                   If        CSC022 = 'N' or
     C                             (wSkip = 'N' and CSC022 = 'Y')
     C                   Commit
     C                   EndIf
     C                   EndIf
      *
      * If update not done due to record being updated by another
      * workstation send message to screen.
 
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'USR0015'     MsgIdArr(1)
 
     C                   EndIf
 
     C                   MOVE      V_AVSEQN      DDSEQN
     C                   MOVE      V_AVMAGE      DDMAGE
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * The following /COPY contains the standard program status
      * subroutine, excluding a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   MOVEL     '0'           APIRetc
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2014
