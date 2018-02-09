     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*XBIA*  CRTPF FILE(QTEMP/QDSPSPL) RCDLEN(150)
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas FC Spooled Output')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  FC200003 - Spooled Output                                    *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BG2193  *CREATE    Date 16Jun04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG2193 - Viewing of reports in MidasPlus web-facing          *
      *                                                               *
      *****************************************************************
 
     FFC200003DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SUBFLREC:SUBF_RRN)
     FQDSPSPL   IF   F  150        DISK    INFSR(*PSSR)
 
      *****************************************************************
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
     D NumPerPag       C                   CONST(17)
 
 
     D PAGCNT          S              5  0 DIM(9999) ASCEND
     D RRNCNT          S              7  0 DIM(9999) ASCEND
 
     D                 DS
     D  DSPDTA                 1    131
 
 
     D                 DS
     D  DDCTRL                 1      8
     D  DDCTRL1                1      1
     D  DDCTRL1x               2      8
     D  DDCTRL2                2      2
     D  DDCTRL2x               3      8
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      /SPACE 5
     IQDSPSPL   NS
     I                                  1    1  CTLCHR
     I                                  2  133  InDSPDTA
 
 
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
     C     *INKQ         OREQ      '1'
     C     DDCTRL        ORNE      *BLANK
     C                   EXSR      FILL_SUBF
     C                   ENDIF
 
     C                   EXSR      DET_PAGE
 
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
 
      * Window Left/Right
 
     C     *INKT         CASEQ     '1'           WINDOW
     C     *INKU         CASEQ     '1'           WINDOW
 
      * Enter pressed
 
     C     *IN04         CASEQ     '0'           ENTER
     C                   END
 
     C                   ENDIF
 
     C  NKQ              Z-ADD     0             PREV_@F
 
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
      * Enter pressed
      *****************************************************************
     C     ENTER         BEGSR
 
      * Return to top of subfile page
 
     C                   Z-ADD     ToP_DS_RRN    DS_RRN            7 0
     C                   Z-ADD     *ZERO         SUBF_RRN
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Window Left/Right
      *****************************************************************
     C     WINDOW        BEGSR
 
     C     *INKT         IFEQ      '1'
     C                   MOVEL     'L'           WindowDsp
     C                   ELSE
     C                   MOVEL     'R'           WindowDsp
     C                   ENDIF
 
      * Return to top of subfile page
 
     C                   Z-ADD     ToP_DS_RRN    DS_RRN            7 0
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
 
     C     DDFIND        IFNE      *BLANK
     C     *INKQ         ANDEQ     '1'
     C                   EXSR      DO_FIND
     C                   ELSE
     C     DDCTRL        IFNE      *BLANK
     C     *IN05         ANDEQ     '0'
     C     *IN06         ANDEQ     '0'
     C                   EXSR      DO_CTRL
     C                   ENDIF
     C                   ENDIF
 
      * Write subfile control
 
     C                   WRITE     SUBFLCTL                                     *
 
      * Get first record
 
     C     DS_RRN        CHAIN     QDSPSPL                            99
 
      * If not end of file
 
     C     *IN99         IFEQ      '0'
     C                   MOVEL     DS_RRN        ToP_DS_RRN        7 0
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
 
      * Write a record to the subfile
 
     C     WindowDsp     IFEQ      'L'
     C                   MOVEL     InDSPDTA      DSPDTA
     C                   ELSE
     C                   MOVE      InDSPDTA      DSPDTA
     C                   ENDIF
 
     C                   WRITE     SUBFLREC
     C     SUBF_RRN      IFEQ      NumPerPag
     C                   ADD       1             DS_RRN
     C     DS_RRN        CHAIN     QDSPSPL                            99
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     1             DS_RRN
     C                   MOVEL     'RCF1098'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   SETON                                            99    *
     C                   END
     C                   ELSE
     C                   ADD       1             DS_RRN
     C     DS_RRN        CHAIN     QDSPSPL                            99
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
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Rolldown
      ********************************************************************
     C     ROLLDOWN      BEGSR
 
     C                   Z-ADD     *ZERO         SUBF_RRN
     C                   Z-ADD     ToP_DS_RRN    DS_RRN
 
     C     DS_RRN        CHAIN     QDSPSPL                            99
 
      * Read previous
      * until count matches count of records previous read
 
     C     *IN99         DOWEQ     '0'
     C     SUBF_RRN      ANDLT     NumPerPag
     C                   SUB       1             DS_RRN
     C     DS_RRN        CHAIN     QDSPSPL                            99
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
      * DO_CTRL - DO CONTROL PROCESSING
      *****************************************************************
     C     DO_CTRL       BEGSR
 
      * top
     C     DDCTRL1       IFEQ      'T'
     C     DDCTRL        OREQ      '1'
     C                   Z-ADD     1             DS_RRN
     C                   ENDIF
 
      * botton
     C     DDCTRL1       IFEQ      'B'
     C                   Z-ADD     Last_RRN      DS_RRN
     C                   ENDIF
 
      * go to page
     C     DDCTRL1       IFEQ      'P'
     C     DDCTRL2       ANDNE     '+'
     C     DDCTRL2       ANDNE     '-'
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVEL     DDCTRL1x      ZFIELD
     C                   EXSR      ZALIGN
     C     ZRTN          IFEQ      *BLANK
     C                   MOVE      ZAFLD         PageNumber        5 0
     C                   Z-ADD     1             @P
     C     PageNumber    LOOKUP    PAGCNT(@P)                             99
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     RRNCNT(@P)    DS_RRN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * add/sub page
     C     DDCTRL1       IFEQ      'P'
     C     DDCTRL2       IFEQ      '+'
     C     DDCTRL2       OREQ      '-'
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVEL     DDCTRL2x      ZFIELD
     C                   EXSR      ZALIGN
     C     ZRTN          IFEQ      *BLANK
     C                   MOVE      ZAFLD         PageNumber
     C     DDCTRL2       IFEQ      '-'
     C                   Z-SUB     PageNumber    PageNumber
     C                   ENDIF
     C                   ADD       DDPAG         PageNumber
     C                   Z-ADD     1             @P
     C     PageNumber    LOOKUP    PAGCNT(@P)                             99
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     RRNCNT(@P)    DS_RRN
     C                   ELSE
     C     DDCTRL2       IFEQ      '+'
     C                   MOVEL     'RCF1098'     ZAMSID
     C                   ELSE
     C                   MOVEL     'RCF1099'     ZAMSID
     C                   ENDIF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * add/sub lines
     C     DDCTRL1       IFEQ      '+'
     C     DDCTRL1       OREQ      '-'
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVEL     DDCTRL1x      ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZAFLD         LineNumber        5 0
     C     ZRTN          IFEQ      *BLANK
     C     DDCTRL1       IFEQ      '+'
     C                   ADD       LineNumber    DS_RRN
     C                   ELSE
     C                   SUB       LineNumber    DS_RRN
     C                   ENDIF
     C     DS_RRN        IFGT      Highest_RRN
     C     DS_RRN        ORLE      0
     C                   Z-ADD     1             DS_RRN
     C                   MOVEL     'RCF1099'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * DO_FIND - DO FIND PROCESSING
      *****************************************************************
     C     DO_FIND       BEGSR
     C                   MOVE      'N'           String_Found      1
     C                   Z-ADD     DS_RRN        @F                7 0
     C     @F            CHAIN     QDSPSPL                            99
     C     *IN99         DOWEQ     '0'
     C                   CALL      'QCLSCAN'
     C                   PARM                    InDSPDTA
     C                   PARM      132           LENGTH1           3 0
     C                   PARM      1             START             3 0
     C                   PARM                    DDFIND
     C                   PARM      30            LENGTH2           3 0
     C                   PARM      '1'           TRANSLATE         1
     C                   PARM      '1'           TRIM              1
     C                   PARM      '?'           WILD              1
     C                   PARM                    RESULT            3 0
     C     RESULT        IFLT      1
     C     @F            OREQ      PREV_@F
     C                   ADD       1             @F
     C     @F            CHAIN     QDSPSPL                            99
     C                   ELSE
     C                   EVAL      String_Found = 'Y'
     C                   Z-ADD     @F            DS_RRN               99
     C                   Z-ADD     @F            PREV_@F
     C                   ENDIF
     C                   ENDDO
 
     C                   IF        String_Found = 'N'
     C                   MOVEL     'RCF1097'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * DET_PAGE - DETERMINE PAGE NUMBER
      *****************************************************************
     C     DET_PAGE      BEGSR
 
     C                   Z-ADD     1             DDPAG
     C     ToP_DS_RRN    LOOKUP    RRNCNT(DDPAG)                      99
     C                   SUB       1             DDPAG                  9999
     C   99              Z-ADD     1             DDPAG
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * ID_RRN - IDENTIFY RRNS VERSUS PAGE NUMBERS
      *****************************************************************
     C     ID_RRN        BEGSR
 
     C                   Z-ADD     99999         PAGCNT
     C                   Z-ADD     9999999       RRNCNT
 
     C                   Z-ADD     1             @F                7 0
     C                   Z-ADD     0             @P                5 0
     C     @F            CHAIN     QDSPSPL                            99
     C     *IN99         DOWEQ     '0'
     C     CTLCHR        IFEQ      '1'
     C     @P            IFLT      9999
     C                   ADD       1             @P
     C                   Z-ADD     @P            PAGCNT(@P)
     C                   Z-ADD     @F            RRNCNT(@P)
     C                   ENDIF
     C                   ENDIF
     C                   ADD       1             @F
     C     @F            CHAIN     QDSPSPL                            99
     C                   ENDDO
 
     C                   Z-ADD     RRNCNT(@P)    Last_RRN          7 0
     C                   Z-ADD     PAGCNT(@P)    DDHPAG            5 0
     C     @F            SUB       1             Highest_RRN       7 0
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * ZALIGN - ALIGN INPUT
      *****************************************************************
     C     ZALIGN        BEGSR
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANK        ZRTN              7            B:Return Code
     C                   PARM                    ZFIELD           16            B:Check Field
     C                   PARM      0             ZADEC             1 0          I:No Of Decs
     C                   PARM      5             ZADIG             2 0          I:No Of Digits
     C                   PARM      *BLANK        ZAFLD            16            O:Check Field
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
      * File
     C                   PARM                    I#PFILE          10
      * Command keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
 
      * Initialize program name
 
     C                   MOVEL     'FC200003 '   DDPGM
 
      * Set up subfile message queue information
 
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      '1'           *IN40
 
      * Set up standard screen fields.
 
     C                   MOVEL     PsJobName     DDJOB
     C                   MOVEL     PsUser        DDUSR
 
     C                   MOVEL     I#PFILE       DDPFILE
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Identify RRNs versus page numbers
 
     C                   EXSR      ID_RRN
 
     C                   Z-ADD     1             DS_RRN
     C                   Z-ADD     0             PREV_@F           7 0
 
     C                   MOVEL     'L'           WindowDsp         1
 
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
