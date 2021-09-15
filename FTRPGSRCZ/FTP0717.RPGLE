     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Test Specific STP requirement')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTP0717 - Midas FT Test Specific STP requirement             *
      *                                                               *
      *  (C) Copyright Misys International Banking Systems 2004       *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. HVB003             Date 19Oct2011             *
      *                 AR856737           Date 15Jul2011             *
      *                 MM2302             Date 23Feb2006             *
      *                 CRC001             Date 10Jun2005             *
      *                 MM0505             Date 04May2005             *
      *                 DJB004             Date 18Mar2005             *
      *                 DJBF03             Date 15Nov2004             *
      *                 EEE065   *CREATE   Date 15Jun2004             *
      * Midas Release 4 --------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  HVB003 - Routing for Target Balance payments                 *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level.     *
      *             Renamed SDCUSTX0  -->  SDCUSTX5                   *
      *                     SDCUSTY1  -->  SDCUSTZ1                   *
      *  MM2302 - Add check for Urgent message                        *
      *  CRC001 - Change O@KNR to CHAR for chain to SDCUSTY1          *
      *  MM0505 - Add Value Date to Routing, add cut off time         *
      *           for Euro CLearing                                   *
      *  DJB004 - Add IBANPL                                          *
      *  DJBF03 - Allow account /08N, /09N, /10N                      *
      *  EEE065 - FT Payment Routing                                  *
      *                                                               *
      *****************************************************************
     FMEBICDL2  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : BIC Directory details
      *
     FSDCTRYL2  IF   E           K DISK
     F                                     Rename(SDCTRYD0:@CTRYL2)
     F                                     INFSR(SRFILE)
      * RTV : SD Country codes
      *
     FMEISOCL1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : ISO  Country details
      *
     FFTPRCTV1  IF   E           K DISK                                                       ESL038
      * RTV : Midas FT Payment Regions                                                        ESL038
      *                                                                                       ESL038
     FSDLCSDL3  IF   E           K DISK                                                       MM0505
     F                                     INFSR(SRFILE)                                      MM0505
      * RTV : Clearing Details                                                                MM0505
      *                                                                                       MM0505
     FSDCUSTZ1  IF   E           K DISK                                                       MM0505
     F                                     INFSR(SRFILE)                                      MM0505
      * RTV : Clearing Details                                                                MM0505
      *                                                                                       MM0505
     FFTCENGP0  IF   E           K DISK                                                       HVB003
     F                                     INFSR(SRFILE)                                      HVB003
      * RTV : Target Balance Senders' BICS                                                    HVB003
      *                                                                                       HVB003
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      *  Array containing Copyright statement
     D/COPY MECPYSRC,SRERRD_ILE
      *
      *  Copysource for error processing
      *
      /EJECT
      * Data structures:
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTMA                 7     12
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      * Get Rundate - Rundate  *
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Data Structures used by Access Programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      * Data Structures used by Access Programs
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      * Bank details Structure *
      *
      *
     D DsBICD        E DS                  EXTNAME(MEBICDPD)
      *
      * SWIFT Details          *
      *
     D D@ACCT        E DS                  EXTNAME(ACCNTAB)                           HVB003
      * ACCNTABF - Account details record format data structure                       HVB003
      *                                                                               HVB003
     D P1Parm        E DS                  EXTNAME(FTMSTRP0)
      * Requirement details    *
      *
     D P2PARM          DS           256
      * Incoming data
     D  P2DATA1                1     35
     D  P2DATA2               36     70
     D  P2DATA3               71    105
     D  P2DATA4              106    140
     D  P2DATA5              141    175
     D  P2DATA6              176    210
     D  P2DATA7                1      1                                                   MM2302
     D  P2INSC                71    210                                                   HVB003
     D  P2MTPY                36     38                                                   HVB003
     D  P2SNDR                 1     11                                                   HVB003
     D  P2SNDC                 1      8                                                   HVB003
     D  P2SNDB                 9     11                                                   HVB003
      *
     D P3PARM          DS           256
      * Incoming data
     D  P3DATA1                1     35
     D  P3DATA2               36     70
     D  P3DATA3               71    105
     D  P3DATA4              106    140
     D  P3DATA5              141    175
     D  P3DATA6              176    210
      *                                                                                   HVB003
     D PACUDF          DS                                                                 HVB003
     D  PAMAD                  1    100                                                   HVB003
     D  TBAC                  39     39                                                   HVB003
      *
     D W#Valid         S              1
     D W#0001A         S              1
     D W#0002A         S              2
     D W#0003A         S              3
     D W#0004A         S              4
     D W#0005A         S              5
     D W#0006A         S              6
     D W#0007A         S              7
     D W#0008A         S              8
     D W#0009A         S              9
     D W#0010A         S             10
     D W#0011A         S             11
     D W#0012A         S             12
                                                                                              DJBF03
     D*W#0016A***      S             12                                                       DJBF03
     D*W#0024A***      S             12                                                       DJBF03
     D W#0016A         S             16                                                       DJBF03
     D W#0024A         S             24                                                       DJBF03
     D W#0035A         S                   Like(P2Data1)
     D W#0035S         S                   Like(P2Data1)
     D MVDATE          S              5P 0                                                    MM0505
      *                                                                                       MM0505
      * Compare date and time as 14 long field                                                MM0505
      *                                                                                       MM0505
     D COTTM           DS                                                                     MM0505
     D  COTIME                 1      6  0                                                    MM0505
     D  COHOMI                 1      4  0                                                    MM0505
     D  COSECS                 5      6  0                                                    MM0505
      *                                                                                       MM0505
      *
      *  Defined Constants
      *
     D DIGITS          C                   CONST('0123456789')
     D CASHP           C                   CONST('OTHR/HB POOLING')                           HVB003
      *

      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P0Action          1
     C                   PARM                    P1Parm
     C                   PARM                    P2Parm
     C                   PARM                    P3Parm
     C                   PARM                    MVDATE                                       MM0505
      *
      *  Set up primary reference
      *
     C                   Clear                   P0Rtn
     C                   MOVEL     'Validate'    W0PREF

     C                   Exsr      SrInit

      * Verify depending on test
     C                   Select
      * EQUAL
      * EMPTY
      * NOT EMPTY
      * LIST
      * NOT LIST
      * LISTSW72
      * BIC
      * BIC IBAN
      * OPTION K
      * IBAN
      * IBANCTRY
      * IBANREGN
      * IBANPL                                                                                DJB004
      * IBANEE                                                                                MM0505
      * IBANEPL                                                                               MM0505
      * BIC(5,2)
      * BIC(1,6)
      * MAX(64)
      * MAX(96)
      * CCY
      * ACCOUNT
      * CODE xx
      * QUOTE
      * EUROPE
      * NOT EUROPE
      * BBAN(xx) where xx is AT BE DE DK FI FR GB HU IT NL NO SE SW
      * INPCOT                                                                                MM0505
      * VALDATE                                                                               MM0505
      * KNR                                                                                   MM0505
      * NORMAL                                                                                MM0505

      * EQUAL
     C                   When      MsTest = 'EQUAL'
     C                   Exsr      SrEqual

      * EMPTY
     C                   When      MsTest = 'EMPTY'
     C                   Exsr      SrEmpty

      * NOT EMPTY
     C                   When      MsTest = 'NOT EMPTY'
     C                   Exsr      SrEmpty
     C                   If        P0rtn = 'False'
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif

      * NOT USED
     C                   When      MsTest = 'NOT USED'
      * LIST
     C                   When      MsTest = 'LIST'
     C                   Exsr      SrList
      * LISTSW72
     C                   When      MsTest = 'LISTSW72'
     C                   Exsr      SrListSw72
      * NOT LIST
     C                   When      MsTest = 'NOT LIST'
     C                   Exsr      SrList
     C                   If        P0rtn = 'False'
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif
      * BIC
     C                   When      MsTest = 'BIC'
     C                   Exsr      SrBic
      * OPTION K
     C                   When      MsTest = 'OPTION K' and P2Parm <> *blanks
     C                   Exsr      SrBic
     C                   If        P0rtn = 'False'
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif
      * BIC(5,2)
     C                   When      MsTest = 'BIC(5,2)'
     C                   Exsr      SrBic
     C                   If        %Subst(BDBICC:5:2) = %Subst(MsTstD:1:2)
     C                             and P0rtn = 'True'
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif
      * BIC(1,6)
     C                   When      MsTest = 'BIC(1,6)'
     C                   Exsr      SrBic
     C                   If        %Subst(BDBICC:1:6) = %Subst(MsTstD:1:6)
     C                             and P0rtn = 'True'
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif
      * MAX(64)
     C                   When      MsTest = 'MAX(64)'
     C                   If        %Subst(P2Parm:65:192) = *blanks
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif
      * MAX(96)
     C                   When      MsTest = 'MAX(96)'
     C                   If        %Subst(P2Parm:97:160) = *blanks
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif
      * CCY
     C                   When      MsTest = 'CCY'
     C                   If        %Subst(MsTstD:1:3) = %Subst(P2data1:1:3)
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif
      * ACCOUNT
     C                   When      MsTest = 'ACCOUNT'
     C                   Exsr      SrAccount

      * CODE xx
     C                   When      MsTest = 'CODE AT'
     C                             or MsTest = 'CODE AU'
     C                             or MsTest = 'CODE BL'
     C                             or MsTest = 'CODE CC'
     C                             or MsTest = 'CODE ES'
     C                             or MsTest = 'CODE GR'
     C                             or MsTest = 'CODE HK'
     C                             or MsTest = 'CODE IE'
     C                             or MsTest = 'CODE IN'
     C                             or MsTest = 'CODE IT'
     C                             or MsTest = 'CODE NZ'
     C                             or MsTest = 'CODE PT'
     C                             or MsTest = 'CODE SC'
     C                   Exsr      SrCodeXX

      * IBAN
     C                   When      MsTest = 'IBAN'
     C                   Exsr      SrIBAN

      * IBANREGN
     C                   When      MsTest = 'IBANREGN'
     C                   Exsr      SrIBAN
      *                                                                                       ESL038
     C                   If        P0rtn = 'True'
     C     KPrCtV1       Klist                                                                ESL038
     C                   Kfld                    PRCREG                                       ESL038
     C                   Kfld                    PRCTRY                                       ESL038
      *                                                                                       ESL038
     C                   Eval      PRCREG = %Subst(MsTstD:1:3)                                ESL038
     C                   Eval      PRCTRY = %Subst(P2Parm:2:2)                                ESL038
      *                                                                                       ESL038
     C     KPrCtV1       Chain     @PrCtV1                                                    ESL038
     C                   If        %Found                                                     ESL038
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif
     C                   Endif

      * IBANCTRY
     C                   When      MsTest = 'IBANCTRY'
     C                   Exsr      SrIBAN
      * Get second and third characters
     C                   If        %Subst(P2Parm:2:2) = %Subst(MsTstD:1:2)
     C                             and P0rtn = 'True'
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif
                                                                                              DJB004
      * IBANPL                                                                                DJB004
     C                   When      MsTest = 'IBANPL'                                          DJB004
     C                   Exsr      SrIBANPL                                                   DJB004

                                                                                              MM0505
      * IBANEE                                                                                MM0505
     C                   When      MsTest = 'IBANEE'                                          MM0505
     C                   Exsr      SrIBANEE                                                   MM0505
                                                                                              MM0505
                                                                                              MM0505
      * IBANEPL                                                                               MM0505
     C                   When      MsTest = 'IBANEPL'                                         MM0505
     C                   Exsr      SrIBANEPL                                                  MM0505
                                                                                              MM0505
                                                                                              MM0505
      * KNR                                                                                   MM0505
     C                   When      MsTest = 'KNR'                                             MM0505
     C                   Exsr      SrKNR                                                      MM0505
                                                                                              MM0505
                                                                                              MM0505
      * INPCOT                                                                                MM0505
     C                   When      MsTest = 'INPCOT'                                          MM0505
     C                   Exsr      SrINPCOT                                                   MM0505
                                                                                              MM0505
      * QUOTE
     C                   When      MsTest = 'QUOTE'
     C                   Exsr      SrQuote

      * BIC IBAN
     C                   When      MsTest = 'BIC IBAN'
     C                   Exsr      SrBic
     C                   If        P0rtn = 'True'
     C                   Eval      P2Data1 = P3Data1
     C                   Exsr      SrIBAN
     C                   Endif

      * EUROPE
     C                   When      MsTest = 'EUROPE'
     C                   Exsr      SrEurope

      * NOT EUROPE
     C                   When      MsTest = 'NOT EUROPE'
     C                   Exsr      SrEurope
     C                   If        P0rtn = 'False'
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif

      * BBAN(xx) where xx is AT BE DE DK FI FR GB HU IT NL NO SE SW
     C                   When      %subst(MsTest:1:5) = 'BBAN('
     C                             And %subst(MsTest:8:1) = ')'
     C                   Exsr      SrBBAN

      * VALDATE
     C                   When      MsTest = 'VALDATE'
      *
     C                   If        MVDATE <> 0
      *
     C                   If        MVDATE <= WURDNB
     C                   Eval      P0rtn = 'False'
     C                   Else
     C                   Eval      P0rtn = 'True'
     C                   Endif

     C                   Else
     C                   Eval      P0rtn = 'True'
      *
     C                   Endif
                                                                                              MM2302
      * NORMAL                                                                                MM2302
     C                   When      MsTest = 'NORMAL'                                          MM2302
     C                   Exsr      SrNURG                                                     MM2302
                                                                                              MM2302
                                                                                              MM2302
                                                                                              HVB003
      * TARGET                                                                                HVB003
     C                   When      MsTest = 'TARGET'                                          HVB003
     C                   Exsr      SrTarget                                                   HVB003
                                                                                              HVB003
                                                                                              HVB003

     C                   Endsl

      * Exit, do not close down
     C                   Return
      *
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrEqual    : Data is equal to that specified                 *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrEqual       BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrEqual '    @STK(Q)
      *
      *  Test first characters of parameter 2 is equal to data specified
      *
     C                   If        %subst(P2Data1:1:30) = MsTstd
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExEqual       TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrEmpty    : Data is empty                                   *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrEmpty       BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrEmpty '    @STK(Q)
      *
      *  Test if any data
      *
     C                   If        P2Parm = *blanks
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExEmpty       TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrList     : Test if elements are in list                    *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrList        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrList  '    @STK(Q)
      *
     C     1             Do        4             #Idx              3 0
      *
      *  Get set of  characters
      *
     C                   Select
     C                   When      #Idx = 1
     C                   Eval      W#0035A = P2Data1
     C                   When      #Idx = 2
     C                   Eval      W#0035A = P2Data2
     C                   When      #Idx = 3
     C                   Eval      W#0035A = P2Data3
     C                   When      #Idx = 4
     C                   Eval      W#0035A = P2Data4
     C                   Endsl

     C                   If        W#0035A <> *blanks
      * Find first blanks character
     C                   Movel     *blanks       ##001             1
     C     1             Do        35            U#                3 0
     C     1             SUBST     W#0035A:U#    ##001
     C                   If        ##001 <> *blanks
     C                   Z-ADD     U#            Z#                3 0
     C                   Endif
     C                   Enddo
     C                   Z-add     Z#            WQ3               3 0
      * Search for string
     C     W#0035A:WQ3   SCAN      MsTstd                                 91
      *
     C                   If        *In91 = *on
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif

     C                   Endif

      * If false exist
     C                   If        P0rtn = 'False'
     C                   Leave
     C                   Endif
      *
     C                   Enddo
      *
      *  Unwind subroutine stack name
      *
     C     ExList        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrListSw72 : Test if elements are in list for field 72       *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrListSw72    BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrListSw72'  @STK(Q)
      *
     C     1             Do        4             #Idx              3 0
      *
      *  Get set of  characters
      *
     C                   Select
     C                   When      #Idx = 1
     C                   Eval      W#0035A = P2Data1
     C                   When      #Idx = 2
     C                   Eval      W#0035A = P2Data2
     C                   When      #Idx = 3
     C                   Eval      W#0035A = P2Data3
     C                   When      #Idx = 4
     C                   Eval      W#0035A = P2Data4
     C                   Endsl

      * Check for / then second / extract data in between
     C                   If        W#0035A <> *blanks
     C                             and %subst(W#0035A:1:1) = '/'
      * Find next / character
     C                   Movel     *blanks       ##001
     C     2             Do        35            U#
     C     1             SUBST     W#0035A:U#    ##001
      * If blanks then leave
     C                   If        ##001 = *blanks
     C                   Leave
     C                   Endif
      * / Found so note length and exit
     C                   If        ##001 = '/'
     C                   Z-ADD     U#            Z#
     C                   Leave
     C                   Endif
      *
     C                   Enddo

      * If not / or position is 2 then next bit of data
     C                   If        ##001 <> '/'
     C                             or Z# = 2
     C                             or Z# > 10
     C                   Iter
     C                   Endif

     C                   Eval      Wq3 = Z# - 2
     C                   Eval      W#0035S = %Subst(W#0035A:2:Wq3)
      * Search for string
     C     W#0035S:WQ3   SCAN      MsTstd                                 91
      *
     C                   If        *In91 = *on
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif

     C                   Endif

      * If false exist
     C                   If        P0rtn = 'False'
     C                   Leave
     C                   Endif
      *
     C                   Enddo
      *
      *  Unwind subroutine stack name
      *
     C     ExListSw72    TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrBic      : Test if Bic on directory                        *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrBic         BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrBic   '    @STK(Q)
      *
      *  Test first characters of parameter 2 is equal to data specified
      *
     C                   If        %subst(P2Data1:1:1) = '/'
      * Set key
     C                   Eval      BDBICC = %subst(P2Data2:1:8)
     C                   Eval      BDBICB = %subst(P2Data2:9:3)
     C                   Else
      * Set key
     C                   Eval      BDBICC = %subst(P2Data1:1:8)
     C                   Eval      BDBICB = %subst(P2Data1:9:3)
     C                   Endif

     C                   If        BDBICB = *blanks
     C                   Eval      BDBICB = 'XXX'
     C                   Endif
      * Get data
     C     KBicdL2       Chain     @BICDL2
      *
     C                   If        %Found
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExBic         TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrAccount  : Data is equal to Account                        *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrAccount     BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrAccount'   @STK(Q)
      *
      *  Test first character is for an account
      *
     C                   If        %Subst(P2Data1:1:1) = '/'
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif
      *
      *  Now check for numerics
      *
     C                   If        P0rtn = 'True'
     C                   Select
                                                                                              DJBF03
      * 08 Numeric                                                                            DJBF03
     C                   When      MsTstD = '/08N'                                            DJBF03
     C                   Eval      W#0008A = %subst(P2Data1:2:08)                             DJBF03
     C     Digits        Check     W#0008A                                90                  DJBF03
     C                   If        *In90 = *Off                                               DJBF03
     C                             and %subst(P2Data1:09:27) = *blanks                        DJBF03
     C                   Eval      P0rtn = 'True'                                             DJBF03
     C                   Else                                                                 DJBF03
     C                   Eval      P0rtn = 'False'                                            DJBF03
     C                   Endif                                                                DJBF03
                                                                                              DJBF03
      * 09 Numeric                                                                            DJBF03
     C                   When      MsTstD = '/09N'                                            DJBF03
     C                   Eval      W#0009A = %subst(P2Data1:2:09)                             DJBF03
     C     Digits        Check     W#0009A                                90                  DJBF03
     C                   If        *In90 = *Off                                               DJBF03
     C                             and %subst(P2Data1:10:26) = *blanks                        DJBF03
     C                   Eval      P0rtn = 'True'                                             DJBF03
     C                   Else                                                                 DJBF03
     C                   Eval      P0rtn = 'False'                                            DJBF03
     C                   Endif                                                                DJBF03
                                                                                              DJBF03
      * 10 Numeric                                                                            DJBF03
     C                   When      MsTstD = '/10N'                                            DJBF03
     C                   Eval      W#0010A = %subst(P2Data1:2:10)                             DJBF03
     C     Digits        Check     W#0010A                                90                  DJBF03
     C                   If        *In90 = *Off                                               DJBF03
     C                             and %subst(P2Data1:11:25) = *blanks                        DJBF03
     C                   Eval      P0rtn = 'True'                                             DJBF03
     C                   Else                                                                 DJBF03
     C                   Eval      P0rtn = 'False'                                            DJBF03
     C                   Endif                                                                DJBF03
      * 12 Numeric
     C                   When      MsTstD = '/12N'
     C                   Eval      W#0012A = %subst(P2Data1:2:12)
     C     Digits        Check     W#0012A                                90
     C                   If        *In90 = *Off
     C                             and %subst(P2Data1:13:23) = *blanks
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif

      * 16 Numeric
     C                   When      MsTstD = '/16N'
     C                   Eval      W#0016A = %subst(P2Data1:2:16)
     C     Digits        Check     W#0016A                                90
     C                   If        *In90 = *Off
     C                             and %subst(P2Data1:17:19) = *blanks
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif

      * 24 Numeric
     C                   When      MsTstD = '/24N'
     C                   Eval      W#0024A = %subst(P2Data1:2:24)
     C     Digits        Check     W#0024A                                90
     C                   If        *In90 = *Off
     C                             and %subst(P2Data1:25:11) = *blanks
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif

     C                   Endsl
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExAccount     TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrCodeXX   : Check national clearing code                    *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrCodeXX      BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrCodeXX '   @STK(Q)
      *
      *  Test first character is for an account
      *
     C                   If        %Subst(P2Data1:1:2) = '//'
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif
      *
      *  Now check for numerics
      *
     C                   If        P0rtn = 'True'
     C                   Select
      * 3 Numeric
      * Honk Kong
     C                   When      MsTest = 'CODE HK'
     C                   Eval      W#0003A = %subst(P2Data1:5:03)
     C     Digits        Check     W#0003A                                90
     C                   If        *In90 = *Off
     C                             and %subst(P2Data1:08:28) = *blanks
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif
      * 5 Numeric
      * Austran Bankleitzahl
     C                   When      MsTest = 'CODE AT'
     C                   Eval      W#0005A = %subst(P2Data1:5:05)
     C     Digits        Check     W#0005A                                90
     C                   If        *In90 = *Off
     C                             and %subst(P2Data1:10:26) = *blanks
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif

      * 6 Numeric
      * Australian Bank State Branch (BSB) coode
      * Irish National Clearing code (NSC)
      * New Zealand National Clearing code
      * UK Domestic Sort code
     C                   When      MsTest = 'CODE AU'
     C                             or MsTest = 'CODE IE'
     C                             or MsTest = 'CODE NZ'
     C                             or MsTest = 'CODE SC'
     C                   Eval      W#0006A = %subst(P2Data1:5:06)
     C     Digits        Check     W#0006A                                90
     C                   If        *In90 = *Off
     C                             and %subst(P2Data1:11:25) = *blanks
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif

      * 7 Numeric
      * Greek Hellenic Bank Identification code
     C                   When      MsTest = 'CODE GR'
     C                   Eval      W#0007A = %subst(P2Data1:5:07)
     C     Digits        Check     W#0007A                                90
     C                   If        *In90 = *Off
     C                             and %subst(P2Data1:12:24) = *blanks
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif

      * 8 Numeric
      * German Bankleitzahl
      * Portuguese National Clearing code (NIB)
     C                   When      MsTest = 'CODE BL'
     C                             or MsTest = 'CODE PT'
     C                   Eval      W#0008A = %subst(P2Data1:5:08)
     C     Digits        Check     W#0008A                                90
     C                   If        *In90 = *Off
     C                             and %subst(P2Data1:13:23) = *blanks
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif

      * 9 Numeric
      * Canadian Payments Association Payment Routing Number
     C                   When      MsTest = 'CODE CC'
     C                   Eval      W#0009A = %subst(P2Data1:5:09)
     C     Digits        Check     W#0009A                                90
     C                   If        *In90 = *Off
     C                             and %subst(P2Data1:14:22) = *blanks
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif

      * 8 or 9 Numeric
      * Spanish Domestic Interbanking Code
     C                   When      MsTest = 'CODE ES'
     C                   Eval      W#0009A = %subst(P2Data1:5:09)
     C     Digits        Check     W#0009A                                90
     C                   If        *In90 = *Off
     C                             and %subst(P2Data1:14:22) = *blanks
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      W#0008A = %subst(P2Data1:5:08)
     C     Digits        Check     W#0008A                                90
     C                   If        *In90 = *Off
     C                             and %subst(P2Data1:13:23) = *blanks
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif
     C                   Endif

      * 10 Numeric
      * Italian Domestic Identification code
     C                   When      MsTest = 'CODE IT'
     C                   Eval      W#0010A = %subst(P2Data1:5:10)
     C     Digits        Check     W#0010A                                90
     C                   If        *In90 = *Off
     C                             and %subst(P2Data1:15:21) = *blanks
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif

      * 11 Numeric
      * Indian Financial System code (IFSC)
     C                   When      MsTest = 'CODE IN'
     C                   Eval      W#0011A = %subst(P2Data1:5:11)
     C     Digits        Check     W#0011A                                90
     C                   If        *In90 = *Off
     C                             and %subst(P2Data1:16:20) = *blanks
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif

     C                   Endsl
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExCodeXX      TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrIBAN     : Check for IBAN                                  *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrIBAN        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrIBAN   '   @STK(Q)
      *
      *  Test first character is for an account
      *
     C                   If        %Subst(P2Data1:1:1) = '/'
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif
      *
      *  Now check for country set up
      *
     C                   If        P0rtn = 'True'
      *
     C                   Eval      A4ISOC = %Subst(P2Data1:2:2)
      *
     C     KCtryL2       Klist
     C                   Kfld                    A4ISOC
      *
     C     KCtryL2       Chain     @CtryL2
      * If not found then false
     C                   If        Not %Found
     C                   Eval      P0rtn = 'False'
     C                   Else

     C                   Eval      O#IBAN = %Subst(P2Data1:2:34)
     C                   Call      'AOIBANR5'
     C                   Parm      *blanks       P@Rtcd            7
     C                   Parm                    O#IBAN           34

      * If not blank then invalid
     C                   If        P@Rtcd <> *blanks
     C                   Eval      P0rtn = 'False'
     C                   Endif

     C                   Endif

     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExIBAN        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
                                                                                              DJB004
     C/EJECT                                                                                  DJB004
      *****************************************************************                       DJB004
      *                                                               *                       DJB004
      *  SrIBANPL   : Check for IBANPL                                *                       DJB004
      *                                                               *                       DJB004
      *  CALLED BY: Main processing                                   *                       DJB004
      *                                                               *                       DJB004
      *****************************************************************                       DJB004
     CSR   SrIBANPL      BEGSR                                                                DJB004
      *                                                                                       DJB004
      *  Set up subroutine stack name                                                         DJB004
      *                                                                                       DJB004
     C                   ADD       1             Q                 5 0                        DJB004
     C                   MOVEL     'SrIBANPL '   @STK(Q)                                      DJB004
      *                                                                                       DJB004
      *  Test first character is for an account                                               DJB004
      *                                                                                       DJB004
     C                   If        %Subst(P2Data1:1:1) = '/'                                  DJB004
     C                   Eval      P0rtn = 'True'                                             DJB004
     C                   Else                                                                 DJB004
     C                   Eval      P0rtn = 'False'                                            DJB004
     C                   Endif                                                                DJB004
      *                                                                                       DJB004
      *  Now check for country set up                                                         DJB004
      *                                                                                       DJB004
     C                   If        P0rtn = 'True'                                             DJB004
      *                                                                                       DJB004
                                                                                              DJB004
     C                   Eval      O#IBAN = 'PL' + %Subst(P2Data1:2:34)                       DJB004
     C                   Call      'AOIBANR5'                                                 DJB004
     C                   Parm      *blanks       P@Rtcd            7                          DJB004
     C                   Parm                    O#IBAN           34                          DJB004
                                                                                              DJB004
      * If not blank then invalid                                                             DJB004
     C                   If        P@Rtcd <> *blanks                                          DJB004
     C                   Eval      P0rtn = 'False'                                            DJB004
     C                   Endif                                                                DJB004
                                                                                              DJB004
     C                   Endif                                                                DJB004
      *                                                                                       DJB004
      *  Unwind subroutine stack name                                                         DJB004
      *                                                                                       DJB004
     C     ExIBANPL      TAG                                                                  DJB004
     C                   MOVEA     *BLANKS       @STK(Q)                                      DJB004
     C                   SUB       1             Q                                            DJB004
      *                                                                                       DJB004
     CSR                 ENDSR                                                                DJB004
      *****************************************************************                       MM0505
     C/EJECT                                                                                  MM0505
      *****************************************************************                       MM0505
      *                                                               *                       MM0505
      *  SrIBANEE   : Check for IBAN with or without '/'              *                       MM0505
      *                                                               *                       MM0505
      *  CALLED BY: Main processing                                   *                       MM0505
      *                                                               *                       MM0505
      *****************************************************************                       MM0505
     CSR   SrIBANEE      BEGSR                                                                MM0505
      *                                                                                       MM0505
      *  Set up subroutine stack name                                                         MM0505
      *                                                                                       MM0505
     C                   ADD       1             Q                 5 0                        MM0505
     C                   MOVEL     'SrIBANEE '   @STK(Q)                                      MM0505
     C                   Eval      P0rtn = 'True'                                             MM0505
      *                                                                                       MM0505
      *  Test first character is for an account                                               MM0505
      *                                                                                       MM0505
      *                                                                                       MM0505
      *  Now check for country set up                                                         MM0505
      *                                                                                       MM0505
      *                                                                                       MM0505
     C                   If        %Subst(P2Data1:1:1) = '/'                                  MM0505
     C                   Eval      A4ISOC = %Subst(P2Data1:2:2)                               MM0505
     C                   Else                                                                 MM0505
     C                   Eval      A4ISOC = %Subst(P2Data1:1:2)                               MM0505
     C                   Endif                                                                MM0505
      *                                                                                       MM0505
     C     KCtryL2       Chain     @CtryL2                                                    MM0505
      * If not found then false                                                               MM0505
     C                   If        Not %Found                                                 MM0505
     C                   Eval      P0rtn = 'False'                                            MM0505
     C                   Else                                                                 MM0505
                                                                                              MM0505
     C                   If        %Subst(P2Data1:1:1) = '/'                                  MM0505
     C                   Eval      O#IBAN = %Subst(P2Data1:2:34)                              MM0505
     C                   Else                                                                 MM0505
     C                   Eval      O#IBAN = %Subst(P2Data1:1:34)                              MM0505
     C                   Endif                                                                MM0505
     C                   Call      'AOIBANR5'                                                 MM0505
     C                   Parm      *blanks       P@Rtcd            7                          MM0505
     C                   Parm                    O#IBAN           34                          MM0505
                                                                                              MM0505
      * If not blank then invalid                                                             MM0505
     C                   If        P@Rtcd <> *blanks                                          MM0505
     C                   Eval      P0rtn = 'False'                                            MM0505
     C                   Endif                                                                MM0505
                                                                                              MM0505
     C                   Endif                                                                MM0505
      *                                                                                       MM0505
      *  Unwind subroutine stack name                                                         MM0505
      *                                                                                       MM0505
     C     ExIBANEE      TAG                                                                  MM0505
     C                   MOVEA     *BLANKS       @STK(Q)                                      MM0505
     C                   SUB       1             Q                                            MM0505
      *                                                                                       MM0505
     CSR                 ENDSR                                                                MM0505
      *****************************************************************                       MM0505
     C/EJECT                                                                                  MM0505
      *****************************************************************                       MM0505
      *                                                               *                       MM0505
      *  SrIBANEPL  : Check for Polish IBAN or BBAN                   *                       MM0505
      *                                                               *                       MM0505
      *  CALLED BY: Main processing                                   *                       MM0505
      *                                                               *                       MM0505
      *****************************************************************                       MM0505
     CSR   SrIBANEPL     BEGSR                                                                MM0505
      *                                                                                       MM0505
      *  Set up subroutine stack name                                                         MM0505
      *                                                                                       MM0505
     C                   ADD       1             Q                 5 0                        MM0505
     C                   MOVEL     'SrIBANEPL'   @STK(Q)                                      MM0505
     C                   Eval      P0rtn = 'True'                                             MM0505
      *                                                                                       MM0505
      *  Now check for country set up                                                         MM0505
      *                                                                                       MM0505
      *                                                                                       MM0505
     C                   If        %Subst(P2Data1:1:1) = '/'                                  MM0505
     C                   Eval      A4ISOC = %Subst(P2Data1:2:2)                               MM0505
     C                   Else                                                                 MM0505
     C                   Eval      A4ISOC = %Subst(P2Data1:1:2)                               MM0505
     C                   Endif                                                                MM0505
      *                                                                                       MM0505
                                                                                              MM0505
     C                   If        %Subst(P2Data1:1:1) = '/'                                  MM0505
     C                   Eval      O#IBAN = %Subst(P2Data1:2:34)                              MM0505
     C                   Else                                                                 MM0505
     C                   Eval      O#IBAN = %Subst(P2Data1:1:34)                              MM0505
     C                   Endif                                                                MM0505
     C                   Call      'AOIBANR5'                                                 MM0505
     C                   Parm      *blanks       P@Rtcd            7                          MM0505
     C                   Parm                    O#IBAN           34                          MM0505
                                                                                              MM0505
      * If vaild IBAN but country not PL                                                      MM0505
     C                   If        P@Rtcd =  *blanks                                          MM0505
     C                             and A4ISOC <> 'PL'                                         MM0505
     C                   Eval      P0rtn = 'False'                                            MM0505
     C                   Else                                                                 MM0505
                                                                                              MM0505
      * If not blank then try Polish BBAN                                                     MM0505
     C                   If        P@Rtcd <> *blanks                                          MM0505
      *                                                                                       MM0505
     C                   If        %Subst(P2Data1:1:1) = '/'                                  MM0505
     C                   Eval      O#IBAN = 'PL' + %Subst(P2Data1:2:34)                       MM0505
     C                   Else                                                                 MM0505
     C                   Eval      O#IBAN = 'PL' + %Subst(P2Data1:1:34)                       MM0505
     C                   Endif                                                                MM0505
     C                   Call      'AOIBANR5'                                                 MM0505
     C                   Parm      *blanks       P@Rtcd            7                          MM0505
     C                   Parm                    O#IBAN           34                          MM0505
                                                                                              MM0505
      * If not blank then invalid                                                             MM0505
     C                   If        P@Rtcd <> *blanks                                          MM0505
     C                   Eval      P0rtn = 'False'                                            MM0505
     C                   Endif                                                                MM0505
                                                                                              MM0505
     C                   Endif                                                                MM0505
     C                   Endif                                                                MM0505
                                                                                              MM0505
      *                                                                                       MM0505
      *  Unwind subroutine stack name                                                         MM0505
      *                                                                                       MM0505
     C     ExIBANEPL     TAG                                                                  MM0505
     C                   MOVEA     *BLANKS       @STK(Q)                                      MM0505
     C                   SUB       1             Q                                            MM0505
      *                                                                                       MM0505
     CSR                 ENDSR                                                                MM0505
      *****************************************************************                       MM0505
     C/EJECT                                                                                  MM0505
      *****************************************************************                       MM0505
      *                                                               *                       MM0505
      *  SrKNR      : Check for KNR                                   *                       MM0505
      *                                                               *                       MM0505
      *  CALLED BY: Main processing                                   *                       MM0505
      *                                                               *                       MM0505
      *****************************************************************                       MM0505
     CSR   SrKNR         BEGSR                                                                MM0505
      *                                                                                       MM0505
      *  Set up subroutine stack name                                                         MM0505
      *                                                                                       MM0505
     C                   ADD       1             Q                 5 0                        MM0505
     C                   MOVEL     'SrKNR    '   @STK(Q)                                      MM0505
     C                   Eval      P0rtn = 'True'                                             MM0505
     C                   Move      *blanks       O#KNR             8                          CRC001
     C*******            Z-Add     0             O#KNR             8 0                        CRC001
      *                                                                                       MM0505
      *  Now check for country set up                                                         MM0505
      *                                                                                       MM0505
                                                                                              MM0505
     C                   If        %Subst(P2Data1:1:1) = '/'                                  MM0505
     C     8             Subst(p)  P2Data1:2     @KNR              8                          MM0505
     C                   Else                                                                 MM0505
     C     8             Subst(p)  P2Data1:1     @KNR                                         MM0505
     C                   Endif                                                                MM0505
     C                   Move      @KNR          O#KNR                                        MM0505
     C     O#KNR         Chain     SDCUSTZ1                                                   MM0505
     C                   If        not %Found                                                 MM0505
     C                   Eval      P0rtn = 'False'                                            MM0505
     C                   Endif                                                                MM0505
      *                                                                                       MM0505
      *                                                                                       MM0505
      *  Unwind subroutine stack name                                                         MM0505
      *                                                                                       MM0505
     C     ExKNR         TAG                                                                  MM0505
     C                   MOVEA     *BLANKS       @STK(Q)                                      MM0505
     C                   SUB       1             Q                                            MM0505
      *                                                                                       MM0505
     CSR                 ENDSR                                                                MM0505
      *****************************************************************                       MM2302
     C/EJECT                                                                                  MM2302
      *****************************************************************                       MM2302
      *                                                               *                       MM2302
      *  SrNURG     : Check for message priority                      *                       MM2302
      *                                                               *                       MM2302
      *  CALLED BY: Main processing                                   *                       MM2302
      *                                                               *                       MM2302
      *****************************************************************                       MM2302
     CSR   SrNURG        BEGSR                                                                MM2302
      *                                                                                       MM2302
      *  Set up subroutine stack name                                                         MM2302
      *                                                                                       MM2302
     C                   ADD       1             Q                 5 0                        MM2302
     C                   MOVEL     'SrNURG   '   @STK(Q)                                      MM2302
     C                   Eval      P0rtn = 'True'                                             MM2302
      *                                                                                       MM2302
     C                   If        P2Data7 = 'U'                                              MM2302
     C                   Eval      P0rtn = 'False'                                            MM2302
     C                   Endif                                                                MM2302
      *                                                                                       MM2302
      *                                                                                       MM2302
      *  Unwind subroutine stack name                                                         MM2302
      *                                                                                       MM2302
     C     ExNURG        TAG                                                                  MM2302
     C                   MOVEA     *BLANKS       @STK(Q)                                      MM2302
     C                   SUB       1             Q                                            MM2302
      *                                                                                       MM2302
     CSR                 ENDSR                                                                MM2302
      *****************************************************************                       HVB003
     C/EJECT                                                                                  HVB003
      *****************************************************************                       HVB003
      *                                                               *                       HVB003
      *  SrTarget   : Check if Target Balance Payment                 *                       HVB003
      *                                                               *                       HVB003
      *  CALLED BY: Main processing                                   *                       HVB003
      *                                                               *                       HVB003
      *****************************************************************                       HVB003
     CSR   SrTarget      BEGSR                                                                HVB003
      *                                                                                       HVB003
      *  Set up subroutine stack name                                                         HVB003
      *                                                                                       HVB003
     C                   ADD       1             Q                 5 0                        HVB003
     C                   MOVEL     'SrTarget '   @STK(Q)                                      HVB003
     C                   Eval      P0rtn = 'False'                                            HVB003
      *                                                                                       HVB003
     C     CASHP         Scan      P2Insc                                 74                  HVB003
      *                                                                                       HVB003
     C                   Select                                                               HVB003
      * IN3 messages and Instruction code not ZB Cashpool code                                HVB003
     C                   When      P2Mtpy = 'IN3' and                                         HVB003
     C                             *In74 = *OFF                                               HVB003
                                                                                              HVB003
     C     P2Sndr        Chain     FTCENGP0                                                   HVB003
     C                   If        not %Found and P2Sndb = *blanks                            HVB003
     C                   Eval      P2Sndb = 'XXX'                                             HVB003
     C     P2Sndr        Chain     FTCENGP0                                                   HVB003
     C                   Endif                                                                HVB003
                                                                                              HVB003
     C                   If        %Found                                                     HVB003
      * Sender is allowed for CashPool engine                                                 HVB003
      * Instruction code should contain INTC and either CMTO or CMSW                          HVB003
      *                                                                                       HVB003
     C     'INTC'        SCAN      P2Insc                                 75                  HVB003
     C     'CMTO'        SCAN      P2Insc                                 76                  HVB003
     C     'CMSW'        SCAN      P2Insc                                 77                  HVB003
     C     *IN75         IFEQ      *ON                                                        HVB003
     C     *IN76         ANDEQ     *ON                                                        HVB003
     C     *IN75         OREQ      *ON                                                        HVB003
     C     *IN77         ANDEQ     *ON                                                        HVB003
     C                   Eval      P0rtn = 'True'                                             HVB003
     C                   Endif                                                                HVB003
      *                                                                                       HVB003
     C                   Else                                                                 HVB003
      * Sender is not on the list of known Cash Pool engine. Check if Ordering                HVB003
      * Customer flagged for Traget Balancing. It's expected that                             HVB003
      * Ordering Customer from CashPool engine will have valid Midas IBAN                     HVB003
      *                                                                                       HVB003
     C                   Move      *Blanks       PIBAN            47                          HVB003
     C                   Move      *Blanks       POWITH           47                          HVB003
     C                   Move      *Blanks       PONOBL           34                          HVB003
     C                   Move      *Blanks       P@IBAN           34                          HVB003
      *                                                                                       HVB003
     C                   If        %Subst(P3DATA1:1:1) = '/'                                  HVB003
     C                   Eval      PIBAN = %Subst(P3DATA1:2:34)                               HVB003
     C                   Else                                                                 HVB003
     C                   Eval      PIBAN = %Subst(P3DATA1:1:34)                               HVB003
     C                   Endif                                                                HVB003
      *                                                                                       HVB003
     C                   CALL      'AOIBANR3'                                                 HVB003
     C                   PARM      *Blanks       P@Rtcd                                       HVB003
     C                   PARM                    PIBAN                                        HVB003
     C                   PARM                    POWITH                                       HVB003
     C     P@IBAN        PARM                    PONOBL                                       HVB003
      *                                                                                       HVB003
     C                   If        P@Rtcd = *Blanks                                           HVB003
      *                                                                                       HVB003
     C                   CALL      'AOIBANR4'                                                 HVB003
     C                   PARM      *Blanks       P@Rtcd                                       HVB003
     C                   PARM      '*KEY   '     P@Optn            7                          HVB003
     C                   PARM                    P@IBAN                                       HVB003
     C     D@ACCT        PARM      *Blanks       DSSDY                                        HVB003
      *                                                                                       HVB003
     C                   If        P@Rtcd = *Blanks and                                       HVB003
     C                             RECI = 'D'                                                 HVB003
      * Check if the account is flagged for Target Balance                                    HVB003
      *                                                                                       HVB003
     C                   Move      *Blanks       PBRCA             3                          HVB003
     C                   Move      *Blanks       PCNUM             6                          HVB003
     C                   Move      *Blanks       PCCY              3                          HVB003
     C                   Move      *Blanks       PACOD            10                          HVB003
     C                   Move      *Blanks       PACSQ             2                          HVB003
     C                   Move      *Blanks       PAMAD                                        HVB003
     C                   Move      *Blanks       PRTN              5                          HVB003
      *                                                                                       HVB003
     C                   Move      BRCA          PBRCA                                        HVB003
     C                   Move      CNUM          PCNUM                                        HVB003
     C                   Move      CCY           PCCY                                         HVB003
     C                   Move      ACOD          PACOD                                        HVB003
     C                   Move      ACSQ          PACSQ                                        HVB003
      *                                                                                       HVB003
      * Program written to get record from T_GXAMADEX.                                        HVB003
     C                   CALL      'MEP0100'                                                  HVB003
     C                   PARM                    PRTN                                         HVB003
     C                   PARM                    PBRCA                                        HVB003
     C                   PARM                    PCNUM                                        HVB003
     C                   PARM                    PCCY                                         HVB003
     C                   PARM                    PACOD                                        HVB003
     C                   PARM                    PACSQ                                        HVB003
     C                   PARM                    PAMAD                                        HVB003
      *                                                                                       HVB003
     C                   If        PRTN = *Blanks and                                         HVB003
     C                             TBAC = 'Y'                                                 HVB003
     C                   Eval      P0rtn = 'True'                                             HVB003
     C                   Endif                                                                HVB003
                                                                                              HVB003
     C                   Endif                                                                HVB003
                                                                                              HVB003
     C                   Endif                                                                HVB003
                                                                                              HVB003
     C                   Endif                                                                HVB003
                                                                                              HVB003
      * 103 messages and Instruction code not ZB Cashpool code                                HVB003
     C                   When      P2Mtpy = '103' and                                         HVB003
     C                             *In74 = *OFF                                               HVB003
                                                                                              HVB003
      *                                                                                       HVB003
     C                   Move      *Blanks       PIBAN                                        HVB003
     C                   Move      *Blanks       POWITH                                       HVB003
     C                   Move      *Blanks       PONOBL                                       HVB003
     C                   Move      *Blanks       P@IBAN                                       HVB003
      *                                                                                       HVB003
     C                   If        %Subst(P3DATA1:1:1) = '/'                                  HVB003
     C                   Eval      PIBAN = %Subst(P3DATA1:2:34)                               HVB003
     C                   Else                                                                 HVB003
     C                   Eval      PIBAN = %Subst(P3DATA1:1:34)                               HVB003
     C                   Endif                                                                HVB003
      *                                                                                       HVB003
     C                   CALL      'AOIBANR3'                                                 HVB003
     C                   PARM      *Blanks       P@Rtcd                                       HVB003
     C                   PARM                    PIBAN                                        HVB003
     C                   PARM                    POWITH                                       HVB003
     C     P@IBAN        PARM                    PONOBL                                       HVB003
      *                                                                                       HVB003
     C                   If        P@Rtcd = *Blanks                                           HVB003
      *                                                                                       HVB003
     C                   CALL      'AOIBANR4'                                                 HVB003
     C                   PARM      *Blanks       P@Rtcd                                       HVB003
     C                   PARM      '*KEY   '     P@Optn                                       HVB003
     C                   PARM                    P@IBAN                                       HVB003
     C     D@ACCT        PARM      *Blanks       DSSDY                                        HVB003
      *                                                                                       HVB003
     C                   If        P@Rtcd = *Blanks and                                       HVB003
     C                             RECI = 'D'                                                 HVB003
      * Check if the account is flagged for Target Balance                                    HVB003
      *                                                                                       HVB003
     C                   Move      *Blanks       PBRCA                                        HVB003
     C                   Move      *Blanks       PCNUM                                        HVB003
     C                   Move      *Blanks       PCCY                                         HVB003
     C                   Move      *Blanks       PACOD                                        HVB003
     C                   Move      *Blanks       PACSQ                                        HVB003
     C                   Move      *Blanks       PAMAD                                        HVB003
     C                   Move      *Blanks       PRTN                                         HVB003
      *                                                                                       HVB003
     C                   Move      BRCA          PBRCA                                        HVB003
     C                   Move      CNUM          PCNUM                                        HVB003
     C                   Move      CCY           PCCY                                         HVB003
     C                   Move      ACOD          PACOD                                        HVB003
     C                   Move      ACSQ          PACSQ                                        HVB003
      *                                                                                       HVB003
      * Program written to get record from T_GXAMADEX.                                        HVB003
     C                   CALL      'MEP0100'                                                  HVB003
     C                   PARM                    PRTN                                         HVB003
     C                   PARM                    PBRCA                                        HVB003
     C                   PARM                    PCNUM                                        HVB003
     C                   PARM                    PCCY                                         HVB003
     C                   PARM                    PACOD                                        HVB003
     C                   PARM                    PACSQ                                        HVB003
     C                   PARM                    PAMAD                                        HVB003
      *                                                                                       HVB003
     C                   If        PRTN = *Blanks and                                         HVB003
     C                             TBAC = 'Y'                                                 HVB003
     C                   Eval      P0rtn = 'True'                                             HVB003
     C                   Endif                                                                HVB003
                                                                                              HVB003
     C                   Endif                                                                HVB003
                                                                                              HVB003
     C                   Endif                                                                HVB003
                                                                                              HVB003
     C                   Endsl                                                                HVB003
      *                                                                                       HVB003
      *  Unwind subroutine stack name                                                         HVB003
      *                                                                                       HVB003
     C     ExTarget      TAG                                                                  HVB003
     C                   MOVEA     *BLANKS       @STK(Q)                                      HVB003
     C                   SUB       1             Q                                            HVB003
      *                                                                                       HVB003
     CSR                 ENDSR                                                                HVB003
      *****************************************************************                       MM2302
     C/EJECT                                                                                  MM0505
      *****************************************************************                       MM0505
      *                                                               *                       MM0505
      *  SrINPCOT   : Check for Input Cut off Time                    *                       MM0505
      *                                                               *                       MM0505
      *  CALLED BY: Main processing                                   *                       MM0505
      *                                                               *                       MM0505
      *****************************************************************                       MM0505
     CSR   SrINPCOT      BEGSR                                                                MM0505
      *                                                                                       MM0505
      *  Set up subroutine stack name                                                         MM0505
      *                                                                                       MM0505
     C                   ADD       1             Q                 5 0                        MM0505
     C                   MOVEL     'SrINPCOT '   @STK(Q)                                      MM0505
     C                   Eval      P0rtn = 'True'                                             MM0505
      *                                                                                       MM0505
      *  Get current time                                                                     MM0505
      *                                                                                       MM0505
     C                   TIME                    COTIME                                       MM0505
      *
      * Get Input Cut off Time for Service
      *                                                                                       MM0505
     C     KLcsdv1       Klist                                                                ESL038
     C                   Kfld                    @Mccy             3                          ESL038
     C                   Kfld                    MSBICB                                       ESL038
     C                   Eval      @Mccy = %Subst(P2data1:1:3)
      *                                                                                       ESL038
     C     KLcsdv1       CHAIN     SDLCSDD0
     C                   If        %Found
     C                   If        COHOMI > LCINCT
     C                   Eval      P0rtn = 'False'                                            MM0505
     C                   Endif
     C                   Endif
      *
      *                                                                                       MM0505
      *  Unwind subroutine stack name                                                         MM0505
      *                                                                                       MM0505
     C     ExINPCOT      TAG                                                                  MM0505
     C                   MOVEA     *BLANKS       @STK(Q)                                      MM0505
     C                   SUB       1             Q                                            MM0505
      *                                                                                       MM0505
     CSR                 ENDSR                                                                MM0505
      *****************************************************************                       MM0505
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrBBAN     : Check for BBAN                                  *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrBBAN        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrBBAN   '   @STK(Q)
      *
      *  Test first character is for an account
      *
     C                   If        %Subst(P2Data1:1:1) = '/'
     C                   Eval      P0rtn = 'True'
     C                   Else
     C                   Eval      P0rtn = 'False'
     C                   Endif
      *
      *  Now check for country set up
      *
     C                   If        P0rtn = 'True'
      *
     C                   Eval      A4ISOC = %Subst(MsTest:6:2)
      *
     C                   If        A4ISOC = 'SW'
     C                   Eval      A4ISOC = 'CH'
     C                   Endif
      *
     C     KCtryL2       Chain     @CtryL2
      * If not found then false
     C                   If        Not %Found
     C                   Eval      P0rtn = 'False'
     C                   Else

     C                   Eval      O#IBAN = A4ISOC + 'XX' + %Subst(P2Data1:2:30)
     C                   Call      'AOIBANR5'
     C                   Parm      *blanks       P@Rtcd            7
     C                   Parm                    O#IBAN           34

      * If not blank then invalid
     C                   If        P@Rtcd <> *blanks and P@Rtcd = '5'
     C                   Eval      P0rtn = 'False'
     C                   Endif

     C                   Endif

     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExBBAN        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrQuote    : Check for Quote                                 *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrQuote       BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrQuote  '   @STK(Q)
      *
     C                   Clear                   P3parm
     C                   Eval      P3Data1 = MsTstD
     C                   Eval      P0rtn = 'True'
      *
      *  Unwind subroutine stack name
      *
     C     ExQuote       TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrNotEurope: The three BICS are in Europe                    *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrEurope      BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrEurope'    @STK(Q)
      *
      *  Check if first BIC is in Europe
      *
     C                   Eval      M3Isoc = %subst(P2Data1:5:2)
      *
     C     KIsocL1       Klist
     C                   Kfld                    M3Isoc
      *
     C     KIsocL1       Chain     @IsocL1
      * If not found then false
     C                   If        Not %Found
     C                             Or %Found and M3Scht = 'N'
     C                   Eval      P0rtn = 'False'
     C                   Else
      *
      *  Check if second BIC is in Europe
      *
     C                   Eval      M3Isoc = %subst(P2Data2:5:2)
      *
     C     KIsocL1       Chain     @IsocL1
      * If not found then false
     C                   If        Not %Found
     C                             Or %Found and M3Scht = 'N'
     C                   Eval      P0rtn = 'False'
     C                   Else
     C                   If        P2Data3 <> *blanks
      *
      *  Check if third BIC is in Europe
      *
     C                   Eval      M3Isoc = %subst(P2Data3:5:2)
      *
     C     KIsocL1       Chain     @IsocL1
      * If not found then false
     C                   If        Not %Found
     C                             Or %Found and M3Scht = 'N'
     C                   Eval      P0rtn = 'False'
     C                   Else
     C                   Eval      P0rtn = 'True'
     C                   Endif
     C                   Else
     C                   Eval      P0rtn = 'True'
     C                   Endif
     C                   Endif
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExEurope      TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrInit   : Initialise and define fields                      *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrInit        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      * Get Rundate - Rundate  *
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT            7            Midas Run date
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
      *
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      *
      *  Unwind subroutine stack name
      *
     C     EXINIT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

      * Define key
     C     KBicdL2       Klist                                                  IF
     C                   Kfld                    BDBICC                         IF
     C                   Kfld                    BDBICB                         IF
      *
     CSR                 ENDSR
      *****************************************************************
      /EJECT
      *================================================================
      *
      * File and Program Error Processing
      *
     C/COPY MECPYSRC,SRERRC_ILE
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
