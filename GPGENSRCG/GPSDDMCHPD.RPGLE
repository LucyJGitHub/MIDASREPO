     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDDMCHPD - On-Line Update of Global File GZSDDMCHPD        *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD093  *CREATE    Date 10Mar14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD093 - Document Management                                 *
      *                                                               *
      *****************************************************************
 
O    FGZSDDMCHL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDDMCHPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDDMCHD0    :W_SDDMCHD0     )
O    F                                     USROPN
O
O    D Z_SDDMCHPD    E DS                  EXTNAME(GZSDDMCHPD)
O    D G_SDDMCHPD    E DS                  EXTNAME(GZSDDMCHPD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_SDDMCHPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDDMCHPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        CHZONE
O
O    C     K_GZSDDMCHL1  CHAIN     SDDMCHD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDDMCHD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDDMCHPD
O    C                   MOVEL     Z_SDDMCHPD    G_SDDMCHPD
O     * Fix Data
O    C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDDMCHPD'  I#FILE           10
O    C                   PARM      G_SDDMCHPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDDMCHPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDDMCHD0
O    C                   ELSE
O    C                   WRITE     W_SDDMCHD0
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
O    C                   OPEN      GZSDDMCHL1
O    C                   OPEN      GZSDDMCHPD
O
O     * Key lists
O
O    C     K_GZSDDMCHL1  KLIST
O    C                   KFLD                    CHZONE
O    C                   KFLD                    CHREFN
O    C                   KFLD                    CHRTYP
O    C                   KFLD                    CHCODE
O    C                   KFLD                    CHSEQN
O    C                   KFLD                    CHCDAT
O    C                   KFLD                    CHCTIM
O    C                   KFLD                    CHCUSR
 
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
