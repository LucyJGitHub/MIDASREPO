     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas UT Populate Class for LEFEED')                   *
      *****************************************************************
      *                                                               *
      *  Midas - CLE138 Facilities Class Codes                        *
      *                                                               *
      *  UTLEFEED  - Midas UT Populate Class for LEFEED               *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD060173           Date 26Jun22               *
      *  Prev Amend No. CLE138   *CREATE   Date 02Nov21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060173 - Compilation errors. Correct key fields and value  *
      *             passed.                                           *
      *  CLE138 - Class Codes of Facilities                           *
      *                                                               *
      *****************************************************************

     FLEFEED    UF   E             DISK    INFSR(*PSSR)
     FLEFCLTLH  IF   E           K DISK    INFSR(*PSSR)

      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      * Work variables
     D*KCNUM****       S                   LIKE(CNUM)                                       MD060173
     D*KFACT****       S                   LIKE(FACT)                                       MD060173
     D*KFCNO****       S                   LIKE(FCNO)                                       MD060173
     D KCNUM           S              6                                                     MD060173
     D KFACT           S              3                                                     MD060173
     D KFCNO           S              2                                                     MD060173
     D                 DS
     D WFACL                   1      5  0
     D WFACT                   1      3  0
     D WFCNO                   4      5  0

     C                   READ      LEFEED                                 80
     C                   DOW       *IN80 = *OFF

     C                   IF        FEFACL > 0
     C                   EVAL      KCNUM = FECNUM
     C                   EVAL      WFACL = FEFACL
     C**********         EVAL      KFACT = WFACT                                            MD060173
     C**********         EVAL      KFCNO = WFCNO                                            MD060173
     C                   MOVE      WFACT         KFACT                                      MD060173
     C                   MOVE      WFCNO         KFCNO                                      MD060173
     C     KFCTYB        CHAIN     LEFCLTLH                           81
     C                   IF        *IN81 = *OFF
     C                   EVAL      FECLAS = FCXCLS
     C                   UPDATE    LEFEEDF
     C                   ENDIF
     C                   ENDIF

     C                   READ      LEFEED                                 80
     C                   ENDDO

     C                   EVAL      *INLR = *ON
     C                   RETURN

      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR

     C                   MOVEL     PSRunDate     PSRunDateA        6
     C                   MOVEL     PSJobNo       PSJobNoA          6

     C     KFCTYB        KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KFACT
     C                   KFLD                    KFCNO

     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR

     C                   DUMP

     C                   SETON                                        LRU7U8
     C                   RETURN

     C                   ENDSR
      *********************************************************************
