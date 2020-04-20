     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPOTPAYDQD - On-Line Update of Global File GZOTPAYDQD        *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. ERZ248             Date 18Nov19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR1084524          Date 13Feb13               *
      *                 CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  ERZ248 - SWIFT UETR via OPAY API (Recompile)                 *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1084524 - Performance issue on IPAY & OPAY listview        *
      *              (Recompile)                                      *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
 
O    FGZOTPAYQL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZOTPAYDQDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(OTPAYQD0    :W_OTPAYQD0     )
O    F                                     USROPN
O
O    D Z_OTPAYDQD    E DS                  EXTNAME(GZOTPAYDQD)
O    D G_OTPAYDQD    E DS                  EXTNAME(GZOTPAYDQD) PREFIX(G_)
 
      ** ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
O
O     ** Global File Updates
O
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        Z_OTPAYDQD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_OTPAYDQD
O    C                   ENDIF
O
O    C     K_GZOTPAYQL1  CHAIN     OTPAYQD0                           99
O
O     ** 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    OTPAYQD0
O    C                   ELSE
O
O     ** 'After'
O
O    C                   CLEAR                   G_OTPAYDQD
O    C                   MOVEL     Z_OTPAYDQD    G_OTPAYDQD
O     ** Fix Data
O    C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZOTPAYDQD'  I#FILE           10
O    C                   PARM      G_OTPAYDQD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_OTPAYDQD
O     ** Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    OTPAYQD0
O    C                   ELSE
O    C                   WRITE     W_OTPAYQD0
O    C                   ENDIF
O    C                   ENDIF
 
     C                   RETURN
 
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
O
O     ** Open for commit?
O
O    C                   CALL      'GPCOPN4COM'
O    C                   PARM                    D_COM             1
O    C                   OPEN      GZOTPAYQL1
O    C                   OPEN      GZOTPAYDQD
O
O     ** Key lists
O
O    C     K_GZOTPAYQL1  KLIST
O    C                   KFLD                    OTBRCA
O    C                   KFLD                    OTPREF
 
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
 
      ** If no identified cause of error
 
     C     I#ERMS        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'UNEXPECTED ERROR'
     C                   ENDIF
 
      ** Log an error on the error log
 
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = I#ERMS
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER         4000
 
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************