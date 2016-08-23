     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas OF Total Forecast')                              *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGLFORTTD - On-Line Update of Global File GZGLFORTTD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD024003           Date 10Dec13               *
      *  Prev Amend No. CGL145A            Date 08Oct13               *
      *                 CGL145   *CREATE   Date 10Jul13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD024003 - Nostro Summary screen does not display any        *
      *             details (Recompile)                               *
      *  CGL145A - Subsidiaries Daily Sweeping Forecast               *
      *            Recompile due to changes in GLFORTTD/GZGLFORTTD    *
      *  CGL145 - Subsidiaries Daily Sweeping Forecast                *
      *                                                               *
      *****************************************************************
 
O    FGZGLFORTI1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZGLFORTTDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(GLFORTD0    :W_GLFORTD0     )
O    F                                     USROPN
O
O    D Z_GLFORTTD    E DS                  EXTNAME(GZGLFORTTD)
O    D G_GLFORTTD    E DS                  EXTNAME(GZGLFORTTD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_GLFORTTD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_GLFORTTD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        TFZONE
O
O    C     K_GZGLFORTI1  CHAIN     GLFORTD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    GLFORTD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_GLFORTTD
O    C                   MOVEL     Z_GLFORTTD    G_GLFORTTD
O     * Fix Data
     C                   CALLB     'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZGLFORTTD'  I#FILE           10
O    C                   PARM      G_GLFORTTD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_GLFORTTD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    GLFORTD0
O    C                   ELSE
O    C                   WRITE     W_GLFORTD0
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
O    C                   OPEN      GZGLFORTI1
O    C                   OPEN      GZGLFORTTD
O
O     * Key lists
O
O    C     K_GZGLFORTI1  KLIST
O    C                   KFLD                    TFCUST
O    C                   KFLD                    TFCSAC
O    C                   KFLD                    TFCCY
O    C                   KFLD                    TFNOSC
O    C                   KFLD                    TFDATE
O    C                   KFLD                    TFFACN
 
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
