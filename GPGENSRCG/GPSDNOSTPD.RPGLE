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
      *  GPSDNOSTPD - On-Line Update of Global File GZSDNOSTPD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CDL094             Date 30May14               *
      *  Prev Amend No. CGP017             Date 06Aug12               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL094 - Enhance  Receive Settlement Instructions (Recompile)*
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10215 - Global replication needs a global interface       *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
O    FGZSDNOSTL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDNOSTPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDNOSTD0    :W_SDNOSTD0     )
O    F                                     USROPN
O
O    D Z_SDNOSTPD    E DS                  EXTNAME(GZSDNOSTPD)
O    D G_SDNOSTPD    E DS                  EXTNAME(GZSDNOSTPD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_SDNOSTPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDNOSTPD
O    C                   ENDIF
O
O    C     K_GZSDNOSTL1  CHAIN     SDNOSTD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDNOSTD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDNOSTPD
O    C                   MOVEL     Z_SDNOSTPD    G_SDNOSTPD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDNOSTPD'  I#FILE           10
O    C                   PARM      G_SDNOSTPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDNOSTPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDNOSTD0
O    C                   ELSE
O    C                   WRITE     W_SDNOSTD0
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
O    C                   OPEN      GZSDNOSTL1
O    C                   OPEN      GZSDNOSTPD
O
O     * Key lists
O
O    C     K_GZSDNOSTL1  KLIST
O    C                   KFLD                    A7BRCD
O    C                   KFLD                    A7CYCD
O    C                   KFLD                    A7NONB
 
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
