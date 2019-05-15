     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDNGLDTD - On-Line Update of Global File GZSDNGLDTD        *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL155  *CREATE    Date 18Mar14               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL155 - Forecast Group Limits                               *
      *                                                               *
      *****************************************************************
 
O    FGZSDNGLDI1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDNGLDTDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDNGLDD0    :W_SDNGLDD0     )
O    F                                     USROPN
O
O    D Z_SDNGLDTD    E DS                  EXTNAME(GZSDNGLDTD)
O    D G_SDNGLDTD    E DS                  EXTNAME(GZSDNGLDTD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_SDNGLDTD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDNGLDTD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        NCZONE
O
O    C     K_GZSDNGLDI1  CHAIN     SDNGLDD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDNGLDD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDNGLDTD
O    C                   MOVEL     Z_SDNGLDTD    G_SDNGLDTD
O     * Fix Data
     C                   CALLB     'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDNGLDTD'  I#FILE           10
O    C                   PARM      G_SDNGLDTD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDNGLDTD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDNGLDD0
O    C                   ELSE
O    C                   WRITE     W_SDNGLDD0
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
O    C                   OPEN      GZSDNGLDI1
O    C                   OPEN      GZSDNGLDTD
O
O     * Key lists
O
O    C     K_GZSDNGLDI1  KLIST
O    C                   KFLD                    NCZONE
O    C                   KFLD                    NCGRPC
O    C                   KFLD                    NCNCCY
O    C                   KFLD                    NCNOSC
 
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
