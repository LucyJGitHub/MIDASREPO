     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPLEFCAMQD - On-Line Update of Global File GZLEFCAMQD        *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. CLE138   *CREATE   Date 02Nov21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE138 - Class Codes for Facilities                          *
      *                                                               *
      *****************************************************************

     FGZLEFCAQL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
     F                                     USROPN
     FGZLEFCAMQDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
     F                                     RENAME(LEFCAQD0    :W_LEFCAQD0     )
     F                                     USROPN

     D Z_LEFCAMQD    E DS                  EXTNAME(GZLEFCAMQD)
     D G_LEFCAMQD    E DS                  EXTNAME(GZLEFCAMQD) PREFIX(G_)

      ** ENTRY PARAMETERS

     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000

      ** Global File Updates

     C     I#BFAF        IFEQ      'B'
     C                   MOVEL     I#BIMG        Z_LEFCAMQD
     C                   ELSE
     C                   MOVEL     I#AIMG        Z_LEFCAMQD
     C                   ENDIF

     C     K_GZLEFCAQL1  CHAIN     LEFCAQD0                           99

      ** 'Before'

     C     I#BFAF        IFEQ      'B'
     C  N99              DELETE    LEFCAQD0
     C                   ELSE

      ** 'After'

     C                   CLEAR                   G_LEFCAMQD
     C                   MOVEL     Z_LEFCAMQD    G_LEFCAMQD
      ** Fix Data
     C                   CALLB     'GPFIXGDTA'
     C                   PARM                    I#ZONE
     C                   PARM      'GZLEFCAMQD'  I#FILE           10
     C                   PARM      G_LEFCAMQD    IO#BUFFER      4000
     C                   MOVEL     IO#BUFFER     G_LEFCAMQD
      ** Update
     C     *IN99         IFEQ      *OFF
     C                   UPDATE    LEFCAQD0
     C                   ELSE
     C                   WRITE     W_LEFCAQD0
     C                   ENDIF
     C                   ENDIF

     C                   RETURN

     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR

      ** Open for commit?

     C                   CALL      'GPCOPN4COM'
     C                   PARM                    D_COM             1
     C                   OPEN      GZLEFCAQL1
     C                   OPEN      GZLEFCAMQD

      ** Key lists

     C     K_GZLEFCAQL1  KLIST
     C                   KFLD                    FABRCA
     C                   KFLD                    FACNUM
     C                   KFLD                    FAFTYP
     C                   KFLD                    FAFCNO

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
