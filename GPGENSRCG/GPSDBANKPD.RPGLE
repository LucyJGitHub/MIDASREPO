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
      *  GPSDBANKPD - On-Line Update of Global File GZSDBANKPD        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10215           Date 27Sep06               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  BUG10215 - Global replication needs a global interface       *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
O    FGZSDBANKL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDBANKPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDBANKD0    :W_SDBANKD0     )
O    F                                     USROPN
O
O    D Z_SDBANKPD    E DS                  EXTNAME(GZSDBANKPD)
O    D G_SDBANKPD    E DS                  EXTNAME(GZSDBANKPD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_SDBANKPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDBANKPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        BJZONE
O
O    C     K_GZSDBANKL1  CHAIN     SDBANKD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDBANKD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDBANKPD
O    C                   MOVEL     Z_SDBANKPD    G_SDBANKPD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDBANKPD'  I#FILE           10
O    C                   PARM      G_SDBANKPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDBANKPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDBANKD0
O    C                   ELSE
O    C                   WRITE     W_SDBANKD0
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
O    C                   OPEN      GZSDBANKL1
O    C                   OPEN      GZSDBANKPD
O
O     * Key lists
O
O    C     K_GZSDBANKL1  KLIST
O    C                   KFLD                    BJZONE
O    C                   KFLD                    BJBANK
 
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
