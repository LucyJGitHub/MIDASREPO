     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPREMEMLPD - On-Line Update of Global File GZREMEMLPD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. MD035554 *CREATE   Date 25May16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD035554 - 2o'clock/ABC compatibility                        *
      *                                                               *
      *****************************************************************

O    FGZREMEMLL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZREMEMLPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(REMEMLD0    :W_REMEMLD0     )
O    F                                     USROPN
O
O    D Z_REMEMLPD    E DS                  EXTNAME(GZREMEMLPD)
O    D G_REMEMLPD    E DS                  EXTNAME(GZREMEMLPD) PREFIX(G_)

      * ENTRY PARAMETERS

     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
     C**********         CALLB     '          '
O
O     * Global File Updates
O
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        Z_REMEMLPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_REMEMLPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        GZONE
O
O    C     K_GZREMEMLL1  CHAIN     REMEMLD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    REMEMLD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_REMEMLPD
O    C                   MOVEL     Z_REMEMLPD    G_REMEMLPD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'
     C                   CALLB     'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZREMEMLPD'  I#FILE           10
O    C                   PARM      G_REMEMLPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_REMEMLPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    REMEMLD0
O    C                   ELSE
O    C                   WRITE     W_REMEMLD0
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
O    C                   OPEN      GZREMEMLL1
O    C                   OPEN      GZREMEMLPD
O
O     * Key lists
O
O    C     K_GZREMEMLL1  KLIST
O    C                   KFLD                    GZONE
O    C                   KFLD                    GACNO

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
