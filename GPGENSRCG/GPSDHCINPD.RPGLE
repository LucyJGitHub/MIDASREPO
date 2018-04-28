     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDHCINPD - On-Line Update of Global File GZSDHCINPD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD026599           Date 28May14               *
      *  Prev Amend No. MD026848           Date 12May14               *
      *                 CSD092   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD026599 - FATCA information complete flag is missing in     *
      *             history of customer information (Recompile)       *
      *  MD026848 - History of cust information is not updated when   *
      *             customer's FATCA classification is change         *
      *             manually                                          *
      *  CSD092 - Account Review                                      *
      *                                                               *
      *****************************************************************
 
O    FGZSDHCINL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDHCINPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDHCIND0    :W_SDHCIND0     )
O    F                                     USROPN
O
O    D Z_SDHCINPD    E DS                  EXTNAME(GZSDHCINPD)
O    D G_SDHCINPD    E DS                  EXTNAME(GZSDHCINPD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_SDHCINPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDHCINPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        HCZONE
O
O    C     K_GZSDHCINL1  CHAIN     SDHCIND0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDHCIND0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDHCINPD
O    C                   MOVEL     Z_SDHCINPD    G_SDHCINPD
O     * Fix Data
O    C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDHCINPD'  I#FILE           10
O    C                   PARM      G_SDHCINPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDHCINPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDHCIND0
O    C                   ELSE
O    C                   WRITE     W_SDHCIND0
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
O    C                   OPEN      GZSDHCINL1
O    C                   OPEN      GZSDHCINPD
O
O     * Key lists
O
O    C     K_GZSDHCINL1  KLIST
O    C                   KFLD                    HCZONE
O    C                   KFLD                    HCCUST
O    C                   KFLD                    HCCDAT
O    C**********         KFLD                    HCCTIM                                     MD026848
O    C                   KFLD                    HCTMST                                     MD026848
 
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
