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
      *  GPDEALSDG  - On-Line Update of Global File GZDEALSDG         *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                 CDL038             Date 10May05               *
      *                 BG1904             Date 15Apr03               *
      *                 BG1711             Date 31Mar04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10215 - Global replication needs a global interface       *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BG1904 - Missing global deliverables (BG1711 not delivered)  *
      *  BG1711 - Global updates fail with record locking on GPTRAPPD *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

O    FGZDLSDGL1 UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZDEALSDG O  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(DEALSDGF    :W_DEALSDGF     )
O    F                                     USROPN
O
O    D Z_DEALSDG     E DS                  EXTNAME(GZDEALSDG )
O    D G_DEALSDG     E DS                  EXTNAME(GZDEALSDG ) PREFIX(G_)

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
T    C                   CALL      'GOWTTFRIR '
T    C                   PARM      *BLANK        W#RTCD            7
T    C                   PARM      *BLANK        W#ERMS           50
T    C                   PARM                    I#BIMG
T    C                   PARM                    I#AIMG
T    C     W#RTCD        IFEQ      '*ERROR'
T    C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOWTTFRIR '
T    C                   EXSR      *PSSR
T    C                   ENDIF
T    C                   ENDIF
O
O     * Global File Updates
O
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        Z_DEALSDG
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_DEALSDG
O    C                   ENDIF
O
O    C     K_GZDLSDGL1   CHAIN     DEALSDGF                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    DEALSDGF
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_DEALSDG
O    C                   MOVEL     Z_DEALSDG     G_DEALSDG
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZDEALSDG '  I#FILE           10
O    C                   PARM      G_DEALSDG     IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_DEALSDG
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    DEALSDGF
O    C                   ELSE
O    C                   WRITE     W_DEALSDGF
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
O    C                   OPEN      GZDLSDGL1
O    C                   OPEN      GZDEALSDG
O
O     * Key lists
O
O    C     K_GZDLSDGL1   KLIST
O    C                   KFLD                    BRCA
O    C                   KFLD                    DLNO

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
