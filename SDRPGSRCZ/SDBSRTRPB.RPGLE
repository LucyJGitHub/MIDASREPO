     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Invalid base rates details browse')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDBSRTRPB - Invalid Base Rates Browse                        *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of invalid base rates for      *
      *             selection                                         *
      *             The other picks off the selection made.           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD041294           Date 19Sep16               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP038  *CREATE    Date 07Mar00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041294 - Customer extension details is missing in          *
      *             CUSD repair browse                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP038 - Conversion of SD inputs into modular structure      *
      *           to use as APIs.                                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDBSRTRDF CF   E             WORKSTN
     F                                     SFILE(SDBSRTS1:@@RRN)
     FSDIBSRTL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDIBSRTD0:SDIBSRTX0)
     FSDIBSRTL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
                                                                                              CSC011
      ** API Invalid Log File from Support Database                                           CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
 
     F/COPY WNCPYSRC,SDBSRTBF01
 
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
     D/COPY WNCPYSRC,SDBSRTBD01
 
     D InvBr         E DS                  EXTNAME(SDIBSRTPD)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD data area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
     D ErrorText       S             52    DIM(1) CTDATA PERRCD(1)
      ** Array containing messages
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D @TMESTPSEL      S             26Z
                                                                                              CSC011
      ** Fields defined for Enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KTimeStamp      S                   LIKE(@TMESTPSEL)                                   CSC011
 
 
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
     C                   WRITE     SDBSRTS0
     C                   MOVE      '0'           *IN97
      *
      **  If previous transaction was not successful due to base rate being
      **  updated by another workstation then display message on screen
      *
     C     @ERRUP        IFEQ      'Y'
     C                   MOVEL     ErrorText(1)  ERRORMSG
     C                   ELSE
     C                   MOVE      *BLANKS       ERRORMSG
     C                   END
      *
      **  Write the select screen footer to the screen.
      *
     C                   WRITE     SDBSRTF1
      *
      **  Set file pointer to start of file
      *
     C     *LOVAL        SETLL     SDIBSRTL0
      *
      * READ AN INVALID BASE RATE
      *
     C                   EXSR      RDIBSRT
      *
      **  If no records exist - set up an error message.
      **  Display a message 'No invalid transactions present'
      **  then terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'FXM1007'     @ERRMS
     C                   EXFMT     SDBSRTEND
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
      **  Write the invalid base rate to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   MOVEL     DDBSRN        DDBSRNSHD
     C                   Z-ADD     @@RRN         DDSFRN
     C                   MOVE      DDTMESTMP     D@TMESTMP
     C                   WRITE     SDBSRTS1
      *
      * READ AN INVALID BASE RATE
      *
     C                   EXSR      RDIBSRT
     C                   END
      *
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     SDBSRTS0
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      SDBSRTS0                               99
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
     C                   READC     SDBSRTS1                               99
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
     C                   MOVE      DDCYCD        @CYCD
     C                   MOVE      DDBSRC        @BSRC
     C                   MOVE      DDFOTRANID    @FOTRANSEL
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
     C                   PARM      *BLANK        BookBranch        3
 
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
 
      * Pass the invalid transaction details to the enquiry
 
     C     ZATRNKX0      CHAIN     SDIBSRTX0                          99
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
     C                   PARM      *BLANKS       DDFOASOCID
     C                   PARM                    D@TMESTMP
 
      * Invalid file names
     C                   PARM      'SDIBSRTPD'   InvFile1         10
     C                   PARM      *BLANKS       InvFile2         10
     C                   PARM      *BLANKS       InvFile3         10
     C                   PARM      *Blanks       InvFile4         10                        MD041294
 
      * Invalid file data
     C                   PARM      InvBr         InvFDta1       2000
     C                   PARM      *BLANKS       InvFDta2       2000
     C                   PARM      *BLANKS       InvFDta3       2000
     C                   PARM      *Blanks       InvFDta4       4000                        MD041294
 
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
     C                   PARM      *BLANKS       DDFOASOCID       20
      *
      * Timestamp
     C                   PARM                    D@TMESTMP
      *
      * Narrative & Field Content 1 - 9
     C                   PARM                    DDNAR1           30
     C                   PARM      DDCYCD        DDFLD1           35
     C                   PARM                    DDNAR2           30
     C                   PARM      DDBSRC        DDFLD2           35
     C                   PARM                    DDNAR3           30
     C                   PARM      DDBSRN        DDFLD3           35
     C                   PARM                    DDNAR4           30
     C                   PARM      DDNBRT        DDFLD4           35
     C                   PARM                    DDNAR5           30
     C                   PARM      DDVDNR        DDFLD5           35
     C                   PARM                    DDNAR6           30
     C                   PARM      DDSCDD        DDFLD6           35
     C                   PARM                    DDNAR7           30
     C                   PARM      DDDGMA        DDFLD7           35
     C                   PARM                    DDNAR8           30
     C                   PARM      DDOMD1        DDFLD8           35
     C                   PARM                    DDNAR9           30
     C                   PARM      DDOMD2        DDFLD9           35
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
      **  If F10, delete invalid base rate
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C     ZATRNKD0      CHAIN     SDIBSRTD0                          99
     C  N99              DELETE    SDIBSRTD0
     C/COPY WNCPYSRC,SDBSRTBC01
                                                                                              CSC011
      ** Delete invalid record from the log file.                                             CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR                             CSC011
                                                                                              CSC011
     C                   EVAL      KMsgType = 'SDBSRT'                                        CSC011
     C                   EVAL      KFrntOffID = DDFOTRANID                                    CSC011
     C                   EVAL      KTimeStamp = @TMESTPSEL                                    CSC011
                                                                                              CSC011
     C     KAPILOGL0     CHAIN     APILOGL0                           99                      CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   COMMIT
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDIBSRT - READ AN INVALID BASE RATE
      *****************************************************************
     C     RDIBSRT       BEGSR
      *
      **  Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      **  Read the file.
      *
     C                   READ      SDIBSRTL0                              96
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
      *                                                                                       CSC011
      * If 24x7 is present then journal APILOGL0                                              CSC011
      *                                                                                       CSC011
     C                   IF        (CSC011 = 'Y')                                             CSC011
     C                   OPEN      APILOGL0                             22                    CSC011
     C                   ENDIF                                                                CSC011
      *
      * CLEAR OUTPUTS
      *
     C                   MOVE      *BLANK        @ERRMS
     C                   MOVE      *BLANK        @OPSEL
     C                   MOVE      *BLANK        @ACSEL
     C                   MOVE      *BLANK        @CYCD
     C                   MOVE      *BLANK        @BSRC
     C                   MOVE      *BLANK        @FOTRANSEL
     C                   CLEAR                   @TMESTPSEL
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
      *
     C                   ENDSR
      ********************************************************************
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
      * Error in update of previous base rate
     C                   PARM                    @ERRUP            1
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
      * Currency Code
     C                   PARM                    @CYCD             3
      *
      * Base Rate Code
     C                   PARM                    @BSRC             2
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM                    @INKC
     C                   PARM                    @INKL
                                                                                              CSC011
      ** CSC011 indicator                                                                     CSC011
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDBSRTRPB'   DBPGM
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
                                                                                              CSC011
      ** Access SDSTAT and SC24X7 if switchable feature CSC011 is on.                         CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   ENDIF                                                                CSC011
      *
      * Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    DDFOTRANID
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    DDFOTRANID
                                                                                              CSC011
     C     KAPILOGL0     KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011
      *
      * FORMAT TEXT FOR INVALID TRANSACTION DELETION FUNCTION
      *
     C                   MOVEL     'APA0302'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR1
     C                   MOVEL     'APA0307'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR2
     C                   MOVEL     'APA0308'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR3
     C                   MOVEL     'APA0132'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR4
     C                   MOVEL     'APA0133'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR5
     C                   MOVEL     'APA0134'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR6
     C                   MOVEL     'APA0135'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR7
     C/COPY WNCPYSRC,SDBSRTBC02
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
(c) Finastra International Limited 2001
**  Array of error messages - ErrorText
The last transaction was not applied to the database
