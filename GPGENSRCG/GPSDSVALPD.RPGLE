     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDSVALPD - On-Line Update of Global File GZSDSVALPD        *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD054605           Date 17Oct19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 23Mar10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *                                                               *
      *****************************************************************

O    FGZSDSVALL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDSVALPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDSVALD0    :W_SDSVALD0     )
O    F                                     USROPN
O
O    D Z_SDSVALPD    E DS                  EXTNAME(GZSDSVALPD)
O    D G_SDSVALPD    E DS                  EXTNAME(GZSDSVALPD) PREFIX(G_)
     D SDSVLX          DS                                                                   MD054605
     D  XSVAL                  1     20                                                     MD054605
     D  XVAL                  21    220                                                     MD054605
     D  XLCD                 221    223P 0                                                  MD054605
     D  XLCT                 224    224                                                     MD054605

      * ENTRY PARAMETERS

     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
     C                   PARM                    I#FILE           10                        MD054605
O
      * If file is bespoke or core, perform normal process                                  MD054605
     C     I#FILE        IFEQ      'SDSVLCTD'                                               MD054605
     C     I#FILE        OREQ      'SDSVLBTD'                                               MD054605
O     * Global File Updates
O
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        Z_SDSVALPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDSVALPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        GIZONE
O
O    C     K_GZSDSVALL1  CHAIN     SDSVALD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDSVALD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDSVALPD
O    C                   MOVEL     Z_SDSVALPD    G_SDSVALPD
O     * Fix Data
O    C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDSVALPD'  I#FILE           10
O    C                   PARM      G_SDSVALPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDSVALPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDSVALD0
O    C                   ELSE
O    C                   WRITE     W_SDSVALD0
O    C                   ENDIF
O    C                   ENDIF

     C                   ENDIF                                                              MD054605
                                                                                            MD054605
      * If file is extension                                                                MD054605
     C     I#FILE        IFEQ      'SDSVLXTD'                                               MD054605
O     * only consider 'update after'                                                        MD054605
O                                                                                           MD054605
O    C     I#BFAF        IFNE      'B'                                                      MD054605
O    C                   MOVEL     I#AIMG        SDSVLX                                     MD054605
O    C                   MOVEL     XSVAL         GISVAL                                     MD054605
Z    C                   MOVEL     I#ZONE        GIZONE                                     MD054605
O                                                                                           MD054605
O    C     K_GZSDSVALL1  CHAIN     SDSVALD0                           99                    MD054605
O     * Update                                                                              MD054605
O    C     *IN99         IFEQ      *OFF                                                     MD054605
O    C                   MOVEL     XVAL          G_GIVAL                                    MD054605
O    C                   MOVEL     XLCD          G_GILCD                                    MD054605
O    C                   MOVEL     XLCT          G_GILCT                                    MD054605
O    C                   UPDATE    SDSVALD0                                                 MD054605
O    C                   ENDIF                                                              MD054605
                                                                                            MD054605
O    C                   ENDIF                                                              MD054605
O    C                   ENDIF                                                              MD054605
                                                                                            MD054605
     C                   SETON                                        LR                    MD054605
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
O    C                   OPEN      GZSDSVALL1
O    C                   OPEN      GZSDSVALPD
O
O     * Key lists
O
O    C     K_GZSDSVALL1  KLIST
O    C                   KFLD                    GIZONE
O    C                   KFLD                    GISVAL

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
