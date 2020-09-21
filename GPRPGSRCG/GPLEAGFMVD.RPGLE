     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*S*D****RPGBASEBNC****************************************************                       CGP017
/*STD *  RPGBASEMOD                                                   *                       CGP017
/*EXI *  TEXT('Update of Global File GZFCLTLVPD from LEAGFMPD')       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPLEAGFMVD - Update of Global File GZFCLTLVPD from LEAGFMPD  *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD034004           Date 13Jul15               *
      *                 CGP017             Date 06Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 AR819939A          Date 02Sep11               *
      *                 AR869238           Date 23Nov11               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 257576  *CREATE    Date 08Nov08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034004 - Aggregate facilities not shown in list view if    *
      *             customer branch is not equal to the aggregate     *
      *             facility branch.                                  *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR819939A - Last Availability and Expiry date are incorrectly*
      *              displayed on facility list view (Child:AR819940) *
      *  AR869238 - Main Listview does not show 'Cust. Shortname',    *
      *             'Cust.ReportName' and 'Cust. ReportTown'          *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
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
     F***GZSDCUSTL1IF   E           K DISK    INFSR(*PSSR)                         AR869238 MD034004
     FGZSDCUSTL0IF   E           K DISK    INFSR(*PSSR)                                     MD034004

      ** Data structure for *ISO date                                                      AR819939A
     D                 DS                                                                  AR819939A
     D  ZDATE8                 1      8  0                                                 AR819939A
     D  ZCC                    1      2  0                                                 AR819939A
     D  ZYY                    3      4  0                                                 AR819939A
     D  ZMMDD                  5      8  0                                                 AR819939A
                                                                                           AR819939A
     D Z_LEAGFMPD    E DS                  EXTNAME(GZLEAGFMPD)
     D G_LEAGFMPD    E DS                  EXTNAME(GZLEAGFMPD) PREFIX(G_)

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
     C                   MOVEL     I#BIMG        Z_LEAGFMPD
     C                   ELSE
     C                   MOVEL     I#AIMG        Z_LEAGFMPD
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

     C                   CLEAR                   G_LEAGFMPD
     C                   MOVEL     Z_LEAGFMPD    G_LEAGFMPD
      * Fix Data
     C                   CALL      'GPFIXGDTA'
     C                   PARM                    I#ZONE
     C                   PARM      'GZLEAGFMPD'  I#FILE           10
     C                   PARM      G_LEAGFMPD    IO#BUFFER      4000
     C                   MOVEL     IO#BUFFER     G_LEAGFMPD

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

     C                   If        G_TRCA = *Blanks
     C                   Eval      G_TRCA = 'FC'
     C                   EndIf

     C                   Move      G_CNUM        G_PADCNUM
     C                   Move      G_FACT        G_PADFACT
     C                   Move      G_FCNO        G_PADFCNO
     C                   Move      G_PMFC        G_PADPMFC
     C                   Move      G_PMFT        G_PADPMFT
     C                   Move      G_PMFN        G_PADPMFN
     C                   Move      G_ANUM        G_PADANUM
     C                   Move      G_ACSQ        G_PADACSQ
     C                   Move      G_CANM        G_PADCANM
     C                   Move      G_CAFT        G_PADCAFT
     C                   Move      G_CAFN        G_PADCAFN

     C                   Eval      G_PADINUM = G_INUM
     C                   Eval      G_PADPOBN = G_POBN
     C                   Eval      G_PADPOCN = G_POCN
     C                   Eval      G_PADROBN = G_ROBN
     C                   Eval      G_PADROCN = G_ROCN

     C                   Move      G_LPBR        G_PADLPBR

     C                   If        G_DTAP <> *Zero
     C                   Eval      ZDAYNO = G_DTAP
     C                   ExSr      ZDATE2
     C                   EXSR      ZISO                                                    AR819939A
     C**********         Eval      G_FDTAP = %Date(ZDATE :*DMY)                            AR819939A
     C                   EVAL      G_FDTAP = %Date(ZDATE8 :*ISO)                           AR819939A
     C                   EndIf

     C                   If        G_DTEX <> *Zero
     C                   Eval      ZDAYNO = G_DTEX
     C                   ExSr      ZDATE2
     C                   EXSR      ZISO                                                    AR819939A
     C**********         Eval      G_FDTEX = %Date(ZDATE :*DMY)                            AR819939A
     C                   EVAL      G_FDTEX = %Date(ZDATE8 :*ISO)                           AR819939A
     C                   EndIf

     C                   If        G_RVDT <> *Zero
     C                   Eval      ZDAYNO = G_RVDT
     C                   ExSr      ZDATE2
     C                   EXSR      ZISO                                                    AR819939A
     C**********         Eval      G_FRVDT = %Date(ZDATE :*DMY)                            AR819939A
     C                   EVAL      G_FRVDT = %Date(ZDATE8 :*ISO)                           AR819939A
     C                   EndIf

     C                   If        G_CDTE <> *Zero
     C                   Eval      ZDAYNO = G_CDTE
     C                   ExSr      ZDATE2
     C                   EXSR      ZISO                                                    AR819939A
     C**********         Eval      G_FCDTE = %Date(ZDATE :*DMY)                            AR819939A
     C                   EVAL      G_FCDTE = %Date(ZDATE8 :*ISO)                           AR819939A
     C                   EndIf

     C                   If        G_AVLD <> *Zero
     C                   Eval      ZDAYNO = G_AVLD
     C                   ExSr      ZDATE2
     C                   EXSR      ZISO                                                    AR819939A
     C**********         Eval      G_FAVLD = %Date(ZDATE :*DMY)                            AR819939A
     C                   EVAL      G_FAVLD = %Date(ZDATE8 :*ISO)                           AR819939A
     C                   EndIf

     C                   If        G_JDTE <> *Zero
     C                   Eval      ZDAYNO = G_JDTE
     C                   ExSr      ZDATE2
     C                   EXSR      ZISO                                                    AR819939A
     C**********         Eval      G_FJDTE = %Date(ZDATE :*DMY)                            AR819939A
     C                   EVAL      G_FJDTE = %Date(ZDATE8 :*ISO)                           AR819939A
     C                   EndIf

     C                   If        G_COMD <> *Zero
     C                   Eval      ZDAYNO = G_COMD
     C                   ExSr      ZDATE2
     C                   EXSR      ZISO                                                    AR819939A
     C**********         Eval      G_FCOMD = %Date(ZDATE :*DMY)                            AR819939A
     C                   EVAL      G_FCOMD = %Date(ZDATE8 :*ISO)                           AR819939A
     C                   EndIf

     C                   If        G_VDTC <> *Zero
     C                   Eval      ZDAYNO = G_VDTC
     C                   ExSr      ZDATE2
     C                   EXSR      ZISO                                                    AR819939A
     C**********         Eval      G_FVDTC = %Date(ZDATE :*DMY)                            AR819939A
     C                   EVAL      G_FVDTC = %Date(ZDATE8 :*ISO)                           AR819939A
     C                   EndIf

     C                   If        G_ORED <> *Zero
     C                   Eval      ZDAYNO = G_ORED
     C                   ExSr      ZDATE2
     C                   EXSR      ZISO                                                    AR819939A
     C**********         Eval      G_FORED = %Date(ZDATE :*DMY)                            AR819939A
     C                   EVAL      G_FORED = %Date(ZDATE8 :*ISO)                           AR819939A
     C                   EndIf

     C                   If        G_LCD  <> *Zero
     C                   Eval      ZDAYNO = G_LCD
     C                   ExSr      ZDATE2
     C                   EXSR      ZISO                                                    AR819939A
     C**********         Eval      G_FLCD  = %Date(ZDATE :*DMY)                            AR819939A
     C                   EVAL      G_FLCD  = %Date(ZDATE8 :*ISO)                           AR819939A
     C                   EndIf

     C                   If        G_RVCD <> *Zero
     C                   Eval      ZDAYNO = G_RVCD
     C                   ExSr      ZDATE2
     C                   EXSR      ZISO                                                    AR819939A
     C**********         Eval      G_FRVCD = %Date(ZDATE :*DMY)                            AR819939A
     C                   EVAL      G_FRVCD = %Date(ZDATE8 :*ISO)                           AR819939A
     C                   EndIf

     C                   Eval      G_SSHPC = G_SHPC / 1000000000000
     C                   Eval      G_SFAMT = G_FAMT
     C                   Eval      G_SMTDH = G_MTDH
     C                   Eval      G_SMTDL = G_MTDL
     C                   Eval      G_SMTDA = MTDA
     C                   Eval      G_SLPAM = LPAM

     C                   Eval      G_SQTDA  = G_QTDA
     C                   Eval      G_SYTDA  = G_YTDA

     C                   Eval      G_ALCY01 = %SubSt(G_ALCY:1 :3)
     C                   Eval      G_ALCY02 = %SubSt(G_ALCY:4 :3)
     C                   Eval      G_ALCY03 = %SubSt(G_ALCY:7 :3)
     C                   Eval      G_ALCY04 = %SubSt(G_ALCY:10:3)
     C                   Eval      G_ALCY05 = %SubSt(G_ALCY:13:3)
     C                   Eval      G_ALCY06 = %SubSt(G_ALCY:16:3)
     C                   Eval      G_ALCY07 = %SubSt(G_ALCY:19:3)
     C                   Eval      G_ALCY08 = %SubSt(G_ALCY:22:3)
     C                   Eval      G_ALCY09 = %SubSt(G_ALCY:25:3)
     C                   Eval      G_ALCY10 = %SubSt(G_ALCY:28:3)
     C                   Eval      G_ALCY11 = %SubSt(G_ALCY:31:3)
     C                   Eval      G_ALCY12 = %SubSt(G_ALCY:34:3)

     C                   Eval      G_DTPS01 = %SubSt(G_DTPS:1 :1)
     C                   Eval      G_DTPS02 = %SubSt(G_DTPS:2 :1)
     C                   Eval      G_DTPS03 = %SubSt(G_DTPS:3 :1)
     C                   Eval      G_DTPS04 = %SubSt(G_DTPS:4 :1)
     C                   Eval      G_DTPS05 = %SubSt(G_DTPS:5 :1)

     C                   Eval      G_DTPX01 = %SubSt(G_DTPX:1 :1)
     C                   Eval      G_DTPX02 = %SubSt(G_DTPX:2 :1)
     C                   Eval      G_DTPX03 = %SubSt(G_DTPX:3 :1)
     C                   Eval      G_DTPX04 = %SubSt(G_DTPX:4 :1)
     C                   Eval      G_DTPX05 = %SubSt(G_DTPX:5 :1)
     C                   Eval      G_DTPX06 = %SubSt(G_DTPX:6 :1)

     C                   Eval      G_RTPS01 = %SubSt(G_RTPS:1 :1)
     C                   Eval      G_RTPS02 = %SubSt(G_RTPS:2 :1)
     C                   Eval      G_RTPS03 = %SubSt(G_RTPS:3 :1)
     C                   Eval      G_RTPS04 = %SubSt(G_RTPS:4 :1)
     C                   Eval      G_RTPS05 = %SubSt(G_RTPS:5 :1)
     C                   Eval      G_RTPS06 = %SubSt(G_RTPS:6 :1)

     C                   Eval      G_ALCYS  = %Trim(G_ALCY01) + ' ' +
     C                                        %Trim(G_ALCY02) + ' ' +
     C                                        %Trim(G_ALCY03) + ' ' +
     C                                        %Trim(G_ALCY04) + ' ' +
     C                                        %Trim(G_ALCY05) + ' ' +
     C                                        %Trim(G_ALCY06) + ' ' +
     C                                        %Trim(G_ALCY07) + ' ' +
     C                                        %Trim(G_ALCY08) + ' ' +
     C                                        %Trim(G_ALCY09) + ' ' +
     C                                        %Trim(G_ALCY10) + ' ' +
     C                                        %Trim(G_ALCY11) + ' ' +
     C                                        %Trim(G_ALCY12)
     C                   Eval      G_ALCYS  = %Trim(G_ALCYS)

     C                   Eval      G_BTB  = %Trim(G_BTB1)   + ' ' +
     C                                      %Trim(G_BTB2)   + ' ' +
     C                                      %Trim(G_BTB3)   + ' ' +
     C                                      %Trim(G_BTB4)   + ' ' +
     C                                      %Trim(G_BTB5)   + ' ' +
     C                                      %Trim(G_BTB6)

     C                   Eval      G_DTP  = %Trim(G_DTP1)   + ' ' +
     C                                      %Trim(G_DTP2)   + ' ' +
     C                                      %Trim(G_DTP3)   + ' ' +
     C                                      %Trim(G_DTP4)

     C                   Eval      G_NAR  = %Trim(G_NAR1)   + ' ' +
     C                                      %Trim(G_NAR2)   + ' ' +
     C                                      %Trim(G_NAR3)   + ' ' +
     C                                      %Trim(G_NAR4)

     C                   If        G_CSEL = *Blanks
     C                   Eval      G_YNCSEL = 'N'
     C                   Else
     C                   Eval      G_YNCSEL = G_CSEL
     C                   EndIf

     C                   If        G_SECI = *Blanks
     C                   Eval      G_YNSECI = 'N'
     C                   Else
     C                   Eval      G_YNSECI = G_SECI
     C                   EndIf

      ** Setup local values for Customer fields                                             AR869238
     C*****KEY_GLCUSLL1  CHAIN     GZSDCUSTL1                                      AR869238 MD034004
     C     G_CNUM        CHAIN     GZSDCUSTL0                                               MD034004
                                                                                            AR869238
     C**********         IF        %FOUND(GZSDCUSTL1)                              AR869238 MD034004
     C                   IF        %FOUND(GZSDCUSTL0)                                       MD034004
                                                                                            AR869238
      ** Local Customer Shortname                                                           AR869238
     C                   EVAL      G_CGCSSN = BBCSSN                                        AR869238
                                                                                            AR869238
      ** Local Customer Report Name                                                         AR869238
     C                   EVAL      G_CGRNM = BBCRNM                                         AR869238
                                                                                            AR869238
      ** Local Customer Report Town                                                         AR869238
     C                   EVAL      G_CGRTN = BBCRTN                                         AR869238
                                                                                            AR869238
     C                   ENDIF                                                              AR869238
                                                                                            AR869238
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
     C**********         Parm      'D'           ZDATFM            1                       AR819939A
     C                   Parm      'M'           ZDATFM            1                       AR819939A
     C                   Parm      *zero         ZDATE             6 0
     C                   Parm      *blank        ZADATE            7

     C                   EndSr
      ********************************************************************
      /SPACE 5
      *****************************************************************                    AR819939A
      * SR_ZISO    - Convert 6,0 date to *ISO format                                       AR819939A
      *****************************************************************                    AR819939A
     C     ZISO          BEGSR                                                             AR819939A
                                                                                           AR819939A
     C                   MOVE      ZDATE         ZYY                                       AR819939A
     C                   MOVEL     ZDATE         ZMMDD                                     AR819939A
                                                                                           AR819939A
      ** Use '20' for date greater than Dec. 31, 1999                                      AR819939A
     C                   IF        ZDAYNO > 10227                                          AR819939A
     C                   MOVEL     20            ZCC                                       AR819939A
     C                   ELSE                                                              AR819939A
     C                   MOVEL     19            ZCC                                       AR819939A
     C                   ENDIF                                                             AR819939A
                                                                                           AR819939A
     C                   ENDSR                                                             AR819939A
      *********************************************************************                AR819939A
      /SPACE 5                                                                             AR819939A
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
