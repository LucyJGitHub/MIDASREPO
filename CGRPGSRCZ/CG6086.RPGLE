     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG SE Statement of transaction extract')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG6086 - Midas CG SE Statement of Transactions Extract       *
      *                                                               *
      *  Function:  This program formats the SE Statement details in  *
      *                                                               *
      *             XML format for MMM and Correspondence Manager     *
      *                                                               *
      *  Called By   : CG6080 - SE Statement Driver                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CSE040  *CREATE    Date 04Apr03               *
      *                                                               *
      *****************************************************************
      *                                                               *
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
      ** Midas SE General Information by Extract reference
 
     FSETFINL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Transaction - Financial Instruments by Extract reference
 
     FSETTRAL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Transaction - Transaction Details by Extract reference
 
     FSETINDL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Transaction - Transaction Indicators by Extract reference
 
     FSETPRTL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Transaction - Transaction Party by Extract reference
 
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
 
     D WCPrtItmSubTyp  C                   CONST('TRANSACT  ')
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
      ** Multi-occurence data structure to store path from start
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
     D WTbGrp          S             10    DIM(123) CTDATA PERRCD(1)
     D WTbRDE          S             22    DIM(123) ALT(WTbGrp)
 
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
     D WAddress1       S                   LIKE(BBCNA1)
     D WAddress2       S                   LIKE(BBCNA2)
     D WAddress3       S                   LIKE(BBCNA3)
     D WAddress4       S                   LIKE(BBCNA4)
 
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
     C                   EXSR      SRStmTrn
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
      *  SRStmTrn   - Top group set.                                  *
      *****************************************************************
     C     SRStmTrn      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRStmTrn  '  @STK(Q)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   Z-ADD     1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'StmTrn'      WMDsPathGrp
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
     C     KRequest      SETLL     SETFINL0
     C     KRequest      READE     SETFINL0
     C                   DOW       NOT %EOF(SETFINL0)
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
      ************************
      ** Access Transaction **
      ************************
      *
     C     KTransac      SETLL     SETTRAL0
     C     KTransac      READE     SETTRAL0
     C                   DOW       NOT %EOF(SETTRAL0)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'Trans '      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ** Repetitive Mandatory Subsequence B1a Transaction
      *
     C                   EXSR      SRTrans
      *
      **********************************
      ** Access Transaction Indicator **
      **********************************
      *
     C     KTrnInd       SETLL     SETINDL0
     C     KTrnInd       READE     SETINDL0
     C                   DOW       NOT %EOF(SETINDL0)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'TrnInd'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ** Repetitive Transaction Indicator
      *
     C                   EXSR      SRTrnInd
      *
      ** Decrement Path DS index - Transaction Indicator
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *
     C                   EXSR      POPGRS
      *
     C     KTrnInd       READE     SETINDL0
     C                   ENDDO
      *
      ******************************
      ** Access Transaction Party **
      ******************************
      *
     C     KTrnPrt       SETLL     SETPRTL0
     C     KTrnPrt       READE     SETPRTL0
     C                   DOW       NOT %EOF(SETPRTL0)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'TrnPrt'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ** Repetitive Optional Subsequence B1a2a Settlement Parties
      *
     C                   EXSR      SRTrnPrt
      *
      ** Decrement Path DS index - Transaction Party
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *
     C                   EXSR      POPGRS
      *
     C     KTrnPrt       READE     SETPRTL0
     C                   ENDDO
      *
      ** Decrement Path DS index - Transaction
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *
     C                   EXSR      POPGRS
      *
     C     KTransac      READE     SETTRAL0
     C                   ENDDO
      *
      ** Decrement Path DS index - Financial Instruments
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *
     C                   EXSR      POPGRS
      *
     C     KRequest      READE     SETFINL0
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
     C                   MOVEL     *Blanks       WAddress1
     C                   MOVEL     *Blanks       WAddress2
     C                   MOVEL     *Blanks       WAddress3
     C                   MOVEL     *Blanks       WAddress4
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
      ** Start Date
      *
     C                   MOVEL     HGMSTD        ##D(8)
      *
      ** Start Time
      *
     C                   IF        HGSTRM <> *Zeros
     C                   MOVEL     HGSTRM        ##D(9)
     C                   ENDIF
      *
      ** End Date
      *
     C                   MOVEL     HGMETD        ##D(10)
      *
      ** End Time
      *
     C                   IF        HGENTM <> *Zeros
     C                   MOVEL     HGENTM        ##D(11)
     C                   ENDIF
      *
      ** Statement Frequency
      *
     C                   MOVEL     HGSFRE        ##D(12)
      *
      ** Complete/Update
      *
     C                   MOVEL     HGCODE        ##D(13)
      *
      ** Safekeeping Account
      *
     C                   MOVEL     HGCUST        ##D(14)
      *
      ** Activity Flag
      *
     C                   MOVEL     HGACTI        ##D(15)
      *
      ** Sub-safekeeping Statement
      *
     C                   MOVEL     HGCONS        ##D(16)
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
     C                   MOVEL     TFNMCY        ##D(1)
      *
      ** Nominal decimal places
      *
     C                   MOVEL     TFNMDP        ##D(2)
      *
      ** Country of risk
      *
     C                   MOVEL     TFSCOR        ##D(3)
      *
      ** Sedol (Extel) Ref
      *
     C                   MOVEL     TFSREF        ##D(4)
      *
      ** Telekurs (Valoren) Ref
      *
     C                   MOVEL     TFT2RF        ##D(5)
      *
      ** Cusip Number
      *
     C                   MOVEL     TFCSPN        ##D(6)
      *
      ** Price Basis
      *
     C                   MOVEL     TFSPBS        ##D(7)
      *
      ** Trade Basis
      *
     C                   MOVEL     TFSTBS        ##D(8)
      *
      ** Yield Basis
      *
     C                   MOVEL     TFSYBS        ##D(9)
      *
      ** SWIFT Security Type
      *
     C                   MOVEL     TFSWTP        ##D(10)
      *
      ** Processing Type
      *
     C                   MOVEL     TFPROT        ##D(11)
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
     C                   MOVEL     TFISIN        ##D(1)
      *
      ** Security shortname
      *
     C                   MOVEL     TFSESN        ##D(2)
      *
      ** Security Report Name
      *
     C                   MOVEL     TFSRPN        ##D(3)
      *
      ** Security Full Name - 1
      *
     C                   MOVEL     TFSFN1        ##D(4)
      *
      ** Security Full Name - 2
      *
     C                   MOVEL     TFSFN2        ##D(5)
      *
      ** Price Qualifier
      *
     C                   MOVEL     TFPQUA        ##D(6)
      *
      ** Price Code
      *
     C                   MOVEL     TFPCOD        ##D(7)
      *
      ** Price Currency
      *
     C                   MOVEL     TFPCCY        ##D(8)
      *
      ** Price
      *
     C                   MOVEL     TFPRIC        ##D(9)
      *
      ** Price Decimal Position
      *
     C                   MOVEL     ##R(9)        R#DEFN
     C                   MOVE      TFPDPS        ##RDED                         Decimal Position
     C                   MOVEL     R#DEFN        ##R(9)
      *
      ** Place Code
      *
     C                   MOVEL     TFPLCD        ##D(10)
      *
      ** Place
      *
     C                   MOVEL     TFPLAC        ##D(11)
      *
      ** Price Quotation Date
      *
     C                   IF        TFPQDT <> *Zeros
     C                   MOVEL     TFPQDT        ##D(12)
     C                   ENDIF
      *
      ** Price Quotation Time
      *
     C                   IF        TFPQTM <> *Zeros
     C                   MOVEL     TFPQTM        ##D(13)
     C                   ENDIF
      *
      ** Balance Type
      *
     C                   MOVEL     TFBLCD        ##D(14)
      *
      ** Opening Balance Code
      *
     C                   MOVEL     TFOBLC        ##D(15)
      *
      ** Opening Balance
      *
     C                   MOVEL     TFOBAL        ##D(16)
      *
      ** Balance Decimal Position
      *
     C                   MOVEL     ##R(16)       R#DEFN
     C                   MOVE      TFBLDP        ##RDED                         Decimal Position
     C                   MOVEL     R#DEFN        ##R(16)
      *
      ** Closing Balance Code
      *
     C                   MOVEL     TFCBLC        ##D(17)
      *
      ** Closing Balance
      *
     C                   MOVEL     TFCBAL        ##D(18)
      *
      ** Balance Decimal Position
      *
     C                   MOVEL     ##R(18)       R#DEFN
     C                   MOVE      TFBLDP        ##RDED                         Decimal Position
     C                   MOVEL     R#DEFN        ##R(18)
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
      ******************************************************************
      *  SRTrans    - Repetitive Mandatory Subsequence B1a Sub-Balance *
      ******************************************************************
     C     SRTrans       BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRTrans   '  @STK(Q)
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'Trans1'      WGrpName
     C                   EXSR      SRRtvRDE
      *
      ** Transaction Type
      *
     C                   MOVEL     TTTYPE        ##D(1)
      *
      ** Pool Reference
      *
     C                   MOVEL     TTRFPO        ##D(2)
      *
      ** Link Previous Reference Type
      *
     C                   MOVEL     TTLKPR        ##D(3)
      *
      ** Previous Reference
      *
     C                   MOVEL     TTRFPR        ##D(4)
      *
      ** Link Related Reference Type
      *
     C                   MOVEL     TTLKRE        ##D(5)
      *
      ** Related Reference
      *
     C                   MOVEL     TTRFRE        ##D(6)
      *
      ** Deal Reference
      *
     C                   MOVEL     TTRFTR        ##D(7)
      *
      ** Common Reference
      *
     C                   MOVEL     TTRFCO        ##D(8)
      *
      ** Account Servicer Reference
      *
     C                   MOVEL     TTRFAS        ##D(9)
      *
      ** Posting Quantity Type
      *
     C                   MOVEL     TTPQTY        ##D(10)
      *
      ** Posting Quantity
      *
     C                   MOVEL     TTPQUA        ##D(11)
      *
      ** Posting Quantity Decimal
      *
     C                   MOVEL     ##R(11)       R#DEFN
     C                   MOVE      TTPQDC        ##RDED                         Decimal Position
     C                   MOVEL     R#DEFN        ##R(11)
      *
      ** Number Days Accrued
      *
     C                   MOVEL     TTNBDY        ##D(12)
      *
      ** Accrued Interest Currency
      *
     C                   MOVEL     TTAICY        ##D(13)
      *
      ** Accrued Interest
      *
     C                   MOVEL     TTAIMT        ##D(14)
      *
      ** Accrued Interest Decimal
      *
     C                   MOVEL     ##R(14)       R#DEFN
     C                   MOVE      TTAIDP        ##RDED                         Decimal Position
     C                   MOVEL     R#DEFN        ##R(14)
      *
      ** Posting Amount Currency
      *
     C                   MOVEL     TTPACY        ##D(15)
      *
      ** Posting Amount
      *
     C                   MOVEL     TTPAMT        ##D(16)
      *
      ** Posting Amount Decimal
      *
     C                   MOVEL     ##R(16)       R#DEFN
     C                   MOVE      TTPADP        ##RDED                         Decimal Position
     C                   MOVEL     R#DEFN        ##R(16)
      *
      ** Effective Settlement Date
      *
     C                   IF        TTESDT <> *Zeros
     C                   MOVEL     TTESDT        ##D(17)
     C                   ENDIF
      *
      ** Effective Settlement Time
      *
     C                   IF        TTESTM <> *Zeros
     C                   MOVEL     TTESTM        ##D(18)
     C                   ENDIF
      *
      ** Effective Settlement Code
      *
     C                   MOVEL     TTESCD        ##D(19)
      *
      ** Accumulate RDEs and associated data and output
      *
     C                   EXSR      SRPackDta
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'Trans2'      WGrpName
     C                   EXSR      SRRtvRDE
      *
      ** Settlement Date
      *
     C                   IF        TTSEDT <> *Zeros
     C                   MOVEL     TTSEDT        ##D(1)
     C                   ENDIF
      *
      ** Settlement Time
      *
     C                   IF        TTSETM <> *Zeros
     C                   MOVEL     TTSETM        ##D(2)
     C                   ENDIF
      *
      ** Settlement Code
      *
     C                   MOVEL     TTSECD        ##D(3)
      *
      ** Trade Date
      *
     C                   IF        TTTRDT <> *Zeros
     C                   MOVEL     TTTRDT        ##D(4)
     C                   ENDIF
      *
      ** Trade Time
      *
     C                   IF        TTTRTM <> *Zeros
     C                   MOVEL     TTTRTM        ##D(5)
     C                   ENDIF
      *
      ** Trade Code
      *
     C                   MOVEL     TTTRCD        ##D(6)
      *
      ** Movement Status
      *
     C                   MOVEL     TTMOVS        ##D(7)
      *
      ** Transaction Narrative 1
      *
     C                   MOVEL     TTNAR1        ##D(8)
      *
      ** Transaction Narrative 2
      *
     C                   MOVEL     TTNAR2        ##D(9)
      *
      ** Transaction Narrative 3
      *
     C                   MOVEL     TTNAR3        ##D(10)
      *
      ** Transaction Narrative 4
      *
     C                   MOVEL     TTNAR4        ##D(11)
      *
      ** Transaction Narrative 5
      *
     C                   MOVEL     TTNAR5        ##D(12)
      *
      ** Transaction Narrative 6
      *
     C                   MOVEL     TTNAR6        ##D(13)
      *
      ** Transaction Narrative 7
      *
     C                   MOVEL     TTNAR7        ##D(14)
      *
      ** Transaction Narrative 8
      *
     C                   MOVEL     TTNAR8        ##D(15)
      *
      ** Transaction Narrative 9
      *
     C                   MOVEL     TTNAR9        ##D(16)
      *
      ** Transaction Narrative 10
      *
     C                   MOVEL     TTNA10        ##D(17)
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
      *  SRTrnInd   - Transaction Indicator                           *
      *****************************************************************
     C     SRTrnInd      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRTrnInd  '  @STK(Q)
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'TrnInd'      WGrpName
     C                   EXSR      SRRtvRDE
      *
      ** Qualifier
      *
     C                   MOVEL     TIQUAL        ##D(1)
      *
      ** Indicator
      *
     C                   MOVEL     TIINDC        ##D(2)
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
      *  SRTrnPrt   - Transaction Party                               *
      *****************************************************************
     C     SRTrnPrt      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRTrnPrt  '  @STK(Q)
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'TrnPrt'      WGrpName
     C                   EXSR      SRRtvRDE
      *
      ** Party Qualifier
      *
     C                   MOVEL     TPQUAL        ##D(1)
      *
      ** Safekeeping Account 1
      *
     C                   MOVEL     TPSAF1        ##D(2)
      *
      ** Safekeeping Account 2
      *
     C                   MOVEL     TPSAF2        ##D(3)
      *
      ** Safekeeping Account 3
      *
     C                   MOVEL     TPSAF3        ##D(4)
      *
      ** Safekeeping Account 4
      *
     C                   MOVEL     TPSAF4        ##D(5)
      *
      ** Accumulate RDEs and associated data and output
      *
     C                   EXSR      SRPackDta
      *
      ** Set up fields to be passed to SRSWCust
      *
     C                   MOVEL     TPPRTC        WSWIFTCust
     C                   MOVEL     TPPRT1        WAddress1
     C                   MOVEL     TPPRT2        WAddress2
     C                   MOVEL     TPPRT3        WAddress3
     C                   MOVEL     TPPRT4        WAddress4
     C                   EXSR      SRSWCust
      *
      ** Accumulate RDEs and associated data and output to CGUDTAPD
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
      ** Customer Address 1
      *
     C                   MOVEL     WAddress1     ##D(2)
      *
      ** Customer Address 2
      *
     C                   MOVEL     WAddress2     ##D(3)
      *
      ** Customer Address 3
      *
     C                   MOVEL     WAddress3     ##D(4)
      *
      ** Customer Address 4
      *
     C                   MOVEL     WAddress4     ##D(5)
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
      ** Key list to access Transaction details
      *
     C     KTransac      KLIST
     C                   KFLD                    SPEXTR
     C                   KFLD                    TFSESN
      *
      ** Key list to access Indicator details
      *
     C     KTrnInd       KLIST
     C                   KFLD                    SPEXTR
     C                   KFLD                    TFSESN
     C                   KFLD                    TTTSEQ
      *
      ** Key list to access Party details
      *
     C     KTrnPrt       KLIST
     C                   KFLD                    SPEXTR
     C                   KFLD                    TFSESN
     C                   KFLD                    TTTSEQ
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
GenInf0008 STAR DATE  Date               General Start Date
GenInf0009 STAR TIME                     General Start Time
GenInf0010 END  DATE  Date               General End Date
GenInf0011 END  TIME                     General End Time
GenInf0012 STAT FREQ                     General Statement Frequency
GenInf0013 STAT COMP                     General Complete/Update
GenInf0014 SAFE ACCNT                    General Safekeeping Account
GenInf0015 FLAG ACTI                     General Activity Flag
GenInf0016 FLAG CONS                     General Sub-safekeeping Statement
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
Instru0006 PRICE QUAL                    Price Qualifier
Instru0007 PRICE CODE                    Price Code
Instru0008 PRICE CURR                    Price Currency
Instru0009 PRICE      Rate   8           Price
Instru0010 PLACE CODE                    Place Code
Instru0011 PLACE                         Place
Instru0012 PRICE DATE Date               Price Quotation Date
Instru0013 PRICE TIME                    Price Quotation Time
Instru0014 BAL CODE                      Balance Code
Instru0015 OPEN CODE                     Opening Balance Code
Instru0016 OPEN BAL   Amount 0           Opening Balance
Instru0017 CLOS CODE                     Closing Balance Code
Instru0018 CLOSE BAL  Amount 0           Closing Balance
Trans10001 TR TYPE                       Transaction Type
Trans10002 TR POOL                       Transaction Pool Reference
Trans10003 TR LK PR                      Transaction Link Previous Reference Type
Trans10004 TR PREV                       Transaction Previous Reference
Trans10005 TR LK RE                      Transaction Link Related Reference Type
Trans10006 TR RELA                       Transaction Related Reference
Trans10007 TR DEAL                       Transaction Deal Reference
Trans10008 TR COMMON                     Transaction Common Reference
Trans10009 TR SERVIC                     Transaction Account Servicer Reference
Trans10010 TR QUA TYP                    Transaction Posting Quantity Type
Trans10011 TR QUANTIT Amount 0           Transaction Posting Quantity
Trans10012 TR NBDY    Number             Transaction Number Days Accrued
Trans10013 TR ACC CCY                    Transaction Accrued Interest Currency
Trans10014 TR ACCRUAL Amount 0           Transaction Accrued Interest
Trans10015 TR AMT CCY                    Transaction Posting Amount Currency
Trans10016 TR AMOUNT  Amount 0           Transaction Posting Amount
Trans10017 TR EFF DAT Date               Transaction Effective Settlement Date
Trans10018 TR EFF TIM                    Transaction Effective Settlement Time
Trans10019 TR EFF COD                    Transaction Effective Settlement Code
Trans20001 TR SET DAT Date               Transaction Settlement Date
Trans20002 TR SET TIM                    Transaction Settlement Time
Trans20003 TR SET COD                    Transaction Settlement Code
Trans20004 TR TRD DAT Date               Transaction Trade Date
Trans20005 TR TRD TIM                    Transaction Trade Time
Trans20006 TR TRD COD                    Transaction Trade Code
Trans20007 TR MOV STS                    Transaction Movement Status
Trans20008 TR NARR 1                     Transaction Transaction Narrative 1
Trans20009 TR NARR 2                     Transaction Transaction Narrative 2
Trans20010 TR NARR 3                     Transaction Transaction Narrative 3
Trans20011 TR NARR 4                     Transaction Transaction Narrative 4
Trans20012 TR NARR 5                     Transaction Transaction Narrative 5
Trans20013 TR NARR 6                     Transaction Transaction Narrative 6
Trans20014 TR NARR 7                     Transaction Transaction Narrative 7
Trans20015 TR NARR 8                     Transaction Transaction Narrative 8
Trans20016 TR NARR 9                     Transaction Transaction Narrative 9
Trans20017 TR NARR 10                    Transaction Transaction Narrative 10
TrnInd0001 TR IND QUA                    Transaction Indicator Qualifier
TrnInd0002 TR INDICAT                    Transaction Indicator
TrnPrt0001 TR PRT QUA                    Transaction Party Qualifier
TrnPrt0002 TR SAFE 1                     Transaction Safekeeping Account 1
TrnPrt0003 TR SAFE 2                     Transaction Safekeeping Account 2
TrnPrt0004 TR SAFE 3                     Transaction Safekeeping Account 3
TrnPrt0005 TR SAFE 4                     Transaction Safekeeping Account 4
