     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL GCMS Activation Deactivation Function')       *
      *****************************************************************
      *                                                               *
      *  Midas - GL Module                                            *
      *                                                               *
      ***GLJ021M*-*GCMS Activation Deactivation Function***************                   JMI113
      *  XX113021 - GCMS Activation Deactivation Function             *                   JMI113
      *                                                               *
      *  Function:  This program gives the status of GCMS interface   *
      *             jobs. Depending the result it allows to start or  *
      *             terminate each process.                           *
      *                                                               *
      *  Called By: *NONE                                             *
      ***Calls****:*GLCJ006 retrieve the number of members of a file***                   JMI113
      *  Calls    : XXC113006 retrieve the number of members of a file*                   JMI113
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2007*************                   JMI113
      *  (c) Finastra International Limited 2018                      *                   JMI113
      *                                                               *
      *  Last Amend No. JMI113             Date 22May18               *
      *  Prev Amend No. JMI019  *CREATE    Date 21Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI113 - Midas GCMS Interface. Upgrade to FBM 2.1            *
      *  JMI019 - Upgrade as is                                       *
      *  JMI019 - Midas GCMS Interface                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    50-51      Screen fields error                             *
      *    90         General error indicator                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR  - Error processing                                    *
      *  *INZSR - Initialise                                          *
      *  FMTSC1 - Format screen 1                                     *
      *  DSPSC1 - Display screen 1                                    *
      *  SRIAT  - Inter Account Transfer processing                   *
      *  SRTPP  - Third party payment processing                      *
      *  FMTLIN - Format line                                         *
      *  PRCLIN - Process line                                        *
      *  SNDMSG - Send a message                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     F***GLJ021DF  CF   E             WORKSTN                                   JMI113
     FXX113021DFCF   E             WORKSTN                                      JMI113
      /EJECT
      *
      ** Array containing Copyright statement
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** For these arrays each index (dim = 2) represent the process
      ***1*-*IAT
      ***2*-*TPP
      ** Files
     D FILE@           S             10    DIM(1) CTDATA
      ** Process names
     D PROC@           S              3    DIM(1) CTDATA
      ** Data queues to handle job start
     D DTAQ@           S             10    DIM(1) CTDATA
      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D***MEGCMSDA      E DS           256    EXTNAME(MEGCMSDA)                  JMI113
     D XXGCMMDA      E DS           256    EXTNAME(XXGCMMDA)                    JMI113
      *
      ** Data Area giving GCMS Details
      *
     D*GLFIATDA*     E DS           256    EXTNAME(GLFIATDA)
      *
      ** Data Area giving IAT Details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D##PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      ** Working
      ** To handle error on Action code
     DWACER            S              2  0
      ** To handle the procedure to be performed
     DWPROC            S              2  0
      *
      ** Dtaareas Job
     DDTAJOB           DS                  OCCURS(2)
     D  WBKGJ                              LIKE(J0BKGJ)
     D    WJOBNM                     10    OVERLAY(WBKGJ:1)
     D    WORIG                      10    OVERLAY(WBKGJ:11)
     D    WJOBNU                      6    OVERLAY(WBKGJ:21)
      *
      ** Line screen
     DSLIG             DS
     D  LIGALL                      106
     D  SLGIA                        53    OVERLAY(LIGALL:1)
     D    SACTP                       1    OVERLAY(SLGIA:1)
     D    SPCTP                       3    OVERLAY(SLGIA:2)
     D    SBGTP                      28    OVERLAY(SLGIA:5)
     D    SSTTP                      21    OVERLAY(SLGIA:33)
     D  LIG@                               DIM(1) OVERLAY(LIGALL:1) LIKE(SLGIA)
      *
      ** Working Line
     DWLIG             DS
     D  WLG                                LIKE(SLGIA)
     D  WAC                                LIKE(SACTP) OVERLAY(WLG:1)
     D  WPC                                LIKE(SPCTP) OVERLAY(WLG:2)
     D  WBG                                LIKE(SBGTP) OVERLAY(WLG:5)
     D  WST                                LIKE(SSTTP) OVERLAY(WLG:33)
      *
      ** Constants
     DDEQW             C                   'ACTIVE - Waiting'
     DMSGW             C                   'Message - Waiting'
     DINACTIVE         C                   'Inactive'
     DJOBQ             C                   'Job queued'
     DOTHERVAL         C                   'ACTIVE - Processing'
      ** For line processing
     DGCMS             C                   1
      ** For action code error indicator
      ** ex (ACER + IAT = 50) => seton IN(50) (field SACIA)
      ** ex (ACER + TPP = 51) => seton IN(51) (field SACTP)
     DACER             C                   49
      *
      ** Parameters for AOCREPT
     DMSGID            S              7
     DMSGF             S             10    INZ('GLUSRMSG')
     DMSGLIB           S             10    INZ('*LIBL')
     DMSGDTA           S            256
     DMSGREL           S              5
     DMSGQ             S             10
     DMSGT             S              7
      *
      ** Parameters for QUSRJOBI
     DP#RCVV           DS
     DWRCVV                         200
     DWFNC                            8    OVERLAY(WRCVV:51)
     DWSTS                            4    OVERLAY(WRCVV:108)
     DP#LEN            S              4B 0
     DP#FMNM           S              8
     DP#QLJN           S             26
     DP#JBID           S             16
      *
      ** Parameters for GLCJ026
     DP#FILE           S             10
     DP#NUMB           S              3  0
     DP#RTN            S              7
      *
      ** Parameters for QSNDDTAQ
     DP#DQNM           S             10
     DP#DQLB           S             10
     DP#DQLN           S              5  0
     DP#DQVL           S              1
      *
      ***Parameters*for*GLCJ022,*MECJ001*****                                   JMI113
      ** Parameters for GLCJ022, XXC113101                                      JMI113
     DP#OPER           S              7
     DP#MODE           S              7
     DP#PHSE           S              1
      *
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE
      *****************************************************************
     C                   EXSR      FMTSC1
     C     *INKC         DOWEQ     '0'
     C                   EXSR      DSPSC1
     C     *INKC         IFEQ      '1'
     C                   LEAVE
     C                   ENDIF
     C     *INKE         IFEQ      '0'
     C                   EXSR      SRTPP
     C                   ENDIF
     C                   EXSR      FMTSC1
     C                   ENDDO
      *
     C                   SETON                                        LR
      *
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
     C                   SETON                                        25
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C******DTAARA       DEFINE                  MEGCMSDA                       JMI113
     C     *DTAARA       DEFINE                  XXGCMMDA                       JMI113
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
     C                   MOVEL     AGMRDT        SRUNA
     C                   MOVEL     USER          SUSER
     C                   MOVEL     WSID          SWSID
      *
     C                   ENDSR
      *****************************************************************
      * S/R FMTSC1 FORMAT FIELDS OF SCREEN 1                          *
      * CALLED BY MAIN PROCEDURE                                      *
      * CALLS : FMTLIN                                                *
      *****************************************************************
     C     FMTSC1        BEGSR
      ** Retrieve job information from the corresponding dtaarea
     C*******************IN        MEGCMSDA                                     JMI113
     C                   IN        XXGCMMDA                                     JMI113
     C     GCMS          OCCUR     DTAJOB
     C                   MOVEL     J0BKGJ        WBKGJ
      ** Line GCMS to process
     C                   Z-ADD     GCMS          WPROC
      ** Format the line
     C                   EXSR      FMTLIN
     C     END_FMTSC1    ENDSR
      *****************************************************************
      * S/R DSPSC1 DISPLAY SCREEN 1                                   *
      * CALLED BY MAIN PROCEDURE                                      *
      * CALLS :                                                       *
      *****************************************************************
     C     DSPSC1        BEGSR
     C                   WRITE     #MSGCTL
     C*******************EXFMT     GLJ021F1
     C                   EXFMT     XX113021F1
      *
      ** Clear the message queue
      *
     C                   CALL      'ZA0250'
     C     END_DSPSC1    ENDSR
      *****************************************************************
      * S/R SRTPP THIRD PARTY PAYMENT                                 *
      * CALLED BY MAIN PROCEDURE                                      *
      * CALLS : PRCLIN                                                *
      *****************************************************************
     C     SRTPP         BEGSR
      ** Line GCMS to process
     C                   Z-ADD     GCMS          WPROC
      ** Setup the value of indicator for the field SACTP
     C     ACER          ADD       GCMS          WACER
      ** Process the line
     C                   EXSR      PRCLIN
     C     END_SRTPP     ENDSR
      *****************************************************************
      * S/R FMTLIN FORMAT A LINE                                      *
      * CALLED BY FMTSC1                                              *
      * CALLS :                                                       *
      *****************************************************************
     C     FMTLIN        BEGSR
      *
     C                   MOVEL     *BLANK        WLG
      *
     C                   MOVEA     PROC@(WPROC)  WPC
      *
     C     WPROC         OCCUR     DTAJOB
      *
      ** Format Background Job as <job name>/<orig>/<job number>
      *
     C     WBKGJ         IFNE      *BLANK
     C     WJOBNM        CAT       '/':0         WBG
     C     WBG           CAT       WORIG:0       WBG
     C     WBG           CAT       '/':0         WBG
     C     WBG           CAT       WJOBNU:0      WBG
      *
      ** Retrieve status of the job (Active ...)
     C                   CALL      'QUSRJOBI'                           90
     C                   PARM                    P#RCVV
     C                   PARM      104           P#LEN
     C                   PARM      'JOBI0200'    P#FMNM
     C                   PARM      WBKGJ         P#QLJN
     C                   PARM      *BLANK        P#JBID
     C     *IN90         IFEQ      '1'
     C                   MOVEL     *BLANK        WST
     C                   ELSE
     C                   SELECT
     C     WFNC          WHENEQ    '*JOBQ'
     C                   MOVEL(P)  JOBQ          WST
     C     WSTS          WHENEQ    'DEQW'
     C                   MOVEL(P)  DEQW          WST
     C     WSTS          WHENEQ    'MSGW'
     C                   MOVEL(P)  MSGW          WST
     C                   OTHER
     C                   MOVEL(P)  OTHERVAL      WST
     C                   ENDSL
     C                   ENDIF
      ** Else of WBKGJ IFNE *BLANK
      ** => the job is not active
     C                   ELSE
     C                   MOVEL     *BLANK        WBG
     C                   MOVEL(P)  INACTIVE      WST
     C                   ENDIF
      *
      ** Put the informations into the appropriate line of the screen
     C                   MOVEA     WLG           LIG@(WPROC)
     C     END_FMTLIN    ENDSR
      *****************************************************************
      * S/R PRCLIN PROCESS A LINE                                     *
      * CALLED BY SRIAT SRTPP                                         *
      * CALLS : SNDMSG                                                *
      *****************************************************************
     C     PRCLIN        BEGSR
      ** Reset error indicator
     C                   MOVEL     '0'           *IN(WACER)
     C                   MOVEA     LIG@(WPROC)   WLG
      *
     C     WAC           IFEQ      *BLANK
     C                   GOTO      END_PRCLIN
     C                   ENDIF
      *
     C     WAC           IFNE      'S'
     C     WAC           ANDNE     'T'
     C                   MOVEL     'GLX0130'     MSGID
     C                   EXSR      SNDMSG
     C                   MOVEL     '1'           *IN(WACER)
     C                   ENDIF
      *
      ** To terminate the job this later must be running
     C     WAC           IFEQ      'T'
     C     WST           IFNE      DEQW
     C     WST           ANDNE     OTHERVAL
     C                   MOVEL     'GLX0411'     MSGID
     C                   EVAL      MSGDTA = DEQW + ' , ' + OTHERVAL
     C                   EXSR      SNDMSG
     C                   MOVEL     '1'           *IN(WACER)
     C** Else of IF (WST <> DEQW) AND (WST <> OTHERVAL)
     C                   ELSE
     C                   SELECT
     C     WPROC         WHENEQ    GCMS
     C*******************CALL      'MECJ001'                            90      JMI113
     C                   CALL      'XXC113101'                          90      JMI113
     C                   PARM      '*END'        P#OPER
     C                   PARM      *BLANK        P#MODE
     C                   PARM      'A'           P#PHSE
     C                   PARM      *BLANK        P#RTN
     C                   ENDSL
      ** Error => <PROCESS> background job not stopped
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'GLX0412'     MSGID
     C                   MOVEA     PROC@(WPROC)  MSGDTA
     C                   EXSR      SNDMSG
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** To start the job
     C     WAC           IFEQ      'S'
     C     WST           IFNE      INACTIVE
     C     WST           ANDNE     DEQW
     C                   MOVEL     'GLX0411'     MSGID
     C                   EVAL      MSGDTA = DEQW +  ' , ' + INACTIVE
     C                   EXSR      SNDMSG
     C                   MOVEL     '1'           *IN(WACER)
      ** Else of IF (WST <> DEQW) AND (WST <> INACTIVE)
     C                   ELSE
      *
     C                   SELECT
     C     WST           WHENEQ    DEQW
     C                   CALL      'QSNDDTAQ'                           90
     C                   PARM      DTAQ@(WPROC)  P#DQNM
     C                   PARM      '*LIBL'       P#DQLB
     C                   PARM      1             P#DQLN
     C                   PARM      'C'           P#DQVL
      ** Error => <PROCESS> background job not stopped
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'GLX0413'     MSGID
     C                   MOVEA     PROC@(WPROC)  MSGDTA
     C                   EXSR      SNDMSG
     C                   ENDIF
     C     WST           WHENEQ    INACTIVE
     C                   SELECT
     C     WPROC         WHENEQ    GCMS
     C*******************CALL      'MECJ001'                            90      JMI113
     C                   CALL      'XXC113101'                          90      JMI113
     C                   PARM      '*START'      P#OPER
     C                   PARM      *BLANK        P#MODE
     C                   PARM      'A'           P#PHSE
     C                   PARM      *BLANK        P#RTN
     C                   ENDSL
      ** Error => <PROCESS> background job not stopped
     C     P#RTN         IFNE      *BLANK
     C     *IN90         OREQ      '1'
     C                   MOVEL     'GLX0413'     MSGID
     C                   MOVEA     PROC@(WPROC)  MSGDTA
     C                   EXSR      SNDMSG
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDIF
     C                   ENDIF
     C     END_PRCLIN    ENDSR
      *****************************************************************
      * S/R SNDMSG SEND PROGRAM MESSAGE                               *
      * CALLED BY SEVERAL SUBROUTINES                                 *
      * CALLS :                                                       *
      *****************************************************************
     C     SNDMSG        BEGSR
      ** Only write message if requested
     C     MSGID         IFNE      *BLANK
     C                   CALLB     'AOCREPT'
     C                   PARM                    MSGID
     C                   PARM                    MSGF
     C                   PARM                    MSGLIB
     C                   PARM                    MSGDTA
     C                   PARM      '*SAME'       MSGREL
     C                   PARM                    ##PGM
     C                   PARM      *BLANK        MSGQ
     C                   PARM      *BLANK        MSGT
      *
     C                   MOVEL     *BLANK        MSGID
     C                   MOVEL     *BLANK        MSGDTA
      *
     C                   ENDIF
      *
     C     END_SNDMSG    ENDSR
      *****************************************************************
      * SAMPLE ERROR                                                  *
      * Its a sample to show how handle errors. Don't call it         *
      *****************************************************************
     C     SPLERR        BEGSR
      *
      ***************** FOR EACH DATABASE ERROR *************************
      *
      ** Data base error in file (file)
      *
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     000           DBASE
     C                   MOVEL     '(file)'      DBFILE
     C                   MOVEL     '(key)'       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      ************ CALL DBERRCTL IF INTERACTIVE PROGRAM ***************
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
      ************ CALL DBERRCTL IF INTERACTIVE PROGRAM ******************
      *
     C                   CALL      'DBERRCTL'
      *
      ********************************************************************
     C                   END
      *
      ************ END PROGRAM IF DBERRCTL NOT CALLED ********************
     C                   SETON                                        U7U8LR
     C                   RETURN
      ********************************************************************
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2018
**  FILE@
XXGCMGPD
**  PROC@
GCMS
**  DTAQ@
MEGCMSA
