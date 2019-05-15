     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGLFRBLTD - On-Line Update of Global File GZGLFRBLTD        *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD027208           Date 28May14               *
      *                 CGL155  *CREATE    Date 18Mar14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD027208 - RT postings not included in Nostro Group totals   *
      *             (Recompile)                                       *
      *  CGL155 - Forecast Group Limits                               *
      *                                                               *
      *****************************************************************
 
O    FGZGLFRBLI1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZGLFRBLTDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(GLFRBLD0    :W_GLFRBLD0     )
O    F                                     USROPN
O
O    D Z_GLFRBLTD    E DS                  EXTNAME(GZGLFRBLTD)
O    D G_GLFRBLTD    E DS                  EXTNAME(GZGLFRBLTD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_GLFRBLTD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_GLFRBLTD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        FCZONE
O
O    C     K_GZGLFRBLI1  CHAIN     GLFRBLD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    GLFRBLD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_GLFRBLTD
O    C                   MOVEL     Z_GLFRBLTD    G_GLFRBLTD
O     * Fix Data
     C                   CALLB     'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZGLFRBLTD'  I#FILE           10
O    C                   PARM      G_GLFRBLTD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_GLFRBLTD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    GLFRBLD0
O    C                   ELSE
O    C                   WRITE     W_GLFRBLD0
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
O    C                   OPEN      GZGLFRBLI1
O    C                   OPEN      GZGLFRBLTD
O
O     * Key lists
O
O    C     K_GZGLFRBLI1  KLIST
O    C                   KFLD                    FCZONE
O    C                   KFLD                    FCGRPC
O    C                   KFLD                    FCDATE
 
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
