     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas UT Populate FCLS from Take-on file')             *
      *****************************************************************
      *                                                               *
      *  Midas - CLE138 Class Codes for Facilities                    *
      *                                                               *
      *  UTFCLTYFN  - Midas UT Populate FCLS in FCLTYFN               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2021            *
      *                                                               *
      *  Last Amend No. CLE138   *Create   Date 02Nov21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE138 - Class Codes for Facilities                          *
      *                                                               *
      *****************************************************************

     FUTFCLTY   IF   E             DISK    INFSR(*PSSR)
     FLEFCLTLH  UF   E           K DISK    INFSR(*PSSR)

      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

     C                   READ      UTFCLTY                                80
     C     *IN80         DOWEQ     *OFF

     C     KFCLTY        CHAIN     LEFCLTLH                           81
     C     *IN81         IFEQ      *OFF
     C     FCXCLS        ANDEQ     *BLANKS
     C                   MOVE      UTFCLS        FCXCLS
     C                   UPDATE    LEFCLTLH
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
     C                   KFLD                    UTCNUM
     C                   KFLD                    UTFACT
     C                   KFLD                    UTFCNO

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
