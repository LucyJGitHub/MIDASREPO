     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Update Global Confirmation Matching File')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPCFFEEDPD - On-Line Update of Global File GPCFFEEDPD        *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG4562A           Date 25Aug06               *
      *                 BUG4562 *CREATE    Date 27Sep05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG4562A- Change code where DS Z_CFFEEDPD references         *
      *           CFFEEDPD to now use internal DS.                    *
      *  BUG4562- Global Processing for CFFEEDPD                      *
      *                                                               *
      *****************************************************************
 
O    FGPCFFEEDL0UF A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O
O    D*Z_CFFEEDPD****E DS                  EXTNAME(CFFEEDPD)                                BUG4562A
O    D G_CFFEEDPD    E DS                  EXTNAME(GPCFFEEDPD) PREFIX(G_)
 
      ** CFFEEDL0 key
     D  WCFKY          DS            16
     D  WTST1                  1      8
     D  WKEY1                  1      2
     D  WKEY2                  3      8
     D  WKEY3                  9     11
                                                                                            BUG4562A
      ** Z_CFFEEDPD as internally described ***                                             BUG4562A
     D  Z_CFFEEDPD     DS           139                                                     BUG4562A
     D  DTSC                   1      6  0                                                  BUG4562A
     D  TMSC                   7     12  0                                                  BUG4562A
     D  IMRF                  13     28                                                     BUG4562A
     D  FRF1                  29     63                                                     BUG4562A
     D  FRF2                  64     98                                                     BUG4562A
     D  CPRF                  99    114                                                     BUG4562A
     D  CPSX                 115    116  0                                                  BUG4562A
     D  BKRF                 117    132                                                     BUG4562A
     D  BKSX                 133    134  0                                                  BUG4562A
     D  CHSN                 135    135                                                     BUG4562A
     D  CNRQ                 136    136                                                     BUG4562A
     D  BRCA                 137    139                                                     BUG4562A
                                                                                            BUG4562A
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
O    C                   MOVEL     I#BIMG        Z_CFFEEDPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_CFFEEDPD
O    C                   ENDIF
O
     C                   EVAL      WCFKY = IMRF
O
O    C     K_GPCFFEEDL0  CHAIN     GPCFFEEDD0                         99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C     *IN99         IFEQ      *OFF
O    C     WKEY3         ANDEQ     G_CFSEQ
O    C                   DELETE    GPCFFEEDD0
O    C                   ENDIF
O    C                   ELSE
O
O     * 'After'
O
     C                   EVAL      *IN77   = *OFF
O    C     WKEY3         IFGE      G_CFSEQ
     C                   EVAL      *IN77   = *ON
O    C                   ENDIF
O    C                   CLEAR                   G_CFFEEDPD
O    C                   MOVEL     Z_CFFEEDPD    G_CFFEEDPD
     C                   EVAL      G_CFMOD = WKEY1
     C                   EVAL      G_CFTRAN = WKEY2
     C                   EVAL      G_CFSEQ = WKEY3
     C                   EVAL      G_CFZONE = I#ZONE
O     * Fix Data
O    *****               CALL      'GPFIXGDTA'
O    *****               PARM                    I#ZONE
O    *****               PARM      'GPCFFEEDPD'  I#FILE           10
O    *****               PARM      G_CFFEEDPD    IO#BUFFER      4000
O    *****               MOVEL     IO#BUFFER     G_CFFEEDPD
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C     *IN77         IFEQ      *ON
O    C                   UPDATE    GPCFFEEDD0
O    C                   ENDIF
O    C                   ELSE
O    C                   WRITE     GPCFFEEDD0
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
O    C                   OPEN      GPCFFEEDL0
O
O     * Key lists
O
O    C     K_GPCFFEEDL0  KLIST
     C                   KFLD                    I#ZONE
     C                   KFLD                    WKEY1
     C                   KFLD                    WKEY2
 
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
