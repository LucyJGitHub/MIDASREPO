     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG SE Statement of holding extract')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG6085 - Midas CG SE Statement of Holding Extract            *
      *                                                               *
      *  Function:  This program formats the SE Statement details in  *
      *                                                               *
      *             XML format for MMM and Correspondence Manager     *
      *                                                               *
      *  Called By   : CG6080 - SE Statement of Holding Driver        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CSE040  *CREATE    Date 12Mar03               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSE040 - Security Statement Production                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *                                                               *
      *  XX - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx                      *
      *                                                               *
      *  U7+U8 - Database error occurs                                *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSESGENL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE - General Information by Extract reference
 
     FSEHFINL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Holding - Financial Instruments by Extract reference
 
     FSEHSBLL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Holding - Sub-balance by Extract reference
 
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
 
     D WCPrtItmTyp     C                   CONST('SE_STAT   ')
      ** Print Item Type
 
     D WCPrtItmSubTyp  C                   CONST('HOLDING   ')
      ** Print Item Sub-Type
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Data structure for access objects, first DS
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Data structure for access objects, second DS
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data structure for Bank details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Data structure for Branch details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  DFACB1       E                     EXTFLD(QQDFAC)                                     CGL029
      ** Data structure Customer details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Data structure Currency details
 
     D PEDsCGUDCRPD  E DS                  EXTNAME(CGUDCRPD)
      ** Data structure for UDC data reference file
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Data structure for SAR data
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** Midas SD Data area
 
     D WArBRCD         S              3A   DIM(999)
      ** Array to keep Branch reference of Branch already processed
 
     D WMDsBrch        DS                  OCCURS(999)
      ** Multi-occurence data structure to store Branch details
     D  WMDsBRCD                           LIKE(A8BRCD)                         Branch code
     D  WMDsBICN                           LIKE(A8BICN)                         Branch Internal Cust
     D  WMDsBTID                           LIKE(A8BTID)                         Branch TID Address
     D  WMDsCSID                           LIKE(BBCSID)                         Cust. SWIFT Address
     D  WMDsCNA1                           LIKE(BBCNA1)                         Cust. Name & Add. 1
     D  WMDsCNA2                           LIKE(BBCNA2)                         Cust. Name & Add. 2
     D  WMDsCNA3                           LIKE(BBCNA3)                         Cust. Name & Add. 3
     D  WMDsCNA4                           LIKE(BBCNA4)                         Cust. Name & Add. 4
     D  WMDsCRNM                           LIKE(BBCRNM)                         Customer Report Name
 
     D WMDsPath        DS                  OCCURS(20)
      ** Multi-occurence data structure to store path from Start
     D  WMDsPathGrp            1      6
 
     D                 DS
      ** General data structure to define fields that need to share data
     D WGrp10                  1     10
     D  WGrpName               1      6
     D  WGrpSeq                7     10S 0
     D  WAr20                 21     40    DIM(20)
     D  WNum20                21     40  0
     D  WAr29                 51     79    DIM(29)
 
     D P0RtnCode       S              6A
      ** Entry parameter return code
 
     D P0DsSDRV      E DS                  EXTNAME(SESDRVPD)
      ** Midas SE Holding - Driver File
     D   RequestRef            9     20                                         Request Reference
 
     D P0Commit        S              3A
      ** Commit Yes/No
 
     D WArr20X1        S              1A   DIM(20)
      ** 20-element alpha runtime-array used as an output by SR/SRFmtNum
 
      ** Compile-time array to contain RDE definitions
     D WTbGrp          S             10    DIM(103) CTDATA PERRCD(1)
     D WTbRDE          S             22    DIM(103) ALT(WTbGrp)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WBIdx           S              5U 0
      ** Index of last branch reference stored in WArBRCD
 
     D Idx             S              5U 0
      ** Index
 
     D WBrchRef        S                   LIKE(A8BRCD)
      ** Customer number
 
     D WSWIFTCust      S                   LIKE(HGRECP)
      ** Swift Customer
 
     D WPathStr        S            256A
      ** String that contains the concatenated path
 
     D WPx             S              3P 0
      ** Index for WMDsPath only
 
     D WOutSeq         S              9P 0
      ** Output Sequence counter
 
     D ##ITEM          S              8  0
      ** Confirmation Text code
 
      ** General purpose variables
     D WProduce        S              1A
     D Wx1             S              3P 0
     D Wx2             S              3P 0
     D Wx3             S              3P 0
     D CCG015          S              1
 
      ** Parameter fields
     D PAction8        S              8A
     D PCommit         S              3A
     D POption         S              7A
     D PRtnCode        S              7A
     D PCustNumChr6    S              6A
     D PItmRef         S              8A
     D PChr003         S              3A
     D PChr007         S              7A
     D PChr010         S             10A
     D PChr016         S             16A
     D PNum010P        S              1P 0
     D PMode           S             10A
 
     D W0CMT           S              3A
 
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
 
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN      '  @STK(Q)
      *
      ** Initial processing
      *
     C                   EXSR      SRInitial
      *
      ** Execute main subroutine
      *
     C                   EXSR      SRMain
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      ** Termination
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRMain - Performs validation and invokes top group set.      *
      *****************************************************************
     C     SRMain        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRMain    '  @STK(Q)
      *
      ** Generate reference number by writing to PF/CGUDCRPD.
      ** If no confirmation to produce, then bypass.
      *
     C                   EXSR      SRGenRef
      *
      ** Top group set
      *
     C                   IF        WProduce = 'Y'
     C                   EXSR      SRStmHol
     C                   ENDIF
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRStmHol   - Top group set.                                  *
      *****************************************************************
     C     SRStmHol      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRStmHol  '  @STK(Q)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   Z-ADD     1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'StmHol'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ********************************
      ** Access General Information **
      ********************************
      *
     C     KRequest      CHAIN     SESGENL0
     C                   IF        NOT %FOUND(SESGENL0)
     C                   MOVEL     'SESGENL0'    W0File
     C                   MOVEL     RequestRef    W0Key
     C                   Z-ADD     1             W0ERNB
     C                   MOVEL     'MEM5004'     W0MsgD
     C                   MOVEL     'MIDAS'       W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Message Other details
      *
     C                   EXSR      SRMsgOth
      *
      ** Sender details
      *
     C                   EXSR      SRSender
      *
      ** Originator details
      *
     C                   EXSR      SROrigin
      *
      ** Recipient details (Destination)
      *
     C                   EXSR      SRRecip
      *
      ** Sequence A General Information
      *
     C                   EXSR      SRGenInf
      *
      ** Repetitive Optional Subsequence A1 Linkages
      *
     C                   EXSR      SRGenLin
 
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'SubSaf'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      **********************************
      ** Access Financial Instruments **
      **********************************
      *
     C     KRequest      SETLL     SEHFINL0
     C     KRequest      READE     SEHFINL0
     C                   DOW       NOT %EOF(SEHFINL0)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'FinIns'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ** Security details
      *
     C                   EXSR      SRSecDtl
      *
      ** Repetitive Optional Subsequence B1 Financial Instrument
      *
     C                   EXSR      SRInstru
      *
      ** Repetitive Optional Subsequence B1 Financial Instrument - Amount
      *
     C                   EXSR      SRFinAmt
      *
      ************************
      ** Access Sub-Balance **
      ************************
      *
     C     KSubBal       SETLL     SEHSBLL0
     C     KSubBal       READE     SEHSBLL0
     C                   DOW       NOT %EOF(SEHSBLL0)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'SubBal'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ** Repetitive Optional Subsequence B1a Sub-Balance
      *
     C                   EXSR      SRSubBal
      *
      ** Decrement Path DS index
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *
     C                   EXSR      POPGRS
      *
     C     KSubBal       READE     SEHSBLL0
     C                   ENDDO
      *
      ** Decrement Path DS index
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *
     C                   EXSR      POPGRS
      *
     C     KRequest      READE     SEHFINL0
     C                   ENDDO
      *
      ** Decrement Path DS index
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *
     C                   EXSR      POPGRS
      *
      ** Repetitive Optional Sequence C Additional Information
      *
     C                   EXSR      SRAddInf
      *
      ** Decrement Path DS index
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *
     C                   EXSR      POPGRS
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRMsgOth   - Message Other details.                          *
      *****************************************************************
     C     SRMsgOth      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRMsgOth  '  @STK(Q)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'MsgOth'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'MsgOth'      WGrpName
     C                   EXSR      SRRtvRDE
      *
      ** First Message Reference
      *
     C                   MOVEL     HG1MRF        ##D(1)
      *
      ** Network
      *
     C                   MOVEL     HGNWRK        ##D(2)
      *
      ** Priority
      *
     C                   MOVEL     HGPRTY        ##D(3)
      *
      ** Delivery Notification
      *
     C                   MOVEL     HGNOTF        ##D(4)
      *
      ** System ID
      *
     C                   IN        SDSTAT
     C                   MOVEL     LIBR          ##D(5)
      *
      ** Accumulate RDEs and associated data and output
      *
     C                   EXSR      SRPackDta
      *
      ** Decrement Path DS index
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *
     C                   EXSR      POPGRS
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRSender   - Sender details.                                 *
      *****************************************************************
     C     SRSender      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRSender  '  @STK(Q)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'Sender'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ** Set up fields to be passed to SRSWBrch
      *
     C                   MOVEL     HGSNDR        WBrchRef
     C                   EXSR      SRSWBrch
      *
      ** Accumulate RDEs and associated data and output
      *
     C                   EXSR      SRPackDta
      *
      ** Decrement Path DS index
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *
     C                   EXSR      POPGRS
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SROrigin   - Originator details.                             *
      *****************************************************************
     C     SROrigin      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SROrigin  '  @STK(Q)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'Origin'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ** Set up fields to be passed to SRSWBrch
      *
     C                   MOVEL     HGSNDR        WBrchRef
     C                   EXSR      SRSWBrch
      *
      ** Accumulate RDEs and associated data and output
      *
     C                   EXSR      SRPackDta
      *
      ** Decrement Path DS index
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *
     C                   EXSR      POPGRS
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRecip    - Recipient details.                              *
      *****************************************************************
     C     SRRecip       BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRRecip   '  @STK(Q)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'Recip '      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ** Set up fields to be passed to SRSWCust
      *
     C                   MOVEL     HGRECP        WSWIFTCust
     C                   EXSR      SRSWCust
      *
      ** Accumulate RDEs and associated data and output to CGUDTAPD
      *
     C                   EXSR      SRPackDta
      *
      ** Decrement Path DS index
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *
     C                   EXSR      POPGRS
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRGenInf   - Sequence A General Information details          *
      *****************************************************************
     C     SRGenInf      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRGenInf  '  @STK(Q)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'GenInf'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'GenInf'      WGrpName
     C                   EXSR      SRRtvRDE
      *
      ** Page Number
      *
     C                   MOVEL     HGPGNB        ##D(1)
      *
      ** Page Continuation Indicator
      *
     C                   MOVEL     HGPGIN        ##D(2)
      *
      ** Statement Number
      *
     C                   MOVEL     HGSTNB        ##D(3)
      *
      ** Message Reference
      *
     C                   MOVEL     HGMREF        ##D(4)
      *
      ** Function Code
      *
     C                   MOVEL     HGFCTC        ##D(5)
      *
      ** Preparation Date
      *
     C                   IF        HGPRDT <> *Zeros
     C                   MOVEL     HGPRDT        ##D(6)
     C                   ENDIF
      *
      ** Preparation Time
      *
     C                   IF        HGPRTM <> *Zeros
     C                   MOVEL     HGPRTM        ##D(7)
     C                   ENDIF
      *
      ** Statement Date
      *
     C                   MOVEL     HGMSTD        ##D(8)
      *
      ** Statement Time
      *
     C                   MOVEL     HGSTRM        ##D(9)
      *
      ** Statement Frequency
      *
     C                   MOVEL     HGSFRE        ##D(10)
      *
      ** Complete/Update
      *
     C                   MOVEL     HGCODE        ##D(11)
      *
      ** Statement Type
      *
     C                   MOVEL     HGSTTY        ##D(12)
      *
      ** Statement Basis
      *
     C                   MOVEL     HGSTBA        ##D(13)
      *
      ** Safekeeping Account
      *
     C                   MOVEL     HGCUST        ##D(14)
      *
      ** Activity Flag
      *
     C                   MOVEL     HGACTI        ##D(15)
      *
      ** Audited Statement
      *
     C                   MOVEL     HGAUDT        ##D(16)
      *
      ** Sub-safekeeping Statement
      *
     C                   MOVEL     HGCONS        ##D(17)
      *
      ** Accumulate RDEs and associated data and output
      *
     C                   EXSR      SRPackDta
      *
      ** Decrement Path DS index
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *
     C                   EXSR      POPGRS
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRGenLin   - Repetitive Optional Subsequence A1 Linkages     *
      *****************************************************************
     C     SRGenLin      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRGenLin  '  @STK(Q)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'GenLin'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'GenLin'      WGrpName
     C                   EXSR      SRRtvRDE
      *
      ** Related Message Type
      *
     C                   MOVEL     HGRLMT        ##D(1)
      *
      ** Related Message
      *
     C                   MOVEL     HGRMSG        ##D(2)
      *
      ** Previous Message Cancelled
      *
     C                   MOVEL     HGPMCC        ##D(3)
      *
      ** Accumulate RDEs and associated data and output
      *
     C                   EXSR      SRPackDta
      *
      ** Decrement Path DS index
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *
     C                   EXSR      POPGRS
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRSecDtl   - Security details                                *
      *****************************************************************
     C     SRSecDtl      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRSecDtl  '  @STK(Q)
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'SecDtl'      WGrpName
     C                   EXSR      SRRtvRDE
      *
      ** Nominal Currency
      *
     C                   MOVEL     HFNMCY        ##D(1)
      *
      ** Nominal decimal places
      *
     C                   MOVEL     HFNMDP        ##D(2)
      *
      ** Country of risk
      *
     C                   MOVEL     HFSCOR        ##D(3)
      *
      ** Sedol (Extel) Ref
      *
     C                   MOVEL     HFSREF        ##D(4)
      *
      ** Telekurs (Valoren) Ref
      *
     C                   MOVEL     HFT2RF        ##D(5)
      *
      ** Cusip Number
      *
     C                   MOVEL     HFCSPN        ##D(6)
      *
      ** Price Basis
      *
     C                   MOVEL     HFSPBS        ##D(7)
      *
      ** Trade Basis
      *
     C                   MOVEL     HFSTBS        ##D(8)
      *
      ** Yield Basis
      *
     C                   MOVEL     HFSYBS        ##D(9)
      *
      ** SWIFT Security Type
      *
     C                   MOVEL     HFSWTP        ##D(10)
      *
      ** Processing Type
      *
     C                   MOVEL     HFPROT        ##D(11)
      *
      ** Accumulate RDEs and associated data and output
      *
     C                   EXSR      SRPackDta
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *************************************************************************
      *  SRInstru   - Repetitive Optional Subsequence B1 Financial Instrument *
      *************************************************************************
     C     SRInstru      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRInstru  '  @STK(Q)
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'Instru'      WGrpName
     C                   EXSR      SRRtvRDE
      *
      ** Security ISIN Code
      *
     C                   MOVEL     HFISIN        ##D(1)
      *
      ** Security shortname
      *
     C                   MOVEL     HFSESN        ##D(2)
      *
      ** Security Report Name
      *
     C                   MOVEL     HFSRPN        ##D(3)
      *
      ** Security Full Name - 1
      *
     C                   MOVEL     HFSFN1        ##D(4)
      *
      ** Security Full Name - 2
      *
     C                   MOVEL     HFSFN2        ##D(5)
      *
      ** Corporate Action Option Code
      *
     C                   MOVEL     HFCAOP        ##D(6)
      *
      ** Price Qualifier
      *
     C                   MOVEL     HFPQUA        ##D(7)
      *
      ** Price Code
      *
     C                   MOVEL     HFPCOD        ##D(8)
      *
      ** Price Currency
      *
     C                   MOVEL     HFPCCY        ##D(9)
      *
      ** Price
      *
     C                   MOVEL     HFPRIC        ##D(10)
      *
      ** Price Decimal Position
      *
     C                   MOVEL     ##R(10)       R#DEFN
     C                   MOVE      HFPDPS        ##RDED                         Decimal Position
     C                   MOVEL     R#DEFN        ##R(10)
      *
      ** Place Code
      *
     C                   MOVEL     HFPLCD        ##D(11)
      *
      ** Place
      *
     C                   MOVEL     HFPLAC        ##D(12)
      *
      ** Price Quotation Date
      *
     C                   IF        HFPQDT <> *Zeros
     C                   MOVEL     HFPQDT        ##D(13)
     C                   ENDIF
      *
      ** Price Quotation Time
      *
     C                   IF        HFPQTM <> *Zeros
     C                   MOVEL     HFPQTM        ##D(14)
     C                   ENDIF
      *
      ** Accumulate RDEs and associated data and output
      *
     C                   EXSR      SRPackDta
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      **********************************************************************************
      *  SRFinAmt   - Repetitive Optional Subsequence B1 Financial Instrument - Amount *
      **********************************************************************************
     C     SRFinAmt      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRFinAmt  '  @STK(Q)
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'FinAmt'      WGrpName
     C                   EXSR      SRRtvRDE
      *
      ** Balance Code
      *
     C                   MOVEL     HFBLCD        ##D(1)
      *
      ** Balance Amount
      *
     C                   MOVEL     HFBALA        ##D(2)
      *
      ** Balance Decimal Position
      *
     C                   MOVEL     ##R(2)        R#DEFN
     C                   MOVE      HFBDPS        ##RDED                         Decimal Position
     C                   MOVEL     R#DEFN        ##R(2)
      *
      ** Number Days Accrued
      *
     C                   MOVEL     HFNBDY        ##D(3)
      *
      ** Accrued Amount Currency
      *
     C                   MOVEL     HFAACY        ##D(4)
      *
      ** Accrued Amount
      *
     C                   MOVEL     HFAAMT        ##D(5)
      *
      ** Accrued Amount Decimal Position
      *
     C                   MOVEL     ##R(5)        R#DEFN
     C                   MOVE      HFAADP        ##RDED                         Decimal Position
     C                   MOVEL     R#DEFN        ##R(5)
      *
      ** Holding Amount Currency
      *
     C                   MOVEL     HFHACY        ##D(6)
      *
      ** Holding Amount
      *
     C                   MOVEL     HFHAMT        ##D(7)
      *
      ** Holding Amount Decimal Position
      *
     C                   MOVEL     ##R(7)        R#DEFN
     C                   MOVE      HFHADP        ##RDED                         Decimal Position
     C                   MOVEL     R#DEFN        ##R(7)
      *
      ** Exchange Rate Currency 1
      *
     C                   MOVEL     HFERC1        ##D(8)
      *
      ** Exchange Rate Currency 2
      *
     C                   MOVEL     HFERC2        ##D(9)
      *
      ** Exchange Rate
      *
     C                   MOVEL     HFEXRT        ##D(10)
      *
      ** Exchange Mult/Div Ind.
      *
     C                   MOVEL     HFEXMD        ##D(11)
      *
      ** Accumulate RDEs and associated data and output
      *
     C                   EXSR      SRPackDta
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRSubBal   - Repetitive Optional Subsequence B1a Sub-Balance *
      *****************************************************************
     C     SRSubBal      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRSubBal  '  @STK(Q)
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'SubBal'      WGrpName
     C                   EXSR      SRRtvRDE
      *
      ** Balance Qualifier
      *
     C                   MOVEL     HSBQUA        ##D(1)
      *
      ** Balance Quantity Code
      *
     C                   MOVEL     HSBQTC        ##D(2)
      *
      ** Balance Type Code
      *
     C                   MOVEL     HSBTYP        ##D(3)
      *
      ** Balance
      *
     C                   MOVEL     HSBALA        ##D(4)
      *
      ** Balance Decimal Position
      *
     C                   MOVEL     ##R(4)        R#DEFN
     C                   MOVE      HSBDPS        ##RDED                         Decimal Position
     C                   MOVEL     R#DEFN        ##R(4)
      *
      ** Place Qualifier
      *
     C                   MOVEL     HSPQUA        ##D(5)
      *
      ** Place Code
      *
     C                   MOVEL     HSPCOD        ##D(6)
      *
      ** Place
      *
     C                   MOVEL     HSPLAC        ##D(7)
      *
      ** Place Country
      *
     C                   MOVEL     HSPCTY        ##D(8)
      *
      ** BIC/BEI
      *
     C                   MOVEL     HSPBIC        ##D(9)
      *
      ** Sub-balance Narrative 1
      *
     C                   MOVEL     HSNAR1        ##D(10)
      *
      ** Sub-balance Narrative 2
      *
     C                   MOVEL     HSNAR2        ##D(11)
      *
      ** Sub-balance Narrative 3
      *
     C                   MOVEL     HSNAR3        ##D(12)
      *
      ** Sub-balance Narrative 4
      *
     C                   MOVEL     HSNAR4        ##D(13)
      *
      ** Accumulate RDEs and associated data and output
      *
     C                   EXSR      SRPackDta
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ************************************************************************
      *  SRAddInf   - Repetitive Optional Sequence C Additional Information  *
      ************************************************************************
     C     SRAddInf      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRAddInf  '  @STK(Q)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'AddInf'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'AddInf'      WGrpName
     C                   EXSR      SRRtvRDE
      *
      ** Total Holding Currency
      *
     C                   MOVEL     HGCURR        ##D(1)
      *
      ** Total Holding Page
      *
     C                   MOVEL     HGHOLP        ##D(2)
      *
      ** Total Holding Decimal Position
      *
     C                   MOVEL     ##R(2)        R#DEFN
     C                   MOVE      HGHSDP        ##RDED                         Decimal Position
     C                   MOVEL     R#DEFN        ##R(2)
      *
      ** Total Holding Statement
      *
     C                   MOVEL     HGHOLS        ##D(3)
      *
      ** Total Holding Decimal Position
      *
     C                   MOVEL     ##R(3)        R#DEFN
     C                   MOVE      HGHSDP        ##RDED                         Decimal Position
     C                   MOVEL     R#DEFN        ##R(3)
      *
      ** Accumulate RDEs and associated data and output
      *
     C                   EXSR      SRPackDta
      *
      ** Decrement Path DS index
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *
     C                   EXSR      POPGRS
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRSWBrch - SWIFT Branch data.                                *
      *****************************************************************
     C     SRSWBrch      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRSWBrch  '  @STK(Q)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'SWBrch'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'SWBrch'      WGrpName
     C                   EXSR      SRRtvRDE
      *
     C                   IF        WBrchRef    <> *BLANKS
      *
      ** Check if Branch details have been retrieved before
      *
     C                   Z-ADD     1             Idx
     C     WBrchRef      LOOKUP    WArBRCD(Idx)                           99
      *
      ** If found
      *
     C                   IF        *IN99
      *
      ** Access branch details
      *
     C     Idx           OCCUR     WMDsBrch
      *
     C                   ELSE
      *
      ** Access branch details
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      WBrchRef      PBranch           3
     C*****SDBRCH        PARM      *BLANKS       DSFDY                                        CGL029
     C     SDBRCH        PARM      *BLANKS       DSSDY                                        CGL029
     C                   IF        PRtnCode <> *BLANKS
     C                   MOVEL     'SDBRCHPD'    W0File
     C                   MOVEL     PChr010       W0Key
     C                   Z-ADD     2             W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS'       W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Access branch internal customer details
      *
     C                   MOVEL     *BLANKS       PChr010
     C                   MOVEL     A8BICN        PChr010
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PChr010
     C                   PARM      *BLANKS       PChr007
     C     SDCUST        PARM      *BLANKS       DSSDY
     C                   IF        PRtnCode <> *BLANKS
     C                   MOVEL     'SDCUSTPD'    W0File
     C                   MOVEL     PChr010       W0Key
     C                   Z-ADD     3             W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS'       W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Increase the index of last branch reference stored in WArBRCD
      *
     C                   ADD       1             WBIdx
      *
      ** Memorize the branch details
      *
     C                   MOVEA     A8BRCD        WArBRCD(WBIdx)
     C     WBIdx         OCCUR     WMDsBrch
     C                   MOVE      A8BRCD        WMDsBRCD                       Branch code
     C                   MOVE      A8BICN        WMDsBICN                       Branch Internal Cust
     C                   MOVE      A8BTID        WMDsBTID                       Branch TID Address
     C                   MOVE      BBCSID        WMDsCSID                       Cust. SWIFT Address
     C                   MOVE      BBCNA1        WMDsCNA1                       Cust. Name & Add. 1
     C                   MOVE      BBCNA2        WMDsCNA2                       Cust. Name & Add. 2
     C                   MOVE      BBCNA3        WMDsCNA3                       Cust. Name & Add. 3
     C                   MOVE      BBCNA4        WMDsCNA4                       Cust. Name & Add. 4
     C                   MOVE      BBCRNM        WMDsCRNM                       Customer Report Name
      *
     C                   ENDIF
      *
      ** Branch Code
      *
     C                   MOVEL     WMDsBRCD      ##D(1)
      *
      ** Branch Internal Cust
      *
     C                   MOVEL     WMDsBICN      ##D(2)
      *
      ** Branch TID Address
      *
     C                   MOVEL     WMDsBTID      ##D(3)
      *
      ** Customer Swift Address
      *
     C                   MOVEL     WMDsCSID      ##D(4)
      *
      ** Cust. Name & Add. 1
      *
     C                   MOVEL     WMDsCNA1      ##D(5)
      *
      ** Cust. Name & Add. 2
      *
     C                   MOVEL     WMDsCNA2      ##D(6)
      *
      ** Cust. Name & Add. 3
      *
     C                   MOVEL     WMDsCNA3      ##D(7)
      *
      ** Cust. Name & Add. 4
      *
     C                   MOVEL     WMDsCNA4      ##D(8)
      *
      ** Customer Report Name
      *
     C                   MOVEL     WMDsCRNM      ##D(9)
      *
     C                   ENDIF
      *
      ** Decrement Path DS index
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *
     C                   EXSR      POPGRS
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRSWCust - SWIFT Customer data.                              *
      *****************************************************************
     C     SRSWCust      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRSWCust  '  @STK(Q)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'SWCust'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'SWCust'      WGrpName
     C                   EXSR      SRRtvRDE
      *
     C                   IF        WSWIFTCust <> *Blanks
      *
      ** If Recipient could be a customer number or SWIFT address if no customer related.
      *
      ** Customer number
      *  ---------------
      *
     C                   IF        %SUBST(WSWIFTCust:7:5) = *Blanks
      *
      ** Access customer details
      *
     C                   MOVEL     *BLANKS       PChr010
     C                   MOVEL     WSWIFTCust    PChr010
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PChr010
     C                   PARM      *BLANKS       PChr007
     C     SDCUST        PARM      *BLANKS       DSSDY
     C                   IF        PRtnCode <> *BLANKS
     C                   MOVEL     'SDCUSTPD'    W0File
     C                   MOVEL     PChr010       W0Key
     C                   Z-ADD     4             W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS'       W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Customer SWIFT Address
      *
     C                   MOVEL     BBCSID        ##D(1)
      *
      ** Customer Address 1
      *
     C                   MOVEL     BBCNA1        ##D(2)
      *
      ** Customer Address 2
      *
     C                   MOVEL     BBCNA2        ##D(3)
      *
      ** Customer Address 3
      *
     C                   MOVEL     BBCNA3        ##D(4)
      *
      ** Customer Address 4
      *
     C                   MOVEL     BBCNA4        ##D(5)
      *
      ** Customer Report Town
      *
     C                   MOVEL     BBCRTN        ##D(6)
      *
      ** Customer Report Name
      *
     C                   MOVEL     BBCRNM        ##D(7)
      *
      ** Customer Location
      *
     C                   MOVEL     BBCOLC        ##D(8)
      *
      ** Customer STTX  Address
      *
     C                   MOVEL     BBSTAD        ##D(9)
      *
      ** Customer Chips Id
      *
     C                   IF        BBCHID <> *Zeros
     C                   MOVEL     BBCHID        ##D(10)
     C                   ENDIF
      *
      ** Customer Chaps sort code
      *
     C                   IF        BBCHSC <> *Zeros
     C                   MOVEL     BBCHSC        ##D(11)
     C                   ENDIF
      *
      ** Customer Chips ABA
      *
     C                   IF        BBCABA <> *Zeros
     C                   MOVEL     BBCABA        ##D(12)
     C                   ENDIF
      *
      ** Customer BOJ Fin. Inst. Code
      *
     C                   MOVEL     BBBFIC        ##D(13)
      *
      ** Customer Bankleitzahl Code (alpha)
      *
     C                   MOVEL     BBBLCD        ##D(14)
      *
      ** Customer Fedwire Code
      *
     C                   IF        BBFWCD <> *Zeros
     C                   MOVEL     BBFWCD        ##D(15)
     C                   ENDIF
      *
      ** Customer Chips ABA for CHIPS 2
      *
     C                   IF        BBABA2 <> *Zeros
     C                   MOVEL     BBABA2        ##D(16)
     C                   ENDIF
      *
      ** Customer Number
      *
     C                   MOVEL     BBCUST        ##D(17)
      *
      ** SWIFT Address
      *  -------------
      *
     C                   ELSE
      *
      ** SWIFT Address
      *
     C                   MOVEL     WSWIFTCust    ##D(1)
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Decrement Path DS index
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *
     C                   EXSR      POPGRS
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRGenRef - Generate reference number and write               *
      *****************************************************************
     C     SRGenRef      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRGenRef  '  @STK(Q)
      *
      ** Reset the flag that indicates wether a correspondence is to be
      ** produced or not.
      *
     C                   MOVEL     'N'           WProduce
      *
      ** Set up fields of parameter PEDsCGUDCRPD to be passed to CG9010
      *
     C                   CLEAR                   PEDsCGUDCRPD
      *
      ** Booking/Main branch (mandatory)
      *
     C                   MOVEL     SPSNDR        DRBRCA                         Sending Branch
      *
      ** Originating branch (Optional)
      *
     C                   MOVEL     SPORIG        DRORBR                         Originating Branch
      *
      ** Module ID (madatory)
      *
     C                   MOVEL     'SE'          DRMODI
      *
      ** MIDAS Transaction number
      *
     C                   EVAL      DRMTRN = SPCUST + SPTYPE
      *
      ** Print Item Type
      *
     C                   MOVEL     WCPrtItmTyp   DRPTYP
      *
      ** Print Item Subtype
      *
     C                   MOVEL     WCPrtItmSubTypDRPSTP
      *
      ** Auto Transmission indicator
      *
     C                   MOVEL     'N'           DRATRM
      *
      ** Customer
      *
     C                   MOVE      *BLANKS       PCustNumChr6
     C                   MOVE      SPCUST        PCustNumChr6
      *
      ** If the newtork is 'Paper',
      ** create item reference records in CGUDCRPD
      *
     C                   IF        SPNWRK = 'PAPER'
      *
     C                   CALL      'CG9010'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*GEN'        PMode
     C                   PARM      P0Commit      PCommit
     C                   PARM                    PCustNumChr6
     C                   PARM                    PEDsCGUDCRPD
     C                   PARM      *BLANKS       PItmRef
      *
      ** Otherwise,
      *
     C                   ELSE
     C                   MOVE      *BLANKS       PRtnCode
     C                   MOVE      SPEXTR        PItmRef
     C                   ENDIF
      *
     C                   SELECT
      *
      ** No error, generate correspondence
     C                   WHEN      PRtnCode = *BLANKS
     C                   MOVEL     'Y'           WProduce
     C                   MOVEL     PItmRef       ##ITEM
     C     DRPTYP        CAT       ':':0         COLON            11
     C     COLON         CAT       DRPSTP:0      ##REFR
     C                   EXSR      WRAPRF
      *
      ** No error, suppress output
     C                   WHEN      PRtnCode = 'CGD1270'
      *
      ** Error.
     C                   OTHER
     C                   MOVEL     'CG9010'      W0File
     C                   MOVEL     PRtnCode      W0Key
     C                   Z-ADD     5             W0ERNB
     C                   MOVEL     'CGD1286'     W0MsgD
     C                   MOVEL     'CGUSRMSG'    W0MsgF
     C                   EXSR      SRERR
      *
     C                   ENDSL
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRInitial - Initial processing.                              *
      *****************************************************************
     C     SRInitial     BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRInitial '  @STK(Q)
      *
      ** Index of WMDsPath
      *
     C                   Z-ADD     0             WPx
      *
      ** Output Sequence counter
      *
     C                   Z-ADD     0             WOutSeq
      *
      ** Initialise XML increment
      *
     C                   EXSR      INIXML
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRPath - Set up path string.                                 *
      *****************************************************************
     C     SRPath        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRPath    '  @STK(Q)
      *
      ** Reset output path string
      *
     C                   MOVEL     *BLANKS       WPathStr
      *
      ** Copy path from multi-occurence DS to string. Each entry is to be
      ** preceded by '\'.
      *
     C                   DO        WPx           Wx1
     C     Wx1           OCCUR     WMDsPath
     C                   CAT       '\':0         WPathStr
     C                   CAT       WMDsPathGrp:0 WPathStr
     C                   ENDDO
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRtvRDE - Retrieve 20 RDE's from the compile-time array and *
      *            store it in ##R.                                   *
      *****************************************************************
     C     SRRtvRDE      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRRtvRDE  '  @STK(Q)
      *
      ** Reset primary arrays
      *
     C                   CLEAR                   ##R
     C                   CLEAR                   ##D
     C                   CLEAR                   ##S
      *
      ** Get info from compile time array of the 20 RDEs in group set
      *
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
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  RFmtDta - Reformat data before packing it.                  *
      *****************************************************************
     C     SRFmtDta      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRFmtDta  '  @STK(Q)
      *
      ** Loop through RDE's and data
      *
     C                   Z-ADD     0             Wx1
      *
     C     Wx1           DOUEQ     20
      *
      ** Move RDE's and its data to their templates
     C                   ADD       1             Wx1
     C                   MOVEL     ##R(Wx1)      R#DEFN
     C                   MOVEL     ##D(Wx1)      R#DATA
      *
      ** Reformat only if data is present and RDE is edited
     C     R#DATA        IFNE      *BLANK
     C     ##RDEC        ANDNE     *BLANK
      *
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
      *
      ** Sign
     C     ##SIGN        IFEQ      '-'
     C                   Z-SUB     WNum20        ##NUMB
     C                   ELSE
     C                   Z-ADD     WNum20        ##NUMB
     C                   ENDIF
      *
      ** Edit type
     C     ##EDTT        IFEQ      *BLANK
     C                   MOVEL     ##RDET        ##EDTT
     C                   ENDIF
      *
      ** Default decimal places
     C     ##DCPA        IFEQ      *BLANK
     C                   MOVEL     ##RDED        ##DCPA
     C                   ENDIF
      *
      ** New RDE data
     C                   MOVEL     R#DATA        ##D(Wx1)
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtNum - Replaces leading blanks with asterisks.           *
      *             Uses WArr20X1 array as input and output parameter.*
      *                                                               *
      *             Input Parameters:                                 *
      *                PChr016  - Amount                              *
      *                PNum010P - Number of decimals                  *
      *                                                               *
      *             Output Parameters:                                *
      *                WArr20X1  - Formatted amount                   *
      *                                                               *
      *****************************************************************
     C     SRFmtNum      BEGSR
      *
      ** Insert decimal point and suppress leading zeroes
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    PChr016
     C                   PARM                    PNum010P
      *
     C                   MOVEA     *BLANKS       WArr20X1
     C                   MOVEA     PChr016       WArr20X1(5)
     C                   Z-ADD     1             Wx1
     C                   DOW       WArr20X1(Wx1) = *BLANK
     C                   MOVEA     '*'           WArr20X1(Wx1)
     C                   ADD       1             Wx1
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRPackDta - Pack/Unpack RDEs and their corresponding data.   *
      *****************************************************************
     C     SRPackDta     BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRPackDta '  @STK(Q)
      *
      ** Reformat RDE data
      *
     C                   EXSR      SRFmtDta
      *
     C     CCG015        IFEQ      'Y'
     C                   MOVEL     '*NEWARR '    PAction8
     C                   MOVEL     WPathStr      W0SPAT
     C                   ELSE
     C                   MOVEL     '*PACK   '    PAction8
     C                   MOVEL     *BLANK        W0SPAT
     C                   ENDIF
      *
      ** Pack RDEs and associated data into data strings
      *
     C                   CALL      'CG3999'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM                    PAction8
     C                   PARM                    ##R
     C                   PARM                    ##D
     C                   PARM                    ##S
     C                   PARM                    W0SPAT           70
     C                   PARM                    ##RN
     C                   PARM                    ##DN
     C                   PARM                    ##FM
      *
     C                   IF        PRtnCode <> *BLANKS
     C                   MOVEL     'CG3999'      W0File
     C                   MOVEL     PRtnCode      W0Key
     C                   Z-ADD     6             W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS  '     W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   EXSR      WRTRDE
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initialization routine.                              *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM      W0RTN         P0RtnCode
     C                   PARM                    P0DsSDRV
     C                   PARM                    P0Commit
      *
      ** Key list to access request details
      *
     C     KRequest      KLIST
     C                   KFLD                    SPEXTR
      *
      ** Key list to access Sub-balance details
      *
     C     KSubBal       KLIST
     C                   KFLD                    SPEXTR
     C                   KFLD                    HFSESN
      *
     C                   MOVEL     ##PGM         DBPGM
      *
      ** Access Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      *BLANKS       DSFDY
     C     PRtnCode      IFNE      *BLANKS
     C                   EVAL      W0File = 'SDBANKPD'
     C                   EVAL      W0Key = POption
     C                   EVAL      W0ERNB = 7
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS  '
     C                   EXSR      SRERR
     C                   ENDIF
      *
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
MsgOth0001 MSG FIRST                     Message First Message Reference
MsgOth0002 MSG NWRK                      Message Network
MsgOth0003 MSG PRTY                      Message Priority
MsgOth0004 MSG NOTF                      Message Delivery Notification
MsgOth0005 SYST ID                       System ID
SWBrch0001 BRCH CODE                     Branch Code
SWBrch0002 BRCH CUST                     Branch Internal Customer
SWBrch0003 BRCH TID                      Branch TID Address
SWBrch0004 BRCH CSID                     Branch SWIFT Address
SWBrch0005 BRCH ADR1                     Branch Address 1
SWBrch0006 BRCH ADR2                     Branch Address 2
SWBrch0007 BRCH ADR3                     Branch Address 3
SWBrch0008 BRCH ADR4                     Branch Address 4
SWBrch0009 BRCH CRNM                     Branch Report Name
SWCust0001 CUST SWIFT                    Customer SWIFT Address
SWCust0002 CUST ADR1                     Customer Address 1
SWCust0003 CUST ADR2                     Customer Address 2
SWCust0004 CUST ADR3                     Customer Address 3
SWCust0005 CUST ADR4                     Customer Address 4
SWCust0006 CUST TOWN                     Customer Report Town
SWCust0007 CUST NAME                     Customer Report Name
SWCust0008 CUST LOCA                     Customer Location
SWCust0009 CUST STTX                     Customer STTX  Address
SWCust0010 CUST CHID                     Customer Chips Id
SWCust0011 CUST CHSC                     Customer Chaps sort code
SWCust0012 CUST CABA                     Customer Chips ABA
SWCust0013 CUST BFIC                     Customer BOJ Fin. Inst. Code
SWCust0014 CUST BLCD                     Customer Bankleitzahl Code (alpha)
SWCust0015 CUST FWCD                     Customer Fedwire Code
SWCust0016 CUST ABA2                     Customer Chips ABA for CHIPS 2
SWCust0017 CUST NBR                      Customer Number
GenInf0001 PAGE NBR   Number             General Page Number
GenInf0002 PAGE CONT                     General Page Continuation Indicator
GenInf0003 STAT NBR   Number             General Statement Number
GenInf0004 MSG REF                       General Message Reference
GenInf0005 FUNC CODE                     General Function Code
GenInf0006 PREP DATE  Date               General Preparation Date
GenInf0007 PREP TIME                     General Preparation Time
GenInf0008 STAT DATE  Date               General Statement Date
GenInf0009 STAT TIME                     General Statement Time
GenInf0010 STAT FREQ                     General Statement Frequency
GenInf0011 STAT COMP                     General Complete/Update
GenInf0012 STAT TYPE                     General Statement Type
GenInf0013 STAT BASE                     General Statement Basis
GenInf0014 SAFE ACCNT                    General Safekeeping Account
GenInf0015 FLAG ACTI                     General Activity Flag
GenInf0016 FLAG AUDI                     General Audited Statement
GenInf0017 FLAG CONS                     General Sub-safekeeping Statement
GenLin0001 RLT MSG TY                    Link Related Message Type
GenLin0002 RLT MSG                       Link Related Message
GenLin0003 PREV MSG                      Link Previous Message Cancelled
SecDtl0001 SEC CURR                      Nominal Currency
SecDtl0002 SEC DECIM                     Nominal decimal places
SecDtl0003 SEC CTRY                      Country of risk
SecDtl0004 SEC SEDOL                     Sedol (Extel) Ref
SecDtl0005 SEC TELEK                     Telekurs (Valoren) Ref
SecDtl0006 SEC CUSIP                     Cusip Number
SecDtl0007 SEC PRI B                     Price Basis
SecDtl0008 SEC TRA B                     Trade Basis
SecDtl0009 SEC YIE B                     Yield Basis
SecDtl0010 SEC SWIFT                     SWIFT Security Type
SecDtl0011 SEC PROC                      Processing Type
Instru0001 SEC ISIN                      Security shortname
Instru0002 SEC SHORT                     Security shortname
Instru0003 SEC NAME                      Security Report Name
Instru0004 SEC NAME 1                    Security Full Name - 1
Instru0005 SEC NAME 2                    Security Full Name - 2
Instru0006 CORP ACT                      Corporate Action Option Code
Instru0007 PRICE QUAL                    Price Qualifier
Instru0008 PRICE CODE                    Price Code
Instru0009 PRICE CURR                    Price Currency
Instru0010 PRICE      Rate   8           Price
Instru0011 PLACE CODE                    Place Code
Instru0012 PLACE                         Place
Instru0013 PRICE DATE Date               Price Quotation Date
Instru0014 PRICE TIME                    Price Quotation Time
FinAmt0001 BAL CODE                      Balance Code
FinAmt0002 BAL AMOUNT Amount 0           Balance Amount
FinAmt0003 ACC DAY    Number             Number Days Accrued
FinAmt0004 ACC CURR                      Accrued Amount Currency
FinAmt0005 ACC AMOUNT Amount 0           Accrued Amount
FinAmt0006 HOLD CURR                     Holding Amount Currency
FinAmt0007 HOLD AMNT  Amount 0           Holding Amount
FinAmt0008 EXCH CURR1                    Exchange Rate Currency 1
FinAmt0009 EXCH CURR2                    Exchange Rate Currency 2
FinAmt0010 EXCH RATE  Rate   8           Exchange Rate
FinAmt0011 EXCH M_D                      Exchange Mult/Div Ind.
SubBal0001 SBAL QUAL                     Sub-Balance Qualifier
SubBal0002 SBAL QUANT                    Sub-Balance Quantity Code
SubBal0003 SBAL TYPE                     Sub-Balance Type Code
SubBal0004 SBAL AMNT  Amount 0           Sub-Balance Amount
SubBal0005 SPLACE QUA                    Sub-Balance Place Qualifier
SubBal0006 SPLACE COD                    Sub-Balance Place Code
SubBal0007 SPLACE                        Sub-Balance Place
SubBal0008 SPLACE CTY                    Sub-Balance Place Country
SubBal0009 SBIC_BEI                      Sub-Balance BIC/BEI
SubBal0010 SBAL NARR1                    Sub-Balance Narrative 1
SubBal0011 SBAL NARR2                    Sub-Balance Narrative 2
SubBal0012 SBAL NARR3                    Sub-Balance Narrative 3
SubBal0013 SBAL NARR4                    Sub-Balance Narrative 4
AddInf0001 TOT CURR                      Total Holding Currency
AddInf0002 TOT PAGE   Amount 0           Total Holding Page
AddInf0003 TOT STAT   Amount 0           Total Holding Statement
