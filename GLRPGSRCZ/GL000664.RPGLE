     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Reporting Group - Pool Report')               *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000664 - Midas GL Reporting Group - Pool Report            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD043973           Date 03Feb17               *
      *  Prev Amend No. MD043185           Date 19Dec16               *
      *                 MD043204           Date 16Dec16               *
      *                 CGL154  *CREATE    Date 13Oct14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD043973 - FATCA Account closed file entries are not         *
      *             transferred to FATCA EOY archive file (Recompile) *
      *  MD043185 - Pressing page down returns to previous screen     *
      *  MD043204 - Transactions/Accounts which do not belong to the  *
      *             branch of the generated FATCA Report are displayed*
      *             in pool report                                    *
      *  CGL154 - FATCA Reporting                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03 - Exit                                                  *
      *    05 - Refresh                                               *
      *    12 - Previous                                              *
      *    50 - Subfile display                                       *
      *    51 - Subfile Clear                                         *
      *    52 - Position Cursor (Report Name)                         *
      *    53 - Subfile attribute non-diplay/highlight                *
      *    54 - Position Cursor (Customer/Naho)                       *
      *    55 - Subfile End                                           *
      *    90 - Empty file indicator                                  *
      *    98 - Rollup Indicator                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR       - Initialise                                    *
      *  *PSSR        - Error processing                              *
      *  SrInitSF - Subroutine to initialize subfile for Pool List    *
      *  SrExtrac - This subroutine extract data from Value field of  *
      *             GLRMDTPD for list of customers and NAHO           *
      *  SrWritSf - Subroutine to build subfile pool list             *
      *  SrDspLst - Display the list of customers and NAHO            *
      *  SrListSC - This subroutine will scan message data if the     *
      *             search records has match/es                       *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas GL List of Cust/Naho Under Exception Management Subfile
     FGL000664DFCF   E             WORKSTN SFILE(GL000664S0:RrnCnt) INFDS(ScnDS)
     F                                     SFILE(GL000664S1:RelNCtr)
     F                                     SFILE(GL000664S2:MsRcnt)

      ** Midas GL Reports Management
     FGLRMDTL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas GL Reports Management
     FGLRMDTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLRMDTD0:GLRMDTD1)
      ** Midas GL Reports Management
     FGLRMDTL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLRMDTD0:GLRMDTD2)
      ** Midas GL FATCA Customer Activity/Payment Amounts by customer
     FGLCAPAL2  IF   E           K DISK    INFSR(*PSSR)

      ** Midas GL FATCA Customer Activity/Payment Amounts by customer
     FGLCSBAL1  IF   E           K DISK    INFSR(*PSSR)

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

      ** Local data area for database error details

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D Remarks1        C                   CONST('Remarks this customer is for')
     D Remarks2        C                   CONST(' pool type')
     D WMaxPos         C                   CONST(200)
     D MaxElmt         C                   CONST(2)
     D MaxRecd         C                   CONST(32766)
     D EnterKey        C                   const(x'F1')

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

     D WstrTps         S              3S 0
     D Wlength         S              3S 0
     D Wpstion         S              3S 0
     D WCusNah         S             10A
     D PKeyST          S              7A
     D PCcyCD          S              3A
     D KCusNh          S              6A
     D PCusNh          S             10A
     D SCusNh          S             10A
     D ElmtIndx        S              4S 0

      ** Parameter  entry
     D PActCod         S              1A
     D PMsgrID         S             21A
     D PDocTyp         S              7A
     D PDRtype         S             18A
     D PDRyear         S              4A
     D PFuncKy         S              3A

      ** Parameters AOBANKR0
     D POptn           S              7A
     D PRtcd           S              7A

      ** Parameter For ZA0350
     D PMsgFile        S             10A   INZ('SDUSRMSG')
     D PMsgId          S             10A
     D PMsgData        S             45A

      ** Working variables
     D MsRcnt          S              5S 0
     D RrnCnt          S              5S 0
     D RrnSav          S              5S 0
     D RelNCtr         S              5S 0
     D ErrorCd         S              1A

      ** Work variables for Report Group - Pool Report
     D WNexPos         S              3  0
     D KMsgRID         S             21A
     D KMgElmt         S             30A
     D KMgTpEl         S             40A
     D WcusIdx         S              5  0
     D WnahIdx         S              5  0
     D WSavCIx         S              5  0
     D WSavNIx         S              5  0
     D WriteSF         S              1
     D WICsNh          S             10
     D WRptNm          S             20
     D WriteRP         S              1A
     D WriteRT         S              1A
     D WriteRNT        S              1A
     D WriteCRNT       S              1A
     D WriteSel        S              1A
     D WSavNam         S             10A
     D WSavRpt         S             20A
     D WTotIndx        S              5  0
     D WMsgDta         S             26A
     D WBalance        S             26A
     D WCvtBal         S             15S 0
     D WPrevSc         S              1A
     D WRrnSel         S              5S 0
     D ErrCnt          S              5S 0
     D SelCnt          S              5S 0
     D MaxErCnt        S              5S 0
     D MaxSlCnt        S              5S 0
     D FirstPs         S              1A
     D PtypIdx         S              5S 0
     D SRtypIdx        S              5S 0
     D AcIdx           S              5S 0
     D SAcIx           S              5S 0
     D PInDx           S              2S 0
     D ExIdx           S              2S 0
     D SIx             S              2S 0
     D SecF12          S              1A
     D WCount          S              1A
     D WRptTyp         S              8A
     D WPoolCust       S             30A
     D WFunKy12        S              1A
     D WBACSQ          S              2A
     D WBACOD          S             10A
     D DwCDCRF         S             35A
     D WWRMRK          S              1A
     D WExclAccHldr    S              1A
     D Wbranch         S              3A                                                    MD043204

      ** Paramter for QCLSCAN of Reporting FI

     D PLength1        S              3P 0
     D PBegin          S              3P 0
     D PLength2        S              3P 0
     D PXSlate         S              1A
     D PTrimR          S              1A
     D PWildC          S              1A
     D POutput         S              3P 0

      ** Parameters for ZFRPED
     D PFld15          S             15  0
     D PDecs           S              1  0
     D PEcode          S              1
     D POut21          S             21
     D POut22          S             22
     D POut25          S             25

     D ScnDS           DS
     D  PressKey             369    369

      ** Reporting group / Pool report Customer sorting array
     D                 DS
     D ARNAHL                        26A   DIM(MaxRecd) DESCEND

      ** Reporting group / Pool report Non-account holder array
     D                 DS
     D ARCUSL                        26A   DIM(MaxRecd) DESCEND

      ** Run-time Array for FATCA Customer Types
     D ElmtArr         S             25A   DIM(MaxElmt) CTDATA

      ** Parameter Array for pool report
     DArPoolRepParm    S             41A   DIM(50)

      ** Parameter Array for Customer exclusion
     DArExclDetParm    S            266A   DIM(50)

      ** Reporting group / Pool report Selected Customer Array
     D                 DS
     D  CustDta                      33A   DIM(MaxRecd)
     D  CnumNh                       10A   OVERLAY(CustDta:1)
     D  CBalance                     22A   OVERLAY(CustDta:11)
     D  CNactn                        1A   OVERLAY(CustDta:33)

      ** Reporting group / Pool report Customer Error array
     D ErrAct                        10A   DIM(MaxRecd)

      ** Reporting group / Pool report array for Main screen
     D  MPoolDetl                   112A   DIM(MaxRecd) DESCEND
     D  MType                         8A   OVERLAY(MPoolDetl:1)
     D  MCount                        9A   OVERLAY(MPoolDetl:9)
     D  MBalance                     22A   OVERLAY(MPoolDetl:18)
     D  MCurrCd                       3A   OVERLAY(MPoolDetl:40)
     D  MDocrefID                    35A   OVERLAY(MPoolDetl:43)
     D  MCDocrefID                   35A   OVERLAY(MPoolDetl:78)

      ** Reporting group / Pool report array for Main screen
     D  MPoolDAct                     9A   DIM(MaxRecd) DESCEND
     D  MTypeSc                       8A   OVERLAY(MPoolDAct:1)
     D  MAction                       1A   OVERLAY(MPoolDAct:9)

      ** Array for Pool Amend, Corrected and void

     D ArPoolDet                     41A   DIM(50)
     D  APoolTyp                      8A   OVERLAY(ArPoolDet:1)
     D  APoolDocRf                   33A   OVERLAY(ArPoolDet:9)

      ** Array for customer exclusion
     D ArExclDet                     60A   DIM(50)
     D  AExCusNah                     6A   OVERLAY(ArExclDet:1)
     D  AExSpace4                     4A   OVERLAY(ArExclDet:7)
     D  AExRemark1                   28A   OVERLAY(ArExclDet:11)
     D  AExSpace1                     1A   OVERLAY(ArExclDet:39)
     D  AExRepTyp                     8A   OVERLAY(ArExclDet:40)
     D  AExRemark2                   10A   OVERLAY(ArExclDet:48)
     D ArExclDet2                   266A   DIM(50)
     D  AExCusNah2                   10A   OVERLAY(ArExclDet2:1)
     D  AExRemarkk1                  64A   OVERLAY(ArExclDet2:11)
     D  AExRemarkk2                  64A   OVERLAY(ArExclDet2:75)
     D  AExRemarkk3                  64A   OVERLAY(ArExclDet2:139)
     D  AExRemarkk4                  64A   OVERLAY(ArExclDet2:203)
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

     C                   EVAL      PInDx = 0

      ** Perform read to check for empty file

     C     KPoolRP1      SETLL     GLRMDTL0

      ** Continue processing records if file is not empty

     C                   IF        %FOUND(GLRMDTL0)

      ** Initialize variables

     C                   EXSR      SrIntVar

      ** Extract the data for main screen from GLRMDTPD
      ** and save it to an array

     C                   EXSR      SrMainEx

     C                   ENDIF

     C                   DOW       *INLR = *OFF

      ** Initialise main screen subfile

     C                   EXSR      SrInitMs

      ** Write the extracted records in the subfile of main screen

     C                   EXSR      SrWritMs

     C                   IF        MsRcnt <> 0
     C                   EVAL      D2SFRN = 1
     C                   EVAL      *IN70 = *ON
     C                   EVAL      *IN75 = *ON

     C                   IF        PMsgId = *BLANKS
     C                   EVAL      *IN55 = *ON
     C                   ENDIF

     C                   ELSE
     C                   EXSR      SrNoData1
     C                   ENDIF
      *
     C                   IF        PActCod = 'O'and  WExclAccHldr = 'Y'
     C                   EVAL      PMsgId = 'USR7524'
     C                   EXSR      SRErrDta
     C                   ENDIF

      ** Display Main screen

     C                   WRITE     GL000664M0
     C                   WRITE     GL000664F0
     C                   EXFMT     GL000664C2

      ** Execute subroutine for function key processing

     C                   EXSR      SrFuncMs

      ** Save the action code if action was taken

     C                   IF        *IN03 = *OFF AND
     C                             *IN05 = *OFF AND
     C                             *IN16 = *OFF AND
     C                             *IN20 = *OFF AND
     C                             *IN22 = *OFF
     C                   EXSR      SrSavMsA
     C                   ENDIF

     C                   IF        AcIdx <> 0 AND
     C                             PMsgId = *BLANKS

     C                   CLEAR                   ARNAHL
     C                   CLEAR                   ARCUSL
     C                   EVAL      WSaVCIx = 0
     C                   EVAL      WSavNIx = 0
     C                   EVAL      WnahIdx = 0
     C                   EVAL      WcusIdx = 0
     C                   EVAL      WTotIndx = 0
     C                   EVAL      SecF12 = *BLANKS
     C                   MOVE      'N'           WExclAccHldr
     C                   Exsr      SrSecScn

     C                   IF        SecF12 = 'Y'
     C                   EVAL      *INLR = *OFF
     C                   CLEAR                   MPoolDAct
     C                   EVAL      *IN77 = *ON
     C                   ENDIF

     C                   ENDIF

     C                   ENDDO

      ** Move selected Pool for Amend, Corrected and Void to
      ** parameter array

     C                   IF        PActCod = 'A' OR
     C                             PActCod = 'C' or
     C                             PActCod = 'V'
     C                   MOVEA     ArPoolDet     ArPoolRepParm
     C                   ENDIF

      ** Move selected customer/naho for exclusion to parameter array

     C                   IF        PActCod = 'O'
     C                   MOVEA     ArPoolDet     ArPoolRepParm
     C                   MOVEA     ArExclDet2    ArExclDetParm
     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrIntVar - Initialize variables                              *
      *                                                               *
      *****************************************************************
     C     SrIntVar      BEGSR
     C                   EVAL      WstrTps = 0
     C                   EVAL      Wlength = 0
     C                   EVAL      Wpstion = 0
     C                   EVAL      WNexPos = 0
     C                   EVAL      WcusIdx = 0
     C                   EVAL      WnahIdx = 0
     C                   EVAL      WSavCIx = 0
     C                   EVAL      WSavNIx = 0
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInitSF - Subroutine to initialize subfile for Pool List    *
      *                                                               *
      *****************************************************************

     C     SrInitSF      BEGSR

      ** Clear program message queue

     C                   CALL      'ZA0250'

      ** Clear working variables

     C                   EVAL      WFunKy12 = *BLANKS
     C                   EVAL      WriteSel = *BLANKS
     C                   EVAL      WriteRP = *BLANK
     C                   EVAL      WriteRT = *BLANK
     C                   EVAL      WriteRNT = *BLANK
     C                   EVAL      WriteCRNT = *BLANK
     C                   EVAL      WriteSF = *BLANK
     C                   EVAL      DCUSNH = *BLANKS
     C                   EVAL      DSRPTN = *BLANKS
     C                   EVAL      RrnCnt = *ZEROS
     C                   EVAL      *IN70 = *OFF
     C                   EVAL      *IN51 = *ON
     C                   EVAL      D0SFRN = *ZEROS
     C                   EVAL      *IN51 = *ON
     C                   WRITE     GL000664C0
     C                   EVAL      *IN51 = *OFF
     C                   EVAL      *IN54 = *ON

      ** Protect action field for list of cust/nah screen during "Amend"

     C                   IF        PActCod = 'A' OR
     C                             PActCod = 'C' OR
     C                             PActCod = 'V'
     C                   EVAL      *IN72 = *ON
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDspLst - Display the list of customer and Non-account      *
      *             holder                                            *
      *                                                               *
      *****************************************************************

     C     SrDspLst      BEGSR

     C                   IF        DICSNH <> *BLANKS AND
     C                             RrnCnt = 0

     C                   EVAL      WRptNm = DRPTNM
     C                   EVAL      WICsNh = DICSNH
     C                   EVAL      DICSNH = *BLANKS
     C                   EVAL      DRPTNM = *BLANKS
     C                   EXSR      SrInitSF
     C                   EVAL      WnahIdx = WSavNIx
     C                   EVAL      WcusIdx = WSavCIx

     C                   EXSR      SrWritSf

     C                   ENDIF

     C                   EVAL      D0SFRN = 1

     C                   IF        WPrevSc = '1'
     C                   EVAL      D0SFRN = WRrnSel
     C                   ENDIF

     C                   IF        RrnCnt = 0

      ** No data to display, set on SFLCLR condition and write the
      ** write the subfile control record

     C                   EVAL      PMsgId = 'USR7530'
     C                   EXSR      SRErrDta
     C                   EVAL      *IN51 = *ON
     C                   WRITE     GL000664C0
     C                   EVAL      *IN51 = *OFF

      ** Write to the subfile with non-display set on

     C                   EVAL      RrnCnt = 1
     C                   EVAL      D0SFRN = 1
     C                   EVAL      *IN53 = *ON
     C                   EVAL      *IN55 = *ON
     C                   WRITE     GL000664S0
     C                   EVAL      *IN53 = *OFF

     C                   ENDIF

     C                   EVAL      WSavNam = WICsNh
     C                   EVAL      WSavRpt = WRptNm
     C                   EVAL      DICSNH = WICsNh
     C                   EVAL      DRPTNM = WRptNm

     C                   WRITE     GL000664M0
     C                   WRITE     GL000664F1
     C                   EXFMT     GL000664C0

     C                   EVAL      PMsgId = *BLANKS
     C                   EVAL      WICsNh = DICSNH
     C                   EVAL      WRptNm = DRPTNM
     C                   EVAL      RrnSav = 0
     C                   EVAL      *IN69 = *OFF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrExtrac - This subroutine extract data from Value field of   *
      *          GLRMDTPD for list of customers and non-account holder*
      *                                                               *
      *****************************************************************
     C     SrExtrac      BEGSR

     C                   EVAL      WNexPos = 0
     C                   EVAL      WstrTps = 1
     C                   EVAL      Wlength = 26

     C                   EVAL      WPoolCust = 'PoolListCust' + WCount

     C                   IF        MGELMT = WPoolCust
     C                   EVAL      Wlength = 26
     C                   ENDIF

     C                   DOW       WstrTps < WMaxPos

     C                   EVAL      WTotIndx = WnahIdx + WcusIdx
     C                   IF        WTotIndx = MaxRecd
     C                   LEAVE
     C                   ENDIF

     C                   EVAL      WMsgDta = *BLANKS
     C                   EVAL      WMsgDta=%TRIM(%SUBST(MGDATA:WstrTps:Wlength))

     C                   IF        WMsgDta = *BLANKS
     C                   LEAVE
     C                   ENDIF

     C                   IF        MGELMT = WPoolCust

      ** Populate array for sorting

     C                   EVAL      WcusIdx = WcusIdx + 1
     C                   EVAL      ARCUSL(WcusIdx)  = WMsgDta

     C                   ELSE

      ** Populate array for sorting

     C                   EVAL      WnahIdx = WnahIdx + 1
     C                   EVAL      ARNAHL(WnahIdx) = WMsgDta

     C                   ENDIF

     C                   EVAL      WstrTps = WstrTps + Wlength
     C                   EVAL      WNexPos = WstrTps + Wlength

      ** If next position is greater than the maximum length of message data
      ** exit from the subfile wirting

     C                   IF        WNexPos > WMaxPos
     C                   LEAVE
     C                   ENDIF

     C                   ENDDO

     C                   EVAL      WSaVCIx = WcusIdx
     C                   EVAL      WSavNIx = WnahIdx

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWritSf - Subroutine to build subfile pool list             *
      *                                                               *
      *****************************************************************

     C     SrWritSf      BEGSR

      ** Build subfile for customer

     C                   SORTA     ARCUSL
     C                   DOW       WcusIdx > 0

     C                   EVAL      WMsgDta = ARCUSL(WcusIdx)
     C                   IF        WMsgDta = *BLANKS
     C                   LEAVE
     C                   ENDIF

     C                   IF        %SUBST(WMsgDta:11:1) = 'C'
     C                   EXSR      SRCallCS
     C                   ELSE
     C                   EXSR      SRCallNH
     C                   ENDIF
     C                   EVAL      WcusIdx = WcusIdx - 1

     C                   IF        DICSNH <> *BLANKS OR
     C                             DRPTNM <> *BLANKS OR
     C                             DRTOWN <> *BLANKS
     C                   EXSR      SrListSC
     C                   ENDIF


     C                   IF        (DICSNH = *BLANKS AND
     C                             DRPTNM = *BLANKS AND
     C                             DRTOWN = *BLANKS) OR

      ** Customer Name/Non-account holder search

     C                             (DICSNH <> *BLANKS AND
     C                             DRPTNM = *BLANKS AND
     C                             DRTOWN = *BLANKS AND
     C                             WriteSF = 'Y') OR

      ** Report Name search

     C                             (DICSNH = *BLANKS AND
     C                             DRTOWN = *BLANKS AND
     C                             DRPTNM <> *BLANKS AND
     C                             WriteRP = 'Y') OR

      ** Report Town search

     C                             (DICSNH = *BLANKS AND
     C                             DRPTNM = *BLANKS AND
     C                             DRTOWN <> *BLANKS AND
     C                             WriteRT = 'Y') OR

      ** Cust/Nah and Report Name search

     C                             (DICSNH <> *BLANKS AND
     C                             DRPTNM <> *BLANKS AND
     C                             DRTOWN = *BLANKS AND
     C                             WriteSF = 'Y' AND
     C                             WriteRP = 'Y' AND
     C                             WriteSel = 'Y') OR

      ** Cust/Nah and Report Town search

     C                             (DICSNH <> *BLANKS AND
     C                             DRTOWN <> *BLANKS AND
     C                             DRPTNM = *BLANKS AND
     C                             WriteSF = 'Y' AND
     C                             WriteRT = 'Y' AND
     C                             WriteRNT = 'Y') OR

      ** Report Name and Report Town search

     C                             (DICSNH = *BLANKS AND
     C                             DRTOWN <> *BLANKS AND
     C                             DRPTNM <> *BLANKS AND
     C                             WriteRT = 'Y' AND
     C                             WriteRP = 'Y') or

      ** Cust/Nah and Report Name and Report Town search

     C                             (DICSNH <> *BLANKS AND
     C                             DRTOWN <> *BLANKS AND
     C                             DRPTNM <> *BLANKS AND
     C                             WriteSF = 'Y' AND
     C                             WriteRT = 'Y' AND
     C                             WriteCRNT = 'Y' AND
     C                             WriteRP = 'Y')

     C                   EVAL      RrnCnt = RrnCnt + 1

     C                   IF        RrnCnt > 9999
     C                   LEAVE
     C                   ENDIF

      ** Convert amount to display format

     C                   EVAL      WBalance = *BLANKS
     C                   EVAL      WBalance = %TRIM(%SUBST(WMsgDta:12:15))
     C                   EVAL      PFLD15 = %DEC(WBalance:15:0)
     C                   Z-ADD     A6NBDP        PDECS
     C                   EXSR      SRCvtAmt
     C                   EVAL      DSTOTB = POUT22

     C                   EXSR      SrValAct

     C                   EVAL      D0SFRN = RrnCnt

     C                   WRITE     GL000664S0
     C                   CLEAR                   GL000664S0
     C                   EVAL      *IN69 = *OFF

     C                   ENDIF

     C                   ENDDO

      ** Build subfile for Non-account Holder

     C                   SORTA     ARNAHL
     C                   DOW       WnahIdx > 1

     C                   EVAL      DCUSNH = ARNAHL(WnahIdx)

     C                   IF        DCUSNH = *BLANKS
     C                   LEAVE
     C                   ENDIF

     C                   EXSR      SRCallNH
     C                   EVAL      WnahIdx = WnahIdx - 1

     C                   IF        DICSNH <> *BLANKS OR
     C                             DRPTNM <> *BLANKS OR
     C                             DRTOWN <> *BLANKS
     C                   EXSR      SrListSC
     C                   ENDIF

     C                   IF        (DICSNH = *BLANKS AND
     C                             DRPTNM = *BLANKS AND
     C                             DRTOWN = *BLANKS) OR

      ** Customer Name/Non-account holder search

     C                             (DICSNH <> *BLANKS AND
     C                             DRPTNM = *BLANKS AND
     C                             DRTOWN = *BLANKS AND
     C                             WriteSF = 'Y') OR

      ** Report Name search

     C                             (DICSNH = *BLANKS AND
     C                             DRTOWN = *BLANKS AND
     C                             DRPTNM <> *BLANKS AND
     C                             WriteRP = 'Y') OR

      ** Report Town search

     C                             (DICSNH = *BLANKS AND
     C                             DRPTNM = *BLANKS AND
     C                             DRTOWN <> *BLANKS AND
     C                             WriteRT = 'Y') OR

      ** Cust/Nah and Report Name search

     C                             (DICSNH <> *BLANKS AND
     C                             DRPTNM <> *BLANKS AND
     C                             DRTOWN = *BLANKS AND
     C                             WriteSF = 'Y' AND
     C                             WriteRP = 'Y' AND
     C                             WriteSel = 'Y') OR

      ** Cust/Nah and Report Town search

     C                             (DICSNH <> *BLANKS AND
     C                             DRTOWN <> *BLANKS AND
     C                             DRPTNM = *BLANKS AND
     C                             WriteSF = 'Y' AND
     C                             WriteRT = 'Y' AND
     C                             WriteRNT = 'Y') OR

      ** Report Name and Report Town search

     C                             (DICSNH = *BLANKS AND
     C                             DRTOWN <> *BLANKS AND
     C                             DRPTNM <> *BLANKS AND
     C                             WriteRT = 'Y' AND
     C                             WriteRP = 'Y') OR

      ** Cust/Nah and Report Name and Report Town search

     C                             (DICSNH <> *BLANKS AND
     C                             DRTOWN <> *BLANKS AND
     C                             DRPTNM <> *BLANKS AND
     C                             WriteSF = 'Y' AND
     C                             WriteRT = 'Y' AND
     C                             WriteCRNT = 'Y' AND
     C                             WriteRP = 'Y')


      ** Write the record in the subfile

     C                   EVAL      RrnCnt = RrnCnt + 1

     C                   IF        RrnCnt > 9999
     C                   LEAVE
     C                   ENDIF

      ** Convert amount to display format

     C                   EVAL      WBalance = *BLANK
     C                   EVAL      WBalance = %TRIM(%SUBST(WMsgDta:12:15))
     C                   EVAL      PFLD15 = %DEC(WBalance:15:0)
     C                   Z-ADD     A6NBDP        PDECS
     C                   EXSR      SRCvtAmt
     C                   EVAL      DSTOTB = POUT22

     C                   EVAL      D0SFRN = RrnCnt

     C                   WRITE     GL000664S0
     C                   CLEAR                   GL000664S0
     C                   EVAL      *IN69 = *OFF

     C                   ENDIF

     C                   ENDDO
     C                   EVAL      *IN55 = *ON

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrListSC - This subroutine will scan message data if the     *
      *             search records has match/es                       *
      *                                                               *
      *****************************************************************
     C     SrListSC      BEGSR

      ** Customer Number/Non-account Holder

     C                   IF        DICSNH <> *BLANKS

     C                   CALL      'QCLSCAN'
     C                   PARM                    DCUSNH
     C                   PARM      10            PLength1
     C                   PARM      1             PBegin
     C                   PARM                    DICSNH
     C                   PARM      10            PLength2
     C                   PARM      '1'           PXSlate
     C                   PARM      '1'           PTrimR
     C                   PARM      '?'           PWildC
     C                   PARM                    POutput

     C                   IF        POutput = 1
     C                   EVAL      WriteSF = 'Y'
     C                   ENDIF

     C                   ENDIF

      ** Report Name search

     C                   IF        DRPTNM <> *BLANKS

     C                   CALL      'QCLSCAN'
     C                   PARM                    DSRPTN
     C                   PARM      20            PLength1
     C                   PARM      1             PBegin
     C                   PARM                    DRPTNM
     C                   PARM      20            PLength2
     C                   PARM      '1'           PXSlate
     C                   PARM      '1'           PTrimR
     C                   PARM      '?'           PWildC
     C                   PARM                    POutput

     C                   IF        POutput >= 1
     C                   EVAL      WriteRP = 'Y'
     C                   ELSE
     C                   EVAL      WriteRP = 'N'
     C                   ENDIF

     C                   ENDIF

      ** Report Town search

     C                   IF        DRTOWN <> *BLANKS

     C                   CALL      'QCLSCAN'
     C                   PARM                    DSRTWN
     C                   PARM      10            PLength1
     C                   PARM      1             PBegin
     C                   PARM                    DRTOWN
     C                   PARM      10            PLength2
     C                   PARM      '1'           PXSlate
     C                   PARM      '1'           PTrimR
     C                   PARM      '?'           PWildC
     C                   PARM                    POutput

     C                   IF        POutput >= 1
     C                   EVAL      WriteRT = 'Y'
     C                   ELSE
     C                   EVAL      WriteRT = 'N'
     C                   ENDIF

     C                   ENDIF

      ** Customer Number/Non-account holder and Report Name

     C                   IF        DICSNH <> *BLANKS AND
     C                             DRPTNM <> *BLANKS AND
     C                             DRTOWN = *BLANKS
     C                   CALL      'QCLSCAN'
     C                   PARM                    DCUSNH
     C                   PARM      10            PLength1
     C                   PARM      1             PBegin
     C                   PARM                    DICSNH
     C                   PARM      10            PLength2
     C                   PARM      '1'           PXSlate
     C                   PARM      '1'           PTrimR
     C                   PARM      '?'           PWildC
     C                   PARM                    POutput

     C                   IF        POutput >= 1
     C                   EVAL      WriteSel = 'Y'
     C                   ENDIF

     C                   ENDIF

      ** Customer Number/Non-account holder and Report Town

     C                   IF        DICSNH <> *BLANKS AND
     C                             DRPTNM = *BLANKS AND
     C                             DRTOWN <> *BLANKS
     C                   CALL      'QCLSCAN'
     C                   PARM                    DCUSNH
     C                   PARM      10            PLength1
     C                   PARM      1             PBegin
     C                   PARM                    DICSNH
     C                   PARM      10            PLength2
     C                   PARM      '1'           PXSlate
     C                   PARM      '1'           PTrimR
     C                   PARM      '?'           PWildC
     C                   PARM                    POutput

     C                   IF        POutput >= 1
     C                   EVAL      WriteRNT = 'Y'
     C                   ENDIF

     C                   ENDIF

      ** Customerr/Naho and Report Name and Report Town

     C                   IF        DICSNH <> *BLANKS AND
     C                             DRPTNM <> *BLANKS AND
     C                             DRTOWN <> *BLANKS
     C                   CALL      'QCLSCAN'
     C                   PARM                    DCUSNH
     C                   PARM      10            PLength1
     C                   PARM      1             PBegin
     C                   PARM                    DICSNH
     C                   PARM      10            PLength2
     C                   PARM      '1'           PXSlate
     C                   PARM      '1'           PTrimR
     C                   PARM      '?'           PWildC
     C                   PARM                    POutput

     C                   IF        POutput >= 1
     C                   EVAL      WriteCRNT = 'Y'
     C                   ENDIF

     C                   ENDIF

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

     C                   EVAL      *IN57 = *ON
     C                   EVAL      DDPGMQ = '*'

     C     *ENTRY        PLIST
     C                   PARM                    PActCod
     C                   PARM                    PMsgrID
     C                   PARM                    PDocTyp
     C                   PARM                    PDRtype
     C                   PARM                    PDRyear
     C                   PARM                    PFuncKy
     C                   PARM                    ArPoolRepParm
     C                   PARM                    ArExclDetParm

     C                   EVAL      ExIdx = 0
     C                   EVAL      PInDx = 0
     C                   CLEAR                   ArPoolDet
     C                   CLEAR                   ArExclDet
     C                   CLEAR                   ArExclDet2
     C                   CLEAR                   ArExclDetParm
     C                   CLEAR                   ArPoolRepParm
     C                   EVAL      DDUSER = PSUser
     C                   EVAL      DDWID = PSJobName
     C                   EVAL      DDACTC = PActCod
     C                   EVAL      DREPTY = PDRtype
     C                   EVAL      DCYEAR = PDRyear

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

     C                   EVAL      PCcyCD = *BLANKS
     C                   EVAL      PFuncKy = *BLANKS
     C                   EVAL      DICSNH = *BLANKS
     C                   EVAL      DRPTNM = *BLANKS
     C                   EVAL      WICsNh = *BLANKS
     C                   EVAL      WRptNm = *BLANKS
     C                   EVAL      KMsgRID = PMsgrID
     C                   EVAL      DDOCTP = *BLANKS
     C                   EVAL      KMgTpEl = 'PoolReport'

     C     KPoolRP1      KLIST
     C                   KFLD                    KMsgRID
     C                   KFLD                    KMgTpEl

     C     KPoolRP2      KLIST
     C                   KFLD                    KMsgRID
     C                   KFLD                    KMgElmt
     C                   KFLD                    KMgTpEl

     C     KPoolRP3      KLIST
     C                   KFLD                    KMsgRID
     C                   KFLD                    KMgElmt

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

     c                   EVAL      DCUSNH = *BLANKS
     C                   EVAL      DCUSNH=%TRIM(%SUBST(WMsgDta:1:10))
     C                   EVAL      WCusNah = DCUSNH

     C                   CALLB     'AONAHOR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    WCusNah
     C     SDNAHO        PARM      SDNAHO        DSSDY

      ** Database error processing

     C                   IF        Prtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDNAHOPD'
     C                   EVAL      DBKEY = WCusNah
     C                   EVAL      DBASE = 003
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF

     C                   EVAL      DSRTWN = *BLANKS
     C                   EVAL      DSRPTN = *BLANKS
     C                   EVAL      DSRPTN = NHNARN
     C                   EVAL      DSRTWN = NHNATW

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

     C                   EVAL      DCUSNH = *BLANKS
     C                   EVAL      DCUSNH=%TRIM(%SUBST(WMsgDta:1:6))
     C                   EVAL      WCusNah = DCUSNH

     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    WCusNah
     C                   PARM      *BLANKS       PKeyST
     C     SDCUST        PARM      SDCUST        DSSDY

      ** Database error processing
     C                   IF        Prtcd <> *BLANKS
     C                             AND Prtcd <> '*CUSDEL'
     C                             AND Prtcd <> '*CUSCLS'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY = WCusNah
     C                   EVAL      DBASE = 002
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF

     C                   IF        Prtcd = '*CUSDEL'
     C                             OR Prtcd = '*CUSCLS'
     C                   ENDIF

     C                   EVAL      DSRPTN = *BLANKS
     C                   EVAL      DSRTWN = *BLANKS
     C                   EVAL      DSRPTN = BBCRNM
     C                   EVAL      DSRTWN = BBCRTN


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
      *  SrInzSel - Initialize the selected account subfile           *
      *                                                               *
      *****************************************************************
     C     SrInzSel      BEGSR

      ** Clear program message queue

     C                   CALL      'ZA0250'

     C                   EVAL      *IN50 = *OFF
     C                   WRITE     GL000664C0

      ** Write to the subfile with non-display set on

     C                   EVAL      RelNCtr = *ZEROS
     C                   EVAL      D1SFRN = *ZEROS
     C                   EVAL      *IN64 = *ON
     C                   EVAL      *IN67 = *ON
     C                   WRITE     GL000664C1
     C                   EVAL      *IN67 = *OFF
     C                   EVAL      *IN61 = *ON

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNoData - Subroutine to execute no data to display          *
      *                                                               *
      *****************************************************************
     C     SrNoData      BEGSR

      ** No data to display, set on SFLCLR condition and write the
      ** write the subfile control record

     C                   EVAL      PMsgId = 'USR7530'
     C                   EXSR      SRErrDta
     C                   EVAL      *IN67 = *ON
     C                   WRITE     GL000664C1
     C                   EVAL      *IN67 = *OFF

      ** Write to the subfile with non-display set on

     C                   EVAL      RelNCtr = 1
     C                   EVAL      D1SFRN = 1
     C                   EVAL      *IN60 = *ON
     C                   EVAL      *IN65 = *ON
     C                   WRITE     GL000664S1
     C                   EVAL      *IN60 = *OFF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNoDat1 - Subroutine to execute no data to display          *
      *                                                               *
      *****************************************************************
     C     SrNoData1     BEGSR

      ** No data to display, set on SFLCLR condition and write the
      ** write the subfile control record

     C                   EVAL      PMsgId = 'USR7530'
     C                   EXSR      SRErrDta
     C                   EVAL      *IN71 = *ON
     C                   WRITE     GL000664C2
     C                   EVAL      *IN71 = *OFF

      ** Write to the subfile with non-display set on

     C                   EVAL      MsRcnt = 1
     C                   EVAL      D2SFRN = 1
     C                   EVAL      *IN73 = *ON
     C                   EVAL      *IN75 = *ON
     C                   WRITE     GL000664S2
     C                   EVAL      *IN73 = *OFF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValAct - Subroutine to validate action code                *
      *                                                               *
      *****************************************************************
     C     SrValAct      BEGSR

     C                   EVAL      SelCnt = 1
     C     DCUSNH        LOOKUP    CnumNh(SelCnt)                         95

     C                   IF        *IN95 = *ON

     C                   EVAL      DSACTN = CNactn(SelCnt)

     C                   IF        CNactn(SelCnt) <> '1' AND
     C                             CNactn(SelCnt) <> *BLANKS
     C                   EVAL      *IN69 = *ON
     C                   EXSR      SRErrDta
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSavSel - Subroutine to save selected customer              *
      *                                                               *
      *****************************************************************
     C     SrSavSel      BEGSR

     C                   EVAL      SelCnt = 1
     C                   EVAL      PMsgId = *BLANKS
     C                   DOW       *IN98 = *OFF

     C                   IF        DSACTN <> '1' AND
     C                             DSACTN <> *BLANKS AND
     C                             PMsgId = *BLANKS
     C                   EVAL      PMsgId = 'USR9358'
     C                   ENDIF

      ** Save Cust/nah and action code for further processing

     C                   IF        DSACTN = '1'
     C                   EVAL      CustDta(SelCnt) = DCUSNH+DSTOTB+DSACTN
     C                   EVAL      SelCnt = SelCnt + 1
     C                   ENDIF

     C                   READC     GL000664S0                             98
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInitMs - Subroutine to initialise main screen              *
      *                                                               *
      *****************************************************************
     C     SrInitMs      BEGSR

      ** Clear program message queue

     C                   CALL      'ZA0250'

     C                   EVAL      MsRcnt = *ZEROS
     C                   EVAL      D2SFRN = *ZEROS
     C                   EVAL      *IN71 = *ON
     C                   WRITE     GL000664C2
     C                   EVAL      *IN71 = *OFF
     C                   EVAL      *IN79 = *OFF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrMainEx - Subroutine to extrac data from GLRMDTPD for main  *
      *             screen details                                    *
      *                                                               *
      *****************************************************************
     C     SrMainEx      BEGSR

     C     KPoolRP1      READE     GLRMDTL0                               94
     C
     C                   EVAL      PtypIdx = 0

     C                   DOW       *IN94 = *OFF

     C                   IF        MGELMT = 'AccountPoolReportType'
     C                   EVAL      PtypIdx = PtypIdx + 1
     C                   EVAL      MType(PtypIdx) = %TRIM(MGDATA)
     C                   ENDIF

     C                   SELECT
     C                   WHEN      MGELMT = 'DocTypeIndic'
     C                   EVAL      DDOCTP = %TRIM(MGDATA)

     C                   WHEN      MGELMT = 'AccountCount'
     C                   EVAL      MCount(PtypIdx) = %TRIM(MGDATA)

     C                   WHEN      MGELMT = 'PoolBalance'
     C                   EVAL      MBalance(PtypIdx) = %TRIM(MGDATA)
     C                   EVAL      MCurrCd(PtypIdx) = %TRIM(MGDAT2)

     C                   WHEN      MGELMT = 'DocRefId'
     C                   EVAL      MDocRefId(PtypIdx) = %TRIM(MGDATA)

     C                   WHEN      MGELMT = 'CorrDocRefId'
     C                   EVAL      DwCDCRF = %TRIM(MGDATA)
     C                   EVAL      MCDocRefId(PtypIdx) = %TRIM(MGDATA)

     C                   ENDSL

     C     KPoolRP1      READE     GLRMDTL0                               94

     C                   ENDDO

     C                   EVAL      SRtypIdx = PtypIdx

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWritMs - Subroutine to populate the field and write the    *
      *             records of main screen                            *
      *                                                               *
      *****************************************************************
     C     SrWritMs      BEGSR

     C                   SORTA     MPoolDetl
     C                   EVAL      PtypIdx = SRtypIdx

     C                   DOW       PtypIdx > 0

      ** Get number of decimal places for the given currency

     C                   EVAL      PCcyCD = MCurrCd(PtypIdx)
     C                   EVAL      PDECS = 0
     C                   EXSR      SrCurrCd

      ** Populate fields of main screen

     C                   EVAL      DMTYPE = MType(PtypIdx)
     C                   EVAL      DBALCC = MCurrCd(PtypIdx)
     C                   EVAL      DMDOCRF = MDocRefId(PtypIdx)

      ** Format numeric value suitable for screen

     C                   EXSR      SrForMat1

     C                   EVAL      MsRcnt = MsRcnt + 1
     C                   EVAL      D2SFRN = MsRcnt

      ** Validate action code

     C                   EVAL      *IN79 = *OFF
     C                   EXSR      SrValMsA

      ** Write to main screen subfile

     C                   WRITE     GL000664S2
     C                   CLEAR                   GL000664S2

     C                   EVAL      PtypIdx = PtypIdx - 1

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFuncMs - Subroutine to Process Main subfile function keys  *
      *                                                               *
      *****************************************************************
     C     SrFuncMs      BEGSR

     C                   SELECT

     C                   WHEN      *IN05 = *ON
     C                   EVAL      AcIdx = 0
     C                   EVAL      DMACTN = *BLANKS
     C                   EVAL      PMsgId = *BLANKS
     C                   CLEAR                   MPoolDAct
     C                   EVAL      *IN79 = *OFF
     C                   EVAL      *IN77 = *ON

     C                   WHEN      *IN03 = *ON
     C                   EVAL      PFuncKy = 'F3 '
     C                   EVAL      *INLR = *ON

     C                   WHEN      *IN16 = *ON
     C                   EVAL      PFuncKy = 'F16'
     C                   EVAL      PFuncKy = 'F12'
     C                   EVAL      *INLR = *ON

     C                   WHEN      *IN20 = *ON
     C                   EVAL      PFuncKy = 'F20'
     C                   EVAL      *INLR = *ON

     C                   WHEN      *IN22 = *ON
     C                   EVAL      PFuncKy = 'F22'
     C                   EVAL      *INLR = *ON

     C                   ENDSL

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
      *  SrValMsA - Subroutine to validate Main screen action code    *
      *                                                               *
      *****************************************************************
     C     SrValMsA      BEGSR

     C                   EVAL      AcIdx = 1
     C     DMTYPE        LOOKUP    MTypeSc(AcIdx)                         92
     C                   IF        *IN92 = *ON
     C                   EVAL      DMACTN = MAction(AcIdx)

      ** Validate action

     C                   IF        DMACTN <> '1' AND
     C                             DMACTN <> *BLANKS
     C                   EVAL      *IN79 = *ON
     C                   EXSR      SRErrDta
     C                   ENDIF

     C                   ELSE

     C                   EVAL      DMACTN = *BLANKS

     C                   ENDIF
     C                   EVAL      *IN77 = *ON

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSavMsA - Subroutine to save Main screen action code        *
      *                                                               *
      *****************************************************************
     C     SrSavMsA      BEGSR

     C                   READC     GL000664S2                             93

     C                   EVAL      D0DOCRF = DMDOCRF
     C                   EVAL      D0CDCRF = DwCDCRF
     C                   EVAL      AcIdx = 0
     C                   CLEAR                   MPoolDAct
     C                   EVAL      PMsgId = *BLANKS

     C                   DOW       *IN93 = *OFF

     C                   EVAL      AcIdx = AcIdx + 1
     C                   EVAL      MTypeSc(AcIdx) = DMTYPE
     C                   EVAL      MAction(AcIdx) = DMACTN

     C                   IF        DMACTN <> '1' AND
     C                             DMACTN <> *BLANKS AND
     C                             PMsgId = *BLANKS
     C                   EVAL      PMsgId = 'USR9358'
     C                   ENDIF

     C                   READC     GL000664S2                             93

     C                   ENDDO

     C                   EVAL      SAcIx = AcIdx

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrForMat1- Subroutine to format numeric value suitable for   *
      *             screen display                                    *
      *                                                               *
      *****************************************************************
     C     SrForMat1     BEGSR

      ** Format Account Count for screen display

     C                   EVAL      DMCOUNT = MCount(PtypIdx)
     C                   EVAL      PFLD15 = %DEC(DMCOUNT:9:0)
     C                   EXSR      SRCvtAmt
     C                   EVALR     DMCOUNT = %TRIM(POUT22)

      ** Format Pool balance for screen display

     C                   EVAL      DMPBALC = MBalance(PtypIdx)
     C                   EVAL      PFLD15 = %DEC(DMPBALC:15:0)
     C                   Z-ADD     A6NBDP        PDECS
     C                   EXSR      SRCvtAmt
     C                   EVAL      DMPBALC = POUT22

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrForMat2- Subroutine to format numeric value suitable for   *
      *             screen display                                    *
      *                                                               *
      *****************************************************************
     C     SrForMat2     BEGSR

      ** Format Account Count for screen display

     C                   EVAL      PDECS = 0
     C                   EVAL      DCOUNT = MCount(PtypIdx)
     C                   EVAL      PFLD15 = %DEC(DCOUNT:9:0)
     C                   EXSR      SRCvtAmt
     C                   EVAL      DCOUNT = %TRIM(POUT22)

      ** Format Pool balance for screen display

     C                   EVAL      DPBALC = MBalance(PtypIdx)
     C                   EVAL      PFLD15 = %DEC(DPBALC:15:0)
     C                   Z-ADD     A6NBDP        PDECS
     C                   EXSR      SRCvtAmt
     C                   EVAL      DPBALC = %TRIM(POUT22)

     C                   EVAL      D0DOCRF = MDocRefId(PtypIdx)
     C                   EVAL      D0CDCRF = MCDocRefId(PtypIdx)

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSecScn - Subroutine to process second screen list of       *
      *             customers and non-account holder                  *
      *                                                               *
      *****************************************************************
     C     SrSecScn      BEGSR

     C                   EVAL      AcIdx = 1

     C                   DOU       AcIdx > SAcIx

     C                   IF        MTypeSc(AcIdx) <> *BLANKS
     C                             AND MAction(AcIdx) <> *BLANKS

     C                   EVAL      WRptTyp = MTypeSc(AcIdx)
     C                   EVAL      WCount = %SUBST(WRptTyp:8:1)
     C                   EVAL      PtypIdx = 1
     C     WRptTyp       LOOKUP    MType(PtypIdx)                         91

      ** Format numeric value suitable for screen

     C                   EXSR      SrForMat2

     C                   EVAL      ElmtIndx = 1
     C                   CLEAR                   ARNAHL
     C                   CLEAR                   ARCUSL

     C                   DOU       ElmtIndx > MaxElmt
     C                   EVAL      KMgElmt = %TRIM(ElmtArr(ElmtIndx)) + WCount

     C     KPoolRP2      SETLL     GLRMDTL1
     C     KPoolRP2      READE     GLRMDTL1

     C                   DOW       NOT %EOF(GLRMDTL1)

      ** Execute subroutine that extract details for second screen

     C                   EXSR      SrExtrac

     C     KPoolRP2      READE     GLRMDTL1

     C                   ENDDO

     C                   EVAL      ElmtIndx = ElmtIndx + 1
     C                   ENDDO

      ** Execute subroutine that manage the second screen subfiled

     C                   EXSR      SrSecMng

     C                   ENDIF

     C                   EVAL      AcIdx = AcIdx + 1

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSecMng - Subroutine that manage the writing of records and *
      *             in the second screen subfile and display          *
      *                                                               *
      *****************************************************************
     C     SrSecMng      BEGSR

      ** For customer/naho search

     C                   DOW       (DICSNH <> *BLANKS) OR
     C                             (DRPTNM <> *BLANKS) OR
     C                             (DRTOWN <> *BLANKS) OR
     C                             (*IN05 <> *ON) OR
     C                             (*IN12 <> *ON)

      ** Continue processing records if file is not empty


      ** Initialise the subfile

     C                   EXSR      SrInitSF

      ** Position cursor to Report Name search field

     C                   IF        DICSNH = *BLANKS AND
     C                             DRPTNM <> *BLANKS
     C                   EVAL      *IN54 = *OFF
     C                   EVAL      *IN52 = *ON
     C                   ENDIF

      ** Position cursor to Report Town search field

     C                   IF        DICSNH = *BLANKS AND
     C                             DRPTNM = *BLANKS AND
     C                             DRTOWN <> *BLANKS
     C                   EVAL      *IN54 = *OFF
     C                   EVAL      *IN68 = *ON
     C                   ENDIF

      ** Set array index for array search

     C                   EVAL      WnahIdx = WSavNIx
     C                   EVAL      WcusIdx = WSavCIx

      ** Write records in the subfile

     C                   EXSR      SrWritSf

     C                   IF        RrnCnt <> 0
     C                   EVAL      *IN50 = *ON
     C                   ENDIF


      ** Perform execute format to display subfile

     C                   EXSR      SrDspLst

      ** Read the subfile to check if actions were taken

     C                   CLEAR                   CustDta
     C                   READC     GL000664S0                             98

     C                   IF        *IN98 = *OFF AND
     C                             *IN03 = *OFF AND
     C                             *IN05 = *OFF AND
     C                             *IN12 = *OFF AND
     C                             *IN20 = *OFF AND
     C                             *IN22 = *OFF

      **Save selected records

     C                   EXSR      SrSavSel

      ** Third screen processing

     C                   IF        PMsgId = *BLANKS

     C                   IF        PActCod = 'O'
     C                   EVAL      *IN74 = *ON
     C                   MOVE      'Y'           WExclAccHldr
     C                   ENDIF

     C                   EXSR      SrThrdSc
     C                   ENDIF

     C                   ENDIF

      ** Process function key

     C                   SELECT

     C                   WHEN      *IN05 = *ON

     C                   EVAL      WSavRpt = *BLANKS
     C                   EVAL      WSavNam = *BLANKS
     C                   EVAL      DICSNH = *BLANKS
     C                   EVAL      DRPTNM = *BLANKS
     C                   EVAL      DRTOWN = *BLANKS
     C                   EVAL      WICsNh = *BLANKS
     C                   EVAL      WRptNm = *BLANKS
     C                   EVAL      WriteSF = *BLANKS
     C                   EVAL      WriteRP = *BLANKS
     C                   EVAL      WriteRT = *BLANKS
     C                   EVAL      WriteRNT = *BLANKS
     C                   EVAL      WriteSel = *BLANKS
     C                   EVAL      WriteCRNT = *BLANKS
     C                   EVAL      *IN69 = *OFF
     C                   EVAL      DSACTN = *BLANK

     C                   WHEN      *IN03 = *ON
     C                   EVAL      DMACTN = *BLANKS
     C                   EVAL      PFuncKy = 'F3 '
     C                   MOVE      'N'           WExclAccHldr
     C                   EVAL      *INLR = *ON
     C                   CLEAR                   MPoolDAct
     C                   EVAL      *IN77 = *ON

     C                   LEAVE

     C                   WHEN      *IN12 = *ON AND
     C                             WFunKy12 = *BLANKS

     C                   EVAL      SecF12 = 'Y'
     C                   LEAVE

     C                   WHEN      *IN20 = *ON
     C                   EVAL      PFuncKy = 'F20'
     C                   EVAL      *INLR = *ON
     C                   LEAVE

     C                   WHEN      *IN22 = *ON
     C                   EVAL      PFuncKy = 'F22'
     C                   EVAL      *INLR = *ON
     C                   LEAVE

     C                   WHEN      PressKey = EnterKey AND
     C                             DRPTNM = *BLANKS AND
     C                             DICSNH = *BLANKS AND
     C                             WSavNam = *BLANKS AND
     C                             WSavRpt = *BLANKS AND
     C                             WFunKy12 = *BLANKS

     C                   IF        PActCod = 'A' OR
     C                             PActCod = 'C' OR
     C                             PActCod = 'V'

      ** Ensure no duplicate records in the pool

     C     WRptTyp       LOOKUP    APoolTyp                               34
     C                   IF        *IN34 = *OFF
     C                   EVAL      PInDx = PInDx + 1
     C                   EVAL      APoolTyp(PInDx) = WRptTyp
     C                   EVAL      APoolDocRf(PInDx) = D0DOCRF
     C                   ENDIF

     C                   ENDIF

     C                   EVAL      SecF12 = 'Y'
     C                   LEAVE

     C                   ENDSL

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrThrdSc - Subroutine to manage third screen display        *
      *                                                               *
      *****************************************************************
     C     SrThrdSc      BEGSR

     C                   EVAL      SelCnt = 1
     C                   EVAL      PCusNh = CnumNh(SelCnt)
     C                   EVAL      WFunKy12 = *BLANKS

     C                   DOW       *IN03 = *OFF AND
     C                             WFunKy12 = *BLANKS AND
     C                             PCusNh <> *BLANKS

     C                   IF        PActCod = 'O'
     C                   EVAL      DCUSNH = PCusNh
     C                   EVAL      D3MIR1 = *BLANKS
     C                   EVAL      D3MIR2 = *BLANKS
     C                   EVAL      D3MIR3 = *BLANKS
     C                   EVAL      D3MIR4 = *BLANKS
     C                   EVAL      WWRMRK = 'N'

     C                   EVAL      *IN56 = *OFF
     C                   WRITE     GL000664C4
     C                   DOW       WWRMRK = 'N'
     C                   WRITE     GL000664M0
     C                   WRITE     GL000664F4
     C                   EXFMT     GL000664C4
     C                   CALL      'ZA0250'
     C                   EVAL      *IN56 = *OFF

     C                   IF        *IN03 = *ON
     C                             OR *IN12 = *ON
     C                   EVAL      *IN50 = *ON
     C                   EVAL      WFunKy12 = 'Y'
     C                   CLEAR                   CustDta
     C                   EVAL      DSACTN = *BLANKS
     C                   GOTO      GFUNC
     C                   ENDIF

     C                   IF        D3MIR1 = *BLANKS
     C                             AND D3MIR2 = *BLANKS
     C                             AND D3MIR3 = *BLANKS
     C                             AND D3MIR4 = *BLANKS
     C                   EVAL      PMsgId = 'USS0565'
     C                   EXSR      SRErrDta
     C                   EVAL      *IN56 = *ON
     C                   WRITE     GL000664C4
     C                   ELSE
     C                   EVAL      WWRMRK = 'Y'
     C                   EVAL      PMsgId = *BLANKS
     C                   ENDIF

     C                   ENDDO

     C                   ENDIF

      ** Initialize third screen

     C                   EXSR      SrInzSel

      ** Write the records of third screen subfile

     C                   EVAL      PCusNh = CnumNh(SelCnt)
     C                   EVAL      DCUSNH = CnumNh(SelCnt)
     C                   EVAL      DTOTBL = %TRIML(CBalance(SelCnt))
     C                   EVAL      Wbranch = %SUBST(PMsgrID:5:3)                            MD043204

     C                   IF        WRptTyp   = 'FATCA204'
     C                   EXSR      SrWrF204
     C                   ELSE
     C                   EXSR      SrWrThrd
     C                   ENDIF

     C                   EVAL      SCusNh = PCusNh
     C                   EVAL      RrnCnt = 1                                               MD043185
     C                   EVAL      D1SFRN = 1                                               MD043185
     C                   EVAL      *IN66 = *ON                                              MD043185
     C                   WRITE     GL000664M0
     C                   WRITE     GL000664F2
     C                   EXFMT     GL000664C1

     C                   EVAL      SelCnt = SelCnt + 1
     C                   EVAL      PCusNh = CnumNh(SelCnt)

     C     GFUNC         TAG

      ** Process function keys of 3rd screen

     C                   EXSR      SrThrdFK

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrWrF204 - Write record to third screen subfile             *
      *                                                               *
      *****************************************************************
     C     SrWrF204      BEGSR

     C                   EVAL      KCusNh = PCusNh
     C     PCusNh        SETLL     GLCAPAL2                               96
     C                   IF        *IN96 = *OFF

     C                   EXSR      SrNoData

     C                   ELSE

      ** Process accounts

     C     PCusNh        READE     GLCAPAL2                               97
     C                   DOW       *IN97 = *OFF

     C                   IF        Wbranch = CPBRCH                                         MD043204
     C                   EVAL      DSACNT = CPACNO
     C                   EVAL      PFLD15 = CPPSTA
     C                   EVAL      DSCURR = CPCCY
     C                   EVAL      PCcyCD = DSCURR

     C                   EXSR      SrCurrCd
     C                   Z-ADD     A6NBDP        PDECS
     C                   EXSR      SRCvtAmt
     C                   EVAL      DSAMNT = POUT22
     C                   EVAL      RelNCtr = RelNCtr + 1

     C                   IF        RelNCtr > 9999
     C                   LEAVE
     C                   ENDIF

     C                   EVAL      D1SFRN = RelNCtr

     C                   WRITE     GL000664S1
     C                   CLEAR                   GL000664S1
     C                   ENDIF                                                              MD043204

     C     PCusNh        READE     GLCAPAL2                               97

     C                   ENDDO

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrWrThrd - Write record to third screen subfile             *
      *                                                               *
      *****************************************************************
     C     SrWrThrd      BEGSR

     C                   EVAL      KCusNh = PCusNh
     C     PCusNh        SETLL     GLCSBAL1                               96
     C                   IF        *IN96 = *OFF

     C                   EXSR      SrNoData

     C                   ELSE

      ** Process accounts

     C     PCusNh        READE     GLCSBAL1                               97
     C                   DOW       *IN97 = *OFF

     C                   IF        Wbranch = CBBRCH                                         MD043204
     C                   IF        CBTRNN = *BLANKS
     C                   MOVE      CBACOD        WBACOD
     C                   MOVE      CBACSQ        WBACSQ
     c                   IF        CBCUST <> *BLANKS
     C                   EVAL      DSACNT=CBBRCH+CBCUST+CBCURR+WBACOD+WBACSQ
     C                   ELSE
     C                   EVAL      DSACNT=CBBRCH+CBJANO+CBCURR+WBACOD+WBACSQ
     C                   ENDIF
     C                   ELSE
     C                   EVAL      DSACNT = CBTRNN
     C                   ENDIF

     C                   EVAL      PFLD15 = CBBALN
     C                   EVAL      DSCURR = CBCURR
     C                   EVAL      PCcyCD = DSCURR

     C                   EXSR      SrCurrCd
     C                   Z-ADD     A6NBDP        PDECS
     C                   EXSR      SRCvtAmt
     C                   EVAL      DSAMNT = POUT22
     C                   EVAL      RelNCtr = RelNCtr + 1

     C                   IF        RelNCtr > 9999
     C                   LEAVE
     C                   ENDIF

     C                   EVAL      D1SFRN = RelNCtr

     C                   WRITE     GL000664S1
     C                   CLEAR                   GL000664S1
     C                   ENDIF                                                              MD043204

     C     PCusNh        READE     GLCSBAL1                               97
     C

     C                   ENDDO

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrThrdFK - Subroutine to manage function keys of 3rd screen *
      *                                                               *
      *****************************************************************
     C     SrThrdFK      BEGSR

     C                   SELECT
     C                   WHEN      *IN03 = *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      PFuncKy = 'F3 '

     C                   WHEN      (*IN12 = *ON AND
     C                             PCusNh = *BLANKS) OR
     C                             (PressKey = EnterKey AND
     C                             PCusNh = *BLANKS)
     C                   EVAL      *IN50 = *ON
     C                   EVAL      WFunKy12 = 'Y'
     C                   CLEAR                   CustDta
     C                   EVAL      DSACTN = *BLANKS

     C                   IF        SCusNh <> *BLANKS
     C                             AND *IN12 = *OFF
     C                   EXSR      SrSavExc
     C                   ENDIF

     C                   WHEN      (PressKey = EnterKey AND
     C                             SCusNh <> *BLANKS)
     C                             AND *IN12 = *OFF

     C                   EXSR      SrSavExc

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrSavExc - Subroutine to save excluded customer/naho        *
      *                                                               *
      *****************************************************************
     C     SrSavExc      BEGSR

      ** Ensure no duplicate records in the Exclusion details

     C                   IF        PActCod = 'O'

     C     SCusNh        LOOKUP    AExCusNah2                             33

      ** Populate exclusion array

     C                   IF        *IN33 = *OFF
     C                   EVAL      ExIdx = ExIdx + 1
     C                   EVAL      AExCusNah2(ExIdx) = SCusNh
     C                   EVAL      AExRemark1(ExIdx) = Remarks1
     C                   EVAL      AExRepTyp(ExIdx) = WRptTyp
     C                   EVAL      AExRemark2(ExIdx) = Remarks2
     C                   EVAL      AExRemarkk1(ExIdx) = D3MIR1
     C                   EVAL      AExRemarkk2(ExIdx) = D3MIR2
     C                   EVAL      AExRemarkk3(ExIdx) = D3MIR3
     C                   EVAL      AExRemarkk4(ExIdx) = D3MIR4

     C     WRptTyp       LOOKUP    APoolTyp                               34
     C                   IF        *IN34 = *OFF
     C                   EVAL      PInDx = PInDx + 1
     C                   EVAL      APoolTyp(PInDx) = WRptTyp
     C                   EVAL      APoolDocRf(PInDx) = D0DOCRF
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**CTDATA ElmtArr
PoolListCust
PoolListNaho
