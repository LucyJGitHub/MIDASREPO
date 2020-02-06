     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDOPESPD - On-Line Update of Global File GZSDOPESPD        *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT045  *CREATE    Date 04Aug11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT045 - Outgoing Payments - Extended Settlement Instructions*
      *                                                               *
      *****************************************************************
 
O    FGZSDOPESL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDOPESPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDOPESD0    :W_SDOPESD0     )
O    F                                     USROPN
O
O    D Z_SDOPESPD    E DS                  EXTNAME(GZSDOPESPD)
O    D G_SDOPESPD    E DS                  EXTNAME(GZSDOPESPD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_SDOPESPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDOPESPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        ESZONE
O
O    C     K_GZSDOPESL1  CHAIN     SDOPESD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDOPESD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDOPESPD
O    C                   MOVEL     Z_SDOPESPD    G_SDOPESPD
O     * Fix Data
O    C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDOPESPD'  I#FILE           10
O    C                   PARM      G_SDOPESPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDOPESPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDOPESD0
O    C                   ELSE
O    C                   WRITE     W_SDOPESD0
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
O    C                   OPEN      GZSDOPESL1
O    C                   OPEN      GZSDOPESPD
O
O     * Key lists
O
O    C     K_GZSDOPESL1  KLIST
O    C                   KFLD                    ESZONE
O    C                   KFLD                    ESESIN
 
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
