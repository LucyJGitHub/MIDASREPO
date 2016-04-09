     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDPRGPTD - On-Line Update of Global File GZSDPRGPTD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CLE164  *CREATE    Date 18Aug14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *                                                               *
      *****************************************************************
 
O    FGZSDPRGPI1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDPRGPTDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDPRGPD0    :W_SDPRGPD0     )
O    F                                     USROPN
O
O    D Z_SDPRGPTD    E DS                  EXTNAME(GZSDPRGPTD)
O    D G_SDPRGPTD    E DS                  EXTNAME(GZSDPRGPTD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_SDPRGPTD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDPRGPTD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        PGZONE
O
O    C     K_GZSDPRGPI1  CHAIN     SDPRGPD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDPRGPD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDPRGPTD
O    C                   MOVEL     Z_SDPRGPTD    G_SDPRGPTD
O     * Fix Data
     C                   CALLB     'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDPRGPTD'  I#FILE           10
O    C                   PARM      G_SDPRGPTD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDPRGPTD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDPRGPD0
O    C                   ELSE
O    C                   WRITE     W_SDPRGPD0
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
O    C                   OPEN      GZSDPRGPI1
O    C                   OPEN      GZSDPRGPTD
O
O     * Key lists
O
O    C     K_GZSDPRGPI1  KLIST
O    C                   KFLD                    PGZONE
O    C                   KFLD                    PGPGID
 
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
