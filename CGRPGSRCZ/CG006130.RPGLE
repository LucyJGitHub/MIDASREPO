     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Tax Self Declaration Statement')              *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG006130 - Midas CG Tax Self Declaration Statement           *
      *                                                               *
      *  Function:  This program produces the Tax Self Declaration    *
      *             Statement onto the UDC extract files.             *
      *                                                               *
      *  Called By: CG006120 - Midas CG Tax Self Declaration          *
      *                        Statement Driver                       *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23123           Date 09Mar09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 236193             Date 19Sep05               *
      *                 234897             Date 12Aug05               *
      *                 234502             Date 20Jul05               *
      *                 232543             Date 11Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23123 - Report: Does not show Retail Account Number       *
      *                     Date is not Midas Standard Date           *
      *                     Period should be actual int. calc. period *
      *                     Secondary Tax amount is not printed       *
      *                     Added field TSSLID                        *
      *                     (Recompile)                               *
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build)   *
      *  236193 - Correct date format.                                *
      *           Review repeating data extract.                      *
      *  234897 - Extract correct Correspondent                       *
      *  234502 - Use branch from SDCUSTPD instead of hardcoded "DOM" *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Customer Income by Cust#, Curr, Pymnt date, Modid, Instr ref
     FSDCSINL2  IF   E           K DISK    INFSR(*PSSR)
 
      ** Customer Income by non-account holder#, Curr, Pymnt date
     FSDCSINL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCSIND0:SDCSIND3)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** Print Item Type
     D WCPrtItmTyp     C                   CONST('STATEMENT')
 
      ** Print Item Sub-Type
     D WCPrtItmSubTyp  C                   CONST('TAX_SLFDEC')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Data strucutre for access objects, short DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Data structure for access objects, long DS
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Data structure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Data structure for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Data structure for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Data structure for UDC data reference file
     D PEDsCGUDCRPD  E DS                  EXTNAME(CGUDCRPD)
 
      ** Data structure for UDC extracted data file
     D PEDsCGUDTAPD  E DS                  EXTNAME(CGUDTAPD)
 
      ** Data Structure of Parameters Passed from CG006120
     D DSPARM          DS
     D  PTaxYear               1      4  0
     D  PRef                   5     14
     D  PRefInd               15     15
     D  PRepName              16     35
     D  PRepTown              36     45
     D  PBranch               46     48                                                       234502
 
      ** Multi-occurence data structure to store subroutine specific data
     D WMDsSRDT        DS                  OCCURS(20)
     D  WMDsPrevBnd            1      5  0
     D  WMDsThisBnd            6     10  0
     D  WMDsPathGrp           11     80
 
      ** General data structure to define fields that need to share data
     D                 DS
     D WGrp10                  1     10
     D  WGrpNme                1      6
     D  WGrpSeq                7     10S 0
     D  WAr20                 21     40    DIM(20)
     D  WNum20                21     40  0
     D  WAr29                 51     79    DIM(29)
 
     D  ##SDS          DS          5120
 
      ** Compile-time array to contain RDE definitions
     D*WTbGrp***       S             10    DIM(19) CTDATA PERRCD(1)                           232543
     D*WTbRDE***       S             22    DIM(19) ALT(WTbGrp)                                232543
     D WTbGrp          S             10    DIM(17) CTDATA PERRCD(1)                           232543
     D WTbRDE          S             22    DIM(17) ALT(WTbGrp)                                232543
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** String that contains the concatenated path
     D W0PATH          S            256A
 
      ** Confirmation Text code
     D ##ITEM          S              8  0
 
      ** General purpose variables
     D Wx1             S              3P 0
     D Wx2             S              3P 0
     D Wx3             S              3P 0
     D Colon           S             11A
 
      ** Parameter fields
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D PCurrency       S              3A
     D PAction8        S              8A
     D PCustNumChr6    S              6A
     D PItmRef         S              8A
     D PMode           S             10A
     D PRtnCode        S              7A
     D W0CMT           S              3A
     D WProduce        S              1A
     D WAUTO           S              1A
     D W0SPAT          S             70A
 
      ** Work Variables
     D CCG015          S              1A
     D WCurrency       S              3A
     D WDlln           S              6A
     D WAcod           S              4A
     D WAcsq           S              2A
     D WTType          S             13A
     D WDateDD         S              2A
     D WDateMM         S              2A
     D WDateYY         S              2A
     D WIpdt           S              6A
     D WTPAMS          S                   Like(TSPAMS)
     D WTGINS          S                   Like(TSGINS)
     D*WTNINS***       S                   Like(TSNINS)                                       232543
     D WTPAMB          S                   Like(TSPAMB)
     D WTGINB          S                   Like(TSGINB)
     D*WTNINB***       S                   Like(TSNINB)                                       232543
     D WBCcyPl         S                   Like(A6NBDP)
     D WSCcyPl         S                   Like(A6NBDP)
 
     D ##PNAM          S              7A
     D ##RFMT          S              1A
     D WPathStr        S            256A
     D ZDAYNO          S              5P 0                                                    236193
     D ErrorFlag       S              7A                                                      236193
 
     D/COPY CGCPYSRC,CGPACKDLE
      ** Data pack arrays and data structures
 
     D/COPY CGCPYSRC,SRERRDLE
      ** Fields, data structures, arrays definition for
      ** CG error processing
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'MAIN      '  @STK(Q)
 
      ** Initialisation Processing
 
     C                   EXSR      SRInit
 
      ** Tax Main Processing - top level group set
 
     C                   EXSR      SrTaxMain
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
      ** Termination
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTaxMain - Top Level Group Set                              *
      *                                                               *
      *****************************************************************
     C     SrTaxMain     BEGSR
 
      ** Set up subroutine stack name.
 
     C                   ADD       1             Q
     C                   MOVEL     'SrTaxMain '  @STK(Q)
 
      ** Retrieve subroutine specific data.
 
     C     1             OCCUR     WMDsSRDT
 
      ** Set up path.
 
     C                   MOVEL     '\TAXMAN'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      WMDsPathGrp
 
      ** Set up Binds from passed in values.
 
     C                   Z-ADD     S#PBIN        WMDsPrevBnd
     C                   Z-ADD     S#TBIN        WMDsThisBnd
 
      ** Generate reference number by writing to PF/CGUDCRPD.
 
     C                   EXSR      SrGenRef
 
     C                   If        WProduce = 'Y'                                             236193
                                                                                              236193
     C                   EXSR      PSHGRS
 
      ** Header (Simple)
 
     C                   EXSR      SrHdrDet
     C     1             OCCUR     WMDsSRDT
     C                   MOVEL     WMDsPathGrp   WPathStr
     C                   Z-ADD     WMDsPrevBnd   S#PBIN
     C                   Z-ADD     WMDsThisBnd   S#TBIN
 
      ** Tax Details (complex)
 
     C                   EXSR      SRTaxDet
     C     1             OCCUR     WMDsSRDT
     C                   MOVEL     WMDsPathGrp   WPathStr
     C                   Z-ADD     WMDsPrevBnd   S#PBIN
     C                   Z-ADD     WMDsThisBnd   S#TBIN
 
      ** Reference Totals (simple)
 
     C                   IF        WCurrency <> *BLANK
 
     C                   EXSR      SrRefTot
     C     3             OCCUR     WMDsSRDT
     C                   MOVEL     WMDsPathGrp   WPathStr
     C                   Z-ADD     WMDsPrevBnd   S#PBIN
     C                   Z-ADD     WMDsThisBnd   S#TBIN
 
     C                   ENDIF
 
      ** Unwind subroutine stack name
 
     C                   EXSR      POPGRS
                                                                                              236193
     C                   Endif                                                                236193
                                                                                              236193
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrHdrDet - Header Details.                                   *
      *                                                               *
      *****************************************************************
     C     SrHdrDet      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrHdrDet  '  @STK(Q)
 
      ** Retrieve subroutine specific data.
 
     C     2             OCCUR     WMDsSRDT
 
      ** Set up path.
 
     C                   MOVEL     '\TAXHDR'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   EXSR      PSHGRS
     C                   MOVEL     WPathStr      WMDsPathGrp
 
      ** Set up Binds from passed in values.
 
     C                   Z-ADD     S#PBIN        WMDsPrevBnd
     C                   Z-ADD     S#TBIN        WMDsThisBnd
 
      ** Retrieve RDE info
 
     C                   MOVEL     'TAXHDR'      WGrpNme
     C                   EXSR      SrRtvRDE
 
      ** Rundate
 
     C**********         MOVEL     BJMRDT        ##D(1)                                       236193
     C                   MOVEL     BJRDNB        ##D(1)                                       236193
 
      ** Tax Year
 
     C                   MOVEL     PTaxYear      ##D(2)
 
      ** Customer Reference
 
     C                   MOVEL     PRef          ##D(3)
 
      ** Report Name
 
     C                   MOVEL     PRepName      ##D(4)
 
      ** Report Town
 
     C                   MOVEL     PRepTown      ##D(5)
 
      ** Report Title                                                                         232543
                                                                                              232543
     C                   MOVEL     BJURPT        ##D(6)                                       232543
                                                                                              232543
      ** Setup First/Subsequent/Last Indicator
 
     C                   MOVE      'FR'          ##FSLI
 
      ** Accumulate RDEs and associated data and output to CGUDTAPD
 
     C                   EXSR      SrADTA
     C                   EXSR      SrODTA
 
      ** Unwind subroutine stack name
 
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTaxDet - Tax Details (complex)                             *
      *                                                               *
      *****************************************************************
     C     SrTaxDet      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrTaxDet  '  @STK(Q)
 
      ** Retrieve subroutine specific data.
 
     C     3             OCCUR     WMDsSRDT
 
      ** Set up path.
 
     C                   MOVEL     '\TAXDET'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   EXSR      PSHGRS
     C                   MOVEL     WPathStr      WMDsPathGrp
 
      ** Set up Binds from passed in values.
 
     C                   Z-ADD     S#PBIN        WMDsPrevBnd
     C                   Z-ADD     S#TBIN        WMDsThisBnd
 
      ** Access Customer Income File
 
     C                   SELECT
     C                   WHEN      PRefInd = 'C'
     C******LOVAL        SETLL     SDCSINL2                                                   234897
     C**********         READ      SDCSINL2                               15                  234897
      ** Read only relevant records for this customer.                                        234897
     C     PCustNumChr6  SETLL     SDCSINL2                                                   234897
     C     PCustNumChr6  READE     SDCSINL2                               15                  234897
     C                   WHEN      PRefInd = 'N'
     C******LOVAL        SETLL     SDCSINL3                                                   234897
     C**********         READ      SDCSINL3                               15                  234897
      ** Read only relevant records for this non-a/c holder.                                  234897
     C     PRef          SETLL     SDCSINL3                                                   234897
     C     PRef          READE     SDCSINL3                               15                  234897
     C                   ENDSL
     C                   MOVEL     'N'           FIRST             1                          236193
 
     C                   DOW       *IN15 = *OFF
 
     C                   IF        TSTAXY = PTaxYear AND
     C                             TSSTAT = 'S'
 
     C                   IF        PRefInd = 'C' AND
     C                             TSCUST = PRef OR
     C                             PRefInd = 'N' AND
     C                             TSNAHO = PRef
 
      ** Ccy Total Details (simple)
 
     C                   IF        TSSCCY <> WCurrency AND
     C                             WCurrency <> *BLANKS
 
      ** The last record for the currency has been processed,
      ** set the First/Last/Subsequent flags accordingly then
      ** process the record.
 
     C                   IF        ##RFMT = 'Y'
     C                   MOVE      'LA'          DEFSLI
     C                   EXSR      SRODTA
     C                   ENDIF
 
     C                   Z-ADD     S#PBINB       S#PBIN
     C                   Z-ADD     S#TBINB       S#TBIN
     C                   EXSR      SrCcyTot
     C     3             OCCUR     WMDsSRDT
     C                   MOVEL     WMDsPathGrp   WPathStr
     C                   Z-ADD     WMDsPrevBnd   S#PBIN
     C                   Z-ADD     WMDsThisBnd   S#TBIN
 
     C                   EXSR      POPGRS                                       236193
     C                   EXSR      PSHGRS                                       236193
     C                   MOVEL     'Y'           FIRST                          236193
                                                                                236193
     C                   ENDIF
 
      ** Currency Details (simple)
 
     C                   IF        TSSCCY <> WCurrency
 
      ** Increment Bind Levels.
 
     C                   Z-ADD     WMDsThisBnd   S#PBIN
     C                   Z-ADD     S#PBIN        S#PBINB
     C                   ADD       1             ##BNDA
     C                   Z-ADD     ##BNDA        S#TBIN
     C                   Z-ADD     S#TBIN        S#TBINB
 
     C                   EXSR      SrCcyDet
     C     3             OCCUR     WMDsSRDT
     C                   MOVEL     WMDsPathGrp   WPathStr
     C                   Z-ADD     WMDsPrevBnd   S#PBIN
     C                   Z-ADD     WMDsThisBnd   S#TBIN
     C                   EVAL      WCurrency = TSSCCY
 
     C                   ENDIF
 
      ** Transaction Details 1 (complex)
 
     C                   EXSR      SRTrnDt1
     C     3             OCCUR     WMDsSRDT
     C                   MOVEL     WMDsPathGrp   WPathStr
     C                   Z-ADD     WMDsPrevBnd   S#PBIN
     C                   Z-ADD     WMDsThisBnd   S#TBIN
 
     C                   ENDIF
     C                   ENDIF
 
      ** Read Next Record
 
     C                   SELECT
     C                   WHEN      PRefInd = 'C'
     C**********         READ      SDCSINL2                               15                  234897
     C     PCustNumChr6  READE     SDCSINL2                               15                  234897
     C                   WHEN      PRefInd = 'N'
     C**********         READ      SDCSINL3                               15                  234897
     C     PRef          READE     SDCSINL3                               15                  234897
     C                   ENDSL
 
     C                   ENDDO
 
     C                   IF        WCurrency <> *BLANKS
 
      ** Process last transaction and Last Currency Totals.
 
     C                   IF        ##RFMT = 'Y'
     C                   MOVE      'LA'          DEFSLI
     C                   EXSR      SRODTA
     C                   ENDIF
 
     C                   Z-ADD     S#PBINB       S#PBIN
     C                   Z-ADD     S#TBINB       S#TBIN
     C                   EXSR      SrCcyTot
     C     3             OCCUR     WMDsSRDT
     C                   MOVEL     WMDsPathGrp   WPathStr
     C                   Z-ADD     WMDsPrevBnd   S#PBIN
     C                   Z-ADD     WMDsThisBnd   S#TBIN
 
     C                   ENDIF
 
      ** Unwind subroutine stack name
 
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCcyDet - Currency Details (simple)                         *
      *                                                               *
      *****************************************************************
     C     SrCcyDet      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrCcyDet  '  @STK(Q)
 
      ** Retrieve subroutine specific data.
 
     C     4             OCCUR     WMDsSRDT
 
      ** Set up path.
 
     C                   MOVEL     '\TAXCCY'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   EXSR      PSHGRS
     C                   MOVEL     WPathStr      WMDsPathGrp
 
      ** Set up Binds from passed in values.
 
     C                   Z-ADD     S#PBIN        WMDsPrevBnd
     C                   Z-ADD     S#TBIN        WMDsThisBnd
 
      ** Retrieve RDE info
 
     C                   MOVEL     'TAXCCY'      WGrpNme
     C                   EXSR      SrRtvRDE
 
      ** Retrieve Settlement Currency Details
 
     C                   EVAL      PCurrency = TSSCCY
     C                   EXSR      SRAOCurr
 
      ** Save Number of Decimal Places
 
     C                   EVAL      WSCcyPl = A6NBDP
 
      ** Currency Code
 
     C                   MOVEL     A6CYCD        ##D(1)
 
      ** Currency Description
 
     C                   MOVEL     A6MACD        ##D(2)
 
      ** Setup First/Subsequent/Last Indicator
 
     C                   MOVE      'FR'          ##FSLI
 
      ** Accumulate RDEs and associated data and output to CGUDTAPD
 
     C                   EXSR      SrADTA
     C                   EXSR      SrODTA
 
      ** Unwind subroutine stack name
 
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTrnDt1 - Transaction Details (complex)                     *
      *                                                               *
      *****************************************************************
     C     SrTrnDt1      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrTrnDt1  '  @STK(Q)
 
      ** Retrieve subroutine specific data.
 
     C     5             OCCUR     WMDsSRDT
 
      ** Set up path.
 
     C                   MOVEL     '\TRNDT1'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   EXSR      PSHGRS
     C                   MOVEL     WPathStr      WMDsPathGrp
 
      ** Set up Binds from passed in values.
 
     C                   Z-ADD     S#PBIN        WMDsPrevBnd
     C                   Z-ADD     S#TBIN        WMDsThisBnd
 
      ** Initialise the First/Last/Subsequent Flag.
 
     C                   MOVE      'FR'          ##FSLI
 
      ** If data has been formatted but not written, process it.
      ** (Note that this will not execute on first pass through SR and
      ** that data relates to previous record to be extracted read.)
 
     C                   IF        ##RFMT = 'Y'
 
      ** Output the Data.
 
     C                   EXSR      SRODTA
 
      ** Set the First/Last/Subsequent Flag for Subsequent runs.
 
     C                   MOVE      'SU'          ##FSLI
 
     C                   ENDIF
 
      ** Increment Bind Levels.
 
     C                   Z-ADD     S#TBINB       S#PBIN
     C                   ADD       1             ##BNDB
     C                   Z-ADD     ##BNDB        S#TBIN
 
      ** Transaction Details (simple)
 
     C                   EXSR      SrTrnDt2
     C     5             OCCUR     WMDsSRDT
     C                   MOVEL     WMDsPathGrp   WPathStr
     C                   Z-ADD     WMDsPrevBnd   S#PBIN
     C                   Z-ADD     WMDsThisBnd   S#TBIN
 
      ** Unwind subroutine stack name
 
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTrnDt2 - Transaction Details (simple)                      *
      *                                                               *
      *****************************************************************
     C     SrTrnDt2      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrTrnDt2 '   @STK(Q)
 
      ** Retrieve subroutine specific data.
 
     C     6             OCCUR     WMDsSRDT
 
      ** Set up path.
 
     C                   MOVEL     '\TRNDT2'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   EXSR      PSHGRS
     C                   MOVEL     WPathStr      WMDsPathGrp
 
      ** Set up Binds from passed in values.
 
     C                   Z-ADD     S#PBIN        WMDsPrevBnd
     C                   Z-ADD     S#TBIN        WMDsThisBnd
 
      ** Retrieve RDE info
 
     C                   MOVEL     'TRNDT2'      WGrpNme
     C                   EXSR      SrRtvRDE
 
      ** Interest Payment Date
 
     C                   EVAL      WDateDD = %SubSt(TSIPDT:7:2)
     C                   EVAL      WDateMM = %SubSt(TSIPDT:5:2)
     C                   EVAL      WDateYY = %SubSt(TSIPDT:3:2)
 
     C                   SELECT
     C                   WHEN      BJDFIN = 'M'
     C                   EVAL      WIPDT  = WDateMM + WDateDD + WDateYY
     C                   WHEN      BJDFIN = 'D'
     C                   EVAL      WIPDT  = WDateDD + WDateMM + WDateYY
     C                   WHEN      BJDFIN = 'Y'
     C                   EVAL      WIPDT  = WDateYY + WDateMM + WDateDD
     C                   ENDSL
     C                   MOVEL     WIPDT         ZDATE                                        236193
                                                                                              236193
     C                   TESTN                   WIPDT                9798                    236193
     C     *IN97         IFEQ      '1'                                                        236193
     C     *IN98         OREQ      '1'                                                        236193
     C                   CALL      'ZDATE1'                                                   236193
     C                   PARM                    ErrorFlag                                    236193
     C                   PARM                    ZDATE             6 0                        236193
     C                   PARM                    BJDFIN                                       236193
     C                   PARM      *ZEROS        ZDAYNO                                       236193
     C                   ENDIF                                                                236193
 
     C**********         MOVEL     WIPDT         ##D(1)                                       236193
     C                   MOVEL     ZDAYNO        ##D(1)                                       236193
 
      ** Module ID
 
     C                   MOVEL     TSMODI        ##D(2)
 
      ** Transaction Type
 
     C                   EVAL      WTType = *Blanks
 
     C                   SELECT
     C                   WHEN      TSMODI = 'D'
     C                   MOVE      TSDLLN        WDlln
     C                   EVAL      WTType = WDlln + '-' +
     C                                      TSTRTP + '/' + TSTRST
 
     C                   WHEN      TSMODI = 'R'
     C                   MOVE      TSACOD        WAcod
     C                   MOVE      TSACSQ        WAcsq
     C                   EVAL      WTType = WAcod + ' - ' +
     C                                      WAcsq
 
     C                   WHEN      TSMODI = 'S'
     C                   EVAL      WTType = TSSESN + TSETYP
 
     C                   ENDSL
 
     C                   MOVEL     WTType        ##D(3)
 
      ** Principal Amount
 
     C                   MOVEL     TSPAMS        ##D(4)
     C                   MOVE      WSCcyPl       ##D(4)
 
     C                   ADD       TSPAMS        WTPAMS
     C                   ADD       TSPAMB        WTPAMB
 
      ** Gross Interest Amount
 
     C                   MOVEL     TSGINS        ##D(5)
     C                   MOVE      WSCcyPl       ##D(5)
 
     C                   ADD       TSGINS        WTGINS
     C                   ADD       TSGINB        WTGINB
 
      ***Net*Interest Amount                                                                  232543
      **********                                                                              232543
     C**********         MOVEL     TSNINS        ##D(6)                                       232543
     C**********         MOVE      WSCcyPl       ##D(6)                                       232543
      **********                                                                              232543
     C**********         ADD       TSNINS        WTNINS                                       232543
     C**********         ADD       TSNINB        WTNINB                                       232543
 
      ** Accumulate RDEs and associated data and output to CGUDTAPD
 
     C                   EXSR      SrADTA
 
      ** Unwind subroutine stack name
 
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCcyTot - Currency Total Details (simple)                   *
      *                                                               *
      *****************************************************************
     C     SrCcyTot      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrCcyTot  '  @STK(Q)
 
      ** Retrieve subroutine specific data.
 
     C     7             OCCUR     WMDsSRDT
 
      ** Set up path.
 
     C                   MOVEL     '\CCYTOT'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   EXSR      PSHGRS
     C                   MOVEL     WPathStr      WMDsPathGrp
 
      ** Set up Binds from passed in values.
 
     C                   Z-ADD     S#PBIN        WMDsPrevBnd
     C                   Z-ADD     S#TBIN        WMDsThisBnd
 
      ** Retrieve RDE info
 
     C                   MOVEL     'CCYTOT'      WGrpNme
     C                   EXSR      SrRtvRDE
 
      ** Currency Total of Principal Amount
 
     C                   MOVEL     WTPAMS        ##D(1)
     C                   MOVE      WSCcyPl       ##D(1)
 
      ** Currency Total of Gross Interest Amount
 
     C                   MOVEL     WTGINS        ##D(2)
     C                   MOVE      WSCcyPl       ##D(2)
 
      ***Currency*Total of Net Interest Amount                                                232543
      **********                                                                              232543
     C**********         MOVEL     WTNINS        ##D(3)                                       232543
     C**********         MOVE      WSCcyPl       ##D(3)                                       232543
 
      ** Setup First/Subsequent/Last Indicator
 
     C                   MOVE      'LA'          ##FSLI
 
      ** Accumulate RDEs and associated data and output to CGUDTAPD
 
     C                   EXSR      SrADTA
     C                   EXSR      SrODTA
 
      ** Reset Currency Total Amount Fields
 
     C                   EVAL      WTPAMS = *ZERO
     C                   EVAL      WTGINS = *ZERO
     C**********         EVAL      WTNINS = *ZERO                                             232543
 
      ** Unwind subroutine stack name
 
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRefTot - Reference Totals Details.                         *
      *                                                               *
      *****************************************************************
     C     SrRefTot      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrRefTot  '  @STK(Q)
 
      ** Retrieve subroutine specific data.
 
     C     8             OCCUR     WMDsSRDT
 
      ** Set up path.
 
     C                   MOVEL     '\REFTOT'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   EXSR      PSHGRS
     C                   MOVEL     WPathStr      WMDsPathGrp
 
      ** Set up Binds from passed in values.
 
     C                   Z-ADD     S#PBIN        WMDsPrevBnd
     C                   Z-ADD     S#TBIN        WMDsThisBnd
 
      ** Retrieve RDE info
 
     C                   MOVEL     'REFTOT'      WGrpNme
     C                   EXSR      SrRtvRDE
 
      ** Retrieve Base Currency Details
 
     C                   EVAL      PCurrency = BJCYCD
     C                   EXSR      SRAOCurr
 
      ** Save Number of Decimal Places
 
     C                   EVAL      WBCcyPl = A6NBDP
 
      ** Reference Total of Principal Amount
 
     C                   MOVEL     WTPAMB        ##D(1)
     C                   MOVE      WBCcyPl       ##D(1)
 
      ** Reference Total of Gross Interest Amount
 
     C                   MOVEL     WTGINB        ##D(2)
     C                   MOVE      WBCcyPl       ##D(2)
 
      ***Reference*Total of Net Interest Amount                                               232543
      **********                                                                              232543
     C**********         MOVEL     WTNINB        ##D(3)                                       232543
     C**********         MOVE      WBCcyPl       ##D(3)                                       232543
 
      ** Setup First/Subsequent/Last Indicator
 
     C                   MOVE      'FR'          ##FSLI
 
      ** Accumulate RDEs and associated data and output to CGUDTAPD
 
     C                   EXSR      SrADTA
     C                   EXSR      SrODTA
 
      ** Reset Reference Total Amount Fields
 
     C                   EVAL      WTPAMB = *ZERO
     C                   EVAL      WTGINB = *ZERO
     C**********         EVAL      WTNINB = *ZERO                                             232543
 
      ** Unwind subroutine stack name
 
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGenRef - Generate reference number and write to CGUDCRPD.  *
      *                                                               *
      *****************************************************************
     C     SrGenRef      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrGenRef  '  @STK(Q)
 
      ** Reset the flag that indicates wether a correspondence is to be
      ** produced or not.
 
     C                   MOVEL     'N'           WProduce
 
      ** Set up fields of parameter PEDsCGUDCRPD to be passed to CG9010
 
     C                   CLEAR                   PEDsCGUDCRPD
 
      ** Booking/Main branch (mandatory)
 
     C**********         MOVEL     'DOM'         DRBRCA                                       234502
     C                   MOVEL     PBranch       DRBRCA                                       234502
 
      ** Module ID (mandatory)
 
     C                   MOVEL     'SD'          DRMODI
 
      ** Customer Reference and Country of Tax
 
     C                   EVAL      DRMTRN = 'TS_' + PRef
 
      ** Print Item Type
 
     C                   MOVEL     WCPrtItmTyp   DRPTYP
 
      ** Print Item Subtype
 
     C                   MOVEL     WCPrtItmSubTypDRPSTP
 
      ** Auto Transmission indicator
 
     C                   MOVEL     'N'           DRATRM
 
      ** Customer
 
     C                   MOVE      *BLANKS       PCustNumChr6
     C*********          MOVE      TSCUST        PCustNumChr6                                 234897
     C                   MOVEL     PRef          PCustNumChr6                                 234897
 
      ** Output to CGUDCRPD
 
     C                   CALL      'CG9010'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*GEN'        PMode
     C                   PARM                    W0CMT
     C                   PARM                    PCustNumChr6
     C                   PARM                    PEDsCGUDCRPD
     C                   PARM      *BLANKS       PItmRef
 
     C                   SELECT
 
      ** No error, generate correspondence
 
     C                   WHEN      PRtnCode = *BLANKS
     C                   MOVEL     'Y'           WProduce
     C                   MOVE      PItmRef       ##ITEM
     C     DRPTYP        CAT       ':':0         COLON
     C     COLON         CAT       DRPSTP:0      ##REFR
     C                   EXSR      WRAPRF
 
      ** No error, suppress output
 
     C                   WHEN      PRtnCode = 'CGD1270'
 
      ** Error.
 
     C                   OTHER
     C                   MOVEL     'CG9010'      W0File
     C                   MOVEL     PRtnCode      W0Key
     C                   Z-ADD     01            W0ERNB
     C                   MOVEL     'CGD1286'     W0MsgD
     C                   MOVEL     'CGUSRMSG'    W0MsgF
     C                   EXSR      SRERR
 
     C                   ENDSL
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRtvRDE - Retrieve 20 RDE's from the compile-time array and *
      *             store it in ##R.                                  *
      *                                                               *
      *****************************************************************
     C     SrRtvRDE      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrRtvRDE  '  @STK(Q)
 
      ** Reset primary arrays
 
     C                   CLEAR                   ##R
     C                   CLEAR                   ##D
     C                   CLEAR                   ##S
 
      ** Get info from compile time array of the 20 RDEs in group set
 
     C                   Z-ADD     1             Wx1
     C                   Z-ADD     1             WGrpSeq
     C                   DOU       *IN61 = *OFF
     C                             OR (Wx1 > 20)
     C                   Z-ADD     1             Wx2
     C     WGrp10        LOOKUP    WTbGrp(Wx2)                            61
     C                   IF        *IN61 = *ON
     C                   MOVEL     WTbRDE(Wx2)   ##R(Wx1)
     C                   ADD       1             Wx1
     C                   ADD       1             WGrpSeq
     C                   ENDIF
     C                   ENDDO
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFmtDta - Reformat data before packing it.                   *
      *                                                               *
      *****************************************************************
     C     SrFmtDta      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrFmtDta  '  @STK(Q)
 
      ** Loop through RDE's and data
 
     C                   Z-ADD     0             Wx1
 
     C     Wx1           DOUEQ     20
 
      ** Move RDE's and its data to their templates
 
     C                   ADD       1             Wx1
     C                   MOVEL     ##R(Wx1)      R#DEFN
     C                   MOVEL     ##D(Wx1)      R#DATA
 
      ** Reformat only if data is present and RDE is edited
 
     C                   IF        R#DATA <> *BLANK AND
     C                             ##RDEC <> *BLANK
 
      ** Right-align amount
 
     C                   MOVEA     ##NUMA        WAr29
     C                   Z-ADD     1             Wx2
     C     *BLANK        LOOKUP    WAr29(Wx2)                             61
     C                   Z-ADD     20            Wx3
     C                   Z-ADD     0             WNum20
 
     C                   DOW       Wx2 > 1 AND
     C                             Wx2 <= 20 AND
     C                             Wx3 > 1
     C                   SUB       1             Wx2
     C                   MOVEL     WAr29(Wx2)    WAr20(Wx3)
     C                   SUB       1             Wx3
     C                   ENDDO
 
      ** Sign
 
     C                   IF        ##SIGN = '-'
     C                   Z-SUB     WNum20        ##NUMB
     C                   ELSE
     C                   Z-ADD     WNum20        ##NUMB
     C                   ENDIF
 
      ** Edit type
 
     C                   IF        ##EDTT = *BLANK
     C                   MOVEL     ##RDET        ##EDTT
     C                   ENDIF
 
      ** Default decimal places
 
     C                   IF        ##DCPA = *BLANK
     C                   MOVEL     ##RDED        ##DCPA
     C                   ENDIF
 
      ** New RDE data
 
     C                   MOVEL     R#DATA        ##D(Wx1)
 
     C                   ENDIF
 
     C                   ENDDO
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrADTA - Accumulate RDEs and associated data for output.     *
      *                                                               *
      *****************************************************************
     C     SrADTA        BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrADTA    '  @STK(Q)
 
      ** Reformat RDE data
 
     C                   EXSR      SrFmtDta
 
      ** Pack RDEs and associated data into data string
 
     C                   CLEAR                   ##SDS
 
     C                   IF        CCG015 = 'Y'
     C                   MOVEL     '*NEWARR '    PAction8
     C                   MOVEL     WPathStr      W0SPAT
     C                   ELSE
     C                   MOVEL     '*PACK   '    PAction8
     C                   MOVEL     *BLANKS       W0SPAT
     C                   ENDIF
 
     C                   CALL      'CG3999'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM                    PAction8
     C                   PARM                    ##R
     C                   PARM                    ##D
     C                   PARM                    ##S
     C                   PARM                    W0SPAT
     C                   PARM                    ##RN
     C                   PARM                    ##DN
     C                   PARM                    ##FM
 
     C                   IF        PRtnCode <> *BLANKS
     C                   MOVEL     'CG3999'      W0File
     C                   MOVEL     PRtnCode      W0Key
     C                   Z-ADD     02            W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS  '     W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF
 
      ** Write XML record for RDE
 
     C                   EXSR      WRTRDE
 
      ** Initialise write format parameter
 
     C                   CLEAR                   PEDsCGUDTAPD
 
      ** Setup Control Information.
 
     C                   Z-ADD     ##ITEM        DEITEM
     C                   ADD       1             ##OSEQ
     C                   Z-ADD     ##OSEQ        DEOSEQ
     C                   Z-ADD     WMDsPrevBnd   DEPBIN
     C                   Z-ADD     WMDsThisBnd   DETBIN
     C                   MOVE      ##FSLI        DEFSLI
     C                   MOVE      *BLANKS       W0PATH
     C                   MOVEL     WPathStr      W0PATH
 
      ** Append Data from pack routine.
 
     C                   MOVEA     ##S           ##SDS
 
     C     PEDsCGUDTAPD  CAT       ##SDS:0       PEDsCGUDTAPD
 
      ** Set Flag to show record formatted.
 
     C                   MOVE      'Y'           ##RFMT
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrODTA - Output Accumulated data to PF/CGUDTAPD              *
      *                                                               *
      *****************************************************************
     C     SrODTA        BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrODTA    '  @STK(Q)
 
      ** Output PF/CGUDTAPD Record.
 
     C                   IF        CCG015 = 'N'
 
     C                   CALL      'CG9020'
     C                   PARM      *BLANK        PRtnCode
     C                   PARM      '*WRITE'      PAction8
     C                   PARM                    W0PATH
     C                   PARM                    PEDsCGUDTAPD
     C                   PARM      *BLANK        W0TITL            7
     C                   PARM      *BLANK        W0ULIN            7
     C                   PARM                    W0CMT
 
     C                   IF        PRtnCode <> *BLANK
 
     C                   MOVEL     'CG9020'      W0File
     C                   MOVEL     PRtnCode      W0Key
     C                   Z-ADD     03            W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS  '     W0MsgF
     C                   EXSR      SRERR
 
     C                   ENDIF
     C                   ENDIF
 
      **  Reset Flag to show formatted data output.
 
     C                   MOVE      *BLANKS       ##RFMT
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAOCurr - Retrieve Currency Details                         *
      *                                                               *
      *****************************************************************
     C     SrAOCurr      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrAOCurr  '  @STK(Q)
 
      ** Retrieve Currency Details
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCurrency
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
 
      ** Handle Database Error if any occur.
 
     C                   MOVEL     'SDCURRPD'    W0File
     C                   MOVEL     PCurrency     W0Key
     C                   Z-ADD     04            W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS  '     W0MsgF
     C                   EXSR      SRERR
 
     C                   ENDIF
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit - Initialisation Processing                           *
      *                                                               *
      *****************************************************************
     C     SrInit        BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrInit    '  @STK(Q)
 
      ** Initialise work variables
 
     C                   EVAL      WCurrency = *BLANK
     C                   EVAL      WTPAMS = *ZERO
     C                   EVAL      WTPAMB = *ZERO
     C                   EVAL      WTGINS = *ZERO
     C                   EVAL      WTGINB = *ZERO
     C**********         EVAL      WTNINS = *ZERO                                             232543
     C**********         EVAL      WTNINB = *ZERO                                             232543
     C                   EVAL      ##OSEQ = *ZERO
     C                   MOVE      *BLANKS       WMDsPathGrp
 
      ** Iniitialise Binds.
 
     C                   Z-ADD     1             S#PBIN
     C                   Z-ADD     1             S#TBIN
     C                   Z-ADD     1             ##BNDA
     C                   Z-ADD     2             ##BNDB
 
      ** Initialise XML increment.
 
     C                   EXSR      INIXML
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialization routine                               *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN
     C                   PARM                    W0CMT
     C                   PARM                    WProduce
     C                   PARM                    WAUTO
     C                   PARM                    DSPARM
 
      ** Define Fields
 
     C     *LIKE         DEFINE    DEFSLI        ##FSLI
     C     *LIKE         DEFINE    DEPBIN        ##BNDA
     C     *LIKE         DEFINE    DEPBIN        ##BNDB
     C     *LIKE         DEFINE    DEPBIN        S#PBIN
     C     *LIKE         DEFINE    DEPBIN        S#PBINB
     C     *LIKE         DEFINE    DETBIN        S#TBIN
     C     *LIKE         DEFINE    DETBIN        S#TBINB
     C     *LIKE         DEFINE    DEOSEQ        ##OSEQ
 
      ** Access Bank Details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Handle Database Error if any occur.
 
     C                   IF        PRtCd <> *Blanks
     C                   EVAL      W0FILE = 'SDBANKPD'
     C                   MOVEL     POptn         W0Key
     C                   Z-ADD     05            W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS     '  W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF
 
      ** Access SAR details file to determine if CCG015 is on.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CCG015'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Handle Database Error if any occur.
 
     C                   IF        PRtcd <> *Blanks and
     C                             PRtcd <> '*NRF   '
     C                   EVAL      W0FILE = 'SCSARDPD'
     C                   MOVEL     'CCG015'      W0Key
     C                   Z-ADD     06            W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS     '  W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   IF        PRtcd = *Blanks
     C                   EVAL      CCG015 = 'Y'
     C                   ELSE
     C                   EVAL      CCG015 = 'N'
     C                   ENDIF
 
     C                   MOVE      *BLANKS       WPathStr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY CGCPYSRC,SRERRCLE
      /EJECT
     C/COPY CGCPYSRC,SRERRPSSRL
      /EJECT
     C/COPY CGCPYSRC,CGNWEXILE
      /EJECT
      *****************************************************************
** WTbGrp/WTbRDE
TAXHDR0001 RUNDATE    Date               Rundate                                              236193
TAXHDR0002 TAX YEAR                      Tax Year
TAXHDR0003 REFERENCE                     Customer Reference
TAXHDR0004 REP_NAME                      Report Name
TAXHDR0005 REP_TOWN                      Report Town
TAXHDR0006 REP_TITLE                     Report Title                                         232543
TAXCCY0001 SETTL CCY                     Settlement Ccy Code
TAXCCY0002 CCY_DESC                      Currency Description
TRNDT20001 INT_PAYD   Date               Interest Payment Date                                236193
TRNDT20002 MODULE_ID                     Module ID
TRNDT20003 TRN_TYPE                      Transaction Type
TRNDT20004 PRINCIPAL  AmountL            Principal Amt
TRNDT20005 GRS INTRST AmountL            Gross Int Amt
CCYTOT0001 CCY_TOTPAM AmountL            Ccy Totals of Principal Amt
CCYTOT0002 CCY_TOTGIN AmountL            Ccy Totals of Gross Int Amt
REFTOT0001 REF_TOTPAM AmountL            Ref Totals of Principal Amt
REFTOT0002 REF_TOTGIN AmountL            Ref Totals of Gross Int Amt
