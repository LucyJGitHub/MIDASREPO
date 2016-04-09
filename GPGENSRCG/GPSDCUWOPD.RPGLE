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
      *  GPSDCUWOPD - On-Line Update of Global File GZSDCUWOPD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                 BUG3644 *CREATE    Date 12Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10215 - Global replication needs a global interface       *
      *  BUG3644 - Serious Error in Collateralised Lending            *
      *                                                               *
      *****************************************************************
 
O    FGZSDCUWOL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDCUWOPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDCUWOD0    :W_SDCUWOD0     )
O    F                                     USROPN
O
O    D Z_SDCUWOPD    E DS                  EXTNAME(GZSDCUWOPD)
O    D G_SDCUWOPD    E DS                  EXTNAME(GZSDCUWOPD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_SDCUWOPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDCUWOPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        WOZONE
O
O    C     K_GZSDCUWOL1  CHAIN     SDCUWOD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDCUWOD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDCUWOPD
O    C                   MOVEL     Z_SDCUWOPD    G_SDCUWOPD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDCUWOPD'  I#FILE           10
O    C                   PARM      G_SDCUWOPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDCUWOPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDCUWOD0
O    C                   ELSE
O    C                   WRITE     W_SDCUWOD0
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
O    C                   OPEN      GZSDCUWOL1
O    C                   OPEN      GZSDCUWOPD
O
O     * Key lists
O
O    C     K_GZSDCUWOL1  KLIST
O    C                   KFLD                    WOZONE
O    C                   KFLD                    WOCNUM
O    C                   KFLD                    WOPTFR
O    C                   KFLD                    WOSESN
O    C                   KFLD                    WOCYCD
O    C                   KFLD                    WOCNCD
 
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
