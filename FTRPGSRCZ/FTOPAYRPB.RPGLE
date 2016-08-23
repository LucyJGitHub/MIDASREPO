     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Invalid outgoing payments browse')            *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTOPAYRPB - Invalid Outgoing Payments Browse                 *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of invalid pmnts for selection,*
      *             the other picks off the selection made.           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT039             Date 28Sep12               *
      *  Prev Amend No. CRE067             Date 05Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 250600             Date 07Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
      *                 CER001             Date 25Apr05               *
      *                 CGL014             Date 20Oct03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 CSC022             Date 24Feb04               *
      *                 207404             Date 09Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 15Nov00               *
      *                 186611             Date 21Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP014             Date 08Dec99               *
      *                 CAP031  *CREATE    Date  8Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT039 - SWIFT Mapping of Field Ordering Bank                *
      *           Amendment done to accommodate longer data           *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  250600 - Recompiled for change in FTV@OPAYPD                 *
      *           to fix CFT032/CSW207 errors                         *
      *  CFT032 - Account line in field 50X in MT103                  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  207404 - Send msg with correct payment reference after       *
      *           successful insert                                   *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
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
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CAP014 - Repair function enhancements                        *
      *  CAP031 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFTOPAYRDF CF   E             WORKSTN
     F                                     SFILE(FTIOPAYS1:@@RRN)
     FFTIOPAYL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FTIOPAYD0:FTIOPAYX0)
     FFTIOPAYL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
     FFTIOPLX1L0UF   E           K DISK    USROPN                                             CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
     F/COPY WNCPYSRC,FTH00138
 
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
 
      ** Commitment Control Job Array                                                         CSC022
     D WJobs           S             10A   Dim(10)                                            CSC022
      **                                                                                      CSC022
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CER001
                                                                                CAP014
     D InvTr         E DS                  EXTNAME(FTIOPAYPD)                   CAP014
     D InvExt        E DS                  EXTNAME(FTIOPLX1L0)                                CER001
     D InvRxt        E DS                  EXTNAME(FTOPRXPD)                                  CER001
     D/COPY WNCPYSRC,FTH00187
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *                                                                                       207404
     D                 DS                                                                     207404
      *  Define fields for message transalation                                               207404
     D  #MSDTA                 1    132                                                       207404
     D  #MSTX1               133    264                                                       207404
     D #MSTX2          DS                                                                     207404
     D  #MSTXA                 1    256                                                       207404
     D  #MSTXB               257    512                                                       207404
                                                                                              CSC011
     D ValFieldsDS   E DS                  EXTNAME(FTV@OPAYPD)                                CSC011
      ** Validation Work Fields                                                               CSC011
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 Status DataArea Layout                                                          CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD Status DataArea Layout                                                            CSC011
      ** DS for Switchable Features details                                                   CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
      ** SCCMTJOB DataArea Layout                                                             CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WDSJobs                4    103A                                                      CSC022
      **                                                                                      CSC022
      ** CSC022 switchable field                                                              CSC022
     D CSC022          S              1A                                                      CSC022
      **                                                                                      CSC022
      ** CSC022 work fields                                                                   CSC022
     D WArrPtr         S              3S 0                                                    CSC022
     D WSkpComtRolbk   S              1A                                                      CSC022
      **                                                                                      CSC022
     D ULX608          S              1A   INZ('N')                                           CER001
     D ULX043          S              1A   INZ('N')                                           CER001
 
     D ErrorText       S             52    DIM(1) CTDATA PERRCD(1)
      ** Array containing messages
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D @TMESTPSEL      S             26Z
                                                                                              CSC011
      ** Message Type key field                                                               CSC011
     D KMTYP           S              8A                                                      CSC011
 
      ** SORC1/SORC2 Workfield                                                                CFT032
                                                                                              CFT032
     D WSorc           S             35A                                                      CFT032
                                                                                              CFT032
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
     C                   WRITE     FTIOPAYS0
     C                   MOVE      '0'           *IN97
      *
      **  Write the select screen footer to the screen.
      *
      **  If previous transaction was not successful due to deal being
      **  updated by another workstation then display message on screen
     C     @ERRUP        IFEQ      'Y'
     C                   MOVEL     ErrorText(1)  ERRORMSG
     C                   ELSE
     C                   MOVE      *BLANKS       ERRORMSG
     C**********         END                                                                  207404
      *                                                                                       207404
      ** If previous transaction inserted successfully,                                       207404
      ** then display message on screen                                                       207404
      *                                                                                       207404
     C     @SITR         IFNE      *BLANK                                                     207404
     C                   MOVEL     @SITR         #MSDTA                                       207404
     C** Retrieve the text for FTM2622 using MEC1150                                          207404
     C*                                                                                       207404
     C                   CALL      'MEC1150'                            9090                  207404
     C                   PARM      'FTM2622'     #MSGID            7                          207404
     C                   PARM      'FTUSRMSG'    #MsgFile         10                          207404
     C                   PARM                    #MSDTA                                       207404
     C                   PARM      *BLANKS       #MSTX1                                       207404
     C                   PARM      *BLANKS       #MSTX2                                       207404
     C                   MOVEL     #MSTX1        ERRORMSG                                     207404
     C                   MOVEL     *BLANK        @SITR                                        207404
     C                   END                                                                  207404
     C                   END                                                                  207404
      *
     C                   WRITE     FTIOPAYF1
      *
      **  Set file pointer to start of file
      *
     C     *LOVAL        SETLL     FTIOPAYL0
      *
      * READ AN INVALID PAYMENT
      *
     C                   EXSR      RDIPMNT
      *
      **  If no records exist - set up an error message.
      **  Display a message 'No invalid transactions present'
      **  then terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'FXM1007'     @ERRMS
     C                   EXFMT     FTIOPAYEND
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
      **  Write the invalid payment to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   MOVE      STMESTMP      D@TMESTMP
     C                   WRITE     FTIOPAYS1
      *
      * READ AN INVALID DEAL
      *
     C                   EXSR      RDIPMNT
     C                   END
      *
      **  Retrieve time
      *
     C                   TIME                    DDTIME
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     FTIOPAYS0
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      FTIOPAYS0                              99
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
     C                   READC     FTIOPAYS1                              99
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
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
      *
     C                   MOVE      DDOPT         @OPSEL
     C                   MOVE      SACTION       @ACSEL
     C                   MOVE      SFOTRANID     @FOTRANSEL
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
     C                   PARM                    SFOTRANID                      CAP014
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
     C     ZATRNKX0      CHAIN     FTIOPAYX0                          99        CAP014
      *                                                                                       CER001
     C                   IF        ULX608 = 'Y' AND ULX043 = 'Y'                              CER001
     C     ZATRNKDX      CHAIN     FTIOPLX1L0                         99                      CER001
     C                   EVAL      InvFile2 = 'FTOPRXPD'                                      CER001
     C                   MOVE      InvExt        InvRxt                                       CER001
     C                   EVAL      InvFdta2 = InvRxt                                          CER001
     C                   ENDIF                                                                CER001
     C/COPY WNCPYSRC,FTH00188
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
     C                   PARM                    SACTION                        CAP014
     C                   PARM                    SFOTRANID                      CAP014
     C                   PARM                    DDFOASOCID                     CAP014
     C                   PARM                    D@TMESTMP                      CAP014
                                                                                CAP014
      * Invalid file names                                                      CAP014
     C                   PARM      'FTIOPAYPD'   InvFile1         10            CAP014
     C                   PARM                    InvFile2         10            CAP014
     C                   PARM                    InvFile3         10            CAP014
                                                                                CAP014
      * Invalid file data                                                       CAP014
     C***********        PARM      InvTr         InvFDta1       2000            CAP014 CFT014
     C***********        PARM                    InvFDta2       2000            CAP014 CFT014
     C***********        PARM                    InvFDta3       2000            CAP014 CFT014
     C**********         PARM      InvTr         InvFDta1       4000                   CFT014 CFT039
     C                   PARM      InvTr         InvFDta1      12000                          CFT039
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
      *
                                                                                              CFT032
     C                   If        %Subst(SORC1:1:1) <> '/'                                   CFT032
     C                   Eval      WSorc = SORC1                                              CFT032
     C                   Else                                                                 CFT032
     C                   Eval      WSorc = SORC2                                              CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   CALLB     'ZAINVTRDEL'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Action code
     C                   PARM                    SACTION
      *
      * Front Office Trans ID & Front Office Associated Trans ID
     C                   PARM                    SFOTRANID
     C                   PARM      *BLANKS       DDFOASOCID       20
      *
      * Timestamp
     C                   PARM                    D@TMESTMP
      *
      * Narrative & Field Content 1 - 9
     C                   PARM                    DDNAR1           30
     C                   PARM      SPREF         DDFLD1           35
     C                   PARM                    DDNAR2           30
     C                   PARM      SPYTP         DDFLD2           35
     C                   PARM                    DDNAR3           30
     C                   PARM      SBRCA         DDFLD3           35
     C                   PARM                    DDNAR4           30
     C                   PARM      SDST1         DDFLD4           35
     C                   PARM                    DDNAR5           30
     C**********         PARM      SORC1         DDFLD5           35                          CFT032
     C                   PARM      WSorc         DDFLD5           35                          CFT032
     C                   PARM                    DDNAR6           30
     C                   PARM      SPCCY         DDFLD6           35
     C                   PARM                    DDNAR7           30
     C                   PARM      SPYAM         DDFLD7           35
     C                   PARM                    DDNAR8           30
     C                   PARM      SPYVD         DDFLD8           35
     C                   PARM                    DDNAR9           30
     C                   PARM      SSTTP         DDFLD9           35
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
      **  If F10, delete invalid payment
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C     ZAPMTKD0      CHAIN     FTIOPAYD0                          99
      *                                                                         186611
     C     *IN99         IFEQ      '0'                                          186611
     C                   MOVE      'D'           SACTION                        186611
     C                   MOVEL     *BLANKS       EntryData                      186611
     C                   MOVEL     *BLANKS       FileName                       186611
     C                   CALL      'RPC1600'                                    186611
     C                   PARM      InvTr         EntryData      3000            186611
     C                   PARM      'FTIOPAYPD'   FileName         10            186611
     C                   ENDIF                                                  186611
      *                                                                         186611
     C  N99              DELETE    FTIOPAYD0
     C/COPY WNCPYSRC,FTH00189
                                                                                              CSC011
      ** Delete invalid record from the log file.                                             CSC011
                                                                                              CSC011
     C                   IF        (@CSC011 = 'Y') AND (LIBR = S1SUPP)                        CSC011
     C                   EVAL      KMTYP = 'FTOPAY'                                           CSC011
     C     KLOGL0        CHAIN     APILOGL0                           99                      CSC011
      *                                                                                       CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGD0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CER001
     C     ULX608        IFEQ      'Y'                                                        CER001
     C     ULX043        ANDEQ     'Y'                                                        CER001
      *                                                                                       CER001
      ** Delete Records from Invalid File                                                     CER001
      *                                                                                       CER001
     C     ZATRNKDX      CHAIN     FTIOPLX1L0                         99                      CER001
     C  N99              DELETE    FTIOPLXDL                                                  CER001
     C                   ENDIF                                                                CER001
     C/COPY WNCPYSRC,FTH00139
      **                                                                                      CSC022
      ** Execute commit if SAR CSC022 is not enrolled or                                      CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDIPMNT - READ AN INVALID PAYMENT
      *****************************************************************
     C     RDIPMNT       BEGSR
      *
      **  Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      **  Read the file.
      *
     C                   READ      FTIOPAYL0                              96
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
     C/COPY WNCPYSRC,FTH00259
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
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
     C                   PARM                    ValFieldsDS                                  CSC011
      *                                                                                       207404
      ** Successful insert Payment                                                            207404
      *                                                                                       207404
     C                   PARM                    @SITR            15                          207404
     C                   PARM                    CSC022                                       CSC022
      *
      ** Initialize program name
      *
     C                   MOVEL     'FTIOPAYBRW'  DBPGM
      *
      ** Move workstation ID to screen field.
      *
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
      *
      * Key Lists
      *
     C     ZAPMTKD0      KLIST
     C                   KFLD                    SFOTRANID
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST                                                  CAP014
     C                   KFLD                    @TMESTPSEL                     CAP014
     C                   KFLD                    SFOTRANID                      CAP014
      *                                                                                       CSC011
     C     KLOGL0        KLIST                                                                CSC011
     C                   KFLD                    KMTYP                                        CSC011
     C                   KFLD                    SFOTRANID                                    CSC011
     C                   KFLD                    @TMESTPSEL                                   CSC011
     C/COPY WNCPYSRC,FTH00258
                                                                                              CSC011
      ** Get support system prefix and current system prefix                                  CSC011
                                                                                              CSC011
     C                   IF        @CSC011 = 'Y'                                              CSC011
     C                   OPEN      APILOGL0                             22                    CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ENDIF                                                                CSC011
      **                                                                                      CSC022
      ** Initialize Commit/Skip Flag                                                          CSC022
     C                   Eval      WSkpComtRolbk = 'N'                                        CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'Y'                                               CSC022
      **                                                                                      CSC022
      ** Get Jobs currently running i batch mode using SCCMRJOB dataarea                      CSC022
      **                                                                                      CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
      ** Move committed jobs to arrary for checking                                           CSC022
     C                   MoveA     WDSJobs       WJobs                                        CSC022
      ** Verify if job running exists in array                                                CSC022
     C                   Eval      WArrPtr = %LookUp(PSJobName:WJobs)                         CSC022
     C                   If        WArrPtr > 0                                                CSC022
     C                   Eval      WSkpComtRolbk = 'Y'                                        CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      **                                                                                      CSC022
     C/COPY WNCPYSRC,FTH00190
 
      * FORMAT TEXT FOR INVALID TRANSACTION DELETION FUNCTION
      *
     C                   MOVEL     'APA0131'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR1
     C                   MOVEL     'APA0132'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR2
     C                   MOVEL     'APA0133'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR3
     C                   MOVEL     'APA0134'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR4
     C                   MOVEL     'APA0135'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR5
     C                   MOVEL     'APA0136'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR6
     C                   MOVEL     'APA0137'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR7
     C                   MOVEL     'APA0138'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR8
     C                   MOVEL     'APA0139'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR9
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX608                                       CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX608'      @SARD                                        CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVEL     'Y'           ULX608                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *Blanks AND                                       CER001
     C                             @RTCD <> '*NRF   '                                         CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   MOVEL     '100'         DBASE                                        CER001
     C                   MOVEL     'ULX608'      DBKEY                                        CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX043 - New IBLC 2002 as feature                                                    CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX043                                       CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX043'      @SARD                                        CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVEL     'Y'           ULX043                                       CER001
      *                                                                                       CER001
      ** Open Invalid File                                                                    CER001
      *                                                                                       CER001
     C                   OPEN      FTIOPLX1L0                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *Blanks AND                                       CER001
     C                             @RTCD <> '*NRF   '                                         CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   MOVEL     '101'         DBASE                                        CER001
     C                   MOVEL     'ULX043'      DBKEY                                        CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
     C/COPY WNCPYSRC,FTH00140
      *                                                                                       CER001
     C     ZATRNKDX      KLIST                                                                CER001
     C                   KFLD                    @TMESTPSEL                                   CER001
     C                   KFLD                    SFOTRANID                                    CER001
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
(c) Misys International Banking Systems Ltd. 2001
**  Array of error messages - ErrorText
The last transaction was not applied to the database
