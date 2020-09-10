     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  ALWNULL(*USRCTL)                                             *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPFCANACQD - On-Line Update of Global File GZFCANACQD        *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. CER073D *Create    Date 13Aug20               *
      * FBMidas 2.1 ---- Base ----------------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER073D - Upgrade of EML014 to FB2.1 SP23                    *
      *      EML014 - AnaCredit Reporting Enhancement                 *
      *                                                               *
      *****************************************************************

O    FGZFCANACI1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZFCANACQDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(FCANACD0    :W_FCANACD0     )
O    F                                     USROPN
O
O    D Z_FCANACQD    E DS                  EXTNAME(GZFCANACQD)
O    D G_FCANACQD    E DS                  EXTNAME(GZFCANACQD) PREFIX(G_)

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
O    C                   MOVEL     I#BIMG        Z_FCANACQD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_FCANACQD
O    C                   ENDIF
O
O    C     K_GZFCANACI1  CHAIN     FCANACD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    FCANACD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_FCANACQD
O    C                   MOVEL     Z_FCANACQD    G_FCANACQD
O     * Fix Data
     C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZFCANACQD'  I#FILE           10
O    C                   PARM      G_FCANACQD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_FCANACQD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    FCANACD0
O    C                   ELSE
O    C                   WRITE     W_FCANACD0
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
O    C                   OPEN      GZFCANACI1
O    C                   OPEN      GZFCANACQD
O
O     * Key lists
O
O    C     K_GZFCANACI1  KLIST
     C                   KFLD                    ACBRCD
     C                   KFLD                    ACCNUM
     C                   KFLD                    ACFACT
     C                   KFLD                    ACFCNO

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
