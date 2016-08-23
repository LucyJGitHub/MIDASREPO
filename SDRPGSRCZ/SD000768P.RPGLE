     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Exchange of Information Detailed Report')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000768P -  SD Exchange of Information Detailed Report      *
      *                                                               *
      *  Function:  This module reports the Exchange of Information   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CER070             Date 19Aug14               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG24029           Date 20May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23670           Date 03Apr09               *
      *                 BUG23123           Date 09Mar09               *
      *                 BUG22529           Date 10Feb09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER034A            Date 19May08               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 237337             Date 03Oct06               *
      *                 CSD027A            Date 05May06               *
      *                 236176             Date 27Sep05               *
      *                 234295             Date 24Jun05               *
      *                 232543             Date 01Apr05               *
      *                 CGL035             Date 01Mar05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24029 - COB Error RE3662 Database Error                   *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG23670 - CGL035 3 x Reports should not be amended for      *
      *             LF047                                             *
      *  BUG23123 - Report: Does not show Retail Account Number       *
      *                     Date is not Midas Standard Date           *
      *                     Period should be actual int. calc. period *
      *                     Secondary Tax amount is not printed       *
      *                     Added field TSSLID                        *
      *                     (Recompile)                               *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  BUG22580 - Fields incorrectly labeled and lengths (Recompile)*
      *  CER034A - LF046 German Features - New Fields and Enquiries   *
      *           (Recompile)                                         *
      *  CER048 - German Features - Taxes                             *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  237337 - Avoid database error if customer deleted (ie,       *
      *           PRTCD = '*CUSDEL')                                  *
      *  CSD027A - Conversion Of Customer Number to Alpha (recompile) *
      *  236176 - Narratives missing or wrong / use tax ccy and not   *
      *           other ccy (original / settlement ...)               *
      *  234295 - Database Error 6                                    *
      *  232543 - Fix to CGL032 (Recompile)                           *
      *  CGL035 - EUSD Upgrade to MidasPlus                           *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Error in reading file SDCSINL9                  *
      *    02         End of file for SDCSINL9                        *
      *    20         Audit mode, use for header                      *
      *    21         Out of balance, difference in number of records *
      *    22         Hide text in Detail2                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRPrint - Print details                                       *
      * SREnd   - Write trailer in report                             *
      * SRAudit - Write audit report                                  *
      * SRWrHeader - Write Header                                     *
      * SRMoveVal  - Moving values to printer fields                  *
      * SRWrIntAmt - Write Total Interest Amount                      *
      * SRPrIntTot - Printe Interest Total                            *
      * SRWrRcvTot - Write Total for Receiving Country                *
      * SRPrRcvTot - Print Receving Total                             *
      * SRWrTaxTot - Write Tax Total                                  *
      * SRWrPageBrk- Page break routine                               *
      * SRWrTaxDenHdr - Write Tax/Denomination Header                 *
      * SRBnfcryHdr- Write Beneficiary Header                         *
      * SRWrBnfcryDtl - Write Beneficiary Detail                      *
      * SRRtvCustDtl  - Retrieve Customer Detail                      *
      * SRRtvNAHODtl  - Retrieve NAHO Detail                          *
      * *INZSR  - Initialise                                          *
      * *PSSR   - Error processing                                    *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** SD Midas Customer Income  - Retrieve
     FSDCSINL9  IF   E           K DISK    INFSR(*PSSR)
 
      ** SD Exchange of Infor Detailed Reprot - Details
     FSD000768P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
 
      ** SD Exchange of Infor Detailed Reprot - Audit
     FSD000768AUO    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
     F                                     INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Externally described DS for Non-Account Holder details
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
 
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                            BUG24029
      ** DS for access objects - longt data structure                                       BUG24029
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG24029
      **********                                                                     CER048 BUG23670
      ***DS*for*access object AOSARDR0                                               CER048 BUG23670
      **********                                                                     CER048 BUG23670
     D***SCSARD*       E DS                  EXTNAME(SCSARDPD)                       CER048 BUG23670
 
      ** Externally described DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
 
      ** Externally described DS for Branch Details
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
 
      ** Externally described DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Externally described DS for Country Details
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
 
      ** Externally described DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTL1)
 
      ** File Information Data Structure for SD000768P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** File Information Data Structure for SD000768AU.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
      ** Input DS
     D PData           DS           100
     D  PTaxY                  1      4A
     D  PTaxY#                 1      4S 0
     D  PTaxM                  5      6A
     D  PTaxM#                 5      6S 0
     D  PCryT                  7      8A
     D  PRcvC                  9     10A
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             01     01
     D  EndOfFile             02     02
     D  RecNotFnd             03     03
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
      *
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters for ZEDIT
     D ZField          S             16
     D ZAdec           S              1  0
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
      ** Parameters for access object programs
     D PRtcd           S              7
     D POptn           S              7
     D PCust           S             10
     D PKey            S              7
     D***PSard**         S              6A                                           CER048 BUG23670
 
      ** Parameter list fields
     D PLevel          S              1
     D PAct            S              1
     D PCmd            S              1
     D PCncd           S              2
     D PBrcd           S              3
     D PKeySts         S              7
     D PAcus           S             10
     D POccy           S              3
     D PNaho           S             10
      **********                                                                     CER048 BUG23670
      ***Parameter list for ZSEDITF                                                  CER048 BUG23670
      **********                                                                     CER048 BUG23670
     D***PFld15*         S             15P 0                                         CER048 BUG23670
     D***PDecs**         S              1P 0                                         CER048 BUG23670
     D***PECode*         S              1A                                           CER048 BUG23670
     D***PEChar*         S              1A                                           CER048 BUG23670
     D***POut21*         S             21A                                           CER048 BUG23670
 
      ** Other fields used
     D WRun            S              1
     D WOpen           S              1    INZ('N')
     D WFirst          S              1    INZ('Y')
     D WNoRec          S              5  0 INZ(0)
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D WCtrt           S              2
      **********                                                                     CER048 BUG23670
      ***Variable for feature CER048                                                 CER048 BUG23670
      **********                                                                     CER048 BUG23670
     D***CER048*         S              1A                                           CER048 BUG23670
 
      ** Variables to hold previous values of fields
     D WPrevBranch     s                   like(TSBRCA)
     D WPrevRcvCtry    s                   like(TSRCTR)
     D WPrevNAHO       s                   like(TSNAHO)
     D WPrevCUST       s                   like(TSCUST)
     D WA6NBDP         s                   like(A6NBDP)
 
     D WDeal#@         s              6
 
     D WTotalPaid      S             15  0
     D WTotalRcvCty    S             15  0
     D WTotalCtyTax    S             15  0
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Set file pointer to first record valid record and do initial read
 
     C     KLIST1        SETLL     SDCSINL9
     C                   READ      SDCSINL9
 
      ** Initialize previous values
 
     C                   EVAL      WPrevBranch   = *blanks
     C                   EVAL      WPrevRcvCtry  = *blanks
     C                   EVAL      WPrevNAHO     = *blanks
     C                   EVAL      WPrevCUST     = *blanks
 
     C                   DOW       NOT %eof(SDCSINL9) AND TSCTRT = PCryT
 
      ** Only select records according to the required info
      ** specified at the screen fields and should be 'D'isclosed Customer
 
     C                   IF        TSTAXY = PTaxy# and ((TSTAXM = PTaxM# and
     C                             PTaxM# <> 0) or (PTaxM# = 0)) and
     C                             ((TSRCTR = PRcvC and PRcvC <> *blanks)
     c                             or (PRcvC = *blanks)) and TSSTAT = 'D'
 
      ** Count no. of records processed.
 
     C                   EVAL      WNoRec = WNoRec + 1
 
      ** Process Report Lines.
 
     C                   EXSR      SRPrint
 
      ** Save previous values
 
     C                   EVAL      WPrevBranch  = TSBRCA
     C                   EVAL      WPrevRcvCtry = TSRCTR
     C                   EVAL      WPrevNAHO    = TSNAHO
     C                   EVAL      WPrevCUST    = TSCUST
 
     C                   ENDIF
 
      ** Read Customer record
 
     C                   READ      SDCSINL9
 
     C                   ENDDO
 
     C                   IF        WFirst = 'N'
 
      ** check for overflow
 
     C                   EVAL      RqdLn1 = 3
 
     C                   EXSR      SRWrHeader
 
      ** Print Interest Total
 
     C                   EXSR      SRPrIntTot
 
      ** check for overflow
 
     C                   EXSR      SRWrHeader
 
      ** Print Receiving Country Total
 
     C                   EXSR      SRPrRcvTot
 
      ** check for overflow
 
     C                   EXSR      SRWrHeader
 
      ** Print Country of Tax Total
 
     C                   EXSR      SRWrTaxTot
 
     C                   EXSR      SREnd
     C                   ENDIF
 
     C                   EXSR      SRAudit
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrnt - Print details                                       *
      *                                                               *
      *****************************************************************
     C     SRPrint       BEGSR
 
     C                   IF        WOpen <> 'Y'
     C                   EVAL      WOpen = 'Y'
     C                   OPEN      SD000768P1
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = SFNUM1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSERR         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      RqdLn1 = 3
      **********                                                                     CER048 BUG23670
     C**********         IF        CER048 = 'Y'                                      CER048 BUG23670
     C**********         EVAL      RqdLn1 = 7                                        CER048 BUG23670
     C**********         ENDIF                                                       CER048 BUG23670
      **********                                                                     CER048 BUG23670
 
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
      ** For initial print of details or overflow has occured, print the Header
      ** of the report.
 
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      WFIRST = 'N'
     C                   ENDIF
 
      ** Print Interest Total (Footer 1)
 
     C                   EXSR      SRWrIntAmt
 
      ** Print Receving Country Total (Footer 2)
 
     C                   EXSR      SRWrRcvTot
 
      ** Page break for next Branch code and receiving country
 
     C                   EXSR      SRWrPageBrk
 
      ** Print Tax and Denomination Header
 
     C                   EXSR      SRWrTaxDenHdr
 
      ** Beneficiary Header
 
     C                   EXSR      SRBnfcryHdr
 
      ** Print Detail Beneficiary Detail
 
     C                   EXSR      SRWrBnfcryDtl
 
      ** Write details to printer fields.
 
      ** Move Values
     C                   EXSR      SRMoveVal
 
 
      ** Acummulate Totals
 
      ** Accumulate interest amount
 
     C                   EVAL      WTotalPaid = WTotalPaid + TSGINB
 
      ** Accumulate Receiving Country amount
 
     C                   EVAL      WTotalRcvCty = WTotalRcvCty + TSGINB
 
      ** Accumulate Country of Tax amount
 
     C                   EVAL      WTotalCtyTax = WTotalCtyTax + TSGINB
 
      ** check for overflow
 
     C                   EVAL      RqdLn1 = 1
     C                   EXSR      SRWrHeader
 
      ** Write Detail
 
     C                   WRITE     DETAIL2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - Write trailer in report                              *
      *                                                               *
      *****************************************************************
     C     SREnd         BEGSR
 
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out report trailer.
 
     C                   WRITE     TRAILP1
 
      ** Write audit report.
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrHeader - Writer Header                                   *
      *                                                               *
      *****************************************************************
     C     SRWrHeader    BEGSR
 
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMoveVal  - Move Values                                     *
      *                                                               *
      *****************************************************************
     C     SRMoveVal     BEGSR
 
     C                   IF        TSBRCA <> WPrevBranch or
     C                             TSRCTR <> WPrevRcvCtry or
     C                             TSCUST <> WPrevCUST or
     C                             TSNAHO <> WPrevNAHO
 
     C                   EVAL      *IN22 = *ON
     C                   ELSE
     C                   EVAL      *IN22 = *OFF
     C                   ENDIF
 
     C                   EVAL      RMODU = TSMODI
     C                   EVAL      RMODTYP = *BLANKS
     C                   SELECT
     C                   WHEN      TSMODI = 'R'
     C                   EVAL      RMODTYP = TSIBAN
     C                   WHEN      TSMODI = 'D'
     C                   MOVE      TSDLLN        WDeal#@
     C                   EVAL      RMODTYP = 'Deposit No.' + WDeal#@
     C                   WHEN      TSMODI = 'S'
     C**********         EVAL      RMODTYP = TSETYP + TSISIN                                  236176
     C                   IF        TSTRTP = '  '                                              236176
     C                   EVAL      RMODTYP = TSETYP + ' ' + TSSESN + TSSRPN                   236176
     C                   ENDIF                                                                236176
     C                   IF        TSTRTP = 'TP' or                                           236176
     C                             TSTRTP = 'TS'                                              236176
     C                   EVAL      RMODTYP = TSINST                                           236176
     C                   ENDIF                                                                236176
     C                   ENDSL
 
     C                   CLEAR                   ZField
     C                   MOVE      TSGINB        ZField
 
     C                   CALL      'ZEDIT'
     C                   PARM                    ZField
     C                   PARM      WA6NBDP       ZADec
 
     C                   MOVE      ZFIELD        RCRINT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrIntAmt - Write Interest Amount                           *
      *                                                               *
      *****************************************************************
     C     SRWrIntAmt    BEGSR
 
     C                   IF        (TSBRCA <> WPrevBranch and
     C                             WPrevBranch <> *blanks) or
     C                             (TSRCTR <> WPrevRcvCtry and
     C                             WPrevRcvCtry <> *blanks) or
     C                             (((TSNAHO <> WPrevNAHO and
     C                             TSCUST = *blanks) or
     C                             (TSCUST <> WPrevCUST and
     C                             TSNAHO = *blanks)) and
     C                             WPrevRcvCtry <> *blanks and
     C                             WPrevBranch <> *blanks)
 
     C                   EXSR      SRPrIntTot
 
      ** initialize total
 
     C                   EVAL      WTotalPaid = 0
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrIntTot - Print Interest Total                            *
      *                                                               *
      *****************************************************************
     C     SRPrIntTot    BEGSR
 
     C                   CLEAR                   ZField
     C                   MOVE      WTotalPaid    ZField
 
     C                   CALL      'ZEDIT'
     C                   PARM                    ZField
     C                   PARM      WA6NBDP       ZADec
 
     C                   MOVE      ZFIELD        RTSGINT
 
     C                   WRITE     ENDER1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrRcvTot - Write Receiving Country Total                   *
      *                                                               *
      *****************************************************************
     C     SRWrRcvTot    BEGSR
 
     C                   IF        (TSBRCA <> WPrevBranch and
     C                              WPrevBranch <> *blanks) or
     C                             (TSRCTR <> WPrevRcvCtry and
     C                              WPrevRcvCtry <> *blanks)
 
      ** print receiving total
 
     C                   EXSR      SRPrRcvTot
 
      ** initialize total
 
     C                   EVAL      WTotalRcvCty = 0
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrRcvTot - Print Receiving Total                           *
      *                                                               *
      *****************************************************************
     C     SRPrRcvTot    BEGSR
 
 
      ** check for overflow
 
     C                   EXSR      SRWrHeader
 
      ** Get the Total Receiving Country
 
     C                   CLEAR                   ZField
     C                   MOVE      WTotalRcvCty  ZField
 
     C                   CALL      'ZEDIT'
     C                   PARM                    ZField
     C                   PARM      WA6NBDP       ZADec
 
     C                   MOVE      ZFIELD        RTOTRCV
 
     C                   EVAL      RHCOLC = WPrevRcvCtry
 
     C                   WRITE     ENDER2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrTaxTot - Write Tax Total                                 *
      *                                                               *
      *****************************************************************
     C     SRWrTaxTot    BEGSR
 
      ** check for overflow
 
     C                   EXSR      SRWrHeader
 
      ** Get the Total Receiving Country
 
     C                   CLEAR                   ZField
     C                   MOVE      WTotalCtyTax  ZField
 
     C                   CALL      'ZEDIT'
     C                   PARM                    ZField
     C                   PARM      WA6NBDP       ZADec
 
     C                   MOVE      ZFIELD        RTOTCTY
 
     C                   WRITE     ENDER3
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrPageBrk - Write Page Break for Next branch code or       *
      *                receiving country                              *
      *                                                               *
      *****************************************************************
     C     SRWrPageBrk   BEGSR
 
     C                   IF        (TSBRCA <> WPrevBranch and
     C                              WPrevBranch <> *blanks) or
     C                             (TSRCTR <> WPrevRcvCtry and
     C                              WPrevRcvCtry <> *blanks)
 
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrTaxDenHdr - Tax and Denomination Header                  *
      *                                                               *
      *****************************************************************
     C     SRWrTaxDenHdr BEGSR
 
     C                   IF        TSBRCA <> WPrevBranch
 
      ** Move Tax information
 
     C                   EVAL      RTAXYR = PTaxY
     C                   IF        PTaxM# <> 0
     C                   MOVE      TSTAXM        RTAXMO
     C                   ENDIF
     C                   EVAL      RWCTRT = PcryT
 
      ** Get Country of Tax Name.
 
     C                   EVAL      R4CNNM = *blanks
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      TSCTRT        PCncd
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCTRYPD'
     C                   EVAL      DBKEY  = PCncd
     C                   EVAL      DBPGM  = 'SD000768P'
     C                   EVAL      DBASE  = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      R4CNNM = A4CNNM
     C                   ENDIF
 
     C                   EVAL      RSBRCA = TSBRCA
 
      ** Get Branch Name.
 
     C                   EVAL      R8BRNM = *blanks
 
     C**********         CALL      'AOBRCHR0'                                                 CGL035
     C                   CALL      'AOBRCHR1'                                                 CGL035
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      RSBRCA        PBrcd
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL035
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL035
      *
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY  = PBrcd
     C                   EVAL      DBPGM  = 'SD000768P'
     C                   EVAL      DBASE  = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      R8BRNM = A8BRNM
     C                   ENDIF
 
      ** Print HEADP2
 
     C                   WRITE     HEADP2
 
      ** Get Name and Denomination of Internal Customer.
 
     C**********         CALL      'AOACUSR0'                                                 234295
     C**********         PARM      *Blanks       PRtcd                                        234295
     C**********         PARM      '*KEY   '     POptn                                        234295
     C**********         PARM      A8BICN        PAcus                                        234295
     C*****SDACUS        PARM      SDACUS        DSSDY                                        234295
      **********                                                                              234295
     C**********         IF        PRtcd <> *Blanks                                           234295
     C******LOCK         IN        LDA                                                        234295
     C**********         EVAL      DBFILE = 'SDACUSPD'                                        234295
     C**********         EVAL      DBKEY  = PAcus                                             234295
     C**********         EVAL      DBPGM  = 'SD000768P'                                       234295
     C**********         EVAL      DBASE  = 006                                               234295
     C**********         OUT       LDA                                                        234295
     C**********         EXSR      *PSSR                                                      234295
      **********                                                                              234295
     C**********         ELSE                                                                 234295
     C**********         EVAL      R5CNA1 = E5CNA1                                            234295
     C**********         EVAL      R5CNA2 = E5CNA2                                            234295
     C**********         EVAL      R5CN34 = %Trim(E5CNA3) + ' ' + %Trim(E5CNA4)               234295
     C**********         EVAL      R5ZIPC = E5ZIPC                                            234295
     C**********         EVAL      R5CITY = E5CITY                                            234295
     C**********         ENDIF                                                                234295
 
      * Get the Receiving Country of the Paying Agent.
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      A8BICN        PCust
     C                   PARM      *Blanks       PKeySts
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C*********          IF        PRtcd <> *Blanks                                   237337
     C                   IF        PRTCD <> *Blanks AND PRTCD <> '*CUSDEL'            237337
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY  = PCust
     C                   EVAL      DBPGM  = 'SD000768P'
     C                   EVAL      DBASE  = 007
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      RBCOLC = BBCOLC
     C                   EVAL      R5CNA1 = BBCNA1                                            234295
     C                   ENDIF
 
      * Get the Receiving Country Name.
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BBCOLC        PCncd
     C     SDCTRY        PARM      SDCTRY        DSFDY
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY  = PCncd
     C                   EVAL      DBPGM  = 'SD000768P'
     C                   EVAL      DBASE  = 008
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      R4CNNM = A4CNNM
     C                   ENDIF
 
      ** Print HEADP3
 
     C                   WRITE     HEADP3
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBnfcryHdr- Beneficiary Header                              *
      *                                                               *
      *****************************************************************
     C     SRBnfcryHdr   BEGSR
 
     C                   IF        TSBRCA <> WPrevBranch   or
     C                             TSRCTR <> WPrevRcvCtry
     C                   WRITE     HEADP4
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrBnfcryDtl- Write Detail 1                                *
      *                                                               *
      *****************************************************************
     C     SRWrBnfcryDtl BEGSR
 
     C                   IF        (TSNAHO <> WPrevNAHO and
     C                             TSCUST = *blanks) or
     C                             (TSCUST <> WPrevCUST and
     C                             TSNAHO = *blanks)
      ** check for overflow
 
     C                   EVAL      RqdLn1 = 6
      **********                                                                     CER048 BUG23670
     C**********         IF        CER048 = 'Y'                                      CER048 BUG23670
     C**********         EVAL      RqdLn1 = 8                                        CER048 BUG23670
     C**********         ENDIF                                                       CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   WRITE     HEADP4
     C                   ENDIF
 
     C     TSCUST        CASNE     *Blanks       SRRtvCustDtl
     C     TSNAHO        CASNE     *Blanks       SRRtvNAHODtl
     C                   ENDCS
      **********                                                                     CER048 BUG23670
     C**********         IF        CER048 = 'Y'                                      CER048 BUG23670
     C**********         EXSR      SRSecTDet                                         CER048 BUG23670
     C**********         ENDIF                                                       CER048 BUG23670
      **********                                                                     CER048 BUG23670
 
     C                   EVAL      RHCOLC = TSRCTR
 
     C                   WRITE     DETAIL1
     C                   ENDIF
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvCustDtl -  Customer Details                             *
      *                                                               *
      *****************************************************************
     C     SRRtvCustDtl  BEGSR
 
      ** Get the Identity of Beneficiary.
 
     C                   CALL      'AOACUSR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      TSCUST        PAcus
     C     SDACUS        PARM      SDACUS        DSSDY
      *
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDACUSPD'
     C                   EVAL      DBKEY  = PAcus
     C                   EVAL      DBPGM  = 'SD000768P'
     C                   EVAL      DBASE  = 009
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      RHNAHO = TSCUST
     C                   EVAL      RHIDE1 = E5CNA1
     C                   EVAL      R5TINO = E5TINO
     C                   EVAL      RHIDE2 = E5CNA2
     C                   EVAL      R5DBTH = E5DBTH
     C                   EVAL      R5BTHT = E5BTHT
     C                   EVAL      R5BTHC = E5BTHC
     C                   EVAL      RHID34 = %Trim(E5CNA3) + ' ' + %Trim(E5CNA4)
     C                   EVAL      RHZIPC = E5ZIPC
     C                   EVAL      RHCITY = E5CITY
     C                   ENDIF
 
      * Get the Receiving Country Name.
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      TSRCTR        PCncd
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY  = PCncd
     C                   EVAL      DBPGM  = 'SD000768P'
     C                   EVAL      DBASE  = 010
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      RHCNNM = A4CNNM
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvNAHODtl- NAHO (Non-Account Holder) Details              *
      *                                                               *
      *****************************************************************
 
     C     SRRtvNAHODtl  BEGSR
 
      ** Get the Identity of Beneficiary (Non-Account Holder).
 
     C                   CALL      'AONAHOR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      TSNAHO        PNaho
     C*****SDNAHO        PARM      SDNAHO        DSSDY                                      BUG24029
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      BUG24029
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDNAHOPD'
     C                   EVAL      DBKEY  = PNaho
     C                   EVAL      DBPGM  = 'SD000768P'
     C                   EVAL      DBASE  = 012
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      RHNAHO = TSNAHO
     C                   EVAL      RHIDE1 = NHIDe1
     C                   EVAL      R5TINO = NHTINO
     C                   EVAL      RHIDE2 = NHIDE2
     C                   EVAL      R5DBTH = NHDBTH
     C                   EVAL      R5BTHT = NHBTHT
     C                   EVAL      R5BTHC = NHBTHC
     C                   EVAL      RHID34 = %Trim(NHIDE3) + ' ' +  %Trim(NHIDE4)
     C                   EVAL      RHZIPC = NHZIPC
     C                   EVAL      RHCITY = NHCITY
     C                   ENDIF
 
      * Get the Receiving Country Name.
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      TSRCTR        PCncd
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCTRYPD'
     C                   EVAL      DBKEY  = PCncd
     C                   EVAL      DBPGM  = 'SD000768P'
     C                   EVAL      DBASE  = 013
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      RHCNNM = A4CNNM
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
     C                   OPEN      SD000768AU
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   EVAL      ZSnumU = SFNUMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSERR         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   IF        *INU7 = *ON
     C                   WRITE     HEADAU
     C                   WRITE     DBERROR
     C                   ELSE
     C                   WRITE     HEADAU
     C                   IF        WNoRec = *Zeros
     C                   WRITE     NODTLS
     C                   ELSE
     C                   WRITE     CONTROL
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    SEnty
     C                   PARM                    PData
 
 
     C                   IF        PTaxM# = 0
     C                   EVAL      RTITLE = 'EXCHANGE OF INFORMATION YEARLY'
     C                             + ' DETAILED REPORT'
     C                   ELSE
     C                   EVAL      RTITLE = 'EXCHANGE OF INFORMATION MONTHL'
     C                             + 'Y DETAILED REPORT'
     C                   ENDIF
 
     C     KList1        KLIST
     C                   KFLD                    PCryT
 
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error.
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
 
      ** Get the No. of decimal places in Currency File.
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BJLCCY        POccy
     C     SDCURR        PARM      SDCURR        DSSDY
     C
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = POptn
     C                   EVAL      DBPGM  = 'SD000768P'
     C                   EVAL      DBASE  = 014
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      WA6NBDP = A6NBDP
     C                   ENDIF
     C                   ENDIF
      **********                                                                     CER048 BUG23670
     C**********         CALL      'AOSARDR0'                                        CER048 BUG23670
     C**********         PARM      *BLANKS       PRtcd                               CER048 BUG23670
     C**********         PARM      '*VERIFY'     POptn                               CER048 BUG23670
     C**********         PARM      'CER048'      PSard                               CER048 BUG23670
     C*****SCSARD        PARM      SCSARD        DSFDY                               CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         IF        PRtcd = *BLANKS                                   CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         EVAL      CER048 = 'Y'                                      CER048 BUG23670
     C**********         EVAL      *IN36 = *ON                                       CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         ELSE                                                        CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         EVAL      CER048 = 'N'                                      CER048 BUG23670
     C**********         EVAL      *IN36 = *OFF                                      CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         ENDIF                                                       CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         IF        PRtcd <> *BLANKS AND                              CER048 BUG23670
     C**********                   PRtcd <> '*NRF'                                   CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C******LOCK         IN        LDA                                               CER048 BUG23670
     C**********         EVAL      DBKey = 'CER048'                                  CER048 BUG23670
     C**********         EVAL      DBFile = 'SCSARDPD'                               CER048 BUG23670
     C**********         EVAL      DBase = 016                                       CER048 BUG23670
     C**********         OUT       LDA                                               CER048 BUG23670
     C**********         EXSR      *PSSR                                             CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         ENDIF                                                       CER048 BUG23670
      **********                                                                     CER048 BUG23670
 
      ** Report Work fields.
 
     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PRTLN1 = 0
 
     C                   ENDSR
 
      *****************************************************************              CER048 BUG23670
      ***/EJECT*                                                                     CER048 BUG23670
      *****************************************************************              CER048 BUG23670
      **********                                                      *              CER048 BUG23670
      ***SRSecTDet: Subroutine to Populate Secondary Tax details      *              CER048 BUG23670
      **********                                                      *              CER048 BUG23670
      ***Called*By: SRWrBnfcryDtl                                     *              CER048 BUG23670
      **********                                                      *              CER048 BUG23670
      ***Calls:*None                                                  *              CER048 BUG23670
      **********                                                      *              CER048 BUG23670
      *****************************************************************              CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C*****SRSecTDet     BEGSR                                                       CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         MOVEL     TSSTXB        RSTXB                               CER048 BUG23670
     C**********         MOVEL     TSSTAC        RSTAC                               CER048 BUG23670
     C**********         MOVEL     TSSTRA        RSTRT                               CER048 BUG23670
      **********                                                                     CER048 BUG23670
      ***Populate secondary tax deducted at src in orig ccy                          CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         EVAL      PDecs = TSOCDP                                    CER048 BUG23670
     C**********         EVAL      PFld15 = TSSTDO                                   CER048 BUG23670
     C**********         EXSR      SRFmtA                                            CER048 BUG23670
     C**********         EVAL      RSTDO = POut21                                    CER048 BUG23670
      **********                                                                     CER048 BUG23670
      ***Populate secondary tax deducted at src in set ccy                           CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         EVAL      PDecs = TSSCDP                                    CER048 BUG23670
     C**********         EVAL      PFld15 = TSSTDS                                   CER048 BUG23670
     C**********         EXSR      SRFmtA                                            CER048 BUG23670
     C**********         EVAL      RSTDS = POut21                                    CER048 BUG23670
      **********                                                                     CER048 BUG23670
      ***Secondary tax deducted at src in tax ccy                                    CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         EVAL      PDecs = TSTCDP                                    CER048 BUG23670
     C**********         EVAL      PFld15 = TSSTDT                                   CER048 BUG23670
     C**********         EXSR      SRFmtA                                            CER048 BUG23670
     C**********         EVAL      RSTDT = POut21                                    CER048 BUG23670
      **********                                                                     CER048 BUG23670
      ***Secondary tax deducted at src in base ccy                                   CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         EVAL      PDecs = WA6NBDP                                   CER048 BUG23670
     C**********         EVAL      PFld15 = TSSTDB                                   CER048 BUG23670
     C**********         EXSR      SRFmtA                                            CER048 BUG23670
     C**********         EVAL      RSTDB = POut21                                    CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         ENDSR                                                       CER048 BUG23670
      **********                                                                     CER048 BUG23670
      *****************************************************************              CER048 BUG23670
      ***/EJECT*                                                                     CER048 BUG23670
      *****************************************************************              CER048 BUG23670
      **********                                                      *              CER048 BUG23670
      ***SRFmtA: Format Amount for output                             *              CER048 BUG23670
      **********                                                      *              CER048 BUG23670
      ***Called*by: SRSecTDet                                         *              CER048 BUG23670
      **********                                                      *              CER048 BUG23670
      ***Calls:*None                                                  *              CER048 BUG23670
      **********                                                      *              CER048 BUG23670
      *****************************************************************              CER048 BUG23670
     C*****SRFmtA        BEGSR                                                       CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         EVAL      PECode = 'J'                                      CER048 BUG23670
     C**********         EVAL      PEChar = *BLANKS                                  CER048 BUG23670
     C**********         EVAL      POut21 = *ZEROS                                   CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         CALLB     'ZSEDITF'                                         CER048 BUG23670
     C**********         PARM                    PFld15                              CER048 BUG23670
     C**********         PARM                    PDecs                               CER048 BUG23670
     C**********         PARM                    PECode                              CER048 BUG23670
     C**********         PARM                    PEChar                              CER048 BUG23670
     C**********         PARM                    POut21                              CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         ENDSR                                                       CER048 BUG23670
      **********                                                                     CER048 BUG23670
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *Blank
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
