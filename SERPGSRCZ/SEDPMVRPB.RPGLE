     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Depot movements repair browse')               *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEDPMVRPB - Securities Invalid Transactions Browse           *
      *              Function Module.                                 *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of deals for selection,        *
      *             the other picks off the selection made.           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD041294           Date 19Sep16               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CER001             Date 25Apr05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *  Prev Amend No. 209009             Date 03Sep02               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 207006             Date 18Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 186611             Date 21Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 166907             Date 03Jan00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE015             Date 06Dec99               *
      *                 CSE017             Date 20Oct99               *
      *                 CAP014             Date 29Nov99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             Date 17Mar99               *
      *                 CAP004             Date 01Sep98               *
      *  Prev Amend No. CAP003  *CREATE    Date 26May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041294 - Customer extension details is missing in          *
      *             CUSD repair browse                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  207006 - Add Counterparty & Market Centre to SSI (Recompile) *
      *  CSC011 - 24x7 Midas Availability                             *
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
      *           in the correct screen.  Remove validations when     *
      *           passing value to @OptSel.                           *
      *  CSE015 - Forward Valued Depot Movements (Recompile)          *
      *  CSE017 - Cum/Ex Indicator on Depot Movements (Recompile)     *
      *  CAP014 - Repair function enhancements                        *
      *  CAP006 - Display message if prev transaction not successful  *
      *           due to  deal being updated by another workstation   *
      *  CAP004 - API's Phase 3.                                      *
      *           Enable delete of invalid transactions               *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSEDPMVRDF CF   E             WORKSTN
     F                                     SFILE(SEDPMVRS1:@@RRN)
     FSEIDPMVL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEIDPMVD0:SEIDPMVX0)          CAP004
     FSEIDPMVL1 UF   E           K DISK    INFSR(*PSSR)                         CAP004
     F                                     COMMIT                               CAP004
                                                                                              CSC011
      ** API Invalid Log File                                                                 CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
 
     FSEIDMLX1L0UF   E           K DISK    USROPN                                             CER001
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
 
      ** Include the FX standard declares
     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
     D/COPY ZACPYSRC,STDDECLARE                                                               209009
 
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
 
      ** External data structures for Midas Modules                                           CER001
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CER001
                                                                                              CER001
     D InvTr         E DS                  EXTNAME(SEIDPMVPD)                   CAP014
     D InvExt        E DS                  EXTNAME(SEIDMLX1PD)                                CER001
     D InvRxt        E DS                  EXTNAME(SEDMRXPD)                                  CER001
 
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD Data Area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
      ** External DS for Bank Details
      ** General ledger details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** DS for Access programs, short DS
      ** DS for Access Programs, long DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Successful Insert Deal Number                                          166907
     D                 DS                                                       166907
     D  DDFOTX                 1     40                                         166907
     D  DDSIDN                11     16                                         166907
                                                                                              CSC022
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
     D  ComitJob               4    103                                                       CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
                                                                                              CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
      ** DS for SAR Detail record                                                             CSC022
                                                                                166907
     D*ErrorText*******S*************52    DIM(1) CTDATA PERRCD(1)       CAP006 166907
     D ErrorText       S             52    DIM(2) CTDATA PERRCD(1)              166907
      ** Array containing messages                                              CAP006
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @TStmpSel       S             26Z
     D CSC011          S              1A                                                      CSC011
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KTimeStamp      S                   LIKE(@TStmpSel)                                    CSC011
                                                                                              CSC022
     D CSC022          S              1A                                                      CSC022
                                                                                              CSC022
     D WCommitSkip     S              1A                                                      CSC022
      ** Commitment Skip Field                                                                CSC022
 
      ** Introduced by CER001                                                                 CER001
      *                                                                                       CER001
     D ULX602          S              1A                                                      CER001
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
      ** Initialization
      *
     C                   EXSR      SRInit
      *
      ** Build sub-file
      *
     C     @BldSfl       IFEQ      'Y'
     C                   EXSR      SRBldSfl
     C                   END
      *
      ** Read Subfile Record
      *
     C     @RdSfl        IFEQ      'Y'
     C                   EXSR      SRRdSfl
     C                   END
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldSfl - SubFile Details Generation Routine                 *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRBldSfl      BEGSR
      *
      ** Check for user authority to Browse if Not Multi-Branching.
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      SRChkAut
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
     C                   WRITE     SEDPMVRS0
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
     C     @SIDN         IFNE      *BLANK                                       166907
     C                   MOVEL     ErrorText(2)  DDFOTX                         166907
     C                   MOVEL     @SIDN         DDSIDN                         166907
     C                   MOVE      *BLANK        @SIDN                          166907
     C                   MOVEL     DDFOTX        ERRORMSG                       166907
     C                   END                                                    166907
     C                   END                                                    CAP006
      *                                                                         CAP006
     C                   WRITE     SEDPMVRF1
      *
      **  Set file pointer to start of file
      *
     C     *LOVAL        SETLL     SEIDPMVL0
      *
      ** Read an Invalid Transaction
      *
     C                   EXSR      SRRdTrans
      *
      ** If no records exist - set up an error message.
      ** and terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   TIME                    DDTIME
     C                   MOVE      PSRUNDATE     RUNDATE
     C                   MOVE      'FXM1007'     @ERRMS
     C                   EXFMT     SEDPMVREND
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
      ** Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     14
      *
      ** Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ** Format Deal fields for output
      *
     C                   EXSR      SRFmtDet
      *
      **  Write the deal to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     SEDPMVRS1
      *
      ** Read a valid deal
      *
     C                   EXSR      SRRdTrans
     C                   END
      *
      **  Retrieve time & date
      *
     C                   TIME                    DDTIME
     C                   MOVE      PSRUNDATE     RUNDATE
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     SEDPMVRS0
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      SEDPMVRS0                              99
      *
      **  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   EVAL      *INLR = '1'
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdSfl - SubFile Details Generation Routine                  *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRRdSfl       BEGSR
      *
      ** Read the subfile for selected records
      ** Only process those for which the option field is not blank.
      *
     C     *IN99         DOUEQ     '1'
     C     DDOPT         ORNE      *BLANK
     C                   READC     SEDPMVRS1                              99
      *                                                                         CAP004
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
     C                   MOVE      D@TMESTMP     @TStmpSel                      CAP014
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
      **  Return the key fields and option of the selected transaction.
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
      *
     C*****DDOPT*********IFEQ      'A'                                          166907
     C*****DDOPT*********OREQ      'D'                                          166907
     C*****DDOPT*********OREQ      'I'                                          166907
     C                   MOVE      DDOPT         @OptSel
     C**********         ELSE                                                   166907
     C**********         MOVE      'E'           @OptSel                        166907
     C**********         END                                                    166907
      *
     C                   MOVE      DDFRONTID     @FrntIdSel
     C                   MOVE      D@TMESTMP     @TStmpSel
     C                   MOVE      DDACTN        @ActSel
     C                   MOVE      DDDPRN        @DPRNSel
     C                   MOVE      DDDPSS        @DPSSSel
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
     C                   PARM                    DDFRONTID                      CAP014
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
     C     ZATRNKX0      CHAIN     SEIDPMVX0                          99        CAP014
      *
     C                   IF        ULX602 = 'Y'                                               CER001
     C     ZATRNKX0      CHAIN     SEIDMLXD6                          99                      CER001
     C                   EVAL      InvFile2 = 'SEDMRXPD'                                      CER001
     C                   MOVE      InvExt        InvRxt                                       CER001
     C                   EVAL      InvFDta2 = InvRxt                                          CER001
     C                   ENDIF                                                                CER001
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
     C                   PARM                    DDFRONTID                      CAP014
     C                   PARM                    DDFOASOCID                     CAP014
     C                   PARM                    D@TMESTMP                      CAP014
                                                                                CAP014
      * Invalid file names                                                      CAP014
     C                   PARM      'SEIDPMVPD'   InvFile1         10            CAP014
     C                   PARM                    InvFile2         10            CAP014
     C                   PARM                    InvFile3         10            CAP014
     C                   PARM      *Blanks       InvFile4         10                        MD041294
                                                                                CAP014
      * Invalid file data                                                       CAP014
     C***********        PARM      InvTr         InvFDta1       2000            CAP014 CFT014
     C***********        PARM                    InvFDta2       2000            CAP014 CFT014
     C***********        PARM                    InvFDta3       2000            CAP014 CFT014
     C                   PARM      InvTr         InvFDta1       4000            CFT014
     C                   PARM                    InvFDta2       4000            CFT014
     C                   PARM                    InvFDta3       4000            CFT014
     C                   PARM      *Blanks       InvFDta4       4000                        MD041294
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
     C                   PARM                    DDFRONTID                      CAP004
     C                   PARM                    DDFOASOCID       20            CAP004
      *                                                                         CAP004
      * Timestamp                                                               CAP004
     C                   PARM                    D@TMESTMP                      CAP004
      *                                                                         CAP004
      * Narrative & Field Content 1 - 9                                         CAP004
     C                   PARM                    DDNAR1           30            CAP004
     C                   PARM      DDDPRN        DDFLD1           35            CAP004
     C                   PARM                    DDNAR2           30            CAP004
     C                   PARM      DDDPSS        DDFLD2           35            CAP004
     C                   PARM                    DDNAR3           30            CAP004
     C                   PARM      DDDEPOT       DDFLD3           35            CAP004
     C                   PARM                    DDNAR4           30            CAP004
     C                   PARM      DDDATE        DDFLD4           35            CAP004
     C                   PARM                    DDNAR5           30            CAP004
     C                   PARM      DDDPBN        DDFLD5           35            CAP004
     C                   PARM                    DDNAR6           30            CAP004
     C                   PARM      DDDPNA        DDFLD6           35            CAP004
     C                   PARM                    DDNAR7           30            CAP004
     C                   PARM      DDMKTP        DDFLD7           35            CAP004
     C                   PARM                    DDNAR8           30            CAP004
     C                   PARM                    DDFLD8           35            CAP004
     C                   PARM                    DDNAR9           30            CAP004
     C                   PARM                    DDFLD9           35            CAP004
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
      **  If F10, delete invalid depot movement                                 CAP004
      *                                                                         CAP004
     C     @INKJ         IFEQ      '1'                                          CAP004
     C                   MOVE      D@TMESTMP     @TSTMPSEL                      CAP004
     C     ZATRNKD0      CHAIN     SEIDPMVD0                          99        CAP004
      *                                                                         186611
     C     *IN99         IFEQ      '0'                                          186611
     C                   MOVE      'D'           DDACTN                         186611
     C                   MOVEL     *BLANKS       EntryData                      186611
     C                   MOVEL     *BLANKS       FileName                       186611
     C                   CALL      'RPC1600'                                    186611
     C                   PARM      InvTr         EntryData      3000            186611
     C                   PARM      'SEIDPMVPD'   FileName         10            186611
     C                   ENDIF                                                  186611
      *                                                                         186611
     C  N99              DELETE    SEIDPMVD0                                    CAP004
                                                                                              CSC011
      ** Delete invalid record from the log file.                                             CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' and LIBR = S1SUPP                             CSC011
                                                                                              CSC011
     C                   IF        DPMVType = 'WI'                                            CSC011
     C                   EVAL      KMsgType = 'SEDMWI'                                        CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      KMsgType = 'SEDMWO'                                        CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   EVAL      KFrntOffID = DDFRONTID                                     CSC011
     C                   EVAL      KTimeStamp = @TSTMPSEL                                     CSC011
                                                                                              CSC011
     C     KAPILOGL0     CHAIN     APILOGL0                           99                      CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CER001
     C                   IF        ULX602 = 'Y'                                               CER001
     C     ZATRNKDX      CHAIN     SEIDMLXD6                          99                      CER001
      *                                                                                       CER001
     C                   IF        *IN99 = *OFF                                               CER001
     C                   DELETE    SEIDMLXD6                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
                                                                                              CSC011
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
      *                                                               *
      * SRFmtDet - Routine to move the file format transaction to     *
      *            Screen format.                                     *
      *                                                               *
      * Called by: SRBldSfl                                           *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      ******************************************************************
 
     C     SRFmtDet      BEGSR
 
 
     C                   MOVE      FOFFID        DDFRONTID
     C                   MOVE      DDTSTMP       D@TMESTMP
 
     C                   ENDSR
 
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdTrans- Subroutine to Retrieve a valid Record from the     *
      *            Transaction file.                                  *
      *                                                               *
      * Called by: SRBldSfl                                           *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRRdTrans     BEGSR
      *
      **  Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      **  Read the file initially - if @@EOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.
      *
     C     @@EOF         DOUEQ     'Y'
     C     DDDPMV        OREQ      DPMVType
     C
      *
      **  Read the file.
      *
     C                   READ      SEIDPMVL0                              96
      *
      ** End of File
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   END
 
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkAut - Subroutine to Check for user's Authority           *
      *                                                               *
      * Called by: SRBldSfl                                           *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
     C     SrChkAut      BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      ** Return Error Message
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
      *                                                               *
      * SRInit- Initializtion Routine                                 *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
      *                                                                                       CSC011
      * If 24x7 is present then journal APILOGL0                                              CSC011
      *                                                                                       CSC011
     C                   IF        (CSC011 = 'Y')                                             CSC011
     C                   OPEN      APILOGL0                             22                    CSC011
     C                   ENDIF                                                                CSC011
      *
      ** Clear Outputs
      *
     C                   MOVE      *BLANK        @ERRMS
     C                   MOVE      *BLANK        @OptSel
     C                   MOVE      *BLANK        @ActSel
     C                   MOVE      *BLANK        @FrntIdSel
     C                   CLEAR                   @TStmpSel
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - Exception Errors                                      *
      *                                                               *
      * Called by: *InzSR                                             *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
      *
      **  Terminte the program
      *
     C                   EXSR      *PSSR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *InzSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *InzSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Received Parameters
      ** -------------------
      *
      ** Build SubFile Indicator
      ** Read SubFile Indicator
     C                   PARM                    DPMVType          2
     C                   PARM                    @BldSfl           1
     C                   PARM                    @RdSfl            1
      * Error in update of previous deal                                        CAP006
     C                   PARM                    @ERRUP            1            CAP006
      *                                                                         CAP006
      ** Returned Parameters
      ** -------------------
      *
      ** Command Keys
      ** F3
      ** F12
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      ** Error Code
      *
     C                   PARM                    @ERRMS            7
      ** Option Selected
      ** Action Code Selected
      ** Front Office Id Selected
      ** Time Stamp of the selected Transaction
      ** Transaction Reference Number Selected
      ** Security Shortname Selected
     C                   PARM                    @OptSel           1
     C                   PARM                    @ActSel           1
     C                   PARM                    @FrntIdSel       20
     C                   PARM                    @TStmpSel
     C                   PARM                    @DPRNSel          6
     C                   PARM                    @DPSSSel         10
      *                                                                         166907
      ** Successful Insert Deal Number                                          166907
      *                                                                         166907
     C                   PARM                    @SIDN             6            166907
     C                   PARM                    CSC011                                       CSC011
 
     C                   MOVEL     'SEIDPMVBRW'  DBPGM
      *
      ** ICD Information Retrieval
      ** -------------------------
      *
      ** Initialize program name
      *
     C                   MOVEL     'SEDPMVBRW'   DBPGM
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     DDWID
      *
      ** Access SDSTAT and SC24X7 if CSC011 is installed                                      CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** Get Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '900'         DBASE                          * DBERR 900*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      ** Get General Ledger ICD
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   EXSR      SRERR                                        ************
     C                   END
      *                                                                         CAP004
      * Key Lists                                                               CAP004
      *                                                                         CAP004
     C     ZATRNKD0      KLIST                                                  CAP004
     C                   KFLD                    DDFRONTID                      CAP004
     C                   KFLD                    @TSTMPSEL                      CAP004
     C     ZATRNKX0      KLIST                                                  CAP014
     C                   KFLD                    @TStmpSel                      CAP014
     C                   KFLD                    DDFRONTID                      CAP014
      *                                                                         CAP004
     C     KAPILOGL0     KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011
                                                                                              CSC011
      * FORMAT TEXT FOR INVALID TRANSACTION DELETION FUNCTION                   CAP004
      *                                                                         CAP004
     C                   MOVEL     'APA0081'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR1                         CAP004
     C                   MOVEL     'APA0082'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR2                         CAP004
     C                   MOVEL     'APA0083'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR3                         CAP004
     C                   MOVEL     'APA0084'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR4                         CAP004
     C                   MOVEL     'APA0085'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR5                         CAP004
     C                   MOVEL     'APA0086'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR6                         CAP004
     C                   MOVEL     'APA0087'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR7                         CAP004
      *                                                                                       CER001
      ** Access Module Details to verify if Lux Return feature is active                      CER001
      *                                                                                       CER001
     C                   CALL      'AOMMODR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*FIRST '     @OPTN                                        CER001
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CER001
      *                                                                                       CER001
      ** Database error                                                                       CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS                                           CER001
     C                   EVAL      DBKey = @OPTN                                              CER001
     C                   EVAL      DBFile = 'SDMMODPD'                                        CER001
     C                   EVAL      DBASE = 904                                                CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX602 - API Luxembourg - Function SEDPMV                                            CER001
      *                                                                                       CER001
     C                   EVAL      ULX602 = 'N'                                               CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX602'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS AND                                        CER001
     C                             BGLRIN = 'Y'                                               CER001
     C                   EVAL      ULX602 = 'Y'                                               CER001
     C                   OPEN      SEIDMLX1L0                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** If return code <> *NRF, call program exception error routine                         CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS AND                                       CER001
     C                             @RTCD <> '*NRF'                                            CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = 'ULX602'                                           CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE = 903                                                CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     ZATRNKDX      KLIST                                                                CER001
     C                   KFLD                    @TSTMPSEL                                    CER001
     C                   KFLD                    DDFRONTID                                    CER001
 
 
      *                                                                                       CSC022
      ** Access Switchable Features File, for CSC022                                          CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD             7                          CSC022
     C                   Parm      '*VERIFY'     @OPTN             7                          CSC022
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
