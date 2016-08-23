     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPCLONCLQD - On-Line Update of Global File GZCLONCLQD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      *  Prev Amend No. CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
 
O    FGZCLONCQL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZCLONCLQDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(CLONLQD0    :W_CLONLQD0     )
O    F                                     USROPN
O
O    D Z_CLONCLQD    E DS                  EXTNAME(GZCLONCLQD)
O    D G_CLONCLQD    E DS                  EXTNAME(GZCLONCLQD) PREFIX(G_)
 
      ** Entry Parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
O
O     ** Global File Updates
O
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        Z_CLONCLQD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_CLONCLQD
O    C                   ENDIF
O
O    C     K_GZCLONCQL1  CHAIN     CLONLQD0                           99
O
O     ** 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    CLONLQD0
O    C                   ELSE
O
O     ** 'After'
O
O    C                   CLEAR                   G_CLONCLQD
O    C                   MOVEL     Z_CLONCLQD    G_CLONCLQD
O
O     ** Fix Data
O
O    C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZCLONCLQD'  I#FILE           10
O    C                   PARM      G_CLONCLQD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_CLONCLQD
O
O     ** Update
O
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    CLONLQD0
O    C                   ELSE
O    C                   WRITE     W_CLONLQD0
O    C                   ENDIF
O    C                   ENDIF
 
     C                   RETURN
 
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
O
O     ** Open for commit?
O
O    C                   CALL      'GPCOPN4COM'
O    C                   PARM                    D_COM             1
O    C                   OPEN      GZCLONCQL1
O    C                   OPEN      GZCLONCLQD
O
O     ** Key lists
O
O    C     K_GZCLONCQL1  KLIST
O    C                   KFLD                    LQLNRF
O    C                   KFLD                    LQBRCA
 
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
 
      ** If no identified cause of error
 
     C     I#ERMS        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'UNEXPECTED ERROR'
     C                   ENDIF
 
      ** Log an error on the error log
 
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = I#ERMS
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER         4000
 
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
