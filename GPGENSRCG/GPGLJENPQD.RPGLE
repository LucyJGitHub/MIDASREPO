     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGLJENPQD - On-Line Update of Global File GZGLJENPQD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. AR1005162          Date 16Jul12               *
      *  Prev Amend No. CSC054  *CREATE    Date 23Feb12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1005162 - Base ccy exchange rate in corrective batch has   *
      *              incorrect number of decimal places (Recompile)   *
      *  CSC054 - Period End Adjustments                              *
      *                                                               *
      *****************************************************************
 
O    FGZGLJEPQL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZGLJENPQDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(GLJEPQD0    :W_GLJEPQD0     )
O    F                                     USROPN
O
O    D Z_GLJENPQD    E DS                  EXTNAME(GZGLJENPQD)
O    D G_GLJENPQD    E DS                  EXTNAME(GZGLJENPQD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_GLJENPQD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_GLJENPQD
O    C                   ENDIF
O
O    C     K_GZGLJEPQL1  CHAIN     GLJEPQD0                           99
O
O     ** 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    GLJEPQD0
O    C                   ELSE
O
O     ** 'After'
O
O    C                   CLEAR                   G_GLJENPQD
O    C                   MOVEL     Z_GLJENPQD    G_GLJENPQD
O     ** Fix Data
O    C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZGLJENPQD'  I#FILE           10
O    C                   PARM      G_GLJENPQD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_GLJENPQD
O     ** Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    GLJEPQD0
O    C                   ELSE
O    C                   WRITE     W_GLJEPQD0
O    C                   ENDIF
O    C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * *INZSR - Initial subroutine called automatically at pgm start
      *****************************************************************
     C     *INZSR        BEGSR
O
O     ** Open for commit?
O
O    C                   CALL      'GPCOPN4COM'
O    C                   PARM                    D_COM             1
O    C                   OPEN      GZGLJEPQL1
O    C                   OPEN      GZGLJENPQD
O
O     ** Key lists
O
O    C     K_GZGLJEPQL1  KLIST
O    C                   KFLD                    IQBRCD
O    C                   KFLD                    IQBTCH
O    C                   KFLD                    IQBITM
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *****************************************************************
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
      *****************************************************************
