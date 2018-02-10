/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MR Update Reporting Hierarchies File - 2')
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting Module                           *
      *                                                               *
      *  MR000056 -  Update Reporting Hierarchies file - 2            *
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
 
     FMRREPHPD  IP   E             DISK    RENAME(MRREPHD0:MRREPHDI)
     FMRREPHL1  UF   E           K DISK
 
     D MRREPH        E DS                  EXTNAME(MRREPHPD)
     D  LV1                  283    322
 
     D                 DS
     D N_LV1                   1     40
     D N_LV1Ar                 1     40    DIM(20)
 
     IMRREPHDI
     I                                          G4RSNO        L1
 
     C   L1              EXSR      UPD_FACTORS
      /SPACE 5
     C**********************************************************************************
     C     UPD_FACTORS   BEGSR
     C     MRREPHK       SETLL     MRREPHD0
     C     MRREPHK       READE     MRREPHD0                               99
     C                   Z-ADD     1             X                 3 0
     C                   MOVEL     *BLANK        P_G4RSC2         10
     C     *IN99         DOWEQ     *OFF
 
     C     G4RSC2        IFNE      P_G4RSC2
     C                   MOVE      *ZEROS        N_LV1
     C     X             IFLE      20
     C                   MOVEL     '01'          N_LV1Ar(X)
     C                   ADD       1             X
     C                   ENDIF
     C                   ENDIF
     C                   MOVEL     G4RSC2        P_G4RSC2
 
     C                   MOVEL     N_LV1         LV1
     C                   UPDATE    MRREPHD0
 
     C     MRREPHK       READE     MRREPHD0                               99
     C                   ENDDO
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     *INZSR        BEGSR
 
     C     MRREPHK       KLIST
     C                   KFLD                    G4RSNO
 
     C                   ENDSR
     C**********************************************************************************
