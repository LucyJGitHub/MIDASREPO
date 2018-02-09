     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Audit Input Selection')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAU0017 - Audit Input Selection                             *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG2410            Date 30Apr04               *
      *                 CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG2410 - Improve web-facing display                         *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     FGPAU0017DFCF   E             WORKSTN
     F                                     SFILE(SUBFLREC:RRN)
     FGPAUIPPD  IF   E           K DISK    INFSR(*PSSR)
 
     D ERR             S             76    DIM(2) CTDATA PERRCD(1)
 
     D DATA          E DS                  EXTNAME(GPAUIPPD)
     D  ##INPT       E                     EXTFLD(AIINPT)
 
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
 
     C                   EXSR      FILLSB
 
     C                   WRITE     SUBMESS                                                   BUG2410
     C                   WRITE     SUBFLCTL
     C*******************WRITE     SUBMESS                                                   BUG2410
     C                   READ      SUBFLCTL                               99    *
     C                   MOVEL     *BLANK        DDERR
 
     C* CK3 OR CK12,  END
 
     C     *INKC         IFEQ      '1'
     C     *INKL         OREQ      '1'
     C                   MOVEL     *BLANK        AIINPT
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
     C     GPAUIPK       SETLL     GPAUIPD0
     C                   EXSR      RDFFIL
     C     *IN99         IFEQ      '0'
     C                   MOVEL     AIINPT        ##INPT
     C                   ELSE
     C                   MOVEL     *BLANK        ##INPT
     C                   MOVEL     *BLANK        AIINPT
     C     DDERR         IFEQ      *BLANK
     C                   MOVEL     ERR(1)        DDERR                          *END OF FILE
     C                   END
     C                   END
 
     C     *IN99         DOWEQ     '0'
     C                   ADD       1             RRN               4 0    04    *
     C                   MOVEL     AIINPT        SSINPT
     C                   WRITE     SUBFLREC
     C     RRN           IFEQ      15
     C                   EXSR      RDFFIL
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        AIINPT
     C     DDERR         IFEQ      *BLANK
     C                   MOVEL     ERR(1)        DDERR                          *END OF FILE
     C                   END
     C                   ELSE
     C                   SETON                                            99    *
     C                   END
     C                   ELSE
     C                   EXSR      RDFFIL
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        AIINPT
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
     C                   MOVEL     ##INPT        AIINPT
     C     GPAUIPK       SETGT     GPAUIPD0
     C                   EXSR      RDPFIL
 
     C     *IN99         DOWEQ     '0'
     C     RRN           ANDLT     15
     C                   EXSR      RDPFIL
     C                   ADD       1             RRN
     C                   END
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        AIINPT
     C                   MOVEL     ERR(2)        DDERR                          *START OF FILE
     C                   END
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Read file
      ********************************************************************
     C     RDFFIL        BEGSR
     C                   READ      GPAUIPD0                               99    *
     C                   EXSR      SELCTN
     C     SELT          DOWEQ     'N'
     C                   READ      GPAUIPD0                               99    *
     C                   EXSR      SELCTN
     C                   END
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Read previous file
      ********************************************************************
     C     RDPFIL        BEGSR
     C                   READP     GPAUIPD0                               99    *
     C                   EXSR      SELCTN
     C     SELT          DOWEQ     'N'
     C                   READP     GPAUIPD0                               99    *
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
     C                   MOVEL     'Y'           SELT
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
     C                   PARM                    AIINPT
 
     C*  KEY LIST
 
     C     GPAUIPK       KLIST
     C                   KFLD                    AIINPT
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
