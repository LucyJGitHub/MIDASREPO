     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDGESTPD - On-Line Update of Global File GZSDGESTPD        *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER054  *CREATE    Date 07Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax                        *
      *                                                               *
      *****************************************************************
 
O    FGZSDGESTL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDGESTPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDGESTD0    :W_SDGESTD0     )
O    F                                     USROPN
O
O    D Z_SDGESTPD    E DS                  EXTNAME(GZSDGESTPD)
O    D G_SDGESTPD    E DS                  EXTNAME(GZSDGESTPD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_SDGESTPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDGESTPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        GEZONE
O
O    C     K_GZSDGESTL1  CHAIN     SDGESTD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDGESTD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDGESTPD
O    C                   MOVEL     Z_SDGESTPD    G_SDGESTPD
O     * Fix Data
O    C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDGESTPD'  I#FILE           10
O    C                   PARM      G_SDGESTPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDGESTPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDGESTD0
O    C                   ELSE
O    C                   WRITE     W_SDGESTD0
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
O    C                   OPEN      GZSDGESTL1
O    C                   OPEN      GZSDGESTPD
O
O     * Key lists
O
O    C     K_GZSDGESTL1  KLIST
O    C                   KFLD                    GEZONE
O    C                   KFLD                    GESTCD
 
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
