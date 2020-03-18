     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDCONVPD - On-Line Update of Global File GPSDCONVPD        *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CMG008  *CREATE    Date 20Feb20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMG008 - MT940, MT941, MT942, MT950 Translation Table.       *
      *                                                               *
      *****************************************************************

O    FGZSDCONVL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDCONVPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDCONVD0    :W_SDCONVD0     )
O    F                                     USROPN
O
O    D Z_SDCONVPD    E DS                  EXTNAME(GZSDCONVPD)
O    D G_SDCONVPD    E DS                  EXTNAME(GZSDCONVPD) PREFIX(G_)

      * ENTRY PARAMETERS

     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
O
O     * Global File Updates
O
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        Z_SDCONVPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDCONVPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        SDZONE
O
O    C     K_GZSDCONVL1  CHAIN     SDCONVD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDCONVD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDCONVPD
O    C                   MOVEL     Z_SDCONVPD    G_SDCONVPD
O     * Fix Data
O    C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDCONVPD'  I#FILE           10
O    C                   PARM      G_SDCONVPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDCONVPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDCONVD0
O    C                   ELSE
O    C                   WRITE     W_SDCONVD0
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
O    C                   OPEN      GZSDCONVL1
O    C                   OPEN      GZSDCONVPD
O
O     * Key lists
O
O    C     K_GZSDCONVL1  KLIST
O    C                   KFLD                    SDZONE
O    C                   KFLD                    FRCHAR

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
