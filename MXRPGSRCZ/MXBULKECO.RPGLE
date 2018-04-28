     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Bulk Export of Composites')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXBULKECO - Bulk Export of Composites                        *
      *                                                               *
      *  Function:  This module allows bulk export of composites      *
      *             to be done.                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. BUG17937           Date 24Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAAA03             Data 12Mar04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17937 - SEC3300 is Failing with an error.  Applied fix    *
      *             245268 (Recompile)                                *
      *  CAAA03 - Webfacing Changes                                   *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXBULKCDD CF   E             WORKSTN
     F                                     SFILE(SUBFLREC:SUBF_RRN)
     FMXCOMDPD  IF   E           K DISK
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
     C                   PARM                    I#EXTT            1
 
      * Display subfile screen until F3 taken
 
     C     *INKC         DOWEQ     '0'
     C                   EXSR      DSPLAY_SCN
     C                   END
 
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
     C  N50              EXSR      FILL_SUBF
     C                   ENDIF
 
      * Write subfile control and foooter
 
     C                   TIME                    DDTIME
     C                   WRITE     MSGSUBCT
     C**********         WRITE     SUBFLCTL                                                   CAAA03
     C                   WRITE     FOOTER
 
      * Read subfile control
 
     C                   WRITE     SUBFLCTL                                                   CAAA03
     C                   READ      SUBFLCTL                               99    *
 
      ** Clear the message queue & init error indicators
 
     C                   EXSR      CLR_MSGQ
 
      ** If F3 was not taken
 
     C     *INKC         IFEQ      '0'
 
      * Rolldown requested
 
     C     *IN05         CASEQ     '1'           ROLLDOWN
 
      * Check for a record selected from the subfile
 
     C     *IN(04)       CASEQ     '0'           CHK_SUBF
     C                   END
 
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      ** Clear the message queue & init error indicators
      *****************************************************************
     C     CLR_MSGQ      BEGSR
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
 
     C                   MOVEA     '0'           *IN(50)
     C                   MOVEA     '0000000000'  *IN(10)
 
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
      *   Maintain the record in the subfile
 
     C     DDACTN        IFNE      *BLANK
     C                   EXSR      MNT_SflREC
     C                   ELSE
     C                   MOVE      '0'           @INKC
     C                   ENDIF
 
      * Return to top of subfile page
 
     C                   MOVEL     ToP_COMI      CDCOMI
     C                   MOVEL     ToP_EXTT      CDEXTT
     C                   Z-ADD     *ZERO         SUBF_RRN
 
      * Read next if F3 not requested
 
     C     @INKC         IFEQ      '0'
     C                   READC     SUBFLREC                               99    *RECORD CHANGED
     C                   ELSE
     C                   MOVE      '1'           *IN99
     C                   MOVE      @INKC         *INKC
     C                   END
 
     C                   ENDDO
 
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
 
     C     MXCOMDK       SETLL     MXCOMDP0
     C                   READ      MXCOMDP0                               99    *
     C     *in99         DOWEQ     '0'
     C     CDEXTT        ANDNE     I#EXTT
     C     *IN99         OREQ      '0'
     C     CDENAB        ANDNE     'Y'
     C                   READ      MXCOMDP0                               99    *
     C                   ENDDO
 
      * If not end of file
 
     C     *IN99         IFEQ      '0'
     C                   MOVEL     CDCOMI        ToP_COMI          8
     C                   MOVEL     CDEXTT        ToP_EXTT          1
     C                   ELSE
     C                   MOVEL     *BLANK        ToP_COMI
     C                   MOVEL     *BLANK        ToP_EXTT
     C                   MOVEL     *BLANK        CDCOMI
     C                   MOVEL     *BLANK        CDEXTT
 
      * Else, if end of file
      * Issue message
 
     C                   MOVEL     'MX00001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      * Do while not end of file
 
     C     *IN99         DOWEQ     '0'
 
     C                   ADD       1             SUBF_RRN          4 0    04    *
 
      * Format data for output
 
     C                   EXSR      FMT_DATA
 
      * Write a record to the subfile
 
     C                   WRITE     SUBFLREC
     C     SUBF_RRN      IFEQ      NumPerPag
     C                   READ      MXCOMDP0                               99    *
     C     *in99         DOWEQ     '0'
     C     CDEXTT        ANDNE     I#EXTT
     C     *IN99         OREQ      '0'
     C     CDENAB        ANDNE     'Y'
     C                   READ      MXCOMDP0                               99    *
     C                   ENDDO
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        CDCOMI
     C                   MOVEL     *BLANK        CDEXTT
     C                   MOVEL     'MX00001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   SETON                                            99    *
     C                   END
     C                   ELSE
     C                   READ      MXCOMDP0                               99    *
     C     *in99         DOWEQ     '0'
     C     CDEXTT        ANDNE     I#EXTT
     C     *IN99         OREQ      '0'
     C     CDENAB        ANDNE     'Y'
     C                   READ      MXCOMDP0                               99    *
     C                   ENDDO
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        CDCOMI
     C                   MOVEL     *BLANK        CDEXTT
     C                   MOVEL     'MX00001'     ZAMSID
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
      * Maintain a record on the subfile
      ********************************************************************
     C     MNT_SflREC    BEGSR
 
      * Bulk Export Prompt
 
     C                   CALL      'MXBULKEPR'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM                    CDCOMI
     C                   PARM                    CDEXTT
     C                   PARM      '*NONE     '  W#FMT            10
     C                   PARM                    CDDESC
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXBULKEPR'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Return to top of subfile page
 
     C                   MOVEL     ToP_COMI      CDCOMI
     C                   MOVEL     ToP_EXTT      CDEXTT
     C                   Z-ADD     *ZERO         SUBF_RRN
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Format data for output
      ********************************************************************
     C     FMT_DATA      BEGSR
 
      * Description
     C                   MOVEL     CDDESC        DDSDES
 
      * Next Date
     C                   CALLB     'ZDATE2'
     C                   PARM      CDEXND        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATEN            6 0
     C                   PARM                    ZADATE            7
     C                   MOVE      ZADATE        DDLIN2
 
      * Last Date of Extract
     C                   CALLB     'ZDATE2'
     C                   PARM      CDLDTX        ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATEN
     C                   PARM                    ZADATE
     C                   MOVEL     ZADATE        DDLDTX
      * No. of COMs Extracted
     C     CDNOTX        IFNE      *ZERO
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      CDNOTX        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   MOVE      ZFIELD        DDNOTX
     C                   ELSE
     C                   MOVE      *BLANK        DDNOTX
     C                   ENDIF
      * No. of COMs/Sec Extracted
     C     CDNTSX        IFNE      *ZERO
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      CDNTSX        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   MOVE      ZFIELD        DDNTSX
     C                   ELSE
     C     CDLSTX        IFEQ      *BLANK
     C                   MOVE      *BLANK        DDNTSX
     C                   ELSE
     C                   MOVE      *BLANK        DDNTSX
     C                   ENDIF
     C                   ENDIF
 
      * Last Date of Transmission
     C                   CALLB     'ZDATE2'
     C                   PARM      CDLDTT        ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATEN
     C                   PARM                    ZADATE
     C                   MOVEL     ZADATE        DDLDTT
      * No. of COMs Transmitted
     C     CDNOTT        IFNE      *ZERO
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      CDNOTT        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   MOVE      ZFIELD        DDNOTT
     C                   ELSE
     C                   MOVE      *BLANK        DDNOTT
     C                   ENDIF
      * No. of COMs/Sec Transmitted
     C     CDNTST        IFNE      *ZERO
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      CDNTST        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   MOVE      ZFIELD        DDNTST
     C                   ELSE
     C     CDLSTT        IFEQ      *BLANK
     C                   MOVE      *BLANK        DDNTST
     C                   ELSE
     C                   MOVE      *BLANK        DDNTST
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Rolldown
      ********************************************************************
     C     ROLLDOWN      BEGSR
 
     C                   Z-ADD     *ZERO         SUBF_RRN
     C                   MOVEL     ToP_COMI      CDCOMI
     C                   MOVEL     ToP_EXTT      CDEXTT
 
     C     MXCOMDK       SETGT     MXCOMDP0
     C                   READP     MXCOMDP0                               99    *
     C     *in99         DOWEQ     '0'
     C     CDEXTT        ANDNE     I#EXTT
     C     *IN99         OREQ      '0'
     C     CDENAB        ANDNE     'Y'
     C                   READP     MXCOMDP0                               99    *
     C                   ENDDO
 
      * Read previous
      * until count matches count of records previous read
 
     C     *IN99         DOWEQ     '0'
     C     SUBF_RRN      ANDLT     NumPerPag
     C                   READP     MXCOMDP0                               99    *
     C     *in99         DOWEQ     '0'
     C     CDEXTT        ANDNE     I#EXTT
     C     *IN99         OREQ      '0'
     C     CDENAB        ANDNE     'Y'
     C                   READP     MXCOMDP0                               99    *
     C                   ENDDO
     C                   ADD       1             SUBF_RRN
     C                   ENDDO
 
      * Issue start of file message
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        CDCOMI
     C                   MOVEL     *BLANK        CDEXTT
     C                   MOVEL     'MX00002'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END
 
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
     C                   PARM      'MIDAS'       ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
 
      * Error encountered
 
     C     ZAMSID        IFNE      'MX00001'
     C     ZAMSID        ANDNE     'MX00002'
     C                   MOVE      '1'           *IN50
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'MXBULKECO'   DDPGM
      *
      ** Set up subfile message queue information
      *
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      '1'           *IN40
      *
      ** Set up standard screen fields.
      *
     C                   MOVEL     PsJobName     DDJOB
     C                   MOVEL     PsUser        DDUSR
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Initialize constants
 
     C                   Z-ADD     8             NumPerPag         2 0
 
      * Key list
 
     C     MXCOMDK       KLIST
     C                   KFLD                    CDCOMI
     C                   KFLD                    CDEXTT
 
     C     I#EXTT        COMP      'A'                                    70    *
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
