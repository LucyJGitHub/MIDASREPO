     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDEERTTD - On-Line Update of Global File GZSDEERTTD        *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL159             Date 27Aug14               *
      *                 CGL153  *CREATE    Date 05Feb14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL159 - Optimisation of Cash Positions (Recompile)          *
      *  CGL153 - Bank Position Report                                *
      *                                                               *
      *****************************************************************
 
O    FGZSDEERTI1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDEERTTDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDEERTD0    :W_SDEERTD0     )
O    F                                     USROPN
O
O    D Z_SDEERTTD    E DS                  EXTNAME(GZSDEERTTD)
O    D G_SDEERTTD    E DS                  EXTNAME(GZSDEERTTD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_SDEERTTD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDEERTTD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        ERZONE
O
O    C     K_GZSDEERTI1  CHAIN     SDEERTD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDEERTD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDEERTTD
O    C                   MOVEL     Z_SDEERTTD    G_SDEERTTD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'
     C                   CALLB     'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDEERTTD'  I#FILE           10
O    C                   PARM      G_SDEERTTD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDEERTTD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDEERTD0
O    C                   ELSE
O    C                   WRITE     W_SDEERTD0
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
O    C                   OPEN      GZSDEERTI1
O    C                   OPEN      GZSDEERTTD
O
O     * Key lists
O
O    C     K_GZSDEERTI1  KLIST
O    C                   KFLD                    ERZONE
O    C                   KFLD                    ERCUST
O    C                   KFLD                    ERCCY
O    C                   KFLD                    ERNOSC
O    C                   KFLD                    ERTCCY
O    C                   KFLD                    ERDATE
O    C                   KFLD                    ERTMST
 
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
