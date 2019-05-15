     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee input Browse')                            *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEFEEMRPB - LE Fee Input Browse                              *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One displays a list of invalid Fee for            *
      *             selection, the other picks off the selection      *
      *             made.                                             *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD041294           Date 19Sep16               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 BUG2571            Date 13May04               *
      *                 CAP078  *CREATE    Date 31Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041294 - Customer extension details is missing in          *
      *             CUSD repair browse                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager (Recompile)                    *
      *  BUG2571 - (CSC022) Commitment Control Changes for MidasPlus  *
      *  CAP078 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Fee input Transaction Details          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FLEFEEMRDF CF   E             WORKSTN
     F                                     SFILE(LEIFEEMS1:@@RRN)
     FLEIFEEML0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEIFEEMD0:LEIFEEMX0)
     FLEIFEEML1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FCLOAN     IF   E           K DISK
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     FFCLTY     IF   E           K DISK
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYZZF)
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
      *  Array for job name                                                                  BUG2571
     D ARRJBNAM        S             10A   DIM(10)                                           BUG2571
     D InvTr         E DS                  EXTNAME(LEIFEEMPD)
      *
      *                                                                                      BUG2571
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                  BUG2571
      ** Midas SC Jobs handling commitment control data area                                 BUG2571
     D  COMITNOM               1      3S 0                                                   BUG2571
     D  COMITJOB               4    103                                                      BUG2571
      *                                                                                      BUG2571
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 BUG2571
      * EXTERNAL DS FOR SAR DETAILS                                                          BUG2571
      *                                                                                      BUG2571
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
      ***  Successful insert Fee
     D                 DS
     D  DDFOTX                 1     54
     D  D@CUST                 9     14
     D  D@FACT                16     18
     D  D@FCNO                20     21
     D  D@LNRF                23     28
     D  D@FSEQ                30     31
      *
     D ErrorText       S             54    DIM(2) CTDATA PERRCD(1)
      ***  Array containing messages
      *
      ** +--------------------------------------+                                            BUG2571
      ** ¦ Use of Indicator                     ¦                                            BUG2571
      ** ¦ ================                     ¦                                            BUG2571
      ** |                                      |                                            BUG2571
      ** | 17      Used by LOOKUP               |                                            BUG2571
      ** +--------------------------------------+                                            BUG2571
                                                                                             BUG2571
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ***  Timestamp selected
     D @TMESTPSEL      S             26Z
      *
     D CSC022          S              1A   INZ('N')                                          BUG2571
      ** Counter variable                                                                    BUG2571
     D WCMT01          S              1A                                                     BUG2571
      ** Commitment Flag                                                                     BUG2571
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
     C                   WRITE     LEIFEEMS0
     C                   MOVE      '0'           *IN97
      *
      ***  Write the select screen footer to the screen.
      *
      ***  If previous transaction was not successful due to Fee being
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
      ***  Extract the Fee key
      *
     C     6             SUBST     @SIDN:1       D@CUST
     C     3             SUBST     @SIDN:7       D@FACT
     C     2             SUBST     @SIDN:10      D@FCNO
     C     6             SUBST     @SIDN:12      D@LNRF
     C     2             SUBST     @SIDN:18      D@FSEQ
     C                   MOVE      *BLANK        @SIDN
     C                   MOVEL     DDFOTX        ERRORMSG
     C                   END
     C                   END
      *
     C                   WRITE     LEIFEEMF1
      *
      ***  Set file pointer to start of file
      *
     C     *LOVAL        SETLL     LEIFEEML0
      *
      ***  Read an invalid Fee
      *
     C                   EXSR      RDIFEE
      *
      ***  If no records exist - set up an error message.
      ***  Display a message 'No invalid transactions present'
      ***  then terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'LER0132'     @ERRMS
     C                   EXFMT     LEIFEEMEND
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
      ***  Write the invalid Fee to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   MOVE      DDTMESTMP     D@TMESTMP
     C                   MOVEL     DDCSSN        DDCNUM
     C                   WRITE     LEIFEEMS1
      *
      ***  Read an invalid Fee
      *
     C                   EXSR      RDIFEE
     C                   END
      *
      ***  Write the subfile control record to the screen to display
      ***  the subfile.
      *
     C                   WRITE     LEIFEEMS0
      *
      ***  Read the subfile control record to determine whether records
      ***  have been selected or whether ROLLUP is required.
      *
     C                   READ      LEIFEEMS0                              99
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
     C                   READC     LEIFEEMS1                              99
      *
      ***  Retrieve Branch code of the transaction
      *
      ** KLIST for file CLOAN
     C     KEY001        KLIST
     C                   KFLD                    WLOAN
     C                   KFLD                    WCLRT
 
      ** KLIST for file FCLTY
     C     KEY002        KLIST
     C                   KFLD                    WCNUM
     C                   KFLD                    WFAC03
     C                   KFLD                    WFAC02
     C                   KFLD                    WRCDT
 
     C                   MOVE      'A'           WRCDT             1
     C                   MOVE      'A'           WCLRT             1
 
     C     DDLNRF        IFNE      *Blanks
     C**********         MOVEL     DDLNRF        WLOAN             6 0                        CLE148
     C                   MOVEL     DDLNRF        WLOAN             6                          CLE148
     C     KEY001        CHAIN     CLOAN
     C                   ELSE
     C******             MOVE      DDCNUM        WCNUM             6 0                        CSD027
     C                   MOVE      DDCNUM        WCNUM             6                          CSD027
     C                   MOVE      DDFACT        WFAC03            3 0
     C                   MOVE      DDFCNO        WFAC02            2 0
     C     KEY002        CHAIN     FCLTY
     C                   END
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
     C                   PARM                    BRCA
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
     C     ZATRNKX0      CHAIN     LEIFEEMX0                          99
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
     C                   PARM      'LEIFEEMPD'   InvFile1         10
     C                   PARM                    InvFile2         10
     C                   PARM                    InvFile3         10
     C                   PARM      *Blanks       InvFile4         10                        MD041294
      *
      ***  Invalid file data
     C                   PARM      InvTr         InvFDta1       4000
     C                   PARM                    InvFDta2       4000
     C                   PARM                    InvFDta3       4000
     C                   PARM      *Blanks       InvFDta4       4000                        MD041294
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
     C                   PARM      DDLNRF        DDFLD4           35
     C                   PARM                    DDNARR5          30
     C                   PARM      DDFSEQ        DDFLD5           35
     C                   PARM                    DDNARR6          30
     C                   PARM      DDEAMT        DDFLD6           35
     C                   PARM                    DDNARR7          30
     C                   PARM      DDECUR        DDFLD7           35
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
      ***  If F10, delete invalid Fee
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C     ZATRNKD0      CHAIN     LEIFEEMD0                          99
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      'D'           DDACTN
     C                   MOVEL     *BLANKS       EntryData
     C                   MOVEL     *BLANKS       FileName
     C                   CALL      'RPC1600'
     C                   PARM      InvTr         EntryData      3000
     C                   PARM      'LEIFEEMPD'   FileName         10
     C                   ENDIF
      *
     C  N99              DELETE    LEIFEEMD0
     C     CSC022        IFEQ      'N'                                                       BUG2571
     C     WCMT01        OREQ      'N'                                                       BUG2571
     C     CSC022        ANDEQ     'Y'                                                       BUG2571
     C                   COMMIT
     C                   ENDIF                                                               BUG2571
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDIFEE  - Read an invalid Fee
      *****************************************************************
     C     RDIFEE        BEGSR
      *
      ***  Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      ***  Read the file.
      *
     C                   READ      LEIFEEML0                              96
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
      ***  Error in update of previous Fee
     C                   PARM                    @ERRUP            1
      *
      ***  Branch code
     C                   PARM                    @BRCA             3
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
      ***  Successful Insert Fee
      *
     C                   PARM                    @SIDN            19
      *
      ***  Extract the Fee key
      *
     C     6             SUBST     @SIDN:1       D@CUST
     C     3             SUBST     @SIDN:7       D@FACT
     C     2             SUBST     @SIDN:10      D@FCNO
     C     6             SUBST     @SIDN:12      D@LNRF
     C     2             SUBST     @SIDN:18      D@FSEQ
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LEFEEMRPB'   DBPGM
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
     C                   MOVEL     'APA0407'     MSGDNB                         Fee Customer
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
     C                   MOVEL     'APA0010'     MSGDNB                         Loan number
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNARR4
      *
     C                   MOVEL     'APA0408'     MSGDNB                         Fee sequence
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNARR5
      *
     C                   MOVEL     'APA0409'     MSGDNB                         Fee amount
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNARR6
      *
     C                   MOVEL     'APA0410'     MSGDNB                         Fee currency
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNARR7
      *
      * Determine if CSC022 is switched on                                                   BUG2571
                                                                                             BUG2571
     C                   CALLB     'AOSARDR0'                                                BUG2571
     C                   PARM      *BLANKS       @RTCD                                       BUG2571
     C                   PARM      '*VERIFY'     @OPTN                                       BUG2571
     C                   PARM      'CSC022'      @SARD                                       BUG2571
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG2571
     C                   IF        @RTCD = *BLANK                                            BUG2571
     C                   EVAL      CSC022 ='Y'                                               BUG2571
     C                   EVAL      WCMT01 ='N'                                               BUG2571
      * SCCMTJOB data area                                                                   BUG2571
     C                   IN        SCCMTJOB                                                  BUG2571
      * Move data area to commitment array                                                   BUG2571
     C                   IF        COMITNOM > 0                                              BUG2571
     C                   MOVEA     COMITJOB      ARRJBNAM                                    BUG2571
      *                                                                                      BUG2571
      * Check if PSJOBNAME exist.                                                            BUG2571
     C     PSJOBNAME     LOOKUP    ARRJBNAM                               17                 BUG2571
     C                   IF        *IN17 = *ON                                               BUG2571
     C                   EVAL      WCMT01= 'Y'                                               BUG2571
     C                   ENDIF                                                               BUG2571
     C                   ENDIF                                                               BUG2571
      *                                                                                      BUG2571
     C                   ELSE                                                                BUG2571
      * @rtcd not found                                                                      BUG2571
     C                   IF        @RTCD <> '*NRF'                                           BUG2571
     C     *LOCK         IN        LDA                                                       BUG2571
     C                   EVAL      DBPGM = 'LEFEEMRPB'                                       BUG2571
     C                   EVAL      DBKEY = 'CSC022'                                          BUG2571
     C                   EVAL      DBFILE ='SCSARDPD'                                        BUG2571
     C                   EVAL      DBASE  = 002                                              BUG2571
     C                   OUT       LDA                                                       BUG2571
     C                   EXSR      *PSSR                                                     BUG2571
     C                   ENDIF                                                               BUG2571
     C                   ENDIF                                                               BUG2571
                                                                                             BUG2571
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
Fee No. 123456 234 12 123456 12 successfully inserted.
