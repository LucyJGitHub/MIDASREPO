     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans input Browse')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIPRPB - LE Customer Loans Input Browse                   *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One displays a list of invalid loans for          *
      *             selection, the other picks off the selection      *
      *             made.                                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      *  Prev Amend No. CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 246347             Date 12Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CLE042             Date 06Sep05               *
      *                 CER001             Date 25Apr05               *
      *                 CLE031             Date 09Aug04               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG3721 (CLE028)   Date 09Aug04               *
      *                 CSC022             Date 24Feb04               *
      *                 CAP074  *CREATE    Date 11Jun02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246347 - ZAINVTRENQ InvFData3 parm as done by 209905         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CLE031 - Lending Enhancements (Recompile)                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  BUG3721 - Flat Rate Personal Loans (Rule of 78s) (CLE028)    *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** Ê F-specs                              Ê
      ** Ê =======                              Ê
      ** +--------------------------------------+
     FLECLIPRDF CF   E             WORKSTN
     F                                     SFILE(LECLIPS1:@@RRN)
     FLEICLIPL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEICLIPD0:LEICLIPX0)
     FLEICLIPL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FAPIDSETL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(S_)
     F                                     RENAME(APIDSETD0:APIDSETX0)
     FAPIDSETL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FLEICLLX1L0UF   E           K DISK    INFSR(*PSSR)                                       CER001
     F                                     USROPN                                             CER001
     F                                     COMMIT                                             CER001
      *
      *****************************************************************
      ** +--------------------------------------+
      ** Ê Automatically included D-specs       Ê
      ** Ê ==============================       Ê
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
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** Ê End of automatically included D-specsÊ
      ** Ê =====================================Ê
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** Ê Manually included D-specs            Ê
      ** Ê =========================            Ê
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** Ê Named constants                      Ê
      ** Ê ===============                      Ê
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** Ê Arrays and Data Structures           Ê
      ** Ê ==========================           Ê
      ** +--------------------------------------+
      *
      *  Array for job name                                                                   CSC022
     D ARRJBNAM        S             10A   DIM(10)                                            CSC022
     D InvTr         E DS                  EXTNAME(LEICLIPPD)
     D InvTrSetIn    E DS                  EXTNAME(APIDSETPD)
     D                                     PREFIX(S_)
     D InvTrSetEx    E DS                  EXTNAME(LEICLLX1L0)                                CER001
      *                                                                                       CSC022
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
     D  COMITNOM               1      3S 0                                                    CSC022
     D  COMITJOB               4    103                                                       CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
      * EXTERNAL DS FOR SAR DETAILS                                                           CSC022
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
      ***  External DS for loans details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
      ***  Successful insert loan number
     D                 DS
     D  DDFOTX                 1     40
     D  DDSIDN                10     15
      *
     D ErrorText       S             52    DIM(2) CTDATA PERRCD(1)
      ***  Array containing messages
      *
      ** +--------------------------------------+                                             CSC022
      ** Ê Use of Indicator                     Ê                                             CSC022
      ** Ê ================                     Ê                                             CSC022
      ** ¦                                      ¦                                             CSC022
      ** ¦ 17      Used by LOOKUP               ¦                                             CSC022
      ** +--------------------------------------+                                             CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      ** Ê Declared variables                   Ê
      ** Ê ==================                   Ê
      ** +--------------------------------------+
      *
     D CSC022          S              1A   INZ('N')                                           CSC022
      ** Counter variable                                                                     CSC022
     D WCMT01          S              1A                                                      CSC022
      ** Commitment Flag                                                                      CSC022
      *                                                                                       CSC022
      ***  Timestamp selected
     D @TMESTPSEL      S             26Z
                                                                                              CER001
     D ULX004          S              1A                                                      CER001
      *
      ***  Message type field for chaining to APIDSETPD; defined in terms
      ***  of the file field when the file field was changed.
     D @MSGTYPE        S                   LIKE(DDMSGTYPE)
      *
      ** +--------------------------------------+
      ** Ê End of D-specs                       Ê
      ** Ê ==============                       Ê
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** Ê                                                                Ê
      ** Ê Initial processing is performed automatically: the *INZSR is   Ê
      ** Ê executed at program activation.                                Ê
      ** Ê                                                                Ê
      ** +----------------------------------------------------------------+
      *
      ***  Initialisation
      *
     C                   EXSR      INIT
      *
      ***  Build subfile
      *
     C     @BDSFL        IFEQ      'Y'
     C                   EXSR      BLDSFL
     C                   END
      *
      ***  Read subfile record
      *
     C     @RDSFL        IFEQ      'Y'
     C                   EXSR      RDSFLR
     C                   END
      *
      ***  Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDSFL - Build subfile
      *****************************************************************
     C     BLDSFL        BEGSR
      *
      ***  Check for user authority to browse if not multi-branching
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      ***  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      ***  Clear subfile before refilling by writing control record
      ***  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     LECLIPS0
     C                   MOVE      '0'           *IN97
      *
      ***  Write the select screen footer to the screen.
      *
      ***  If previous transaction was not successful due to loan being
      ***  updated by another workstation then display message on screen
      *
     C     @ERRUP        IFEQ      'Y'
     C                   MOVEL     ErrorText(1)  ERRORMSG
     C                   ELSE
     C                   MOVE      *BLANKS       ERRORMSG
     C                   MOVE      *BLANKS       DDFOTX
     C     @SIDN         IFNE      *BLANK
     C                   MOVEL     ErrorText(2)  DDFOTX
     C                   MOVEL     @SIDN         DDSIDN
     C                   MOVE      *BLANK        @SIDN
     C                   MOVEL     DDFOTX        ERRORMSG
     C                   END
     C                   END
      *
     C                   WRITE     LECLIPF1
      *
      ***  Set file pointer to start of file
      *
     C     *LOVAL        SETLL     LEICLIPL0
      *
      ***  Read an invalid loan
      *
     C                   EXSR      RDILOAN
      *
      ***  If no records exist - set up an error message.
      ***  Display a message 'No invalid transactions present'
      ***  then terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'FXM1007'     @ERRMS
     C                   EXFMT     LECLIPEND
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      ***  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      ***  Read records from the file into the subfile until a page has
      ***  been filled or there are no more records.
      ***  Repeat the process until either the end of file, ROLLUP
      ***  has not been entered or F3 or F12 is input.
      *
     C     @@EOF         DOWNE     'Y'
     C     *IN98         ANDEQ     '1'
      *
      ***  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      ***  For each record read, write it to the subfile.
      ***  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     14
      *
     C     @@FND         IFEQ      'Y'
      *
      ***  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ***  Write the invalid loan to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   MOVE      DDTMESTMP     D@TMESTMP
     C                   WRITE     LECLIPS1
      *
     C                   ENDIF
      *
      ***  Read an invalid loan
      *
     C                   EXSR      RDILOAN
     C                   END
      *
     C     @@FND         IFEQ      'N'
     C                   MOVEL     'FXM1007'     @ERRMS
     C                   EXFMT     LECLIPEND
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      ***  Write the subfile control record to the screen to display
      ***  the subfile.
      *
     C                   WRITE     LECLIPS0
      *
      ***  Read the subfile control record to determine whether records
      ***  have been selected or whether ROLLUP is required.
      *
     C                   READ      LECLIPS0                               99
      *
      ***  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      ***  If F12, bypass further processing.
      *
     C     *INKL         IFEQ      '1'
     C                   MOVEL     '1'           @INKL
     C                   RETURN
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * RDSFLR - Read subfile record
      ********************************************************************
     C     RDSFLR        BEGSR
      *
      ***  Read the subfile for selected records
      ***  Only process those for which the option field is blank.
      *
     C     *IN99         DOUEQ     '1'
     C     DDOPT         ORNE      *BLANK
     C                   READC     LECLIPS1                               99
      *
      ***  Validate repair option code
      *
     C     *IN99         IFEQ      '0'
     C                   EXSR      VALID_ROPT
     C                   END
      *
      ***  If 'E' is input, enquire upon invalid transaction
      *
     C     *IN99         IFEQ      '0'
     C     DDOPT         ANDEQ     'E'
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C                   EXSR      ENQ_INV
     C                   MOVEL     *BLANK        DDOPT
     C                   END
      *
      ***  If 'Q' is input, prompt for deletion of invalid transaction
      ***  If 'D' is input, prompt for deletion of invalid transaction
      *
     C     *IN99         IFEQ      '0'
     C     DDOPT         ANDEQ     'Q'
     C                   EXSR      PROM_DELT
     C                   MOVEL     *BLANK        DDOPT
     C                   END
     C                   END
      *
      ***  Return the selected option, action, front office transaction ID
      ***  and front office associated transaction ID
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
      *
     C                   MOVE      DDOPT         @OPSEL
     C                   MOVE      DDACTN        @ACSEL
     C                   MOVE      DDFOTRANID    @FOTRANSEL
     C                   MOVE      D@TMESTMP     @TMESTPSEL
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALID_ROPT - Validate repair option code
      *****************************************************************
     C     VALID_ROPT    BEGSR
      *
     C                   CALLB     'ZAROPTVAL'
      *
      * INPUTS
      *
      ***  Return Code
     C                   PARM      *BLANK        RetCodeOut
      ***  Option code
      ***  Front Office ID
      ***  Booking Branch
     C                   PARM                    DDOPT
     C                   PARM                    DDFOTRANID
     C                   PARM                    DDBRCA
      *
      ***  ICD Single branch code
     C                   PARM                    BJSBRC
      *
      ***  OUTPUTS
      *
      ***  Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
      *
      ***  If F3, bypass further processing.
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      ***  If F12, continue with next option
      *
     C     @INKL         IFEQ      '1'
     C                   MOVEL     *BLANK        DDOPT
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENQ_INV - Enquire on invalid transaction
      *****************************************************************
     C     ENQ_INV       BEGSR
      *
      ***  Pass the invalid transaction details to the enquiry
      *
     C     ZATRNKX0      CHAIN     LEICLIPX0                          99
     C                   CLEAR                   InvTrSetIn
     C     APDSETKX      CHAIN     APIDSETX0                          99
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y'                                               CER001
     C                   CLEAR                   InvTrSetEx                                   CER001
     C     ZATRNKX0      CHAIN     LEICLLX1L0                         99                      CER001
     C                   EVAL      InvFile3 = 'LECLRXPD'                                      CER001
     C                   MOVEL     InvTrSetEx    InvFDta3                                     CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      *
     C                   CALLB     'ZAINVTRENQ'
      *
      ***  INPUTS
      *
      ***  Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Action code
      ***  Front Office ID
      ***  Associated Front Office ID
      ***  Timestamp
     C                   PARM                    DDACTN
     C                   PARM                    DDFOTRANID
     C                   PARM      *BLANKS       DDFOASOCSEL      20
     C                   PARM                    D@TMESTMP
      *
      ***  Invalid file names
     C                   PARM      'LEICLIPPD'   InvFile1         10
     C                   PARM      'APIDSETPD'   InvFile2         10
     C                   PARM                    InvFile3         10
      *
      ***  Invalid file data
     C                   PARM      InvTr         InvFDta1       4000
     C                   PARM      InvTrSetIn    InvFDta2       4000
     C**********         PARM                    InvFDta3       4000                          246347
     C                   PARM                    InvFDta3       5000                          246347
      *
      ***  Outputs
      *
      ***  Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
      *
      ***  If F3, bypass further processing.
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PROM_DELT - Prompt for deletion
      *****************************************************************
     C     PROM_DELT     BEGSR
      *
     C                   CALLB     'ZAINVTRDEL'
      *
      ***  Inputs
      *
      ***  Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Action code
     C                   PARM                    DDACTN
      *
      ***  Front Office Trans ID & Front Office Associated Trans ID
     C                   PARM                    DDFOTRANID
     C                   PARM      *BLANKS       DDFOASOCSEL
      *
      ***  Timestamp
     C                   PARM                    D@TMESTMP
      *
      ***  Narrative & Field Content 1 - 9
     C                   PARM                    DDNARR1          30
     C                   PARM      DDLNRF        DDFLD1           35
     C                   PARM                    DDNARR2          30
     C                   PARM      DDCUST        DDFLD2           35
     C                   PARM                    DDNARR3          30
     C                   PARM      DDVDAT        DDFLD3           35
     C                   PARM                    DDNARR4          30
     C                   PARM      DDMDAT        DDFLD4           35
     C                   PARM                    DDNARR5          30
     C                   PARM      DDCURR        DDFLD5           35
     C                   PARM                    DDNARR6          30
     C                   PARM      DDCPAM        DDFLD6           35
     C                   PARM                    DDNARR7          30
     C                   PARM      DDBRCA        DDFLD7           35
     C                   PARM                    DDNARR8          30
     C                   PARM      *BLANKS       DDFLD8           35
     C                   PARM                    DDNARR9          30
     C                   PARM      *BLANKS       DDFLD9           35
      *
      ***  Outputs
      *
      ***  Function keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
      *
      ***  If F3, bypass further processing.
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      ***  If F10, delete invalid loan
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C     ZATRNKD0      CHAIN     LEICLIPD0                          99
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      'D'           DDACTN
     C                   MOVEL     *BLANKS       EntryData
     C                   MOVEL     *BLANKS       FileName
     C                   CALL      'RPC1600'
     C                   PARM      InvTr         EntryData      3000
     C                   PARM      'LEICLIPPD'   FileName         10
     C                   ENDIF
      *
     C  N99              DELETE    LEICLIPD0
     C     APDSETK0      CHAIN     APIDSETD0                          99
     C  N99              DELETE    APIDSETD0
      *                                                                                       CER001
      ** Delete record in invalid extension file                                              CER001
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y'                                               CER001
     C     ZATRNKX0      CHAIN     LEICLLX1L0                                                 CER001
     C                   IF        %FOUND (LEICLLX1L0)                                        CER001
     C                   DELETE    LEICLIPF6                                                  CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CSC022
      * Commit the databse changes                                                            CSC022
     C     CSC022        IFEQ      'N'                                                        CSC022
     C     WCMT01        OREQ      'N'                                                        CSC022
     C     CSC022        ANDEQ     'Y'                                                        CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDILOAN - Read an invalid loan
      *****************************************************************
     C     RDILOAN       BEGSR
      *
      ***  Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      ***  Read the file.
      *
     C                   READ      LEICLIPL0                              96
      *
     C                   MOVE      DDLTYP        @LNTY             2
     C                   MOVE      DDSUTP        @LNST             2
     C                   MOVE      DDCLAS        @LNCL             4                          CLE042
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @LNTY
     C                   PARM                    @LNST
     C                   PARM                    @LNCL                                        CLE042
     C     SDLOAN        PARM      SDLOAN        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'Y'           LNPT_Invalid      1
     C                   ELSE
     C                   MOVEL     'N'           LNPT_Invalid      1
     C                   END
      *
      * Display Invalid Transactions depending on Processing Type
      *
     C                   MOVE      'N'           @@FND             1
     C                   SELECT
     C     LoanType      WHENEQ    'LOAN'
     C     AYLNPT        IFEQ      61
     C     AYLNPT        OREQ      62
     C     AYLNPT        OREQ      63
     C     AYLNPT        OREQ      70
     C     AYLNPT        OREQ      80                                                        BUG3721
     C     CLE028        ANDEQ     'Y'                                                       BUG3721
     C     LNPT_Invalid  OREQ      'Y'
     C                   MOVE      'Y'           @@FND
     C                   END
      *
     C     LoanType      WHENEQ    'PTPU'
     C     AYLNPT        IFEQ      64
     C     AYLNPT        OREQ      65
     C     AYLNPT        OREQ      68
     C     CLE005        ANDEQ     'Y'
     C     AYLNPT        OREQ      71
     C     CLE005        ANDEQ     'Y'
     C     LNPT_Invalid  OREQ      'Y'
     C                   MOVE      'Y'           @@FND
     C                   END
      *
     C     LoanType      WHENEQ    'PTSO'
     C     AYLNPT        IFEQ      66
     C     AYLNPT        OREQ      67
     C     AYLNPT        OREQ      69
     C     CLE005        ANDEQ     'Y'
     C     AYLNPT        OREQ      72
     C     CLE005        ANDEQ     'Y'
     C     LNPT_Invalid  OREQ      'Y'
     C                   MOVE      'Y'           @@FND
     C                   END
     C                   END
      *
      ***  End of File
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   END
      *
     C     ERDDEL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - Check for user authority if not multi-branching
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      ***  Return error message
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'FXM0292'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVTXT - Retrieve text
      *****************************************************************
     C     RTVTXT        BEGSR
      *
     C                   CALL      'SDRTVTXT'
     C                   PARM                    MSGDNB            7
     C                   PARM      'ZZGBMSGF  '  MSGNM            10
     C                   PARM      *BLANK        MSGTXT           80
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initialization
      *****************************************************************
     C     INIT          BEGSR
      *
      ***  Clear outputs
      *
     C                   MOVE      *BLANK        @ERRMS
     C                   MOVE      *BLANK        @OPSEL
     C                   MOVE      *BLANK        @ACSEL
     C                   MOVE      *BLANK        @FOTRANSEL
     C                   CLEAR                   @TMESTPSEL
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Parameters
      *
     C     *ENTRY        PLIST
      *
      ***  Input parameters
      *
      ***  Return code
     C                   PARM                    RetCodeIn
      *
      ***  Build subfile
     C                   PARM                    @BDSFL            1
      *
      ***  Read subfile record
     C                   PARM                    @RDSFL            1
      *
      ***  Error in update of previous loan
     C                   PARM                    @ERRUP            1
                                                                                             BUG3721
      ** Switchable Features                                                                 BUG3721
     C                   PARM                    CLE028            1                         BUG3721
      *
      ***  Output parameters
      *
      ***  Error message
     C                   PARM                    @ERRMS            7
      *
      ***  Option selected
     C                   PARM                    @OPSEL            1
      *
      ***  Action selected
     C                   PARM                    @ACSEL            1
      *
      ***  FO transaction ID selected
     C                   PARM                    @FOTRANSEL       20
      *
      ***  Timestamp of transaction selected
     C                   PARM                    @TMESTPSEL
      *
      ***  Command keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *
      ***  Successful Insert Loan Number
      *
     C                   PARM                    @SIDN             6
      *
      ***  Calling type
      *
     C                   PARM                    LoanType          4
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LECLIPRPB'   DBPGM
      *
      ***  Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PSUser        DDUSER                                       CER001
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   Z-ADD     1             DBASE                          * DBERR 001 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Determine if Customer Lending Enhancements - Others
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE005            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005
     C                   ENDIF
      *                                                                                       CER001
      ** Check if switch ULX004 is installed                                                  CER001
      *                                                                                       CER001
     C                   MOVE      'N'           ULX004                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      @SARD                                        CER001
                                                                                              CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVE      'Y'           ULX004                                       CER001
     C                   OPEN      LEICLLX1L0                                                 CER001
     C                   ELSE                                                                 CER001
     C     @RTCD         IFEQ      '*NRF'                                                     CER001
     C                   MOVE      'N'           ULX004                                       CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
      ** Database error                                                                       CER001
      *                                                                                       CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   MOVEL     '003'         DBASE                                        CER001
     C                   MOVEL     @OPTN         DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *
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
     C                   EVAL      DBPGM = 'LECLIPRPB'                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE ='SCSARDPD'                                         CSC022
     C                   EVAL      DBASE  = 002                                               CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
      ***  Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    DDFOTRANID
     C                   KFLD                    @TMESTPSEL
     C     APDSETK0      KLIST
     C                   KFLD                    @MSGTYPE
     C                   KFLD                    DDFOTRANID
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    DDFOTRANID
     C     APDSETKX      KLIST
     C                   KFLD                    @MSGTYPE
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    DDFOTRANID
      *
      ***  Message Type
      *
     C                   MOVEL     'LECLIP'      @MSGTYPE
      *
      ***  Format text for invalid transaction deletion function
      *
     C                   MOVEL     'APA0010'     MSGDNB                         Loan reference
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNARR1
      *
     C                   MOVEL     'APA0023'     MSGDNB                         Customer
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNARR2
      *
     C                   MOVEL     'APA0025'     MSGDNB                         Value date
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNARR3
      *
     C                   MOVEL     'APA0026'     MSGDNB                         Maturity date
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNARR4
      *
     C                   MOVEL     'APA0027'     MSGDNB                         Currency
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNARR5
      *
     C                   MOVEL     'APA0028'     MSGDNB                         Amount
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNARR6
      *
     C                   MOVEL     'APA0312'     MSGDNB                         Branch
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNARR7
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
**  Array of error messages - ErrorText
The last transaction was not applied to the database
Loan No. 999999 successfully inserted.
