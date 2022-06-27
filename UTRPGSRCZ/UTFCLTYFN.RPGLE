     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas UT Populate FCLS from Take-on file')             *
      *****************************************************************
      *                                                               *
      *  Midas - CLE138 Class Codes for Facilities                    *
      *                                                               *
      *  UTFCLTYFN  - Midas UT Populate FCXCLS in LEFCLTQD            *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD060173           Date 26Jun22               *
      *  Prev Amend No. CLE138   *Create   Date 02Nov21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060173 - Compilation errors. Correct key fields and value  *
      *             passed.                                           *
      *  CLE138 - Class Codes for Facilities                          *
      *                                                               *
      *****************************************************************

     FUTFCLTY   IF   E             DISK    INFSR(*PSSR)
     FLEFCLTLH  UF   E           K DISK    INFSR(*PSSR)

      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

     C                   READ      UTFCLTY                                80
     C     *IN80         DOWEQ     *OFF

     C                   MOVEL     UTCNUM        UXCNUM                                     MD060173
     C                   MOVE      UTFACT        UXFACT                                     MD060173
     C                   MOVE      UTFCNO        UXFCNO                                     MD060173
     C     KFCLTY        CHAIN     LEFCLTLH                           81
     C     *IN81         IFEQ      *OFF
     C     FCXCLS        ANDEQ     *BLANKS
     C                   MOVE      UTFCLS        FCXCLS
     C**********         UPDATE    LEFCLTLH                                                 MD060173
     C                   UPDATE    LEFCLTD0                                                 MD060173
     C                   ENDIF

     C                   READ      UTFCLTY                                80
     C                   ENDDO

     C                   EVAL      *INLR = *ON
     C                   RETURN

      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR

     C                   MOVEL     PSRunDate     PSRunDateA        6
     C                   MOVEL     PSJobNo       PSJobNoA          6

     C     KFCLTY        KLIST
     C**********         KFLD                    UTCNUM                                     MD060173
     C**********         KFLD                    UTFACT                                     MD060173
     C**********         KFLD                    UTFCNO                                     MD060173
     C                   KFLD                    UXCNUM            6                        MD060173
     C                   KFLD                    UXFACT            3                        MD060173
     C                   KFLD                    UXFCNO            2                        MD060173

     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR

     C     RunBefore     IFEQ      *BLANKS

     C                   MOVE      'Y'           RunBefore         1

     C                   DUMP
     C                   ENDIF

     C                   SETON                                        LRU7U8
     C                   RETURN

     C                   ENDSR
      *********************************************************************
