     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Field Selection From Layout Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAU0014 - Field Selection From Layout Maintenance           *
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
 
     FGPAU0014DFCF   E             WORKSTN
     F                                     SFILE(SUBFLREC:RRN)
     FGPAUFDL4  IF   E           K DISK    INFSR(*PSSR)
 
     D ERR             S             76    DIM(2) CTDATA PERRCD(1)
 
     D DATA          E DS                  EXTNAME(GPAUFDPD)
     D  ##FILE       E                     EXTFLD(AFFILE)
     D  ##RCID       E                     EXTFLD(AFRCID)
     D  ##SNAM       E                     EXTFLD(AFSNAM)
     D  ##FLDN       E                     EXTFLD(AFFLDN)
     D  ##RSEQ       E                     EXTFLD(AFRSEQ)
 
     D PSDS           SDS
     D  ERROR            *STATUS
     D  WKSID                244    253
     D  USRID                254    263
 
     C* INITIAL PROCESSING
 
     C                   EXSR      INIT
 
     C     *INKC         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
     C                   EXSR      DSPLAY
     C                   END
 
     C                   SETON                                        LR
 
      /SPACE 5
      *****************************************************************
      * Display screen
      *****************************************************************
     C     DSPLAY        BEGSR
 
     C     DDFDES        IFNE      DDFDES_P
     C     DDFFMT        ORNE      DDFFMT_P
     C     DDEDTW        ORNE      DDEDTW_P
     C                   Z-ADD     *ZERO         AFRSEQ
     C                   Z-ADD     *ZERO         AFFLDN
     C                   MOVEL     *BLANK        AFSNAM
     C                   ENDIF
     C                   MOVEL     DDFDES        DDFDES_P         30
     C                   MOVEL     DDFFMT        DDFFMT_P          6
     C                   MOVEL     DDEDTW        DDEDTW_P         26
 
     C                   EXSR      FILLSB
 
     C                   WRITE     SUBFLCTL
     C                   WRITE     SUBMESS
     C                   READ      SUBFLCTL                               99    *
     C                   MOVEL     *BLANK        DDERR
 
     C* CK3 OR CK12,  END
 
     C     *INKC         IFEQ      '1'
     C     *INKL         OREQ      '1'
     C                   MOVEL     *BLANK        AFSNAM
     C   KC              MOVEL     'EXIT  '      RETC
     C                   ELSE
     C* ROLLDOWN
     C     *IN05         IFEQ      '1'
     C                   EXSR      ROLDWN
     C                   ELSE
     C* SELECT
     C     *IN(04)       IFEQ      '0'
     C                   READC     SUBFLREC                               99    *RECORD CHANGED
     C     *IN99         IFEQ      '0'
     C                   MOVEL     '1'           *INKL
     C                   END
     C                   END
     C                   END
     C                   END
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Fill subfile
      ********************************************************************
     C     FILLSB        BEGSR
     C                   MOVEA     '000'         *IN(1)
     C                   MOVEA     '1'           *IN(4)
     C                   Z-ADD     *ZERO         RRN
     C                   WRITE     SUBFLCTL                                     *
     C     GPAUFDK       SETLL     GPAUFDD0
     C                   EXSR      RDFFIL
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     AFRSEQ        ##RSEQ
     C                   Z-ADD     AFFLDN        ##FLDN
     C                   MOVEL     AFSNAM        ##SNAM
     C                   ELSE
     C                   Z-ADD     *ZERO         ##RSEQ
     C                   Z-ADD     *ZERO         ##FLDN
     C                   MOVEL     *BLANK        ##SNAM
     C                   Z-ADD     *ZERO         AFRSEQ
     C                   Z-ADD     *ZERO         AFFLDN
     C                   MOVEL     *BLANK        AFSNAM
     C     DDERR         IFEQ      *BLANK
     C                   MOVEL     ERR(1)        DDERR                          *END OF FILE
     C                   END
     C                   END
 
     C     *IN99         DOWEQ     '0'
     C                   ADD       1             RRN               4 0    04    *
     C                   MOVEL     AFSNAM        SSSNAM
     C                   WRITE     SUBFLREC
     C     RRN           IFEQ      15
     C                   EXSR      RDFFIL
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     *ZERO         AFRSEQ
     C                   Z-ADD     *ZERO         AFFLDN
     C                   MOVEL     *BLANK        AFSNAM
     C     DDERR         IFEQ      *BLANK
     C                   MOVEL     ERR(1)        DDERR                          *END OF FILE
     C                   END
     C                   ELSE
     C                   SETON                                            99    *
     C                   END
     C                   ELSE
     C                   EXSR      RDFFIL
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     *ZERO         AFRSEQ
     C                   Z-ADD     *ZERO         AFFLDN
     C                   MOVEL     *BLANK        AFSNAM
     C     DDERR         IFEQ      *BLANK
     C                   MOVEL     ERR(1)        DDERR                          *END OF FILE
     C                   END
     C                   END
     C                   END
     C                   END
 
     C     *IN(4)        IFEQ      '1'
     C                   MOVEA     '010'         *IN(1)
     C                   ELSE
     C                   MOVEA     '111'         *IN(1)
     C                   END
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Rolldown
      ********************************************************************
     C     ROLDWN        BEGSR
     C                   Z-ADD     *ZERO         RRN
     C                   Z-ADD     ##RSEQ        AFRSEQ
     C                   Z-ADD     ##FLDN        AFFLDN
     C                   MOVEL     ##SNAM        AFSNAM
     C     GPAUFDK       SETGT     GPAUFDD0
     C                   EXSR      RDPFIL
 
     C     *IN99         DOWEQ     '0'
     C     RRN           ANDLT     15
     C                   EXSR      RDPFIL
     C                   ADD       1             RRN
     C                   END
 
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     *ZERO         AFRSEQ
     C                   Z-ADD     *ZERO         AFFLDN
     C                   MOVEL     *BLANK        AFSNAM
     C                   MOVEL     ERR(2)        DDERR                          *START OF FILE
     C                   END
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Read file
      ********************************************************************
     C     RDFFIL        BEGSR
     C     GPAUFLK       READE     GPAUFDD0                               99    *
     C                   EXSR      SELCTN
     C     SELT          DOWEQ     'N'
     C     GPAUFLK       READE     GPAUFDD0                               99    *
     C                   EXSR      SELCTN
     C                   END
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Read previous file
      ********************************************************************
     C     RDPFIL        BEGSR
     C     GPAUFLK       READPE    GPAUFDD0                               99    *
     C                   EXSR      SELCTN
     C     SELT          DOWEQ     'N'
     C     GPAUFLK       READPE    GPAUFDD0                               99    *
     C                   EXSR      SELCTN
     C                   END
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Selection of record
      ********************************************************************
     C     SELCTN        BEGSR
     C     *IN99         IFEQ      '1'
     C                   MOVEL     '*'           SELT              1
     C                   ELSE
 
     C     I#RECD_TYPE   IFEQ      'ALL'
     C                   MOVEL     'Y'           SELT
     C                   ELSE
     C     AFLN          IFEQ      *ZERO
     C                   MOVEL     'Y'           SELT
     C                   ELSE
     C                   MOVEL     'N'           SELT
     C                   END
     C                   END
 
     C     SELT          IFEQ      'Y'
     C     DDFDES        ANDNE     *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    AFFDES
      * Length
     C                   PARM      30            WQA3N             3 0
      * Start
     C                   PARM      1             WQB3N             3 0
      * Mask
     C                   PARM                    DDFDES
      * Length
     C                   PARM      30            WQC3N             3 0
      * Translate
     C                   PARM      '1'           WQD1              1
      * Trim
     C                   PARM      '1'           WQE1              1
      * Wild
     C                   PARM      '?'           WQF1              1
      * Result
     C                   PARM                    WQG3N             3 0
     C     WQG3N         IFLT      1
     C                   MOVEL     'N'           SELT
     C                   ENDIF
     C                   ENDIF
 
     C* FIELD FORMAT
 
     C                   CALLB     'GPAUEFFMT'
     C                   PARM      AFTYPE        I#TYPE            1
     C                   PARM      AFDIG         I#DIG             4 0
     C                   PARM      AFDEC         I#DEC             2 0
     C                   PARM                    SSFFMT
 
     C     SELT          IFEQ      'Y'
     C     DDFFMT        ANDNE     *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    SSFFMT
      * Length
     C                   PARM      6             WQA3N             3 0
      * Start
     C                   PARM      1             WQB3N             3 0
      * Mask
     C                   PARM                    DDFFMT
      * Length
     C                   PARM      6             WQC3N             3 0
      * Translate
     C                   PARM      '1'           WQD1              1
      * Trim
     C                   PARM      '1'           WQE1              1
      * Wild
     C                   PARM      '?'           WQF1              1
      * Result
     C                   PARM                    WQG3N             3 0
     C     WQG3N         IFLT      1
     C                   MOVEL     'N'           SELT
     C                   ENDIF
     C                   ENDIF
 
     C     SELT          IFEQ      'Y'
     C     DDEDTW        ANDNE     *BLANK
     C     DDEDTW        ANDNE     AFEDTW
     C                   MOVEL     'N'           SELT
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Initial processing
      ********************************************************************
     C     INIT          BEGSR
 
     C*  PARAMETERS PASSED
 
     C     *ENTRY        PLIST
     C                   PARM                    RETC              6
     C                   PARM                    I#RECD_TYPE       3
     C                   PARM                    AFFILE
     C                   PARM                    AFRCID
     C                   PARM                    AFSNAM
 
     C*  KEY LIST
 
     C     GPAUFLK       KLIST
     C                   KFLD                    AFFILE
     C                   KFLD                    AFRCID
     C     GPAUFDK       KLIST
     C                   KFLD                    AFFILE
     C                   KFLD                    AFRCID
     C                   KFLD                    AFRSEQ
     C                   KFLD                    AFFLDN
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
End of File
Start of File
