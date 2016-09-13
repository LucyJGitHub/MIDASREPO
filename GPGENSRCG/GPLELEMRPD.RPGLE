     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPLELEMRPD - On-Line Update of Global File GZLELEMRPD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. MD041012           Date 09Sep16               *
      *  Prev Amend No. CLE068   *CREATE   Date 03Aug16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041012 - Component GOC0100 00244 failed during COB due to  *
      *             The match field for file GZLELEMRL0 is out of seq.*
      *           - Recompile only due to changes in GZLELEMRL1       *
      *  CLE068 - Loan Event Modeller                                 *
      *                                                               *
      *****************************************************************

O    FGZLELEMRL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZLELEMRPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(LELEMRWF    :W_LELEMRWF     )
O    F                                     USROPN
O

O    D Z_LELEMRWPD   E DS                  EXTNAME(GZLELEMRPD)
O    D G_LELEMRWPD   E DS                  EXTNAME(GZLELEMRPD) PREFIX(G_)

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
O    C                   MOVEL     I#BIMG        Z_LELEMRWPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_LELEMRWPD
O    C                   ENDIF
O
O    C     K_GZLELEMRL1  CHAIN     LELEMRWF                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    LELEMRWF
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_LELEMRWPD
O    C                   MOVEL     Z_LELEMRWPD   G_LELEMRWPD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'
     C                   CALLB     'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZLELEMRPD'  I#FILE           10
O    C                   PARM      G_LELEMRWPD   IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_LELEMRWPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    LELEMRWF
O    C                   ELSE
O    C                   WRITE     W_LELEMRWF
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
O    C                   OPEN      GZLELEMRL1
O    C                   OPEN      GZLELEMRPD
O
O     * Key lists
O
O    C     K_GZLELEMRL1  KLIST
O    C                   KFLD                    BRCA
O    C                   KFLD                    LNRF
O    C                   KFLD                    VDAT
O    C                   KFLD                    LASN

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
