     H DEBUG
     H CCSID(*GRAPH:*SRC)                                                                   MD056543
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas CG CGCORRPD Utility Program 2')                  *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                          *
     F*                                                               *
     F*  CGFRIG2 - CGORRPD File Utility Program 2                     *
     F*                                                               *
     F*  (c) Finastra International Limited 2020                      *
     F*                                                               *
     F*  Last Amend No. MD056543  *CREATE  DATE 15Sep20               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*  MD056543 - EDWH SSRS Reports cannot be run.                  *
     F*           - Translate graphic fields of CGCORRPD and CGCDSHPD *
     F*             to readable unicode equivalent.                   *
     F*                                                               *
     F*****************************************************************
     F*
     FCGCORXPD  IP   E             DISK
     FCGCORRL0  UF A E           K DISK
     F*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*                 M A I N L I N E
     C********************************************************************
      *
      ** Check for existing record
     C     KRTV          KLIST
     C                   KFLD                    CDCORR
      *
      ** Setup key
     C                   MOVEL     XXCORR        CDCORR
     C     KRTV          CHAIN     @CORRL0                            9091
      *
     C     *IN90         IFEQ      '0'
     C                   MOVEL     XXCORR        CDCORR
     C                   MOVEL     XXCORN        CDCORN
     C                   MOVEL     XXADD1        CDADD1
     C                   MOVEL     XXADD2        CDADD2
     C                   MOVEL     XXADD3        CDADD3
     C                   MOVEL     XXADD4        CDADD4
     C                   MOVEL     XXADD5        CDADD5
     C                   MOVEL     XXADD6        CDADD6
     C                   MOVEL     XXADD7        CDADD7
     C                   MOVEL     XXADD8        CDADD8
     C                   UPDATE    @CORRL0                              91
     C                   ENDIF
      *
     CLR                 RETURN
