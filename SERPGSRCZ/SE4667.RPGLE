     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2021')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE4667 - Midas SE Statement of Pending Transactions          *
      *           Extract                                             *
      *                                                               *
      *  Function:  This program formats the SE Statement details in  *
      *                                                               *
      *             XML format for MMM and Correspondence Manager     *	
      *                                                               *
      *  Called By   : CG6080 - SE Statement Driver                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2021            *
      *                                                               *
      *  Last Amend No. 252259             Date 10Mar21               *
      *  Prev Amend No. CSE040  *Create    Date 10Mar21               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  252259 - MT537 are Nacked,                                   *
      *           Load pay amount in all cases                        *
      *  CSE040 - Security Statement Production                       *
      *           Correspondence Manager extract                      *
      *           Applied for MD-55740                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *                                                               *
      *  60 - Network PAPER (Correspondence Manager)                  *
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

     FSEPSTAL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Pending Transaction - Status by Extract reference/Status

     FSEPSTAL3  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Pending Transaction - Status by Extract reference/Transaction
     F                                     RENAME(SEPSTAD0:SEPSTAD3)

     FSEPTRAL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Pending Transaction - Transaction by Extract reference

     FSEPINDL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Pending Transaction - Indicators by Extract reference

     FSEPPRTL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Pending Transaction - Party by Extract reference

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

     D WCPrtItmSubTyp  C                   CONST('PENDING   ')
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
     D  QQDFAC1      E                     EXTFLD(QQDFAC)
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
     C                   EXSR      SRStmPen
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
      *  SRStmPen   - Top group set.                                  *
      *****************************************************************
     C     SRStmPen      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRStmPen  '  @STK(Q)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   Z-ADD     1             WPx
     C     WPx           OCCUR     WMDsPath
     C  N60              MOVEL     'StmPen'      WMDsPathGrp
     C   60              MOVEL     'StmPep'      WMDsPathGrp
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
      *
      ************************************
      ** Access Sub-Safekeeping Account **
      ************************************
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C  N60              MOVEL     'SubSaf'      WMDsPathGrp
     C   60              MOVEL     'SubSap'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ** Repetitive Optional Subsequence B Status
      *
     C                   IF        HGTYPE = 'PS'
      *
     C                   EXSR      SRStsStat

     C                   ELSE
      *
      ** Repetitive Optional Subsequence C Transaction
      *
     C                   EXSR      SRStsTran
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
     C  N60              MOVEL     'MsgOth'      WMDsPathGrp
     C   60              MOVEL     'MsgOtp'      WMDsPathGrp
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
     C  N60              MOVEL     'Sender'      WMDsPathGrp
     C   60              MOVEL     'Sendep'      WMDsPathGrp
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
     C  N60              MOVEL     'Origin'      WMDsPathGrp
     C   60              MOVEL     'Origip'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ** Set up fields to be passed to SRSWBrch
      *
     C                   MOVEL     HGORIG        WBrchRef
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
     C  N60              MOVEL     'Recip '      WMDsPathGrp
     C   60              MOVEL     'Recpp '      WMDsPathGrp
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
     C  N60              MOVEL     'GenInf'      WMDsPathGrp
     C   60              MOVEL     'GenInp'      WMDsPathGrp
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
     C                   IF        HGMETD <> *Zeros
     C                   MOVEL     HGMETD        ##D(10)
     C                   ENDIF
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
      ** Statement Type
      *
     C                   MOVEL     HGSTTY        ##D(14)
      *
      ** Safekeeping Account
      *
     C                   MOVEL     HGSAFE        ##D(15)
      *
      ** Activity Flag
      *
     C                   MOVEL     HGACTI        ##D(16)
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
     C  N60              MOVEL     'GenLin'      WMDsPathGrp
     C   60              MOVEL     'GenLip'      WMDsPathGrp
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
      *************************************************************************
      /EJECT
      *************************************************************************
      *  SRStsStat - Repetitive Optional Subsequence B Status                 *
      *************************************************************************
     C     SRStsStat     BEGSR
      *
      ********************************************
      ** Access Pending Transations Status Details
      ********************************************
      *
     C     KPenStat      SETLL     SEPSTAL0
     C     KPenStat      READE     SEPSTAL0
     C                   DOW       NOT %EOF(SEPSTAL0)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C  N60              MOVEL     'PenSta'      WMDsPathGrp
     C   60              MOVEL     'PenStp'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ** Repetitive Optional Subsequence B Status
      *
      ** The status has to be reported once.
      *
     C                   EXSR      SRStatus
      *
     C                   EXSR      SRReason
      *
     C                   DOW       NOT %EOF(SEPSTAL0)
      *
      ************************
      ** Access Transaction **
      ************************
      *
     C     KTransac      SETLL     SEPTRAL0
     C     KTransac      READE     SEPTRAL0
     C                   DOW       NOT %EOF(SEPTRAL0)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C  N60              MOVEL     'Trans '      WMDsPathGrp
     C   60              MOVEL     'Tranp '      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ** Repetitive Mandatory Subsequence B2 Transaction
      *
     C                   EXSR      SRTrans
      *
      **********************************
      ** Access Transaction Indicator **
      **********************************
      *
     C     KTrnInd       SETLL     SEPINDL0
     C     KTrnInd       READE     SEPINDL0
     C                   DOW       NOT %EOF(SEPINDL0)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C  N60              MOVEL     'TrnInd'      WMDsPathGrp
     C   60              MOVEL     'TrnInp'      WMDsPathGrp
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
     C     KTrnInd       READE     SEPINDL0
     C                   ENDDO
      *
      ******************************
      ** Access Transaction Party **
      ******************************
      *
     C     KTrnPrt       SETLL     SEPPRTL0
     C     KTrnPrt       READE     SEPPRTL0
     C                   DOW       NOT %EOF(SEPPRTL0)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C  N60              MOVEL     'TrnPrt'      WMDsPathGrp
     C   60              MOVEL     'TrnPrp'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ** Repetitive Optional Subsequence B2b1 Settlement Parties
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
     C     KTrnPrt       READE     SEPPRTL0
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
     C     KTransac      READE     SEPTRAL0
     C                   ENDDO
      *
      ** Read the next transaction with the same status
      *
     C     KPenCurStat   READE     SEPSTAL0
     C                   ENDDO
      *
      ** Decrement Path DS index - Status
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *
     C                   EXSR      POPGRS
      *
      ** Read the next status
      *
     C     KPenCurStat   SETGT     SEPSTAL0
     C     KPenStat      READE     SEPSTAL0
     C                   ENDDO
      *
     C                   ENDSR
      *************************************************************************
      /EJECT
      *************************************************************************
      *  SRStsTran - Repetitive Optional Subsequence C Transaction            *
      *************************************************************************
     C     SRStsTran     BEGSR
      *
      ************************
      ** Access Transaction **
      ************************
      *
     C     KPenStat      SETLL     SEPTRAL0
     C     KPenStat      READE     SEPTRAL0
     C                   DOW       NOT %EOF(SEPTRAL0)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C  N60              MOVEL     'Trans '      WMDsPathGrp
     C   60              MOVEL     'Tranp '      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ** Repetitive Mandatory Subsequence C2 Transaction
      *
     C                   EXSR      SRTrans
      *
      **********************************
      ** Access Transaction Indicator **
      **********************************
      *
     C     KTrnInd       SETLL     SEPINDL0
     C     KTrnInd       READE     SEPINDL0
     C                   DOW       NOT %EOF(SEPINDL0)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C  N60              MOVEL     'TrnInd'      WMDsPathGrp
     C   60              MOVEL     'TrnInp'      WMDsPathGrp
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
     C     KTrnInd       READE     SEPINDL0
     C                   ENDDO
      *
      ******************************
      ** Access Transaction Party **
      ******************************
      *
     C     KTrnPrt       SETLL     SEPPRTL0
     C     KTrnPrt       READE     SEPPRTL0
     C                   DOW       NOT %EOF(SEPPRTL0)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C  N60              MOVEL     'TrnPrt'      WMDsPathGrp
     C   60              MOVEL     'TrnPrp'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ** Repetitive Optional Subsequence C2a Settlement Parties
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
     C     KTrnPrt       READE     SEPPRTL0
     C                   ENDDO
      *
      ********************************************
      ** Access Pending Transations Status Details
      ********************************************
      *
     C     KTrnStat      SETLL     SEPSTAL3
     C     KTrnStat      READE     SEPSTAL3
      *
     C                   DOW       NOT %EOF(SEPSTAL3)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C  N60              MOVEL     'PenSta'      WMDsPathGrp
     C   60              MOVEL     'PenStp'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ** Repetitive Optional Subsequence C3 Status
      *
     C                   EXSR      SRStatus
      *
     C                   Z-ADD     PRTSEQ        Pr_TSEQ           5 0
     C                   MOVEL     PRSTAT        Pr_STAT           4
     C                   MOVEL     PRSTCD        Pr_STCD           4
      *
     C                   DOW       NOT %EOF(SEPSTAL3)  AND
     C                             PRTSEQ = Pr_TSEQ    AND
     C                             PRSTAT = Pr_STAT    AND
     C                             PRSTCD = Pr_STCD
      *
      ** Reason Code exists
      *
     C                   IF        PRREAS <> *Blanks
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C  N60              MOVEL     'PenRea'      WMDsPathGrp
     C   60              MOVEL     'PenRep'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *
     C                   EXSR      PSHGRS
      *
      ** Repetitive Optional Subsequence C3a Reason
      *
     C                   EXSR      SRReason
      *
      ** Decrement Path DS index - Reason
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *
     C                   EXSR      POPGRS
      *
     C                   ENDIF
      *
      ** Read the next Status
      *
     C     KTrnStat      READE     SEPSTAL3
     C                   ENDDO
      *
      ** Decrement Path DS index - Reason
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *
     C                   EXSR      POPGRS
      *
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
      ** Read next transaction
      *
     C     KPenStat      READE     SEPTRAL0
     C                   ENDDO
      *
     C                   ENDSR
      *************************************************************************
      /EJECT
      *************************************************************************
      *  SRStatus   - Status Details                                          *
      *************************************************************************
     C     SRStatus      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRStatus  '  @STK(Q)
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'Status'      WGrpName
     C                   EXSR      SRRtvRDE
      *
      ** Transaction Status
      *
     C                   MOVEL     PRSTAT        ##D(1)
      *
      ** Status Code
      *
     C                   MOVEL     PRSTCD        ##D(2)
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
      ******************************************************************
      /EJECT
      *************************************************************************
      *  SRReason   - Reason Details                                          *
      *************************************************************************
     C     SRReason      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRReason  '  @STK(Q)
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'Reaso1'      WGrpName
     C                   EXSR      SRRtvRDE
      *
      ** Reason
      *
     C                   MOVEL     PRREAS        ##D(1)
      *
      ** Reason Code
      *
     C                   MOVEL     PRRECD        ##D(2)
      *
      ** Accumulate RDEs and associated data and output
      *
     C                   EXSR      SRPackDta
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'Reaso2'      WGrpName
     C                   EXSR      SRRtvRDE
      *
      ** Reason Narrative 1
      *
     C                   MOVEL     PRNAR1        ##D(1)
      *
      ** Reason Narrative 2
      *
     C                   MOVEL     PRNAR2        ##D(2)
      *
      ** Reason Narrative 3
      *
     C                   MOVEL     PRNAR3        ##D(3)
      *
      ** Reason Narrative 4
      *
     C                   MOVEL     PRNAR4        ##D(4)
      *
      ** Reason Narrative 5
      *
     C                   MOVEL     PRNAR5        ##D(5)
      *
      ** Reason Narrative 6
      *
     C                   MOVEL     PRNAR6        ##D(6)
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
      ******************************************************************
      /EJECT
      ******************************************************************
      *  SRTrans    - Transactions Details                             *
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
     C                   MOVEL     PTTYPE        ##D(1)
      *
      ** Pool Reference
      *
     C                   MOVEL     PTRFPO        ##D(2)
      *
      ** Link Previous Reference Type
      *
     C                   MOVEL     PTLKPR        ##D(3)
      *
      ** Previous Reference
      *
     C                   MOVEL     PTRFPR        ##D(4)
      *
      ** Link Related Reference Type
      *
     C                   MOVEL     PTLKRE        ##D(5)
      *
      ** Related Reference
      *
     C                   MOVEL     PTRFRE        ##D(6)
      *
      ** Deal Reference
      *
     C                   MOVEL     PTRFTR        ##D(7)
      *
      ** Common Reference
      *
     C                   MOVEL     PTRFCO        ##D(8)
      *
      ** Account Servicer Reference
      *
     C                   MOVEL     PTRFAS        ##D(9)
      *
      ** Place of Trade Code
      *
     C                   MOVEL     PTPLTC        ##D(10)
      *
      ** Place of Trade Narrative
      *
     C                   MOVEL     PTPLTN        ##D(11)
      *
      ** Place of Safekeeping Code
      *
     C                   MOVEL     PTPLSC        ##D(12)
      *
      ** Place of Safekeeping Narrative
      *
     C                   MOVEL     PTPLSN        ##D(13)
      *
      ** Security shortname
      *
     C                   MOVEL     PTSESN        ##D(14)
      *
      ** Security Report Name
      *
     C                   MOVEL     PTSRPN        ##D(15)
      *
      ** Security Full Name - 1
      *
     C                   MOVEL     PTSFN1        ##D(16)
      *
      ** Security Full Name - 2
      *
     C                   MOVEL     PTSFN2        ##D(17)
      *
      ** Nominal Currency
      *
     C                   MOVEL     PTNMCY        ##D(18)
      *
      ** Nominal decimal places
      *
     C                   MOVEL     PTNMDP        ##D(19)
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
      ** Country of risk
      *
     C                   MOVEL     PTSCOR        ##D(1)
      *
      ** Sedol (Extel) Ref
      *
     C                   MOVEL     PTSREF        ##D(2)
      *
      ** Telekurs (Valoren) Ref
      *
     C                   MOVEL     PTT2RF        ##D(3)
      *
      ** Cusip Number
      *
     C                   MOVEL     PTCSPN        ##D(4)
      *
      ** ISIN Number
      *
     C                   MOVEL     PTISIN        ##D(5)
      *
      ** Posting Quantity Code
      *
     C                   MOVEL     PTPQCD        ##D(6)
      *
      ** Posting Quantity
      *
     C                   MOVEL     PTPQUA        ##D(7)
      *
      ** Posting Quantity Decimal
      *
     C                   MOVEL     ##R(7)        R#DEFN
     C                   MOVE      PTPQDP        ##RDED                         Decimal Position
     C                   MOVEL     R#DEFN        ##R(7)
      *
     C*********          IF        PTPAMT <> *Zeros                                           252259
     C                   IF        PTPACY <> *Blanks                                          252259
      *
      ** Posting Amount Currency
      *
     C                   MOVEL     PTPACY        ##D(8)
      *
      ** Posting Amount
      *
     C                   MOVEL     PTPAMT        ##D(9)
      *
      ** Posting Amount Decimal
      *
     C                   MOVEL     ##R(9)        R#DEFN
     C                   MOVE      PTPADP        ##RDED                         Decimal Position
     C                   MOVEL     R#DEFN        ##R(9)
      *
     C                   ENDIF
      *
     C                   IF        PTOAMT <> *Zeros
      *
      ** Original Amount Currency
      *
     C                   MOVEL     PTOCCY        ##D(10)
      *
      ** Original Amount
      *
     C                   MOVEL     PTOAMT        ##D(11)
      *
     C                   ENDIF
      *
      ** Original Amount Decimal
      *
     C                   MOVEL     ##R(11)       R#DEFN
     C                   MOVE      PTOADP        ##RDED                         Decimal Position
     C                   MOVEL     R#DEFN        ##R(11)
      *
      ** Expected Settlement Date
      *
     C                   IF        PTEXDT <> *Zeros
     C                   MOVEL     PTEXDT        ##D(12)
     C                   ENDIF
      *
      ** Expected Settlement Time
      *
     C                   IF        PTEXTM <> *Zeros
     C                   MOVEL     PTEXTM        ##D(13)
     C                   ENDIF
      *
      ** Expected Settlement Code
      *
     C                   MOVEL     PTEXCD        ##D(14)
      *
      ** Settlement Date
      *
     C                   IF        PTSEDT <> *Zeros
     C                   MOVEL     PTSEDT        ##D(15)
     C                   ENDIF
      *
      ** Settlement Time
      *
     C                   IF        PTSETM <> *Zeros
     C                   MOVEL     PTSETM        ##D(16)
     C                   ENDIF
      *
      ** Settlement Code
      *
     C                   MOVEL     PTSECD        ##D(17)
      *
      ** Accumulate RDEs and associated data and output
      *
     C                   EXSR      SRPackDta
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'Trans3'      WGrpName
     C                   EXSR      SRRtvRDE
      *
      ** Late Delivery Date
      *
     C                   IF        PTADDT <> *Zeros
     C                   MOVEL     PTADDT        ##D(1)
     C                   ENDIF
      *
      ** Late Delivery Time
      *
     C                   IF        PTADTM <> *Zeros
     C                   MOVEL     PTADTM        ##D(2)
     C                   ENDIF
      *
      ** Late Delivery Code
      *
     C                   MOVEL     PTADCD        ##D(3)
      *
      ** Trade Date
      *
     C                   IF        PTTRDT <> *Zeros
     C                   MOVEL     PTTRDT        ##D(4)
     C                   ENDIF
      *
      ** Trade Time
      *
     C                   IF        PTTRTM <> *Zeros
     C                   MOVEL     PTTRTM        ##D(5)
     C                   ENDIF
      *
      ** Trade Code
      *
     C                   MOVEL     PTTRCD        ##D(6)
      *
      ** Transaction Narrative 1
      *
     C                   MOVEL     PTNAR1        ##D(7)
      *
      ** Transaction Narrative 2
      *
     C                   MOVEL     PTNAR2        ##D(8)
      *
      ** Transaction Narrative 3
      *
     C                   MOVEL     PTNAR3        ##D(9)
      *
      ** Transaction Narrative 4
      *
     C                   MOVEL     PTNAR4        ##D(10)
      *
      ** Transaction Narrative 5
      *
     C                   MOVEL     PTNAR5        ##D(11)
      *
      ** Transaction Narrative 6
      *
     C                   MOVEL     PTNAR6        ##D(12)
      *
      ** Transaction Narrative 7
      *
     C                   MOVEL     PTNAR7        ##D(13)
      *
      ** Transaction Narrative 8
      *
     C                   MOVEL     PTNAR8        ##D(14)
      *
      ** Transaction Narrative 9
      *
     C                   MOVEL     PTNAR9        ##D(15)
      *
      ** Transaction Narrative 10
      *
     C                   MOVEL     PTNA10        ##D(16)
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
     C                   MOVEL     PIQUAL        ##D(1)
      *
      ** Indicator
      *
     C                   MOVEL     PIINDC        ##D(2)
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
     C                   MOVEL     PPQUAL        ##D(1)
      *
      ** Safekeeping Account Code
      *
     C                   MOVEL     PPSAFC        ##D(2)
      *
      ** Safekeeping Account
      *
     C                   MOVEL     PPSAFA        ##D(3)
      *
      ** Accumulate RDEs and associated data and output
      *
     C                   EXSR      SRPackDta
      *
      ** Set up fields to be passed to SRSWCust
      *
     C                   MOVEL     PPPRTC        WSWIFTCust
     C                   MOVEL     PPPRT1        WAddress1
     C                   MOVEL     PPPRT2        WAddress2
     C                   MOVEL     PPPRT3        WAddress3
     C                   MOVEL     PPPRT4        WAddress4
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
     C  N60              MOVEL     'SWBrch'      WMDsPathGrp
     C   60              MOVEL     'SWBrcp'      WMDsPathGrp
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
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      WBrchRef      PBranch           3
     C     SDBRCH        PARM      *BLANKS       DSFDY
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
     C  N60              MOVEL     'SWCust'      WMDsPathGrp
     C   60              MOVEL     'SWCusp'      WMDsPathGrp
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
     C                             and %SUBST(WSWIFTCust:1:6) <> '000000'
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
     C                   IF        %SUBST(WSWIFTCust:1:6) <> '000000'
     C                   MOVEL     WSWIFTCust    ##D(1)
     C                   ENDIF
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
     C                   MOVE      *OFF          *IN60
      *
      ** If the newtork is 'Paper',
      ** create item reference records in CGUDCRPD
      *
     C                   IF        SPNWRK = 'PAPER'
      *
     C                   MOVE      *ON           *IN60
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
      ** Key list to access Pending Transaction Status Details
      *
     C     KPenStat      KLIST
     C                   KFLD                    SPEXTR
      *
     C     KPenCurStat   KLIST
     C                   KFLD                    SPEXTR
     C                   KFLD                    PRSTAT
     C                   KFLD                    PRSTCD
     C                   KFLD                    PRREAS
     C                   KFLD                    PRRECD
     C                   KFLD                    PRNAR1
     C                   KFLD                    PRNAR2
     C                   KFLD                    PRNAR3
     C                   KFLD                    PRNAR4
     C                   KFLD                    PRNAR5
     C                   KFLD                    PRNAR6
      *
      ** Key list to access Transaction details
      *
     C     KTransac      KLIST
     C                   KFLD                    SPEXTR
     C                   KFLD                    PRTSEQ
      *
      ** Key list to access Indicator details
      *
     C     KTrnInd       KLIST
     C                   KFLD                    SPEXTR
     C                   KFLD                    PTTSEQ
      *
      ** Key list to access Party details
      *
     C     KTrnPrt       KLIST
     C                   KFLD                    SPEXTR
     C                   KFLD                    PTTSEQ
      *
      ** Key list to access Status details
      *
     C     KTrnStat      KLIST
     C                   KFLD                    SPEXTR
     C                   KFLD                    PTTSEQ
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
      ** This processing is used to format the SE Statements in XML format for
      ** SWIFT and Correspondance Manager.
      ** In all cases, the processing and data will be available, and not switchable by
      ** CCG015
      *********
     C*********          CALL      'AOSARDR0'
     C*********          PARM      *BLANKS       PRtnCode
     C*********          PARM      '*VERIFY'     POption
     C*********          PARM      'CCG015'      PSard
     C*****SCSARD        PARM      SCSARD        DSFDY

     C*****PRtnCode      IFEQ      *BLANKS
     C                   MOVE      'Y'           CCG015            1
     C*********          ELSE
     C*********          MOVE      'N'           CCG015

     C*****PRtnCode      IFNE      '*NRF  '
     C*********          EVAL      W0File = 'SCSARDPD'
     C*********          EVAL      W0Key = '*CALL'
     C*********          EVAL      W0ERNB = 8
     C*********          EVAL      W0MsgD = 'MEM5003'
     C*********          EVAL      W0MsgF = 'MIDAS  '
     C*********          EXSR      SRERR
     C*********          ENDIF
      *
     C*********          ENDIF
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
GenInf0014 STAT TYPE                     General Statement Type
GenInf0015 SAFE ACCNT                    General Safekeeping Account
GenInf0016 FLAG ACTI                     General Activity Flag
GenInf0017 FLAG CONS                     General Sub-safekeeping Statement
GenLin0001 RLT MSG TY                    Link Related Message Type
GenLin0002 RLT MSG                       Link Related Message
GenLin0003 PREV MSG                      Link Previous Message Cancelled
SubSaf0001 SSAF CODE                     Sub-Safekeeping Account Type Code
SubSaf0002 SSAF ACCN                     Sub-Safekeeping Account
SubSaf0003 SSAF ACTI                     Sub-Safekeeping Activity Flag
SubSaf0004 SSAF PLCD                     Sub-Safekeeping Place Code
SubSaf0005 SSAF PLACE                    Sub-Safekeeping Place
Status0001 STAT TRN                      Transaction Status
Status0002 STAT CODE                     Status Code
Reaso10001 REASON                        Reason
Reaso10002 REASONCODE                    Reason Code
Reaso20001 REASONNAR1                    Reason Narrative 1
Reaso20002 REASONNAR2                    Reason Narrative 2
Reaso20003 REASONNAR3                    Reason Narrative 3
Reaso20004 REASONNAR4                    Reason Narrative 4
Reaso20005 REASONNAR5                    Reason Narrative 5
Reaso20006 REASONNAR6                    Reason Narrative 6
Trans10001 TR TYPE                       Transaction Type
Trans10002 TR POOL                       Transaction Pool Reference
Trans10003 TR LK PR                      Transaction Link Previous Reference Type
Trans10004 TR PREV                       Transaction Previous Reference
Trans10005 TR LK RE                      Transaction Link Related Reference Type
Trans10006 TR RELA                       Transaction Related Reference
Trans10007 TR DEAL                       Transaction Deal Reference
Trans10008 TR COMMON                     Transaction Common Reference
Trans10009 TR SERVIC                     Transaction Account Servicer Reference
Trans10010 TR PLCODE                     Place of Trade Code
Trans10011 TR PLCNAR                     Place of Trade Narrative
Trans10012 TR SAFECD                     Place of Safekeeping Code
Trans10013 TR SAFENA                     Place of Safekeeping Narrative
Trans10014 TR SECSHN                     Security shortname
Trans10015 TR SECRPT                     Security Report Name
Trans10016 TR SECFN1                     Security Full Name - 1
Trans10017 TR SECFN2                     Security Full Name - 2
Trans10018 TR NOMCCY                     Nominal Currency
Trans10019 TR NOMCDP                     Nominal decimal places
Trans20001 TR CTRYRK                     Country of risk
Trans20002 TR SEDOL                      Sedol (Extel) Ref
Trans20003 TR TELEKU                     Telekurs (Valoren) Ref
Trans20004 TR CUSIP                      Cusip Number
Trans20005 TR ISIN                       ISIN Number
Trans20006 TR PSTQCD                     Posting Quantity Code
Trans20007 TR PSTQTY  Amount 0           Posting Quantity
Trans20008 TR PSTACCY                    Posting Amount Currency
Trans20009 TR PSTAMT  Amount 0           Posting Amount
Trans20010 TR OAMTCCY                    Original Amount Currency
Trans20011 TR OAMOUNT Amount 0           Original Amount
Trans20012 TR EXPSTDT Date               Expected Settlement Date
Trans20013 TR EXPSTTI                    Expected Settlement Time
Trans20014 TR EXPSTCD                    Expected Settlement Code
Trans20015 TR SETDATE Date               Settlement Date
Trans20016 TR SETTIME                    Settlement Time
Trans20017 TR SETCODE                    Settlement Code
Trans30001 TR LTDLDTE Date               Late Delivery Date
Trans30002 TR LTDLTIM                    Late Delivery Time
Trans30003 TR LTDLCOD                    Late Delivery Code
Trans30004 TR TRDATE  Date               Trade Date
Trans30005 TR TRTIME                     Trade Time
Trans30006 TR TRCODE                     Trade Code
Trans30007 TR NARR 1                     Transaction Narrative 1
Trans30008 TR NARR 2                     Transaction Narrative 2
Trans30009 TR NARR 3                     Transaction Narrative 3
Trans30010 TR NARR 4                     Transaction Narrative 4
Trans30011 TR NARR 5                     Transaction Narrative 5
Trans30012 TR NARR 6                     Transaction Narrative 6
Trans30013 TR NARR 7                     Transaction Narrative 7
Trans30014 TR NARR 8                     Transaction Narrative 8
Trans30015 TR NARR 9                     Transaction Narrative 9
Trans30016 TR NARR 10                    Transaction Narrative 10
TrnInd0001 TR IND QUA                    Transaction Indicator Qualifier
TrnInd0002 TR INDICAT                    Transaction Indicator
TrnPrt0001 TR PRT QUA                    Transaction Party Qualifier
TrnPrt0002 TR SAFEACD                    Transaction Safekeeping Account Code
TrnPrt0003 TR SAFEACC                    Transaction Safekeeping Account
