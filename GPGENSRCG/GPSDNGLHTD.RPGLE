     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDNGLHTD - On-Line Update of Global File GZSDNGLHTD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CGL155   *Create   Date 18Mar14               *
      *  Prev Amend No. xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL155 - Forecast Group Limits                               *
      *                                                               *
      *****************************************************************
 
O    FGZSDNGLHI1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDNGLHTDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDNGLHD0    :W_SDNGLHD0     )
O    F                                     USROPN
O
O    D Z_SDNGLHTD    E DS                  EXTNAME(GZSDNGLHTD)
O    D G_SDNGLHTD    E DS                  EXTNAME(GZSDNGLHTD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_SDNGLHTD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDNGLHTD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        NGZONE
O
O    C     K_GZSDNGLHI1  CHAIN     SDNGLHD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDNGLHD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDNGLHTD
O    C                   MOVEL     Z_SDNGLHTD    G_SDNGLHTD
O     * Fix Data
     C                   CALLB     'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDNGLHTD'  I#FILE           10
O    C                   PARM      G_SDNGLHTD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDNGLHTD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDNGLHD0
O    C                   ELSE
O    C                   WRITE     W_SDNGLHD0
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
O    C                   OPEN      GZSDNGLHI1
O    C                   OPEN      GZSDNGLHTD
O
O     * Key lists
O
O    C     K_GZSDNGLHI1  KLIST
O    C                   KFLD                    NGZONE
O    C                   KFLD                    NGGRPC
 
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
