     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Invalid Rollover Instructions Browse')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LELERIRPB - Invalid Rollover Instructions Browse             *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of invalid Roll. for selection,*
      *             the other picks off the selection made.           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG9737            Date 29Dec05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG2665            Date 13May04               *
      *                 CAP084             Date 09Jan04               *
      *                 CAP076  *CREATE    Date 15Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG9737- Must included in CLE106 delivery due to changes made*
      *           CLE036 in loans file.(Recompile)                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  BUG2665 - Commitment Control Changes for MidasPlus. (CSC022) *
      *  CAP084 - Remove Rollover Status from defn file (recompile)   *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FLELERIRDF CF   E             WORKSTN
     F                                     SFILE(LEILERIS1:@@RRN)
     FLEILERIL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEILERID0:LEILERIX0)
     FLEILERIL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FAPIDSETL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(S_)
     F                                     RENAME(APIDSETD0:APIDSETX0)
     FAPIDSETL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** API Invalid log file by Type/FO Id/Time
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR)
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
      ******True*******logical*=**on*(for*indcator*processing)*********                       CAP084
      ******False******logical*=**off*(for*indcator*processing)********                       CAP084
      **    True       logical = *on (for indicator processing)                               CAP084
      **    False      logical = *off (for indicator processing)                              CAP084
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
 
     D WArrCmtJob      S             10A   DIM(10)                                           BUG2665
      ** Array for Commitment Job Names                                                      BUG2665
                                                                                             BUG2665
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                BUG2665
      ** Data structure for SCCMTJOB data area                                               BUG2665
     D  COMITNO                1      3S 0                                                   BUG2665
     D  COMITJOBS              4    103                                                      BUG2665
                                                                                             BUG2665
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 BUG2665
      ** External DS for API ICD                                                             BUG2665
                                                                                             BUG2665
     D InvTr         E DS                  EXTNAME(LEILERIPD)
     D InvTrSetIn    E DS                  EXTNAME(APIDSETPD)
     D                                     PREFIX(S_)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status data area
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
      ** Message text
     D                 DS
     D  DDFOTX                 1     40
 
     D ErrorText       S             52    DIM(1) CTDATA PERRCD(1)
      ** Array containing messages
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D @TMESTPSEL      S             26Z
 
      ** Message type field for chaining to APIDSETPD; defined in terms
      ** of the file field when the file field was changed.
     D @MSGTYPE        S                   LIKE(DDMSGTYPE)
 
     D CSC011          S              1A
     D KMsgType        S              8A
     D KFrntOffID      S             20A
     D KTimeStamp      S             26Z
     D PSARD           S              6A                                                      CSC022
     D CSC022          S              1A   Inz                                                CSC022
     D WSkipCommit     S              1A   Inz                                                CSC022
     D WPtr            S              2S 0 Inz                                                CSC022
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      * INITIALIZATION
      *
     C                   EXSR      INIT
      *
      * BUILD SUB-FILE
      *
     C     @BDSFL        IFEQ      'Y'
     C                   EXSR      BLDSFL
     C                   END
      *
      * READ SUBFILE RECORD
      *
     C     @RDSFL        IFEQ      'Y'
     C                   EXSR      RDSFLR
     C                   END
      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL - BUILD SUBFILE
      ********************************************************************
     C     BLDSFL        BEGSR
      *
      * CHECK FOR USER AUTHORITY TO BROWSE IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     LEILERIS0
     C                   MOVE      '0'           *IN97
      *
      **  Write the select screen footer to the screen.
      *
      **  If previous transaction was not successful due to loan being
      **  updated by another workstation then display message on screen
     C     @ERRUP        IFEQ      'Y'
     C                   MOVEL     ErrorText(1)  ERRORMSG
     C                   ELSE
     C                   MOVE      *BLANKS       ERRORMSG
     C                   MOVE      *BLANKS       DDFOTX
     C                   END
      *
     C                   WRITE     LEILERIF1
      *
      **  Set file pointer to start of file
      *
     C     *LOVAL        SETLL     LEILERIL0
      *
      * Read an Invalid Rollover Instruction
      *
     C                   EXSR      RDIROLL
      *
      **  If no records exist - set up an error message.
      **  Display a message 'No invalid transactions present'
      **  then terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'FXM1007'     @ERRMS
     C                   EXFMT     LEILERIEND
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C     @@EOF         DOWNE     'Y'
     C     *IN98         ANDEQ     '1'
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     14
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      **  Write the invalid Rollover Instruction to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   MOVE      DDTMESTMP     D@TMESTMP
     C                   WRITE     LEILERIS1
      *
      * Read an Invalid Rollover Instructions
      *
     C                   EXSR      RDIROLL
     C                   END
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     LEILERIS0
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      LEILERIS0                              99
      *
      **  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      **  If F12, bypass further processing.
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
      * RDSFLR - READ SUBFILE RECORD
      ********************************************************************
     C     RDSFLR        BEGSR
      *
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
      *
     C     *IN99         DOUEQ     '1'
     C     DDOPT         ORNE      *BLANK
     C                   READC     LEILERIS1                              99
      *
      * Validate repair option code
      *
     C     *IN99         IFEQ      '0'
     C                   EXSR      VALID_ROPT
     C                   END
      *
      ** If 'E' is input, enquire upon invalid transaction
      *
     C     *IN99         IFEQ      '0'
     C     DDOPT         ANDEQ     'E'
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C                   EXSR      ENQ_INV
     C                   MOVEL     *BLANK        DDOPT
     C                   END
      *
      ** If 'Q' is input, prompt for deletion of invalid transaction
      ** If 'D' is input, prompt for deletion of invalid transaction
      *
     C     *IN99         IFEQ      '0'
     C     DDOPT         ANDEQ     'Q'
     C                   EXSR      PROM_DELT
     C                   MOVEL     *BLANK        DDOPT
     C                   END
     C                   END
      *
      **  Return the selected option, action, front office transaction ID
      **  and front office associated transaction ID
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
      *
     C                   MOVE      DDOPT         @OPSEL
     C                   MOVE      DDACTN        @ACSEL
     C                   MOVE      DDFOTRANID    @FOTRANSEL
     C                   MOVE      DDFOASOCID    @FOASOCSEL
     C                   MOVE      D@TMESTMP     @TMESTPSEL
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALID_ROPT - VALIDATE REPAIR OPTION CODE
      *****************************************************************
     C     VALID_ROPT    BEGSR
      *
     C                   CALLB     'ZAROPTVAL'
 
      * INPUTS
 
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      * Option code
      * Front Office ID
      * Booking Branch
     C                   PARM                    DDOPT
     C                   PARM                    DDFOTRANID
     C                   PARM                    DDBRSN
 
      * ICD Single branch code
     C                   PARM                    BJSBRC
 
      * OUTPUTS
 
      * Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
      *
      **  If F3, bypass further processing.
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      **  If F12, continue with next option
      *
     C     @INKL         IFEQ      '1'
     C                   MOVEL     *BLANK        DDOPT
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENQ_INV - ENQUIRE ON INVALID TRANSACTION
      *****************************************************************
     C     ENQ_INV       BEGSR
 
     C                   MOVEL     'LELERI'      @XMSGTYP         32
 
      * Pass the invalid transaction details to the enquiry
 
     C     ZATRNKX0      CHAIN     LEILERIX0                          99
     C                   CLEAR                   InvTrSetIn
     C     APIDSETKX     CHAIN     APIDSETX0                          99
      *
     C                   CALLB     'ZAINVTRENQ'
 
      * INPUTS
 
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      * Action code
      * Front Office ID
      * Associated Front Office ID
      * Timestamp
     C                   PARM                    DDACTN
     C                   PARM                    DDFOTRANID
     C                   PARM                    DDFOASOCID
     C                   PARM                    D@TMESTMP
 
      * Invalid file names
     C                   PARM      'LEILERIPD'   InvFile1         10
     C                   PARM      'APIDSETPD'   InvFile2         10
     C                   PARM                    InvFile3         10
 
      * Invalid file data
     C                   PARM      InvTr         InvFDta1       4000
     C                   PARM      InvTrSetIn    InvFDta2       4000
     C                   PARM                    InvFDta3       4000
 
      * OUTPUTS
 
      * Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
      *
      **  If F3, bypass further processing.
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
      * PROM_DELT - PROMPT FOR DELETION
      *****************************************************************
     C     PROM_DELT     BEGSR
      *
     C                   CALLB     'ZAINVTRDEL'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Action code
     C                   PARM                    DDACTN
      *
      * Front Office Trans ID & Front Office Associated Trans ID
     C                   PARM                    DDFOTRANID
     C                   PARM                    DDFOASOCID
      *
      * Timestamp
     C                   PARM                    D@TMESTMP
      *
      * Narrative & Field Content 1 - 9
     C                   PARM                    DDNAR1           30
     C                   PARM      DDLOAN        DDFLD1           35
     C                   PARM                    DDNAR2           30
     C                   PARM      DDCNUM        DDFLD2           35
     C                   PARM                    DDNAR3           30
     C                   PARM      DDSRDT        DDFLD3           35
     C                   PARM                    DDNAR4           30
     C                   PARM      DDSNRD        DDFLD4           35
     C                   PARM                    DDNAR5           30
     C                   PARM      DDSFRQ        DDFLD5           35
     C                   PARM                    DDNAR6           30
     C                   PARM      DDSRDY        DDFLD6           35
     C                   PARM                    DDNAR7           30
     C                   PARM      DDSRST        DDFLD7           35
     C                   PARM                    DDNAR8           30
     C                   PARM                    DDFLD8           35
     C                   PARM                    DDNAR9           30
     C                   PARM                    DDFLD9           35
      *
      * OUTPUTS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
      *
      **  If F3, bypass further processing.
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      **  If F10, delete invalid Rollover Instruction
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C     ZATRNKD0      CHAIN     LEILERID0                          99
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      'D'           DDACTN
     C                   MOVEL     *BLANKS       EntryData
     C                   MOVEL     *BLANKS       FileName
     C                   CALL      'RPC1600'
     C                   PARM      InvTr         EntryData      3000
     C                   PARM      'LEILERIPD'   FileName         10
     C                   ENDIF
      *
     C  N99              DELETE    LEILERID0
     C     APIDSETK0     CHAIN     APIDSETD0                          99
     C  N99              DELETE    APIDSETD0
                                                                                             BUG2665
      **  COMMIT data if either of the following is true:                                    BUG2665
      **    1. Commitment Control Changes switch is OFF; or                                  BUG2665
      **    2. Commitment Control Changes switch is ON and                                   BUG2665
      **       this particular job is not included in the                                    BUG2665
      **       commitment jobs in data area SCCMTJOB                                         BUG2665
                                                                                             BUG2665
     C                   If        CSC022  = 'N' or                                          BUG2665
     C                             (CSC022 = 'Y' and WSkipCommit = 'N')                      BUG2665
     C                   COMMIT
     C                   EndIf                                                               BUG2665
 
      ** Delete invalid record from the log file
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
 
     C                   EVAL      KMsgType = 'LELERI'
     C                   EVAL      KFrntOffID = DDFOTRANID
     C                   EVAL      KTimeStamp = DDTMESTMP
 
     C     KAPLOG        CHAIN     APILOGL0                           99
 
     C                   IF        *IN99 = *OFF
     C                   DELETE    APILOGL0
     C                   ENDIF
 
     C                   ENDIF
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDIROLL - READ AN INVALID ROLLOVER INSTRUCTION
      *****************************************************************
     C     RDIROLL       BEGSR
      *
      **  Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      **  Read the file.
      *
     C                   READ      LEILERIL0                              96
      *
      * End of File
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   END
      *
     C     ERDDEL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - CHECK FOR USER AUTHORITY IF NOT MULTI-BRANCHING
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      * RETURN ERROR MESSAGE
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
      * RTVTXT - RETRIEVE TEXT
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
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
      *
     C                   MOVE      *BLANK        @ERRMS
     C                   MOVE      *BLANK        @OPSEL
     C                   MOVE      *BLANK        @ACSEL
     C                   MOVE      *BLANK        @FOTRANSEL
     C                   MOVE      *BLANK        @FOASOCSEL
     C                   CLEAR                   @TMESTPSEL
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM                    RetCodeIn
      *
      * BUILD SUB-FILE
     C                   PARM                    @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM                    @RDSFL            1
      *
      * Error in update of previous rollover instruction
     C                   PARM                    @ERRUP            1
      *
     C                   PARM                    CSC011
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM                    @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM                    @OPSEL            1
      *
      * ACTION SELECTED
     C                   PARM                    @ACSEL            1
      *
      * FO TRANSACTION ID SELECTED
     C                   PARM                    @FOTRANSEL       20
      *
      * FO ASSOCIATED TRANSACTION ID SELECTED
     C                   PARM                    @FOASOCSEL       20
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *
      ** Initialize program name
      *
     C                   MOVEL     'LELERIRPB'   DBPGM
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER
 
      ** Access SDSTAT and SC24X7 if CSC011 is installed
 
     C                   IF        CSC011 = 'Y'
     C                   IN        SDSTAT
     C                   IN        SC24X7
     C                   ENDIF
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      * Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    DDFOTRANID
     C                   KFLD                    @TMESTPSEL
 
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    DDFOTRANID
 
     C     APIDSETK0     KLIST
     C                   KFLD                    @MSGTYPE
     C                   KFLD                    DDFOTRANID
     C                   KFLD                    @TMESTPSEL
 
     C     APIDSETKX     KLIST
     C                   KFLD                    @MSGTYPE
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    DDFOTRANID
 
     C     KAPLOG        KLIST
     C                   KFLD                    KMsgType
     C                   KFLD                    KFrntOffID
     C                   KFLD                    KTimeStamp
      ** Message Type
     C                   MOVEL     'LELERI'      @MSGTYPE
 
      ** Initialize SAR work flag and Commit flag                                            BUG2665
     C                   Eval      CSC022      = 'N'                                         BUG2665
     C                   Eval      WSkipCommit = ' '                                         BUG2665
                                                                                             BUG2665
      ** Determine if Commitment Control Changes for MidasPlus                               BUG2665
      ** (CSC022) is installed                                                               BUG2665
                                                                                             BUG2665
     C                   Call      'AOSARDR0'                                                BUG2665
     C                   Parm      *BLANKS       @RTCD                                       BUG2665
     C                   Parm      '*VERIFY'     @OPTN                                       BUG2665
     C                   Parm      'CSC022'      PSARD                                       BUG2665
     C     SCSARD        Parm      SCSARD        DSFDY                                       BUG2665
                                                                                             BUG2665
      ** If feature is on, set up SAR work flag                                              BUG2665
                                                                                             BUG2665
     C                   If        @RTCD = *Blanks                                           BUG2665
     C                   Eval      CSC022      = 'Y'                                         BUG2665
     C                   Eval      WSkipCommit = 'N'                                         BUG2665
     C                   In        SCCMTJOB                                                  BUG2665
                                                                                             BUG2665
     C                   If        COMITNO  <> 0                                             BUG2665
     C                   MoveA     COMITJOBS     WArrCmtJob                                  BUG2665
                                                                                             BUG2665
     C                   Eval      WPtr = %LookUp(PSJobName:WArrCmtJob)                      BUG2665
     C                   If        WPtr > 0                                                  BUG2665
     C                   Eval      WSkipCommit = 'Y'                                         BUG2665
     C                   EndIf                                                               BUG2665
                                                                                             BUG2665
     C                   EndIf                                                               BUG2665
                                                                                             BUG2665
      ** else, database error (return code other than *NRF)                                  BUG2665
                                                                                             BUG2665
     C                   Else                                                                BUG2665
                                                                                             BUG2665
     C                   If        @RTCD <> '*NRF   '                                        BUG2665
     C     *Lock         In        LDA                                                       BUG2665
     C                   MoveL     'LELERIRPB'   DBPGM                                       BUG2665
     C                   MoveL     'SCSARDPD'    DBFILE                                      BUG2665
     C                   MoveL     'CSC022'      DBKEY                          *************BUG2665
     C                   Z-Add     902           DBASE                          * DBASE 902 *BUG2665
     C                   Out       LDA                                          *************BUG2665
     C                   ExSR      *PSSR                                                     BUG2665
     C                   EndIf                                                               BUG2665
                                                                                             BUG2665
     C                   EndIf                                                               BUG2665
                                                                                             BUG2665
      * FORMAT TEXT FOR INVALID TRANSACTION DELETION FUNCTION
      *
     C                   MOVEL     'APA0021'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR1
     C                   MOVEL     'APA0022'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR2
     C                   MOVEL     'APA0023'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR3
     C                   MOVEL     'APA0024'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR4
     C                   MOVEL     'APA0025'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR5
     C                   MOVEL     'APA0026'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR6
     C                   MOVEL     'APA0027'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR7
     C                   MOVEL     'APA0028'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR8
     C                   MOVEL     'APA0029'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR9
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
