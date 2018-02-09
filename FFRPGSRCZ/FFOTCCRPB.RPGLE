     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Invalid currency OTC browse')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFOTCCRPB - Invalid currency OTC options browse              *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of invalid trans for selection,*
      *             the other picks off the selection made.           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007             Date 13Feb01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 186611             Date 21Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 166907             Date 03Jan00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP014             Date 29Nov99               *
      * Midas DBA 3.00 -----------------Base--------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP006             Date 19Mar99               *
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 15Sep98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CSC022 - Commitment Control Changes for Midas Plus           *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *           (Recompiled)                                        *
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
      *  CAP014 - Repair function enhancements                        *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP006 - Display message if prev transaction not successful  *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of Midas inputs to APIs, phase 3         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFFOTCCRDF CF   E             WORKSTN
     F                                     SFILE(FFIOTCCS1:@@RRN)
 
      ** Invalid OTC currency option transactions by timestamp and
      ** front-office ID
     FFFIOTCCL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FFIOTCCD0 : FFIOTCCX0)
 
      ** Invalid OTC currency option transactions by front-office ID
      ** and timestamp
     FFFIOTCCL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Invalid customer settlement instructions by timestamp and              CAP014
      ** front-office transaction ID                                            CAP014
     FFFICSETL0 IF   E           K DISK    INFSR(*PSSR)                         CAP014
     F                                     PREFIX(R_)                           CAP014
     F                                     RENAME(FFICSETD0 : FFICSETX0)        CAP014
                                                                                CAP014
      ** Invalid customer settlement instructions by front-office ID
      ** and timestamp
     FFFICSETL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
                                                                                              CSC011
      ** API invalid log file                                                                 CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
 
     FFFIOTLX1L0UF   E           K DISK    USROPN                                             CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
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
      ** External data structures for Midas Modules                                           CER001
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CER001
 
     D InvTr         E DS                  EXTNAME(FFIOTCCPD)                   CAP014
     D InvTrCSetIn   E DS                  EXTNAME(FFICSETPD)                   CAP014
     D                                     PREFIX(R_)                           CAP014
     D InvTrExt      E DS                  EXTNAME(FFIOTLX1PD)                                CER001
     D InvTrReg      E DS                  EXTNAME(FFOTRXPD)                                  CER001
                                                                                CAP014
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** Instrument details
     D InstTypes     E DS                  EXTNAME(INTYPD)
                                                                                              CSC011
      ** Data structure for data area SC24X7                                                  CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** Data structure for data area SDSTAT                                                  CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
 
      ** Successful Insert Deal Number                                          166907
     D                 DS                                                       166907
     D  DDFOTX                 1     40                                         166907
     D  DDSIDN                10     15                                         166907
                                                                                166907
     D*ErrorText*******S*************52    DIM(1) CTDATA PERRCD(1)       CAP006 166907
     D ErrorText       S             52    DIM(2) CTDATA PERRCD(1)              166907
      ** Array containing messages                                              CAP006
      ** Data structure for data area commitment control                                      CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  ComitJobs              4    103A                                                      CSC022
                                                                                              CSC022
     D JobCmtCtlDS     S             10A   DIM(10)                                            CSC022
      * MIDAS SC Jobs Handling Commitment Control Data Structure                              CSC022
                                                                                              CSC022
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D @TMESTPSEL      S             26Z
                                                                                              CSC011
      ** Define variable for enhancement CSC011                                               CSC011
     D CSC011          S              1A                                                      CSC011
                                                                                              CSC011
      ** Work field for Message type                                                          CSC011
     D WMTYP           S                   LIKE(APMTYP)                                       CSC011
 
      ** Define workfields for Commitment Control Changes for Midas Plus                      CSC022
     D CSC022          S              1A                                                      CSC022
     D WSkpCom         S              1A                                                      CSC022
     D WPos            S              2S 0                                                    CSC022
                                                                                              CER001
     D ULX605          S              1                                                       CER001
     D ULX008          S              1                                                       CER001
 
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
     C                   WRITE     FFIOTCCS0
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
     C                   WRITE     FFIOTCCF1
      *
      **  Set file pointer to start of file
      *
     C     *LOVAL        SETLL     FFIOTCCL0
      *
      * READ AN INVALID DEAL
      *
     C                   EXSR      RDIDEAL
      *
      **  If no records exist - set up an error message.
      **  Display a message 'No invalid transactions present'
      **  then terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'FXM1007'     @ERRMS
     C                   EXFMT     FFIOTCCEND
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
 
      **  Write the invalid deal to the subfile.
     C                   CLEAR                   DDOPT
     C                   EVAL      DDSFRN = @@RRN
     C                   MOVEL     SOTMESTMP     D@TMESTMP
     C                   EVAL      DDFOTRANID = SOFOTRANID
     C                   EVAL      DDACTN = SACTN
     C                   EVAL      DDTNBR = STNBR
     C                   EVAL      DDISTT = SISTT
     C                   EVAL      DDPCAL = SPCAL
     C                   EVAL      DDTRTY = STRTY
     C                   EVAL      DDNUCO = SNUCO
     C                   EVAL      DDSTRP = SSTRP
     C                   EVAL      DDAEIN = SAEIN
     C                   EVAL      DDPTFR = SPTFR
     C                   EVAL      DDCTAM = SCTAM
 
     C                   WRITE     FFIOTCCS1
      *
      * READ AN INVALID DEAL
      *
     C                   EXSR      RDIDEAL
     C                   END
      *
      **  Retrieve time
      *
     C                   TIME                    DDTIME
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     FFIOTCCS0
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      FFIOTCCS0                              99
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
 
      **  Read the subfile for selected records
      **  Only process those for which the option field is not blank.
     C     *IN99         DOUEQ     '1'
     C     DDOPT         ORNE      *BLANK
 
     C                   READC     FFIOTCCS1                              99
 
      * Validate repair option code                                             CAP014
     C     *IN99         IFEQ      '0'                                          CAP014
     C                   EXSR      VALID_ROPT                                   CAP014
     C                   END                                                    CAP014
                                                                                CAP014
      ** If 'E' is input, enquire upon invalid transaction                      CAP014
     C     *IN99         IFEQ      '0'                                          CAP014
     C     DDOPT         ANDEQ     'E'                                          CAP014
     C                   MOVE      D@TMESTMP     @TMESTPSEL                     CAP014
     C                   EXSR      ENQ_INV                                      CAP014
     C                   MOVEL     *BLANK        DDOPT                          CAP014
     C                   END                                                    CAP014
                                                                                CAP004
      ** If 'Q' is input, prompt for deletion of invalid transaction            CAP014
      ***If*'D'*is*input,*prompt*for*deletion*of*invalid*transaction     CAP004 CAP014
     C     *IN99         IFEQ      '0'
     C     DDOPT         ANDEQ     'Q'                                          CAP014
     C*****DDOPT*********ANDEQ*****'D'                                   CAP004 CAP014
     C                   EXSR      PromptDel
     C                   MOVEL     *BLANK        DDOPT
     C                   ENDIF
 
     C                   ENDDO
      *
      **  Return the selected option, action, front office transaction ID
      **  and transaction reference
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
      /EJECT
      *****************************************************************
      * RDIDEAL - READ AN INVALID DEAL
      *****************************************************************
     C     RDIDEAL       BEGSR
      *
      **  Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      **  Read the file.
      *
     C                   READ      FFIOTCCL0                              96
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
     C     ZATRNKX0      CHAIN     FFIOTCCX0                          99        CAP014
     C                   CLEAR                   InvTrCSetIn                    CAP014
     C     FFDSETKX      CHAIN     FFICSETX0                          99        CAP014
     C                   IF        ULX605 = 'Y' AND                                           CER001
     C                             ULX008 = 'Y'                                               CER001
     C                   EVAL      InvFile3 = 'FFOTRXPD'                                      CER001
     C     ZATRNKX0      CHAIN     FFIOTLX1L0                                                 CER001
     C                   MOVE      InvTrExt      InvTrReg                                     CER001
     C                   EVAL      InvFDta3 = InvTrReg                                        CER001
     C                   ENDIF                                                                CER001
                                                                                CAP014
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
     C                   PARM      'FFIOTCCPD'   InvFile1         10            CAP014
     C                   PARM      'FFICSETPD'   InvFile2         10            CAP014
     C                   PARM                    InvFile3         10            CAP014
                                                                                CAP014
      * Invalid file data                                                       CAP014
     C***********        PARM      InvTr         InvFDta1       2000            CAP014 CFT014
     C***********        PARM      InvTrCSetIn   InvFDta2       2000            CAP014 CFT014
     C***********        PARM                    InvFDta3       2000            CAP014 CFT014
     C                   PARM      InvTr         InvFDta1       4000            CFT014
     C                   PARM      InvTrCSetIn   InvFDta2       4000            CFT014
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
      * PrompDel - Prompt for deletion
      *****************************************************************
 
     C     PromptDel     BEGSR
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ZAINVTRDEL'
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * Action code
     C                   PARM                    DDACTN
      * Front Office Trans ID & Front Office Associated Trans ID
     C                   PARM                    DDFOTRANID
     C                   PARM                    DDFOASOCID
      * Timestamp
     C                   PARM                    D@TMESTMP
      * Narrative & Field Content 1 - 9
     C                   PARM                    DDNAR1           30
     C                   PARM      DDTNBR        DDFLD1           35
     C                   PARM                    DDNAR2           30
     C                   PARM      DDISTT        DDFLD2           35
     C                   PARM                    DDNAR3           30
     C                   PARM      DDPCAL        DDFLD3           35
     C                   PARM                    DDNAR4           30
     C                   PARM      DDTRTY        DDFLD4           35
     C                   PARM                    DDNAR5           30
     C                   PARM      DDNUCO        DDFLD5           35
     C                   PARM                    DDNAR6           30
     C                   PARM      DDSTRP        DDFLD6           35
     C                   PARM                    DDNAR7           30
     C                   PARM      DDAEIN        DDFLD7           35
     C                   PARM                    DDNAR8           30
     C                   PARM      DDPTFR        DDFLD8           35
     C                   PARM                    DDNAR9           30
     C                   PARM      DDCTAM        DDFLD9           35
 
      * OUTPUTS
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
 
      **  If F3, bypass further processing.
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   END
 
      **  If F10, delete invalid deal
     C     @INKJ         IFEQ      '1'
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C     ZATRNKD0      CHAIN     FFIOTCCD0                          99
      *                                                                         186611
     C     *IN99         IFEQ      '0'                                          186611
     C                   MOVE      'D'           SACTN                          186611
     C                   MOVEL     *BLANKS       EntryData                      186611
     C                   MOVEL     *BLANKS       FileName                       186611
     C                   CALL      'RPC1600'                                    186611
     C                   PARM      InvTr         EntryData      3000            186611
     C                   PARM      'FFIOTCCPD'   FileName         10            186611
     C                   ENDIF                                                  186611
      *                                                                         186611
     C  N99              DELETE    FFIOTCCD0
     C     ZATRNKD0      CHAIN     FFICSETD0                          99
     C  N99              DELETE    FFICSETD0
                                                                                              CSC011
      ** Also delete corresponding record in API standard log file                            CSC011
      ** if CSC011 is present and user is still in support system.                            CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
     C                   EVAL      WMTYP = 'FFOTCC'                                           CSC011
     C     KAPILOG       CHAIN     APILOGL0                           71                      CSC011
                                                                                              CSC011
      ** If record found                                                                      CSC011
     C     *IN71         IFEQ      '0'                                                        CSC011
     C                   DELETE    APILOGD0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        ULX605 = 'Y'  AND                                          CER001
     C                             ULX008 = 'Y'                                               CER001
     C     ZATRNKDX      CHAIN     FFIOTLXD6                                                  CER001
     C                   IF        %FOUND()                                                   CER001
     C                   DELETE    FFIOTLXD6                                                  CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
     C                   IF        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
     C                   COMMIT
     C                   Endif                                                                CSC022
     C                   END
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      *****************************************************************
      * RtvText - Retrieve text
      *****************************************************************
 
     C     RtvText       BEGSR
 
     C                   CALL      'SDRTVTXT'
     C                   PARM                    MSGDNB            7
     C                   PARM      'ZZGBMSGF  '  MSGNM            10
     C                   PARM      *BLANK        MSGTXT           80
     C                   ENDSR
 
      *****************************************************************
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
     C                   PARM                    ReturnCode
      *
      * BUILD SUB-FILE
     C                   PARM                    @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM                    @RDSFL            1
      *
      * Error in update of previous deal                                        CAP006
     C                   PARM                    @ERRUP            1            CAP006
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
 
      * COMMAND KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *                                                                         166907
      ** Successful Insert Deal Number                                          166907
      *                                                                         166907
     C                   PARM                    @SIDN             6            166907
                                                                                              CSC011
      ** CSC011 Enhancement                                                                   CSC011
     C                   PARM                    CSC011                                       CSC011
                                                                                              CSC011
      ** CSC022 Enhancement                                                                   CSC022
     C                   PARM                    CSC022                                       CSC022
                                                                                              CSC022
 
      ** Move workstation ID to screen field.
     C                   MOVEL     PsJobName     DDWID
 
      ** ACCESS BANK DETAILS
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * DATABASE ERROR
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
 
      * Retrieve texts for invalid transaction deletion function.
     C                   MOVEL     'APA0101'     MSGDNB
     C                   EXSR      RtvText
     C                   MOVEL     MSGTXT        DDNAR1
 
     C                   MOVEL     'APA0120'     MSGDNB
     C                   EXSR      RtvText
     C                   MOVEL     MSGTXT        DDNAR2
 
     C                   MOVEL     'APA0106'     MSGDNB
     C                   EXSR      RtvText
     C                   MOVEL     MSGTXT        DDNAR3
 
     C                   MOVEL     'APA0104'     MSGDNB
     C                   EXSR      RtvText
     C                   MOVEL     MSGTXT        DDNAR4
 
     C                   MOVEL     'APA0105'     MSGDNB
     C                   EXSR      RtvText
     C                   MOVEL     MSGTXT        DDNAR5
 
     C                   MOVEL     'APA0107'     MSGDNB
     C                   EXSR      RtvText
     C                   MOVEL     MSGTXT        DDNAR6
 
     C                   MOVEL     'APA0121'     MSGDNB
     C                   EXSR      RtvText
     C                   MOVEL     MSGTXT        DDNAR7
 
     C                   MOVEL     'APA0122'     MSGDNB
     C                   EXSR      RtvText
     C                   MOVEL     MSGTXT        DDNAR8
 
     C                   MOVEL     'APA0123'     MSGDNB
     C                   EXSR      RtvText
     C                   MOVEL     MSGTXT        DDNAR9
 
 
      * Key Lists
     C     ZATRNKD0      KLIST
     C                   KFLD                    DDFOTRANID
     C                   KFLD                    @TMESTPSEL
 
     C     ZATRNKX0      KLIST                                                  CAP014
     C                   KFLD                    @TMESTPSEL                     CAP014
     C                   KFLD                    DDFOTRANID                     CAP014
 
     C     FFDSETKX      KLIST                                                  CAP014
     C                   KFLD                    @TMESTPSEL                     CAP014
     C                   KFLD                    DDFOTRANID                     CAP014
                                                                                              CSC011
      ** Key List for access to API standard log file                                         CSC011
     C     KAPILOG       KLIST                                                                CSC011
     C                   KFLD                    WMTYP                                        CSC011
     C                   KFLD                    DDFOTRANID                                   CSC011
     C                   KFLD                    @TMESTPSEL                                   CSC011
                                                                                              CSC011
      ** Retrieve values held in data areas SC24X7 and SDSTAT                                 CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ENDIF                                                                CSC011
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
      *                                                                                       CER001
      ** Access Module Details to verify if Lux Return feature is active                      CER001
      *                                                                                       CER001
     C                   CALL      'AOMMODR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*FIRST '     @OPTN                                        CER001
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *Blanks                                           CER001
     C                   EVAL      DBFILE = 'SDMMODPD'                                        CER001
     C                   EVAL      DBASE  = 904                                               CER001
     C                   EVAL      DBKEY  = @OPTN                                             CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX008 - Commissariat Aux Bourses                                                    CER001
      *                                                                                       CER001
     C                   EVAL      ULX008 = 'N'                                               CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX008'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *Blanks                                            CER001
     C                   EVAL      ULX008 = 'Y'                                               CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
      * DATABASE ERROR                                                                        CER001
     C                   IF        @RTCD  <> *BLANKS and                                      CER001
     C                             @RTCD  <> '*NRF   '                                        CER001
     C                   EVAL      DBFILE  = 'SCSARDPD'                                       CER001
     C                   EVAL      DBASE   = 902                                              CER001
     C                   EVAL      DBKEY   = @OPTN                                            CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX605 - API Luxembourg - Function FFOTCC                                            CER001
      *                                                                                       CER001
     C                   EVAL      ULX605 = 'N'                                               CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX605'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *Blanks and                                        CER001
     C                             BGLRIN = 'Y'                                               CER001
     C                   EVAL      ULX605 = 'Y'                                               CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
      * DATABASE ERROR                                                                        CER001
     C                   IF        @RTCD  <> *BLANKS and                                      CER001
     C                             @RTCD  <> '*NRF   '                                        CER001
     C                   EVAL      DBFILE  = 'SCSARDPD'                                       CER001
     C                   EVAL      DBASE   = 903                                              CER001
     C                   EVAL      DBKEY   = @OPTN                                            CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX008 = 'Y' and                                           CER001
     C                             ULX605 = 'Y'                                               CER001
     C                   OPEN      FFIOTLX1L0                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     ZATRNKDX      KLIST                                                                CER001
     C                   KFLD                    @TMESTPSEL                                   CER001
     C                   KFLD                    DDFOTRANID                                   CER001
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  Array of error messages - ErrorText                                         CAP006
The last transaction was not applied to the database
Deal No. 999999 successfully inserted.                                          166907
