     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDACUSPD - On-Line Update of Global File GZSDACUSPD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CER071             Date 01Aug16               *
      *  Prev Amend No. CER070             Date 19Aug14               *
      *                 CGL132             Date 01May13               *
      *                 CLE134             Date 01Aug12               *
      *                 AR742563           Date 06Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 BUG22529 *CREATE   Date 05Feb09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master (Recompile)                 *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR742563 - Global Replication : GZSDACUSPD vs SDACUSPD       *
      *             (Child: AR742564) (Recompile)                     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG22529 - Global Additional Customer Details                *
      *                                                               *
      *****************************************************************

O    FGZSDACUSL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDACUSPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDACUSD0    :W_SDACUSD0     )
O    F                                     USROPN
O
O    D Z_SDACUSPD    E DS                  EXTNAME(GZSDACUSPD)
O    D G_SDACUSPD    E DS                  EXTNAME(GZSDACUSPD) PREFIX(G_)

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
O    C                   MOVEL     I#BIMG        Z_SDACUSPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDACUSPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        E5ZONE
O
O    C     K_GZSDACUSL1  CHAIN     SDACUSD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDACUSD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDACUSPD
O    C                   MOVEL     Z_SDACUSPD    G_SDACUSPD
O     * Fix Data
O    C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDACUSPD'  I#FILE           10
O    C                   PARM      G_SDACUSPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDACUSPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDACUSD0
O    C                   ELSE
O    C                   WRITE     W_SDACUSD0
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
O    C                   OPEN      GZSDACUSL1
O    C                   OPEN      GZSDACUSPD
O
O     * Key lists
O
O    C     K_GZSDACUSL1  KLIST
O    C                   KFLD                    E5ZONE
O    C                   KFLD                    E5CUST

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
