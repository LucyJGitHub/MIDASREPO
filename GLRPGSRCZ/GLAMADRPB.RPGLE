     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Invalid accounts browse')                     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMADRPB - Invalid Accounts Browse                          *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of invalid Accounts or         *
      *             selections the other picks off the selection made.*
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 LLN022A            Date 03Jun15               *
      *                 CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CER001             Date 25Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 LLN022             Date 24Jan05               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 14Feb99               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 186611             Date 21Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP014             Date 22Dec99               *
      *                 CFT004             Date 12Nov99               *
      *                 CAP035  *CREATE    Date 06Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CDE002 - CCRM Revenue Analysis - Recompile only              *
      *  186611 - API Repair Queues : Review Delete Operation.        *
      *                                                               *
      *           To distinguish 'Delete' in Repair Queues between    *
      *                                                               *
      *              - Delete by action code 'Q' (Module 'RPB')       *
      *                (Message Refused by Midas)                     *
      *           and                                                 *
      *              - Delete after Main File updated (Module 'RPR')  *
      *                (Message Accepted by Midas)                    *
      *                                                               *
      *           Send a User Defined Journal Entry for the Invalid   *
      *           File and ensure Action Code is set to 'D'. So,      *
      *           Front Office system will receive a return message   *
      *           for Invalid File(s) ONLY when Message is refused    *
      *           by Midas.                                           *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  CAP014 - Repair function enhancements                        *
      *  CFT004 - Straight Through Processing Phase 2                 *
      *         - International Bank Account Numbers(Recompile Only)  *
      *  CAP035 - Midas API Conversion for ToF                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FGLAMADRDF CF   E             WORKSTN
     F                                     SFILE(GLAMADS1:@@RRN)
     F***GLIAMADL0 IF   E           K DISK    INFSR(*PSSR)                                    CGL029
     FGLIAMADL2 IF   E           K DISK    INFSR(*PSSR)                                       CGL029
     F                                     RENAME(GLIAMADD0:GLIAMADX0)
     F***GLIAMADL1 UF   E           K DISK    INFSR(*PSSR)                                    CGL029
     FGLIAMADL3 UF   E           K DISK    INFSR(*PSSR)                                       CGL029
     F                                     COMMIT
     F***APILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                      CSC011 CGL029
     FAPILOGL1  UF   E           K DISK    INFSR(*PSSR) USROPN                                CGL029
     F                                     COMMIT                                             CSC011

     F/COPY WNCPYSRC,GLAMADPF01
     FGLIAMADY0 UF   E           K DISK    INFSR(*PSSR)                                      LLN022A
     F                                     RENAME(GLIAMADD0 : IAMADD0)                       LLN022A
     FGLIAMLX1L0UF   E           K DISK    USROPN                                             CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
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
                                                                                CAP014
     D InvAc         E DS                  EXTNAME(GLIAMADPD)                   CAP014
     D InvExt        E DS                  EXTNAME(GLAMRXPD)                                  CER001

     D* Account Number
     D**ACNUMB**       DS            22                                                       CGL029
     D  ACNUMB         DS            28                                                       CGL029
     D  ACBRCA                 1      3
     D  FLD0                   4      4
     D  ACCNUM                 5     10
     D  FLD1                  11     11
     D  ACCCY                 12     14
     D  FLD2                  15     15
     D**ACACOD**              16     19                                                       CGL029
     D**FLD3****              20     20                                                       CGL029
     D**ACACSQ**              21     22                                                       CGL029
     D  ACACOD                16     25                                                       CGL029
     D  FLD3                  26     26                                                       CGL029
     D  ACACSQ                27     28                                                       CGL029

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
      * Data Structure for Midas SAR Details                                                  CSC022
                                                                                              CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WCMTJOBS               4    103A                                                      CSC022
      ** Commitment Control dataarea                                                          CSC022

     D ErrorText       S             52    DIM(1) CTDATA PERRCD(1)
      ** Array containing messages

      ** Array to hold commitment jobs name                                                   CSC022
     D WCMT            S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      **   Timestamp selected
     D @TMESTPSEL      S             26Z

      ** Fields defined for Enhancement CSC011                                                CSC011
     D CSC011          S              1A                                                      CSC011
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KFrntAscID      S             20A                                                      CGL029
     D KTimeStamp      S                   LIKE(@TMESTPSEL)                                   CSC011

      ** Fields for enhancement CSC022                                                        CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D WCmtSk          S              1A                                                      CSC022
                                                                                              CSC022
     D ULX004          S              1A                                                      CER001
     D ULX606          S              1A                                                      CER001
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
     C                   WRITE     GLAMADS0
     C                   MOVE      '0'           *IN97
      *
      **  If previous transaction was not successful due to Account being
      **  updated by another workstation then display message on screen
     C     @ERRUP        IFEQ      'Y'
     C                   MOVEL     ErrorText(1)  ERRORMSG
     C                   ELSE
     C                   MOVE      *BLANKS       ERRORMSG
     C                   END
      *
      **  Write the select screen footer to the screen.
      *
     C                   WRITE     GLAMADF1
      *
      **  Set file pointer to start of file
      *
     C******LOVAL        SETLL     GLIAMADL0                                                  CGL029
     C     *LOVAL        SETLL     GLIAMADL2                                                  CGL029
      *
      * READ AN INVALID ACCOUNT
      *
     C                   EXSR      RDIACNT
      *
      **  If no records exist - set up an error message.
      **  Display a message 'No invalid accounts present'
      **  then terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'RE72016'     @ERRMS
     C                   EXFMT     GLAMADEND
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
      **  Write the invalid account to the subfile.
      *
      *
      ** Account Number
     C                   MOVE      DDBRCA        ACBRCA
     C                   MOVE      DDCUSN        ACCNUM
     C                   MOVE      DDCCY         ACCCY
     C                   MOVE      DDACOD        ACACOD
     C                   MOVE      DDACSQ        ACACSQ
     C                   MOVE      ACNUMB        DDACNUM
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   MOVE      DDTMESTMP     D@TMESTMP
     C                   WRITE     GLAMADS1
      *
      * READ AN INVALID ACCOUNT
      *
     C                   EXSR      RDIACNT
     C                   END
      *
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     GLAMADS0
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      GLAMADS0                               99
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
      **  Only process those for which the option field is not blank.
      *
     C     *IN99         DOUEQ     '1'
     C     DDOPT         ORNE      *BLANK
     C                   READC     GLAMADS1                               99
      *                                                                         CAP014
      * Validate repair option code                                             CAP014
      *                                                                         CAP014
     C     *IN99         IFEQ      '0'                                          CAP014
     C                   EXSR      VALID_ROPT                                   CAP014
     C                   END                                                    CAP014
      *                                                                         CAP014
      ** If 'E' is input, enquire upon invalid transaction                      CAP014
      *                                                                         CAP014
     C     *IN99         IFEQ      '0'                                          CAP014
     C     DDOPT         ANDEQ     'E'                                          CAP014
     C                   MOVE      D@TMESTMP     @TMESTPSEL                     CAP014
     C                   EXSR      ENQ_INV                                      CAP014
     C                   MOVEL     *BLANK        DDOPT                          CAP014
     C                   END                                                    CAP014
      *                                                                         CAP004
      ** If 'Q' is input, prompt for deletion of invalid transaction            CAP014
      ***If*'D'*is*input,*prompt*for*deletion*of*invalid*transaction            CAP014
      *
     C     *IN99         IFEQ      '0'
     C     DDOPT         ANDEQ     'Q'                                          CAP014
     C*****DDOPT*********ANDEQ*****'D'                                          CAP014
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
     C**********         MOVE      DDFOTRANID    @FOTRANSEL                                   CGL029
     C                   MOVEL     DDFOTRANID    @FOTRANSEL                                   CGL029
     C                   MOVE      DDFOASOCID    @FOTRANSEL                                   CGL029
     C                   MOVE      D@TMESTMP     @TMESTPSEL
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CAP014
      *****************************************************************         CAP014
      * VALID_ROPT - VALIDATE REPAIR OPTION CODE                                CAP014
      *****************************************************************         CAP014
     C     VALID_ROPT    BEGSR                                                  CAP014
      *                                                                         CAP014
     C**********         CALLB     'ZAROPTVAL'                                         CAP014 CGL029
     C                   CALLB     'ZAROPTVAL1'                                               CGL029
                                                                                CAP014
      * INPUTS                                                                  CAP014
                                                                                CAP014
      * Return Code                                                             CAP014
     C                   PARM      *BLANK        RetCodeOut                     CAP014
      * Option code                                                             CAP014
      * Front Office ID                                                         CAP014
      * Booking Branch                                                          CAP014
     C                   PARM                    DDOPT                          CAP014
     C**********         PARM                    DDFOTRANID                            CAP014 CGL029
     C                   PARM                    DDFOTRAN40                                   CGL029
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
     C     ZATRNKX0      CHAIN     GLIAMADX0                          99        CAP014
     C                   MOVEL     DDFOTRAN40    DDFOTRANID                                   CGL029
     C                   MOVE      DDFOTRAN40    DDFOASOCID                                   CGL029
     C                   IF        ULX606 = 'Y'                                               CER001
     C     ZATRNKX0      CHAIN     GLIAMLXD6                          99                      CER001
     C                   EVAL      L6LXCOBR = #6LXCOBR                                        CER001
     C                   EVAL      L6LXCOAC = #6LXCOAC                                        CER001
     C                   EVAL      L6LXCOAM = #6LXCOAM                                        CER001
     C                   EVAL      L6LXLUSU = #6LXLUSU                                        CER001
     C                   EVAL      L6LX1UAC = #6LX1UAC                                        CER001
     C                   EVAL      InvFile2 = 'GLAMRXPD'                                      CER001
     C                   EVAL      InvFDta2 = InvExt                                          CER001
     C                   ENDIF                                                                CER001
      *                                                                         CAP014
     C                   CALLB     'ZAINVTRENQ'                                 CAP014
                                                                                CAP014
      * INPUTS                                                                  CAP014
                                                                                CAP014
      * Return Code                                                             CAP014
     C**********         PARM      *BLANK        RetCodeOut                            CAP014 CGL029
     C                   PARM      'GL        '  RetCodeOut                                   CGL029
      * Action code                                                             CAP014
      * Front Office ID                                                         CAP014
      * Associated Front Office ID                                              CAP014
      * Timestamp                                                               CAP014
     C                   PARM                    DDACTN                         CAP014
     C                   PARM                    DDFOTRANID                     CAP014
     C                   PARM                    DDFOASOCID                     CAP014
     C                   PARM                    D@TMESTMP                      CAP014
                                                                                CAP014
      * Invalid file names                                                      CAP014
     C                   PARM      'GLIAMADPD'   InvFile1         10            CAP014
     C                   PARM                    InvFile2         10            CAP014
     C                   PARM                    InvFile3         10            CAP014
                                                                                CAP014
      * Invalid file data                                                       CAP014
     C***********        PARM      InvAc         InvFDta1       2000            CAP014 CFT014
     C***********        PARM                    InvFDta2       2000            CAP014 CFT014
     C***********        PARM                    InvFDta3       2000            CAP014 CFT014
     C                   PARM      InvAc         InvFDta1       4000            CFT014
     C                   PARM                    InvFDta2       4000            CFT014
     C                   PARM                    InvFDta3       4000            CFT014
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
                                                                                              CGL029
     C                   MOVEL     DDFOTRAN40    DDFOTRANID                                   CGL029
     C                   MOVE      DDFOTRAN40    DDFOASOCID                                   CGL029
      *
     C                   CALLB     'ZAINVTRDEL'
      *
      * INPUTS
      *
      * Return Code
     C**********         PARM      *BLANK        RetCodeOut                                   CGL029
     C                   PARM      'GL        '  RetCodeOut                                   CGL029
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
     C                   PARM      DDACNUM       DDFLD1           35
     C                   PARM                    DDNAR2           30
     C                   PARM      DDACNO        DDFLD2           35
     C                   PARM                    DDNAR3           30
     C                   PARM      DDANAM        DDFLD3           35
     C                   PARM                    DDNAR4           30
     C                   PARM      DDDACO        DDFLD4           35
     C                   PARM                    DDNAR5           30
     C                   PARM      DDDACC        DDFLD5           35
     C                   PARM                    DDNAR6           30
     C                   PARM      DDNSTD        DDFLD6           35
     C                   PARM                    DDNAR7           30
     C                   PARM      DDSTFQ        DDFLD7           35
     C                   PARM                    DDNAR8           30
     C                   PARM      DDENOC        DDFLD8           35
     C                   PARM                    DDNAR9           30
     C                   PARM      DDNSDN        DDFLD9           35
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
      **  If F10, delete invalid Account
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C     ZATRNKD0      CHAIN     GLIAMADD0                          99
      *                                                                         186611
     C     *IN99         IFEQ      '0'                                          186611
     C                   MOVE      'D'           DDACTN                         186611
     C                   MOVEL     *BLANKS       EntryData                      186611
     C                   MOVEL     *BLANKS       FileName                       186611
     C                   CALL      'RPC1600'                                    186611
     C                   PARM      InvAc         EntryData      3000            186611
     C                   PARM      'GLIAMADPD'   FileName         10            186611
     C                   ENDIF                                                  186611
      *                                                                         186611
     C  N99              DELETE    GLIAMADD0
                                                                                              CSC011
      ** Delete invalid record from the log file.                                             CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   EVAL      KMsgType = 'GLAMAD'                                        CSC011
     C                   EVAL      KFrntOffID = DDFOTRANID                                    CSC011
     C                   EVAL      KFrntAscID = DDFOASOCID                                    CGL029
     C                   EVAL      KTimeStamp = @TMESTPSEL                                    CSC011
                                                                                              CSC011
     C*****KAPILOGL0     CHAIN     APILOGL0                           99               CSC011 CGL029
     C     KAPILOGL1     CHAIN     APILOGL1                           99                      CGL029
     C                   IF        *IN99 = *OFF                                               CSC011
     C**********         DELETE    APILOGL0                                            CSC011 CGL029
     C                   DELETE    APILOGL1                                                   CGL029
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C/COPY WNCPYSRC,GLAMADPC01
      *                                                                                      LLN022A
     C     ZATRNKX1      KLIST                                                               LLN022A
     C                   KFLD                    @TMESTPSEL                                  LLN022A
     C                   KFLD                    DDFOTRANID                                  LLN022A
      *                                                                                      LLN022A
      ** Delete extra data on the invalid file.                                              LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN022 = 'Y'                                              LLN022A
     C     ZATRNKX1      CHAIN     IAMADD0                            99                     LLN022A
     C  N99              DELETE    IAMADD0                                                   LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   IF        ULX606 = 'Y'                                               CER001
     C     ZATRNKX0      CHAIN     GLIAMLXD6                          99                      CER001
     C  N99              DELETE    GLIAMLXD6                                                  CER001
     C                   ENDIF                                                                CER001
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDIACNT - READ AN INVALID ACCOUNT
      *****************************************************************
     C     RDIACNT       BEGSR
      *
      **  Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      **  Read the file.
      *
     C**********         READ      GLIAMADL0                              96                  CGL029
     C                   READ      GLIAMADL2                              96                  CGL029
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
      **If*24x7*is*present*then*journal*APILOGL0**********************                 CSC011 CGL029
      * If 24x7 is present then journal APILOGL1                                              CGL029
      *                                                                                       CSC011
     C                   IF        (CSC011 = 'Y')                                             CSC011
     C**********         OPEN      APILOGL0                             22             CSC011 CGL029
     C                   OPEN      APILOGL1                             22                    CGL029
     C                   ENDIF                                                                CSC011
      *
      * CLEAR OUTPUTS
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
      * Error in update of previous Account
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
     C**********         PARM                    @FOTRANSEL       20                          CGL029
     C                   PARM                    @FOTRANSEL       40                          CGL029
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
                                                                                              CSC011
      ** CSC011 Enhancement is installed                                                      CSC011
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
      *
      ** Initialize program name
      *
     C                   MOVEL     'GLAMADRPB'   DBPGM
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
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
                                                                                              CSC011
      ** Access SDSTAT and SC24x7 when CSC011 is installed                                    CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       @RTCD                                        CSC022
     C                   PARM      '*VERIFY'     @OPTN                                        CSC022
     C                   PARM      'CSC022'      @SARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        @RTCD = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   EVAL      WCMTSK = 'N'                                               CSC022
                                                                                              CSC022
     C                   IN        SCCMTJOB                                                   CSC022
                                                                                              CSC022
     C                   IF        COMITNUM > 0                                               CSC022
                                                                                              CSC022
     C                   MOVEA     WCMTJOBS      WCMT                                         CSC022
                                                                                              CSC022
     C                   IF        %LOOKUP(PSJOBNAME:WCMT) > 0                                CSC022
     C                   EVAL      WCMTSK = 'Y'                                               CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
     C                   IF        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 11                                                 CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                       CER001
      ** ULX004 - European Reporting as Feature                                               CER001
      *                                                                                       CER001
     C                   EVAL      ULX004 = 'N'                                               CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *Blanks                                            CER001
     C                   EVAL      ULX004 = 'Y'                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX606 - API Luxembourg - Function GLAMAD                                            CER001
      *                                                                                       CER001
     C                   EVAL      ULX606 = 'N'                                               CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX606'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *Blanks and                                        CER001
     C                             ULX004 = 'Y'                                               CER001
     C                   EVAL      ULX606 = 'Y'                                               CER001
     C                   OPEN      GLIAMLX1L0                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      **  Access Switchable SAR details for the existence of LLN022 (Bank of England)        LLN022A
      *                                                                                      LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANK        @RTCD                                       LLN022A
     C                   PARM      '*VERIFY'     @OPTN                                       LLN022A
     C                   PARM      'LLN022'      @SARD                                       LLN022A
      *                                                                                      LLN022A
     C                   IF        @RTCD = *BLANK                                            LLN022A
     C                   MOVE      'Y'           LLN022            1                         LLN022A
     C                   ELSE                                                                LLN022A
     C                   MOVE      'N'           LLN022            1                         LLN022A
     C                   ENDIF                                                               LLN022A
      *
      * Key Lists
      *
     C     ZATRNKD0      KLIST
     C**********         KFLD                    DDFOTRANID                                   CGL029
     C                   KFLD                    DDFOTRAN40                                   CGL029
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST                                                  CAP014
     C                   KFLD                    @TMESTPSEL                     CAP014
     C**********         KFLD                    DDFOTRANID                            CAP014 CGL029
     C                   KFLD                    DDFOTRAN40                                   CGL029
                                                                                              CSC011
     C*****KAPILOGL0     KLIST                                                         CSC011 CGL029
     C     KAPILOGL1     KLIST                                                                CGL029
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KFrntAscID                                   CGL029
     C                   KFLD                    KTimeStamp                                   CSC011
      *
      * FORMAT TEXT FOR INVALID ACCOUNT DELETION FUNCTION
      *
     C                   MOVEL     'ZZM9338'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR1
     C                   MOVEL     'ZZM9339'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR2
     C                   MOVEL     'ZZM9340'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR3
     C                   MOVEL     'ZZM9341'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR4
     C                   MOVEL     'ZZM9342'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR5
     C                   MOVEL     'ZZM9343'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR6
     C                   MOVEL     'ZZM9344'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR7
     C                   MOVEL     'ZZM9345'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR8
     C                   MOVEL     'ZZM9346'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR9
      *
      * Initialise field separaters
      *
     C                   MOVE      '-'           FLD0
     C                   MOVE      '-'           FLD1
     C                   MOVE      '-'           FLD2
     C                   MOVE      '-'           FLD3
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
