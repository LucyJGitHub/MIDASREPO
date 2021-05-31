     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas FC Reports Requested Browse')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  FC200001 - Reports Requested Browse                          *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD055265           Date 10Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BG2193  *CREATE    Date 16Jun04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
      *  BG2193 - Viewing of reports in MidasPlus web-facing          *
      *                                                               *
      *****************************************************************

     FFC200001DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SUBFLREC:SUBF_RRN)
     FFCRREQLD  IF   E           K DISK    INFSR(*PSSR)
     F*FCREPTL0* IF   E           K DISK    INFSR(*PSSR)                                    MD055265

      *****************************************************************
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************


     D NumPerPag       C                   CONST(16)


      ** Array of Fields in error.
     D RIE             S              5    DIM(NumPerPag)


      ** Work with Job
     D WRKJOB          S              1    DIM(80) CTDATA PERRCD(80)


     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)

     D FCREPT        E DS                  EXTNAME(FCREPJW0)                                MD055265

      /SPACE 5


      * Display subfile screen until F3 or F12 taken

     C     *INKC         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
     C                   EXSR      DSPLAY_SCN
     C                   END

      * End

     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL

      * End of program

     C                   SETON                                        LR

      /SPACE 5
      *****************************************************************
      * Display subfile screen
      *****************************************************************
     C     DSPLAY_SCN    BEGSR

      * Fill current subfile page

     C     *IN05         IFEQ      '1'
     C     *IN06         OREQ      '1'
     C     SUBF_RRN      OREQ      *ZERO
     C     DDRQSQ        ORNE      *BLANK
     C                   EXSR      FILL_SUBF
     C                   ENDIF

     C                   MOVEL     *BLANK        DDRQSQ

      * Write subfile control and foooter

     C                   TIME                    DDTIME
     C                   WRITE     MSGSUBCT
     C                   WRITE     FOOTER
     C   04              WRITE     NODATA
     C                   WRITE     SUBFLCTL

      * Read subfile control

     C                   READ      SUBFLCTL                               99    *

      ** Clear the message queue & init error indicators

     C                   EXSR      CLR_MSGQ

      ** If F3 was not taken

     C     *INKC         IFEQ      '0'

      * Rolldown requested

     C     *IN05         CASEQ     '1'           ROLLDOWN

      * Rollup requested

     C     *IN06         CASEQ     '1'           CONTINUE

      * Reselection

     C     DDRQSQ        CASNE     *BLANK        CONTINUE

      * Check for a record selected from the subfile

     C     *IN04         CASEQ     '0'           CHK_SUBF
     C                   END

     C                   ENDIF

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      ** Clear the message queue
      *****************************************************************
     C     CLR_MSGQ      BEGSR

     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Continue
      *****************************************************************
     C     CONTINUE      BEGSR
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Check for a record selected from the subfile
      *****************************************************************
     C     CHK_SUBF      BEGSR

     C                   READC     SUBFLREC                               99    *RECORD CHANGED

      * Do until all records processed

     C     *IN99         DOWEQ     '0'

      * If an action code is specified
      *   Enquire on the record in the subfile

     C     DDACTN        IFNE      *BLANK
     C                   EXSR      ACTN_CHK
     C     ActnOK        IFEQ      'Y'
     C                   EXSR      ENQ_SflREC
     C                   ENDIF
     C                   ENDIF
      * Read next
     C                   READC     SUBFLREC                               99    *RECORD CHANGED
     C                   ENDDO

      * Return to top of subfile page

     C                   MOVEL     ToP_RQSQ      D5RQSQ
     C                   Z-ADD     *ZERO         SUBF_RRN

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Fill subfile
      *****************************************************************
     C     FILL_SUBF     BEGSR

     C     DDRQSQ        IFNE      *BLANK
     C                   MOVEL     DDRQSQ        D5RQSQ
     C                   ENDIF

     C                   MOVEA     '000'         *IN(1)
     C                   MOVEA     '1'           *IN(4)
     C                   Z-ADD     *ZERO         SUBF_RRN

      * Write subfile control

     C                   WRITE     SUBFLCTL                                     *

      * Get first record

     C     FCRREQK       SETLL     FCRREQD0
     C     FCRREQKP      READE     FCRREQD0                               99    *

      * If not end of file

     C     *IN99         IFEQ      '0'
     C                   MOVEL     D5RQSQ        ToP_RQSQ          5
     C                   ELSE
     C                   MOVEL     *BLANK        ToP_RQSQ
     C                   MOVEL     *BLANK        D5RQSQ

      * Else, if end of file
      * Issue message

     C                   MOVEL     'RCF1098'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF

      * Do while not end of file

     C     *IN99         DOWEQ     '0'

     C                   ADD       1             SUBF_RRN          4 0    04    *

     C*****D5RNAM        CHAIN     @DXREIJ                            99                    MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCREPT                                                                        MD055265
     C+ from FCREPJW0                                                                       MD055265
     C+ where DXRNAM = :D5RNAM                                                              MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                       99                    MD055265
     C                   If        SQLCODE = 100                                            MD055265
     C                   SETON                                        99                    MD055265
     C                   ENDIF                                                              MD055265
                                                                                            MD055265

      * In error?

     C     D5RQSQ        LOOKUP    RIE                                    65

      * Write a record to the subfile

     C                   WRITE     SUBFLREC
     C     SUBF_RRN      IFEQ      NumPerPag
     C     FCRREQKP      READE     FCRREQD0                               99    *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        D5RQSQ
     C                   MOVEL     'RCF1098'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   SETON                                            99    *
     C                   END
     C                   ELSE
     C     FCRREQKP      READE     FCRREQD0                               99    *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        D5RQSQ
     C                   MOVEL     'RCF1098'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END
     C                   END

     C                   ENDDO

      * Set on subfile control indicators

     C     *IN(4)        IFEQ      '1'
     C                   MOVEA     '010'         *IN(1)
     C                   ELSE
     C                   MOVEA     '111'         *IN(1)
     C                   END

     C                   MOVEL     *BLANK        RIE

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Enquire on the record in the subfile
      ********************************************************************
     C     ENQ_SflREC    BEGSR

     C                   MOVEL     D5RQSQ        I#RQSQ
     C                   MOVEL     ToP_RQSQ      I#TRQSQ

      * Display job spooled output

     C                   MOVEA     D5JBNB        WRKJOB(12)
     C                   MOVEA     D5JUSR        WRKJOB(19)
     C                   MOVEA     '           ' WRKJOB(29)
     C                   Z-ADD     19            @I                3 0
     C     ' '           LOOKUP    WRKJOB(@I)                             99
     C                   MOVEA     '/'           WRKJOB(@I)
     C                   ADD       1             @I
     C                   MOVEA     D5JBNM        WRKJOB(@I)
     C                   CALL      'QCMDEXC'     WJ_Parm                9999

      * ok
     C     *IN99         IFEQ      *OFF
     C                   MOVE      D5JBNM        I#JBNM
     C                   MOVE      D5JUSR        I#JUSR
     C                   MOVE      D5JBNB        I#JBNB
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
     C                   SETON                                        LR
     C                   RETURN

      * NOT ok
     C                   ELSE
     C                   Z-ADD     1             @RIE              2 0
     C     *BLANK        LOOKUP    RIE(@RIE)                              99
     C                   MOVEL     D5RQSQ        RIE(@RIE)
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Rolldown
      ********************************************************************
     C     ROLLDOWN      BEGSR

     C                   Z-ADD     *ZERO         SUBF_RRN
     C                   MOVEL     ToP_RQSQ      D5RQSQ

     C     FCRREQK       SETGT     FCRREQD0
     C     FCRREQKP      READPE    FCRREQD0                               99    *

      * Read previous
      * until count matches count of records previous read

     C     *IN99         DOWEQ     '0'
     C     SUBF_RRN      ANDLT     NumPerPag
     C     FCRREQKP      READPE    FCRREQD0                               99    *
     C                   ADD       1             SUBF_RRN
     C                   ENDDO

      * Issue start of file message

     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        D5RQSQ
     C                   MOVEL     'RCF1099'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Action code check
      *****************************************************************
     C     ACTN_CHK      BEGSR

     C                   MOVEL     'Y'           ActnOK            1

      * Check for valid action code

     C     DDACTN        IFNE      'E'

     C                   MOVEL     'N'           ActnOK
     C                   MOVEL     'RCF1100'     ZAMSID
     C                   EXSR      ZASNMS

     C                   ENDIF

      * If action code not OK, log record in error

     C     ActnOK        IFNE      'Y'
     C                   Z-ADD     1             @RIE              2 0
     C     *BLANK        LOOKUP    RIE(@RIE)                              99
     C                   MOVEL     D5RQSQ        RIE(@RIE)
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * ZASNMS - SEND A MESSAGE
      *****************************************************************
     C     ZASNMS        BEGSR

     C                   CALL      'Y2SNMGC'                            0909    *
     C                   PARM      DDPGM         ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM      'FCUSRMSG  '  ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      * Return code
      * Error Message
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * User
     C                   PARM                    I#USER           10
      * Top Report Sequence
     C                   PARM                    I#TRQSQ           5
      * Report Sequence
     C                   PARM                    I#RQSQ            5
      * Job attributes
     C                   PARM                    I#JBNM           10
     C                   PARM                    I#JUSR           10
     C                   PARM                    I#JBNB            6
      * Command keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1

      * Initialize program name

     C                   MOVEL     'FC200001 '   DDPGM

      * Set up subfile message queue information

     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      '1'           *IN40

      * Set up standard screen fields.

     C                   MOVEL     PsJobName     DDJOB
     C                   MOVEL     PsUser        DDUSR

      * User

     C     I#USER        IFNE      *BLANK
     C                   SETOFF                                       45
     C                   MOVEL     I#USER        DDUSER
     C                   ELSE
     C                   SETON                                        45
     C                   MOVEL     DDUSR         DDUSER
     C                   ENDIF

      *  Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   MOVEL     I#TRQSQ       D5RQSQ

     C     WJ_Parm       PLIST
     C                   PARM                    WRKJOB
     C                   PARM                    MESLEN
     C                   Z-ADD     80            MESLEN           15 5

      * Key list

     C     FCRREQK       KLIST
     C                   KFLD                    DDUSER
     C                   KFLD                    D5RQSQ
     C     FCRREQKP      KLIST
     C                   KFLD                    DDUSER
     C                   ENDSR
      *****************************************************************
      /EJECT
     CSR   *PSSR         BEGSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
      * Core function specific processing.
      *
      * Standard Midas PSSR processing.
      *
     C/COPY SDCPYSRC,SDPSSRINTI
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
      *
** WRKJOB
WRKJOB JOB(nnnnnn/uuuuuuuuuu/jjjjjjjjjj) OUTPUT(*PRINT) OPTION(*SPLF )
