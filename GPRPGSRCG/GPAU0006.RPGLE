     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Copy Audit File Data')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAU0006 - Copy Audit File Data                              *
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
 
     FGPAUFLL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GPAUFLD0:GPAUFLDX)
     FGPAUFLPD  O    E           K DISK    INFSR(*PSSR)
     FGPAUFDL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GPAUFDD0:GPAUFDDX)
     FGPAUFDPD  O    E           K DISK    INFSR(*PSSR)
     FGPAURNL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GPAURND0:GPAURNDX)
     FGPAURNPD  O    E           K DISK    INFSR(*PSSR)
     FGPAUASL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GPAUASD0:GPAUASDX)
     FGPAUASPD  O    E           K DISK    INFSR(*PSSR)
 
     D PSDS           SDS
     D  ERROR            *STATUS
     D  WKSID                244    253
     D  USRID                254    263
 
     IGPAUFLDX
     I              AFFILE                      XXFILE
     I              AFRCID                      XXRCID
     IGPAUFDDX
     I              AFFILE                      XXFILE
     I              AFRCID                      XXRCID
     IGPAURNDX
     I              AFFILE                      XXFILE
     I              AFRCID                      XXRCID
     IGPAUASDX
     I              AFFILE                      XXFILE
     I              AFRCID                      XXRCID
 
     C     *ENTRY        PLIST
     C                   PARM                    AFFILE           10
     C                   PARM                    AFRCID           15
     C                   PARM                    CPFILE           10
     C                   PARM                    CPRCID           15
 
     C     GPAUFLK       KLIST
     C                   KFLD                    CPFILE
     C                   KFLD                    CPRCID
 
     C                   EXSR      AUFL
     C                   EXSR      AUFD
     C                   EXSR      AURN
     C                   EXSR      AUAS
     C                   SETON                                        LR
 
      /SPACE 5
      ********************************************************************
      * Copy GPAUFLPD
      *****************************************************************
     C     AUFL          BEGSR
     C     GPAUFLK       SETLL     GPAUFLDX
     C     GPAUFLK       READE     GPAUFLDX                               90    *
     C     *IN90         DOWEQ     '0'
     C                   WRITE     GPAUFLD0
     C     GPAUFLK       READE     GPAUFLDX                               90    *
     C                   END
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * Copy GPAUFDPD
      *****************************************************************
     C     AUFD          BEGSR
     C     GPAUFLK       SETLL     GPAUFDDX
     C     GPAUFLK       READE     GPAUFDDX                               90    *
     C     *IN90         DOWEQ     '0'
     C                   WRITE     GPAUFDD0
     C     GPAUFLK       READE     GPAUFDDX                               90    *
     C                   END
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * Copy GPAURNPD
      *****************************************************************
     C     AURN          BEGSR
     C     GPAUFLK       SETLL     GPAURNDX
     C     GPAUFLK       READE     GPAURNDX                               90    *
     C     *IN90         DOWEQ     '0'
     C                   WRITE     GPAURND0
     C     GPAUFLK       READE     GPAURNDX                               90    *
     C                   END
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * Copy GPAUASPD
      *****************************************************************
     C     AUAS          BEGSR
     C     GPAUFLK       SETLL     GPAUASDX
     C     GPAUFLK       READE     GPAUASDX                               90    *
     C     *IN90         DOWEQ     '0'
     C                   WRITE     GPAUASD0
     C     GPAUFLK       READE     GPAUASDX                               90    *
     C                   END
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * *PSSR processing
      *****************************************************************
     C     *PSSR         BEGSR
     C                   DUMP
     C                   MOVEL     '*CANCL'      RETURN            6
     C                   ENDSR     RETURN
      **********************************************************************
