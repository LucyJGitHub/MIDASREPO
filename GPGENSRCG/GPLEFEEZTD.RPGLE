     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPLEFEEZTD - On-Line Update of Global File GZLEFEEZTD        *
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
 
O    FGZLEFEEZI1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZLEFEEZTDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(LEFEEZD0    :W_LEFEEZD0     )
O    F                                     USROPN
O
O    D Z_LEFEEZTD    E DS                  EXTNAME(GZLEFEEZTD)
O    D G_LEFEEZTD    E DS                  EXTNAME(GZLEFEEZTD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_LEFEEZTD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_LEFEEZTD
O    C                   ENDIF
O
O    C     K_GZLEFEEZI1  CHAIN     LEFEEZD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    LEFEEZD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_LEFEEZTD
O    C                   MOVEL     Z_LEFEEZTD    G_LEFEEZTD
O     * Fix Data
     C                   CALLB     'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZLEFEEZTD'  I#FILE           10
O    C                   PARM      G_LEFEEZTD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_LEFEEZTD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    LEFEEZD0
O    C                   ELSE
O    C                   WRITE     W_LEFEEZD0
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
O    C                   OPEN      GZLEFEEZI1
O    C                   OPEN      GZLEFEEZTD
O
O     * Key lists
O
O    C     K_GZLEFEEZI1  KLIST
O    C                   KFLD                    FXBRCA
O    C                   KFLD                    FXCNUM
O    C                   KFLD                    FXFACL
O    C                   KFLD                    FXLOAN
O    C                   KFLD                    FXFSEQ
O    C                   KFLD                    FXCATE
 
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
