     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility input browse')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEFCIPRPB - LE Facility Input Browse                         *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One displays a list of invalid facility for       *
      *             selection, the other picks off the selection      *
      *             made.                                             *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE064             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CLE042             Date 06Sep05               *
      *                 CER001             Date 25Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG3723 (CLE028)   Date 19Jul04               *
      *                 CSC022             Date 24Feb04               *
      *                 CLE029             Date 04Sep02               *
      *                 CAP073  *CREATE    Date 21Jun02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  BUG3723 - Recompile due to changes LEIFCIPPD.                *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CLE029 - Addition of Severity code and Limit ID to FCLTYFM   *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *           use as APIs. Facility input Transaction Details     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FLEFCIPRDF CF   E             WORKSTN
     F                                     SFILE(LEIFCIPS1:@@RRN)
     FLEIFCIPL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEIFCIPD0:LEIFCIPX0)
     FLEIFCIPL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FLEIFCLX1L0UF   E           K DISK    INFSR(*PSSR)                                       CER001
     F                                     USROPN                                             CER001
     F                                     COMMIT                                             CER001
      *
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
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D WArrCmtJob      S             10A   DIM(10)                                            CSC022
      ** Array for Commitment Job Names                                                       CSC022
                                                                                              CSC022
      ** Data structure for SCCMTJOB data area                                                CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  COMITNO                1      3S 0                                                    CSC022
     D  COMITJOBS              4    103                                                       CSC022
      ** External DS for API ICD                                                              CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
                                                                                              CSC022
     D InvTr         E DS                  EXTNAME(LEIFCIPPD)
      *                                                                                       CER001
     D InvTrReg      E DS                  EXTNAME(LEFCRXPD)                                  CER001
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
      ***  Successful insert facility
     D                 DS
     D  DDFOTX                 1     50
     D  D@CUST                14     19
     D  D@FACT                21     23
     D  D@FCNO                25     26
      *
     D ErrorText       S             52    DIM(2) CTDATA PERRCD(1)
      ***  Array containing messages
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D PSARD           S              6A                                                      CSC022
     D CSC022          S              1A   Inz                                                CSC022
     D WSkipCommit     S              1A   Inz                                                CSC022
     D WPtr            S              2S 0 Inz                                                CSC022
     D ULX004          S              1A                                                      CER001
      *
      ***  Timestamp selected
     D @TMESTPSEL      S             26Z
      *
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
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
     C                   WRITE     LEIFCIPS0
     C                   MOVE      '0'           *IN97
      *
      ***  Write the select screen footer to the screen.
      *
      ***  If previous transaction was not successful due to facility being
      ***  updated by another workstation then display message on screen
      *
     C     @ERRUP        IFEQ      'Y'
     C                   MOVEL     ErrorText(1)  ERRORMSG
     C                   ELSE
     C                   MOVE      *BLANKS       ERRORMSG
     C                   MOVE      *BLANKS       DDFOTX
     C     @SIDN         IFNE      *BLANK
     C                   MOVEL     ErrorText(2)  DDFOTX
      *
      ***  Extract the facility key
      *
     C     6             SUBST     @SIDN:1       D@CUST
     C     3             SUBST     @SIDN:7       D@FACT
     C     2             SUBST     @SIDN:10      D@FCNO
     C                   MOVE      *BLANK        @SIDN
     C                   MOVEL     DDFOTX        ERRORMSG
     C                   END
     C                   END
      *
     C                   WRITE     LEIFCIPF1
      *
      ***  Set file pointer to start of file
      *
     C     *LOVAL        SETLL     LEIFCIPL0
      *
      ***  Read an invalid facility
      *
     C                   EXSR      RDIFACI
      *
      ***  If no records exist - set up an error message.
      ***  Display a message 'No invalid transactions present'
      ***  then terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'FXM1007'     @ERRMS
     C                   EXFMT     LEIFCIPEND
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
      ***  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ***  Write the invalid Facility to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   MOVE      DDTMESTMP     D@TMESTMP
     C                   MOVEL     DDCSSN        DDCNUM
     C                   WRITE     LEIFCIPS1
      *
      ***  Read an invalid facility
      *
     C                   EXSR      RDIFACI
     C                   END
      *
      ***  Write the subfile control record to the screen to display
      ***  the subfile.
      *
     C                   WRITE     LEIFCIPS0
      *
      ***  Read the subfile control record to determine whether records
      ***  have been selected or whether ROLLUP is required.
      *
     C                   READ      LEIFCIPS0                              99
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
     C                   READC     LEIFCIPS1                              99
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
     C     ZATRNKX0      CHAIN     LEIFCIPX0                          99
      *                                                                                       CER001
     C                   IF        ULX004   = 'Y'                                             CER001
     C     ZATRNKX0      CHAIN     LEIFCLX1L0                         99                      CER001
     C                   EVAL      InvFile2 = 'LEFCRXPD'                                      CER001
     C                   EVAL      LSUBR    = LISUBR                                          CER001
     C                   EVAL      LMOBL    = LIMOBL                                          CER001
     C                   EVAL      LDGRI    = LIDGRI                                          CER001
     C                   EVAL      InvFDta2 = InvTrReg                                        CER001
     C                   ENDIF                                                                CER001
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
     C                   PARM      'LEIFCIPPD'   InvFile1         10
     C                   PARM                    InvFile2         10
     C                   PARM                    InvFile3         10
      *
      ***  Invalid file data
     C                   PARM      InvTr         InvFDta1       4000
     C                   PARM                    InvFDta2       4000
     C                   PARM                    InvFDta3       4000
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
     C                   PARM      DDCSSN        DDFLD1           35
     C                   PARM                    DDNARR2          30
     C                   PARM      DDFACT        DDFLD2           35
     C                   PARM                    DDNARR3          30
     C                   PARM      DDFCNO        DDFLD3           35
     C                   PARM                    DDNARR4          30
     C                   PARM      DDDTAP        DDFLD4           35
     C                   PARM                    DDNARR5          30
     C                   PARM      DDDTEX        DDFLD5           35
     C                   PARM                    DDNARR6          30
     C                   PARM      DDFAMT        DDFLD6           35
     C                   PARM                    DDNARR7          30
     C                   PARM      DDFCCY        DDFLD7           35
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
      ***  If F10, delete invalid facility
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C     ZATRNKD0      CHAIN     LEIFCIPD0                          99
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      'D'           DDACTN
     C                   MOVEL     *BLANKS       EntryData
     C                   MOVEL     *BLANKS       FileName
     C                   CALL      'RPC1600'
     C                   PARM      InvTr         EntryData      3000
     C                   PARM      'LEIFCIPPD'   FileName         10
     C                   ENDIF
      *
     C  N99              DELETE    LEIFCIPD0
      *
     C                   IF        ULX004 = 'Y'                                               CER001
     C     ZATRNKX0      CHAIN     LEIFCLX1L0                                                 CER001
     C                   IF        %FOUND (LEIFCLX1L0)                                        CER001
     C                   DELETE    LEIFCIPXD6                                                 CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      *   COMMIT data if either of the following is true:                                     CSC022
      *     1. Commitment Control Changes switch is OFF; or                                   CSC022
      *     2. Commitment Control Changes switch is ON and                                    CSC022
      *        this particular job is not included in the                                     CSC022
      *        commitment jobs in data area SCCMTJOB                                          CSC022
     C                   If        CSC022  = 'N' or                                           CSC022
     C                             (CSC022 = 'Y' and WSkipCommit = 'N')                       CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDIFACI - Read an invalid facility
      *****************************************************************
     C     RDIFACI       BEGSR
      *
      ***  Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      ***  Read the file.
      *
     C                   READ      LEIFCIPL0                              96
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
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y'                                               CER001
     C                   EVAL      DDUSER = PSUser                                            CER001
     C                   EVAL      DDWID = PSJobName                                          CER001
     C                   ENDIF                                                                CER001
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
      ***  Error in update of previous facility
     C                   PARM                    @ERRUP            1
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
      ***  Successful Insert facility
      *
     C                   PARM                    @SIDN            11
      *
      ** Initialize SAR work flag and Commit flag                                             CSC022
     C                   Eval      CSC022      = 'N'                                          CSC022
     C                   Eval      WSkipCommit = ' '                                          CSC022
      *                                                                                       CSC022
      ** Determine if Commitment Control Changes for MidasPlus                                CSC022
      ** (CSC022) is installed                                                                CSC022
      *                                                                                       CSC022
     C                   Call      'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      PSARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      **                                                                                      CSC022
      *                                                                                       CSC022
      ** If feature is on, set up SAR work flag                                               CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *Blanks                                            CSC022
     C                   Eval      CSC022      = 'Y'                                          CSC022
     C                   Eval      WSkipCommit = 'N'                                          CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        COMITNO  <> 0                                              CSC022
     C                   MoveA     COMITJOBS     WArrCmtJob                                   CSC022
     C                   Eval      WPtr = %LookUp(PSJobName:WArrCmtJob)                       CSC022
     C                   If        WPtr > 0                                                   CSC022
     C                   Eval      WSkipCommit = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   Else                                                                 CSC022
      *                                                                                       CSC022
      ** else, database error (return code other than *NRF)                                   CSC022
      *                                                                                       CSC022
     C                   If        @RTCD <> '*NRF   '                                         CSC022
     C     *Lock         In        LDA                                                        CSC022
     C                   MoveL     'LEFCIPRPB'   DBPGM                                        CSC022
     C                   MoveL     'SCSARDPD'    DBFILE                                       CSC022
     C                   MoveL     'CSC022'      DBKEY                          ************* CSC022
     C                   Z-Add     900           DBASE                          * DBASE 900 * CSC022
     C                   Out       LDA                                          ************* CSC022
     C                   ExSR      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   EndIf                                                                CSC022
      ***  Extract the facility key
      *
     C     6             SUBST     @SIDN:1       D@CUST
     C     3             SUBST     @SIDN:7       D@FACT
     C     2             SUBST     @SIDN:10      D@FCNO
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LEFCIPRPB'   DBPGM
      *
      ***  Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     DDWSID
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
      *                                                                                       CER001
      ** Check for switchable feature                                                         CER001
      *                                                                                       CER001
     C                   EVAL      ULX004 = 'N'                                               CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      PSARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS                                            CER001
     C                   EVAL      ULX004 = 'Y'                                               CER001
     C                   OPEN      LEIFCLX1L0                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS AND                                       CER001
     C                             @RTCD <> '*NRF   '                                         CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBPGM  = 'LEFCIPRPB'                                       CER001
     C                   EVAL      DBKEY  = 'ULX004'                                          CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE  = 901                                               CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *
      ***  Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    DDFOTRANID
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    DDFOTRANID
      *
      ***  Format text for invalid transaction deletion function
      *
     C                   MOVEL     'APA0400'     MSGDNB                         Facility Customer
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNARR1
      *
     C                   MOVEL     'APA0401'     MSGDNB                         Facility Type
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNARR2
      *
     C                   MOVEL     'APA0402'     MSGDNB                         Facility Number
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNARR3
      *
     C                   MOVEL     'APA0403'     MSGDNB                         Facility start date
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNARR4
      *
     C                   MOVEL     'APA0404'     MSGDNB                         Fac. date expires
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNARR5
      *
     C                   MOVEL     'APA0405'     MSGDNB                         Facility amount
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNARR6
      *
     C                   MOVEL     'APA0406'     MSGDNB                         Facility currency
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
(c) Finastra International Limited 2002
**  Array of error messages - ErrorText
The last transaction was not applied to the database
Facility No. 123456 234 12 successfully inserted.
