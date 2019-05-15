     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Audit File Selection')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAU0005 - Audit File Selection                              *
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
 
     FGPAU0005DFCF   E             WORKSTN
     F                                     SFILE(SUBFLREC:RRN)
     FGPAUFLL0  IF   E           K DISK    INFSR(*PSSR)
 
     D ERR             S             76    DIM(2) CTDATA PERRCD(1)
 
     D DATA          E DS                  EXTNAME(GPAUFLPD)
     D  ##FILE       E                     EXTFLD(AFFILE)
     D  ##RCID       E                     EXTFLD(AFRCID)
 
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
      ********************************************************************
      * Display the screen
      *****************************************************************
     C     DSPLAY        BEGSR
 
     C                   EXSR      FILLSB
 
     C                   WRITE     SUBFLCTL
     C                   WRITE     SUBMESS
     C                   READ      SUBFLCTL                               99    *
     C                   MOVEL     *BLANK        DDERR
 
     C* CK3 OR CK12,  END
 
     C     *INKC         IFEQ      '1'
     C     *INKL         OREQ      '1'
     C                   MOVEL     *BLANK        AFFILE
     C                   MOVEL     *BLANK        AFRCID
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
      * Fill the subfile
      ********************************************************************
     C     FILLSB        BEGSR
     C                   MOVEA     '000'         *IN(1)
     C                   MOVEA     '1'           *IN(4)
     C                   Z-ADD     *ZERO         RRN
     C                   WRITE     SUBFLCTL                                     *
     C     GPAUFLK       SETLL     GPAUFLD0
     C                   EXSR      RDFFIL
     C     *IN99         IFEQ      '0'
     C                   MOVEL     AFFILE        ##FILE
     C                   MOVEL     AFRCID        ##RCID
     C                   ELSE
     C                   MOVEL     *BLANK        ##FILE
     C                   MOVEL     *BLANK        ##RCID
     C                   MOVEL     *BLANK        AFFILE
     C                   MOVEL     *BLANK        AFRCID
     C     DDERR         IFEQ      *BLANK
     C                   MOVEL     ERR(1)        DDERR                          *END OF FILE
     C                   END
     C                   END
 
     C     *IN99         DOWEQ     '0'
     C                   ADD       1             RRN               4 0    04    *
     C                   MOVEL     AFFILE        SSFILE
     C                   MOVEL     AFRCID        SSRCID
     C                   WRITE     SUBFLREC
     C     RRN           IFEQ      15
     C                   EXSR      RDFFIL
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        AFFILE
     C                   MOVEL     *BLANK        AFRCID
     C     DDERR         IFEQ      *BLANK
     C                   MOVEL     ERR(1)        DDERR                          *END OF FILE
     C                   END
     C                   ELSE
     C                   SETON                                            99    *
     C                   END
     C                   ELSE
     C                   EXSR      RDFFIL
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        AFFILE
     C                   MOVEL     *BLANK        AFRCID
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
     C                   MOVEL     ##FILE        AFFILE
     C                   MOVEL     ##RCID        AFRCID
     C     GPAUFLK       SETGT     GPAUFLD0
     C                   EXSR      RDPFIL
 
     C     *IN99         DOWEQ     '0'
     C     RRN           ANDLT     15
     C                   EXSR      RDPFIL
     C                   ADD       1             RRN
     C                   END
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        AFFILE
     C                   MOVEL     *BLANK        AFRCID
     C                   MOVEL     ERR(2)        DDERR                          *START OF FILE
     C                   END
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Read file
      ********************************************************************
     C     RDFFIL        BEGSR
     C                   READ      GPAUFLD0                               99    *
     C                   EXSR      SELCTN
     C     SELT          DOWEQ     'N'
     C                   READ      GPAUFLD0                               99    *
     C                   EXSR      SELCTN
     C                   END
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Read previous file
      ********************************************************************
     C     RDPFIL        BEGSR
     C                   READP     GPAUFLD0                               99    *
     C                   EXSR      SELCTN
     C     SELT          DOWEQ     'N'
     C                   READP     GPAUFLD0                               99    *
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
     C                   GOTO      ESELCT
     C                   END
     C                   MOVEL     'Y'           SELT
     C     AFAUTH        IFEQ      'O'
     C     AFUSRI        ANDNE     USRID
     C                   MOVEL     'N'           SELT
     C                   GOTO      ESELCT
     C                   END
     C     ESELCT        ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Initial processing
      ********************************************************************
     C     INIT          BEGSR
 
     C*  PARAMETERS PASSED
 
     C     *ENTRY        PLIST
     C                   PARM                    RETC              6
     C                   PARM                    AFFILE
     C                   PARM                    AFRCID
 
     C*  KEY LIST
 
     C     GPAUFLK       KLIST
     C                   KFLD                    AFFILE
     C                   KFLD                    AFRCID
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
