     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDFCSDTD - On-Line Update of Global File GZSDFCSDTD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CGL145A  *CREATE   Date 08Oct13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL145A - Subsidiaries Daily Sweeping Forecast               *
      *                                                               *
      *****************************************************************
 
O    FGZSDFCSDI1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDFCSDTDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDFCSDD0    :W_SDFCSDD0     )
O    F                                     USROPN
O
O    D Z_SDFCSDTD    E DS                  EXTNAME(GZSDFCSDTD)
O    D G_SDFCSDTD    E DS                  EXTNAME(GZSDFCSDTD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_SDFCSDTD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDFCSDTD
O    C                   ENDIF
O
O    C     K_GZSDFCSDI1  CHAIN     SDFCSDD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDFCSDD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDFCSDTD
O    C                   MOVEL     Z_SDFCSDTD    G_SDFCSDTD
O     * Fix Data
     C                   CALLB     'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDFCSDTD'  I#FILE           10
O    C                   PARM      G_SDFCSDTD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDFCSDTD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDFCSDD0
O    C                   ELSE
O    C                   WRITE     W_SDFCSDD0
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
O    C                   OPEN      GZSDFCSDI1
O    C                   OPEN      GZSDFCSDTD
O
O     * Key lists
O
O    C     K_GZSDFCSDI1  KLIST
O    C                   KFLD                    FCCUST
O    C                   KFLD                    FCCSRC
O    C                   KFLD                    FCCURR
O    C                   KFLD                    FCNOTR
 
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
