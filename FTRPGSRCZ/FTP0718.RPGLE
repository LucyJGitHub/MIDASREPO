     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Test route is STP/LVP/REG capable')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTP0718 - Midas FT Test route is STP/LVP/REG capable         *
      *                                                               *
      *  (C) Copyright Misys International Banking Systems 2004       *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. HVB003             Date 19Oct2011             *
      *                 AR856737           Date 15Jul2011             *
      *                 MM2302             Date 23Feb2006             *
      *                 CRC001             Date 10Jun2005             *
      *                 PNL014             Date 08dec2005             *
      *                 MM0505             Date 04May2005             *
      *                 ESL038             Date 18Jan2005             *
      *                 EEE065   *CREATE   Date 15Jun2004             *
      * Midas Release 4 --------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  HVB003 - Routing for Target Balance payments                 *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level.     *
      *             Renamed QQDFAC field in SDBRCHPD                  *
      *  MM2302 - Add check for Urgent message                        *
      *  CRC001 - Change O@KNR to CHAR for chain to SDCUSTY1          *
      *  PNL014 - Time Sensitive Payments                             *
      *  MM0505 - Add Value Date to Routing                           *
      *  ESL038 - Conversion to use general routing for 54            *
      *  EEE065 - FT Payment Routing                                  *
      *                                                               *
      *****************************************************************
     FFTMSTPV1  IF   E           K DISK
     F                                     INFDS(INFDS1)
     F                                     INFSR(SRFILE)
      * RTV : Midas FT SWIFT Correspondent STP Req.
      *
     FFTMSTRV1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : Midas FT SWIFT Correspondent STP Req. Details
      *
      *                                                                                      MM2302
     FMEINCRL1  IF   E           K DISK                                                      MM2302
      *                                                                                      MM2302
      *  Midas ME I.M Control Retrieval index                                                MM2302
      *                                                                                      MM2302
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
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFA1        E                     EXTFLD(QQDFAC)                                  AR856737
      *
      * Branch details Structure *
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  ESL038
      *                                                                                       ESL038
      * Customer details Structure *                                                          ESL038
                                                                                              ESL038
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      * Bank details Structure *
      *
      *
     D DsBICD        E DS                  EXTNAME(MEBICDPD)
      *
      * SWIFT Details          *
      *
     D P1Parm        E DS                  EXTNAME(FTMROTP0)
      * Routing details        *
      *
     D O1Parm        E DS                  EXTNAME(FTMSTRP0)
      * Requirement details    *
      *
     D O2PARM          DS           256
      * Incoming data
     D  O2DATA1                1     35
     D  O2DATA2               36     70
     D  O2DATA3               71    105
     D  O2DATA4              106    140
     D  O2DATA5              141    175
     D  O2DATA6              176    210
     D  O2DATA7                1      1                                                      MM2302
      *
     D O3PARM          DS           256
      * Incoming data
     D  O3DATA1                1     35
     D  O3DATA2               36     70
     D  O3DATA3               71    105
     D  O3DATA4              106    140
     D  O3DATA5              141    175
     D  O3DATA6              176    210
      *                                                                                      HVB003
     D INSTRC          DS           140                                                      HVB003
      * Instruction Codes                                                                    HVB003
     D  I2INSC1                1     35                                                      HVB003
     D  I2INSC2               36     70                                                      HVB003
     D  I2INSC3               71    105                                                      HVB003
     D  I2INSC4              106    140                                                      HVB003
      *
     D W#Valid         S              7
     D W#PerCent       S             11S 3
     D W#Quote         S             35
     D S#Mtag          S                   Like(MsMtag)
     D S#Tseq          S                   Like(MsTseq)
      *
     D MVDATE          S              5P 0                                                    MM0505

      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P0Action          3
     C                   PARM                    P1Parm
     C                   PARM                    MVDATE                                       MM0505
      *
      *  Set up primary reference
      *
     C                   Clear                   P0Rtn
     C                   MOVEL     'Validate'    W0PREF

     C                   Exsr      SrInit

     C                   Select
                                                                                              ESL038
      * See if Services Regulated Payment                                                     ESL038
     C                   When      P0Action = 'SRG'                                           ESL038
     C                   Exsr      SrSRGr                                                     ESL038
      * See if Regulated Payment
     C                   When      P0Action = 'REG'
     C                   Exsr      SrREGr

      * See if STP route
     C                   When      P0Action = 'STP'
     C                   Exsr      SrSTPr

      * See if LVP route
     C                   When      P0Action = 'LVP'
     C                   Exsr      SrLVPr
     C                   Endsl

      * Exit, do not close down
     C                   Return
      *
     C/EJECT                                                                                  ESL038
      *****************************************************************                       ESL038
      *                                                               *                       ESL038
      *  SrSrgr     : Check for Services Regulated Route              *                       ESL038
      *                                                               *                       ESL038
      *  CALLED BY: Main processing                                   *                       ESL038
      *                                                               *                       ESL038
      *****************************************************************                       ESL038
     CSR   SrSrgr        BEGSR                                                                ESL038
      *                                                                                       ESL038
      *  Set up subroutine stack name                                                         ESL038
      *                                                                                       ESL038
     C                   ADD       1             Q                 5 0                        ESL038
     C                   MOVEL     'SrRegr  '    @STK(Q)                                      ESL038
      *                                                                                       ESL038
     C                   Eval      MSBicc =  'SERVICES'                                       ESL038
     C                   Eval      MSBicb =  MoPvas                                           ESL038
     C                   Eval      MSLvpa = 'N'                                               ESL038
     C                   Eval      MSRegp = 'Y'                                               ESL038
      * Set as invalid                                                                        ESL038
     C                   Eval      W#Valid = 'False'                                          ESL038
     C                   Clear                   W#Quote                                      ESL038
     C                   Eval      MoRegF = 'N'                                               ESL038
      *                                                                                       ESL038
     C     KMstpV1       Chain     @MStpV1                                                    ESL038
      * If found then process                                                                 ESL038
     C                   If        %Found                                                     ESL038
      * Set as OK                                                                             ESL038
     C                   Eval      W#Valid = 'True'                                           ESL038
     C                   Eval      MoRegF = 'Y'                                               ESL038
      *                                                                                       ESL038
      * If 103+ then test for it                                                              ESL038
     C                   If        MS103p = 'Y'                                               ESL038
     C                   Exsr      Sr103p                                                     ESL038
     C                   If        W#Valid = 'False'                                          ESL038
     C                   Eval      MoRegf = 'N'                                               ESL038
     C                   Goto      ExSrgr                                                     ESL038
     C                   Endif                                                                ESL038
     C                   Endif                                                                ESL038
      *                                                                                       ESL038
     C                   Eval      MSBicc =  'SERVICES'                                       ESL038
     C                   Eval      MSBicb =  MoPvas                                           ESL038
     C                   Eval      MSLvpa = 'N'                                               ESL038
     C                   Eval      MSRegp = 'Y'                                               ESL038
     C                   Clear                   MSMtag                                       ESL038
     C                   Clear                   MSTseq                                       ESL038
      *                                                                                       ESL038
     C     KMstrV1p      Setll     @MStrV1                                                    ESL038
     C     KMstrV1r      Reade     @MStrV1                                90                  ESL038
     C                   If        *In90 = *Off                                               ESL038
     C                   Dou       *In90 = *On                                                ESL038
                                                                                              ESL038
      * Process record read                                                                   ESL038
     C                   Exsr      SrVReq                                                     ESL038
                                                                                              ESL038
      * Save previous setting                                                                 ESL038
     C                   Eval      S#Mtag = MsMtag                                            ESL038
     C                   Eval      S#Tseq = MsTseq                                            ESL038
                                                                                              ESL038
     C     KMstrV1r      Reade     @MStrV1                                90                  ESL038
      * Leave if end of set                                                                   ESL038
     C                   If        *In90 = *On                                                ESL038
                                                                                              ESL038
      * If last condition is false then set to fail                                           ESL038
     C                   If        W#Valid = 'False'                                          ESL038
     C                   Eval      MoRegF = 'N'                                               ESL038
     C                   Endif                                                                ESL038
     C                   Leave                                                                ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
      * Tag has changed and previous condition is false                                       ESL038
     C                   If        W#Valid = 'False'                                          ESL038
     C                             and S#Mtag <> MsMtag                                       ESL038
     C                   Eval      MoRegF = 'N'                                               ESL038
     C                   Leave                                                                ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
      * Tag is the same and first character is the same                                       ESL038
     C                   If        W#Valid = 'False'                                          ESL038
     C                             and S#Mtag = MsMtag                                        ESL038
     C                             and %subst(S#Tseq:1:1) = %subst(MsTseq:1:1)                ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
      * Tag is the same and first character is not                                            ESL038
     C                   If        W#Valid = 'True'                                           ESL038
     C                             and S#Mtag = MsMtag                                        ESL038
     C                             and %subst(S#Tseq:1:1) <> %subst(MsTseq:1:1)               ESL038
                                                                                              ESL038
      * Read until tag changes or end of set                                                  ESL038
     C                   Dou       *In90 = *On                                                ESL038
     C                             or  S#Mtag <> MsMtag                                       ESL038
     C     KMstrV1r      Reade     @MStrV1                                90                  ESL038
      * Leave if end of set                                                                   ESL038
     C                   If        *In90 = *On                                                ESL038
     C                   Leave                                                                ESL038
     C                   Endif                                                                ESL038
     C                   Enddo                                                                ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
      * Tag is the same and new set then start with True                                      ESL038
     C                   If        W#Valid = 'False'                                          ESL038
     C                             and S#Mtag = MsMtag                                        ESL038
     C                             and %subst(S#Tseq:1:1) <> %subst(MsTseq:1:1)               ESL038
     C                   Eval      W#Valid = 'True'                                           ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
     C                   Enddo                                                                ESL038
     C                   Endif                                                                ESL038
     C                   Endif                                                                ESL038
      *                                                                                       ESL038
      * If Regulated Payment and quote set up, change bank to bank                            ESL038
     C                   If        MoRegF = 'Y' and W#Quote <> *blanks                        ESL038
     C                   Eval      MoBtBi = W#quote                                           ESL038
     C                   Endif                                                                ESL038
      *                                                                                       ESL038
      *  Unwind subroutine stack name                                                         ESL038
      *                                                                                       ESL038
     C     ExSrgr        TAG                                                                  ESL038
     C                   MOVEA     *BLANKS       @STK(Q)                                      ESL038
     C                   SUB       1             Q                                            ESL038
      *                                                                                       ESL038
     CSR                 ENDSR                                                                ESL038
      *****************************************************************                       ESL038
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrRegr     : Check for Regulated Route                       *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrRegr        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrRegr  '    @STK(Q)
      *
     C                   Eval      MSBicc =  %Subst(MoDstr:1:8)
     C                   Eval      MSBicb =  %Subst(MoDstr:9:3)
     C                   Eval      MSLvpa = 'N'
     C                   Eval      MSRegp = 'Y'
      * Set as invalid
     C                   Eval      W#Valid = 'False'
     C                   Clear                   W#Quote
     C                   Eval      MoRegF = 'N'
      *
     C     KMstpV1       Chain     @MStpV1
      * If found then process
     C                   If        %Found
      * Set as OK
     C                   Eval      W#Valid = 'True'
     C                   Eval      MoRegF = 'Y'
      *
      * If 103+ then test for it
     C                   If        MS103p = 'Y'
     C                   Exsr      Sr103p
     C                   If        W#Valid = 'False'
     C                   Eval      MoRegf = 'N'
     C                   Goto      ExRegr
     C                   Endif
     C                   Endif
      *
      * Check for default Regulated 103+ then test for it
     C                   Exsr      Sr103pReg
     C                   If        W#Valid = 'False'
     C                   Eval      MoRegf = 'N'
     C                   Goto      ExRegr
     C                   Endif
      *
     C                   Eval      MSBicc =  %Subst(MoDstr:1:8)
     C                   Eval      MSBicb =  %Subst(MoDstr:9:3)
     C                   Eval      MSLvpa = 'N'
     C                   Eval      MSRegp = 'Y'
     C                   Clear                   MSMtag
     C                   Clear                   MSTseq
      *
     C     KMstrV1p      Setll     @MStrV1
     C     KMstrV1r      Reade     @MStrV1                                90
     C                   If        *In90 = *Off
     C                   Dou       *In90 = *On

      * Process record read
     C                   Exsr      SrVReq

      * Save previous setting
     C                   Eval      S#Mtag = MsMtag
     C                   Eval      S#Tseq = MsTseq

     C     KMstrV1r      Reade     @MStrV1                                90
      * Leave if end of set
     C                   If        *In90 = *On

      * If last condition is false then set to fail
     C                   If        W#Valid = 'False'
     C                   Eval      MoRegF = 'N'
     C                   Endif
     C                   Leave
     C                   Endif

      * Tag has changed and previous condition is false
     C                   If        W#Valid = 'False'
     C                             and S#Mtag <> MsMtag
     C                   Eval      MoRegF = 'N'
     C                   Leave
     C                   Endif

      * Tag is the same and first character is the same
     C                   If        W#Valid = 'False'
     C                             and S#Mtag = MsMtag
     C                             and %subst(S#Tseq:1:1) = %subst(MsTseq:1:1)
     C*********          Eval      MoRegF = 'N'
     C                   Endif

      * Tag is the same and first character is not
     C                   If        W#Valid = 'True'
     C                             and S#Mtag = MsMtag
     C                             and %subst(S#Tseq:1:1) <> %subst(MsTseq:1:1)

      * Read until tag changes or end of set
     C                   Dou       *In90 = *On
     C                             or  S#Mtag <> MsMtag
     C     KMstrV1r      Reade     @MStrV1                                90
      * Leave if end of set
     C                   If        *In90 = *On
     C                   Leave
     C                   Endif
     C                   Enddo
     C                   Endif

      * Tag is the same and new set then start with True
     C                   If        W#Valid = 'False'
     C                             and S#Mtag = MsMtag
     C                             and %subst(S#Tseq:1:1) <> %subst(MsTseq:1:1)
     C                   Eval      W#Valid = 'True'
     C                   Endif

     C                   Enddo
     C                   Endif
     C                   Endif
      *
      * If Regulated Payment and quote set up, change bank to bank
     C                   If        MoRegF = 'Y' and W#Quote <> *blanks
     C                   Eval      MoBtBi = W#quote
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExRegr        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrSTPr     : Check for STP Route information                 *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrSTPr        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrSTPr  '    @STK(Q)
      *
     C                   Eval      MSBicc =  %Subst(MoDstr:1:8)
     C                   Eval      MSBicb =  %Subst(MoDstr:9:3)
     C                   Eval      MSLvpa = 'N'
     C                   Eval      MSRegp = 'N'
      * Set as invalid
     C                   Eval      W#Valid = 'False'
     C                   Clear                   W#Quote
     C                   Eval      MoStpF = 'N'
      *
     C     KMstpV1       Chain     @MStpV1
     C                   Select
      * If not found then check against Mt103+
     C                   When      Not %Found
      * Set as OK
     C                   Eval      W#Valid = 'True'
     C                   Eval      MoStpF = 'Y'
      *
      * Test 103+ as default
     C                   Exsr      Sr103p
     C                   If        W#Valid = 'False'
     C                   Eval      MoStpF = 'N'
     C                   Goto      ExSTPr
     C                   Endif
      * If found then process
     C                   When      %Found
      * Set as OK
     C                   Eval      W#Valid = 'True'
     C                   Eval      MoStpF = 'Y'
      *
      * If 103+ then test for it
     C                   If        MS103p = 'Y'
     C                   Exsr      Sr103p
     C                   If        W#Valid = 'False'
     C                   Eval      MoStpF = 'N'
     C                   Goto      ExSTPr
     C                   Endif
     C                   Endif
      *
     C                   Eval      MSBicc =  %Subst(MoDstr:1:8)
     C                   Eval      MSBicb =  %Subst(MoDstr:9:3)
     C                   Eval      MSLvpa = 'N'
     C                   Eval      MSRegp = 'N'
     C                   Clear                   MSMtag
     C                   Clear                   MSTseq
      *
     C     KMstrV1p      Setll     @MStrV1
     C     KMstrV1r      Reade     @MStrV1                                90
     C                   If        *In90 = *Off
     C                   Dou       *In90 = *On

      * Process record read
     C                   Exsr      SrVReq

      * Save previous setting
     C                   Eval      S#Mtag = MsMtag
     C                   Eval      S#Tseq = MsTseq

     C     KMstrV1r      Reade     @MStrV1                                90
      * Leave if end of set
     C                   If        *In90 = *On

      * If last condition is false then set to fail
     C                   If        W#Valid = 'False'
     C                   Eval      MoStpF = 'N'
     C                   Endif
     C                   Leave
     C                   Endif

      * Tag has changed and previous condition is false
     C                   If        W#Valid = 'False'
     C                             and S#Mtag <> MsMtag
     C                   Eval      MoStpF = 'N'
     C                   Leave
     C                   Endif

      * Tag is the same and first character is the same
     C                   If        W#Valid = 'False'
     C                             and S#Mtag = MsMtag
     C                             and %subst(S#Tseq:1:1) = %subst(MsTseq:1:1)
     C******             Eval      MoStpF = 'N'
     C                   Endif

      * Tag is the same and first character is not
     C                   If        W#Valid = 'True'
     C                             and S#Mtag = MsMtag
     C                             and %subst(S#Tseq:1:1) <> %subst(MsTseq:1:1)

      * Read until tag changes or end of set
     C                   Dou       *In90 = *On
     C                             or  S#Mtag <> MsMtag
     C     KMstrV1r      Reade     @MStrV1                                90
      * Leave if end of set
     C                   If        *In90 = *On
     C                   Leave
     C                   Endif
     C                   Enddo
     C                   Endif

      * Tag is the same and new set then start with True
     C                   If        W#Valid = 'False'
     C                             and S#Mtag = MsMtag
     C                             and %subst(S#Tseq:1:1) <> %subst(MsTseq:1:1)
     C                   Eval      W#Valid = 'True'
     C                   Endif

     C                   Enddo
     C                   Endif
     C                   Endsl
      *
      * If STP Payment and quote set up, change bank to bank
     C                   If        MoStpF = 'Y' and W#Quote <> *blanks
     C                   Eval      MoBtBi = W#quote
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExSTPr        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrLVPr     : Check for LVP Route information                 *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrLVPr        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrLVPr  '    @STK(Q)
      *
     C                   Eval      MSBicc =  %Subst(MoDstr:1:8)
     C                   Eval      MSBicb =  %Subst(MoDstr:9:3)
     C                   Eval      MSLvpa = 'Y'
     C                   Eval      MSRegp = 'N'
      * Set as invalid
     C                   Eval      W#Valid = 'False'
     C                   Clear                   W#Quote
     C                   Eval      MoLvpF = 'N'
      *
     C     KMstpV1       Chain     @MStpV1
      * If found then process
     C                   If        %Found
      * Set as OK
     C                   Eval      W#Valid = 'True'
     C                   Eval      MoLvpF = 'Y'
      *
      * If 103+ then test for it
     C                   If        MS103p = 'Y'
     C                   Exsr      Sr103p
     C                   If        W#Valid = 'False'
     C                   Eval      MoLvpF = 'N'
     C                   Goto      ExLvpr
     C                   Endif
     C                   Endif
      *
     C                   Eval      MSBicc =  %Subst(MoDstr:1:8)
     C                   Eval      MSBicb =  %Subst(MoDstr:9:3)
     C                   Eval      MSLvpa = 'Y'
     C                   Eval      MSRegp = 'N'
     C                   Clear                   MSMtag
     C                   Clear                   MSTseq
      *
     C     KMstrV1p      Setll     @MStrV1
     C     KMstrV1r      Reade     @MStrV1                                90
     C                   If        *In90 = *Off
     C                   Dou       *In90 = *On

      * Process record read
     C                   Exsr      SrVReq

      * Save previous setting
     C                   Eval      S#Mtag = MsMtag
     C                   Eval      S#Tseq = MsTseq

     C     KMstrV1r      Reade     @MStrV1                                90
      * Leave if end of set
     C                   If        *In90 = *On

      * If last condition is false then set to fail
     C                   If        W#Valid = 'False'
     C                   Eval      MoLvpF = 'N'
     C                   Endif
     C                   Leave
     C                   Endif

      * Tag has changed and previous condition is false
     C                   If        W#Valid = 'False'
     C                             and S#Mtag <> MsMtag
     C                   Eval      MoLvpF = 'N'
     C                   Leave
     C                   Endif

      * Tag is the same and first character is the same
     C                   If        W#Valid = 'False'
     C                             and S#Mtag = MsMtag
     C                             and %subst(S#Tseq:1:1) = %subst(MsTseq:1:1)
     C*********          Eval      MoLvpF = 'N'
     C                   Endif

      * Tag is the same and first character is not
     C                   If        W#Valid = 'True'
     C                             and S#Mtag = MsMtag
     C                             and %subst(S#Tseq:1:1) <> %subst(MsTseq:1:1)

      * Read until tag changes or end of set
     C                   Dou       *In90 = *On
     C                             or  S#Mtag <> MsMtag
     C     KMstrV1r      Reade     @MStrV1                                90
      * Leave if end of set
     C                   If        *In90 = *On
     C                   Leave
     C                   Endif
     C                   Enddo
     C                   Endif

      * Tag is the same and new set then start with True
     C                   If        W#Valid = 'False'
     C                             and S#Mtag = MsMtag
     C                             and %subst(S#Tseq:1:1) <> %subst(MsTseq:1:1)
     C                   Eval      W#Valid = 'True'
     C                   Endif

     C                   Enddo
     C                   Endif
     C                   Endif
      *
      * If STP Payment and quote set up, change bank to bank
     C                   If        MoLvpF = 'Y' and W#Quote <> *blanks
     C                   Eval      MoBtBi = W#quote
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExLVPr        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  Sr103p     : Check for 103 Plus                              *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   Sr103p        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'Sr103p  '    @STK(Q)
      *
     C                   Eval      MSBicc =  'MT103+'
     C                   Eval      MSBicb =  *blanks
     C                   Eval      MSLvpa = 'N'
     C                   Eval      MSRegp = 'N'
      * Set as invalid
     C                   Eval      W#Valid = 'False'
     C                   Clear                   W#Quote
      *
     C     KMstpV1       Chain     @MStpV1
      * If found then process
     C                   If        %Found
      * Set as OK
     C                   Eval      W#Valid = 'True'
      *
     C                   Eval      MSBicc =  'MT103+'
     C                   Eval      MSBicb =  *blanks
     C                   Eval      MSLvpa = 'N'
     C                   Eval      MSRegp = 'N'
     C                   Clear                   MSMtag
     C                   Clear                   MSTseq
      *
     C     KMstrV1p      Setll     @MStrV1
     C     KMstrV1r      Reade     @MStrV1                                90
     C                   If        *In90 = *Off
     C                   Dou       *In90 = *On

      * Process record read
     C                   Exsr      SrVReq

      * Save previous setting
     C                   Eval      S#Mtag = MsMtag
     C                   Eval      S#Tseq = MsTseq

     C     KMstrV1r      Reade     @MStrV1                                90
      * Leave if end of set
     C                   If        *In90 = *On

      * If last condition is false then set to fail
     C                   If        W#Valid = 'False'
     C                   Endif
     C                   Leave
     C                   Endif

      * Tag has changed and previous condition is false
     C                   If        W#Valid = 'False'
     C                             and S#Mtag <> MsMtag
     C                   Leave
     C                   Endif

      * Tag is the same and first character is the same
     C                   If        W#Valid = 'False'
     C                             and S#Mtag = MsMtag
     C                             and %subst(S#Tseq:1:1) = %subst(MsTseq:1:1)
     C                   Endif

      * Tag is the same and first character is not
     C                   If        W#Valid = 'True'
     C                             and S#Mtag = MsMtag
     C                             and %subst(S#Tseq:1:1) <> %subst(MsTseq:1:1)

      * Read until tag changes or end of set
     C                   Dou       *In90 = *On
     C                             or  S#Mtag <> MsMtag
     C     KMstrV1r      Reade     @MStrV1                                90
      * Leave if end of set
     C                   If        *In90 = *On
     C                   Leave
     C                   Endif
     C                   Enddo
     C                   Endif

      * Tag is the same and new set then start with True
     C                   If        W#Valid = 'False'
     C                             and S#Mtag = MsMtag
     C                             and %subst(S#Tseq:1:1) <> %subst(MsTseq:1:1)
     C                   Eval      W#Valid = 'True'
     C                   Endif

     C                   Enddo
     C                   Endif
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     Ex103p        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  Sr103pReg  : Check for 103 Plus Regulated Payment            *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   Sr103pReg     BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'Sr103pReg'   @STK(Q)
      *
     C                   Eval      MSBicc =  'MT103+'
     C                   Eval      MSBicb =  *blanks
     C                   Eval      MSLvpa = 'N'
     C                   Eval      MSRegp = 'Y'
      * Set as valid  as if not found not a problem
     C                   Eval      W#Valid = 'True'
     C                   Clear                   W#Quote
      *
     C     KMstpV1       Chain     @MStpV1
      * If found then process
     C                   If        %Found
      * Set as OK
     C                   Eval      W#Valid = 'True'
      *
     C                   Eval      MSBicc =  'MT103+'
     C                   Eval      MSBicb =  *blanks
     C                   Eval      MSLvpa = 'N'
     C                   Eval      MSRegp = 'Y'
     C                   Clear                   MSMtag
     C                   Clear                   MSTseq
      *
     C     KMstrV1p      Setll     @MStrV1
     C     KMstrV1r      Reade     @MStrV1                                90
     C                   If        *In90 = *Off
     C                   Dou       *In90 = *On

      * Process record read
     C                   Exsr      SrVReq

      * Save previous setting
     C                   Eval      S#Mtag = MsMtag
     C                   Eval      S#Tseq = MsTseq

     C     KMstrV1r      Reade     @MStrV1                                90
      * Leave if end of set
     C                   If        *In90 = *On

      * If last condition is false then set to fail
     C                   If        W#Valid = 'False'
     C                   Endif
     C                   Leave
     C                   Endif

      * Tag has changed and previous condition is false
     C                   If        W#Valid = 'False'
     C                             and S#Mtag <> MsMtag
     C                   Leave
     C                   Endif

      * Tag is the same and first character is the same
     C                   If        W#Valid = 'False'
     C                             and S#Mtag = MsMtag
     C                             and %subst(S#Tseq:1:1) = %subst(MsTseq:1:1)
     C                   Endif

      * Tag is the same and first character is not
     C                   If        W#Valid = 'True'
     C                             and S#Mtag = MsMtag
     C                             and %subst(S#Tseq:1:1) <> %subst(MsTseq:1:1)

      * Read until tag changes or end of set
     C                   Dou       *In90 = *On
     C                             or  S#Mtag <> MsMtag
     C     KMstrV1r      Reade     @MStrV1                                90
      * Leave if end of set
     C                   If        *In90 = *On
     C                   Leave
     C                   Endif
     C                   Enddo
     C                   Endif

      * Tag is the same and new set then start with True
     C                   If        W#Valid = 'False'
     C                             and S#Mtag = MsMtag
     C                             and %subst(S#Tseq:1:1) <> %subst(MsTseq:1:1)
     C                   Eval      W#Valid = 'True'
     C                   Endif

     C                   Enddo
     C                   Endif
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     Ex103pReg     TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrVReq     : Validate Requirement                            *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrVReq        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrVreq  '    @STK(Q)
      *
     C                   Clear                   O2Parm
     C                   Clear                   O3Parm
      * Set up parameters depending on field to be verified
     C                   Select
     C                   When      MsMtag = ':23B:'
     C                   Eval      O2Parm = MoBnkc
     C                   When      MsMtag = ':23E:'
     C                   Eval      O2Parm = MoInsc
     C                   When      MsMtag = ':26T:'
     C                   Eval      O2Parm = MoTtyp
     C                   When      MsMtag = ':32A:'
     C                   Eval      O2Parm = MoPccy
     C                   When      MsMtag = ':50K:'
     C                   Eval      O2Parm = MoOrdc
     C                   When      MsMtag = ':50A:'
     C                   Eval      O2Parm = MoOrdc
     C                   When      MsMtag = ':52A:'
     C                   Eval      O2Parm = MoOrdb
     C                   When      MsMtag = ':52D:'
     C                   Eval      O2Parm = MoOrdb
     C                   When      MsMtag = ':53A:'
     C                   If        %Subst(MoSncd:1:1) = '/'
     C                   Eval      O2Parm = MoSncd + MoSncr
     C                   Else
     C                   Eval      O2Parm = MoSncr
     C                   Endif
     C                   When      MsMtag = ':53D:'
     C                   If        %Subst(MoSncd:1:1) = '/'
     C                   Eval      O2Parm = MoSncd + MoSncr
     C                   Else
     C                   Eval      O2Parm = MoSncr
     C                   Endif
     C                   When      MsMtag = ':54A:'
     C                   If        %Subst(MoRccd:1:1) = '/'
     C                   Eval      O2Parm = MoRccd + MoRccr
     C                   Else
     C                   Eval      O2Parm = MoRccr
     C                   Endif
     C                   When      MsMtag = ':54D:'
     C                   If        %Subst(MoRccd:1:1) = '/'
     C                   Eval      O2Parm = MoRccd + MoRccr
     C                   Else
     C                   Eval      O2Parm = MoRccr
     C                   Endif
     C                   When      MsMtag = ':55A:'
     C                   When      MsMtag = ':55D:'
     C                   When      MsMtag = ':56A:'
     C                   If        %Subst(MoIntd:1:1) = '/'
     C                   Eval      O2Parm = MoIntd + MoIntr
     C                   Else
     C                   Eval      O2Parm = MoIntr
     C                   Endif
     C                   When      MsMtag = ':56D:'
     C                   If        %Subst(MoIntd:1:1) = '/'
     C                   Eval      O2Parm = MoIntd + MoIntr
     C                   Else
     C                   Eval      O2Parm = MoIntr
     C                   Endif
     C                   When      MsMtag = ':57A:'
     C                   If        %Subst(MoAcbd:1:1) = '/'
     C                   Eval      O2Parm = MoAcbd + MoAcbr
     C                   Else
     C                   Eval      O2Parm = MoAcbr
     C                   Endif
     C                   When      MsMtag = ':57D:'
     C                   If        %Subst(MoAcbd:1:1) = '/'
     C                   Eval      O2Parm = MoAcbd + MoAcbr
     C                   Else
     C                   Eval      O2Parm = MoAcbr
     C                   Endif
     C                   When      MsMtag = ':59: '
     C                   Eval      O2Parm = MoBenf
     C                   When      MsMtag = ':59A:'
     C                   Eval      O2Parm = MoBenf
     C                   When      MsMtag = ':71A:'
     C                   Eval      O2Data1 = MoDtch
     C                   When      MsMtag = ':71G:'
     C                   Eval      O2Parm = MoOchg
     C                   When      MsMtag = ':72: '
     C                   Eval      O2Parm = MoBtbi
     C                   Endsl
      *
     C                   Select
                                                                                              ESL038
     C                   When      MsTest = 'BIC' and MsMtag = ':52A:'                        ESL038
     C                             and %Subst(moOrdb:11:165) = *blanks                        ESL038
     C                             Or                                                         ESL038
     C                             MsTest = 'BIC' and MsMtag = ':52D:'                        ESL038
     C                             and %Subst(moOrdb:11:165) = *blanks                        ESL038
                                                                                              ESL038
     C                   Eval      P@Key1 = %Subst(moOrdb:1:10)                               ESL038
                                                                                              ESL038
     C                   Call      'AOCUSTR0'                                                 ESL038
     C                   Parm      *blanks       P@RTCD            7            B:Return code ESL038
     C                   Parm      '*KEY'        P@OPTN            7            I:Option      ESL038
     C                   Parm                    P@KEY1           10            I:Key field   ESL038
     C                   Parm                    P@KYST            7            O:Key status  ESL038
     C     SDCUST        Parm                    DSSDY                          O:Format      ESL038
                                                                                              ESL038
      * If Swift then use                                                                     ESL038
     C                   Select                                                               ESL038
     C                   When      P@Rtcd = *blanks                                           ESL038
     C                             and BBCSID <> *blanks                                      ESL038
     C                   Eval      O2Parm = BBCSID                                            ESL038
     C                   When      P@Rtcd = *blanks                                           ESL038
     C                             and BBCUST = '100032'                                      ESL038
     C                   Eval      O2Parm = 'PKOPPLPWXXX'                                     ESL038
     C                   Endsl                                                                ESL038
                                                                                              ESL038
     C                   When      MsTest = 'EUROPE'
     C                             Or MsTest = 'NOT EUROPE'

      * Get branch details
      *
     C                   CALL      'AOBRCHR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      MoBRCA        P@BRCA            3            I:Branch
     C     SDBRCH        PARM      *BLANKS       DSSDY
      *
     C                   If        P@RTCD <> *blanks
     C                   Eval      O2Data1 = *blanks
     C                   Else
     C                   Eval      O2Data1 = %Subst(A8Btid:1:8) +
     C                                       %Subst(A8Btid:10:3)
     C                   Endif

     C                   Eval      O2Data2 = MoDstr
     C                   Eval      O2Data3 = MoAcbr
     C                   When      MsTest = 'BIC IBAN'
     C                   Eval      O3Parm = MoBenf
                                                                                              MM2302
     C                   When      MsTest = 'NORMAL'                                         MM2302
                                                                                             MM2302
     C                   IF        MOMSGR <> 0                                               MM2302
     C     MOMSGR        CHAIN     @INCRL1                                                   MM2302
     C                   IF        %FOUND                                                    MM2302
     C                   MOVE      CRMPRY        O2DATA7                                     MM2302
     C                   ELSE                                                                MM2302
     C                   MOVE      'N'           O2DATA7                                     MM2302
     C                   ENDIF                                                               MM2302
     C                   ELSE                                                                MM2302
     C                   MOVE      'N'           O2DATA7                                     MM2302
     C                   ENDIF                                                               MM2302
                                                                                             MM2302
                                                                                             HVB003
     C                   When      MsTest = 'TARGET'                                         HVB003
                                                                                             HVB003
     C                   Clear                   Instrc                                      HVB003
     C                   Clear                   O2PARM                                      HVB003
     C                   Clear                   O3PARM                                      HVB003
     C                   If        MOMSGR <> 0                                               HVB003
     C     MOMSGR        CHAIN     @INCRL1                                                   HVB003
     C                   If        %FOUND                                                    HVB003
     C                   Movel     CRSNDR        O2DATA1                                     HVB003
     C                   Movel     CRMTPY        O2DATA2                                     HVB003
     C                   Movel     MoInsc        Instrc                                      HVB003
     C                   Movel     I2Insc1       O2DATA3                                     HVB003
     C                   Movel     I2Insc2       O2DATA4                                     HVB003
     C                   Movel     I2Insc3       O2DATA5                                     HVB003
     C                   Movel     I2Insc4       O2DATA6                                     HVB003
                                                                                             HVB003
     C                   Select                                                              HVB003
                                                                                             HVB003
     C                   When      CRMTPY = 'IN3'                                            HVB003
     C                   Eval      O3Parm = MoOrdc                                           HVB003
     C                   When      CRMTPY = '103'                                            HVB003
     C                   Eval      O3Parm = MoBenf                                           HVB003
     C                   Other                                                               HVB003
                                                                                             HVB003
     C                   Endsl                                                               HVB003
                                                                                             HVB003
     C                   Endif                                                               HVB003
                                                                                             HVB003
     C                   Endif                                                               HVB003
                                                                                             HVB003
     C                   Endsl
      *
     C                   Call      'FTP0717'
     C                   PARM      *Blanks       O0RTN             7
     C                   PARM      'V'           O0Action          1
     C                   PARM                    O1Parm
     C                   PARM                    O2Parm
     C                   PARM                    O3Parm
     C                   PARM                    MVDATE                                       MM0505
      *
      * If return is false then set internal value to false
     C                   If        O0RTN = 'False'
     C                   Eval      W#Valid = 'False'
     C                   Endif
      *
      * If return is true and Quote then save Quote, in O3Parm
     C                   If        O0RTN = 'True' and MsTest = 'QUOTE'
     C                   Eval      W#Quote = O3Data1
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExVreq        TAG
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
      *
     C     KMStpV1       Klist
     C                   Kfld                    MSBicc
     C                   Kfld                    MSBicb
     C                   Kfld                    MSLvpa
     C                   Kfld                    MSRegp
      *
     C     KMStrV1p      Klist
     C                   Kfld                    MSBicc
     C                   Kfld                    MSBicb
     C                   Kfld                    MSLvpa
     C                   Kfld                    MSRegp
     C                   Kfld                    MSMtag
     C                   Kfld                    MSTseq
      *
     C     KMStrV1r      Klist
     C                   Kfld                    MSBicc
     C                   Kfld                    MSBicb
     C                   Kfld                    MSLvpa
     C                   Kfld                    MSRegp
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
