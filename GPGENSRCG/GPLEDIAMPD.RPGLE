     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPLEDIAMPD - On-Line Update of Global File GZLEDIAMPD        *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. CLE070  *CREATE    Date 19Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE070 - Manual Diary                                        *
      *                                                               *
      *****************************************************************

     FGZLEDIAML1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
     F                                     USROPN
     FGZLEDIAMPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
     F                                     RENAME(DIARYMEF    :W_DIARYMEF     )
     F                                     USROPN

     D Z_LEDIAMPD    E DS                  EXTNAME(GZLEDIAMPD)
     D G_LEDIAMPD    E DS                  EXTNAME(GZLEDIAMPD) PREFIX(G_)

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
     C                   MOVEL     I#BIMG        Z_LEDIAMPD
     C                   ELSE
     C                   MOVEL     I#AIMG        Z_LEDIAMPD
     C                   ENDIF

     C     K_GZLEDIAML1  CHAIN     DIARYMEF                           99

      * 'Before'

     C     I#BFAF        IFEQ      'B'
     C  N99              DELETE    DIARYMEF
     C                   ELSE

      * 'After'

     C                   CLEAR                   G_LEDIAMPD
     C                   MOVEL     Z_LEDIAMPD    G_LEDIAMPD
      * Fix Data
     C                   CALLB     'GPFIXGDTA'
     C                   PARM                    I#ZONE
     C                   PARM      'GZLEDIAMPD'  I#FILE           10
     C                   PARM      G_LEDIAMPD    IO#BUFFER      4000
     C                   MOVEL     IO#BUFFER     G_LEDIAMPD
      * Update
     C     *IN99         IFEQ      *OFF
     C                   UPDATE    DIARYMEF
     C                   ELSE
     C                   WRITE     W_DIARYMEF
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
     C                   OPEN      GZLEDIAML1
     C                   OPEN      GZLEDIAMPD

      * Key lists

     C     K_GZLEDIAML1  KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    DYRF

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
