     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDARCHPD - On-Line Update of Global File GZSDARCHPD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD026274           Date 10Apr14               *
      *  Prev Amend No. CSD092   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD026274 - Previous comment is not recorded in comment       *
      *             history                                           *
      *  CSD092 - Account Review                                      *
      *                                                               *
      *****************************************************************
 
O    FGZSDARCHL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDARCHPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDARCHD0    :W_SDARCHD0     )
O    F                                     USROPN
O
O    D Z_SDARCHPD    E DS                  EXTNAME(GZSDARCHPD)
O    D G_SDARCHPD    E DS                  EXTNAME(GZSDARCHPD) PREFIX(G_)
 
      ** ENTRY PARAMETERS
 
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
O    C                   MOVEL     I#BIMG        Z_SDARCHPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDARCHPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        AHZONE
O
O    C     K_GZSDARCHL1  CHAIN     SDARCHD0                           99
O
O     ** 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDARCHD0
O    C                   ELSE
O
O     ** 'After'
O
O    C                   CLEAR                   G_SDARCHPD
O    C                   MOVEL     Z_SDARCHPD    G_SDARCHPD
O     ** Fix Data
O    C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDARCHPD'  I#FILE           10
O    C                   PARM      G_SDARCHPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDARCHPD
O     ** Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDARCHD0
O    C                   ELSE
O    C                   WRITE     W_SDARCHD0
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
O    C                   OPEN      GZSDARCHL1
O    C                   OPEN      GZSDARCHPD
O
O     ** Key lists
O
O    C     K_GZSDARCHL1  KLIST
O    C                   KFLD                    AHZONE
O    C                   KFLD                    AHCUST
O    C                   KFLD                    AHSCDT
O    C                   KFLD                    AHSEQN
O    C                   KFLD                    AHCDAT
     C                   KFLD                    AHCTIM                                     MD026274
 
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
      *********************************************************************
