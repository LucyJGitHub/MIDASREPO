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
      *  GPFXDEALPP - On-Line Update of Global File GZFXDEALPP        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CDL094             Date 30May14               *
      *                 CGP017             Date 06Aug12               *
      *                 CSW212             Date 03May12               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                 CDL038             Date 10May05               *
      *                 BG1904             Date 15Apr03               *
      *                 BG1711             Date 31Mar04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CDL094 - Enhance  Receive Settlement Instructions (Recompile)*
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10215 - Global replication needs a global interface       *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BG1904 - Missing global deliverables (BG1711 not delivered)  *
      *  BG1711 - Global updates fail with record locking on GPTRAPPD *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

O    FGZFXDEALL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZFXDEALPPO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(FXDEALP0    :W_FXDEALP0     )
O    F                                     USROPN
O
O    D Z_FXDEALPP    E DS                  EXTNAME(GZFXDEALPP)
O    D G_FXDEALPP    E DS                  EXTNAME(GZFXDEALPP) PREFIX(G_)

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
T    C                   CALL      'GOWTTFXDL '
T    C                   PARM      *BLANK        W#RTCD            7
T    C                   PARM      *BLANK        W#ERMS           50
T    C                   PARM                    I#BIMG
T    C                   PARM                    I#AIMG
T    C     W#RTCD        IFEQ      '*ERROR'
T    C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOWTTFXDL '
T    C                   EXSR      *PSSR
T    C                   ENDIF
T    C                   ENDIF
O
O     * Global File Updates
O
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        Z_FXDEALPP
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_FXDEALPP
O    C                   ENDIF
O
O    C     K_GZFXDEALL1  CHAIN     FXDEALP0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    FXDEALP0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_FXDEALPP
O    C                   MOVEL     Z_FXDEALPP    G_FXDEALPP
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZFXDEALPP'  I#FILE           10
O    C                   PARM      G_FXDEALPP    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_FXDEALPP
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    FXDEALP0
O    C                   ELSE
O    C                   WRITE     W_FXDEALP0
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
O    C                   OPEN      GZFXDEALL1
O    C                   OPEN      GZFXDEALPP
O
O     * Key lists
O
O    C     K_GZFXDEALL1  KLIST
O    C                   KFLD                    FHDBRC
O    C                   KFLD                    FHDN38

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
