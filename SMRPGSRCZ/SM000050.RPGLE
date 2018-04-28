     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Maintain Account Code Conversion Table')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000050 - Manintain Account Code Conversion Table           *
      *                                                               *
      *  Function: This program will display all the Account Codes    *
      *            in SMAC10PD on a subfile and allow for maintenance *
      *            on the file.                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BUG27641           Date 07May10               *
      *  Prev Amend No. 260070             Date 07May10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSM007  *CREATE    Date 29Sep05               *
      *  Prev Amend No. NNNxxx             Date XXnnnXX               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  BUG27641 - Apply fix 260070                                  *
      *  260070 - Last record not displayed.  Display codes in order. *
      *  CSM007 - Change Account Codes Utility                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *       03         F3 has been pressed (Exit program)           *
      *       05         F5 has been pressed (Refresh screen)         *
      *       27         On to display next subfile page              *
      *       38         Invalid new Account code entry               *
      *       40         Account Code found in the array @10ACCD      *
      *       45         There is at least one changed SF rec         *
      *       73         End of file of SMAC10L0                      *
      *       80         Clear subfile                                *
      *       81         Display subfile. (no. of records > 0)        *
      *       84         Subfile next change                          *
      *       88         Do not show record                           *
      *       86         Subfile putover                              *
      *       92         EOF of changed subfile records               *
      *       99         Global error flag                            *
      *                                                               *
     F*****************************************************************
      *                                                               *
      *  Subroutines                                                  *
      *                                                               *
      * InitNLoadSF   - Initialise and load subfile page              *
      * LoadSubfile   - Load subfile page                             *
      * DspScreen     - Display screen                                *
      * ProcScreenIP  - Process screen input                          *
      * ProcChgSFRecs - Process all modified subfile records          *
      * ValNewAcod    - Validate new Account Code field               *
      * ChkExist      - Check if New branch exists in other zones or  *
      *                 new zone                                      *
      * MovY2LoadSFReq- Move 'Y' to ReloadSFReq indicator             *
      * ZASNMS        - Send message to program's message queue       *
      * ExitPgm       - Set on *in LR and return                      *
      * *INZSR        - Initialise                                    *
      * LoadAllAcArr  - Load all the Account Codes from SMAC10PD      *
      *                 into array @10ACCD                            *
      * *PSSR         - Error processing                              *
      *                                                               *
      *****************************************************************
     FSM000050DFCF   E             WORKSTN SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SM Maintenance of Account Codes
      *
     F**AC10L0  IF   E             DISK    INFSR(*PSSR) RENAME(SDAC10F:SDAC10L)               260070
     FSMAC10L0  IF   E           K DISK    INFSR(*PSSR) RENAME(SDAC10F:SDAC10L)               260070
      * Read : Midas SM Account Codes to be converted
      *
     FSMAC10PD  UF   E           K DISK    INFSR(*PSSR)
      * WRT : Midas SM Account Codes to be converted
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      * Program data structure
     D/COPY ZACPYSRC,PSDS
      *
      * Display file information data structure
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      * Array holding all converted Account Codes from the file
     D                 DS
     D @10ACCD                       19    DIM(9999)                            MaxEntry size
     D  Accd4fld                      4  0 Overlay(@10ACCD : 1)
     D  Accd10fld                    10    Overlay(@10ACCD : 5)
      *
      * Data structure to turn the 10 digit account code from the first read of SMAC10PD to String
     D                 DS
     D  FileAcodN              1     10  0
     D  FileAcodS              1     10
      *
      * Data structure used to fill the @FileACCD array to allow for checking if the 10 digit
      * account code already exists
   25D                 DS
     DFileAccount                    19
     D  FileAcod4              1      4  0
     D  FileAcod10             5     14
     D  FileRRN               15     19  0
      *
     D ZAPGMQ          S             10                                         Program queue
     D ZAPGRL          S              5                                         Rel queue
     D ZAMSID          S              7                                         Message ID
     D ZAMSGF          S             10                                         Message file
     D ZAMSDA          S            132                                         Message data
     D ZAMSTP          S              7                                         Message type
     D Wrun            S              1
      *
     D Idx             S              5  0                                      Array index
     D MaxEntry        S              5  0 INZ(9999)                            @AllAccntCode dimens
      *
     D PrevNewAcod     S             10                                         Previous A/C Code
     D Num             S              2  0
     D Digits          C                   '0123456789'
      *
      *****************************************************************
      *
     C                   DO        *HIVAL
      *
      * Initialise & load subfile page
     C                   EXSR      InitNLoadSF
     C                   MOVEL     'N'           ReloadSFReq       1
      *
      * Display screen until reload requested
     C     ReloadSFReq   DOWEQ     'N'
      *
      * Display screen
     C                   EXSR      DspScreen
      *
      * Process response
      * Cancel & exit program
     C   03              CAS                     ExitPgm
      *
      * Request subfile reload
     C   05              CAS                     MovY2LoadSFReq
      *
      * Display next SFL page
     C   27              CAS                     LoadSubfile
      *
      * Process screen input
     C                   CAS                     ProcScreenIP
     C                   END
      *
     C                   END                                                    OD ReloadSFReq
     C                   END                                                    OD *HIVAL
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * InitNLoadSF - Initialise and load subfile page                *
      *                                                               *
      * Called by:    Main processing                                 *
      *                                                               *
      * Calls:        LoadSubfile                                     *
      *                                                               *
      *****************************************************************
      *
     C     InitNLoadSF   BEGSR
      *
      * Clear subfile
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
      *
     C                   SETOFF                                       80
      *
      * Reset no of records in subfile
     C                   Z-ADD     1             ##RRMX            5 081         SETOF 81
      *
     C                   EVAL      Idx = 1
      *
      * Load subfile page
     C                   Z-ADD     0             ##RROK            5 0
      *
      * Set required pages based on *Set Cursor or *Subfile Pages
     C     W0RR0         IFGT      0
     C     WSFRR         DIV       ##SFPG        ##SPG             3 0
     C                   MVR                     ##SLIN            3 0
     C     ##SLIN        IFGT      0
     C                   ADD       1             ##SPG
     C                   END
      * Compute lines required based on pages
     C     ##SPG         MULT      ##SFPG        ##SFLN            9 0
     C                   END
      *
     C                   EXSR      LoadSubfile
      *
     C     InitNLoadSFE  ENDSR
      *
      *****************************************************************
      *                                                               *
      * LoadSubfile - Load subfile page                               *
      *                                                               *
      * Called by:    Main processing                                 *
      *               InitNLoadSF                                     *
      *                                                               *
      * Calls:        ZASNMS                                          *
      *                                                               *
      *****************************************************************
     C     LoadSubfile   BEGSR
      *
      * Setof field error indicators
     C                   SETOFF                                       38
      *
      * Start at previous highest record in SFL
     C                   Z-ADD     ##RRMX        ##RR              5 0
      *
      * Reset count of DBF records read
     C                   Z-ADD     0             ##RRRD            5 0
      *
      * If page down active
     C                   IF        *IN27 = '1'
     C                   Eval      ##SFRC = ##RR
     C                   EndIf
      *
      * Load next SFL page until SFL page full, or
      * All pages loaded
     C     ##RROK        DOWLT     ##SFPG
     C     W0SPG         ANDLE     ##SPG
      * If current record is not the last
     C     ##RR          IFLT      WSFRR
      *
      * Load SFL fields
     C                   Eval      FileAccount = @10ACCD(Idx)
     C                   EVAL      #1OLDAC = FileAcod4                          Old Account Code
     C                   EVAL      #1NWACS = FileAcod10                         New Account Code
      *
      * If last record but page is not full then put out blank records
     C                   ELSE
     C                   EVAL      #1OLDAC = *Zero                              Old Account Code
     C                   EVAL      #1NWACS = *BLANKS                            New Account Code
      * Set on indicator to show that the field should not be shown
     C                   SETON                                        88
     C                   ENDIF
      *
      * Output to subfile
      *
     C                   WRITE     #SFLRCD
     C                   EVAL      Idx             = Idx  + 1
     C                   ADD       1             ##RR
     C                   ADD       1             ##RROK               81        *
     C                   SETOFF                                       88
      *
      * Increment scan check count
     C                   ADD       1             ##RRRD
     C                   ENDDO                                                  ODW E
      *
     C     W0SPG         IFGE      ##SPG
      * 'End of file' reached set on indicator and set off the next page indicator
     C                   SETON                                        82
     C                   SETOFF                                       27
     C                   END
      *
      * If no DBF records found, display error message
     C     ##RR          IFEQ      *ZERO
      *
      *
      * Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI ##RR = *ZERO
      *
     C                   ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
      *
      * If scan limit reached, display error message
     C     ##RRRD        IFGE      W0SLM
      *
      * Send message '*Scan limit reached'
     C                   MOVEL     'Y2U0017'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   Z-ADD     0             ##RROK
     C                   END
      *
     C     LoadSubfileE  ENDSR
      *
      *****************************************************************
      *                                                               *
      * DspScreen - Display screen                                    *
      *                                                               *
      * Called by:  Main processing                                   *
      *                                                               *
      * Calls:      ZASNMS                                            *
      *                                                               *
      *****************************************************************
     C     DspScreen     BEGSR
      *
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
      *
      * Update screen time
     C                   TIME                    ##TME
      *
      * PUTOVR unless conditioned fields change
     C                   SETON                                        86
     C     *IN81         IFNE      CAIN81
     C                   SETOFF                                       86
     C                   END
     C                   MOVE      *IN81         CAIN81            1
      *
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
      *
      * Maintain subfile position where possible
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   END
     C                   Eval      W0SPG = W0SPG + 1
      *
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
     C                   SETOFF                                         8392    *
      *
     C     DspScreenE    ENDSR
      *
      *****************************************************************
      *                                                               *
      * ProcScreenIP - Process screen input                           *
      *                                                               *
      * Called by:     Main processing                                *
      *                                                               *
      * Calls:         ProcChgSFRecs                                  *
      *                ExitPgm                                        *
      *                                                               *
      *****************************************************************
      *
     C     ProcScreenIP  BEGSR
      *
      * If there is no record on screen, redisplay the SF only
     C                   IF        *IN81 = '0'
     C                   EVAL      ReloadSFReq  = 'Y'
     C                   GOTO      ProcScreenIPE
     C                   ENDIF                                                  FI *IN81 = '0'
      *
      * Validate changed subfile records
     C                   EXSR      ProcChgSFRecs
      *
      * If dup error, quit further processing
     C     *IN99         CABEQ     '1'           ProcScreenIPE
      *
      * No error:
      *  Write records where branch to be converted to SMBRCCVTPD.
      *
      *  Exit program
     C                   EXSR      ExitPgm
      *
     C     ProcScreenIPE ENDSR
      *
      *****************************************************************
      *                                                               *
      * ProcChgSFRecs - Process all modified subfile records          *
      *                                                               *
      * Called by:      ProcScreenIP                                  *
      *                                                               *
      * Calls:          ValNewAcod                                    *
      *                                                               *
      *****************************************************************
      *
     C     ProcChgSFRecs BEGSR
      *
      * Initialise the at least one changed SF rec indicator
     C                   EVAL      *IN45 = '0'
      *
     C                   READC     #SFLRCD                                92    *EOF
      *
      * while not EOF of changed record
     C                   DOW       *IN92 = '0'
      *
     C  N45              EVAL      *IN45 = '1'
      *
      * Validate new Account Code Entry
     C                   EXSR      ValNewAcod
      *
     C                   UPDATE    #SFLRCD
      * Update the approriate Array fields
     C                   EVAL      FileAccount = @10ACCD(##RR)
     C                   Eval      FileAcodS  = #1NWACS
     C     FileAcod4     CHAIN     SMAC10PD
     C                   Eval      FileAcodS  = #1NWACS
     C                   Eval      ACOD10 = FileAcodN
     C                   UPDATE    SDAC10F
      *
     C                   READC     #SFLRCD                                92    *
      *
     C                   END
      *
     C     ProcChgSFRecsEENDSR
      *
      *****************************************************************
      *                                                               *
      * ValNewAcod    - Validate new Account Code field               *
      *                                                               *
      * Called by:      ProcChgSFRecs                                 *
      *                                                               *
      * Calls:          ChkExist                                      *
      *                 ZASNMS                                        *
      *                                                               *
      *****************************************************************
      *
     C     ValNewAcod    BEGSR
      *
      * Setoff error indicator and SFLNXTCHG
     C                   SETOFF                                       3884      *
      *
      * Check to see if the field contains only numeric characters
     C     Digits        CHECK     #1NWACS       Num
     C                   IF        %FOUND
      * Display the information message that the field does not contain all numerics
     C                   SETON                                        38
     C                   EVAL      ZAMSID  = 'USR5200'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      * Else check the new account code does not already exist
     C                   EXSR      ChkExist
      *
      * Invalid new branch entry
     C                   IF        *IN38 = '1'
      * SFLRCD invalid
     C  N99              Z-ADD     ##RR          ##SFRC               99        *
      * SFLNXTCHG
     C                   SETON                                        84
     C                   ENDIF                                                  FI *IN38 = '1'
      *
     C     ValNewAcodE   ENDSR
      *
      *****************************************************************
      *                                                               *
      * ChkExist   - Check if New Account Code exists already         *
      *                                                               *
      * Called by:   ValNewAcod                                       *
      *                                                               *
      * Calls:       ZASNMS                                           *
      *                                                               *
      *****************************************************************
      *
     C     ChkExist      BEGSR
      *
      * Check if New Account Code exists
     C     #1NWACS       LOOKUP    Accd10fld                              40    exist already
      *
      * If new account code exists.
     C                   IF        *IN40   = '1'
      * Check if it not just a retyping of the original record (ie exists)
     C     #1OLDAC       LOOKUP    Accd4fld                               41    not original
     C                   IF        *IN41   = '0'
      * Send an error message that the account code already exists and Not the same record
     C                   SETON                                        38
     C                   EVAL      ZAMSID  = 'USR5201'
     C                   EXSR      ZASNMS
     C                   Else
      * If the Account code exists and the 4 digit account code is the same (ie not changed)
      * Reset Indicator 40
     C                   SETOFF                                       40
     C                   ENDIF                                                  FI *IN40 <> '0'
     C                   ENDIF                                                  FI *IN40 = '1'
      *
     C     ChkExistE     ENDSR
      *
      *****************************************************************
      *                                                               *
      * MovY2LoadSFReq - Move 'Y' to ReloadSFReq indicator            *
      *                                                               *
      * Called by:  Main processing when F5 is pressed                *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     MovY2LoadSFReqBEGSR
      *
      *
     C                   MOVEL     'Y'           ReloadSFReq
      *
     C     MovY2LoadSFRqEENDSR
      *
      *****************************************************************
      *                                                               *
      * ZASNMS -   Send message to program's message queue            *
      *                                                               *
      * Called by: LoadSubfile                                        *
      *            DspScreen                                          *
      *            ProcScreenIP                                       *
      *            ValNewAcod                                         *
      *            ChkExist                                           *
      *            *INZSR                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     ZASNMS        BEGSR
      *
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      *
      * If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ                         Program queue
     C                   PARM                    ZAPGRL                         Rel queue
     C                   PARM                    ZAMSID                         Message ID
     C                   PARM                    ZAMSGF                         Message file
     C                   PARM                    ZAMSDA                         Message data
     C                   PARM                    ZAMSTP                         Message type
      *
      * Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *
     C     ZAEXIT        ENDSR
      *
      *****************************************************************
      *                                                               *
      * ExitPgm     - Set on *INLR and exit program                   *
      *                                                               *
      * Called by:    ProcScreenIp                                    *
      *               Main processing when F3 is pressed              *
      *                                                               *
      * Calls:        None                                            *
      *                                                               *
      *****************************************************************
      *
     C     ExitPgm       BEGSR
      *
     C                   SETON                                        LR
      *
     C                   RETURN
      *
     C     ExitPgmE      ENDSR
      *
      *****************************************************************
      *                                                               *
      * *INZSR -   Program Initialisation routine                     *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls:     LoadAllAcArr                                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      * Move program status structure fields for display
     C                   MOVEL     PSProcName    ##PGM
     C                   MOVEL     PSJobName     ##JOB
     C                   MOVEL     PSUser        ##USR
      *
     C                   MOVEL     *BLANK        ReloadSFReq       1
      *
      * Update screen time
     C                   TIME                    ##TME             6 0
      *
      * Obtain default message file
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      *
     C                   Z-ADD     17            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
      *
      * Maximum record number
     C                   Z-ADD     *ZERO         ##RRMX
      *
      * Scan limit
     C                   Z-ADD     9999          W0SLM             5 0
     C                   Z-ADD     0000          WSFRR             5 0
      *
      * Subfile pages
     C                   Z-ADD     1             W0SPG             3 0
      *
      * Processed Subfile record
     C                   Z-ADD     1             W0RR0             4 0
      *
      * Reset count of DBF records read
     C                   Z-ADD     0             ##RRRD            5 0
      *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      AGMRDT        ##MRDT            7            RUN DATE
      *
      * Load all the Account Codes into the Array FileAccount
     C                   EXSR      LoadAllACArr
      *
     C     INZSRE        ENDSR
      *
      *****************************************************************
      *                                                               *
      * LoadAllACArr - Load all the Account code records into array   *
      *                FileAccount                                    *
      *                Then the array is sorted by Original Account   *
      *                Code                                           *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls:     *PSSR                                              *
      *                                                               *
      *****************************************************************
      *
     C     LoadAllAcArr  BEGSR
      *
      * Initialize array index.
     C                   EVAL      Idx  = 1
      * Initialize File Relative record Number
     C                   EVAL      FileRRN = 1
      *
     C*****1             Setll     SMAC10L0                                                   260070
     C     0001          Setll     SMAC10L0                                                   260070
      *
      * Load all branches of the zone to array
     C                   READ      SMAC10L0                               73    Eof
      *
     C                   DOW       *IN73 <> '1'      AND
     C                             Idx  <= MaxEntry                             MaxEntry = 100
     C                   Eval      FileAcod4    = ACOD4
     C                   Eval      FileAcodN    = ACOD10
     C                   Eval      FileAcod10   = FileAcodS
     C                   EVAL      @10ACCD(Idx) = FileAccount
     C                   EVAL      Idx             = Idx  + 1
     C                   EVAL      FileRRN         = FileRRN + 1
     C                   READ      SMAC10L0                               73    Eof
     C                   ENDDO                                                  ODW *IN73 <> '1'
      *
      * Abort this program when all the array entries have been filled up and
      * still some branches left.
     C                   IF        Idx > MaxEntry
     C                   IF        *IN73 = '0'
     C                   EXSR      *PSSR
     C                   GOTO      LoadAllAcArrE
     C                   ENDIF                                                  FI (*IN73 = '0')
     C                   ENDIF                                                  FI Idx > MaxEntry
      *
      * Set count of records read
     C*******            EVAL      WSFRR = FileRRN - 1                                        260070
     C                   EVAL      WSFRR = FileRRN                                            260070
      *
     C     LoadAllAcArrE ENDSR
      *
      *****************************************************************
      *                                                               *
      * *PSSR  -   Program exception error routine                    *
      *            Called automatically if a program error occurs,    *
      *            or directly by the program code using EXSR.        *
      *            This subroutine DUMPs the program just once.       *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Wrun = *BLANK
     C                   EVAL      Wrun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
