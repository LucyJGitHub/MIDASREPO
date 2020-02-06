     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDCTTXPD - On-Line Update of Global File GZSDCTTXPD        *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. MD050231 *CREATE   Date 25Mar18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050231 - Failed global replication process during switchon *
      *                                                               *
      *****************************************************************

O    FGZSDCTTXL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDCTTXPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDCTTXD0    :W_SDCTTXD0     )
O    F                                     USROPN
O
O    D Z_SDCTTXPD    E DS                  EXTNAME(GZSDCTTXPD)
O    D G_SDCTTXPD    E DS                  EXTNAME(GZSDCTTXPD) PREFIX(G_)

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
O    C                   MOVEL     I#BIMG        Z_SDCTTXPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDCTTXPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        EWZONE
O
O    C     K_GZSDCTTXL1  CHAIN     SDCTTXD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDCTTXD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDCTTXPD
O    C                   MOVEL     Z_SDCTTXPD    G_SDCTTXPD
O     * Fix Data
     C                   CALLB     'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDCTTXPD'  I#FILE           10
O    C                   PARM      G_SDCTTXPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDCTTXPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDCTTXD0
O    C                   ELSE
O    C                   WRITE     W_SDCTTXD0
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
O    C                   OPEN      GZSDCTTXL1
O    C                   OPEN      GZSDCTTXPD
O
O     * Key lists
O
O    C     K_GZSDCTTXL1  KLIST
O    C                   KFLD                    EWZONE
O    C                   KFLD                    EWCTRT
O    C                   KFLD                    EWCTRR

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
