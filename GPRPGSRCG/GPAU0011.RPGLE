     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Report Field Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAU0011 - Report Field Maintenance                          *
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
 
     FGPAU0011DFCF   E             WORKSTN
     F                                     SFILE(SUBFLRE2:RRN2)
     FGPAUFDL3  UF   E           K DISK    INFSR(*PSSR)
     FGPAUFDL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GPAUFDD0:GPAUFDDX)
 
     D ERR             S             76    DIM(15) CTDATA PERRCD(1)
 
     D                 DS
     D  AF_DATA                1    109
     D  AFEDTW                 1     26
     D  AFFDES                27     56
     D  AFCOL1                57     73
     D  AFCOL2                74     90
     D  AFCOL3                91    107
     D  AFREFF               108    108
     D  AFBRCF               109    109
     D                 DS
     D  SS_DATA                1    109
     D  SSEDTW                 1     26
     D  SSFDES                27     56
     D  SSCOL1                57     73
     D  SSCOL2                74     90
     D  SSCOL3                91    107
     D  SSREFF               108    108
     D  SSBRCF               109    109
 
     D PSDS           SDS
     D  ERROR            *STATUS
     D  WKSID                244    253
     D  USRID                254    263
 
     C                   EXSR      INIT
 
     C* ACCESS THE AUDIT FILE FOR THE REPORT OUTPUT TYPE
 
     C                   Z-ADD     99            ER                2 0
     C                   EXSR      FILSB2
     C     ER            DOWNE     *ZERO
     C                   EXSR      DSPLAY
     C                   END
 
     C                   SETON                                        LR
 
      /SPACE 5
      *****************************************************************
      * Display screen
      *****************************************************************
     C     DSPLAY        BEGSR
 
     C                   WRITE     SUBFLCT2
     C                   WRITE     SUBMESS
     C                   READ      SUBFLCT2                               99    *
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
 
     C* IF ENTER PRESSED, CHECK SELECTION
     C* (AS LONG AS SUBFILE HAS SOMETHING IN IT)
 
     C                   Z-ADD     *ZERO         PRRN2
     C     *IN(14)       IFEQ      '0'
     C                   Z-ADD     1             RRN2
     C     RRN2          CHAIN     SUBFLRE2                           99
     C     *IN99         DOWEQ     '0'
     C                   EXSR      VALSUB
     C                   ADD       1             RRN2
     C     RRN2          CHAIN     SUBFLRE2                           99
     C                   END
     C                   END
     C* CK/6
     C     *INKF         IFEQ      '1'
     C     PRRN2         ANDEQ     *ZERO
     C                   Z-ADD     *ZERO         ER
     C                   ELSE
     C     PRRN2         IFEQ      *ZERO
     C                   Z-ADD     1             PRRN2
     C                   END
     C                   Z-ADD     99            ER
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
 
     C                   Z-ADD     0             ER
     C                   MOVEA     '00000'       *IN(41)
 
     C* ACCESS FIELD RECORD
 
     C     GPAUFDK       CHAIN     GPAUFDD0                           99        *
 
     C* EDIT CODE, EDIT WORD, DESCRIPTION, COL1, COL2, COL3
 
     C                   MOVEL     SS_DATA       AF_DATA
 
     C* EDIT WORD VALIDATION
 
     C                   CALLB     'GPAUEDWVL'
     C                   PARM      AFFILE        I#FILE           10
     C                   PARM      AFRCID        I#RCID           15
     C                   PARM      AFEDTW        I#EDTW           26
     C                   PARM      AFTYPE        I#TYPE            1
     C                   PARM      AFDIG         I#DIG             4 0
     C                   PARM      AFDEC         I#DEC             2 0
     C                   PARM      AFFDES        I#FDES           30
     C                   PARM                    O#VERR           50
     C                   PARM                    O#EDTS            4 0
      * ERRORS
     C     ER            IFEQ      0
     C                   SELECT
     C     O#VERR        WHENEQ    'ALPHAMERIC'
     C                   Z-ADD     1             ER                   41
     C     O#VERR        WHENEQ    'NUMERIC'
     C                   Z-ADD     2             ER                   41
     C     O#VERR        WHENEQ    'DAYNUMBER'
     C                   Z-ADD     3             ER                   41
     C     O#VERR        WHENEQ    'BASECCY'
     C                   Z-ADD     4             ER                   41
     C     O#VERR        WHENEQ    'MISSING'
     C                   Z-ADD     5             ER                   41
     C     O#VERR        WHENEQ    'CHARACTERS_T'
     C                   Z-ADD     6             ER                   41
     C     O#VERR        WHENEQ    'INVCHARACTER'
     C                   Z-ADD     7             ER                   41
     C     O#VERR        WHENEQ    'ONE0ONLY'
     C                   Z-ADD     8             ER                   41
     C     O#VERR        WHENEQ    'FIELDSIZE'
     C                   Z-ADD     9             ER                   41
     C     O#VERR        WHENEQ    'CHARACTERS_F'
     C                   Z-ADD     10            ER                   41
     C     O#VERR        WHENEQ    'INVALIDFIELD'
     C                   Z-ADD     11            ER                   41
     C                   ENDSL
     C                   ENDIF
      * Edit Word
     C                   MOVEL     I#EDTW        SSEDTW
     C                   MOVEL     I#EDTW        AFEDTW
      * Edit Size
     C                   Z-ADD     O#EDTS        AFEDTS
 
     C* DESCRIPTION
 
     C     SSFDES        IFEQ      *BLANK
     C     ER            IFEQ      0
     C                   Z-ADD     12            ER
     C                   END
     C                   MOVE      '1'           *IN42
     C                   END
 
     C* COLUMN HEADING #1
 
     C     SSCOL1        IFEQ      *BLANK
     C     ER            IFEQ      0
     C                   Z-ADD     13            ER
     C                   END
     C                   MOVE      '1'           *IN43
     C                   END
 
     C* REFERENCE FIELD
 
     C     SSREFF        IFNE      *BLANK
     C     SSREFF        ANDNE     '1'
     C     SSREFF        ANDNE     '2'
     C     SSREFF        ANDNE     '3'
     C     SSREFF        ANDNE     '4'
     C     SSREFF        ANDNE     '5'
     C     SSREFF        ANDNE     '6'
     C     SSREFF        ANDNE     '7'
     C     SSREFF        ANDNE     '8'
     C     SSREFF        ANDNE     '9'
     C     ER            IFEQ      0
     C                   Z-ADD     14            ER
     C                   END
     C                   MOVE      '1'           *IN44
     C                   END
 
     C* BRANCH FIELD
 
     C     SSBRCF        IFNE      *BLANK
     C     SSBRCF        ANDNE     'Y'
     C     ER            IFEQ      0
     C                   Z-ADD     15            ER
     C                   END
     C                   MOVE      '1'           *IN45
     C                   END
 
     C* UPDATE AUDIT FIELD RECORD IF NO ERRORS
 
     C     ER            IFEQ      0
     C                   UPDATE    GPAUFDD0
     C                   ELSE
     C     PRRN2         IFEQ      *ZERO
     C                   Z-ADD     RRN2          PRRN2
     C                   END
     C                   MOVEA     ERR(ER)       DDERR
     C                   END
 
     C* IF LINE DEFINED (THEN FIELD APPEARS ON THE REPORT)
     C* PROTECT THE EDIT CODE AND WORD
 
     C     AFLN          IFNE      *ZERO
     C                   MOVE      '1'           *IN60
     C                   ELSE
     C                   MOVE      '0'           *IN60
     C                   END
 
     C* UPDATE SUBFILE RECORD
 
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
     C     GPAUFLK       SETLL     GPAUFDDX
     C     GPAUFLK       READE     GPAUFDDX                               99    *
     C     *IN99         DOWEQ     '0'
     C                   EXSR      FMTFL2
     C                   ADD       1             RRN2              4 0    14    *
     C                   WRITE     SUBFLRE2
     C     GPAUFLK       READE     GPAUFDDX                               99    *
     C                   END
     C     *IN(14)       IFEQ      '1'
     C                   MOVEA     '010'         *IN(11)
     C                   ELSE
     C                   MOVEA     '111'         *IN(11)
     C                   END
 
     C                   Z-ADD     1             PRRN2             4 0
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Format file
      ********************************************************************
     C     FMTFL2        BEGSR
 
     C* EDIT CODE, EDIT WORD, DESCRIPTION, COL1, COL2, COL3
 
     C                   MOVEL     AF_DATA       SS_DATA
 
     C* SHORTNAME
 
     C                   MOVEL     AFSNAM        SSSNAM
 
     C* FIELD FORMAT
 
     C                   CALLB     'GPAUEFFMT'
     C                   PARM      AFTYPE        I#TYPE            1
     C                   PARM      AFDIG         I#DIG             4 0
     C                   PARM      AFDEC         I#DEC             2 0
     C                   PARM                    SSFFMT
 
     C* IF LINE DEFINED (THEN FIELD APPEARS ON THE REPORT)
     C* PROTECT THE EDIT CODE AND WORD
 
     C     AFLN          IFNE      *ZERO
     C                   MOVE      '1'           *IN60
     C                   ELSE
     C                   MOVE      '0'           *IN60
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Initial processing
      ********************************************************************
     C     INIT          BEGSR
 
     C* PARAMETER LIST
 
     C     *ENTRY        PLIST
     C                   PARM                    RETC              6
     C                   PARM                    AFFILE           10
     C                   PARM                    AFRCID           15
     C                   PARM                    AFDESC           40
 
     C* KEY LISTS
 
     C     GPAUFLK       KLIST
     C                   KFLD                    AFFILE
     C                   KFLD                    AFRCID
     C     GPAUFDK       KLIST
     C                   KFLD                    AFFILE
     C                   KFLD                    AFRCID
     C                   KFLD                    AFSNAM
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * *PSSR processing
      ********************************************************************
     C     *PSSR         BEGSR
     C                   DUMP
     C                   MOVEL     '*CANCL'      RETURN            6
     C                   ENDSR     RETURN
      **********************************************************************
** ERR
An Edit Word cannot be defined against an alphameric field
An Edit Word cannot be defined for a numeric field > 17 bytes in length
Day number conversion requires the field to be 5 digits and numeric
Base currency editing requires the field to be at least 11 digits & numeric
Missing inverted commas around Edit Word (eg '   , 0 .  -')
Characters are defined after the second inverted comma
Valid characters are blank, '0', ',', '.' and '-'
Only one '0' (for zero suppress) is allowed in an edit word
Edit word does not match field size
Characters are defined after what appears to be an RPG field name
Invalid RPG field name
Description must be defined
Column Heading #1 must be defined
Reference field - if defined - must be a number between 1 and 9
Branch field - if defined - can only be 'Y'
