     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*S*D****RPGBASEBNC****************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDBRCHX0 - On-Line Update of Global File GZSDBRCHX0        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL052             Date 02Dec15               *
      *                 CGP017             Date 06Aug12               *
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL052 - Amend Washout Processing                            *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  BUG10215 - Global replication needs a global interface       *
      *                                                               *
      *****************************************************************
 
O    FGZSDBRX0L1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDBRCHX0O  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDBRCHF0    :W_SDBRCHF0     )
O    F                                     USROPN
O
O    D Z_SDBRCHX0    E DS                  EXTNAME(GZSDBRCHX0)
O    D G_SDBRCHX0    E DS                  EXTNAME(GZSDBRCHX0) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_SDBRCHX0
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDBRCHX0
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        A8ZONE
O
O    C     K_GZSDBRX0L1  CHAIN     SDBRCHF0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDBRCHF0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDBRCHX0
O    C                   MOVEL     Z_SDBRCHX0    G_SDBRCHX0
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'
     C                   CALLB     'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDBRCHX0'  I#FILE           10
O    C                   PARM      G_SDBRCHX0    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDBRCHX0
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDBRCHF0
O    C                   ELSE
O    C                   WRITE     W_SDBRCHF0
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
O    C                   OPEN      GZSDBRX0L1
O    C                   OPEN      GZSDBRCHX0
O
O     * Key lists
O
O    C     K_GZSDBRX0L1  KLIST
O    C                   KFLD                    A8ZONE
O    C                   KFLD                    A8BRCD
 
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
