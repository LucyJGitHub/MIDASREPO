     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDACTXPD - On-Line Update of Global File GZSDACTXPD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. CER059  *CREATE    Date 19Jul10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *                                                               *
      *****************************************************************
 
O    FGZSDACTXL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDACTXPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDACTXD0    :W_SDACTXD0     )
O    F                                     USROPN
O
O    D Z_SDACTXPD    E DS                  EXTNAME(GZSDACTXPD)
O    D G_SDACTXPD    E DS                  EXTNAME(GZSDACTXPD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_SDACTXPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDACTXPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        AXZONE
O
O    C     K_GZSDACTXL1  CHAIN     SDACTXD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDACTXD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDACTXPD
O    C                   MOVEL     Z_SDACTXPD    G_SDACTXPD
O     * Fix Data
O    C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDACTXPD'  I#FILE           10
O    C                   PARM      G_SDACTXPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDACTXPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDACTXD0
O    C                   ELSE
O    C                   WRITE     W_SDACTXD0
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
O    C                   OPEN      GZSDACTXL1
O    C                   OPEN      GZSDACTXPD
O
O     * Key lists
O
O    C     K_GZSDACTXL1  KLIST
O    C                   KFLD                    AXZONE
O    C                   KFLD                    AXCUST
O    C                   KFLD                    AXCTTX
 
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
