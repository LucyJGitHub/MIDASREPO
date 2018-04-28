     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*XBIA*  OVRDBF FILE(NEWZOBRL1) TOFILE(SDBRCHL1)                      *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Enter new branches for conversion Subfile')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM1090 - Enter new branches for conversion in new zone       *
      *                                                               *
      *  Function: This program will display all the branch codes in a*
      *            zone (SDBRCHPD) on subfile and allow for input of  *
      *            new branch codes. The branch codes must be unique  *
      *            in all zones.                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CGP009             Date 22Dec04               *
      *                 CUP025  *CREATE    Date 05Jan04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP009 - Local Zone Time Difference (Recompile)              *
      *  CUP025 - Change branches utility                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *       03         F3 has been pressed (Exit program)           *
      *       05         F5 has been pressed (Refresh screen)         *
      *       27         On to display next subfile page              *
      *       38         Invalid new branch entry                     *
      *       40         Branch code found in the array @AllBrches    *
      *       41         Chain fail to NEWZOBRL1                      *
      *       45         There is at least one changed SF rec         *
      *       72         End of file of GPZONEPD                      *
      *       73         End of file of SDBRCHPD in zone              *
      *       80         Clear subfile                                *
      *       81         Display subfile. (no. of records > 0)        *
      *       82         End of file                                  *
      *       84         Subfile next change                          *
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
      * ValNewBrch    - Validate new branch field                     *
      * ChkExist      - Check if New branch exists in other zones or  *
      *                 new zone                                      *
      * ChkDupNewBr   - Check if new branches are unique              *
      * LoadCvtBrArr  - Load the new branches entered to array        *
      *                 @CvtBrArr                                     *
      * WrtCvtBrRecs  - Write records to file SMBRCCVTPD              *
      * MovY2LoadSFReq- Move 'Y' to ReloadSFReq indicator             *
      * ZASNMS        - Send message to program's message queue       *
      * ExitPgm       - Set on *in LR and return                      *
      * *INZSR        - Initialise                                    *
      * LoadAllBrArr  - Load all the branches from existing zones     *
      *                 into array @AllBrches.                        *
      * *PSSR         - Error processing                              *
      *                                                               *
      *****************************************************************
     FSM1090DF  CF   E             WORKSTN SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SM Maintenance of branch codes in a zone
      *
     FNEWZOBRL1 IF   E           K DISK    INFSR(*PSSR)
     F                                     Prefix(NewZo_)
      * RTV : Midas SD Branch codes retrieval (for the new zone)
      *
     FSMBRCCVTPDUF A E             DISK    INFSR(*PSSR)
      * WRT : Midas SM Branches to be converted
      *
     FGPZONEPD  IF   E             DISK    USROPN
     F                                     INFSR(*PSSR)
      * RTV : Midas GP Zones
      *
     FSDBRCHPD  IF   E             DISK    USROPN
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Branch codes
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
      * Array holding all branches from existing zones
     D @AllBrches      S              3    DIM(9999)
     D                                     DESCEND
      *
      * Array holding all converted branches for new zone
     D @CvtBrches      S             11    DIM(9999)                            MaxEntry size
     D                                     DESCEND                              by new branch
      *
      * Entry for array @CvtBrches
     D                 DS
     DCvtBrchesEntry           1     11
     D  CvtNewBrch             1      3
     D  CvtOldBrch             4      6
     D  CvtRRN                 7     11  0
      *
      * Library containing the SDBRCHL1 for the zone.
     D                 DS
     D ZoneDMLib               1      7
     D ZOMSYS                  1      2
     D DMLIB                   3      7    INZ('DMLIB')
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
     D MaxEntry        S              5  0 INZ(9999)                            @AllBrches dimension
      *
     D CmdString       S             50
     D CmdLen          S             15  5 INZ(50)                              Command Length= 50
      *
      * Constant strings used to make up the OVRDBF command.
     D OVRF_cmd        C                   'OVRDBF SDBRCHPD '
     D TOFILEKwrd      C                   '/SDBRCHPD SECURE(*YES)'
      *
     D PrevNewBrch     S              3                                         Previous new branch
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
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
      *
      * Get the first record from file NEWZOBRL1
     C     *LOVAL        SETLL     NEWZOBRL1
     C                   READ      NEWZOBRL1                              82    *82=EOF
      *
      * Load subfile page
     C                   Z-ADD     0             ##RROK            5 0
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
      * Set required pages based on *Set Cursor or *Subfile Pages
     C     W0RR0         IFGT      0
     C     W0RR0         DIV       ##SFPG        ##SPG             3 0
     C                   MVR                     ##SLIN            3 0
     C     ##SLIN        IFGT      0
     C                   ADD       1             ##SPG
     C                   END
     C     W0SPG         IFGT      ##SPG
     C                   Z-ADD     W0SPG         ##SPG
     C                   END
     C                   ELSE
     C                   Z-ADD     W0SPG         ##SPG
     C                   END
      *
      * Compute lines required based on pages
     C     ##SPG         MULT      ##SFPG        ##SFLN            9 0
     C     ##SFLN        IFGT      999
     C                   Z-ADD     999           ##SFLN
     C                   END
      *
      * Load next SFL page until SFL page full, or
      * Scan limit reached, or End of file
     C     *IN82         DOWEQ     '0'                                          DO
     C     ##RROK        ANDLT     ##SFLN
     C     ##RRRD        ANDLT     W0SLM
      *
      * Load SFL fields
     C                   EVAL      #1OLDB = NewZo_A8BRCD                        Old branch code
      *
     C     NewZo_A8BRCD  LOOKUP    @AllBrches                             40    Brch found in array
     C   40              EVAL      #1EXST = 'Y'
     C   40              SETON                                        84        SF next change
     C  N40              EVAL      #1EXST = *BLANK                              Exist?
     C  N40              SETOFF                                       84        SF next change
      *
     C                   EVAL      #1NEWB = *BLANK                              New branch code
      *
      * Output to subfile
     C                   ADD       1             ##RR
     C                   ADD       1             ##RROK               81        *
      *
     C                   WRITE     #SFLRCD
      *
      * Increment scan check count
     C                   ADD       1             ##RRRD
      *
      * Read next record
     C                   READ      NEWZOBRL1                              82    *82=EOF
      *
     C                   ENDDO                                                  ODE *IN82 = '0'
      *
      * If no DBF records found, display error message
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
      *
      * Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI ##RR = *ZERO
      *
      * Save highest SFL record load can continue at end point
     C     ##RR          IFGT      ##RRMX
      *
      * Calculate top line
     C     ##RROK        DIV       ##SFPG        ##SPG
     C                   MVR                     ##SLIN
     C     ##SLIN        IFGT      0
     C     ##RR          SUB       ##SLIN        ##SFRC
     C                   ELSE
     C     ##RR          SUB       ##SFPG        ##SFRC
     C                   END
     C                   ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
     C                   END
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
      *                ChkDupNewBr                                    *
      *                WrtCvtBrRecs                                   *
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
      * If error, quit further processing
     C     *IN99         CABEQ     '1'           ProcScreenIPE
      *
      * Check for any duplicate new branches entered when there is changed SF rec
     C   45              EXSR      ChkDupNewBr
      *
      * If dup error, quit further processing
     C     *IN99         CABEQ     '1'           ProcScreenIPE
      *
      * No error:
      *  Write records where branch to be converted to SMBRCCVTPD.
     C                   EXSR      WrtCvtBrRecs
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
      * Calls:          ValNewBrch                                    *
      *                                                               *
      *****************************************************************
      *
     C     ProcChgSFRecs BEGSR
      *
      * Initialise the at least one chagned SF rec indicator
     C                   EVAL      *IN45 = '0'
      *
     C                   READC     #SFLRCD                                92    *EOF
      *
      * while not EOF of changed record
     C                   DOW       *IN92 = '0'
      *
     C  N45              EVAL      *IN45 = '1'
      *
      * Validate new branch entry
     C                   EXSR      ValNewBrch
      *
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92    *
      *
     C                   END
      *
     C     ProcChgSFRecsEENDSR
      *
      *****************************************************************
      *                                                               *
      * ValNewBrch    - Validate new branch field                     *
      *                                                               *
      * Called by:      ProcChgSFRecs                                 *
      *                                                               *
      * Calls:          ChkExist                                      *
      *                 ZASNMS                                        *
      *                                                               *
      *****************************************************************
      *
     C     ValNewBrch    BEGSR
      *
      * Setoff error indicator and SFLNXTCHG
     C                   SETOFF                                       3884      *
      *
     C                   IF        #1NEWB  <> *BLANK
      *
     C                   IF        #1OLDB  = #1NEWB
     C                   SETON                                        38
     C                   EVAL      ZAMSID  = 'USR5101'
     C                   EXSR      ZASNMS
     C                   ELSE
      * Else new branch not same as branch to be converted from,
      *      Check if New branch already exist in other zones or new zone
     C                   EXSR      ChkExist
     C                   ENDIF                                                  FI #1OLDB = #1NEWB
      *
     C                   ELSE
      * Else new branch is blank,
      *      If old branch already exists, New branch must be entered.
     C                   IF        #1EXST  = 'Y'
     C                   SETON                                        38
     C                   EVAL      ZAMSID  = 'USR5100'
     C                   EXSR      ZASNMS
     C                   ENDIF                                                  FI #1EXST  = 'Y'
      *
     C                   ENDIF                                                  FI #1NEWB  <> *BLANK
      *
      * Invalid new branch entry
     C                   IF        *IN38 = '1'
      * SFLRCD invalid
     C  N99              Z-ADD     ##RR          ##SFRC               99        *
      * SFLNXTCHG
     C                   SETON                                        84
     C                   ENDIF                                                  FI *IN38 = '1'
      *
     C     ValNewBrchE   ENDSR
      *
      *****************************************************************
      *                                                               *
      * ChkExist   - Check if New branch exists in other zones or new *
      *              zone                                             *
      *                                                               *
      * Called by:   ValNewBrch                                       *
      *                                                               *
      * Calls:       ZASNMS                                           *
      *                                                               *
      *****************************************************************
      *
     C     ChkExist      BEGSR
      *
      * Check if New branch exists in other zones.
     C     #1NEWB        LOOKUP    @AllBrches                             40    exist in other zones
      *
      * Error if new branch exists in other zones.
     C                   IF        *IN40   = '1'
     C                   SETON                                        38
     C                   EVAL      ZAMSID  = 'USR5102'
     C                   EXSR      ZASNMS
      *
     C                   ELSE
      * Else not exist in other zones:
      *      check if new branch exists in new zone
     C     #1NEWB        CHAIN     NEWZOBRL1                          41        ON, no record found
     C                   IF        *IN41 = '0'                                  Record found
     C                   SETON                                        38
     C                   EVAL      ZAMSID  = 'USR5103'
     C                   EXSR      ZASNMS
     C                   ENDIF                                                  FI *IN41 = '0'
     C
     C                   ENDIF                                                  FI *IN40 = '1'
      *
     C     ChkExistE     ENDSR
      *
      *****************************************************************
      *                                                               *
      * ChkDupNewBr   - Check if new branches are unique.             *
      *                 Highlight and send error messages for any     *
      *                 duplicated new branches.                      *
      *                                                               *
      * Called by:      ProcScreenIP                                  *
      *                                                               *
      * Calls:          LoadCvtBrArr                                  *
      *                                                               *
      *****************************************************************
      *
     C     ChkDupNewBr   BEGSR
      *
      * Load new branches to @CVTBrches
     C                   EXSR      LoadCvtBrArr
      *
      * Sort array by NEW branches and in descending order
     C                   SORTA     @CvtBrches
      *
      * Check if there is any duplicated new branches in @CvtBr
      * If duplicated found, update the SF record and send error message
      *
      * Check if DupEntry is same as its previous entry...
      *
      * Initialise variables.
     C                   EVAL      Idx            = 1
     C                   EVAL      PrevNewBrch    = *BLANK
      *
     C                   EVAL      CvtBrchesEntry = @CvtBrches(Idx)
      *
     C                   DOW       Idx        <=  MaxEntry    AND
     C                             CvtNewBrch <> *BLANK
      *
      * If CvtNewBrch same as PrevNewBrch, update SF Record with field error indicator ON.
     C                   IF        PrevNewBrch = CvtNewBrch
      *
     C     CvtRRN        CHAIN(E)  #SFLRCD
      * Set on New branch indicators and SFLNXTCHG ind.
     C                   SETON                                        3884
     C  N99              Z-ADD     CvtRRN        ##SFRC               99        Global error
     C                   UPDATE    #SFLRCD
      *
      * Send message 'Duplicate new branch is not allowed.'
     C                   MOVEL     'USR5104'     ZAMSID
     C                   EXSR      ZASNMS
      *
     C                   ENDIF                                                  FI Dup1to71=PreDupEn
      *
      * Update PrevNewbrch with present CvtNewBrch
     C                   EVAL      PrevNewBrch    = CvtNewBrch
      *
      * increment count for next entry
     C                   EVAL      Idx            = 1  + Idx
     C                   IF        Idx           <= MaxEntry
     C                   EVAL      CvtBrchesEntry = @CvtBrches(Idx)
     C                   ENDIF
      *
     C                   ENDDO                                                  ODW Idx<=SflSize
      *                                                                         CvtNEwBrch <> *BLANK
      *
     C     ChkDupNewBrE  ENDSR
      *
      *****************************************************************
      *                                                               *
      * LoadCvtBrArr  - Load the new branches entered to array        *
      *                 @CvtBrArr                                     *
      *                                                               *
      * Called by:      ChkDupNewBr                                   *
      *                                                               *
      * Calls:          none                                          *
      *                                                               *
      *****************************************************************
      *
     C     LoadCvtBrArr  BEGSR
      *
      * Initialise variables and array.
     C                   MOVE      *ALL' '       @CvtBrches
     C                   EVAL      ##RR  = 1
     C                   EVAL      Idx   = 1
      *
      *  Load @CvtBrches array with subfile records whose new branches not blank
      *
     C                   DOW       ##RR   <= ##RRMX   AND                       Max recs on SF
     C                             Idx    <= MaxEntry                           Max array extry
      *
     C     ##RR          CHAIN(E)  #SFLRCD
      *
     C                   IF        #1NEWB <> *BLANK
     C                   EVAL      CvtNewBrch      = #1NEWB
     C                   EVAL      CvtOldBrch      = #1OLDB
     C                   EVAL      CvtRRN          = ##RR
     C                   EVAL      @CvtBrches(Idx) = CvtBrchesEntry
     C                   EVAL      Idx             = Idx + 1
     C                   ENDIF                                                  FI #1NEWB <> *BLANK
      *
     C                   EVAL      ##RR  = ##RR + 1
      *
     C                   ENDDO                                                  ODW ##RR <= ##RRMX
      *
     C     LoadCvtBrArrE ENDSR
      *
      *****************************************************************
      *                                                               *
      *  WrtCvtBrRecs - Write records to SMBRCCVTPD file for any      *
      *                 SF record with new branch not blank.          *
      *                                                               *
      * Called by:      ProcScreenIP                                  *
      *                                                               *
      * Calls:          None                                          *
      *                                                               *
      *****************************************************************
      *
     C     WrtCvtBrRecs  BEGSR
      *
      * Chain to each SF record and write record is New branch not blank.
      *
     C                   EVAL      ##RR    = 1
      *
     C                   DOW       ##RR   <=  ##RRMX
      *
     C     ##RR          CHAIN(E)  #SFLRCD
      *
      * If new branch is not blank, write a record to SMBRCCVTPD.
     C                   IF        #1NEWB <> *BLANK
     C                   EVAL      BCOLDB = #1OLDB
     C                   EVAL      BCNEWB = #1NEWB
     C                   WRITE     SMBRCCVTD0
     C                   ENDIF                                                  FI #1NEWB <> *BLANK
      *
      * Increment ##RR for next SF record,
     C                   EVAL      ##RR    = ##RR + 1
     C                   ENDDO                                                  ODW ##RR<= ##RRMX
      *
     C     WrtCvtBrRecsE ENDSR
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
      *            ValNewBrch                                         *
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
      * Calls:     LoadAllBrArr                                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0ZoMSys          2            Zone System id
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
     C                   Z-ADD     500           W0SLM             5 0
      *
      * Subfile pages
     C                   Z-ADD     1             W0SPG             3 0
      *
      * Processed Subfile record
     C                   Z-ADD     0             W0RR0             4 0
      *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      AGMRDT        ##MRDT            7            RUN DATE
      *
      * Move P0ZoMSys to subfile title
     C                   EVAL      ##ZOMSYS = P0ZoMSys
      *
      * Load all the branches of other zone into array @AllBrches
     C                   EXSR      LoadAllBrArr
      *
     C     INZSRE        ENDSR
      *
      *****************************************************************
      *                                                               *
      * LoadAllBrArr - Load all the branches from existing zones      *
      *                except new zone into array @AllBrches.         *
      *                Then the array is sorted by Branches.          *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls:     *PSSR                                              *
      *                                                               *
      *****************************************************************
      *
     C     LoadAllBrArr  BEGSR
      *
      * Initialize array index.
     C                   EVAL      Idx  = 1
      *
     C                   OPEN      GPZONEPD
      *
     C                   READ      GPZONEPD                               72    End of file
      *
     C                   DOW       *IN72 <> '1'       AND
     C                             Idx  <= MaxEntry                             MaxEntry = 100
      *
      * If ZOMSYS is different from P0ZoMSys, load the branches to array
      *    from file SDBRCHPD in the zone's DMLIB.
     C                   IF        ZOMSYS <> P0ZoMSys   AND
     C                             ZOMSYS <> *BLANK
      *
      * OVRDBF SDBRCHPD to SDBRCHPD in the DMLIB of the zone main system.
     C                   EVAL      CmdString = OVRF_cmd + ZoneDMLIB
     C                   EVAL      CmdString = %TRIMR(CmdString) +
     C                                         TOFILEKwrd
     C                   CALL      'QCMDEXC'
     C                   PARM                    CmdString
     C                   PARM                    CmdLen
      *
     C                   OPEN      SDBRCHPD
      *
      * Load all branches of the zone to array
     C                   READ      SDBRCHPD                               73    Eof
      *
     C                   DOW       *IN73 <> '1'      AND
     C                             Idx  <= MaxEntry                             MaxEntry = 100
     C                   EVAL      @AllBrches(Idx) = A8BRCD
     C                   EVAL      Idx             = Idx  + 1
     C                   READ      SDBRCHPD                               73    Eof
     C                   ENDDO                                                  ODW *IN73 <> '1'
      *
      * Close SDBRCHPD in the zone.
     C                   CLOSE     SDBRCHPD
      *
      * DLTOVR of SDBRCHPD in the zone main system DMLIB
     C                   EVAL      CmdString = 'DLTOVR SDBRCHPD'
     C                   CALL      'QCMDEXC'
     C                   PARM                    CmdString
     C                   PARM                    CmdLen
      *
     C                   ENDIF                                                  FI ZOMSYS<>P0ZoMSys
      *                                                                         and ZOMSYS <> ' '
      * Read next record from GPZONEPD
     C                   READ      GPZONEPD                               72    EOF
      *
     C                   ENDDO                                                  ODW *IN72 <> '1'
      *                                                                         and Idx <= MaxEntry
     C                   CLOSE     GPZONEPD
      *
      * Abort this program when all the array entries have been filled up and
      * still some branches left.
     C                   IF        Idx > MaxEntry
     C                   IF        *IN72 = '0'    OR
     C                             *IN73 = '0'
     C                   EXSR      *PSSR
     C                   GOTO      LoadAllBrArrE
     C                   ENDIF                                                  FI (*IN72 = '0') OR
      *                                                                            (*IN73 = '0')
     C                   ENDIF                                                  FI Idx > MaxEntry
      *
      * Sort the array in descending order so that the unfilled blank entries are
      * at the end of the array.
     C                   SORTA     @AllBrches
      *
     C     LoadAllBrArrE ENDSR
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
