     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Unauthorised Sweep Accounts')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE000334 - Midas RE Unauthorised Sweep Accounts              *
      *                                                               *
      *  Function:  This program generates a report that will list    *
      *             all the unauthorised Sweep accounts.              *
      *                                                               *
      *  Called By: REC000334 - Midas RE Unauthorised Sweep Accounts  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CRE401  *CREATE    Date 26Nov09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE401 - 4-Eyes Checking Gaps - Sweeps                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SrProcess - Process the records based from parameters passed  *
      *             to the program                                    *
      * SrProcAll - Process all records                               *
      * SrProcEnt - Process a single Entity/Branch                    *
      * SrFormat  - Format and move the details to printer fields     *
      * SrRtvBrch - Retrieve Branch Name                              *
      * SrChkBrch - Check if Branch has changed                       *
      * SrFmtSDate - Format the Start Date based from Date Format     *
      *             Indicator of SDBANKPD                             *
      * SrFmtLCDate - Format the Last Change Date based from Date     *
      *             Format Indicator of SDBANKPD                      *
      * SrEdit    - Edit the Threshold Amount based from the no. of   *
      *             decimal places setup in SDCURRPD                  *
      * SrWP1REC  - Write a detail record to the report               *
      * SrWP1End  - Write End of Report                               *
      * SrRegP1   - Open and register P1 on the first run             *
      * SrRCFP1   - Register the P1 Printer File via RCF              *
      * SrRCFAU   - Register the P1 Printer File via RCF              *
      * SrAudit   - Write to Audit Report RE000334AU                  *
      * *PSSR     - Error processing                                  *
      * *INZSR    - Program initialisation                            *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FRESWEPL9  IF   E           K DISK    INFSR(*PSSR)
      ** Unauthorised Sweep Accounts by Branch, Last User,
      ** and Sweep Reference
 
     FRE000334AUO    E             PRINTER
     F                                     INFDS(SPOOLU)
      ** Unauthorised Sweeps List Audit report
 
     FRE000334P1O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
      ** Unathorised Sweeps List report
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      ** Sweep Type Description
     D/COPY WNCPYSRC,RE0331I003
     D SW1             C                   'MAINTAIN MAXIMUM BALANCE'
     D SW2             C                   'MAINTAIN MINIMUM BALANCE'
     D/COPY WNCPYSRC,RE0331I004
     D SW3             C                   'MAINTAIN SPECIFIED BALANCE'
     D SW4             C                   'SWEEP MAPPING'
     D WACNOF          C                   'DR A/C NOT FOUND'
     D ZACNOF          C                   'CR A/C NOT FOUND'
     D BACNOF          C                   'CR AND DR A/C NOT FOUND'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Short DS for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for Access Objects
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS based on SDBRCHPD
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** File information DS for RE000334P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189I 0
     D  PRTLN1               367    368I 0
 
     ** File information DS for RE000334AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameter List
     D PRTCD           S              1A
     D PSEQ            S              5A
     D PLEV            S              1A
     D PENT            S              3A
 
      ** Parameters for ZSFILE
     D PSENTY          S              3
     D PSFILE          S             10
     D PZSNUM          S              6  0
     D PZSERR          S              1
 
      ** Parameters for ZSEDIT
     D PZFld15         S             15P 0 INZ(*ZEROS)
     D PZDecs          S              1P 0 INZ(*ZERO)
     D PZeCode         S              1A   INZ(*BLANKS)
     D PZOut21         S             21A   INZ(*BLANKS)
 
      ** Parameters for Access Objects
     D PRetCode        S              7A
     D POptn           S              7A
     D PBRCA           S              3A
     D PDateIn         S              5P 0
     D PDate           S              6  0
     D PStDate         S              7A
     D PLCDate         S              7A
     D PCcy            S              3A
 
      ** Work Variables
     D @RUN            S              1    INZ(*BLANK)
     D WPrtcd          S              1A   INZ(*BLANK)
     D WBrch           S              3A   INZ(*BLANKS)
     D WSDate          S              5P 0
     D WLCDate         S              5P 0
     D WLastUsr        S             10A   INZ(*BLANKS)
     D WRCount         S              3S 0
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EXSR      SrProcess
     C                   EXSR      SrWP1End
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialisation subroutine                            *
      *                                                               *
      * Called by: Automatically called                               *
      *                                                               *
      * Calls: AOBANKR0                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Receive parameter list
      *
     C     *ENTRY        PLIST
     C                   PARM      WPrtcd        PRTCD
     C                   PARM                    PSEQ
     C                   PARM                    PLEV
     C                   PARM                    PENT
      *
      ** Read in Installation Data for multibranching indicator
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C                   IF        AGMBIN = 'Y'
     C                   EVAL      *IN37 = *ON
     C                   ELSE
     C                   EVAL      *IN37 = *OFF
     C                   ENDIF
      *
      ** Setup Local Data Area (LDA)
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE    =   *BLANKS
     C                   EVAL      DBKEY     =   *BLANKS
     C                   EVAL      DBPGM     =   'RE000334'
     C                   EVAL      DBASE     =   001
     C                   EVAL      DBMOD     =   *BLANKS
     C                   EVAL      DBPROC    =   *BLANKS
     C                   OUT       LDA
      *
      ** Call Access program for Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetcode
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRetcode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  POptn
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcess - Subroutine to process the records based from      *
      *             parameters passed to the program                  *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrProcess     BEGSR
      *
      ** Process all records
      *
     C                   IF        PENT = *BLANKS OR
     C                             PENT = 'ALL'
     C                   EXSR      SrProcAll
      *
      ** Else, process the selected Entity
      *
     C                   ELSE
     C                   EXSR      SrProcEnt
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcAll - Subroutine to process all the records             *
      *                                                               *
      * Called by: SrProcess                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrProcAll     BEGSR
 
      *
      ** Read all records if Entity parameter (PENT) is blank or equal
      ** to 'ALL'
      *
     C     *LOVAL        SETLL     RESWEPL9
     C                   READ      RESWEPL9
     C                   EVAL      WBrch = BRCA
      *
      ** If EOF, perform Audit reporting (No Records)
      *
     C                   IF        %EOF
     C                   EVAL      WRCount = 0
     C                   EXSR      SrAudit
     C                   ENDIF
      *
     C                   EXSR      SrRegP1
     C                   EVAL      WLastUsr = LUSR
     C                   DOW       NOT %EOF(RESWEPL9)
     C                   EVAL      WPrtcd = 'Y'
     C                   EXSR      SrFormat
     C                   READ      RESWEPL9
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcEnt - Subroutine to process a single Entity/Branch      *
      *                                                               *
      * Called by: SrProcess                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrProcEnt     BEGSR
 
     C     PENT          SETLL     RESWEPL9
     C     PENT          READE     RESWEPL9
      *
      ** If EOF, perform Audit reporting (No Records)
      *
     C                   IF        %EOF
     C                   EVAL      WRCount = 0
     C                   EXSR      SrAudit
     C                   ENDIF
      *
     C                   EXSR      SrRegP1
     C                   EVAL      WLastUsr = LUSR
     C                   DOW       NOT %EOF(RESWEPL9)
     C                   EVAL      WPrtcd = 'Y'
     C                   EXSR      SrFormat
     C     PENT          READE     RESWEPL9
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFormat - Subroutine to format and move the details to       *
      *            printer fields                                     *
      *                                                               *
      * Called by: SrProcAll, SrProcEnt                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrFormat      BEGSR
      *
      ** Check if Branch or Last User has changed
      *
     C                   IF        PENT = *BLANKS OR
     C                             PENT = 'ALL'
     C                   EXSR      SrChkBrch
     C                   ENDIF
      *
      ** Check if Last User has changed for single Entity processing
      ** When Last User has changed, print the new Last User on
      ** a new page
      *
     C                   IF        PENT <> *BLANKS AND
     C                             PENT <> 'ALL'
     C                   IF        WLastUsr <> LUSR
     C                   EVAL      WLastUsr = LUSR
     C                   WRITE     HEADPY
     C                   ENDIF
     C                   ENDIF
      *
      ** Move data to detail fields
      *
     C                   MOVEL     SWEP          RSWEP
     C                   EVAL      RDRBR = DRBR
     C                   MOVEL     DRAN          RCRAO
     C                   EVAL      RCBRC = CBRC
     C                   MOVEL     CRAN          RCRSA
     C                   EVAL      RLUSR = LUSR
      *
      ** Format 'Start Date'
      *
     C                   EVAL      WSDate = NXTP
     C                   EXSR      SrFmtSDate
     C                   EVAL      RSDAT = PStDate
      *
      ** Format 'Last Change Date'
      *
     C                   EVAL      WLCDate = LCD
     C                   EXSR      SrFmtLCDate
     C                   EVAL      RLCD = PLCDate
      *
      ** Format 'Last Change Type'
      *
     C                   SELECT
     C                   WHEN      CHTP = 'I'
     C                   EVAL      RCHTP = 'Insert'
     C                   WHEN      CHTP = 'A'
     C                   EVAL      RCHTP = 'Amend'
     C                   WHEN      CHTP = 'D'
     C                   EVAL      RCHTP = 'Delete'
     C                   ENDSL
      *
      ** Format 'Threshold Amount'
      *
     C                   Z-ADD     STHR          PZFLD15
     C                   EVAL      PZECODE = 'J'
     C                   EXSR      SrEdit
     C                   MOVE      PZOut21       RSTHR
      *
      ** Format Sweep Type
      *
     C                   SELECT
     C                   WHEN      SWTP = '1'
     C                   EVAL      RSWTP = SW1
     C                   WHEN      SWTP = '2'
     C                   EVAL      RSWTP = SW2
     C                   WHEN      SWTP = '3'
     C                   EVAL      RSWTP = SW3
     C                   WHEN      SWTP = '4'
     C                   EVAL      RSWTP = SW4
     C                   ENDSL
      *
      ** Print out a record
      *
     C                   EXSR      SrWP1REC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRtvBrch - Subroutine to retrieve Branch Name                *
      *                                                               *
      * Called by: SrChkBrch                                          *
      *                                                               *
      * Calls: AOBRCHR1                                               *
      *                                                               *
      *****************************************************************
     C     SrRtvBrch     BEGSR
 
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BRCA          PBRCA
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C                   IF        (PRtcd <> *BLANKS)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBASE = 003
     C                   EVAL      DBPGM = PSProcPgm
     C                   EVAL      DBMOD = PSProcMod
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      RDESC = A8BRNM
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrChkBrch - Subroutine to check if Branch has changed         *
      *                                                               *
      * Called by: SrFormat                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrChkBrch     BEGSR
      *
      ** If Transaction Branch has changed, close and reopen P1 to
      ** generate a separate spool file for the new branch
      *
     C                   IF        WBrch <> BRCA
     C                   EXSR      SrWP1End
     C                   IF        NOT %OPEN(RE000334P1)
     C                   OPEN      RE000334P1
     C                   ENDIF
     C                   EVAL      WBrch = BRCA
     C                   EVAL      RBRCA = BRCA
     C                   EXSR      SrRtvBrch
     C                   WRITE     HEADPY
      *
     C                   ELSE
      *
      ** When Last User has changed, print the new Last User on
      ** a new page
      *
     C                   IF        WLastUsr <> LUSR
     C                   EVAL      WLastUsr = LUSR
     C                   WRITE     HEADPY
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFmtSDate - Subroutine to format the Start Date based from   *
      *              Date Format Indicator (BJDFIN) of SDBANKPD       *
      *                                                               *
      * Called by: SrFormat                                           *
      *                                                               *
      * Calls: ZDATE2                                                 *
      *                                                               *
      *****************************************************************
     C     SrFmtSDate    BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM      WSDate        PDateIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PDate
     C                   PARM      *BLANKS       PStDate
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFmtLCDate - Subroutine to format the Last Change Date based *
      *               from Date Format Indicator (BJDFIN) of SDBANKPD *
      *                                                               *
      * Called by: SrFormat                                           *
      *                                                               *
      * Calls: ZDATE2                                                 *
      *                                                               *
      *****************************************************************
     C     SrFmtLCDate   BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM      WLCDate       PDateIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PDate
     C                   PARM      *BLANKS       PLCDate
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrEdit - Subroutine to edit the Threshold Amount based from   *
      *          the no. of decimal places setup in SDCURRPD          *
      *                                                               *
      * Called by: SrFormat                                           *
      *                                                               *
      * Calls: AOCURRR0, ZSEDIT                                       *
      *                                                               *
      *****************************************************************
     C     SrEdit        BEGSR
 
     C                   EVAL      PCcy = CCYC
      *
      ** Call AOCURRR0 to check the no. of decimal places setup
      ** for the currency in SDCURRPD
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRetcode
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     PRetcode      IFNE      *BLANKS
     C                   EVAL      DBFILE =  'SDCURRPD'
     C                   EVAL      DBKEY  =  PCCy
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  004
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-ADD     A6NBDP        PZDecs
      *
      ** Call ZSEDIT to format the amount based from no. of decimal
      ** places
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    PZFld15
     C                   PARM                    PZDecs
     C                   PARM                    PZeCode
     C                   PARM                    PZOut21
 
     C                   EVAL      PZFld15 = *ZEROS
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrWP1REC - Subroutine to Write a Detail record to the report  *
      *                                                               *
      * Called by: SrFormat                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrWP1REC      BEGSR
      *
      ** Check that sufficient lines remain for the Format, if not,
      ** write out the Main Headings on a new page
      *
     C                   IF        OFLLN1 <= PRTLN1 + 4
     C                   WRITE     HEADPY
     C                   ENDIF
      *
      ** Write out Detail Record
      *
     C                   WRITE     DETAIL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrWP1End - Subroutine to write End of Report                  *
      *                                                               *
      * Called by: Main Processing, SrChkBrch                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrWP1End      BEGSR
 
     C                   IF        %OPEN(RE000334P1)
      *
      ** Check that sufficient lines remain for the Format, if not,
      ** write out the Main Headings on a new page
      *
     C                   IF        OFLLN1 <= PRTLN1 + 2
     C                   WRITE     HEADPY
     C                   ENDIF
      *
     C                   WRITE     TRAILPY
     C                   CLOSE     RE000334P1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRegP1 - Subroutine to open and register P1 on the first     *
      *           run                                                 *
      *                                                               *
      * Called by: SrProcAll, SrProcEnt                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrRegP1       BEGSR
      *
      ** Open and register P1 on the first run
      *
     C                   IF        NOT %OPEN(RE000334P1)
     C                   OPEN      RE000334P1
     C                   EXSR      SrRCFP1
     C                   ENDIF
      *
      ** Move details to Header fields
      *
     C                   EVAL      RBRCA = BRCA
     C                   EXSR      SrRtvBrch
      *
      ** Write out Header details
      *
     C                   WRITE     HEADPY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRCFP1 - Register the P1 Printer File via RCF                *
      *                                                               *
      * Called by: SrRegP1                                            *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************
     C     SrRCFP1       BEGSR
 
     C                   Z-ADD     SFNUM1        PZSNUM
 
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQ          PSEQ
     C                   PARM      *BLANKS       PSENTY
     C                   PARM      SFILE1        PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANK        PZSERR
      *
     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRCFAU - Register the AU Printer File via RCF                *
      *                                                               *
      * Called by: SrAudit                                            *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************
     C     SrRCFAU       BEGSR
 
     C                   Z-ADD     SFNUMU        PZSNUM
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PSEQ
     C                   PARM      *BLANKS       PSENTY
     C                   PARM      SFILEU        PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANK        PZSERR
      *
     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAudit - Write to Audit Report RE000334AU                    *
      *                                                               *
      * Called by: SrProcAll, SrProcEnt, *PSSR                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrAudit       BEGSR
      *
     C                   EXSR      SrRCFAU
 
     C                   WRITE     HEADAU
      *
      ** No Details to Report
      *
     C                   IF        WRCount = 0
     C                   WRITE     NODTLS
     C                   ENDIF
      *
      ** Database error
      *
     C                   IF        (*INU7)
     C                   WRITE     DBERROR
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   EXSR      SrAudit
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2009
