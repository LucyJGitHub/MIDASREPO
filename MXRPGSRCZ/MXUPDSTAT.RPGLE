     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Update Statistics')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXUPDSTAT - Update Statistics                                *
      *                                                               *
      *  Function:  This module updates information about the last    *
      *             extract and transmission for a given message type *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR702741           Date 02Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG17937           Date 24Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX002             Data 26Sep00               *
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17937 - SEC3300 is Failing with an error.  Applied fix    *
      *             245268                                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CMX002 - Meridian Export Enhancements - Phase 1              *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXCOMDPD  UF   E           K DISK    INFSR(*PSSR)
      * Composite Message Details
 
     FMXEXFDL2  UF   E           K DISK    INFSR(*PSSR)
      * Export Format Details
 
     FMXPLOGL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
     D                 DS
     D  TIME_STR               1      6S 0
     D  STR_HH                 1      2S 0
     D  STR_MM                 3      4S 0
     D  STR_SS                 5      6S 0
 
     D                 DS
     D  TIME_END               1      6S 0
     D  END_HH                 1      2S 0
     D  END_MM                 3      4S 0
     D  END_SS                 5      6S 0
 
 
     D                 DS
     D  BUF_TIME               1      8
     D  BUF_HH                 1      2
     D  BUF_C1                 3      3
     D  BUF_MM                 4      5
     D  BUF_C2                 6      6
     D  BUF_SS                 7      8
 
     D                 DS
     D  ALP_TIME               1      6
     D  ALP_HH                 1      2
     D  ALP_MM                 3      4
     D  ALP_SS                 5      6
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      ** Inputs to ZFREQB
     D  ZFREQ          S              1A
     D  ZDAYNO         S              5  0
     D  ZCCY           S              3A
     D  ZMDAY          S              2  0
     D  ZLOC           S              3A
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
 
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
      * Mode
      * Composite ID
      * Extract Type
      * Format
      * Function
      * Extract Member
 
     C                   PARM                    I#MODE            1
     C                   PARM                    I#COMI            8
     C                   PARM                    I#EXTT            1
     C                   PARM                    I#FMT            10
     C                   PARM                    I#FUNC            1
 
 
      * Read the performance log
 
     C     I#FUNC        SETLL     MXPLOGP0
     C     I#FUNC        READE     MXPLOGP0                               99    *
      * first
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     PLTIME        TIME_STR
     C                   ENDIF
 
      * Read the performance log until EOF
 
     C     *IN99         DOWEQ     '0'
     C                   Z-ADD     PLTIME        TIME_END
     C                   ADD       1             REC_CNT           6 0
     C     I#FUNC        READE     MXPLOGP0                               99    *
     C                   ENDDO
 
      * If no start and end times found
      * Set up start and end times as current time
 
     C     TIME_STR      IFEQ      *ZERO
     C     TIME_END      ANDEQ     *ZERO
     C                   TIME                    TIME_STR
     C                   TIME                    TIME_END
     C                   ENDIF
 
      * Calculate number of composites/second
 
     C                   EXSR      CAL_TOS
     C     TOS           IFNE      0
     C     REC_CNT       DIV(H)    TOS           NPS               4 0
     C                   ELSE
     C                   Z-ADD     *ZERO         NPS
     C                   ENDIF
 
      * Format start and end times for output
 
     C                   MOVEL     TIME_STR      ALP_TIME
     C                   MOVEL     ALP_HH        BUF_HH
     C                   MOVEL     ALP_MM        BUF_MM
     C                   MOVEL     ALP_SS        BUF_SS
     C                   MOVEL     ':'           BUF_C1
     C                   MOVEL     ':'           BUF_C2
     C                   MOVEL     BUF_TIME      #_LST             8
 
     C                   MOVEL     TIME_END      ALP_TIME
     C                   MOVEL     ALP_HH        BUF_HH
     C                   MOVEL     ALP_MM        BUF_MM
     C                   MOVEL     ALP_SS        BUF_SS
     C                   MOVEL     ':'           BUF_C1
     C                   MOVEL     ':'           BUF_C2
     C                   MOVEL     BUF_TIME      #_LET             8
 
      * Process a single format or process a composite
 
     C     I#COMI        IFEQ      '*NONE   '
     C                   EXSR      PROC_FMT
     C                   ELSE
     C                   EXSR      PROC_COM
     C                   ENDIF
 
      * Return
 
     C                   SETON                                        LR
     C                   RETURN
      *
      /SPACE 5
      ********************************************************************
      * Calculate total number of seconds
      ********************************************************************
     C     CAL_TOS       BEGSR
 
     C     TIME_END      IFLT      TIME_STR
     C                   ADD       240000        TIME_END
     C                   ENDIF
 
     C     END_HH        SUB       STR_HH        TOT_HH            6 0
     C     END_MM        SUB       STR_MM        TOT_MM            6 0
     C     END_SS        SUB       STR_SS        TOT_SS            6 0
 
     C     STR_MM        IFGT      END_MM
     C                   SUB       1             TOT_HH
     C                   ADD       60            TOT_MM
     C                   ENDIF
 
     C     STR_SS        IFGT      END_SS
     C                   SUB       1             TOT_MM
     C                   ADD       60            TOT_SS
     C                   ENDIF
 
     C                   MULT      3600          TOT_HH
     C                   MULT      60            TOT_MM
 
     C                   Z-ADD     TOT_HH        TOS               7 0
     C                   ADD       TOT_MM        TOS
     C                   ADD       TOT_SS        TOS
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * Process a composite
      *********************************************************************
     C     PROC_COM      BEGSR
 
      * Get the Composite Message Details record
 
     C     MXCOMDK       CHAIN     MXCOMDP0                           99        *
     C     *in99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'MISSING COMPOSITE:'
     C                             + I#COMI + I#EXTT
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Update the Composite Message Details record
 
     C     I#FUNC        IFEQ      'X'
     C                   Z-ADD     BJRDNB        CDLDTX
     C                   MOVEL     #_LST         CDLSTX
     C                   MOVEL     #_LET         CDLETX
     C                   Z-ADD     REC_CNT       CDNOTX
     C                   Z-ADD     NPS           CDNTSX
     C                   ELSE
     C                   Z-ADD     BJRDNB        CDLDTT
     C                   MOVEL     #_LST         CDLSTT
     C                   MOVEL     #_LET         CDLETT
     C                   Z-ADD     REC_CNT       CDNOTT
     C                   Z-ADD     NPS           CDNTST
     C                   ENDIF
 
      * Update the extract control indicator
      * after a successful extract
 
     C     I#FUNC        IFEQ      'X'
     C                   ADD       1             CDXCTL
     C                   ENDIF
 
      * Update the next export date
      * if this is a COB transmission update
 
     C     I#FUNC        IFEQ      'T'
     C     I#MODE        ANDEQ     'C'
     C     CDEXND        ANDLT     BJDNWD
     C     CDEXND        ANDNE     *ZERO
     C                   EXSR      UPD_C_EXND
     C                   ENDIF
      *
      * Log an error on the error log
      *
     C     I#FUNC        IFEQ      'T'
     C     CDTCTL        IFGT      1
     C                   CLEAR                   BUF200
     C                   EVAL      BUF200 = 'Composite ID ' +  I#COMI +
     C                                      ' and Extract Type ' + I#EXTT +
     C                                      ' have been ' +
     C                                      'transmitted more than once.' +
     C                                      ' The mode is ' + I#MODE + '.'
     C
     C                   CALLB     'MXWRTELOG'
     C                   PARM                    BUF200          200
     C                   ENDIF
     C                   Z-ADD     0             CDXCTL
     C                   ENDIF
     C                   Z-ADD     0             CDTCTL
 
     C                   UPDATE    MXCOMDP0                                     *
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Update the next export date (on a COMPOSITE)
      ********************************************************************
     C     UPD_C_EXND    BEGSR
 
      * Daily
     C     CDEXFQ        IFEQ      'D'
 
     C                   Z-ADD     BJDNWD        CDEXND
 
     C                   ELSE
 
     C                   CALLB     'ZFREQB'
     C                   PARM                    RetCodeIn
     C                   PARM      CDEXFQ        ZFREQ
     C                   PARM      CDEXND        ZDAYNO
     C                   PARM      BJLCCY        ZCCY
     C                   PARM      *BLANKS       ZLOC                                       AR702741
     C                   PARM      CDEXDY        ZMDAY
     C                   PARM                    BJDFIN
     C                   PARM                    SDGELR
 
     C                   Z-ADD     ZDAYNO        CDEXND
 
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * Process a single format
      *********************************************************************
     C     PROC_FMT      BEGSR
 
      * Get the Single Format Details
 
     C     I#FMT         CHAIN     MXEXFDP0                           99        *
     C     *in99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'MISSING FORMAT:'
     C                             + I#FMT
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Update the Format record
 
     C     I#FUNC        IFEQ      'X'
     C                   Z-ADD     BJRDNB        EXLDTX
     C                   MOVEL     #_LST         EXLSTX
     C                   MOVEL     #_LET         EXLETX
     C                   Z-ADD     REC_CNT       EXNOTX
     C                   Z-ADD     NPS           EXNTSX
     C                   ELSE
     C                   Z-ADD     BJRDNB        EXLDTT
     C                   MOVEL     #_LST         EXLSTT
     C                   MOVEL     #_LET         EXLETT
     C                   Z-ADD     REC_CNT       EXNOTT
     C                   Z-ADD     NPS           EXNTST
     C                   ENDIF
 
      * Update the extract control indicator
      * after a successful extract
 
     C     I#FUNC        IFEQ      'X'
     C                   ADD       1             EXXCTL
     C                   ENDIF
 
      * Update the next export date
      * if this is a COB transmission update
 
     C     I#FUNC        IFEQ      'T'
     C     I#MODE        ANDEQ     'C'
     C     EXEXND        ANDLT     BJDNWD
     C     EXEXND        ANDNE     *ZERO
     C                   EXSR      UPD_F_EXND
     C                   ENDIF
      *
      * Log an error on the error log
      *
     C     I#FUNC        IFEQ      'T'
     C     EXTCTL        IFGT      1
     C                   CLEAR                   BUF200
     C                   EVAL      BUF200 = 'Format' +  I#FMT  +
     C                                      ' has been ' +
     C                                      'transmitted more than once.' +
     C                                      ' The mode is ' + I#MODE + '.'
     C
     C                   CALLB     'MXWRTELOG'
     C                   PARM                    BUF200          200
     C                   ENDIF
     C                   Z-ADD     0             EXXCTL
     C                   ENDIF
     C                   Z-ADD     0             EXTCTL
 
     C                   UPDATE    MXEXFDP0                                     *
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Update the next export date (on a SINGLE FORMAT)
      ********************************************************************
     C     UPD_F_EXND    BEGSR
 
      * Daily
     C     EXEXFQ        IFEQ      'D'
 
     C                   Z-ADD     BJDNWD        EXEXND
 
     C                   ELSE
 
     C                   CALLB     'ZFREQB'
     C                   PARM                    RetCodeIn
     C                   PARM      EXEXFQ        ZFREQ
     C                   PARM      EXEXND        ZDAYNO
     C                   PARM      BJLCCY        ZCCY
     C                   PARM      *BLANKS       ZLOC                                       AR702741
     C                   PARM      EXEXDY        ZMDAY
     C                   PARM                    BJDFIN
     C                   PARM                    SDGELR
 
     C                   Z-ADD     ZDAYNO        EXEXND
 
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      *  Access General Ledger Details
 
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      * Initialization
 
     C                   Z-ADD     *ZERO         TIME_STR
     C                   Z-ADD     *ZERO         TIME_END
 
      * Key lists
 
     C     MXCOMDK       KLIST
     C                   KFLD                    I#COMI
     C                   KFLD                    I#EXTT
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
