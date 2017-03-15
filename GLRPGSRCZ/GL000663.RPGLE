     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL List of Reporting Group / Account Report')    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000663 - Midas GL List of Reporting Group / Account Report *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD043149           Date 15Dec16               *
      *  Prev Amend No. MD043135           Date 15Dec16               *
      *                 MD043079           Date 08Dec16               *
      *                 MD043064           Date 08Dec16               *
      *                 MD043057           Date 07Dec16               *
      *                 MD043045           Date 07Dec16               *
      *                 MD042955           Date 05Dec16               *
      *                 CGL154  *CREATE    Date 13Oct14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD043149 - When the same account holder is void two times,   *
      *             it appears twice also in the generated Draft Void *
      *  MD043135 - Action code must be '1' error                     *
      *  MD043079 - Error Message "Action Code must be 1" is still    *
      *             displayed even if input action code is already    *
      *             corrected and next screen is displayed            *
      *  MD043064 - In the Draft Correct report, only one entry of    *
      *             each customer were being displayed                *
      *  MD043057 - F12 Previous button not working in the account    *
      *             holder details screen                             *
      *  MD043045 - Confirmation Messages are truncated for Actions   *
      *             Amend and Void                                    *
      *  MD042955 - Error Message is displayed on enquiry of an       *
      *             Account Report entry                              *
      *  CGL154 - FATCA Reporting                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR       - Initialise                                    *
      *  *PSSR        - Error processing                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas GL Reports Management - Account Report
     FGL000663DFCF   E             WORKSTN SFILE(GL00066XS1:WxSFRN)
     F                                     SFILE(GL00066XS2:WySFRN)
     F                                     SFILE(GL00066XS3:WzSFRN)
 
      ** Midas GL Reports Management - Account Report
     FGLRMDTL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLRMDTD0:GLRMDT02)
     FGLRMDTL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLRMDTD0:GLRMDT03)
     FGLRMDTL8  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLRMDTD0:GLRMDT08)
     FGLRMDTLB  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLRMDTD0:GLRMDT0B)
 
      ** Midas GL Excluded Account Records File
     FGLRMIEL1  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** Data Structures used by Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS Based On SDCUSTPD
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** External DS Based On SDNAHOPD
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
 
      ** DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Currency Codes Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Output Array for Excluded Records
     D ArAcctDetExOut  S            280A   DIM(50)
 
      ** Output Array for Amend/Corrected Records
     D ArAcctDetAmOut  S             83A   DIM(50)
 
     DWDSO             DS
      ** Work Array for Excluded Records
     D ArAcctDetEx                  280A   DIM(50)
     D  ExCNNH                       10A   OVERLAY(ArAcctDetEx:1)
     D  ExMERM                      256A   OVERLAY(ArAcctDetEx:11)
     D  ExMemb                       10A   OVERLAY(ArAcctDetEx:267)
     D  ExMTyp                        4A   OVERLAY(ArAcctDetEx:277)
 
      ** Work Array for Amend/Corrected Records
     D ArAcctDetAm                   83A   DIM(50)
     D  AmCNNH                       10A   OVERLAY(ArAcctDetAm:1)
     D  AmACNO                       26A   OVERLAY(ArAcctDetAm:11)
     D  AmDRID                       33A   OVERLAY(ArAcctDetAm:37)
     D  AmACHO                       10A   OVERLAY(ArAcctDetAm:70)
     D  AmMTyp                        4A   OVERLAY(ArAcctDetAm:80)
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
     D WxSFRN          S              5  0
     D WySFRN          S              5  0
     D WzSFRN          S              5  0
 
     D KMsgRID         S             21A
     D KTopElm         S             40A
 
     D OIx             S              2S 0 INZ(0)
     D AIx             S              2S 0 INZ(0)
     D OIw             S              2S 0 INZ(0)
     D AIw             S              2S 0 INZ(0)
     D WLeaveExit      S              1A
     D WError          S              1A   INZ('N')
     D WxCNNH          S             10A
     D WxMTYP          S             04A
     D WxRPTN          S             20A
     D WxACHT          S              8A
     D WxACNO          S             26A
     D WxDRID          S             33A
     D WxCRID          S             30A
     D MsgDtaKey       S             26A
     D AcnoStr         S              1A
     D AcnoEnd         S             26A
     D DpAcno          S             26A
     D DpDataKey       S             26A
     D DpAcStr         S              1A
     D DpAcEnd         S             26A
     D DsAcno          S             26A
     D DsDataKey       S             26A
     D DsAcStr         S              1A
     D DsAcEnd         S             26A
     D DDCRID          S             30A
     D DpAHStr         S             10A
     D WSSeq2          S                   LIKE(MGSEQ2)
     D KSeqNo2         S                   LIKE(MGSEQ2)
     D WsFound         S              1A
     D WSSeqNo         S                   LIKE(MGSEQU)
     D KSeqNo          S                   LIKE(MGSEQU)
     D TxCNNH          S             10A
     D WsANEnd         S              1A
     D WExclAccHldr    S              1A
 
      ** Parameter  entry
     D PActionCode     S              1A
     D PMsgRId         S             21A
     D PDRtype         S             18A
     D PDRyear         S              4A
     D PDDocTp         S              7A
     D PDDocRf         S             30A
     D PDCorRf         S             30A
     D PFuncKey        S              3A
 
      ** Parameters AOBANKR0
     D POptn           S              7A
     D PRtcd           S              7A
 
      ** Parameters AOCURRR0
     D PCcyCD          S              3A
 
      ** Parameters AOCUSTR0 / AONAHOR0
     D WCusNah         S             10A
     D PKeyST          S              7A
 
      ** Parameter For ZA0350
     D PMsgFile        S             10A   INZ('SDUSRMSG')
     D PMsgId          S             10A
     D PMsgData        S             45A
 
      ** Parameters for ZFRPED
     D PFld15          S             15  0
     D PDecs           S              1  0
     D PEcode          S              1
     D POut21          S             21
     D POut22          S             22
     D POut25          S             25
 
     D WxACBL          S             21A
     D WxABCC          S              3A
     D WxPSTA          S             21A
     D WxPACC          S              3A
     D FinalAddress    S            200A
     D WSlash          S              5U 0
     D WTrim           S              5U 0
     D MxCUST          S             10A
     D MxType          S              4A
     D MxScrDsp        S              1A   INZ('N')
     D MxIEMSID        S             21A
     D MxIEINEX        S              1A
     D MxIECREF        S             10A
     D WStr            S              3P 0 INZ(1)
     D WReturn         S              1A   INZ('N')
 
     D WIdx            S              3P 0
 
      ** Work DS for Tax Identification Numbers
     DMGDataTIN        DS           125
     D WxMGTIN1                1     25
     D WxMGTIN2               26     50
     D WxMGTIN3               51     75
     D WxMGTIN4               76    100
     D WxMGTIN5              101    125
 
      ** Work DS for TIN Issuing Country
     DMGDataCOT        DS            10
     D WxMGCOT1                1      2
     D WxMGCOT2                3      4
     D WxMGCOT3                5      6
     D WxMGCOT4                7      8
     D WxMGCOT5                9     10
 
     DWkDataTIN        DS
     D WkMGTIN                       25    DIM(5)
     DWkDataCOT        DS
     D WkMGCOT                        2    DIM(5)
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      *                                                               *
      * MAIN PROCEDURE                                                *
      *                                                               *
      *****************************************************************
 
     C                   EVAL      OIx = *ZEROS
     C                   EVAL      AIx = *ZEROS
     C                   EVAL      ArAcctDetExOut = *BLANKS
     C                   EVAL      ArAcctDetAmOut = *BLANKS
 
      ** Display the Screen Until F3 Is Pressed
 
     C                   DOW       (*IN03 = *OFF)
 
     C                   EVAL      *IN03 = *OFF
     C                   EVAL      *IN12 = *OFF
 
      ** Main processing for the Reporting Group - Account Report
 
     C                   EXSR      SrRGACR
 
     C                   IF        PActionCode = 'O'
     C                   MOVEA     ArAcctDetEx   ArAcctDetExOut
     C                   ENDIF
 
     C                   IF        PActionCode = 'A' OR PActionCode = 'C'
     C                             OR PActionCode = 'V'
     C                   MOVEA     ArAcctDetAm   ArAcctDetAmOut
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRGACR - Reporting Group - Account Report Processing         *
      *                                                               *
      *****************************************************************
 
     C     SrRGACR       BEGSR
 
     C                   IF        WIdx = *ZEROS
      ** Clear program queue and message file
 
     C                   CALL      'ZA0250'
     C                   EVAL      WIdx = 0
     C                   EVAL      WError = 'N'
 
      ** Reporting Group - Account Report Main Display
 
     C                   EXSR      SrRGAMD
 
     C                   ELSE
 
     C                   EVAL      DDSFRN = 1
     C                   EVAL      *IN96 = *ON
     C                   WRITE     GL00066XF1
     C                   EXFMT     GL00066XC1
 
     C                   ENDIF
 
      ** IF F5 - Refresh was done
 
     C                   IF        *IN05 = *ON
     C                   EXSR      SrRGAF5
     C                   ENDIF
 
      ** Read Action on Account Report Main Screen Subfile
 
     C                   IF        WxSFRN <> 0
     C                   READC     GL00066XS1
     C                   ENDIF
 
      ** IF F3, F12, F21 and F22 was pressed
 
     C                   IF        *IN03 = *ON OR *IN16 = *ON OR
     C                             *IN21 = *ON OR *IN22 = *ON
     C                   EXSR      SrRGNFK
     C                   LEAVESR
     C                   ENDIF
 
      ** IF F5 - Refresh was done
 
     C                   IF        *IN05 = *ON
     C                   EXSR      SrRGAF5
     C                   ENDIF
 
      ** Read input until end of file reached
 
     C                   DOW       NOT %EOF
 
     C                   EVAL      WIdx = *ZEROS
 
      ** Check if enter key is pressed without selection
 
      ** Invalid Action Code (Only '1' for Selection Allowed)
 
     C                   IF        DDACTN <> '1'
     C                             AND DDACTN <> ' '                                        MD043135
     C                   EVAL      PMsgId = 'USR9358'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
 
     C                   IF        WIdx > *ZEROS
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN33 = *ON
     C                   EVAL      DDSFRN = WxSFRN
     C**********         EVAL      *IN40 = *ON                                              MD043079
     C                   WRITE     GL00066XC0
 
     C                   ELSE
     C                   CALL      'ZA0250'
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN41 = *ON
     C**********         EVAL      *IN40 = *OFF                                             MD043079
     C                   WRITE     GL00066XC0
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      WError = 'N'
     C                   ENDIF
 
     C                   EVAL      *IN34 = *ON
     C                   UPDATE    GL00066XS1
     C                   READC     GL00066XS1
 
     C                   ENDDO
 
     C                   EVAL      *IN34 = *OFF
 
      ** If Error, stop processing further
 
     C                   IF        (WError = 'Y')
     C                             OR (WxSFRN = *ZEROS)
     C                   LEAVESR
     C                   ENDIF
 
      ** If action code / option is '1' call detail processing
 
     C                   READC     GL00066XS1
 
     C                   DOW       NOT %EOF
 
     C                   IF        DDACTN = '1'
 
     C                   EVAL      WxCNNH = DDCNNH
     C                   EVAL      WxRPTN = DDRPTN
     C                   EVAL      WxACHT = DDACHT
     C                   EVAL      WxACNO = DDACNO
     C                   EVAL      WxDRID = DDDRID
     C                   EVAL      WxCRID = DDCRID
     C                   EVAL      WxMTYP = DDMTYP
 
      ** Reporting Group - Account Report Detail Processing
 
     C                   EXSR      SrRGADP
 
      ** Reporting Group - Account Report Records Output
 
     C                   IF        PActionCode = 'O' OR
     C                             PActionCode = 'A' OR
     C                             PActionCode = 'C' OR
     C                             PActionCode = 'V'
     C                   IF        *IN12 = '0'
     C                   EXSR      SrRGARO
     C                   ENDIF
     C                   ENDIF
 
      ** IF F3, F12, F21 and F22 was pressed
 
     C                   IF        WLeaveExit = 'Y'
     C                   EXSR      SrRGNFK
     C                   LEAVESR
     C                   ENDIF
 
      ** If function F12 is pressed in detail screen, turn off F12
      ** return to main list of exception screen only
 
     C                   IF        *IN12 = *ON
     C                   EVAL      *IN12 = *OFF
     C                   ENDIF
 
     C                   EVAL      DDACTN = *BLANKS
     C                   UPDATE    GL00066XS1
     C                   ENDIF
 
     C                   READC     GL00066XS1
     C                   ENDDO
 
      ** Navigation for Functions Keys
 
     C                   EXSR      SrRGNFK
 
     C                   IF        PActionCode = 'O'
     C                   MOVEA     ArAcctDetEx   ArAcctDetExOut
     C                   ENDIF
 
     C                   IF        PActionCode = 'A' OR PActionCode = 'C'
     C                             OR PActionCode = 'V'
     C                   MOVEA     ArAcctDetAm   ArAcctDetAmOut
     C                   ENDIF
 
     C**********         IF        WExclAccHldr = 'Y'                                       MD042955
     C**********         EVAL      PMsgId = 'USR7524'                                       MD042955
     C**********         EVAL      WIdx = WIdx + 1                                          MD042955
     C**********         EXSR      SRErrDta                                                 MD042955
     C**********         EVAL      WError = 'Y'                                             MD042955
     C**********         EVAL      *IN33 = *ON                                              MD042955
     C**********         EVAL      DDSFRN = WxSFRN                                          MD042955
     C**********         EVAL      *IN40 = *ON                                              MD042955
     C**********         WRITE     GL00066XC0                                               MD042955
     C**********         ENDIF                                                              MD042955
 
     C                   IF        *INKC = *ON
     C                   EVAL      WExclAccHldr = 'N'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRGNFK - Reporting Group - Navigation for Function Keys      *
      *                                                               *
      *****************************************************************
 
     C     SrRGNFK       BEGSR
 
     C                   SELECT
 
     C                   WHEN      *IN03 = *ON
     C                   EVAL      PFuncKey = 'F3 '
     C                   WHEN      *IN12 = *ON
     C                   EVAL      PFuncKey = 'F12'
     C                   WHEN      *IN16 = *ON
     C                   EVAL      PFuncKey = 'F12'
     C                   EVAL      *IN03 = *ON
     C                   WHEN      *IN21 = *ON
     C                   EVAL      PFuncKey = 'F21'
     C                   EVAL      *IN03 = *ON
     C                   WHEN      *IN22 = *ON
     C                   EVAL      PFuncKey = 'F22'
     C                   EVAL      *IN03 = *ON
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRGAF5 - Reporting Group - Account Report F5 Refresh         *
      *                                                               *
      *****************************************************************
 
     C     SrRGAF5       BEGSR
 
     C                   CALL      'ZA0250'
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN41 = *ON
     C**********         EVAL      *IN40 = *OFF                                             MD043079
     C**********         EVAL      *IN46 = *ON                                              MD043079
     C                   WRITE     GL00066XC0
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      WError = 'N'
 
     C                   EXSR      SrRGAMD
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRGARO - Reporting Group - Account Report Records Output     *
      *                                                               *
      *****************************************************************
 
     C     SrRGARO       BEGSR
 
      ** Process the Record Selected for Omit/Exclude Array
     C                   IF        PActionCode = 'O'
     C                   EVAL      WStr = %LOOKUP(MxCUST:ExCNNH)
     C                   IF        WStr <> 0
     C                   EVAL      OIw = WStr
     C                   ELSEIF    WStr = 0
     C                   EVAL      OIx = OIx + 1
     C                   EVAL      OIw = OIx
     C                   ENDIF
     C                   EVAL      ExCNNH(OIw) = MxCUST
     C                   EVAL      ExMemb(OIw) = DDCNNH
     C                   EVAL      ExMTyp(OIw) = MxType
     C                   EVAL      ExMERM(OIw) = D2MER1 + D2MER2 +
     C                             D2MER3 + D2MER4
     C                   ENDIF
 
      ** Process the Record Selected for Amend/Correct Array
     C                   IF        PActionCode = 'A' or
     C                             PActionCode = 'C' or
     C                             PActionCode = 'V'
     C**********         EVAL      WStr = %LOOKUP(MxCUST:AmCNNH)                            MD043064
     C**********         IF        WStr <> 0                                                MD043064
     C**********         EVAL      AIw = WStr                                               MD043064
     C**********         ELSEIF    WStr = 0                                                 MD043064
     C*********          EVAL      AIx = AIx + 1                                            MD043149
     C**********         EVAL      AIw = AIx                                                MD043064
     C**********         ENDIF                                                              MD043064
     C**********         EVAL      AmCNNH(AIw) = MxCUST                                     MD043064
     C**********         EVAL      AmACHO(AIw) = DDCNNH                                     MD043064
     C**********         EVAL      AmMTyp(AIw) = MxType                                     MD043064
     C**********         EVAL      AmACNO(AIw) = DDACNO                                     MD043064
     C**********         EVAL      AmDRID(AIw) = DDDRID                                     MD043064
     C**********         EVAL      AmCNNH(AIx) = MxCUST                                     MD043149
     C**********         EVAL      AmACHO(AIx) = DDCNNH                                     MD043149
     C**********         EVAL      AmMTyp(AIx) = MxType                                     MD043149
     C**********         EVAL      AmACNO(AIx) = DDACNO                                     MD043149
     C**********         EVAL      AmDRID(AIx) = DDDRID                                     MD043149
     C                   EVAL      WStr = %LOOKUP(DDACNO:AmACNO)                            MD043149
     C                   IF        WStr <> 0                                                MD043149
     C                   EVAL      AIw = WStr                                               MD043149
     C                   ELSEIF    WStr = 0                                                 MD043149
     C                   EVAL      AIx = AIx + 1                                            MD043149
     C                   EVAL      AIw = AIx                                                MD043149
     C                   ENDIF                                                              MD043149
     C                   EVAL      AmCNNH(AIw) = MxCUST                                     MD043149
     C                   EVAL      AmACHO(AIw) = DDCNNH                                     MD043149
     C                   EVAL      AmMTyp(AIw) = MxType                                     MD043149
     C                   EVAL      AmACNO(AIw) = DDACNO                                     MD043149
     C                   EVAL      AmDRID(AIw) = DDDRID                                     MD043149
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRGADP - Reporting Group - Account Report Detail Processing  *
      *                                                               *
      *****************************************************************
 
     C     SrRGADP       BEGSR
 
     C                   EVAL      WLeaveExit = 'N'
 
      ** Reporting Group - Account Report - Account Holder Details
 
     C     RGAHD         TAG
     C                   EXSR      SrRGAHD
 
     C                   EVAL      D2SFRN = D2SFRN + 1
     C                   WRITE     GL00066XF2
 
     C                   IF        PActionCode = 'O'
     C                   EVAL      WStr = %LOOKUP(WXCNNH:ExCNNH)
     C                   IF        WStr <> 0
     C                   EVAL      D2MER1 = %SUBST(ExMERM(WStr):1:64)
     C                   EVAL      D2MER2 = %SUBST(ExMERM(WStr):65:64)
     C                   EVAL      D2MER3 = %SUBST(ExMERM(WStr):129:64)
     C                   EVAL      D2MER4 = %SUBST(ExMERM(WStr):193:64)
 
     C                   EVAL      PMsgId = 'USS0692'
     C                   EXSR      SRErrDta
     C                   WRITE     GL00066XF4
     C**********         EVAL      *IN40 = *ON                                              MD043079
     C                   WRITE     GL00066XC0
     C**********         EVAL      *IN40 = *OFF                                             MD043079
 
     C                   ELSE
     C                   EVAL      D2MER1 = *BLANKS
     C                   EVAL      D2MER2 = *BLANKS
     C                   EVAL      D2MER3 = *BLANKS
     C                   EVAL      D2MER4 = *BLANKS
     C                   ENDIF
 
     C     RGEXC         TAG
 
     C                   DOU       *IN42 = *OFF
     C                   EXFMT     GL00066XF4
 
     C                   EVAL      *IN42 = *OFF
     C                   CALL      'ZA0250'
     C                   IF        D2MER1 <> *BLANKS
     C                             OR D2MER2 <> *BLANKS
     C                             OR D2MER3 <> *BLANKS
     C                             OR D2MER4 <> *BLANKS
     C                   ELSE
     C                   IF        *IN12 = *OFF
     C                   EVAL      PMsgId = 'USS0565'
     C                   EXSR      SRErrDta
     C                   EVAL      *IN42 = *ON
     C                   WRITE     GL00066XF4
     C                   ENDIF
     C                   ENDIF
     C**********         EVAL      *IN40 = *ON                                              MD043079
     C                   WRITE     GL00066XC0
     C**********         EVAL      *IN40 = *OFF                                             MD043079
 
     C                   IF        *IN03 = *ON OR *IN12 = *ON
     C                   CALL      'ZA0250'
 
     C                   SELECT
 
     C                   WHEN      *IN03 = *ON
     C                   EVAL      PFuncKey = 'F3 '
     C                   EVAL      WLeaveExit = 'Y'
     C                   WHEN      *IN12 = *ON
     C                   EVAL      PFuncKey = 'F12'
     C                   ENDSL
 
     C                   LEAVESR
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
 
     C     RGIOD         TAG
      ** Account Report - Individual / Organisation Detail
     C                   EXFMT     GL00066XF0
 
     C                   IF        *IN03 = *ON OR *IN12 = *ON
 
     C                   SELECT
 
     C                   WHEN      *IN03 = *ON
     C                   EVAL      PFuncKey = 'F3 '
     C                   EVAL      WLeaveExit = 'Y'
     C                   WHEN      *IN12 = *ON
     C                   EVAL      PFuncKey = 'F12'
     C                   IF        PActionCode <> 'O'
     C**********         GOTO      RGAHD                                                    MD043057
     C                   ELSE
     C                   GOTO      RGEXC
     C                   ENDIF
     C                   ENDSL
 
     C                   LEAVESR
     C                   ENDIF
 
      ** Reporting Group - Account Report - Manual Inclusion Remarks Screen
 
     C     RGAMI         TAG
     C                   EXSR      SrRGAMI
 
     C                   IF        *IN03 = *ON OR *IN12 = *ON
 
     C                   SELECT
 
     C                   WHEN      *IN03 = *ON
     C                   EVAL      PFuncKey = 'F3 '
     C                   EVAL      WLeaveExit = 'Y'
     C                   LEAVESR
     C                   WHEN      *IN12 = *ON
     C                   EVAL      PFuncKey = 'F12'
     C                   GOTO      RGAHD
     C                   ENDSL
 
     C                   ENDIF
 
      ** Reporting Group - Account Report - Substantial Owners
 
     C     RGASO         TAG
     C                   EXSR      SrRGASO
 
     C                   IF        *IN03 = *ON OR *IN12 = *ON
 
     C                   SELECT
 
     C                   WHEN      *IN03 = *ON
     C                   EVAL      PFuncKey = 'F3 '
     C                   EVAL      WLeaveExit = 'Y'
     C                   LEAVESR
     C                   WHEN      *IN12 = *ON
     C                   EVAL      PFuncKey = 'F12'
     C                   IF        MxScrDsp = 'N'
     C                   IF        PActionCode <> 'O'
     C                   GOTO      RGAHD
     C                   ELSE
     C                   GOTO      RGIOD
     C                   ENDIF
     C                   ELSE
     C                   GOTO      RGAMI
     C                   ENDIF
     C                   ENDSL
 
     C                   ENDIF
 
      ** Reporting Group - Account Report - Payment Details
 
     C                   EXSR      SrRGAPD
 
     C                   IF        *IN03 = *ON OR *IN12 = *ON
 
     C                   SELECT
 
     C                   WHEN      *IN03 = *ON
     C                   EVAL      PFuncKey = 'F3 '
     C                   EVAL      WLeaveExit = 'Y'
     C                   LEAVESR
     C                   WHEN      *IN12 = *ON
     C                   EVAL      PFuncKey = 'F12'
     C                   IF        WReturn = 'N'
     C                   GOTO      RGASO
     C                   ELSEIF    WReturn = 'Y'
     C                   GOTO      RTURN
     C                   ENDIF
     C                   ENDSL
 
     C                   ENDIF
 
     C     RTURN         TAG
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRGAMD - Reporting Group - Account Report Main Display       *
      *                                                               *
      *****************************************************************
 
     C     SrRGAMD       BEGSR
 
     C                   EVAL      *IN81 = *ON
     C                   EVAL      WxSFRN = *ZEROS
     C                   EVAL      DDSFRN = *ZEROS
     C                   EVAL      DDACTN = *BLANKS
     C                   EVAL      DDDTIN = *BLANKS
     C                   EVAL      D2DTIN = *BLANKS
     C                   EVAL      D4DTIN = *BLANKS
     C                   EVAL      DDACTC = PActionCode
     C                   EVAL      DDRTYP = PDRtype
     C                   EVAL      DDRYER = PDRyear
     C                   EVAL      *IN95 = *ON
     C                   WRITE     GL00066XC1
     C                   EVAL      *IN95 = *OFF
 
     C     PMsgRId       SETLL     GLRMDTL2
     C     PMsgRId       READE     GLRMDTL2
     C                   DOW       NOT %EOF(GLRMDTL2)
     C                             AND PMsgRId = MGMSID
 
     C                   SELECT
 
     C                   WHEN      MGELMT = 'DocTypeIndic'
     C                             AND MGTPMT = 'AccountReport'
     C                   EVAL      DDDTIN = MGDATA
     C                   EVAL      D2DTIN = MGDATA
     C                   EVAL      D4DTIN = MGDATA
 
     C                   WHEN      MGELMT = 'DocRefId'
     C                   EVAL      DDDRID = MGDATA
 
     C                   WHEN      MGELMT = 'CorrDocRefId'
     C                   EVAL      DDCRID = MGDATA
 
     C                   WHEN      MGELMT = 'AccountNumber'
     C                   EVAL      DDACNO = MGDATA
 
     C                   WHEN      MGELMT = 'AcctHolder'
     C                   EVAL      DDCNNH = MGDATA
     C                   EVAL      DDMTYP = MGMTYP
     C                   IF        MGDAT2 = 'CUST'
     C                   EXSR      SRCallCS
     C                   ELSEIF    MGDAT2 = 'NAHO'
     C                   EXSR      SRCallNH
     C                   ENDIF
 
     C                   WHEN      MGELMT = 'AcctHolderType'
     C                   EVAL      DDACHT = MGDATA
     C                   EVAL      D2ACHT = MGDATA
     C                   EVAL      WxSFRN = WxSFRN + 1
     C                   EVAL      DDSFRN = WxSFRN
     C                   WRITE     GL00066XS1
 
     C                   ENDSL
 
     C                   READ      GLRMDTL2
 
     C                   ENDDO
 
     C                   IF        WxSFRN <> 0
     C                   EVAL      *IN97 = *ON
     C                   ELSE
     C                   EVAL      PMsgId = 'USR7530'
     C                   EXSR      SRErrDta
     C**********         EVAL      *IN40 = *ON                                              MD043079
     C                   WRITE     GL00066XC0
     C**********         EVAL      *IN40 = *OFF                                             MD043079
     C                   ENDIF
 
      ** Display Account Report Main Screen
 
     C                   EVAL      DDSFRN = 1
     C                   EVAL      *IN96 = *ON
     C                   WRITE     GL00066XF1
     C                   EXFMT     GL00066XC1
 
     C                   IF        *IN03 = *ON OR *IN16 = *ON
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRGAHD - Account Report - Account Holder Details             *
      *                                                               *
      *****************************************************************
 
     C     SrRGAHD       BEGSR
 
     C                   EVAL      D2SFRN = *ZEROS
     C                   EVAL      D4SFRN = *ZEROS
     C                   EVAL      AcnoStr = *BLANKS
     C                   EVAL      KMsgRID = PMsgRId
     C                   EVAL      KTopElm = *BLANKS
     C                   EVAL      KSeqNo2 = *ZEROS
 
      ** Reset D2BRTD per Account Holder
     C                   EVAL      D2BRTD = *BLANKS
     C                   EVAL      D2ABCC = *BLANKS
     C                   EVAL      D2ACBL = *BLANKS
 
     C     KAcctNo       SETLL     GLRMDTL8
     C                   READ      GLRMDTL8
     C                   DOW       NOT %EOF(GLRMDTL8)
     C                             AND PMsgRId = MGMSID
     C                             AND WxACNO = MGACNO
     C                             AND WxCNNH = MGACHO
     C                             AND WxMTYP = MGMTYP
 
     C                   SELECT
 
     C                   WHEN      MGELMT = 'CorrDocRefId'
     C                             AND MGTPMT = 'AccountReport'
     C                   EVAL      D2CRID = MGDATA
 
     C                   WHEN      MGELMT = 'AcctHolder'
     C                             AND (MGTPMT = 'Individual' OR
     C                                  MGTPMT = 'Organisation')
     C                   EVAL      TxCNNH = MGDATA
     C                   EVAL      MxType = MGDAT2
 
     C                   WHEN      MGELMT = 'AccountNumber'
     C                             AND (MGTPMT = 'Individual' OR
     C                                  MGTPMT = 'Organisation')
     C                   EVAL      D2ACNO = WxACNO
     C                   EVAL      D2CNNH = WxCNNH
     C                   EVAL      D2DRID = WxDRID
     C                   EVAL      D2RPTN = DDRPTN
     C                   EVAL      D2ACHT = DDACHT
     C                   EVAL      MxCUST = MGCUST
     C                   EVAL      AcnoEnd = %TRIM(MGDATA)
     C                   EVAL      MsgDtaKey = %TRIM(MGDATA)
 
     C                   WHEN      MGELMT = 'AccountBalance'
     C                             AND MGTPMT = 'AccountBalance'
     C                   EVAL      WxACBL = MGDATA
     C                   EVAL      D2ABCC = MGDAT2
     C                   EVAL      WxABCC = MGDAT2
     C                   EVAL      PCcyCD = WxABCC
     C                   EVAL      PDECS = 0
     C                   EXSR      SrCurrCd
     C                   EVAL      PFLD15 = %DEC(WxACBL:15:0)
     C                   Z-ADD     A6NBDP        PDECS
     C                   EXSR      SRCvtAmt
     C                   MOVE      POUT22        D2ACBL
 
     C                   WHEN      MGELMT = 'FirstName' AND
     C                             MGTPMT = 'Individual'
     C                   EVAL      D2FNME = MGDATA
 
     C                   WHEN      MGELMT = 'LastName' AND
     C                             MGTPMT = 'Individual'
     C                   EVAL      D2LNME = MGDATA
 
     C                   WHEN      MGELMT = 'Name' AND
     C                             MGTPMT = 'Organisation'
     C                   EVAL      D2FNME = MGDATA
     C                   EVAL      D2LNME = *BLANKS
 
     C                   WHEN      MGELMT = 'AddressFree' AND
     C                             MGTPMT = 'Organisation' OR
     C                             MGELMT = 'AddressFree' AND
     C                             MGTPMT = 'Individual'
     C                   EVAL      FinalAddress = %TRIM(MGDATA)
     C                   EVAL      WSlash = %SCAN('/':FinalAddress)
     C                   EVAL      WSlash = WSlash + 1
     C                   EVAL      WTrim = %SCAN('/':FinalAddress:WSlash)
     C                   EVAL      D2ADD1 = %SUBST(FinalAddress:1:WTrim)
     C                   EVAL      D2ADD1 = %TRIM(D2ADD1)
     C                   EVAL      WTrim = WTrim + 1
     C                   EVAL      D2ADD2 = %SUBST(FinalAddress:WTrim:60)
     C                   EVAL      D2ADD2 = %TRIM(D2ADD2)
 
     C                   WHEN      MGELMT = 'TIN' AND
     C                             MGTPMT = 'Organisation' OR
     C                             MGELMT = 'TIN' AND
     C                             MGTPMT = 'Individual'
     C                   EVAL      MGDataTIN = MGDATA
     C                   EVAL      D2TIN1 = WxMGTIN1
     C                   EVAL      MGDataCOT = MGDAT2
     C                   EVAL      D2COT1 = WxMGCOT1
 
     C                   WHEN      MGELMT = 'ResCountryCode' AND
     C                             MGTPMT = 'Organisation' OR
     C                             MGELMT = 'ResCountryCode' AND
     C                             MGTPMT = 'Individual'
     C                   EVAL      D2RECO = MGDATA
 
     C                   WHEN      MGELMT = 'CountryCode' AND
     C                             MGTPMT = 'Organisation' OR
     C                             MGELMT = 'CountryCode' AND
     C                             MGTPMT = 'Individual'
     C                   EVAL      D2COCO = MGDATA
 
     C                   WHEN      MGELMT = 'BirthDate' AND
     C                             MGTPMT = 'Individual'
     C                   EVAL      D2BRTD = %SUBST(MGDATA:1:4)
     C                                      + '-' + %SUBST(MGDATA:5:2)
     C                                      + '-' + %SUBST(MGDATA:7:2)
     C                   ENDSL
 
     C                   READ      GLRMDTL8
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRGAPD - Account Report - Payment Details                    *
      *                                                               *
      *****************************************************************
 
     C     SrRGAPD       BEGSR
 
     C                   EVAL      WySFRN = *ZEROS
     C                   EVAL      D2SFRN = *ZEROS
     C                   EVAL      DpAcStr = *BLANKS
     C                   EVAL      *IN97 = *OFF
     C                   EVAL      *IN96 = *OFF
     C                   EVAL      WsSeq2 = 1
     C                   EVAL      WsFound = 'N'
     C                   EVAL      WsANEnd = 'N'
     C                   EVAL      WsSeqNo = 3001
     C                   EVAL      KMsgRID = PMsgRId
     C                   EVAL      KTopElm = 'Payment'
     C                   EVAL      KSeqNo2 = WsSeqNo
 
     C                   EVAL      *IN95 = *ON
     C                   WRITE     GL00066XC2
     C                   EVAL      *IN95 = *OFF
 
     C     KAcctN2       SETLL     GLRMDTLB
     C                   READ      GLRMDTLB
     C                   DOW       NOT %EOF(GLRMDTLB)
     C                             AND PMsgRId = MGMSID
     C                             AND WxACNO = MGACNO
     C                             AND KTopElm = MGTPMT
     C                             AND WxCNNH = MGACHO
     C                             AND WxMTYP = MGMTYP
 
     C                   EVAL      WsFound = 'Y'
     C                   IF        MGELMT = 'Type'
     C                             AND WsANEnd = 'Y'
     C                   EVAL      WsANEnd = 'N'
     C                   EVAL      WySFRN = WySFRN + 1
     C                   EVAL      D2SFRN = WySFRN
     C                   WRITE     GL00066XS2
     C                   ENDIF
 
     C                   SELECT
 
      ** Reporting Group - Account Report Payment Detail
 
     C                   WHEN      MGELMT = 'AcctHolder'
     C                   EVAL      DpAHStr = MGDATA
 
     C                   WHEN      MGELMT = 'Type'
     C                   EVAL      D3PAYT = MGDATA
 
     C                   WHEN      MGELMT = 'PaymentAmnt'
     C                   EVAL      WxPSTA = MGDATA
     C                   EVAL      D3PACC = MGDAT2
     C                   EVAL      WxPACC = MGDAT2
     C                   EVAL      PCcyCD = WxPACC
     C                   EVAL      PDECS = 0
     C                   EXSR      SrCurrCd
     C                   EVAL      PFLD15 = %DEC(WxPSTA:15:0)
     C                   Z-ADD     A6NBDP        PDECS
     C                   EXSR      SRCvtAmt
     C                   MOVE      POUT22        D3PSTA
 
     C                   WHEN      MGELMT = 'AccountNumber'
     C                   EVAL      DpAcEnd = MGDATA
     C                   EVAL      WsANEnd = 'Y'
 
     C                   ENDSL
 
     C                   READ      GLRMDTLB
 
     C                   ENDDO
 
     C                   IF        WsFound = 'Y'
     C                   EVAL      WySFRN = WySFRN + 1
     C                   EVAL      D2SFRN = WySFRN
     C                   WRITE     GL00066XS2
     C                   ENDIF
 
     C                   IF        WySFRN = 0
     C                   EVAL      D3PAYT = *BLANKS
     C                   EVAL      D3PACC = *BLANKS
     C                   EVAL      D3PSTA = *BLANKS
     C                   EVAL      *IN97 = *ON
     C                   EVAL      WySFRN = WySFRN + 1
     C                   EVAL      D2SFRN = WySFRN
     C                   WRITE     GL00066XS2
     C                   EVAL      WySFRN = *ZEROS
     C                   ENDIF
 
     C                   IF        WySFRN <> 0
     C                   EVAL      *IN97 = *ON
     C                   ENDIF
 
     C     SRABScr       TAG
     C                   EVAL      *IN03 = *OFF
     C                   EVAL      *IN12 = *OFF
     C                   EVAL      *IN96 = *ON
     C                   WRITE     GL00066XF2
     C                   EVAL      *IN90 = *OFF
     C                   EXFMT     GL00066XC2
 
     C                   IF        *IN12 = *ON
     C                   MOVE      'N'           WReturn
     C                   GOTO      SRABRtn
     C                   ENDIF
 
     C                   EVAL      *IN51 = *OFF
     C                   EVAL      *IN52 = *OFF
     C                   EVAL      *IN53 = *OFF
     C                   EVAL      *IN54 = *OFF                                             MD043045
     C                   EVAL      *IN55 = *OFF                                             MD043045
     C                   IF        *IN03 <> *ON AND
     C                             *IN12 <> *ON
     C                   EVAL      *IN96 = *ON
     C                   IF        PActionCode = 'O' OR
     C                             PActionCode = 'C' OR
     C                             PActionCode = 'A' OR
     C                             PActionCode = 'V'
     C                   IF        PActionCode = 'O'
     C                   EVAL      *IN51 = *ON
     C                   ENDIF
     C                   IF        PActionCode = 'I'
     C                   EVAL      *IN52 = *ON
     C                   ENDIF
     C                   IF        PActionCode = 'C'
     C                   EVAL      *IN53 = *ON
     C                   ENDIF
     C                   IF        PActionCode = 'A'                                        MD043045
     C                   EVAL      *IN54 = *ON                                              MD043045
     C                   ENDIF                                                              MD043045
     C                   IF        PActionCode = 'V'                                        MD043045
     C                   EVAL      *IN55 = *ON                                              MD043045
     C                   ENDIF                                                              MD043045
     C                   WRITE     GL00066XF3
     C                   EVAL      *IN90 = *ON
     C                   EXFMT     GL00066XC2
     C                   ENDIF
 
     C                   MOVE      'N'           WReturn
     C                   MOVE      'N'           WExclAccHldr
     C                   IF        *IN12 = *ON
     C                   EVAL      WReturn = 'Y'
     C                   EVAL      *IN53 = *ON
     C                   ELSE
     C                   MOVE      'Y'           WExclAccHldr
     C                   ENDIF
     C                   ENDIF
     C     SRABRtn       TAG
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRGAMI - Account Report - Manual Inclusion Remarks Display   *
      *                                                               *
      *****************************************************************
 
     C     SrRGAMI       BEGSR
 
     C                   EVAL      MxIEMSID = PMsgRId
     C                   EVAL      MxIEINEX = 'I'
     C                   EVAL      MxIECREF = WxCNNH
 
     C     KAcctMI       CHAIN     GLRMIEL1
 
     C                   IF        %FOUND(GLRMIEL1)
 
     C                   EVAL      MxScrDsp = 'Y'
     C                   EVAL      D2MIR1 = %SUBST(IERMRK:1:64)
     C                   EVAL      D2MIR2 = %SUBST(IERMRK:65:64)
     C                   EVAL      D2MIR3 = %SUBST(IERMRK:129:64)
     C                   EVAL      D2MIR4 = %SUBST(IERMRK:193:64)
     C                   EVAL      D2USER = IEUSER
     C                   EVAL      D2TMST = IETMST
 
     C                   EXFMT     GL00066XF5
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRGASO - Account Report - Substantial Owners                 *
      *                                                               *
      *****************************************************************
 
     C     SrRGASO       BEGSR
 
     C                   EVAL      WzSFRN = *ZEROS
     C                   EVAL      D4SFRN = *ZEROS
     C                   EVAL      DsAcStr = *BLANKS
     C                   EVAL      WsSeq2 = 1
     C                   EVAL      WsFound = 'N'
     C                   EVAL      WsSeqNo = 1001
     C                   EVAL      *IN97 = *OFF
     C                   EVAL      *IN96 = *OFF
     C                   EVAL      KMsgRID = PMsgRId
     C                   EVAL      KTopElm = 'SubstantialOwner'
     C                   EVAL      KSeqNo2 = WsSeqNo
 
     C                   EVAL      *IN95 = *ON
     C                   WRITE     GL00066XC3
     C                   EVAL      *IN95 = *OFF
 
     C     KAcctNo       SETLL     GLRMDTL8
     C                   READ      GLRMDTL8
     C                   DOW       NOT %EOF(GLRMDTL8)
     C                             AND PMsgRId = MGMSID
     C                             AND WxACNO = MGACNO
     C                             AND KTopElm = MGTPMT
     C                             AND WxCNNH = MGACHO
     C                             AND WxMTYP = MGMTYP
 
     C                   EVAL      WsFound = 'Y'
 
     C                   IF        WsSeqNo <> MGSEQU
     C                   EVAL      WsSeqNo =  MGSEQU
     C                   EVAL      WzSFRN = WzSFRN + 1
     C                   EVAL      D4SFRN = 1
     C                   WRITE     GL00066XS3
     C                   ENDIF
 
     C                   SELECT
 
     C                   WHEN      MGELMT = 'AccountNumber'
     C                   EVAL      D5ACNO = MGDATA
     C                   EVAL      DsAcno = WxACNO
     C                   EVAL      DsAcEnd = %TRIM(MGDATA)
     C                   EVAL      DsDataKey = %TRIM(MGDATA)
 
     C                   WHEN      MGELMT = 'TIN'
     C                   EVAL      WkDataTIN = MGDATA
     C                   EVAL      WkDataCOT = MGDAT2
     C                   EVAL      D5TIN1 =WkMGTIN(1) + ' ' + WkMGCOT(1)
 
     C                   WHEN      MGELMT = 'ResCountryCode'
     C                   EVAL      D5RECO = MGDATA
 
     C                   WHEN      MGELMT = 'CountryCode'
     C                   EVAL      D5COCO = MGDATA
 
     C                   WHEN      MGELMT = 'FirstName'
     C                   EVAL      D5FNME = MGDATA
 
     C                   WHEN      MGELMT = 'LastName'
     C                   EVAL      D5LNME = MGDATA
 
     C                   WHEN      MGELMT = 'Name'
     C                   EVAL      D5FNME = MGDATA
 
     C                   WHEN      MGELMT = 'AddressFree'
     C                   EVAL      FinalAddress = %TRIM(MGDATA)
     C                   EVAL      D5ADD1 = FinalAddress
 
     C                   WHEN      MGELMT = 'BirthDate'
     C                   EVAL      D5BRTD = %SUBST(MGDATA:1:4)
     C                                      + '-' + %SUBST(MGDATA:5:2)
     C                                      + '-' + %SUBST(MGDATA:7:2)
 
     C                   ENDSL
 
     C                   READ      GLRMDTL8
 
     C                   ENDDO
 
     C                   IF        WsFound = 'Y'
     C                   EVAL      WzSFRN = WzSFRN + 1
     C                   EVAL      D4SFRN = 1
     C                   WRITE     GL00066XS3
     C                   ENDIF
 
     C                   IF        WzSFRN <> 0
     C                   EVAL      *IN97 = *ON
     C                   ENDIF
 
     C                   EVAL      *IN96 = *ON
     C                   WRITE     GL00066XF2
     C                   EXFMT     GL00066XC3
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCallCS - Call access object to retrieve report name        *
      *                                                               *
      *****************************************************************
     C     SRCallCS      BEGSR
 
      ** Retrieve Customer Report Name
 
     C                   EVAL      WCusNah = *BLANKS
     C                   EVAL      WCusNah = DDCNNH
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    WCusNah
     C                   PARM      *BLANKS       PKeyST
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** Database error processing
     C                   IF        PRtcd <> *BLANKS
     C                             AND PRtcd <> '*CUSDEL'
     C                             AND PRtcd <> '*CUSCLS'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY = WCusNah
     C                   EVAL      DBASE = 002
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF
 
     C                   IF        PRtcd = '*CUSDEL'
     C                             OR PRtcd = '*CUSCLS'
     C                   ENDIF
 
     C                   EVAL      DDRPTN = *BLANKS
     C                   EVAL      DDRPTN = BBCRNM
     C                   EVAL      D2RPTN = *BLANKS
     C                   EVAL      D2RPTN = BBCRNM
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCallNH - Call access object to retrieve report name        *
      *                                                               *
      *****************************************************************
     C     SRCallNH      BEGSR
 
      ** Get Non-account holder Report Name
 
     C                   EVAL      WCusNah = *BLANKS
     C                   EVAL      WCusNah = DDCNNH
 
     C                   CALLB     'AONAHOR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    WCusNah
     C     SDNAHO        PARM      SDNAHO        DSSDY
 
      ** Database error processing
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDNAHOPD'
     C                   EVAL      DBKEY = WCusNah
     C                   EVAL      DBASE = 003
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF
 
     C                   EVAL      DDRPTN = *BLANKS
     C                   EVAL      DDRPTN = NHNARN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRErrDta - Output Error Message with data                    *
      *                                                               *
      *****************************************************************
     C     SRErrDta      BEGSR
 
     C                   CALL      'ZA0350'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgId
     C                   PARM                    PMsgData
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCurrCd - Subroutine to get the number of decimals set for  *
      *             a given currency                                  *
      *                                                               *
      *****************************************************************
     C     SrCurrCd      BEGSR
 
     C     PCcyCD        IFNE      *BLANKS
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCcyCD
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCvtAmt - This subroutine calls the program that inserts a   *
      *            decimal point and sign into a numeric field,       *
      *            to blank out leading zeros and optionally inserting*
      *            commas                                             *
      *                                                               *
      *****************************************************************
     C     SRCvtAmt      BEGSR
 
     C                   CALLB     'ZFRPED'
     C                   PARM                    PFLD15
     C                   PARM                    PDECS
     C                   PARM      'J'           PECODE
     C                   PARM      *Blanks       POUT22
     C                   PARM      *Blanks       POUT25
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Access Bank file to set system date, time, job       *
      *          and user in the screen header                        *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PActionCode
     C                   PARM                    PMsgRId
     C                   PARM                    PDRtype
     C                   PARM                    PDRyear
     C                   PARM                    PDDocTp
     C                   PARM                    PDDocRf
     C                   PARM                    PDCorRf
     C                   PARM                    PFuncKey
     C                   PARM                    ArAcctDetExOut
     C                   PARM                    ArAcctDetAmOut
 
     C                   EVAL      DDPGMQ = '*'
     C                   EVAL      DDUSER = PSUser
     C                   EVAL      DDWID = PSJobName
     C                   EVAL      *IN46 = *ON                                              MD043079
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF
 
     C     KRGACKY       KLIST
     C                   KFLD                    KMsgRID
     C                   KFLD                    KTopElm
 
     C     KAcctN2       KLIST
     C                   KFLD                    KMsgRID
     C                   KFLD                    WxACNO
     C                   KFLD                    WxCNNH
     C                   KFLD                    WxMTYP
     C                   KFLD                    KTopElm
     C
     C     KAcctNo       KLIST
     C                   KFLD                    KMsgRID
     C                   KFLD                    WxACNO
     C                   KFLD                    WxCNNH
     C                   KFLD                    WxMTYP
     C                   KFLD                    KTopElm
     C                   KFLD                    KSeqNo2
 
     C     KAcctMI       KLIST
     C                   KFLD                    MxIEMSID
     C                   KFLD                    MxIEINEX
     C                   KFLD                    MxIECREF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
