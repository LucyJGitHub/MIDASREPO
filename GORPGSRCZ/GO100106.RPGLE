     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Audit Enquiry - User')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO100106 - Audit Enquiry - User                              *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG6979            Date 03May05               *
      *                 BUG2410            Date 30Apr04               *
      *                 TDA035             Date 02Apr04               *
      *                 CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026  - Consumer Banking (Recompile)                       *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  BUG2410 - Improve web-facing display                         *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     FGO100106DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SUBFLREC:SUBF_RRN)
     FGOAUW2PD  IF   E           K DISK    INFSR(*PSSR)
     FGPAUCHL0  IF   E           K DISK    INFSR(*PSSR)
     FMUSER     IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
     D NumPerPag       C                   CONST(14)
      ** Array of Fields in error.
     D RIE             S             17S 0 DIM(NumPerPag)
 
 
     D ZMUSER          DS            17
     D  UBRC                  11     13
 
 
     D                 DS
     D  YYMMDD                 1      6
     D  YY                     1      2  0
     D  MM                     3      4  0
     D  DD                     5      6  0
 
 
     D MON             S              3    DIM(12) CTDATA PERRCD(12)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
 
 
      /SPACE 5
 
      *                                                                                      BUG6979
      **  GET ZMUSER to access default branch.                                               BUG6979
      *                                                                                      BUG6979
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG6979
     C                   IN        ZMUSER                                                    BUG6979
     C                   UNLOCK    ZMUSER                                                    BUG6979
                                                                                             BUG6979
      * Set up standard screen fields.                                                       BUG6979
                                                                                             BUG6979
     C                   MOVEL     PsJobName     DDJOB                                       BUG6979
     C                   MOVEL     PsUser        DDUSR                                       BUG6979
 
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
     C     DDREFI        ORNE      *BLANK
     C     DDACTN        ORNE      DDACTN_P
     C     DDBRCA        ORNE      DDBRCA_P
     C     DDRUND        ORNE      DDRUND_P
     C     DDMACD        ORNE      DDMACD_P
     C     DDCCID        ORNE      DDCCID_P
     C                   EXSR      FILL_SUBF
     C                   ENDIF
 
     C                   MOVEL     *BLANK        DDINPT
     C                   MOVEL     *BLANK        DDREFI
     C                   MOVEL     DDACTN        DDACTN_P         10
     C                   MOVEL     DDBRCA        DDBRCA_P          3
     C                   MOVEL     DDRUND        DDRUND_P          7
     C                   MOVEL     DDMACD        DDMACD_P          7
     C                   MOVEL     DDCCID        DDCCID_P         10
 
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
     C     DDREFI        CASNE     *BLANK        CONTINUE
 
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
 
     C     DDACTX        IFNE      *BLANK
     C                   EXSR      ACTN_CHK
     C     ActnOK        IFEQ      'Y'
     C                   EXSR      ENQ_SflREC
     C                   ENDIF
     C                   ELSE
     C                   MOVE      '0'           @INKC
     C                   ENDIF
 
      * Read next if F3 not requested
 
     C     @INKC         IFEQ      '0'
     C                   READC     SUBFLREC                               99    *RECORD CHANGED
     C                   ELSE
     C                   MOVE      '1'           *IN99
     C                   MOVE      @INKC         *INKC
     C                   END
 
     C                   ENDDO
 
      * Return to top of subfile page
 
     C                   MOVEL     ToP_INPT      AHINPT
     C                   MOVEL     ToP_REFI      AHREFI
     C                   Z-ADD     ToP_RDNB      AHRDNB
     C                   Z-ADD     ToP_CCID      AHCCID
     C                   Z-ADD     ToP_CID       AHCID
     C                   Z-ADD     *ZERO         SUBF_RRN
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Fill subfile
      *****************************************************************
     C     FILL_SUBF     BEGSR
 
     C     DDINPT        IFNE      *BLANK
     C     DDREFI        ORNE      *BLANK
                                                                                             BUG2410
     C     DDINPT        IFEQ      '?'                                                       BUG2410
     C                   EXSR      ACS_INPT                                                  BUG2410
     C                   END                                                                 BUG2410
                                                                                             BUG2410
     C                   MOVEL     DDINPT        AHINPT
     C                   MOVEL     DDREFI        AHREFI
     C                   Z-ADD     *ZERO         AHRDNB
     C                   Z-ADD     *ZERO         AHCCID
     C                   Z-ADD     *ZERO         AHCID
     C                   ELSE
     C     DDACTN        IFNE      DDACTN_P
     C     DDBRCA        ORNE      DDBRCA_P
     C     DDRUND        ORNE      DDRUND_P
     C     DDMACD        ORNE      DDMACD_P
     C     DDCCID        ORNE      DDCCID_P
     C                   MOVEL     *BLANK        AHINPT
     C                   MOVEL     *BLANK        AHREFI
     C                   Z-ADD     *ZERO         AHRDNB
     C                   Z-ADD     *ZERO         AHCCID
     C                   Z-ADD     *ZERO         AHCID
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEA     '000'         *IN(1)
     C                   MOVEA     '1'           *IN(4)
     C                   Z-ADD     *ZERO         SUBF_RRN
 
      * Write subfile control
 
     C                   WRITE     SUBFLCTL                                     *
 
      * Get first record
 
     C     GOAUW2K       SETLL     GOAUW2D0
     C                   READ      GOAUW2D0                               99    *
     C                   EXSR      READ4SELECT
 
      * If not end of file
 
     C     *IN99         IFEQ      '0'
     C                   MOVEL     AHINPT        ToP_INPT          4
     C                   MOVEL     AHREFI        ToP_REFI         40
     C                   Z-ADD     AHRDNB        ToP_RDNB          5 0
     C                   Z-ADD     AHCCID        ToP_CCID         10 0
     C                   Z-ADD     AHCID         ToP_CID          17 0
     C                   ELSE
     C                   MOVEL     *BLANK        ToP_INPT
     C                   MOVEL     *BLANK        ToP_REFI
     C                   Z-ADD     *ZERO         ToP_RDNB
     C                   Z-ADD     *ZERO         ToP_CCID
     C                   Z-ADD     *ZERO         ToP_CID
     C                   MOVEL     *BLANK        AHINPT
     C                   MOVEL     *BLANK        AHREFI
     C                   Z-ADD     *ZERO         AHRDNB
     C                   Z-ADD     *ZERO         AHCCID
     C                   Z-ADD     *ZERO         AHCID
 
      * Else, if end of file
      * Issue message
 
     C                   MOVEL     'GO00001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      * Do while not end of file
 
     C     *IN99         DOWEQ     '0'
 
     C                   ADD       1             SUBF_RRN          4 0    04    *
 
      * In error?
 
     C     AHCID         LOOKUP    RIE                                    65
 
      * Write a record to the subfile
 
     C                   WRITE     SUBFLREC
     C     SUBF_RRN      IFEQ      NumPerPag
     C                   READ      GOAUW2D0                               99    *
     C                   EXSR      READ4SELECT
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        AHINPT
     C                   MOVEL     *BLANK        AHREFI
     C                   Z-ADD     *ZERO         AHRDNB
     C                   Z-ADD     *ZERO         AHCCID
     C                   Z-ADD     *ZERO         AHCID
     C                   MOVEL     'GO00001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   SETON                                            99    *
     C                   END
     C                   ELSE
     C                   READ      GOAUW2D0                               99    *
     C                   EXSR      READ4SELECT
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        AHINPT
     C                   MOVEL     *BLANK        AHREFI
     C                   Z-ADD     *ZERO         AHRDNB
     C                   Z-ADD     *ZERO         AHCCID
     C                   Z-ADD     *ZERO         AHCID
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
 
     C                   Z-ADD     *ZERO         RIE
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Enquire on the record in the subfile
      ********************************************************************
     C     ENQ_SflREC    BEGSR
 
      * Display the audit update overview
 
     C                   EXSR      UPDT_OVERVIEW
 
      * Return to top of subfile page
 
     C                   MOVEL     ToP_INPT      AHINPT
     C                   MOVEL     ToP_REFI      AHREFI
     C                   Z-ADD     ToP_RDNB      AHRDNB
     C                   Z-ADD     ToP_CCID      AHCCID
     C                   Z-ADD     ToP_CID       AHCID
     C                   Z-ADD     *ZERO         SUBF_RRN
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Rolldown
      ********************************************************************
     C     ROLLDOWN      BEGSR
 
     C                   Z-ADD     *ZERO         SUBF_RRN
     C                   MOVEL     ToP_INPT      AHINPT
     C                   MOVEL     ToP_REFI      AHREFI
     C                   Z-ADD     ToP_RDNB      AHRDNB
     C                   Z-ADD     ToP_CCID      AHCCID
     C                   Z-ADD     ToP_CID       AHCID
 
     C     GOAUW2K       SETGT     GOAUW2D0
     C                   READP     GOAUW2D0                               99    *
     C                   EXSR      READP4SELECT
 
      * Read previous
      * until count matches count of records previous read
 
     C     *IN99         DOWEQ     '0'
     C     SUBF_RRN      ANDLT     NumPerPag
     C                   READP     GOAUW2D0                               99    *
     C                   EXSR      READP4SELECT
     C                   ADD       1             SUBF_RRN
     C                   ENDDO
 
      * Issue start of file message
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        AHINPT
     C                   MOVEL     *BLANK        AHREFI
     C                   Z-ADD     *ZERO         AHRDNB
     C                   Z-ADD     *ZERO         AHCCID
     C                   Z-ADD     *ZERO         AHCID
     C                   MOVEL     'GO00002'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Read for selection
      *****************************************************************
     C     READ4SELECT   BEGSR
     C  N99              EXSR      CONV_FIELDS
     C     *IN99         DOWEQ     '0'
     C     DDACTN        ANDNE     *BLANK
     C     DDACTN        ANDNE     AHACTN
     C     *IN99         OREQ      '0'
     C     DDBRCA        ANDNE     *BLANK
     C     DDBRCA        ANDNE     AHBRCA
     C     *IN99         OREQ      '0'
     C     DDRUND        ANDNE     *BLANK
     C     DDRUND        ANDNE     RUNDAT
     C     *IN99         OREQ      '0'
     C     DDMACD        ANDNE     *BLANK
     C     DDMACD        ANDNE     MACDAT
     C     *IN99         OREQ      '0'
     C     DDCCID        ANDNE     *BLANK
     C     DDCCID        ANDNE     CommitID
     C                   READ      GOAUW2D0                               99    *
     C  N99              EXSR      CONV_FIELDS
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Read previous for selection
      *****************************************************************
     C     READP4SELECT  BEGSR
     C  N99              EXSR      CONV_FIELDS
     C     *IN99         DOWEQ     '0'
     C     DDACTN        ANDNE     *BLANK
     C     DDACTN        ANDNE     AHACTN
     C     *IN99         OREQ      '0'
     C     DDBRCA        ANDNE     *BLANK
     C     DDBRCA        ANDNE     AHBRCA
     C     *IN99         OREQ      '0'
     C     DDRUND        ANDNE     *BLANK
     C     DDRUND        ANDNE     RUNDAT
     C     *IN99         OREQ      '0'
     C     DDMACD        ANDNE     *BLANK
     C     DDMACD        ANDNE     MACDAT
     C     *IN99         OREQ      '0'
     C     DDCCID        ANDNE     *BLANK
     C     DDCCID        ANDNE     CommitID
     C                   READP     GOAUW2D0                               99    *
     C  N99              EXSR      CONV_FIELDS
     C                   ENDDO
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
      * Convert Fields
      *****************************************************************
     C     CONV_FIELDS   BEGSR
 
      * Access audit header
 
     C     GPAUCHK       CHAIN     GPAUCHD0                           H1
 
      * Convert run date
 
     C                   CALLB     'ZDATE2'
     C                   PARM      AHRDNB        ZDAYNO            5 0
     C                   PARM      'D'           ZDATFM            1
     C                   PARM      *ZERO         ZDATE             6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   MOVEL     ZADATE        RUNDAT
 
      * Convert machine date
 
     C                   MOVEL     AHDATE        YYMMDD
     C                   EVAL      MACDAT = %subst(YYMMDD: 5:2)
     C                                      + MON(MM)
     C                                      + %subst(YYMMDD: 1:2)
 
      * Convert CCID
 
     C                   MOVEL     AHCCID        CommitID         10
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Display the audit update overview
      *****************************************************************
     C     UPDT_OVERVIEW BEGSR
 
     C                   CALL      'GO100108'
     C                   PARM      *BLANK        X_RTCD            7
     C                   PARM      *BLANK        X_ERMS           50
      * INPUT
      * Zone
     C                   PARM                    I#ZONE           10
      * ID
     C                   PARM      AHCID         I#CID            17 0
 
      * Command keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
 
      * Error
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'UPDATE OVERVIEW ENQUIRY FAILED'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Action code check
      *****************************************************************
     C     ACTN_CHK      BEGSR
 
     C                   MOVEL     'Y'           ActnOK            1
 
      * Check for valid action code
 
     C     DDACTX        IFNE      'E'
 
     C                   MOVEL     'N'           ActnOK
     C                   MOVEL     'GO00010'     ZAMSID
     C                   EXSR      ZASNMS
 
     C                   ELSE
 
      * Check for user authority to action code
 
     C     AHBRCA        IFNE      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTX        @ZACTN            1
     C                   PARM      AHBRCA        @ZBR              3
     C                   PARM      *ZERO         @ERR              1 0
     C     @ERR          IFEQ      1
     C     @ERR          OREQ      2
     C                   MOVEL     'N'           ActnOK
     C                   MOVEL     'GO00011'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * If action code not OK, log record in error
 
     C     ActnOK        IFNE      'Y'
     C                   MOVE      '0'           @INKC
     C                   Z-ADD     1             @RIE              2 0
     C     *ZERO         LOOKUP    RIE(@RIE)                              99
     C                   Z-ADD     AHCID         RIE(@RIE)
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
      **********                                                                             BUG6979
      ****GET*ZMUSER*to*access*default*branch.                                               BUG6979
      **********                                                                             BUG6979
     C******DTAARA       DEFINE                  ZMUSER                                      BUG6979
     C**********         IN        ZMUSER                                                    BUG6979
     C**********         UNLOCK    ZMUSER                                                    BUG6979
 
      * Initialize program name
 
     C                   MOVEL     'GO100106 '   DDPGM
 
      * Set up subfile message queue information
 
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      '1'           *IN40
      **********                                                                             BUG6979
      **Set*up*standard*screen*fields.                                                       BUG6979
      **********                                                                             BUG6979
     C**********         MOVEL     PsJobName     DDJOB                                       BUG6979
     C**********         MOVEL     PsUser        DDUSR                                       BUG6979
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Access User details
 
     C     I#USER        CHAIN     MUSERDDF                           99
     C   99              MOVEL     *BLANK        USER1
     C   99              MOVEL     ' * UNKNOWN *'USER1
 
      * Convert dates
 
     C                   CALLB     'ZDATE2'
     C                   PARM      I#FRDT        ZDAYNO
     C                   PARM      'D'           ZDATFM
     C                   PARM      *ZERO         ZDATE
     C                   PARM      *BLANK        FRDATE
 
     C                   CALLB     'ZDATE2'
     C                   PARM      I#TODT        ZDAYNO
     C                   PARM      'D'           ZDATFM
     C                   PARM      *ZERO         ZDATE
     C                   PARM      *BLANK        TODATE
 
 
      * Key list
 
     C     GOAUW2K       KLIST
     C                   KFLD                    AHINPT
     C                   KFLD                    AHREFI
     C                   KFLD                    AHRDNB
     C                   KFLD                    AHCCID
     C                   KFLD                    AHCID
     C     GPAUCHK       KLIST
     C                   KFLD                    I#ZONE
     C                   KFLD                    AHCID
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
** MON
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
