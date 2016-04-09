     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSTRANF   - On-Line Update of Global File GZSTRANF          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. AR1096788 *CREATE  Date 18Mar13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1096788 - DLAA details should be written in core STRANF    *
      *              file instead of the new DLSTRANFPD file          *
      *                                                               *
      *****************************************************************
      *
O    FGZSTRANL1 UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSTRANF  O  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(STRANFF     :W_STRANFF      )
O    F                                     USROPN
O     *
O    D Z_STRANF      E DS                  EXTNAME(GZSTRANF  )
O    D G_STRANF      E DS                  EXTNAME(GZSTRANF  ) PREFIX(G_)
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
O    C                   MOVEL     I#BIMG        Z_STRANF
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_STRANF
O    C                   ENDIF
O     *
O    C     K_GZSTRANL1   CHAIN     STRANFF                            99
O     *
O     ** 'Before'
O     *
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    STRANFF
O    C                   ELSE
O     *
O     ** 'After'
O     *
O    C                   CLEAR                   G_STRANF
O    C                   MOVEL     Z_STRANF      G_STRANF
O     ** Fix Data
O    C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSTRANF  '  I#FILE           10
O    C                   PARM      G_STRANF      IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_STRANF
O     ** Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    STRANFF
O    C                   ELSE
O    C                   WRITE     W_STRANFF
O    C                   ENDIF
O    C                   ENDIF
      *
     C                   RETURN
      ********************************************************************
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
O    C                   OPEN      GZSTRANL1
O    C                   OPEN      GZSTRANF
O     *
O     ** Key lists
O     *
O    C     K_GZSTRANL1   KLIST
O    C                   KFLD                    BRCA
O    C                   KFLD                    FLTRNN
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR
      *
     C     W#RUN         IFEQ      *BLANKS
      *
     C                   MOVE      'Y'           W#RUN             1
      *
     C                   MOVEL     '*ERROR'      I#RTCD
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
      *
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
      *
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *********************************************************************
