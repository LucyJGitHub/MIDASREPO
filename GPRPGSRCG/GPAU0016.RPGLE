     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Action Selection - 2')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAU0016 - Action Selection - 2                              *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     FGPAU0016DFCF   E             WORKSTN
     F                                     SFILE(SUBFLRE1:RRN1)
     F                                     SFILE(SUBFLRE2:RRN2)
     FGPAUFDL6  IF   E           K DISK    INFSR(*PSSR)
     FGPAUFDL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GPAUFDD0:GPAUFDDX)
     FGPAUASL1  UF A E           K DISK    INFSR(*PSSR)
 
     D ERR             S             76    DIM(9) CTDATA PERRCD(1)
 
     D                 DS
     D  F_DATA                 1     46
     D  AFSIAO                 1      3
     D  AFBFAF                 4      4
     D  AFSFLD                 5     14
     D  AFSCMP                15     16
     D  AFSCPV                17     46
 
     D                 DS
     D  S_DATA                 1     46
     D  SSSIAO                 1      3
     D  SSBFAF                 4      4
     D  SSSFLD                 5     14
     D  SSSCMP                15     16
     D  SSSCPV                17     46
 
     D PSDS           SDS
     D  ERROR            *STATUS
     D  WKSID                244    253
     D  USRID                254    263
 
     C                   EXSR      INIT
     C                   EXSR      FILSB1
     C                   EXSR      FILSB2
     C                   MOVE      '1'           *IN10
 
     C                   Z-ADD     99            ER                2 0
     C     ER            DOWNE     *ZERO
     C                   EXSR      DSPLAY
     C                   END
 
     C                   SETON                                        LR
 
      /SPACE 5
      *****************************************************************
      * Display screen
      *****************************************************************
     C     DSPLAY        BEGSR
 
     C                   WRITE     SUBFLCT1
     C                   WRITE     SUBFLCT2
     C                   WRITE     SUBMESS
     C                   READ      SUBFLCT1                               99    *
     C                   MOVEL     *BLANK        DDERR
     C* CK/3
     C     *INKC         IFEQ      '1'
     C                   MOVEL     'EXIT  '      RETC
     C                   Z-ADD     *ZERO         ER
     C                   ELSE
     C* CK/12
     C     *INKL         IFEQ      '1'
     C                   MOVEL     'ABAND '      RETC
     C                   Z-ADD     *ZERO         ER
     C                   ELSE
     C* ROLLUP
     C     *IN05         IFEQ      '1'
     C                   EXSR      FILSB1
     C                   Z-ADD     99            ER
     C                   ELSE
     C* VALIDATE SUBFILE
     C                   Z-ADD     *ZERO         PRRN1
     C                   Z-ADD     1             RRN1
     C                   Z-ADD     *ZERO         SFRR              3 0
     C     RRN1          CHAIN     SUBFLRE1                           99
     C     *IN99         DOWEQ     '0'
     C                   EXSR      VALSUB
     C                   ADD       1             RRN1
     C     RRN1          CHAIN     SUBFLRE1                           99
     C                   END
     C* CK/6 TO UPDATE
     C     *INKF         IFEQ      '1'
     C     PRRN1         ANDEQ     *ZERO
     C                   EXSR      UPDDET
     C                   ELSE
     C     PRRN1         IFEQ      *ZERO
     C                   Z-ADD     1             PRRN1
     C                   END
     C                   Z-ADD     99            ER
     C                   END
     C                   END
     C                   END
     C                   END
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Validate subfile
      *****************************************************************
     C     VALSUB        BEGSR
 
     C                   Z-ADD     0             ER
     C                   MOVEA     '00000'       *IN(41)
 
     C* IF DATA DEFINED
 
     C     S_DATA        IFNE      *BLANK
 
     C* INCREMENT SUBFILE RECORDS READ
 
     C                   ADD       1             SFRR
 
     C* SPECIAL VALIDATION FOR FIRST SUBFILE RECORD READ
 
     C     SFRR          IFEQ      1
     C     SSSIAO        IFEQ      *BLANK
     C                   MOVEL     'IF '         SSSIAO
     C                   END
     C     SSSIAO        IFNE      'IF '
     C     ER            IFEQ      0
     C                   Z-ADD     1             ER
     C                   END
     C                   MOVE      '1'           *IN41
     C                   END
     C                   ELSE
     C     SSSIAO        IFEQ      'IF '
     C     ER            IFEQ      0
     C                   Z-ADD     2             ER
     C                   END
     C                   MOVE      '1'           *IN41
     C                   END
     C                   END
 
     C* CHECK IF/AND/OR
 
     C     SSSIAO        IFNE      'IF '
     C     SSSIAO        ANDNE     'AND'
     C     SSSIAO        ANDNE     'OR '
     C     ER            IFEQ      0
     C                   Z-ADD     3             ER
     C                   END
     C                   MOVE      '1'           *IN41
     C                   END
 
     C* CHECK BEFORE/AFTER
 
     C     SSBFAF        IFEQ      *BLANK
     C                   MOVEL     'A'           SSBFAF
     C                   END
     C     SSBFAF        IFNE      'B'
     C     SSBFAF        ANDNE     'A'
     C     ER            IFEQ      0
     C                   Z-ADD     4             ER
     C                   END
     C                   MOVE      '1'           *IN42
     C                   END
 
     C* CHECK FIELD IS ENTERED
 
     C     SSSFLD        IFEQ      *BLANK
     C     ER            IFEQ      0
     C                   Z-ADD     5             ER
     C                   END
     C                   MOVE      '1'           *IN43
     C                   END
 
     C* CHECK FIELD EXISTS
 
     C     GPAUFDKS      CHAIN     GPAUFDDX                           99        *
     C     *IN99         IFEQ      '0'
     C     AFWSEQ        ANDEQ     99999                                         NOT SELECTED
     C                   SETON                                        99
     C                   END
     C     *IN99         IFEQ      '1'
     C     ER            IFEQ      0
     C                   Z-ADD     6             ER
     C                   END
     C                   MOVE      '1'           *IN43
     C                   END
 
     C* CHECK COMPARISON
 
     C     SSSCMP        IFNE      'EQ'
     C     SSSCMP        ANDNE     'NE'
     C     SSSCMP        ANDNE     'GT'
     C     SSSCMP        ANDNE     'GE'
     C     SSSCMP        ANDNE     'LT'
     C     SSSCMP        ANDNE     'LE'
     C     ER            IFEQ      0
     C                   Z-ADD     7             ER
     C                   END
     C                   MOVE      '1'           *IN44
     C                   END
 
     C* VALIDATE COMPARISON & COMPARISON VALUE, IF NO ERRORS
 
     C     ER            IFEQ      0
     C                   CALLB     'GPAUSEXVL'                          9999    *
     C                   PARM      *BLANK        RETC              6
     C                   PARM      AFEDTS        I#EDTS            4 0
     C                   PARM      SSSCMP        I#SCMP            2
     C                   PARM      SSSCPV        I#SCPV           30
     C                   EXSR      CHKERR
     C     RETC          IFEQ      'INVSIZ'
     C     ER            IFEQ      0
     C                   Z-ADD     8             ER
     C                   END
     C                   MOVE      '1'           *IN45
     C                   END
     C     RETC          IFEQ      'INVCHR'
     C     ER            IFEQ      0
     C                   Z-ADD     9             ER
     C                   END
     C                   MOVE      '1'           *IN45
     C                   END
 
     C                   END
     C                   END
 
     C                   UPDATE    SUBFLRE1
 
     C* IF FIRST ERROR, POINT TO SUBFILE RECORD AND SET OUTPUT MESSAGE
 
     C     ER            IFNE      *ZERO
     C     PRRN1         ANDEQ     *ZERO
     C                   Z-ADD     RRN1          PRRN1
     C                   MOVEA     ERR(ER)       DDERR
     C                   END
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Fill subfile 1
      *****************************************************************
     C     FILSB1        BEGSR
     C                   Z-ADD     MRRN1         RRN1
     C                   MOVEA     '000'         *IN(1)
     C                   MOVEA     '1'           *IN(4)
     C                   MOVEA     '00000'       *IN(41)
     C                   MOVEL     *BLANK        S_DATA
     C                   WRITE     SUBFLCT1                                     *
 
     C* LOAD UP SUBFILE UNTIL END OF FILE
 
     C     *IN90         DOUEQ     '1'
     C* DO 6 TIMES
     C                   DO        6
     C                   ADD       1             RRN1              4 0    04    *
     C                   Z-ADD     RRN1          AFSELN
     C                   MOVEL     *BLANK        F_DATA
     C     GPAUASK       CHAIN     GPAUASD0                           90        *
     C                   MOVEL     F_DATA        S_DATA
     C                   WRITE     SUBFLRE1
     C                   END
 
     C                   END
     C* RESET SUBFILE
     C     *IN(4)        IFEQ      '1'
     C                   MOVEA     '010'         *IN(1)
     C                   ELSE
     C                   MOVEA     '111'         *IN(1)
     C                   END
     C  N10              Z-ADD     1             PRRN1                           FIRST CYCLE
     C   10RRN1          SUB       6             PRRN1             4 0
     C                   Z-ADD     RRN1          MRRN1
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Fill subfile 2
      *****************************************************************
     C     FILSB2        BEGSR
     C                   MOVEA     '000'         *IN(11)
     C                   MOVEA     '1'           *IN(14)
     C                   Z-ADD     *ZERO         RRN2
     C                   WRITE     SUBFLCT2                                     *
     C     GPAUFLK       SETLL     GPAUFDD0
     C     GPAUFLK       READE     GPAUFDD0                               99    *
     C* DO WHILE NOT EOF
     C     *IN99         DOWEQ     '0'
     C                   EXSR      FMTFL2
     C                   ADD       1             RRN2              4 0    14    *
     C                   WRITE     SUBFLRE2
     C     GPAUFLK       READE     GPAUFDD0                               99    *
     C                   END
     C* RESET SUBFILE
     C     *IN(14)       IFEQ      '1'
     C                   MOVEA     '010'         *IN(11)
     C                   ELSE
     C                   MOVEA     '111'         *IN(11)
     C                   END
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Format 2
      *****************************************************************
     C     FMTFL2        BEGSR
 
     C* FIELD FORMAT
 
     C                   CALLB     'GPAUEFFMT'
     C                   PARM      AFTYPE        I#TYPE            1
     C                   PARM      AFEDTS        I#DIG             4 0
     C                   PARM      AFDEC         I#DEC             2 0
     C                   PARM                    SSFFMT
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Update details
      *****************************************************************
     C     UPDDET        BEGSR
     C                   Z-ADD     *ZERO         AFSELN
     C                   Z-ADD     1             RRN1
 
     C* UPDATE RECORDS ON QRSEL WITH SUBFILE DETAILS
 
     C     RRN1          CHAIN     SUBFLRE1                           99
     C     *IN99         DOWEQ     '0'
     C     S_DATA        IFNE      *BLANK
     C                   ADD       1             AFSELN
     C     GPAUASK       CHAIN     GPAUASD0                           90
     C                   MOVEL     S_DATA        F_DATA
     C   90              WRITE     GPAUASD0
     C  N90              UPDATE    GPAUASD0
     C                   END
     C                   ADD       1             RRN1
     C     RRN1          CHAIN     SUBFLRE1                           99
     C                   END
 
     C* DELETE REMAINING
 
     C     GPAUASK       SETGT     GPAUASD0
     C     GPAUASKP      READE     GPAUASD0                               99    *
     C     *IN99         DOWEQ     '0'
     C                   DELETE    GPAUASD0
     C     GPAUASKP      READE     GPAUASD0                               99    *
     C                   END
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Initial processing
      *****************************************************************
     C     INIT          BEGSR
 
     C* PARAMETER LIST
 
     C     *ENTRY        PLIST
     C                   PARM                    RETC              6
     C                   PARM                    AFFILE           10
     C                   PARM                    AFRCID           15
     C                   PARM                    AFDESC           40
     C                   PARM                    AFACTN           10
 
     C                   Z-ADD     *ZERO         MRRN1             4 0
 
     C* KEY LISTS
 
     C     GPAUFLK       KLIST
     C                   KFLD                    AFFILE
     C                   KFLD                    AFRCID
     C     GPAUFDKS      KLIST
     C                   KFLD                    AFFILE
     C                   KFLD                    AFRCID
     C                   KFLD                    SSSFLD
     C     GPAUFDK       KLIST
     C                   KFLD                    AFFILE
     C                   KFLD                    AFRCID
     C                   KFLD                    AFWSEQ
     C     GPAUASK       KLIST
     C                   KFLD                    AFFILE
     C                   KFLD                    AFRCID
     C                   KFLD                    AFACTN
     C                   KFLD                    AFSELN
     C     GPAUASKP      KLIST
     C                   KFLD                    AFFILE
     C                   KFLD                    AFRCID
     C                   KFLD                    AFACTN
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Check for error
      *****************************************************************
     C     CHKERR        BEGSR
 
     C* ERROR ON CALL OF PROGRAM
 
     C     *IN99         IFEQ      '1'
     C     ERROR         ANDNE     1
     C                   EXSR      *PSSR
     C                   END
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      *****************************************************************
      * *PSSR processing
      *****************************************************************
     C     *PSSR         BEGSR
     C                   DUMP
     C                   MOVEL     '*CANCL'      RETURN            6
     C                   ENDSR     RETURN
      **********************************************************************
** ERR
First line IF/AND/OR must start with 'IF '
'IF ' can only be used on the first line
Invalid IF/AND/OR. Enter:'IF','AND','OR '
Before/After must be 'B' or 'A'
A field must be defined
This field must have been selected for use in this report
Invalid expression:Enter:'EQ','NE','GT','GE','LT','LE'
The comparison value has more characters than is possible for the field
The comparison value contains an invalid character (eg ',")
