     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Retail Advice for FT - Extract')                       *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG003861 - Retail Advice for FT - Extract                    *
      *                                                               *
      *  Function:  This program produces the customer correspondence *
      *             onto the UDC extract files required for           *
      *             production of the Funds Transfer Retail Advices   *
      *             through Correspondence Manager.                   *
      *                                                               *
      *  Called By: CG003860 - Retail Advice for FT - Driver          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CER055             Date 06Dec10
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG23445A          Date 19Apr09               *
      *                 BUG23445           Date 17Mar09               *
      *                 BUG23197           Date 03Mar00               *
      *                 CER031             Date 19May08               *
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
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23445A - Paper statements were not reformatted based on   *
      *              network *PAPER                                   *
      *  BUG23445 - Format network according to network Paper if      *
      *             Account is linked                                 *
      *  BUG23197 - Pass blank parameter to the MG001900(Output       *
      *             parameter)                                        *
      *  CER031 - FT/GL Extended Narrative German Features            *
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
      *                                                                                       CER031
      ** Midas FT Inc. Payments                                                               CER031
      *                                                                                       CER031
     FINPAY     IF   E           K DISK                                                       CER031
      *                                                                                       CER031
      ** Midas FT Out. Payments                                                               CER031
      *                                                                                       CER031
     FOTPAY     IF   E           K DISK                                                       CER031
      *                                                                                     BUG23445
      ** Midas GL Network accounts - MT94x - retrieval                                      BUG23445
      *                                                                                     BUG23445
     F*GLNW94L1  IF   E           K DISK                                          BUG23445 BUG23445A
     FGLNWACL1  IF   E           K DISK                                                    BUG23445A
      *                                                                                     BUG23445
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
      *
     D/COPY ZACPYSRC,ERR_XARRYS                                                               CER031
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D WCPrtItmTyp     C                   CONST('RTL_ADV')
      ** Print Item Type
 
     D WCPrtItmSubTyp  C                   CONST('FT')
      ** Print Item Sub-Type
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Data structure for access objects, second DS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Data structure for SD Customer details file
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Data structure Currency details
 
     D PEDsCGUDCRPD  E DS                  EXTNAME(CGUDCRPD)
      ** Data structure for UDC data reference file
 
     D WDsRSAC       E DS                  EXTNAME(RSACMTPD)
      ** Data structure for GL Account Movements
 
      *                                                                                       CER031
      ** Switchable Features Descriptions                                                     CER031
      *                                                                                       CER031
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER031
      *                                                                                       CER031
      ** Data Structures used by Access Programs                                              CER031
      *                                                                                       CER031
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER031
      *                                                                                       CER031
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
     D**********WTbGrp       S             10    DIM(16) CTDATA PERRCD(1)                     CER031
     D*WTbGrp***       S             10    DIM(56) CTDATA PERRCD(1)                    CER031 CER055
     D WTbGrp          S             10    DIM(67) CTDATA PERRCD(1)                           CER055
     D*********WTbRDE       S             22    DIM(16) ALT(WTbGrp)                           CER031
     D*WTbRDE***       S             22    DIM(56) ALT(WTbGrp)                         CER031 CER055
     D WTbRDE          S             22    DIM(67) ALT(WTbGrp)                                CER055
 
      ** Compile-time array to contain Deal Type Codes/Narratives
     D WTabCod         S              2    DIM(10) CTDATA PERRCD(1)
     D WTabNar         S             35    DIM(10) ALT(WTabCod)
 
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
     D PCommit         S              3A
     D PCustNumChr6    S              6A
     D PItmRef         S              8A
     D PMode           S             10A
     D PRtnCode        S              7A
     D W0CMT           S              3A
     D CCG015          S              1A
     D PChgType        S              1A
     D W0SPAT          S             70A
     D CER055          S              1A                                                      CER055
     D CFT004          S              1A                                                      CER055
 
      ** Access Object Parameter fields
     D PRtCd           S              7A
     D POptn           S              7A
     D PCustNo         S             10A
     D PChr003         S              3A
     D PErrInf         S              7A
      *                                                                                       CER031
     D Idx             S              3P 0                                                    CER031
     D #MsgData        S             45A                                                      CER031
     D #MsgID          S              7A                                                      CER031
     D PRtcd2          S             10A                                                      CER031
     D PNetwork        S              6A                                                      CER031
     D PMsgType        S              3A                                                      CER031
     D PBrca           S              3A                                                      CER031
     D*PCusNo***       S              6  0                                             CER031 CER059
     D PCusNo          S              6A                                                      CER059
     D PCcy            S              3A                                                      CER031
     D PAccd           S             10S 0                                                    CER031
     D PAcSq           S              2S 0                                                    CER031
     D PDCIn           S              1A                                                      CER031
     D PTranTp         S              5A                                                      CER031
     D PNarr1          S             65A                                                      CER031
     D PNarr2          S             65A                                                      CER031
     D PNarr3          S             65A                                                      CER031
     D PNarr4          S             65A                                                      CER031
     D PNarr5          S             65A                                                      CER031
     D PNarr6          S             65A                                                      CER031
     D PRtFmt1         S             70A                                                      CER031
     D PRtFmt2         S             70A                                                      CER031
     D PRtFmt3         S             70A                                                      CER031
     D PRtFmt4         S             70A                                                      CER031
     D PRtFmt5         S             70A                                                      CER031
     D PRtFmt6         S             70A                                                      CER031
     D PRtFmt7         S             70A                                                      CER031
     D PRtFmt8         S             70A                                                      CER031
     D PRtFmt9         S             70A                                                      CER031
     D PRtFmt10        S             70A                                                      CER031
     D PRtFmt11        S             70A                                                      CER031
     D PRtFmt12        S             70A                                                      CER031
     D PRtFmt13        S             70A                                                      CER031
     D PRtFmt14        S             70A                                                      CER031
     D PRtFmt15        S             70A                                                      CER031
     D PRtFmt16        S             70A                                                      CER031
     D PRtFmt17        S             70A                                                      CER031
     D PRtFmt18        S             70A                                                      CER031
     D PRtFmt19        S             70A                                                      CER031
     D PRtFmt20        S             70A                                                      CER031
     D WFTType         S              2A                                                      CER031
     D CER031          S              1A                                                      CER031
     D WFUND           S             15A                                                      CER031
      *                                                                                     BUG23445
     D KNwrk           S              6A                                                    BUG23445
     D KAccd           S             10S 0                                                  BUG23445
     D KAcsq           S              2S 0                                                  BUG23445
     D CGL013          S              1A                                                    BUG23445
 
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
                                                                                              CER031
     C                   IF        CER031 = 'Y'                                               CER031
                                                                                              CER031
     C                   EXSR      SrRtvExNr                                                  CER031
                                                                                              CER031
     C                   ENDIF                                                                CER031
 
      ** Decrement Path DS index
 
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
 
     C                   EXSR      POPGRS
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************                       CER031
      /EJECT                                                                                  CER031
      *****************************************************************                       CER031
      *                                                               *                       CER031
      *  SrRtvExNr - Retrieve Extended Narratives based on            *                       CER031
      *              Transaction Type                                 *                       CER031
      *                                                               *                       CER031
      *  Called by - SrTREADV                                         *                       CER031
      *                                                               *                       CER031
      *  Calls - SrCExNar                                             *                       CER031
      *                                                               *                       CER031
      *****************************************************************                       CER031
     C     SrRtvExNr     BEGSR                                                                CER031
      *                                                                                       CER031
      ** Set up subroutine stack name                                                         CER031
      *                                                                                       CER031
     C                   ADD       1             Q                                            CER031
     C                   MOVEL     'SrRtvExNr'   @STK(Q)                                      CER031
     C                   IF        FUND <>   *BLANKS                                          CER031
     C                   EVAL      WFUND = %SUBST(FUND : 1: 15)                               CER031
      *                                                                                       CER031
      ** Extract Movement Type - Incoming / Outgoing                                          CER031
      *                                                                                       CER031
     C                   EVAL      WFTType = %SUBST(FUND:12:2)                                CER031
      *                                                                                       CER031
      ** Incoming Payment                                                                     CER031
      *                                                                                       CER031
     C                   IF        WFTType = 'IN'                                             CER031
     C     WFUND         CHAIN     INPAY                                                      CER031
     C                   IF        %FOUND                                                     CER031
     C                   MOVEL     IEXT1         PNarr1                                       CER031
     C                   MOVEL     IEXT2         PNarr2                                       CER031
     C                   MOVEL     IEXT3         PNarr3                                       CER031
     C                   MOVEL     IEXT4         PNarr4                                       CER031
     C                   MOVEL     IEXT5         PNarr5                                       CER031
     C                   MOVEL     IEXT6         PNarr6                                       CER031
      *                                                                                       CER031
     C                   EXSR      SrCExNar                                                   CER031
      *                                                                                       CER031
     C                   ELSE                                                                 CER031
     C                   MOVEL     'INPAYDD'     W0File                                       CER031
     C                   MOVEL     FUND          W0Key                                        CER031
     C                   MOVEL     5             W0ERNB                                       CER031
     C                   EVAL      W0MsgD = 'MEM5004'                                         CER031
     C                   EVAL      W0MsgF = 'MIDAS'                                           CER031
      *                                                                                       CER031
     C                   EXSR      SRERR                                                      CER031
      *                                                                                       CER031
     C                   ENDIF                                                                CER031
      *                                                                                       CER031
      ** Outgoing Payment                                                                     CER031
      *                                                                                       CER031
     C                   ELSEIF    WFTType = 'OP'                                             CER031
     C     WFUND         CHAIN     OTPAY                                                      CER031
     C                   IF        %FOUND                                                     CER031
      *                                                                                       CER031
      ** Extract Debit Narratives                                                             CER031
      *                                                                                       CER031
     C                   MOVEL     OPEXT1        PNarr1                                       CER031
     C                   MOVEL     OPEXT2        PNarr2                                       CER031
     C                   MOVEL     OPEXT3        PNarr3                                       CER031
     C                   MOVEL     OPEXT4        PNarr4                                       CER031
     C                   MOVEL     OPEXT5        PNarr5                                       CER031
     C                   MOVEL     OPEXT6        PNarr6                                       CER031
      *                                                                                       CER031
     C                   EXSR      SrDExNar                                                   CER031
      *                                                                                       CER031
      ** Extract Credit Narratives                                                            CER031
      *                                                                                       CER031
     C                   MOVEL     OPEXC1        PNarr1                                       CER031
     C                   MOVEL     OPEXC2        PNarr2                                       CER031
     C                   MOVEL     OPEXC3        PNarr3                                       CER031
     C                   MOVEL     OPEXC4        PNarr4                                       CER031
     C                   MOVEL     OPEXC5        PNarr5                                       CER031
     C                   MOVEL     OPEXC6        PNarr6                                       CER031
      *                                                                                       CER031
     C                   EXSR      SrCExNar                                                   CER031
      *                                                                                       CER031
     C                   ELSE                                                                 CER031
     C                   MOVEL     'OTPAYDD'     W0File                                       CER031
     C                   MOVEL     FUND          W0Key                                        CER031
     C                   MOVEL     6             W0ERNB                                       CER031
     C                   EVAL      W0MsgD = 'MEM5004'                                         CER031
     C                   EVAL      W0MsgF = 'MIDAS'                                           CER031
      *                                                                                       CER031
     C                   EXSR      SRERR                                                      CER031
      *                                                                                       CER031
     C                   ENDIF                                                                CER031
     C                   ENDIF                                                                CER031
     C                   ENDIF                                                                CER031
      *                                                                                       CER031
     C                   EVAL      @STK(Q) = '  '                                             CER031
     C                   SUB       1             Q                                            CER031
      *                                                                                       CER031
     C                   ENDSR                                                                CER031
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
 
     C                   MOVEL     FUND          ##D(1)
 
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
 
     C                   IF        FUND <> *BLANKS
     C                   MOVEL     FUND          ##D(6)
     C                   ELSE
     C                   EVAL      ##D(6) = 'FUNDS TRANSFER TRANSACTION'
     C                   ENDIF
 
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
      *****************************************************************                       CER031
      /EJECT                                                                                  CER031
      *****************************************************************                       CER031
      *                                                               *                       CER031
      *  SrDExNar - Extract Extended Debit Narrative                  *                       CER031
      *                                                               *                       CER031
      *  Called by - Main routine                                     *                       CER031
      *                                                               *                       CER031
      *  Calls - SrRtvRDE, SrPath, PSHGRS, SrPackDta                  *                       CER031
      *                                                               *                       CER031
      *****************************************************************                       CER031
      *                                                                                       CER031
     C     SrDExNar      BEGSR                                                                CER031
      *                                                                                       CER031
      ** Set up subroutine stack name                                                         CER031
      *                                                                                       CER031
     C                   ADD       1             Q                                            CER031
     C                   MOVEL     'SrDExNar '   @STK(Q)                                      CER031
      *                                                                                       CER031
      ** Set up path multi-occurrence data structure & path string                            CER031
      *                                                                                       CER031
     C                   ADD       1             WPx                                          CER031
     C     WPx           OCCUR     WMDsPath                                                   CER031
     C                   MOVEL     'DEXNAR'      WMDsPathGrp                                  CER031
      *                                                                                       CER031
     C                   EXSR      SrPath                                                     CER031
     C                   EXSR      PSHGRS                                                     CER031
      *                                                                                       CER031
      ** Retrieve RDE info                                                                    CER031
      *                                                                                       CER031
     C                   MOVEL     'DEXNAR'      WGrpNme                                      CER031
      *                                                                                       CER031
     C                   EXSR      SrRtvRDE                                                   CER031
      *                                                                                       CER031
      ** Format Narrative fields                                                              CER031
      *                                                                                       CER031
     C                   EVAL      PBrca = BRCA                                               CER031
     C                   MOVEL     CUSN          PCusno                                       CER031
     C                   EVAL      PCcy = CCYD                                                CER031
     C                   EVAL      PAccd = ACDE                                               CER031
     C                   EVAL      PAcsq = ASNC                                               CER031
     C                   EVAL      POptn = '*FORMAT'                                          CER031
      *                                                                                     BUG23445
      ** Format according to network Paper if Account is linked                             BUG23445
      *                                                                                     BUG23445
     C                   MOVEL     *BLANKS       PNetwork                                   BUG23445
     C     CGL013        IFEQ      'Y'                                                      BUG23445
     C                   MOVEL     'PAPER'       KNwrk                                      BUG23445
     C                   MOVE      PAccd         KAccd                                      BUG23445
     C                   MOVE      PAcsq         KAcsq                                      BUG23445
     C*****KAcct         CHAIN     GLNW94L1                           99          BUG23445 BUG23445A
     C     KAcct         CHAIN     GLNWACL1                           99                   BUG23445A
     C     *IN99         IFEQ      *OFF                                                     BUG23445
     C**********         MOVEL     N4NWRK        PNetwork                         BUG23445 BUG23445A
     C                   MOVEL     NANWRK        PNetwork                                  BUG23445A
     C                   ENDIF                                                              BUG23445
     C                   ENDIF                                                              BUG23445
      *                                                                                       CER031
      ** Call the MG001900 access object to format the extended narratives                    CER031
      *                                                                                       CER031
     C                   CALL      'MG001900'                                                 CER031
     C                   PARM                    PRtcd2                                       CER031
     C                   PARM                    POptn                                        CER031
     C                   PARM                    PNetwork                                     CER031
     C                   PARM                    PMsgType                                     CER031
     C                   PARM                    PBrca                                        CER031
     C                   PARM                    PCusno                                       CER031
     C                   PARM                    PCcy                                         CER031
     C                   PARM                    PAccd                                        CER031
     C                   PARM                    PAcSq                                        CER031
     C                   PARM                    PDCin                                        CER031
     C                   PARM                    PTranTp                                      CER031
     C                   PARM                    PNarr1                                       CER031
     C                   PARM                    PNarr2                                       CER031
     C                   PARM                    PNarr3                                       CER031
     C                   PARM                    PNarr4                                       CER031
     C                   PARM                    PNarr5                                       CER031
     C                   PARM                    PNarr6                                       CER031
     C**********         PARM                    PRtFmt1                             CER031 BUG23197
     C**********         PARM                    PRtFmt2                             CER031 BUG23197
     C**********         PARM                    PRtFmt3                             CER031 BUG23197
     C**********         PARM                    PRtFmt4                             CER031 BUG23197
     C**********         PARM                    PRtFmt5                             CER031 BUG23197
     C**********         PARM                    PRtFmt6                             CER031 BUG23197
     C**********         PARM                    PRtFmt7                             CER031 BUG23197
     C**********         PARM                    PRtFmt8                             CER031 BUG23197
     C**********         PARM                    PRtFmt9                             CER031 BUG23197
     C**********         PARM                    PRtFmt10                            CER031 BUG23197
     C**********         PARM                    PRtFmt11                            CER031 BUG23197
     C**********         PARM                    PRtFmt12                            CER031 BUG23197
     C**********         PARM                    PRtFmt13                            CER031 BUG23197
     C**********         PARM                    PRtFmt14                            CER031 BUG23197
     C**********         PARM                    PRtFmt15                            CER031 BUG23197
     C**********         PARM                    PRtFmt16                            CER031 BUG23197
     C**********         PARM                    PRtFmt17                            CER031 BUG23197
     C**********         PARM                    PRtFmt18                            CER031 BUG23197
     C**********         PARM                    PRtFmt19                            CER031 BUG23197
     C**********         PARM                    PRtFmt20                            CER031 BUG23197
     C                   PARM      *Blanks       PRtFmt1                                    BUG23197
     C                   PARM      *Blanks       PRtFmt2                                    BUG23197
     C                   PARM      *Blanks       PRtFmt3                                    BUG23197
     C                   PARM      *Blanks       PRtFmt4                                    BUG23197
     C                   PARM      *Blanks       PRtFmt5                                    BUG23197
     C                   PARM      *Blanks       PRtFmt6                                    BUG23197
     C                   PARM      *Blanks       PRtFmt7                                    BUG23197
     C                   PARM      *Blanks       PRtFmt8                                    BUG23197
     C                   PARM      *Blanks       PRtFmt9                                    BUG23197
     C                   PARM      *Blanks       PRtFmt10                                   BUG23197
     C                   PARM      *Blanks       PRtFmt11                                   BUG23197
     C                   PARM      *Blanks       PRtFmt12                                   BUG23197
     C                   PARM      *Blanks       PRtFmt13                                   BUG23197
     C                   PARM      *Blanks       PRtFmt14                                   BUG23197
     C                   PARM      *Blanks       PRtFmt15                                   BUG23197
     C                   PARM      *Blanks       PRtFmt16                                   BUG23197
     C                   PARM      *Blanks       PRtFmt17                                   BUG23197
     C                   PARM      *Blanks       PRtFmt18                                   BUG23197
     C                   PARM      *Blanks       PRtFmt19                                   BUG23197
     C                   PARM      *Blanks       PRtFmt20                                   BUG23197
     C                   PARM                    Idx                                          CER031
     C                   PARM                    FldNamXAr                                    CER031
     C                   PARM                    MsgIDXAr                                     CER031
     C                   PARM                    MsgDtaXAr                                    CER031
     C                   PARM                    WFldNmXAr                                    CER031
     C                   PARM                    WMsgIDXAr                                    CER031
     C                   PARM                    WmsgDtXAr                                    CER031
      *                                                                                       CER031
     C                   IF        PRtcd2 = *BLANKS                                           CER031
     C                             OR PRtcd2 = '*FORMAT'                                      CER031
     C                   MOVEL     PRtFmt1       ##D(1)                                       CER031
     C                   MOVEL     PRtFmt2       ##D(2)                                       CER031
     C                   MOVEL     PRtFmt3       ##D(3)                                       CER031
     C                   MOVEL     PRtFmt4       ##D(4)                                       CER031
     C                   MOVEL     PRtFmt5       ##D(5)                                       CER031
     C                   MOVEL     PRtFmt6       ##D(6)                                       CER031
     C                   MOVEL     PRtFmt7       ##D(7)                                       CER031
     C                   MOVEL     PRtFmt8       ##D(8)                                       CER031
     C                   MOVEL     PRtFmt9       ##D(9)                                       CER031
     C                   MOVEL     PRtFmt10      ##D(10)                                      CER031
     C                   MOVEL     PRtFmt11      ##D(11)                                      CER031
     C                   MOVEL     PRtFmt12      ##D(12)                                      CER031
     C                   MOVEL     PRtFmt13      ##D(13)                                      CER031
     C                   MOVEL     PRtFmt14      ##D(14)                                      CER031
     C                   MOVEL     PRtFmt15      ##D(15)                                      CER031
     C                   MOVEL     PRtFmt16      ##D(16)                                      CER031
     C                   MOVEL     PRtFmt17      ##D(17)                                      CER031
     C                   MOVEL     PRtFmt18      ##D(18)                                      CER031
     C                   MOVEL     PRtFmt19      ##D(19)                                      CER031
     C                   MOVEL     PRtFmt20      ##D(20)                                      CER031
      *                                                                                       CER031
     C                   ELSE                                                                 CER031
      *                                                                                       CER031
     C                   EVAL      W0File = 'MG001900'                                        CER031
     C                   EVAL      W0Key = FUND                                               CER031
     C                   EVAL      W0ERNB = 07                                                CER031
     C                   EVAL      W0MsgD = 'MEM5003'                                         CER031
     C                   EVAL      W0MsgF = 'MIDAS'                                           CER031
      *                                                                                       CER031
     C                   EXSR      SRERR                                                      CER031
      *                                                                                       CER031
     C                   ENDIF                                                                CER031
      *                                                                                       CER031
      ** Accumulate RDEs and associated data and output to CGUDTAPD                           CER031
      *                                                                                       CER031
     C                   EXSR      SrPackDta                                                  CER031
      *                                                                                       CER031
      ** Decrement Path DS Index                                                              CER031
      *                                                                                       CER031
     C     WPx           OCCUR     WMDsPath                                                   CER031
     C                   CLEAR                   WMDSPathGrp                                  CER031
     C                   SUB       1             WPx                                          CER031
      *                                                                                       CER031
     C                   EXSR      POPGRS                                                     CER031
      *                                                                                       CER031
     C                   EVAL      @STK(Q) = '  '                                             CER031
     C                   SUB       1             Q                                            CER031
      *                                                                                       CER031
     C                   ENDSR                                                                CER031
      *****************************************************************                       CER031
      /EJECT                                                                                  CER031
      *****************************************************************                       CER031
      *                                                               *                       CER031
      *  SrCExNar - Extract Extended Credit Narratives                *                       CER031
      *                                                               *                       CER031
      *  Called by - SrRtvExNr                                        *                       CER031
      *                                                               *                       CER031
      *  Calls - SrRtvRDE, SrPackDta                                  *                       CER031
      *                                                               *                       CER031
      *****************************************************************                       CER031
      *                                                                                       CER031
     C     SrCExNar      BEGSR                                                                CER031
      *                                                                                       CER031
      ** Set up subroutine stack name                                                         CER031
      *                                                                                       CER031
     C                   ADD       1             Q                                            CER031
     C                   MOVEL     'SrCExNar'    @STK(Q)                                      CER031
      *                                                                                       CER031
      ** Set up path multi-occurrence data structure & path string                            CER031
      *                                                                                       CER031
     C                   ADD       1             WPx                                          CER031
     C     WPx           OCCUR     WMDsPath                                                   CER031
     C                   MOVEL     'CEXNAR'      WMDsPathGrp                                  CER031
      *                                                                                       CER031
     C                   EXSR      SrPath                                                     CER031
     C                   EXSR      PSHGRS                                                     CER031
      *                                                                                       CER031
      ** Retrieve RDE info                                                                    CER031
      *                                                                                       CER031
     C                   MOVEL     'CEXNAR'      WGrpNme                                      CER031
      *                                                                                       CER031
     C                   EXSR      SrRtvRDE                                                   CER031
      *                                                                                       CER031
      ** Format Narrative fields                                                              CER031
      *                                                                                       CER031
     C                   EVAL      PBrca = BRCA                                               CER031
     C                   MOVEL     CUSN          PCusno                                       CER031
     C                   EVAL      PCcy = CCYD                                                CER031
     C                   EVAL      PAccd = ACDE                                               CER031
     C                   EVAL      PAcsq = ASNC                                               CER031
     C                   EVAL      POptn = '*FORMAT'                                          CER031
      *                                                                                     BUG23445
      ** Format according to network Paper if Account is linked                             BUG23445
      *                                                                                     BUG23445
     C                   MOVEL     *BLANKS       PNetwork                                   BUG23445
     C     CGL013        IFEQ      'Y'                                                      BUG23445
     C                   MOVEL     'PAPER'       KNwrk                                      BUG23445
     C                   MOVE      PAccd         KAccd                                      BUG23445
     C                   MOVE      PAcsq         KAcsq                                      BUG23445
     C*****KAcct         CHAIN     GLNW94L1                           99          BUG23445 BUG23445A
     C     KAcct         CHAIN     GLNWACL1                           99                   BUG23445A
     C     *IN99         IFEQ      *OFF                                                     BUG23445
     C**********         MOVEL     N4NWRK        PNetwork                         BUG23445 BUG23445A
     C                   MOVEL     NANWRK        PNetwork                                  BUG23445A
     C                   ENDIF                                                              BUG23445
     C                   ENDIF                                                              BUG23445
      *                                                                                       CER031
     C                   CALL      'MG001900'                                                 CER031
     C                   PARM                    PRtcd2                                       CER031
     C                   PARM                    POptn                                        CER031
     C                   PARM                    PNetwork                                     CER031
     C                   PARM                    PMsgType                                     CER031
     C                   PARM                    PBrca                                        CER031
     C                   PARM                    PCusno                                       CER031
     C                   PARM                    PCcy                                         CER031
     C                   PARM                    PAccd                                        CER031
     C                   PARM                    PAcSq                                        CER031
     C                   PARM                    PDCin                                        CER031
     C                   PARM                    PTranTp                                      CER031
     C                   PARM                    PNarr1                                       CER031
     C                   PARM                    PNarr2                                       CER031
     C                   PARM                    PNarr3                                       CER031
     C                   PARM                    PNarr4                                       CER031
     C                   PARM                    PNarr5                                       CER031
     C                   PARM                    PNarr6                                       CER031
     C**********         PARM                    PRtFmt1                             CER031 BUG23197
     C**********         PARM                    PRtFmt2                             CER031 BUG23197
     C**********         PARM                    PRtFmt3                             CER031 BUG23197
     C**********         PARM                    PRtFmt4                             CER031 BUG23197
     C**********         PARM                    PRtFmt5                             CER031 BUG23197
     C**********         PARM                    PRtFmt6                             CER031 BUG23197
     C**********         PARM                    PRtFmt7                             CER031 BUG23197
     C**********         PARM                    PRtFmt8                             CER031 BUG23197
     C**********         PARM                    PRtFmt9                             CER031 BUG23197
     C**********         PARM                    PRtFmt10                            CER031 BUG23197
     C**********         PARM                    PRtFmt11                            CER031 BUG23197
     C**********         PARM                    PRtFmt12                            CER031 BUG23197
     C**********         PARM                    PRtFmt13                            CER031 BUG23197
     C**********         PARM                    PRtFmt14                            CER031 BUG23197
     C**********         PARM                    PRtFmt15                            CER031 BUG23197
     C**********         PARM                    PRtFmt16                            CER031 BUG23197
     C**********         PARM                    PRtFmt17                            CER031 BUG23197
     C**********         PARM                    PRtFmt18                            CER031 BUG23197
     C**********         PARM                    PRtFmt19                            CER031 BUG23197
     C**********         PARM                    PRtFmt20                            CER031 BUG23197
     C                   PARM      *Blanks       PRtFmt1                                    BUG23197
     C                   PARM      *Blanks       PRtFmt2                                    BUG23197
     C                   PARM      *Blanks       PRtFmt3                                    BUG23197
     C                   PARM      *Blanks       PRtFmt4                                    BUG23197
     C                   PARM      *Blanks       PRtFmt5                                    BUG23197
     C                   PARM      *Blanks       PRtFmt6                                    BUG23197
     C                   PARM      *Blanks       PRtFmt7                                    BUG23197
     C                   PARM      *Blanks       PRtFmt8                                    BUG23197
     C                   PARM      *Blanks       PRtFmt9                                    BUG23197
     C                   PARM      *Blanks       PRtFmt10                                   BUG23197
     C                   PARM      *Blanks       PRtFmt11                                   BUG23197
     C                   PARM      *Blanks       PRtFmt12                                   BUG23197
     C                   PARM      *Blanks       PRtFmt13                                   BUG23197
     C                   PARM      *Blanks       PRtFmt14                                   BUG23197
     C                   PARM      *Blanks       PRtFmt15                                   BUG23197
     C                   PARM      *Blanks       PRtFmt16                                   BUG23197
     C                   PARM      *Blanks       PRtFmt17                                   BUG23197
     C                   PARM      *Blanks       PRtFmt18                                   BUG23197
     C                   PARM      *Blanks       PRtFmt19                                   BUG23197
     C                   PARM      *Blanks       PRtFmt20                                   BUG23197
     C                   PARM                    Idx                                          CER031
     C                   PARM                    FldNamXAr                                    CER031
     C                   PARM                    MsgIDXAr                                     CER031
     C                   PARM                    MsgDtaXAr                                    CER031
     C                   PARM                    WFldNmXAr                                    CER031
     C                   PARM                    WMsgIDXAr                                    CER031
     C                   PARM                    WmsgDtXAr                                    CER031
      *                                                                                       CER031
     C                   IF        PRtcd2 = *BLANKS                                           CER031
     C                             OR PRtcd2 = '*FORMAT'                                      CER031
     C                   MOVEL     PRtFmt1       ##D(1)                                       CER031
     C                   MOVEL     PRtFmt2       ##D(2)                                       CER031
     C                   MOVEL     PRtFmt3       ##D(3)                                       CER031
     C                   MOVEL     PRtFmt4       ##D(4)                                       CER031
     C                   MOVEL     PRtFmt5       ##D(5)                                       CER031
     C                   MOVEL     PRtFmt6       ##D(6)                                       CER031
     C                   MOVEL     PRtFmt7       ##D(7)                                       CER031
     C                   MOVEL     PRtFmt8       ##D(8)                                       CER031
     C                   MOVEL     PRtFmt9       ##D(9)                                       CER031
     C                   MOVEL     PRtFmt10      ##D(10)                                      CER031
     C                   MOVEL     PRtFmt11      ##D(11)                                      CER031
     C                   MOVEL     PRtFmt12      ##D(12)                                      CER031
     C                   MOVEL     PRtFmt13      ##D(13)                                      CER031
     C                   MOVEL     PRtFmt14      ##D(14)                                      CER031
     C                   MOVEL     PRtFmt15      ##D(15)                                      CER031
     C                   MOVEL     PRtFmt16      ##D(16)                                      CER031
     C                   MOVEL     PRtFmt17      ##D(17)                                      CER031
     C                   MOVEL     PRtFmt18      ##D(18)                                      CER031
     C                   MOVEL     PRtFmt19      ##D(19)                                      CER031
     C                   MOVEL     PRtFmt20      ##D(20)                                      CER031
      *                                                                                       CER031
     C                   ELSE                                                                 CER031
      *                                                                                       CER031
     C                   EVAL      W0File = 'MG001900'                                        CER031
     C                   EVAL      W0Key = FUND                                               CER031
     C                   EVAL      W0ERNB = 08                                                CER031
     C                   EVAL      W0MsgD = 'MEM5003'                                         CER031
     C                   EVAL      W0MsgF = 'MIDAS'                                           CER031
      *                                                                                       CER031
     C                   EXSR      SRERR                                                      CER031
      *                                                                                       CER031
     C                   ENDIF                                                                CER031
      *                                                                                       CER031
      ** Accumulate RDEs and associated data and output to CGUDTAPD                           CER031
      *                                                                                       CER031
     C                   EXSR      SrPackDta                                                  CER031
      *                                                                                       CER031
      ** Decrement Path DS Index                                                              CER031
      *                                                                                       CER031
     C     WPx           OCCUR     WMDsPath                                                   CER031
     C                   CLEAR                   WMDSPathGrp                                  CER031
     C                   SUB       1             WPx                                          CER031
      *                                                                                       CER031
     C                   EXSR      POPGRS                                                     CER031
      *                                                                                       CER031
     C                   EVAL      @STK(Q) = '  '                                             CER031
     C                   SUB       1             Q                                            CER031
      *                                                                                       CER031
     C                   ENDSR                                                                CER031
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
 
      ** Module ID (madatory)
 
     C                   MOVEL     'RE'          DRMODI
 
      ** MIDAS Transaction number
 
     C                   MOVEL     FUND          DRMTRN
 
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
     C                   PARM                    W0CMT
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
 
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN
     C                   PARM                    W0CMT
     C                   PARM                    PDsRetRsac
     C                   PARM                    CCG015
     C                   PARM                    PChgType
 
     C                   Z-ADD     0             Q
 
      ** Initialise XML increment
 
     C                   EXSR      INIXML
 
      ** Index of WMDsPath
 
     C                   Z-ADD     0             WPx
     C                   CLEAR                   WMDsPath
 
     C                   CALL      'AOSARDR0'                                                 CER031
     C                   PARM      *BLANKS       PRtcd                                        CER031
     C                   PARM      '*VERIFY'     POptn                                        CER031
     C                   PARM      'CER031'      PSard             6                          CER031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER031
                                                                                              CER031
     C                   IF        PRtcd = ' '                                                CER031
     C                   EVAL      CER031 = 'Y'                                               CER031
     C                   ELSE                                                                 CER031
     C                   EVAL      CER031 = 'N'                                               CER031
     C                   ENDIF                                                                CER031
                                                                                              CER031
      *                                                                                     BUG23445
      ** Access Switchable Features file and check if CCG015 is                             BUG23445
      ** installed                                                                          BUG23445
      *                                                                                     BUG23445
     C                   CALL      'AOSARDR0'                                               BUG23445
     C                   PARM      *BLANKS       PRtcd                                      BUG23445
     C                   PARM      '*VERIFY'     POptn                                      BUG23445
     C                   PARM      'CGL013'      PSard                                      BUG23445
      *                                                                                     BUG23445
     C     PRtcd         IFEQ      *BLANK                                                   BUG23445
     C                   MOVE      'Y'           CGL013                                     BUG23445
     C                   ELSE                                                               BUG23445
     C                   MOVE      'N'           CGL013                                     BUG23445
     C     PRtcd         IFNE      '*NRF   '                                                BUG23445
     C                   MOVEL     'SCSARDPD'    W0File                                     BUG23445
     C                   MOVEL     '*CALL'       W0Key                                      BUG23445
     C                   Z-ADD     09            W0ERNB                                     BUG23445
     C                   MOVEL     'MEM5003'     W0Msgd                                     BUG23445
     C                   MOVEL     'MIDAS  '     W0Msgf                                     BUG23445
     C                   EXSR      SRERR                                                    BUG23445
     C                   ENDIF                                                              BUG23445
     C                   ENDIF                                                              BUG23445
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
      *                                                                                     BUG23445
      ***Keylist*for*file**GLNW94L1                                               BUG23445 BUG23445A
      ** Keylist for file  GLNWACL1                                                        BUG23445A
      *                                                                                     BUG23445
     C     KAcct         KLIST                                                              BUG23445
     C                   KFLD                    KNwrk                                      BUG23445
     C                   KFLD                    PBrca                                      BUG23445
     C                   KFLD                    PCusno                                     BUG23445
     C                   KFLD                    PCcy                                       BUG23445
     C                   KFLD                    KAccd                                      BUG23445
     C                   KFLD                    KAcsq                                      BUG23445
      *                                                                                       CER055
     C     KACKEY        KLIST                                                                CER055
     C                   KFLD                    CUSN                                         CER055
     C                   KFLD                    CCYD                                         CER055
     C                   KFLD                    ACDE                                         CER055
     C                   KFLD                    ASNC                                         CER055
     C                   KFLD                    BRCA                                         CER055
      *                                                                                     BUG23445
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
DEXNAR0001 DEX_NARR01                    Extended Narrative 1                                 CER031
DEXNAR0002 DEX_NARR02                    Extended Narrative 2                                 CER031
DEXNAR0003 DEX_NARR03                    Extended Narrative 3                                 CER031
DEXNAR0004 DEX_NARR04                    Extended Narrative 4                                 CER031
DEXNAR0005 DEX_NARR05                    Extended Narrative 5                                 CER031
DEXNAR0006 DEX_NARR06                    Extended Narrative 6                                 CER031
DEXNAR0007 DEX_NARR07                    Extended Narrative 7                                 CER031
DEXNAR0008 DEX_NARR08                    Extended Narrative 8                                 CER031
DEXNAR0009 DEX_NARR09                    Extended Narrative 9                                 CER031
DEXNAR0010 DEX_NARR10                    Extended Narrative 10                                CER031
DEXNAR0011 DEX_NARR11                    Extended Narrative 11                                CER031
DEXNAR0012 DEX_NARR12                    Extended Narrative 12                                CER031
DEXNAR0013 DEX_NARR13                    Extended Narrative 13                                CER031
DEXNAR0014 DEX_NARR14                    Extended Narrative 14                                CER031
DEXNAR0015 DEX_NARR15                    Extended Narrative 15                                CER031
DEXNAR0016 DEX_NARR16                    Extended Narrative 16                                CER031
DEXNAR0017 DEX_NARR17                    Extended Narrative 17                                CER031
DEXNAR0018 DEX_NARR18                    Extended Narrative 18                                CER031
DEXNAR0019 DEX_NARR19                    Extended Narrative 19                                CER031
DEXNAR0020 DEX_NARR20                    Extended Narrative 20                                CER031
CEXNAR0001 CEX_NARR01                    Extended Narrative 1 Crd                             CER031
CEXNAR0002 CEX_NARR02                    Extended Narrative 2 Crd                             CER031
CEXNAR0003 CEX_NARR03                    Extended Narrative 3 Crd                             CER031
CEXNAR0004 CEX_NARR04                    Extended Narrative 4 Crd                             CER031
CEXNAR0005 CEX_NARR05                    Extended Narrative 5 Crd                             CER031
CEXNAR0006 CEX_NARR06                    Extended Narrative 6 Crd                             CER031
CEXNAR0007 CEX_NARR07                    Extended Narrative 7 Crd                             CER031
CEXNAR0008 CEX_NARR08                    Extended Narrative 8 Crd                             CER031
CEXNAR0009 CEX_NARR09                    Extended Narrative 9 Crd                             CER031
CEXNAR0010 CEX_NARR10                    Extended Narrative 10 Crd                            CER031
CEXNAR0011 CEX_NARR11                    Extended Narrative 11 Crd                            CER031
CEXNAR0012 CEX_NARR12                    Extended Narrative 12 Crd                            CER031
CEXNAR0013 CEX_NARR13                    Extended Narrative 13 Crd                            CER031
CEXNAR0014 CEX_NARR14                    Extended Narrative 14 Crd                            CER031
CEXNAR0015 CEX_NARR15                    Extended Narrative 15 Crd                            CER031
CEXNAR0016 CEX_NARR16                    Extended Narrative 16 Crd                            CER031
CEXNAR0017 CEX_NARR17                    Extended Narrative 17 Crd                            CER031
CEXNAR0018 CEX_NARR18                    Extended Narrative 18 Crd                            CER031
CEXNAR0019 CEX_NARR19                    Extended Narrative 19 Crd                            CER031
CEXNAR0020 CEX_NARR20                    Extended Narrative 20 Crd                            CER031
** WTabCod/WTabNar  - Deal Code/Deal Type Narratives
ININCOMING PAYMENTS
OPOUTGOING PAYMENTS
RPREGULAR PAYMENTS
CPCHEQUES TO BE PAID
CCCHEQUES TO BE COLLECTED
BIINCOMING CUSTOMER CREDIT TRANSFER
BOOUTGOING CUSTOMER CREDIT TRANSFER
RIINCOMING REQUEST FOR TRANSFER
ROOUTGOING REQUEST FOR TRANSFER
NTNOSTRO TRANSFER
