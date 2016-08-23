     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGLJENP1D - On-Line Update of Global File GZGLJENP1D        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CGL135A  *Create   Date 10Jul13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL135A - Accounting Rules Process                           *
      *                                                               *
      *****************************************************************
 
O    FGZGLJENPI1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZGLJENP1DO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(GLJENPD0    :W_GLJENPD0     )
O    F                                     USROPN
O
O    D Z_GLJENP1D    E DS                  EXTNAME(GZGLJENP1D)
O    D G_GLJENP1D    E DS                  EXTNAME(GZGLJENP1D) PREFIX(G_)
 
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
     C                   MOVEL     I#BIMG        Z_GLJENP1D
     C                   ELSE
     C                   MOVEL     I#AIMG        Z_GLJENP1D
     C                   ENDIF
     C                   MOVEL     I#ZONE        BEZONE
 
     C     K_GZGLJENPI1  CHAIN     GLJENPD0                           99
 
      * 'Before'
 
     C     I#BFAF        IFEQ      'B'
     C  N99              DELETE    GLJENPD0
     C                   ELSE
 
      * 'After'
 
     C                   CLEAR                   G_GLJENP1D
     C                   MOVEL     Z_GLJENP1D    G_GLJENP1D
      * Fix Data
     C                   CALLB     'GPFIXGDTA'
     C                   PARM                    I#ZONE
     C                   PARM      'GZGLJENP1D'  I#FILE           10
     C                   PARM      G_GLJENP1D    IO#BUFFER      4000
     C                   MOVEL     IO#BUFFER     G_GLJENP1D
      * Update
     C     *IN99         IFEQ      *OFF
     C                   UPDATE    GLJENPD0
     C                   ELSE
     C                   WRITE     W_GLJENPD0
     C                   ENDIF
     C                   ENDIF
 
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
O    C                   OPEN      GZGLJENPI1
O    C                   OPEN      GZGLJENP1D
O
O     * Key lists
O
O    C     K_GZGLJENPI1  KLIST
O    C                   KFLD                    BEZONE
O    C                   KFLD                    BEPSTD
O    C                   KFLD                    BEBTNB
O    C                   KFLD                    BEBINB
O    C                   KFLD                    BEBRCA
 
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
