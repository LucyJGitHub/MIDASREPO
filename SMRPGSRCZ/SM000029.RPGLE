     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Migrate Account Officers')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000029 - Migrate Account Officers                          *
      *                                                               *
      *  Function: This program will display any Account Officers in  *
      *            SDACOFPD that are not in GPACOFXPD.  The user      *
      *            can amend the Global Account Officer ID only.      *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 242534  *CREATE    Date 05Oct06               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  242534 - Migration of Account Officers.                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *       03         F3 has been pressed (Exit program)           *
      *       05         F5 has been pressed (Refresh screen)         *
      *       27         On to display next subfile page              *
      *       38         Invalid global Account Officer               *
      *       45         There is at least one changed SF rec         *
      *       80         Clear subfile                                *
      *       81         Display subfile. (no. of records > 0)        *
      *       82         End of file                                  *
      *       84         Subfile next change                          *
      *       86         Subfile putover                              *
      *       92         EOF of changed subfile records               *
      *       99         Global error flag                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutines                                                  *
      *                                                               *
      * InitNLoadSF   - Initialise and load subfile page              *
      * LoadSubfile   - Load subfile page                             *
      * DspScreen     - Display screen                                *
      * ProcScreenIP  - Process screen input                          *
      * ProcChgSFRecs - Process all modified subfile records          *
      * ValGLobAcOff  - Validate new global Account Officer           *
      * WrtGlobAcOff  - Write records to file GPACOFXPD               *
      * MovY2LoadSFReq- Move 'Y' to ReloadSFReq indicator             *
      * ZASNMS        - Send message to program's message queue       *
      * ExitPgm       - Set on *in LR and return                      *
      * *INZSR        - Initialise                                    *
      * *PSSR         - Error processing                              *
      *                                                               *
      *****************************************************************
     FSM000029DFCF   E             WORKSTN SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SM Account Officers maintenance
      *
     FSDACOFL0  IF   E           K DISK    INFSR(*PSSR)
      * RTV : Midas SD Account Officers
      *
     FGPACOFXL0 UF A E           K DISK    INFSR(*PSSR)
      * WRT : Midas GP Global Account Officers
      *
     FGPZONEL2  IF   E           K DISK    INFSR(*PSSR)
      * RTV : Midas GP Zones
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
     D ZAPGMQ          S             10                                         Program queue
     D ZAPGRL          S              5                                         Rel queue
     D ZAMSID          S              7                                         Message ID
     D ZAMSGF          S             10                                         Message file
     D ZAMSDA          S            132                                         Message data
     D ZAMSTP          S              7                                         Message type
     D Wrun            S              1
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
     C                   ENDDO                                                  OD ReloadSFReq
     C                   ENDDO                                                  OD *HIVAL
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
      * Get the first record from file SDACOFPD.
     C     *LOVAL        SETLL     SDACOFL0
     C                   READ      SDACOFL0                               82    *82=EOF
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
      * Chain to GPACOFXPD.
     C                   EVAL      KAcOfficer = AZACOC
      *
     C     KeyGPACOF     CHAIN     GPACOFXL0
     C                   IF        NOT %FOUND
      * Load SFL fields
     C                   EVAL      #1ACOF = AZACOC
     C                   EVAL      #1NAME = AZACON
     C                   EVAL      #1GLAO = AZACOC
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
     C                   ENDIF
      *
      * Read next record
     C                   READ      SDACOFL0                               82    *82=EOF
      *
     C                   ENDDO                                                  ODE *IN82 = '0'
      *
      * If no DBF records found, display error message
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
      *
      * Send message '*No data to display'
     C                   MOVEL     'ASM0001'     ZAMSID
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
      * If scan limit reached, display error message.
     C     ##RRRD        IFGE      W0SLM
      *
      * Send message '*Scan limit reached'
     C                   MOVEL     'BRG0007'     ZAMSID
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
      *                WrtGlobAcOff                                   *
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
      * If error, quit further processing.
     C     *IN99         CABEQ     '1'           ProcScreenIPE
      *
      * No error:
      *  Write records to GPACOFXPD.
     C                   EXSR      WrtGlobAcOff
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
      * Calls:          ValGLobAcOff                                  *
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
     C                   EXSR      ValGLobAcOff
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
      * ValGLobAcOff  - Validate global Account Officer               *
      *                                                               *
      * Called by:      ProcChgSFRecs                                 *
      *                                                               *
      * Calls:          ZASNMS                                        *
      *                                                               *
      *****************************************************************
      *
     C     ValGLobAcOff  BEGSR
      *
      * Setoff error indicator and SFLNXTCHG
     C                   SETOFF                                       3884      *
      *
     C                   IF        #1GLAO  = *BLANK
     C                   SETON                                        38
     C                   EVAL      ZAMSID  = 'BRG0006'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      * Invalid global Account Officer code
     C                   IF        *IN38 = '1'
      * SFLRCD invalid
     C  N99              Z-ADD     ##RR          ##SFRC               99        *
      * SFLNXTCHG
     C                   SETON                                        84
     C                   ENDIF                                                  FI *IN38 = '1'
      *
     C     ValGLobAcOffE ENDSR
      *
      *****************************************************************
      *                                                               *
      *  WrtGlobAcOff - Write records to GPACOFXPD.                   *
      *                                                               *
      * Called by:      ProcScreenIP                                  *
      *                                                               *
      * Calls:          *NONE                                         *
      *                                                               *
      *****************************************************************
      *
     C     WrtGlobAcOff  BEGSR
      *
      * Chain to each SF record and write record.
     C                   EVAL      ##RR    = 1
      *
     C                   DOW       ##RR   <=  ##RRMX
      *
     C     ##RR          CHAIN(E)  #SFLRCD
      *
     C                   EVAL      ACACOC = #1ACOF
     C                   EVAL      ACGACO = #1GLAO
     C                   WRITE     GPACOFXD0
      *
      * Increment ##RR for next SF record,
     C                   EVAL      ##RR    = ##RR + 1
     C                   ENDDO                                                  ODW ##RR<= ##RRMX
      *
     C     WrtGlobAcOffE ENDSR
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
      *            ValGLobAcOff                                       *
      *            *INZSR                                             *
      *                                                               *
      * Calls:     *NONE                                              *
      *                                                               *
      *****************************************************************
      *
     C     ZASNMS        BEGSR
      *
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      *
      * If no message file specified, use default.
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
      * Calls:     *NONE                                              *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0ZoMSys          2            Zone System id
      *
      * Key fields
     C     KeyGPACOF     KLIST
     C                   KFLD                    KZone            10            Zone
     C                   KFLD                    KAcOfficer        2            Account Officer
      *
      * Move program status structure fields for display
     C                   MOVEL     PSProcName    ##PGM
     C                   MOVEL     PSJobName     ##JOB
     C                   MOVEL     PSUser        ##USR
     C                   MOVEL     'GBSDUSRMSG'  ZAMSGF
      *
     C                   MOVEL     *BLANK        ReloadSFReq       1
      *
      * Update screen time
     C                   TIME                    ##TME             6 0
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
      * Find name of zone.
     C     P0ZoMSys      CHAIN     GPZONEL2
     C                   IF        %FOUND
     C                   EVAL      ACZONE = ZOZONE
     C                   EVAL      KZone = ACZONE
     C                   ELSE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     INZSRE        ENDSR
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
