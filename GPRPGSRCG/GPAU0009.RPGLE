     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Field Selection')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAU0009 - Field Selection                                   *
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
 
     FGPAU0009DFCF   E             WORKSTN
     F                                     SFILE(SUBFLRE2:RRN2)
     FGPAUFDL3  UF   E           K DISK    INFSR(*PSSR)
     FGPAUFDL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GPAUFDD0:GPAUFDDX)
     FGPAUASL1  IF   E           K DISK    INFSR(*PSSR)
 
     D #_OUS           S             10    DIM(250)
     D ERR             S             76    DIM(1) CTDATA PERRCD(1)
 
     D PSDS           SDS
     D  ERROR            *STATUS
     D  WKSID                244    253
     D  USRID                254    263
 
     C                   EXSR      INIT
 
      * Determine other usage of fields
 
     C                   EXSR      DET_OTHR_USE
 
     C     *INKC         DOWEQ     '0'
     C     *INKF         ANDEQ     '0'
     C     *INKL         ANDEQ     '0'
     C                   EXSR      FILSB2
     C                   EXSR      DSPLAY
     C                   END
 
     C                   SETON                                        LR
 
      /SPACE 5
      ********************************************************************
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
     C     WWPROT        IFNE      'Y'
     C                   Z-ADD     90000         WWWSEQ
     C                   EXSR      VALSUB
     C                   ENDIF
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
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate subfile
      ********************************************************************
     C     VALSUB        BEGSR
 
     C* ACCESS FIELD RECORD
 
     C     GPAUFDK       CHAIN     GPAUFDD0                           99        *
 
     C* CHECK IF TO BE SELECTED
 
     C     SSSELT        IFEQ      *BLANK
     C                   Z-ADD     99999         AFWSEQ
     C                   Z-ADD     99999         AFRSEQ
     C                   Z-ADD     *ZERO         AFSPCB
     C                   Z-ADD     *ZERO         AFLN
     C                   Z-ADD     *ZERO         AFPS
     C                   ELSE
     C                   Z-ADD     WWWSEQ        AFWSEQ
     C     AFEDTW        IFEQ      *BLANK
     C     AFRSEQ        ANDEQ     99999
     C                   EXSR      DEFLT_EDTW
     C                   END
     C                   END
 
     C* UPDATE FIELD RECORD WITH SEQUENCE NUMBER
 
     C                   EXCEPT    U_GPAUFD
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Fill subfile
      ********************************************************************
     C     FILSB2        BEGSR
     C                   Z-ADD     *ZERO         CUSE              3 0
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
 
     C* IF NUMBER USED EXCEEDED NUMBER AVAILABLE
 
     C     CUSE          IFGT      CAVL
     C                   MOVE      '0'           *INKF
     C                   Z-ADD     1             ER                2 0
     C                   MOVEA     ERR(ER)       DDERR
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Format file
      ********************************************************************
     C     FMTFL2        BEGSR
 
     C                   SETOFF                                       72
 
     C     AFWSEQ        IFNE      99999
     C                   ADD       1             CUSE
     C     CUSE          IFGT      CAVL
     C                   Z-ADD     99999         AFWSEQ
     C                   END
     C                   END
 
     C* SEQUENCE NUMBER
 
     C     AFWSEQ        IFEQ      99999
     C                   Z-ADD     99999         WWWSEQ
     C                   MOVE      *BLANK        SSSELT
     C                   ELSE
     C                   ADD       1             HSEQN
     C                   Z-ADD     HSEQN         WWWSEQ
     C                   MOVE      'X'           SSSELT
     C     AFLN          COMP      *ZERO                              7272
     C     *IN72         IFEQ      *OFF
     C     AFSNAM        LOOKUP    #_OUS                                  72
     C                   END
     C                   END
 
     C* SHORTNAME
 
     C                   MOVEL     AFSNAM        SSSNAM
 
     C* FIELD FORMAT
 
     C                   CALLB     'GPAUEFFMT'
     C                   PARM      AFTYPE        I#TYPE            1
     C                   PARM      AFDIG         I#DIG             4 0
     C                   PARM      AFDEC         I#DEC             2 0
     C                   PARM                    SSFFMT
 
     C* PROTECT
 
     C  N72              MOVEL     'N'           WWPROT
     C   72              MOVEL     'Y'           WWPROT
 
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
     C     AFLN          IFEQ      *ZERO
     C     AFSNAM        LOOKUP    #_OUS                                  99    *
     C  N99              Z-ADD     SETSEQ        AFWSEQ
     C                   ENDIF
     C                   EXCEPT    U_GPAUFD
     C     GPAUFLK       READE     GPAUFDD0                               99    *
     C                   END
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Default edit word
      ********************************************************************
     C     DEFLT_EDTW    BEGSR
 
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
      * Edit Word
     C                   MOVEL     I#EDTW        AFEDTW
      * Edit Size
     C                   Z-ADD     O#EDTS        AFEDTS
     C
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Determine other usage of fields
      ********************************************************************
     C     DET_OTHR_USE  BEGSR
 
     C                   MOVE      *BLANK        #_OUS
 
     C     GPAUFLK       SETLL     GPAUASD0
     C     GPAUFLK       READE     GPAUASD0                               99    *
     C     *IN99         DOWEQ     '0'
     C                   Z-ADD     1             #X                3 0
     C     AFSFLD        LOOKUP    #_OUS(#X)                              99    *
     C     *IN99         IFEQ      '0'
     C     *BLANK        LOOKUP    #_OUS(#X)                              99    *
     C                   MOVEL     AFSFLD        #_OUS(#X)
     C                   ENDIF
     C     GPAUFLK       READE     GPAUASD0                               99    *
     C                   ENDDO
 
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
 
     C* NUMBER OF FIELDS AVAILABLE TO BE SELECTED
 
     C                   Z-ADD     250           CAVL              3 0
 
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
      * Check for error
      ********************************************************************
     C     CHKERR        BEGSR
 
     C* ERROR ON CALL OF PROGRAM
 
     C     *IN99         IFEQ      '1'
     C     ERROR         ANDNE     1
     C                   EXSR      *PSSR
     C                   END
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
     O                       AFEDTW
     O                       AFEDTS
     O                       AFWSEQ
     O                       AFRSEQ
     O                       AFSPCB
     O                       AFLN
     O                       AFPS
** ERR
A MAXIMUM OF 250 FIELDS ONLY CAN BE SELECTED AS WORK FIELDS
