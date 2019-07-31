     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDATSTPD - SD Account Transfer Type/Sub-Type               *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG27394           Date 26Apr10               *
      *                 CAP204A            Date 10Mar10               *
      *                 CAP204 *CREATE     Date 20Jan10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27394 - Add new field Record ID to allow logical deletion *
      *             of this file (Recompile)                          *
      *  CAP204A - Teller Related APIs - Account Transfer: Change     *
      *            Request 027 - Add new field Wash Account Code      *
      *            (Recompile)                                        *
      *  CAP204 - Retail Account Transfer                             *
      *                                                               *
      *****************************************************************
 
O    FGZSDATSTL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDATSTPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDATSTD0    :W_SDATSTD0     )
O    F                                     USROPN
O
O    D Z_SDATSTPD    E DS                  EXTNAME(GZSDATSTPD)
O    D G_SDATSTPD    E DS                  EXTNAME(GZSDATSTPD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_SDATSTPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDATSTPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        ATZONE
O
O    C     K_GZSDATSTL1  CHAIN     SDATSTD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDATSTD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDATSTPD
O    C                   MOVEL     Z_SDATSTPD    G_SDATSTPD
O     * Fix Data
O    C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDATSTPD'  I#FILE           10
O    C                   PARM      G_SDATSTPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDATSTPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDATSTD0
O    C                   ELSE
O    C                   WRITE     W_SDATSTD0
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
O    C                   OPEN      GZSDATSTL1
O    C                   OPEN      GZSDATSTPD
O
O     * Key lists
O
O    C     K_GZSDATSTL1  KLIST
O    C                   KFLD                    ATZONE
O    C                   KFLD                    ATTRTY
O    C                   KFLD                    ATTRST
 
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
