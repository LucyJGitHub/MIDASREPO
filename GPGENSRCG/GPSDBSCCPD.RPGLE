     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDBSCCPD - On-Line Update of Global File GZSDBSCCPD        *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank              *
      *                                                               *
      *****************************************************************
 
O    FGZSDBSCCL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDBSCCPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDBSCCD0    :W_SDBSCCD0     )
O    F                                     USROPN
O
O    D Z_SDBSCCPD    E DS                  EXTNAME(GZSDBSCCPD)
O    D G_SDBSCCPD    E DS                  EXTNAME(GZSDBSCCPD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_SDBSCCPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDBSCCPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        N5ZONE
O
O    C     K_GZSDBSCCL1  CHAIN     SDBSCCD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDBSCCD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDBSCCPD
O    C                   MOVEL     Z_SDBSCCPD    G_SDBSCCPD
O     * Fix Data
O    C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDBSCCPD'  I#FILE           10
O    C                   PARM      G_SDBSCCPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDBSCCPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDBSCCD0
O    C                   ELSE
O    C                   WRITE     W_SDBSCCD0
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
O    C                   OPEN      GZSDBSCCL1
O    C                   OPEN      GZSDBSCCPD
O
O     * Key lists
O
O    C     K_GZSDBSCCL1  KLIST
O    C                   KFLD                    N5ZONE
O    C                   KFLD                    N5BSCC
 
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
