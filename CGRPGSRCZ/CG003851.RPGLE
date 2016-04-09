     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Retail Advice for SE - Extract')                       *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG003851 - Retail Advice for SE - Extract                    *
      *                                                               *
      *  Function:  This program produces the customer correspondence *
      *             onto the UDC extract files required for           *
      *             production of the Securities Trading Advices      *
      *             through Correspondence Manager.                   *
      *                                                               *
      *  Called By: CG003850 - Retail Advice for SE - Driver          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CER055             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 23Feb10               *
      *                 CAP204             Date 09Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CRE020   *CREATE   Date 20Jan04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *  CAP204 - Teller Related APIs - Account Transfer              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas GL Account details - full a/c number                                           CER055
      *                                                                                       CER055
     FACCNTL0   IF   E           K DISK                                                       CER055
      *                                                                                       CER055
      ** Midas GL Account details - full a/c number                                           CER055
      *                                                                                       CER055
     FACCNTBY0  IF   E           K DISK                                                       CER055
      *                                                                                       CER055
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
 
     D WCPrtItmTyp     C                   CONST('RTL_ADV')
      ** Print Item Type
 
     D WCPrtItmSubTyp  C                   CONST('SE')
      ** Print Item Sub-Type
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *                                                                                       CER055
      ** Data Structures used by Access Programs                                              CER055
      *                                                                                       CER055
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER055
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER055
      ** Data structure for access objects, second DS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Data structure for SD Customer details file
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Data structure Currency details
 
     D PEDsCGUDCRPD  E DS                  EXTNAME(CGUDCRPD)
      ** Data structure for UDC data reference file
 
     D WDsRSAC       E DS                  EXTNAME(RSACMTPD)
      ** Data structure for GL Account Movements
 
     D*PDsRetRsac      DS           155                                                       CAP204
     D*PDsRetRsac      DS           175                                                CAP204 CAP205
     D PDsRetRsac      DS           182                                                       CAP205
      ** Data structure for Retail Number and GL Accnt Movements Dtls
     D  WRetailNum             1     10
     D**WRsacDetls            11    155                                                       CAP204
     D**WRsacDetls            11    175                                                CAP204 CAP205
     D  WRsacDetls            11    182                                                       CAP205
 
     D WMDsPath        DS                  OCCURS(20)
      ** Multi-occurence data structure to store path starting from Treadv
     D  WMDsPathGrp            1      6
 
     D                 DS
      ** General data structure to define fields that need to share data
     D WGrp10                  1     10
     D  WGrpNme                1      6
     D  WGrpSeq                7     10S 0
     D  WAr20                 21     40    DIM(20)
     D  WNum20                21     40  0
     D  WAr29                 51     79    DIM(29)
 
      ** Compile-time array to contain RDE definitions
     D*WTbGrp***       S             10    DIM(16) CTDATA PERRCD(1)                           CER055
     D*WTbRDE***       S             22    DIM(16) ALT(WTbGrp)                                CER055
     D WTbGrp          S             10    DIM(27) CTDATA PERRCD(1)                           CER055
     D WTbRDE          S             22    DIM(27) ALT(WTbGrp)                                CER055
 
      ** Compile-time array to contain Deal Type Codes/Narratives
     D WTabCod         S              2    DIM(18) CTDATA PERRCD(1)
     D WTabNar         S             30    DIM(18) ALT(WTabCod)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WPathStr        S            256A
      ** String that contains the concatenated path
 
     D WPx             S              3P 0
      ** Index for WMDsPath only
 
     D ##ITEM          S              8  0
      ** Confirmation Text code
 
      ** General purpose variables
     D WProduce        S              1A
     D Wx1             S              3P 0
     D Wx2             S              3P 0
     D Wx3             S              3P 0
     D WMvam           S             13P 0
 
      ** Parameter fields
     D PAction8        S              8A
     D PCustNumChr6    S              6A
     D PItmRef         S              8A
     D PMode           S             10A
     D PRtnCode        S              7A
     D PInp_Commit     S              3A
     D CCG015          S              1A
     D PChgType        S              1A
     D W0SPAT          S             70A
     D W0CMT           S              3A
     D CER055          S              1A                                                      CER055
     D CFT004          S              1A                                                      CER055
     D PSard           S              6A                                                      CER055
 
      ** Access Object Parameter fields
     D PRtCd           S              7A
     D POptn           S              7A
     D PCustNo         S             10A
     D PChr003         S              3A
     D PErrInf         S              7A
 
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
 
      ** Execute main subroutine
 
     C                   EXSR      SrMain
 
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
      *  SrMain - Performs validation and invokes top group set.      *
      *                                                               *
      *****************************************************************
     C     SrMain        BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrMain    '  @STK(Q)
 
      ** Move GL Account Movement details to a DS for RSACMTPD.
 
     C                   MOVEL     WRsacDetls    WDsRSAC
 
      ** Generate reference number by writing to PF/CGUDCRPD.
      ** If no confirmation to produce, then bypass.
 
     C                   EXSR      SrGenRef
 
      ** Top group set
 
     C                   IF        WProduce = 'Y'
     C                   EXSR      SrTREADV
     C                   ENDIF
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTREADV - Top group set.                                    *
      *                                                               *
      *****************************************************************
     C     SrTREADV      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrTREADV  '  @STK(Q)
 
      ** Set up path multi-occurence data structure & path string
 
     C                   Z-ADD     1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'TREADV'      WMDsPathGrp
 
     C                   EXSR      SrPath
 
     C                   EXSR      PSHGRS
 
      *********************************
      ** Retail Advice Details group **
      *********************************
 
     C                   EXSR      SrRA_DTL
 
      *********************************
      ** Customer details group      **
      *********************************
 
     C                   EXSR      SrCUST
                                                                                              CER055
      *********************************                                                       CER055
      ** Ovderdraft Line Details     **                                                       CER055
      *********************************                                                       CER055
                                                                                              CER055
     C                   IF        CER055 = 'Y'                                               CER055
     C                   EXSR      SrODACCT                                                   CER055
     C                   ENDIF                                                                CER055
 
      ** Decrement Path DS index
 
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
 
     C                   EXSR      POPGRS
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRA_DTL   - Extract Retail Advice Details.                  *
      *                                                               *
      *****************************************************************
     C     SrRA_DTL      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrRA_DTL  '  @STK(Q)
 
      ** Set up path multi-occurence data structure & path string
 
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'RA_DTL'      WMDsPathGrp
 
     C                   EXSR      SrPath
 
     C                   EXSR      PSHGRS
 
      ** Retrieve RDE info
 
     C                   MOVEL     'RA_DTL'      WGrpNme
     C                   EXSR      SrRtvRDE
 
      ** Funds Transfer Reference
 
      ** If transaction is for Position Settlement, use Security Shortname as
      ** Reference; otherwise use Transaction reference
 
     C                   IF        TRYP='CP' or TRYP='DV' or TRYP='PP' or
     C                             TRYP='MT' or TRYP='MP' or TRYP='RC' or
     C                             TRYP='PS'
     C                   EVAL      ##D(1) = %SUBST(FUND:1:10)
     C                   ELSE
     C                   MOVEL     TNMR          ##D(1)
     C                   ENDIF
 
      ** Debit or Credit (0 or 1)
 
     C                   IF        DORC = 0
     C                   MOVEL     'DR'          ##D(2)
     C                   ELSE
     C                   MOVEL     'CR'          ##D(2)
     C                   ENDIF
 
      ** Retail Account Number
 
     C                   MOVEL     WRetailNum    ##D(3)
 
      ** Value Date
 
     C                   IF        VUDT <> *ZEROS
     C                   MOVEL     VUDT          ##D(4)
     C                   ENDIF
 
      ** Transaction Type Description
 
     C                   Z-ADD     1             Wx2
     C     TRYP          LOOKUP    WTabCod(Wx2)                           61
     C                   IF        *IN61 = *ON
     C                   MOVEL     WTabNar(Wx2)  ##D(5)
     C                   ENDIF
 
      ** Transaction Narrative
 
     C                   SELECT
     C                   WHEN      TRYP = 'CP' or
     C                             TRYP = 'MT'
     C                   EVAL      ##D(6) = 'INTEREST'
     C                   WHEN      TRYP = 'TS' or
     C                             TRYP = 'TP'
     C                   EVAL      ##D(6) = 'VALUE'
     C                   WHEN      TRYP = 'DV' or
     C                             TRYP = 'PS' or
     C                             TRYP = 'MP' or
     C                             TRYP = 'PP' or
     C                             TRYP = 'RC' or
     C                             TRYP = 'RP'
     C                   EVAL      ##D(6) = 'SECURITIES SETTLEMENTS'
     C                   OTHER
     C                   EVAL      ##D(6) = 'SECURITIES TRANSACTION'
     C                   ENDSL
 
      ** Currency Code
 
     C                   MOVEL     CCYD          ##D(7)
 
      ** Posting Amount
 
     C                   EVAL      R#DATA = *BLANKS
 
     C                   IF        MVAM < *ZERO
     C                   Z-SUB     MVAM          WMvam
     C                   EVAL      ##SIGN = '-'
     C                   ELSE
     C                   Z-ADD     MVAM          WMvam
     C                   EVAL      ##SIGN = *BLANKS
     C                   ENDIF
 
      ** Retrieve number of decimal places
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      CCYD          PChr003
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     PRtCd         IFNE      *BLANKS
 
     C                   MOVEL     'SDCURRPD'    W0File
     C                   MOVEL     CCYD          W0Key
     C                   Z-ADD     04            W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS     '  W0MsgF
     C                   EXSR      SRERR
 
     C                   ENDIF
 
     C                   MOVE      A6NBDP        ##DCPA
     C                   MOVEL     WMvam         ##NUMA
 
     C                   MOVEL     R#DATA        ##D(8)
 
      ** Last Transaction Change Type
 
     C                   MOVEL     PChgType      ##D(9)
                                                                                              CER055
     C                   IF        CER055 = 'Y'                                               CER055
     C                   MOVEL     'Y'           ##D(10)                                      CER055
     C                   ENDIF                                                                CER055
 
      ** Accumulate RDEs and associated data and output to CGUDTAPD
 
     C                   EXSR      SrPackDta
 
      ** Decrement Path DS index
 
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
 
     C                   EXSR      POPGRS
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCUST   - Extract Customer Details.                         *
      *                                                               *
      *****************************************************************
     C     SrCUST        BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrCUST    '  @STK(Q)
 
      ** Set up path multi-occurence data structure & path string
 
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'CUST  '      WMDsPathGrp
 
     C                   EXSR      SrPath
 
     C                   EXSR      PSHGRS
 
      ** Retrieve RDE info
 
     C                   MOVEL     'CUST  '      WGrpNme
     C                   EXSR      SrRtvRDE
 
      ** Get the Customer Detail.
 
     C                   MOVEL     CUSN          PCustNo
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCustNo
     C                   PARM      *BLANKS       PErrInf
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        PRtCd = *BLANKS
 
      ** Customer number
 
     C                   MOVEL     BBCUST        ##D(1)
 
      ** Customer name
 
     C                   MOVEL     BBCRNM        ##D(2)
 
      ** Customer town
 
     C                   MOVEL     BBCRTN        ##D(3)
 
      ** Customer Name and Address line 1
 
     C                   MOVEL     BBCNA1        ##D(4)
 
      ** Customer Name and Address line 2
 
     C                   MOVEL     BBCNA2        ##D(5)
 
      ** Customer Name and Address line 3
 
     C                   MOVEL     BBCNA3        ##D(6)
 
      ** Customer Name and Address line 4
 
     C                   MOVEL     BBCNA4        ##D(7)
 
     C                   ELSE
 
      ** Handle Database Errors if any occur.
 
     C                   MOVEL     'SDCUSTPD'    W0File
     C                   MOVEL     PCustNo       W0Key
     C                   Z-ADD     01            W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS  '     W0MsgF
     C                   EXSR      SRERR
 
     C                   ENDIF
 
      ** Accumulate RDEs and associated data and output to CGUDTAPD
 
     C                   EXSR      SrPackDta
 
      ** Decrement Path DS index
 
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
 
     C                   EXSR      POPGRS
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************                       CER055
      /EJECT                                                                                  CER055
      *****************************************************************                       CER055
      *                                                               *                       CER055
      *  SrODACCT - Extract Overdraft Line Details.                   *                       CER055
      *                                                               *                       CER055
      *****************************************************************                       CER055
     C     SrODACCT      BEGSR                                                                CER055
                                                                                              CER055
      ** Set up subroutine stack name                                                         CER055
                                                                                              CER055
     C                   EVAL      Q      += 1                                                CER055
     C                   EVAL      @STK(Q) = 'SrODACCT'                                       CER055
                                                                                              CER055
      ** Set up path multi-occurence data structure & path string                             CER055
                                                                                              CER055
     C                   EVAL      WPx += 1                                                   CER055
     C     WPx           OCCUR     WMDsPath                                                   CER055
     C                   EVAL      WMDsPathGrp = 'ODACCT'                                     CER055
                                                                                              CER055
     C                   EXSR      SrPath                                                     CER055
                                                                                              CER055
     C                   EXSR      PSHGRS                                                     CER055
                                                                                              CER055
      ** Retrieve RDE info                                                                    CER055
                                                                                              CER055
     C                   EVAL      WGrpNme = 'ODACCT'                                         CER055
     C                   EXSR      SrRtvRDE                                                   CER055
                                                                                              CER055
      ** Move Details                                                                         CER055
                                                                                              CER055
     C     KACKEY        CHAIN     ACCNTL0                                                    CER055
     C                   IF        CFT004  = 'Y' AND                                          CER055
     C                             IBAN   <> *BLANKS                                          CER055
     C                   MOVEL     IBAN          ##D(1)                                       CER055
     C                   ELSE                                                                 CER055
     C                   MOVEL     ACNO          ##D(1)                                       CER055
     C                   ENDIF                                                                CER055
     C                   MOVEL     CCY           ##D(2)                                       CER055
     C                   MOVEL     CLBL          ##D(3)                                       CER055
     C                   MOVEL     LDBL          ##D(4)                                       CER055
     C                   MOVEL     ODLN          ##D(5)                                       CER055
     C                   MOVEL     ODED          ##D(6)                                       CER055
     C                   MOVEL     DRIS          ##D(7)                                       CER055
     C     KACKEY        CHAIN     ACCNTBY0                                                   CER055
     C                   MOVEL     ATAODR        ##D(8)                                       CER055
     C                   MOVEL     ATDOBE        ##D(9)                                       CER055
     C                   MOVEL     ATNDYE        ##D(10)                                      CER055
                                                                                              CER055
      ** Accumulate RDEs and associated data and output to CGUDTAPD                           CER055
                                                                                              CER055
     C                   EXSR      SrPackDta                                                  CER055
                                                                                              CER055
      ** Decrement Path DS index                                                              CER055
                                                                                              CER055
     C     WPx           OCCUR     WMDsPath                                                   CER055
     C                   CLEAR                   WMDsPathGrp                                  CER055
     C                   EVAL      WPx -= 1                                                   CER055
                                                                                              CER055
     C                   EXSR      POPGRS                                                     CER055
                                                                                              CER055
      ** Unwind subroutine stack name                                                         CER055
                                                                                              CER055
     C                   MOVEA     *BLANKS       @STK(Q)                                      CER055
     C                   EVAL      Q -= 1                                                     CER055
                                                                                              CER055
     C                   ENDSR                                                                CER055
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
 
     C                   MOVEL     BRCA          DRBRCA
 
      ** Module ID (mandatory)
 
     C                   MOVEL     'RE'          DRMODI
 
      ** MIDAS Transaction number
 
     C                   MOVEL     TNMR          DRMTRN
 
      ** Print Item Type
 
     C                   MOVEL     WCPrtItmTyp   DRPTYP
 
      ** Print Item Subtype
 
     C                   MOVEL     WCPrtItmSubTypDRPSTP
 
      ** Auto Transmission indicator
 
     C                   MOVEL     'N'           DRATRM
 
      ** Customer
 
     C                   MOVE      *BLANKS       PCustNumChr6
     C                   MOVE      CUSN          PCustNumChr6
 
      ** Output to CGUDCRPD
 
     C                   CALL      'CG9010'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*GEN'        PMode
     C                   PARM                    PInp_Commit
     C                   PARM                    PCustNumChr6
     C                   PARM                    PEDsCGUDCRPD
     C                   PARM      *BLANKS       PItmRef
 
     C                   SELECT
 
      ** No error, generate correspondence
 
     C                   WHEN      PRtnCode = *BLANKS
     C                   MOVEL     'Y'           WProduce
     C                   MOVEL     PItmRef       ##ITEM
     C     DRPTYP        CAT       ':':0         COLON            11
     C     COLON         CAT       DRPSTP:0      ##REFR
     C                   EXSR      WRAPRF
 
      ** No error, suppress output
 
     C                   WHEN      PRtnCode = 'CGD1270'
 
      ** Error.
 
     C                   OTHER
     C                   MOVEL     'CG9010'      W0File
     C                   MOVEL     PRtnCode      W0Key
     C                   Z-ADD     02            W0ERNB
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
      *  SrPath - Set up path string.                                 *
      *                                                               *
      *****************************************************************
     C     SrPath        BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrPath    '  @STK(Q)
 
      ** Reset output path string
 
     C                   MOVEL     *BLANKS       WPathStr
 
      ** Copy path from multi-occurence DS to string. Each entry is to be
      ** preceded by '\'.
 
     C                   DO        WPx           Wx1
     C     Wx1           OCCUR     WMDsPath
     C                   CAT       '\':0         WPathStr
     C                   CAT       WMDsPathGrp:0 WPathStr
     C                   ENDDO
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRtvRDE - Retrieve 20 RDE's from the compile-time array and *
      *            store it in ##R.                                   *
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
 
     C     R#DATA        IFNE      *BLANK
     C     ##RDEC        ANDNE     *BLANK
 
      ** Right-align amount
 
     C                   MOVEA     ##NUMA        WAr29
     C                   Z-ADD     1             Wx2
     C     *BLANK        LOOKUP    WAr29(Wx2)                             61
     C                   Z-ADD     20            Wx3
     C                   Z-ADD     0             WNum20
     C     Wx2           DOWGT     1
     C     Wx2           ANDLE     20
     C     Wx3           ANDGT     1
     C                   SUB       1             Wx2
     C                   MOVEL     WAr29(Wx2)    WAr20(Wx3)
     C                   SUB       1             Wx3
     C                   ENDDO
 
      ** Sign
 
     C     ##SIGN        IFEQ      '-'
     C                   Z-SUB     WNum20        ##NUMB
     C                   ELSE
     C                   Z-ADD     WNum20        ##NUMB
     C                   ENDIF
 
      ** Edit type
 
     C     ##EDTT        IFEQ      *BLANK
     C                   MOVEL     ##RDET        ##EDTT
     C                   ENDIF
 
      ** Default decimal places
 
     C     ##DCPA        IFEQ      *BLANK
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
      *  SrPackDta - Pack/Unpack RDEs and their corresponding data.   *
      *                                                               *
      *****************************************************************
     C     SrPackDta     BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrPackDta '  @STK(Q)
 
      ** Reformat RDE data
 
     C                   EXSR      SrFmtDta
 
     C                   MOVEL     '*NEWARR '    PAction8
     C                   MOVEL     WPathStr      W0SPAT
 
      ** Pack RDEs and associated data into data strings
 
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
     C                   Z-ADD     03            W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS  '     W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   EXSR      WRTRDE
 
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
      *                                                                                       CER055
     C     KACKEY        KLIST                                                                CER055
     C                   KFLD                    CUSN                                         CER055
     C                   KFLD                    CCYD                                         CER055
     C                   KFLD                    ACDE                                         CER055
     C                   KFLD                    ASNC                                         CER055
     C                   KFLD                    BRCA                                         CER055
 
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN
     C                   PARM                    PInp_Commit
     C                   PARM                    PDsRetRsac
     C                   PARM                    CCG015
     C                   PARM                    PChgType
 
     C                   Z-ADD     0             Q
 
      ** Initialise XML increment
 
     C                   EXSR      INIXML
                                                                                              CER055
      ** Check if 'CER055' is switched 'ON'                                                   CER055
                                                                                              CER055
     C                   CALL      'AOSARDR0'                                                 CER055
     C                   PARM      *BLANKS       PRtcd                                        CER055
     C                   PARM      '*VERIFY'     POptn                                        CER055
     C                   PARM      'CER055'      PSard                                        CER055
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER055
      *                                                                                       CER055
     C                   IF        PRtcd  = *BLANKS                                           CER055
     C                   EVAL      CER055 = 'Y'                                               CER055
     C                   ELSE                                                                 CER055
      *                                                                                       CER055
     C                   EVAL      CER055 = 'N'                                               CER055
     C                   ENDIF                                                                CER055
                                                                                              CER055
      ** Check if 'CFT004' is switched 'ON'                                                   CER055
                                                                                              CER055
     C                   CALL      'AOSARDR0'                                                 CER055
     C                   PARM      *BLANKS       PRtcd                                        CER055
     C                   PARM      '*VERIFY'     POptn                                        CER055
     C                   PARM      'CFT004'      PSard                                        CER055
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER055
      *                                                                                       CER055
     C                   IF        PRtcd  = *BLANKS                                           CER055
     C                   EVAL      CFT004 = 'Y'                                               CER055
     C                   ELSE                                                                 CER055
      *                                                                                       CER055
     C                   EVAL      CFT004 = 'N'                                               CER055
     C                   ENDIF                                                                CER055
 
      ** Index of WMDsPath
 
     C                   Z-ADD     0             WPx
     C                   CLEAR                   WMDsPath
 
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
RA_DTL0001 TRNREF                        Transaction Reference
RA_DTL0002 DR/CRIND                      DR/CR indicator
RA_DTL0003 RETL_ACNO                     Retail Account Number
RA_DTL0004 VALUE DATE Date               Value Date
RA_DTL0005 TRNTYPDESC                    Transaction Type Description
RA_DTL0006 TRANSNARR                     Transaction Narrative
RA_DTL0007 CURRENCY                      Currency Code
RA_DTL0008 POST_AMT   AmountL            Posting Amount
RA_DTL0009 LSTCHGTYP                     Last Transaction Change Type
RA_DTL0010 CER055F                       CER055 Switchable Feature Flag                       CER055
ODACCT0001 ACCNUM                        Account Number                                       CER055
ODACCT0002 CURRENCY                      Currency                                             CER055
ODACCT0003 CLRDBAL    AmountL            Cleared Balance                                      CER055
ODACCT0004 LDGRBAL    AmountL            Ledger Balance                                       CER055
ODACCT0005 ODLIMIT    AmountL            Overdraft Limit Amount                               CER055
ODACCT0006 ODLMTEXPDT Date               Overdraft Limit Expiry Date                          CER055
ODACCT0007 DEBINTRTE  Rate  L7           Debit Interest Rate                                  CER055
ODACCT0008 ODINTRATE  Rate  L7           Overdraft Interest Rate                              CER055
ODACCT0009 DTEODBAL   Date               Date of Overdraft Balance Excess                     CER055
ODACCT0010 NUMDAYS                       Number of Days in Excess                             CER055
CUST  0001 CUSTOMER                      Customer Number
CUST  0002 CUST_NAME                     Customer Name
CUST  0003 CUST_TOWN                     Customer Town
CUST  0004 CUST_ADR1                     Customer Name & Address 1
CUST  0005 CUST_ADR2                     Customer Name & Address 2
CUST  0006 CUST_ADR3                     Customer Name & Address 3
CUST  0007 CUST_ADR4                     Customer Name & Address 4
** WTabCod/WTabNar  - Transaction Type/Transaction Narratives
TPTRADE PURCHASED
TSTRADE SALE
CPCOUPON PAYMENT
DVDIVIDEND PAYMENT
PPPARTLY PAID
MTMATURITY
MPMORTGAGE PAYMENT
RCREDEMPTION CALL
WIWALK-IN
WOWALK-OUT
BBBOND BORROWING
BLBOND LENDING
RPREPURCHASE AGREEMENT (REPO)
RLREVERSE REPO
PLPLEDGED LOAN
PDPLEDGE DEPOSIT
DTDEPOT TRANSFER
PSPOSITION SETTLEMENT
