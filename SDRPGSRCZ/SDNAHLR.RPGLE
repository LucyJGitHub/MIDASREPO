     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non Account Holder retrieve')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNAHLR   - SD Non Account Holder retrieve a record          *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. CAP240   *Create   Date 11Jun21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP240 - SD Non Account Holder JAVA                          *
      *                                                               *
      *****************************************************************
     FSDNAHOY0  IF   E           K DISK    INFSR(*PSSR)
     FSDNHTXL4  IF   E           K Disk    INFSR(*PSSR)
     FSDCTTXL2  IF   E           K Disk
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** SCREEN FORMATS
      **--------------------------------------------------------------------------------------------

     D CT50ArrDS       DS
     D  CT50Arr                      55A   DIM(50)

     D Cr10ArrDS       DS
     D  Cr10Arr                     223A   DIM(10)

     D PCRSDT          DS
     D  DDCTRY                 1      2
     D  DDPREP                 3      3
     D  DDREPTT                4      4
     D  DDREPU                 5     14
     D  DDREPD                15     20
     D  DDREPM                21     26
     D  DDREP1                27     90
     D  DDREP2                91    154
     D  DDEVE1               155    156
     D  DDEVS1               157    159
     D  DDEVE2               160    161
     D  DDEVS2               162    164
     D  DDEVE3               165    166
     D  DDEVS3               167    169
     D  DDEVE4               170    171
     D  DDEVS4               172    174
     D  DDEVE5               175    176
     D  DDEVS5               177    179
     D  DDTINN               180    204
     D  DDEFFD               205    210
     D  DDEXPD               211    216
     D  DDCODO               217    217
     D  DDJACM               218    218
     D  DDMAILT              219    219
     D  DDPHONT              220    220
     D  DDRPAY               221    221
     D  DDPEP1               222    285
     D  DDPEP2               286    349
     D  DDCRSA               350    350
     D  DDTINS               351    351

     D TranInCT501   E DS                  EXTNAME (SDNATXPD)
     D                                     PREFIX(TX:2)

     D TranInCR101   E DS                  EXTNAME (SDCR01PD)
     D                                     PREFIX(CR_)

      * Current Non account holder in file format
     D CuNAFilFmt    E DS                  EXTNAME(SDNAHOPD)

      ** Current Non-A/C Holder in File Format - CRS details Header
     D CuCrhFlFmt    E DS                  EXTNAME(SDCRNHPD)

      ** Current Non-A/C Holder in File Format - FACTCA details
     D CuFaFilFmt    E DS                  EXTNAME(SDFTNHPD)

      * Current Non account holder in screen format
     D CuNAScnFmt    E DS                  EXTNAME(SDNAHLPD)

      ** Current Non-A/C Holder in Scr Format - CRS details Header
     D CuCrhScFmt    E DS                  EXTNAME(SDCRNSPD)

      ** Current Non-A/C Holder in Scr Format - FACTCA details
     D CuFaScnFmt    E DS                  EXTNAME(SDFTNRPD)

      ** Current Non-A/C Holder in Scr Format - CRS repeating fields (all fields 10 times)
     D CuCr10ScFm    E DS                  EXTNAME(SDCR10PD)

     D CuCt50FlFm    E DS                  EXTNAME(SDNHTXPD)
     D CuCt50ScFm    E DS                  EXTNAME(SDCT50PD)
     D                                     PREFIX(TX)

      ** NATX Details in Screen Format
     D NwNatxScFm    E DS                  Extname(SDNATXPD)
     D                                     Prefix(NS)

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR MIDAS DETAILS

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR RETAIL TABLE FILE

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D CuFoFilFmt      DS
     D  WCDESC                 1     50
     D  WPDESC                51    100
     D  WWBRTH               101    105
     D  WWCBTH               106    107
     D  WWBTHT               108    142
     D  WWCNCZ               143    144
     D  WWCDOM               145    146
     D  WWACCZ               147    148
     D  WWTINO               149    173

     D CuFoScnFmt      DS
     D  WCDESC1                1     50
     D  WPDESC1               51    100
     D  WNBRTH               101    106
     D  WWCBTH1              107    108
     D  WWBTHT1              109    143
     D  WWCNCZ1              144    145
     D  WWCDOM1              146    147
     D  WWACCZ1              148    149
     D  WWUTIN2              150    174

     D PCrsdF          S            222A   DIM(30)
     D PCrsdS          S            351A   DIM(30)


      ** ZDATE1 and ZDATE2 parameters
     D PZDayNo         S              5  0
     D PZDate          S              6  0
     D PZadate         S              7
     D PZDatErr        S              1

      **--------------------------------------------------------------------------------------------

     D X               S              3P 0
     D Idy             S              3P 0
     D Y               S              5S 0
     D Z               S              5S 0

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0

     D Auth            S              1A
     D DDEINO          S             30A
     D ModeofOp        S              6
     D FOTRID          S             20
      **--------------------------------------------------------------------------------------------

     C                   CLEAR                   CuNaFilFmt
     C                   CLEAR                   CuFaFilFmt
     C                   CLEAR                   CuFoFilFmt
     C                   CLEAR                   CuCrHFlFmt
     C                   CLEAR                   PCrsdF
     C                   CLEAR                   CuCt50FlFm

     C     DDACTN        IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           DDACTN
     C                   ELSE
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF
     C                   ENDIF

     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ENDIF
     C                   ENDIF

     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      SDNAHLRED
     C                   ELSE
     C                   MOVEL     DDNAHO_In     @NARED
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If record read
      * and no error message returned
      *
     C     @NARED        IFNE      *BLANK
     C     @ERRMS        ANDEQ     *BLANK
      *
      * Retrieve non account holder details
      *
     C                   MOVEL     @NaRED        DDNAHO
     C                   EXSR      SDNAHLRTV
      *
      * Convert to screeen format
      *
     C     Idx           IFEQ      0
     C                   EXSR      SDNAHLCVT
     C                   ENDIF

     C     CER076        IFEQ      'Y'
     C     DDNAHO        Chain     SDNAHOY0                           80
     C     *In80         Ifeq      *Off
     C                   Eval      DDEINO = NHEINO
     C                   else
     C                   Eval      DDEINO = *Blanks
     C                   Endif
     C                   ENDIF

     C                   EXSR      SDNATXRTV

     C     @ERRMS        IFNE      *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDNAHO'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      Buffer = CuNaScnFmt
     C                                      + Auth
     C                                      + CuFaScnFmt
     C                                      + CUCrHScFmt
     C                                      + DDEINO
     C                                      + CUCr10ScFm
     C                                      + CUCt50ScFm

     C                   Move      'Buffer'      Dumpv            10
     C                   dump
     C                   Move      *Blanks       Dumpv

     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SDNATXRTV - Retrieve non-a/c holder Country of Tax details   *
      *                                                               *
      *****************************************************************
     C     SDNatxRtv     BEGSR

     C                   EVAL      Idy = 1
     C     DDNAHO        SETLL     SDNHTXL4
     C                   READ      SDNHTXL4
     C                   DOW       NOT %EOF(SDNHTXL4)
     C                             AND DDNAHO = NXNAHO
     C                   EVAL      TXACTN  = *BLANK
     C                   EVAL      TXNAHO  = NXNAHO
     C                   EVAL      TXCTTX  = NXCTTX
     C                   EVAL      TXETXS  = NXETXS
     C                   EVAL      TXCERF  = NXCERF
     C                   EVAL      TXNSTS  = NXNSTS
     C                   EVAL      TXCRTP  = NXCRTP

     C                   EVAL      TXCEEX  = *BLANK
     C                   IF        NXCEEX <> *ZERO
     C                   EVAL      PZDAYNO = NXCEEX
     C                   EXSR      SRZDATE2
     C                   MOVEL     PZDATE        TXCEEX
     C                   ENDIF

     C                   EVAL      TXCADT  = *BLANK
     C                   IF        NXCADT <> *ZERO
     C                   EVAL      PZDAYNO = NXCADT
     C                   EXSR      SRZDATE2
     C                   MOVEL     PZDATE        TXCADT
     C                   ENDIF

     C                   EVAL      TXCVDT  = *BLANK
     C                   IF        NXCVDT <> *ZERO
     C                   EVAL      PZDAYNO = NXCVDT
     C                   EXSR      SRZDATE2
     C                   MOVEL     PZDATE        TXCVDT
     C                   ENDIF

     C                   EVAL      CT50Arr(Idy) = TranInCT501
     C                   EVAL      Idy =Idy + 1
     C                   READ      SDNHTXL4
     C                   ENDDO

      ** Default NATX details if empty


