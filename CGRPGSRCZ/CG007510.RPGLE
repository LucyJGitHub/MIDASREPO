      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Overdraft Reminder Letter - Extract')         *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG007510 - RE Overdraft Reminder Letter - Extract            *
      *                                                               *
      *  Function:  This program produces the customer correspondence *
      *             onto the UDC extract files required for           *
      *             production of Retail Advices through              *
      *             Correspondence Manager.                           *
      *                                                               *
      *  Called By: CG007510 - RE Overdraft Reminder Letter           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. MD025760           Date 20Mar14               *
      *                 CER055  *CREATE    Date 06Dec10               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  MD025760 - Reminder Letter generated lacking fields          *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCSEGL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Customer Segmentation
      *
     FCGCORRL4  IF   E           K DISK    INFSR(*PSSR)
      ** Midas CG Correspondent details by customer
      *
     FSDCMRKL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Customer Marketing Groups
      *
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
 
     D WCPrtItmTyp     C                   CONST('ODREMLET')
      ** Print Item Type
 
     D WCPrtItmSubTyp  C                   CONST('NOTICE')
      ** Print Item Sub-Type
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Data structure for access objects, first DS
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Data structure for access objects, second DS
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** Data structure for access objects
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Data structure for SD Branch details file
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Data structure Currency details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D QQDFAC1       E                     EXTFLD(QQDFAC)
      ** Data structure for SD Customer details file
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Data structure for Switchable Feature File
 
     D PEDsCGUDCRPD  E DS                  EXTNAME(CGUDCRPD)
      ** Data structure for UDC data reference file
 
     D PDsAccntBx0   E DS                  EXTNAME(ACCNTBY0)
      ** Data structure for Account Details Extension
 
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D LCD1          E                     EXTFLD(LCD)
      ** Data structure for Account Details Extension
 
     D SDACOF        E DS                  EXTNAME(SDACOFPD)                                MD025760
      ** Data structure for SD Account Officer Details file                                 MD025760
                                                                                            MD025760
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
     D WTbGrp          S             10    DIM(42) CTDATA PERRCD(1)
     D WTbRDE          S             22    DIM(42) ALT(WTbGrp)
 
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
     D ExNumDay        S              5A
 
      ** Parameter fields
     D PAction8        S              8A
     D PCustNumChr6    S              6A
     D PItmRef         S              8A
     D PMode           S             10A
     D PRtnCode        S              7A
     D W0CMT           S              3A
     D PChgType        S              1A
     D W0SPAT          S             70A
 
      ** Access Object Parameter fields
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D PCustNo         S             10A
     D PCustNo6A       S              6A
     D PChr003         S              3A
     D PErrInf         S              7A
     D CSD090          S              1A
     D CFT004          S              1A
     D CCG015          S              1A
     D PRetail         S             10A
     D PCNum           S              6A
     D PCcy            S              3A
     D PACod           S             10A
     D PASeq           S              2A
     D PBrch           S              3A
     D PCurr           S              3A
     D PAcof           S              2A                                                    MD025760
 
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
      ** Execute main subroutine
      *
     C                   EXSR      SrMain
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *Blanks       @STK(Q)
     C                   SUB       1             Q
      *
      ** Termination
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrMain - Performs validation and invokes top group set.      *
      *                                                               *
      *****************************************************************
     C     SrMain        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SrMain    '  @STK(Q)
      *
      ** Generate reference number by writing to PF/CGUDCRPD.
      ** If no confirmation to produce, then bypass.
      *
     C                   EXSR      SrGenRef
      *
     C                   IF        WProduce = 'Y'
     C                   EXSR      SrRMLETT
     C                   ENDIF
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *Blanks       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRMLETT - Top group set.                                    *
      *                                                               *
      *****************************************************************
     C     SrRMLETT      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SrRMLETT  '  @STK(Q)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   Z-ADD     1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   EVAL      WMDsPathGrp = 'RMLETT'
      *
     C                   EXSR      SrPATH
      *
     C                   EXSR      PSHGRS
      *
      ********************************************
      ** Branch where retail account is handled **
      ********************************************
      *
     C                   EXSR      SrBRANCH
      *
      ********************************************
      ** Branch Internal Customer Details       **
      ********************************************
      *
     C                   EXSR      SrBICD
      *                                                                                     MD025760
      ********************************************                                          MD025760
      ** Account Officer Details                **                                          MD025760
      ********************************************                                          MD025760
      *                                                                                     MD025760
     C                   EXSR      SrACOF                                                   MD025760
      *
      ********************************************
      ** Customer details group                 **
      ********************************************
      *
     C                   EXSR      SrCUSTE
      *
      ********************************************
      ** Customer Segmentation Details          **
      ********************************************
      *
     C                   IF        CSD090 = 'Y'
     C                   EXSR      SrCUSTSG
     C                   ENDIF
      *
      ********************************************
      ** Overdraft Account Details              **
      ********************************************
      *
     C                   EXSR      SrODACCT
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
     C                   MOVEA     *Blanks       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrBRANCH   - Branch Details.                                 *
      *                                                               *
      *****************************************************************
     C     SrBRANCH      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SrBRANCH  '  @STK(Q)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'BRANCH'      WMDsPathGrp
      *
     C                   EXSR      SrPATH
      *
     C                   EXSR      PSHGRS
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'BRANCH'      WGrpNme
     C                   EXSR      SrRtvRDE
      *
      ** Get Branch Details
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      ATBRCA        PBrch
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
      ** Handle Database Errors if any occur.
      *
     C                   IF        PRtCd <> *Blanks
      *
     C                   MOVEL     'SDBRCHPD'    W0File
     C                   MOVEL     BRCA          W0Key
     C                   Z-ADD     01            W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS  '     W0MsgF
     C                   EXSR      SRERR
      *
     C                   ENDIF
      *
      ** Branch Code
      *
     C                   MOVEL     A8BRCD        ##D(1)
      *
      ** Branch Name
      *
     C                   MOVEL     A8BRNM        ##D(2)
      *
      ** Accumulate RDEs and associated data and output to CGUDTAPD
      *
     C                   EXSR      SrPackDta
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
     C                   MOVEA     *Blanks       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrBICD - Branch Internal Customer Details                    *
      *                                                               *
      *****************************************************************
     C     SrBICD        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SrBICD    '  @STK(Q)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'CGBRCH'      WMDsPathGrp
      *
     C                   EXSR      SrPATH
      *
     C                   EXSR      PSHGRS
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'CGBRCH'      WGrpNme
     C                   EXSR      SrRtvRDE
      *
     C                   MOVEL     A8BICN        PCustNo
      *
      ** Get Branch Internal Customer Details
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCustNo
     C                   PARM      *Blanks       PErrInf
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        PRtCd <> *Blanks
      *
      ** Handle Database Errors if any occur.
      *
     C                   MOVEL     'SDCUSTPD'    W0File
     C                   MOVEL     PCustNo       W0Key
     C                   Z-ADD     01            W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS  '     W0MsgF
     C                   EXSR      SRERR
      *
     C                   ENDIF
      *
     C     A8BICN        CHAIN     CGCORRL4
     C                   IF        NOT %FOUND(CGCORRL4)
     C                   EVAL      W0File = 'CGCORRL4'
     C                   EVAL      W0Key = PRtnCode
     C                   EVAL      W0ErNb = 6
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS'
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** BOJ Financil Institution Code
      *
     C                   MOVEL     BBBFIC        ##D(1)
      *
      ** Chaps Sort Code
      *
     C                   MOVEL     BBCHSC        ##D(2)
      *
      ** Chips ABA
      *
     C                   IF        BBCABA <> 0
     C                   MOVEL     BBCABA        ##D(3)
     C                   ENDIF
      *
      ** Chips ID
      *
     C                   MOVEL     BBCHID        ##D(4)
      *
      ** Fedwire Code
      *
     C                   MOVEL     BBFWCD        ##D(5)
      *
      ** Branch Internal Customer
      *
     C                   MOVEL     A8BICN        ##D(6)
      *
      ** Bankleitzahl Code (alpha)
      *
     C                   MOVEL     BBBLCD        ##D(7)
      *
      ** Customer Swift ID
      *
     C                   MOVEL     BBCSID        ##D(8)
      *
      ** Customer Telephone Number
      *
     C                   MOVEL     BBCTNB        ##D(9)
      *
      ** Customer Fax Number
      *
     C                   MOVEL     CDFAX         ##D(10)
      *
      ** Customer STTX Address
      *
     C                   MOVEL     BBSTAD        ##D(11)
      *
      ** Accumulate RDEs and associated data and output to CGUDTAPD
      *
     C                   EXSR      SrPackDta
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
     C                   MOVEA     *Blanks       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************                     MD025760
      /EJECT                                                                                MD025760
      *****************************************************************                     MD025760
      *                                                               *                     MD025760
      *  SrACOF     - Account Officer Details                         *                     MD025760
      *                                                               *                     MD025760
      *****************************************************************                     MD025760
     C     SrACOF        BEGSR                                                              MD025760
      *                                                                                     MD025760
      ** Set up subroutine stack name                                                       MD025760
      *                                                                                     MD025760
     C                   ADD       1             Q                                          MD025760
     C                   MOVEL     'SrACOF    '  @STK(Q)                                    MD025760
      *                                                                                     MD025760
      ** Set up path multi-occurence data structure & path string                           MD025760
      *                                                                                     MD025760
     C                   ADD       1             WPx                                        MD025760
     C     WPx           OCCUR     WMDsPath                                                 MD025760
     C                   MOVEL     'ACOF  '      WMDsPathGrp                                MD025760
      *                                                                                     MD025760
     C                   EXSR      SrPATH                                                   MD025760
      *                                                                                     MD025760
     C                   EXSR      PSHGRS                                                   MD025760
      *                                                                                     MD025760
      ** Retrieve RDE info                                                                  MD025760
      *                                                                                     MD025760
     C                   MOVEL     'ACOF  '      WGrpNme                                    MD025760
     C                   EXSR      SrRtvRDE                                                 MD025760
      *                                                                                     MD025760
      ** Get Account Officer Details                                                        MD025760
      *                                                                                     MD025760
     C                   CALL      'AOACOFR0'                                               MD025760
     C                   PARM      '*MSG   '     PRtCd                                      MD025760
     C                   PARM      '*KEY   '     POptn                                      MD025760
     C                   PARM      BBACOC        PAcof                                      MD025760
     C     SDACOF        PARM      SDACOF        DSSDY                                      MD025760
      *                                                                                     MD025760
      ** Handle Database Errors if any occur.                                               MD025760
      *                                                                                     MD025760
     C                   IF        PRtCd <> *Blanks                                         MD025760
      *                                                                                     MD025760
     C                   MOVEL     'SDACOFPD'    W0File                                     MD025760
     C                   MOVEL     BBACOC        W0Key                                      MD025760
     C                   Z-ADD     03            W0ERNB                                     MD025760
     C                   MOVEL     'MEM5003'     W0MsgD                                     MD025760
     C                   MOVEL     'MIDAS  '     W0MsgF                                     MD025760
     C                   EXSR      SRERR                                                    MD025760
      *                                                                                     MD025760
     C                   ENDIF                                                              MD025760
      *                                                                                     MD025760
      ** Account Officer Code                                                               MD025760
      *                                                                                     MD025760
     C                   MOVEL     AZACOC        ##D(1)                                     MD025760
      *                                                                                     MD025760
      ** Account Officer Dept                                                               MD025760
      *                                                                                     MD025760
     C                   MOVEL     AZDPCD        ##D(2)                                     MD025760
      *                                                                                     MD025760
      ** Account Officer Name                                                               MD025760
      *                                                                                     MD025760
     C                   MOVEL     AZACON        ##D(3)                                     MD025760
      *                                                                                     MD025760
      ** Account Officer Telephone Num                                                      MD025760
      *                                                                                     MD025760
     C                   MOVEL     AZAPHN        ##D(4)                                     MD025760
      *                                                                                     MD025760
      ** Account Officer Telephone Ext                                                      MD025760
      *                                                                                     MD025760
     C                   MOVEL     AZAEXT        ##D(5)                                     MD025760
      *                                                                                     MD025760
      ** Accumulate RDEs and associated data and output to CGUDTAPD                         MD025760
      *                                                                                     MD025760
     C                   EXSR      SrPackDta                                                MD025760
      *                                                                                     MD025760
      ** Decrement Path DS index                                                            MD025760
      *                                                                                     MD025760
     C     WPx           OCCUR     WMDsPath                                                 MD025760
     C                   CLEAR                   WMDsPathGrp                                MD025760
     C                   SUB       1             WPx                                        MD025760
      *                                                                                     MD025760
     C                   EXSR      POPGRS                                                   MD025760
      *                                                                                     MD025760
      ** Unwind subroutine stack name                                                       MD025760
      *                                                                                     MD025760
     C                   MOVEA     *Blanks       @STK(Q)                                    MD025760
     C                   SUB       1             Q                                          MD025760
      *                                                                                     MD025760
     C                   ENDSR                                                              MD025760
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCUSTE  - Extract Customer Details.                         *
      *                                                               *
      *****************************************************************
     C     SrCUSTE       BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SrCUSTE   '  @STK(Q)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'CUSTE '      WMDsPathGrp
      *
     C                   EXSR      SrPATH
      *
     C                   EXSR      PSHGRS
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'CUSTE '      WGrpNme
     C                   EXSR      SrRtvRDE
      *
      ** Get the Customer Detail.
      *
     C                   MOVEL     ATCNUM        PCustNo
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCustNo
     C                   PARM      *Blanks       PErrInf
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        PRtCd <> *Blanks
      *
      ** Handle Database Errors if any occur.
      *
     C                   MOVEL     'SDCUSTPD'    W0File
     C                   MOVEL     PCustNo       W0Key
     C                   Z-ADD     01            W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS  '     W0MsgF
     C                   EXSR      SRERR
      *
     C                   ENDIF
      *
      ** Customer number
      *
     C                   MOVEL     BBCUST        ##D(1)
      *
      ** Customer name
      *
     C                   MOVEL     BBCRNM        ##D(2)
      *
      ** Customer town
      *
     C                   MOVEL     BBCRTN        ##D(3)
      *
      ** Customer Name and Address line 1
      *
     C                   MOVEL     BBCNA1        ##D(4)
      *
      ** Customer Name and Address line 2
      *
     C                   MOVEL     BBCNA2        ##D(5)
      *
      ** Customer Name and Address line 3
      *
     C                   MOVEL     BBCNA3        ##D(6)
      *
      ** Customer Name and Address line 4
      *
     C                   MOVEL     BBCNA4        ##D(7)
      *
      ** Accumulate RDEs and associated data and output to CGUDTAPD
      *
     C                   EXSR      SrPackDta
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
     C                   MOVEA     *Blanks       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCUSTSG   - Customer Segmentation Details                   *
      *                                                               *
      *****************************************************************
     C     SrCUSTSG      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SrCUSTSG  '  @STK(Q)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'CUSTSG'      WMDsPathGrp
      *
     C                   EXSR      SrPATH
      *
     C                   EXSR      PSHGRS
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'CUSTSG'      WGrpNme
     C                   EXSR      SrRtvRDE
      *
      ** Get Additional Customer Details For Retail Account Owner
      *
     C                   MOVEL     ATCNUM        PCustNo6A
     C     PCustNo6A     CHAIN     SDCMRKL0
     C                   IF        %FOUND()
      *
      ** Get Customer Segmentation Details
      *
     C     D7CSDE        CHAIN     SDCSEGL0
     C                   IF        %FOUND(SDCSEGL0)
      *
      ** Customer Segmentation Code
      *
     C                   MOVEL     CSCODE        ##D(1)
      *
      ** Customer Segmentation Name
      *
     C                   MOVEL     CSNAME        ##D(2)
      *
      ** Customer Segmentation Group
      *
     C                   MOVEL     CSGRP         ##D(3)
     C                   ENDIF
     C                   ENDIF
      *
      ** Accumulate RDEs and associated data and output to CGUDTAPD
      *
     C                   EXSR      SrPackDta
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
     C                   MOVEA     *Blanks       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrODACCT   - Overdraft Account Details.                      *
      *                                                               *
      *****************************************************************
     C     SrODACCT      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SrODACCT  '  @STK(Q)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'ODACCT'      WMDsPathGrp
      *
     C                   EXSR      SrPATH
      *
     C                   EXSR      PSHGRS
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'ODACCT'      WGrpNme
     C                   EXSR      SrRtvRDE
      *
      ** Get Account Number
      *
     C                   MOVE      ATCNUM        PCNum
     C                   MOVE      ATCCY         PCcy
     C                   MOVE      ATACOD        PACod
     C                   MOVE      ATACSQ        PASeq
     C                   MOVE      ATBRCA        PBrch
      *
     C                   CALL      'AOACCTR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *Blanks       PRetail
     C                   PARM                    PCNum
     C                   PARM                    PCcy
     C                   PARM                    PACod
     C                   PARM                    PASeq
     C                   PARM                    PBrch
     C     ACCNT         PARM      ACCNT         DSSDY
      *
     C                   IF        PRtCd = *Blanks
      *
     C                   IF        CFT004 = 'Y' and
     C                             IBAN <> *Blanks
     C                   EVAL      ##D(1) = IBAN
     C                   ELSE
     C                   IF        ATYP = 'R'
      *
      ** Account Number
      *
     C                   MOVEL     ACNO          ##D(1)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        PRtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'ACCNTAB'
     C                   EVAL      DBKey = PCNum + PCcy + PACod +
     C                                     PASeq + PBrch
     C                   EVAL      DBase = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Currency
      *
     C                   MOVEL     CCY           ##D(2)
      *
      ** Retrieve number of decimal places
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      CCY           PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        PrtCd <> *BLANKS
      *
     C                   EVAL      W0File = 'SDCURRPD'
     C                   EVAL      W0Key = CCY
     C                   Z-ADD     04            W0ERNB
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS     '
     C                   EXSR      SRERR
      *
     C                   ENDIF
      *
     C                   MOVEL     A6NBDP        ##DCPA
      *
      ** Cleared Balance
      *
     C                   MOVEL     CLBL          ##D(3)
     C                   MOVE      A6NBDP        ##D(3)
      *
      ** Ledger Balance
      *
     C                   MOVEL     LDBL          ##D(4)
     C                   MOVE      A6NBDP        ##D(4)
      *
      ** Overdraft Limit Amount
      *
     C                   MOVEL     ODLN          ##D(5)
     C                   MOVE      A6NBDP        ##D(5)
      *
      ** Overdraft Limit Expiry Date
      *
     C                   MOVEL     ODED          ##D(6)
      *
      ** Debit Interest Rate
      *
     C                   MOVEL     DRIS          ##D(7)
      *
      ** Overdraft Interest Rate
      *
     C                   MOVEL     ATAODR        ##D(8)
      *
      ** Date of overdraft balance excess
      *
     C                   MOVEL     ATDOBE        ##D(9)
      *
      ** Number of days in excess
      *
     C                   EVAL      ExNumDay = %Char(ATNDYE)
     C                   EVAL      ##D(10) = %Trim(ExNumDay)
      *
      ** Accumulate RDEs and associated data and output to CGUDTAPD
      *
     C                   EXSR      SrPackDta
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
     C                   MOVEA     *Blanks       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGenRef - Generate reference number and write to CGUDCRPD.  *
      *                                                               *
      *****************************************************************
     C     SrGenRef      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SrGenRef  '  @STK(Q)
      *
      ** Reset the flag that indicates wether a correspondence is to be
      ** produced or not.
      *
     C                   EVAL      WProduce = 'N'
      *
      ** Set up fields of parameter PEDsCGUDCRPD to be passed to CG9010
      *
     C                   CLEAR                   PEDsCGUDCRPD
      *
      ** Booking/Main branch (mandatory)
      *
     C                   EVAL      DRBRCA = ATBRCA
      *
      ** Module ID (madatory)
      *
     C                   EVAL      DRMODI = 'RE'
      *
      ** MIDAS Transaction number
      *
     C                   EVAL      DRMTRN = *Blanks
      *
      ** Print Item Type
      *
     C                   EVAL      DRPTYP = WCPrtItmTyp
      *
      ** Print Item Subtype
      *
     C                   EVAL      DRPSTP = WCPrtItmSubTyp
      *
      ** Auto Transmission indicator
      *
     C                   EVAL      DRATRM = 'N'
      *
      ** Customer
      *
     C                   MOVE      *Blanks       PCustNumChr6
     C                   MOVE      ATCNUM        PCustNumChr6
      *
      ** Output to CGUDCRPD
      *
     C                   CALL      'CG9010'
     C                   PARM      *Blanks       PRtnCode
     C                   PARM      '*GEN'        PMode
     C                   PARM                    W0CMT
     C                   PARM                    PCustNumChr6
     C                   PARM                    PEDsCGUDCRPD
     C                   PARM      *Blanks       PItmRef
      *
     C                   SELECT
      *
      ** No error, generate correspondence
      *
     C                   WHEN      PRtnCode = *Blanks
     C                   MOVEL     'Y'           WProduce
     C                   MOVEL     PItmRef       ##ITEM
     C     DRPTYP        CAT       ':':0         COLON            11
     C     COLON         CAT       DRPSTP:0      ##REFR
     C                   EXSR      WRAPRF
      *
      ** No error, suppress output
      *
     C                   WHEN      PRtnCode = 'CGD1270'
      *
      ** Error.
      *
     C                   OTHER
     C                   EVAL      W0File = 'CG9010'
     C                   EVAL      W0Key = PRtnCode
     C                   EVAL      W0ErNb = 4
     C                   EVAL      W0MsgD = 'CGD1286'
     C                   EVAL      W0MsgF = 'CGUSRMSG'
     C                   EXSR      SRERR
      *
     C                   ENDSL
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *Blanks       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPATH - Set up path string.                                 *
      *                                                               *
      *****************************************************************
     C     SrPATH        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SrPATH    '  @STK(Q)
      *
      ** Reset output path string
      *
     C                   MOVEL     *Blanks       WPathStr
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
     C                   MOVEA     *Blanks       @STK(Q)
     C                   SUB       1             Q
      *
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
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SrRtvRDE  '  @STK(Q)
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
     C                   MOVEA     *Blanks       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFmtDta - Reformat data before packing it.                   *
      *                                                               *
      *****************************************************************
     C     SrFmtDta      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SrFmtDta  '  @STK(Q)
      *
      ** Loop through RDE's and data
      *
     C                   Z-ADD     0             Wx1
      *
     C     Wx1           DOUEQ     20
      *
      ** Move RDE's and its data to their templates
      *
     C                   ADD       1             Wx1
     C                   MOVEL     ##R(Wx1)      R#DEFN
     C                   MOVEL     ##D(Wx1)      R#DATA
      *
      ** Reformat only if data is present and RDE is edited
      *
     C                   IF        R#DATA <> *Blanks And
     C                             ##RDEC <> *Blanks
      *
      ** Right-align amount
      *
     C                   MOVEA     ##NUMA        WAr29
     C                   Z-ADD     1             Wx2
     C     *Blanks       LOOKUP    WAr29(Wx2)                             61
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
      *
     C                   IF        ##SIGN = '-'
     C                   Z-SUB     WNum20        ##NUMB
     C                   ELSE
     C                   Z-ADD     WNum20        ##NUMB
     C                   ENDIF
      *
      ** Edit type
      *
     C                   IF        ##EDTT = *Blanks
     C                   EVAL      ##EDTT = ##RDET
     C                   ENDIF
      *
      ** Default decimal places
      *
     C                   IF        ##DCPA = *Blanks
     C                   EVAL      ##DCPA = ##RDED
     C                   ENDIF
      *
      ** New RDE data
      *
     C                   MOVEL     R#DATA        ##D(Wx1)
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *Blanks       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPackDta - Pack/Unpack RDEs and their corresponding data.   *
      *                                                               *
      *****************************************************************
     C     SrPackDta     BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SrPackDta '  @STK(Q)
      *
      ** Reformat RDE data
      *
     C                   EXSR      SrFmtDta
      *
     C                   MOVEL     '*NEWARR '    PAction8
     C                   MOVEL     WPathStr      W0SPAT
      *
      ** Pack RDEs and associated data into data strings
      *
     C                   CALL      'CG3999'
     C                   PARM      *Blanks       PRtnCode
     C                   PARM                    PAction8
     C                   PARM                    ##R
     C                   PARM                    ##D
     C                   PARM                    ##S
     C                   PARM                    W0SPAT
     C                   PARM                    ##RN
     C                   PARM                    ##DN
     C                   PARM                    ##FM
      *
     C                   IF        PRtnCode <> *Blanks
     C                   EVAL      W0File = 'CG3999'
     C                   EVAL      W0Key = PRtnCode
     C                   EVAL      W0ErNb = 3
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS  '
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   EXSR      WRTRDE
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *Blanks       @STK(Q)
     C                   SUB       1             Q
      *
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
      *
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN
     C                   PARM                    W0CMT
     C                   PARM                    PDsAccntBx0
      *
      ** Check if CSD090 - Customer Segmentation is on.
      *
     C                   EVAL      CSD090 = 'N'
     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       PRtnCode
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSD090'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRtnCode <> *Blanks  and
     C                             PRtnCode <> '*NRF'
     C                   EVAL      W0File = 'AOSARDR0'
     C                   EVAL      W0Key = POptn
     C                   EVAL      W0ErNb = 1
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS'
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   IF        PRtnCode = *Blanks
     C                   EVAL      CSD090 = 'Y'
     C                   ENDIF
      *
      ** Check if CFT004 - IBAN Numbers is on.
      *
     C                   EVAL      CFT004 = 'N'
     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       PRtnCode
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CFT004'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRtnCode <> *Blanks  and
     C                             PRtnCode <> '*NRF'
     C                   EVAL      W0File = 'AOSARDR0'
     C                   EVAL      W0Key = POptn
     C                   EVAL      W0ErNb = 2
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS'
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   IF        PRtnCode = *Blanks
     C                   EVAL      CFT004 = 'Y'
     C                   ENDIF
      *
      ** Check if CCG015 - Correspondence Manager.
      *
     C                   EVAL      CCG015 = 'N'
     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       PRtnCode
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CCG015'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRtnCode <> *Blanks  and
     C                             PRtnCode <> '*NRF'
     C                   EVAL      W0File = 'AOSARDR0'
     C                   EVAL      W0Key = POptn
     C                   EVAL      W0ErNb = 3
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS'
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   IF        PRtnCode = *Blanks
     C                   EVAL      CCG015 = 'Y'
     C                   ENDIF
      *
     C                   Z-ADD     0             Q
      *
      ** Initialise XML increment
      *
     C                   EXSR      INIXML
      *
      ** Index of WMDsPath
      *
     C                   Z-ADD     0             WPx
     C                   CLEAR                   WMDsPath
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
BRANCH0001 BRANCH                        Branch Code
BRANCH0002 BRANCH NAM                    Branch Name
CGBRCH0001 BBOJ                          BOJ Financial Inst. Code
CGBRCH0002 BCHAPS_SRT                    Chaps Sort Code
CGBRCH0003 BCHIPS_ABA                    Chips ABA
CGBRCH0004 BCHIPS_ID                     Chips ID
CGBRCH0005 BFEDWIRE                      Fedwire Code
CGBRCH0006 BICNBR                        Branch Internal Customer
CGBRCH0007 ZZBLCD                        Bankleitzahl Code (alpha)
CGBRCH0008 ZZCSID                        Customer Swift ID
CGBRCH0009 ZZCTNB                        Customer Telephone Number
CGBRCH0010 ZZFAX                         Customer Fax Number
CGBRCH0011 ZZSTAD                        Customer STTX Address
CUSTE 0001 CUSTOMER                      Customer
CUSTE 0002 CUST_NAME                     Customer Name
CUSTE 0003 CUST_ADR1                     Customer Address 1
CUSTE 0004 CUST_ADR2                     Customer Address 2
CUSTE 0005 CUST_ADR3                     Customer Address 3
CUSTE 0006 CUST_ADR4                     Customer Address 4
CUSTE 0007 CUST_TOWN                     Customer Town
CUSTE 0008 CUST_TEL                      Customer Telephone
CUSTE 0009 CUST_FAX                      Customer Fax
CUSTE 0010 CUST_SWIFT                    Customer Swift Code
CUSTE 0011 CUST_BLZ                      Bankleitzahl
ACOF  0001 ACOF_CODE                     Account Officer Code
ACOF  0002 ACOF_DEPT                     Account Officer Dept
ACOF  0003 ACOF_NAME                     Account Officer Name
ACOF  0004 ACOF_TELP                     Account Officer Telephone Num.
ACOF  0005 ACOF_TELX                     Account Officer Telephone Ext.
CUSTSG0001 CSCODE                        Customer Segmentation Code
CUSTSG0002 CSNAME                        Customer Segmentation Name
CUSTSG0003 CSGRP                         Customer Segmentation Group
ODACCT0001 ACCNUM                        Account Number
ODACCT0002 CURRENCY                      Currency
ODACCT0003 CLRDBAL    AmountL            Cleared Balance
ODACCT0004 LDGRBAL    AmountL            Ledger Balance
ODACCT0005 ODLIMIT    AmountL            Overdraft Limit
ODACCT0006 ODLMTEXPDT Date               Overdraft Limit Expiry Date
ODACCT0007 DEBINTRTE  Rate  L7           Debit Interest Rate
ODACCT0008 ODINTRATE  Rate  L7           Overdraft Interest Rate
ODACCT0009 DTEODBAL   Date               Date of Overdraft Balance excess
ODACCT0010 NUMDAYS                       Number of days in excess
