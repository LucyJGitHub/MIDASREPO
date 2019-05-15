     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Report Field Selection')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAU0010 - Report Field Selection                            *
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
 
     FGPAU0010DFCF   E             WORKSTN
     F                                     SFILE(SUBFLRE2:RRN2)
     FGPAUFDL3  UF   E           K DISK    INFSR(*PSSR)
     FGPAUFDL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GPAUFDD0:GPAUFDDX)
 
     D PSDS           SDS
     D  ERROR            *STATUS
     D  WKSID                244    253
     D  USRID                254    263
 
     C                   EXSR      INIT
 
 
     C     *INKC         DOWEQ     '0'
     C     *INKF         ANDEQ     '0'
     C     *INKL         ANDEQ     '0'
     C                   EXSR      FILSB2
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
     C                   ELSE
     C* CK/12
     C     *INKL         IFEQ      '1'
     C                   MOVEL     'ABAND '      RETC
     C                   ELSE
 
     C* IF THE SUBFILE HAS RECORDS IN IT
 
     C     *IN(14)       IFEQ      '0'
 
     C* IF CMD/7 TAKEN SET ALL TO NOT SELECTED
 
     C     *INKG         IFEQ      '1'
     C                   Z-ADD     99999         SETSEQ            5 0
     C                   EXSR      SETFIL
     C                   ELSE
 
     C* IF CMD/8 TAKEN SET ALL TO SELECTED
 
     C     *INKH         IFEQ      '1'
     C                   Z-ADD     90000         SETSEQ            5 0
     C                   EXSR      SETFIL
     C                   ELSE
 
     C* IF ENTER PRESSED OR CMD/6 TAKEN, CHECK SELECTION
 
     C                   Z-ADD     1             RRN2
     C     RRN2          CHAIN     SUBFLRE2                           99
     C     *IN99         DOWEQ     '0'
     C                   EXSR      VALSUB
     C                   ADD       1             RRN2
     C     RRN2          CHAIN     SUBFLRE2                           99
     C                   END
 
     C* IF CMD/6 TAKEN FILL SUB-FILE TO RESEQUENCE AGAIN IF NECESSARY
 
     C     *INKF         IFEQ      '1'
     C                   EXSR      FILSB2
     C                   END
     C                   END
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
 
     C* ACCESS FIELD RECORD
 
     C     GPAUFDK       CHAIN     GPAUFDD0                           99        *
 
     C* CHECK INPUT SEQUENCE NUMBER
 
     C     SSSEQN        IFNE      *BLANK
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVEL     SSSEQN        ZFIELD
     C                   Z-ADD     5             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C   99              Z-ADD     99998         AFRSEQ
     C  N99              MOVE      ZFIELD        AFRSEQ
     C     AFRSEQ        IFEQ      *ZERO
     C                   Z-ADD     1             AFRSEQ
     C                   END
     C                   ELSE
     C                   Z-ADD     99999         AFRSEQ
     C                   MOVEL     *BLANK        SSSPCB
     C                   Z-ADD     *ZERO         AFLN
     C                   Z-ADD     *ZERO         AFPS
     C                   END
 
     C* CHECK INPUT SPACE BEFORE
 
     C     SSSPCB        IFNE      *BLANK
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVEL     SSSPCB        ZFIELD
     C                   Z-ADD     1             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C  N99              MOVE      ZFIELD        AFSPCB
     C   99              Z-ADD     1             AFSPCB
     C                   ELSE
     C                   Z-ADD     *ZERO         AFSPCB
     C                   END
 
     C* UPDATE FIELD RECORD WITH SEQUENCE NUMBER AND SPACE BEFORE
 
     C                   EXCEPT    U_GPAUFD
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Fill subfile
      ********************************************************************
     C     FILSB2        BEGSR
     C                   Z-ADD     *ZERO         HSEQN             5 0
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
 
     C* NOW UPDATE FILE WITH LATEST SEQUENCE NUMBERS
 
     C     *IN(14)       IFEQ      '0'
     C                   Z-ADD     1             RRN2
     C     RRN2          CHAIN     SUBFLRE2                           99
     C     *IN99         DOWEQ     '0'
     C                   EXSR      VALSUB
     C                   ADD       1             RRN2
     C     RRN2          CHAIN     SUBFLRE2                           99
     C                   END
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Format file
      ********************************************************************
     C     FMTFL2        BEGSR
 
     C* SEQUENCE NUMBER
 
     C     AFRSEQ        IFEQ      99999
     C                   MOVE      *BLANK        SSSEQN
     C                   ELSE
     C                   ADD       10            HSEQN
     C                   Z-ADD     HSEQN         AFRSEQ
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      AFRSEQ        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SSSEQN
     C                   END
 
     C* SPACE BEFORE
 
     C     AFSPCB        IFNE      *ZERO
     C                   MOVEL     AFSPCB        SSSPCB
     C                   ELSE
     C                   MOVEL     *BLANK        SSSPCB
     C                   END
 
     C* SHORTNAME
 
     C                   MOVEL     AFSNAM        SSSNAM
 
     C* FIELD FORMAT
 
     C                   CALLB     'GPAUEFFMT'
     C                   PARM      AFTYPE        I#TYPE            1
     C                   PARM      AFDIG         I#DIG             4 0
     C                   PARM      AFDEC         I#DEC             2 0
     C                   PARM                    SSFFMT
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Set file
      ********************************************************************
     C     SETFIL        BEGSR
     C     GPAUFLK       SETLL     GPAUFDD0
     C     GPAUFLK       READE     GPAUFDD0                               99    *
     C     *IN99         DOWEQ     '0'
     C     AFWSEQ        IFNE      99999
     C     SETSEQ        IFEQ      99999
     C                   Z-ADD     SETSEQ        AFRSEQ
     C                   ELSE
     C                   Z-ADD     AFWSEQ        AFRSEQ
     C                   ENDIF
     C                   Z-ADD     *ZERO         AFSPCB
     C     AFRSEQ        IFEQ      99999
     C                   Z-ADD     *ZERO         AFLN
     C                   Z-ADD     *ZERO         AFPS
     C                   END
     C                   EXCEPT    U_GPAUFD
     C                   END
     C     GPAUFLK       READE     GPAUFDD0                               99    *
     C                   END
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * Edit field
      ********************************************************************
     C     ZEDIT         BEGSR
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * Align field
      ********************************************************************
     C     ZALIGN        BEGSR
     C                   CALL      'ZALIGN'
     C                   PARM                    ZRTN              7
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   PARM                    ZAFLD            16
 
     C     ZRTN          IFNE      *BLANK
     C                   MOVE      *ON           *IN99
     C                   ELSE
     C                   MOVE      *OFF          *IN99
     C                   ENDIF
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
     OGPAUFDD0  E            U_GPAUFD
     O                       AFRSEQ
     O                       AFSPCB
     O                       AFLN
     O                       AFPS
