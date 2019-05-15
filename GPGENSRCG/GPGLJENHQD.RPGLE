     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGLJENHQD - On-Line Update of Global File GZGLJENHQD        *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL182             Date 11May17               *
      *                 CSC054  *CREATE    Date 23Feb12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL182 - Journal Entry via the Interface File - Java Version *
      *           (Recompile)                                         *
      *  CSC054 - Period End Adjustments                              *
      *                                                               *
      *****************************************************************
 
O    FGZGLJEHQL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZGLJENHQDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(GLJEHQD0    :W_GLJEHQD0     )
O    F                                     USROPN
O
O    D Z_GLJENHQD    E DS                  EXTNAME(GZGLJENHQD)
O    D G_GLJENHQD    E DS                  EXTNAME(GZGLJENHQD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_GLJENHQD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_GLJENHQD
O    C                   ENDIF
O
O    C     K_GZGLJEHQL1  CHAIN     GLJEHQD0                           99
O
O     ** 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    GLJEHQD0
O    C                   ELSE
O
O     ** 'After'
O
O    C                   CLEAR                   G_GLJENHQD
O    C                   MOVEL     Z_GLJENHQD    G_GLJENHQD
O     ** Fix Data
O    C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZGLJENHQD'  I#FILE           10
O    C                   PARM      G_GLJENHQD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_GLJENHQD
O     ** Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    GLJEHQD0
O    C                   ELSE
O    C                   WRITE     W_GLJEHQD0
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
O    C                   OPEN      GZGLJEHQL1
O    C                   OPEN      GZGLJENHQD
O
O     ** Key lists
O
O    C     K_GZGLJEHQL1  KLIST
O    C                   KFLD                    HQBRCD
O    C                   KFLD                    HQBTCH
 
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
