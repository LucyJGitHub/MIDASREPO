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
      *  GPSFRAURPA - On-Line Update of Global File GZSFRAURPA        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CRE024  *CREATE    Date 22Dec05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  CRE024 - Restricted Account                                  *
      *                                                               *
      *****************************************************************
 
O    FGZSFRAURL1UF A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O
O    D Z_SFRAURPA    E DS                  EXTNAME(GZSFRAURPA)
O    D G_SFRAURPA    E DS                  EXTNAME(GZSFRAURPA) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_SFRAURPA
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SFRAURPA
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        MZONE
O
O    C     K_GZSFRAURL1  CHAIN     SFRAURP0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SFRAURP0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SFRAURPA
O    C                   MOVEL     Z_SFRAURPA    G_SFRAURPA
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
O    C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSFRAURPA'  I#FILE           10
O    C                   PARM      G_SFRAURPA    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SFRAURPA
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SFRAURP0
O    C                   ELSE
O    C                   WRITE     SFRAURP0
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
O    C                   OPEN      GZSFRAURL1
O
O     * Key lists
O
O    C     K_GZSFRAURL1  KLIST
O    C                   KFLD                    MZONE
O    C                   KFLD                    MAUSR
O    C                   KFLD                    MFRAC
 
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
