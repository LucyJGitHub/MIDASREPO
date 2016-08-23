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
      *  GPPRICED   - On-Line Update of Global File GZPRICED          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. 260464             Date 28May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                 CGL035             Date 01Mar05               *
      *                 CLE024             Date 20Oct03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  260464 - Recompile due to change in LF/GZPRICEL1.            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL035 - EUSD Upgrade to Midasplus (Recompile)               *
      *  CLE024 - Collateralised Lending                              *
      *  CGP001 - Global Processing                                   *
      *  BUG10215 - Global replication needs a global interface       *
      *                                                               *
      *****************************************************************
 
O    FGZPRICEL1 UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZPRICED  O  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(PRICEDF     :W_PRICEDF      )
O    F                                     USROPN
O
O    D Z_PRICED      E DS                  EXTNAME(GZPRICED  )
O    D G_PRICED      E DS                  EXTNAME(GZPRICED  ) PREFIX(G_)
                                                                                            BUG10215
     D/COPY GPCPYSRCG,GPWRTALTDS                                                            BUG10215
 
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
O    C                   MOVEL     I#BIMG        Z_PRICED
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_PRICED
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        SEZONE
O
O    C     K_GZPRICEL1   CHAIN     PRICEDF                            99
                                                                                            BUG10215
     C/COPY GPCPYSRCG,GPWRTAL2PR                                                            BUG10215
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    PRICEDF
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_PRICED
O    C                   MOVEL     Z_PRICED      G_PRICED
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZPRICED  '  I#FILE           10
O    C                   PARM      G_PRICED      IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_PRICED
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    PRICEDF
O    C                   ELSE
O    C                   WRITE     W_PRICEDF
O    C                   ENDIF
O    C                   ENDIF
                                                                                            BUG10215
     C/COPY GPCPYSRCG,GPWRTALTPR                                                            BUG10215
 
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
O    C                   OPEN      GZPRICEL1
O    C                   OPEN      GZPRICED
O
O     * Key lists
O
O    C     K_GZPRICEL1   KLIST
O    C                   KFLD                    SEZONE
O    C                   KFLD                    PSSN
O    C                   KFLD                    PCNM
O    C                   KFLD                    PMKT
O    C                   KFLD                    PBRA
O    C                   KFLD                    PBOK
O    C                   KFLD                    PPRT
O    C                   KFLD                    PTFR
 
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
