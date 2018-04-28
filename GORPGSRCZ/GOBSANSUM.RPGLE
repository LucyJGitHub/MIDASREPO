     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GO BSPL Analysis File Summary')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOBSANSUM - BSPL Analysis File Summary                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG6789            Date 21Apr05               *
      *  Prev Amend No. CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG6789- Sequence of extract is wrong                        *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     F***GOBSANEPD*I****E*************DISK    INFSR(*PSSR) RENAME(GPBSAND0:BSANIN)           BUG6789
     FGOBSANEPD IP   E           K DISK    INFSR(*PSSR) RENAME(GPBSAND0:BSANIN)              BUG6789
     FGOBSANSPD O    E             DISK    INFSR(*PSSR)
 
 
     IBSANIN        01
     I                                          BRCA          L1
     I                                          CCY           L1
     I                                          ACOD          L1
     I                                          YR            L1
     I                                          PR            L1
     I                                          EPBLDC        L1
     I                                          ANLYSC        L1
 
 
      * Accumulate total
 
     C                   ADD       EPBLAC        SEPBLAC
 
 
      * Write BSPL Analysis record (summary)
 
     CL1                 Z-ADD     SEPBLAC       EPBLAC
     CL1                 MOVEL     I#ZONE        A1ZONE
     CL1                 WRITE     GPBSAND0
     CL1                 Z-ADD     0             SEPBLAC          21 3
 
      /SPACE 5
      ********************************************************************
      * *INZSR - Initial Processing
      ********************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    I#ZONE           10
     C                   ENDSR
      ********************************************************************
      /SPACE 5
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
