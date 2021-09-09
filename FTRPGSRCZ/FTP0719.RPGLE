     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTP0719 - Midas FT Test Cut Off Times for payment routing    *
      *                                                               *
      *  (c) Misys Banking Systems Ltd. 2005                          *
      *                                                               *
      *  Last Amend No. MD31937            Date 13Jan15               *
      *  Last Amend No. AR856737           Date 13Sep11               *
      *  Last Amend No. PNL014  *Create    Date 16Aug2005             *
      * Midas Release 4 --------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD31937  - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancement to Midas Plus level.      *
      *  PNL014 - Time Sensitive Payments                             *
      *                                                               *
      ******************************************************************
     FFTMSCCV1  IF   E           K DISK
     F                                     INFDS(INFDS1)
     F                                     INFSR(SRFILE)
      * RTV : FT SWIFT Correspondent STP
      *
     FFTMSCPV1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : FT SWIFT Correspondent STP Pay Route
      *
     FSDLCSDL1  IF   E           K DISK    Rename(SdLCSdD0:@LcSdL1)
     F                                     INFSR(SRFILE)
      * RTV : Midas FT Local Clearing Information
      *
     FFTPICDV1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : Midas FT Payment Route ICD
      *
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
     D MscpDs        E DS                  EXTNAME(FTMSCPP0)
      *
     D P1Parm        E DS                  EXTNAME(FTMROTP0)
      *
      * Routing details        *
      *
      * Key parameters for correspondent details
     D P2Parm          DS           256
     D K#MsccBicC                          Like(McBicc)
     D K#MsccBicB                          Like(McBicB)
     D K#MsccPCcy                          Like(McPCcy)
      *
     D D#MsccStmt                          Like(McStmt)
      *
      * Key parameters for correspondent payment routes details
     D P3Parm          DS           256
     D K#MscpBicC                          Like(MpBicc)
     D K#MscpBicB                          Like(MpBicB)
     D K#MscpPCcy                          Like(MpPCcy)
     D K#MscpCBic                          Like(MpCBic)
     D K#MscpCBiB                          Like(MpCBiB)
      *
     D D#MscpStmt                          Like(MpStmt)
      *
      * Output information
     D P4Parm          DS           256
     D O#VDat                              Like(MoVDat)
     D O#RTSQ                              Like(MpRTSQ)
     D O#TSDO                              Like(MpTSDO)
     D O#TSCT                              Like(MpTSCT)
     D O#TSCD                              Like(MpTSCD)
     D O#TSCK                              Like(MpTSCK)
     D O#TSFC                              Like(MpTSFC)
     D O#TSIS                              Like(MpTSIS)
     D O#TSHC                              Like(MpTSHC)
     D O#TSHL                              Like(MpTSHL)
     D O#DateTime                          Like(W#DateTime)
     D O#CheckDateTim                      Like(W#CheckDateTim)
      *
      * Routing details        *
      *
     D ZMDay           S              5P 0
     D ZSDate          S              6
     D ZSDatc          S              8
     D W#CurrentDate   S             12
     D W#DateTime      S             12
     D W#CheckDateTim  S             12
     D ZErr            S              7
     D ZDate           S              6P 0
     D ZDateFmt        S              1
     D ZDayNbr         S              5P 0
     D W#Date          S              6
     D W#Days          S              1
     D W#DaysNbr       S              2P 0
      *

      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P0Action         10
     C                   PARM                    P1Parm
     C                   PARM                    P2Parm
     C                   PARM                    P3Parm
     C                   PARM                    P4Parm
      *
      *  Set up primary reference
      *
     C                   Clear                   P0Rtn
     C                   Clear                   P4Parm
     C                   MOVEL     'Validate'    W0PREF

     C                   Exsr      SrInit

     C                   Select

      * If correspondent check
     C                   When      P0Action = '*CorRoute'
     C                   Exsr      SrCorRoute

      * If correspondent payment route check
     C                   When      P0Action = '*PayRoute'
     C                   Exsr      SrPayRoute
     C                   Endsl

      * Exit, do not close down
     C                   Return
      *
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrCorRoute : Check Correspondent Route Time                  *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrCorRoute    BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrCorRoute'  @STK(Q)

      * Calculate new date
     C                   Eval      W#Date = %SubSt(W#CheckDateTim:7:2)
     C                                    + %SubSt(W#CheckDateTim:5:2)
     C                                    + %SubSt(W#CheckDateTim:3:2)

     C                   Movel     W#Date        ZDate

     C                   Call      'ZDATE1'
     C                   Parm      *blanks       ZErr
     C                   Parm                    ZDate
     C                   Parm      'D'           ZDateFmt
     C                   Parm                    ZDayNbr
      *
      * Get Correspondent data
      *
     C                   Eval      McBicc = K#MsccBicc
     C                   Eval      McBicB = K#MsccBicB
     C                   Eval      McPCcy = K#MsccPCcy
      *
     C     KMsccV1       Chain     @MsccV1
     C                   If        %Found
     C                   Eval      O#RTSQ = *Blanks
     C                   Eval      O#TSDO = McTSDO
     C                   Eval      O#TSCT = McTSCT
     C                   Eval      O#TSCD = McTSCD
     C                   Eval      O#TSCK = McTSCK
     C                   Eval      O#TSFC = McTSFC
     C                   Eval      O#TSIS = McTSIS
     C                   Eval      O#TSHC = McTSHC
     C                   Eval      O#TSHL = McTSHL
     C                   If        O#TSHC = *blanks
     C                   Eval      O#TSHC = McPccy
     C                   Endif
      *
      * Get Local Clearing Data if type C checking
     C                   If        McTSCK = 'C'
      *
     C                   Eval      LcCyCd = K#MsccPCcy
     C                   Eval      LcSetM = McStMt
     C                   If        D#MsccStmt <> *blanks
     C                   Eval      LcSetM = D#MsccStmt
     C                   Endif
      *
     C     KLcSdL1       Chain     @LcSdL1
     C                   If        %Found
     C                   Eval      O#TSCT = LcInCt
     C                   Eval      O#TSCD = LcInCd * -1
     C                   Endif

      * Adjust date depending on O#TSCD
     C                   If        O#TSCD > 0
      * Decrement date by number of days

      * Loop forward number of days
     C     1             Do        O#TsCd

      * Loop until working day
     C                   DoU       Z0HolInd = 'W' or Z0HolInd = ' '

     C                   Eval      ZDayNbr = ZDayNbr - 1

     C                   Call      'FT0305'
     C                   Parm      *blanks       Zerr
     C                   Parm      ZDayNbr       Z0RDNB            5 0
     C                   Parm      O#TsHc        Z0CCY             3
     C                   Parm      O#TsHl        Z0Loc             3
     C                   Parm      *blanks       Z0HolInd          1

     C                   Enddo

     C                   Enddo

      * Get Midas date as CcYyMmDd
     C                   Call      'ZM0065'
     C                   Parm      ZDayNbr       ZMDay
     C                   Parm      *blanks       ZSDate
     C                   Parm      *blanks       ZSDatc
      *
     C                   Movel     ZSDatc        W#CheckDateTim

     C                   Endif

      *
     C                   Endif
      * Construct Date Time
     C                   Move      O#TSCT        W#CheckDateTim

      * Check if holiday today if 0 days
     C                   If        O#TSCD = 0

     C                   Call      'FT0305'
     C                   Parm      *blanks       Zerr
     C                   Parm      ZDayNbr       Z0RDNB
     C                   Parm      O#TsHc        Z0CCY
     C                   Parm      O#TsHl        Z0Loc
     C                   Parm      *blanks       Z0HolInd
     C                   Endif

      * Check Time not passed
     C                   Select
      * Check if 0 days that it is not a holiday
     C                   When      O#TsCd = 0 and Z0HolInd <> 'W'
     C                                        and Z0HolInd <> *blanks
     C                   Eval      P0Rtn = '*NotOk'
      * Check Time not passed
     C                   When      W#CheckDateTim >= W#DateTime
     C                   Eval      P0Rtn = '*Ok'
     C                   Other
     C                   Eval      P0Rtn = '*NotOk'
     C                   Endsl
      *
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExCorRoute    TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrPayRoute : Check Correspondent Pay Route Time              *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrPayRoute    BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrPayRoute'  @STK(Q)

      * Calculate new date
     C                   Eval      W#Date = %SubSt(W#CheckDateTim:7:2)
     C                                    + %SubSt(W#CheckDateTim:5:2)
     C                                    + %SubSt(W#CheckDateTim:3:2)

     C                   Movel     W#Date        ZDate

     C                   Call      'ZDATE1'
     C                   Parm      *blanks       ZErr
     C                   Parm                    ZDate
     C                   Parm      'D'           ZDateFmt
     C                   Parm                    ZDayNbr
      *
      * Get Correspondent Pay Route data
      *
     C                   Eval      MpBicc = K#MscpBicc
     C                   Eval      MpBicB = K#MscpBicB
     C                   Eval      MpPCcy = K#MscpPCcy
     C                   Eval      MpCBic = K#MscpCBIc
     C                   Eval      MpCBiB = K#MscpCBiB
      *
     C     KMscpV1       Chain     @MscpV1
     C                   If        %Found
     C                   Eval      O#RTSQ = MpRTSQ
     C                   Eval      O#TSDO = MpTSDO
     C                   Eval      O#TSCT = MpTSCT
     C                   Eval      O#TSCD = MpTSCD
     C                   Eval      O#TSCK = MpTSCK
     C                   Eval      O#TSFC = MpTSFC
     C                   Eval      O#TSIS = MpTSIS
     C                   Eval      O#TSHC = MpTSHC
     C                   Eval      O#TSHL = MpTSHL
     C                   If        O#TSHC = *blanks
     C                   Eval      O#TSHC = MpPCcy
     C                   Endif
      *
      * Get Local Clearing Data if type C checking
     C                   If        MpTSCK = 'C'
      *
     C                   Eval      LcCyCd = K#MscpPCcy
     C                   Eval      LcSetM = MpStMt
     C                   If        D#MsccStmt <> *blanks
     C                   Eval      LcSetM = D#MsccStmt
     C                   Endif
      *
     C     KLcSdL1       Chain     @LcSdL1
     C                   If        %Found
     C                   Eval      O#TSCT = LcInCt
     C                   Eval      O#TSCD = LcInCd * -1
     C                   Endif

      * Adjust date depending on O#TSCD
     C                   If        O#TSCD > 0
      * Decrement date by number of days

      * Loop forward number of days
     C     1             Do        O#TsCd

      * Loop until working day
     C                   DoU       Z0HolInd = 'W' or Z0HolInd = ' '

     C                   Eval      ZDayNbr = ZDayNbr - 1

     C                   Call      'FT0305'
     C                   Parm      *blanks       Zerr
     C                   Parm      ZDayNbr       Z0RDNB            5 0
     C                   Parm      O#TsHc        Z0CCY             3
     C                   Parm      O#TsHl        Z0Loc             3
     C                   Parm      *blanks       Z0HolInd          1

     C                   Enddo

     C                   Enddo

      * Get Midas date as CcYyMmDd
     C                   Call      'ZM0065'
     C                   Parm      ZDayNbr       ZMDay
     C                   Parm      *blanks       ZSDate
     C                   Parm      *blanks       ZSDatc
      *
     C                   Movel     ZSDatc        W#CheckDateTim

     C                   Endif
      *
     C                   Endif
      * Construct Date Time
     C                   Move      O#TSCT        W#CheckDateTim

      * Check if holiday today if 0 days
     C                   If        O#TSCD = 0

     C                   Call      'FT0305'
     C                   Parm      *blanks       Zerr
     C                   Parm      ZDayNbr       Z0RDNB
     C                   Parm      O#TsHc        Z0CCY
     C                   Parm      O#TsHl        Z0Loc
     C                   Parm      *blanks       Z0HolInd
     C                   Endif

      * Check Time not passed
     C                   Select
      * Check if 0 days that it is not a holiday
     C                   When      O#TsCd = 0 and Z0HolInd <> 'W'
     C                                        and Z0HolInd <> *blanks
     C                   Eval      P0Rtn = '*NotOk'
     C                   When      W#CheckDateTim >= W#DateTime
     C                   Eval      P0Rtn = '*Ok'
     C                   Other
     C                   Eval      P0Rtn = '*NotOk'
     C                   Endsl
      *
     C                   Endif
      *
      *
      *  Unwind subroutine stack name
      *
     C     ExPayRoute    TAG
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
     C                   MOVEL     'SrInit'      @STK(Q)
      *
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      *
     C                   Clear                   W#DateTime
     C                   Clear                   W#CheckDateTim
      *
     C                   Movel     W#CurrentDate W#DateTime
     C                   Eval      %Subst(W#DateTime:9:4) = %Subst(##Jtma:1:4)

      * If basis is today then Midas date else passed date
     C                   Select
     C                   When      MoCDat <> *blanks
     C                   Movel     MoCDat        W#CheckDateTim
     C                   When      ICTsBs = 'T' and MoCDat = *blanks
     C                   Movel     W#CurrentDate W#CheckDateTim
     C                   When      ICTsBs = 'C' and MoCDat = *blanks
     C                                          and MoVDat <> *blanks
     C                   Movel     MoVdat        W#CheckDateTim
     C                   Other
     C                   Movel     W#CurrentDate W#CheckDateTim
     C                   Endsl
      *
      *  Unwind subroutine stack name
      *
     C     ExInit        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *InzSr   : Program Initialisation                            *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   *InzSr        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     '*InzSr'      @STK(Q)
      *
      *  Extract bank details
      *
     C                   CALL      'AOBANKR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*FIRST '     P@OPTN            7            I:Option
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     3             W0ERNB                         * DB ERROR 30 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
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
      * Get ICD data
     C                   Clear                   IcKey
     C     KPicdV1       Setll     @PicdV1
     C                   Read      @PicdV1
      *
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      *
      * Get Midas date as CcYyMmDd
     C                   Call      'ZM0065'
     C                   Parm      BjRdNb        ZMDay
     C                   Parm      *blanks       ZSDate
     C                   Parm      *blanks       ZSDatc
      *
     C                   Movel     ZSDatc        W#CurrentDate
      * Define keys
      * Full key
     C     KMsccV1       KLIST
     C                   KFLD                    MCBICC
     C                   KFLD                    MCBICB
     C                   KFLD                    MCPCCY
      * Full key
     C     KMscpV1       KLIST
     C                   KFLD                    MPBICC
     C                   KFLD                    MPBICB
     C                   KFLD                    MPPCCY
     C                   KFLD                    MPCBIC
     C                   KFLD                    MPCBIB
      * Full key
     C     KLcSdL1       KLIST
     C                   KFLD                    LcCyCd
     C                   KFLD                    LcSetM
      *
      * Get ICD Data
     C     KPicdV1       KLIST
     C                   KFLD                    IcKey
      *
      *  Unwind subroutine stack name
      *
     C     ExInzSr       TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
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
(c) Misys Banking Systems Ltd. 2005
