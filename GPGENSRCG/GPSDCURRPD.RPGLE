     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*S*D****RPGBASEBNC****************************************************                       CGP017
/*STD *  RPGBASEMOD                                                   *                       CGP017
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDCURRPD - On-Line Update of Global File GZSDCURRPD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CGP017             Date 06Aug12               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER048             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                 CLE024             Date 20Oct04               *
      *                 CGP003             Date 25Mar04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG10215 - Global replication needs a global interface       *
      *  CLE024 - Collateralised Lending (Recompile)                  *
      *  CGP003 - Management Limits                                   *
      *           Required to inform Management Limits about          *
      *           changes in spot rates                               *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
O    FGZSDCURRL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDCURRPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDCURRD0    :W_SDCURRD0     )
O    F                                     USROPN
O
O    D Z_SDCURRPD    E DS                  EXTNAME(GZSDCURRPD)
O    D G_SDCURRPD    E DS                  EXTNAME(GZSDCURRPD) PREFIX(G_)
                                                                                            BUG10215
     D/COPY GPCPYSRCG,GPWRTALTDS                                                            BUG10215
 
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
O    C                   MOVEL     I#BIMG        Z_SDCURRPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDCURRPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        A6ZONE
O
O    C     K_GZSDCURRL1  CHAIN     SDCURRD0                           99
                                                                                            BUG10215
     C/COPY GPCPYSRCG,GPWRTAL2CR                                                            BUG10215
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDCURRD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDCURRPD
O    C                   MOVEL     Z_SDCURRPD    G_SDCURRPD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDCURRPD'  I#FILE           10
O    C                   PARM      G_SDCURRPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDCURRPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDCURRD0
O    C                   ELSE
O    C                   WRITE     W_SDCURRD0
O    C                   ENDIF
O    C                   ENDIF
                                                                                            BUG10215
     C/COPY GPCPYSRCG,GPWRTALTCR                                                            BUG10215
 
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
O    C                   OPEN      GZSDCURRL1
O    C                   OPEN      GZSDCURRPD
O
O     * Key lists
O
O    C     K_GZSDCURRL1  KLIST
O    C                   KFLD                    A6ZONE
O    C                   KFLD                    A6CYCD
 
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
