     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDCMDTPD - On-Line Update of Global File GZSDCMDTPD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CMG003  *CREATE    Date 04Oct12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMG003 - SWIFT MT600 Message Generation                      *
      *                                                               *
      *****************************************************************
 
O    FGZSDCMDTL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    FGZSDCMDTPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(SDCMDTD0    :W_SDCMDTD0     )
O    F                                     USROPN
O
O    D Z_SDCMDTPD    E DS                  EXTNAME(GZSDCMDTPD)
O    D G_SDCMDTPD    E DS                  EXTNAME(GZSDCMDTPD) PREFIX(G_)
 
      ** Entry Parameters
 
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
O    C                   MOVEL     I#BIMG        Z_SDCMDTPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDCMDTPD
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        A6CZON
O
O    C     K_GZSDCMDTL1  CHAIN     SDCMDTD0                           99
O
O     ** 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    SDCMDTD0
O    C                   ELSE
O
O     ** 'After'
O
O    C                   CLEAR                   G_SDCMDTPD
O    C                   MOVEL     Z_SDCMDTPD    G_SDCMDTPD
O     ** Fix Data
O    C                   CALL      'GPFIXGDTA'
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZSDCMDTPD'  I#FILE           10
O    C                   PARM      G_SDCMDTPD    IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_SDCMDTPD
O     ** Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    SDCMDTD0
O    C                   ELSE
O    C                   WRITE     W_SDCMDTD0
O    C                   ENDIF
O    C                   ENDIF
 
     C                   RETURN
 
      ********************************************************************
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
O    C                   OPEN      GZSDCMDTL1
O    C                   OPEN      GZSDCMDTPD
O
O     ** Key lists
O
O    C     K_GZSDCMDTL1  KLIST
O    C                   KFLD                    A6CZON
O    C                   KFLD                    A6CMSN
 
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
