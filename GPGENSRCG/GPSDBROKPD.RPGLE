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
      *  GPSDBROKPD - On-Line Update of Global File GZSDBROKPD        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD058085           Date 11May21               *
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
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  BUG10215 - Global replication needs a global interface       *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

O    FGZSDBROKL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDBROKPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDBROKD0    :W_SDBROKD0     )
O    F                                     USROPN
O
O    D Z_SDBROKPD    E DS                  EXTNAME(GZSDBROKPD)
O    D G_SDBROKPD    E DS                  EXTNAME(GZSDBROKPD) PREFIX(G_)
     D SDBROKX         DS                                                                   MD058085
     D  ABROK                  1      4                                                     MD058085
     D  ABRCY                  5      7                                                     MD058085
     D  ALCD                   8     10P 0                                                  MD058085
     D  ATYLC                 11     11                                                     MD058085
     D  ABKNM                 12     41                                                     MD058085
     D  ABRTN                 42     51                                                     MD058085
     D  AACBC                 52     54                                                     MD058085
     D  AOGID                 55     64                                                     MD058085
     D  AEBS                  65     65                                                     MD058085

      * ENTRY PARAMETERS

     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
     C                   PARM                    I#FILE           10                        MD058085
O
      * If file is bespoke or core, perform normal process                                  MD058085
     C     I#FILE        IFEQ      'SDBRKCTD'                                               MD058085
     C     I#FILE        OREQ      'SDBRKBTD'                                               MD058085
O     * Global File Updates
O
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        Z_SDBROKPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDBROKPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        A9ZONE
O
O    C     K_GZSDBROKL1  CHAIN     SDBROKD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDBROKD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDBROKPD
O    C                   MOVEL     Z_SDBROKPD    G_SDBROKPD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDBROKPD'  I#FILE           10
O    C                   PARM      G_SDBROKPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDBROKPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDBROKD0
O    C                   ELSE
O    C                   WRITE     W_SDBROKD0
O    C                   ENDIF
O    C                   ENDIF
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
      * If file is extension                                                                MD058085
     C     I#FILE        IFEQ      'SDBRKXTD'                                               MD058085
O     * only consider 'update after'                                                        MD058085
O                                                                                           MD058085
O    C     I#BFAF        IFNE      'B'                                                      MD058085
O                                                                                           MD058085
O    C                   MOVEL     I#AIMG        SDBROKX                                    MD058085
O    C                   MOVEL     ABROK         A9BROK                                     MD058085
Z    C                   MOVEL     I#ZONE        A9ZONE                                     MD058085
                                                                                            MD058085
O    C     K_GZSDBROKL1  CHAIN     SDBROKD0                           99                    MD058085
      * Update                                                                              MD058085
O    C     *IN99         IFEQ      *OFF                                                     MD058085
O    C                   MOVEL     ABRCY         G_A9BRCY                                   MD058085
O    C                   MOVEL     ALCD          G_A9LCD                                    MD058085
O    C                   MOVEL     ATYLC         G_A9TYLC                                   MD058085
O    C                   MOVEL     ABKNM         G_A9BKNM                                   MD058085
O    C                   MOVEL     ABRTN         G_A9BRTN                                   MD058085
O    C                   MOVEL     AACBC         G_A9ACBC                                   MD058085
O    C                   MOVEL     AOGID         G_A9OGID                                   MD058085
O    C                   MOVEL     AEBS          G_A9EBS                                    MD058085
O    C                   UPDATE    SDBROKD0                                                 MD058085
O    C                   ENDIF                                                              MD058085
                                                                                            MD058085
O    C                   ENDIF                                                              MD058085
O    C                   ENDIF                                                              MD058085
                                                                                            MD058085
     C                   SETON                                        LR                    MD058085

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
O    C                   OPEN      GZSDBROKL1
O    C                   OPEN      GZSDBROKPD
O
O     * Key lists
O
O    C     K_GZSDBROKL1  KLIST
O    C                   KFLD                    A9ZONE
O    C                   KFLD                    A9BROK

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
