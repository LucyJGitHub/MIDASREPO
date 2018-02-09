     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Market Prices Repair Browse')
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFMPRIRPB - Invalid Market Prices Transactions Browse        *
      *                                                               *
      *  Function: This module runs in two modes:                     *
      *            one display a list of invalid transactions for     *
      *            selection, the other picks off the selection made. *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAP183  *CREATE    Date 05Jan06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP183 - Conversion of Market Prices Input into modular      *
      *           structure to use APIs.                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFFMPRIRDF CF   E             WORKSTN
     F                                     SFILE(FFIMPRIS1:@@RRN)
 
      ** Invalid Market Prices Details File - by Timestamp, Front Office ID
     FFFIMPRIL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FFIMPRID0:FFIMPRIX0)
 
      ** Invalid Market Prices Details File - by Front Office ID, Timestamp
     FFFIMPRIL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** API invalid log file
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT
 
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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
 
     D/COPY WNCPYSRC,FFIMPRIBD01
 
     D InvFF         E DS                  EXTNAME(FFIMPRIPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Array containing messages
     D ErrorText       S             52    DIM(1) CTDATA PERRCD(1)
 
      ** Data structure for data area SC24X7
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** Data structure for data area SDSTAT
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Timestamp selected
     D @TMESTPSEL      S             26Z
 
      ** Define variable forsenhancement CSC011
     D CSC011          S              1A
 
      ** Work field for Message type
     D WMTYP           S                   LIKE(APMTYP)
 
      ** 'Invalid Market Price Transaction' fields Selected
 
     D @MRKTSEL        S                   LIKE(DDMRKT)
     D @ISTCSEL        S                   LIKE(DDISTC)
     D @MTHNSEL        S                   LIKE(DDMTHN)
     D @YRNOSEL        S                   LIKE(DDYRNO)
     D @PCALSEL        S                   LIKE(DDPCAL)
     D @STRPSEL        S                   LIKE(DDSTRP)
     D @NEWPSEL        S                   LIKE(DDNEWP)
 
 
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
      ** Initialisation
     C                   EXSR      INIT
      *
      ** Build Sub-file
     C                   IF        @BDSFL = 'Y'
     C                   EXSR      BLDSFL
     C                   ENDIF
      *
      ** Read Subfile Record
     C                   IF        @RDSFL = 'Y'
     C                   EXSR      RDSFLR
     C                   ENDIF
      *
      ** Return
     C                   RETURN
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL - BUILD SUBFILE
      ********************************************************************
     C     BLDSFL        BEGSR
      *
      ** Check for user authority to browse if not multi-branching
      *
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
      *
      ** Initialise subfile relative record number.
     C                   Z-ADD     0             @@RRN             5 0
      *
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
     C                   EVAL      *IN97 = *ON
     C                   WRITE     FFIMPRIS0
     C                   EVAL      *IN97 = *OFF
      *
      ** If previous transaction was not successful due to deal being
      ** updated by another workstation then display message on screen
     C                   IF        @ERRUP = 'Y'
     C                   EVAL      ERRORMSG = ErrorText(1)
     C                   ELSE
     C                   EVAL      ERRORMSG = *BLANKS
     C                   ENDIF
      *
      ** Write the select screen footer to the screen.
     C                   WRITE     FFIMPRIF1
      *
      ** Set file pointer to start of file
     C     *LOVAL        SETLL     FFIMPRIL0
      *
      ** Read an invalid transaction
     C                   EXSR      RDITRAN
      *
      ** If no records exist - set up an error message.
      ** Display a message 'No invalid transactions present'
      ** then terminate
     C                   IF        @@EOF = 'Y'
     C                   EVAL      @ERRMS = 'FXM1007'
     C                   EXFMT     FFIMPRIEND
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      ** Set on ROLLUP indicator to drive initial loop.
     C                   EVAL      *IN98 = *ON
      *
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 or F12 is input.
     C                   DOW       @@EOF <> 'Y' AND
     C                             *IN98 = *ON
      *
      ** Initialise count of records written to subfile page.
     C                   Z-ADD     0             @@CNT             3 0
      *
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
     C                   DOW       @@EOF <> 'Y' AND
     C                             @@CNT < 14
      *
      ** Increment the subfile record no. and records written fields.
     C                   EVAL      @@RRN = 1 + @@RRN
     C                   EVAL      @@CNT = 1 + @@CNT
      *
      ** Write the invalid market prices to the subfile.
 
     C                   EVAL      DDOPT       = *BLANK
     C                   EVAL      DDSFRN      = @@RRN
     C                   EVAL      DDACTN      = DIACTN
     C                   EVAL      DDFOTRANID  = DIFRNT
     C                   EVAL      DDFOASOCID  = DIFRNT
     C                   EVAL      DDMRKT      = DIMRKT
     C                   EVAL      DDISTC      = DIISTC
     C                   EVAL      DDMTHN      = DIMTHN
     C                   EVAL      DDYRNO      = DIYRNO
     C                   EVAL      DDPCAL      = DIPCAL
     C                   EVAL      DDSTRP      = DISTRP
     C                   EVAL      DDNEWP      = DINEWP
     C                   MOVE      DITMST        D@TMESTMP
 
     C                   WRITE     FFIMPRIS1
      *
      ** Read an invalid transaction
     C                   EXSR      RDITRAN
     C                   ENDDO
      *
      *
      ** Write the subfile control record to the screen to display
      ** the subfile.
     C                   WRITE     FFIMPRIS0
      *
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.
     C                   READ      FFIMPRIS0                              99
      *
      ** If F3, bypass further processing.
     C                   IF        *INKC = *ON
     C                   EVAL      @INKC = '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      ** If F12, bypass further processing.
     C                   IF        *INKL = *ON
     C                   EVAL      @INKL = '1'
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
      ** Read the subfile for selected records
      ** Only process those for which the option field is blank.
     C                   DOU       *IN99 = *ON OR
     C                             DDOPT <> *BLANK
     C                   READC     FFIMPRIS1                              99
      *
      ** Validate repair option code
     C                   IF        *IN99 = *OFF
     C                   EXSR      VALID_ROPT
     C                   ENDIF
      *
      ** If 'E' is input, enquire upon invalid transaction
     C                   IF        *IN99 = *OFF AND
     C                             DDOPT = 'E'
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C                   EXSR      ENQ_INV
     C                   EVAL      DDOPT = *BLANK
     C                   ENDIF
      *
      ** If 'Q' is input, prompt for deletion of invalid transaction
     C                   IF        *IN99 = *OFF AND
     C                             DDOPT = 'Q'
     C                   EXSR      PROM_DELT
     C                   EVAL      DDOPT = *BLANK
     C                   ENDIF
     C                   ENDDO
      *
      ** Return the selected option, action, front office transaction ID
      ** and front office associated transaction ID
     C                   IF        *IN99 <> *ON AND
     C                             DDOPT <> *BLANK
      *
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C     ZATRNKX0      CHAIN     FFIMPRIX0                          99
      *
     C                   EVAL      @OPSEL      = DDOPT
     C                   EVAL      @ACSEL      = DDACTN
     C                   EVAL      @FOTRANSEL  = DDFOTRANID
     C                   MOVE      @TMESTPSEL    D@TMESTMP
      *
     C                   EVAL      @MRKTSEL    = DDMRKT
     C                   EVAL      @ISTCSEL    = DDISTC
     C                   EVAL      @MTHNSEL    = DDMTHN
     C                   EVAL      @YRNOSEL    = DDYRNO
     C                   EVAL      @PCALSEL    = DDPCAL
     C                   EVAL      @STRPSEL    = DDSTRP
     C                   EVAL      @NEWPSEL    = DDNEWP
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
 
      ** Inputs
 
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
      ** Option code
      ** Front Office ID
      ** Booking Branch
     C                   PARM                    DDOPT
     C                   PARM                    DDFOTRANID
     C                   PARM                    DDBRSN
 
      ** ICD Single branch code
     C                   PARM                    BJSBRC
 
      ** Outputs
 
      ** Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
      *
      ** If F3, bypass further processing.
      *
     C                   IF        @INKC = '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      ** If F12, continue with next option
      *
     C                   IF        @INKL = '1'
     C                   EVAL      DDOPT = *BLANK
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENQ_INV - ENQUIRE ON INVALID TRANSACTION
      *****************************************************************
     C     ENQ_INV       BEGSR
 
      ** Pass the invalid transaction details to the enquiry
 
     C     ZATRNKX0      CHAIN     FFIMPRIX0                          99
      *
     C                   CALLB     'ZAINVTRENQ'
 
      ** Inputs
 
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
      ** Action code
      ** Front Office ID
      ** Associated Front Office ID
      ** Timestamp
     C                   PARM                    DDACTN
     C                   PARM                    DDFOTRANID
     C                   PARM                    DDFOASOCID
     C                   PARM                    D@TMESTMP
 
      ** Invalid file names
     C                   PARM      'FFIMPRIPD'   InvFile1         10
     C                   PARM      '         '   InvFile2         10
     C                   PARM      '         '   InvFile3         10
 
      ** Invalid file data
     C                   PARM      InvFF         InvFDta1       4000
     C                   PARM      *BLANKS       InvFDta2       4000
     C                   PARM      *BLANKS       InvFDta3       5000
 
      ** Outputs
 
      ** Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
      *
      ** If F3, bypass further processing.
      *
     C                   IF        @INKC = '1'
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
      ** Inputs
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Action code
     C                   PARM                    DDACTN
      *
      ** Front Office Trans ID & Front Office Associated Trans ID
     C                   PARM                    DDFOTRANID
     C                   PARM                    DDFOASOCID       20
      *
      ** Timestamp
     C                   PARM                    D@TMESTMP
      *
      ** Narrative & Field Content 1 - 9
     C                   PARM                    DDNAR1           30
     C                   PARM      DDISTC        DDFLD1           35
     C                   PARM                    DDNAR2           30
     C                   PARM      DDMTHN        DDFLD2           35
     C                   PARM                    DDNAR3           30
     C                   PARM      DDYRNO        DDFLD3           35
     C                   PARM                    DDNAR4           30
     C                   PARM      DDPCAL        DDFLD4           35
     C                   PARM                    DDNAR5           30
     C                   PARM      DDSTRP        DDFLD5           35
     C                   PARM                    DDNAR6           30
     C                   PARM      DDNEWP        DDFLD6           35
     C                   PARM                    DDNAR7           30
     C                   PARM      DDPCAL        DDFLD7           35
     C                   PARM                    DDNAR8           30
     C                   PARM      DDSTRP        DDFLD8           35
     C                   PARM                    DDNAR9           30
     C                   PARM      DDNEWP        DDFLD9           35
      *
      ** Outputs
      *
      ** Function Keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
      *
      ** If F3, bypass further processing.
      *
     C                   IF        @INKC = '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      ** If F10, delete invalid transaction
      *
     C                   IF        @INKJ = '1'
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C     ZATRNKD0      CHAIN     FFIMPRID0                          99
     C  N99              DELETE    FFIMPRID0
 
      ** Also delete corresponding record in API standard log file
      ** if CSC011 is present and user is still in support system.
 
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)
     C                   EVAL      WMTYP = 'FFEXTR'
     C     KAPILOG       CHAIN     APILOGL0                           71
 
      ** If record found
     C                   IF        *IN71 = '0'
     C                   DELETE    APILOGD0
     C                   ENDIF
     C                   ENDIF
 
     C                   COMMIT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDITRAN - READ AN INVALID TRANSACTION
      *****************************************************************
     C     RDITRAN       BEGSR
      *
      ** Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      ** Read the file.
      *
     C                   READ      FFIMPRIL0                              96
      *
      *
      ** End of File
     C                   IF        *IN96 = *ON
     C                   EVAL      @@EOF = 'Y'
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
      ** Return error message
     C                   IF        @@ERR = 1
     C                   EVAL      @ERRMS = 'FXM0292'
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
      * INIT - Initialisation
      *****************************************************************
     C     INIT          BEGSR
      *
      * If 24x7 is present then journal APILOGL0
      *
     C                   IF        (CSC011 = 'Y')
     C                   OPEN      APILOGL0                             22
     C                   ENDIF
      *
      ** Clear outputs
     C                   EVAL      @ERRMS = *BLANK
     C                   EVAL      @OPSEL = *BLANK
     C                   EVAL      @ACSEL = *BLANK
     C                   EVAL      @FOTRANSEL = *BLANK
     C                   CLEAR                   @TMESTPSEL
     C                   EVAL      @INKC = '0'
     C                   EVAL      @INKL = '0'
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Input parameters
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Build sub-file
     C                   PARM                    @BDSFL            1
      *
      ** Read subfile record
     C                   PARM                    @RDSFL            1
      *
      ** Error in update of previous deal
     C                   PARM                    @ERRUP            1
      *
      ** Output parameters
      *
      ** Error message
     C                   PARM                    @ERRMS            7
      *
      ** Option selected
     C                   PARM                    @OPSEL            1
      *
      ** Action selected
     C                   PARM                    @ACSEL            1
      *
      ** FO Transaction ID selected
     C                   PARM                    @FOTRANSEL       20
      *
      ** 'Invalid Market Price Transaction' Fields Selected to RPR
     C                   PARM                    @MRKTSEL
     C                   PARM                    @ISTCSEL
     C                   PARM                    @MTHNSEL
     C                   PARM                    @YRNOSEL
     C                   PARM                    @PCALSEL
     C                   PARM                    @STRPSEL
     C                   PARM                    @NEWPSEL
      *
      ** Timestamp of Transaction Record Selected
     C                   PARM                    @TMESTPSEL
      *
      ** Command Keys
     C                   PARM                    @INKC
     C                   PARM                    @INKL
 
      ** CSC011 Enhancement
     C                   PARM                    CSC011
 
      *
      ** Initialise program name
      *
     C                   EVAL      DBPGM = 'FFMPRIRPB'
      *
      ** Move workstation ID to screen field.
     C                   EVAL      DDUSER = PsUser
     C                   EVAL      DDWID = PsJobName
      *
      ** Access bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 901
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Key Lists
     C     ZATRNKD0      KLIST
     C                   KFLD                    DDFOTRANID
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    DDFOTRANID
      *
      ** Format text for invalid transaction deletion function
     C                   EVAL      MSGDNB = 'ZZM2822'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR1 = MSGTXT
     C                   EVAL      MSGDNB = 'ZZM2823'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR2 = MSGTXT
     C                   EVAL      MSGDNB = 'ZZM2824'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR3 = MSGTXT
     C                   EVAL      MSGDNB = 'ZZM2825'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR4 = MSGTXT
     C                   EVAL      MSGDNB = 'ZZM2825'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR5 = MSGTXT
     C                   EVAL      MSGDNB = 'ZZM3641'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR6 = MSGTXT
     C                   EVAL      MSGDNB = 'ZZM2826'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR7 =  MSGTXT
     C                   EVAL      MSGDNB =  'ZZM2827'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR8 =  MSGTXT
     C                   EVAL      MSGDNB =  'ZZM2828'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR9 =  MSGTXT
      *
 
      ** Key List for access to API standard log file
     C     KAPILOG       KLIST
     C                   KFLD                    WMTYP
     C                   KFLD                    DDFOTRANID
     C                   KFLD                    @TMESTPSEL
 
      ** Retrieve values held in data areas SC24X7 and SDSTAT
     C                   IF        CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2006
**  Array of error messages - ErrorText
The last transaction was not applied to the database
