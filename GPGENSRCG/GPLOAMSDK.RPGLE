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
      *  GPLOAMSDK  - On-Line Update of Global File GZLOAMSDK         *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGP017             Date 06Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10215           Date 27Sep06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 BG1904             Date 15Apr03               *
      *                 BG1711             Date 31Mar04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10215 - Global replication needs a global interface       *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager. (Recompile)                   *
      *  BG1904 - Missing global deliverables (BG1711 not delivered)  *
      *  BG1711 - Global updates fail with record locking on GPTRAPPD *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
O    FGZLOAMSL1 UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZLOAMSDK O  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(LOAMSDKF    :W_LOAMSDKF     )
O    F                                     USROPN
O
O    D Z_LOAMSDK     E DS                  EXTNAME(GZLOAMSDK )
O    D G_LOAMSDK     E DS                  EXTNAME(GZLOAMSDK ) PREFIX(G_)
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
T
T     * GPTRAPPD Updates
T
T    C     I#TRAP        IFEQ      'Y'
T    C     I#BFAF        ANDEQ     'A'
T    C                   CALL      'GOWTTLOAM '
T    C                   PARM      *BLANK        W#RTCD            7
T    C                   PARM      *BLANK        W#ERMS           50
T    C                   PARM                    I#BIMG
T    C                   PARM                    I#AIMG
T    C     W#RTCD        IFEQ      '*ERROR'
T    C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOWTTLOAM '
T    C                   EXSR      *PSSR
T    C                   ENDIF
T    C                   ENDIF
O
O     * Global File Updates
O
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        Z_LOAMSDK
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_LOAMSDK
O    C                   ENDIF
O
O    C     K_GZLOAMSL1   CHAIN     LOAMSDKF                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    LOAMSDKF
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_LOAMSDK
O    C                   MOVEL     Z_LOAMSDK     G_LOAMSDK
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZLOAMSDK '  I#FILE           10
O    C                   PARM      G_LOAMSDK     IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_LOAMSDK
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    LOAMSDKF
O    C                   ELSE
O    C                   WRITE     W_LOAMSDKF
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
O    C                   OPEN      GZLOAMSL1
O    C                   OPEN      GZLOAMSDK
O
O     * Key lists
O
O    C     K_GZLOAMSL1   KLIST
O    C                   KFLD                    BRCA
O    C                   KFLD                    LNRF
O    C                   KFLD                    VDAT
O    C                   KFLD                    LASN
 
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
