     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD ***RPGBASEBNC****************************************************
      *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDCUSTXC - On-Line Update of Global File GZSDCUSTXC        *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. MD050212 *Create   Date 02Apr18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050212 - Replication processing for PF/SDCUSTXC            *
      *                                                               *
      *****************************************************************

O    FGZSDCUSXL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDCUSTXCO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDCUSTX0    :W_SDCUSTX0     )
O    F                                     USROPN
O
O    D Z_SDCUSTXC    E DS                  EXTNAME(GZSDCUSTXC)
O    D G_SDCUSTXC    E DS                  EXTNAME(GZSDCUSTXC) PREFIX(G_)

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
O    C                   MOVEL     I#BIMG        Z_SDCUSTXC
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDCUSTXC
O    C                   ENDIF
O
O    C     K_GZSDCUSXL1  CHAIN     SDCUSTX0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDCUSTX0
O    C                   ELSE
O
O     * 'After'
O
     C                   IF        *IN99 = *ON  OR (*IN99 = *OFF
     C                             AND Z_SDCUSTXC <> G_SDCUSTXC)

O    C                   CLEAR                   G_SDCUSTXC
O    C                   MOVEL     Z_SDCUSTXC    G_SDCUSTXC
O     * Fix Data
O    C                   CALL      'GPFIXGDTA'
     C**********         CALLB     'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDCUSTXC'  I#FILE           10
O    C                   PARM      G_SDCUSTXC    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDCUSTXC
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDCUSTX0
O    C                   ELSE
O    C                   WRITE     W_SDCUSTX0
O    C                   ENDIF
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
O    C                   OPEN      GZSDCUSXL1
O    C                   OPEN      GZSDCUSTXC
O
O     * Key lists
O
O    C     K_GZSDCUSXL1  KLIST
O    C                   KFLD                    XCBRCH
O    C                   KFLD                    XCCUST

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
