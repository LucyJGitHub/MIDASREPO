/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MR Update Reporting Hierarchies File - 1')
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting Module                           *
      *                                                               *
      *  MR000055 -  Update Reporting Hierarchies file - 1            *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CMR001             Date 01Sep04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CMR001 - MidasPlus Reporting                                 *
      *                                                               *
      *****************************************************************
 
     FSDREPCL1  IP   E           K DISK
     FSDACRCL1  IF   E           K DISK
     FMRREPHPD  O    E             DISK
 
 
     C                   SELECT
     C     G4LVNB        WHENEQ    '1'
     C                   MOVEL     G4RSCD        G4RSC1
     C                   MOVEL     G4RPNA        G4RPN1
     C     G4LVNB        WHENEQ    '2'
     C                   MOVEL     G4RSCD        G4RSC2
     C                   MOVEL     G4RPNA        G4RPN2
     C     G4LVNB        WHENEQ    '3'
     C                   MOVEL     G4RSCD        G4RSC3
     C                   MOVEL     G4RPNA        G4RPN3
     C     G4LVNB        WHENEQ    '4'
     C                   MOVEL     G4RSCD        G4RSC4
     C                   MOVEL     G4RPNA        G4RPN4
     C     G4LVNB        WHENEQ    '5'
     C                   MOVEL     G4RSCD        G4RSC5
     C                   MOVEL     G4RPNA        G4RPN5
     C     G4LVNB        WHENEQ    '6'
     C                   MOVEL     G4RSCD        G4RSC6
     C                   MOVEL     G4RPNA        G4RPN6
     C                   ENDSL
 
     C     G4LVNB        IFLT      '6'
     C                   MOVEL     *BLANK        G4RSC6
     C                   MOVEL     *BLANK        G4RPN6
     C                   ENDIF
     C     G4LVNB        IFLT      '5'
     C                   MOVEL     *BLANK        G4RSC5
     C                   MOVEL     *BLANK        G4RPN5
     C                   ENDIF
     C     G4LVNB        IFLT      '4'
     C                   MOVEL     *BLANK        G4RSC4
     C                   MOVEL     *BLANK        G4RPN4
     C                   ENDIF
     C     G4LVNB        IFLT      '3'
     C                   MOVEL     *BLANK        G4RSC3
     C                   MOVEL     *BLANK        G4RPN3
     C                   ENDIF
     C     G4LVNB        IFLT      '2'
     C                   MOVEL     *BLANK        G4RSC2
     C                   MOVEL     *BLANK        G4RPN2
     C                   ENDIF
 
     C     SDACRCK       CHAIN     SDACRCL1                           99
     C     *IN99         IFEQ      *OFF
     C                   WRITE     MRREPHD0
     C                   ENDIF
 
      /SPACE 5
     C**********************************************************************************
     C     *INZSR        BEGSR
 
     C     SDACRCK       KLIST
     C                   KFLD                    G4RSNO
     C                   KFLD                    G4RSCD
 
     C                   ENDSR
     C**********************************************************************************
