     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Exchange of Information Summary Report')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000767P -  Midas SD Exchange of Information Summary Report *
      *                                                               *
      *  Function:  This module reports the Exchange of Information   *
      *             Summary.                                          *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
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
      *                 234303             Date 24Jun05               *
      *                 232543             Date 01Apr05               *
      *                 CGL035             Date 01Mar05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
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
      *  BUG22580 - Fields incorrectly labeled and lengths            *
      *             (Recompile)                                       *
      *  CER034A - LF046 German Features - New Fields and Enquiries   *
      *           (Recompile)                                         *
      *  CER048 - German Features - Taxes                             *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  237337 - Avoid database error if customer deleted (ie,       *
      *           PRTCD = '*CUSDEL')                                  *
      *  CSD027A - Conversion Of Customer Number to Alpha (recompile) *
      *  234303 - Database error 5                                    *
      *  232543 - Fix to CGL032 (Recompile)                           *
      *  CGL035 - EUSD Upgrade to MidasPlus                           *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    02         End of file for SDBRCHL1                        *
      *    10         Toggle switch, use for Header 1                 *
      *****36***      Display Secondry Tax field                      *              CER048 BUG23670
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRProcRtn     - Process Routine                               *
      * SRProceed     - Proceed Processing                            *
      * SRPrintCust   - Print details for Customer                    *
      * SRPrintAcct   - Print details for Non-Account Holder          *
      * SRValidRec    - Validate Record to be Processed               *
      * SRTotalRcvCty - Write Total Receiving Country                 *
      * SRTotalCtyTax - Write Total Country of Tax                    *
      * SRHeader1     - Print Header 1                                *
      * SRHeader2     - Print Header 2                                *
      * SRHeader3     - Print Header 3                                *
      * SRHeader4     - Print Header 4                                *
      * SRHeader5     - Print Header 5                                *
      * SRAudit       - Write Audit Report                            *
      * SREnd         - Write Trailer in Report                       *
      * SRInitialise  - Initialised Variables                         *
      ***SRSecTDet     - Subroutine to Populate Secondary Tax details  *             CER048 BUG23670
      ***SRFmtA*       - Format detail amount based on the currency    *             CER048 BUG23670
      * *INZSR        - Initialise                                    *
      * *PSSR         - Error Processing                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Branch Codes Retrieval
     FSDBRCHL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Customer Income
     FSDCSINL9  IF   E           K DISK    INFSR(*PSSR)
 
      ** SD Exchange of Information Summary Report
     FSD000767P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
 
      ** SD Exchange of Information Summary Report
     FSD000767AUO    E             PRINTER INFDS(SPOOLU)
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
 
      ** Externally described DS for Country Details
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
 
      ** Externally described DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Externally described DS for Branch Details
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
 
      ** Externally described DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D QQDFAC1       E                     EXTFLD(QQDFAC)                                     CGL035
 
      ** Externally described DS for Non-Account Holder details
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
 
      ** Externally described DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access objects - very long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                            BUG24029
      ** DS for access objects - longt data structure                                       BUG24029
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG24029
      **********                                                                     CER048 BUG23670
      ***DS*for*access object AOSARDR0                                               CER048 BUG23670
      **********                                                                     CER048 BUG23670
     D***SCSARD*       E DS                  EXTNAME(SCSARDPD)                       CER048 BUG23670
 
      ** File Information Data Structure for SD000767P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** File Information Data Structure for SD000767AU.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
      ** Input DS
     D PData           DS           100
     D  PTAXYR                 1      4S 0
     D  PTAXMO                 5      6A
     D  PTAXMO#                5      6S 0
     D  PWCTRT                 7      8A
     D  P4CNCD                 9     10A
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             02     02
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
     D***PSard**         S              6A                                           CER048 BUG23670
 
      ** Parameter list fields
     D PLevel          S              1
     D PAct            S              1
     D PCmd            S              1
     D PEnty           S              3
     D PCncd           S              2
     D PBrcd           S              3
     D PAcus           S              6
     D PCust           S             10
     D PKeySts         S              7
     D PNaho           S             10
     D POccy           S              3
 
     D Kctrt           S              2
     D Kbrca           S              3
     D Krctr           S              2
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
     D WReadFlag       S              1    INZ
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
 
     D WSvBranch       S              3    INZ(*loval)
     D WSvCustNo       S              6    INZ(*loval)
     D WSvRcvCty       S              2    INZ(*loval)
     D WSvActHldr      S             10    INZ(*loval)
     D WValRec         S              1    INZ
     D WErrFlg         S              1    INZ
     D WOneValid       S              1    INZ
 
     D WTotalPaid      S             15  0 INZ
     D WTotalRcvCty    S             15  0 INZ
     D WTotalCtyTax    S             15  0 INZ
      **********                                                                     CER048 BUG23670
     D***CER048*         S              1A                                           CER048 BUG23670
     D***WBNBDP*         S              1P 0                                         CER048 BUG23670
 
 
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
 
      ** Set file pointer to first record and do initial read.
 
     C     *LOVAL        SETLL     SDBRCHL1
     C                   READ      SDBRCHL1                               02
 
     C                   IF        EndOfFile = True
     C                   EXSR      SRAudit
     C                   ENDIF
 
     C                   DOU       EndOfFile = True
 
     C                   EXSR      SRInitialise
     C                   EXSR      SRProcRtn
 
      ** Read next record.
 
     C                   READ      SDBRCHL1                               02
 
     C                   ENDDO
 
     C                   EXSR      SREnd
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcRtn  - Process Routine                                 *
      *                                                               *
      *****************************************************************
 
     C     SRProcRtn     BEGSR
 
     C                   EVAL      Kctrt = PWCTRT
     C                   EVAL      Kbrca = A8BRCD
     C                   EVAL      Krctr = P4CNCD
 
     C                   IF        P4CNCD = *Blanks
     C     KSDCSINL9A    SETLL     SDCSINL9
     C     KSDCSINL9A    READE     SDCSINL9
     C                   ELSE
     C     KSDCSINL9B    SETLL     SDCSINL9
     C     KSDCSINL9B    READE     SDCSINL9
     C                   ENDIF
 
     C                   DOW       Not %Eof
 
      ** Check if Record will be processed.
 
     C                   EXSR      SRValidRec
 
     C                   IF        WValRec = 'Y'
     C                   EXSR      SRProceed
     C                   ENDIF
 
      ** Read next record.
 
     C                   IF        P4CNCD = *Blanks
     C     KSDCSINL9A    READE     SDCSINL9
     C                   ELSE
     C     KSDCSINL9B    READE     SDCSINL9
     C                   ENDIF
 
     C                   ENDDO
 
      ** Process the last valid record.
 
     C                   IF        WOneValid = 'Y' or WValRec = 'Y'
 
     C     WSvCustNo     CASNE     *Blanks       SRPrintCust
     C     WSvActHldr    CASNE     *Blanks       SRPrintAcct
     C                   ENDCS
 
     C                   EXSR      SRTotalRcvCty
     C                   EXSR      SRTotalCtyTax
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProceed  - Proceed Processing                              *
      *                                                               *
      *****************************************************************
 
     C     SRProceed     BEGSR
 
     C                   SELECT
 
      ** When there is a Break in Branch.
 
     C                   WHEN      WSvBranch <> A8BRCD
 
     C                   EVAL      WSvBranch = A8BRCD
     C                   EVAL      WSvRcvCty = TSRCTR
     C                   EVAL      WSvCustNo = TSCUST
     C                   EVAL      WSvActHldr = TSNAHO
 
     C                   EXSR      SRHeader1
     C                   EXSR      SRHeader2
     C                   EXSR      SRHeader3
     C                   EXSR      SRHeader4
 
     C                   EVAL      WOneValid = *Blanks
 
      ** When there is a Break in Receiving Country.
 
     C                   WHEN      WSvRcvCty <> TSRCTR
 
     C     WSvCustNo     CASNE     *Blanks       SRPrintCust
     C     WSvActHldr    CASNE     *Blanks       SRPrintAcct
     C                   ENDCS
 
     C                   EXSR      SRTotalRcvCty
 
     C                   WRITE     HEADP1
     C                   WRITE     HEADP4
 
     C                   EVAL      WSvRcvCty = TSRCTR
     C                   EVAL      WSvCustNo = TSCUST
     C                   EVAL      WSvActHldr = TSNAHO
 
      ** When there is a Break in Customer.
 
     C                   WHEN      WSvRcvCty = TSRCTR and
     C                             WSvActHldr = *Blanks and
     C                             WSvCustNo <> TSCUST
     C
     C                   EXSR      SRPrintCust
 
     C                   EVAL      WSvCustNo = TSCUST
     C                   EVAL      WSvActHldr = TSNAHO
 
      ** When there is a Break in Non-Account Holder.
 
     C                   WHEN      WSvRcvCty = TSRCTR and
     C                             WSvCustno = *Blanks and
     C                             WSvActHldr <> TSNAHO
 
     C                   EXSR      SRPrintAcct
 
     C                   EVAL      WSvCustNo = TSCUST
     C                   EVAL      WSvActHldr = TSNAHO
 
     C                   ENDSL
 
      ** Accumulate the Total Paid or Credited Interest Amount
 
     C                   EVAL      WTotalPaid = WTotalPaid + TSGINB
 
      ** Accumulate the Total Receiving Country
 
     C                   EVAL      WTotalRcvCty = WTotalRcvCty + TSGINB
 
      ** Accumulate the Total for Country of Tax
 
     C                   EVAL      WTotalCtyTax = WTotalCtyTax + TSGINB
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidRec - Validate Record to be Processed                 *
      *                                                               *
      *****************************************************************
 
     C     SRValidRec    BEGSR
     C                   EVAL      WValRec = *Blanks
     C                   EVAL      WErrFlg = *Blanks
 
     C                   SELECT
 
      ** Process only when Customer Status = D.
 
     C                   WHEN      TSSTAT = 'D'
 
      ** Process only when Tax Year(parm) = Tax Year(file).
 
     C                   IF        PTAXYR = TSTAXY
     C                   EVAL      WValRec =  'Y'
     C                   EVAL      WErrFlg = *Blanks
     C                   ELSE
     C                   EVAL      WValRec = *Blanks
     C                   EVAL      WErrFlg = 'Y'
     C                   ENDIF
 
      ** Process only when Tax Month(parm) = Tax Month(file), if Tax Month(parm) has a value.
 
     C                   IF        WErrFlg = *Blanks
 
     C                   IF        PTAXMO <> *Blanks
 
     C                   IF        PTAXMO# = TSTAXM
     C                   EVAL      WValRec =  'Y'
     C                   ELSE
     C                   EVAL      WValRec = *Blanks
     C                   EVAL      WErrFlg =  'Y'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
 
     C                   IF        WErrFlg = *Blanks and
     C                             TSCUST <> *Blanks and
     C                             TSNAHO <> *Blanks
     C                   EVAL      WErrFlg = 'Y'
     C                   ENDIF
 
     C                   IF        WErrFlg = *Blanks
     C                   EVAL      WOneValid = 'Y'
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintCust  -  Print Details for Customer                   *
      *                                                               *
      *****************************************************************
 
     C     SRPrintCust   BEGSR
 
      ** Get the Identity of Beneficiary.
 
     C                   CALL      'AOACUSR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WSvCustNo     PAcus
     C     SDACUS        PARM      SDACUS        DSSDY
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDACUSPD'
     C                   EVAL      DBKEY  = PAcus
     C                   EVAL      DBASE  = 008
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      RHNAHO = WSvCustNo
     C                   EVAL      RHIDE1 = E5CNA1
     C                   EVAL      R5TINO = E5TINO
     C                   EVAL      RHIDE2 = E5CNA2
     C                   EVAL      R5DBTH = E5DBTH
     C                   EVAL      R5BTHT = E5BTHT
     C                   EVAL      R5BTHC = E5BTHC
     C                   EVAL      RHID34 = %Trim(E5CNA3) + ' ' + %Trim(E5CNA4)
     C                   EVAL      RHZIPC = E5ZIPC
     C                   EVAL      RHCITY = E5CITY
     C                   EVAL      RHCOLC = WSvRcvCty
     C                   ENDIF
 
      * Get the Receiving Country Name.
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WSvRcvCty     PCncd
     C     SDCTRY        PARM      SDCTRY        DSFDY
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY  = PCncd
     C                   EVAL      DBASE  = 009
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      RHCNNM = A4CNNM
     C                   ENDIF
 
      ** Get the Total Paid or Credited Amount.
 
     C                   CLEAR                   ZFIELD
     C                   MOVE      WTotalPaid    ZFIELD
 
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC
 
     C                   MOVE      ZFIELD        RTSGINB
      **********                                                                     CER048 BUG23670
     C**********         IF        CER048 = 'Y'                                      CER048 BUG23670
     C**********         EXSR      SRSecTDet                                         CER048 BUG23670
     C**********         ENDIF                                                       CER048 BUG23670
      **********                                                                     CER048 BUG23670
 
 
     C                   EVAL      RqdLn1 = 6
      **********                                                                     CER048 BUG23670
     C**********         IF        CER048 = 'Y'                                      CER048 BUG23670
     C**********         EVAL      RqdLn1 = 8                                        CER048 BUG23670
     C**********         ENDIF                                                       CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
      ** When overflow has occured, print the Header of the report.
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   WRITE     HEADP4
     C                   ENDIF
 
      ** Write Detail
 
     C                   WRITE     DETAIL
 
      ** Initialised Accumulator
 
     C                   CLEAR                   WTotalPaid
 
      ** Record Read Flag
 
     C                   EVAL      WReadFlag = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintAcct - Print Details for Non-Account Holder           *
      *                                                               *
      *****************************************************************
 
     C     SRPrintAcct   BEGSR
 
      ** Get the Identity of Beneficiary (Non-Account Holder).
 
     C                   CALL      'AONAHOR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WSvActHldr    PNaho
     C*****SDNAHO        PARM      SDNAHO        DSSDY                                      BUG24029
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      BUG24029
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDNAHOPD'
     C                   EVAL      DBKEY  = PNaho
     C                   EVAL      DBASE  = 010
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      RHNAHO = WSvActHldr
     C                   EVAL      RHIDE1 = NHIDe1
     C                   EVAL      R5TINO = NHTINO
     C                   EVAL      RHIDE2 = NHIDE2
     C                   EVAL      R5DBTH = NHDBTH
     C                   EVAL      R5BTHT = NHBTHT
     C                   EVAL      R5BTHC = NHBTHC
     C                   EVAL      RHID34 = %Trim(NHIDE3) + ' ' +  %Trim(NHIDE4)
     C                   EVAL      RHZIPC = NHZIPC
     C                   EVAL      RHCITY = NHCITY
     C                   EVAL      RHCOLC = WSvRcvCty
     C                   ENDIF
 
      * Get the Receiving Country Name.
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WSvRcvCty     PCncd
     C     SDCTRY        PARM      SDCTRY        DSFDY
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCTRYPD'
     C                   EVAL      DBKEY  = PCncd
     C                   EVAL      DBASE  = 011
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      RHCNNM = A4CNNM
     C                   ENDIF
 
      ** Get the Total Paid or Credited Amount.
 
     C                   CLEAR                   ZFIELD
     C                   MOVE      WTotalPaid    ZFIELD
 
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC
 
     C                   MOVE      ZFIELD        RTSGINB
      **********                                                                     CER048 BUG23670
     C**********         IF        CER048 = 'Y'                                      CER048 BUG23670
     C**********         EXSR      SRSecTDet                                         CER048 BUG23670
     C**********         ENDIF                                                       CER048 BUG23670
      **********                                                                     CER048 BUG23670
 
     C                   EVAL      RqdLn1 = 6
      **********                                                                     CER048 BUG23670
     C**********         IF        CER048 = 'Y'                                      CER048 BUG23670
     C**********         EVAL      RqdLn1 = 8                                        CER048 BUG23670
     C**********         ENDIF                                                       CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
      ** When overflow has occured, print the Header of the report.
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   WRITE     HEADP4
     C                   ENDIF
 
      ** Write Detail
 
     C                   WRITE     DETAIL
 
      ** Initialised Accumulator
 
     C                   CLEAR                   WTotalPaid
 
      ** Record Read Flag
 
     C                   EVAL      WReadFlag = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHeader1 - Print Header 1                                   *
      *                                                               *
      *****************************************************************
 
     C     SRHeader1     BEGSR
     C                   IF        WOpen <> 'Y'
     C                   EVAL      WOpen = 'Y'
     C                   OPEN      SD000767P1
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = SFNUM1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *Blanks       ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSerr         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
 
      ** Print the Header of the report.
 
     C                   WRITE     HEADP1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHeader2 - Print Header 2                                   *
      *                                                               *
      *****************************************************************
 
     C     SRHeader2     BEGSR
     C                   MOVE      PTAXYR        RTAXYR
     C                   EVAL      RTAXMO = PTAXMO
     C                   EVAL      RWCTRT = PWCTRT
     C                   EVAL      RSBRCA = WSvBranch
 
      ** Get Country of Tax Name.
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      PWCTRT        PCncd
     C     SDCTRY        PARM      SDCTRY        DSFDY
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCTRYPD'
     C                   EVAL      DBKEY  = PCncd
     C                   EVAL      DBASE  = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      R4CNNM = A4CNNM
     C                   ENDIF
 
      ** Get Branch Name.
 
     C**********         CALL      'AOBRCHR0'                                                 CGL035
     C                   CALL      'AOBRCHR1'                                                 CGL035
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WSvBranch     PBrcd
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY  = PBrcd
     C                   EVAL      DBASE  = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      R8BRNM = A8BRNM
     C                   ENDIF
 
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
      ** When overflow has occured, print the Header of the report.
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     Headp2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHeader3 - Print Header 3                                   *
      *                                                               *
      *****************************************************************
 
     C     SRHeader3     BEGSR
 
      ** Get Name and Denomination of Internal Customer.
 
     C**********         CALL      'AOACUSR0'                                                 234303
     C**********         PARM      *Blanks       PRtcd                                        234303
     C**********         PARM      '*KEY   '     POptn                                        234303
     C**********         PARM      A8BICN        PAcus                                        234303
     C*****SDACUS        PARM      SDACUS        DSSDY                                        234303
      **********                                                                              234303
     C**********         IF        PRtcd <> *Blanks                                           234303
     C******LOCK         IN        LDA                                                        234303
     C**********         EVAL      DBFILE = 'SDACUSPD'                                        234303
     C**********         EVAL      DBKEY  = PAcus                                             234303
     C**********         EVAL      DBASE  = 005                                               234303
     C**********         OUT       LDA                                                        234303
     C**********         EXSR      *PSSR                                                      234303
      **********                                                                              234303
     C**********         ELSE                                                                 234303
     C**********         EVAL      R5CNA1 = E5CNA1                                            234303
     C**********         EVAL      R5CNA2 = E5CNA2                                            234303
     C**********         EVAL      R5CN34 = %Trim(E5CNA3) + ' ' + %Trim(E5CNA4)               234303
     C**********         EVAL      R5ZIPC = E5ZIPC                                            234303
     C**********         EVAL      R5CITY = E5CITY                                            234303
     C**********         ENDIF                                                                234303
 
      ** Get the Receiving Country of the Paying Agent.
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      A8BICN        PCust
     C                   PARM      *Blanks       PKeySts
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C*********          IF        PRtcd <> *Blanks                                   237337
     C                   IF        PRTCD <> *Blanks AND PRTCD <> '*CUSDEL'            237337
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY  = PCust
     C                   EVAL      DBASE  = 006
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      RBCOLC = BBCOLC
     C                   EVAL      R5CNA1 = BBCNA1                                            234303
     C                   ENDIF
 
      ** Get the Receiving Country Name.
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BBCOLC        PCncd
     C     SDCTRY        PARM      SDCTRY        DSFDY
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY  = PCncd
     C                   EVAL      DBASE  = 007
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      R4CNNM = A4CNNM
     C                   ENDIF
 
     C                   EVAL      RqdLn1 = 6
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
      ** When overflow has occured, print the Header of the report.
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     HEADP3
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHeader4 - Print Header 4                                   *
      *                                                               *
      *****************************************************************
 
     C     SRHeader4     BEGSR
     C                   EVAL      RqdLn1 = 3
      **********                                                                     CER048 BUG23670
     C**********         IF        CER048 = 'Y'                                      CER048 BUG23670
     C**********         EVAL      RqdLn1 = 7                                        CER048 BUG23670
     C**********         ENDIF                                                       CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
      ** When overflow has occured, print the Header of the report.
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     HEADP4
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTotalRcvCty - Write Total Receiving Country                *
      *                                                               *
      *****************************************************************
 
     C     SRTotalRcvCty BEGSR
 
     C                   EVAL      RHCOLC = WSvRcvCty
 
      ** Get the Total for Receiving Country.
 
     C                   CLEAR                   ZFIELD
     C                   MOVE      WTotalRcvCty  ZFIELD
 
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC
 
     C                   MOVE      ZFIELD        RTOTRCV
 
     C                   EVAL      RqdLn1 = 2
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
      ** When overflow has occured, print the Header of the report.
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   WRITE     HEADP4
     C                   ENDIF
 
     C                   WRITE     ENDER1
 
      ** Initialized Accumulator
 
     C                   CLEAR                   WTotalRcvCty
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTotalCtyTax -  Write Total Country of Tax                  *
      *                                                               *
      *****************************************************************
 
     C     SRTotalCtyTax BEGSR
 
     C                   EVAL      RWCTRT = PWCTRT
 
     C                   CLEAR                   ZFIELD
     C                   MOVE      WTotalCtyTax  ZFIELD
 
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC
 
     C                   MOVE      ZFIELD        RTOTCTY
 
     C                   EVAL      RqdLn1 = 2
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
      ** When overflow has occured, print the Header of the report.
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   WRITE     HEADP4
     C                   ENDIF
 
     C                   WRITE     ENDER2
 
      ** Initialized Accumulator
 
     C                   CLEAR                   WTotalCtyTax
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitialise - Initialised Variables                         *
      *                                                               *
      *****************************************************************
 
     C     SRInitialise  BEGSR
     C                   CLEAR                   WValRec
     C                   CLEAR                   WOneValid
     C                   CLEAR                   WErrFlg
 
     C                   CLEAR                   WTotalPaid
     C                   CLEAR                   WTotalRcvCty
     C                   CLEAR                   WTotalCtyTax
 
     C                   EVAL      WSvBranch = *loval
     C                   EVAL      WSvCustNo = *loval
     C                   EVAL      WSvRcvCty = *loval
     C                   EVAL      WSvActHldr = *loval
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - Write Trailer in Report                              *
      *                                                               *
      *****************************************************************
 
     C     SREnd         BEGSR
 
     C                   IF        WReadFlag = 'Y'
 
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out report trailer.
 
     C                   WRITE     TRAILP1
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ELSE
 
      ** Write audit report.
 
     C                   EXSR      SRAudit
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write Audit Report                                 *
      *                                                               *
      *****************************************************************
 
     C     SRAudit       BEGSR
 
     C                   OPEN      SD000767AU
 
      ** Ensure No Record Spool File recorded by RCF.
 
     C                   EVAL      ZSnumU = SFNUMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *Blanks       ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSerr         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** Or, if no records read, Output "No Details" message.
 
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************              CER048 BUG23670
      **********                                                      *              CER048 BUG23670
      ***SRSecTDet: Subroutine to Populate Secondary Tax details      *              CER048 BUG23670
      **********                                                      *              CER048 BUG23670
      ***Called*by: SRPrintCust, SRPrintAcct                          *              CER048 BUG23670
      **********                                                      *              CER048 BUG23670
      ***Calls:*None                                                  *              CER048 BUG23670
      **********                                                      *              CER048 BUG23670
      *****************************************************************              CER048 BUG23670
     C*****SRSecTDet     BEGSR                                                       CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         MOVEL     TSSTXB        RSTXB                               CER048 BUG23670
     C**********         MOVEL     TSSTAC        RSTAC                               CER048 BUG23670
     C**********         MOVEL     TSSTRA        RSTRT                               CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         EVAL      PDecs = TSOCDP                                    CER048 BUG23670
     C**********         EVAL      PFld15 = TSSTDO                                   CER048 BUG23670
     C**********         EXSR      SRFmtA                                            CER048 BUG23670
     C**********         EVAL      RSTDO = POut21                                    CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         EVAL      PDecs = TSSCDP                                    CER048 BUG23670
     C**********         EVAL      PFld15 = TSSTDS                                   CER048 BUG23670
     C**********         EXSR      SRFmtA                                            CER048 BUG23670
     C**********         EVAL      RSTDS = POut21                                    CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         EVAL      PDecs = TSTCDP                                    CER048 BUG23670
     C**********         EVAL      PFld15 = TSSTDT                                   CER048 BUG23670
     C**********         EXSR      SRFmtA                                            CER048 BUG23670
     C**********         EVAL      RSTDT = POut21                                    CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         EVAL      PDecs = WBNBDP                                    CER048 BUG23670
     C**********         EVAL      PFld15 = TSSTDB                                   CER048 BUG23670
     C**********         EXSR      SRFmtA                                            CER048 BUG23670
     C**********         EVAL      RSTDB = POut21                                    CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         ENDSR                                                       CER048 BUG23670
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
     C**********         EVAL      POUT21 = *ZEROS                                   CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         CALLB     'ZSEDITF'                                         CER048 BUG23670
     C**********         PARM                    PFld15                              CER048 BUG23670
     C**********         PARM                    PDecs                               CER048 BUG23670
     C**********         PARM                    PECode                              CER048 BUG23670
     C**********         PARM                    PEChar                              CER048 BUG23670
     C**********         PARM                    POut21                              CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         ENDSR                                                       CER048 BUG23670
      *****************************************************************              CER048 BUG23670
      ***/EJECT*                                                                     CER048 BUG23670
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
     C                   PARM                    PEnty
     C                   PARM                    PData
 
     C     KSDCSINL9A    KLIST
     C                   KFLD                    Kctrt
     C                   KFLD                    Kbrca
 
     C     KSDCSINL9B    KLIST
     C                   KFLD                    Kctrt
     C                   KFLD                    Kbrca
     C                   KFLD                    Krctr
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
     C                   CALLB     'AOBANKR0'
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
     C                   ENDIF
 
      ** Get the No. of decimal places in Currency File.
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BJCYCD        POccy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = POccy
     C                   EVAL      DBASE  = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C**********         ELSE                                                        CER048 BUG23670
     C**********         EVAL      WBNBDP = A6NBDP                                   CER048 BUG23670
     C                   ENDIF
      **********                                                                     CER048 BUG23670
     C**********         CALL      'AOSARDR0'                                        CER048 BUG23670
     C**********         PARM      *BLANKS       PRtcd                               CER048 BUG23670
     C**********         PARM      '*VERIFY'     POptn                               CER048 BUG23670
     C**********         PARM      'CER048'      PSard                               CER048 BUG23670
     C*****SCSARD        PARM      SCSARD        DSFDY                               CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         IF        PRtCd = *BLANKS                                   CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         EVAL      CER048 = 'Y'                                      CER048 BUG23670
     C**********         EVAL      *IN36 = *ON                                       CER048 BUG23670
     C**********         ELSE                                                        CER048 BUG23670
     C**********         EVAL      CER048 = 'N'                                      CER048 BUG23670
     C**********         EVAL      *IN36 = *OFF                                      CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         ENDIF                                                       CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         IF        PRtCd <> *BLANKS AND                              CER048 BUG23670
     C**********                   PRtCd <> '*NRF'                                   CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C******LOCK         IN        LDA                                               CER048 BUG23670
     C**********         EVAL      DBFile = 'SCSARDPD'                               CER048 BUG23670
     C**********         EVAL      DBKey = 'CER048'                                  CER048 BUG23670
     C**********         EVAL      DBase = 012                                       CER048 BUG23670
     C**********         OUT       LDA                                               CER048 BUG23670
     C**********         EXSR      *PSSR                                             CER048 BUG23670
      **********                                                                     CER048 BUG23670
     C**********         ENDIF                                                       CER048 BUG23670
      **********                                                                     CER048 BUG23670
 
      ** Report Work fields.
 
     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PRTLN1 = 0
 
     C                   IF        PTAXMO = *Blanks
     C                   EVAL      *IN10 = *OFF
     C                   ELSE
     C                   EVAL      *IN10 = *ON
     C                   ENDIF
 
     C                   ENDSR
 
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
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
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
(c) Finastra International Limited 2004
