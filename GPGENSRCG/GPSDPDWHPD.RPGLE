     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*S*D****RPGBASEBNC****************************************************                       CGP017
/*STD *  RPGBASEMOD                                                   *                       CGP017
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDPDWHPD - On-Line Update of Global File GZSDPDWHPD        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD056557           Date 31Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10215           Date 27Sep06               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056557 - Deliverable Data Split for Pulldown               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  BUG10215 - Global replication needs a global interface       *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

O    FGZSDPDWHL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDPDWHPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDPDWHD0    :W_SDPDWHD0     )
O    F                                     USROPN
O
O    D Z_SDPDWHPD    E DS                  EXTNAME(GZSDPDWHPD)
O    D G_SDPDWHPD    E DS                  EXTNAME(GZSDPDWHPD) PREFIX(G_)
     D SDPDWH          DS                                                                   MD056557
     D  XHIDN                  1     10  0                                                  MD056557

      * ENTRY PARAMETERS

     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
     C                   PARM                    I#FILE           10                        MD056557
O
      * If file is bespoke or core, perform normal process                                  MD056557
     C     I#FILE        IFEQ      'SDPWHCTD'                                               MD056557
     C     I#FILE        OREQ      'SDPWHBTD'                                               MD056557
O     * Global File Updates
O
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        Z_SDPDWHPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDPDWHPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        GHZONE
O
O    C     K_GZSDPDWHL1  CHAIN     SDPDWHD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDPDWHD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDPDWHPD
O    C                   MOVEL     Z_SDPDWHPD    G_SDPDWHPD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDPDWHPD'  I#FILE           10
O    C                   PARM      G_SDPDWHPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDPDWHPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDPDWHD0
O    C                   ELSE
O    C                   WRITE     W_SDPDWHD0
O    C                   ENDIF
O    C                   ENDIF

     C                   ENDIF                                                              MD056557
                                                                                            MD056557
      * If file is extension                                                                MD056557
     C     I#FILE        IFEQ      'SDPWHXTD'                                               MD056557
O     * only consider 'update after'                                                        MD056557
O                                                                                           MD056557
O    C     I#BFAF        IFNE      'B'                                                      MD056557
O                                                                                           MD056557
O    C                   MOVEL     I#AIMG        SDPDWH                                     MD056557
Z    C                   MOVEL     I#ZONE        GHZONE                                     MD056557
                                                                                            MD056557
O    C     K_GZSDPDWHL1  CHAIN     SDPDWHD0                           99                    MD056557
      * Update                                                                              MD056557
O    C     *IN99         IFEQ      *OFF                                                     MD056557
O    C                   UPDATE    SDPDWHD0                                                 MD056557
O    C                   ENDIF                                                              MD056557
                                                                                            MD056557
O    C                   ENDIF                                                              MD056557
O    C                   ENDIF                                                              MD056557
                                                                                            MD056557
     C                   SETON                                        LR                    MD056557
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
O    C                   OPEN      GZSDPDWHL1
O    C                   OPEN      GZSDPDWHPD
O
O     * Key lists
O
O    C     K_GZSDPDWHL1  KLIST
O    C                   KFLD                    GHZONE
O    C                   KFLD                    GHHIND

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
