     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas OF Individual Forecast')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGLFORITD - On-Line Update of Global File GZGLFORITD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD024003           Date 10Dec13               *
      *  Prev Amend No. CGL145A            Date 08Oct13               *
      *                 CGL145   *CREATE   Date 10Jul13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD024003 - Nostro Summary screen does not display any        *
      *             details (Recompile)                               *
      *  CGL145A - Subsidiaries Daily Sweeping Forecast               *
      *            Recompile due to changes in GLFORITD/GZGLFORITD    *
      *  CGL145 - Subsidiaries Daily Sweeping Forecast                *
      *                                                               *
      *****************************************************************
 
O    FGZGLFORII1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZGLFORITDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(GLFORID0    :W_GLFORID0     )
O    F                                     USROPN
O
O    D Z_GLFORITD    E DS                  EXTNAME(GZGLFORITD)
O    D G_GLFORITD    E DS                  EXTNAME(GZGLFORITD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_GLFORITD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_GLFORITD
O    C                   ENDIF
O
O    C     K_GZGLFORII1  CHAIN     GLFORID0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    GLFORID0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_GLFORITD
O    C                   MOVEL     Z_GLFORITD    G_GLFORITD
O     * Fix Data
     C                   CALLB     'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZGLFORITD'  I#FILE           10
O    C                   PARM      G_GLFORITD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_GLFORITD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    GLFORID0
O    C                   ELSE
O    C                   WRITE     W_GLFORID0
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
O    C                   OPEN      GZGLFORII1
O    C                   OPEN      GZGLFORITD
O
O     * Key lists
O
O    C     K_GZGLFORII1  KLIST
O    C                   KFLD                    IFCUST
O    C                   KFLD                    IFCSAC
O    C                   KFLD                    IFCCY
O    C                   KFLD                    IFNOSC
O    C                   KFLD                    IFDATE
O    C                   KFLD                    IFFACN
O    C                   KFLD                    IFOPTY
O    C                   KFLD                    IFSEQN
 
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
