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
      *  GPSDYLDRPD - On-Line Update of Global File GZSDYLDRPD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK024             Date 03Feb06               *
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                 CLE024             Date 20Oct03               *
      *                 BG1364             Date 04Mar04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  CPK024   - Release Package for MP1.2.1                       *
      *  BUG10215 - Global replication needs a global interface       *
      *  CLE024 - Collateralised Lending                              *
      *  BG1364 - Filter Duplicate records in Bulk Synchronization    *
      *           (Regenerated)                                       *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
O    FGZSDYLDRL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDYLDRPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDYLDRD0    :W_SDYLDRD0     )
O    F                                     USROPN
O
O    D Z_SDYLDRPD    E DS                  EXTNAME(GZSDYLDRPD)
O    D G_SDYLDRPD    E DS                  EXTNAME(GZSDYLDRPD) PREFIX(G_)
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
O    C                   MOVEL     I#BIMG        Z_SDYLDRPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDYLDRPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        FSZONE
O
O    C     K_GZSDYLDRL1  CHAIN     SDYLDRD0                           99
                                                                                            BUG10215
     C*/COPY*GPCPYSRCR,GPWRTAL2YR                                                    BUG10215 CPK024
     C/COPY GPCPYSRCG,GPWRTAL2YR                                                              CPK024
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDYLDRD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDYLDRPD
O    C                   MOVEL     Z_SDYLDRPD    G_SDYLDRPD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDYLDRPD'  I#FILE           10
O    C                   PARM      G_SDYLDRPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDYLDRPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDYLDRD0
O    C                   ELSE
O    C                   WRITE     W_SDYLDRD0
O    C                   ENDIF
O    C                   ENDIF
                                                                                            BUG10215
     C*/COPY*GPCPYSRCR,GPWRTALTYR                                                    BUG10215 CPK024
     C/COPY GPCPYSRCG,GPWRTALTYR                                                              CPK024
 
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
O    C                   OPEN      GZSDYLDRL1
O    C                   OPEN      GZSDYLDRPD
O
O     * Key lists
O
O    C     K_GZSDYLDRL1  KLIST
O    C                   KFLD                    FSZONE
O    C                   KFLD                    FSYLDC
O    C                   KFLD                    FSYCCY
O    C                   KFLD                    FSYICM
O    C                   KFLD                    FSMMDN
 
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
