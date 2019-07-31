     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Invalid non-currency OTC browse')             *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFOTCORPB - Invalid non-currency OTC options browse          *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of invalid trans for selection,*
      *             the other picks off the selection made.           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD041294           Date 19Sep16               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP166  *CREATE    Date 15Oct01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041294 - Customer extension details is missing in          *
      *             CUSD repair browse                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSC022 - Commitment Control Changes for Midas Plus           *
      *  CAP166 - API for Non-Currency OTC                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFFOTCORPDFCF   E             WORKSTN
     F                                     SFILE(FFOTCORPS1:WkSRRN)
 
      ** Invalid OTC non-currency option transactions by
      ** timestamp and front-office ID
     FFFIOTCOL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FFIOTCOD0 : FFIOTCOX0)
 
      ** Invalid OTC non-currency option transactions by
      ** front-office ID and timestamp
     FFFIOTCOL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Invalid customer settlement instructions by timestamp and
      ** front-office transaction ID
     FFFICSETL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(R_)
     F                                     RENAME(FFICSETD0 : FFICSETX0)
 
      ** Invalid customer settlement instructions by front-office ID
      ** and timestamp
     FFFICSETL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** API invalid log file
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **-------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-------------------------------------------------------------------
 
      **-------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-------------------------------------------------------------------
 
      **-------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-------------------------------------------------------------------
 
      **-------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **-------------------------------------------------------------------
 
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
 
     D InvTr         E DS                  EXTNAME(FFIOTCOPD)
     D InvTrCSetIn   E DS                  EXTNAME(FFICSETPD)
     D                                     PREFIX(R_)
 
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Instrument details
     D InstTypes     E DS                  EXTNAME(INTYPD)
 
      ** Data structure for data area SC24X7
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** Data structure for data area SDSTAT
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** Successful Insert Deal Number
     D                 DS
     D  WFOTX                  1     40
     D  WSIDN                 10     15
 
      ** Array containing messages
     D ErrorText       S             52    DIM(2) CTDATA PERRCD(1)
 
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
 
      ** Subfile Relative Record Number
     D WkSRRN          S              5  0
 
      **   Timestamp selected
     D @TMESTPSEL      S             26Z
 
      ** Work Variables
     D WkEOF           S              1A
     D WkCnt           S              3  0
 
     D PSIDN           S              6
 
      ** Define variable for enhancement CSC011
     D CSC011          S              1A
 
      ** Work field for Message type
     D WMTYP           S                   LIKE(APMTYP)
 
      ** Define workfields for Commitment Control Changes for Midas Plus                      CSC022
     D CSC022          S              1A                                                      CSC022
     D WSkpCom         S              1A                                                      CSC022
     D WPos            S              2S 0                                                    CSC022
                                                                                              CSC022
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
 
      ** Initialisation
 
     C                   EXSR      SRInit
 
      ** Build sub-file
 
     C                   IF        @BDSFL = 'Y'
     C                   EXSR      BLDSFL
     C                   ENDIF
 
      ** Read subfile record
 
     C                   IF        @RDSFL = 'Y'
     C                   EXSR      RDSFLR
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL - Build subfile
      ********************************************************************
     C     BLDSFL        BEGSR
 
      ** Check for user authority to browse if not multi-branching
 
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
 
      **  Initialise subfile relative record number.
 
     C                   EVAL      WkSRRN = 0
 
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
 
     C                   EVAL      *IN97 = True
     C                   WRITE     FFOTCORPC1
     C                   EVAL      *IN97 = False
 
      **  Write the select screen footer to the screen.
      **  If previous transaction was not successful due to deal being
      **  updated by another workstation then display message on screen
 
     C                   IF        @ERRUP = 'Y'
     C                   EVAL      ERRORMSG = ErrorText(1)
     C                   ELSE
     C                   EVAL      ERRORMSG = *BLANKS
     C                   EVAL      WFOTX    = *BLANKS
     C                   IF        PSIDN <> *BLANKS
     C                   EVAL      WFOTX = ErrorText(2)
     C                   EVAL      WSIDN = PSIDN
     C                   EVAL      ERRORMSG = WFOTX
     C                   ENDIF
 
     C                   ENDIF
 
     C                   WRITE     FFOTCORPF1
 
      ** Set file pointer to start of file
 
     C     *LOVAL        SETLL     FFIOTCOL0
 
      ** Read an invalid deal
 
     C                   EXSR      RDIDEAL
 
      **  If no records exist - set up an error message.
      **  Display a message 'No invalid transactions present'
      **  then terminate
 
     C                   IF        WkEOF = 'Y'
     C                   EVAL      @ERRMS = 'FXM1007'
     C                   EXFMT     FFOTCORPF2
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
      **  Set on ROLLUP indicator to drive initial loop.
 
     C                   EVAL      *IN98 = True
 
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
 
     C                   DOW       WkEOF <> 'Y' and *IN98 = True
 
      **  Initialise count of records written to subfile page.
 
     C                   EVAL      WkCnt = 0
 
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
 
     C                   DOW       WkEOF <> 'Y' and WkCnt < 14
 
      ** Increment the subfile record no. and records written fields.
 
     C                   EVAL      WkSRRN = WkSRRN + 1
     C                   EVAL      WkCnt = WkCnt + 1
 
      ** Write the invalid deal to the subfile.
 
     C                   EVAL      #1OPTN = *Blanks
     C                   EVAL      #1SFRN = WkSRRN
     C                   MOVEL     SOTMESTMP     #1TMSP
     C                   EVAL      #1FRNT = SOFOTRANID
     C                   EVAL      #1ACTN = NACTN
     C                   EVAL      #1TNBR = NTNBR
     C                   EVAL      #1ISTT = NISTT
     C                   EVAL      #1PCAL = NPCAL
     C                   EVAL      #1TRTY = NTRTY
     C                   EVAL      #1NUCO = NNUCO
     C                   EVAL      #1STRP = NSTRP
     C                   EVAL      #1AEIN = NAEIN
     C                   EVAL      #1PTFR = NPTFR
     C                   EVAL      #1CTAM = NCTAM
 
     C                   WRITE     FFOTCORPS1
 
      ** Read an invalid deal
 
     C                   EXSR      RDIDEAL
     C                   ENDDO
 
      **  Write the subfile control record to the screen to display
      **  the subfile.
 
     C                   WRITE     FFOTCORPC1
 
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
 
     C                   READ      FFOTCORPC1                             99
 
      **  If F3, bypass further processing.
 
     C                   IF        *INKC = True
     C                   EVAL      @INKC = '1'
     C                   EVAL      *INLR = True
     C                   RETURN
     C                   ENDIF
 
      **  If F12, bypass further processing.
 
     C                   IF        *INKL = True
     C                   EVAL      @INKL = '1'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * RDSFLR - Read subfile record
      ********************************************************************
     C     RDSFLR        BEGSR
 
      **  Read the subfile for selected records
      **  Only process those for which the option field is not blank.
 
     C                   DOU       *IN99 = True or #1OPTN <> *BLANK
     C                   READC     FFOTCORPS1                             99
 
      ** Validate repair option code
 
     C                   IF        *IN99 = False and #1OPTN <> *BLANKS
     C                   EXSR      VALID_ROPT
     C                   ENDIF
 
      ** If 'E' is input, enquire upon invalid transaction
 
     C                   IF        *IN99 = False and #1OPTN = 'E'
     C                   MOVE      #1TMSP        @TMESTPSEL
     C                   EXSR      ENQ_INV
     C                   EVAL      #1OPTN = *BLANK
     C                   ENDIF
 
      ** If 'Q' is input, prompt for deletion of invalid transaction
 
     C                   IF        *IN99 = False and #1OPTN = 'Q'
     C                   EXSR      PromptDel
     C                   EVAL      #1OPTN = *BLANK
     C                   ENDIF
 
     C                   ENDDO
 
      **  Return the selected option, action, front office transaction ID
      **  and transaction reference
 
     C                   IF        *IN99 <> True and #1OPTN <> *BLANK
 
     C                   EVAL      @OPSEL = #1OPTN
     C                   EVAL      @ACSEL = #1ACTN
     C                   EVAL      @FOTRANSEL = #1FRNT
     C                   MOVE      #1TMSP        @TMESTPSEL
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDIDEAL - Read an invalid deal
      *****************************************************************
     C     RDIDEAL       BEGSR
 
      **  Reset End of File indicator
 
     C                   EVAL      WkEOF = *Blanks
 
      **  Read the file.
 
     C                   READ      FFIOTCOL0                              96
 
      ** End of File
 
     C                   IF        *IN96 = True
     C                   EVAL      WkEOF = 'Y'
     C                   ENDIF
 
     C     ERDDEL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - CHECK FOR USER AUTHORITY IF NOT MULTI-BRANCHING
      *****************************************************************
     C     CHAUTN        BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
 
      ** Return error message for user not authorized then terminate.
 
     C                   IF        @@ERR = 1
     C                   EVAL      @ERRMS = 'FXM0292'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRInit - INITIALIZATION
      *****************************************************************
     C     SRInit        BEGSR
      *
      * If 24x7 is present then journal APILOGL0
      *
     C                   IF        (CSC011 = 'Y')
     C                   OPEN      APILOGL0                             22
     C                   ENDIF
 
      ** Clear outputs
 
     C                   EVAL      @ERRMS = *BLANK
     C                   EVAL      @OPSEL = *BLANK
     C                   EVAL      @ACSEL = *BLANK
     C                   EVAL      @FOTRANSEL = *BLANK
     C                   CLEAR                   @TMESTPSEL
     C                   EVAL      @INKC = '0'
     C                   EVAL      @INKL = '0'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALID_ROPT - VALIDATE REPAIR OPTION CODE
      *****************************************************************
     C     VALID_ROPT    BEGSR
 
     C                   CALLB     'ZAROPTVAL'
 
      ** Inputs
      ** ------
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Option code
      ** Front Office ID
      ** Booking Branch
      ** ICD Single branch code
 
     C                   PARM                    #1OPTN
     C                   PARM                    #1FRNT
     C                   PARM                    #1BRSN
     C                   PARM                    BJSBRC
 
      ** Outputs
      ** -------
      ** Function Keys                                                                4
 
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
 
      **  If F3, bypass further processing.
 
     C                   IF        @INKC = '1'
     C                   EVAL      *INLR = True
     C                   RETURN
     C                   ENDIF
 
      **  If F12, continue with next option
 
     C                   IF        @INKL = '1'
     C                   EVAL      #1OPTN = *BLANK
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENQ_INV - ENQUIRE ON INVALID TRANSACTION
      *****************************************************************
     C     ENQ_INV       BEGSR
 
      ** Pass the invalid transaction details to the enquiry
 
     C     ZATRNKX0      CHAIN     FFIOTCOX0                          99
 
     C                   CLEAR                   InvTrCSetIn
     C     FFDSETKX      CHAIN     FFICSETX0                          99
 
     C                   CALLB     'ZAINVTRENQ'
 
      ** INPUTS
      ** ------
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Action code
      ** Front Office ID
      ** Associated Front Office ID
      ** Timestamp
 
     C                   PARM                    #1ACTN
     C                   PARM                    #1FRNT
     C                   PARM                    #1FOASOCID
     C                   PARM                    #1TMSP
 
      ** Invalid file names
 
     C                   PARM      'FFIOTCOPD'   InvFile1         10
     C                   PARM      'FFICSETPD'   InvFile2         10
     C                   PARM      *BLANKS       InvFile3         10
     C                   PARM      *Blanks       InvFile4         10                        MD041294
 
      ** Invalid file data
 
     C                   PARM      InvTr         InvFDta1       4000
     C                   PARM      InvTrCSetIn   InvFDta2       4000
     C                   PARM      *BLANKS       InvFDta3       4000
     C                   PARM      *Blanks       InvFDta4       4000                        MD041294
 
      ** Outputs
      ** -------
      ** Function Keys
 
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
 
      **  If F3, bypass further processing.
 
     C                   IF        @INKC = '1'
     C                   EVAL      *INLR = True
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PromptDel - Prompt for deletion
      *****************************************************************
 
     C     PromptDel     BEGSR
 
     C                   CALLB     'ZAINVTRDEL'
 
      ** Inputs
      ** ------
      ** Return Code
      ** Action code
 
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    #1ACTN
 
      ** Front Office Trans ID & Front Office Associated Trans ID
 
     C                   PARM                    #1FRNT
     C                   PARM                    #1FOASOCID
 
      ** Timestamp
 
     C                   PARM                    #1TMSP
 
      ** Narrative & Field Content 1 - 9
 
     C                   PARM                    DDNAR1           30
     C                   PARM      #1TNBR        DDFLD1           35
     C                   PARM                    DDNAR2           30
     C                   PARM      #1ISTT        DDFLD2           35
     C                   PARM                    DDNAR3           30
     C                   PARM      #1PCAL        DDFLD3           35
     C                   PARM                    DDNAR4           30
     C                   PARM      #1TRTY        DDFLD4           35
     C                   PARM                    DDNAR5           30
     C                   PARM      #1NUCO        DDFLD5           35
     C                   PARM                    DDNAR6           30
     C                   PARM      #1STRP        DDFLD6           35
     C                   PARM                    DDNAR7           30
     C                   PARM      #1AEIN        DDFLD7           35
     C                   PARM                    DDNAR8           30
     C                   PARM      #1PTFR        DDFLD8           35
     C                   PARM                    DDNAR9           30
     C                   PARM      #1CTAM        DDFLD9           35
 
      ** Outputs
      ** -------
      ** Function keys
 
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
 
      **  If F3, bypass further processing.
 
     C                   IF        @INKC = '1'
     C                   EVAL      *INLR = True
     C                   RETURN
     C                   ENDIF
 
      **  If F10, delete invalid deal
 
     C                   IF        @INKJ = '1'
     C                   MOVE      #1TMSP        @TMESTPSEL
 
     C     ZATRNKD0      CHAIN     FFIOTCOD0                          99
 
     C                   IF        *IN99 = False
 
      ** To distinguish 'Delete' in repair queues between
      ** a) Delete by action code 'Q' (Module 'RPB')
      **    (Message Refused by Midas)
      ** b) Delete after main file updated (Module 'RPR')
      **    (Message Accepted by Midas)
      ** Send a User Defined Journal Entry for the Invalid File and
      ** ensure Action Code is set to 'D'. So, Front Office system
      ** will receive a return message for Invalid File(s) ONLY when
      ** Message is refused by Midas.
 
     C                   EVAL      NACTN = 'D'
     C                   EVAL      EntryData  = *BLANKS
     C                   EVAL      FileName   = *BLANKS
     C                   CALL      'RPC1600'
     C                   PARM      InvTr         EntryData      3000
     C                   PARM      'FFIOTCOPD'   FileName         10
 
     C                   DELETE    FFIOTCOD0
     C                   ENDIF
 
     C     ZATRNKD0      CHAIN     FFICSETD0                          99
 
     C                   IF        *IN99 = False
     C                   DELETE    FFICSETD0
     C                   ENDIF
 
      ** Also delete corresponding record in API standard log file
      ** if CSC011 is present and user is still in support system.
 
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR
 
     C                   EVAL      WMTYP = 'FFOTCO'
     C     KAPILOG       CHAIN     APILOGL0                           71
 
      ** If record found
 
     C                   IF        *IN71 = False
     C                   DELETE    APILOGD0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
     C                   COMMIT
     C                   Endif                                                                CSC022
     C                   ENDIF
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      *****************************************************************
      * SRRtvTxt - Retrieve text
      *****************************************************************
 
     C     SRRtvTxt      BEGSR
 
     C                   CALL      'SDRTVTXT'
     C                   PARM                    MSGDNB            7
     C                   PARM      'ZZGBMSGF  '  MSGNM            10
     C                   PARM      *BLANK        MSGTXT           80
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** Input parameters
      ** ----------------
      ** Return code
      ** Build subfile
      ** Read subfile record
      ** Error in update of previous deal
 
     C                   PARM                    ReturnCode
     C                   PARM                    @BDSFL            1
     C                   PARM                    @RDSFL            1
     C                   PARM                    @ERRUP            1
 
      ** Output parameters
 
      ** Error message
 
     C                   PARM                    @ERRMS            7
 
      ** Option selected
      ** Action selected
 
     C                   PARM                    @OPSEL            1
     C                   PARM                    @ACSEL            1
 
      ** FO Transaction ID selected
 
     C                   PARM                    @FOTRANSEL       20
 
      ** Timestamp of transaction selected
 
     C                   PARM                    @TMESTPSEL
 
      ** Command keys
 
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
 
      ** Successful Insert Deal Number
 
     C                   PARM                    PSIDN
 
      ** CSC011 Enhancement
 
     C                   PARM                    CSC011
      ** CSC022 Enhancement                                                                   CSC022
                                                                                              CSC022
     C                   PARM                    CSC022                                       CSC022
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = @OPTN
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Move workstation ID to screen field.
 
     C                   EVAL      #1WSID = PSJobName
     C                   EVAL      #1USER = PSUser
     C                   EVAL      #1DATE = BJMRDT
 
      ** Key Lists
 
     C     ZATRNKD0      KLIST
     C                   KFLD                    #1FRNT
     C                   KFLD                    @TMESTPSEL
 
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    #1FRNT
 
     C     FFDSETKX      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    #1FRNT
 
      ** Key List for access to API standard log file
 
     C     KAPILOG       KLIST
     C                   KFLD                    WMTYP
     C                   KFLD                    #1FRNT
     C                   KFLD                    @TMESTPSEL
 
      ** Retrieve values held in data areas SC24X7 and SDSTAT
 
     C                   IF        CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   ENDIF
 
      ** Retrieve texts for invalid transaction deletion function.
 
     C                   EVAL      MSGDNB = 'APA0101'
     C                   EXSR      SRRtvTxt
     C                   EVAL      DDNAR1 = MSGTXT
 
     C                   EVAL      MSGDNB = 'APA0120'
     C                   EXSR      SRRtvTxt
     C                   EVAL      DDNAR2 = MSGTXT
 
     C                   EVAL      MSGDNB = 'APA0106'
     C                   EXSR      SRRtvTxt
     C                   EVAL      DDNAR3 = MSGTXT
 
     C                   EVAL      MSGDNB = 'APA0104'
     C                   EXSR      SRRtvTxt
     C                   EVAL      DDNAR4 = MSGTXT
 
     C                   EVAL      MSGDNB = 'APA0105'
     C                   EXSR      SRRtvTxt
     C                   EVAL      DDNAR5 = MSGTXT
 
     C                   EVAL      MSGDNB = 'APA0107'
     C                   EXSR      SRRtvTxt
     C                   EVAL      DDNAR6 = MSGTXT
 
     C                   EVAL      MSGDNB = 'APA0121'
     C                   EXSR      SRRtvTxt
     C                   EVAL      DDNAR7 = MSGTXT
 
     C                   EVAL      MSGDNB = 'APA0122'
     C                   EXSR      SRRtvTxt
     C                   EVAL      DDNAR8 = MSGTXT
 
     C                   EVAL      MSGDNB = 'APA0123'
     C                   EXSR      SRRtvTxt
     C                   EVAL      DDNAR9 = MSGTXT
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
 
      **-------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **-------------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **-------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **-------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  Array of error messages - ErrorText
The last transaction was not applied to the database
Deal No. 999999 successfully inserted.
