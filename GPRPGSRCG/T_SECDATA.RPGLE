     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Global Action Codes Trigger Program')         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  T_SECDATA - On-Line Update of Global File T_SECDATA          *
      *             - Trigger program for GPMACBRDD                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CBF005             Date 16Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BG7655  *CREATE    Date 22Jun05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *           Profile (Recompile)                                 *
      *  BG7655 - Rework bug 6438, rename from GPMACBRDD              *
      *           Also rename T_SECDATL1 to GPSECDL1 (see bug 7390)   *
      *                                                               *
      *****************************************************************
 
     FGPSECDL1  UF A E           K DISK    INFSR(*PSSR) COMMIT(D_COM)
     F                                     USROPN
 
     D G_GPMACBRDD   E DS                  EXTNAME(GPMACBRDD)
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
 
      * Global File Updates
     C     I#BFAF        IFEQ      'B'
     C                   MOVEL     I#BIMG        G_GPMACBRDD
     C                   ELSE
     C                   MOVEL     I#AIMG        G_GPMACBRDD
     C                   ENDIF
 
      * Use USRP from GPMACBRDD to get position on T_SECDATA
     C
     C                   MOVE      USRP          KUSER            10
     C     KUSER         SETLL     GPSECDL1                           99
     C*
     C     KUSER         READE     GPSECDL1                               98
     C*
     C     *IN98         DOWEQ     '0'
     C                   DELETE    GPSECDL1
     C     KUSER         READE     GPSECDL1                               98
     C                   ENDDO
 
     C                   RETURN
 
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Open for commit?
     C                   CALL      'GPCOPN4COM'
     C                   PARM                    D_COM             1
     C                   OPEN      GPSECDL1
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR
 
     C     W#RUN         IFEQ      *BLANKS
 
     C                   MOVE      'Y'           W#RUN             1
 
     C                   MOVEL     '*ERROR'      I#RTCD
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
 
     C                   DUMP
      *
      * If no identified cause of error
      *
     C     I#ERMS        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'UNEXPECTED ERROR'
     C                   ENDIF
      *
      * Log an error on the error log
      *
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = I#ERMS
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER         4000
 
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
