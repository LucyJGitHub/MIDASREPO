     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Invalid customer details browse')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDCUSDRPB - Invalid Customers Browse                         *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of invalid customers for selection*
      *             the other picks off the selection made.           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 247154             Date 19Apr07               *
      *                 CSW207A            Date 07Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW207             Date 06Jul07               *
      *                 CSD031             Date 10Apr06               *
      *                 CER001             Date 25Apr05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSD018             Date 27Nov02               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 CSW024             Date 31Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CRE007             Date 01Mar01               *
      *                 186611             Date 21Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP014             Date 09Dec99               *
      *                 CAP034  *CREATE    Date 14Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247154 - Adjust Valid Branch validation to use correct field.*
      *           Applied fix 242019.                                 *
      *  CSW207A - SWIFT 2007 Changes                                 *
      *  CSW207 - SWIFT 2007 Changes (Recompile)                      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CGL031 - Taxation on Savings Income (Recompile)              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSD018 - Restrict Access to Customers By Branch.             *
      *  CSC011 - 24X7 Midas Availability                             *
      *  CSW024 - S.W.I.F.T. MT3xx Field 82/83/87 (Recompiled).       *
      *  CRE007 -  Base Rate Tax 2001 - Recompile.                    *
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
      *  CAP034 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDCUSDRDF CF   E             WORKSTN
     F                                     SFILE(SDCUSDS1:@@RRN)
     FSDICUSDL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDICUSDD0:SDICUSDX0)
     F**                                   PREFIX(C:2)                          CAP014
     FSDICUSDL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FSDICUBRL0 IF   E           K DISK    INFSR(*PSSR)                         CAP014
     F                                     RENAME(SDICUBRD0:SDICUBRX0)          CAP014
     F                                     PREFIX(B:2)                          CAP014
     FSDICUBRL1 UF   E           K DISK    INFSR(*PSSR) COMMIT
 
     FSDICUPBL0 IF   E           K DISK    INFSR(*PSSR)                         CAP014
     F                                     RENAME(SDICUPBD0:SDICUPBX0)          CAP014
     F                                     PREFIX(P:2)                          CAP014
     FSDICUPBL1 UF   E           K DISK    INFSR(*PSSR) COMMIT
     F                                     PREFIX(R:2)                          186611
                                                                                             CSW207A
     FSDISWFDL0 IF   E           K DISK    INFSR(*PSSR)                                      CSW207A
     F                                     RENAME(SDISWFDD0:SDISWFXD0)                       CSW207A
     FSDISWFDL1 UF   E           K DISK    INFSR(*PSSR) COMMIT                               CSW207A
                                                                                              CSC011
      ** API Invalid Log File from Support Database                                           CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
                                                                                              CSC011
     FSDICULX2L0UF   E           K DISK    USROPN                                             CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
     FSDICULX1L0UF   E           K DISK    USROPN                                             CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
                                                                                              CER001
      * Invalid Customers Details extra data file                                             CER001
     FSDICEXL1  UF A E           K DISK    INFSR(*pssr) USROPN                                CER001
     F                                     COMMIT                                             CER001
     **  Valid Booking Branches by User.                                                      CSD018
     FMBRBS     IF   E           K DISK    INFSR(*PSSR)                                       CSD018
                                                                                              CSD018
     F/COPY WNCPYSRC,SDCUSDBF01
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
                                                                                             CSW207A
      ** Swift installed flag                                                                CSW207A
     D CSW207          S              1A                                                     CSW207A
     D PRtCd           S              7A                                                     CSW207A
                                                                                             CSW207A
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
     D/COPY WNCPYSRC,SDCUSDBD01
      *                                                                                       CER001
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CER001
      ** External data structures for Midas Modules                                           CER001
                                                                                              CER001
                                                                                CAP014
     D*WWVBRA***       S              3    DIM(100) ASCEND                             CSD018 247154
     D WWVBRX          S              3    DIM(900) ASCEND                                    247154
                                                                                              CSD018
     D InvCd         E DS                  EXTNAME(SDICUSDPD)                   CAP014
     D InvBr         E DS                  EXTNAME(SDICUBRPD)                   CAP014
     D                                     PREFIX(B:2)                          CAP014
     D InvPb         E DS                  EXTNAME(SDICUPBPD)                   CAP014
     D                                     PREFIX(P:2)                          CAP014
     D InvRp         E DS                  EXTNAME(SDICUPBPD)                   186611
     D                                     PREFIX(R:2)                          186611
     D InvSw         E DS                  EXTNAME(SDISWSDPD)                                CSW207A
     D                                     PREFIX(Q:2)                                       CSW207A
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
                                                                                              CSD018
      ** Customer Details                                                                     CSD018
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSD018
                                                                                              CSD018
      ** External DS for SAR Details                                                          CSD018
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD018
                                                                                              CSD018
      **  Long DS for access programs                                                         CSD018
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSD018
                                                                                              CSD018
      **  Third DS for access programs, very long data structure                              CSD018
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     CSD018
                                                                                              CSD018
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
     C                   WRITE     SDCUSDS0
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
     C                   WRITE     SDCUSDF1
      *
      **  Set file pointer to start of file
      *
     C     *LOVAL        SETLL     SDICUSDL0
      *
      * READ AN INVALID CUSTOMER
      *
     C                   EXSR      RDICUST
      *
      **  If no records exist - set up an error message.
      **  Display a message 'No invalid transactions present'
      **  then terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'FXM1007'     @ERRMS
     C                   EXFMT     SDCUSDEND
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
     C/COPY WNCPYSRC,SDCUSDPC01
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      **  Write the invalid customer to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   MOVE      DDTMESTMP     D@TMESTMP
     C                   WRITE     SDCUSDS1
     C/COPY WNCPYSRC,SDCUSDPC02
      *
      * READ AN INVALID CUSTOMER
      *
     C                   EXSR      RDICUST
     C                   END
      *
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     SDCUSDS0
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      SDCUSDS0                               99
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
     C                   READC     SDCUSDS1                               99
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
     C                   MOVE      DDCUSN        @CUST                         CAP014
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
     C     ZATRNKX0      CHAIN     SDICUSDX0                          99        CAP014
     C                   CLEAR                   InvBr                          CAP014
     C     ZATRNKX0      CHAIN     SDICUBRX0                          99        CAP014
     C                   CLEAR                   InvPb                          CAP014
     C     ZATRNKX0      CHAIN     SDICUPBX0                          99        CAP014
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                              CSW207A
     C                   CLEAR                   InvSw                                       CSW207A
     C     ZATRNKX0      CHAIN     SDISWFXD0                          99                     CSW207A
     C                   ENDIF                                                               CSW207A
     C/COPY WNCPYSRC,SDCUSDPC03
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
     C                   PARM                    DDFOTRANID                     CAP014
     C                   PARM                    DDFOASOCID                     CAP014
     C                   PARM                    D@TMESTMP                      CAP014
                                                                                CAP014
      * Invalid file names                                                      CAP014
     C                   PARM      'SDICUSDPD'   InvFile1         10            CAP014
     C                   PARM      'SDICUBRPD'   InvFile2         10            CAP014
     C                   PARM      'SDICUPBPD'   InvFile3         10            CAP014
                                                                                CAP014
      * Invalid file data                                                       CAP014
     C***********        PARM      InvCd         InvFDta1       2000            CAP014 CFT014
     C***********        PARM      InvBr         InvFDta2       2000            CAP014 CFT014
     C***********        PARM      InvPb         InvFDta3       2000            CAP014 CFT014
     C                   PARM      InvCd         InvFDta1       4000            CFT014
     C                   PARM      InvBr         InvFDta2       4000            CFT014
     C**********         PARM      InvPb         InvFDta3       4000            CFT014       CSW207A
     C                   PARM      InvPb         InvFDta3       5000                         CSW207A
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
     C                   PARM      DDCUSN        DDFLD1           35
     C                   PARM                    DDNAR2           30
     C                   PARM      DDCSSN        DDFLD2           35
     C                   PARM                    DDNAR3           30
     C                   PARM      DDDRCS        DDFLD3           35
     C                   PARM                    DDNAR4           30
     C                   PARM      DDCRNM        DDFLD4           35
     C                   PARM                    DDNAR5           30
     C                   PARM      DDCRTN        DDFLD5           35
     C                   PARM                    DDNAR6           30
     C                   PARM      DDCNA1        DDFLD6           35
     C                   PARM                    DDNAR7           30
     C                   PARM      DDCNA2        DDFLD7           35
     C                   PARM                    DDNAR8           30
     C                   PARM      DDCNA3        DDFLD8           35
     C                   PARM                    DDNAR9           30
     C                   PARM      DDCNA4        DDFLD9           35
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
      **  If F10, delete invalid customer
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C     ZATRNKD0      CHAIN     SDICUSDD0                          99
     C  N99              DELETE    SDICUSDD0
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                              CSW207A
     C     ZATRNKD0      CHAIN     SDISWFDD0                          99                     CSW207A
     C  N99              DELETE    SDISWFDD0                                                 CSW207A
     C                   ENDIF                                                               CSW207A
     C     ZATRNKD0      CHAIN     SDICUBRD0                          99
     C  N99              DELETE    SDICUBRD0
     C     ZATRNKD0      CHAIN     SDICUPBD0                          99
      *                                                                         186611
     C     *IN99         IFEQ      '0'                                          186611
     C                   MOVE      'D'           RACTN                          186611
     C                   MOVEL     *BLANKS       EntryData                      186611
     C                   MOVEL     *BLANKS       FileName                       186611
     C                   CALL      'RPC1600'                                    186611
     C                   PARM      InvRp         EntryData      3000            186611
     C                   PARM      'SDICUPBPD'   FileName         10            186611
     C                   ENDIF                                                  186611
      *                                                                         186611
     C  N99              DELETE    SDICUPBD0
     C     ULX609        IFEQ      'Y'                                                        CER001
     C     ULX004        ANDEQ     'Y'                                                        CER001
     C     ZATRNKDX      CHAIN     SDICULX2L0                         99                      CER001
     C  N99              DELETE    SDICULXD6                                                  CER001
     C                   ENDIF                                                                CER001
     C     ULX043        IFEQ      'Y'                                                        CER001
     C     ZATRNKDX      CHAIN     SDICULX1L0                         99                      CER001
     C  N99              DELETE    SDICULXDL                                                  CER001
     C                   ENDIF                                                                CER001
     C                   If        PB3610 = 'Y'                                               CER001
     C                   MOVE      @FOTRANSEL    WWFRNT           20                          CER001
     C     WWFRNT        CHAIN     SDICEXL1                           99                      CER001
     C  N99              Delete    SDICEXD0                                                   CER001
     C                   EndIf                                                                CER001
     C/COPY WNCPYSRC,SDCUSDBC01
                                                                                              CSC011
      ** Delete invalid record from the log file.                                             CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR                             CSC011
                                                                                              CSC011
     C                   EVAL      KMsgType = 'SDCUSD'                                        CSC011
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
      * RDICUST - READ AN INVALID CCUSTOMER
      *****************************************************************
     C     RDICUST       BEGSR
      *
      **  Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
     C     @@EOF         DOUEQ     'Y'                                                        CSD018
     C     WSHOW         OREQ      'Y'                                                        CSD018
      *                                                                                       CSD018
      **  Read the file.
      *
     C                   READ      SDICUSDL0                              96
      *
      ** Determine if details should be shown                                                 CSD018
     C                   EXSR      SRSHOW                                                     CSD018
      *                                                                                       CSD018
      * End of File
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   END
      *                                                                                       CSD018
     C                   ENDDO                                                                CSD018
      *                                                                                       CSD018
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
     C                   MOVE      *BLANK        @CUST                          CAP014
     C                   MOVE      *BLANK        @FOTRANSEL
     C                   CLEAR                   @TMESTPSEL
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
      *
     C                   ENDSR
                                                                                              CSD018
      *****************************************************************                       CSD018
      * SRSHOW - Determine if details should be shown                                         CSD018
      *****************************************************************                       CSD018
     C     SRSHOW        BEGSR                                                                CSD018
                                                                                              CSD018
     C                   MOVE      'Y'           WSHOW             1                          CSD018
     C     CSD018        IFEQ      'Y'                                                        CSD018
      *                                                                                       CSD018
      ** When building the sub-file of Securities Clients Details,                            CSD018
      *  do not include the records if the branch code of the customer                        CSD018
      *  being processed does not exist for this Midas user on file                           CSD018
      *  MBRBSDD.                                                                             CSD018
      *                                                                                       CSD018
      * Check if the User is authorized to the branch code of the                             CSD018
      * Customer being processed.                                                             CSD018
      *                                                                                       CSD018
     C     PsUser        CHAIN     MBRBS                              74                      CSD018
      *                                                                                       CSD018
     C     *IN74         IFEQ      '0'                                                        CSD018
     C     RECI          ANDEQ     'D'                                                        CSD018
     C**********         MOVEA     VBRA          WWVBRA                                CSD018 247154
     C                   MOVEA     VBRX          WWVBRX                                       247154
     C*****DDBRCD        LOOKUP    WWVBRA                                 73           CSD018 247154
     C     DDBRCD        LOOKUP    WWVBRX                                 73                  247154
     C     *IN73         IFEQ      *OFF                                                       CSD018
     C                   MOVE      'N'           WSHOW                                        CSD018
     C                   ENDIF                                                                CSD018
     C                   ENDIF                                                                CSD018
      *                                                                                       CSD018
     C                   ENDIF                                                                CSD018
                                                                                              CSD018
     C                   ENDSR                                                                CSD018
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
                                                                                              CSC011
      ** CSC011 indicator                                                                     CSC011
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
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
      * Customer Number
     C                   PARM                    @CUST             6
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM                    @INKC
     C                   PARM                    @INKL
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDCUSDRPB'   DBPGM
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
     C     ZATRNKX0      KLIST                                                  CAP014
     C                   KFLD                    @TMESTPSEL                     CAP014
     C                   KFLD                    DDFOTRANID                     CAP014
                                                                                              CSC011
     C     KAPILOGL0     KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011
      *
      * FORMAT TEXT FOR INVALID TRANSACTION DELETION FUNCTION
      *
     C                   MOVEL     'ZZN6682'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR1
     C                   MOVEL     'ZZN6683'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR2
     C                   MOVEL     'ZZN6684'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR3
     C                   MOVEL     'ZZN6685'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR4
     C                   MOVEL     'ZZN6684'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR5
     C                   MOVEL     'ZZN6681'     MSGDNB
     C                   EXSR      RTVTXT
     C                   MOVEL     MSGTXT        DDNAR6
     C                   MOVEL     *BLANK        DDNAR7
     C                   MOVEL     *BLANK        DDNAR8
     C                   MOVEL     *BLANK        DDNAR9
     C/COPY WNCPYSRC,SDCUSDBC02
      *
      ** Access SAR details to check if CSD018 is installed                                   CSD018
     C                   CALLB     'AOSARDR0'                                                 CSD018
     C                   PARM      *BLANKS       @RTCD             7                          CSD018
     C                   PARM      '*VERIFY'     @OPTN             7                          CSD018
     C                   PARM      'CSD018'      @SARD             6                          CSD018
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD018
                                                                                              CSD018
     C     @RTCD         IFNE      *BLANKS                                                    CSD018
     C     @RTCD         ANDNE     '*NRF   '                                                  CSD018
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSD018
     C                   MOVEL     '902'         DBASE                                        CSD018
     C                   MOVEL     @SARD         DBKEY                                        CSD018
     C                   EXSR      *PSSR                                                      CSD018
     C                   ENDIF                                                                CSD018
                                                                                              CSD018
     C     @RTCD         IFEQ      *BLANKS                                                    CSD018
     C                   MOVEL     'Y'           CSD018            1                          CSD018
     C                   ELSE                                                                 CSD018
     C                   MOVEL     'N'           CSD018                                       CSD018
     C                   ENDIF                                                                CSD018
      *                                                                                       CSD018
      ** Access Module Details to verify if ULX609 is active                                  CER001
      *                                                                                       CER001
     C                   CALL      'AOMMODR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*FIRST '     @OPTN                                        CER001
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CER001
      *                                                                                       CER001
      ** ULX004 - European Reporting as Feature                                               CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX004            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX004'                                          CER001
     C                   EVAL      DBASE  = 903                                               CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVEL     'Y'           ULX004                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX609 - API Luxembourg - Function SDCUSD                                            CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX609            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX609'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX609'                                          CER001
     C                   EVAL      DBASE  = 904                                               CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C     BGLRIN        ANDEQ     'Y'                                                        CER001
     C                   MOVEL     'Y'           ULX609                                       CER001
     C                   OPEN      SDICULX2L0                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX043 - IBLC 2002 as feature                                                        CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX043            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX043'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX043'                                          CER001
     C                   EVAL      DBASE  = 905                                               CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVEL     'Y'           ULX043                                       CER001
     C                   OPEN      SDICULX1L0                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     ZATRNKDX      KLIST                                                                CER001
     C                   KFLD                    @TMESTPSEL                                   CER001
     C                   KFLD                    DDFOTRANID                                   CER001
      *                                                                                       CER001
      ** Access SAR details file to check Customer Extended details Default                   CER001
      **  (PB3610) is switched on                                                             CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'PB3610'      @SARD             6                          CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'PB3610'                                          CER001
     C                   EVAL      DBASE  = 906                                               CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANK                                                     CER001
     C                   MOVEL     'Y'           PB3610            1                          CER001
     C                   OPEN      SDICEXL1                                                   CER001
     C                   ELSE                                                                 CER001
     C                   MOVEL     'N'           PB3610                                       CER001
     C                   ENDIF                                                                CER001
                                                                                             CSW207A
      ** Check if SWIFT 2007 is installed                                                    CSW207A
                                                                                             CSW207A
     C                   CALL      'SWIF2007'                                                CSW207A
     C                   PARM      *BLANKS       PRtCd                                       CSW207A
                                                                                             CSW207A
     C                   IF        PRtCd = 'CSW2007'                                         CSW207A
     C                   EVAL      CSW207 = 'Y'                                              CSW207A
     C                   ELSE                                                                CSW207A
     C                   EVAL      CSW207 = 'N'                                              CSW207A
     C                   ENDIF                                                               CSW207A
                                                                                             CSW207A
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
