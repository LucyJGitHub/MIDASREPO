     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Function code browse')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SEPRCSRPB - Invalid Securities Prices Browse                 *
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
      *                 CGL031             Date 05Jul04               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG2812            Date 01Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSD010             Date 03May02               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP060  *CREATE    Date 03Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CGL031 - Taxation on Savings Income                          *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG2812 - Commitment Control Changes for MidasPlus (CSC022)  *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSD010 - Collateralised Lending (Securities and FX Pricing)  *
      *           (Recompile)                                         *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP060 - Conversion of Midas Screen Input Program into full  *
      *           API, including repair program which CAP030 does not *
      *           include                                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSEPRCSRPDFCF   E             WORKSTN
     F                                     SFILE(SEPRCSS1:@@RRN)
     FSEIPRCSL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEIPRCSD0:SEIPRCSX0)
     FSEIPRCSL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
                                                                                              CSC011
      ** API Invalid Log File by Type/FO ID/Timestamp                                         CSC011
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
                                                                                             BUG2812
     D WCmtJobArr      S             10A   DIM(10)                                           BUG2812
      ** Array for commitment job names                                                      BUG2812
 
     D/COPY WNCPYSRC,SEPRCSBD01
 
     D InvMm         E DS                  EXTNAME(SEIPRCSPD)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR CUSTOMER DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      ** 24x7 Status Data Area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD Data Area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
     D ErrorText       S             52    DIM(1) CTDATA PERRCD(1)
      ** Array containing messages
                                                                                             BUG2812
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 BUG2812
      ** DS for SAR Detail record                                                            BUG2812
                                                                                             BUG2812
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                  BUG2812
     D  ComitJob               4    103                                                      BUG2812
      ** Midas SC Jobs handling commitment control data area                                 BUG2812
                                                                                             BUG2812
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D @TMESTPSEL      S             26Z
 
     D CSC011          S              1A                                                      CSC011
                                                                                              CSC011
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KTimeStamp      S             26Z                                                      CSC011
                                                                                              CGL031
      ** Parameter for RPC1600                                                                CGL031
     D EntryData       S           3000A                                                      CGL031
     D FileName        S             10A                                                      CGL031
                                                                                             BUG2812
     D CSC022          S              1A                                                     BUG2812
                                                                                             BUG2812
     D WCommitSkip     S              1A                                                     BUG2812
      ** Commitment Skip Field                                                               BUG2812
 
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
     C                   ENDIF
      *
      * READ SUBFILE RECORD
      *
     C     @RDSFL        IFEQ      'Y'
     C                   EXSR      RDSFLR
     C                   ENDIF
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
     C                   ENDIF
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     SEPRCSS0
     C                   MOVE      '0'           *IN97
      *
      **  If previous transaction was not successful due to record being
      **  updated by another workstation then display message on screen
      *
     C     @ERRUP        IFEQ      'Y'
     C                   MOVEL     ErrorText(1)  ERRORMSG
     C                   ELSE
     C                   MOVE      *BLANKS       ERRORMSG
     C                   ENDIF
      *
      **  Write the select screen footer to the screen.
      *
     C                   WRITE     SEPRCSF1
      *
      **  Set file pointer to start of file
      *
     C     *LOVAL        SETLL     SEIPRCSL0
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
     C                   EXFMT     SEPRCSEND
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
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
      **  Write the invalid transaction to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   MOVE      DDTMESTMP     D@TMESTMP
     C                   WRITE     SEPRCSS1
      *
      * READ AN INVALID TRANSACTION
      *
     C                   EXSR      RDITRAN
     C                   ENDDO
      *
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     SEPRCSS0
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      SEPRCSS0                               99
      *
      **  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      **  If F12, bypass further processing.
      *
     C     *INKL         IFEQ      '1'
     C                   MOVEL     '1'           @INKL
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDDO
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
     C                   READC     SEPRCSS1                               99
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
     C                   ENDIF
     C                   ENDDO
      *
      **  Return the selected option, action, front office transaction ID
      **  and front office associated transaction ID
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
      *
     C                   MOVE      DDOPT         @OPSEL
     C                   MOVE      DDACTN        @ACSEL
     C                   MOVE      DDPSSN        @PSSN
     C                   MOVE      DDFOTRANID    @FOTRANSEL
     C                   MOVE      D@TMESTMP     @TMESTPSEL
      *
     C                   ENDIF
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
     C                   ENDIF
      *
      **  If F12, continue with next option
      *
     C     @INKL         IFEQ      '1'
     C                   MOVEL     *BLANK        DDOPT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENQ_INV - ENQUIRE ON INVALID TRANSACTION
      *****************************************************************
     C     ENQ_INV       BEGSR
 
      * Pass the invalid transaction details to the enquiry
 
     C     ZATRNKX0      CHAIN     SEIPRCSX0                          99
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
     C                   PARM      'SEIPRCSPD'   InvFile1         10
     C                   PARM      '         '   InvFile2         10
     C                   PARM      '         '   InvFile3         10
 
      * Invalid file data
     C                   PARM      InvMm         InvFDta1       4000
     C                   PARM      *BLANKS       InvFDta2       4000
     C                   PARM      *BLANKS       InvFDta3       4000
 
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
     C                   ENDIF
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
     C                   PARM                    DDFOASOCID       20
      *
      * Timestamp
     C                   PARM                    D@TMESTMP
      *
      * Narrative & Field Content 1 - 9
     C                   PARM                    DDNAR1           30
     C                   PARM      DDPSSN        DDFLD1           35
     C                   PARM                    DDNAR2           30
     C                   PARM      DDPCNM        DDFLD2           35
     C                   PARM                    DDNAR3           30
     C                   PARM      DDPMKT        DDFLD3           35
     C                   PARM                    DDNAR4           30
     C                   PARM      DDPBRA        DDFLD4           35
     C                   PARM                    DDNAR5           30
     C                   PARM      DDPBOK        DDFLD5           35
     C                   PARM                    DDNAR6           30
     C                   PARM      DDPRFC        DDFLD6           35
     C                   PARM                    DDNAR7           30
     C                   PARM      DDPPRT        DDFLD7           35
     C                   PARM                    DDNAR8           30
     C                   PARM      DDPTFR        DDFLD8           35
     C                   PARM                    DDNAR9           30
     C                   PARM      DDPVDT        DDFLD9           35
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
     C                   ENDIF
      *
      **  If F10, delete invalid transaction
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C     ZATRNKD0      CHAIN     SEIPRCSD0                          99
     C                   IF        *IN99 = *OFF                                               CGL031
     C                   MOVE      'D'           DDACTN                                       CGL031
     C                   MOVEL     *BLANKS       EntryData                                    CGL031
     C                   MOVEL     *BLANKS       FileName                                     CGL031
     C                   CALL      'RPC1600'                                                  CGL031
     C                   PARM      InvMm         EntryData                                    CGL031
     C                   PARM      'SEIPRCSPD'   FileName                                     CGL031
     C                   DELETE    SEIPRCSD0                                                  CGL031
     C**N99*****         DELETE    SEIPRCSD0                                                  CGL031
      *                                                                                      BUG2812
     C                   If        (CSC022 <> 'Y')                                           BUG2812
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                  BUG2812
     C                   COMMIT
     C                   EndIf                                                               BUG2812
     C                   ENDIF                                                                CGL031
                                                                                              CSC011
      ** Delete the record from the APILOGPD file                                             CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR                             CSC011
     C                   EVAL      KMsgType = 'SEPRCS'                                        CSC011
     C                   EVAL      KFrntOffID = DDFOTRANID                                    CSC011
     C                   MOVE      D@TMESTMP     KTimeStamp                                   CSC011
                                                                                              CSC011
     C     KAPILOG       CHAIN     APILOGL0                           89                      CSC011
                                                                                              CSC011
     C                   IF        *IN89 = *Off                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF
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
     C                   READ      SEIPRCSL0                              96
      *
      * End of File
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   ENDIF
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
     C                   ENDIF
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
     C                   MOVE      *BLANK        @PSSN
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
      * Error in update of previous record
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
     C                   PARM                    @PSSN             6
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM                    @INKC
     C                   PARM                    @INKL
                                                                                              CSC011
      ** Switchable feature CSC011                                                            CSC011
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
      *
      ** Initialize program name
      *
     C                   MOVEL     'SEPRCSRPB'   DBPGM
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
      ** Access Data Area SC24X7 and SDSTAT                                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
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
     C     KAPILOG       KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011
      *
      * FORMAT TEXT FOR INVALID TRANSACTION DELETION FUNCTION
      *
     C                   MOVEL     'APA0309'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR1
     C                   MOVEL     'APA0310'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR2
     C                   MOVEL     'APA0311'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR3
     C                   MOVEL     'APA0312'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR4
     C                   MOVEL     'APA0313'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR5
     C                   MOVEL     'APA0314'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR6
     C                   MOVEL     'APA0315'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR7
     C                   MOVEL     'APA0316'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR8
     C                   MOVEL     'APA0317'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR9
      *                                                                                      BUG2812
      ** Access Switchable Features File, for CSC022                                         BUG2812
      *                                                                                      BUG2812
     C                   Eval      CSC022 = 'N'                                              BUG2812
     C                   CallB     'AOSARDR0'                                                BUG2812
     C                   Parm      *BLANKS       @RTCD                                       BUG2812
     C                   Parm      '*VERIFY'     @OPTN                                       BUG2812
     C                   Parm      'CSC022'      @SARD             6                         BUG2812
     C     SCSARD        Parm      SCSARD        DSFDY                                       BUG2812
      *                                                                                      BUG2812
     C                   If        @RTCD = *Blanks                                           BUG2812
     C                   Eval      CSC022 = 'Y'                                              BUG2812
     C                   Eval      WCommitSkip = 'N'                                         BUG2812
      *                                                                                      BUG2812
     C                   In        SCCMTJOB                                                  BUG2812
     C                   If        ComitNum > 0                                              BUG2812
     C                   MoveA     ComitJob      WCmtJobArr                                  BUG2812
      *                                                                                      BUG2812
     C     PSJOBNAME     LOOKUP    WCmtJobArr                             87                 BUG2812
     C                   If        *IN87 = *ON                                               BUG2812
     C                   Eval      WCommitSkip = 'Y'                                         BUG2812
     C                   EndIf                                                               BUG2812
     C                   EndIf                                                               BUG2812
      *                                                                                      BUG2812
     C                   Else                                                                BUG2812
      *                                                                                      BUG2812
      ** If return code <> *NRF, call program exception error routine                        BUG2812
      *                                                                                      BUG2812
     C                   If        @RTCD <> '*NRF'                                           BUG2812
     C     *LOCK         IN        LDA                                                       BUG2812
     C                   EVAL      DBKEY = 'CSC022'                                          BUG2812
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG2812
     C                   EVAL      DBASE = 902                                               BUG2812
     C                   OUT       LDA                                                       BUG2812
     C                   Exsr      *PSSR                                                     BUG2812
     C                   EndIf                                                               BUG2812
     C                   EndIf                                                               BUG2812
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
**  Array of error messages - ErrorText
The last transaction was not applied to the database
