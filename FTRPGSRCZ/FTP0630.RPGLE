     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT STP Reset Preferential Numbers')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTP0630 - Midas FT STP Reset Preferential Numbers            *
      *                                                               *
      *  (C) Copyright Misys International Banking Systems 2004       *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 13Sep11               *
      *                 PNL015             Date 01Dec2005             *
      *                 PNL014             Date 07Dec2005             *
      *                 EEE065   *CREATE   Date 21Sep2004             *
      * Midas Release 4 --------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancement to Midas Plus level.      *
      *  PNL015 - Redirection to head office BIC                      *
      *  PNL014 - Time Sensitive Payments                             *
      *  EEE065 - FT Payment Routing                                  *
      *                                                               *
      *****************************************************************
     FFTMSCCV1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : FT SWIFT Correspondent STP
      *
     FFTMSCPV1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : FT SWIFT Correspondent STP Pay Route
      *
     FFTMSCCV0  UF   E           K DISK    Commit
     F                                     INFDS(INFDS1)
     F                                     INFSR(SRFILE)
      * UPD : FT SWIFT Correspondent STP
      *
     FFTMSCPV0  UF   E           K DISK    Commit
     F                                     INFSR(SRFILE)
      * UPD : FT SWIFT Correspondent STP Pay Route
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
      *
     D P1PARM          DS           256
      * O : Preferential update
     D  P1Bicc                             Like(McBicc)
     D  P1Bicb                             Like(McBicb)
     D  P1Pccy                             Like(McPccy)

      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1Parm
      *
      *  Set up primary reference
      *
     C                   Clear                   P0Rtn
     C                   MOVEL     'Reset '      W0PREF
     C                   Exsr      SrInit

      *
      *  If key passed then only clear that else clear all
      *
     C                   If        P1Bicc <> *blanks

     C                   Eval      McBicc = P1Bicc
     C                   Eval      McBicb = P1Bicb
     C                   Eval      McPccy = P1Pccy
      *
      *  Find record passed
     C     KMsccV1       Chain     @MsccV1
      *
     C                   If        %Found
     C                   Exsr      SrClear
     C                   Endif
     C                   Endif

     C                   If        P1Bicc = *blanks

     C                   Eval      McBicc = *Blanks
     C                   Eval      McBicb = *Blanks
     C                   Eval      McPccy = *Blanks
      *
      *  Read all records
     C     KMsccV1       Setll     @MsccV1
     C                   Read      @MsccV1                                90
      *
     C                   If        *In90 = *Off
     C                   Dou       *In90 = *On
     C                   Exsr      SrClear
     C                   Read      @MsccV1                                90
     C                   Enddo
     C                   Endif
     C                   Endif
      * Commit
     C                   Commit
      * Exit
     C*****              Seton                                        Lr
     C                   Return
      *
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrClear  : Clear preferential numbers                        *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrClear       BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrClear'     @STK(Q)

     C                   Eval      MpBicc = McBicc
     C                   Eval      MpBicb = McBicb
     C                   Eval      MpPccy = McPccy
     C                   Eval      MpCbic = *blanks
     C                   Eval      MpCbib = *blanks
      *
      *  Read all records
     C     KMscpV1       Setll     @MscpV1
     C     KMscpV1p      Reade     @MscpV1                                91
      *
     C                   If        *In91 = *Off
     C                   Dou       *In91 = *On
      * Read actual record
     C     KMscpV1       Chain     @MscpV0
     C                   If        %Found
     C                   Eval      MpPnbr = MpPpct
     C                   Eval      MpPbnb = MpPbpt
     C                   Eval      MpPsnb = MpPspt
     C                   Eval      MpPonb = MpPopt
     C                   Eval      MpPrnb = MpPrpc
     C                   Eval      MpPlnb = MpPlpc
     C                   Update    @MscpV0
     C                   Endif
      *
     C     KMscpV1p      Reade     @MscpV1                                91
     C                   Enddo
     C                   Endif
      *
      *  Clear header
     C     KMsccV1       Chain     @MsccV0
      *
     C                   If        %Found
     C                   If        McPcor = 'Y'
     C                             Or  %Subst(McBicc:1:4) = '????' and                        ESL044
     C                                 %Subst(McBicc:7:2) = '??'   and                        ESL044
     C                                 McBicb = '???'                                         ESL044
     C                             Or  McBicc = 'SERVICES' and                                ESL044
     C                                 McBicb = '???'                                         ESL044
     C                   Eval      McPnbr = 100
     C                   Else
     C                   Clear                   McPnbr
     C                   Endif
      *
     C                   If        McLvpa = 'Y'
     C                             Or  %Subst(McBicc:1:4) = '????' and                        ESL044
     C                                 %Subst(McBicc:7:2) = '??'   and                        ESL044
     C                                 McBicb = '???'                                         ESL044
     C                             Or  McBicc = 'SERVICES' and                                ESL044
     C                                 McBicb = '???'                                         ESL044
     C                   Eval      McPlnb = 100
     C                   Else
     C                   Clear                   McPlnb
     C                   Endif
      *
     C                   If        McRegp = 'Y'
     C                             Or  %Subst(McBicc:1:4) = '????' and                        ESL044
     C                                 %Subst(McBicc:7:2) = '??'   and                        ESL044
     C                                 McBicb = '???'                                         ESL044
     C                             Or  McBicc = 'SERVICES' and                                ESL044
     C                                 McBicb = '???'                                         ESL044
     C                   Eval      McPrnb = 100
     C                   Else
     C                   Clear                   McPrnb
     C                   Endif
      *
     C                   If        McSpcr = 'Y'
     C                             Or  %Subst(McBicc:1:4) = '????' and                        ESL044
     C                                 %Subst(McBicc:7:2) = '??'   and                        ESL044
     C                                 McBicb = '???'                                         ESL044
     C                             Or  McBicc = 'SERVICES' and                                ESL044
     C                                 McBicb = '???'                                         ESL044
     C                   Eval      McSpBn = 100
     C                   Eval      McSpSn = 100
     C                   Eval      McSpOn = 100
     C                   Else
     C                   Clear                   McSpBn
     C                   Clear                   McSpSn
     C                   Clear                   McSpOn
     C                   Endif
      *
     C                   Update    @MsccV0
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExClear       TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
      /EJECT
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
      * Define keys
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
      * Partial key
     C     KMscpV1p      KLIST
     C                   KFLD                    MPBICC
     C                   KFLD                    MPBICB
     C                   KFLD                    MPPCCY
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
