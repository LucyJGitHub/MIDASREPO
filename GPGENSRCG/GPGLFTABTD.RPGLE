     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGLFTABTD - On-Line Update of Global File GZGLFTABTD        *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL145B *CREATE    Date 30Oct13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL145B - Subsidiaries Daily Sweeping Forecast               *
      *                                                               *
      *****************************************************************
 
O    FGZGLFTABI1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZGLFTABTDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(GLFTABD0    :W_GLFTABD0     )
O    F                                     USROPN
O
O    D Z_GLFTABTD    E DS                  EXTNAME(GZGLFTABTD)
O    D G_GLFTABTD    E DS                  EXTNAME(GZGLFTABTD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_GLFTABTD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_GLFTABTD
O    C                   ENDIF
O
O    C     K_GZGLFTABI1  CHAIN     GLFTABD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    GLFTABD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_GLFTABTD
O    C                   MOVEL     Z_GLFTABTD    G_GLFTABTD
O     * Fix Data
     C                   CALLB     'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZGLFTABTD'  I#FILE           10
O    C                   PARM      G_GLFTABTD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_GLFTABTD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    GLFTABD0
O    C                   ELSE
O    C                   WRITE     W_GLFTABD0
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
O    C                   OPEN      GZGLFTABI1
O    C                   OPEN      GZGLFTABTD
O
O     * Key lists
O
O    C     K_GZGLFTABI1  KLIST
O    C                   KFLD                    FBBRCA
O    C                   KFLD                    FBCNUM
O    C                   KFLD                    FBCCY
O    C                   KFLD                    FBACOD
O    C                   KFLD                    FBACSQ
 
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
