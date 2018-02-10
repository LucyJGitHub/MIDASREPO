     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NAs sold validate and update')                *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMNASSVU - Negotiable Assets Sold Validate and Update        *
      *                                                               *
      *  Function: This program validates NAs Sold details for input  *
      *            into the Midas database. The action code           *
      *            determines which processes are executed as are     *
      *            follows:                                           *
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
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CLE134             Date 01Aug12               *
      *                 CSF011A            Date 28Nov11               *
      *                 259924A            Date 28May09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 254420             Date 20May08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239400             Date 26Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9711            Date 26Jan06               *
      *                 BUG8119            Date 20Oct05               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 CDL038             Date 10May05               *
      *                 BUG6512            Date 13May05               *
      *                 BUG4808            Date 16Nov04               *
      *                 BUG4728            Date 05Nov04               *
      *                 BUG3992            Date 01Oct04               *
      *                 BUG4482            Date 29Sep04               *
      *                 BUG4146            Date 31Aug04               *
      *                 BUG2588            Date 17May04               *
      *                 CDL018             Date 03Feb04               *
      *                 TCA090             Date 02Apr04               *
      *                 NAD002             Date 26Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 CAP084  *CREATE    Date 25Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  259924A- Amended so that system can get the front office ID  *
      *           from Java.                                          *
      *  254420 - Validate value date against the back value period   *
      *           defined in PF/SDBANKPD                              *
      *  239400 - Add Front Office ID to be used by SOAP Interface    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9711- Changes to MMVNASPPD/MMVNASSPD (re-compile)         *
      *  BUG8119 - Fields returned incorrectly from API if update     *
      *            flag set to 'Y' but data is invalid.               *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG6512 - Retrieve TRAM details                              *
      *  BUG4808 - Unable to authorise transaction because WIP do     *
      *            not have correct Timestamp.                        *
      *  BUG4728 - Serious Midas error with blank timestamp when      *
      *            authorising insert of transaction.                 *
      *  BUG3992- Call new program MMNASSVLP to perform post          *
      *           settlement detail validation. Revalidate dates.     *
      *  BUG4482 - Authorise should call Validate to show all the     *
      *            warning errors.                                    *
      *  BUG4146 - Stopping two users to update the same record at the*
      *            same time.                                         *
      *  BUG2588 - Remove PAY SETTLEMENT tab from NAS input JSP so    *
      *            relevant Pay settlement fields needs to be         *
      *            defaulted to 00.                                   *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TCA090 - Retrieve Pgms should NOT run in front-office mode.  *
      *           (Also call SETUPDEALN at correct time)              *
      *  NAD002 - 10-Digit Account Code Errors                        *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CAP084 - API Wrapper project                                 *
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.                                                           BUG4808
     D @FldNameArr     S             10A   DIM(ArrayMax)                                     BUG4808
                                                                                             BUG4808
      ** Array of error message IDs                                                          BUG4808
     D @MsgIDArr       S                   DIM(ArrayMax)                                     BUG4808
     D                                     LIKE(#MsgID)                                      BUG4808
                                                                                             BUG4808
      ** Array of error message data.                                                        BUG4808
     D @MsgDtaArr      S                   DIM(ArrayMax)                                     BUG4808
     D                                     LIKE(#MsgData)                                    BUG4808
                                                                                             BUG4808
      ** Array of message files to check                                                     BUG4808
     D @MsgFArray      S             10A   DIM(MsgFArrMax)                                   BUG4808
                                                                                             BUG4808
      * Array to hold Commitment Job Names                                                    CSC022
     D CmtJobNArr      S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
      * Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming transaction in screen format
     D TranIn        E DS                  EXTNAME(MMNASSPD)
 
      * Valid file layout
     D ValidDeal     E DS                  EXTNAME(MMVNASSPD)
     D NASSRecIns            328    382                                                       NAD002
     D NASSPayIns            397    941                                                       NAD002
     D*NASSRecIns************314    382                                                       NAD002
     D*NASSPayIns************383    941                                                       NAD002
 
      * Current transaction record in file format
     D DealFilFmt    E DS                  EXTNAME(MMDENSPP)
     D DENSRecIns            328    382                                                       NAD002
     D DENSPayIns            397    941                                                       NAD002
     D*DENSRecIns************314    382                                                       NAD002
     D*DENSPayIns************383    941                                                       NAD002
 
      * Current transaction in screen format
     D DealScnFmt    E DS                  EXTNAME(MMNASSPD)
     D                                     PREFIX(@)
 
      * Pay settlement instructions in screen format
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
 
      * Receive settlement instructions in screen format
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
 
      * FRA/IRS settlement instructions in screen format
     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
 
      * Pay settlement instructions - current
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)
 
      * Receive settlement instructions - current
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)
 
      * FRA/IRS settlement instructions - current
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)
 
      * Pay settlement instructions in file format
     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
     D FLPAY2                 21    565                                                       NAD002
 
      * Receive settlement instructions in file format
     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
     D FLREC2                 21     75                                                       NAD002
 
      * FRA/IRS settlement instructions in file format
     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
 
      * Extra data in file format
     D ExtData       E DS                  EXTNAME(MMNSEXPD)
 
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
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
      ** Commitment Control Data Area                                                         CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  wComitJob              4    103                                                       CSC022
                                                                                              CSC022
     D InfData       E DS                  EXTNAME(MMNAIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
                                                                                              CAP086
      ** DS for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10
     D  PDBRN                 11     13
     D  PDPPT                 14     16
      *
     D MMNASSUPC       DS             1    DTAARA(MMNASSUPC)
 
     D                 DS
     D  @@YEAR                 1      4  0
     D  @@MNTH                 5      6  0
     D  @@DAY                  7      8  0
     D  @@DTIN                 1      8  0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Error message field(s)
     D Msg1            S                   LIKE(#MsgID)
 
      * Index for arrays of error message ids etc in AMEND validation
     D AmIdx           S              3P 0 INZ(0)
 
      * Index for arrays of error message ids etc
     D Idx             S              3P 0 INZ(0)
 
      * Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(0)
 
      * Fields (500A) to receive the incoming transaction
     D Trans500        S            500A
 
      * Field (500A) to receive the incoming Extra Data
     D InfData500      S            500A
 
      * Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      * Indices for arrays used to set up corresponding
      * sequence numbers for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ** Flags to indicate whether transaction fields are valid
      ** These have been declared for all MM0026D2 fields, some may not
      **  actually be needed if the field is not used/not validated
      ** The OKFlagsDS data structure is defined in the following /COPY
     D/COPY MMCPYSRC,MMNASSOK
      **--------------------------------------------------------------------------------------------
 
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
 
      ** Flag to indicate outcome of call to lower level module
     D AmendOK         S              1A   INZ('Y')
 
      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
 
      ** A code to indicate the calling function to the lower level modules
     D NASS            S              4A   INZ('NASS')
 
      ** Payment & Receipt dates, passed to Settlements Validation routine.
      ** spaces in parameter list not used by this function
     D PayDat          S              5P 0 INZ(99999)
     D RecDat          S              5P 0 INZ(99999)
 
      ** Value Date as a Midas Day Number to be placed in either Payment
      **  or Receipt Date
     D ValDateMDN      S              5P 0
 
      ** Blank fields, passed to Settlements Defaulting routine, to fill
      ** spaces in parameter list not used by this function
     D Blank2          S              2A   INZ(*BLANKS)
     D Blank3          S              3A   INZ(*BLANKS)
     D Blank4          S              4A   INZ(*BLANKS)
     D Blank6          S              6A   INZ(*BLANKS)
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
 
      ** Error Flag for call to Standard routines (equates to *IN99)
     D ErrorFlag       S              1A   INZ('N')
 
      * Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** Receive / Pay Settlement Currency, Method & Nostro
     D RecSetCcy       S              3A
     D RecSetMeth      S              2S 0
     D RecNostro       S             18A                                                      CDL038
     D*RecNostro*******S             12A                                                      CDL038
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D PayNostro       S             18A                                                      CDL038
     D*PayNostro*******S             12A                                                      CDL038
 
      ** Midas Day number
     D @@DAYN          S              5P 0
 
      ** Work fields for 24x7 implementation
     D WProcDate       S                   LIKE(BJRDNB)
     D CSC011          S              1A   INZ('N')
 
      ** Formatted date field for use in the parameter list
     D DateOut         S              8S 0
 
      ** Work variables for CSC022                                                            CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D wCommitSkip     S              1A   INZ('N')                                           CSC022
                                                                                              CSC022
      ** Auto Authorisation flag                                                              CAP086
     D CAP086          S              1A   INZ('N')                                           CAP086
                                                                                              CAP086
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans500      TranIn
     C                   MOVEL     InfData500    InfData                                      CAP086
     C                   MOVEL     Extdata500    Extdata
     C                   EVAL      APFOTranID = DDFOID                                       259924A
                                                                                              CAP086
      ** Set Auto Authorise flag for transactions from Interface                              CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      ILAUTH = IF_AUTH                                           CAP086
     C                   ENDIF                                                                CAP086
 
      ** Generate a timestamp for this transaction
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      * Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
 
      * Validate action code
 
     C                   EXSR      ValidateAc
 
      * If error in validation of action code, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
                                                                                             BUG6512
      *                                                                                      BUG6512
      * Retrieve TRAM details                                                                BUG6512
      *                                                                                      BUG6512
     C                   EXSR      ZACFFEERTV                                                BUG6512
      * Processing depends upon action code
     C                   SELECT
 
      * Processing for inserts
     C                   WHEN         DDACTN = 'I'
      *  Processing for Inserts
     C                   EXSR      DftSettmts
     C                   EXSR      ValidateTr
     C                   EXSR      ValidateSt
     C                   EXSR      ValidateLP                                                BUG3992
 
      * Processing for amends or changes
     C                   WHEN         DDACTN = 'A'
      *  Processing for Amends
     C     GHSUBS        IFNE      *BLANK
     C     GHSUBS        SCAN      TranIn                                 99
     C     *IN99         IFEQ      *ON
     C                   EXSR      TDtDtaSubs
     C                   ENDIF
     C                   ENDIF
     C                   EXSR      SetupAmend
     C                   EXSR      ValidateTr
     C                   EXSR      ValidateSt
     C                   EXSR      ValidateLP                                                BUG3992
     C                   EXSR      ValdateAmd
                                                                                             BUG4482
     C                   WHEN      DDACTN = 'X'                                              BUG4482
      *  Processing for Authorises                                                           BUG4482
     C                   EXSR      ValidateTr                                                BUG4482
     C                   EXSR      ValidateSt                                                BUG4482
     C                   EXSR      ValidateLP                                                BUG3992
 
     C                   ENDSL
      *
     C     INVALID       TAG
 
      * Write to database
 
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   IF        DDACTN = 'I'                                               TCA090
     C                   EXSR      SETUPDEALN                                                 TCA090
     C                   ENDIF                                                                TCA090
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
     C                   ENDIF
 
     C                   SETON                                        LR
 
      ** If action is for Update, get the correct record information                         BUG4808
      ** from file                                                                           BUG4808
     C                   IF        UpdateYN = 'Y'                                            BUG4808
     C                             AND Idx = 0                                               BUG8119
     C                   MOVE      ILDN38        DDDLNO_In                                   BUG4808
     C                   CALL      'MMNASSR'                                                 BUG4808
     C                   PARM                    @AuthComp         1                         BUG4808
     C                   PARM                    @FwdBck           1                         BUG4808
     C                   PARM                    DDDLNO_In         6                         BUG4808
     C                   PARM                    Buffer                                      BUG4808
     C                   PARM                    @FldNameArr                                 BUG4808
     C                   PARM                    @MsgIDArr                                   BUG4808
     C                   PARM                    @MsgDtaArr                                  BUG4808
     C                   PARM                    @MsgFArray                                  BUG4808
     C                   PARM                    @APIRetC          1                         BUG4808
     C                   MOVEL     DDACTN        Buffer                                      BUG4808
     C                   ELSE                                                                BUG4808
      * Remerge buffer with all relevant data structures
     C****************** EVAL                    Buffer = TranIn + InRecSttmt                BUG4146
     C                   EVAL                    Buffer = TranIn                             BUG4146
     C                                           + CPST     + DSPCP                          BUG6512
     C                                           + BKST     + DSPBK                          BUG6512
     C                                                    + @TimeStamp                       BUG4146
     C                                           + DDFOID                                     239400
     C                                                    + InRecSttmt                       BUG4146
     C**********                                        + InPaySttmt + ExtData                CAP086
     C                                                    + InPaySttmt + InfData              CAP086
     C                                                    + ExtData                           CAP086
     C                   ENDIF                                                               BUG4808
 
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
      * Transaction information in a single large field from source system
     C                   PARM                    Trans500
      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM                    InfData500                                   CAP086
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
     C                   PARM                    @TimeStamp       26                         BUG4146
     C                   PARM                    DDFOID           20                          239400
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,MMNASSM01
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
      * Access SAR details file to determine if Net Present Value (NPV)
      * Accounting is switched on.
     C                   MOVEL     'N'           CAS001            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAS001'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CAS001
     C                   ENDIF
      *
      * Access SAR details file to determine if CSC011 switchable feature
      * is switched on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD = *Blanks
 
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
 
     C                   IF        @RTCD <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 900
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Retrieve ZMUSER details.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
 
      ** Access SAR details file to determine if Commitment Control                           CSC022
      ** Changes is switched on.                                                              CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      @SARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   If        @RTCD = *BLANKS                                            CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
      ** Check if Current Job exists in the Commitment Job Names                              CSC022
      ** Data Area.                                                                           CSC022
     C                   MoveA     wComitJob     CmtJobNArr                                   CSC022
     C     PSJOBNAME     LookUp    CmtJobNArr                             20                  CSC022
     C                   If        *IN20                                                      CSC022
     C                   Eval      wCommitSkip = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   Else                                                                 CSC022
      ** Database error                                                                       CSC022
     C                   If        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         In        LDA                                                        CSC022
     C                   Eval      DBKey = 'CSC022'                                           CSC022
     C                   Eval      DBPgm = 'MMNASSVU'                                         CSC022
     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
     C                   Eval      DBase = 901                                                CSC022
     C                   Out       LDA                                                        CSC022
     C                   ExSr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   EndIf                                                                CSC022
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
     C                   IF        @RTCD <> *BLANKS AND                                       CAP086
     C                             @RTCD <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBPGM = 'MMNASSVU'                                         CAP086
     C                   EVAL      DBKEY = 'CAP086'                                           CAP086
     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP086
     C                   EVAL      DBASE  = 902                                               CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
      *                                                                                       CAP086
     C                   IF        @RTCD = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
      *                                                                                       CSC022
     C/COPY WNCPYSRC,MMH00053
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
      **Set*retrieve*mode to '*FRONT' (Access using Front Office ID)                          TCA090
      ***if*insert*******                                                                     TCA090
      ***if*not*insert and Midas transaction ID is not present                                TCA090
      **Otherwise********                                                                     TCA090
      ***Set*retrieve*mode to blank  (Access using Midas transaction ID).                     TCA090
      *******************                                                                     TCA090
     C*****DDACTN********IFEQ      'I'                                                        TCA090
     C*******************MOVEL     '*FRONT'      ModeofOp                                     TCA090
      *******************                                                                     TCA090
      ***Also setup deal number as Front Office Transaction ID                                TCA090
      ***(if DDDLNO is blank, autogenerate by calling SETUPDEALN)                             TCA090
      *******************                                                                     TCA090
     C*****DDDLNO********IFEQ      *BLANK                                                     TCA090
     C*******************EXSR      SETUPDEALN                                                 TCA090
     C*******************MOVEL     ILDN38        APFOTranID                                   TCA090
     C*******************ELSE                                                                 TCA090
     C*******************MOVEL     DDDLNO        APFOTranID                                   TCA090
     C*******************ENDIF                                                                TCA090
      *******************                                                                     TCA090
      ***Setup associated deal number as Associated Front Office Tran ID                      TCA090
      *******************                                                                     TCA090
     C*******************MOVEL     DDDADN        APFOAsocID                                   TCA090
      *******************                                                                     TCA090
     C*******************ELSE                                                                 TCA090
     C*****DDDLNO********IFEQ      *BLANK                                                     TCA090
     C*******************MOVEL     '*FRONT'      ModeofOp                                     TCA090
     C*******************ELSE                                                                 TCA090
     C*******************MOVEL     '      '      ModeofOp                                     TCA090
     C*******************ENDIF                                                                TCA090
     C*******************ENDIF                                                                TCA090
      *
      * Validate action code versus transaction IDs supplied
      * The Transaction in file format from the MM database is retrieved
      * as well.
     C                   RESET                   ReturnCode
     C                   CALLB     'MMNASSRTV'
      * INPUTS
      * Return code
     C                   PARM                    ReturnCode       10
      * Mode = '      ' (not front office transaction interface)
     C*******************PARM                    ModeofOp          6                          TCA090
     C                   PARM      '      '      ModeofOp          6                          TCA090
      * Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM      'S'           APRespMode
      * Action Code
     C                   PARM                    DDACTN
      * Front Office Transaction ID
     C                   PARM                    APFOTranID
      * Front Office Associated Transaction Id
     C                   PARM                    APFOAsocID
      * (Midas) Deal Number
     C                   PARM                    DDDLNO
      * (Midas) Associated Deal Number
     C                   PARM                    DDDADN
      * OUTPUTS
      * (Current) deal in file format
     C                   PARM                    DealFilFmt
      * OK - Action code
     C                   PARM                    DDActnOK
      * OK - Deal Number
     C                   PARM                    DDDlnoOK
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Default current system date to Deal Date when displaying
      ** a blank screen for insert.
      *
     C     DDACTN        IFEQ      *BLANK
     C                   EXSR      SetupDDAT
     C                   ENDIF
 
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
 
     C/COPY WNCPYSRC,MMH00054
     C                   CALLB     'ZASETINDFT'
      ** OUTPUT
      ** Calling function type
     C                   PARM                    NASS
      ** Payment currency (or deal cuurency if only one currency on deal)
     C                   PARM                    DDCcy
      ** Receive currency (only if deal has two currencies)
     C                   PARM                    DDCcy
      ** Customer (shortname or number)
     C                   PARM                    DDCsnm
      ** Deal type
     C                   PARM                    DDMTYP
      ** Federal Funds Ind.
     C                   PARM                    DDFedF
      ** ISDA Rules for FRA/IRS deals only
      ** Version of ISDA Rules govern
     C                   PARM                    Blank4
      ** Type of ISDA agreement
     C                   PARM                    Blank6
      ** Date of ISDA Agreement
     C                   PARM                    Blank6
      ** Version of ISDA Agreement
     C                   PARM                    Blank2
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
     C                   PARM                    DBPaySttmt
      ** Defaulted Receipt Settlement Instruction in file format
     C                   PARM                    DBRecSttmt
      ** Defaulted FRA/IRS Settlement Instruction in file format
     C                   PARM                    DBFRASttmt
 
      *  The defaulted instructions are in file format, but the
      *   Settlements validation requires that they are in the input format.
      *  Therefore run them through a conversion module.
     C/COPY WNCPYSRC,MMH00055
 
     C                   CALLB     'ZASETINCVT'
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
 
      ** Defaulted Settlement Instruction in input format
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM      DDCCY         InRCCY                                      CSF011A
     C                   PARM      DDCCY         InPCCY                                      CSF011A
 
     C                   ENDIF
                                                                                             BUG2588
      * If Receive settlement details have been entered, ensure Pay                          BUG2588
      * settlement method is set to '00' as pay side is NOT required                         BUG2588
      * for NAS. A change in JSP will be delivered with this amendment                       BUG2588
      * where Pay Settlement tab will be removed from NAS input screen.                      BUG2588
      * Hence Pay Settlement Method field needs to be set to zero here..                     BUG2588
                                                                                             BUG2588
     C                   IF            (InRecSttmt <> *blank)                                BUG2588
     C                             AND (InPaySttmt = *blank)                                 BUG2588
     C                   EVAL      FLPSTM = *ZERO                                            BUG2588
     C                   EVAL      DDPSTM = '00'                                             BUG2588
     C                   ENDIF                                                               BUG2588
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetupAmend - Set up fields that are needed in the validation  *
      *              of amendments.                                   *
      *                                                               *
      *****************************************************************
     C     SetupAmend    BEGSR
 
      * For amends, put the complete (pre-existing) transaction into the valid
      * file record - fields in this will be updated during processing
 
     C                   MOVE      DealFilFmt    ValidDeal
      *
     C*******************EVAL      DBRecSttmt = DENSRecIns + HMROBR                           NAD002
     C                   EVAL      FLRSTM     = HMRSTM                                        NAD002
     C                   EVAL      FLRONS     = HMRONS                                        NAD002
     C                   EVAL      FLREC2     = DENSRecIns                                    NAD002
     C                   EVAL      FLROBR     = HMROBR                                        NAD002
     C                   EVAL      FLRSCY     = HMSTCY
     C*******************EVAL      DBPaySttmt = DENSPayIns                                    NAD002
     C                   EVAL      FLPSTM     = HMPSTM                                        NAD002
     C                   EVAL      FLPONS     = HMPONS                                        NAD002
     C                   EVAL      FLPAY2     = DENSPayIns                                    NAD002
     C                   EVAL      FLCVMR     = HMCVMR                                        NAD002
 
      *  .... and then convert these to the screen format
     C                   CALLB     'ZASETINCVT'
 
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
 
      ** Current Settlement Instruction in input format
     C                   PARM                    CrPaySttmt
     C                   PARM                    CrRecSttmt
     C                   PARM                    CrFRASttmt
     C                   PARM      HMCCY         InRCCY                                      CSF011A
     C                   PARM      HMCCY         InPCCY                                      CSF011A
 
      *  If no Payment or Receive instructions have been supplied
      *  Default them to those currently on the deal.
 
     C                   IF            (InPaySttmt = *blank)
     C                   EVAL      InPaySttmt = CrPaySttmt
     C                   ENDIF
 
     C                   IF            (InRecSttmt = *blank)
     C                   EVAL      InRecSttmt = CrRecSttmt
     C                   ENDIF
 
      * Do data substitution for Settlement Instructions
 
     C     GHSUBS        IFNE      *BLANK
     C     GHSUBS        SCAN      InPaySttmt                             99
     C  N99GHSUBS        SCAN      InRecSttmt                             99
     C     *IN99         IFEQ      *ON
     C                   EXSR      SDtDtaSubs
     C                   ENDIF
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
 
      * Validate transaction details
 
     C                   CALLB     'MMNASSVAL'
      * Response mode (1A), from source system common header
     C                   PARM      'S'           APRespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
      * Receive Settlement Currency, Method & Nostro and
      * Payment Settlement Currency, Method & Nostro
      * Extra Data
     C                   PARM      *BLANK        RecSetCcy
     C                   PARM      *ZERO         RecSetMeth
     C                   PARM                    RecNostro
     C                   PARM      *BLANK        PaySetCcy
     C                   PARM      *ZERO         PaySetMeth
     C                   PARM                    PayNostro
     C                   PARM                    ExtData
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
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
      * Valid Deals layout (DS) from/to caller
     C                   PARM                    ValidDeal
      *                                                                                       254420
     C     Idx           IFNE      0                                                          254420
     C                   GOTO      INVALID                                                    254420
     C                   END                                                                  254420
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                      BUG3992
      *                                                               *                      BUG3992
      * ValidateLP - Re-Validate dates after the settlement details   *                      BUG3992
      *              have been determined.                            *                      BUG3992
      *                                                               *                      BUG3992
      *****************************************************************                      BUG3992
                                                                                             BUG3992
     C     ValidateLP    BEGSR                                                               BUG3992
                                                                                             BUG3992
      * Initialise parameter fields                                                          BUG3992
     C                   MOVEL     DDRSTM        RecSetMeth                                  BUG3992
     C                   MOVEL     DDPSTM        PaySetMeth                                  BUG3992
     C                   MOVEL     DDRONX        RecNostro                                   BUG3992
     C                   MOVEL     DDPONX        PayNostro                                   BUG3992
                                                                                             BUG3992
      * Validate transaction details                                                         BUG3992
                                                                                             BUG3992
     C                   CALLB     'MMNASSVLP'                                               BUG3992
      * Response mode (1A), from source system common header                                 BUG3992
     C                   PARM      'S'           APRespMode                                  BUG3992
      * Transaction information (DS) from source system                                      BUG3992
     C                   PARM                    TranIn                                      BUG3992
      * Receive Settlement Currency, Method & Nostro and                                     BUG3992
      * Payment Settlement Currency, Method & Nostro                                         BUG3992
      * Extra Data                                                                           BUG3992
     C                   PARM      DDRSCY        RecSetCcy                                   BUG3992
     C                   PARM                    RecSetMeth                                  BUG3992
     C                   PARM                    RecNostro                                   BUG3992
     C                   PARM      DDPSCY        PaySetCcy                                   BUG3992
     C                   PARM                    PaySetMeth                                  BUG3992
     C                   PARM                    PayNostro                                   BUG3992
     C                   PARM                    ExtData                                     BUG3992
      * Field OK flags (DS) from/to caller                                                   BUG3992
     C                   PARM                    OKFlagsDS                                   BUG3992
      * Error fields/message IDs/message data (arrays) from/to caller                        BUG3992
     C                   PARM                    FldNameArr                                  BUG3992
     C                   PARM                    MsgIDArr                                    BUG3992
     C                   PARM                    MsgDtaArr                                   BUG3992
      * Array index (3P0) from/to caller                                                     BUG3992
     C                   PARM                    Idx                                         BUG3992
      * Warning fields/message IDs/message data (arrays) from/to caller                      BUG3992
     C                   PARM                    WFldNamArr                                  BUG3992
     C                   PARM                    WMsgIDArr                                   BUG3992
     C                   PARM                    WMsgDtaArr                                  BUG3992
      * Array index (3P0) from/to caller                                                     BUG3992
     C                   PARM                    WIdx                                        BUG3992
      * Valid Deals layout (DS) from/to caller                                               BUG3992
     C                   PARM                    ValidDeal                                   BUG3992
                                                                                             BUG3992
     C                   ENDSR                                                               BUG3992
                                                                                             BUG3992
      *****************************************************************                      BUG3992
      /EJECT                                                                                 BUG3992
      *****************************************************************
      *                                                               *
      * ValidateSt - Routine to validate the settlement instructions  *
      *                                                               *
      *****************************************************************
     C     ValidateSt    BEGSR
 
      * The called module requires that the customer number/name is valid,
      *  if it is not, exit from this subroutine.
     C                   IF        NOT (DDCsnmOK = 'Y')
     C                   GOTO      ValSetExit
     C                   ENDIF
 
      * The called module uses the value date in Midas Day Number format,
      *  which will not have been returned from the overall validation
      *  routine, so it needs to be converted here.
 
     C                   IF        DDVDatOK <> 'N'
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    DDVDAT
     C                   PARM                    ValDateMDN
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
 
      ** NAs Sold only have receive settlement instructions, so set the
      ** receive date equal to the value date.
     C                   EVAL      RecDat = ValDateMDN
 
     C                   ENDIF
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ZASETINVAL'
      ** Return Code
     C                   PARM                    ReturnCode
      ** Following parameters are output to called module
      ** Calling function type
     C                   PARM                    NASS
      ** Transaction Fields
      ** Payment currency (or deal currency if only one currency on deal)
     C                   PARM                    DDCCY
      ** Receive currency (or deal currency if only one currency on deal)
     C                   PARM                    DDCCY
      ** Customer (shortname or number)
     C                   PARM                    DDCSNM
      ** Deal type
     C                   PARM                    DDMTYP
      ** Federal Funds Ind.
     C                   PARM                    DDFEDF
      ** Booking Branch
     C                   PARM                    ILBRCA
      ** Receipt Date
     C                   PARM                    RecDat
      ** Payment Date
     C                   PARM                    Paydat
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
      * Action Code
     C                   PARM                    DDACTN
 
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
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
      ** Extra Input
      ** Action Code used
     C                   PARM      DDACTN        ##ACTN            1
      ** Validation Iteration
     C                   PARM      '1ST'         ##ValIter         3
 
     C     ValSetExit    TAG
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TDtDtaSubs - Transaction Details Data Substitution            *
      *                                                               *
      *****************************************************************
 
     C     TDtDtaSubs    BEGSR
 
      ** Conversion of file fields to screen format
 
     C                   RESET                   ReturnCode
     C                   CALLB     'MMNASSCVT'
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt
 
      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    DealScnfmt
      * Deal Status
     C                   PARM                    DDSTS
 
      ** DATA SUBSTITUTION
 
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode       10
      * Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      * Incoming Data
     C                   PARM      TranIn        IncDATA        2000
      * Current Data
     C                   PARM      DealScnfmt    CurDATA        2000
 
     C                   MOVEL     IncDATA       TranIn
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SDtDtaSubs - Settlement Details Data Substitution             *
      *                                                               *
      *****************************************************************
 
     C     SDtDtaSubs    BEGSR
 
      ** PAYMENT INSTRUCTIONS
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM      GHSUBS        SubsChar
      * Incoming Data
     C                   PARM      InPaySttmt    IncDATA
      * Current Data
     C                   PARM      CrPaySttmt    CurDATA
 
     C                   MOVEL     IncDATA       InPaySttmt
 
      ** RECEIPT INSTRUCTIONS
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM      GHSUBS        SubsChar
      * Incoming Data
     C                   PARM      InRecSttmt    IncDATA
      * Current Data
     C                   PARM      CrRecSttmt    CurDATA
 
     C                   MOVEL     IncDATA       InRecSttmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdateAmd - Routine to check whether the fields amended      *
      *              are amendable.                                   *
      *                                                               *
      *****************************************************************
 
     C     ValdateAmd    BEGSR
 
      * This subroutine calls a procedure which checks whether it
      * was valid to amend any of the fields which have been
      * changed.  Some are never amendable and some depend upon ICD
      * settings as to whether they are amendable.
 
      * To determine what fields have changed, the current fields
      * on file must be converted to a 'screen' format.
 
      * These fields are then compared with the fields on the input
      * transaction.
 
      * Any errors detected by the called procedure take precedence
      * over any errors found during the validation of the complete
      * transaction.  The errors from the called procedure are kept
      * separately and, if any are found, these errors will REPLACE
      * the normal validation errors.
 
      * Convert file format to screen format
 
     C                   RESET                   ReturnCode
     C                   CALLB     'MMNASSCVT'
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt
 
      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    DealScnfmt
      * Deal Status
     C                   PARM                    DDSTS            24
 
      ** AMEND CHECKING
     C                   RESET                   ReturnCode
     C                   CALLB     'MMNASSAMD'
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * New Deal in Screen Format (Incoming Transaction)
     C                   PARM                    TranIn
      * (Current) Deal in Screen Format
     C                   PARM                    DealScnfmt
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt
 
      * OUTPUTS
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      * Amendments OK
     C                   PARM                    AmendOk
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1                          CDL038
     C*******************PARM      'N'           ResetErrs         1                          CDL038
 
      * If any errors overwrite previous error information
     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   EVAL      Idx = AmIdx
     C                   ENDIF
 
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
     C                   RESET                   AmendOK
     C                   RESET                   OKPayInsDS
     C                   RESET                   OKRecInsDS
     C                   RESET                   OKFRAInsDS
 
     C                   RESET                   PayDat
     C                   RESET                   RecDat
 
     C                   CLEAR                   DealScnFmt
 
     C                   MOVE      *ALL'Y'       OKFlagsDS
 
     C                   CLEAR                   ValidDeal
      ** Numeric fields within 'ValidDeal' have to be reset explicitly as
      **  there are long alpha fileds overlapping these which cause the
      **  CLEAR to put blanks in the numeric fields
     C                   Z-ADD     *ZERO         ILRSTM
     C**********         Z-ADD     *ZERO         ILROBN                                       CSD027
     C**********         Z-ADD     *ZERO         ILROCN                                       CSD027
     C                   EVAL      ILROBN = *BLANKS                                           CSD027
     C                   EVAL      ILROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         ILPSTM
     C**********         Z-ADD     *ZERO         ILPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         ILPOCN                                       CSD027
     C                   EVAL      ILPOBN = *BLANKS                                           CSD027
     C                   EVAL      ILPOCN = *BLANKS                                           CSD027
 
      ** Have to clear the settlement data structure, or the packed numeric
      ** fields are not initialised correctly.
     C                   CLEAR                   DBPaySttmt
     C                   CLEAR                   DBRecSttmt
     C                   CLEAR                   DBFRASttmt
 
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
      ** For Insert, ensure that ILDN38 is updated when there's a
      ** an error or warning encountered from previous cycle.
     C                   IF        DDACTN = 'I'
     C                   MOVE      DDDLNO        ILDN38
 
      * Include header fields that need to be o/p to the valid file
     C                   EVAL      ILFRNT = APFOTranId
     C                   EVAL      ILAFRT = APFOAsocId
     C                   EVAL      ILREPA = APRprLocn
     C                   IF        DDFOID <> *BLANKS                                          239400
     C                   EVAL      ILFRNT = DDFOID                                            239400
     C                   END                                                                  239400
 
     C                   ENDIF
      *
      * For Inserts and Amends, put the Settlement Instructions (input or
      *  defaulted) into the Valid file record.
      * Two DSs (one Pay, one Receive) contain the Settlement Instructions
      *  in contiguous areas, which must be placed into the correct parts
      *  of the Valid file record
     C                   IF        DDACTN = 'I'
     C                             OR (DDACTN = 'A')
     C*******************MOVEL     DBPaySttmt    NASSPayIns                                   NAD002
     C*******************MOVEL     DBRecSttmt    NASSRecIns                                   NAD002
     C                   MOVEL     FLRSTM        ILRSTM                                       NAD002
     C                   MOVEL     FLRONS        ILRONS                                       NAD002
     C                   MOVEL     FLREC2        NASSRecIns                                   NAD002
     C                   MOVE      FLROBR        ILROBR
     C                   MOVE      FLRSCY        ILSTCY
     C                   MOVEL     FLPSTM        ILPSTM                                       NAD002
     C                   MOVEL     FLPONS        ILPONS                                       NAD002
     C                   MOVEL     FLPAY2        NASSPayIns                                   NAD002
     C                   MOVE      FLCVMR        ILCVMR                                       NAD002
     C                   MOVE      FLIC72        ILIC72                                       NAD002
     C                   ENDIF
 
      * For Deletes & Authorises, put the complete (pre-existing) deal
      *  into the Valid file record
     C                   IF           DDACTN = 'D'
     C                             OR DDACTN = 'X'
     C                   MOVE      DealFilFmt    ValidDeal
     C                   ENDIF
      *
      * Set file field(s) that are needed for all action codes
     C                   EVAL      ILLACT = DDACTN
 
     C                   EVAL      TranStatus = 'S'
 
      * Restore Timestamp from the original record                                           BUG4146
     C                   IF        DDACTN <> 'I'                                             BUG4146
     C*****************            AND DDACTN <> 'X'                                 BUG4808 BUG4808
     C                             AND @TimeStamp <> *BLANKS                                 BUG4728
     C                   MOVEL     @TimeStamp    ILTMST                                      BUG4146
     C                   ENDIF                                                               BUG4146
                                                                                              CAP086
      ** Set Auto Authorise flag for transactions from Interface                              CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      ILAUTH = IF_AUTH                                           CAP086
     C                   ENDIF                                                                CAP086
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPDEALN - Set up Deal Number for Inserts                   *
      *                                                               *
      *****************************************************************
 
     C     SETUPDEALN    BEGSR
 
     C                   IF           DDDLNO = *blanks
     C                             OR DDDLNO = *zeros
 
     C                   RESET                   ReturnCode
     C                   CALLB     'CAGETNXTDL'
     C                   PARM                    ReturnCode
     C                   PARM                    Msg1
     C                   PARM                    DDDLNO
     C                   PARM      *ZEROS        ILDN38
 
     C     Msg1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
     C                   EVAL      MsgIDArr(Idx) = Msg1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDDlnoOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      ** If deal number was entered, put it in the file field
     C                   ELSE
     C                   MOVE      DDDLNO        ILDN38
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetupDDAT - Default Midas rundate as Deal Date.               *
      *                                                               *
      *****************************************************************
 
     C     SetupDDAT     BEGSR
 
      *
      ** Convert day number to YYYYMMDD format
      *
     C                   EVAL      @@DAYN = BJRDNB
     C                   CALLB     'ZDATE9'
     C                   PARM                    @@DAYN
     C                   PARM                    DateOut
     C                   PARM                    @@RETC           10
 
      *
      ** ZDATE9 assigns a value of '0' for non-zero/non-negative date
      ** so test it here. Otherwise, value of '1' returns (if so just
      ** default a blank deal date on the screen).
      *
     C                   IF        @@RETC = '0'
     C                   EVAL      @@DTIN = DateOut
     C                   CALLB     'ZA0770'
     C                   PARM                    @@RETC
     C                   PARM                    @@DTIN
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         @@DTOU            6 0
     C                   MOVEL     @@DTOU        DDDLDT
     C                   ELSE
     C                   MOVEL     *BLANK        DDDLDT
     C                   ENDIF
 
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
     C                   CALLB     'MMNASSUPM'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    ValidDeal
 
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'MMNASSUPD'
     C                   PARM                    @RTCD
     C                   PARM                    ValidDeal
     C                   ENDIF
      *
      * If there were any errors in the update functions, rollback any
      * updates (done in *PSSR) and end this program. Otherwise commit.
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc
     C                   If        (CSC022 = 'N')                                             CSC022
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
     C                   If        (CSC022 = 'N')                                             CSC022
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   ENDIF
      *
      * If update not done due to record being updated by another
      * workstation send message to screen.
 
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************                 BUG6512
     C     ZACFFEERTV    BEGSR                                                               BUG6512
                                                                                             BUG6512
     C                   CALLB     'ZACFFEERTV'                                              BUG6512
      *                                                                                      BUG6512
      * INPUTS                                                                               BUG6512
      *                                                                                      BUG6512
      * Return code                                                                          BUG6512
     C                   PARM      *BLANK        RetCodeIn        10                         BUG6512
      *                                                                                      BUG6512
      * Action Code                                                                          BUG6512
     C                   PARM                    DDACTN            1                         BUG6512
      *                                                                                      BUG6512
      * (Midas) Deal Number                                                                  BUG6512
     C                   PARM                    DDDLNO            6                         BUG6512
      *                                                                                      BUG6512
      * Broker                                                                               BUG6512
     C                   PARM                    DDBKCD            4                         BUG6512
      *                                                                                      BUG6512
      * OUTPUTS                                                                              BUG6512
      *                                                                                      BUG6512
      * OK - Action code                                                                     BUG6512
     C                   PARM      'Y'           DDActnOK          1                         BUG6512
      *                                                                                      BUG6512
      * Counterparty Status                                                                  BUG6512
     C                   PARM                    CPST              2                         BUG6512
     C                   PARM                    DSPCP             1                         BUG6512
      *                                                                                      BUG6512
      * Broker Status                                                                        BUG6512
     C                   PARM                    BKST              2                         BUG6512
     C                   PARM                    DSPBK             1                         BUG6512
      *                                                                                      BUG6512
      * Error fields/message IDs/message data (arrays) from/to caller                        BUG6512
     C                   PARM                    FldNameArr                                  BUG6512
     C                   PARM                    MsgIdArr                                    BUG6512
     C                   PARM                    MsgDtaArr                                   BUG6512
      *                                                                                      BUG6512
      * Array index (3P0) from/to caller                                                     BUG6512
     C                   PARM                    Idx                                         BUG6512
                                                                                             BUG6512
      ** Warning error fields/message IDs/message data (arrays) from/to caller               BUG6512
                                                                                             BUG6512
     C                   PARM      *BLANKS       WFldNamArr                                  BUG6512
     C                   PARM      *BLANKS       WMsgIdArr                                   BUG6512
     C                   PARM      *BLANKS       WMsgDtaArr                                  BUG6512
                                                                                             BUG6512
      ** Warning array index (3P0) from/to caller                                            BUG6512
                                                                                             BUG6512
     C                   PARM      *ZEROS        WIdx                                        BUG6512
                                                                                             BUG6512
     C                   ENDSR                                                               BUG6512
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