s1   C                   If        Idy = 1

s2   C                   If        DDPIND = 'Y'

     C                   MOVE      *BLANKS       Ct50ArrDS
     C                   EVAL      X = 0
     C     DDCOLC        SETLL     SDCTTXL2
     C     DDCOLC        READE     SDCTTXL2

s3   C                   DOW       NOT %EOF(SDCTTXL2)

     C                   EVAL      X = X + 1
     C                   EVAL      NSDDACTN = DDACTN
     C                   EVAL      NSDDNAHO = DDNAHO
     C                   EVAL      NSDDCTTX = EWCTRT
     C                   EVAL      NSDDETXS = EWTXS1
     C                   EVAL      NSDDCERF = *BLANKS
     C                   EVAL      NSDDCEEX = *BLANKS
     C                   EVAL      NSDDNSTS = 'A'
     C
      *
      ** If CER048 is installed,supply certificate type,approval date
      ** and value date.
      *
 s4  C                   IF        CER048 = 'Y'
     C                   EVAL      NSDDCRTP = *BLANKS
     C                   EVAL      NSDDCADT = *BLANKS
     C                   EVAL      NSDDCVDT = *BLANKS
 e4  C                   ENDIF

     C                   EVAL      Ct50Arr(X) = NwNatxScFm

     C     DDCOLC        READE     SDCTTXL2
 e3  C                   ENDDO

      ** Blank out country of residence

     C                   Move      *Blanks       Ct50Ctry          2
     C                   Move      *Blanks       BlkColc           2
     C                   EVAL      Z = X + 1
     C     BlkColc       SETLL     SDCTTXL2
     C     BlkColc       READE     SDCTTXL2

 s3  C                   DOW       NOT %EOF(SDCTTXL2)

     C                   EVAL      Y = 0
     C                   Move      *Blanks       Match             1
 s4  C                   If        Z > 1
 s5  C                   DOW       Y < Z
     C                   EVAL      Y = Y + 1
     C                   EVAL      Ct50Ctry = %SUBST(Ct50Arr(Y):12:2)
 s6  C                   If        EwCtrt = Ct50Ctry
     C                   EVAL      Match = 'Y'
 e6  C                   Endif
 e5  C                   Enddo
 e4  C                   Endif

 s4  C                   If        Z > 1
     C                             and Match <> 'Y'
     C                             or Z = 1
     C                   EVAL      X = X + 1
     C                   EVAL      NSDDACTN = DDACTN
     C                   EVAL      NSDDNAHO = DDNAHO
     C                   EVAL      NSDDCTTX = EWCTRT
     C                   EVAL      NSDDETXS = EWTXS1
     C                   EVAL      NSDDCERF = *BLANKS
     C                   EVAL      NSDDCEEX = *BLANKS
     C                   EVAL      NSDDNSTS = 'A'
      *
     C                   IF        CER048 = 'Y'
     C                   EVAL      NSDDCRTP = *BLANKS
     C                   EVAL      NSDDCADT = *BLANKS
     C                   EVAL      NSDDCVDT = *BLANKS
     C                   ENDIF

     C                   EVAL      Ct50Arr(X) = NwNatxScFm

 e4  C                   Endif

     C     BlkColc       READE     SDCTTXL2
 e3  C                   ENDDO

 e2  C                   ENDIF
 e1  C                   Endif

     C                   EVAL      CuCt50ScFm = CT50ArrDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZDATE2 - Format a date for output                             *
      *****************************************************************
     C     SRZDATE2      BEGSR

     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayNo
     C                   PARM                    BJDFIN
     C                   PARM                    PZDate
     C                   PARM                    PZaDate

     C                   ENDSR

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDNAHO_In        10
     C                   PARM                    Buffer         9999
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1

      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'
      *
      ** Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @Rtcd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C                   IF        @Rtcd <> *Blanks
     C     *Lock         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = @Optn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access SAR file to determine if CER076 is present.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CER076'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         Ifne      *BLANKS
     C                   Movel     'N'           CER076            1
     C                   else
     C                   Movel     'Y'           CER076
     C                   Endif


      ** Check if feature CER048 is enabled

     C                   Call      'AOSARDR0'
     C                   Parm      *Blanks       @rtcd
     C                   Parm      '*VERIFY'     @optn
     C                   Parm      'CER048'      @Sard
     C     SCSARD        Parm      SCSARD        DSFDY

     C                   If        @rtcd <> *Blanks
     C                   Movel     'N'           CER048            1
     C                   else
     C                   Eval      CER048 = 'Y'
     C                   Endif

      *  Hook to enable non-core message files to be included

     C                   ENDSR

      **********************************************************************
      /EJECT
      **********************************************************************
     C     SDNAHLRED     BEGSR

     C                   CALLB     'SDNAHLRED'
      *
      * INPUT PARAMETERS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut       10
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Non account holder ref
     C                   PARM                    DDNAHO
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * Error message
     C                   PARM      *BLANK        @ERRMS            7
      *
      * Non account holder ref
     C                   PARM      *BLANK        @NARED           10

     C                   ENDSR
      **********************************************************************
     C     SDNAHLRTV     BEGSR

     C                   CALLB     'SDNAHLRTV'
      ** INPUTS :         ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** Return code
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      ** Response mode
      ** Action Code
      ** Front Office Transaction ID
      ** (Midas) Non-A/C Holder Number

     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    ModeofOp
     C                   PARM      'S'           APRESPMODE        1
     C                   PARM                    DDACTN
     C                   PARM                    FOTRID
     C                   PARM                    DDNAHO
     C                   PARM                    @IN36             1

      ** OUTPUTS :
      ** (Current) Non-A/C Holder in file format
      ** OK - Action code
      ** OK - Non-A/C Holder Number
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller

     C                   PARM                    CuNaFilFmt
     C                   PARM                    CuFaFilFmt
     C                   PARM                    CuFoFilFmt
     C                   PARM                    CuCrhFlFmt
     C                   PARM                    PCrsdF
     C                   PARM                    OkActn            1
     C                   PARM                    OKNaho            1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx

     C                   ENDSR
      **********************************************************************
     C     SDNAHLCVT     BEGSR

     C                   CALLB     'SDNAHLCVT'
      ** INPUTS :         ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** Return Code
      ** Non-A/C Holder - file formats

     C                   PARM                    RetCodeIn
     C                   PARM                    CuNaFilFmt
     C                   PARM                    CuFaFilFmt
     C                   PARM                    CuFoFilFmt
     C                   PARM                    CuCrhFlFmt
     C                   PARM                    PCrsdF

      ** OUTPUTS :
      ** Non-A/C Holder Details - screen formats

     C                   PARM                    CuNaScnFmt
     C                   PARM                    CuFaScnFmt
     C                   PARM                    CuFoScnFmt
     C                   PARM                    CuCrhScFmt
     C                   PARM                    PCrsdS


      ** Load Country Details

     C                   Eval      X = 1

     C                   DOW       X < 11

     C                   Eval      CuCr10ScFm = *Blanks
     C                   Eval      TranInCr101 = *Blanks
     C                   Move      *Blanks       Cr10ArrDS
     C                   Eval      PCRSDT = *Blanks

     C                   Eval      PCRSDT = PCrsdS(X)

     C                   If        DDCTRY <> *Blanks
     C                   Eval      CR_DDCTR1 = DDCTRY
     C                   Eval      CR_DDREU1 = DDREPU
     C                   Eval      CR_DDRET1 = DDREPTT
     C                   Eval      CR_DDRED1 = DDREPD
     C                   Eval      CR_DDREM1 = DDREPM
     C                   Eval      CR_DDRE11 = DDREP1
     C                   Eval      CR_DDRE21 = DDREP2
     C                   Eval      CR_DDEE11 = DDEVE1
     C                   Eval      CR_DDES11 = DDEVS1
     C                   Eval      CR_DDEE21 = DDEVE2
     C                   Eval      CR_DDES21 = DDEVS2
     C                   Eval      CR_DDEE31 = DDEVE3
     C                   Eval      CR_DDES31 = DDEVS3
     C                   Eval      CR_DDEE41 = DDEVE4
     C                   Eval      CR_DDES41 = DDEVS4
     C                   Eval      CR_DDEE51 = DDEVE5
     C                   Eval      CR_DDES51 = DDEVS5
     C                   Eval      CR_DDTIN1 = DDTINN
     C                   Eval      CR_DDEFF1 = DDEFFD
     C                   Eval      CR_DDEXP1 = DDEXPD
     C                   Eval      CR_DDCOD1 = DDCODO
     C                   Eval      CR_DDJAC1 = DDJACM
     C                   Eval      CR_DDMAI1 = DDMAILT
     C                   Eval      CR_DDPHO1 = DDPHONT
     C                   Eval      CR_DDRPA1 = DDRPAY
     C                   Eval      CR_DDCRS1 = DDCRSA
     C                   Eval      CR_DDTNN1 = DDTINS
     C                   Eval      Cr10Arr(X) = TranInCr101
     C                   Endif

     C                   Eval      X = X + 1

     C                   ENDDO

     C                   EVAL      CuCr10ScFm = Cr10ArrDS

     C                   ENDSR
      **********************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2021
