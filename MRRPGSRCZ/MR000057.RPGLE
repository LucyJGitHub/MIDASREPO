/*XBIA*: OVRDBF FILE(MRDSBDL1I) TOFILE(MRDSBDL1) SHARE(*NO)         : *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MR Update Date Schedule Bucket Hierarchy')
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting Module                           *
      *                                                               *
      *  MR000057 -  Update Date Schedule Bucket Hierarchy file       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CMR001             Date 01Sep04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMR001 - MidasPlus Reporting                                 *
      *                                                               *
      *****************************************************************
 
     FMRDSBDL1I IP   E           K DISK    RENAME(MRDSBDD0:MRDSBDDI)
     FMRDSBDL1  IF   E           K DISK
     FMRDSBHPD  O    E             DISK
 
     D MRDSBH        E DS                  EXTNAME(MRDSBHPD)
     D  DTS                   12     51
 
     D                 DS
     D N_DTS                   1     40
     D N_DTSAr                 1     40    DIM(20)
 
     IMRDSBDDI
     I                                          DSSCHD        L1
 
     C   L1              EXSR      UPD_FACTORS
      /SPACE 5
     C**********************************************************************************
     C     UPD_FACTORS   BEGSR
     C     MRDSBDK       SETLL     MRDSBDD0
     C     MRDSBDK       READE     MRDSBDD0                               99
     C                   Z-ADD     1             X                 3 0
     C     *IN99         DOWEQ     *OFF
 
     C                   MOVE      *ZEROS        N_DTS
     C     X             IFLE      20
     C                   MOVEL     '01'          N_DTSAr(X)
     C                   ADD       1             X
     C                   ENDIF
 
     C                   MOVEL     N_DTS         DTS
     C                   WRITE     MRDSBHD0
 
     C     MRDSBDK       READE     MRDSBDD0                               99
     C                   ENDDO
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     *INZSR        BEGSR
 
     C     MRDSBDK       KLIST
     C                   KFLD                    DSSCHD
 
     C                   ENDSR
     C**********************************************************************************
