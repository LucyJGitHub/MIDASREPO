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
      *  GPGLJENHPD - On-Line Update of Global File GZGLJENHPD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG10215 *REBUILD  Date 27Sep06               *
      *                 CSC024             Date 07Feb05               *
      *                 BUG2427 (Reopen)   Date 25May04               *
      *                 BUG2427            Date 11May04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  BUG10215 - Global replication needs a global interface       *
      *  CSC024 - Open Month End (Recompile)                          *
      *  BUG2427- Reverse previous changes made so that commit        *
      *           control definition will be present on GZGLJENHL1    *
      *           file.                                               *
      *  BUG2427- Remove commit control definition on GZGLJENHL1 file *
      *           so that the CPF4326 error would not occur.  This    *
      *           would allow the update of the GZGLJENHPD file so    *
      *           that only 1 user could update a batch header at a   *
      *           time.                                               *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
O    FGZGLJENHL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZGLJENHPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(@BRREMA     :W_@BRREMA      )
O    F                                     USROPN
O
O    D Z_GLJENHPD    E DS                  EXTNAME(GZGLJENHPD)
O    D G_GLJENHPD    E DS                  EXTNAME(GZGLJENHPD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_GLJENHPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_GLJENHPD
O    C                   ENDIF
O
O    C     K_GZGLJENHL1  CHAIN     @BRREMA                            99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    @BRREMA
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_GLJENHPD
O    C                   MOVEL     Z_GLJENHPD    G_GLJENHPD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZGLJENHPD'  I#FILE           10
O    C                   PARM      G_GLJENHPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_GLJENHPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    @BRREMA
O    C                   ELSE
O    C                   WRITE     W_@BRREMA
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
O    C                   OPEN      GZGLJENHL1
O    C                   OPEN      GZGLJENHPD
O
O     * Key lists
O
O    C     K_GZGLJENHL1  KLIST
O    C                   KFLD                    BRBCDA
O    C                   KFLD                    BRBTNB
 
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
