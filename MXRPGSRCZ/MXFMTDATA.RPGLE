     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Format Data (For Export)')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXFMTDATA - Format Data (For Export)                         *
      *                                                               *
      *  Function:  This module formats data                          *
      *             for export to Meridian                            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CTI006             Date 31Mar14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                         *CREATE    Date                       *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CTI006 - Trade Finance BF Midas 2.2 Interface                *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXCOMFL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * R E F O R M A T   D A T A
     D/COPY MXCPYSRC,MXRFMDD
 
 
 
      * FORMAT/SEQUENCE IN MESSAGE
     D #_FMTSEQM       S             11    DIM(20)
      * COMPOSITE FORMAT
     D #_COMF          S            100    DIM(20)
 
 
      * FIELD DATA ARRAYS
     D*#_FLDD01*       S             17    DIM(300)                                           CTI006
     D*#_FLDD02*       S             17    DIM(300)                                           CTI006
     D*#_FLDD03*       S             17    DIM(300)                                           CTI006
     D*#_FLDD04*       S             17    DIM(300)                                           CTI006
     D*#_FLDD05*       S             17    DIM(300)                                           CTI006
     D*#_FLDD06*       S             17    DIM(300)                                           CTI006
     D*#_FLDD07*       S             17    DIM(300)                                           CTI006
     D*#_FLDD08*       S             17    DIM(300)                                           CTI006
     D*#_FLDD09*       S             17    DIM(300)                                           CTI006
     D*#_FLDD10*       S             17    DIM(300)                                           CTI006
     D*#_FLDD11*       S             17    DIM(300)                                           CTI006
     D*#_FLDD12*       S             17    DIM(300)                                           CTI006
     D*#_FLDD13*       S             17    DIM(300)                                           CTI006
     D*#_FLDD14*       S             17    DIM(300)                                           CTI006
     D*#_FLDD15*       S             17    DIM(300)                                           CTI006
     D*#_FLDD16*       S             17    DIM(300)                                           CTI006
     D*#_FLDD17*       S             17    DIM(300)                                           CTI006
     D*#_FLDD18*       S             17    DIM(300)                                           CTI006
     D*#_FLDD19*       S             17    DIM(300)                                           CTI006
     D*#_FLDD20*       S             17    DIM(300)                                           CTI006
     D #_FLDD01        S             17    DIM(400)                                           CTI006
     D #_FLDD02        S             17    DIM(400)                                           CTI006
     D #_FLDD03        S             17    DIM(400)                                           CTI006
     D #_FLDD04        S             17    DIM(400)                                           CTI006
     D #_FLDD05        S             17    DIM(400)                                           CTI006
     D #_FLDD06        S             17    DIM(400)                                           CTI006
     D #_FLDD07        S             17    DIM(400)                                           CTI006
     D #_FLDD08        S             17    DIM(400)                                           CTI006
     D #_FLDD09        S             17    DIM(400)                                           CTI006
     D #_FLDD10        S             17    DIM(400)                                           CTI006
     D #_FLDD11        S             17    DIM(400)                                           CTI006
     D #_FLDD12        S             17    DIM(400)                                           CTI006
     D #_FLDD13        S             17    DIM(400)                                           CTI006
     D #_FLDD14        S             17    DIM(400)                                           CTI006
     D #_FLDD15        S             17    DIM(400)                                           CTI006
     D #_FLDD16        S             17    DIM(400)                                           CTI006
     D #_FLDD17        S             17    DIM(400)                                           CTI006
     D #_FLDD18        S             17    DIM(400)                                           CTI006
     D #_FLDD19        S             17    DIM(400)                                           CTI006
     D #_FLDD20        S             17    DIM(400)                                           CTI006
      * FIELDS FOR SELECTION ARRAYS
     D #_FLDS01        S              5S 0 DIM(99)
     D #_FLDS02        S              5S 0 DIM(99)
     D #_FLDS03        S              5S 0 DIM(99)
     D #_FLDS04        S              5S 0 DIM(99)
     D #_FLDS05        S              5S 0 DIM(99)
     D #_FLDS06        S              5S 0 DIM(99)
     D #_FLDS07        S              5S 0 DIM(99)
     D #_FLDS08        S              5S 0 DIM(99)
     D #_FLDS09        S              5S 0 DIM(99)
     D #_FLDS10        S              5S 0 DIM(99)
     D #_FLDS11        S              5S 0 DIM(99)
     D #_FLDS12        S              5S 0 DIM(99)
     D #_FLDS13        S              5S 0 DIM(99)
     D #_FLDS14        S              5S 0 DIM(99)
     D #_FLDS15        S              5S 0 DIM(99)
     D #_FLDS16        S              5S 0 DIM(99)
     D #_FLDS17        S              5S 0 DIM(99)
     D #_FLDS18        S              5S 0 DIM(99)
     D #_FLDS19        S              5S 0 DIM(99)
     D #_FLDS20        S              5S 0 DIM(99)
      * SELECTION CRITERIA ARRAYS
     D #_SELC01        S             25    DIM(99)
     D #_SELC02        S             25    DIM(99)
     D #_SELC03        S             25    DIM(99)
     D #_SELC04        S             25    DIM(99)
     D #_SELC05        S             25    DIM(99)
     D #_SELC06        S             25    DIM(99)
     D #_SELC07        S             25    DIM(99)
     D #_SELC08        S             25    DIM(99)
     D #_SELC09        S             25    DIM(99)
     D #_SELC10        S             25    DIM(99)
     D #_SELC11        S             25    DIM(99)
     D #_SELC12        S             25    DIM(99)
     D #_SELC13        S             25    DIM(99)
     D #_SELC14        S             25    DIM(99)
     D #_SELC15        S             25    DIM(99)
     D #_SELC16        S             25    DIM(99)
     D #_SELC17        S             25    DIM(99)
     D #_SELC18        S             25    DIM(99)
     D #_SELC19        S             25    DIM(99)
     D #_SELC20        S             25    DIM(99)
 
 
      * Composite Message Formats
     D MXCOMF        E DS                  EXTNAME(MXCOMFPD)
 
 
      * Export Control Data
     D MXEXPCTL      E DS                  EXTNAME(MXEXPCTL)
 
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUT
      * Mode
      * Composite ID
      * Extract Type
      * Sequence in Message
      * Format
     C                   PARM                    I#MODE            1
     C                   PARM                    I#COMI            8
     C                   PARM                    I#EXTT            1
     C                   PARM                    I#SEQM            2
     C                   PARM                    I#FMT            10
      * Incoming Data
     C                   PARM                    InData
      * OUTPUT
      * Composite Message Format
     C                   PARM                    MXCOMF
      * Out Position
      * Outbound Data
     C                   PARM                    OutPos
     C                   PARM                    OutData
      * Reference ID
      * Select For Export
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * If a new composite message ID, load formats
 
     C     I#COMI        IFNE      W#COMI
     C     I#COMI        OREQ      '*NONE   '
     C     I#FMT         ANDNE     W#FMT
     C                   EXSR      LOAD_FMT
     C                   MOVEL     I#COMI        W#COMI            8
     C                   MOVEL     I#FMT         W#FMT            10
     C                   ENDIF
 
      * Recover Composite Message Format previously accessed
 
     C                   MOVEL     I#FMT         FMT_SEQM         11
     C                   MOVE      I#SEQM        FMT_SEQM         11
 
     C                   Z-ADD     1             @I                2 0
     C     FMT_SEQM      LOOKUP    #_FMTSEQM(@I)                          99    *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     #_COMF(@I)    MXCOMF
     C                   ELSE
     C                   EVAL      I#ERMS = 'INVALID FORMAT/SEQUENCE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If export required
      *   Re-format message data
 
     C     CFEXPT        IFEQ      'Y'
 
     C                   EXSR      REFMGDT
 
     C                   ENDIF
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      *   Re-format message data
      ********************************************************************
     C     REFMGDT       BEGSR
 
      * Get export format fields
 
     C     CFSEQM        CASEQ     '  '          REFMGDT01
     C     CFSEQM        CASEQ     '01'          REFMGDT01
     C     CFSEQM        CASEQ     '02'          REFMGDT02
     C     CFSEQM        CASEQ     '03'          REFMGDT03
     C     CFSEQM        CASEQ     '04'          REFMGDT04
     C     CFSEQM        CASEQ     '05'          REFMGDT05
     C     CFSEQM        CASEQ     '06'          REFMGDT06
     C     CFSEQM        CASEQ     '07'          REFMGDT07
     C     CFSEQM        CASEQ     '08'          REFMGDT08
     C     CFSEQM        CASEQ     '09'          REFMGDT09
     C     CFSEQM        CASEQ     '10'          REFMGDT10
     C     CFSEQM        CASEQ     '11'          REFMGDT11
     C     CFSEQM        CASEQ     '12'          REFMGDT12
     C     CFSEQM        CASEQ     '13'          REFMGDT13
     C     CFSEQM        CASEQ     '14'          REFMGDT14
     C     CFSEQM        CASEQ     '15'          REFMGDT15
     C     CFSEQM        CASEQ     '16'          REFMGDT16
     C     CFSEQM        CASEQ     '17'          REFMGDT17
     C     CFSEQM        CASEQ     '18'          REFMGDT18
     C     CFSEQM        CASEQ     '19'          REFMGDT19
     C     CFSEQM        CASEQ     '20'          REFMGDT20
     C                   END
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Load Formats
      ********************************************************************
     C     LOAD_FMT      BEGSR
 
      * Clear list of formats
 
     C                   MOVEL     *BLANK        #_FMTSEQM
     C                   MOVEL     *BLANK        #_COMF
 
      * If composite ID is '*NONE'
      * set up default composite format with sequence in message = '01'
 
     C     I#COMI        IFEQ      '*NONE'
     C                   CLEAR                   MXCOMF
     C                   MOVEL     I#COMI        CFCOMI
     C                   MOVEL     I#EXTT        CFEXTT
     C                   MOVEL     I#SEQM        CFSEQM
     C                   MOVEL     I#FMT         CFFMT
     C                   MOVEL     '01'          CFPRSQ
     C                   MOVEL     'N'           CFMULT
     C                   MOVEL     'Y'           CFEXPT
     C                   MOVEL     'L'           CFFILT
     C                   MOVEL     'N'           CFOPTF
     C                   MOVEL     I#FMT         #_FMTSEQM(1)
     C                   MOVE      I#SEQM        #_FMTSEQM(1)
     C                   MOVEL     MXCOMF        #_COMF(1)
     C                   EXSR      GETEXFF01
     C                   ELSE
 
      * Get Composite Message Formats
 
     C                   Z-ADD     1             @I                2 0
     C     MXCOMFK       SETLL     MXCOMFP0                                     *
     C     MXCOMFK       READE     MXCOMFP0                               99    *
     C     *IN99         DOWEQ     '0'
 
      * If mode is 'DRIP-FEED'
      * Put all data to the 'LONG' file
 
     C     I#MODE        IFEQ      'D'
     C                   MOVEL     'L'           CFFILT
     C                   MOVEL     'N'           CFOPTF
     C                   ENDIF
 
     C                   MOVEL     CFFMT         #_FMTSEQM(@I)
     C                   MOVE      CFSEQM        #_FMTSEQM(@I)
     C                   MOVEL     MXCOMF        #_COMF(@I)
     C                   ADD       1             @I
 
      * Get export format fields
 
     C     CFSEQM        CASEQ     '01'          GETEXFF01
     C     CFSEQM        CASEQ     '02'          GETEXFF02
     C     CFSEQM        CASEQ     '03'          GETEXFF03
     C     CFSEQM        CASEQ     '04'          GETEXFF04
     C     CFSEQM        CASEQ     '05'          GETEXFF05
     C     CFSEQM        CASEQ     '06'          GETEXFF06
     C     CFSEQM        CASEQ     '07'          GETEXFF07
     C     CFSEQM        CASEQ     '08'          GETEXFF08
     C     CFSEQM        CASEQ     '09'          GETEXFF09
     C     CFSEQM        CASEQ     '10'          GETEXFF10
     C     CFSEQM        CASEQ     '11'          GETEXFF11
     C     CFSEQM        CASEQ     '12'          GETEXFF12
     C     CFSEQM        CASEQ     '13'          GETEXFF13
     C     CFSEQM        CASEQ     '14'          GETEXFF14
     C     CFSEQM        CASEQ     '15'          GETEXFF15
     C     CFSEQM        CASEQ     '16'          GETEXFF16
     C     CFSEQM        CASEQ     '17'          GETEXFF17
     C     CFSEQM        CASEQ     '18'          GETEXFF18
     C     CFSEQM        CASEQ     '19'          GETEXFF19
     C     CFSEQM        CASEQ     '20'          GETEXFF20
     C                   END
 
     C     MXCOMFK       READE     MXCOMFP0                               99    *
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Get export format fields - Sequence Number in Message 01
      ********************************************************************
     C     GETEXFF01     BEGSR
 
     C                   CALLB     'MXGETEXFF'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
      * Format
     C                   PARM                    CFFMT
      * Export Control Data
     C                   PARM                    MXEXPCTL
      * OUTPUT
      * Field Data
     C                   PARM                    #_FLDD01
      * Fields For Selection
     C                   PARM                    #_FLDS01
      * Selection Criteria
     C                   PARM                    #_SELC01
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXGETEXFF -01'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Get export format fields - Sequence Number in Message 02
      ********************************************************************
     C     GETEXFF02     BEGSR
 
     C                   CALLB     'MXGETEXFF'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
      * Format
     C                   PARM                    CFFMT
      * Export Control Data
     C                   PARM                    MXEXPCTL
      * OUTPUT
      * Field Data
     C                   PARM                    #_FLDD02
      * Fields For Selection
     C                   PARM                    #_FLDS02
      * Selection Criteria
     C                   PARM                    #_SELC02
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXGETEXFF -02'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Get export format fields - Sequence Number in Message 03
      ********************************************************************
     C     GETEXFF03     BEGSR
 
     C                   CALLB     'MXGETEXFF'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
      * Format
     C                   PARM                    CFFMT
      * Export Control Data
     C                   PARM                    MXEXPCTL
      * OUTPUT
      * Field Data
     C                   PARM                    #_FLDD03
      * Fields For Selection
     C                   PARM                    #_FLDS03
      * Selection Criteria
     C                   PARM                    #_SELC03
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXGETEXFF -03'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Get export format fields - Sequence Number in Message 04
      ********************************************************************
     C     GETEXFF04     BEGSR
 
     C                   CALLB     'MXGETEXFF'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
      * Format
     C                   PARM                    CFFMT
      * Export Control Data
     C                   PARM                    MXEXPCTL
      * OUTPUT
      * Field Data
     C                   PARM                    #_FLDD04
      * Fields For Selection
     C                   PARM                    #_FLDS04
      * Selection Criteria
     C                   PARM                    #_SELC04
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXGETEXFF -04'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Get export format fields - Sequence Number in Message 05
      ********************************************************************
     C     GETEXFF05     BEGSR
 
     C                   CALLB     'MXGETEXFF'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
      * Format
     C                   PARM                    CFFMT
      * Export Control Data
     C                   PARM                    MXEXPCTL
      * OUTPUT
      * Field Data
     C                   PARM                    #_FLDD05
      * Fields For Selection
     C                   PARM                    #_FLDS05
      * Selection Criteria
     C                   PARM                    #_SELC05
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXGETEXFF -05'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Get export format fields - Sequence Number in Message 06
      ********************************************************************
     C     GETEXFF06     BEGSR
 
     C                   CALLB     'MXGETEXFF'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
      * Format
     C                   PARM                    CFFMT
      * Export Control Data
     C                   PARM                    MXEXPCTL
      * OUTPUT
      * Field Data
     C                   PARM                    #_FLDD06
      * Fields For Selection
     C                   PARM                    #_FLDS06
      * Selection Criteria
     C                   PARM                    #_SELC06
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXGETEXFF -06'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Get export format fields - Sequence Number in Message 07
      ********************************************************************
     C     GETEXFF07     BEGSR
 
     C                   CALLB     'MXGETEXFF'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
      * Format
     C                   PARM                    CFFMT
      * Export Control Data
     C                   PARM                    MXEXPCTL
      * OUTPUT
      * Field Data
     C                   PARM                    #_FLDD07
      * Fields For Selection
     C                   PARM                    #_FLDS07
      * Selection Criteria
     C                   PARM                    #_SELC07
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXGETEXFF -07'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Get export format fields - Sequence Number in Message 08
      ********************************************************************
     C     GETEXFF08     BEGSR
 
     C                   CALLB     'MXGETEXFF'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
      * Format
     C                   PARM                    CFFMT
      * Export Control Data
     C                   PARM                    MXEXPCTL
      * OUTPUT
      * Field Data
     C                   PARM                    #_FLDD08
      * Fields For Selection
     C                   PARM                    #_FLDS08
      * Selection Criteria
     C                   PARM                    #_SELC08
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXGETEXFF -08'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Get export format fields - Sequence Number in Message 09
      ********************************************************************
     C     GETEXFF09     BEGSR
 
     C                   CALLB     'MXGETEXFF'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
      * Format
     C                   PARM                    CFFMT
      * Export Control Data
     C                   PARM                    MXEXPCTL
      * OUTPUT
      * Field Data
     C                   PARM                    #_FLDD09
      * Fields For Selection
     C                   PARM                    #_FLDS09
      * Selection Criteria
     C                   PARM                    #_SELC09
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXGETEXFF -09'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Get export format fields - Sequence Number in Message 10
      ********************************************************************
     C     GETEXFF10     BEGSR
 
     C                   CALLB     'MXGETEXFF'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
      * Format
     C                   PARM                    CFFMT
      * Export Control Data
     C                   PARM                    MXEXPCTL
      * OUTPUT
      * Field Data
     C                   PARM                    #_FLDD10
      * Fields For Selection
     C                   PARM                    #_FLDS10
      * Selection Criteria
     C                   PARM                    #_SELC10
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXGETEXFF -10'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Get export format fields - Sequence Number in Message 11
      ********************************************************************
     C     GETEXFF11     BEGSR
 
     C                   CALLB     'MXGETEXFF'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
      * Format
     C                   PARM                    CFFMT
      * Export Control Data
     C                   PARM                    MXEXPCTL
      * OUTPUT
      * Field Data
     C                   PARM                    #_FLDD11
      * Fields For Selection
     C                   PARM                    #_FLDS11
      * Selection Criteria
     C                   PARM                    #_SELC11
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXGETEXFF -11'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Get export format fields - Sequence Number in Message 12
      ********************************************************************
     C     GETEXFF12     BEGSR
 
     C                   CALLB     'MXGETEXFF'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
      * Format
     C                   PARM                    CFFMT
      * Export Control Data
     C                   PARM                    MXEXPCTL
      * OUTPUT
      * Field Data
     C                   PARM                    #_FLDD12
      * Fields For Selection
     C                   PARM                    #_FLDS12
      * Selection Criteria
     C                   PARM                    #_SELC12
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXGETEXFF -12'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Get export format fields - Sequence Number in Message 13
      ********************************************************************
     C     GETEXFF13     BEGSR
 
     C                   CALLB     'MXGETEXFF'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
      * Format
     C                   PARM                    CFFMT
      * Export Control Data
     C                   PARM                    MXEXPCTL
      * OUTPUT
      * Field Data
     C                   PARM                    #_FLDD13
      * Fields For Selection
     C                   PARM                    #_FLDS13
      * Selection Criteria
     C                   PARM                    #_SELC13
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXGETEXFF -13'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Get export format fields - Sequence Number in Message 14
      ********************************************************************
     C     GETEXFF14     BEGSR
 
     C                   CALLB     'MXGETEXFF'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
      * Format
     C                   PARM                    CFFMT
      * Export Control Data
     C                   PARM                    MXEXPCTL
      * OUTPUT
      * Field Data
     C                   PARM                    #_FLDD14
      * Fields For Selection
     C                   PARM                    #_FLDS14
      * Selection Criteria
     C                   PARM                    #_SELC14
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXGETEXFF -14'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Get export format fields - Sequence Number in Message 15
      ********************************************************************
     C     GETEXFF15     BEGSR
 
     C                   CALLB     'MXGETEXFF'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
      * Format
     C                   PARM                    CFFMT
      * Export Control Data
     C                   PARM                    MXEXPCTL
      * OUTPUT
      * Field Data
     C                   PARM                    #_FLDD15
      * Fields For Selection
     C                   PARM                    #_FLDS15
      * Selection Criteria
     C                   PARM                    #_SELC15
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXGETEXFF -15'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Get export format fields - Sequence Number in Message 16
      ********************************************************************
     C     GETEXFF16     BEGSR
 
     C                   CALLB     'MXGETEXFF'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
      * Format
     C                   PARM                    CFFMT
      * Export Control Data
     C                   PARM                    MXEXPCTL
      * OUTPUT
      * Field Data
     C                   PARM                    #_FLDD16
      * Fields For Selection
     C                   PARM                    #_FLDS16
      * Selection Criteria
     C                   PARM                    #_SELC16
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXGETEXFF -16'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Get export format fields - Sequence Number in Message 17
      ********************************************************************
     C     GETEXFF17     BEGSR
 
     C                   CALLB     'MXGETEXFF'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
      * Format
     C                   PARM                    CFFMT
      * Export Control Data
     C                   PARM                    MXEXPCTL
      * OUTPUT
      * Field Data
     C                   PARM                    #_FLDD17
      * Fields For Selection
     C                   PARM                    #_FLDS17
      * Selection Criteria
     C                   PARM                    #_SELC17
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXGETEXFF -17'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Get export format fields - Sequence Number in Message 18
      ********************************************************************
     C     GETEXFF18     BEGSR
 
     C                   CALLB     'MXGETEXFF'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
      * Format
     C                   PARM                    CFFMT
      * Export Control Data
     C                   PARM                    MXEXPCTL
      * OUTPUT
      * Field Data
     C                   PARM                    #_FLDD18
      * Fields For Selection
     C                   PARM                    #_FLDS18
      * Selection Criteria
     C                   PARM                    #_SELC18
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXGETEXFF -18'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Get export format fields - Sequence Number in Message 19
      ********************************************************************
     C     GETEXFF19     BEGSR
 
     C                   CALLB     'MXGETEXFF'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
      * Format
     C                   PARM                    CFFMT
      * Export Control Data
     C                   PARM                    MXEXPCTL
      * OUTPUT
      * Field Data
     C                   PARM                    #_FLDD19
      * Fields For Selection
     C                   PARM                    #_FLDS19
      * Selection Criteria
     C                   PARM                    #_SELC19
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXGETEXFF -19'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Get export format fields - Sequence Number in Message 20
      ********************************************************************
     C     GETEXFF20     BEGSR
 
     C                   CALLB     'MXGETEXFF'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
      * Format
     C                   PARM                    CFFMT
      * Export Control Data
     C                   PARM                    MXEXPCTL
      * OUTPUT
      * Field Data
     C                   PARM                    #_FLDD20
      * Fields For Selection
     C                   PARM                    #_FLDS20
      * Selection Criteria
     C                   PARM                    #_SELC20
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXGETEXFF -20'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Re-format message data - Sequence Number in Message 01
      ********************************************************************
     C     REFMGDT01     BEGSR
 
     C                   CALLB     'MXREFMGDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUTS
     C                   PARM                    InData
     C                   PARM                    #_FLDD01
     C                   PARM                    #_FLDS01
     C                   PARM                    #_SELC01
      * OUTPUTS
     C                   PARM                    OutPos
     C                   PARM                    OutData
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXREFMGDT -01'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Re-format message data - Sequence Number in Message 02
      ********************************************************************
     C     REFMGDT02     BEGSR
 
     C                   CALLB     'MXREFMGDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUTS
     C                   PARM                    InData
     C                   PARM                    #_FLDD02
     C                   PARM                    #_FLDS02
     C                   PARM                    #_SELC02
      * OUTPUTS
     C                   PARM                    OutPos
     C                   PARM                    OutData
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXREFMGDT -02'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Re-format message data - Sequence Number in Message 03
      ********************************************************************
     C     REFMGDT03     BEGSR
 
     C                   CALLB     'MXREFMGDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUTS
     C                   PARM                    InData
     C                   PARM                    #_FLDD03
     C                   PARM                    #_FLDS03
     C                   PARM                    #_SELC03
      * OUTPUTS
     C                   PARM                    OutPos
     C                   PARM                    OutData
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXREFMGDT -03'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Re-format message data - Sequence Number in Message 04
      ********************************************************************
     C     REFMGDT04     BEGSR
 
     C                   CALLB     'MXREFMGDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUTS
     C                   PARM                    InData
     C                   PARM                    #_FLDD04
     C                   PARM                    #_FLDS04
     C                   PARM                    #_SELC04
      * OUTPUTS
     C                   PARM                    OutPos
     C                   PARM                    OutData
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXREFMGDT -04'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Re-format message data - Sequence Number in Message 05
      ********************************************************************
     C     REFMGDT05     BEGSR
 
     C                   CALLB     'MXREFMGDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUTS
     C                   PARM                    InData
     C                   PARM                    #_FLDD05
     C                   PARM                    #_FLDS05
     C                   PARM                    #_SELC05
      * OUTPUTS
     C                   PARM                    OutPos
     C                   PARM                    OutData
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXREFMGDT -05'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Re-format message data - Sequence Number in Message 06
      ********************************************************************
     C     REFMGDT06     BEGSR
 
     C                   CALLB     'MXREFMGDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUTS
     C                   PARM                    InData
     C                   PARM                    #_FLDD06
     C                   PARM                    #_FLDS06
     C                   PARM                    #_SELC06
      * OUTPUTS
     C                   PARM                    OutPos
     C                   PARM                    OutData
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXREFMGDT -06'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Re-format message data - Sequence Number in Message 07
      ********************************************************************
     C     REFMGDT07     BEGSR
 
     C                   CALLB     'MXREFMGDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUTS
     C                   PARM                    InData
     C                   PARM                    #_FLDD07
     C                   PARM                    #_FLDS07
     C                   PARM                    #_SELC07
      * OUTPUTS
     C                   PARM                    OutPos
     C                   PARM                    OutData
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXREFMGDT -07'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Re-format message data - Sequence Number in Message 08
      ********************************************************************
     C     REFMGDT08     BEGSR
 
     C                   CALLB     'MXREFMGDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUTS
     C                   PARM                    InData
     C                   PARM                    #_FLDD08
     C                   PARM                    #_FLDS08
     C                   PARM                    #_SELC08
      * OUTPUTS
     C                   PARM                    OutPos
     C                   PARM                    OutData
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXREFMGDT -08'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Re-format message data - Sequence Number in Message 09
      ********************************************************************
     C     REFMGDT09     BEGSR
 
     C                   CALLB     'MXREFMGDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUTS
     C                   PARM                    InData
     C                   PARM                    #_FLDD09
     C                   PARM                    #_FLDS09
     C                   PARM                    #_SELC09
      * OUTPUTS
     C                   PARM                    OutPos
     C                   PARM                    OutData
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXREFMGDT -09'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Re-format message data - Sequence Number in Message 10
      ********************************************************************
     C     REFMGDT10     BEGSR
 
     C                   CALLB     'MXREFMGDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUTS
     C                   PARM                    InData
     C                   PARM                    #_FLDD10
     C                   PARM                    #_FLDS10
     C                   PARM                    #_SELC10
      * OUTPUTS
     C                   PARM                    OutPos
     C                   PARM                    OutData
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXREFMGDT -10'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Re-format message data - Sequence Number in Message 11
      ********************************************************************
     C     REFMGDT11     BEGSR
 
     C                   CALLB     'MXREFMGDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUTS
     C                   PARM                    InData
     C                   PARM                    #_FLDD11
     C                   PARM                    #_FLDS11
     C                   PARM                    #_SELC11
      * OUTPUTS
     C                   PARM                    OutPos
     C                   PARM                    OutData
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXREFMGDT -11'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Re-format message data - Sequence Number in Message 12
      ********************************************************************
     C     REFMGDT12     BEGSR
 
     C                   CALLB     'MXREFMGDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUTS
     C                   PARM                    InData
     C                   PARM                    #_FLDD12
     C                   PARM                    #_FLDS12
     C                   PARM                    #_SELC12
      * OUTPUTS
     C                   PARM                    OutPos
     C                   PARM                    OutData
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXREFMGDT -12'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Re-format message data - Sequence Number in Message 13
      ********************************************************************
     C     REFMGDT13     BEGSR
 
     C                   CALLB     'MXREFMGDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUTS
     C                   PARM                    InData
     C                   PARM                    #_FLDD13
     C                   PARM                    #_FLDS13
     C                   PARM                    #_SELC13
      * OUTPUTS
     C                   PARM                    OutPos
     C                   PARM                    OutData
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXREFMGDT -13'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Re-format message data - Sequence Number in Message 14
      ********************************************************************
     C     REFMGDT14     BEGSR
 
     C                   CALLB     'MXREFMGDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUTS
     C                   PARM                    InData
     C                   PARM                    #_FLDD14
     C                   PARM                    #_FLDS14
     C                   PARM                    #_SELC14
      * OUTPUTS
     C                   PARM                    OutPos
     C                   PARM                    OutData
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXREFMGDT -14'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Re-format message data - Sequence Number in Message 15
      ********************************************************************
     C     REFMGDT15     BEGSR
 
     C                   CALLB     'MXREFMGDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUTS
     C                   PARM                    InData
     C                   PARM                    #_FLDD15
     C                   PARM                    #_FLDS15
     C                   PARM                    #_SELC15
      * OUTPUTS
     C                   PARM                    OutPos
     C                   PARM                    OutData
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXREFMGDT -15'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Re-format message data - Sequence Number in Message 16
      ********************************************************************
     C     REFMGDT16     BEGSR
 
     C                   CALLB     'MXREFMGDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUTS
     C                   PARM                    InData
     C                   PARM                    #_FLDD16
     C                   PARM                    #_FLDS16
     C                   PARM                    #_SELC16
      * OUTPUTS
     C                   PARM                    OutPos
     C                   PARM                    OutData
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXREFMGDT -16'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Re-format message data - Sequence Number in Message 17
      ********************************************************************
     C     REFMGDT17     BEGSR
 
     C                   CALLB     'MXREFMGDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUTS
     C                   PARM                    InData
     C                   PARM                    #_FLDD17
     C                   PARM                    #_FLDS17
     C                   PARM                    #_SELC17
      * OUTPUTS
     C                   PARM                    OutPos
     C                   PARM                    OutData
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXREFMGDT -17'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Re-format message data - Sequence Number in Message 18
      ********************************************************************
     C     REFMGDT18     BEGSR
 
     C                   CALLB     'MXREFMGDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUTS
     C                   PARM                    InData
     C                   PARM                    #_FLDD18
     C                   PARM                    #_FLDS18
     C                   PARM                    #_SELC18
      * OUTPUTS
     C                   PARM                    OutPos
     C                   PARM                    OutData
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXREFMGDT -18'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Re-format message data - Sequence Number in Message 19
      ********************************************************************
     C     REFMGDT19     BEGSR
 
     C                   CALLB     'MXREFMGDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUTS
     C                   PARM                    InData
     C                   PARM                    #_FLDD19
     C                   PARM                    #_FLDS19
     C                   PARM                    #_SELC19
      * OUTPUTS
     C                   PARM                    OutPos
     C                   PARM                    OutData
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXREFMGDT -19'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Re-format message data - Sequence Number in Message 20
      ********************************************************************
     C     REFMGDT20     BEGSR
 
     C                   CALLB     'MXREFMGDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUTS
     C                   PARM                    InData
     C                   PARM                    #_FLDD20
     C                   PARM                    #_FLDS20
     C                   PARM                    #_SELC20
      * OUTPUTS
     C                   PARM                    OutPos
     C                   PARM                    OutData
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXREFMGDT -20'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Get extract control data
 
     C     *DTAARA       DEFINE                  MXEXPCTL
     C                   IN        MXEXPCTL
 
      * Key Lists
 
     C     MXCOMFK       KLIST
     C                   KFLD                    I#COMI
     C                   KFLD                    I#EXTT
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
