     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGLATMIPD - GL Account Transfer Manual Input                *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1075388          Date 21Nov13               *
      *                 AR845655           Date 06Oct11               *
      *                 CRE067             Date 05Oct10               *
      *                 BUG27831A          Date 04Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204 *CREATE     Date 20Jan10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1075388 - Account transfer fees - net (Child:AR1075389)    *
      *              Applied for MD-23536 (Recompile)                 *
      *  AR845655 - Update datatype of Paying Bank to Alphanumeric    *
      *             (Recompile)                                       *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  BUG27831A - Forward Account Transfer Processing              *
      *              (Recompiled due to changes in GLATMIPD)          *
      *  CAP204 - Retail Account Transfer                             *
      *                                                               *
      *****************************************************************
 
O    FGZGLATMIL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZGLATMIPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(GLATMID0    :W_GLATMID0     )
O    F                                     USROPN
O
O    D Z_GLATMIPD    E DS                  EXTNAME(GZGLATMIPD)
O    D G_GLATMIPD    E DS                  EXTNAME(GZGLATMIPD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_GLATMIPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_GLATMIPD
O    C                   ENDIF
O
O    C     K_GZGLATMIL1  CHAIN     GLATMID0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    GLATMID0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_GLATMIPD
O    C                   MOVEL     Z_GLATMIPD    G_GLATMIPD
O     * Fix Data
O    C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZGLATMIPD'  I#FILE           10
O    C                   PARM      G_GLATMIPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_GLATMIPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    GLATMID0
O    C                   ELSE
O    C                   WRITE     W_GLATMID0
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
O    C                   OPEN      GZGLATMIL1
O    C                   OPEN      GZGLATMIPD
O
O     * Key lists
O
O    C     K_GZGLATMIL1  KLIST
O    C                   KFLD                    R1BRCA
O    C                   KFLD                    R1TREF
 
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
