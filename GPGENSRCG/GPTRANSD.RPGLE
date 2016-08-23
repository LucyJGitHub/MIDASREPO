     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPTRANSD   - On-Line Update of Global File GZTRANSD          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD025452           Date 03Mar14               *
      *  Prev Amend No. MD022168  *CREATE  Date 12Sep13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD025452 - Missing program for module GOTRANSD introduced by *
      *             SWIFT 2013 at BF Midas 2.1 SP2 Patch K            *
      *  MD022168 - GZMEBIB3PD Replication                            *
      *                                                               *
      *****************************************************************
 
O    FGZTRANSL1 UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZTRANSD  O  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(TRANSDF     :W_TRANSDF      )
O    F                                     USROPN
O
O    D Z_TRANSD      E DS                  EXTNAME(GZTRANSD  )
O    D G_TRANSD      E DS                  EXTNAME(GZTRANSD  ) PREFIX(G_)
 
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
T    C**********         CALL      'GOWTTTRAN '
     C**********         CALLB     'GOWTTTRAN '                                             MD025452
T    C                   CALL      'GOWTTTRAN '                                             MD025452
T    C                   PARM      *BLANK        W#RTCD            7
T    C                   PARM      *BLANK        W#ERMS           50
T    C                   PARM                    I#BIMG
T    C                   PARM                    I#AIMG
T    C     W#RTCD        IFEQ      '*ERROR'
T    C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOWTTTRAN '
T    C                   EXSR      *PSSR
T    C                   ENDIF
T    C                   ENDIF
O
O     * Global File Updates
O
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        Z_TRANSD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_TRANSD
O    C                   ENDIF
O
O    C     K_GZTRANSL1   CHAIN     TRANSDF                            99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    TRANSDF
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_TRANSD
O    C                   MOVEL     Z_TRANSD      G_TRANSD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'
     C                   CALLB     'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZTRANSD  '  I#FILE           10
O    C                   PARM      G_TRANSD      IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_TRANSD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    TRANSDF
O    C                   ELSE
O    C                   WRITE     W_TRANSDF
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
O    C                   OPEN      GZTRANSL1
O    C                   OPEN      GZTRANSD
O
O     * Key lists
O
O    C     K_GZTRANSL1   KLIST
O    C                   KFLD                    BRCA
O    C                   KFLD                    TNBR
 
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
