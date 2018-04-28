     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDJACCPD - On-Line Update of Global File GZSDJACCPD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER048  *CREATE    Date 06Jan09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Features - Taxes                             *
      *                                                               *
      *****************************************************************
 
O    FGZSDJACCL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDJACCPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDJACCD0    :W_SDJACCD0     )
O    F                                     USROPN
O
O    D Z_SDJACCPD    E DS                  EXTNAME(GZSDJACCPD)
O    D G_SDJACCPD    E DS                  EXTNAME(GZSDJACCPD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_SDJACCPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDJACCPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        JCZONE
O
O    C     K_GZSDJACCL1  CHAIN     SDJACCD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDJACCD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDJACCPD
O    C                   MOVEL     Z_SDJACCPD    G_SDJACCPD
O     * Fix Data
O    C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDJACCPD'  I#FILE           10
O    C                   PARM      G_SDJACCPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDJACCPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDJACCD0
O    C                   ELSE
O    C                   WRITE     W_SDJACCD0
O    C                   ENDIF
O    C                   ENDIF
 
     C                   RETURN
 
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
O    C                   OPEN      GZSDJACCL1
O    C                   OPEN      GZSDJACCPD
O
O     * Key lists
O
O    C     K_GZSDJACCL1  KLIST
O    C                   KFLD                    JCZONE
O    C                   KFLD                    JCJANO
O    C                   KFLD                    JCCUST
O    C                   KFLD                    JCNAHO
 
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
