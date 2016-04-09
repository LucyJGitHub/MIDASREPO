     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*S*D****RPGBASEBNC****************************************************                       CGP017
/*STD *  RPGBASEMOD                                                   *                       CGP017
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPLEAGFTQD - On-Line Update of Global File GZLEAGFTQD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CGP017             Date 06Aug12               *
      *  Prev Amend No. CLE147             Date 30Sep11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE041  *CREATE    Date 11Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  CLE147 - Aggregate Facility (Recompile)                      *
      *  BUG10215 - Global replication needs a global interface       *
      *  CLE106 - Syndications Manager. (Recompiled)                  *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *                                                               *
      *****************************************************************
 
O    FGZLEAGFTL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZLEAGFTQDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(LEFCLTD0    :W_LEFCLTD0     )
O    F                                     USROPN
O
O    D Z_LEAGFTQD    E DS                  EXTNAME(GZLEAGFTQD)
O    D G_LEAGFTQD    E DS                  EXTNAME(GZLEAGFTQD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_LEAGFTQD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_LEAGFTQD
O    C                   ENDIF
O
O    C     K_GZLEAGFTL1  CHAIN     LEFCLTD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    LEFCLTD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_LEAGFTQD
O    C                   MOVEL     Z_LEAGFTQD    G_LEAGFTQD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZLEAGFTQD'  I#FILE           10
O    C                   PARM      G_LEAGFTQD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_LEAGFTQD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    LEFCLTD0
O    C                   ELSE
O    C                   WRITE     W_LEFCLTD0
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
O    C                   OPEN      GZLEAGFTL1
O    C                   OPEN      GZLEAGFTQD
O
O     * Key lists
O
O    C     K_GZLEAGFTL1  KLIST
O    C                   KFLD                    FCXBRC
O    C                   KFLD                    FCXFCU
O    C                   KFLD                    FCXFTP
O    C                   KFLD                    FCXFNO
 
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
