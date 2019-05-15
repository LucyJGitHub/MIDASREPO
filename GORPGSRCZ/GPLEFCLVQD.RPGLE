     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Update of Global File GZFCLTLVPD from LEFCLTQD')       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPLEFCLVQD - Update of Global File GZFCLTLVPD from LEFCLTQD  *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR658311           Date 21Oct10               *
      *                 CER059             Date 19Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 257576  *CREATE    Date 08Nov08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR658311 - Failed to compile GPT_AMADEX using Bridge for     *
      *             global program (Recompile)                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT039: include new fields introduced by CER020 in   *
      *           GZFCLTYFM(V_#FCLTY), PEXD and PNXD. (Recompile)     *
      *  257576 - Performance: Facilities Input                       *
      *                                                               *
      *****************************************************************
 
     FGZFCLTLVL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
     F                                     USROPN
     FGZFCLTLVPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
     F                                     RENAME(FCLTLVD0    :W_FCLTLVD0     )
     F                                     USROPN
 
     D Z_LEFCLTQD    E DS                  EXTNAME(LEFCLTQD  )
     D G_LEFCLTQD    E DS                  EXTNAME(LEFCLTQD  ) PREFIX(G_)
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
 
      * Global File Updates
 
     C     I#BFAF        IFEQ      'B'
     C                   MOVEL     I#BIMG        Z_LEFCLTQD
     C                   ELSE
     C                   MOVEL     I#AIMG        Z_LEFCLTQD
     C                   ENDIF
 
     C                   Eval      G_CUSTZONE = I#ZONE
     C                   Eval      G_PADCNUM = FCXFCU
     C                   Eval      G_PADFACT = FCXFTP
     C                   Eval      G_PADFCNO = FCXFNO
 
     C     K_GZFCLTLVL1  CHAIN     FCLTLVD0                           99
 
      * 'Before'
 
     C     I#BFAF        IFEQ      'B'
     C  N99              DELETE    FCLTLVD0
     C                   ELSE
 
      * 'After'
 
     C                   CLEAR                   G_LEFCLTQD
     C                   MOVEL     Z_LEFCLTQD    G_LEFCLTQD
      * Fix Data
     C                   CALL      'GPFIXGDTA'
     C                   PARM                    I#ZONE
     C                   PARM      'LEFCLTQD  '  I#FILE           10
     C                   PARM      G_LEFCLTQD    IO#BUFFER      4000
     C                   MOVEL     IO#BUFFER     G_LEFCLTQD
 
     C                   EXSR      MOVEDATA
      * Update
     C     *IN99         IFEQ      *OFF
     C                   UPDATE    FCLTLVD0
     C                   ELSE
     C                   WRITE     W_FCLTLVD0
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
 
     C/SPACE 5
      ********************************************************************
      * MOVEDATA - Load field values for Global File GZFCLTLVPD
      ********************************************************************
     C     MOVEDATA      BEGSR
 
     C                   Eval      G_PADCNUM = G_FCXFCU
     C                   Eval      G_PADFACT = G_FCXFTP
     C                   Eval      G_PADFCNO = G_FCXFNO
 
     C                   Eval      G_PADFCXPOR = G_FCXPOR
 
     C                   Eval      G_SFCXOML  = G_FCXOML
 
     C                   If        G_FCXCGP = *Zero
     C                   Eval      G_AFCXCGP = *Blanks
     C                   Else
     C                   Eval      G_AFCXCGP = %Char(G_FCXCGP)
     C                   EndIf
 
     C                   Eval      G_SFCXCOF  = G_FCXCOF
     C                   Eval      G_SFCXCV2  = G_FCXCV2
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Open for commit?
 
     C                   CALL      'GPCOPN4COM'
     C                   PARM                    D_COM             1
     C                   OPEN      GZFCLTLVL1
     C                   OPEN      GZFCLTLVPD
 
      * Key lists
 
     C     K_GZFCLTLVL1  KLIST
     C                   KFLD                    G_CUSTZONE
     C                   KFLD                    G_PADCNUM
     C                   KFLD                    G_PADFACT
     C                   KFLD                    G_PADFCNO
 
     C     KEY_GLCUSLL1  KList
     C                   KFld                    G_FCXBRC
     C                   KFld                    G_FCXFCU
 
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
