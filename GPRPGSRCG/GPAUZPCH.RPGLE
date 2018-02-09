     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Audit Purge of Audit Changes')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAUZPCH - Audit Purge of Audit Changes                      *
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
 
     FGPAUCHPD  UP   E           K DISK    INFSR(*PSSR)
     FGPAUCDPD  UF   E           K DISK    INFSR(*PSSR)
 
      * Delete detail
 
     C                   EXSR      DLT_DETAIL
 
      * Delete header
 
     C                   EXSR      DLT_HEADER
 
     C/SPACE 5
      ****************************************************************
      * Delete detail
      ****************************************************************
     C     DLT_DETAIL    BEGSR
 
     C     GPAUCDK       SETLL     GPAUCDD0
     C     GPAUCDK       READE     GPAUCDD0                               99    *
     C     *IN99         DOWEQ     '0'
     C                   DELETE    GPAUCDD0
     C     GPAUCDK       READE     GPAUCDD0                               99    *
     C                   ENDDO
 
     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Delete header
      ****************************************************************
     C     DLT_HEADER    BEGSR
 
     C                   DELETE    GPAUCHD0
 
     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
      * key list
     C     GPAUCDK       KLIST
     C                   KFLD                    AHZONE
     C                   KFLD                    AHCID
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
