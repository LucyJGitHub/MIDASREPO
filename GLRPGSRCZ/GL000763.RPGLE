     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL List of Reporting Group / Account Report')    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000763 - Midas GL List of Reporting Group / Account Report *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD054940           Date 13Feb20               *
      *  Prev Amend No. MD054905           Date 04Dec19               *
      *                 MD051055           Date 31Aug16               *
      *                 MD040953           Date 31Aug16               *
      *                 MD040841           Date 26Aug16               *
      *                 MD040832           Date 26Aug16               *
      *                 CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054940 - CRS Issue: Controlling Person Type                *
      *  MD054905 - Change Message Ref Id format                      *
      *  MD051055 - Incorrect report when multiple account selected   *
      *  MD040953 - Same accounts excluded twice produced 2 same      *
      *             entries in the generated Draft Delete report      *
      *  MD040841 - CRS Reports Screenflow for Actions Exclude, Cor-  *
      *             rect and Include should be adjusted               *
      *  MD040832 - Database Error encountered when pressing Enter    *
      *             from empty Account Report.                        *
      *  CGL177 - CRS Reporting Phase 2                               *
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
     FGL000763DFCF   E             WORKSTN SFILE(GL000763S1:WxSFRN)
     F                                     SFILE(GL000763S2:WySFRN)
     F                                     SFILE(GL000763S3:WzSFRN)
     F                                     SFILE(GL000763S4:WvSFRN)
     F                                     SFILE(GL000763S6:WwSFRN)
     F                                     INFDS(Infds)

      ** Midas GL Reports Management - Account Report
     FGLCRMDL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCRMDD0:GLCRMD02)
     FGLCRMDL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCRMDD0:GLCRMD03)
     FGLCRMDL8  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCRMDD0:GLCRMD08)
     FGLCRMDLB  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCRMDD0:GLCRMD0B)
     FGLCRMDLD  IF   E           K DISK    INFSR(*PSSR)                                     MD054940
     F                                     RENAME(GLCRMDD0:GLCRMD0D)                        MD054940

      ** Midas GL Excluded Account Records File
     FGLCRMIL1  IF   E           K DISK    INFSR(*PSSR)

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

      ** Second DS for access programs, long data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)

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
     D  AmCorr                       36A   OVERLAY(ArAcctDetAm:1)                           MD051055

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

     D WxSFRN          S              5  0
     D WySFRN          S              5  0
     D WzSFRN          S              5  0
     D WvSFRN          S              5  0
     D WwSFRN          S              5  0
     D CtrNum          S              5  0
     D TINNum          S              5  0
     D CtryNo          S              5  0
     D CtryPr          S              5  0
     D CtrLen          S              5  0 INZ(2)
     D TINLen          S              5  0 INZ(25)
     D WrCTRY          S             60A
     D WrFlag          S              1A
     D WsCTRY          S              2A
     D WsTNIB          S              2A
     D WsTINN          S             25A
     D CtrNum2         S              5  0
     D TINNum2         S              5  0
     D WsResEqTIB      S              1A
     D WTN             S              4  0

     D***KMsgRID         S             21A                                                  MD054905
     D KMsgRID         S             29A                                                    MD054905
     D KTopElm         S             40A
     D KTopElmName     S             40A
     D KMGSEQU         S              5  0
     D KTopElmN4       S             40A                                                    MD054940
     D WMGSEQU         S              5  0                                                  MD054940

     D OIx             S              2S 0 INZ(0)
     D AIx             S              2S 0 INZ(0)
     D OIw             S              2S 0 INZ(0)                                           MD040953
     D AIw             S              2S 0 INZ(0)                                           MD040953
     D WLeaveExit      S              1A
     D WError          S              1A   INZ('N')
     D WxCNNH          S             10A
     D WxMTYP          S             04A
     D WxRPTN          S             20A
     D WxACHT          S              8A
     D WxACNO          S             26A
     D WxDRID          S             33A
     D WxCRID          S             30A
     D WxCOPR          S             10A
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
     D WcFound         S              1A
     D WSSeqNo         S                   LIKE(MGSEQU)
     D KSeqNo          S                   LIKE(MGSEQU)
     D TxCNNH          S             10A
     D WsANEnd         S              1A
     D WkSelect        S             36A                                                    MD051055

      ** Parameter  entry
     D PActionCode     S              1A
     D***PMsgRId         S             21A                                                  MD054905
     D PMsgRId         S             29A                                                    MD054905
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
     D***MxIEMSID        S             21A                                                  MD054905
     D MxIEMSID        S             29A                                                    MD054905
     D MxIEINEX        S              1A
     D MxIECREF        S             10A
     D WStr            S              3P 0 INZ(1)                                           MD040841
     D WReturn         S              1A   INZ('N')                                         MD040841

     D WIdx            S              3P 0

     D WxDCOT          S             80A
     D WxDTIN          S            800A
     D WxDTIB          S             80A
     D WcDCOT          S             80A
     D WcDTIN          S            800A
     D WcDTIB          S             80A

      ** Work DS for Tax Identification Numbers
     DMGDataTIN        DS           200
     D WxMGTIN1                1     25
     D WxMGTIN2               26     50
     D WxMGTIN3               51     75
     D WxMGTIN4               76    100
     D WxMGTIN5              101    125
     D WxMGTIN6              126    150
     D WxMGTIN7              151    175
     D WxMGTIN8              176    200

      ** Work DS for TIN Issuing Country
     DMGDataCOT        DS            16
     D WxMGCOT1                1      2
     D WxMGCOT2                3      4
     D WxMGCOT3                5      6
     D WxMGCOT4                7      8
     D WxMGCOT5                9     10
     D WxMGCOT6               11     12
     D WxMGCOT7               13     14
     D WxMGCOT8               15     16

     DWkDataTIN        DS
     D WkMGTIN                       25    DIM(5)
     DWkDataCOT        DS
     D WkMGCOT                        2    DIM(5)

     DInfds            DS
     D Cmd_Key               369    369
     D  Cmd_Enter      C                   Const(x'F1')
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

     C                   IF        PActionCode = 'C'
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
     C                   WRITE     GL000763F1
     C                   EXFMT     GL000763C1

     C                   ENDIF

      ** IF F5 - Refresh was done

     C                   IF        *IN05 = *ON
     C                   EXSR      SrRGAF5
     C                   ENDIF

      ** Read Action on Account Report Main Screen Subfile

     C                   IF        WxSFRN <> 0
     C                   READC     GL000763S1
     C                   ENDIF

      ** IF F3, F12, F21 and F22 was pressed

     C                   IF        *IN03 = *ON OR *IN16 = *ON OR
     C                             *IN22 = *ON
     C                   EXSR      SrRGNFK
     C                   LEAVESR
     C                   ENDIF

      ** IF F5 - Refresh was done

     C                   IF        *IN05 = *ON
     C                   EXSR      SrRGAF5
     C                   ENDIF

      ** Perform only if records are existing                                               MD040832
      *                                                                                     MD040832
     C                   IF        WxSFRN <> 0                                              MD040832
      *                                                                                     MD040832
      ** Read input until end of file reached

     C                   DOW       NOT %EOF

     C                   EVAL      WIdx = *ZEROS

      ** Check if enter key is pressed without selection

      ** Invalid Action Code (Only '1' for Selection Allowed)

     C                   IF        DDACTN <> '1'
     C                   EVAL      PMsgId = 'USR9358'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF

     C                   IF        WIdx > *ZEROS
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN33 = *ON
     C                   EVAL      DDSFRN = WxSFRN
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN46 = *ON
     C                   WRITE     GL000763C0

     C                   ELSE
     C                   CALL      'ZA0250'
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN41 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN46 = *ON
     C                   WRITE     GL000763C0
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      WError = 'N'
     C                   ENDIF

     C                   EVAL      *IN34 = *ON
     C                   UPDATE    GL000763S1
     C                   READC     GL000763S1

     C                   ENDDO
      *
     C                   ENDIF                                                              MD040832

     C                   EVAL      *IN34 = *OFF

      ** If Error, stop processing further

     C                   IF        (WError = 'Y')
     C                             OR (WxSFRN = *ZEROS)
     C                   LEAVESR
     C                   ENDIF

      ** If action code / option is '1' call detail processing

     C                   READC     GL000763S1

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
     C                             PActionCode = 'C'
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
     C                   UPDATE    GL000763S1
     C                   ENDIF

     C                   READC     GL000763S1
     C                   ENDDO

      ** Navigation for Functions Keys

     C                   EXSR      SrRGNFK

     C                   IF        PActionCode = 'O'
     C                   MOVEA     ArAcctDetEx   ArAcctDetExOut
     C                   ENDIF

     C                   IF        PActionCode = 'C'
     C                   MOVEA     ArAcctDetAm   ArAcctDetAmOut
     C                   ENDIF

     C                   IF        *INKC = *ON
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
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN46 = *ON
     C                   WRITE     GL000763C0
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
     C                   EVAL      WStr = %LOOKUP(MxCUST:ExCNNH)                            MD040953
     C                   IF        WStr <> 0                                                MD040953
     C                   EVAL      OIw = WStr                                               MD040953
     C                   ELSEIF    WStr = 0                                                 MD040953
     C                   EVAL      OIx = OIx + 1
     C                   EVAL      OIw = OIx                                                MD040953
     C                   ENDIF                                                              MD040953
     C                   EVAL      ExCNNH(OIw) = MxCUST                                     MD040953
     C                   EVAL      ExMemb(OIw) = DDCNNH                                     MD040953
     C                   EVAL      ExMTyp(OIw) = MxType                                     MD040953
     C                   EVAL      ExMERM(OIw) = D2MER1 + D2MER2 +                          MD040953
     C                             D2MER3 + D2MER4                                          MD040953
     C**********         EVAL      ExCNNH(OIx) = MxCUST                                     MD040953
     C**********         EVAL      ExMemb(OIx) = DDCNNH                                     MD040953
     C**********         EVAL      ExMTyp(OIx) = MxType                                     MD040953
     C**********         EVAL      ExMERM(OIx) = D2MER1 + D2MER2 +                          MD040953
     C**********                   D2MER3 + D2MER4                                          MD040953
     C                   ENDIF

      ** Process the Record Selected for Amend/Correct Array
     C                   IF        PActionCode = 'C'
     C**********         EVAL      WStr = %LOOKUP(MxCUST:AmCNNH)                   MD040953 MD051055
     C                   EVAL      WkSelect = MxCUST + DDACNO                               MD051055
     C                   EVAL      WStr = %LOOKUP(WKSelect:AmCorr)                          MD051055
     C                   IF        WStr <> 0                                                MD040953
     C                   EVAL      AIw = WStr                                               MD040953
     C                   ELSEIF    WStr = 0                                                 MD040953
     C                   EVAL      AIx = AIx + 1
     C                   EVAL      AIw = AIx                                                MD040953
     C                   ENDIF                                                              MD040953
     C                   EVAL      AmCNNH(AIw) = MxCUST                                     MD040953
     C                   EVAL      AmACHO(AIw) = DDCNNH                                     MD040953
     C                   EVAL      AmMTyp(AIw) = MxType                                     MD040953
     C                   EVAL      AmACNO(AIw) = DDACNO                                     MD040953
     C                   EVAL      AmDRID(AIw) = DDDRID                                     MD040953
     C**********         EVAL      AmCNNH(AIx) = MxCUST                                     MD040953
     C**********         EVAL      AmACHO(AIx) = DDCNNH                                     MD040953
     C**********         EVAL      AmMTyp(AIx) = MxType                                     MD040953
     C**********         EVAL      AmACNO(AIx) = DDACNO                                     MD040953
     C**********         EVAL      AmDRID(AIx) = DDDRID                                     MD040953
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
     C                   WRITE     GL000763F2

      ** Reporting Group - Account Report - List of Country Subfile

     C                   EXSR      SrRGACS

      ** Reporting Group - Exclude 1=Select Footer
     C                   IF        PActionCode = 'O'
     C                   WRITE     GL000763C5
     C                   ELSE
     C                   WRITE     GL000763F8
     C                   ENDIF

     C                   EXFMT     GL000763F0

     C                   IF        *IN03 = *ON OR *IN12 = *ON

     C                   SELECT

     C                   WHEN      *IN03 = *ON
     C                   EVAL      PFuncKey = 'F3 '
     C                   EVAL      WLeaveExit = 'Y'
     C                   WHEN      *IN12 = *ON
     C                   EVAL      PFuncKey = 'F12'
     C                   ENDSL

     C                   LEAVESR
     C                   ENDIF

      ** Reporting Group - Account Report - Exclude Country Processing

     C                   IF        PActionCode = 'O'

     C                   EVAL      CtryPr = 0
     C                   EVAL      WrFlag = 'N'
     C                   EVAL      WrCTRY = *BLANKS

     C                   READC     GL000763S4
     C                   DOW       NOT %EOF

     C                   READC     GL000763S4
     C                   ENDDO

     C                   IF        CtryPr = CtryNo
     C                   EVAL      WrFlag = 'Y'
     C                   ELSE
     C                   EVAL      WrFlag = 'N'
     C                   ENDIF

     C                   ENDIF

      ** Reporting Group - Account Report - Exclude Remarks Input Screen

     C                   IF        PActionCode = 'O'
     C                   WRITE     GL000763F2
     C***                EVAL      D2MER1 = *BLANKS                                         MD040841
     C***                EVAL      D2MER2 = *BLANKS                                         MD040841
     C***                EVAL      D2MER3 = *BLANKS                                         MD040841
     C***                EVAL      D2MER4 = *BLANKS                                         MD040841
     C                   EVAL      WStr = %LOOKUP(WXCNNH:ExCNNH)                            MD040841
     C                   IF        WStr <> 0                                                MD040841
     C                   EVAL      D2MER1 = %SUBST(ExMERM(WStr):1:64)                       MD040841
     C                   EVAL      D2MER2 = %SUBST(ExMERM(WStr):65:64)                      MD040841
     C                   EVAL      D2MER3 = %SUBST(ExMERM(WStr):129:64)                     MD040841
     C                   EVAL      D2MER4 = %SUBST(ExMERM(WStr):193:64)                     MD040841
                                                                                            MD040841
     C                   EVAL      PMsgId = 'USS0692'                                       MD040841
     C                   EXSR      SRErrDta                                                 MD040841
     C                   WRITE     GL000763F4                                               MD040841
     C                   EVAL      *IN40 = *ON                                              MD040841
     C                   WRITE     GL000763C0                                               MD040841
     C                   EVAL      *IN40 = *OFF                                             MD040841
                                                                                            MD040841
     C                   ELSE                                                               MD040841
     C                   EVAL      D2MER1 = *BLANKS                                         MD040841
     C                   EVAL      D2MER2 = *BLANKS                                         MD040841
     C                   EVAL      D2MER3 = *BLANKS                                         MD040841
     C                   EVAL      D2MER4 = *BLANKS                                         MD040841
     C                   ENDIF                                                              MD040841
                                                                                            MD040841
     C     RGEXC         TAG                                                                MD040841
                                                                                            MD040841
     C                   DOU       *IN42 = *OFF
     C                   EXFMT     GL000763F4

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
     C                   WRITE     GL000763F4
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      *IN40 = *ON
     C                   WRITE     GL000763C0
     C                   EVAL      *IN40 = *OFF

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
     C                   IF        PActionCode <> 'O'                                       MD040841
     C                   GOTO      RGAHD
     C                   ELSE                                                               MD040841
     C                   GOTO      RGEXC                                                    MD040841
     C                   ENDIF                                                              MD040841
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
     C                   IF        WReturn = 'N'                                            MD040841
     C                   GOTO      RGASO
     C                   ELSEIF    WReturn = 'Y'                                            MD040841
     C                   GOTO      RTURN                                                    MD040841
     C                   ENDIF                                                              MD040841
     C                   ENDSL

     C                   ENDIF

     C     RTURN         TAG                                                                MD040841
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
     C                   WRITE     GL000763C1
     C                   EVAL      *IN95 = *OFF

     C     PMsgRId       SETLL     GLCRMDL2
     C     PMsgRId       READE     GLCRMDL2
     C                   DOW       NOT %EOF(GLCRMDL2)
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

     C                   WHEN      MGELMT = 'AccountHolder'
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
     C                   WRITE     GL000763S1

     C                   ENDSL

     C                   READ      GLCRMDL2

     C                   ENDDO

     C                   IF        WxSFRN <> 0
     C                   EVAL      *IN97 = *ON
     C                   ELSE
     C                   EVAL      PMsgId = 'USR7530'
     C                   EXSR      SRErrDta
     C                   EVAL      *IN40 = *ON
     C                   WRITE     GL000763C0
     C                   EVAL      *IN40 = *OFF
     C                   ENDIF

      ** Display Account Report Main Screen

     C                   EVAL      DDSFRN = 1
     C                   EVAL      *IN96 = *ON
     C                   WRITE     GL000763F1
     C                   EXFMT     GL000763C1

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
     C                   EVAL      WxDCOT = *BLANKS
     C                   EVAL      WxDTIN = *BLANKS
     C                   EVAL      WxDTIB = *BLANKS
     C                   EVAL      WTN = *ZEROS

      ** Reset screen fields per Account Holder
     C                   EVAL      D2BRTD = *BLANKS
     C                   EVAL      D2ABCC = *BLANKS
     C                   EVAL      D2ACBL = *BLANKS
     C                   EVAL      D2COCO = *BLANKS
     C                   EVAL      D2CITY = *BLANKS

     C     KAcctNo       SETLL     GLCRMDL8
     C                   READ      GLCRMDL8
     C                   DOW       NOT %EOF(GLCRMDL8)
     C                             AND PMsgRId = MGMSID
     C                             AND WxACNO = MGACNO
     C                             AND WxCNNH = MGACHO
     C                             AND WxMTYP = MGMTYP

     C                   SELECT

     C                   WHEN      MGELMT = 'CorrDocRefId'
     C                             AND MGTPMT = 'AccountReport'
     C                   EVAL      D2CRID = MGDATA

     C                   WHEN      MGELMT = 'AccountHolder'
     C                             AND (MGTPMT = 'Individual' OR
     C                                  MGTPMT = 'Organisation')
     C                   EVAL      TxCNNH = MGDATA
     C                   EVAL      MxType = MGDAT2
     C                   EVAL      WMGSEQU = MGSEQU                                         MD054940

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
     C                   EVAL      WMGSEQU = MGSEQU                                         MD054940

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

     C                   WHEN      MGELMT = 'AccountNumber(DormantAccount)' AND
     C                             MGTPMT = 'AccountReport'
     C                   IF        MGDATA = *BLANKS
     C                   EVAL      D2DMAC = 'N'
     C                   ELSE
     C                   EVAL      D2DMAC = 'Y'
     C                   ENDIF

     C                   WHEN      MGELMT = 'FirstName' AND
     C                             WMGSEQU = MGSEQU AND                                     MD054940
     C                             MGTPMT = 'Individual' OR
     C                             MGELMT = 'FirstName' AND
     C                             MGTPMT = 'Name'
     C                   EVAL      D2FNME = MGDATA

     C                   WHEN      MGELMT = 'LastName' AND
     C                             WMGSEQU = MGSEQU AND                                     MD054940
     C                             MGTPMT = 'Individual' OR
     C                             MGELMT = 'LastName' AND
     C                             MGTPMT = 'Name'
     C                   EVAL      D2LNME = MGDATA

     C                   WHEN      MGELMT = 'Name' AND
     C                             MGTPMT = 'Organisation'
     C                   EVAL      D2FNME = MGDATA
     C                   EVAL      D2LNME = *BLANKS

     C                   WHEN      MGELMT = 'AddressFree' AND
     C                             MGTPMT = 'Organisation' OR
     C                             MGELMT = 'AddressFree' AND
     C                             MGTPMT = 'Individual'
     C                             AND WMGSEQU = MGSEQU                                     MD054940
     C                   EVAL      FinalAddress = %TRIM(MGDATA)
     C                   EVAL      WSlash = %SCAN('/':FinalAddress)
     C                   EVAL      WSlash = WSlash + 1
     C                   EVAL      WTrim = %SCAN('/':FinalAddress:WSlash)
     C                   EVAL      D2ADD1 = %SUBST(FinalAddress:1:WTrim)
     C                   EVAL      D2ADD1 = %TRIM(D2ADD1)
     C                   EVAL      WTrim = WTrim + 1
     C                   EVAL      D2ADD2 = %SUBST(FinalAddress:WTrim:60)
     C                   EVAL      D2ADD2 = %TRIM(D2ADD2)
     C                   IF        MGTPMT = 'Organisation'
     C                   EVAL      D2BRTD = *BLANKS
     C                   EVAL      D2CITY = *BLANKS
     C                   EVAL      D2COCO = *BLANKS
     C                   ENDIF

     C                   WHEN      MGELMT = 'ResCountryCode' AND
     C                             MGTPMT = 'Organisation' OR
     C                             MGELMT = 'ResCountryCode' AND
     C                             MGTPMT = 'Individual'
     C                             AND WMGSEQU = MGSEQU                                     MD054940
     C                   IF        WxDCOT = *BLANKS
     C                   EVAL      WxDCOT = %TRIM(MGDATA) + WxDCOT
     C                   ELSE
     C                   EVAL      WxDCOT = %TRIM(WxDCOT) + %TRIM(MGDATA)
     C                   ENDIF

     C                   WHEN      MGELMT = 'IN' AND
     C                             MGTPMT = 'Organisation' OR
     C                             MGELMT = 'TIN' AND
     C                             MGTPMT = 'Individual'
     C                             AND WMGSEQU = MGSEQU                                     MD054940
     C                   IF        WxDTIN = *BLANKS
     C                   EVAL      WTN = *ZEROS
     C                   EVAL      WTN = WTN + 200
     C                   EVAL      WxDTIN = %TRIM(MGDATA) + WxDTIN
     C                   EVAL      WxDTIB = %TRIM(MGDAT2) + WxDTIB
     C                   ELSE
     C                   EVAL      WxDTIN = %SUBST(WxDTIN:1:WTN) + %TRIM(MGDATA)
     C                   EVAL      WxDTIB = %TRIM(WxDTIB) + %TRIM(MGDAT2)
     C                   EVAL      WTN = WTN + 200
     C                   ENDIF

     C                   WHEN      MGELMT = 'BirthDate' AND
     C                             MGTPMT = 'Individual'
     C                             AND WMGSEQU = MGSEQU                                     MD054940
     C                   EVAL      D2BRTD = %SUBST(MGDATA:1:4)
     C                                      + '-' + %SUBST(MGDATA:5:2)
     C                                      + '-' + %SUBST(MGDATA:7:2)

     C                   WHEN      MGELMT = 'City' AND
     C                             MGTPMT = 'Individual'
     C                             AND WMGSEQU = MGSEQU                                     MD054940
     C                   EVAL      D2CITY = MGDATA

     C                   WHEN      MGELMT = 'CountryCode' AND
     C                             MGTPMT = 'CountryInfo'
     C                   EVAL      D2COCO = MGDATA

     C                   ENDSL

     C                   READ      GLCRMDL8

     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRGACS - Account Report - Country List Subfile               *
      *                                                               *
      *****************************************************************

     C     SrRGACS       BEGSR

     C                   EVAL      WsCTRY = *BLANKS
     C                   EVAL      CtrNum = 1
     C                   EVAL      TINNum = 1
     C                   EVAL      CtryNo = 0
     C                   EVAL      WvSFRN = *ZEROS
     C                   EVAL      D0SFRN = *ZEROS
     C                   EVAL      WsFound = 'Y'
     C                   EVAL      *IN97 = *OFF
     C                   EVAL      *IN96 = *OFF

     C                   IF        PActionCode = 'O'
     C                   EVAL      *IN43 = *ON
     C                   ELSE
     C                   EVAL      *IN43 = *OFF
     C                   ENDIF

     C                   EVAL      *IN95 = *ON
     C                   WRITE     GL000763F0
     C                   EVAL      *IN95 = *OFF

     C                   DOW       WsFound = 'Y'

      ** Check if WxDCOT has a ResCountryCode values
     C                   EVAL      WsCTRY=%TRIM(%SUBST(WxDCOT:CtrNum:CtrLen))
     C                   EVAL      D2CTRY = WsCTRY

     C                   IF        WsCTRY <> *BLANKS

     C                   EVAL      CtrNum2 = 1
     C                   EVAL      TINNum2 = 1
     C                   EVAL      WsTNIB = *BLANKS
     C                   EVAL      WsResEqTIB = 'N'

      ** If there's a ResCountryCode, loop and find the TIN/TIN Issued By Combo
     C                   DOW       WsResEqTIB = 'N'

     C                   EVAL      WsTNIB=%TRIM(%SUBST(WxDTIB:CtrNum2:CtrLen))

     C                   IF        WsCTRY = WsTNIB
     C                             OR WsTNIB = *BLANKS

      ** If the ResCountryCode = TIN Issued By, get the TIN and prep for write
     C                   EVAL      WsTINN=%TRIM(%SUBST(WxDTIN:TINNum2:TINLen))
     C                   EVAL      WsResEqTIB = 'Y'
     C                   EVAL      D2TINN = WsTINN
     C                   EVAL      D2TNIB = WsTNIB

     C                   ENDIF                                                              MD054940
     C**********         ELSE                                                               MD054940
     C                   EVAL      CtrNum2 = CtrNum2 + 2
     C                   EVAL      TINNum2 = TINNum2 + 25
     C
     C**********         ENDIF                                                              MD054940

     C                   ENDDO

     C                   ENDIF

     C                   IF        D2CTRY = *BLANKS
     C                   EVAL      WsFound = 'N'
     C                   ENDIF

     C                   EVAL      CtrNum = CtrNum + 2
     C                   EVAL      TINNum = TINNum + 25

     C                   IF        WsFound = 'Y'
     C                   EVAL      CtryNo = CtryNo + 1
     C                   EVAL      WvSFRN = WvSFRN + 1
     C                   EVAL      D0SFRN = 1
     C                   WRITE     GL000763S4
     C                   ENDIF

     C                   ENDDO

     C                   IF        WvSFRN <> 0
     C                   EVAL      *IN97 = *ON
     C                   ENDIF

     C                   EVAL      *IN96 = *ON


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
     C                   EVAL      KMsgRID = PMsgRId
     C                   EVAL      KTopElm = 'Payment'

     C                   EVAL      *IN95 = *ON
     C                   WRITE     GL000763C2
     C                   EVAL      *IN95 = *OFF

     C     KAcctN2       SETLL     GLCRMDLB
     C                   READ      GLCRMDLB
     C                   DOW       NOT %EOF(GLCRMDLB)
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
     C                   WRITE     GL000763S2
     C                   ENDIF

     C                   SELECT

     C                   WHEN      MGELMT = 'AccountHolder'
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

     C                   READ      GLCRMDLB

     C                   ENDDO

     C                   IF        WsFound = 'Y'
     C                   EVAL      WySFRN = WySFRN + 1
     C                   EVAL      D2SFRN = WySFRN
     C                   WRITE     GL000763S2
     C                   ENDIF

     C                   IF        WySFRN = 0
     C                   EVAL      D3PAYT = *BLANKS
     C                   EVAL      D3PACC = *BLANKS
     C                   EVAL      D3PSTA = *BLANKS
     C                   EVAL      *IN97 = *ON
     C                   EVAL      WySFRN = WySFRN + 1
     C                   EVAL      D2SFRN = WySFRN
     C                   WRITE     GL000763S2
     C                   EVAL      WySFRN = *ZEROS
     C                   ENDIF

     C                   IF        WySFRN <> 0
     C                   EVAL      *IN97 = *ON
     C                   ENDIF

     C     SRABScr       TAG
     C                   EVAL      *IN03 = *OFF
     C                   EVAL      *IN12 = *OFF
     C                   EVAL      *IN96 = *ON
     C                   WRITE     GL000763F2
     C                   EVAL      *IN90 = *OFF
     C                   EXFMT     GL000763C2

     C                   IF        *IN12 = *ON                                              MD040841
     C                   MOVE      'N'           WReturn                                    MD040841
     C                   GOTO      SRABRtn                                                  MD040841
     C                   ENDIF                                                              MD040841
                                                                                            MD040841
     C                   EVAL      *IN51 = *OFF                                             MD040841
     C                   EVAL      *IN52 = *OFF                                             MD040841
     C                   EVAL      *IN53 = *OFF                                             MD040841
     C                   IF        *IN03 <> *ON AND
     C                             *IN12 <> *ON
     C                   EVAL      *IN96 = *ON
     C                   IF        PActionCode = 'O' OR
     C                             PActionCode = 'C'
     C                   IF        PActionCode = 'O'                                        MD040841
     C                   EVAL      *IN51 = *ON                                              MD040841
     C                   ENDIF                                                              MD040841
     C                   IF        PActionCode = 'I'                                        MD040841
     C                   EVAL      *IN52 = *ON                                              MD040841
     C                   ENDIF                                                              MD040841
     C                   IF        PActionCode = 'C'                                        MD040841
     C                   EVAL      *IN53 = *ON                                              MD040841
     C                   ENDIF                                                              MD040841
     C                   WRITE     GL000763F3
     C                   EVAL      *IN90 = *ON
     C                   EXFMT     GL000763C2
     C                   ENDIF

     C                   MOVE      'N'           WReturn                                    MD040841
     C                   IF        *IN12 = *ON
     C**********         GOTO      SRABScr                                                  MD040841
     C                   EVAL      WReturn = 'Y'                                            MD040841
     C                   EVAL      *IN53 = *ON                                              MD040841
     C                   ENDIF
     C                   ENDIF
     C     SRABRtn       TAG                                                                MD040841

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

     C     KAcctMI       CHAIN     GLCRMIL1

     C                   IF        %FOUND(GLCRMIL1)

     C                   EVAL      MxScrDsp = 'Y'
     C                   EVAL      D2MIR1 = %SUBST(IERMRK:1:64)
     C                   EVAL      D2MIR2 = %SUBST(IERMRK:65:64)
     C                   EVAL      D2MIR3 = %SUBST(IERMRK:129:64)
     C                   EVAL      D2MIR4 = %SUBST(IERMRK:193:64)
     C                   EVAL      D2USER = IEUSER
     C                   EVAL      D2TMST = IETMST

     C                   EXFMT     GL000763F5

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

     C     RGACP         TAG
     C                   EVAL      WzSFRN = *ZEROS
     C                   EVAL      D4SFRN = *ZEROS
     C                   EVAL      DsAcStr = *BLANKS
     C                   EVAL      WsSeq2 = 1
     C                   EVAL      WsFound = 'N'
     C                   EVAL      WcFound = 'N'
     C                   EVAL      WsSeqNo = 1001
     C                   EVAL      *IN97 = *OFF
     C                   EVAL      *IN96 = *OFF
     C                   EVAL      KMsgRID = PMsgRId
     C                   EVAL      KTopElm = 'ControllingPerson'
     C                   EVAL      KSeqNo2 = WsSeqNo
     C                   EVAL      D5ACTN = *BLANKS

     C                   EVAL      *IN95 = *ON
     C                   WRITE     GL000763C3
     C                   EVAL      *IN95 = *OFF

     C     KAcctNo       SETLL     GLCRMDL8
     C                   READ      GLCRMDL8
     C                   DOW       NOT %EOF(GLCRMDL8)
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
     C                   WRITE     GL000763S3
     C                   ENDIF

     C                   SELECT

     C                   WHEN      MGELMT = 'AccountNumber'
     C                   EVAL      D5ACNO = MGDATA
     C                   EVAL      DsAcno = WxACNO
     C                   EVAL      DsAcEnd = %TRIM(MGDATA)
     C                   EVAL      DsDataKey = %TRIM(MGDATA)

     C                   WHEN      MGELMT = 'CtrlgPersonType'                               MD054940
     C                   EVAL      D5CTYP = MGDATA                                          MD054940
                                                                                            MD054940
     C                   WHEN      MGELMT = 'ControllingPerson'
     C                   EVAL      D5COPR = MGDATA

     C                   WHEN      MGELMT = 'Individual'                                    MD054940
     C                   EVAL      KTopElmN4 = 'Individual'                                 MD054940
     C                   EVAL      KMGSEQU = MGSEQU                                         MD054940
                                                                                            MD054940
     C     KAcctN4       SETLL     GLCRMDLD                                                 MD054940
     C     KAcctN4       READE     GLCRMDLD                                                 MD054940
     C                   DOW       NOT %EOF(GLCRMDLD)                                       MD054940
     C                   IF        MGELMT = 'AddressFree'                                   MD054940
     C                   EVAL      FinalAddress = %TRIM(MGDATA)                             MD054940
     C                   EVAL      D5ADD1 = FinalAddress                                    MD054940
     C                   ENDIF                                                              MD054940
     C                   IF        MGELMT = 'BirthDate'                                     MD054940
     C                   EVAL      D5BRTD = %SUBST(MGDATA:1:4)                              MD054940
     C                                      + '-' + %SUBST(MGDATA:5:2)                      MD054940
     C                                      + '-' + %SUBST(MGDATA:7:2)                      MD054940
     C                   ENDIF                                                              MD054940
                                                                                            MD054940
     C                   IF        MGELMT = 'City'                                          MD054940
     C                   EVAL      D5CITY = MGDATA                                          MD054940
     C                   ENDIF                                                              MD054940
     C**********         WHEN      MGELMT = 'Name'                                          MD054940
     C                   IF        MGELMT = 'Name'                                          MD054940
     C                             AND MGSEQU = KMGSEQU                                     MD054940
     C                   EVAL      D5FNME = MGDATA
     C                   EVAL      KTopElmName = 'Name'
     C                   EVAL      KMGSEQU = MGSEQU
     C                   EVAL      D5FNME = *BLANKS
     C                   EVAL      D5LNME = *BLANKS

     C     KAcctN3       SETLL     GLCRMDLB
     C                   READ      GLCRMDLB
     C                   DOW       NOT %EOF(GLCRMDLB)
     C                   IF        MGELMT = 'FirstName'
     C                             AND MGSEQU = KMGSEQU
     C                   EVAL      D5FNME = MGDATA
     C                   ENDIF

     C                   IF        MGELMT = 'LastName'
     C                             AND MGSEQU = KMGSEQU
     C                   EVAL      D5LNME = MGDATA
     C                   LEAVE
     C                   ENDIF

     C                   READ      GLCRMDLB

     C                   ENDDO
     C                   ENDIF                                                              MD054940
     C**********         WHEN      MGELMT = 'AddressFree'                                   MD054940
     C**********         EVAL      FinalAddress = %TRIM(MGDATA)                             MD054940
     C**********         EVAL      D5ADD1 = FinalAddress                                    MD054940
      **********                                                                            MD054940
     C**********         WHEN      MGELMT = 'BirthDate'                                     MD054940
     C**********         EVAL      D5BRTD = %SUBST(MGDATA:1:4)                              MD054940
     C**********                            + '-' + %SUBST(MGDATA:5:2)                      MD054940
     C**********                            + '-' + %SUBST(MGDATA:7:2)                      MD054940
      **********                                                                            MD054940
     C**********         WHEN      MGELMT = 'City'                                          MD054940
     C**********         EVAL      D5CITY = MGDATA                                          MD054940
                                                                                            MD054940
     C**********         WHEN      MGELMT = 'CountryCode'                                   MD054940
     C                   IF        MGELMT = 'CountryCode'                                   MD054940
     C                   EVAL      D5COCO = MGDATA
     C                   EVAL      KTopElmName = 'CountryInfo'
     C                   EVAL      KMGSEQU = MGSEQU

     C     KAcctN3       SETLL     GLCRMDLB
     C                   READ      GLCRMDLB
     C                   DOW       NOT %EOF(GLCRMDLB)
     C                   IF        MGELMT = 'CountryCode'
     C                             AND MGSEQU = KMGSEQU
     C                   EVAL      D5COCO = MGDATA
     C                   LEAVE
     C                   ENDIF

     C                   READ      GLCRMDLB

     C                   ENDDO
     C                   ENDIF                                                              MD054940
     C     KAcctN4       READE     GLCRMDLD                                                 MD054940
     C                   ENDDO                                                              MD054940

     C                   ENDSL

     C                   READ      GLCRMDL8

     C                   ENDDO

     C                   IF        WsFound = 'Y'
     C                   EVAL      WzSFRN = WzSFRN + 1
     C                   EVAL      D4SFRN = 1
     C                   EVAL      WcFound = 'Y'
     C                   WRITE     GL000763S3
     C                   ELSE
     C                   EVAL      WcFound = 'N'
     C                   WRITE     GL000763C4
     C                   ENDIF

     C                   IF        WzSFRN <> 0
     C                   EVAL      *IN97 = *ON
     C                   ENDIF

     C                   EVAL      *IN96 = *ON
     C                   WRITE     GL000763C4
     C                   WRITE     GL000763F6
     C                   EXFMT     GL000763C3

     C                   IF        WcFound = 'Y'
      ** Check if a Controlling Person record was selected
     C                   EVAL      *IN97 = *OFF
     C                   READC     GL000763S3
     C                   DOW       NOT %EOF

     C                   IF        D5ACTN = '1'
     C                   EXSR      SrRGACP
     C                   ENDIF

     C                   READC     GL000763S3
     C                   ENDDO

     C                   IF        *IN97 = *ON
     C                   WRITE     GL000763F7
     C                   EXFMT     GL000763C6

      ** Go back to Controlling Person initial screen
     C                   IF        *IN12 = *ON
     C                             OR Cmd_Key = Cmd_enter
     C                   GOTO      RGACP
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRGACP - Account Report - Country List - Controlling Persons *
      *                                                               *
      *****************************************************************

     C     SrRGACP       BEGSR

      ** Get the ResCountryCode, TIN and TIN Issued By per Controlling Person
     C                   EVAL      WcDCOT = *BLANKS
     C                   EVAL      WcDTIN = *BLANKS
     C                   EVAL      WcDTIB = *BLANKS
     C                   EVAL      WsSeq2 = 1
     C                   EVAL      WsSeqNo = 1001
     C                   EVAL      KMsgRID = PMsgRId
     C                   EVAL      KTopElm = 'ControllingPerson'
     C                   EVAL      KSeqNo2 = WsSeqNo


     C     KAcctNo       SETLL     GLCRMDL8
     C                   READ      GLCRMDL8
     C                   DOW       NOT %EOF(GLCRMDL8)
     C                             AND PMsgRId = MGMSID
     C                             AND WxACNO = MGACNO
     C                             AND KTopElm = MGTPMT
     C                             AND WxCNNH = MGACHO
     C                             AND WxMTYP = MGMTYP

     C                   SELECT

     C                   WHEN      MGELMT = 'ControllingPerson'
     C                   EVAL      WxCOPR = MGDATA
                                                                                            MD054940
     C                   WHEN      MGELMT = 'Individual'                                    MD054940
     C                             AND D5COPR = WxCOPR                                      MD054940
     C                   EVAL      KMGSEQU = MGSEQU                                         MD054940
     C                   EVAL      KTopElmN4 = 'Individual'                                 MD054940

     C     KAcctN4       SETLL     GLCRMDLD                                                 MD054940
     C     KAcctN4       READE     GLCRMDLD                                                 MD054940
     C                   DOW       NOT %EOF(GLCRMDLD)                                       MD054940
     C**********         WHEN      MGELMT = 'ResCountryCode'                                MD054940
     C                   IF        MGELMT = 'ResCountryCode'                                MD054940
     C                   IF        D5COPR = WxCOPR
     C                   IF        WcDCOT = *BLANKS
     C                   EVAL      WcDCOT = %TRIM(MGDATA) + WcDCOT
     C                   ELSE
     C                   EVAL      WcDCOT = %TRIM(WcDCOT) + %TRIM(MGDATA)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                              MD054940

     C**********         WHEN      MGELMT = 'TIN'                                           MD054940
     C                   IF        MGELMT = 'TIN'                                           MD054940
     C                             OR MGELMT = 'IN'
     C                   IF        D5COPR = WxCOPR
     C                   IF        WcDTIN = *BLANKS
     C                   EVAL      WTN = *ZEROS
     C                   EVAL      WTN = WTN + 200
     C                   EVAL      WcDTIN = %TRIM(MGDATA) + WcDTIN
     C                   EVAL      WcDTIB = %TRIM(MGDAT2) + WcDTIB
     C                   ELSE
     C                   EVAL      WcDTIN = %SUBST(WcDTIN:1:WTN) + %TRIM(MGDATA)
     C                   EVAL      WcDTIB = %TRIM(WcDTIB) + %TRIM(MGDAT2)
     C                   EVAL      WTN = WTN + 200
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                              MD054940

     C**********         WHEN      MGELMT = 'AddressFree'                                   MD054940
     C                   IF        MGELMT = 'AddressFree'                                   MD054940
     C                   EVAL      FinalAddress = %TRIM(MGDATA)
     C                   EVAL      FinalAddress = %TRIM(MGDATA)
     C                   EVAL      WSlash = %SCAN('/':FinalAddress)
     C                   EVAL      WSlash = WSlash + 1
     C                   EVAL      WTrim = %SCAN('/':FinalAddress:WSlash)
     C                   EVAL      D5ADC1 = %SUBST(FinalAddress:1:WTrim)
     C                   EVAL      D5ADC1 = %TRIM(D5ADC1)
     C                   EVAL      WTrim = WTrim + 1
     C                   EVAL      D5ADC2 = %SUBST(FinalAddress:WTrim:60)
     C                   EVAL      D5ADC2 = %TRIM(D5ADC2)
     C                   ENDIF                                                              MD054940

     C**********         WHEN      MGELMT = 'CountryInfo'                                   MD054940
     C                   IF        MGELMT = 'CountryInfo'                                   MD054940
     C                   IF        D5COPR = WxCOPR
     C                   GOTO      RGACPT
     C                   ENDIF
     C                   ENDIF                                                              MD054940

     C     KAcctN4       READE     GLCRMDLD                                                 MD054940
     C                   ENDDO                                                              MD054940
     C                   ENDSL

     C                   READ      GLCRMDL8

     C                   ENDDO

      ** Process the retrieved ResCountryCode, TIN and TIN Issued By
     C     RGACPT        TAG
     C                   EVAL      WsCTRY = *BLANKS
     C                   EVAL      CtrNum = 1
     C                   EVAL      TINNum = 1
     C                   EVAL      CtryNo = 0
     C                   EVAL      WwSFRN = *ZEROS
     C                   EVAL      D0SFRN = *ZEROS
     C                   EVAL      WsFound = 'Y'
     C                   EVAL      *IN97 = *OFF
     C                   EVAL      *IN96 = *OFF

     C                   EVAL      *IN95 = *ON
     C                   WRITE     GL000763C6
     C                   EVAL      *IN95 = *OFF

     C                   DOW       WsFound = 'Y'

      ** Check if WcDCOT has a ResCountryCode values
     C                   EVAL      WsCTRY=%TRIM(%SUBST(WcDCOT:CtrNum:CtrLen))
     C                   EVAL      D6CTRY = WsCTRY

     C                   IF        WsCTRY <> *BLANKS

     C                   EVAL      CtrNum2 = 1
     C                   EVAL      TINNum2 = 1
     C                   EVAL      WsTNIB = *BLANKS
     C                   EVAL      WsResEqTIB = 'N'

      ** If there's a ResCountryCode, loop and find the TIN/TIN Issued By Combo
     C                   DOW       WsResEqTIB = 'N'

     C                   EVAL      WsTNIB=%TRIM(%SUBST(WcDTIB:CtrNum2:CtrLen))

     C                   IF        WsCTRY = WsTNIB
     C                             OR WsTNIB = *BLANKS

      ** If the ResCountryCode = TIN Issued By, get the TIN and prep for write
     C                   EVAL      WsTINN=%TRIM(%SUBST(WcDTIN:TINNum2:TINLen))
     C                   EVAL      WsResEqTIB = 'Y'
     C                   EVAL      D6TINN = WsTINN
     C                   EVAL      D6TNIB = WsTNIB

     C                   ENDIF                                                              MD054940
     C**********         ELSE                                                               MD054940
     C                   EVAL      CtrNum2 = CtrNum2 + 2
     C                   EVAL      TINNum2 = TINNum2 + 25
     C
     C**********         ENDIF                                                              MD054940

     C                   ENDDO

     C                   ENDIF

     C                   IF        D6CTRY = *BLANKS
     C                   EVAL      WsFound = 'N'
     C                   ENDIF

     C                   EVAL      CtrNum = CtrNum + 2
     C                   EVAL      TINNum = TINNum + 25

     C                   IF        WsFound = 'Y'
     C                   EVAL      CtryNo = CtryNo + 1
     C                   EVAL      WwSFRN = WwSFRN + 1
     C                   EVAL      D0SFRN = 1
     C                   WRITE     GL000763S6
     C                   ENDIF

     C                   ENDDO

     C                   IF        WwSFRN <> 0
     C                   EVAL      *IN97 = *ON
     C                   ENDIF

     C                   EVAL      *IN96 = *ON

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
     C     SDNAHO        PARM      SDNAHO        DSLDY

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
     C     KAcctN3       KLIST
     C                   KFLD                    KMsgRID
     C                   KFLD                    WxACNO
     C                   KFLD                    WxCNNH
     C                   KFLD                    WxMTYP
     C                   KFLD                    KTopElmName
     C
     C     KAcctN4       KLIST                                                              MD054940
     C                   KFLD                    KMsgRID                                    MD054940
     C                   KFLD                    WxACNO                                     MD054940
     C                   KFLD                    WxCNNH                                     MD054940
     C                   KFLD                    WxMTYP                                     MD054940
     C                   KFLD                    KTopElmN4                                  MD054940
     C                   KFLD                    KMGSEQU                                    MD054940
     C                                                                                      MD054940
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
