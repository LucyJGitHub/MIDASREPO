     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGLACMI1D - On-Line Update of Global File GZGLACMI1D        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CRE101  *CREATE    Date 18Aug14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE101 - Interim Interest Statement on a Frequency           *
      *                                                               *
      *****************************************************************
 
     FGZGLACMI11UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
     F                                     USROPN
     FGZGLACMI1DO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
     F                                     RENAME(GLACMID1    :W_GLACMID1     )
     F                                     USROPN
 
     D Z_GLACMI1D    E DS                  EXTNAME(GZGLACMI1D)
     D G_GLACMI1D    E DS                  EXTNAME(GZGLACMI1D) PREFIX(G_)
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
 
      * Global File Updates
 
     C     I#BFAF        IFEQ      'B'
     C                   MOVEL     I#BIMG        Z_GLACMI1D
     C                   ELSE
     C                   MOVEL     I#AIMG        Z_GLACMI1D
     C                   ENDIF
 
     C     K_GZGLACMI11  CHAIN     GLACMID1                           99
 
      * 'Before'
 
     C     I#BFAF        IFEQ      'B'
     C  N99              DELETE    GLACMID1
     C                   ELSE
 
      * 'After'
 
     C                   CLEAR                   G_GLACMI1D
     C                   MOVEL     Z_GLACMI1D    G_GLACMI1D
      * Fix Data
     C**********         CALL      'GPFIXGDTA'
     C                   CALLB     'GPFIXGDTA'
     C                   PARM                    I#ZONE
     C                   PARM      'GZGLACMI1D'  I#FILE           10
     C                   PARM      G_GLACMI1D    IO#BUFFER      4000
     C                   MOVEL     IO#BUFFER     G_GLACMI1D
      * Update
     C     *IN99         IFEQ      *OFF
     C                   UPDATE    GLACMID1
     C                   ELSE
     C                   WRITE     W_GLACMID1
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
 
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Open for commit?
 
     C                   CALL      'GPCOPN4COM'
     C                   PARM                    D_COM             1
     C                   OPEN      GZGLACMI11
     C                   OPEN      GZGLACMI1D
 
      * Key lists
 
     C     K_GZGLACMI11  KLIST
     C                   KFLD                    MICNUM
     C                   KFLD                    MICCY
     C                   KFLD                    MIACOD
     C                   KFLD                    MIACSQ
     C                   KFLD                    MIBRCA
 
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
