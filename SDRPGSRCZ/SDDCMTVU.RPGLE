     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Document Management Interface Controller')    *
      *****************************************************************
      *                                                               *
      *  Midas - Module name ILE Module                               *
      *                                                               *
      *  SDDCMTVU - Document Management Validate and Update           *
      *                                                               *
      *  Function: This program validates Document Codes for          *
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
      *            - For D (=DELETE), call a separate function to     *
      *              process the transaction and bypass the rest of   *
      *              the validation.                                  *
      *                                                               *
      *            For all action codes, the decision to as to        *
      *            whether to write to the valid or invalid file and  *
      *            the call to the message handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CSD093  *CREATE    Date 01Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD093 - Document Management                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      * Document Codes (Keyed by currency code and Document Code)
     FSDDCMTL1  IF   E           K DISK    RENAME(SDDCMTD0:SDDCMTD1)
     F                                     INFSR(*PSSR)
 
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
 
      * Incoming Document Mgt in screen format
     D DocMgtScnF    E DS                  EXTNAME(SDDCMSPD)
 
      * Valid file layout
     D ValdDocMgt    E DS                  EXTNAME(SDVDCMTPD)
     D                                     PREFIX(V_)
 
      * Current Document Mgt Record in file format
     D DocmFilFmt    E DS                  EXTNAME(SDDCMTPD)
 
      * SD Extra data in file (D/B) format
     D ExtData       E DS                  EXTNAME(SDDCMXPD)
 
      * Current transaction in screen format
     D CurTrDCMT     E DS                  EXTNAME(SDDCMSPD)
     D                                     PREFIX(@)
 
      * Error indicators
     D OKTrDCMT      E DS                  EXTNAME(SDEDCMTPD)
 
      * External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      * External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      * External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
 
      ** External DS for Midas modules
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External DS for Midas modules
     D SDDOCM        E DS                  EXTNAME(SDDOCMPD)
 
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
 
      ** Field (500A) to receive the incoming Document Managemet
     D DocDt500        S            500A
 
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
 
     D WSEQN           S              3S 0
     D WSEQA           S              3A
     D #1TESTN         S              1A
     D PINSEQ          S              3S 0
     D PINTYP          S              1A
     D PINMOD          S              1A
     D PIREFN          S             10A
 
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
 
      * Incoming Document Management is in a 500A field.
      * This module needs to break the 500A field by loading it into
      * the appropriate (externally described) data structure.
 
      * Copy the header into the screen format
     C                   Eval      DocMgtScnF = DocDt500
     C                   MOVEL     Extdata500    Extdata
     C                   EVALR     WSEQA = %TRIM(DDSEQN)
     C                   MOVE      WSEQA         WSEQN
 
      * Reset variables gradually updated
     C                   EXSR      RESETCYCLE
      *
      *  If valid Doc Code does exist (even after delay), fail this input
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   EndIf
 
      * Reset variables again in case the details have been corrupted
      * by previous chain to valid Doc Mgt file.
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
     C                   EXSR      ValDocmnt
 
      * Processing for amends or changes
     C                   WHEN         DDACTN = 'A'
     C                   EXSR      ValDocmnt
 
      * Processing for deletes
     C                   WHEN         DDACTN = 'D'
     C                   CLEAR                   ValdDocMgt
     C                   MOVEL     DocmFilFmt    ValdDocMgt
     C                   EVAL      V_DVLTYP = DDACTN
     C                   EVAL      V_DVLCDT = RunDayNbr
 
     C                   ENDSL
      *
     C     INVALID       TAG
 
      * Write to database
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      UpdateDB
     C                   ENDIF
 
     C                   SETON                                        LR
 
      ** Populate System Status for display
 
     C                   EVAL      DDSYST = *BLANKS
     C                   IF        BJRDNB > V_DVEXDT
     C                             AND V_DVEXDT > *ZERO
     C                             AND V_DVSTCD <> 'C'
     C                   EVAL      DDSYST = 'EXPIRED'
     C                   ELSE
     C                   IF        BJRDNB > V_DVREQB
     C                             AND V_DVREQB > *ZERO
     C                             AND V_DVSTCD <> 'A'
     C                             AND V_DVSTCD <> 'C'
     C                   EVAL      DDSYST = 'OVERDUE'
     C                   ENDIF
     C                   ENDIF
 
      * Remerge buffer with all relevant data structures
     C                   EVAL                    Buffer = DocMgtScnF
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
     C                   PARM                    DocDt500
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
 
      * Hook to enable non-core Message files to be included
     D/COPY WNCPYSRC,SDDCMTVM01
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
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC022'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database Error
      *
     C                   If        @RTCD <> *BLANKS and
     C                             @RTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = 'CSC022'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        @RTCD = *BLANK
     C                   EVAL      CSC022 = 'Y'
     C                   IN        SCCMTJOB
      *
     C                   IF        Comitnum > 0
     C                   MOVEA     wComitjobs    wComitarr
     C     psJobname     LOOKUP    wComitarr                              10
     C                   IF        *IN10
     C                   EVAL      wSkip = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Key list
 
     C     SDDCMT        KLIST
     C                   KFLD                    DDREFN
     C                   KFLD                    DDRTYP
     C                   KFLD                    DDCODE
     C                   KFLD                    WSEQN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValAction - Routine to validate action code versus the        *
      *              Document details supplied                        *
      *                                                               *
      *****************************************************************
     C     ValAction     BEGSR
      *
      * Validate action code versus transaction IDs supplied
      * This function will set the Midas Document Management
      * The Doc Mgt in file format from the SD database is retrieved
      * as well.
     C                   RESET                   ReturnCode
 
     C                   CALLB     'SDDCMTRTV'
 
      * Inputs
      * Return code
     C                   PARM                    ReturnCode
 
      * Mode = '*FRONT' (Front office transaction interface)
      * Mode = '      ' (Not front office transaction interface)
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    APRESPMODE        1
 
      ** Entry Mode
     C                   PARM                    PINMOD
      * Action code
     C                   PARM                    DDACTN            1
 
      ** Customer and Document Code
     C                   PARM                    DDREFN
     C                   PARM                    DDRTYP
     C                   PARM                    DDCODE
     C                   PARM                    WSEQA
 
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
 
      * Outputs
      * Current Document Mgt in file format
     C                   PARM                    DocmFilFmt
 
      * OK - Action code
     C                   PARM                    DDActnOK
 
      * OK - Document Reference
     C                   PARM                    DDDrefOK
 
      * OK - Document Code
     C                   PARM                    DDCodeOK
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Document Narrative
     C                   PARM                    DDNARR
      *
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValDocmnt   - Routine to validate the Document details        *
      *                                                               *
      *****************************************************************
 
     C     ValDocmnt     BEGSR
 
     C                   CLEAR                   ValdDocMgt
      *
      * Initialise valid file with format output by the RTV API
      * Some fields may be overwritten by the validation.
     C                   MOVEL     DocmFilFmt    ValdDocMgt
      *
     C                   CALLB     'SDDCMTVAL'
 
      * Response mode (1A), from source system common header
     C                   PARM                    APRespMode
 
      * Document information (DS) from source system
     C                   PARM                    DocMgtScnF
 
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKTrDCMT
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Valid document Mgt layout (DS) from/to caller
     C                   PARM                    ValdDocMgt
 
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
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
 
     C                   CLEAR                   CurTrDCMT
 
     C                   MOVE      *ALL'Y'       OKTrDCMT
 
     C                   CLEAR                   ValdDocMgt
 
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
     C                   MOVEL     @TimeStamp    V_DVTMST
     C                   ENDIF
 
      *
      * Update
     C                   CALLB     'SDDCMTUPD'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    ValdDocMgt
 
     C                   MOVEL     V_DVSEQN      DDSEQN
 
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
(c) Misys International Banking Systems Ltd. 2013
