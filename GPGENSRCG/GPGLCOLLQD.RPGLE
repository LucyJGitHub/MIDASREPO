     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGLCOLLQD - GL Collateral Details Extension                 *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG27973 *CREATE   Date 06Aug10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27973 - No section for Blocked Collateral                 *
      *                                                               *
      *****************************************************************
 
O    FGZGLCOLQL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZGLCOLLQDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(GLCOLQD0    :W_GLCOLQD0     )
O    F                                     USROPN
O
O    D Z_GLCOLLQD    E DS                  EXTNAME(GZGLCOLLQD)
O    D G_GLCOLLQD    E DS                  EXTNAME(GZGLCOLLQD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_GLCOLLQD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_GLCOLLQD
O    C                   ENDIF
O
O    C     K_GZGLCOLQL1  CHAIN     GLCOLQD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    GLCOLQD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_GLCOLLQD
O    C                   MOVEL     Z_GLCOLLQD    G_GLCOLLQD
O     * Fix Data
O    C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZGLCOLLQD'  I#FILE           10
O    C                   PARM      G_GLCOLLQD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_GLCOLLQD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    GLCOLQD0
O    C                   ELSE
O    C                   WRITE     W_GLCOLQD0
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
O    C                   OPEN      GZGLCOLQL1
O    C                   OPEN      GZGLCOLLQD
O
O     * Key lists
O
O    C     K_GZGLCOLQL1  KLIST
O    C                   KFLD                    CDXBRC
O    C                   KFLD                    CDXREF
 
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
