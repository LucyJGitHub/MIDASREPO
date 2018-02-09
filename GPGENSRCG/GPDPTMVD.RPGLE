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
      *  GPDPTMVD   - On-Line Update of Global File GZDPTMVD          *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                 CGL035             Date 01Mar05               *
      *                 BG1904             Date 15Apr03               *
      *                 BG1711             Date 31Mar04               *
      *                 222727             Date 05Nov03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10215 - Global replication needs a global interface       *
      *  CGL035 - EUSD Upgrade to Midasplus (Recompile)               *
      *  BG1904 - Missing global deliverables (BG1711 not delivered)  *
      *  BG1711 - Global updates fail with record locking on GPTRAPPD *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
O    FGZDPTMVL1 UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZDPTMVD  O  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(DPTMVDF     :W_DPTMVDF      )
O    F                                     USROPN
O
O    D Z_DPTMVD      E DS                  EXTNAME(GZDPTMVD  )
O    D G_DPTMVD      E DS                  EXTNAME(GZDPTMVD  ) PREFIX(G_)
 
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
T    C                   CALL      'GOWTTDPMV '
T    C                   PARM      *BLANK        W#RTCD            7
T    C                   PARM      *BLANK        W#ERMS           50
T    C                   PARM                    I#BIMG
T    C                   PARM                    I#AIMG
T    C     W#RTCD        IFEQ      '*ERROR'
T    C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOWTTDPMV '
T    C                   EXSR      *PSSR
T    C                   ENDIF
T    C                   ENDIF
O
O     * Global File Updates
O
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        Z_DPTMVD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_DPTMVD
O    C                   ENDIF
O
O    C     K_GZDPTMVL1   CHAIN     DPTMVDF                            99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    DPTMVDF
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_DPTMVD
O    C                   MOVEL     Z_DPTMVD      G_DPTMVD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZDPTMVD  '  I#FILE           10
O    C                   PARM      G_DPTMVD      IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_DPTMVD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    DPTMVDF
O    C                   ELSE
O    C                   WRITE     W_DPTMVDF
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
O    C                   OPEN      GZDPTMVL1
O    C                   OPEN      GZDPTMVD
O
O     * Key lists
O
O    C     K_GZDPTMVL1   KLIST
O    C                   KFLD                    DPBA
O    C                   KFLD                    DPSS
O    C                   KFLD                    DPRN
 
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
