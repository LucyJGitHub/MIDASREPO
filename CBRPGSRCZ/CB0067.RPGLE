     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CB Job spooled files subfile')
      *****************************************************************
      *                                                               *
      *  Midas - Close of Business Processing                         *
      *                                                               *
      *  CB0067 - Midas CB Job spooled files subfile                  *
      *                                                               *
      *  Function: This program displays a subfile of all spooled     *
      *            files for the passed in Job, user and job number.  *
      *                                                               *
      *  Called By: CBC0066 after CB0066                              *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAAA02  *CREATE    Date 14Nov03               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAAA02 - Created to display spooled files info. subfile from *
      *           file CBSPLFPD for a qualified job.                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *       03         F3 has been pressed (Exit program)           *
      *       05         F5 has been pressed (Refresh screen)         *
      *       27         On to display next subfile page              *
      *       80         Clear subfile                                *
      *       81         Display subfile. (no. of records > 0)        *
      *       82         READE failed for the passed in parameters.   *
      *       86         Subfile putover                              *
      *       99         Global error flag                            *
      *                                                               *
     F*****************************************************************
      *                                                               *
      *  Subroutines                                                  *
      *                                                               *
      * InitNLoadSF   - Initialise and load subfile page              *
      * LoadSubfile   - Load subfile page                             *
      * DspScreen     - Display screen                                *
      * MovY2LoadSFReq- Move 'Y' to ReloadSFReq indicator             *
      * ZASNMS        - Send message to program's message queue       *
      * ExitPgm       - Exit program: Set on LR and Return            *
      * *INZSR        - Initialise                                    *
      * *PSSR         - Error processing                              *
      *                                                               *
      *****************************************************************
     FCB0067DF  CF   E             WORKSTN
     F                                     SFILE(#SFLRCE:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas CB Job Spooled Files subfile
      *
     FCBSPLFPD  IF   E           K DISK
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      * RTV : Midas CB Job Spooled files
      *
      * Program data structure
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      *
      * Display file information data structure
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      *
      * File information data structure
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
     D* Local Data Area
     D LDA            UDS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
     D ZAPGMQ          S             10                                         Program queue
     D ZAPGRL          S              5                                         Rel queue
     D ZAMSID          S              7                                         Message ID
     D ZAMSGF          S             10                                         Message file
     D ZAMSDA          S            132                                         Message data
     D ZAMSTP          S              7                                         Message type
     D Wrun            S              1
     D JobInfo1        S             40
 
      * AOSVALR0 Call to access object fields
     D @RTCD           S              7
     D SVALKK          C                   CONST('iWAMachineAndPortNbr')        Key to SDSVALPD
 
     D JobSPL          C                   CONST('/webaccess/iWASpoolViewer?+
     D                                           jobInfo=')
     D JobPDF          C                   CONST('/webaccess/iWAPDFDownload?+
     D                                           jobInfo=')
     D JobPCL          C                   CONST('/webaccess/iWAPclDownload?+
     D                                           jobInfo=')
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
     C                   WRITE     #SFLCTE
     C                   SETOFF                                       80
      *
      * Reset no of records in subfile
     C                   Z-ADD     *ZERO         ##RRMX            5 081        SETOF 81
      *
      * Position to CBSPLFPD.
     C     KPOS          SETLL     CBSPLFPD
     C     KPOS          READE     CBSPLFPD                               82    ON if READE failed
      *
      * Load subfile page
     C                   Z-ADD     0             ##RROK            5 0
     C                   EXSR      LoadSubfile
      *
     C     InitNLoadSFE  ENDSR
      /EJECT
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
      * Re-establish fields in read-ahead record
     C*  27              DO
     C* N82              READP     CBSPLFD0                               82    *
     C* N82              READ      CBSPLFD0                               82    *
     C*                  END
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
      * Scan limit reached, or End of spooled files for the job.
      *
     C                   DOW       (*IN82  = '0')    AND
     C                             (##RROK < ##SFLN) AND
     C                             (##RRRD < W0SLM)
      *
      * Display the spooled file if the status is not '*FINISHED'
     C                   IF        SPSTAT <> '*FINISHED '
      *
      * Load SFL fields
     C                   MOVEL     SPSPLF        #1SPLF                         Spooled file
     C                   MOVEL     SPOUTQ        #1OUTQ                         Output Q name
     C                   MOVEL     SPUDTA        #1UDTA                         User data
     C                   MOVEL     SPSTAT        #1STAT                         Status
     C                   EVAL      #1TPAG      = SPTPAG                         Total pages
      *
      * Hidden field for SpoolViewer
     C                   EVAL      JobInfo1 = 'http://' + %TRIMR(SVAL1)
     C                   EVAL      #1SFSPL  = %TRIM(JobInfo1) + JobSPL +
     C                                        %TRIM(#2JNBR) + '%2f' +
     C                                        %TRIM(#2JUSR) + '%2f' +
     C                                        %TRIM(#2JOB) +
     C                                        '&filename=' + %TRIM(#1SPLF) +
     C                                        '&filenumber=' + %TRIM(SPSNBR)
      *
      * Hidden field for viewing as a PDF Document
     C                   EVAL      #1SFPDF  = %TRIM(JobInfo1) + JobPDF +
     C                                        %TRIM(#2JNBR) + '%2f' +
     C                                        %TRIM(#2JUSR) + '%2f' +
     C                                        %TRIM(#2JOB) +
     C                                        '&filename=' + %TRIM(#1SPLF) +
     C                                        '&filenumber=' + %TRIM(SPSNBR)
      *
      * Hidden field for viewing as a PCL Document
     C                   EVAL      #1SFPCL  = %TRIM(JobInfo1) + JobPCL +
     C                                        %TRIM(#2JNBR) + '%2f' +
     C                                        %TRIM(#2JUSR) + '%2f' +
     C                                        %TRIM(#2JOB) +
     C                                        '&filename=' + %TRIM(#1SPLF) +
     C                                        '&filenumber=' + %TRIM(SPSNBR)
      *
      * Output to subfile
     C                   ADD       1             ##RR
     C                   ADD       1             ##RROK               81        *
      *
     C                   WRITE     #SFLRCE
      *
     C                   ENDIF                                                  FI SPSTAT<>*FINISHED
      *
      * Increment scan check count
     C                   ADD       1             ##RRRD
      *
      * Read next record with job, user and job number same as passed in parameters.
     C     KPOS          READE     CBSPLFD0                               82    READE fails
      *
     C                   ENDDO                                                  OD *IN82
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
     C                   END                                                    FI ##SLIN > 0
     C                   ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
     C                   END                                                    FI ##RR > ##RRMX
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
     C                   END                                                    FI ##RRRD >= W0SLM
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
     C                   EXFMT     #SFLCTE
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
      * MovY2LoadSFReq - Move 'Y' to ReloadSFReq indicator            *
      *                                                               *
      * Called by:       Main processing                              *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     MovY2LoadSFReqBEGSR
      *
     C                   EVAL      ReloadSFReq  = 'Y'
      *
     C     MovY2LoadSFRqEENDSR
      *
      *****************************************************************
      *                                                               *
      * ZASNMS -   Send message to program's message queue            *
      *                                                               *
      * Called by: LoadSubfile                                        *
      *            DspScreen                                          *
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
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *
     C     ZAEXIT        ENDSR
      *
      *****************************************************************
      *                                                               *
      * ExitPgm -  Exit program: Set on LR and Return                 *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     ExitPgm       BEGSR
      *
      * Terminate program
     C                   SETON                                        LR
      *
      * Exit program
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
      * Calls:     ZASNMS                                             *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      * Entry parameters
     C     *ENTRY        PLIST
     C     #2JOB         PARM                    P0JOB            10
     C     #2JUSR        PARM                    P0JUSR           10
     C     #2JNBR        PARM                    P0JNBR            6
      *
     C                   MOVEL     *BLANK        ReloadSFReq       1
      *
      * Update screen time
     C                   TIME                    ##TME             6 0
      *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      AGMRDT        ##MRDT            7            RUN DATE
      *
      * Obtain default message file
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      *
     C* Define LDA for DB errror
     C     *DTAARA       DEFINE                  LDA
     C*
     C                   Z-ADD     13            ##SFPG            3 0          SFLPAG
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
      * Key to access file CBSPLFPD.
     C     KPOS          KLIST
     C                   KFLD                    P0JOB                          Job
     C                   KFLD                    P0JUSR                         Job User
     C                   KFLD                    P0JNBR                         Job Number
      *
      ** Call AOSVALR0 to get the system value for the iSeries Access for Web
      ** machine and port
      *
     C                   CALL      'AOSVALR0'
     C                   PARM                    @RTCD
     C                   PARM      SVALKK        SVALK1           20
     C                   PARM                    SVAL1           200
     C                   PARM                    SVALK2           20
     C                   PARM                    SVAL2           200
     C                   PARM                    SVALK3           20
     C                   PARM                    SVAL3           200
     C                   PARM                    SVALK4           20
     C                   PARM                    SVAL4           200
     C                   PARM                    SVALK5           20
     C                   PARM                    SVAL5           200
     C                   PARM                    SVALK6           20
     C                   PARM                    SVAL6           200
     C                   PARM                    SVALK7           20
     C                   PARM                    SVAL7           200
     C                   PARM                    SVALK8           20
     C                   PARM                    SVAL8           200
     C                   PARM                    SVALK9           20
     C                   PARM                    SVAL9           200
     C                   PARM                    SVALK10          20
     C                   PARM                    SVAL10          200
      *
     C     @RTCD         IFNE      *BLANKS
 
     C     *LOCK         IN        LDA
 
     C     SVAL10        IFEQ      '*NRF'
     C                   MOVE      SVALK10       DBKEY
     C                   ENDIF
     C     SVAL9         IFEQ      '*NRF'
     C                   MOVE      SVALK9        DBKEY
     C                   ENDIF
     C     SVAL8         IFEQ      '*NRF'
     C                   MOVE      SVALK8        DBKEY
     C                   ENDIF
     C     SVAL7         IFEQ      '*NRF'
     C                   MOVE      SVALK7        DBKEY
     C                   ENDIF
     C     SVAL6         IFEQ      '*NRF'
     C                   MOVE      SVALK6        DBKEY
     C                   ENDIF
     C     SVAL5         IFEQ      '*NRF'
     C                   MOVE      SVALK5        DBKEY
     C                   ENDIF
     C     SVAL4         IFEQ      '*NRF'
     C                   MOVE      SVALK4        DBKEY
     C                   ENDIF
     C     SVAL3         IFEQ      '*NRF'
     C                   MOVE      SVALK3        DBKEY
     C                   ENDIF
     C     SVAL2         IFEQ      '*NRF'
     C                   MOVE      SVALK2        DBKEY
     C                   ENDIF
     C     SVAL1         IFEQ      '*NRF'
     C                   MOVE      SVALK1        DBKEY
     C                   ENDIF
 
     C                   MOVEL     '001'         DBASE
     C                   MOVE      'SDSVALPD'    DBFILE
     C                   MOVE      'CB0067'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Call SDRTVTXT pgm to access appropriate text
      *  for a field used in a SFL
      *
      * Spool
     C                   MOVEL     'ZZGBMSGF'    MSGNM
     C                   MOVEL     'ZZN0207'     MSGDNB
     C                   CALL      'SDRTVTXT'
     C                   PARM                    MSGDNB            7
     C                   PARM                    MSGNM            10
     C                   PARM                    MSGTXT           80
     C                   MOVEL     MSGTXT        ZZM002            5
      *
      * PDF
     C                   MOVEL     'ZZN9775'     MSGDNB
     C                   CALL      'SDRTVTXT'
     C                   PARM                    MSGDNB
     C                   PARM                    MSGNM
     C                   PARM                    MSGTXT
     C                   MOVEL     MSGTXT        ZZM003            3
      *
      * PCL
     C                   MOVEL     'ZZO1433'     MSGDNB
     C                   CALL      'SDRTVTXT'
     C                   PARM                    MSGDNB
     C                   PARM                    MSGNM
     C                   PARM                    MSGTXT
     C                   MOVEL     MSGTXT        ZZM004            3
      *
     C     ZZEXIT        ENDSR
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
