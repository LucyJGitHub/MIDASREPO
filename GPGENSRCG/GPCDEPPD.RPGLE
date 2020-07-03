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
      *  GPCDEPPD   - On-Line Update of Global File GZCDEPPD          *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. 250019             Date 01Jun20               *      
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 09May06               *
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                 CGP001   *CREATE   Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  250019 - Added fields DDTE and PTFR in KLIST K_GZCDEPPL1     *
      *           after the fields were added as key in GZCDEPPL1.    *      
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build)   *
      *  BUG10215 - Global replication needs a global interface.      *
      *             - Moved from GPRPGSRCG to GPGENSRCG.              *
      *             - Code regenerated after the move.                *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
O    FGZCDEPPL1 UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZCDEPPD  O  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(CDEPPDF     :W_CDEPPDF      )
O    F                                     USROPN
O
O    D Z_CDEPPD      E DS                  EXTNAME(GZCDEPPD  )
O    D G_CDEPPD      E DS                  EXTNAME(GZCDEPPD  ) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_CDEPPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_CDEPPD
O    C                   ENDIF
O
O    C     K_GZCDEPPL1   CHAIN     CDEPPDF                            99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    CDEPPDF
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_CDEPPD
O    C                   MOVEL     Z_CDEPPD      G_CDEPPD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZCDEPPD  '  I#FILE           10
O    C                   PARM      G_CDEPPD      IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_CDEPPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    CDEPPDF
O    C                   ELSE
O    C                   WRITE     W_CDEPPDF
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
O    C                   OPEN      GZCDEPPL1
O    C                   OPEN      GZCDEPPD
O
O     * Key lists
O
O    C     K_GZCDEPPL1   KLIST
O    C                   KFLD                    CDPA
O    C                   KFLD                    CDCN
O    C                   KFLD                    CDSN
O    C                   KFLD                    CDPT
O    C                   KFLD                    CDMK
O    C                   KFLD                    DDTE                                         250019
O    C                   KFLD                    PTFR                                         250019
 
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
