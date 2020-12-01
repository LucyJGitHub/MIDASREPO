     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GO Bulk Update of Global File GZFCLTLVPD')       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOFCLTLVPD - Bulk Update of Global File GZFCLTLVPD           *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD025682           Date 19Aug14               *
      *                 MD022705           Date 04Oct13               *
      *                 CLE134             Date 01Aug12               *
      *                 CGO001AB           Date 06Aug12               *
      *                 AR812802           Date 01Sep11               *
      *                 CSF011             Date 12Sep11               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CGP015             Date 06Mar09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 257576  *CREATE    Date 06Nov08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD025682 - Set CGZONE to A8ZONE                              *
      *  MD022705 - Duplicate records in GZFCLTLVPD                   *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CGO001AB - COB Restructure - GO COB Optimisation Phase 1     *
      *  AR812802 - Facility resets to erroneous dates in list view   *
      *             after running CoB. Correct convertion of dates for*
      *             year 20xx by extending fix AR375713.              *
      *           - Applied fix for AR980193 (Child:AR980194)         *
      *  CSF011 - Customer Name on Inputs (Recompile)                 *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT039: include new fields introduced by CER020 in   *
      *           GZFCLTYFM(V_#FCLTY), PEXD and PNXD. (Recompile)     *
      *  CGP015 - Task Split of Bulk update of Facilities listview    *
      *  257576 - Performance: Facilities Input                       *
      *                                                               *
      *****************************************************************
                                                                                              CGP015
     FFCLVDVPD  IF   E           K DISK    INFSR(*PSSR)                                       CGP015
     F                                     RENAME(FCLTYFMF: DRIVERF)                          CGP015
     F                                     USROPN                                             CGP015

     FFCLTYFM   IF   E             DISK    INFSR(*PSSR)
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)                                     CGO001AB
     F                                     INCLUDE(FCLTYFMF)                                CGO001AB
     F                                     RENAME(FCLTYFMF: MASTERF)                        CGO001AB
     F                                     USROPN                                           CGO001AB
                                                                                            CGO001AB
     FFCLTYL5   IF   E           K DISK    INFSR(*PSSR)
     FLEFCLTLH  IF   E           K DISK    INFSR(*PSSR)

     FLEAGFMPD  IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:LEAGFM)
     FLEAGFYL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFNF:LEAGFN)
     FLEAGFCL7  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFCLTD0:LEAGFQ)

     FGPGLCUSL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GPGLCUSL:GPGLCUSLD0)
     FGZFCLTLVL1UF A E           K DISK    INFSR(*PSSR)

      *****************************************************************

      ** Program Status Data Structure

     D/COPY ZACPYSRC,PSDS

     D DSFDY         E DS                  EXTNAME(DSFDY)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D GZSDBRCH      E DS                  EXTNAME(GZSDBRCHPD)

     D DS_FCLTYFN    E DS                  EXTNAME(FCLTYFN)
     D  DS_CNUM      E                     EXTFLD(CNUM)
     D  DS_FACT      E                     EXTFLD(FACT)
     D  DS_FCNO      E                     EXTFLD(FCNO)
     D  DS_RECI      E                     EXTFLD(RECI)
     D  DS_RCTP      E                     EXTFLD(RCTP)
     D  DS_LCD       E                     EXTFLD(LCD)
     D  DS_CHTP      E                     EXTFLD(CHTP)
     D  DS_FRNT      E                     EXTFLD(FRNT)

     D DS_LEFCLTQD   E DS                  EXTNAME(LEFCLTQD)
                                                                                            AR812802
     D CentFlag                       2A    INZ(*BLANKS)                                    AR812802
     D CharDate                      30A    INZ(*BLANKS)                                    AR812802

      ** Data Structure for the end record key                                              CGO001AB
                                                                                            CGO001AB
     D                 DS                                                                   CGO001AB
     D ENDKEY                  1     12                                                     CGO001AB
     D ECNUM                   1      6                                                     CGO001AB
     D EFACT                   7      9  0                                                  CGO001AB
     D EFCNO                  10     11  0                                                  CGO001AB
     D ERCTP                  12     12                                                     CGO001AB
                                                                                            CGO001AB
      ** Data structure for the next record key                                             CGO001AB
                                                                                            CGO001AB
     D                 DS                                                                   CGO001AB
     D NXTKEY                  1     12                                                     CGO001AB
     D NCNUM                   1      6                                                     CGO001AB
     D NFACT                   7      9  0                                                  CGO001AB
     D NFCNO                  10     11  0                                                  CGO001AB
     D NRCTP                  12     12                                                     CGO001AB
                                                                                            MD022705
     D GZFCLTDS        DS                  INZ                                              MD022705
     D                                     LIKEREC(FCLTLVD0:*INPUT)                         MD022705
                                                                                            CGO001AB
     IFCLTYFNF
     I              CNUM                        CNUM_FN
     I              FACT                        FACT_FN
     I              FCNO                        FCNO_FN
     I              RECI                        RECI_FN
     I              RCTP                        RCTP_FN
     I              CHTP                        CHTP_FN
     I              FRNT                        FRNT_FN
     ILEAGFN
     I              CNUM                        CNUM_FN
     I              FACT                        FACT_FN
     I              FCNO                        FCNO_FN
     I              RECI                        RECI_FN
     I              RCTP                        RCTP_FN
     I              CHTP                        CHTP_FN
     I              FRNT                        FRNT_FN
      *****************************************************************

      ** Facilities
                                                                                            CGO001AB
     C                   MOVE      *BLANK        AZKEY             1                        CGO001AB
                                                                                              CGP015
      ** Task-split mode                                                                      CGP015
     C                   If        I_MODE = '*TSK'                                            CGP015
     C                   Eval      *In01 = *On                                                CGP015
                                                                                              CGP015
     C                   OPEN      FCLVDVPD                                                 CGO001AB
     C                   OPEN      FCLTY                                                    CGO001AB
                                                                                            CGO001AB
     C                   EVAL      AZKEY = 'Z'                                              CGO001AB
     C     AZKEY         CHAIN     FCLVDVPD                           38                    CGO001AB
     C                   IF        *IN38 = *OFF                                             CGO001AB
     C                   EVAL      ECNUM = CNUM                                             CGO001AB
     C                   EVAL      EFACT = FACT                                             CGO001AB
     C                   EVAL      EFCNO = FCNO                                             CGO001AB
     C                   EVAL      ERCTP = RCTP                                             CGO001AB
     C                   ENDIF                                                              CGO001AB
                                                                                            CGO001AB
     C                   IF        *IN38 = *OFF                                             CGO001AB
     C                   EVAL      AZKEY = 'A'                                              CGO001AB
     C     AZKEY         CHAIN     FCLVDVPD                           38                    CGO001AB
     C                   ENDIF                                                              CGO001AB
     C                   IF        *IN38 = *OFF                                             CGO001AB
     C                   EVAL      NCNUM = CNUM                                             CGO001AB
     C                   EVAL      NFACT = FACT                                             CGO001AB
     C                   EVAL      NFCNO = FCNO                                             CGO001AB
     C                   EVAL      NRCTP = RCTP                                             CGO001AB
     C                   ENDIF                                                              CGO001AB
                                                                                            CGO001AB
      ** Set pointer to the first record for process                                        CGO001AB
                                                                                            CGO001AB
     C                   EVAL      *IN19 = *OFF                                             CGO001AB
     C                   IF        NXTKEY > ENDKEY                                          CGO001AB
     C                   EVAL      *IN19 = *ON                                              CGO001AB
     C                   ENDIF                                                              CGO001AB
                                                                                            CGO001AB
     C                   IF        *IN19 = *OFF                                             CGO001AB
                                                                                            CGO001AB
     C     KEY_FCLTY     SETLL     FCLTY                                                    CGO001AB
     C**********         Read      FCLVDVPD                                          CGP015 CGO001AB
     C                   READ      FCLTY                                  19                CGO001AB
     C**********         DoW       NOT %EOF                                          CGP015 CGO001AB
     C                   DOW       *IN19 = *OFF                                             CGO001AB
     C                   ExSr      Sr_Process                                                 CGP015
     C**********         Read      FCLVDVPD                                          CGP015 CGO001AB
     C                   READ      FCLTY                                  19                CGO001AB
                                                                                            CGO001AB
     C                   IF        *IN19 = *OFF                                             CGO001AB
     C                   EVAL      NCNUM = CNUM                                             CGO001AB
     C                   EVAL      NFACT = FACT                                             CGO001AB
     C                   EVAL      NFCNO = FCNO                                             CGO001AB
     C                   EVAL      NRCTP = RCTP                                             CGO001AB
                                                                                            CGO001AB
     C                   IF        NXTKEY > ENDKEY                                          CGO001AB
     C                   EVAL      *IN19 = *ON                                              CGO001AB
     C                   ENDIF                                                              CGO001AB
                                                                                            CGO001AB
     C                   ENDIF                                                              CGO001AB
                                                                                            CGO001AB
     C                   EndDo                                                                CGP015
                                                                                            CGO001AB
     C                   ENDIF                                                              CGO001AB
                                                                                            CGO001AB
     C                   EndIf                                                                CGP015
                                                                                              CGP015
      ** Original (non-task split) mode                                                       CGP015
     C                   If        I_MODE = *blanks                                           CGP015

     C                   Eval      *In01 = *On

     C                   Read      FCLTYFM
     C                   DoW       NOT %EOF(FCLTYFM)
     C                   ExSr      Sr_Process
     C                   Read      FCLTYFM
     C                   EndDo
     C                   EndIf                                                                CGP015

      ** Aggregated Facilities

     C                   If           I_MODE = *blanks                                        CGP015
     C                             or I_MODE = '*AGF'                                         CGP015
     C                   Eval      *In01 = *Off

     C                   Read      LEAGFMPD
     C                   DoW       NOT %EOF(LEAGFMPD)
     C                   ExSr      Sr_Process
     C                   Read      LEAGFMPD
     C                   EndDo
     C                   EndIf                                                                CGP015

     C                   IF        I_MODE <> '*TSK'                                         CGO001AB
     C                   Eval      *InLr = *On
     C                   ELSE                                                               CGO001AB
     C                   CLOSE     FCLVDVPD                                                 CGO001AB
     C                   CLOSE     FCLTY                                                    CGO001AB
     C                   ENDIF                                                              CGO001AB
     C                   RETURN                                                             CGO001AB

      *****************************************************************
      * *INZSR - Initial subroutine Called automatiCally at program
      *          start.
      *****************************************************************
     C     *INZSR        BegSr

     C     *ENTRY        PList
     C                   Parm                    I_ZONE           10
     C                   Parm                    I_MODE            4                          CGP015

     C     KEY_FCLTYL5   KList
     C                   KFld                    CNUM
     C                   KFld                    FACT
     C                   KFld                    FCNO

     C     KEY_LEFCLTLH  KList
     C                   KFld                    FCXFCU
     C                   KFld                    FCXFTP
     C                   KFld                    FCXFNO

     C     KEY_LEAGFYL2  KList
     C                   KFld                    CNUM
     C                   KFld                    FACT
     C                   KFld                    FCNO

     C     KEY_LEAGFCL7  KList
     C                   KFld                    FCXFCU
     C                   KFld                    FCXFTP
     C                   KFld                    FCXFNO

     C     KEY_GLCUSL    KList
     C                   KFld                    CNUM
     C                   KFld                    I_ZONE

     C     KEY_FCLTY     KLIST                                                              CGO001AB
     C                   KFLD                    CNUM                                       CGO001AB
     C                   KFLD                    FACT                                       CGO001AB
     C                   KFLD                    FCNO                                       CGO001AB
     C                   KFLD                    RCTP                                       CGO001AB
                                                                                            CGO001AB
     C     GZFCLTKEY     KLIST                                                              MD022705
     C                   KFLD                    CUSTZONE                                   MD022705
     C                   KFLD                    PADCNUM                                    MD022705
     C                   KFLD                    PADFACT                                    MD022705
     C                   KFLD                    PADFCNO                                    MD022705
                                                                                            MD022705
      ** Access Switchable Features File

     C                   Call      'AOSARDR0'
     C                   Parm      *Blanks       PRtcd             7
     C                   Parm      '*VERIFY '    POptn             7
     C                   Parm      'CLE024'      PSard             6
     C     SCSARD        Parm      SCSARD        DSFDY

     C                   Move      'N'           #CLE024           1
     C                   If        PRtcd = *Blanks
     C                   Eval      #CLE024 = 'Y'
     C                   EndIf

     C                   Call      'AOSARDR0'
     C                   Parm      *Blanks       PRtcd
     C                   Parm      '*VERIFY '    POptn
     C                   Parm      'CLE025'      PSard
     C     SCSARD        Parm      SCSARD        DSFDY

     C                   Move      'N'           #CLE025           1
     C                   If        PRtcd = *Blanks
     C                   Eval      #CLE025 = 'Y'
     C                   EndIf

     C**********         If        I_MODE = '*TSK'                                   CGP015 CGO001AB
     C**********         Open      FCLVDVPD                                          CGP015 CGO001AB
     C**********         EndIf                                                       CGP015 CGO001AB

      ** delete zone records from global facilities list view

     C                   If        I_MODE = *blanks                                           CGP015
     C     I_ZONE        SetLl     GZFCLTLVL1
     C     I_ZONE        ReadE     GZFCLTLVL1
     C                   DoW       NOT %EOF(GZFCLTLVL1)
     C                   Delete    FCLTLVD0
     C     I_ZONE        ReadE     GZFCLTLVL1
     C                   EndDo
     C                   EndIf                                                                CGP015

     C                   EndSr
      ****************************************************************
     C/SPACE 5
      *****************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *****************************************************************
     C     *PSSR         BegSr

     C                   Dump
     C                   SetOn                                        LRU7U8
     C                   Return

     C                   EndSr
      *****************************************************************
      * SR_Process - Detail processing
      *****************************************************************
     C     SR_Process    BegSr

     C                   Clear                   DS_FCLTYFN
     C                   Clear                   DS_LEFCLTQD
     C                   Clear                   GZSDBRCH

     C                   Eval      FCXFCU = CNUM
     C                   Move      FACT          FCXFTP
     C                   Move      FCNO          FCXFNO

     C                   Call      'GPACSBRCH'
     C                   Parm                    I#RTCD            7
     C                   Parm                    I#ERMS           50
     C                   Parm      BRCA          I#BRCD            3
     C                   Parm                    GZSDBRCH

     C                   If        *In01 = *On
     C     KEY_FCLTYL5   Chain     FCLTYL5                            90
     C     KEY_LEFCLTLH  Chain     LEFCLTLH
     C                   Else
     C     KEY_LEAGFYL2  Chain     LEAGFYL2
     C     KEY_LEAGFCL7  Chain     LEAGFCL7
     C                   EndIf

     C     KEY_GLCUSL    Chain     GPGLCUSL

     C                   If        TRCA = *Blanks
     C                   Eval      TRCA = 'FC'
     C                   EndIf

     C                   Move      CNUM          PADCNUM
     C                   Move      FACT          PADFACT
     C                   Move      FCNO          PADFCNO
     C                   Move      PMFC          PADPMFC
     C                   Move      PMFT          PADPMFT
     C                   Move      PMFN          PADPMFN
     C                   Move      ANUM          PADANUM
     C                   Move      ACSQ          PADACSQ
     C                   Move      CANM          PADCANM
     C                   Move      CAFT          PADCAFT
     C                   Move      CAFN          PADCAFN

     C                   Eval      PADINUM = INUM
     C                   Eval      PADPOBN = POBN
     C                   Eval      PADPOCN = POCN
     C                   Eval      PADROBN = ROBN
     C                   Eval      PADROCN = ROCN

     C                   Move      LPBR          PADLPBR

     C                   If        DTAP <> *Zero
     C                   Eval      ZDAYNO = DTAP
     C                   EXSR      CENT20                                                   AR812802
     C                   ExSr      ZDATE2
     C                   Eval      FDTAP = %Date(ZDATE :*DMY)
     C                   IF        CentFlag = 'Y'                                           AR812802
     C                   EVAL      CharDate = %CHAR(FDTAP)                                  AR812802
     C                   EVAL      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR812802
     C                   EVAL      FDTAP = %Date(CHARDATE)                                  AR812802
     C                   ENDIF                                                              AR812802
     C                   EndIf

     C                   If        DTEX <> *Zero
     C                   Eval      ZDAYNO = DTEX
     C                   EXSR      CENT20                                                   AR812802
     C                   ExSr      ZDATE2
     C                   Eval      FDTEX = %Date(ZDATE :*DMY)
     C                   IF        CentFlag = 'Y'                                           AR812802
     C                   EVAL      CharDate = %CHAR(FDTEX)                                  AR812802
     C                   EVAL      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR812802
     C                   EVAL      FDTEX = %Date(CHARDATE)                                  AR812802
     C                   ENDIF                                                              AR812802
     C                   EndIf

     C                   If        RVDT <> *Zero
     C                   Eval      ZDAYNO = RVDT
     C                   EXSR      CENT20                                                   AR812802
     C                   ExSr      ZDATE2
     C                   Eval      FRVDT = %Date(ZDATE :*DMY)
     C                   IF        CentFlag = 'Y'                                           AR812802
     C                   EVAL      CharDate = %CHAR(FRVDT)                                  AR812802
     C                   EVAL      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR812802
     C                   EVAL      FRVDT = %Date(CHARDATE)                                  AR812802
     C                   ENDIF                                                              AR812802
     C                   EndIf

     C                   If        CDTE <> *Zero
     C                   Eval      ZDAYNO = CDTE
     C                   EXSR      CENT20                                                   AR812802
     C                   ExSr      ZDATE2
     C                   Eval      FCDTE = %Date(ZDATE :*DMY)
     C                   IF        CentFlag = 'Y'                                           AR812802
     C                   EVAL      CharDate = %CHAR(FCDTE)                                  AR812802
     C                   EVAL      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR812802
     C                   EVAL      FCDTE = %Date(CHARDATE)                                  AR812802
     C                   ENDIF                                                              AR812802
     C                   EndIf

     C                   If        AVLD <> *Zero
     C                   Eval      ZDAYNO = AVLD
     C                   EXSR      CENT20                                                   AR812802
     C                   ExSr      ZDATE2
     C                   Eval      FAVLD = %Date(ZDATE :*DMY)
     C                   IF        CentFlag = 'Y'                                           AR812802
     C                   EVAL      CharDate  =  %CHAR(FAVLD)                                AR812802
     C                   EVAL      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR812802
     C                   EVAL      FAVLD = %Date(CHARDATE)                                  AR812802
     C                   ENDIF                                                              AR812802
     C                   EndIf

     C                   If        JDTE <> *Zero
     C                   Eval      ZDAYNO = JDTE
     C                   EXSR      CENT20                                                   AR812802
     C                   ExSr      ZDATE2
     C                   Eval      FJDTE = %Date(ZDATE :*DMY)
     C                   IF        CentFlag = 'Y'                                           AR812802
     C                   EVAL      CharDate = %CHAR(FJDTE)                                  AR812802
     C                   EVAL      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR812802
     C                   EVAL      FJDTE  = %Date(CHARDATE)                                 AR812802
     C                   ENDIF                                                              AR812802
     C                   EndIf

     C                   If        COMD <> *Zero
     C                   Eval      ZDAYNO = COMD
     C                   EXSR      CENT20                                                   AR812802
     C                   ExSr      ZDATE2
     C                   Eval      FCOMD = %Date(ZDATE :*DMY)
     C                   IF        CentFlag = 'Y'                                           AR812802
     C                   EVAL      CharDate = %CHAR(FCOMD)                                  AR812802
     C                   EVAL      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR812802
     C                   EVAL      FCOMD = %Date(CHARDATE)                                  AR812802
     C                   ENDIF                                                              AR812802
     C                   EndIf

     C                   If        VDTC <> *Zero
     C                   Eval      ZDAYNO = VDTC
     C                   EXSR      CENT20                                                   AR812802
     C                   ExSr      ZDATE2
     C                   Eval      FVDTC = %Date(ZDATE :*DMY)
     C                   IF        CentFlag = 'Y'                                           AR812802
     C                   EVAL      CharDate = %CHAR(FVDTC)                                  AR812802
     C                   EVAL      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR812802
     C                   EVAL      FVDTC = %Date(CHARDATE)                                  AR812802
     C                   ENDIF                                                              AR812802
     C                   EndIf

     C                   If        ORED <> *Zero
     C                   Eval      ZDAYNO = ORED
     C                   EXSR      CENT20                                                   AR812802
     C                   ExSr      ZDATE2
     C                   Eval      FORED = %Date(ZDATE :*DMY)
     C                   IF        CentFlag = 'Y'                                           AR812802
     C                   EVAL      CharDate = %CHAR(FORED)                                  AR812802
     C                   EVAL      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR812802
     C                   EVAL      FORED = %Date(CHARDATE)                                  AR812802
     C                   ENDIF                                                              AR812802
     C                   EndIf

     C                   If        LCD  <> *Zero
     C                   Eval      ZDAYNO = LCD
     C                   EXSR      CENT20                                                   AR812802
     C                   ExSr      ZDATE2
     C                   Eval      FLCD  = %Date(ZDATE :*DMY)
     C                   IF        CentFlag = 'Y'                                           AR812802
     C                   EVAL      CharDate = %CHAR(FLCD)                                   AR812802
     C                   EVAL      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR812802
     C                   EVAL      FLCD = %Date(CHARDATE)                                   AR812802
     C                   ENDIF                                                              AR812802
     C                   EndIf

     C                   If        RVCD <> *Zero
     C                   Eval      ZDAYNO = RVCD
     C                   EXSR      CENT20                                                   AR812802
     C                   ExSr      ZDATE2
     C                   Eval      FRVCD = %Date(ZDATE :*DMY)
     C                   IF        CentFlag = 'Y'                                           AR812802
     C                   EVAL      CharDate = %CHAR(FRVCD)                                  AR812802
     C                   EVAL      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR812802
     C                   EVAL      FRVCD = %Date(CHARDATE)                                  AR812802
     C                   ENDIF                                                              AR812802
     C                   EndIf

     C                   If        RUN0 <> *Zero
     C                   Eval      ZDAYNO = RUN0
     C                   EXSR      CENT20                                                   AR812802
     C                   ExSr      ZDATE2
     C                   Eval      FRUN00 = %Date(ZDATE :*DMY)
     C                   IF        CentFlag = 'Y'                                           AR812802
     C                   EVAL      CharDate = %CHAR(FRUN00)                                 AR812802
     C                   EVAL      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR812802
     C                   EVAL      FRUN00 = %Date(CHARDATE)                                 AR812802
     C                   ENDIF                                                              AR812802
     C                   EndIf

     C                   If        RUN1 <> *Zero
     C                   Eval      ZDAYNO = RUN1
     C                   EXSR      CENT20                                                   AR812802
     C                   ExSr      ZDATE2
     C                   Eval      FRUN01 = %Date(ZDATE :*DMY)
     C                   IF        CentFlag = 'Y'                                           AR812802
     C                   EVAL      CharDate = %CHAR(FRUN01)                                 AR812802
     C                   EVAL      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR812802
     C                   EVAL      FRUN01 = %Date(CHARDATE)                                 AR812802
     C                   ENDIF                                                              AR812802
     C                   EndIf

     C                   If        RUN2 <> *Zero
     C                   Eval      ZDAYNO = RUN2
     C                   EXSR      CENT20                                                   AR812802
     C                   ExSr      ZDATE2
     C                   Eval      FRUN02 = %Date(ZDATE :*DMY)
     C                   IF        CentFlag = 'Y'                                           AR812802
     C                   EVAL      CharDate = %CHAR(FRUN02)                                 AR812802
     C                   EVAL      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR812802
     C                   EVAL      FRUN02 = %Date(CHARDATE)                                 AR812802
     C                   ENDIF                                                              AR812802
     C                   EndIf

     C                   If        RUN3 <> *Zero
     C                   Eval      ZDAYNO = RUN3
     C                   EXSR      CENT20                                                   AR812802
     C                   ExSr      ZDATE2
     C                   Eval      FRUN03 = %Date(ZDATE :*DMY)
     C                   IF        CentFlag = 'Y'                                           AR812802
     C                   EVAL      CharDate = %CHAR(FRUN03)                                 AR812802
     C                   EVAL      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR812802
     C                   EVAL      FRUN03 = %Date(CHARDATE)                                 AR812802
     C                   ENDIF                                                              AR812802
     C                   EndIf

     C                   If        RUN4 <> *Zero
     C                   Eval      ZDAYNO = RUN4
     C                   EXSR      CENT20                                                   AR812802
     C                   ExSr      ZDATE2
     C                   Eval      FRUN04 = %Date(ZDATE :*DMY)
     C                   IF        CentFlag = 'Y'                                           AR812802
     C                   EVAL      CharDate = %CHAR(FRUN04)                                 AR812802
     C                   EVAL      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR812802
     C                   EVAL      FRUN04 = %Date(CHARDATE)                                 AR812802
     C                   ENDIF                                                              AR812802
     C                   EndIf

     C                   If        RUN5 <> *Zero
     C                   Eval      ZDAYNO = RUN5
     C                   EXSR      CENT20                                                   AR812802
     C                   ExSr      ZDATE2
     C                   Eval      FRUN05 = %Date(ZDATE :*DMY)
     C                   IF        CentFlag = 'Y'                                           AR812802
     C                   EVAL      CharDate = %CHAR(FRUN05)                                 AR812802
     C                   EVAL      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR812802
     C                   EVAL      FRUN05 = %Date(CHARDATE)                                 AR812802
     C                   ENDIF                                                              AR812802
     C                   EndIf

     C                   If        RUN6 <> *Zero
     C                   Eval      ZDAYNO = RUN6
     C                   EXSR      CENT20                                                   AR812802
     C                   ExSr      ZDATE2
     C                   Eval      FRUN06 = %Date(ZDATE :*DMY)
     C                   IF        CentFlag = 'Y'                                           AR812802
     C                   EVAL      CharDate = %CHAR(FRUN06)                                 AR812802
     C                   EVAL      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR812802
     C                   EVAL      FRUN06 = %Date(CHARDATE)                                 AR812802
     C                   ENDIF                                                              AR812802
     C                   EndIf

     C                   If        RUN7 <> *Zero
     C                   Eval      ZDAYNO = RUN7
     C                   EXSR      CENT20                                                   AR812802
     C                   ExSr      ZDATE2
     C                   Eval      FRUN07 = %Date(ZDATE :*DMY)
     C                   IF        CentFlag = 'Y'                                           AR812802
     C                   EVAL      CharDate = %CHAR(FRUN07)                                 AR812802
     C                   EVAL      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR812802
     C                   EVAL      FRUN07 = %Date(CHARDATE)                                 AR812802
     C                   ENDIF                                                              AR812802
     C                   EndIf

     C                   If        RUN8 <> *Zero
     C                   Eval      ZDAYNO = RUN8
     C                   EXSR      CENT20                                                   AR812802
     C                   ExSr      ZDATE2
     C                   Eval      FRUN08 = %Date(ZDATE :*DMY)
     C                   IF        CentFlag = 'Y'                                           AR812802
     C                   EVAL      CharDate = %CHAR(FRUN08)                                 AR812802
     C                   EVAL      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR812802
     C                   EVAL      FRUN08 = %Date(CHARDATE)                                 AR812802
     C                   ENDIF                                                              AR812802
     C                   EndIf

     C                   If        RUN9 <> *Zero
     C                   Eval      ZDAYNO = RUN9
     C                   EXSR      CENT20                                                   AR812802
     C                   ExSr      ZDATE2
     C                   Eval      FRUN09 = %Date(ZDATE :*DMY)
     C                   IF        CentFlag = 'Y'                                           AR812802
     C                   EVAL      CharDate = %CHAR(FRUN09)                                 AR812802
     C                   EVAL      CharDate = %REPLACE('20':CHARDATE:1:2)                   AR812802
     C                   EVAL      FRUN09 = %Date(CHARDATE)                                 AR812802
     C                   ENDIF                                                              AR812802
     C                   EndIf

     C                   Eval      SSHPC = SHPC / 1000000000000
     C                   Eval      SFAMT = FAMT
     C                   Eval      SMTDH = MTDH
     C                   Eval      SMTDL = MTDL
     C                   Eval      SMTDA = MTDA
     C                   Eval      SLPAM = LPAM
     C                   Eval      SCAMD = CAMD

     C                   Eval      SOAM01 = OAM1
     C                   Eval      SOAM02 = OAM2
     C                   Eval      SOAM03 = OAM3
     C                   Eval      SOAM04 = OAM4
     C                   Eval      SOAM05 = OAM5
     C                   Eval      SOAM06 = OAM6
     C                   Eval      SOAM07 = OAM7
     C                   Eval      SOAM08 = OAM8
     C                   Eval      SOAM09 = OAM9
     C                   Eval      SOAM10 = OA10

     C                   Eval      SQTDA  = QTDA
     C                   Eval      SYTDA  = YTDA

     C                   Eval      ALCY01 = %SubSt(ALCY:1 :3)
     C                   Eval      ALCY02 = %SubSt(ALCY:4 :3)
     C                   Eval      ALCY03 = %SubSt(ALCY:7 :3)
     C                   Eval      ALCY04 = %SubSt(ALCY:10:3)
     C                   Eval      ALCY05 = %SubSt(ALCY:13:3)
     C                   Eval      ALCY06 = %SubSt(ALCY:16:3)
     C                   Eval      ALCY07 = %SubSt(ALCY:19:3)
     C                   Eval      ALCY08 = %SubSt(ALCY:22:3)
     C                   Eval      ALCY09 = %SubSt(ALCY:25:3)
     C                   Eval      ALCY10 = %SubSt(ALCY:28:3)
     C                   Eval      ALCY11 = %SubSt(ALCY:31:3)
     C                   Eval      ALCY12 = %SubSt(ALCY:34:3)

     C                   Eval      DTPS01 = %SubSt(DTPS:1 :1)
     C                   Eval      DTPS02 = %SubSt(DTPS:2 :1)
     C                   Eval      DTPS03 = %SubSt(DTPS:3 :1)
     C                   Eval      DTPS04 = %SubSt(DTPS:4 :1)
     C                   Eval      DTPS05 = %SubSt(DTPS:5 :1)

     C                   Eval      DTPX01 = %SubSt(DTPX:1 :1)
     C                   Eval      DTPX02 = %SubSt(DTPX:2 :1)
     C                   Eval      DTPX03 = %SubSt(DTPX:3 :1)
     C                   Eval      DTPX04 = %SubSt(DTPX:4 :1)
     C                   Eval      DTPX05 = %SubSt(DTPX:5 :1)
     C                   Eval      DTPX06 = %SubSt(DTPX:6 :1)

     C                   Eval      RTPS01 = %SubSt(RTPS:1 :1)
     C                   Eval      RTPS02 = %SubSt(RTPS:2 :1)
     C                   Eval      RTPS03 = %SubSt(RTPS:3 :1)
     C                   Eval      RTPS04 = %SubSt(RTPS:4 :1)
     C                   Eval      RTPS05 = %SubSt(RTPS:5 :1)
     C                   Eval      RTPS06 = %SubSt(RTPS:6 :1)

     C                   Eval      ALCYS  = %Trim(ALCY01) + ' ' +
     C                                      %Trim(ALCY02) + ' ' +
     C                                      %Trim(ALCY03) + ' ' +
     C                                      %Trim(ALCY04) + ' ' +
     C                                      %Trim(ALCY05) + ' ' +
     C                                      %Trim(ALCY06) + ' ' +
     C                                      %Trim(ALCY07) + ' ' +
     C                                      %Trim(ALCY08) + ' ' +
     C                                      %Trim(ALCY09) + ' ' +
     C                                      %Trim(ALCY10) + ' ' +
     C                                      %Trim(ALCY11) + ' ' +
     C                                      %Trim(ALCY12)
     C                   Eval      ALCYS  = %Trim(ALCYS)

     C                   Eval      BTB    = %Trim(BTB1)   + ' ' +
     C                                      %Trim(BTB2)   + ' ' +
     C                                      %Trim(BTB3)   + ' ' +
     C                                      %Trim(BTB4)   + ' ' +
     C                                      %Trim(BTB5)   + ' ' +
     C                                      %Trim(BTB6)

     C                   Eval      DTP    = %Trim(DTP1)   + ' ' +
     C                                      %Trim(DTP2)   + ' ' +
     C                                      %Trim(DTP3)   + ' ' +
     C                                      %Trim(DTP4)

     C                   Eval      NAR    = %Trim(NAR1)   + ' ' +
     C                                      %Trim(NAR2)   + ' ' +
     C                                      %Trim(NAR3)   + ' ' +
     C                                      %Trim(NAR4)

     C                   If        CSEL = *Blanks
     C                   Eval      YNCSEL = 'N'
     C                   Else
     C                   Eval      YNCSEL = CSEL
     C                   EndIf

     C                   If        SECI = *Blanks
     C                   Eval      YNSECI = 'N'
     C                   Else
     C                   Eval      YNSECI = SECI
     C                   EndIf

     C                   Eval      PADFCXPOR = FCXPOR
     C                   Eval      SFCXOML   = FCXOML

     C                   If        FCXCGP = *Zero
     C                   Eval      AFCXCGP = *Blanks
     C                   Else
     C                   Eval      AFCXCGP = %Char(FCXCGP)
     C                   EndIf

     C                   Eval      SFCXCOF  = FCXCOF
     C                   Eval      SFCXCV2  = FCXCV2
     C                   Eval      CLE024   = #CLE024
     C                   Eval      CLE025   = #CLE025
     C                   Eval      CUSTZONE = A8ZONE
     C                   Eval      CGZONE = A8ZONE                                          MD025682

     C                   Select
     C                   When      FDTEX < FRUN01 Or
     C                             FDTAP > FRUN01
     C                   Eval      SAVAILAMT = *Zero
     C                   Other
     C                   Eval      SAVAILAMT = SFAMT - SOAM02
     C                   EndSl

     C                   IF        I_MODE = '*TSK'                                          MD022705
                                                                                            MD022705
     C     GZFCLTKEY     CHAIN     GZFCLTLVL1    GZFCLTDS                                   MD022705
     C                   IF        %FOUND                                                   MD022705
     C                   UPDATE    FCLTLVD0                                                 MD022705
     C                   ELSE                                                               MD022705
     C                   WRITE     FCLTLVD0                                                 MD022705
     C                   ENDIF                                                              MD022705
                                                                                            MD022705
     C                   ELSE                                                               MD022705
     C                   Write     FCLTLVD0
     C                   ENDIF                                                              MD022705

     C                   EndSr
      *****************************************************************                     AR812802
      * Cent20     - Convert Midas date to *DMY format for 20xx.      *                     AR812802
      *****************************************************************                     AR812802
     C     Cent20        BEGSR                                                              AR812802
                                                                                            AR812802
     C                   EVAL      CentFlag = *Blanks                                       AR812802
     C                   IF        ZDAYNO > 10227                                           AR812802
     C                   EVAL      CharDate = *blanks                                       AR812802
     C                   EVAL      CentFlag = 'Y'                                           AR812802
     C                   ENDIF                                                              AR812802
                                                                                            AR812802
     C                   ENDSR                                                              AR812802
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
      *****************************************************************
