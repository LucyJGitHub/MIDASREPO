     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGLACBHTD - On-Line Update of Global File GZGLACBHTD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD023837           Date 27Nov13               *
      *  Prev Amend No. CGL135B  *CREATE   Date 10Jul13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD023837 - Triggers on tables GLACMNTD, GLACBHTD, GLACBDTD   *
      *             failed                                            *
      *  CGL135B - Accounting Rules Process                           *
      *                                                               *
      *****************************************************************
 
O    FGZGLACBHI1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZGLACBHTDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(GLACBHD0    :W_GLACBHD0     )
O    F                                     USROPN
O
O    D Z_GLACBHTD    E DS                  EXTNAME(GZGLACBHTD)
O    D G_GLACBHTD    E DS                  EXTNAME(GZGLACBHTD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_GLACBHTD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_GLACBHTD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        BHZONE
O
O    C     K_GZGLACBHI1  CHAIN     GLACBHD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    GLACBHD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_GLACBHTD
O    C                   MOVEL     Z_GLACBHTD    G_GLACBHTD
O     * Fix Data
     C                   CALLB     'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZGLACBHTD'  I#FILE           10
O    C                   PARM      G_GLACBHTD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_GLACBHTD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    GLACBHD0
O    C                   ELSE
O    C                   WRITE     W_GLACBHD0
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
O    C                   OPEN      GZGLACBHI1
O    C                   OPEN      GZGLACBHTD
O
O     * Key lists
O
O    C     K_GZGLACBHI1  KLIST
     C                   KFLD                    BHZONE                                     MD023837
O    C                   KFLD                    BHBTID
     C                   KFLD                    BHFRNT                                     MD023837
 
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
