     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD Forward rates repair browse')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing ILE Module                                   *
      *                                                               *
      *  FDFWRTRPB - Invalid Forward Rates Transactions Browse        *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *          One display a list of invalid transactions for       *
      *          selection, the other picks off the selection made.   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG1056            Date 20May04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 196570             Date 20Jul01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP059  *CREATE    Date 17Oct00               *
      *                                                               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG1056 - (CSC022) Commitment Control Changes for MidasPlus  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  196570 - Patch for Market Data Feed (recompile)              *
      *  CSD006 - Market Data Feed                                    *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFDFWRTRDF CF   E             WORKSTN
     F                                     SFILE(FDFWRTS1:@@RRN)
     FFDIFWRTL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FDIFWRTD0:FDIFWRTX0)
     FFDIFWRTL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
                                                                                              CSC011
     ** API Invalid Log File                                                                  CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
 
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
 
      ** Include the FD standard declares
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
 
     D/COPY WNCPYSRC,FDFWRTBD01
      ** Commitment Control Job Array                                                        BUG1056
     D WJobs           S             10A   Dim(10)                                           BUG1056
      **                                                                                     BUG1056
 
     D InvFD         E DS                  EXTNAME(FDIFWRTPD)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR CUSTOMER DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
      ** DS for Switchable Features details                                                  BUG1056
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 BUG1056
      **                                                                                     BUG1056
      ** SCCMTJOB DataArea Layout                                                            BUG1056
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                BUG1056
     D  WDSJobs                4    103A                                                     BUG1056
      **                                                                                     BUG1056
     D ErrorText       S             52    DIM(1) CTDATA PERRCD(1)
      ** Array containing messages
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D @TMESTPSEL      S             26Z
 
      ** Fields defined for Enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KTimeStamp      S                   LIKE(@TMESTPSEL)                                   CSC011
      ** CSC022 switchable field                                                             BUG1056
     D CSC022          S              1A                                                     BUG1056
      ** CSC022 work fields                                                                  BUG1056
     D WArrPtr         S              3S 0                                                   BUG1056
     D WSkpComtRolbk   S              1A                                                     BUG1056
      **                                                                                     BUG1056
 
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
     C                   WRITE     FDFWRTS0
     C                   MOVE      '0'           *IN97
      *
      **  If previous transaction was not successful due to deal being
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
     C                   WRITE     FDFWRTF1
      *
      **  Set file pointer to start of file
      *
     C     *LOVAL        SETLL     FDIFWRTL0
      *
      * READ AN INVALID TRANSACTION
      *
     C                   EXSR      RDITRAN
      *
      **  If no records exist - set up an error message.
      **  Display a message 'No invalid transactions present'
      **  then terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'FXM1007'     @ERRMS
     C                   EXFMT     FDFWRTEND
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
     C     @@CNT         ANDLT     16
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      **  Write the invalid transaction to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   MOVE      DDTMESTMP     D@TMESTMP
     C                   WRITE     FDFWRTS1
      *
      * READ AN INVALID TRANSACTION
      *
     C                   EXSR      RDITRAN
     C                   END
      *
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     FDFWRTS0
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      FDFWRTS0                               99
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
     C                   READC     FDFWRTS1                               99
      *
      * Validate repair option code
      *
     C     *IN99         IFEQ      '0'
     C                   EXSR      VALID_ROPT
     C                   ENDIF
      *
      ** If 'E' is input, enquire upon invalid transaction
      *
     C     *IN99         IFEQ      '0'
     C     DDOPT         ANDEQ     'E'
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C                   EXSR      ENQ_INV
     C                   MOVEL     *BLANK        DDOPT
     C                   ENDIF
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
     C                   MOVE      DDCCY         @CCY
     C                   MOVE      DDFOTRANID    @FOTRANSEL
     C                   MOVE      D@TMESTMP     @TMESTPSEL
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CAP014
      *****************************************************************         CAP014
      * VALID_ROPT - VALIDATE REPAIR OPTION CODE                                CAP014
      *****************************************************************         CAP014
     C     VALID_ROPT    BEGSR                                                  CAP014
      *                                                                         CAP014
     C                   CALLB     'ZAROPTVAL'                                  CAP014
                                                                                CAP014
      * INPUTS                                                                  CAP014
                                                                                CAP014
      * Return Code                                                             CAP014
     C                   PARM      *BLANK        RetCodeOut                     CAP014
      * Option code                                                             CAP014
      * Front Office ID                                                         CAP014
      * Booking Branch                                                          CAP014
     C                   PARM                    DDOPT                          CAP014
     C                   PARM                    DDFOTRANID
     C                   PARM                    DDBRSN                         CAP014
                                                                                CAP014
      * ICD Single branch code                                                  CAP014
     C                   PARM                    BJSBRC                         CAP014
                                                                                CAP014
      * OUTPUTS                                                                 CAP014
                                                                                CAP014
      * Function Keys                                                           CAP014
     C                   PARM      '0'           @INKC                          CAP014
     C                   PARM      '0'           @INKL                          CAP014
      *                                                                         CAP014
      **  If F3, bypass further processing.                                     CAP014
      *                                                                         CAP014
     C     @INKC         IFEQ      '1'                                          CAP014
     C                   SETON                                        LR        CAP014
     C                   RETURN                                                 CAP014
     C                   END                                                    CAP014
      *                                                                         CAP014
      **  If F12, continue with next option                                     CAP014
      *                                                                         CAP014
     C     @INKL         IFEQ      '1'                                          CAP014
     C                   MOVEL     *BLANK        DDOPT                          CAP014
     C                   END                                                    CAP014
      *                                                                         CAP014
     C                   ENDSR                                                  CAP014
      *****************************************************************         CAP014
      /EJECT                                                                    CAP014
      *****************************************************************         CAP014
      * ENQ_INV - ENQUIRE ON INVALID TRANSACTION                                CAP014
      *****************************************************************         CAP014
     C     ENQ_INV       BEGSR                                                  CAP014
                                                                                CAP014
      * Pass the invalid transaction details to the enquiry                     CAP014
                                                                                CAP014
     C     ZATRNKX0      CHAIN     FDIFWRTX0                          99        CAP014
      *                                                                         CAP014
     C                   CALLB     'ZAINVTRENQ'                                 CAP014
                                                                                CAP014
      * INPUTS                                                                  CAP014
                                                                                CAP014
      * Return Code                                                             CAP014
     C                   PARM      *BLANK        RetCodeOut                     CAP014
      * Action code                                                             CAP014
      * Front Office ID                                                         CAP014
      * Associated Front Office ID                                              CAP014
      * Timestamp                                                               CAP014
     C                   PARM                    DDACTN                         CAP014
     C                   PARM                    DDFOTRANID
     C                   PARM                    DDFOTRANID
     C                   PARM                    D@TMESTMP                      CAP014
                                                                                CAP014
      * Invalid file names                                                      CAP014
     C                   PARM      'FDIFWRTPD'   InvFile1         10            CAP014
     C                   PARM      '         '   InvFile2         10            CAP014
     C                   PARM      '         '   InvFile3         10            CAP014
                                                                                CAP014
      * Invalid file data                                                       CAP014
     C                   PARM      InvFD         InvFDta1       2000            CAP014
     C                   PARM      *BLANKS       InvFDta2       2000            CAP014
     C                   PARM      *BLANKS       InvFDta3       2000            CAP014
                                                                                CAP014
      * OUTPUTS                                                                 CAP014
                                                                                CAP014
      * Function Keys                                                           CAP014
     C                   PARM      '0'           @INKC                          CAP014
     C                   PARM      '0'           @INKL                          CAP014
      *                                                                         CAP014
      **  If F3, bypass further processing.                                     CAP014
      *                                                                         CAP014
     C     @INKC         IFEQ      '1'                                          CAP014
     C                   SETON                                        LR        CAP014
     C                   RETURN                                                 CAP014
     C                   END                                                    CAP014
      *                                                                         CAP014
     C                   ENDSR                                                  CAP014
      *****************************************************************         CAP014
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
     C                   PARM                    DDFOASOCID       20
      *
      * Timestamp
     C                   PARM                    D@TMESTMP
      *
      * Narrative & Field Content 1 - 9
     C                   PARM                    DDNAR1           30
     C                   PARM      DDCCY         DDFLD1           35
     C                   PARM                    DDNAR2           30
     C                   PARM      DDDYS1        DDFLD2           35
     C                   PARM                    DDNAR3           30
     C                   PARM      DDRTE1        DDFLD3           35
     C                   PARM                    DDNAR4           30
     C                   PARM      DDDYS2        DDFLD4           35
     C                   PARM                    DDNAR5           30
     C                   PARM      DDRTE2        DDFLD5           35
     C                   PARM                    DDNAR6           30
     C                   PARM      DDSFW2        DDFLD6           35
     C                   PARM                    DDNAR7           30
     C                   PARM                    DDFLD7           35
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
      **  If F10, delete invalid transaction
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C     ZATRNKD0      CHAIN     FDIFWRTD0                          99
     C  N99              DELETE    FDIFWRTD0
                                                                                              CSC011
      ** Delete invalid record from the log file.                                             CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   EVAL      KMsgType = 'FDFWRT'                                        CSC011
     C                   EVAL      KFrntOffID = DDFOTRANID                                    CSC011
     C                   EVAL      KTimeStamp = @TMESTPSEL                                    CSC011
                                                                                              CSC011
     C     KAPILOGL0     CHAIN     APILOGL0                           99                      CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      **                                                                                     BUG1056
      ** Execute commit if SAR CSC022 is not enrolled or                                     BUG1056
      **   job is not currently running in batch mode                                        BUG1056
      **                                                                                     BUG1056
     C                   If        CSC022 = 'N'                                              BUG1056
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                 BUG1056
     C                   COMMIT
     C                   EndIf                                                               BUG1056
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDITRAN - READ AN INVALID TRANSACTION
      *****************************************************************
     C     RDITRAN       BEGSR
      *
      **  Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      **  Read the file.
      *
     C                   READ      FDIFWRTL0                              96
      **  Get Transaction Details
     C                   CALL      'AOCUSTR0'
     C                   PARM      *blanks       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCCY         @CCY             10
     C                   PARM      *BLANKS       @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
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
     C                   MOVE      *BLANK        @CCY
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
      * Error in update of previous deal
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
      * Transaction Number
     C                   PARM                    @TRNN             6
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM                    @INKC
     C                   PARM                    @INKL
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
     C                   PARM                    CSC022                                      BUG1056
      *
      ** Initialize program name
      *
     C                   MOVEL     'FDFWRTRPB'   DBPGM
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
      ** Access SDSTAT and SC24X7 if CSC011 is installed                                      CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   ENDIF                                                                CSC011
      **                                                                                     BUG1056
      ** Initialize Commit/Skip Flag                                                         BUG1056
     C                   Eval      WSkpComtRolbk = 'N'                                       BUG1056
      **                                                                                     BUG1056
     C                   If        CSC022 = 'Y'                                              BUG1056
      **                                                                                     BUG1056
      ** Get Jobs currently running i batch mode using SCCMRJOB dataarea                     BUG1056
      **                                                                                     BUG1056
     C                   In        SCCMTJOB                                                  BUG1056
     C                   If        ComitNum > 0                                              BUG1056
      ** Move committed jobs to arrary for checking                                          BUG1056
     C                   MoveA     WDSJobs       WJobs                                       BUG1056
      ** Verify if job running exists in array                                               BUG1056
     C                   Eval      WArrPtr = %LookUp(PSJobName:WJobs)                        BUG1056
     C                   If        WArrPtr > 0                                               BUG1056
     C                   Eval      WSkpComtRolbk = 'Y'                                       BUG1056
     C                   EndIf                                                               BUG1056
     C                   EndIf                                                               BUG1056
     C                   EndIf                                                               BUG1056
      **                                                                                     BUG1056
      *
      * Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    DDFOTRANID
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST                                                  CAP014
     C                   KFLD                    @TMESTPSEL                     CAP014
     C                   KFLD                    DDFOTRANID                     CAP014
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
     C                   MOVEL     'APA0303'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR2
     C                   MOVEL     'APA0304'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR3
     C                   MOVEL     'APA0305'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR4
     C                   MOVEL     'APA0306'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR5
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
