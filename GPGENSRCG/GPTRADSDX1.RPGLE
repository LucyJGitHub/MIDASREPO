     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPTRADSDX1 - On-Line Update of Global File GZTRADSDX1        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. AR1048651 *CREATE  Date 07Feb113              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1048651 - TRADSDX1 global replication (Child:AR1048654)    *
      *                                                               *
      *****************************************************************
 
O    FGZTRADSDL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZTRADSDX1O  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(TRADSDD1    :W_TRADSDD1     )
O    F                                     USROPN
O
O    D Z_TRADSDX1    E DS                  EXTNAME(GZTRADSDX1)
O    D G_TRADSDX1    E DS                  EXTNAME(GZTRADSDX1) PREFIX(G_)
      *
      ** ENTRY PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
O     *
O     ** Global File Updates
O     *
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        Z_TRADSDX1
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_TRADSDX1
O    C                   ENDIF
O
O    C     K_GZTRADSDL1  CHAIN     TRADSDD1                           99
O     *
O     ** 'Before'
O     *
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    TRADSDD1
O    C                   ELSE
O     *
O     ** 'After'
O     *
O    C                   CLEAR                   G_TRADSDX1
O    C                   MOVEL     Z_TRADSDX1    G_TRADSDX1
      *
O     ** Fix Data
      *
O    C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZTRADSDX1'  I#FILE           10
O    C                   PARM      G_TRADSDX1    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_TRADSDX1
      *
O     ** Update
      *
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    TRADSDD1
O    C                   ELSE
O    C                   WRITE     W_TRADSDD1
O    C                   ENDIF
O    C                   ENDIF
 
     C                   RETURN
 
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
O     *
O     ** Open for commit?
O     *
O    C                   CALL      'GPCOPN4COM'
O    C                   PARM                    D_COM             1
O    C                   OPEN      GZTRADSDL1
O    C                   OPEN      GZTRADSDX1
O     *
O     ** Key lists
O     *
O    C     K_GZTRADSDL1  KLIST
O    C                   KFLD                    T1TDRF
O    C                   KFLD                    T1WHEN
 
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
      ** If no identified cause of error
      *
     C     I#ERMS        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'UNEXPECTED ERROR'
     C                   ENDIF
      *
      ** Log an error on the error log
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
