     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Generated Code')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPTRANSDPD - On-Line Update of Global File GZTRANSD          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CAP191  *CREATE    Date 26Nov09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP191 - MQ Enabling of FUND and EXTR APIs                   *
      *           (Applied 261610 fix)                                *
      *                                                               *
      *****************************************************************
 
     FGZTRANSL1 UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
     F                                     USROPN
     FGZTRANSD  O  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
     F                                     RENAME(TRANSDF     :W_TRANSDF      )
     F                                     USROPN
 
     D Z_TRANSD      E DS                  EXTNAME(GZTRANSD)
     D G_TRANSD      E DS                  EXTNAME(GZTRANSD) PREFIX(G_)
      *
      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
      *
      ** GPTRAPPD Updates
      *
     C     I#TRAP        IFEQ      'Y'
     C     I#BFAF        ANDEQ     'A'
     C                   CALL      'GOWTTTRAN '
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           50
     C                   PARM                    I#BIMG
     C                   PARM                    I#AIMG
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOWTTTRAN '
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Global File Updates
      *
     C     I#BFAF        IFEQ      'B'
     C                   MOVEL     I#BIMG        Z_TRANSD
     C                   ELSE
     C                   MOVEL     I#AIMG        Z_TRANSD
     C                   ENDIF
 
     C     K_GZTRANSL1   CHAIN     TRANSDF                            99
      *
      ** 'Before'
      *
     C     I#BFAF        IFEQ      'B'
     C  N99              DELETE    TRANSDF
     C                   ELSE
      *
      ** 'After'
      *
     C                   CLEAR                   G_TRANSD
     C                   MOVEL     Z_TRANSD      G_TRANSD
      *
      ** Fix Data
      *
     C                   CALL      'GPFIXGDTA'
     C                   PARM                    I#ZONE
     C                   PARM      'GZTRANSD'    I#FILE           10
     C                   PARM      G_TRANSD      IO#BUFFER      4000
     C                   MOVEL     IO#BUFFER     G_TRANSD
      *
      ** Update
      *
     C     *IN99         IFEQ      *OFF
     C                   UPDATE    TRANSDF
     C                   ELSE
     C                   WRITE     W_TRANSDF
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
 
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
      *
      ** Open for commit?
      *
     C                   CALL      'GPCOPN4COM'
     C                   PARM                    D_COM             1
     C                   OPEN      GZTRANSL1
     C                   OPEN      GZTRANSD
      *
      ** Key lists
      *
     C     K_GZTRANSL1   KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    TNBR
 
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
      ** If no identified cause of error
      *
     C     I#ERMS        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'UNEXPECTED ERROR'
     C                   ENDIF
      *
      ** Log an error on the error log
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
