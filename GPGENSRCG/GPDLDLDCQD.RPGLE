     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*S*D****RPGBASEBNC****************************************************                       CGP017
/*STD *  RPGBASEMOD                                                   *                       CGP017
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPDLDLDCQD - On-Line Update of Global File GZDLDLDCQD        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGP017             Date 06Aug12               *
      *                 AR821923           Date 29Aug11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10215           Date 27Sep06               *
      *                 CLE040             Date 05Jul04               *
      *                 BUG3035            Date 03Jun04               *
      *                 CLE025  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  AR821923 - Rubbish data was saved in GZGLACNTQD file         *
      *             (Recompile)                                       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10215 - Global replication needs a global interface       *
      *  CLE040 - Collateralised Lending Phase 2 (Recompile)          *
      *  BUG3035 - Error on calculation when a rate change is done    *
      *            (Recompile)                                        *
      *  CLE025 - Credit Lines                                        *
      *                                                               *
      *****************************************************************
 
O    FGZDLDLDCL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZDLDLDCQDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(DLDLDCD0    :W_DLDLDCD0     )
O    F                                     USROPN
O
O    D Z_DLDLDCQD    E DS                  EXTNAME(GZDLDLDCQD)
O    D G_DLDLDCQD    E DS                  EXTNAME(GZDLDLDCQD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_DLDLDCQD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_DLDLDCQD
O    C                   ENDIF
O
O    C     K_GZDLDLDCL1  CHAIN     DLDLDCD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    DLDLDCD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_DLDLDCQD
O    C                   MOVEL     Z_DLDLDCQD    G_DLDLDCQD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZDLDLDCQD'  I#FILE           10
O    C                   PARM      G_DLDLDCQD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_DLDLDCQD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    DLDLDCD0
O    C                   ELSE
O    C                   WRITE     W_DLDLDCD0
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
O    C                   OPEN      GZDLDLDCL1
O    C                   OPEN      GZDLDLDCQD
O
O     * Key lists
O
O    C     K_GZDLDLDCL1  KLIST
O    C                   KFLD                    F1BRCA
O    C                   KFLD                    F1DLNO
 
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
