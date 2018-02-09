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
      *  GPSDLOANPD - On-Line Update of Global File GZSDLOANPD        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE164             Date 18Aug14               *
      *                 CGP017             Date 06Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                 CLE042             Date 06Sep05               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *           (Recompile)                                         *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG10215 - Global replication needs a global interface       *
      *  CLE042 - Extended Loan Sub Type                              *
      *           Regenerated over changed GPGLOBFPD record for       *
      *           SDLOANPD: key field now AYLNTY, AYLNST and AYLNCL   *
      *           CLE042                                              *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
O    FGZSDLOANL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDLOANPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDLOAND0    :W_SDLOAND0     )
O    F                                     USROPN
O
O    D Z_SDLOANPD    E DS                  EXTNAME(GZSDLOANPD)
O    D G_SDLOANPD    E DS                  EXTNAME(GZSDLOANPD) PREFIX(G_)
 
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
O    C                   MOVEL     I#BIMG        Z_SDLOANPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDLOANPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        AYZONE
O
O    C     K_GZSDLOANL1  CHAIN     SDLOAND0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDLOAND0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_SDLOANPD
O    C                   MOVEL     Z_SDLOANPD    G_SDLOANPD
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDLOANPD'  I#FILE           10
O    C                   PARM      G_SDLOANPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDLOANPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDLOAND0
O    C                   ELSE
O    C                   WRITE     W_SDLOAND0
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
O    C                   OPEN      GZSDLOANL1
O    C                   OPEN      GZSDLOANPD
O
O     * Key lists
O
O    C     K_GZSDLOANL1  KLIST
O    C                   KFLD                    AYZONE
O    C                   KFLD                    AYLNTY
O    C                   KFLD                    AYLNST
O    C                   KFLD                    AYLNCL                                       CLE042
 
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
