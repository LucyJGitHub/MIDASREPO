     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*S*D****RPGBASEBNC****************************************************                       CGP017
/*STD *  RPGBASEMOD                                                   *                       CGP017
/*EXI *  TEXT('Update of Global File GZFCLTLVPD from LEAGFNPD')       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPLEAGFNVD - Update of Global File GZFCLTLVPD from LEAGFNPD  *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. AR727693           Date 20Jun14               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGP017             Date 06Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG27993           Date 18Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 257576  *CREATE    Date 08Nov08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR727693 - Facilities List view screen is unable to display  *
      *             properly facilities with dates that are later than*
      *             31/12/1999. Correct conversion of dates for year  *
      *             20XX. (Child:AR727694)                            *
      *           - Applied for MD027518                              *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT039: include new fields introduced by CER020 in   *
      *           GZFCLTYFM(V_#FCLTY), PEXD and PNXD. (Recompile)     *
      *  BUG27993 - Calculations manager Halted                       *
      *  257576 - Performance: Facilities Input                       *
      *                                                               *
      *****************************************************************
 
     FGZFCLTLVL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
     F                                     USROPN
     FGZFCLTLVPDO  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
     F                                     RENAME(FCLTLVD0    :W_FCLTLVD0     )
     F                                     USROPN
 
     D Z_LEAGFNPD    E DS                  EXTNAME(GZLEAGFNPD)
     D G_LEAGFNPD    E DS                  EXTNAME(GZLEAGFNPD) PREFIX(G_)
 
      *                                                                                     AR727693
      **  Variables                                                                         AR727693
      *                                                                                     AR727693
     DCentFlag                        2A    INZ(*BLANKS)                                    AR727693
     DCharDate                       30A    INZ(*BLANKS)                                    AR727693
                                                                                            AR727693
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
     C                   MOVEL     I#BIMG        Z_LEAGFNPD
     C                   ELSE
     C                   MOVEL     I#AIMG        Z_LEAGFNPD
     C                   ENDIF
 
     C                   Eval      G_CUSTZONE = I#ZONE
     C                   Move      CNUM          G_PADCNUM
     C                   Move      FACT          G_PADFACT
     C                   Move      FCNO          G_PADFCNO
 
     C     K_GZFCLTLVL1  CHAIN     FCLTLVD0                           99
 
      * 'Before'
 
     C     I#BFAF        IFEQ      'B'
     C  N99              DELETE    FCLTLVD0
     C                   ELSE
 
      * 'After'
 
     C                   CLEAR                   G_LEAGFNPD
     C                   MOVEL     Z_LEAGFNPD    G_LEAGFNPD
      * Fix Data
     C                   CALL      'GPFIXGDTA'
     C                   PARM                    I#ZONE
     C                   PARM      'GZLEAGFNPD'  I#FILE           10
     C                   PARM      G_LEAGFNPD    IO#BUFFER      4000
     C                   MOVEL     IO#BUFFER     G_LEAGFNPD
 
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
 
     C                   Move      G_CNUM        G_PADCNUM
     C                   Move      G_FACT        G_PADFACT
     C                   Move      G_FCNO        G_PADFCNO
 
     C                   If        G_RUN0 <> *Zero
     C                   Eval      ZDAYNO = G_RUN0
     C                   ExSr      CENT20                                                   AR727693
     C                   ExSr      ZDATE2
     C                   Eval      G_FRUN00 = %Date(ZDATE :*DMY)
     C                   If        CentFlag = 'Y'                                           AR727693
     C                   Eval      CharDate  =  %CHAR(G_FRUN00)                             AR727693
     C                   Eval      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR727693
     C                   Eval      G_FRUN00 = %Date(CHARDATE)                               AR727693
     C                   EndIf                                                              AR727693
     C                   EndIf
 
     C                   If        G_RUN1 <> *Zero
     C                   Eval      ZDAYNO = G_RUN1
     C                   ExSr      CENT20                                                   AR727693
     C                   ExSr      ZDATE2
     C                   Eval      G_FRUN01 = %Date(ZDATE :*DMY)
     C                   If        CentFlag = 'Y'                                           AR727693
     C                   Eval      CharDate  =  %CHAR(G_FRUN01)                             AR727693
     C                   Eval      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR727693
     C                   Eval      G_FRUN01 = %Date(CHARDATE)                               AR727693
     C                   EndIf                                                              AR727693
     C                   EndIf
 
     C                   If        G_RUN2 <> *Zero
     C                   Eval      ZDAYNO = G_RUN2
     C                   ExSr      CENT20                                                   AR727693
     C                   ExSr      ZDATE2
     C                   Eval      G_FRUN02 = %Date(ZDATE :*DMY)
     C                   If        CentFlag = 'Y'                                           AR727693
     C                   Eval      CharDate  =  %CHAR(G_FRUN02)                             AR727693
     C                   Eval      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR727693
     C                   Eval      G_FRUN02 = %Date(CHARDATE)                               AR727693
     C                   EndIf                                                              AR727693
     C                   EndIf
 
     C                   If        G_RUN3 <> *Zero
     C                   Eval      ZDAYNO = G_RUN3
     C                   ExSr      CENT20                                                   AR727693
     C                   ExSr      ZDATE2
     C                   Eval      G_FRUN03 = %Date(ZDATE :*DMY)
     C                   If        CentFlag = 'Y'                                           AR727693
     C                   Eval      CharDate  =  %CHAR(G_FRUN03)                             AR727693
     C                   Eval      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR727693
     C                   Eval      G_FRUN03 = %Date(CHARDATE)                               AR727693
     C                   EndIf                                                              AR727693
     C                   EndIf
 
     C                   If        G_RUN4 <> *Zero
     C                   Eval      ZDAYNO = G_RUN4
     C                   ExSr      CENT20                                                   AR727693
     C                   ExSr      ZDATE2
     C                   Eval      G_FRUN04 = %Date(ZDATE :*DMY)
     C                   If        CentFlag = 'Y'                                           AR727693
     C                   Eval      CharDate  =  %CHAR(G_FRUN04)                             AR727693
     C                   Eval      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR727693
     C                   Eval      G_FRUN04 = %Date(CHARDATE)                               AR727693
     C                   EndIf                                                              AR727693
     C                   EndIf
 
     C                   If        G_RUN5 <> *Zero
     C                   Eval      ZDAYNO = G_RUN5
     C                   ExSr      CENT20                                                   AR727693
     C                   ExSr      ZDATE2
     C                   Eval      G_FRUN05 = %Date(ZDATE :*DMY)
     C                   If        CentFlag = 'Y'                                           AR727693
     C                   Eval      CharDate  =  %CHAR(G_FRUN05)                             AR727693
     C                   Eval      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR727693
     C                   Eval      G_FRUN05 = %Date(CHARDATE)                               AR727693
     C                   EndIf                                                              AR727693
     C                   EndIf
 
     C                   If        G_RUN6 <> *Zero
     C                   Eval      ZDAYNO = G_RUN6
     C                   ExSr      CENT20                                                   AR727693
     C                   ExSr      ZDATE2
     C                   Eval      G_FRUN06 = %Date(ZDATE :*DMY)
     C                   If        CentFlag = 'Y'                                           AR727693
     C                   Eval      CharDate  =  %CHAR(G_FRUN06)                             AR727693
     C                   Eval      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR727693
     C                   Eval      G_FRUN06 = %Date(CHARDATE)                               AR727693
     C                   EndIf                                                              AR727693
     C                   EndIf
 
     C                   If        G_RUN7 <> *Zero
     C                   Eval      ZDAYNO = G_RUN7
     C                   ExSr      CENT20                                                   AR727693
     C                   ExSr      ZDATE2
     C                   Eval      G_FRUN07 = %Date(ZDATE :*DMY)
     C                   If        CentFlag = 'Y'                                           AR727693
     C                   Eval      CharDate  =  %CHAR(G_FRUN07)                             AR727693
     C                   Eval      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR727693
     C                   Eval      G_FRUN07 = %Date(CHARDATE)                               AR727693
     C                   EndIf                                                              AR727693
     C                   EndIf
 
     C                   If        G_RUN8 <> *Zero
     C                   Eval      ZDAYNO = G_RUN8
     C                   ExSr      CENT20                                                   AR727693
     C                   ExSr      ZDATE2
     C                   Eval      G_FRUN08 = %Date(ZDATE :*DMY)
     C                   If        CentFlag = 'Y'                                           AR727693
     C                   Eval      CharDate  =  %CHAR(G_FRUN08)                             AR727693
     C                   Eval      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR727693
     C                   Eval      G_FRUN08 = %Date(CHARDATE)                               AR727693
     C                   EndIf                                                              AR727693
     C                   EndIf
 
     C                   If        G_RUN9 <> *Zero
     C                   Eval      ZDAYNO = G_RUN9
     C                   ExSr      CENT20                                                   AR727693
     C                   ExSr      ZDATE2
     C                   Eval      G_FRUN09 = %Date(ZDATE :*DMY)
     C                   If        CentFlag = 'Y'                                           AR727693
     C                   Eval      CharDate  =  %CHAR(G_FRUN09)                             AR727693
     C                   Eval      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR727693
     C                   Eval      G_FRUN09 = %Date(CHARDATE)                               AR727693
     C                   EndIf                                                              AR727693
     C                   EndIf
 
     C                   Eval      G_SCAMD  = G_CAMD                                        BUG27993
     C                   Eval      G_SOAM01 = G_OAM1
     C                   Eval      G_SOAM02 = G_OAM2
     C                   Eval      G_SOAM03 = G_OAM3
     C                   Eval      G_SOAM04 = G_OAM4
     C                   Eval      G_SOAM05 = G_OAM5
     C                   Eval      G_SOAM06 = G_OAM6
     C                   Eval      G_SOAM07 = G_OAM7
     C                   Eval      G_SOAM08 = G_OAM8
     C                   Eval      G_SOAM09 = G_OAM9
     C                   Eval      G_SOAM10 = G_OA10
 
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
     C                   KFld                    G_BRCA
     C                   KFld                    G_CNUM
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * SR_ZDATE2  - Convert Midas date to *DMY format
      *****************************************************************
     C     ZDATE2        BegSr
 
     C                   Call      'ZDATE2'
     C                   Parm                    ZDAYNO            5 0
     C                   Parm      'D'           ZDATFM            1
     C                   Parm      *zero         ZDATE             6 0
     C                   Parm      *blank        ZADATE            7
 
     C                   EndSr
      *****************************************************************                     AR727693
      * Cent20     - Convert Midas date to *DMY format for 20xx.      *                     AR727693
      *****************************************************************                     AR727693
     C     Cent20        BegSr                                                              AR727693
                                                                                            AR727693
     C                   EVAL       CentFlag = *Blanks                                      AR727693
     C                   If        ZDAYNO > 10227                                           AR727693
     C                   EVAL      CharDate = *blanks                                       AR727693
     C                   EVAL      CentFlag = 'Y'                                           AR727693
     C                   EndIf                                                              AR727693
                                                                                            AR727693
     C                   EndSr                                                              AR727693
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
