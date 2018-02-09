     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Invalid Manual Repayment - Browse')           *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEMAPYRPB - LE Invalid Manual Repayment - Browse             *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One displays a list of invalid manual repayment   *
      *             for selection, the other picks off the selection  *
      *             made.                                             *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 246702             Date 28Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG3114            Date 04Aug04               *
      *                 CSC022             Date 24Feb04               *
      *                 CAP077  *CREATE    Date 17Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246702 - Correct length of InvFDta3 as of fix 209905 found   *
      *           in ZAINVTRENQ                                       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  BUG3114- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  CSC022 - Commitment Control Changes for Midas Plus           *
      *  CAP077 - Lending API enhancements - Manual Repayments        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
     FLEMAPYRDF CF   E             WORKSTN
     F                                     SFILE(LEMAPYS1:@@RRN)
     FLEIMAPYL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEIMAPYD0:LEIMAPYX0)
     FLEIMAPYL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FAPIDSETL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(S_)
     F                                     RENAME(APIDSETD0:APIDSETX0)
     FAPIDSETL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Manual Repayment by front office id
     F                                     Include(CLOANCLF)
     F                                     Prefix(CL_)
      *
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
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
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
      *
     D InvTr         E DS                  EXTNAME(LEIMAPYPD)
     D InvTrSetIn    E DS                  EXTNAME(APIDSETPD)
     D                                     PREFIX(S_)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External DS for Currency details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  First DS for access programs, short data structure
      *
      ***  Successful insert manual repayment
     D                 DS
     D  D#FOTX                 1     70
     D  D#LNRF                48     53
     D  D#VDAT                55     60
     D  D#LSSQ                65     67
      *
     D ErrorText       S             70    DIM(2) CTDATA PERRCD(1)
      ***  Array containing messages
      *
      ** Data structure for data area commitment control                                      CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  ComitJobs              4    103A                                                      CSC022
                                                                                              CSC022
     D JobCmtCtlDS     S             10A   DIM(10)                                            CSC022
      * MIDAS SC Jobs Handling Commitment Control Data Structure                              CSC022
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
      *
     D  ZOUT22         DS            22
     D  ZOUT20                 1     20
      *
      ***  Timestamp selected
     D @TMESTPSEL      S             26Z
      *
      ***  Message type field for chaining to APIDSETPD; defined in terms
      ***  of the file field when the file field was changed.
     D @MSGTYPE        S                   LIKE(DDMSGTYPE)
      *
      ** Define workfields for Commitment Control Changes for Midas Plus                      CSC022
     D CSC022          S              1A                                                      CSC022
     D WSkpCom         S              1A                                                      CSC022
     D WPos            S              2S 0                                                    CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
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
     C                   WRITE     LEMAPYS0
     C                   MOVE      '0'           *IN97
      *
      ***  Write the select screen footer to the screen.
      *
      ***  If previous transaction was not successful due to manual repayment being
      ***  updated by another workstation then display message on screen
      *
     C     @ERRUP        IFEQ      'Y'
     C                   MOVEL     ErrorText(1)  ERRORMSG
     C                   ELSE
     C                   MOVE      *BLANKS       ERRORMSG
     C                   MOVEL     *BLANKS       D#FOTX
     C     @LSSQ         IFNE      *BLANKS
     C                   MOVEL     ErrorText(2)  D#FOTX
     C                   MOVEL     @LNRF         D#LNRF
     C                   MOVEL     @VDAT         D#VDAT
     C                   MOVEL     @LSSQ         D#LSSQ
     C                   MOVEL     *BLANKS       @LNRF
     C                   MOVEL     *BLANKS       @VDAT
     C                   MOVEL     *BLANKS       @LSSQ
     C                   MOVEL     DDFOTX        ERRORMSG
     C                   END
     C                   END
      *
     C                   WRITE     LEMAPYF1
      *
      ***  Set file pointer to start of file
      *
     C     *LOVAL        SETLL     LEIMAPYL0
      *
      ***  Read an invalid manual repayment
      *
     C                   EXSR      RDIMAPY
      *
      ***  If no records exist - set up an error message.
      ***  Display a message 'No invalid transactions present'
      ***  then terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'FXM1007'     @ERRMS
     C                   EXFMT     LEMAPYEND
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
      ***  Write the invalid manual repayment to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   MOVE      DDTMESTMP     D@TMESTMP
     C**********         MOVE      DDLNRF        KeyLNRF           6 0                        CLE148
     C                   MOVE      DDLNRF        KeyLNRF           6                          CLE148
      *
      ***  Access loan details
      *
     C     k@LOAN        CHAIN     CLOAN                              99
     C
      ***  Currency
      *
     C     DDCURR        IFEQ      *BLANKS
     C  N99              MOVEL     CL_CCY        DDCURR                         Loan Currency
     C                   endif
      *
      ***  Amount
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCURR        @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     CL_CPAM       ZFLD15           15 0          Loan Curr. Princ
      *
     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   PARM      'J'           ZECODE            1
     C                   PARM      *BLANKS       ZOUT22           22
     C                   PARM      *BLANKS       ZOUT25           25
      *
     C                   MOVE      Zout20        DDSAMT                         Loan Curr. Principal
      *
     C                   WRITE     LEMAPYS1
      *
      ***  Read an invalid manual repayment
      *
     C                   EXSR      RDIMAPY
     C                   END
      *
      ***  Write the subfile control record to the screen to display
      ***  the subfile.
      *
     C                   WRITE     LEMAPYS0
      *
      ***  Read the subfile control record to determine whether records
      ***  have been selected or whether ROLLUP is required.
      *
     C                   READ      LEMAPYS0                               99
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
     C                   READC     LEMAPYS1                               99
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
     C                   PARM                    @BRCA
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
     C     ZATRNKX0      CHAIN     LEIMAPYX0                          99
     C                   CLEAR                   InvTrSetIn
     C     APDSETKX      CHAIN     APIDSETX0                          99
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
     C                   PARM      'LEIMAPYPD'   InvFile1         10
     C                   PARM      'APIDSETPD'   InvFile2         10
     C                   PARM                    InvFile3         10
      *
      ***  Invalid file data
     C                   PARM      InvTr         InvFDta1       4000
     C                   PARM      InvTrSetIn    InvFDta2       4000
     C**********         PARM                    InvFDta3       4000                          246702
     C                   PARM                    InvFDta3       5000                          246702
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
     C                   PARM      DDVALD        DDFLD3           35
     C                   PARM                    DDNARR4          30
     C                   PARM      DDSEQN        DDFLD4           35
     C                   PARM                    DDNARR5          30
     C                   PARM      DDSAMT        DDFLD5           35
     C                   PARM                    DDNARR6          30
     C                   PARM      DDCURR        DDFLD6           35
     C                   PARM                    DDNARR7          30
     C                   PARM      *BLANKS       DDFLD7           35
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
      ***  If F10, delete invalid manual repayment
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C     ZATRNKD0      CHAIN     LEIMAPYD0                          99
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      'D'           DDACTN
     C                   MOVEL     *BLANKS       EntryData
     C                   MOVEL     *BLANKS       FileName
     C                   CALL      'RPC1600'
     C                   PARM      InvTr         EntryData      3000
     C                   PARM      'LEIMAPYPD'   FileName         10
     C                   ENDIF
      *
     C  N99              DELETE    LEIMAPYD0
     C     APDSETK0      CHAIN     APIDSETD0                          99
     C  N99              DELETE    APIDSETD0
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
     C                   COMMIT
     C                   Endif                                                                CSC022
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDIMAPY - Read an invalid manual repayment
      *****************************************************************
     C     RDIMAPY       BEGSR
      *
      ***  Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      ***  Read the file.
      *
     C                   READ      LEIMAPYL0                              96
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
      ***  Branch code
     C                   PARM                    @BRCA             3
      *
      ***  Error in update of previous manual repayment
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
      ***  Successful Insert manual repayment schedule
     C                   PARM                    @LNRF             6
     C                   PARM                    @VDAT             6
     C                   PARM                    @LSSQ             3
      *                                                                                       CSC022
      ***  Enhancements for CSC022                                                            CSC022
     C                   PARM                    CSC022                                       CSC022
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LEMAPYRPB'   DBPGM
      *
      ***  Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
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
      ** Determine if enhancement CSC022 is switched on                                       CSC022
                                                                                              CSC022
     C                   Eval      WSkpCom = 'N'                                              CSC022
      *                                                                                       CSC022
     C                   If        CSC022 = 'Y'                                               CSC022
      *                                                                                       CSC022
     C                   IN        SCCMTJOB                                                   CSC022
      *                                                                                       CSC022
     C                   If        COMITNUM <> 0                                              CSC022
     C                   MOVEA     Comitjobs     JobCmtctlDS                                  CSC022
     C                   Eval      WPos = %Lookup(PSJOBNAME:JobCmtCtlDS)                      CSC022
     C                   If        WPos > 0                                                   CSC022
     C                   Eval      WSkpCom = 'Y'                                              CSC022
     C                   Endif                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *
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
     C     K@LOAN        KLIST
     C                   KFLD                    KeyLNRF                        Loan ref of LOAM
      *
      ***  Message Type
      *
     C                   MOVEL     'LEMAPY'      @MSGTYPE
      *
      ***  Format text for invalid transaction deletion function
      *
     C                   MOVEL     'APA0010'     MSGDNB                         Loan reference
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNARR1
      *
     C                   MOVEL     'APA0014'     MSGDNB                         Customer number
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNARR2
      *
     C                   MOVEL     'APA0012'     MSGDNB                         Value date
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNARR3
      *
     C                   MOVEL     'APA0013'     MSGDNB                         Sequence
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNARR4
      *
     C                   MOVEL     'APA0018'     MSGDNB                         Principal amount
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNARR5
      *
     C                   MOVEL     'APA0017'     MSGDNB                         Currency code
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNARR6
      *
     C                   MOVEL     *BLANKS       DDNARR7
     C                   MOVEL     *BLANKS       DDNARR8
     C                   MOVEL     *BLANKS       DDNARR9
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
Sequence no. allocated to last repayment input 666666 666666 is 333
