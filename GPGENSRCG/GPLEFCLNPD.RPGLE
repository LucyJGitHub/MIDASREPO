     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*S*D****RPGBASEBNC****************************************************                       CGP017
/*STD *  RPGBASEMOD                                                   *                       CGP017
/*EXI *  ALWNULL(*USRCTL)                                             *                     BUG10215
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPLEFCLNPD - On-Line Update of Global File GZLEFCLNPD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG10215 *REBUILD  Date 27Sep06               *
      *                 BUG6140            Date 01Mar05               *
      *                 CLE041  *CREATE    Date 11Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  BUG10215 - Global replication needs a global interface       *
      *  BUG6140 - Various error due to FCZONE.                       *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *                                                               *
      *****************************************************************
 
O    FGZLEFCLNL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZLEFCLNPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(LEFCLND0    :W_LEFCLND0     )
O    F                                     USROPN
O
O    D Z_LEFCLNPD    E DS                  EXTNAME(GZLEFCLNPD)
O    D G_LEFCLNPD    E DS                  EXTNAME(GZLEFCLNPD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_LEFCLNPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_LEFCLNPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        FCZONE
O
O    C     K_GZLEFCLNL1  CHAIN     LEFCLND0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    LEFCLND0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_LEFCLNPD
O    C                   MOVEL     Z_LEFCLNPD    G_LEFCLNPD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZLEFCLNPD'  I#FILE           10
O    C                   PARM      G_LEFCLNPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_LEFCLNPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    LEFCLND0
O    C                   ELSE
O    C                   WRITE     W_LEFCLND0
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
O    C                   OPEN      GZLEFCLNL1
O    C                   OPEN      GZLEFCLNPD
O
O     * Key lists
O
O    C     K_GZLEFCLNL1  KLIST
O    C                   KFLD                    FCZONE
O    C                   KFLD                    FCHYID
O    C                   KFLD                    FCLNID
O    C                   KFLD                    FCENDI
 
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
