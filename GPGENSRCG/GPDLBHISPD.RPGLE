     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPDLBHISPD - On-Line Update of Global File GZDLBHISPD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CDL094             Date 30May14               *
      *                 CER059             Date 19Jul10               *
      *                 BUG25189           Date 27Jul09               *
      *                 CER034  *CREATE    Date 28Jul08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CDL094 - Enhance  Receive Settlement Instructions (Recompile)*
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25189 - MARG field on DLCHISPD contains invalid data after*
      *             the close of business (Recompile)                 *
      *  CER034 - German Features - New fields and enquiries          *
      *                                                               *
      *****************************************************************

O    FGZDLBHISL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZDLBHISPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(DLBHISD0    :W_DLBHISD0     )
O    F                                     USROPN
O
O    D Z_DLBHISPD    E DS                  EXTNAME(GZDLBHISPD)
O    D G_DLBHISPD    E DS                  EXTNAME(GZDLBHISPD) PREFIX(G_)

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
O    C                   MOVEL     I#BIMG        Z_DLBHISPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_DLBHISPD
O    C                   ENDIF
O
O    C     K_GZDLBHISL1  CHAIN     DLBHISD0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    DLBHISD0
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_DLBHISPD
O    C                   MOVEL     Z_DLBHISPD    G_DLBHISPD
O     * Fix Data
O    C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZDLBHISPD'  I#FILE           10
O    C                   PARM      G_DLBHISPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_DLBHISPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    DLBHISD0
O    C                   ELSE
O    C                   WRITE     W_DLBHISD0
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
O    C                   OPEN      GZDLBHISL1
O    C                   OPEN      GZDLBHISPD
O
O     * Key lists
O
O    C     K_GZDLBHISL1  KLIST
O    C                   KFLD                    BRCA
O    C                   KFLD                    DLNO

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
