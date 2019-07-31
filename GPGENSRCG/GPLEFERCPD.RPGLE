     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPLEFERCPD - On-Line Update of Global File GZLEFERCPD        *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. CLE071  *CREATE    Date 18Jul18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE071 - Value Dating of Rate Changes to Fees                *
      *                                                               *
      *****************************************************************

     FGZLEFERCL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
     F                                     USROPN
     FGZLEFERCPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
     F                                     RENAME(LEFERCD0    :W_LEFERCD0     )
     F                                     USROPN

     D Z_LEFERCPD    E DS                  EXTNAME(GZLEFERCPD)
     D G_LEFERCPD    E DS                  EXTNAME(GZLEFERCPD) PREFIX(G_)

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
     C                   MOVEL     I#BIMG        Z_LEFERCPD
     C                   ELSE
     C                   MOVEL     I#AIMG        Z_LEFERCPD
     C                   ENDIF

     C     K_GZLEFERCL1  CHAIN     LEFERCD0                           99

      * 'Before'

     C     I#BFAF        IFEQ      'B'
     C  N99              DELETE    LEFERCD0
     C                   ELSE

      * 'After'

     C                   CLEAR                   G_LEFERCPD
     C                   MOVEL     Z_LEFERCPD    G_LEFERCPD
      * Fix Data
     C                   CALLB     'GPFIXGDTA'
     C                   PARM                    I#ZONE
     C                   PARM      'GZLEFERCPD'  I#FILE           10
     C                   PARM      G_LEFERCPD    IO#BUFFER      4000
     C                   MOVEL     IO#BUFFER     G_LEFERCPD
      * Update
     C     *IN99         IFEQ      *OFF
     C                   UPDATE    LEFERCD0
     C                   ELSE
     C                   WRITE     W_LEFERCD0
     C                   ENDIF
     C                   ENDIF

     C                   RETURN

     C/SPACE 5
      *****************************************************************
      * *INZSR - Initial Routine called automatically at program start
      *****************************************************************
     C     *INZSR        BEGSR

      * Open for commit?

     C                   CALL      'GPCOPN4COM'
     C                   PARM                    D_COM             1
     C                   OPEN      GZLEFERCL1
     C                   OPEN      GZLEFERCPD

      * Key lists

     C     K_GZLEFERCL1  KLIST
     C                   KFLD                    FCBRCA
     C                   KFLD                    FCCNUM
     C                   KFLD                    FCFACL
     C                   KFLD                    FCLOAN
     C                   KFLD                    FCFSEQ
     C                   KFLD                    FCRCVD

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
      *****************************************************************
