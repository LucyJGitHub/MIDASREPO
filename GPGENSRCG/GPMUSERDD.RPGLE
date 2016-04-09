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
      *  GPMUSERDD  - On-Line Update of Global File GZMUSERDD         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
     /*  Prev Amend No. CSD086             Date 17Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                 BG1904             Date 15Apr03               *
      *                 TDA035             Date 23May03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
     /*  CSD086 - Overridable Errors (Recompile)                      *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  BUG10215 - Global replication needs a global interface       *
      *  BG1904 - Missing global deliverables (TDA035 not delivered)  *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
O    FGZMUSERL1 UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZMUSERDD O  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(MUSERDDF    :W_MUSERDDF     )
O    F                                     USROPN
O
O    D Z_MUSERDD     E DS                  EXTNAME(GZMUSERDD )
O    D G_MUSERDD     E DS                  EXTNAME(GZMUSERDD ) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_MUSERDD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_MUSERDD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        USZONE
O
O    C     K_GZMUSERL1   CHAIN     MUSERDDF                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    MUSERDDF
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_MUSERDD
O    C                   MOVEL     Z_MUSERDD     G_MUSERDD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZMUSERDD '  I#FILE           10
O    C                   PARM      G_MUSERDD     IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_MUSERDD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    MUSERDDF
O    C                   ELSE
O    C                   WRITE     W_MUSERDDF
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
O    C                   OPEN      GZMUSERL1
O    C                   OPEN      GZMUSERDD
O
O     * Key lists
O
O    C     K_GZMUSERL1   KLIST
O    C                   KFLD                    USZONE
O    C                   KFLD                    USRP
 
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
