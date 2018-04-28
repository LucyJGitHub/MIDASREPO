     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*XBIA*  CRTPF FILE(QTEMP/QDSPJOB) RCDLEN(150)
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas FC Job Spooled File Output')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  FC200002 - Job Spooled File Output                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BG2193  *CREATE    Date 16Jun04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BG2193 - Viewing of reports in MidasPlus web-facing          *
      *                                                               *
      *****************************************************************
 
     FFC200002DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SUBFLREC:SUBF_RRN)
     FQDSPJOB   IF   F  150        DISK    INFSR(*PSSR)
 
      *****************************************************************
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
     D NumPerPag       C                   CONST(17)
 
 
      ** Array of Fields in error.
     D RIE             S              5  0 DIM(NumPerPag)
 
 
     D                 DS
     D  DSPDTA                 1    129
     D  PFILE                  1     10
     D  PSTAT                 35     37
     D  PFNUM                 94     98
 
 
      ** Copy Spool File
     D CPYSPL          S              1    DIM(120) CTDATA PERRCD(94)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      /SPACE 5
     IQDSPJOB   NS
     I                                  2  130  DSPDTA
 
 
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
     C                   EXSR      FILL_SUBF
     C                   ENDIF
 
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
 
     C                   Z-ADD     ToP_DS_RRN    DS_RRN            5 0
     C                   Z-ADD     *ZERO         SUBF_RRN
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Fill subfile
      *****************************************************************
     C     FILL_SUBF     BEGSR
 
     C                   MOVEA     '000'         *IN(1)
     C                   MOVEA     '1'           *IN(4)
     C                   Z-ADD     *ZERO         SUBF_RRN
 
      * Write subfile control
 
     C                   WRITE     SUBFLCTL                                     *
 
      * Get first record
 
     C     DS_RRN        CHAIN     QDSPJOB                            99
 
      * If not end of file
 
     C     *IN99         IFEQ      '0'
     C                   MOVEL     DS_RRN        ToP_DS_RRN        5 0
     C                   ELSE
     C                   Z-ADD     1             ToP_DS_RRN
     C                   Z-ADD     1             DS_RRN
 
      * Else, if end of file
      * Issue message
 
     C                   MOVEL     'RCF1098'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      * Do while not end of file
 
     C     *IN99         DOWEQ     '0'
 
     C                   ADD       1             SUBF_RRN          4 0    04    *
 
     C     PSTAT         IFEQ      'RDY'
     C     PSTAT         OREQ      'HLD'
     C     PSTAT         OREQ      'SAV'
     C                   SETOFF                                       64
     C                   ELSE
     C                   SETON                                        64
     C                   ENDIF
 
      * In error?
 
     C     DS_RRN        LOOKUP    RIE                                    65
 
      * Write a record to the subfile
 
     C                   Z-ADD     DS_RRN        HIDE_RRN
     C                   WRITE     SUBFLREC
     C     SUBF_RRN      IFEQ      NumPerPag
     C                   ADD       1             DS_RRN
     C     DS_RRN        CHAIN     QDSPJOB                            99
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     1             DS_RRN
     C                   MOVEL     'RCF1098'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   SETON                                            99    *
     C                   END
     C                   ELSE
     C                   ADD       1             DS_RRN
     C     DS_RRN        CHAIN     QDSPJOB                            99
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     1             DS_RRN
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
 
     C                   Z-ADD     *ZERO         RIE
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Enquire on the record in the subfile
      ********************************************************************
     C     ENQ_SflREC    BEGSR
 
      * Copy spool file
 
     C                   MOVEA     PFILE         CPYSPL(14)
     C                   MOVEA     I#JBNB        CPYSPL(52)
     C                   MOVEA     '           ' CPYSPL(69)
     C                   MOVEA     I#JUSR        CPYSPL(59)
     C                   Z-ADD     59            @I                3 0
     C     ' '           LOOKUP    CPYSPL(@I)                             99
     C                   MOVEA     '/'           CPYSPL(@I)
     C                   ADD       1             @I
     C                   MOVEA     I#JBNM        CPYSPL(@I)
     C                   MOVEA     PFNUM         CPYSPL(89)
     C                   CALL      'QCMDEXC'     WS_Parm                9999
 
      * ok
     C     *IN99         IFEQ      *OFF
     C                   CALL      'FC200003'
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD            7
     C                   PARM      *BLANK        X_ERMS           50
      * File
     C                   PARM      PFILE         I#PFILE          10
      * Command keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      * Error
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'SPPOLED OUTPUT ENQUIRY FAILED'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      @INKC         *INKC
      * NOT ok
     C                   ELSE
     C                   Z-ADD     1             @RIE              2 0
     C     *ZERO         LOOKUP    RIE(@RIE)                              99
     C                   Z-ADD     HIDE_RRN      RIE(@RIE)
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Rolldown
      ********************************************************************
     C     ROLLDOWN      BEGSR
 
     C                   Z-ADD     *ZERO         SUBF_RRN
     C                   Z-ADD     ToP_DS_RRN    DS_RRN
 
     C     DS_RRN        CHAIN     QDSPJOB                            99
 
      * Read previous
      * until count matches count of records previous read
 
     C     *IN99         DOWEQ     '0'
     C     SUBF_RRN      ANDLT     NumPerPag
     C                   SUB       1             DS_RRN
     C     DS_RRN        CHAIN     QDSPJOB                            99
     C                   ADD       1             SUBF_RRN
     C                   ENDDO
 
      * Issue start of file message
 
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     1             DS_RRN
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
     C     *ZERO         LOOKUP    RIE(@RIE)                              99
     C                   Z-ADD     HIDE_RRN      RIE(@RIE)
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
     C                   PARM      'FCUSRMSG'    ZAMSGF           10
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
      * Job attributes
     C                   PARM                    I#JBNM           10
     C                   PARM                    I#JUSR           10
     C                   PARM                    I#JBNB            6
      * Command keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
 
      * Initialize program name
 
     C                   MOVEL     'FC200002 '   DDPGM
 
      * Set up subfile message queue information
 
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      '1'           *IN40
 
      * Set up standard screen fields.
 
     C                   MOVEL     PsJobName     DDJOB
     C                   MOVEL     PsUser        DDUSR
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     WS_Parm       PLIST
     C                   PARM                    CPYSPL
     C                   PARM                    MESLEN
     C                   Z-ADD     120           MESLEN           15 5
 
     C                   Z-ADD     1             DS_RRN
 
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
** CPYSPLF
CPYSPLF FILE(ffffffffff) TOFILE(QTEMP/QDSPSPL) JOB(nnnnnn/uuuuuuuuuu/jjjjjjjjjj) SPLNBR(12345)
 CTLCHAR(*FCFC)
