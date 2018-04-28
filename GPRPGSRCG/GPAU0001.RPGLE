     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Audit File Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAU0001 - Audit File Maintenance                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     FGPAU0001DFCF   E             WORKSTN
     F                                     SFILE(SUBFLRE2:RRN2)
 
     D PCP             S             10    DIM(7) CTDATA PERRCD(1)
     D PNP             S             50    DIM(7) CTDATA PERRCD(1)
     D PAC             S              1    DIM(7) CTDATA PERRCD(1)
     D CLR             S              1    DIM(39) CTDATA PERRCD(39)
     D ERR             S             76    DIM(1) CTDATA PERRCD(1)
 
     D PSDS           SDS
     D  ERROR            *STATUS
     D  WKSID                244    253
     D  USRID                254    263
 
     C  N10              EXSR      INIT
 
     C* LOOP UNLESS EXIT OR ADVANCE
 
     C                   MOVEL     'ABAND '      RETC
     C     RETC          DOWEQ     'ABAND'
 
     C* CLEAR FILES
 
     C                   EXSR      CLEAR
 
     C* FILE DEFINITION
 
     C                   EXSR      FILE_DEF
     C                   END
 
     C* FILL SUBFILE WITH OPTIONS
 
     C                   EXSR      FILSB2
 
     C* DISPLAY AND PROCESS OPTIONS
 
     C                   MOVE      '0'           *INKF
     C                   MOVE      '0'           *INKL
     C     *INKF         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
     C                   EXSR      DSPLAY
     C                   END
 
      *****************************************************************
      * Display
      *****************************************************************
     C     DSPLAY        BEGSR
 
     C                   WRITE     SUBFLCT2
     C                   WRITE     SUBMESS
     C                   READ      SUBFLCT2                               99    *
     C                   MOVEL     *BLANK        DDERR
 
     C* IF CK/3 TAKEN, END PROGRAM
 
     C     *INKC         IFEQ      '1'
     C                   EXSR      EXIT
 
     C* IF CK/12 TAKEN, LOOP AROUND USING RPG CYCLE
 
     C                   ELSE
     C     *INKL         IFEQ      '1'
     C                   EXSR      ABAND
 
     C* IF CK/6 TAKEN, UPDATE FILES (AS LONG AS 1ST OPTION COMPLETE)
 
     C                   ELSE
     C     *INKF         IFEQ      '1'
     C     1             CHAIN     SUBFLRE2                           99
     C     SSACTN        IFEQ      *BLANK
     C                   CALL      'GPAU0007'                           9999    *
     C                   PARM                    AFFILE
     C                   PARM                    AFRCID
     C                   EXSR      CHKERR
     C                   ELSE
     C                   MOVE      '0'           *INKF
     C                   MOVEA     ERR(1)        DDERR
     C                   END
 
     C* ELSE IF ENTER PRESSED, CHECK SELECTION
 
     C                   ELSE
     C                   Z-ADD     1             RRN2
     C     RRN2          CHAIN     SUBFLRE2                           99
     C     *IN99         DOWEQ     '0'
 
     C* IF ACTION DEFINED
 
     C     SSACTN        IFNE      *BLANK
     C                   EXSR      VALSUB
     C                   END
     C                   ADD       1             RRN2
     C     RRN2          CHAIN     SUBFLRE2                           99
     C                   END
     C                   END
     C                   END
     C                   END
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate subfile
      ********************************************************************
     C     VALSUB        BEGSR
 
     C* CALL RELEVANT PROGRAM
 
     C                   CALL      SSPGM                                9999    *
     C                   PARM      *BLANK        RETC
     C                   PARM                    AFFILE
     C                   PARM                    AFRCID
     C                   PARM                    AFDESC
     C                   EXSR      CHKERR
 
     C* IF CK/3 TAKEN AT A LOWER LEVEL, THEN EXIT
 
     C     RETC          IFEQ      'EXIT'
     C                   EXSR      EXIT
     C                   END
 
     C* BLANK ACTION AND FORBID INPUT ON OPTION 1 IF NOT ABANDONED
 
     C     RRN2          IFEQ      1
     C     RETC          ANDNE     'ABAND '
     C                   MOVEL     *BLANK        SSACTN
     C                   MOVE      '1'           *IN15
     C                   ELSE
 
     C* FORBID INPUT ON OPTION 1 IF ABANDONED (IE LEAVE 'X')
 
     C     RRN2          IFEQ      1
     C     RETC          ANDEQ     'ABAND '
     C                   MOVE      '1'           *IN15
     C                   ELSE
 
     C* ELSE BLANK ACTION AND ENABLE INPUT
 
     C                   MOVEL     *BLANK        SSACTN
     C                   MOVE      '0'           *IN15
     C                   END
     C                   END
 
     C* IF CK/12 TAKEN AT A LOWER LEVEL, THEN ABANDON
 
     C     RETC          IFEQ      'ABAND '
     C                   Z-ADD     9998          RRN2
     C                   END
 
     C* UPDATE SUBFILE
 
     C                   UPDATE    SUBFLRE2
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Fill subfile
      ********************************************************************
     C     FILSB2        BEGSR
     C                   MOVEA     '000'         *IN(11)
     C                   MOVEA     '1'           *IN(14)
     C                   Z-ADD     *ZERO         RRN2
     C                   WRITE     SUBFLCT2                                     *
     C     RRN2          DOUEQ     7
     C                   ADD       1             RRN2              4 0    14    *
 
     C                   MOVEL     PCP(RRN2)     SSPGM
     C                   MOVEL     PNP(RRN2)     SSNAR
 
     C     COPY          IFNE      'Y'
     C                   MOVEL     PAC(RRN2)     SSACTN
     C                   ELSE
     C                   MOVEL     *BLANK        SSACTN
     C                   END
 
     C     SSPGM         IFEQ      *BLANK
     C     SSACTN        ORNE      *BLANK
     C     RRN2          OREQ      1
     C                   MOVE      '1'           *IN15
     C                   ELSE
     C                   MOVE      '0'           *IN15
     C                   END
     C                   WRITE     SUBFLRE2
     C                   END
 
     C     *IN(14)       IFEQ      '1'
     C                   MOVEA     '010'         *IN(11)
     C                   ELSE
     C                   MOVEA     '111'         *IN(11)
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Clear files
      ********************************************************************
     C     CLEAR         BEGSR
     C* GPAUFLPD
     C                   Z-ADD     39            MESLEN           15 5
     C                   MOVEA     'GPAUFLPD'    CLR(13)
     C                   MOVEA     USRID         CLR(29)
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    CLR
     C                   PARM                    MESLEN
     C* GPAUFDPD
     C                   MOVEA     'GPAUFDPD'    CLR(13)
     C                   MOVEA     USRID         CLR(29)
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    CLR
     C                   PARM                    MESLEN
     C* GPAURNPD
     C                   MOVEA     'GPAURNPD'    CLR(13)
     C                   MOVEA     USRID         CLR(29)
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    CLR
     C                   PARM                    MESLEN
     C* GPAUASPD
     C                   MOVEA     'GPAUASPD'    CLR(13)
     C                   MOVEA     USRID         CLR(29)
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    CLR
     C                   PARM                    MESLEN
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * File definition
      ********************************************************************
     C     FILE_DEF      BEGSR
 
     C* CREATE
 
     C     MODE          IFEQ      'C'
     C                   CALL      'GPAU0002'                           9999    *
     C                   PARM      *BLANK        RETC              6
     C                   PARM      *BLANK        AFFILE           10
     C                   PARM      *BLANK        AFRCID           15
     C                   PARM      *BLANK        AFDESC           40
     C                   PARM      *BLANK        COPY              1
     C                   EXSR      CHKERR
     C                   ELSE
 
     C* AMEND
 
     C     MODE          IFEQ      'A'
     C                   CALL      'GPAU0003'                           9999    *
     C                   PARM      *BLANK        RETC              6
     C                   PARM      *BLANK        AFFILE           10
     C                   PARM      *BLANK        AFRCID           15
     C                   PARM      *BLANK        AFDESC           40
     C                   EXSR      CHKERR
     C                   MOVEL     'Y'           COPY
     C                   ELSE
 
     C* DELETE
 
     C     MODE          IFEQ      'D'
     C                   CALL      'GPAU0004'                           9999    *
     C                   PARM      *BLANK        RETC              6
     C                   PARM      *BLANK        AFFILE           10
     C                   PARM      *BLANK        AFRCID           15
     C                   PARM      *BLANK        AFDESC           40
     C                   EXSR      CHKERR
     C                   ELSE
     C                   SETON                                        LR
     C                   RETURN
     C                   END
     C                   END
     C                   END
 
     C* CHECK FOR EXIT
 
     C     RETC          IFEQ      'EXIT  '
     C                   SETON                                        LR
     C                   RETURN
     C                   END
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Exit
      ********************************************************************
     C     EXIT          BEGSR
     C                   MOVEL     'YES'         ANSWER
     C                   WRITE     CLEARSCR
     C                   EXFMT     EXITREQ
     C     ANSWER        IFEQ      'YES'
     C                   SETON                                        LR
     C                   RETURN
     C                   END
     C                   MOVEL     'ABAND '      RETC
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Abandon
      ********************************************************************
     C     ABAND         BEGSR
     C                   MOVEL     'YES'         ANSWER
     C                   WRITE     CLEARSCR
     C                   EXFMT     EXITREQ
     C     ANSWER        IFEQ      'YES'
     C                   MOVE      '1'           *INKL
     C                   END
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Initial processing
      ********************************************************************
     C     INIT          BEGSR
 
     C*  PARAMETERS PASSED (MODE EQUAL TO 'C' 'A' OR 'D')
 
     C     *ENTRY        PLIST
     C                   PARM                    MODE              1
 
     C                   MOVE      '1'           *IN10
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Check for error
      ********************************************************************
     C     CHKERR        BEGSR
 
     C* ERROR ON CALL OF PROGRAM
 
     C     *IN99         IFEQ      '1'
     C     ERROR         ANDNE     1
     C                   EXSR      *PSSR
     C                   END
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * *PSSR processing
      ********************************************************************
     C     *PSSR         BEGSR
     C                   DUMP
     C                   MOVEL     '*CANCL'      RETURN            6
     C                   ENDSR     RETURN
      **********************************************************************
** PCP
 
GPAU0009
GPAU0010
GPAU0011
GPAU0012
GPAU0013
GPAU0015
** PNP
 
Work Field Selection
Report Field Selection
Report Field Maintenance
Layout Generation
Layout Maintenance
Action Selection
** PAC
 
X
 
 
 
 
 
** CLR (39)
CLRPFM FILE(          ) MBR(          )
** ERR
Updates cannot be done until Work Field Retrieval has been done
