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
      *  GPSCSARDPD - On-Line Update of Global File GZSCSARDPD        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD048501           Date 08Nov17               *
      *                 MD023266           Date 07Nov13               *
      *                 CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  MD048501 - Internal failure on call to GPFIXGDT              *
      *  MD023266 - Dumps in CGL135 and CGL146 Switch-On (Recompile)  *
      *           - Applied for MD023043                              *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  BUG10215 - Global replication needs a global interface       *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

O    FGZSCSARDL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSCSARDPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SCSARDD0    :W_SCSARDD0     )
O    F                                     USROPN
O
O    D Z_SCSARDPD    E DS                  EXTNAME(GZSCSARDPD)
O    D G_SCSARDPD    E DS                  EXTNAME(GZSCSARDPD) PREFIX(G_)
     D SCSARD          DS                                                                   MD055681
     D  XSAR                   1      6                                                     MD055681
     D  XENBLD                21     21                                                     MD055681

      * ENTRY PARAMETERS

     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
     C                   PARM                    I#FILE           10                        MD055681
O
      * If file is bespoke or core, perform normal process                                  MD055681
     C     I#FILE        IFEQ      'SCSRDCTD'                                               MD055681
     C     I#FILE        OREQ      'SCSRDBTD'                                               MD055681
O     * Global File Updates
O
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        Z_SCSARDPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SCSARDPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        ZONE
O
O    C     K_GZSCSARDL1  CHAIN     SCSARDD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SCSARDD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SCSARDPD
O    C                   MOVEL     Z_SCSARDPD    G_SCSARDPD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C**********         CALLB     'GPFIXGDTA'                                       CGP017 MD048501
     C                   CALL      'GPFIXGDTA'                                              MD048501
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSCSARDPD'  I#FILE           10
O    C                   PARM      G_SCSARDPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SCSARDPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SCSARDD0
O    C                   ELSE
O    C                   WRITE     W_SCSARDD0
O    C                   ENDIF
O    C                   ENDIF

     C                   ENDIF                                                              MD055681
                                                                                            MD055681
      * If file is extension                                                                MD055681
     C     I#FILE        IFEQ      'SCSRDXTD'                                               MD055681
O     * only consider 'update after'                                                        MD055681
O                                                                                           MD055681
O    C     I#BFAF        IFNE      'B'                                                      MD055681
O                                                                                           MD055681
O    C                   MOVEL     I#AIMG        SCSARD                                     MD055681
O    C                   MOVEL     XSAR          SARN                                       MD055681
Z    C                   MOVEL     I#ZONE        ZONE                                       MD055681
O     * if feature has been disabled, delete GZ record                                      MD055681
O    C     XENBLD        IFEQ      'D'                                                      MD055681
O    C     K_GZSCSARDL1  CHAIN     SCSARDD0                           99                    MD055681
O    C  N99              DELETE    SCSARDD0                                                 MD055681
     C                   ENDIF                                                              MD055681
                                                                                            MD055681
O     * if feature has been enable, write GZ record                                         MD055681
O    C     XENBLD        IFEQ      'E'                                                      MD055681
O    C     K_GZSCSARDL1  CHAIN     SCSARDD0                           99                    MD055681
O    C   99              MOVEL     SARN          G_SARN                                     MD055681
O    C   99              MOVEL     *BLANKS       G_SARD                                     MD055681
O    C   99              Z-ADD     0             G_LCD                                      MD055681
O    C   99              MOVEL     'I'           G_TYLC                                     MD055681
O    C   99              MOVEL     ZONE          G_ZONE                                     MD055681
O    C   99              WRITE     W_SCSARDD0                                               MD055681
     C                   ENDIF                                                              MD055681
                                                                                            MD055681
O    C                   ENDIF                                                              MD055681
O    C                   ENDIF                                                              MD055681
                                                                                            MD055681
     C                   SETON                                        LR                    MD055681
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
O    C                   OPEN      GZSCSARDL1
O    C                   OPEN      GZSCSARDPD
O
O     * Key lists
O
O    C     K_GZSCSARDL1  KLIST
O    C                   KFLD                    ZONE
O    C                   KFLD                    SARN

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
