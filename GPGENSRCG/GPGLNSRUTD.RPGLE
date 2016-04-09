     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGLNSRUTD - On-Line Update of Global File GZGLNSRUTD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD033486           Date 27Feb15               *
      *  Prev Amend No. MD031974           Date 16Jan15               *
      *                 CGL158   *Create   Date 22Aug14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD033486 - Add new Beneficiary Account field (Recompile)     *
      *  MD031974 - Failed COB Component GOC0100 seq 002234 due to    *
      *             field mismatch. (Recompile)                       *
      *  CGL158 - Nostro Sweeping Rules Maintenance                   *
      *                                                               *
      *****************************************************************
 
O    FGZGLNSRUI1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZGLNSRUTDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(GLNSRUD0    :W_GLNSRUD0     )
O    F                                     USROPN
O
O    D Z_GLNSRUTD    E DS                  EXTNAME(GZGLNSRUTD)
O    D G_GLNSRUTD    E DS                  EXTNAME(GZGLNSRUTD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_GLNSRUTD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_GLNSRUTD
O    C                   ENDIF
O
O    C     K_GZGLNSRUI1  CHAIN     GLNSRUD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    GLNSRUD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_GLNSRUTD
O    C                   MOVEL     Z_GLNSRUTD    G_GLNSRUTD
O     * Fix Data
     C                   CALLB     'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZGLNSRUTD'  I#FILE           10
O    C                   PARM      G_GLNSRUTD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_GLNSRUTD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    GLNSRUD0
O    C                   ELSE
O    C                   WRITE     W_GLNSRUD0
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
O    C                   OPEN      GZGLNSRUI1
O    C                   OPEN      GZGLNSRUTD
O
O     * Key lists
O
O    C     K_GZGLNSRUI1  KLIST
O    C                   KFLD                    NSBNBR
O    C                   KFLD                    NSCCY
O    C                   KFLD                    NSBNOC
O    C                   KFLD                    NSSLVL
 
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
