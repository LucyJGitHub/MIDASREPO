     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Stamp Tax Retail & Loan Average Balance')     *
/*OVRF*: OVRDBF FILE(SDSTMDX2) TOFILE(SDSTMDL2)
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG002300 - Retail and Loan Average Balance                   *
      *                                                               *
      *  Function:  This program creates the extract for Retail       *
      *             and Loan average balances.                        *
      *                                                               *
      *  Called By: CGC002300, CGC002310, CGC002320                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. MD040354           Date 12Aug16               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 AR888911           Date 26Jan12               *
      *                 AR879983           Date 21Dec11               *
      *                 AR853257           Date 04Nov11               *
      *                 CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD040354 - 1. DB erro 953 due to INIXML executed too soon.   *
      *             2. array index error caused by Q.                 *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR888911 - In reversing a deal, REV column in Stamp Tax      *
      *             Movements Enquiry is not changing from N to Y     *
      *             (Recompile)                                       *
      *           - Applied for AR944923                              *
      *  AR879983 - Add stamp tax exchange rate (Recompile)           *
      *  AR853257 - Account Keys for FT were not generated            *
      *             (Recompile)                                       *
      *  CER049 - Stamp Tax (Portuguese Features Upgrade)             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ~~~~~~~~~~~~~~~                                              *
      *  90   -    READE indicator                                    *
      *  99   -    General error indicator                            *
      *                                                               *
      *****************************************************************

      ** Midas SD Stamp Tax Hist Detail - Average by date

     FSDSTMDL2  UF   E           K DISK    COMMIT
     F                                     USROPN
     F                                     INFSR(SRFILE)
     FSDSTMDX2  UF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     F                                     RENAME(@STMDV2:@STMDX2)

      ** Midas RE Retail int. and charges detail

     FREIAC     IF   E           K DISK    INFSR(SRFILE)
     F                                     IGNORE(REIACAF)
     F                                     IGNORE(REIACZF)

      ** Midas LE Customer loans

     FCLOAN     IF   E           K DISK    INFSR(SRFILE)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANZ1F)

      *****************************************************************
      /EJECT
      *****************************************************************

      ** Data pack arrays and data structures

     D/COPY CGCPYSRC,CGPACKDLE

      ** Fields, data structures, arrays definition for
      ** CG error processing

     D/COPY CGCPYSRC,SRERRDLE

      ** Array of Currencies accessed by program

     D ##CY            S              3    DIM(100)

      ** Look-up string for RDE definition Array

     D #@SDS           DS
     D  #@S                 5120   5120

      **  Number Field

     D                 DS
     D  ##ITMA                 1      8
     D  ##ITEM                 1      8  0

      ** Multi-occurence data structure to store path

     D WMDsPath        DS                  OCCURS(20)
     D  WMDsPathGrp            1      6

      ** String that contains the concatenated path

     D WPathStr        S            256A

      ** Index for WMDsPath only

     D WPx             S              3P 0

      ** General purpose variables

     D WProduce        S              1A
     D Wx1             S              3P 0
     D Wx2             S              3P 0

      ** Parameter fields

     D PAction8        S              8A
     D PCustNumChr6    S              6A
     D PItmRef         S              8A
     D PMode           S             10A
     D PRtnCode        S              7A
     D W0CMT           S              3A
     D W0RTN           S              7A
     D WAUTO           S              1A
     D CCG015          S              1A
     D PChgType        S              1A
     D W0SPAT          S             70A
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D PCKey           S             10A
     D PSKey           S              7A
     D PCcy            S              3A
     D PCnum           S              6A
     D PAcod           S             10S 0
     D PAcsq           S              2S 0
     D PBrca           S              3A
     D PAcoc           S              2A
     D PCAcno          S             10A
     D PCAcod          S             10A
     D PCAcsq          S              2A

     D                 DS

      ** General data structure to define fields that need to share data

     D WGrp10                  1     10
     D  WGrpName               1      6
     D  WGrpSeq                7     10S 0
     D  WNum20                21     40  0
     D  WChr20                21     40
     D  WChr29                51     79
     D  WACOD          S             10A
     D  WACSQ          S              2A

      ** Used to convert item reference from character to numeric

     D                 DS
     D  ##NCIT                 1      6
     D  NMCY                   1      3
     D  SITP                   4      6
     D                 DS
     D  ##CCY                  1      3
      *
      *----------------------------------------------------------------
      ** Named constants

      ** Stamp Tax Print Type

     D W#PTYP          C                   CONST('STAMP_TAX')

      ** Stamp Tax Print Subtypes

     D W#PSTY          C                   CONST('RETAVRBAL')
     D W#PSTL          C                   CONST('LN_AVRBAL')
     D W#PSTI          C                   CONST('LOAN INT')
     D W#PSTP          C                   CONST('LOAN PRN')

      *----------------------------------------------------------------

      ** External DS for UDC Data reference

     D PEDsCGUDCRPD  E DS                  EXTNAME(CGUDCRPD)

      **  External DS for Bank details

     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      **  External DS for General Ledger details

     D SDGELR        E DS                  EXTNAME(SDGELRPD)

      **  External DS for Module details

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      **  External DS for Securities Trading Module details
      *
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  TRACCD       E                     EXTFLD(QQACCD)
      **  External DS for Trading Module details
      *
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  DLACCD       E                     EXTFLD(QQACCD)
      **  External DS for Dealing Module details
      *
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  REACCD       E                     EXTFLD(QQACCD)
      **  External DS for Retail details
      *
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
      **  External DS for Message Management details
      *
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
      **  External DS for Funds Transfer details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      **  External DS for branch details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **  External DS for customer details
     D  CUDFAC       E                     EXTFLD(QQDFAC)
      *
     D SDACOF        E DS                  EXTNAME(SDACOFPD)
      **  External DS for Account Officer Details
      *
     D SDCURR        E DS                  OCCURS(101) EXTNAME(SDCURRPD)

      **  External DS for currency details

     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** MIDAS Switchable Features Accessed Via Access Program

     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  First DS for access programs, short data structure

     D DSSDY         E DS                  EXTNAME(DSSDY)

      **  Second DS for access programs, long data structure

     D SDACCT        E DS                  EXTNAME(ACCNTAB)

      **  External DS for Bank details

     D  ACRECI       E                     EXTFLD(RECI)
     D  ACLCD        E                     EXTFLD(LCD)

      **  Record format of PF/CGUDTAPD for use as a parameter

      ** Compile-time array to contain RDE definitions

     D WTbGrp          S             10    DIM(47) CTDATA PERRCD(1)
     D WTbRDE          S             22    DIM(47) ALT(WTbGrp)

      **  Data Structure for Compilation - Copyright Insertion

     D CPYR            DS
     D  ##CPY                  1     80    DIM(1) CTDATA PERRCD(1)

      ** DS to store subroutine specific data.
      ** - Saved Path

     D #PDS            DS
     D  P1                     1      3  0 INZ(0)
     D  P2                     4      6  0
     D  P3                     7      9  0
     D  P4                    10     12  0
     D  P5                    13     15  0

      ** Correspondence Manager details

     D P1PARM          DS           256

      ** Output Sequence

     D  P1OSEQ                 1      9  0

      ** Item Reference Number

     D  P1ITEM                10     17  0

      ** This bind level

     D  P1TBIN                18     25  0

      ** Previous bind level

     D  P1PBIN                26     33  0

      ** Loan details Parameters for call to CG6001.

     D P@PARM          DS           256

      ** Loan Reference

     D  P@LNRF                 1      6

      ** Cancel/Amend Field

     D  P@CNAM                 7      7

      ** Facility details Parameter for call to CG6001

     D P4PARM          DS           256

      ** Facility customer

     D  P4FCUS                 1      6

      ** Facility type

     D  P4FTYP                 7      9  0

      ** Facility Seq

     D  P4FSEQ                10     11  0
      *****************************************************************
      /EJECT
      *****************************************************************
     ICLOANCLF
     I              ACOF                        CLACOF
     I              CCY                         LNCCY
      *****************************************************************
      /EJECT
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Process     :  MAINLINE                                      *
      *  Function    :  Mainline processing                           *
      *                                                               *
      *  Called by   :  None                                          *
      *  Calls       :  SRINZ  - Initialise Fields on Each Invocation *
      *                 SRMAIN - Main Processing                      *
      *                                                               *
      *****************************************************************

      ** Set up subroutine stack name

     C                   EVAL      Q      += 1
     C                   EVAL      @STK(Q) = 'MAIN'

      ** Read stamp tax until end of file

     C                   IF        W0CMT = 'YES'
     C                   READ      SDSTMDL2
     C                   ELSE
     C                   READ      SDSTMDX2
     C                   ENDIF

     C                   DOW       NOT %EOF()

      ** If UDC not extracted, process record

     C                   IF        T2UDCF = *BLANKS

      ** Initialisation processing

     C                   EXSR      SRINZ

      ** Main processing

     C                   EXSR      SRMAIN
     C                   ENDIF

      ** Read next record

     C                   EVAL      T2UDCF = 'Y'
     C                   IF        W0CMT  = 'YES'
     C                   UPDATE    @STMDV2
     C                   COMMIT
     C                   READ      SDSTMDL2
     C                   ELSE
     C                   UPDATE    @STMDX2
     C                   READ      SDSTMDX2
     C                   ENDIF

     C                   ENDDO

     C                   EVAL      *INLR  = *ON

      ** Unwind subroutine stack name

     C                   EVAL      %SUBARR(@STK:Q) = *BLANKS
     C                   EVAL      Q -=  1

      ** Terminate program

     C                   RETURN

      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      *  SRMAIN - Main Processing                                     *
      *                                                               *
      *  Called by:  Mainline                                         *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************

     C     SRMAIN        BEGSR

      ** Set up subroutine stack name

     C                   EVAL      Q  += 1
     C                   MOVEL     'SRMAIN'      @STK(Q)

      ** Account or Loan average

     C                   SELECT
     C                   WHEN      T2KEY = 'ACCOUNT'

      ** Check that account needs to be advised

     C                   EVAL      CNUM = T2CNUM
     C                   EVAL      CCY  = T2CCY
     C                   EVAL      ACOD = T2ACOD
     C                   EVAL      ACSQ = T2ACSQ
     C                   EVAL      BRCA = T2BRCA

     C     KACKEY        CHAIN     REIACDF
     C                   IF        %FOUND() AND
     C                             PTRA = 'Y'

      ** Generate reference number by writing to PF/CGUDCRPD
      ** If no confirmation to be produced, then bypass

     C                   EXSR      SRGenRef
     C                   IF        WProduce = 'Y'

      ** Extract

     C                   EXSR      SRzSTAVR
     C                   ENDIF

     C                   ENDIF

      ** If loan

     C                   WHEN      T2KEY = 'LOAN'

      ** Get Loan Information

     C                   EVAL      LNRF  = T2LNRF
     C                   EVAL      RCDT  = 'A'
     C     KCLOAN        CHAIN     CLOANCLF

     C                   IF        %FOUND()

      ** Generate reference number by writing to PF/CGUDCRPD.
      ** If no confirmation to be produced, then bypass.

     C                   EXSR      SRGenRef
     C                   IF        WProduce = 'Y'

      ** Extract Principal and Interest Related Events.

     C                   IF        T2STFB = *BLANKS
     C                   EXSR      SRZSTLN
     C                   ELSE
     C                   EXSR      SRzSTAVL
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDSL

      ** Unwind subroutine stack name

     C                   EVAL      %SUBARR(@STK:Q) = *BLANKS
     C                   EVAL      Q  -= 1
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      *  SRzSTAVR -  Process Stamp Tax Retail Average Balance         *
      *                                                               *
      *  Called by: SrMAIN                                            *
      *                                                               *
      *  Calls:     SRPath, PSHGRS, SRCust                            *
      *                                                               *
      *****************************************************************
     C     SRzSTAVR      BEGSR

      **  Set up subroutine stack name

     C                   EVAL      Q      += 1
     C                   EVAL      @STK(Q) = 'SRzSTAVR'

      ** Set up path multi-occurence data structure & path string

     C                   EVAL      WPx              = 1
     C                   EVAL      %OCCUR(WMDsPath) = WPx
     C                   EVAL      WMDsPathGrp      = 'zSTAVR'

     C                   EXSR      SRPath

     C                   EXSR      PSHGRS

      *****************************************************************

     C                   EXSR      SRCust

      ** Set up key

     C                   EVAL      PCnum  = T2CNUM
     C                   EVAL      PCcy   = T2CCY
     C                   EVAL      PAcod  = T2ACOD
     C                   EVAL      PAcsq  = T2ACSQ
     C                   EVAL      PBrca  = T2BRCA

     C                   EXSR      SRAccnt

      ** If account officer present...

     C                   IF        BBACOC <> *BLANKS
     C                   EVAL      PAcoc   = BBACOC
     C                   EXSR      SRACOF
     C                   ENDIF

     C                   EXSR      SRZAVR1
     C                   EXSR      SRZAVR2

      ** If details entered...

     C                   IF        T2DBRC <> *BLANKS AND
     C                             T2DCCY <> *BLANKS
     C                   EXSR      SRZDRACC
     C                   ENDIF

      ** Decrement Path DS index

     C                   EVAL      %OCCUR(WMDsPath) = WPx
     C                   CLEAR                   WMDsPathGrp
     C                   EVAL      WPx -= 1

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   EVAL      %SUBARR(@STK:Q) = *BLANKS
     C                   EVAL      Q  -= 1
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      *  SRzSTAVL  -  Process Stamp Tax C Loan Average Balance        *
      *                                                               *
      *  Called by: SRMAIN                                            *
      *                                                               *
      *  Calls:     SRPath, PSHGRS                                    *
      *                                                               *
      *****************************************************************
     C     SRzSTAVL      BEGSR

      ** Set up subroutine stack name

     C                   EVAL      Q      += 1
     C                   EVAL      @STK(Q) = 'SRzSTAVL'

      ** Set up path multi-occurence data structure & path string

     C                   EVAL      WPx              = 1
     C                   EVAL      %OCCUR(WMDsPath) = WPx
     C                   EVAL      WMDsPathGrp      = 'zSTAVL'

     C                   EXSR      SRPath

     C                   EXSR      PSHGRS

      *****************************************************************

      ** Loan details

     C                   EXSR      SRLOANA

      ** Average details

     C                   EXSR      SRZAVR1
     C                   EXSR      SRZAVR2

      ** If details entered

     C                   IF        T2DBRC <> *BLANKS AND
     C                             T2DCCY <> *BLANKS
     C                   EXSR      SRZDRACC
     C                   ENDIF

      ** Decrement Path DS index

     C                   EVAL      %OCCUR(WMDsPath) = WPx
     C                   CLEAR                   WMDsPathGrp
     C                   EVAL      WPx -= 1

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   EVAL      %SUBARR(@STK:Q) = *BLANKS
     C                   EVAL      Q  -= 1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZSTLN  -  Process Stamp Tax Loan Prin.Int.                 *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     SRZSTLN       BEGSR

      ** Set up subroutine stack name

     C                   EVAL      Q      += 1
     C                   EVAL      @STK(Q) = 'SRZSTLN'

      ** Set up path multi-occurence data structure & path string

     C                   EVAL      WPx              = 1
     C                   EVAL      %OCCUR(WMDsPath) = WPx
     C                   EVAL      WMDsPathGrp      = 'zSTLN'

     C                   EXSR      SRPath

     C                   EXSR      PSHGRS

      *****************************************************************

      ** Loan details

     C                   EXSR      SRLOANA

      ** Loan Stamp Details

     C                   EXSR      SRZLOAN
     C                   EXSR      SRZAVR2

      ** If details entered

     C                   IF        T2DBRC <> *BLANKS AND
     C                             T2DCCY <> *BLANKS
     C                   EXSR      SRZDRACC
     C                   ENDIF

      ** Decrement Path DS index

     C                   EVAL      %OCCUR(WMDsPath) = WPx
     C                   CLEAR                   WMDsPathGrp
     C                   EVAL      WPx -= 1

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   EVAL      %SUBARR(@STK:Q) = *BLANKS
     C                   EVAL      Q  -= 1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDRACC  -  Process Stamp Tax Debit Account Detail          *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     SRZDRACC      BEGSR

      **  Set up subroutine stack name

     C                   EVAL      Q       += 1
     C                   EVAL      @STK(Q)  = 'SRZDRACC'

      ** Set up path multi-occurence data structure & path string

     C                   EVAL      WPx             += 1
     C                   EVAL      %OCCUR(WMDsPath) = WPx
     C                   EVAL      WMDsPathGrp      = 'ZDRACC'

     C                   EXSR      SRPath

     C                   EXSR      PSHGRS

      ** Set up key

     C                   EVAL      PCnum  = T2DCST
     C                   EVAL      PCcy   = T2DCCY
     C                   EVAL      PAcod  = T2DACD
     C                   EVAL      PAcsq  = T2DASQ
     C                   EVAL      PBrca  = T2DBRC

     C                   EXSR      SRAccnt

      **  Decrement Path DS index

     C                   EVAL      %OCCUR(WMDsPath) = WPx
     C                   CLEAR                   WMDsPathGrp
     C                   EVAL      WPx -= 1

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   EVAL      %SUBARR(@STK:Q) = *BLANKS
     C                   EVAL      Q  -= 1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAccnt  -  Get Account Details                              *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     SRAccnt       BEGSR

      **  Set up subroutine stack name

     C                   EVAL      Q  += 1
     C                   EVAL      @STK(Q)  =  'SRAccnt'

      ** Set up path multi-occurence data structure & path string

     C                   EVAL      WPx += 1
     C                   EVAL      %OCCUR(WMDsPath) = WPx
     C                   EVAL      WMDsPathGrp = 'ACCNT'

     C                   EXSR      SRPath

     C                   EXSR      PSHGRS

      ** Retrieve RDE info

     C                   EVAL      WGrpName = 'ACCNT'
     C                   EVAL      WGrpSeq  = 1
     C                   EXSR      SRRtvRDE

      ** Get Account Information

     C                   MOVE      PAcod         PCAcod
     C                   MOVE      PAcsq         PCAcsq

     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY    '    POptn
     C                   PARM      *BLANKS       PCAcno
     C                   PARM                    PCnum
     C                   PARM                    PCcy
     C                   PARM                    PCAcod
     C                   PARM                    PCAcsq
     C                   PARM                    PBrca
     C     SDACCT        PARM      SDACCT        DSSDY

      ** Midas Account Identifier

     C                   EVAL      ##D(1) = DRMACT

      ** Retail Account number

     C                   MOVEL     ACNO          ##D(2)

      ** Account Name

     C                   EVAL      ##D(3) = ANAM

      ** Account type

     C                   EVAL      ##D(4) = ATYP

      ** Show Balance in Euros

     C                   EVAL      ##D(5) = EUSB

      ** International Bank A/c Number

     C                   EVAL      ##D(6) = IBAN

      ** Accumulate RDEs and associated data and output to CGUXMRPD

     C                   EXSR      SrPackDta

      ** Decrement Path DS index

     C                   EVAL      %OCCUR(WMDsPath) = WPx
     C                   CLEAR                   WMDsPathGrp
     C                   EVAL      WPx -= 1

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   EVAL      %SUBARR(@STK:Q) = *BLANKS
     C                   EVAL      Q  -= 1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZAVR2  -  Process Stamp Tax Average Details 2              *
      *                                                               *
      *  Called by: SRzSTAVR, SRzSTAVL, SRZSTLN                       *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     SRZAVR2       BEGSR

      **  Set up subroutine stack name

     C                   EVAL      Q  += 1
     C                   EVAL      @STK(Q)  = 'SRZAVR2'

      ** Set up path multi-occurence data structure & path string

     C                   EVAL      WPx += 1
     C                   EVAL      %OCCUR(WMDsPath) = WPx
     C                   EVAL      WMDsPathGrp = 'ZAVR2'

     C                   EXSR      SRPath

     C                   EXSR      PSHGRS

      ** Retrieve RDE info

     C                   EVAL      WGrpName = 'ZAVR2'
     C                   EVAL      WGrpSeq  = 1
     C                   EXSR      SRRtvRDE

      ** Tax Amount in Stamp Ccy

     C                   EVAL      ##D(1) = %CHAR(T2TASC)
     C                   EVAL      ##CCY  = T2SCCY
     C                   EXSR      SRDCDT
     C                   EVAL      %SUBST(##D(1):256) = %CHAR(A6NBDP)

      ** Stamp Tax Currency

     C                   EVAL      ##D(2) = T2SCCY

      ** Tax Paid Amount

     C                   EVAL      ##D(3) = %CHAR(T2TADC)
     C                   IF        T2DCCY = *BLANKS
     C                   EVAL      ##CCY  = T2ECCY
     C                   ELSE
     C                   EVAL      ##CCY  = T2DCCY
     C                   ENDIF
     C                   EXSR      SRDCDT
     C                   EVAL      %SUBST(##D(3):256) = %CHAR(A6NBDP)

      ** Tax Paid Curreny

     C                   EVAL      ##D(4) = ##CCY

      ** Transaction Stamp Tax Amount

     C                   EVAL      ##D(5) = %CHAR(T2TATC)
     C                   EVAL      ##CCY  = T2ECCY
     C                   EXSR      SRDCDT
     C                   EVAL      %SUBST(##D(5):256) = %CHAR(A6NBDP)

      ** Transaction Currency

     C                   EVAL      ##D(6) = T2ECCY

     C                   EXSR      SrPackDta

      *****************************************************************

      **  Decrement Path DS index

     C                   EVAL      %OCCUR(WMDsPath) = WPx
     C                   CLEAR                   WMDsPathGrp
     C                   EVAL      WPx -= 1

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   EVAL      %SUBARR(@STK:Q) = *BLANKS
     C                   EVAL      Q  -= 1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZLOAN  -  Process Loan Details                             *
      *                                                               *
      *  Called by:  SRZSTLN                                          *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     SRZLOAN       BEGSR

      **  Set up subroutine stack name

     C                   EVAL      Q      += 1
     C                   EVAL      @STK(Q) = 'SRZLOAN'

      ** Set up path multi-occurence data structure & path string

     C                   EVAL      WPx             += 1
     C                   EVAL      %OCCUR(WMDsPath) = WPx
     C                   EVAL      WMDsPathGrp      = 'ZLOAN'

     C                   EXSR      SRPath

     C                   EXSR      PSHGRS

      ** Retrieve RDE info

     C                   EVAL      WGrpName = 'ZLOAN'
     C                   EVAL      WGrpSeq  = 1
     C                   EXSR      SRRtvRDE

      ** Current Principal (Amount)

     C                   EVAL      ##D(1) = %CHAR(CPAM)
     C                   EVAL      ##CCY  = CCY
     C                   EXSR      SRDCDT
     C                   EVAL      %SUBST(##D(1):256) = %CHAR(A6NBDP)

      ** Currency

     C                   EVAL      ##D(2) = CCY

      ** Loan Reference

     C                   MOVEL     LNRF          ##D(3)

      ** Control Date

     C                   MOVEL     T2CDTE        ##D(4)

      ** Tax Value Date

     C                   MOVEL     T2VALD        ##D(5)

      ** Tax Posted Date

     C                   MOVEL     T2PSDT        ##D(6)

      ** Tax Rate (as percentage %)

     C                   EVAL      ##D(7) = %CHAR(T2TXRT*100)

      ** Account Key

     C                   EVAL      ##D(8) = T2AKEY

      ** Event Type

     C                   EVAL      ##D(9) = T2ETYP

      ** Event Amount

     C                   EVAL      ##D(10) = %CHAR(T2KAMT)
     C                   EVAL      ##CCY   = T2KCCY
     C                   EXSR      SRDCDT
     C                   EVAL      %SUBST(##D(10):256) = %CHAR(A6NBDP)

      ** Event Currency

     C                   EVAL      ##D(11) = T2KCCY

      ** Number of Months

     C                   EVAL      ##D(12) = %CHAR(T2MNTH)

      ** Period of Stamp Tax

     C                   EVAL      ##D(13) = T2PERD

      ** Reversal Indicator

     C                   EVAL      ##D(14) = T2REVI

      ** Stamp Tax Rate

     C                   EVAL      ##D(15) = %CHAR(T2TXBR * 100)

     C                   EXSR      SrPackDta

      *****************************************************************

      **  Decrement Path DS index

     C                   EVAL      %OCCUR(WMDsPath) = WPx
     C                   CLEAR                   WMDsPathGrp
     C                   EVAL      WPx -= 1

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   EVAL      %SUBARR(@STK:Q) = *BLANKS
     C                   EVAL      Q  -= 1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZAVR1  -  Process: Stamp tax Avergae Details 1             *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     SRZAVR1       BEGSR

      **  Set up subroutine stack name

     C                   EVAL      Q      += 1
     C                   EVAL      @STK(Q) = 'SRZAVR1'

      ** Set up path multi-occurence data structure & path string

     C                   EVAL      WPx             += 1
     C                   EVAL      %OCCUR(WMDsPath) = WPx
     C                   EVAL      WMDsPathGrp      = 'ZAVR1'

     C                   EXSR      SRPath

     C                   EXSR      PSHGRS

      ** Retrieve RDE info

     C                   EVAL      WGrpName = 'ZAVR1'
     C                   EVAL      WGrpSeq  = 1
     C                   EXSR      SRRtvRDE

      ** Adjustment Number

     C                   EVAL      ##D(1) = %CHAR(T2ASEQ)

      ** Control Date

     C                   EVAL      ##D(2) = %CHAR(T2CDTE)

      ** End of Period Date

     C                   EVAL      ##D(3) = %CHAR(T2ENDT)

      ** Start of Period Date

     C                   EVAL      ##D(4) = %CHAR(T2STDT)

      ** Tax Value Date

     C                   EVAL      ##D(5) = %CHAR(T2VALD)

      ** Tax Posted Date

     C                   EVAL      ##D(6) = %CHAR(T2PSDT)

      ** Tax rate (as percentage %)

     C                   EVAL      ##D(7) = %CHAR(T2TXRB * 100)

      ** Sum of Balances for Period

     C                   EVAL      ##D(8) = %CHAR(T2AVBL)
     C                   SELECT
     C                   WHEN      T2KEY  = 'ACCOUNT'
     C                   EVAL      ##CCY  = T2CCY
     C                   WHEN      T2KEY  = 'LOAN'
     C                   EVAL      ##CCY  = LNCCY
     C                   ENDSL
     C                   EXSR      SRDCDT
     C                   EVAL      %SUBST(##D(8):256) = %CHAR(A6NBDP)

     C                   EXSR      SrPackDta

      *****************************************************************

      **  Decrement Path DS index

     C                   EVAL      %OCCUR(WMDsPath) = WPx
     C                   CLEAR                   WMDsPathGrp
     C                   EVAL      WPx -= 1

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   EVAL      %SUBARR(@STK:Q) = *BLANKS
     C                   EVAL      Q  -= 1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCust - Get Customer Details                                *
      *                                                               *
      *  Called by: SRzSTAVR                                          *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     SRCust        BEGSR

      **  Set up subroutine stack name

     C                   EVAL      Q  += 1
     C                   EVAL      @STK(Q)  =  'SRCust'

      ** Set up path multi-occurence data structure & path string

     C                   EVAL      WPx += 1
     C                   EVAL      %OCCUR(WMDsPath) = WPx
     C                   EVAL      WMDsPathGrp = 'CUST'

     C                   EXSR      SRPath

     C                   EXSR      PSHGRS

      ** Retrieve RDE info

     C                   EVAL      WGrpName = 'CUST'
     C                   EVAL      WGrpSeq  = 1
     C                   EXSR      SRRtvRDE

     C                   EVAL      PCKey = T2CNUM
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCKey
     C                   PARM      *BLANKS       PSKey
     C     SDCUST        PARM      SDCUST        DSSDY

      *****************************************************************

      ** Customer Number

     C                   EVAL      ##D(1) = BBCUST

      ** Customer Name

     C                   EVAL      ##D(2) = BBCRNM

      ** Customer Town

     C                   EVAL      ##D(3) = BBCRTN

      ** Customer Address Line 1 - 4

     C                   EVAL      ##D(4) = BBCNA1
     C                   EVAL      ##D(5) = BBCNA2
     C                   EVAL      ##D(6) = BBCNA3
     C                   EVAL      ##D(7) = BBCNA4

      ** Accumulate RDEs and associated data and output to CGUXMRPD

     C                   EXSR      SrPackDta
      *****************************************************************

      **  Decrement Path DS index

     C                   EVAL      %OCCUR(WMDsPath) = WPx
     C                   CLEAR                   WMDsPathGrp
     C                   EVAL      WPx -= 1

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   EVAL      %SUBARR(@STK:Q) = *BLANKS
     C                   EVAL      Q  -= 1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRACOF  -  Process Account Officer Details                   *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     SRACOF        BEGSR

      **  Set up subroutine stack name

     C                   EVAL      Q      += 1
     C                   EVAL      @STK(Q) = 'SRACOF'

      ** Set up path multi-occurence data structure & path string

     C                   EVAL      WPx             += 1
     C                   EVAL      %OCCUR(WMDsPath) = WPx
     C                   EVAL      WMDsPathGrp      = 'ACOF'

     C                   EXSR      SRPath

     C                   EXSR      PSHGRS

      ** Retrieve RDE info

     C                   EVAL      WGrpName = 'ACOF'
     C                   EVAL      WGrpSeq  = 1
     C                   EXSR      SRRtvRDE

      ** Retrieve Account Officer Details

     C                   CALL      'AOACOFR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PAcoc
     C     SDACOF        PARM      SDACOF        DSFDY

      ** Account Officer Code

     C                   EVAL      ##D(1) = AZACOC

      ** Acc. Officer Dept. Code

     C                   EVAL      ##D(2) = AZDPCD

      ** Account Officer Name

     C                   EVAL      ##D(3) = AZACON

      ** Account Officer Telephone Number

     C                   EVAL      ##D(4) = AZAPHN

      ** Acc. Off. Telephone Extension

     C                   EVAL      ##D(5) = AZAEXT

     C                   EXSR      SrPackDta

      *****************************************************************

      **  Decrement Path DS index

     C                   EVAL      %OCCUR(WMDsPath) = WPx
     C                   CLEAR                   WMDsPathGrp
     C                   EVAL      WPx -= 1

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   EVAL      %SUBARR(@STK:Q) = *BLANKS
     C                   EVAL      Q  -= 1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLOANA  -  Process General Loan details                     *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls:     SRPath - Generate Path String                     *
      *             CG6001 - General Loan Details                     *
      *                                                               *
      *****************************************************************
     C     SRLOANA       BEGSR

      **  Set up subroutine stack name

     C                   EVAL      Q  += 1
     C                   EVAL      @STK(Q)  =  'SRLOANA'

      ** Set up path multi-occurence data structure & path string

     C                   EVAL      WPx             += 1
     C                   EVAL      %OCCUR(WMDsPath) = WPx
     C                   EVAL      WMDsPathGrp      = 'LOANA'

     C                   EXSR      SRPath

      *****************************************************************
      *                                                               *
      *  Get general loan information                                 *
      *                                                               *
      *****************************************************************

     C                   EVAL      P2PARM  = WPathStr
     C                   EVAL      P1ITEM  = ##ITEM

      ** Set up data.

     C                   CLEAR                   P4PARM
     C                   EVAL      P@CNAM = *BLANKS

     C                   IF        T2REVI = '1'
     C                   EVAL      P@CNAM = 'R'
     C                   ENDIF

     C                   MOVE      LNRF          P@LNRF

     C                   CALL      'CG6001'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM                    W0CMT
     C                   PARM                    P1PARM                         UDC Details
     C                   PARM                    P2PARM          140            Path Details
     C                   PARM                    P@PARM                         Loan Details
     C                   PARM                    P4PARM                         Facility Details
     C                   PARM                    WAUTO
     C                   PARM                    ##REFR
     C                   PARM      0             P@ICR
     C                   PARM      'N'           ##MAST

      ** Unwind subroutine stack name

     C                   EVAL      %SUBARR(@STK:Q) = *BLANKS
     C                   EVAL      Q  -= 1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  Subroutine  :  SRINZ                                         *
      *  Function    :  Initialise Fields on Program Invocation       *
      *                                                               *
      *  Called by   :  Mainline                                      *
      *  Calls       :                                                *
      *****************************************************************
     C     SRINZ         BEGSR

      **  Set up subroutine stack name

     C                   EVAL      Q      += 1
     C                   EVAL      @STK(Q) = 'SRINZ'

      **...............................................................

      ** Initialise work fields

     C                   EVAL      WPathStr = *BLANKS

      ** Initialise XML increment

     C                   EXSR      INIXML

      ** Unwind subroutine stack name

     C                   EVAL      %SUBARR(@STK:Q) = *BLANKS
     C                   EVAL      Q  -= 1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPATH  -  Generate Path String /GS1/GS2...                  *
      *                                                               *
      *  Called by:  All Group Set subroutines                        *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     SRPath        BEGSR

      **  Set up subroutine stack name

     C                   EVAL      Q      += 1
     C                   EVAL      @STK(Q) = 'SRPath'

      *................................................................

     C                   EVAL      WPathStr = *BLANKS

     C                   DO        WPx           Wx1
     C                   EVAL      %OCCUR(WMDsPath) = Wx1
     C                   EVAL      WPathStr = %TRIMR(WPathStr) + '\' +
     C                                        %TRIM(WMDsPathGrp)
     C                   ENDDO

      ** Unwind subroutine stack name

     C                   EVAL      %SUBARR(@STK:Q) = *BLANKS
     C                   EVAL      Q  -= 1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrFmtDta - Reformat data before packing it.                  *
      *****************************************************************
     C     SrFmtDta      BEGSR

      ** Set up subroutine stack name

     C                   EVAL      Q  += 1
     C                   EVAL      @STK(Q) = 'SrFmtDta'

      ** Loop through RDE's and data

     C                   FOR       Wx1 = 1 TO 20

      ** Move RDE's and its data to their templates

     C                   EVAL      R#DEFN = ##R(Wx1)
     C                   EVAL      R#DATA = ##D(Wx1)

      ** Reformat only if data is present and RDE is edited

     C                   IF        R#DATA <> *BLANKS AND
     C                             ##RDEC <> *BLANKS

      ** Right-align amount

     C                   EVAL      WNum20  = 0
     C                   EVAL      WChr20  = *ALL'0'
     C                   EVALR     WChr20  = WChr20 + %TRIM(##NUMA)

      ** Sign

     C                   IF        ##SIGN = '-'
     C                   EVAL      ##NUMB = -WNum20
     C                   ELSE
     C                   EVAL      ##NUMB = WNum20
     C                   ENDIF

      ** Edit type

     C                   IF        ##EDTT = *BLANKS
     C                   EVAL      ##EDTT = ##RDET
     C                   ENDIF

      ** Default decimal places

     C                   IF        ##DCPA = *BLANKS
     C                   EVAL      ##DCPA = ##RDED
     C                   ENDIF

      ** New RDE data

     C                   EVAL      ##D(Wx1) = R#DATA

     C                   ENDIF

     C                   ENDFOR

      ** Unwind subroutine stack name

     C                   EVAL      %SUBARR(@STK:Q) = *BLANKS
     C                   EVAL      Q  -= 1

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

     C                   EVAL      Q      += 1
     C                   EVAL      @STK(Q) = 'SrPackDta'

      ** Reformat RDE data

     C                   EXSR      SrFmtDta

     C                   EVAL      PAction8 = '*NEWARR'
     C                   EVAL      W0SPAT   = WPathStr

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
     C                   EVAL      W0File   = 'CG3999'
     C                   EVAL      W0Key    = PRtnCode
     C                   EVAL      W0ERNB   = 03
     C                   EVAL      W0MsgD   = 'MEM5003'
     C                   EVAL      W0MsgF   = 'MIDAS'
     C                   EXSR      SRERR
     C                   ENDIF

     C                   EXSR      WRTRDE

      ** Unwind subroutine stack name

     C                   EVAL      %SUBARR(@STK:Q) = *BLANKS
     C                   EVAL      Q -=  1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRDCDT - Determine Currency Details                          *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     SRDCDT        BEGSR

      ** Set up subroutine stack name

     C                   EVAL      Q  += 1
     C                   EVAL      @STK(Q)  =  'SRDCDT'

      *................................................................

      ** Access array of Currency Details already loaded

     C                   EVAL      Wx1 = %LOOKUP(##CCY:##CY)

      **  If no match is found determine the next free space in the
      **  loaded currency array.

     C                   IF        Wx1 = 0
     C                   EVAL      Wx2 = %LOOKUP(*BLANKS:##CY)

      **  If no space is left, set the Currency Data data structure to
      **  the 101st occurrence so that when the new details are
      **  retrieved no existing details are overwritten.

     C                   IF        Wx2 = 0
     C                   EVAL      %OCCUR(SDCURR) = 101

      ** If a space is found, set up the new currency into the array
      ** and position the Currency Data data structure on the
      ** occurrence matching the array index.

     C                   ELSE
     C                   EVAL      ##CY(Wx2) = ##CCY
     C                   EVAL      %OCCUR(SDCURR) = Wx2
     C                   ENDIF

      ** Retrieve the currency details.

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd                          B:Return Cd
     C                   PARM      '*KEY'        POptn                          I:Option
     C                   PARM      ##CCY         PCcy                           I:Currency Code
     C     SDCURR        PARM      *BLANK        DSSDY                          O:Format

      ** Database Error

     C                   IF        PRtCd <> *BLANK
     C                   EVAL      W0FILE = 'SDCURRPD'
     C                   EVAL      W0KEY  = ##CCY
     C                   EVAL      W0ERNB = 12
     C                   EVAL      W0MSGD = 'MEM5004'
     C                   EVAL      W0MSGF = 'MIDAS'
     C                   EXSR      SRERR
     C                   ENDIF

      ** If the currency has been retrieved earlier, position the
      ** Currency Data data structure on the relevant occurrence.

     C                   ELSE
     C                   EVAL      %OCCUR(SDCURR) = Wx1
     C                   ENDIF

      ** Unwind subroutine stack name

     C                   EVAL      %SUBARR(@STK:Q) = *BLANKS
     C                   EVAL      Q  -= 1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRGenRef - Generate reference number by writing              *
      *             to PF/CGUDCRPD                                    *
      *                                                               *
      *  Called by: SRMAIN                                            *
      *                                                               *
      *  Calls:     CG9010                                            *
      *                                                               *
      *****************************************************************
     C     SRGenRef      BEGSR

      ** Set up subroutine stack name

     C                   EVAL      Q      += 1
     C                   EVAL      @STK(Q) = 'SRGenRef'

      ** Generate reference number and check if further processing
      ** required. Set up all available information in the record
      ** format before calling.

     C                   CLEAR                   PEDsCGUDCRPD

      ** Booking/Main Branch (Mandatory)

     C                   EVAL      DRBRCA = T2BRCA

      ** Auto Transmission indicator

     C                   EVAL      DRATRM = 'N'

      ** If Account

     C                   SELECT
     C                   WHEN      T2KEY = 'ACCOUNT'

      ** Module identifier (Mandatory)

     C                   EVAL      DRMODI = 'RE'

      ** Midas GL Account Reference CNUMCCYACODACSQBRCA  (Optional)

     C                   MOVEL     T2ACOD        WACOD
     C                   MOVEL     T2ACSQ        WACSQ
     C                   EVAL      DRMACT = %TRIM(T2CNUM) + T2CCY + WACOD +
     C                                      WACSQ + T2BRCA

     C                   EVAL      DRPTYP = W#PTYP
     C                   EVAL      DRPSTP = W#PSTY

      ** Customer Number (Mandatory)

     C                   EVAL      PCustNumChr6 = T2CNUM

      ** If loan

     C                   WHEN      T2KEY = 'LOAN'

      ** Module identifier (Mandatory)

     C                   EVAL      DRMODI = 'LE'

      ** Midas Transaction Number (Mandatory)

     C                   MOVEL     LNRF          DRMTRN

      ** Midas GL Account Reference CNUMCCYACODACSQBRCA  (Optional)

     C                   MOVEL     T2DACD        WACOD
     C                   MOVEL     T2DASQ        WACSQ
     C                   EVAL      DRMACT = %TRIM(T2DCST) + T2DCCY + WACOD +
     C                                      WACSQ + T2DBRC

     C                   EVAL      DRPTYP = W#PTYP

     C                   SELECT
     C                   WHEN      T2STFB = 'Y'
     C                   EVAL      DRPSTP = W#PSTL
     C                   WHEN      T2STFI = 'Y'
     C                   EVAL      DRPSTP = W#PSTI
     C                   WHEN      T2STFF = 'Y'
     C                   EVAL      DRPSTP = W#PSTP
     C                   ENDSL

      ** Customer Number (Mandatory)

     C                   EVAL      PCustNumChr6 = T2DCST

     C                   ENDSL

     C                   CALL      'CG9010'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*GEN'        PMode
     C                   PARM                    W0CMT
     C                   PARM                    PCustNumChr6
     C                   PARM                    PEDsCGUDCRPD
     C                   PARM      *BLANKS       PItmRef

      ** Blank return code implies generate correspondence.
      ** CGD1270 => no error, but suppress output for this transaction.

     C                   IF        PRtnCode = *BLANKS

     C                   EVAL      WProduce = 'Y'
     C                   EVAL      ##ITMA   = PItmRef

      ** Pass reference as PRINTTYPE:SUBTYPE.

     C                   EVAL      ##REFR   = %TRIM(DRPTYP) + ':' +
     C                                        %TRIM(DRPSTP)

     C                   EXSR      WRAPRF

     C                   ELSE

     C                   IF        PRtnCode <> 'CGD1270'
     C                   EVAL      W0FILE = 'CG9010'
     C                   EVAL      W0KEY  = PRtnCode
     C                   EVAL      W0ERNB = 9
     C                   EVAL      W0MSGD = 'CGD1286'
     C                   EVAL      W0MSGF = 'CGUSRMSG'
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF

      ** Unwind subroutine stack name

     C                   EVAL      %SUBARR(@STK:Q) = *BLANKS
     C                   EVAL      Q -=  1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initialization routine                              *
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

     C     KACKEY        KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    BRCA

     C     KCLOAN        KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    RCDT

     C                   EVAL      Q   = 0

      ** Initialise XML increment

     C**********         EXSR      INIXML                                                   MD040354

      ** Index of WMDsPath

     C                   EVAL      WPx = 0
     C                   CLEAR                   WMDsPath

      ** Call access program for Bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSSDY

     C                   IF        PRtCd <> *BLANKS

      ** Database error

     C                   EVAL      W0FILE  = 'AOBANKR0'
     C                   EVAL      W0KEY   = '*CALL'
     C                   EVAL      W0ERNB  = 01
     C                   EVAL      W0MSGD  = 'MEM5003'
     C                   EVAL      W0MSGF  = 'MIDAS  '
     C                   EXSR      SRERR
     C                   ENDIF

     C     BJDFIN        COMP      'M'                                    98    MMDDYY, 98 ON

      ** Determine Number of decimal places - Base currency

     C                   MOVEL     BJCYCD        ##CCY
     C                   EXSR      SRDCDT
     C                   Z-ADD     A6NBDP        BASCDP            1 0

     C                   IF        W0CMT = 'YES'
     C                   OPEN      SDSTMDL2
     C                   ELSE
     C                   OPEN      SDSTMDX2
     C                   ENDIF

      ** CCG015

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CCG015'      PSard

     C                   IF        PRtCd  = *BLANKS
     C                   EVAL      CCG015 = 'Y'
     C                   ENDIF

     C                   EXSR      INIXML                                                   MD040354
      ** Unwind subroutine stack name

     C**********         EVAL      %SUBARR(@STK:Q) = *BLANKS                                MD040354
     C**********         EVAL      Q -=  1                                                  MD040354

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvRDE - Retrieve 20 RDE's from the compile-time array and *
      *             store it in ##R.                                  *
      *                                                               *
      *  Called by: SRCust                                            *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     SRRtvRDE      BEGSR

      ** Set up subroutine stack name

     C                   EVAL      Q  += 1
     C                   EVAL      @STK(Q)  =  'SRRtvRDE'

      ** Reset primary arrays

     C                   CLEAR                   ##R
     C                   CLEAR                   ##D
     C                   CLEAR                   ##S

      ** Get info from compile time array of the 20 RDEs in group set

     C                   EVAL      Wx1      = 1
     C                   DOU       Wx2      = 0  OR
     C                             Wx1      > 20
     C                   EVAL      Wx2      = %LOOKUP(WGrp10:WTbGrp)
     C                   IF        Wx2      > 0
     C                   EVAL      ##R(Wx1) = WTbRDE(Wx2)
     C                   EVAL      Wx1     += 1
     C                   EVAL      WGrpSeq += 1
     C                   ENDIF
     C                   ENDDO

      ** Unwind subroutine stack name

     C                   EVAL      %SUBARR(@STK:Q) = *BLANKS
     C                   EVAL      Q  -= 1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/SPACE 5
     C/COPY CGCPYSRC,SRERRPSSRL
     C/SPACE 5
     C/COPY CGCPYSRC,SRERRCLE
     C/SPACE 5
     C/COPY CGCPYSRC,CGNWEXILE
     C/SPACE 5
      *****************************************************************
** WTbGrp/WTbRDE
ACCNT 0001 ACCOUNT                       Account Identifier
ACCNT 0002 RETL_ACNO                     Retail Account Number
ACCNT 0003 ACC_NAME                      Account Name
ACCNT 0004 ACC_TYPE                      Account Type
ACCNT 0005 BAL_EURO                      Show Balance in Euros
ACCNT 0006 IBAN                          International Bank A/c Number
ACOF  0001 ACOF_CODE                     Account Officer Code
ACOF  0002 ACOF_DEPT                     Account Officer Dept. Code
ACOF  0003 ACOF_NAME                     Account Officer Name
ACOF  0004 ACOF_TELP                     Account Officer Telephone Num.
ACOF  0005 ACOF_TELX                     Account Officer Telephone Ext.
CUST  0001 CUSTOMER                      Customer Number
CUST  0002 CUST_NAME                     Customer Name
CUST  0003 CUST_TOWN                     Customer Town
CUST  0004 CUST_ADR1                     Customer Address Line 1
CUST  0005 CUST_ADR2                     Customer Address Line 2
CUST  0006 CUST_ADR3                     Customer Address Line 3
CUST  0007 CUST_ADR4                     Customer Address Line 4
ZAVR1 0001 Z_ADJUST                      Adjustment Number
ZAVR1 0002 Z_CNTRL_DT Date               Control Date
ZAVR1 0003 Z_END_DATE Date               End of Period Date
ZAVR1 0004 Z_ST_DATE  Date               Start of Period Date
ZAVR1 0005 Z_TAX_DATE Date               Tax Value Date
ZAVR1 0006 Z_TAX_POST Date               Tax Posted Date
ZAVR1 0007 Z_TAX_RATE Rate  L7           Tax Rate (as percentage %)
ZAVR1 0008 Z_TAXAVR1  AmountL            Sum of Balances for Period
ZAVR2 0001 Z_ST_AMT   AmountL            Tax Amount in Stamp Ccy
ZAVR2 0002 Z_ST_CCY                      Stamp Tax Currency
ZAVR2 0003 Z_TAX_AMT  AmountL            Tax Paid Amount
ZAVR2 0004 Z_TAX_CCY                     Tax Paid Currency
ZAVR2 0005 Z_TRAN_AMT AmountL            Transaction Stamp Tax Amount
ZAVR2 0006 Z_TRAN_CCY                    Transaction Currency
ZLOAN 0001 CUR PRINCL AmountL            Current Principal (Amount)
ZLOAN 0002 CURRENCY                      Currency
ZLOAN 0003 LOAN REF                      Loan Reference
ZLOAN 0004 Z_CNTRL_DT Date               Control Date
ZLOAN 0005 Z_TAX_DATE Date               Tax Value Date
ZLOAN 0006 Z_TAX_POST Date               Tax Posted Date
ZLOAN 0007 Z_TAX_RATE Rate  L7           Tax Rate (as percentage %)
ZLOAN 0008 ZAKEY                         Account Key
ZLOAN 0009 ZETYP                         Event Type
ZLOAN 0010 ZKAMT      AmountL            Event Amount
ZLOAN 0011 ZKCCY                         Event Currency
ZLOAN 0012 ZMNTH                         Number of Months
ZLOAN 0013 ZPERD                         Period of Stamp Tax
ZLOAN 0014 ZREVI                         Reversal Indicator
ZLOAN 0015 ZTXBR      Rate  L7           Stamp Tax Rate
** CTDATA ##CPY
(c) COPYRIGHT Misys International Banking Systems Ltd 2010
