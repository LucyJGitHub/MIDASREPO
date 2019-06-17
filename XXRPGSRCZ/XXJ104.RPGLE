     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Pooling Accounts Job Status')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      ***SDJ104*-*MIDAS*SD*Account Pooling Job Status******************
      *  XXJ104 - MIDAS SD Account Pooling Job Status                 *
      *                                                               *
      *  Function:  This program displays the job status of the       *
      *             receive and send jobs and allows the user to      *
      *             start or terminate the jobs                       *
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2007*************
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. JMI108             Date 31May18               *
      *  Prev Amend No. TFJ011  *CREATE    Date 22Jan07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI108 - Account Balance Pooling. Upgrade to FBM 2.1         *
      *  TFJ011 - Account Pooling                                     *
      *                                                               *
      *****************************************************************
      *
     F***SDJ104DF  CF   E             WORKSTN USROPN                            JMI108
     FXXJ104DF  CF   E             WORKSTN USROPN                               JMI108
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      ** DSP: Midas Account Pooling Installation Control Data Maintenance
      *
      ********************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
      ** Dtaareas Job
     DPINJDTA          DS           128
     D    WIJOBNM              1     10
     D    WIORIG              11     20
     D    WIJOBNU             21     26

     DPOTJDTA          DS           128
     D    WOJOBNM              1     10
     D    WOORIG              11     20
     D    WOJOBNU             21     26

     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      *
      /EJECT
      *
      ** Data structures:
      *
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      ** Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      ** File information data structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Midas SD Bank Details
      *
     D A@CPY           DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
     DMSGW             C                   'Message - Waiting'
     DINACTIVE         C                   'Inactive'
     DACTIVE           C                   'Active'

      /EJECT
      ** Data structures:
      *
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
      *
     DJOBDTA           DS
     D    JOBNM                      10
     D    ORIG                       10
     D    JOBNU                       6
      *
     DP#RCVV           DS
     DWRCVV                         200
     DWFNC                    51     59
     DWSTS                   108    111

      ** Data Structures used by Access Programs
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      /EJECT
      *****************************************************************
      *
      ** Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    PMODE             1
      *****************************************************************
      ** Display and process key screen
     C
     C                   EXSR      MAIN
     C
      ** Terminate program
     C                   EXSR      ZXEXPG
      *
      /EJECT
      *****************************************************************
     C     MAIN          BEGSR
      *
      ** Do until F3 pressed
      *
     C     *INKC         DOUEQ     '1'
      *
      ** If error write messages
     C                   IF        ERR = 'Y'
     C                   WRITE     #MSGCTL
     C                   ENDIF
      *
     C                   WRITE     #RCDKEY
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDDTL1
     C                   EXSR      CLEAR
      *
      ** Process response to screen
      ** Cancel & exit program
     C   03              CAS                     ZXEXPG
     C   05              CAS                     RESET
      ** Process key screen input
     C                   CAS                     VALID
     C                   ENDCS
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * Clear message file
      *****************************************************************
     C     CLEAR         BEGSR
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
     C     RESET         BEGSR
      *
      ** Clear the program message queue and call SR/INIT to retrieve
      ** the job statuses
      *
     C                   EXSR      CLEAR
     C                   WRITE     #MSGCTL
     C                   EXSR      *INZSR
      *
      ** Reset all error indicators
      *
     C                   EXSR      CLRIND
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
     C     VALID         BEGSR
      *
     C                   IF        PMODE = 'E'
     C                   EXSR      ZXEXPG
     C                   ENDIF
      *
      ** Clear error conditioning fields
      *
     C                   EVAL      ERR = 'N'
     C                   EXSR      CLRIND
      *
      ** Validate values in Action selection
      *
      * Value must be 'S' or 'T'
     C                   IF        SACTNR <> 'S' and SACTNR <> 'T'
     C                             and SACTNR <> ' '
     C                   EVAL      ZAMSID = 'XXX1133'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        31
     C                   EVAL      ERR = 'Y'
     C                   ENDIF
      *
     C                   IF        SACTNS <> 'S' and SACTNS <> 'T'
     C                             and SACTNS <> ' '
     C                   EVAL      ZAMSID = 'XXX1133'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        32
     C                   EVAL      ERR = 'Y'
     C                   ENDIF

      * If status is ACTIVE or MSGW, error if 'S'
     C                   IF        SACTNR = 'S' and SREC = 'Active'
     C                             or SACTNR = 'S'
     C                             and SREC = 'Message - Waiting'
     C                   EVAL      ZAMSID = 'XXX1134'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        31
     C                   EVAL      ERR = 'Y'
     C                   ENDIF
      *
     C                   IF        SACTNS = 'S' and SSEND = 'Active'
     C                             or SACTNS = 'S'
     C                             and SSEND = 'Message - Waiting'
     C                   EVAL      ZAMSID = 'XXX1136'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        32
     C                   EVAL      ERR = 'Y'
     C                   ENDIF

      * If status is INACTIVE, error if 'T'
     C                   IF        SACTNR = 'T' and SREC = 'Inactive'
     C                   EVAL      ZAMSID = 'XXX1135'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        31
     C                   EVAL      ERR = 'Y'
     C                   ENDIF
      *
     C                   IF        SACTNS = 'T' and SSEND = 'Inactive'
     C                   EVAL      ZAMSID = 'XXX1137'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        32
     C                   EVAL      ERR = 'Y'
     C                   ENDIF
      *
      ** No Error detected?
     C                   IF        ERR = 'N' AND SACTNR <> ' '
      *
      * Start or Terminate send or receive jobs
     C                   SELECT
     C     SACTNR        WHENEQ    'S'
     C                   MOVEL     *BLANKS       Start_Stop
     C                   MOVEL     'START'       Start_Stop
     C                   MOVEL     'R'           Send_Rec
      *
     C     SACTNR        WHENEQ    'T'
     C                   MOVEL     *BLANKS       Start_Stop
     C                   MOVEL     'STOP'        Start_Stop
     C                   MOVEL     'R'           Send_Rec
     C                   ENDSL
      *
     C****************** CALL      'GLCJ101'                                    JMI108
     C                   CALL      'XXCJ111'                                    JMI108
     C                   PARM                    Start_Stop        5
     C                   PARM                    Send_Rec          1
      *
     C                   ENDIF
      *
      ** No Error detected?
     C                   IF        ERR = 'N' AND SACTNS <> ' '
      *
     C                   SELECT
     C     SACTNS        WHENEQ    'S'
     C                   MOVEL     *BLANKS       Start_Stop
     C                   MOVEL     'START'       Start_Stop
     C                   MOVEL     'S'           Send_Rec
      *
     C     SACTNS        WHENEQ    'T'
     C                   MOVEL     *BLANKS       Start_Stop
     C                   MOVEL     'STOP'        Start_Stop
     C                   MOVEL     'S'           Send_Rec
     C                   ENDSL
      *
     C****************** CALL      'GLCJ101'                                    JMI108
     C                   CALL      'XXCJ111'                                    JMI108
     C                   PARM                    Start_Stop        5
     C                   PARM                    Send_Rec          1
      *
     C                   ENDIF
      *
      ** No Error detected?
     C                   IF        ERR = 'N' AND SACTNR <> ' '
     C                             OR ERR = 'N' AND SACTNS <> ' '

      * Have a delay of 2 seconds to ensure job details update
     C                   Z-ADD     50            MESLEN           15 5
     C                   EVAL      ##OX1 = 'DLYJOB DLY(2)'
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX1            50
     C                   PARM                    MESLEN

      * Reset as though F5 had been pressed to display new job status
     C                   EXSR      RESET
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     CLRIND        BEGSR
      *
     C                   SETOFF                                       3132
      *
     C                   ENDSR
      *****************************************************************
     C     ZASNMS        BEGSR
      *
      ** Send message to program's message queue
      *
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      *
      ** If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     'GBXXMSGF'    ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      *
      ** Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     ZXEXPG        BEGSR
      *
      ** Terminate program
     C                   SETON                                        LR
      *
      ** Exit program
     C                   RETURN
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C                   TIME                    ##TME
      ** Initialisation
      *
      ** Only do first time through
     C                   IF        *IN01 = *OFF
      * Open file
     C****************** OPEN      SDJ104DF                                     JMI108
     C                   OPEN      XXJ104DF                                     JMI108
     C                   MOVE      'N'           ERR               1
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  ##PGM
     C                   OUT       LDA
      *  Get rundate
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
      *
     C                   IF        @RTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      * Move rundate to display
     C                   MOVEL     BJMRDT        ##MRDT
      *
     C                   IF        PMODE = 'E'
      * Protect and non-display action fields
     C                   SETON                                        87
     C                   ENDIF
      *
     C                   SETON                                        01
     C                   SETOFF                                       03
     C                   ENDIF
      *
      * Move *blanks to action fields
     C                   MOVE      *BLANKS       SACTNR
     C                   MOVE      *BLANKS       SACTNS
      *
     C* Get receive pooling job details
     C     *DTAARA       DEFINE                  PINJDTA
     C                   IN        PINJDTA

     C     WIJOBNM       IFNE      *BLANK
     C                   EVAL      JOBNM = WIJOBNM
     C                   EVAL      ORIG = WIORIG
     C                   EVAL      JOBNU = WIJOBNU

     C                   CALL      'QUSRJOBI'                           90
     C                   PARM                    P#RCVV
     C                   PARM      104           P#LEN             4 0
     C                   PARM      'JOBI0200'    P#FMNM            8
     C                   PARM      JOBDTA        P#QLJN           26
     C                   PARM      *BLANK        P#JBID           16

     C     *IN90         IFEQ      '1'
     C                   MOVEL     *BLANK        SREC
     C                   ELSE
     C                   SELECT
     C     WSTS          WHENEQ    'MSGW'
     C                   MOVEL(P)  MSGW          SREC
     C     WFNC          WHENEQ    '*OUTQ'
     C                   MOVEL(P)  INACTIVE      SREC
     C                   OTHER
     C                   MOVEL(P)  ACTIVE        SREC
     C                   ENDSL
     C                   ENDIF
      ** Else if job details are blank
      ** => the job is not active
     C                   ELSE
     C                   MOVEL(P)  INACTIVE      SREC
     C                   ENDIF
      *
     C* Get send pooling job details
     C     *DTAARA       DEFINE                  POTJDTA
     C                   IN        POTJDTA

     C     WOJOBNM       IFNE      *BLANK
     C                   EVAL      JOBNM = WOJOBNM
     C                   EVAL      ORIG = WOORIG
     C                   EVAL      JOBNU = WOJOBNU

     C                   CALL      'QUSRJOBI'                           90
     C                   PARM                    P#RCVV
     C                   PARM      104           P#LEN             4 0
     C                   PARM      'JOBI0200'    P#FMNM            8
     C                   PARM      JOBDTA        P#QLJN           26
     C                   PARM      *BLANK        P#JBID           16

     C     *IN90         IFEQ      '1'
     C                   MOVEL     *BLANK        SSEND
     C                   ELSE
     C                   SELECT
     C     WSTS          WHENEQ    'MSGW'
     C                   MOVEL(P)  MSGW          SSEND
     C     WFNC          WHENEQ    '*OUTQ'
     C                   MOVEL(P)  INACTIVE      SSEND
     C                   OTHER
     C                   MOVEL(P)  ACTIVE        SSEND
     C                   ENDSL
     C                   ENDIF
      ** Else if job details are blank
      ** => the job is not active
     C                   ELSE
     C                   MOVEL(P)  INACTIVE      SSEND
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
      *
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2018
