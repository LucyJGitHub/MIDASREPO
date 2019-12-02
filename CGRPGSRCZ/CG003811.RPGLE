     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Retail Advice for GL - Extract')              *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG003811 - Retail Advice for GL - Extract                    *
      *                                                               *
      *  Function:  This program produces the customer correspondence *
      *             onto the UDC extract files required for           *
      *             production of the GL Retail Advices through       *
      *             Correspondence Manager.                           *
      *                                                               *
      *  Called By: CG003810 - Retail Advice for GL - Driver          *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CER055             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23742           Date 09May09               *
      *                 BUG23445A          Date 19Apr09               *
      *                 BUG23445           Date 17Mar09               *
      *                 BUG23197           Date 03Mar09               *
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
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23742 - Improper handling of Ext Narr from Batch          *
      *             Interface Input                                   *
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
      ** Midas GL Journal entry - add. inf. - retrieval                                       CER031
      *                                                                                       CER031
     FGLJENXL2  IF   E           K DISK                                                       CER031
      *                                                                                       CER031
      ** Midas GL Network accounts - MT94x - retrieval                                      BUG23445
      *                                                                                     BUG23445
     F*GLNW94L1  IF   E           K DISK                                          BUG23445 BUG23445A
     FGLNWACL1  IF   E           K DISK                                                    BUG23445A
      *                                                                                     BUG23445
      ** GL MultiCash Narratives File                                                       BUG23742
      *                                                                                     BUG23742
     FGLMNARL1  IF   E           K DISK                                                     BUG23742
      *                                                                                     BUG23742
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

     D/COPY ZACPYSRC,ERR_XARRYS                                                               CER031
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     D WCPrtItmTyp     C                   CONST('RTL_ADV')
      ** Print Item Type

     D WCPrtItmSubTyp  C                   CONST('GL')
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

      *                                                                                       CER031
      ** Switchable Features Descriptions                                                     CER031
      *                                                                                       CER031
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER031
      *                                                                                       CER031
      ** Data Structures used by Access Programs                                              CER031
      *                                                                                       CER031
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER031
      *                                                                                       CER031
     D PEDsCGUDCRPD  E DS                  EXTNAME(CGUDCRPD)
      ** Data structure for UDC data reference file

     D WDsRSAC       E DS                  EXTNAME(RSACMTPD)
      ** Data structure for GL Account Movements
     D  WNrtd                 29     56

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
     D**********WTbGrp          S             10    DIM(16) CTDATA PERRCD(1)                  CER031
     D*WTbGrp***       S             10    DIM(56) CTDATA PERRCD(1)                  CER031 BUG23742
     D*WTbGrp***       S             10    DIM(60) CTDATA PERRCD(1)                  BUG23742 CER055
     D WTbGrp          S             10    DIM(71) CTDATA PERRCD(1)                           CER055
     D**********WTbRDE          S             22    DIM(16) ALT(WTbGrp)                       CER031
     D*WTbRDE***       S             22    DIM(56) ALT(WTbGrp)                       CER031 BUG23742
     D*WTbRDE***       S             22    DIM(60) ALT(WTbGrp)                       BUG23742 CER055
     D WTbRDE          S             22    DIM(71) ALT(WTbGrp)                                CER055
      *                                                                                     BUG23742
      ** Array for 22 * 35                                                                  BUG23742
      *                                                                                     BUG23742
     D PArrExt22       S             35A   DIM(22)                                          BUG23742

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
     D W0CMT           S              3A
     D CCG015          S              1A
     D PChgType        S              1A
     D W0SPAT          S             70A

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
     D PRtFmt21        S             70A                                                    BUG23742
     D PRtFmt22        S             70A                                                    BUG23742
     D WAcum           S              1A                                                    BUG23742
     D WMT06           S              1A                                                    BUG23742
     D WMT22           S              1A                                                    BUG23742
     D WBatchNo        S              3A                                                      CER031
     D WitemNo         S              3P 0                                                    CER031
     D WFTType         S              2A                                                      CER031
      *                                                                                       CER031
     D KNwrk           S              6A                                                    BUG23445
     D KAccd           S             10S 0                                                  BUG23445
     D KAcsq           S              2S 0                                                  BUG23445
     D CGL013          S              1A                                                    BUG23445
     D CER055          S              1A                                                      CER055
     D CFT004          S              1A                                                      CER055
      *                                                                                     BUG23445
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
      *
     C     CER031        IFEQ      'Y'                                                        CER031
     C     CER030        OREQ      'Y'                                                      BUG23742
     C                   EXSR      SrRtvExNr                                                  CER031
     C                   ENDIF                                                                CER031
      *                                                                                       CER031

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

      ** Transaction Reference

     C                   MOVEL     TNMR          ##D(1)

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

     C                   IF        TRYP = 'ME'
     C                   EVAL      ##D(5) = 'JOURNAL ENTRY'
     C                   ELSE
     C                   EVAL      ##D(5) = TRYP
     C                   ENDIF

      ** Transaction Narrative

     C                   MOVEL     WNrtd         ##D(6)

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

      ** Module ID (madatory)

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
      *                                                                                     BUG23742
     C                   IF        WAcum = 'Y'                                              BUG23742
     C                   EVAL      WGrpSeq = 21                                             BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
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
      * SrFmtDta - Reformat data before packing it.                  *
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
      *                                                                                       CER031
      ** Transaction Type is not an FT Movement                                               CER031
      *                                                                                       CER031
     C                   IF        TRYP = 'ME'                                                CER031
      *                                                                                       CER031
     C                   MOVEL     TNMR          WBatchNo                                     CER031
     C                   MOVE      TNMR          WItemNo                                      CER031
     C     KlJEnP        CHAIN     GLJENXL2                                                   CER031
      *                                                                                       CER031
     C                   IF        %FOUND(GLJENXL2)                                           CER031
     C                             AND CER031 ='Y'                                          BUG23742
     C                   MOVEL     BAADI1        PNarr1                                       CER031
     C                   MOVEL     BAADI2        PNarr2                                       CER031
     C                   MOVEL     BAADI3        PNarr3                                       CER031
     C                   MOVEL     BAADI4        PNarr4                                       CER031
     C                   MOVEL     BAADI5        PNarr5                                       CER031
     C                   MOVEL     BAADI6        PNarr6                                       CER031
      *                                                                                     BUG23742
     C                   MOVEL     'Y'           WMT06                                      BUG23742
      *                                                                                     BUG23742
     C                   ELSE                                                               BUG23742
      *                                                                                     BUG23742
     C     KlNar         CHAIN     GLMNARL1                           97                    BUG23742
     C                   IF        %FOUND(GLMNARL1)                                         BUG23742
     C                             AND CER030 = 'Y'                                         BUG23742
     C                   EXSR      SrEvNarr                                                 BUG23742
     C                   MOVEL     'Y'           WMT22                                      BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                       CER031
      ** Check Transaction Type - Debit / Credit                                              CER031
      *                                                                                       CER031
     C                   IF        WMT22 ='Y'                                               BUG23742
     C                             OR WMT06 ='Y'                                            BUG23742
     C     DORC          IFEQ      *ZEROS                                                     CER031
     C                   EXSR      SrDExNar                                                   CER031
     C                   ELSE                                                                 CER031
      *                                                                                       CER031
     C                   EXSR      SrCExNar                                                   CER031
     C                   ENDIF                                                                CER031
     C**********         ELSE                                                        CER031 BUG23742
      *                                                                                       CER031
     C                   ENDIF                                                              BUG23742
     C**********         MOVEL     'GLJENXPD'    W0File                              CER031 BUG23742
     C**********         MOVEL     TNMR          W0Key                               CER031 BUG23742
     C**********         MOVE      5             W0ERNB                              CER031 BUG23742
     C**********         MOVE      'MEM5004'     W0MsgD                              CER031 BUG23742
     C**********         MOVE      'MIDAS'       W0MsgF                              CER031 BUG23742
     C**********         EXSR      SRERR                                             CER031 BUG23742
     C                   ENDIF                                                                CER031
      *                                                                                       CER031
     C                   ENDIF                                                                CER031
      *                                                                                       CER031
     C                   MOVE      *BLANKS       @STK(Q)                                      CER031
     C                   SUB       1             Q                                            CER031
     C                   ENDSR                                                                CER031
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
     C                   EXSR      SrPath                                                     CER031
     C                   EXSR      PSHGRS                                                     CER031
      *                                                                                       CER031
      ** Retrieve RDE info                                                                    CER031
      *                                                                                       CER031
     C                   MOVEL     'DEXNAR'      WGrpNme                                      CER031
     C                   EXSR      SrRtvRDE                                                   CER031
      *                                                                                       CER031
      ** Format Narrative fields                                                              CER031
      *                                                                                       CER031
     C                   MOVEL     BRCA          PBrca                                        CER031
     C                   MOVEL     CUSN          PCusno                                       CER031
     C                   MOVEL     CCYD          PCcy                                         CER031
     C                   MOVEL     ACDE          PAccd                                        CER031
     C                   MOVEL     ASNC          PAcsq                                        CER031
     C                   MOVEL     '*FORMAT'     POptn                                        CER031
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
      *                                                                                     BUG23742
      ** Set Flag for Accumulate RDE's and data when RDE's > than 21                        BUG23742
      *                                                                                     BUG23742
     C                   EVAL      WAcum = ' '                                              BUG23742
      *                                                                                     BUG23742
     C                   IF        WMT22 = 'Y'                                              BUG23742
     C                   EVAL      WAcum = 'Y'                                              BUG23742
      *                                                                                     BUG23742
      ** Call the MG001901 access object to format the extended                             BUG23742
      ** narratives                                                                         BUG23742
      *                                                                                     BUG23742
     C                   CALL      'MG001901'                                               BUG23742
     C                   PARM      *BLANKS       PRtcd2                                     BUG23742
     C                   PARM                    POptn                                      BUG23742
     C                   PARM                    PNetwork                                   BUG23742
     C                   PARM                    PMsgType                                   BUG23742
     C                   PARM                    PBrca                                      BUG23742
     C                   PARM                    PCusno                                     BUG23742
     C                   PARM                    PCcy                                       BUG23742
     C                   PARM                    PAccd                                      BUG23742
     C                   PARM                    PAcSq                                      BUG23742
     C                   PARM                    PDCin                                      BUG23742
     C                   PARM                    PTranTp                                    BUG23742
      *                                                                                     BUG23742
      ** Extended Narratives of length 22 * 35                                              BUG23742
      *                                                                                     BUG23742
     C                   PARM                    PArrExt22                                  BUG23742
      *                                                                                     BUG23742
     C                   PARM      *BLANKS       PRtFmt1                                    BUG23742
     C                   PARM      *BLANKS       PRtFmt2                                    BUG23742
     C                   PARM      *BLANKS       PRtFmt3                                    BUG23742
     C                   PARM      *BLANKS       PRtFmt4                                    BUG23742
     C                   PARM      *BLANKS       PRtFmt5                                    BUG23742
     C                   PARM      *BLANKS       PRtFmt6                                    BUG23742
     C                   PARM      *BLANKS       PRtFmt7                                    BUG23742
     C                   PARM      *BLANKS       PRtFmt8                                    BUG23742
     C                   PARM      *BLANKS       PRtFmt9                                    BUG23742
     C                   PARM      *BLANKS       PRtFmt10                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt11                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt12                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt13                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt14                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt15                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt16                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt17                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt18                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt19                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt20                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt21                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt22                                   BUG23742
     C                   PARM                    Idx                                        BUG23742
     C                   PARM                    FldNamXAr                                  BUG23742
     C                   PARM                    MsgIDXAr                                   BUG23742
     C                   PARM                    MsgDtaXAr                                  BUG23742
     C                   PARM                    WFldNmXAr                                  BUG23742
     C                   PARM                    WMsgIDXAr                                  BUG23742
     C                   PARM                    WMsgDtXAr                                  BUG23742
      *                                                                                     BUG23742
     C                   IF        PRtcd2 = *BLANKS                                         BUG23742
     C                             OR PRtcd2 = '*FORMAT'                                    BUG23742
     C                   MOVEL     PRtFmt1       ##D(1)                                     BUG23742
     C                   MOVEL     PRtFmt2       ##D(2)                                     BUG23742
     C                   MOVEL     PRtFmt3       ##D(3)                                     BUG23742
     C                   MOVEL     PRtFmt4       ##D(4)                                     BUG23742
     C                   MOVEL     PRtFmt5       ##D(5)                                     BUG23742
     C                   MOVEL     PRtFmt6       ##D(6)                                     BUG23742
     C                   MOVEL     PRtFmt7       ##D(7)                                     BUG23742
     C                   MOVEL     PRtFmt8       ##D(8)                                     BUG23742
     C                   MOVEL     PRtFmt9       ##D(9)                                     BUG23742
     C                   MOVEL     PRtFmt10      ##D(10)                                    BUG23742
     C                   MOVEL     PRtFmt11      ##D(11)                                    BUG23742
     C                   MOVEL     PRtFmt12      ##D(12)                                    BUG23742
     C                   MOVEL     PRtFmt13      ##D(13)                                    BUG23742
     C                   MOVEL     PRtFmt14      ##D(14)                                    BUG23742
     C                   MOVEL     PRtFmt15      ##D(15)                                    BUG23742
     C                   MOVEL     PRtFmt16      ##D(16)                                    BUG23742
     C                   MOVEL     PRtFmt17      ##D(17)                                    BUG23742
     C                   MOVEL     PRtFmt18      ##D(18)                                    BUG23742
     C                   MOVEL     PRtFmt19      ##D(19)                                    BUG23742
     C                   MOVEL     PRtFmt20      ##D(20)                                    BUG23742
      *                                                                                     BUG23742
     C                   ELSE                                                               BUG23742
      *                                                                                     BUG23742
     C                   MOVEL     'MG001901'    W0File                                     BUG23742
     C                   MOVEL     PArrExt22(1)  W0Key                                      BUG23742
     C                   MOVEL     11            W0ERNB                                     BUG23742
     C                   MOVEL     'MEM5003'     W0MsgD                                     BUG23742
     C                   MOVEL     'MIDAS'       W0MsgF                                     BUG23742
     C                   EXSR      SRERR                                                    BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   ELSE                                                               BUG23742
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
     C                   PARM                    WMsgDtXAr                                    CER031
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
     C                   MOVEL     'MG001900'    W0File                                       CER031
     C                   MOVEL     PNarr1        W0Key                                        CER031
     C                   MOVEL     08            W0ERNB                                       CER031
     C                   MOVEL     'MEM5003'     W0MsgD                                       CER031
     C                   MOVEL     'MIDAS'       W0MsgF                                       CER031
     C                   EXSR      SRERR                                                      CER031
     C                   ENDIF                                                                CER031
      *                                                                                     BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                       CER031
      ** Accumulate RDEs and associated data and output to CGUDTAPD                           CER031
      *                                                                                       CER031
     C                   EXSR      SrPackDta                                                  CER031
      *                                                                                     BUG23742
     C                   IF        WAcum = 'Y'                                              BUG23742
      *                                                                                     BUG23742
      ** Retrieve RDE information for RDEs in group set                                     BUG23742
      *                                                                                     BUG23742
     C                   EXSR      SrRtvRDE                                                 BUG23742
      *                                                                                     BUG23742
     C                   MOVEL     PRtFmt21      ##D(1)                                     BUG23742
     C                   MOVEL     PRtFmt22      ##D(2)                                     BUG23742
     C                   EXSR      SrPackDta                                                BUG23742
     C                   MOVEL     *BLANKS       WAcum                                      BUG23742
     C                   CLEAR                   PArrExt22                                  BUG23742
      *                                                                                     BUG23742
     C                   Endif                                                              BUG23742
      *                                                                                       CER031
      ** Decrement Path DS Index                                                              CER031
      *                                                                                       CER031
     C     WPx           OCCUR     WMDsPath                                                   CER031
     C                   CLEAR                   WMDSPathGrp                                  CER031
     C                   SUB       1             WPx                                          CER031
     C                   EXSR      POPGRS                                                     CER031
     C                   MOVE      *BLANKS       @STK(Q)                                      CER031
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
     C                   EXSR      SrPath                                                     CER031
     C                   EXSR      PSHGRS                                                     CER031
      *                                                                                       CER031
      ** Retrieve RDE info                                                                    CER031
      *                                                                                       CER031
     C                   MOVEL     'CEXNAR'      WGrpNme                                      CER031
     C                   EXSR      SrRtvRDE                                                   CER031
      *                                                                                       CER031
      ** Format Narrative fields                                                              CER031
      *                                                                                       CER031
     C                   MOVEL     BRCA          PBrca                                        CER031
     C                   MOVEL     CUSN          PCusno                                       CER031
     C                   MOVEL     CCYD          PCcy                                         CER031
     C                   MOVEL     ACDE          PAccd                                        CER031
     C                   MOVEL     ASNC          PAcsq                                        CER031
     C                   MOVEL     '*FORMAT'     POptn                                        CER031
      *                                                                                     BUG23445
      ** Format according to network Paper if Account is linked                             BUG23445
      *                                                                                     BUG23445
     C                   MOVEL     *BLANKS       PNetwork                                   BUG23445
     C     CGL013        IFEQ      'Y'                                                      BUG23445
     C                   MOVEL     'PAPER'       KNWRK                                      BUG23445
     C                   MOVE      PAccd         KAccd                                      BUG23445
     C                   MOVE      PAcsq         KAcsq                                      BUG23445
     C*****KAcct         CHAIN     GLNW94L1                           99          BUG23445 BUG23445A
     C     KAcct         CHAIN     GLNWACL1                           99                   BUG23445A
     C     *IN99         IFEQ      *OFF                                                     BUG23445
     C**********         MOVEL     N4NWRK        PNetwork                         BUG23445 BUG23445A
     C                   MOVEL     NANWRK        PNetwork                                  BUG23445A
     C                   ENDIF                                                              BUG23445
     C                   ENDIF                                                              BUG23445
      *                                                                                     BUG23742
      ** Set Flag for Accumulate RDE's and data when RDE's > than 21                        BUG23742
      *                                                                                     BUG23742
     C                   EVAL      WAcum = ' '                                              BUG23742
      *                                                                                     BUG23742
     C                   IF        WMT22 = 'Y'                                              BUG23742
     C                   EVAL      WAcum = 'Y'                                              BUG23742
      *                                                                                     BUG23742
      ** Call the MG001901 access object to format the extended                             BUG23742
      ** narratives                                                                         BUG23742
      *                                                                                     BUG23742
     C                   CALL      'MG001901'                                               BUG23742
     C                   PARM      *BLANKS       PRtcd2                                     BUG23742
     C                   PARM                    POptn                                      BUG23742
     C                   PARM                    PNetwork                                   BUG23742
     C                   PARM                    PMsgType                                   BUG23742
     C                   PARM                    PBrca                                      BUG23742
     C                   PARM                    PCusno                                     BUG23742
     C                   PARM                    PCcy                                       BUG23742
     C                   PARM                    PAccd                                      BUG23742
     C                   PARM                    PAcSq                                      BUG23742
     C                   PARM                    PDCin                                      BUG23742
     C                   PARM                    PTranTp                                    BUG23742
      *                                                                                     BUG23742
      ** Extended Narratives of length 22 * 35                                              BUG23742
      *                                                                                     BUG23742
     C                   PARM                    PArrExt22                                  BUG23742
      *                                                                                     BUG23742
     C                   PARM      *BLANKS       PRtFmt1                                    BUG23742
     C                   PARM      *BLANKS       PRtFmt2                                    BUG23742
     C                   PARM      *BLANKS       PRtFmt3                                    BUG23742
     C                   PARM      *BLANKS       PRtFmt4                                    BUG23742
     C                   PARM      *BLANKS       PRtFmt5                                    BUG23742
     C                   PARM      *BLANKS       PRtFmt6                                    BUG23742
     C                   PARM      *BLANKS       PRtFmt7                                    BUG23742
     C                   PARM      *BLANKS       PRtFmt8                                    BUG23742
     C                   PARM      *BLANKS       PRtFmt9                                    BUG23742
     C                   PARM      *BLANKS       PRtFmt10                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt11                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt12                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt13                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt14                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt15                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt16                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt17                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt18                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt19                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt20                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt21                                   BUG23742
     C                   PARM      *BLANKS       PRtFmt22                                   BUG23742
     C                   PARM                    Idx                                        BUG23742
     C                   PARM                    FldNamXAr                                  BUG23742
     C                   PARM                    MsgIDXAr                                   BUG23742
     C                   PARM                    MsgDtaXAr                                  BUG23742
     C                   PARM                    WFldNmXAr                                  BUG23742
     C                   PARM                    WMsgIDXAr                                  BUG23742
     C                   PARM                    WMsgDtXAr                                  BUG23742
      *                                                                                     BUG23742
     C                   IF        PRtcd2 = *BLANKS                                         BUG23742
     C                             OR PRtcd2 = '*FORMAT'                                    BUG23742
     C                   MOVEL     PRtFmt1       ##D(1)                                     BUG23742
     C                   MOVEL     PRtFmt2       ##D(2)                                     BUG23742
     C                   MOVEL     PRtFmt3       ##D(3)                                     BUG23742
     C                   MOVEL     PRtFmt4       ##D(4)                                     BUG23742
     C                   MOVEL     PRtFmt5       ##D(5)                                     BUG23742
     C                   MOVEL     PRtFmt6       ##D(6)                                     BUG23742
     C                   MOVEL     PRtFmt7       ##D(7)                                     BUG23742
     C                   MOVEL     PRtFmt8       ##D(8)                                     BUG23742
     C                   MOVEL     PRtFmt9       ##D(9)                                     BUG23742
     C                   MOVEL     PRtFmt10      ##D(10)                                    BUG23742
     C                   MOVEL     PRtFmt11      ##D(11)                                    BUG23742
     C                   MOVEL     PRtFmt12      ##D(12)                                    BUG23742
     C                   MOVEL     PRtFmt13      ##D(13)                                    BUG23742
     C                   MOVEL     PRtFmt14      ##D(14)                                    BUG23742
     C                   MOVEL     PRtFmt15      ##D(15)                                    BUG23742
     C                   MOVEL     PRtFmt16      ##D(16)                                    BUG23742
     C                   MOVEL     PRtFmt17      ##D(17)                                    BUG23742
     C                   MOVEL     PRtFmt18      ##D(18)                                    BUG23742
     C                   MOVEL     PRtFmt19      ##D(19)                                    BUG23742
     C                   MOVEL     PRtFmt20      ##D(20)                                    BUG23742
      *                                                                                     BUG23742
     C                   ELSE                                                               BUG23742
      *                                                                                     BUG23742
     C                   MOVEL     'MG001901'    W0File                                     BUG23742
     C                   MOVEL     PArrExt22(1)  W0Key                                      BUG23742
     C                   MOVEL     12            W0ERNB                                     BUG23742
     C                   MOVEL     'MEM5003'     W0MsgD                                     BUG23742
     C                   MOVEL     'MIDAS'       W0MsgF                                     BUG23742
     C                   EXSR      SRERR                                                    BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   ELSE                                                               BUG23742
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
     C                   MOVEL     'MG001900'    W0File                                       CER031
     C                   MOVEL     PNarr1        W0Key                                        CER031
     C                   MOVEL     09            W0ERNB                                       CER031
     C                   MOVEL     'MEM5003'     W0MsgD                                       CER031
     C                   MOVEL     'MIDAS'       W0MsgF                                       CER031
     C                   EXSR      SRERR                                                      CER031
     C                   ENDIF                                                                CER031
      *                                                                                     BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                       CER031
      ** Accumulate RDEs and associated data and output to CGUDTAPD                           CER031
      *                                                                                       CER031
     C                   EXSR      SrPackDta                                                  CER031
      *                                                                                     BUG23742
     C                   IF        WAcum = 'Y'                                              BUG23742
     C                   EXSR      SrRtvRDE                                                 BUG23742
     C                   MOVEL     PRtFmt21      ##D(1)                                     BUG23742
     C                   MOVEL     PRtFmt22      ##D(2)                                     BUG23742
     C                   EXSR      SrPackDta                                                BUG23742
     C                   MOVEL     *BLANKS       WAcum                                      BUG23742
     C                   CLEAR                   PArrExt22                                  BUG23742
      *                                                                                     BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                       CER031
      ** Decrement Path DS Index                                                              CER031
      *                                                                                       CER031
     C     WPx           OCCUR     WMDsPath                                                   CER031
     C                   CLEAR                   WMDSPathGrp                                  CER031
     C                   SUB       1             WPx                                          CER031
     C                   EXSR      POPGRS                                                     CER031
     C                   MOVE      *BLANKS       @STK(Q)                                      CER031
     C                   SUB       1             Q                                            CER031
      *                                                                                       CER031
     C                   ENDSR                                                                CER031
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

      *                                                                                       CER031
      ** Check if 'CER031' is switched 'ON'                                                   CER031
      *                                                                                       CER031
     C                   CALL      'AOSARDR0'                                                 CER031
     C                   PARM      *BLANKS       PRtcd                                        CER031
     C                   PARM      '*VERIFY'     POptn                                        CER031
     C                   PARM      'CER031'      PSard             6                          CER031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER031
      *                                                                                       CER031
     C     PRTCD         IFEQ      *BLANKS                                                    CER031
     C                   MOVE      'Y'           CER031            1                          CER031
     C                   ELSE                                                                 CER031
      *                                                                                       CER031
     C                   MOVE      'N'           CER031                                       CER031
     C                   ENDIF                                                                CER031
      *                                                                                     BUG23445
      ** Access Switchable Features file and check if CCG015 is                             BUG23445
      ** installed                                                                          BUG23445
      *                                                                                     BUG23445
     C                   CALL      'AOSARDR0'                                               BUG23445
     C                   PARM      *BLANKS       PRTCD                                      BUG23445
     C                   PARM      '*VERIFY'     POPTN                                      BUG23445
     C                   PARM      'CGL013'      PSARD                                      BUG23445
      *                                                                                     BUG23445
     C     PRTCD         IFEQ      *BLANK                                                   BUG23445
     C                   MOVE      'Y'           CGL013                                     BUG23445
     C                   ELSE                                                               BUG23445
     C                   MOVE      'N'           CGL013                                     BUG23445
     C     PRTCD         IFNE      '*NRF   '                                                BUG23445
     C                   MOVEL     'SCSARDPD'    W0File                                     BUG23445
     C                   MOVEL     '*CALL'       W0Key                                      BUG23445
     C                   Z-ADD     10            W0ERNB                                     BUG23445
     C                   MOVEL     'MEM5003'     W0Msgd                                     BUG23445
     C                   MOVEL     'MIDAS  '     W0Msgf                                     BUG23445
     C                   EXSR      SRERR                                                    BUG23445
     C                   ENDIF                                                              BUG23445
     C                   ENDIF                                                              BUG23445
      *                                                                                     BUG23742
      ** Check if 'CER030' is switched 'ON'                                                 BUG23742
      *                                                                                     BUG23742
     C                   CALL      'AOSARDR0'                                               BUG23742
     C                   PARM      *BLANKS       PRtcd                                      BUG23742
     C                   PARM      '*VERIFY'     POptn                                      BUG23742
     C                   PARM      'CER030'      PSard             6                        BUG23742
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG23742
      *                                                                                     BUG23742
     C     PRTCD         IFEQ      *BLANKS                                                  BUG23742
     C                   MOVE      'Y'           CER030            1                        BUG23742
     C                   ELSE                                                               BUG23742
      *                                                                                     BUG23742
     C                   MOVE      'N'           CER030                                     BUG23742
     C                   ENDIF                                                              BUG23742
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
      *                                                                                       CER031
      ** Keylist for file GLJENXL2                                                            CER031
      *                                                                                       CER031
     C     KlJEnP        KLIST                                                                CER031
     C                   KFLD                    WBatchNo                                     CER031
     C                   KFLD                    WITemNo                                      CER031
      *                                                                                       CER031
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
      *                                                                                     BUG23445
      *                                                                                     BUG23742
      ** Keylist for file GLMNARL1                                                          BUG23742
      *                                                                                     BUG23742
     C     KlNar         KLIST                                                              BUG23742
     C                   KFLD                    PTDT                                       BUG23742
     C                   KFLD                    WBatchNo                                   BUG23742
     C                   KFLD                    WITemNo                                    BUG23742
      *                                                                                       CER055
     C     KACKEY        KLIST                                                                CER055
     C                   KFLD                    CUSN                                         CER055
     C                   KFLD                    CCYD                                         CER055
     C                   KFLD                    ACDE                                         CER055
     C                   KFLD                    ASNC                                         CER055
     C                   KFLD                    BRCA                                         CER055
      *                                                                                     BUG23742
     C                   ENDSR
      *****************************************************************                     BUG23742
      /EJECT                                                                                BUG23742
      *****************************************************************                     BUG23742
      *                                                               *                     BUG23742
      *  SrEvNarr - Evaluate Additional Narrative Details             *                     BUG23742
      *                                                               *                     BUG23742
      *  Called by: SrDExNar, SrCExNar                                *                     BUG23742
      *                                                               *                     BUG23742
      *  Calls: None                                                  *                     BUG23742
      *                                                               *                     BUG23742
      *****************************************************************                     BUG23742
     C     SrEvNarr      BEGSR                                                              BUG23742
      *                                                                                     BUG23742
     C                   EVAL      PArrExt22(1) = BAEX1                                     BUG23742
     C                   EVAL      PArrExt22(2) = BAEX2                                     BUG23742
     C                   EVAL      PArrExt22(3) = BAEX3                                     BUG23742
     C                   EVAL      PArrExt22(4) = BAEX4                                     BUG23742
     C                   EVAL      PArrExt22(5) = BAEX5                                     BUG23742
     C                   EVAL      PArrExt22(6) = BAEX6                                     BUG23742
     C                   EVAL      PArrExt22(7) = BAEX7                                     BUG23742
     C                   EVAL      PArrExt22(8) = BAEX8                                     BUG23742
     C                   EVAL      PArrExt22(9) = BAEX9                                     BUG23742
     C                   EVAL      PArrExt22(10) = BAEX10                                   BUG23742
     C                   EVAL      PArrExt22(11) = BAEX11                                   BUG23742
     C                   EVAL      PArrExt22(12) = BAEX12                                   BUG23742
     C                   EVAL      PArrExt22(13) = BAEX13                                   BUG23742
     C                   EVAL      PArrExt22(14) = BAEX14                                   BUG23742
     C                   EVAL      PArrExt22(15) = BAEX15                                   BUG23742
     C                   EVAL      PArrExt22(16) = BAEX16                                   BUG23742
     C                   EVAL      PArrExt22(17) = BAEX17                                   BUG23742
     C                   EVAL      PArrExt22(18) = BAEX18                                   BUG23742
     C                   EVAL      PArrExt22(19) = BAEX19                                   BUG23742
     C                   EVAL      PArrExt22(20) = BAEX20                                   BUG23742
     C                   EVAL      PArrExt22(21) = BAEX21                                   BUG23742
     C                   EVAL      PArrExt22(22) = BAEX22                                   BUG23742
      *                                                                                     BUG23742
     C                   ENDSR                                                              BUG23742
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
DEXNAR0021 DEX_NARR21                    Extended Narrative 21                              BUG23742
DEXNAR0022 DEX_NARR22                    Extended Narrative 22                              BUG23742
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
CEXNAR0021 CEX_NARR21                    Extended Narrative 21 Crd                          BUG23742
CEXNAR0022 CEX_NARR22                    Extended Narrative 22 Crd                          BUG23742
