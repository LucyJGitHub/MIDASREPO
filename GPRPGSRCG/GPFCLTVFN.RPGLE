     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*S*D****RPGBASEBNC****************************************************                       CGP017
/*STD *  RPGBASEMOD                                                   *                       CGP017
/*EXI *  TEXT('Update of Global File GZFCLTLVPD from FCLTYFN')        *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPFCLTVFN - Update of Global File GZFCLTLVPD from FCLTYFN    *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. AR727693           Date 20Jun14               *
      *  Prev Amend No. MD049445           Date 05Feb18               *
      *                 MD046248           Date 27Oct17               *
      *                 CGP017             Date 06Aug12               *
      *                 CLE134             Date 01Aug12               *
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
      *  MD049445 - Listview not displaying correct available amount. *
      *             Added SFAMT and SAVAILAMT computation.            *      
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
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
     FGZCLOANLL2IF   E           K DISK    INFSR(*PSSR) PREFIX(G1_)                         MD049445
     FGZCLOANLL3IF   E           K DISK    INFSR(*PSSR) PREFIX(G1_)                         MD049445
     F                                     RENAME(CLOANCLF    :CLOANCLF2      )             MD049445
     FGZLOAMSL1 IF   E           K DISK    INFSR(*PSSR) PREFIX(G2_)                         MD049445
     FGZFCLTLVL2IF   E           K DISK    INFSR(*PSSR) PREFIX(G3_)                         MD049445
     F                                     RENAME(FCLTLVD0    :FCLTLVD02      )             MD049445
     FGZFCLTYML1IF   E           K DISK    INFSR(*PSSR) PREFIX(G4_)                         MD049445
     FGZSDBANKL1IF   E           K DISK    INFSR(*PSSR)                                     MD049445
 
     D Z_FCLTYFN     E DS                  EXTNAME(GZFCLTYFN )
     D G_FCLTYFN     E DS                  EXTNAME(GZFCLTYFN ) PREFIX(G_)
 
      *                                                                                     AR727693
      **  Variables                                                                         AR727693
      *                                                                                     AR727693
     DCentFlag                        2A    INZ(*BLANKS)                                    AR727693
     DCharDate                       30A    INZ(*BLANKS)                                    AR727693
     D RPAYAMT         S             15  0                                                  MD049445
     D WFCBAL          S             15  0                                                  MD049445
     D KBRCA           S              3                                                     MD049445
     D KCNUM           S              6                                                     MD049445
     D KFACT           S              3  0                                                  MD049445
     D KFCNO           S              2  0                                                  MD049445
     D KZONE           S             10                                                     MD049445
     D KCANM           S              6                                                     MD049445
     D KCAFT           S              3                                                     MD049445
     D KCAFN           S              2                                                     MD049445
                                                                                            MD049445
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
     C                   MOVEL     I#BIMG        Z_FCLTYFN
     C                   ELSE
     C                   MOVEL     I#AIMG        Z_FCLTYFN
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
 
     C                   CLEAR                   G_FCLTYFN
     C                   MOVEL     Z_FCLTYFN     G_FCLTYFN
      * Fix Data
     C                   CALL      'GPFIXGDTA'
     C                   PARM                    I#ZONE
     C                   PARM      'GZFCLTYFN '  I#FILE           10
     C                   PARM      G_FCLTYFN     IO#BUFFER      4000
     C                   MOVEL     IO#BUFFER     G_FCLTYFN
 
     C                   EXSR      MOVEDATA
      * Update
     C     *IN99         IFEQ      *OFF
     C                   Select                                                             MD049445
     C                   When      G_FDTEX < G_FRUN01 Or                                    MD049445
     C                             G_FDTAP > G_FRUN01                                       MD049445
     C                   Eval      G_SAVAILAMT = *Zero                                      MD049445
     C                   Other                                                              MD049445
     C                   Eval      G_SAVAILAMT = G_SFAMT - G_SOAM02                         MD049445
     C                   EndSl                                                              MD049445
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
     C                   ExSr      CENT20                                                   AR991435
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
      * get latest FAMT
     C                   EVAL      KBRCA = G_BRCA                                           MD049445
     C                   EVAL      KCNUM = G_CNUM                                           MD049445
     C                   EVAL      KFACT = G_FACT                                           MD049445
     C                   EVAL      KFCNO = G_FCNO                                           MD049445
     C     K_GZCLOANL    CHAIN     GZFCLTYML1                         94                    MD049445
     C                   EVAL      G_SFAMT = G4_FAMT                                        MD049445
      * recompute for SFAMT                                                                 MD049445
     C                   IF        G_TRCA = 'CA'                                            MD049445
     C                             AND G_RVCR <> 'Y'                                        MD049445
     C                   EXSR      SRCAAMT                                                  MD049445
     C                   ELSE                                                               MD049445
     C                   IF        G_RVCR = 'N'                                             MD049445
     C                   EXSR      SRFAMT                                                   MD049445
     C                   ENDIF                                                              MD049445
     C                   ENDIF                                                              MD049445
     
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************                  MD049445
      * SRCAAMT - Compute for facility amount of CA facility                                MD049445
      ********************************************************************                  MD049445
     C     SRCAAMT       BEGSR                                                              MD049445
      *                                                                                     MD049445
     C                   EVAL      KZONE = I#ZONE                                           MD049445
     C                   EVAL      KCANM = G_PADCNUM                                        MD049445
     C                   EVAL      KCAFT = G_PADFACT                                        MD049445
     C                   EVAL      KCAFN = G_PADFCNO                                        MD049445
      * get tranches                                                                        MD049445
     C     K_GZFCLTLVL2  SETLL     GZFCLTLVL2                                               MD049445
     C     K_GZFCLTLVL2  READE     GZFCLTLVL2                             95                MD049445
     C     *IN95         DOWEQ     *OFF                                                     MD049445
     C                   IF        G_RVCR = 'N'                                             MD049445
      * setup keys                                                                          MD049445
     C                   EVAL      KBRCA = G3_BRCA                                          MD049445
     C                   EVAL      KCNUM = G3_PADCNUM                                       MD049445
     C                   EVAL      KFACT = %DEC(G3_PADFACT:3:0)                             MD049445
     C                   EVAL      KFCNO = %DEC(G3_PADFCNO:2:0)                             MD049445
     C                   EXSR      SRFAMT                                                   MD049445
     C                   ENDIF                                                              MD049445
     C     K_GZFCLTLVL2  READE     GZFCLTLVL2                             95                MD049445
     C                   ENDDO                                                              MD049445
     C                   ENDSR                                                              MD049445
      ********************************************************************                  MD049445
     C/SPACE 5                                                                              MD049445
      ********************************************************************                  MD049445
      * SRFAMT - Compute for facility amount                                                MD049445
      ********************************************************************                  MD049445
     C     SRFAMT        BEGSR                                                              MD049445
                                                                                            MD049445
      * get rundate                                                                         MD049445
     C     I#ZONE        CHAIN     GZSDBANKL1                         98                    MD049445
                                                                                            MD049445
      * if syndicated facility but not the agent facility.                                  MD049445
     C                   IF        G_SYIN = 'Y'                                             MD049445
     C                             AND G_PRTR <> 'A'                                        MD049445
     C     K_GZCLOANL    SETLL     GZCLOANLL3                                               MD049445
     C     K_GZCLOANL    READE     GZCLOANLL3                             97                MD049445
     C                   ELSE                                                               MD049445
     C     K_GZCLOANL    SETLL     GZCLOANLL2                                               MD049445
     C     K_GZCLOANL    READE     GZCLOANLL2                             97                MD049445
     C                   ENDIF                                                              MD049445
      *                                                                                     MD049445
     C     *IN97         DOWEQ     *OFF                                                     MD049445
      *                                                                                     MD049445
      * compute for CLOANCL repayment.                                                      MD049445
     C                   EVAL      RPAYAMT = 0                                              MD049445
     C                   IF        G1_NRPD <= BJRDNB                                        MD049445
     C                             AND G1_AUTO = 'Y'                                        MD049445
     C                   EVAL      RPAYAMT = RPAYAMT + G1_RAMT                              MD049445
     C                   ENDIF                                                              MD049445
      * get loamsdk records....                                                             MD049445
     C                   EVAL      G2_BRCA = KBRCA                                          MD049445
     C                   EVAL      G2_LNRF = G1_LNRF                                        MD049445
                                                                                            MD049445
     C     K_GZLOAMS     SETLL     GZLOAMSL1                                                MD049445
     C     K_GZLOAMS     READE     GZLOAMSL1                              96                MD049445
     C     *IN96         DOWEQ     *OFF                                                     MD049445
     C                   IF        G2_AMTP = 'RE'                                           MD049445
     C                             AND G2_VDAT <= BJRDNB                                    MD049445
     C                             AND G2_AUTO = 'Y'                                        MD049445
     C                   EVAL      RPAYAMT = RPAYAMT + G2_PRAM                              MD049445
     C                   ENDIF                                                              MD049445
     C                   IF        G2_AMTP = 'MR'                                           MD049445
     C                             AND G2_VDAT <= BJRDNB                                    MD049445
     C                             AND G2_GASS <> 'A'                                       MD049445
     C                   EVAL      RPAYAMT = RPAYAMT + G2_PRAM                              MD049445
     C                   ENDIF                                                              MD049445
     C     K_GZLOAMS     READE     GZLOAMSL1                              96                MD049445
     C                   ENDDO                                                              MD049445
      *                                                                                     MD049445
      * convert                                                                             MD049445
      *                                                                                     MD049445
     C                   IF        G_FCCY <> G1_CCY                                         MD049445
     C                   EXSR      SRCONV                                                   MD049445
     C                   ENDIF                                                              MD049445
     C                   EVAL      G_SFAMT = G_SFAMT - RPAYAMT                              MD049445
      *                                                                                     MD049445
     C                   IF        G_SYIN = 'Y'                                             MD049445
     C                             AND G_PRTR <> 'A'                                        MD049445
     C     K_GZCLOANL    READE     GZCLOANLL3                             97                MD049445
     C                   ELSE                                                               MD049445
     C     K_GZCLOANL    READE     GZCLOANLL2                             97                MD049445
     C                   ENDIF                                                              MD049445
     C                   ENDDO                                                              MD049445
     C                   ENDSR                                                              MD049445
      ********************************************************************                  MD049445
     C/SPACE 5                                                                              MD049445
      ********************************************************************                  MD049445
      * SRCONV - Convert repayment amount                                                   MD049445
      ********************************************************************                  MD049445
     C     SRCONV        BEGSR                                                              MD049445
     C                   EVAL      WFCBAL = 0                                               MD049445
     C                   IF        G1_FMDI = 'D'                                            MD049445
     C                   EVAL      RPAYAMT = RPAYAMT / G1_FCXR                              MD049445
     C                   ELSE                                                               MD049445
     C                   EVAL      RPAYAMT = RPAYAMT * G1_FCXR                              MD049445
     C                   ENDIF                                                              MD049445
     C                   ENDSR                                                              MD049445
      ********************************************************************                  MD049445
     C/SPACE 5                                                                              MD049445
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
 
     C     K_GZCLOANL    KLIST                                                              MD049445
     C                   KFLD                    KBRCA                                      MD049445
     C                   KFLD                    KCNUM                                      MD049445
     C                   KFLD                    KFACT                                      MD049445
     C                   KFLD                    KFCNO                                      MD049445
                                                                                            MD049445 
     C     K_GZFCLTLVL2  KLIST                                                              MD049445
     C                   KFLD                    KZONE                                      MD049445
     C                   KFLD                    KCANM                                      MD049445
     C                   KFLD                    KCAFT                                      MD049445
     C                   KFLD                    KCAFN                                      MD049445
                                                                                            MD049445
     C     K_GZLOAMS     KLIST                                                              MD049445
     C                   KFLD                    G2_BRCA                                    MD049445
     C                   KFLD                    G2_LNRF                                    MD049445
                                                                                            MD049445 
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
      ********************************************************************
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
      *****************************************************************                     AR727693
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