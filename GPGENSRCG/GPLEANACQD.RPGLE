     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2017')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  ALWNULL(*USRCTL)                                             *                      CER073D
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPLEANACQD - On-Line Update of Global File GZLEANACQD        *
      *                                                               *
      *  (c) Finastra International Limited 2017                      *
      *                                                               *
      *  Last Amend No. CER073D            Date 13Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER073B            Date 25Sep17               *
      *                 CER073A            Date 05Sep17               *
      *                 CER073  *CREATE    Date 10Jul17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER073D - Upgrade of EML014 to FB2.1 SP23                    *
      *      EML014 - AnaCredit Reporting Enhancement                 *
      *  MD046248 - Finastra Rebranding                               *
      *  CER073B - CER073 Change Control 2 (Recompile)                *
      *  CER073A - CER073 Change Control 1 (Recompile)                *
      *  CER073 - AnaCredit Reporting                                 *
      *                                                               *
      *****************************************************************

O    FGZLEANACI1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZLEANACQDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(LEANACD0    :W_LEANACD0     )
O    F                                     USROPN
O
O    D Z_LEANACQD    E DS                  EXTNAME(GZLEANACQD)
O    D G_LEANACQD    E DS                  EXTNAME(GZLEANACQD) PREFIX(G_)

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
O    C                   MOVEL     I#BIMG        Z_LEANACQD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_LEANACQD
O    C                   ENDIF
O
O    C     K_GZLEANACI1  CHAIN     LEANACD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    LEANACD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_LEANACQD
O    C                   MOVEL     Z_LEANACQD    G_LEANACQD
O     * Fix Data
     C**********         CALLB     'GPFIXGDTA'                                               CER073D
     C                   CALL      'GPFIXGDTA'                                               CER073D
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZLEANACQD'  I#FILE           10
O    C                   PARM      G_LEANACQD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_LEANACQD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    LEANACD0
O    C                   ELSE
O    C                   WRITE     W_LEANACD0
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
O    C                   OPEN      GZLEANACI1
O    C                   OPEN      GZLEANACQD
O
O     * Key lists
O
O    C     K_GZLEANACI1  KLIST
     C                   KFLD                    ACBRCD
O    C                   KFLD                    ACLNRF

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
