     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Process CAR migration GLMNARPD')              *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU00247 - German Feature migration for GLMNARPD             *
      *                                                               *
      *  Called By: SMUC00000                                         *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR854753 *CREATE   Date 26Oct11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR854753 - Historical JE extended narratives not migrated    *
      *                                                               *
      *****************************************************************
 
     FSMUGF18PD IF   E             DISK
      ** Template file for GLJENPX0
 
     FGLMNARPD  UF A E             DISK
 
      /EJECT
 
     D Recursive       S              1
 
      ** Read template file.
     C     1             SETLL     SMUGF18PD
     C                   READ      SMUGF18PD
     C                   DOW       NOT %EOF
 
     C                   EVAL      BAPODT = FPTDT
     C                   EVAL      BABANB = FBTNB
     C                   EVAL      BAITNB = FBINB
     C                   EVAL      BAEX1  = FNA02
     C                   EVAL      BAEX2  = FNA03
     C                   EVAL      BAEX3  = FNA04
     C                   EVAL      BAEX4  = FNA05
     C                   EVAL      BAEX5  = FNA06
     C                   EVAL      BAEX6  = FNA07
     C                   EVAL      BAEX7  = FNA08
     C                   EVAL      BAEX8  = FNA09
     C                   EVAL      BAEX9  = FNA10
     C                   EVAL      BAEX10 = FNA11
     C                   EVAL      BAEX11 = FNA12
     C                   EVAL      BAEX12 = FNA13
     C                   EVAL      BAEX13 = FNA14
     C                   EVAL      BAEX14 = FNA15
     C                   EVAL      BAEX15 = FNA16
     C                   EVAL      BAEX16 = FNA17
     C                   EVAL      BAEX17 = *BLANKS
     C                   EVAL      BAEX18 = *BLANKS
     C                   EVAL      BAEX19 = *BLANKS
     C                   EVAL      BAEX20 = *BLANKS
     C                   EVAL      BAEX21 = *BLANKS
     C                   EVAL      BAEX22 = *BLANKS
     C                   WRITE     GLMNARD0
 
     C                   READ      SMUGF18PD
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
