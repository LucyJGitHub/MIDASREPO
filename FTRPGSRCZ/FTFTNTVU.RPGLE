     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Nostro Transfer Validate and Update')         *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTFTNTVU - Midas FT Nostro Transfer Validate and Update      *
      *                                                               *
      *  Function: This program validates FT Nostro Transfer          *
      *            transactions for input into the Midas database.    *
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
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. CFT163             Date 04May18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CAP212  *CREATE    Date 15Sep14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT163 - FT Nostro Transfer Authorisation (RPG)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP212 - FT Nostro Transfer API                              *
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      * Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)

      * Incoming transaction in screen format
     D TranInNoTr    E DS                  EXTNAME(FTFTNTPD)
     D  CustDtls              98    169

      * Extra Data
     D ExtData       E DS                  EXTNAME(FTFTEXPD)

     D AuthData      E DS                  EXTNAME(FTNAUTPD)                                  CFT163
                                                                                              CFT163
      * Valid file layout
     D ValidNoTr     E DS                  EXTNAME(FTVFTNTPD)
     D  ValidDS1               1     22
     D  ValidDS2              28     46
     D  ValidDS3              75    218
     D  ValidDS4             224    257
     D  ValidDS5             263    281
     D  ValidDS6             295    357
     D  ValidDS7             361    600

      * Current transaction record in file format
     D NoTrFilFmt    E DS                  EXTNAME(NTRANDD)
     D  NtranDS1               1     22
     D  NtranDS2              26     44
     D  NtranDS3              60    203
     D  NtranDS4             207    240
     D  NtranDS5             244    262
     D  NtranDS6             270    332
     D  NtranDS7             335    600

      * Current transaction in screen format
     D CurTrNoTr     E DS                  EXTNAME(FTFTNTPD)
     D                                     PREFIX(@)
      * Copy of transaction in Screen Format
     D CurTrNoTr@    E DS                  EXTNAME(FTFTNTPD)
     D                                     PREFIX(@C)
      * Error indicators
     D OKTrNoTr      E DS                  EXTNAME(FTEFTNTPD)

      * External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      * Data structure for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  SCLCD        E                     EXTFLD(LCD)

      * Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      * Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      * User Details
     D ZMUSER          DS            17
     D  USERID                 1     10

      ** Commitment Control Job Array
     D WJobs           S             10A   DIM(10)

      ** SCCMTJOB DataArea Layout
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)
     D  WDSJobs                4    103A

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      * Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)

      * Index for arrays of error message ids etc
     D Idx             S              3P 0 INZ(0)

      * Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(0)

      * Field (1000A) to receive the incoming transaction
     D Trans1A         S           1000A

      * Field (500A) to receive the incoming extra data
     D ExtData500      S            500A

      * Timestamp for the transaction
     D TimeStamp       S             26A

      ** CSC022 Switchable Feature
     D CSC022          S              1A

      ** CFT163 Switchable Feature                                                            CFT163
     D CFT163          S              1A                                                      CFT163
                                                                                              CFT163
      ** CSC022 work fields
     D WArrPtr         S              3S 0
     D WSkpComtRolbk   S              1A

     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6
     D PCNUM           S             10
     D PKYST           S              7
     D UpdateYN        S              1
     D Buffer          S           6000
     D APIRetc         S              1
     D ModeofOp        S              6

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

     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER

     C                   MOVEL     Trans1A       TranInNoTr
     C                   MOVEL     Extdata500    Extdata

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
     C                   WHEN      NTACTN = 'I'
     C                   EXSR      ValidateTr

      * Processing for amends
     C                   WHEN      NTACTN = 'A'
     C                   EXSR      ConvertTr
     C                   EXSR      ValidateTr

      *  Processing for Deletes
     C                   WHEN      NTACTN = 'D'
     C                   EXSR      ConvertTr

     C                   ENDSL
      *
     C     INVALID       TAG

      ** Populate customer details
     C                   IF        NVINBT = 'C'
      *
     C                   IF        %SUBST(NVINB1:1:1) <> '/'
     C                   MOVEL     NVINB1        PCNUM
     C                   ELSE
     C                   MOVEL     NVINB2        PCNUM
     C                   ENDIF
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCNUM
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      *BLANKS       DSSDY
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      NTIBSN = BBCSSN
     C                   EVAL      NTIBNM = BBCRNM
     C                   EVAL      NTIBTN = BBCRTN
     C                   EVAL      NTIBID = BBCSID
     C                   ENDIF
      *
     C                   ENDIF

      * Write to database
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
     C                   ENDIF

     C                   EVAL      *INLR = *ON

      * Remerge buffer with all relevant data structures
     C                   EVAL                    Buffer = TranInNoTr + ExtData +
     C**********                                          Timestamp                           CFT163
     C                                                    Timestamp +                         CFT163
     C                                                    AuthData                            CFT163
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
     C                   PARM                    Trans1A
     C                   PARM                    ExtData500
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    TimeStamp
     C                   PARM                    AuthData                                     CFT163

      ** Determine if CSC022 is installed
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC022'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   EVAL      CSC022 = 'N'
     C                   EVAL      WSkpComtRolbk = 'N'
      *
     C                   IF        PRTCD = *BLANKS
      *
     C                   MOVE      'Y'           CSC022
     C                   In        SCCMTJOB
     C                   IF        ComitNum > 0
     C                   MOVEA     WDSJobs       WJobs
     C                   EVAL      WArrPtr = %LOOKUP(PSJobName:WJobs)
     C                   IF        WArrPtr > 0
     C                   EVAL      WSkpComtRolbk = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        PRTCD <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBPgm  = 'FTOPAYVU'
     C                   EVAL      DBKey  = 'CSC022'
     C                   EVAL      DBase  = 900
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF

      ** Check if enhancement CFT163 (Full auto authorisation) is on                          CFT163
     C                   CALLB     'AOSARDR0'                                                 CFT163
     C                   PARM      *BLANKS       PRTCD                                        CFT163
     C                   PARM      '*VERIFY'     POPTN                                        CFT163
     C                   PARM      'CFT163'      PSARD                                        CFT163
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT163
                                                                                              CFT163
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CFT163
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT163
     C                   EVAL      DBKEY  = 'CFT163'                                          CFT163
     C                   EVAL      DBASE  = 42                                                CFT163
     C                   EXSR      *PSSR                                                      CFT163
     C                   ENDIF                                                                CFT163
     C                   IF        PRTCD = *BLANKS                                            CFT163
     C                   EVAL      CFT163 = 'Y'                                               CFT163
     C                   ELSE                                                                 CFT163
     C                   EVAL      CFT163 = 'N'                                               CFT163
     C                   ENDIF                                                                CFT163

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

     C                   IF        APFOTRANID <> *BLANKS
     C                   EVAL      ModeOfOp = '*FRONT'
     C                   ELSE
     C                   EVAL      ModeOfOp = *BLANKS
     C                   ENDIF

      * Validate action code versus transaction IDs supplied
      * The Transaction in file format from the database is retrieved
      * as well.

     C                   CALLB     'FTFTNTRTV'

      ** INPUTS
      * Return code
     C                   PARM      *BLANKS       ReturnCode
      *
     C                   PARM                    ModeofOp
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE
      *
      * Action Code
     C                   PARM                    NTACTN
      *
      * Front Office Transaction ID
     C                   PARM                    APFOTranID
      *
      * (Midas) Transfer Reference
     C                   PARM                    NTTFRF
      *
      ** OUTPUTS
      *
      * (Current) Transaction in file format
     C                   PARM                    NoTrFilFmt
      *
      * OK - Action code
     C                   PARM                    OKACTN
      *
      * OK - Transfer Reference
     C                   PARM                    OKTFRF
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
      * ConvertTr - Convert fields from file to screen format         *
      *                                                               *
      *****************************************************************
     C     ConvertTr     BEGSR

     C                   EVAL      ValidDS1 = NtranDS1
     C                   Z-ADD     VDAT          NVVDAT
     C                   EVAL      ValidDS2 = NtranDS2
     C                   Z-ADD     AMNT          NVAMNT
     C                   Z-ADD     AMNTD         NVAMTD
     C                   EVAL      ValidDS3 = NtranDS3
     C                   Z-ADD     LCD           NVLCD
     C                   EVAL      ValidDS4 = NtranDS4
     C                   Z-ADD     OEDT          NVOEDT
     C                   EVAL      ValidDS5 = NtranDS5
     C                   Z-ADD     SBCQ          NVSBCQ
     C                   EVAL      ValidDS6 = NtranDS6
     C                   Z-ADD     SWSN          NVSWSN
     C                   EVAL      ValidDS7 = NtranDS7
     C                   EVAL      NVTMST = TMST

      * Convert file format to screen format

     C                   CALLB     'FTFTNTCVT'

      ** INPUTS
      * Return Code
     C                   PARM      *BLANKS       ReturnCode
      *
      * Transaction Details in File Format
     C                   PARM                    NoTrFilFmt

      ** OUTPUTS
      * Transaction Details in Screen Format
     C                   PARM                    CurTrNoTr

     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR

     C                   CALLB     'FTFTNTVAL'

      ** INPUTS
      * Response mode
     C                   PARM      'S'           APRespMode

      ** Transaction Details
     C                   PARM                    TranInNoTr

      ** Extra Data
     C                   PARM                    ExtData

      ** OUTPUTS
      ** Transaction Details OK inds
     C                   PARM                    OKTrNoTr

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

      * Valid Transaction (DS) from/to caller
     C                   PARM                    ValidNoTr

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

     C                   CLEAR                   CurTrNoTr

     C                   MOVE      *ALL'Y'       OKTrNoTr

     C                   CLEAR                   ValidNoTr

     C                   EVAL      CustDtls = *BLANKS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *              valid file record.                               *
      *                                                               *
      *****************************************************************

     C     SETUPVALID    BEGSR
      *
      * Set file field(s) that are needed for all action codes
     C                   EVAL      NVCHTP = NTACTN
     C                   EVAL      NVRECI = 'D'
     C                   EVAL      NVINU1 = USERID

      * Include header fields that need to be o/p to the valid file
     C                   IF        APFOTranID <> *BLANKS
     C                   EVAL      NVFRNT = APFOTranID
     C                   ENDIF

      * Restore Timestamp from the original record
     C                   IF        NTACTN <> 'I'
     C                             AND TimeStamp <> *BLANKS
     C                   MOVEL     TimeStamp     NVTMST
     C                   ENDIF

      * When CFT163 enhancement is installed                                                  CFT163
     C                   IF        CFT163 = 'Y'                                               CFT163
                                                                                              CFT163
     C     NAUP1         IFNE      *BLANKS                                                    CFT163
     C                   MOVE      NAUP1         NVAUP1                                       CFT163
     C                   MOVE      NAUP2         NVAUP2                                       CFT163
     C                   ELSE                                                                 CFT163
     C                   MOVE      NAUP2         NVAUP1                                       CFT163
     C                   MOVE      *BLANKS       NVAUP2                                       CFT163
     C                   ENDIF                                                                CFT163
                                                                                              CFT163
      * (4-eyes) If NVAUP1 is not blank, change NVAUIN to Y.                                  CFT163
     C     NVAUP1        IFNE      *BLANKS                                                    CFT163
     C                   EVAL      NVAUIN = 'Y'                                               CFT163
     C                   ENDIF                                                                CFT163
                                                                                              CFT163
     C                   ENDIF                                                                CFT163

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
     C                   CALLB     'FTFTNTUPD'

     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    ValidNoTr
      *
      * If there were any errors in the update functions, rollback any
      * updates (done in *PSSR) and end this program. Otherwise commit.
     C     ReturnCode    IFNE      *BLANK
     C     ReturnCode    ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc
     C                   IF        CSC022 = 'N' OR
     C                             (CSC022 = 'Y' AND WSkpComtRolbk = 'N')
     C                   ROLBK
     C                   ENDIF
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        CSC022 = 'N' OR
     C                             (CSC022 = 'Y' AND WSkpComtRolbk = 'N')
     C                   COMMIT
     C                   ENDIF
     C                   IF        NTACTN = 'I'
     C                   EVAL      NTTFRF = NVTFRF
     C                   ENDIF
     C                   ENDIF
      *
      * If update not done due to record being updated by another
      * workstation send message to screen.

     C     ReturnCode    IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * The following /COPY contains the standard program status
      * subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2014
