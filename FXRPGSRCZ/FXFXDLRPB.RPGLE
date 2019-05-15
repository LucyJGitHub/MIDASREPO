     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Invalid FX deals browse')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Foreign Exchange Dealing Module                      *
      *                                                               *
      *  FXFXDLRPB - INVALID FX DEALS BROWSE                          *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of invalid deals for selection,*
      *             the other picks off the selection made.           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD041294           Date 19Sep16               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      *                 196952             Date 06May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 186611             Date 21Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 166907             Date 03Jan00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 11Nov99               *
      *                 CAP014             Date 29Nov99               *
      * Midas DBA 3.00 -----------------Base--------------------------*
      *                 CAP006             Date 26Feb99               *
      *                 CAP004             Date 01Sep98               *
      *                 CAP002  *CREATE    Date 22Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041294 - Customer extension details is missing in          *
      *             CUSD repair browse                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSC022 - Commitment Control Changes for Midas Plus           *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  196952 - Ensure Rate has 5 digits before decimal and 8       *
      *           digits after. Recompiled over changed FXIFXDLPD.    *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
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
      *  CDL008 - Continuous Linked Settlement (Recompiled).          *
      *  166907 - Display 'Deal No. 999999 successfully inserted.'    *
      *           in the correct screen.                              *
      *  CAP051 - Automatic Authorisation (FX Part)                   *
      *           Recompile due to changes in FXIFXDLPD               *
      *  CAP014 - Repair function enhancements                        *
      *  CAP006 - Display message if prev transaction not successful  *
      *           due to  deal being updated by another workstation   *
      *  CAP004 - API's Phase 3.                                      *
      *           - Enable delete of invalid transactions             *
      *           - Change definition of MSGTYPE to be based on file  *
      *             field                                             *
      *  CAP002 - Conversion of FX inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFXFXDLRDF CF   E             WORKSTN
     F                                     SFILE(FXIFXDLS1:@@RRN)
     F/COPY WNCPYSRC,FXFXDLPF02
     FFXIFXDLL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FXIFXDLD0:FXIFXDLX0)          CAP004
     FFXIFXDLL1 UF   E           K DISK    INFSR(*PSSR)                         CAP004
     F                                     COMMIT                               CAP004
     FAPIDSETL0 IF   E           K DISK    INFSR(*PSSR)                         CAP014
     F                                     PREFIX(S_)                           CAP014
     F                                     RENAME(APIDSETD0:APIDSETX0)          CAP014
     FAPIDSETL1 UF   E           K DISK    INFSR(*PSSR)                         CAP004
     F                                     COMMIT                               CAP004
      ** API Invalid Log File from Support Database                                           CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
     F/COPY WNCPYSRC,FXFXDLPF01

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
                                                                                CAP014
     D InvTr         E DS                  EXTNAME(FXIFXDLPD)                   CAP014
     D InvTrSetIn    E DS                  EXTNAME(APIDSETPD)                   CAP014
     D                                     PREFIX(S_)                           CAP014

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

      ** Successful Insert Deal Number                                          166907
     D                 DS                                                       166907
     D  DDFOTX                 1     40                                         166907
     D  DDSIDN                10     15                                         166907
                                                                                166907
     D*ErrorText*******S*************52    DIM(1) CTDATA PERRCD(1)       CAP006 166907
     D ErrorText       S             52    DIM(2) CTDATA PERRCD(1)              166907
      ** Array containing messages                                              CAP006

     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
     D/COPY WNCPYSRC,FXFXDLPD01
      ** Data structure for data area commitment control                                      CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  ComitJobs              4    103A                                                      CSC022
                                                                                              CSC022
     D JobCmtCtlDS     S             10A   DIM(10)                                            CSC022
      * MIDAS SC Jobs Handling Commitment Control Data Structure                              CSC022
                                                                                              CSC011
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      **   Timestamp selected
     D @TMESTPSEL      S             26Z

      ** Message type field for chaining to APIDSETPD; defined in terms         CAP004
      ** of the file field when the file field was changed.                     CAP004
     D @MSGTYPE        S                   LIKE(DDMSGTYPE)                      CAP004
                                                                                CAP004
      ** Fields defined for Enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KTimeStamp      S                   LIKE(@TMESTPSEL)                                   CSC011
      ** Define workfields for Commitment Control Changes for Midas Plus                      CSC022
     D CSC022          S              1A                                                      CSC022
     D WSkpCom         S              1A                                                      CSC022
     D WPos            S              2S 0                                                    CSC022

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
     C/COPY WNCPYSRC,FXFXDLPC04
     C                   EXSR      BLDSFL
     C/COPY WNCPYSRC,FXFXDLPC05
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
     C                   WRITE     FXIFXDLS0
     C/COPY WNCPYSRC,FXFXDLPC06
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
     C                   WRITE     FXIFXDLF1
      *
      **  Set file pointer to start of file
      *
     C     *LOVAL        SETLL     FXIFXDLL0
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
     C                   EXFMT     FXIFXDLEND
     C                   SETON                                        LR
     C                   RETURN
     C                   END
     C/COPY WNCPYSRC,FXFXDLPC07
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
     C/COPY WNCPYSRC,FXFXDLPC08
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      **  Write the invalid deal to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   MOVE      DDTMESTMP     D@TMESTMP
     C/COPY WNCPYSRC,FXFXDLPC09
     C                   WRITE     FXIFXDLS1
     C/COPY WNCPYSRC,FXFXDLPC10
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
     C/COPY WNCPYSRC,FXFXDLPC11
     C                   WRITE     FXIFXDLS0
     C/COPY WNCPYSRC,FXFXDLPC12
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C/COPY WNCPYSRC,FXFXDLPC13
     C                   READ      FXIFXDLS0                              99
     C/COPY WNCPYSRC,FXFXDLPC14
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
     C/COPY WNCPYSRC,FXFXDLPC15
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
     C/COPY WNCPYSRC,FXFXDLPC16
     C                   READC     FXIFXDLS1                              99
     C/COPY WNCPYSRC,FXFXDLPC17
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
      ***If*'D'*is*input,*prompt*for*deletion*of*invalid*transaction     CAP004 CAP014
      *                                                                         CAP004
     C     *IN99         IFEQ      '0'                                          CAP004
     C     DDOPT         ANDEQ     'Q'                                          CAP014
     C*****DDOPT*********ANDEQ*****'D'                                   CAP004 CAP014
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
     C                   MOVE      DDFOASOCID    @FOASOCSEL
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
     C     ZATRNKX0      CHAIN     FXIFXDLX0                          99        CAP014
     C                   CLEAR                   InvTrSetIn                     CAP014
     C     APDSETKX      CHAIN     APIDSETX0                          99        CAP014
     C/COPY WNCPYSRC,FXFXDLPC01
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
     C                   PARM      'FXIFXDLPD'   InvFile1         10            CAP014
     C                   PARM      'APIDSETPD'   InvFile2         10            CAP014
     C                   PARM                    InvFile3         10            CAP014
     C                   PARM      *Blanks       InvFile4         10                        MD041294
                                                                                CAP014
      * Invalid file data                                                       CAP014
     C***********        PARM      InvTr         InvFDta1       2000            CAP014 CFT014
     C***********        PARM      InvTrSetIn    InvFDta2       2000            CAP014 CFT014
     C***********        PARM                    InvFDta3       2000            CAP014 CFT014
     C                   PARM      InvTr         InvFDta1       4000            CFT014
     C                   PARM      InvTrSetIn    InvFDta2       4000            CFT014
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
     C                   PARM                    DDFOTRANID                     CAP004
     C                   PARM                    DDFOASOCID                     CAP004
      *                                                                         CAP004
      * Timestamp                                                               CAP004
     C                   PARM                    D@TMESTMP                      CAP004
      *                                                                         CAP004
      * Narrative & Field Content 1 - 9                                         CAP004
     C                   PARM                    DDNAR1           30            CAP004
     C                   PARM      DDDLNO        DDFLD1           35            CAP004
     C                   PARM                    DDNAR2           30            CAP004
     C                   PARM      DDCUST        DDFLD2           35            CAP004
     C                   PARM                    DDNAR3           30            CAP004
     C                   PARM      DDDLTP        DDFLD3           35            CAP004
     C                   PARM                    DDNAR4           30            CAP004
     C                   PARM      DDDLDT        DDFLD4           35            CAP004
     C                   PARM                    DDNAR5           30            CAP004
     C                   PARM      DDVDAT        DDFLD5           35            CAP004
     C                   PARM                    DDNAR6           30            CAP004
     C                   PARM      DDBCCY        DDFLD6           35            CAP004
     C                   PARM                    DDNAR7           30            CAP004
     C                   PARM      DDBAMT        DDFLD7           35            CAP004
     C                   PARM                    DDNAR8           30            CAP004
     C                   PARM      DDSCCY        DDFLD8           35            CAP004
     C                   PARM                    DDNAR9           30            CAP004
     C                   PARM      DDSAMT        DDFLD9           35            CAP004
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
      **  If F10, delete invalid deal                                           CAP004
      *                                                                         CAP004
     C     @INKJ         IFEQ      '1'                                          CAP004
     C                   MOVE      D@TMESTMP     @TMESTPSEL                     CAP004
     C     ZATRNKD0      CHAIN     FXIFXDLD0                          99        CAP004
      *                                                                         186611
     C     *IN99         IFEQ      '0'                                          186611
     C                   MOVE      'D'           DDACTN                         186611
     C                   MOVEL     *BLANKS       EntryData                      186611
     C                   MOVEL     *BLANKS       FileName                       186611
     C                   CALL      'RPC1600'                                    186611
     C                   PARM      InvTr         EntryData      3000            186611
     C                   PARM      'FXIFXDLPD'   FileName         10            186611
     C                   ENDIF                                                  186611
      *                                                                         186611
     C  N99              DELETE    FXIFXDLD0                                    CAP004
     C     APDSETK0      CHAIN     APIDSETD0                          99        CAP004
     C  N99              DELETE    APIDSETD0                                    CAP004
                                                                                              CSC011
      ** Delete invalid record from the log file.                                             CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') and (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   EVAL      KMsgType = 'FXFXDL'                                        CSC011
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
     C/COPY WNCPYSRC,FXFXDLPC02
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
     C                   COMMIT                                                 CAP004
     C                   Endif                                                                CSC022
     C                   END                                                    CAP004
      *                                                                         CAP004
     C                   ENDSR                                                  CAP004
      *****************************************************************         CAP004
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
     C                   READ      FXIFXDLL0                              96
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
     C                   MOVE      *BLANK        @FOASOCSEL
     C                   CLEAR                   @TMESTPSEL
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
      *
     C                   ENDSR
     C/COPY WNCPYSRC,FXFXDLPC18
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
      * FO ASSOCIATED TRANSACTION ID SELECTED
     C                   PARM                    @FOASOCSEL       20
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *                                                                         166907
      ** Successful Insert Deal Number                                          166907
      *                                                                         166907
     C                   PARM                    @SIDN             6            166907
                                                                                              CSC011
      ** CSC011 enhancement                                                                   CSC011
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
      *                                                                                       CSC022
     C                   PARM                    CSC022                                       CSC022
      *
      ** Initialize program name
      *
     C                   MOVEL     'FXIFXDLBRW'  DBPGM
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
                                                                                              CSC011
      ** Check if switchable feature CSC011 is installed                                      CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   ENDIF                                                                CSC011
      *                                                                         CAP004
      * Key Lists                                                               CAP004
      *                                                                         CAP004
     C     ZATRNKD0      KLIST                                                  CAP004
     C                   KFLD                    DDFOTRANID                     CAP004
     C                   KFLD                    @TMESTPSEL                     CAP004
     C     APDSETK0      KLIST                                                  CAP004
     C                   KFLD                    @MSGTYPE                       CAP004
     C                   KFLD                    DDFOTRANID                     CAP004
     C                   KFLD                    @TMESTPSEL                     CAP004
     C     ZATRNKX0      KLIST                                                  CAP014
     C                   KFLD                    @TMESTPSEL                     CAP014
     C                   KFLD                    DDFOTRANID                     CAP014
     C     APDSETKX      KLIST                                                  CAP014
     C                   KFLD                    @MSGTYPE                       CAP014
     C                   KFLD                    @TMESTPSEL                     CAP014
     C                   KFLD                    DDFOTRANID                     CAP014
     C     KAPILOGL0     KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011
                                                                                CAP004
      ** Message Type                                                           CAP004
     C*******************MOVEL     'FXFXDL'      @MSGTYPE          8            CAP004
     C                   MOVEL     'FXFXDL'      @MSGTYPE                       CAP004
                                                                                CAP004
      * FORMAT TEXT FOR INVALID TRANSACTION DELETION FUNCTION                   CAP004
      *                                                                         CAP004
     C                   MOVEL     'APA0001'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR1                         CAP004
     C                   MOVEL     'APA0002'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR2                         CAP004
     C                   MOVEL     'APA0003'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR3                         CAP004
     C                   MOVEL     'APA0004'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR4                         CAP004
     C                   MOVEL     'APA0005'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR5                         CAP004
     C                   MOVEL     'APA0006'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR6                         CAP004
     C                   MOVEL     'APA0007'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR7                         CAP004
     C                   MOVEL     'APA0008'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR8                         CAP004
     C                   MOVEL     'APA0009'     MSGDNB                         CAP004
     C                   EXSR      RTVTXT                                       CAP004
     C                   MOVEL     MSGTXT        DDNAR9                         CAP004
      ** Determine if enhancement CSC022 is switched on                                       CSC022
      *                                                                                       CSC022
     C                   Eval      WSkpCom = 'N'                                              CSC022
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
     C/COPY WNCPYSRC,FXFXDLPC03
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
The last transaction was not applied to the database                            CAP006
Deal No. 999999 successfully inserted.                                          166907
