     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDHCIDPD - On-Line Update of Global File GZSDHCIDPD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD027295           Date 24May14               *
      *  Prev Amend No. MD026848           Date 12May14               *
      *                 MD026193           Date 07Apr14               *
      *                 CSD092   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD027295 - SDC009697 COB component run too long              *
      *  MD026848 - History of cust information is not updated when   *
      *             customer's FATCA classification is change         *
      *             manually                                          *
      *  MD026193 - History of cust information is not updated        *
      *  CSD092 - Account Review                                      *
      *                                                               *
      *****************************************************************
 
O    FGZSDHCIDL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDHCIDPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDHCIDD0    :W_SDHCIDD0     )
O    F                                     USROPN
O
O    D Z_SDHCIDPD    E DS                  EXTNAME(GZSDHCIDPD)
O    D G_SDHCIDPD    E DS                  EXTNAME(GZSDHCIDPD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_SDHCIDPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDHCIDPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        HDZONE
O
O    C     K_GZSDHCIDL1  CHAIN     SDHCIDD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDHCIDD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDHCIDPD
O    C                   MOVEL     Z_SDHCIDPD    G_SDHCIDPD
O     * Fix Data
O    C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDHCIDPD'  I#FILE           10
O    C                   PARM      G_SDHCIDPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDHCIDPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDHCIDD0
O    C                   ELSE
O    C                   WRITE     W_SDHCIDD0
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
O    C                   OPEN      GZSDHCIDL1
O    C                   OPEN      GZSDHCIDPD
O
O     * Key lists
O
O    C     K_GZSDHCIDL1  KLIST
O    C                   KFLD                    HDZONE
O    C                   KFLD                    HDCUST
O    C                   KFLD                    HDFILN                                     MD027295
O    C                   KFLD                    HDCDAT
O    C**********         KFLD                    HDCTIM                                     MD026848
O    C                   KFLD                    HDTMST                                     MD026848
O    C**********         KFLD                    HDFILN                            MD026193 MD027295
O    C**********         KFLD                    HDIMGT                            MD026193 MD027295
 
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
