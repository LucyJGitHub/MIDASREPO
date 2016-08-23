     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Invalid REPO browse')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMREPORPB - Invalid REPO transactions Browse                 *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *          One display a list of invalid transactions for       *
      *          selection, the other picks off the selection made.   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 CAP067  *CREATE    Date 24Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CAP067 - Repurchase Agreements API.                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FMMREPORDF CF   E             WORKSTN
     F                                     SFILE(MMIREPOS1:W_RRN)
     FMMIRPLDL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMIRPLDD0:MMIRPLDX0)
     FMMIRPLDL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FMMIRPDDL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMIRPDD0:MMIRPDDX0)
     FAPIDSETL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(S_)
     F                                     RENAME(APIDSETD0:APIDSETX0)
     FAPIDSETL1 UF   E           K DISK    INFSR(*PSSR)
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
 
     D/COPY WNCPYSRC,MMREPOBD01
 
     D InvTr         E DS                  EXTNAME(MMIRPLDPD)
     D InvTrD        E DS                  EXTNAME(MMIRPDDPD)
     D  GADLNO       E                     EXTFLD(DDDLNO)
     D  GAACTN       E                     EXTFLD(DDACTN)
     D InvTrSetIn    E DS                  EXTNAME(APIDSETPD)
     D                                     PREFIX(S_)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Successful Insert Deal Number
     D                 DS
     D  DDFOTX                 1     40
     D  DDSIDN                10     15
 
      ** Array containing messages
     D ErrorText       S             52    DIM(2) CTDATA PERRCD(1)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D PTMESTPSEL      S             26Z
 
      ** Message type field for chaining to APIDSETPD; defined in terms
      ** of the file field when the file field was changed.
     D PMSGTYPE        S                   LIKE(DDMSGTYPE)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *
      * Initialization
      *
     C                   EXSR      INIT
      *
      * Build Sub-file
      *
     C                   IF        PBDSFL = 'Y'
     C                   EXSR      BLDSFL
     C                   ENDIF
      *
      * Read Subfile Record
      *
     C                   IF        PRDSFL = 'Y'
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
      *
      * CHECK FOR USER AUTHORITY TO BROWSE IF NOT MULTI-BRANCHING
      *
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             W_RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   EVAL      *IN97 = *ON
     C                   WRITE     MMIREPOS0
     C                   EVAL      *IN97 = *OFF
      *
      **  If previous transaction was not successful due to deal being
      **  updated by another workstation then display message on screen
      *
     C                   IF        PERRUP = 'Y'
 
     C                   EVAL      ERRORMSG = ErrorText(1)
 
     C                   ELSE
 
     C                   EVAL      DDFOTX = *BLANKS
     C                   EVAL      ERRORMSG = *BLANKS
 
     C                   IF        PSIDN <> *BLANKS
     C                   MOVEL     ErrorText(2)  DDFOTX
     C                   MOVEL     PSIDN         DDSIDN
     C                   MOVE      *BLANK        PSIDN
     C                   MOVEL     DDFOTX        ERRORMSG
     C                   ENDIF
 
     C                   ENDIF
      *
      **  Write the select screen footer to the screen.
      *
     C                   WRITE     MMIREPOF1
      *
      **  Set file pointer to start of file
      *
     C     *LOVAL        SETLL     MMIRPLDL0
      *
      * Read an invalid transaction
      *
     C                   EXSR      RDITRAN
      *
      **  If no records exist - set up an error message.
      **  Display a message 'No invalid transactions present'
      **  then terminate
      *
     C                   IF        W_EOF = 'Y'
     C                   EVAL      PERRMS = 'FXM1007'
     C                   EXFMT     MMIREPOEND
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   EVAL      *IN98 = *ON
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C                   DOW       W_EOF <> 'Y' AND
     C                             *IN98 = *ON
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             W_CNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C                   DOW       W_EOF <> 'Y' AND
     C                             W_CNT < 14
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   EVAL      W_RRN = 1 + W_RRN
     C                   EVAL      W_CNT = 1 + W_CNT
      *
      **  Write the invalid transaction to the subfile.
      *
     C                   EVAL      DDOPT = *BLANK
     C                   EVAL      DDSFRN = W_RRN
     C                   MOVE      DDTMESTMP     D_TMESTMP
     C                   WRITE     MMIREPOS1
      *
      * Read an invalid transaction
      *
     C                   EXSR      RDITRAN
     C                   ENDDO
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     MMIREPOS0
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      MMIREPOS0                              99
      *
      **  If F3, bypass further processing.
      *
     C                   IF        *INKC = *ON
     C                   EVAL      PINKC = '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      **  If F12, bypass further processing.
      *
     C                   IF        *INKL = *ON
     C                   EVAL      PINKL = '1'
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDDO
      *
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
     C                   DOU       *IN99 = *ON OR
     C                             DDOPT <> *BLANK
 
     C                   READC     MMIREPOS1                              99
      *
      * Validate repair option code
      *
     C                   IF        *IN99 = *OFF
     C                   EXSR      VALID_ROPT
     C                   ENDIF
      *
      ** If 'E' is input, enquire upon invalid transaction
      *
     C                   IF        *IN99 = *OFF AND
     C                             DDOPT = 'E'
     C                   MOVE      D_TMESTMP     PTMESTPSEL
     C                   EXSR      ENQ_INV
     C                   EVAL      DDOPT = *BLANK
     C                   ENDIF
      *
      ** If 'Q' is input, prompt for deletion of invalid transaction
      *
     C                   IF        *IN99 = *OFF AND
     C                             DDOPT = 'Q'
     C                   EXSR      PROM_DELT
     C                   EVAL      DDOPT = *BLANK
     C                   ENDIF
     C                   ENDDO
      *
      **  Return the selected option, action, front office transaction ID
      **  and front office associated transaction ID
      *
     C                   IF        *IN99 <> *ON AND
     C                             DDOPT <> *BLANK
      *
     C                   EVAL      POPSEL = DDOPT
     C                   EVAL      PACSEL = DDACTN
     C                   EVAL      PFOTRANSEL = DDFOTRANID
     C                   EVAL      PFOASOCSEL = DDFOASOCID
     C                   EVAL      PTMESTPSEL = D_TMESTMP
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
 
      * Inputs
 
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
 
      * Outputs
 
      * Function Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
      *
      **  If F3, bypass further processing.
      *
     C                   IF        PINKC = '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      **  If F12, continue with next option
      *
     C                   IF        PINKL = '1'
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
 
      * Pass the invalid transaction details to the enquiry
 
     C     ZATRNKX0      CHAIN     MMIRPLDX0                          99
     C                   CLEAR                   InvTrD
     C     DDFOASOCID    CHAIN     MMIRPDDX0                          10
     C                   CLEAR                   InvTrSetIn
     C     APDSETKX      CHAIN     APIDSETX0                          10
 
     C                   EVAL      GADLNO = DDDLNO
     C                   EVAL      GAACTN = DDACTN
      *
     C                   CALLB     'ZAINVTRENQ'
 
      * Inputs
 
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      * Action code
      * Front Office ID
      * Associated Front Office ID
      * Timestamp
     C                   PARM                    DDACTN
     C                   PARM                    DDFOTRANID
     C                   PARM                    DDFOASOCID
     C                   PARM                    D_TMESTMP
 
      * Invalid file names
     C                   PARM      'MMIRPLDPD'   InvFile1         10
     C                   PARM      'APIDSETPD'   InvFile2         10
     C                   PARM      'MMIRPDDPD'   InvFile3         10
 
      * Invalid file data
     C                   PARM      InvTr         InvFDta1       4000
     C                   PARM      InvTrSetIn    InvFDta2       4000
     C                   PARM      InvTrD        InvFDta3       4000
 
      * Outputs
 
      * Function Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
      *
      **  If F3, bypass further processing.
      *
     C                   IF        PINKC = '1'
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
      * Inputs
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
     C                   PARM                    D_TMESTMP
      *
      * Narrative & Field Content 1 - 9
     C                   PARM                    DDNAR1           30
     C                   PARM      DDDLNO        DDFLD1           35
     C                   PARM                    DDNAR2           30
     C                   PARM      DDTYPE        DDFLD2           35
     C                   PARM                    DDNAR3           30
     C                   PARM      DDCUST        DDFLD3           35
     C                   PARM                    DDNAR4           30
     C                   PARM      DDDLDT        DDFLD4           35
     C                   PARM                    DDNAR5           30
     C                   PARM      DDVDAT        DDFLD5           35
     C                   PARM                    DDNAR6           30
     C                   PARM      DDMDAT        DDFLD6           35
     C                   PARM                    DDNAR7           30
     C                   PARM      DDCCY         DDFLD7           35
     C                   PARM                    DDNAR8           30
     C                   PARM      DDAMNP        DDFLD8           35
     C                   PARM                    DDNAR9           30
     C                   PARM      DDSPRT        DDFLD9           35
      *
      * Outputs
      *
      * Function Keys
     C                   PARM      '0'           PINKC             1
     C                   PARM      '0'           PINKJ             1
     C                   PARM      '0'           PINKL             1
      *
      **  If F3, bypass further processing.
      *
     C                   IF        PINKC = '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      **  If F10, delete invalid transaction
      *
     C                   IF        PINKJ = '1'
 
     C                   CALLB     'MMREPOIDL'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    DDFOASOCID
     C                   PARM                    D_TMESTMP
 
     C                   EVAL      EntryData = *BLANKS
     C                   EVAL      FileName = *BLANKS
 
     C                   CALL      'RPC1600'
     C                   PARM      InvTr         EntryData      3000
     C                   PARM      'MMIRPLDPD'   FileName         10
 
     C                   COMMIT
 
 
     C     APDSETK0      CHAIN     APIDSETD0                          10
     C  N10              DELETE    APIDSETD0
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
      **  Reset End of File indicator
      *
     C                   MOVE      *BLANK        W_EOF             1
      *
      **  Read the file.
      *
     C                   READ      MMIRPLDL0                              96
      *
      * End of File
      *
     C                   IF        *IN96 = *ON
     C                   EVAL      W_EOF = 'Y'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - CHECK FOR USER AUTHORITY IF NOT MULTI-BRANCHING
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    W_ERR             1 0
      *
      * Return error message
      *
     C                   IF        W_ERR = 1
     C                   EVAL      PERRMS = 'FXM0292'
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
      *
      * Clear outputs
      *
     C                   EVAL      PERRMS = *BLANK
     C                   EVAL      POPSEL = *BLANK
     C                   EVAL      PACSEL = *BLANK
     C                   EVAL      PFOTRANSEL = *BLANK
     C                   EVAL      PFOASOCSEL = *BLANK
     C                   CLEAR                   PTMESTPSEL
     C                   EVAL      PINKC = '0'
     C                   EVAL      PINKL = '0'
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
      * Input parameters
      *
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Build sub-file
     C                   PARM                    PBDSFL            1
      *
      * Read subfile record
     C                   PARM                    PRDSFL            1
      *
      * Error in update of previous deal
     C                   PARM                    PERRUP            1
      *
      ** Successful Insert Deal Number
      *
     C                   PARM                    PSIDN             6
      *
      * Output parameters
      *
      * Error message
     C                   PARM                    PERRMS            7
      *
      * Option selected
     C                   PARM                    POPSEL            1
      *
      * Action selected
     C                   PARM                    PACSEL            1
      *
      * FO Transaction ID selected
     C                   PARM                    PFOTRANSEL       20
      *
      * FO ASSOCIATED TRANSACTION ID SELECTED
     C                   PARM                    PFOASOCSEL       20
      *
      * Timestamp of Transaction selected
     C                   PARM                    PTMESTPSEL
      *
      * Command Keys
     C                   PARM                    PINKC
     C                   PARM                    PINKL
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM = 'MMREPORPB'
      *
      ** Move workstation ID to screen field.
      *
     C                   EVAL      DDUSER = PsUser
     C                   EVAL      DDWID = PsJobName
      *
      ** Access bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
      *
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    DDFOTRANID
     C                   KFLD                    PTMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    PTMESTPSEL
     C                   KFLD                    DDFOTRANID
     C     APDSETK0      KLIST
     C                   KFLD                    PMSGTYPE
     C                   KFLD                    DDFOTRANID
     C                   KFLD                    PTMESTPSEL
     C     APDSETKX      KLIST
     C                   KFLD                    PMSGTYPE
     C                   KFLD                    PTMESTPSEL
     C                   KFLD                    DDFOTRANID
      *
      ** Message Type
      *
     C                   MOVEL     'MMRPLD'      PMSGTYPE
      *
      * Format text for invalid transaction deletion function
      *
     C                   EVAL      MSGDNB = 'APA0021'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR1 = MSGTXT
     C                   EVAL      MSGDNB = 'APA0022'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR2 = MSGTXT
     C                   EVAL      MSGDNB = 'APA0023'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR3 = MSGTXT
     C                   EVAL      MSGDNB = 'APA0024'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR4 = MSGTXT
     C                   EVAL      MSGDNB = 'APA0025'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR5 = MSGTXT
     C                   EVAL      MSGDNB = 'APA0026'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR6 = MSGTXT
     C                   EVAL      MSGDNB = 'APA0027'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR7 =  MSGTXT
     C                   EVAL      MSGDNB = 'APA0028'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR8 =  MSGTXT
     C                   EVAL      MSGDNB = 'APA0029'
     C                   EXSR      RTVTXT
     C                   EVAL      DDNAR9 =  MSGTXT
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
Deal No. 999999 successfully inserted.
