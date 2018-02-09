     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Invalid trades browse')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRADRPB - Invalid Trades Browse                            *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of invalid trades for selection*
      *             the other picks off the selection made.           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CER001             Date 25Apr05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSC022             Date 24Feb04               *
      *                 CSE039             Date 02Apr03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 211556             Date 28Nov02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 186611             Date 21Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 166907             Date 03Jan00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 16Nov99               *
      *                 CAP014             Date 29Nov99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             Date 17Mar99               *
      *                 CAP004             Date 01Sep98               *
      *                 CAP003  *CREATE    Date 31Jul98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CSE039 - Auto-settlement of trades                           *
      *         - Recompiled due to change in SEITRADPD               *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  211556 - Error message was displayed after unselecting a     *
      *           trade and selecting another trade. Fix was to add   *
      *           extra condition in SR/RDSFLR, so that a subfile     *
      *           will not undergo validation if the option entered   *
      *           is *BLANKS.  Apply fix 209257.                      *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP067 - Repurchase Agreements API.                          *
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
      *  166907 - Display 'Deal No. 999999 successfully inserted.'    *
      *           in the correct screen.                              *
      *  CAP051 - Automatic Authorisation (SE Trades Part)            *
      *           Recompiled due to database changes                  *
      *  CAP014 - Repair function enhancements                        *
      *  CAP006 - Display message if prev transaction not successful  *
      *           due to  deal being updated by another workstation   *
      *  CAP004 - API's Phase 3.                                      *
      *           Enable delete of invalid transactions               *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSETRADRDF CF   E             WORKSTN
     F                                     SFILE(SETRADS1:@@RRN)
     FSEITRADL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEITRADD0:SEITRADX0)          CAP004
     FSEITRADL1 UF   E           K DISK    INFSR(*PSSR)                         CAP004
     F                                     COMMIT                               CAP004
                                                                                              CSC011
      ** API Invalid Log File                                                                 CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
     FSEITDLX1L0UF   E           K DISK    USROPN                                             CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
 
     F/COPY WNCPYSRC,SETRADPF01
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
                                                                                              CSC022
     D WCmtJobArr      S             10A   DIM(10)                                            CSC022
      ** Array for commitment job names                                                       CSC022
      *                                                                                       CER001
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CER001
      *                                                                                       CER001
      ** External data structures for Midas Modules                                           CER001
      *                                                                                       CER001
 
     D InvTr         E DS                  EXTNAME(SEITRADPD)                   CAP014
                                                                                              CSC011
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD Data Area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** Successful Insert Deal Number                                          166907
     D                 DS                                                       166907
     D  DDFOTX                 1     40                                         166907
     D  DDSITR                11     16                                         166907
                                                                                166907
     D*ErrorText*******S*************52    DIM(1) CTDATA PERRCD(1)       CAP006 166907
     D*ErrorText*******S*************52    DIM(2) CTDATA PERRCD(1)                     166907 CAP067
     D ErrorText       S             60    DIM(3) CTDATA PERRCD(1)                            CAP067
      ** Array containing messages                                              CAP006
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
      ** DS for SAR Detail record                                                             CSC022
                                                                                              CSC022
     D InvTrSetEx    E DS                  EXTNAME(SETDRXPD)                                  CER001
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
     D  ComitJob               4    103                                                       CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
      *                                                                                       CSC022
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D @TMESTPSEL      S             26Z
     D CSC011          S              1A                                                      CSC011
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KTimeStamp      S                   LIKE(@TMESTPSEL)                                   CSC011
                                                                                              CSC011
     D CSC022          S              1A                                                      CSC022
                                                                                              CSC022
     D WCommitSkip     S              1A                                                      CSC022
      ** Commitment Skip Field                                                                CSC022
                                                                                              CSC022
     D/COPY WNCPYSRC,SETRADPD01
 
 
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
     C                   WRITE     SETRADS0
     C                   MOVE      '0'           *IN97
      *
      **  Write the select screen footer to the screen.
      *
      **  If previous transaction was not successful due to deal being          CAP006
      **  updated by another workstation then display message on screen         CAP006
     C     @ERRUP        IFEQ      'Y'                                          CAP006
     C                   MOVEL     ErrorText(1)  ERRORMSG                       CAP006
     C                   ELSE                                                   CAP006
     C                   MOVE      *BLANKS       ERRORMSG                       CAP006
     C                   MOVE      *BLANKS       DDFOTX                         166907
     C     @SITR         IFNE      *BLANK                                       166907
     C                   MOVEL     ErrorText(2)  DDFOTX                         166907
     C                   MOVEL     @SITR         DDSITR                         166907
     C                   MOVE      *BLANK        @SITR                          166907
     C                   MOVEL     DDFOTX        ERRORMSG                       166907
     C                   END                                                    166907
     C                   END                                                    CAP006
      *                                                                                       CAP067
      ** If action is either delete, authorise or approve, show message that                  CAP067
      ** the same action is automatically applied on the related trade                        CAP067
      *                                                                                       CAP067
     C     PDPYMS        IFEQ      'Y'                                                        CAP067
     C                   MOVEL     ErrorText(3)  ERRORMSG                                     CAP067
     C                   ENDIF                                                                CAP067
      *                                                                         CAP006
     C                   WRITE     SETRADF1
      *
      **  Set file pointer to start of file
      *
     C     *LOVAL        SETLL     SEITRADL0
      *
      * READ AN INVALID TRADE
      *
     C                   EXSR      RDITRADE
      *
      **  If no records exist - set up an error message.
      **  Display a message 'No invalid transactions present'
      **  then terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'FXM1007'     @ERRMS
     C                   EXFMT     SETRADEND
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
      **  Write the invalid trade to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   MOVE      DDTMESTMP     D@TMESTMP
     C                   WRITE     SETRADS1
      *
      * READ AN INVALID TRADE
      *
     C                   EXSR      RDITRADE
     C                   END
      *
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     SETRADS0
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      SETRADS0                               99
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
     C                   READC     SETRADS1                               99
      *                                                                         CAP004
      *                                                                         CAP014
      * Validate repair option code                                             CAP014
      *                                                                         CAP014
     C     *IN99         IFEQ      '0'                                          CAP014
     C     DDOPT         ANDNE     *BLANKS                                                    211556
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
      ***If*'D'*is*input,*prompt*for*deletion*of*invalid*transaction     CAP004 CAP014
      *                                                                         CAP004
     C     *IN99         IFEQ      '0'                                          CAP004
     C     DDOPT         ANDEQ     'Q'                                          CAP014
     C*****DDOPT******** ANDEQ     'D'                                   CAP004 CAP014
     C                   EXSR      PROM_DELT                                    CAP004
     C                   MOVEL     *BLANK        DDOPT                          CAP004
     C                   END                                                    CAP004
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
     C                   PARM                    DDFOTRANID                     CAP014
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
     C     ZATRNKX0      CHAIN     SEITRADX0                          99        CAP014
      *                                                                         CAP014
     C                   IF        ULX603 = 'Y'                                               CER001
     C                   CLEAR                   InvTrSetEx                                   CER001
     C     ZATRNKX0      CHAIN     SEITDLX1L0                         99                      CER001
     C                   EVAL      L6LXAGSD = #6LXAGSD                                        CER001
     C                   EVAL      L6LXTTIM = #6LXTTIM                                        CER001
     C                   EVAL      L6LXCABR = #6LXCABR                                        CER001
     C                   EVAL      L6LXMTRD = CCMTRD                                          CER001
     C                   EVAL      InvFile2 = 'SETDRXPD'                                      CER001
     C                   MOVEL     InvTrSetEx    InvFDta2                                     CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
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
     C                   PARM                    DDFOTRANID                     CAP014
     C                   PARM                    DDFOASOCID                     CAP014
     C                   PARM                    D@TMESTMP                      CAP014
                                                                                CAP014
      * Invalid file names                                                      CAP014
     C                   PARM      'SEITRADPD'   InvFile1         10            CAP014
     C                   PARM                    InvFile2         10            CAP014
     C                   PARM                    InvFile3         10            CAP014
                                                                                CAP014
      * Invalid file data                                                       CAP014
     C***********        PARM      InvTr         InvFDta1       2000            CAP014 CFT014
     C***********        PARM                    InvFDta2       2000            CAP014 CFT014
     C***********        PARM                    InvFDta3       2000            CAP014 CFT014
     C                   PARM      InvTr         InvFDta1       4000            CFT014
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
      /EJECT                                                                    CAP004
      *****************************************************************         CAP004
      * PROM_DELT - PROMPT FOR DELETION                                         CAP004
      *****************************************************************         CAP004
     C     PROM_DELT     BEGSR                                                  CAP004
      *                                                                         CAP004
     C                   CALLB     'ZAINVTRDEL'                                 CAP004
      *                                                                         CAP004
      * INPUTS                                                                  CAP004
      *                                                                         CAP004
      * Return Code                                                             CAP004
     C                   PARM      *BLANK        RetCodeOut                     CAP004
      *                                                                         CAP004
      * Action code                                                             CAP004
     C                   PARM                    DDACTN                         CAP004
      *                                                                         CAP004
      * Front Office Trans ID & Front Office Associated Trans ID                CAP004
     C                   PARM                    DDFOTRANID                     CAP004
     C                   PARM                    DDFOASOCID       20            CAP004
      *                                                                         CAP004
      * Timestamp                                                               CAP004
     C                   PARM                    D@TMESTMP                      CAP004
      *                                                                         CAP004
      * Narrative & Field Content 1 - 9                                         CAP004
     C                   PARM                    DDNAR1           30            CAP004
     C                   PARM      DDTDRF        DDFLD1           35            CAP004
     C                   PARM                    DDNAR2           30            CAP004
     C                   PARM      DDSESN        DDFLD2           35            CAP004
     C                   PARM                    DDNAR3           30            CAP004
     C                   PARM      DDCNUM        DDFLD3           35            CAP004
     C                   PARM                    DDNAR4           30            CAP004
     C                   PARM      DDINCS        DDFLD4           35            CAP004
     C                   PARM                    DDNAR5           30            CAP004
     C                   PARM      DDTDTP        DDFLD5           35            CAP004
     C                   PARM                    DDNAR6           30            CAP004
     C                   PARM      DDNOML        DDFLD6           35            CAP004
     C                   PARM                    DDNAR7           30            CAP004
     C                   PARM      DDTPDY        DDFLD7           35            CAP004
     C                   PARM                    DDNAR8           30            CAP004
     C                   PARM      DDTDVD        DDFLD8           35            CAP004
     C                   PARM                    DDNAR9           30            CAP004
     C                   PARM      DDTDDT        DDFLD9           35            CAP004
      *                                                                         CAP004
      * OUTPUTS                                                                 CAP004
      *                                                                         CAP004
      * FUNCTION KEYS                                                           CAP004
     C                   PARM      '0'           @INKC             1            CAP004
     C                   PARM      '0'           @INKJ             1            CAP004
     C                   PARM      '0'           @INKL             1            CAP004
      *                                                                         CAP004
      **  If F3, bypass further processing.                                     CAP004
      *                                                                         CAP004
     C     @INKC         IFEQ      '1'                                          CAP004
     C                   SETON                                        LR        CAP004
     C                   RETURN                                                 CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
      **  If F10, delete invalid trade                                          CAP004
      *                                                                         CAP004
     C     @INKJ         IFEQ      '1'                                          CAP004
     C                   MOVE      D@TMESTMP     @TMESTPSEL                     CAP004
     C     ZATRNKD0      CHAIN     SEITRADD0                          99        CAP004
      *                                                                         186611
     C     *IN99         IFEQ      '0'                                          186611
     C                   MOVE      'D'           DDACTN                         186611
     C                   MOVEL     *BLANKS       EntryData                      186611
     C                   MOVEL     *BLANKS       FileName                       186611
     C                   CALL      'RPC1600'                                    186611
     C                   PARM      InvTr         EntryData      3000            186611
     C                   PARM      'SEITRADPD'   FileName         10            186611
     C                   ENDIF                                                  186611
      *                                                                         186611
     C  N99              DELETE    SEITRADD0                                    CAP004
     C                   IF        ULX603 = 'Y'                                               CER001
     C     ZATRNKDX      CHAIN     SEITDLXD6                          99                      CER001
     C                   IF        %FOUND()                                                   CER001
     C                   DELETE    SEITDLXD6                                                  CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
                                                                                              CSC011
      ** Delete invalid record from the log file.                                             CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' and LIBR = S1SUPP                             CSC011
                                                                                              CSC011
     C                   EVAL      KMsgType   = 'SETRAD'                                      CSC011
     C                   EVAL      KFrntOffID = DDFOTRANID                                    CSC011
     C                   EVAL      KTimeStamp = @TMESTPSEL                                    CSC011
                                                                                              CSC011
     C     KAPILOGL0     CHAIN     APILOGL0                           99                      CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C/COPY WNCPYSRC,SETRADPC01
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   COMMIT                                                 CAP004
     C                   EndIf                                                                CSC022
     C                   END                                                    CAP004
      *                                                                         CAP004
     C                   ENDSR                                                  CAP004
      *****************************************************************         CAP004
      /EJECT
      *****************************************************************
      * RDITRADE - READ AN INVALID TRADE
      *****************************************************************
     C     RDITRADE      BEGSR
      *
      **  Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      **  Read the file.
      *
     C                   READ      SEITRADL0                              96
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
      /EJECT                                                                    CAP004
      *****************************************************************         CAP004
      * RTVTXT - RETRIEVE TEXT                                                  CAP004
      *****************************************************************         CAP004
     C     RTVTXT        BEGSR                                                  CAP004
     C                   CALL      'SDRTVTXT'                                   CAP004
     C                   PARM                    MSGDNB            7            CAP004
     C                   PARM      'ZZGBMSGF  '  MSGNM            10            CAP004
     C                   PARM      *BLANK        MSGTXT           80            CAP004
     C                   ENDSR                                                  CAP004
      *****************************************************************         CAP004
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
      * Error in update of previous deal                                        CAP006
     C                   PARM                    @ERRUP            1            CAP006
      *                                                                                       CAP067
      * Display message for buy-sell transactions                                             CAP067
     C                   PARM                    PDPYMS            1                          CAP067
      *                                                                         CAP006
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
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *                                                                         166907
      ** Successful Insert Trade                                                166907
      *                                                                         166907
     C                   PARM                    @SITR             6            166907
     C                   PARM                    CSC011                                       CSC011
      *
      ** Initialize program name
      *
     C                   MOVEL     'SETRADRPB'   DBPGM
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
      ** Access SDSTAT and SC24X7 if CSC011 is installed                                      CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
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
      *                                                                         CAP004
      * Key Lists                                                               CAP004
      *                                                                         CAP004
     C     ZATRNKD0      KLIST                                                  CAP004
     C                   KFLD                    DDFOTRANID                     CAP004
     C                   KFLD                    @TMESTPSEL                     CAP004
     C     ZATRNKX0      KLIST                                                  CAP014
     C                   KFLD                    @TMESTPSEL                     CAP014
     C                   KFLD                    DDFOTRANID                     CAP014
     C     KAPILOGL0     KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011
      *                                                                         CAP004
      * FORMAT TEXT FOR INVALID TRANSACTION DELETION FUNCTION                   CAP004
      *                                                                         CAP004
     C                   MOVEL     'APA0091'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR1                         CAP004
     C                   MOVEL     'APA0092'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR2                         CAP004
     C                   MOVEL     'APA0093'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR3                         CAP004
     C                   MOVEL     'APA0094'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR4                         CAP004
     C                   MOVEL     'APA0095'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR5                         CAP004
     C                   MOVEL     'APA0096'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR6                         CAP004
     C                   MOVEL     'APA0097'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR7                         CAP004
     C                   MOVEL     'APA0098'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR8                         CAP004
     C                   MOVEL     'APA0099'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR9                         CAP004
      *                                                                                       CER001
      ** Access Module Details to verify if Lux Return feature is active                      CER001
      *                                                                                       CER001
     C                   CALL      'AOMMODR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*FIRST '     @OPTN                                        CER001
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CER001
      *                                                                                       CER001
      ** ULX603 - API Luxembourg - Function SETRAD                                            CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX603            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX603'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD   = *BLANKS AND                                      CER001
     C                             BGLRIN  = 'Y'                                              CER001
     C                   EVAL      ULX603  = 'Y'                                              CER001
     C                   OPEN      SEITDLX1L0                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     ZATRNKDX      KLIST                                                                CER001
     C                   KFLD                    @TMESTPSEL                                   CER001
     C                   KFLD                    DDFOTRANID                                   CER001
      *                                                                                       CSC022
      ** Access Switchable Features File, for CSC022                                          CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      @SARD             6                          CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *Blanks                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   Eval      WCommitSkip = 'N'                                          CSC022
      *                                                                                       CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
     C                   MoveA     ComitJob      WCmtJobArr                                   CSC022
      *                                                                                       CSC022
     C     PSJOBNAME     LOOKUP    WCmtJobArr                             87                  CSC022
     C                   If        *IN87 = *ON                                                CSC022
     C                   Eval      WCommitSkip = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   Else                                                                 CSC022
      *                                                                                       CSC022
      ** If return code <> *NRF, call program exception error routine                         CSC022
      *                                                                                       CSC022
     C                   If        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 902                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C/COPY WNCPYSRC,SETRADPC02
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
**  Array of error messages - ErrorText                                         CAP006
The last transaction was not applied to the database
Trade No. 999999 successfully inserted.                                         166907
The related trade is also deleted/authorised/approved.                                      CAP067
