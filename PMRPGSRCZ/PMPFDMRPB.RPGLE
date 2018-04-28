     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Invalid portfolio definitions browse')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMPFDMRPB - Invalid Portfolio Definitions Browse             *
      *                                                               *
      *  Function: This module runs in two modes:                     *
      *            - displays a list of invalid Portfolio Definitions *
      *              for selection                                    *
      *            - picks off the selection made                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. 186611             Date 21Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 176287             Date 10Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC011 - 24X7 Midas Availability                             *
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
      *  176287 - Timestamp field not compatible with release level.  *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Browse screen
     FPMPFDMRDF CF   E             WORKSTN
     F                                     SFILE(PMIPFDMS0:WSRRN)
      *
      ** Invalid Portfolio Definitions by timestamp & front office ID
      ** - for record retrieval
     FPMIPFDML0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(PMIPFDMD0:PMIPFDMX0)
      *
      ** Invalid Portfolio Definitions by timestamp & front office ID
      ** - for record update
     FPMIPFDML1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Invalid Log File                                                                     CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
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
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Array containing messages
     D ErrorText       S             52    DIM(1) CTDATA PERRCD(1)
      *
     D InvTr         E DS                  EXTNAME(PMIPFDMPD)
      *
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Timestamp selected
     D PTMESTPSEL      S             26Z
      *
      ** Fields defined for Enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KTimeStamp      S                   LIKE(PTMESTPSEL)                                   CSC011
                                                                                              CSC011
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialisation
      *
     C                   EXSR      SRINIT
      *
      ** Build subfile.
      *
     C     PBDSFL        IFEQ      'Y'
     C                   EXSR      SRBLDSFL
     C                   ENDIF
      *
      ** Read subfile record.
      *
     C     PRDSFL        IFEQ      'Y'
     C                   EXSR      SRRDSFLR
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBLDSFL - Build the subfile for the browse screen           *
      *                                                               *
      *****************************************************************
      *
     C     SRBLDSFL      BEGSR
      *
      ** Check for user authority to browse if not multi-branching.
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      SRCHAUTN
     C                   ENDIF
      *
      ** Initialise subfile relative record number.
      *
     C                   Z-ADD     0             WSRRN             5 0
      *
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     PMIPFDMC0
     C                   MOVE      '0'           *IN97
      *
      ** If previous transaction was not successful due to
      ** Portfolio Definition being updated by another workstation,
      ** then display message on screen.
      *
     C     PERRUP        IFEQ      'Y'
     C                   MOVEL     ErrorText(1)  ERRORMSG
     C                   ELSE
     C                   MOVE      *BLANKS       ERRORMSG
     C                   ENDIF
      *
      ** Write the select screen footer to the screen.
      *
     C                   WRITE     PMIPFDMF1
      *
      ** Set file pointer to start of file.
      *
     C     *LOVAL        SETLL     PMIPFDMX0
      *
      ** Read an invalid Portfolio Definition from file.
      *
     C                   EXSR      SRRDIDEFS
      *
      ** If no records exist - set up an error message.
      ** Display message 'No invalid transactions present'
      ** and then terminate.
      *
     C     WVEOF         IFEQ      'Y'
     C                   MOVEL     'FXM1007'     PERRMS
     C                   EVAL      *IN10 = *OFF
     C                   TIME                    DDTIME
     C                   EXFMT     PMIPFDMEND
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      ** Read records from the file into the subfile until a page
      ** has been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 or F12 is input.
      *
     C     WVEOF         DOWNE     'Y'
     C     *IN98         ANDEQ     '1'
      *
      ** Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             WVCNT             3 0
      *
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
      *
     C     WVEOF         DOWNE     'Y'
     C     WVCNT         ANDLT     12
      *
      ** Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             WSRRN
     C                   ADD       1             WVCNT
      *
      ** Write the invalid Portfolio Definition to the subfile.
      *
     C                   MOVE      *BLANK        DDOPTN
     C                   Z-ADD     WSRRN         DDSFRN
     C                   MOVE      DDTMESTMP     D@TMESTMP                                    176287
     C                   WRITE     PMIPFDMS0
      *
      ** Read next invalid Portfolio Definition.
      *
     C                   EXSR      SRRDIDEFS
     C                   ENDDO
      *
      ** Write the subfile control record to the screen to display
      ** the subfile.
      *
     C                   TIME                    DDTIME
     C                   WRITE     PMIPFDMC0
      *
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.
      *
     C                   READ      PMIPFDMC0                              99
      *
      ** If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           PINKC
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRDSFLR - Read details of the selected subfile record       *
      *                                                               *
      *****************************************************************
      *
     C     SRRDSFLR      BEGSR
      *
      ** Read the subfile for selected records.
      ** Only process those for which the option field is not blank.
      *
     C     *IN99         DOUEQ     '1'
     C     DDOPTN        ORNE      *BLANK
     C                   READC     PMIPFDMS0                              99
      *
      ** Validate repair option code.
      *
     C     *IN99         IFEQ      '0'
     C                   EXSR      SRValidOpt
     C                   ENDIF
      *
      ** If 'E' is input, enquire upon invalid transaction.
      *
     C     *IN99         IFEQ      '0'
     C     DDOPTN        ANDEQ     'E'
     C***************    MOVE      DDTMESTMP     PTMESTPSEL                                   176287
     C                   MOVE      D@TMESTMP     PTMESTPSEL                                   176287
     C                   EXSR      SREnqInv
     C                   MOVEL     *BLANK        DDOPTN
     C                   ENDIF
      *
      ** If 'Q' is input, prompt for deletion of invalid transaction.
      *
     C     *IN99         IFEQ      '0'
     C     DDOPTN        ANDEQ     'Q'
     C                   EXSR      SRPROM_DELT
     C                   MOVEL     *BLANK        DDOPTN
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Return the selected option, action and front office
      ** transaction ID.
      *
     C     *IN99         IFNE      '1'
     C     DDOPTN        ANDNE     *BLANK
     C                   MOVE      DDOPTN        POPSEL
     C                   MOVE      DDACTN        PACSEL
     C                   MOVEL     DDCSNM        PCSNMSEL
     C                   MOVE      DDPREF        PPREFSEL
     C                   MOVE      DDFRNT        PFOTRANSEL
     C*******************MOVE      DDTMESTMP     PTMESTPSEL                                   176287
     C                   MOVE      D@TMESTMP     PTMESTPSEL                                   176287
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCHAUTN - Check for user authority if not multi-branching   *
      *                                                               *
      *****************************************************************
      *
     C     SRCHAUTN      BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    WVERR             1 0
      *
      ** Return error message for user not authorized then terminate.
      *
     C     WVERR         IFEQ      1
     C                   MOVEL     'FXM0292'     PERRMS
     C                   EVAL      *IN10 = *ON
     C                   TIME                    DDTIME
     C                   EXFMT     PMIPFDMEND
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRDIDEFS - Read an invalid Portfolio Definition             *
      *                                                               *
      *****************************************************************
      *
     C     SRRDIDEFS     BEGSR
      *
      ** Reset End of File indicator.
      *
     C                   MOVE      *BLANK        WVEOF             1
      *
      ** Read the invalid records file.
      *
     C                   READ      PMIPFDMX0                              96
      *
      ** End of File
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           WVEOF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidOpt - Validate Repair option code                     *
      *                                                               *
      *****************************************************************
      *
     C     SRValidOpt    BEGSR
      *
     C                   CALLB     'ZAROPTVAL'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Option Code
     C                   PARM                    DDOPTN
      *
      ** Front Office Id
     C                   PARM                    DDFRNT
      *
      ** Booking Branch
     C                   PARM      *BLANKS       DDBRSN            3
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
      *
      ** If F3, bypass further processing.
      *
     C     PINKC         IFEQ      '1'
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDIF
      *
      ** If F12, continue with next option.
      *
     C     PINKL         IFEQ      '1'
     C                   MOVEL     *BLANK        DDOPTN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnqInv - Enquire on invalid transaction                    *
      *                                                               *
      *****************************************************************
      *
     C     SREnqInv      BEGSR
      *
      ** Pass the invalid transaction details to the enquiry.
      *
     C     ZATRNKX0      CHAIN     PMIPFDMX0                          99
      *
     C                   CALLB     'ZAINVTRENQ'
      *                             ==========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Action code
     C                   PARM                    DDACTN
      *
      ** Front Office Id
     C                   PARM                    DDFRNT
      *
      ** Associated Front Office Id
     C                   PARM                    DDAFRT
      *
      ** Timestamp
     C*******************PARM                    DDTMESTMP                                    176287
     C                   PARM                    D@TMESTMP                                    176287
      *
      ** Invalid file names
     C                   PARM      'PMIPFDMPD'   InvFile1         10
     C                   PARM                    InvFile2         10
     C                   PARM                    InvFile3         10
      *
      ** Invalid file data
     C***********        PARM      InvTr         InvFDta1       2000            CAP014 CFT014
     C***********        PARM                    InvFDta2       2000            CAP014 CFT014
     C***********        PARM                    InvFDta3       2000            CAP014 CFT014
     C                   PARM      InvTr         InvFDta1       4000            CFT014
     C                   PARM                    InvFDta2       4000            CFT014
     C                   PARM                    InvFDta3       4000            CFT014
      *
      ** OUTPUT
      ** ======
      *
      * Function Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
      *
      ** If F3, bypass further processing.
      *
     C     PINKC         IFEQ      '1'
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPROM_DELT - Read details of the selected subfile record    *
      *                for deletion                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRPROM_DELT   BEGSR
      *
      ** Setup fields for output (conditioned on customer being PM Customer
      ** and SARs).
      *
     C     PMCUST        IFNE      'Y'
      *
     C     CAC003        IFEQ      'Y'
     C     BGN0ST        ANDEQ     'Y'
     C                   EVAL      WFIELD1 = DDPRF2
     C                   ENDIF
      *
     C     S01464        IFEQ      'Y'
     C     FBFGCP        ANDEQ     'Y'
     C                   EVAL      WFIELD2 = DDCFGC
     C                   ENDIF
      *
     C     BGFUOP        IFEQ      'Y'
     C                   EVAL      WFIELD3 = DDACSQ
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   EVAL      WFIELD1 = DDPTFT
     C                   EVAL      WFIELD2 = DDMNGI
     C                   EVAL      WFIELD3 = *BLANKS
     C                   ENDIF
      *
     C                   CALLB     'ZAINVTRDEL'
      *                             ==========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Action code
     C                   PARM                    DDACTN
      *
      ** Front Office Transaction ID
     C                   PARM                    DDFRNT
      *
      ** Associated Front Office Transaction ID
     C                   PARM                    DDAFRT
      *
      ** Timestamp
     C*******************PARM                    DDTMESTMP                                    176287
     C                   PARM                    D@TMESTMP                                    176287
      *
      ** Narrative & Field Content 1 - 9
     C                   PARM                    DDNAR1           30
     C                   PARM      DDCSNM        DDFLD1           35
     C                   PARM                    DDNAR2           30
     C                   PARM      DDPREF        DDFLD2           35
     C                   PARM                    DDNAR3           30
     C                   PARM      DDPTCY        DDFLD3           35
     C                   PARM                    DDNAR4           30
     C                   PARM      DDPTFN        DDFLD4           35
     C                   PARM                    DDNAR5           30
     C                   PARM      DDDPCL        DDFLD5           35
     C                   PARM                    DDNAR6           30
     C                   PARM      WFIELD1       DDFLD6           35
     C                   PARM                    DDNAR7           30
     C                   PARM      WFIELD2       DDFLD7           35
     C                   PARM                    DDNAR8           30
     C                   PARM      WFIELD3       DDFLD8           35
     C                   PARM      *BLANKS       DDNAR9           30
     C                   PARM      *BLANKS       DDFLD9           35
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKJ             1
     C                   PARM      '0'           PINKL             1
      *
      ** If F3, bypass further processing.
      *
     C     PINKC         IFEQ      '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** If F10, delete invalid Portfolio Definition.
      *
     C     PINKJ         IFEQ      '1'
     C*******************MOVE      DDTMESTMP     PTMESTPSEL                                   176287
     C                   MOVE      D@TMESTMP     PTMESTPSEL                                   176287
     C     ZATRNKD0      CHAIN     PMIPFDMD0                          99
     C     *IN99         IFEQ      '0'
      *                                                                         186611
     C                   MOVE      'D'           DDACTN                         186611
     C                   MOVEL     *BLANKS       EntryData                      186611
     C                   MOVEL     *BLANKS       FileName                       186611
     C                   CALL      'RPC1600'                                    186611
     C                   PARM      InvTr         EntryData      3000            186611
     C                   PARM      'PMIPFDMPD'   FileName         10            186611
      *                                                                         186611
     C                   DELETE    PMIPFDMD0
                                                                                              CSC011
      ** Delete invalid record from the log file.                                             CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   EVAL      KMsgType = 'PMPFDM'                                        CSC011
     C                   EVAL      KFrntOffID = DDFRNT                                        CSC011
     C                   EVAL      KTimeStamp = PTMESTPSEL                                    CSC011
                                                                                              CSC011
     C     KAPILOGL0     CHAIN     APILOGL0                           99                      CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF
     C                   COMMIT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialisation                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *                                                                                       CSC011
      * If 24x7 is present then journal APILOGL0                                              CSC011
      *                                                                                       CSC011
     C                   IF        (CSC011 = 'Y')                                             CSC011
     C                   OPEN      APILOGL0                             22                    CSC011
     C                   ENDIF                                                                CSC011
      *
      ** Clear output
      *
     C                   MOVE      '0'           PINKC
     C                   MOVE      *BLANK        PERRMS
     C                   MOVE      *BLANK        POPSEL
     C                   MOVE      *BLANK        PACSEL
     C                   MOVE      *BLANK        PCSNMSEL
     C                   MOVE      *BLANK        PPREFSEL
     C                   MOVE      *BLANK        PFOTRANSEL
      *
     C                   MOVE      *BLANKS       WFIELD1          35
     C                   MOVE      *BLANKS       WFIELD2          35
     C                   MOVE      *BLANKS       WFIELD3          35
      *
     C                   CLEAR                   PTMESTPSEL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRTVTXT - Retrieve text narrative for transaction deletion  *
      *                                                               *
      *****************************************************************
      *
     C     SRRTVTXT      BEGSR
      *
     C                   CALL      'SDRTVTXT'
     C                   PARM                    MSGDNB            7
     C                   PARM      'ZZGBMSGF  '  MSGNM            10
     C                   PARM      *BLANK        MSGTXT           80
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
     C                   PARM                    RetCodeIn
      *
      ** Build subfile
     C                   PARM                    PBDSFL            1
      *
      ** Read subfile record
     C                   PARM                    PRDSFL            1
      *
      ** Error in update of previous transaction
     C                   PARM                    PERRUP            1
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST            1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT            7
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC            3
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST            1
      *
      ** SDSCFE - Custody Fees Group for Portfolio
     C                   PARM                    FBFGCP            1
      *
      ** SDMMOD - Futures & Options
     C                   PARM                    BGFUOP            1
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Safe Custody Fees feature
     C                   PARM                    S01464            1
      *
      ** Profit Centre feature
     C                   PARM                    CAC003            1
      *
      ** OUTPUT
      ** ======
      *
      ** Error message
     C                   PARM                    PERRMS            7
      *
      ** Option selected
     C                   PARM                    POPSEL            1
      *
      ** Action Selected
     C                   PARM                    PACSEL            1
      *
      ** Customer Selected
     C                   PARM                    PCSNMSEL         10
      *
      ** Portfolio Reference Selected
     C                   PARM                    PPREFSEL          4
      *
      ** Front Office Transaction ID selected
     C                   PARM                    PFOTRANSEL       20
      *
      ** Timestamp of transaction selected
     C                   PARM                    PTMESTPSEL
      *
      ** Command key
     C                   PARM                    PINKC             1
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
                                                                                              CSC011
      ** Access SDSTAT and SC24X7 if CSC011 is on.                                            CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   ENDIF                                                                CSC011
      *
      ** Key List
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    DDFRNT
     C                   KFLD                    PTMESTPSEL
      *
     C     ZATRNKX0      KLIST
     C                   KFLD                    PTMESTPSEL
     C                   KFLD                    DDFRNT
                                                                                              CSC011
     C     KAPILOGL0     KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011
      *
      ** Format text for invalid transaction deletion function.
      *
     C                   MOVEL     'APA0002'     MSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     MSGTXT        DDNAR1
     C                   MOVEL     'APA0122'     MSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     MSGTXT        DDNAR2
     C                   MOVEL     'APA0124'     MSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     MSGTXT        DDNAR3
     C                   MOVEL     'APA0125'     MSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     MSGTXT        DDNAR4
     C                   MOVEL     'APA0128'     MSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     MSGTXT        DDNAR5
      *
      ** Condition additional narratives on fields used in Delete
      ** Invalid Transaction option based on PM Customer flag and
      ** on their corresponding switchability features.
      *
     C     PMCUST        IFNE      'Y'
      *
     C                   MOVEL     *BLANKS       DDNAR6
     C                   MOVEL     *BLANKS       DDNAR7
     C                   MOVEL     *BLANKS       DDNAR8
      *
     C     CAC003        IFEQ      'Y'
     C     BGN0ST        ANDEQ     'Y'
     C                   MOVEL     'APA0129'     MSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     MSGTXT        DDNAR6
     C                   ENDIF
      *
     C     S01464        IFEQ      'Y'
     C     FBFGCP        ANDEQ     'Y'
     C                   MOVEL     'APA0130'     MSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     MSGTXT        DDNAR7
     C                   ENDIF
      *
     C     BGFUOP        IFEQ      'Y'
     C                   MOVEL     'APA0131'     MSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     MSGTXT        DDNAR8
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVEL     'APA0126'     MSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     MSGTXT        DDNAR6
     C                   MOVEL     'APA0127'     MSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     MSGTXT        DDNAR7
     C                   MOVEL     *BLANKS       DDNAR8
     C                   ENDIF
      *
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**  Array of error messages - ErrorText
The last transaction was not applied to the database
