     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Audit Enquiry - Summary')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO100102 - Audit Enquiry - Summary                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG2410            Date 30Apr04               *
      *  Prev Amend No. CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG2410 - Improve web-facing display                         *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     FGO100102DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SUBFLREC:SUBF_RRN)
     FGOAUW0PD  IF   E           K DISK    INFSR(*PSSR)
     FGPAUIPPD  IF   E           K DISK    INFSR(*PSSR)                                      BUG2410
 
      *****************************************************************
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
     D NumPerPag       C                   CONST(14)
 
 
      ** Array of Fields in error.
     D RIE             S             14    DIM(NumPerPag)
 
 
     D                 DS
     D  InputUser              1     14
     D  AHINPT                 1      4
     D  AHUSER                 5     14
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
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
     C     DDINPT        ORNE      *BLANK
     C     DDUSER        ORNE      *BLANK
     C                   EXSR      FILL_SUBF
     C                   ENDIF
 
     C                   MOVEL     *BLANK        DDINPT
     C                   MOVEL     *BLANK        DDUSER
 
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
 
     C     DDINPT        CASNE     *BLANK        CONTINUE
     C     DDUSER        CASNE     *BLANK        CONTINUE
 
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
 
     C                   MOVEL     ToP_INPT      AHINPT
     C                   MOVEL     ToP_USER      AHUSER
     C                   Z-ADD     *ZERO         SUBF_RRN
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Fill subfile
      *****************************************************************
     C     FILL_SUBF     BEGSR
 
     C     DDINPT        IFNE      *BLANK
     C     DDUSER        ORNE      *BLANK
                                                                                             BUG2410
     C     DDINPT        IFEQ      '?'                                                       BUG2410
     C                   EXSR      ACS_INPT                                                  BUG2410
     C                   END                                                                 BUG2410
                                                                                             BUG2410
     C                   MOVEL     DDINPT        AHINPT
     C                   MOVEL     DDUSER        AHUSER
     C                   ENDIF
 
     C                   MOVEA     '000'         *IN(1)
     C                   MOVEA     '1'           *IN(4)
     C                   Z-ADD     *ZERO         SUBF_RRN
 
      * Write subfile control
 
     C                   WRITE     SUBFLCTL                                     *
 
      * Get first record
 
     C     GOAUW0K       SETLL     GOAUW0D0
     C                   READ      GOAUW0D0                               99    *
 
      * If not end of file
 
     C     *IN99         IFEQ      '0'
     C                   MOVEL     AHINPT        ToP_INPT          4
     C                   MOVEL     AHUSER        ToP_USER         10
     C                   ELSE
     C                   MOVEL     *BLANK        ToP_INPT
     C                   MOVEL     *BLANK        ToP_USER
     C                   MOVEL     *BLANK        AHINPT
     C                   MOVEL     *BLANK        AHUSER
 
      * Else, if end of file
      * Issue message
 
     C                   MOVEL     'GO00001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      * Do while not end of file
 
     C     *IN99         DOWEQ     '0'
 
     C                   ADD       1             SUBF_RRN          4 0    04    *
 
      * In error?
 
     C     InputUser     LOOKUP    RIE                                    65
                                                                                             BUG2410
      * Get input description                                                                BUG2410
     C                   MOVE      *BLANK        AIDESC                                      BUG2410
     C     AHINPT        CHAIN     GPAUIPD0                           99                     BUG2410
 
      * Write a record to the subfile
 
     C                   WRITE     SUBFLREC
     C     SUBF_RRN      IFEQ      NumPerPag
     C                   READ      GOAUW0D0                               99    *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        AHINPT
     C                   MOVEL     *BLANK        AHUSER
     C                   MOVEL     'GO00001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   SETON                                            99    *
     C                   END
     C                   ELSE
     C                   READ      GOAUW0D0                               99    *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        AHINPT
     C                   MOVEL     *BLANK        AHUSER
     C                   MOVEL     'GO00001'     ZAMSID
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
 
     C                   MOVEL     AHINPT        I#INPT
     C                   MOVEL     AHUSER        I#USER
     C                   MOVEL     ToP_INPT      I#TINPT
     C                   MOVEL     ToP_USER      I#TUSER
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
     C                   SETON                                        LR
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Rolldown
      ********************************************************************
     C     ROLLDOWN      BEGSR
 
     C                   Z-ADD     *ZERO         SUBF_RRN
     C                   MOVEL     ToP_INPT      AHINPT
     C                   MOVEL     ToP_USER      AHUSER
 
     C     GOAUW0K       SETGT     GOAUW0D0
     C                   READP     GOAUW0D0                               99    *
 
      * Read previous
      * until count matches count of records previous read
 
     C     *IN99         DOWEQ     '0'
     C     SUBF_RRN      ANDLT     NumPerPag
     C                   READP     GOAUW0D0                               99    *
     C                   ADD       1             SUBF_RRN
     C                   ENDDO
 
      * Issue start of file message
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        AHINPT
     C                   MOVEL     *BLANK        AHUSER
     C                   MOVEL     'GO00002'     ZAMSID
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
     C                   MOVEL     'GO00010'     ZAMSID
     C                   EXSR      ZASNMS
 
     C                   ENDIF
 
      * If action code not OK, log record in error
 
     C     ActnOK        IFNE      'Y'
     C                   Z-ADD     1             @RIE              2 0
     C     *BLANK        LOOKUP    RIE(@RIE)                              99
     C                   MOVEL     InputUser     RIE(@RIE)
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                               BUG2410
      *****************************************************************                      BUG2410
      * Access an input                                                                      BUG2410
      *****************************************************************                      BUG2410
     C     ACS_INPT      BEGSR                                                               BUG2410
     C                   CALL      'GPAU0017'                           9999                 BUG2410
     C                   PARM      *BLANK        RETC              6                         BUG2410
     C                   PARM      *BLANK        DDINPT                                      BUG2410
     C                   ENDSR                                                               BUG2410
      *****************************************************************                      BUG2410
      /SPACE 5
      *****************************************************************
      * ZASNMS - SEND A MESSAGE
      *****************************************************************
     C     ZASNMS        BEGSR
 
     C                   CALL      'Y2SNMGC'                            0909    *
     C                   PARM      DDPGM         ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM      'MIDAS   '    ZAMSGF           10
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
      * Top Input
      * Top User
     C                   PARM                    I#TINPT           4
     C                   PARM                    I#TUSER          10
      * Zone
      * User
      * Input
      * From Date
      * To Date
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#USER           10
     C                   PARM                    I#INPT            4
     C                   PARM                    I#FRDT            5 0
     C                   PARM                    I#TODT            5 0
      * Command keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
 
      * Initialize program name
 
     C                   MOVEL     'GO100102 '   DDPGM
 
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
 
      * Convert dates
 
     C                   CALLB     'ZDATE2'
     C                   PARM      I#FRDT        ZDAYNO            5 0
     C                   PARM      'D'           ZDATFM            1
     C                   PARM      *ZERO         ZDATE             6 0
     C                   PARM      *BLANK        FRDATE
 
     C                   CALLB     'ZDATE2'
     C                   PARM      I#TODT        ZDAYNO
     C                   PARM      'D'           ZDATFM
     C                   PARM      *ZERO         ZDATE
     C                   PARM      *BLANK        TODATE
 
     C                   MOVEL     I#TINPT       AHINPT
     C                   MOVEL     I#TUSER       AHUSER
 
      * Key list
 
     C     GOAUW0K       KLIST
     C                   KFLD                    AHINPT
     C                   KFLD                    AHUSER
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
