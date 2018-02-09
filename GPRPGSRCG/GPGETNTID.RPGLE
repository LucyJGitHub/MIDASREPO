     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Get Next Universal Transaction ID')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGETNTID - Get Next Universal Transaction ID                *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGP003  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP003 - Management Limits                                   *
      *           Required to move details of manual transactions     *
      *           to the Global Transactions file.                    *
      *                                                               *
      *****************************************************************
 
     FGPUTNIPD  UF   E             DISK    INFSR(*PSSR)
 
     D/COPY GPCPYSRCG,STD_D_SPEC
 
     C     *ENTRY        PLIST
 
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * OUTPUTS
     C                   PARM                    O#NTID           15 0
 
      * Access the single record in GPUTNIPD
 
     C     1             CHAIN     GPUTNID0                           99
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'NO RECORD IN GPUTNIPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Update
     C                   ADD       1             IDNTID
     C                   UPDATE    GPUTNID0
 
     C                   Z-ADD     IDNTID        O#NTID
 
     C                   RETURN
     C/SPACE 5
      *********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *********************************************************************
     C     *INZSR        BEGSR
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
