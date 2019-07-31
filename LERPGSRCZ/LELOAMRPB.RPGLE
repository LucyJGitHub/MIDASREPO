     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Loan amendments repair browse')
      *****************************************************************
      *                                                               *
      *  Midas - Module name   ILE Module                             *
      *                                                               *
      *  LELOAMRPB - Invalid loan amendments browse                   *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *          One display a list of invalid transactions for       *
      *          selection, the other picks off the selection made.   *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD041294           Date 19Sep16               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 11Jan05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CAP075  *CREATE    Date 05Aug02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041294 - Customer extension details is missing in          *
      *             CUSD repair browse                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager (Recompiled)                   *
      *  CLE031 - Lending Enhancements (Recompile)                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for Midas Plus           *
      *  CAP075 - Lending API enhancements - Loan Amendments          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FLELOAMRDF CF   E             WORKSTN
     F                                     SFILE(LELOAMS1:@@RRN)
     FLEILOAML0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEILOAMD0:LEILOAMX0)
     FLEILOAML1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      * Settlement details
     FAPIDSETL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(S_)
     F                                     RENAME(APIDSETD0:APIDSETX0)
     FAPIDSETL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
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
 
      ** Include the LE standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
     D/COPY WNCPYSRC,LELOAMBD01
 
     D InvLE         E DS                  EXTNAME(LEILOAMPD)
     D InvSetIn      E DS                  EXTNAME(APIDSETPD)
     D                                     PREFIX(S_)
 
      ** External DS for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Timestamp
     D @XTMSTSEL       S             26Z
     D @XREPNSEL       S              5S 0
 
      ** Array containing messages
     D ErrorText       S             52    DIM(2) CTDATA PERRCD(1)
 
      ** Array for amendment type narratives
     D LATP            S             21    DIM(6) CTDATA PERRCD(1)
      *
      ***  Message type field for chaining to APIDSETPD; defined in terms
      ***  of the file field when the file field was changed.
     D @MSGTYPE        S                   LIKE(DDMSGTYPE)
 
      ** Data structure for data area commitment control                                      CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  ComitJobs              4    103A                                                      CSC022
                                                                                              CSC022
     D JobCmtCtlDS     S             10A   DIM(10)                                            CSC022
      * MIDAS SC Jobs Handling Commitment Control Data Structure                              CSC022
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D @STMP           S             26Z
 
      ** Define workfields for Commitment Control Changes for Midas Plus                      CSC022
     D CSC022          S              1A                                                      CSC022
     D WSkpCom         S              1A                                                      CSC022
     D WPos            S              2S 0                                                    CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** ¦ Note that this module uses logic-cycle processing; it will ¦
      ** ¦ repeat the main processing until 'return' is specified.    ¦
      ** ¦ It will also only execute the *INZSR once, on activation,  ¦
      ** ¦ not every time it is called.                               ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      * Initialisation
     C                   EXSR      Reset
      *
      * Build subfile
     C                   IF        @BDSFL = 'Y'
     C                   EXSR      BLDSFL
     C                   ENDIF
      *
      * Read subfile record
     C                   IF        @RDSFL = 'Y'
     C                   EXSR      RDSFLR
     C                   ENDIF
      *
      * Return
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      ********************************************************************
      * Reset - Clear outputs
      ********************************************************************
     C     Reset         BEGSR
      *
      * Clear outputs
     C                   EVAL      @ERRMS = *BLANK
     C                   EVAL      @OPSEL = *BLANK
     C                   EVAL      @ACSEL = *BLANK
     C                   EVAL      @FRNT  = *BLANK
     C                   CLEAR                   @STMP
     C                   EVAL      @INKC = '0'
     C                   EVAL      @INKL = '0'
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL - Build subfile
      ********************************************************************
     C     BLDSFL        BEGSR
      *
      * Check for user authority to browse if not multi-branching
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
      *
      **  Initialise subfile relative record number.
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
     C                   EVAL      *IN97 = *ON
     C                   WRITE     LELOAMS0
     C                   EVAL      *IN97 = *OFF
      *
      **  If previous transaction was not successful due to loan being
      **  updated by another workstation then display message on screen
     C                   CLEAR                   ERRORMSG
     C                   IF        @ERRUP = 'Y'
     C                   EVAL      ERRORMSG = ErrorText(2)
     C                   ENDIF
 
      **  else display success message on screen
     C                   IF        @ERRUP = 'N'
     C                   EVAL      ERRORMSG = ErrorText(1)
     C                   ENDIF
      *
      **  Write the select screen footer to the screen.
     C                   WRITE     LELOAMF1
      *
      **  Set file pointer to start of file
     C     *LOVAL        SETLL     LEILOAML0
      *
      * Read an invalid transaction
     C                   EXSR      RDITRAN
      *
      **  If no records exist - set up an error message.
      **  Display a message 'No invalid transactions present'
      **  then terminate
     C                   IF        @@EOF = 'Y'
      *
      ** Retrieve time
     C                   TIME                    S#TIME
     C                   EVAL      @ERRMS = 'LEV1005'
     C                   EXFMT     LELOAMEND
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      **  Set on ROLLUP indicator to drive initial loop.
     C                   EVAL      *IN98 = *ON
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
     C                   DOW       @@EOF <> 'Y' AND
     C                             *IN98 = *ON
      *
      **  Initialise count of records written to subfile page.
     C                   Z-ADD     0             @@CNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
     C                   DOW       @@EOF <> 'Y' AND
     C                             @@CNT < 14
      *
      **  Increment the subfile record no. and records written fields.
     C                   EVAL      @@RRN = 1 + @@RRN
     C                   EVAL      @@CNT = 1 + @@CNT
      *
      * Loan amendment narrative
     C                   SELECT
     C     DDATYP        WHENEQ    'PI'
     C                   MOVEL     LATP(1)       D@ATXT
     C     DDATYP        WHENEQ    'SC'
     C                   MOVEL     LATP(2)       D@ATXT
     C     DDATYP        WHENEQ    'BC'
     C                   MOVEL     LATP(3)       D@ATXT
     C     DDATYP        WHENEQ    'SA'
     C                   MOVEL     LATP(4)       D@ATXT
     C     DDATYP        WHENEQ    'LS'
     C                   MOVEL     LATP(5)       D@ATXT
     C     DDATYP        WHENEQ    'PD'
     C                   MOVEL     LATP(6)       D@ATXT
     C                   ENDSL
      *
      **  Write the invalid loan amendment to the subfile.
     C                   EVAL      DDOPT = *BLANK
     C                   EVAL      DDSFRN = @@RRN
     C                   MOVE      DDSTMP        D@STMP
     C                   WRITE     LELOAMS1
      *
      * Read an invalid loan amendment
     C                   EXSR      RDITRAN
     C                   ENDDO
      *
      ** Retrieve time
     C                   TIME                    S#TIME
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
     C                   WRITE     LELOAMS0
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
     C                   READ      LELOAMS0                               99
      *
      **  If F3, bypass further processing.
     C                   IF        *INKC = *ON
     C                   EVAL      @INKC = '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      **  If F12, bypass further processing.
     C                   IF        *INKL = *ON
     C                   EVAL      @INKL = '1'
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * RDSFLR - Read subfile record
      ********************************************************************
     C     RDSFLR        BEGSR
      *
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
     C                   DOU       *IN99 = *ON OR
     C                             DDOPT <> *BLANK
     C                   READC     LELOAMS1                               99
      *
      * Validate repair option code
     C                   IF        *IN99 = *OFF
     C                   EXSR      VALID_ROPT
     C                   ENDIF
      *
      ** If 'E' is input, enquire upon invalid transaction
     C                   IF        *IN99 = *OFF AND
     C                             DDOPT = 'E'
     C                   MOVE      D@STMP        @STMP
     C                   EXSR      ENQ_INV
     C                   EVAL      DDOPT = *BLANK
     C                   ENDIF
      *
      ** If 'Q' is input, prompt for deletion of invalid transaction
     C                   IF        *IN99 = *OFF AND
     C                             DDOPT = 'Q'
     C                   EXSR      PROM_DELT
     C                   EVAL      DDOPT = *BLANK
     C                   ENDIF
     C                   ENDDO
      *
      **  Return the selected option, action, front office transaction ID
      **  and front office associated transaction ID
     C                   IF        *IN99 <> *ON AND
     C                             DDOPT <> *BLANK
      *
     C                   EVAL      @OPSEL = DDOPT
     C                   EVAL      @ACSEL = DDACTN
     C                   EVAL      @FRNT  = DDFRNT
     C                   MOVE      D@STMP        @STMP
      *
     C                   ENDIF
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
 
      * Inputs
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      * Option code
      * Front Office ID
      * Booking Branch
     C                   PARM                    DDOPT
     C                   PARM                    DDFRNT
     C                   PARM                    DDBRSN
 
      * ICD Single branch code
     C                   PARM                    BJSBRC
 
      * Outputs
      * Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
      *
      **  If F3, bypass further processing.
     C                   IF        @INKC = '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      **  If F12, continue with next option
     C                   IF        @INKL = '1'
     C                   EVAL      DDOPT = *BLANK
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENQ_INV - Enquire on an invalid transaction
      *****************************************************************
     C     ENQ_INV       BEGSR
 
      * Pass the invalid transaction details to the enquiry
     C     ZATRNKX0      CHAIN     LEILOAMX0                          99
     C                   CLEAR                   InvSetIn
     C     APDSETKX      CHAIN     APIDSETX0                          99
      *
     C                   CALLB     'ZAINVTRENQ'
 
      * Inputs
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      * Action code
      * Front Office ID
      * Associated Front Office ID
      * Timestamp
     C                   PARM                    DDACTN
     C                   PARM                    DDFRNT
     C                   PARM                    DDAFRT
     C                   PARM                    D@STMP
 
      * Invalid file names
     C                   PARM      'LEILOAMPD'   InvFile1         10
     C                   PARM      'APIDSETPD'   InvFile2         10
     C                   PARM      '         '   InvFile3         10
     C                   PARM      *Blanks       InvFile4         10                        MD041294
 
      * Invalid file data
     C                   PARM      InvLE         InvFDta1       4000
     C                   PARM      InvSetIn      InvFDta2       4000
     C                   PARM      *BLANKS       InvFDta3       4000
     C                   PARM      *Blanks       InvFDta4       4000                        MD041294
 
      * Outputs
      * Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
      *
      **  If F3, bypass further processing.
     C                   IF        @INKC = '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
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
      * Inputs
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Action code
     C                   PARM                    DDACTN
      *
      * Front Office Trans ID & Front Office Associated Trans ID
     C                   PARM                    DDFRNT
     C                   PARM                    DDAFRT           20
      *
      * Timestamp
     C                   PARM                    D@STMP
      *
      * Narrative & Field Content 1 - 9
     C                   PARM                    DDNAR1           30
     C                   PARM      DDLOAN        DDFLD1           35
     C                   PARM                    DDNAR2           30
     C                   PARM      DDVDAT        DDFLD2           35
     C                   PARM                    DDNAR3           30
     C                   PARM      DDSEQN        DDFLD3           35
     C                   PARM                    DDNAR4           30
     C                   PARM      DDATYP        DDFLD4           35
     C                   PARM                    DDNAR5           30
     C                   PARM      DDCNUM        DDFLD5           35
     C                   PARM                    DDNAR6           30
     C                   PARM      DDCURR        DDFLD6           35
     C                   PARM                    DDNAR7           30
     C                   PARM      DDAMNT        DDFLD7           35
     C                   PARM                    DDNAR8           30
     C                   PARM      DDSTYP        DDFLD8           35
     C                   PARM                    DDNAR9           30
     C                   PARM      DDMDAT        DDFLD9           35
      *
      * Outputs
      * Function Keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
      *
      **  If F3, bypass further processing.
     C                   IF        @INKC = '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      **  If F10, delete invalid transaction
     C                   IF        @INKJ = '1'
     C                   MOVE      D@STMP        @STMP
     C     ZATRNKD0      CHAIN     LEILOAMD0                          99
     C  N99              DELETE    LEILOAMD0
 
     C     *IN99         IFEQ      '0'
     C                   MOVE      'D'           DDACTN
     C                   CALL      'RPC1600'
     C                   PARM      InvLE         EntryData      3000
     C                   PARM      'LEILOAMPD'   FileName         10
     C                   ENDIF
      *
     C     APDSETK0      CHAIN     APIDSETD0                          99
     C  N99              DELETE    APIDSETD0
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
     C                   COMMIT
     C                   Endif                                                                CSC022
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDITRAN - Read an invalid transaction
      *****************************************************************
     C     RDITRAN       BEGSR
      *
      **  Reset End of File indicator
     C                   MOVE      *BLANK        @@EOF             1
      *
      **  Read the file.
     C                   READ      LEILOAML0                              96
      *
      * End of File
     C                   IF        *IN96 = *ON
     C                   EVAL      @@EOF = 'Y'
     C                   ENDIF
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
      * Return error message
     C                   IF        @@ERR = 1
     C                   MOVEL     'LEA0302'     @ERRMS
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVTXT - Retrieve text
      *****************************************************************
     C     RTVTXT        BEGSR
     C                   CALL      'SDRTVTXT'
     C                   PARM                    MSGDNB            7
     C                   PARM      'ZZGBMSGF  '  MSGNM            10
     C                   PARM      *BLANK        MSGTXT           80
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
     C     *ENTRY        PLIST
      *
      * Input parameters
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Build sub-file
     C                   PARM                    @BDSFL            1
      *
      * Read subfile record
     C                   PARM                    @RDSFL            1
      *
      * Multi-branching indicator / runday
     C                   PARM                    BJSBRC            1
     C                   PARM                    WRUNDT            7
      *
      * Error in update of previous loan amendment
     C                   PARM                    @ERRUP            1
      *
      * Output parameters
      * Error message
     C                   PARM                    @ERRMS            7
      *
      * Option selected
     C                   PARM                    @OPSEL            1
      *
      * Action selected
     C                   PARM                    @ACSEL            1
      *
      * FO Transaction ID selected
     C                   PARM                    @FRNT            20
      *
      * Timestamp of Transaction selected
     C                   PARM                    @STMP
      *
      * Command Keys
     C                   PARM                    @INKC
     C                   PARM                    @INKL
      *                                                                                       CSC022
      * Enhancements for CSC022                                                               CSC022
     C                   PARM                    CSC022                                       CSC022
      *
      ** Initialise program name
     C                   EVAL      DBPGM = 'LELOAMRPB'
      *
      ** Move workstation ID to screen field.
     C                   EVAL      DDUSER = PsUser
     C                   EVAL      DDWID = PsJobName
     C                   MOVE      WRUNDT        S#RUNA
      *
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
     C                   Endif                                                                CSC022
     C                   EndIf                                                                CSC022
      * Key Lists
     C     ZATRNKD0      KLIST
     C                   KFLD                    DDFRNT
     C                   KFLD                    @STMP
 
     C     APDSETK0      KLIST
     C                   KFLD                    @MSGTYPE
     C                   KFLD                    DDFRNT
     C                   KFLD                    @STMP
 
     C     ZATRNKX0      KLIST
     C                   KFLD                    @STMP
     C                   KFLD                    DDFRNT
 
     C     APDSETKX      KLIST
     C                   KFLD                    @MSGTYPE
     C                   KFLD                    @STMP
     C                   KFLD                    DDFRNT
     C                   MOVEL     'LELOAM'      @MSGTYPE
      *
      * Format text for invalid transaction deletion function
     C                   EVAL      MSGDNB = 'APA0318'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR1 = MSGTXT
     C                   EVAL      MSGDNB = 'APA0319'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR2 = MSGTXT
     C                   EVAL      MSGDNB = 'APA0320'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR3 = MSGTXT
     C                   EVAL      MSGDNB = 'APA0321'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR4 = MSGTXT
     C                   EVAL      MSGDNB = 'APA0322'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR5 = MSGTXT
     C                   EVAL      MSGDNB = 'APA0323'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR6 = MSGTXT
     C                   EVAL      MSGDNB = 'APA0324'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR7 =  MSGTXT
     C                   EVAL      MSGDNB =  'APA0325'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR8 =  MSGTXT
     C                   EVAL      MSGDNB =  'APA0326'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR9 =  MSGTXT
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
Amendment successfully inserted.
The last transaction was not applied to the database
** LATP ** Loan amendment type
Principal increase
Spread rate change
Base rate code change
Stop/start accrual
Loan subtype
Past due item
