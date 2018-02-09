     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Update Audit File Data')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAU0007 - Update Audit File Data                            *
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
 
     FGPAUFLPD  IF   E             DISK    INFSR(*PSSR)
     FGPAUFLL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GPAUFLD0:GPAUFLDX)
     FGPAUFDPD  IF   E             DISK    INFSR(*PSSR)
     FGPAUFDL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GPAUFDD0:GPAUFDDX)
     FGPAURNPD  IF   E             DISK    INFSR(*PSSR)
     FGPAURNL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GPAURND0:GPAURNDX)
     FGPAUASPD  IF   E             DISK    INFSR(*PSSR)
     FGPAUASL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GPAUASD0:GPAUASDX)
 
     D #_DTC           S              1    DIM(30)
     D #_VCH           S              1    DIM(80) CTDATA PERRCD(80)
 
     D PSDS           SDS
     D  ERROR            *STATUS
     D  WKSID                244    253
     D  USRID                254    263
 
     C     *ENTRY        PLIST
     C                   PARM                    AFFILE           10
     C                   PARM                    AFRCID           15
 
     C     GPAUFLK       KLIST
     C                   KFLD                    AFFILE
     C                   KFLD                    AFRCID
 
     C                   EXSR      AUFL
     C                   EXSR      AUFD
     C                   EXSR      AURN
     C                   EXSR      AUAS
     C                   SETON                                        LR
 
      /SPACE 5
      *****************************************************************
      * Copy data to GPAUFLPD
      *****************************************************************
     C     AUFL          BEGSR
 
     C* FIRST DELETE EXISTING RECORDS FOR FILE
 
     C     GPAUFLK       SETLL     GPAUFLDX
     C     GPAUFLK       READE     GPAUFLDX                               90    *
     C     *IN90         DOWEQ     '0'
     C                   DELETE    GPAUFLDX
     C     GPAUFLK       READE     GPAUFLDX                               90    *
     C                   END
 
     C* WRITE NEW RECORDS FOR FILE
 
     C                   READ      GPAUFLD0                               90    *
     C     *IN90         DOWEQ     '0'
     C                   WRITE     GPAUFLDX
     C                   READ      GPAUFLD0                               90    *
     C                   END
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Copy data to GPAUFDPD
      *****************************************************************
     C     AUFD          BEGSR
 
     C* FIRST DELETE EXISTING RECORDS FOR FILE
 
     C     GPAUFLK       SETLL     GPAUFDDX
     C     GPAUFLK       READE     GPAUFDDX                               90    *
     C     *IN90         DOWEQ     '0'
     C                   DELETE    GPAUFDDX
     C     GPAUFLK       READE     GPAUFDDX                               90    *
     C                   END
 
     C* WRITE NEW RECORDS FOR FILE
 
     C                   READ      GPAUFDD0                               90    *
     C     *IN90         DOWEQ     '0'
     C                   EXSR      VALFLD
 
     C                   SELECT
     C     AFLN          WHENNE    *ZERO
     C     AFLN          MULT      132           AFRSEQ
     C                   ADD       AFPS          AFRSEQ
     C                   Z-ADD     AFRSEQ        AFWSEQ
     C     AFRSEQ        WHENNE    99999
     C     90000         ADD       AFFLDN        AFRSEQ
     C                   Z-ADD     AFRSEQ        AFWSEQ
     C     AFWSEQ        WHENNE    99999
     C     90000         ADD       AFFLDN        AFWSEQ
     C                   ENDSL
 
     C                   WRITE     GPAUFDDX
     C                   READ      GPAUFDD0                               90    *
     C                   END
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * Copy data to GPAURNPD
      *****************************************************************
     C     AURN          BEGSR
 
     C* FIRST DELETE EXISTING RECORDS FOR FILE
 
     C     GPAUFLK       SETLL     GPAURNDX
     C     GPAUFLK       READE     GPAURNDX                               90    *
     C     *IN90         DOWEQ     '0'
     C                   DELETE    GPAURNDX
     C     GPAUFLK       READE     GPAURNDX                               90    *
     C                   END
 
     C* WRITE NEW RECORDS FOR FILE
 
     C                   READ      GPAURND0                               90    *
     C     *IN90         DOWEQ     '0'
     C                   EXSR      VAL_NAR
     C                   WRITE     GPAURNDX
     C                   READ      GPAURND0                               90    *
     C                   END
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Copy data to GPAUASPD
      *****************************************************************
     C     AUAS          BEGSR
 
     C* FIRST DELETE EXISTING RECORDS FOR FILE
 
     C     GPAUFLK       SETLL     GPAUASDX
     C     GPAUFLK       READE     GPAUASDX                               90    *
     C     *IN90         DOWEQ     '0'
     C                   DELETE    GPAUASDX
     C     GPAUFLK       READE     GPAUASDX                               90    *
     C                   END
 
     C* WRITE NEW RECORDS FOR FILE
 
     C                   READ      GPAUASD0                               90    *
     C     *IN90         DOWEQ     '0'
     C                   WRITE     GPAUASDX
     C                   READ      GPAUASD0                               90    *
     C                   END
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Validate field data
      *****************************************************************
     C     VALFLD        BEGSR
 
     C* VALIDATE DESCRIPTION
 
     C                   MOVEA     AFFDES        #_DTC
     C                   EXSR      RMV_INVC
     C                   MOVEA     #_DTC         AFFDES
 
     C* VALIDATE COLUMN HEADINGS
 
     C                   MOVE      *BLANK        #_DTC
     C                   MOVEA     AFCOL1        #_DTC
     C                   EXSR      RMV_INVC
     C                   MOVEA     #_DTC         AFCOL1
     C                   MOVEA     AFCOL2        #_DTC
     C                   EXSR      RMV_INVC
     C                   MOVEA     #_DTC         AFCOL2
     C                   MOVEA     AFCOL3        #_DTC
     C                   EXSR      RMV_INVC
     C                   MOVEA     #_DTC         AFCOL3
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Validate narrative data
      *****************************************************************
     C     VAL_NAR       BEGSR
 
     C* VALIDATE NARRATIVE
 
     C                   MOVE      *BLANK        #_DTC
     C                   MOVEA     AFNARR        #_DTC
     C                   EXSR      RMV_INVC
     C                   MOVEA     #_DTC         AFNARR
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Remove invalid characters
      *****************************************************************
     C     RMV_INVC      BEGSR
     C                   Z-ADD     1             X                 3 0
     C     X             DOUGT     30
     C                   Z-ADD     1             Y                 3 0
     C     #_DTC(X)      LOOKUP    #_VCH(Y)                               99    *
     C  N99              MOVEL     *BLANK        #_DTC(X)
     C                   ADD       1             X
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
** #_VCH
 ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#@0123456789.,:;/+*_$%&()"|
