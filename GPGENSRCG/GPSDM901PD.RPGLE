     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2017')
/*STD ***RPGBASEBNC****************************************************
      *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDM901PD - On-Line Update of Global File GZSDM901PD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2017            *
      *                                                               *
      *  Last Amend No. CFT162  *Create    Date 05Sep17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT162 - MT900 and MT910 Message Generation                  *
      *                                                               *
      *****************************************************************

     FGZSDM901L1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
     F                                     USROPN
     FGZSDM901PDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
     F                                     RENAME(SDM901D0    :W_SDM901D0     )
     F                                     USROPN

     D Z_SDM901PD    E DS                  EXTNAME(GZSDM901PD)
     D G_SDM901PD    E DS                  EXTNAME(GZSDM901PD) PREFIX(G_)

      * ENTRY PARAMETERS

     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000

      * Global File Updates

     C     I#BFAF        IFEQ      'B'
     C                   MOVEL     I#BIMG        Z_SDM901PD
     C                   ELSE
     C                   MOVEL     I#AIMG        Z_SDM901PD
     C                   ENDIF
     C                   MOVEL     I#ZONE        M9ZONE

     C     K_GZSDM901L1  CHAIN     SDM901D0                           99

      * 'Before'

     C     I#BFAF        IFEQ      'B'
     C  N99              DELETE    SDM901D0
     C                   ELSE

      * 'After'

     C                   CLEAR                   G_SDM901PD
     C                   MOVEL     Z_SDM901PD    G_SDM901PD
      * Fix Data
     C                   CALLB     'GPFIXGDTA'
     C                   PARM                    I#ZONE
     C                   PARM      'GZSDM901PD'  I#FILE           10
     C                   PARM      G_SDM901PD    IO#BUFFER      4000
     C                   MOVEL     IO#BUFFER     G_SDM901PD
      * Update
     C     *IN99         IFEQ      *OFF
     C                   UPDATE    SDM901D0
     C                   ELSE
     C                   WRITE     W_SDM901D0
     C                   ENDIF
     C                   ENDIF

     C                   RETURN

     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR

      * Open for commit?

     C                   CALL      'GPCOPN4COM'
     C                   PARM                    D_COM             1
     C                   OPEN      GZSDM901L1
     C                   OPEN      GZSDM901PD

      * Key lists

     C     K_GZSDM901L1  KLIST
     C                   KFLD                    M9ZONE
     C                   KFLD                    M9CNUM
     C                   KFLD                    M9CCY
     C                   KFLD                    M9ACOD
     C                   KFLD                    M9ACSQ
     C                   KFLD                    M9BRCD

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
