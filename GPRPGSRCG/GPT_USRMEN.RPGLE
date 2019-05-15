     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP User to Menu Config Trigger Program')         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPT_USRMEN - On-Line Update of Global File T_SECDATA         *
      *             - Trigger program for T_USERMENU                  *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CBF005             Date 16Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BG7390             Date 31May05               *
      *                 BUG4241 *CREATE    Date 24Nov04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *           Profile (Recompile)                                 *
      *  BG7390 - Rename T_SECDATL1                                   *
      *  BUG4241- Triggers for T_SECDATA file                         *
      *                                                               *
      *****************************************************************
 
O    F***T_SECDATL1UF A E           K DISK    INFSR(*PSSR) COMMIT(D_COM)                      BG7390
O    FGPSECDL1  UF A E           K DISK    INFSR(*PSSR) COMMIT(D_COM)                         BG7390
O    F                                     USROPN
O
O    D G_T_USERMENU  E DS                  EXTNAME(T_USERMENU)
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
O
O     * Global File Updates
O
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        G_T_USERMENU
O    C                   ELSE
O    C                   MOVEL     I#AIMG        G_T_USERMENU
O    C                   ENDIF
O
      * Use MUSERNAME from T_USERMENU to get position on T_SECDATA
     C
     C                   MOVEL     MUSERNAME     KUSER            10
     C     KUSER         SETLL     GPSECDL1                           99                      BG7390
      *                                                                                       BG7390
     C     KUSER         READE     GPSECDL1                               98                  BG7390
      *                                                                                       BG7390
     C     *IN98         DOWEQ     '0'                                                        BG7390
     C                   DELETE    GPSECDL1                                                   BG7390
     C     KUSER         READE     GPSECDL1                               98                  BG7390
      *                                                                                       BG7390
     C*****KUSER         SETLL     T_SECDATL1                         99                      BG7390
     C******                                                                                  BG7390
     C*****KUSER         READE     T_SECDATL1                             98                  BG7390
     C******                                                                                  BG7390
     C******IN98         DOWEQ     '0'                                                        BG7390
     C******             DELETE    T_SECDATL1                                                 BG7390
     C*****KUSER         READE     T_SECDATL1                             98                  BG7390
     C                   ENDDO
 
     C                   RETURN
O
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
O
O     * Open for commit?
O
O    C                   CALL      'GPCOPN4COM'
O    C                   PARM                    D_COM             1
     C                   OPEN      GPSECDL1                                                   BG7390
     C******             OPEN      T_SECDATL1                                                 BG7390
 
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
