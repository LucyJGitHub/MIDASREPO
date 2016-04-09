     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGLACRUTD - On-Line Update of Global File GZGLACRUTD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD024513           Date 23Jan14               *
      *  Prev Amend No. CGL135A   *Create   Date 10Jul13              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD024513 - Add Description field (30A) to the Accounting     *
      *             Rules. (Recompile)                                *
      *  CGL135A - Accounting Rules Process                           *
      *                                                               *
      *****************************************************************
 
O    FGZGLACRUI1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZGLACRUTDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(GLACRUD0    :W_GLACRUD0     )
O    F                                     USROPN
O
O    D Z_GLACRUTD    E DS                  EXTNAME(GZGLACRUTD)
O    D G_GLACRUTD    E DS                  EXTNAME(GZGLACRUTD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_GLACRUTD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_GLACRUTD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        ARZONE
O
O    C     K_GZGLACRUI1  CHAIN     GLACRUD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    GLACRUD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_GLACRUTD
O    C                   MOVEL     Z_GLACRUTD    G_GLACRUTD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'
     C                   CALLB     'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZGLACRUTD'  I#FILE           10
O    C                   PARM      G_GLACRUTD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_GLACRUTD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    GLACRUD0
O    C                   ELSE
O    C                   WRITE     W_GLACRUD0
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
O    C                   OPEN      GZGLACRUI1
O    C                   OPEN      GZGLACRUTD
O
O     * Key lists
O
O    C     K_GZGLACRUI1  KLIST
O    C                   KFLD                    ARUNID
 
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
