     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Validate Backward Looking Rate Fields')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data module                                 *
      *                                                               *
      *  ZAVBLRTE - Validate Backward Looking Rate Fields             *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Backward-Looking Rate fields and confirms whether *
      *             they have valid values.                           *
      *             If the flds are valid, the returncode 10A will be *
      *             blank and the passed flds will contain valid      *
      *             formatted values (ready to be stored).            *
      *             If one of the flds is invalid, the returncode     *
      *             will contain 'Error' and an error message will be *
      *             returned.                                         *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CSD103  *CREATE    Date 01Aug20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *    U7, U8     Database error                                  *
      *    80         BSRC and CCY are not in SDBSRTPD                *
      *    90         End of File for CLOANCL                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *  RSTFLDS - Subroutine for resetting work fields               *
      *  SRBLRT - Validate Backward-Looking Rate                      *
      *  SRRFRR - Validate Risk Free Rate Field                       *
      *  SRCALM - Validate Calculation Method Field                   *
      *  SRBADJ - Validate Benchmark Adjustment Field                 *
      *  SRFLOR - Validate Floor Field                                *
      *  SRLBDY - Validate Lookback Days Field                        *
      *  SRLODY - Validate Lockout Days Field                         *
      *  SROPSH - Validate Observation Period Shift Field             *
      *  SRRRDP - Validate Rate Rounding Decimal Places               *
      *  SRDBAV - Validate Day Basis for Average Field                *
      *  SRRTKN - Populate Rates Known Field                          *   						
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** ARR Calculator Parameter Details File
     FSDLIBRTD  IF   E           K DISK    INFSR(*PSSR)

      ** Lending Loans File
     FLECLIPL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANCKF)

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure

     D/COPY ZACPYSRC,STD_D_SPEC

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(40)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Array of fields in error
     D FldNamXAr       S             10A   DIM(XArrayMax)

      ** Array of error message IDs
     D MsgIdXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
	
      ** Array for allowed processing type for loan
     D WLPtyp          S              2A   DIM(9) CTDATA PERRCD(20)

      ** DS for Access programs: Long Sata Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** DS for Dealing Details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)

      ** DS for Base Rate Details
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)

      ** DS for Loan Details
     D CLOANL        E DS                  EXTNAME(LECLIPL2:*INPUT)
     D                                     PREFIX(CL)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1A

      ** Program Entry Parameters
     D ApiName         S              4A
     D TransRef        S              6A
     D TransType       S              2A
     D TransCCY        S              3A
     D TransBSRC       S              2A
     D TransICBS       S              1S 0
     D TransCHTP       S              1A

      ** Index for arrays of error message ids
     D Idx             S              3P 0

      ** Passed index value
     D Ix              S              3P 0

      ** Input Screen fields
     D InpScrfld       DS           200

      ** Output Valid fields
     D OutValfld       DS           200

      ** Incoming Backward-Looking Rate Screen Fields (Input)
     D TranScnBlrt     DS
     D  DDBLRT                        1A
     D  DDRFRR                       10A
     D  DDCALM                        4A
     D  DDBADJ                       13A
     D  DDFLOR                       13A
     D  DDLBDY                        2A
     D  DDLODY                        2A
     D  DDOPSH                        1A
     D  DDRRDP                        2A
     D  DDDBAV                        1A
     D  DDRTKN                        1A

      ** Backward-Looking Rate Valid fields (Output)
     D BLRTValFlds     DS
     D  VBLRT                         1A
     D  VRFRR                        10A
     D  VCALM                         4A
     D  VBADJ                        11P 7
     D  VFLOR                        11P 7
     D  VLBDY                         2S 0
     D  VLODY                         2S 0
     D  VOPSH                         1A
     D  VRRDP                         2S 0
     D  VDBAV                         1S 0
     D  VRTKN                         1A

      ** Parameters for base rate code access object
     D PRTCD           S              7A
     D POPTN           S              7A
     D PKEY1           S              3A
     D PKEY2           S              2A

      ** Parameters for calling ZA0841
     D @@ALPH          S             16A
     D @@IDP           S              3P 0
     D @@IINT          S              3P 0
     D @@MTID          S              1A
     D @@ERCD          S              1P 0
     D @@AMT           S             15P 0

      ** Work Variables
     D WDAY            S              2S 0
     D WDBAV           S              1S 0
     D WNumBADJ        S             11P 7
     D WNumFLOR        S             11P 7
     D WSign           S              1A
     D KSCRFLD         S                   LIKE(SCRFLD)
     D KINTVAL         S                   LIKE(INTVAL)

      ** OK fields
     D DDBLRTOK        S              1A
     D DDRFRROK        S              1A
     D DDCALMOK        S              1A
     D DDBADJOK        S              1A
     D DDFLOROK        S              1A
     D DDLBDYOK        S              1A
     D DDLODYOK        S              1A
     D DDOPSHOK        S              1A
     D DDRRDPOK        S              1A
     D DDDBAVOK        S              1A
     D DDRTKNOK        S              1A

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Reset work fields
     C                   EXSR      RSTFLDS

      ** Move inputs to Backward-Looking Rate data structure
     C                   MOVEL     InpScrfld     TranScnBlrt

      ** If called from a transaction input (e.g. CLIP, LDNI) and
      ** currency/base rate code are not blanks, access the
      ** base rate code table to get the default values
     C                   IF        TransCCY  <> *BLANKS and
     C                             TransBSRC <> *BLANKS

     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      TransCCY      PKEY1
     C                   PARM      TransBSRC     PKEY2
     C     SDBSRT        PARM      SDBSRT        DSSDY
     C                   IF        PRTCD = '*NRF   '
     C                   SETON                                        80
     C                   ENDIF

     C                   ENDIF

      ** Validate Backward-Looking Rate Indicator
     C                   EXSR      SRBLRT

     C                   IF        DDBLRTOK <> 'N'

      ** Validate Risk Free Rate
     C                   EXSR      SRRFRR

      ** Validate Calculation Method
     C                   EXSR      SRCALM

      ** Validate Benchmark Adjustment
     C                   EXSR      SRBADJ

      ** Validate Floor
     C                   EXSR      SRFLOR

      ** Validate Lookback Days
     C                   EXSR      SRLBDY

      ** Validate Lockout Days
     C                   EXSR      SRLODY

      ** Validate Observation Period Shift
     C                   EXSR      SROPSH

      ** Validate Rate Rounding Decimal Places
     C                   EXSR      SRRRDP

      ** Validate Day Basis for Average
     C                   EXSR      SRDBAV

      ** Populate Rates Known
     C                   EXSR      SRRTKN

     C                   ENDIF

     C                   MOVEL     BLRTValFlds   OutValfld
     C                   MOVEL     TranScnBlrt   InpScrfld

      ** If a new error was found, set the return code appropriately
     C                   IF        Idx > Ix
     C                   EVAL      RetCodeOut = 'Error'
     C                   ENDIF

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *  RSTFLDS - Subroutine for resetting work fields               *
      *****************************************************************
     C     RSTFLDS       BEGSR

     C                   CLEAR                   TranScnBlrt
     C                   CLEAR                   BLRTValFlds
     C                   CLEAR                   OutValfld

      ** Store current number of error index
     C                   Z-ADD     Idx           Ix

      ** Reset OK Fields
     C                   EVAL      DDBLRTOK = *BLANK
     C                   EVAL      DDRFRROK = *BLANK
     C                   EVAL      DDCALMOK = *BLANK
     C                   EVAL      DDBADJOK = *BLANK
     C                   EVAL      DDFLOROK = *BLANK
     C                   EVAL      DDLBDYOK = *BLANK
     C                   EVAL      DDLODYOK = *BLANK
     C                   EVAL      DDOPSHOK = *BLANK
     C                   EVAL      DDRRDPOK = *BLANK
     C                   EVAL      DDDBAVOK = *BLANK
     C                   EVAL      DDRTKNOK = *BLANK

      ** Reset Indicators
     C                   SETOFF                                       80
     C                   SETOFF                                       90

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRBLRT - Validate Backward Looking Rate Field                *
      *****************************************************************
     C     SRBLRT        BEGSR

      ** Default value depending on where this program is called
     C                   IF        DDBLRT = *BLANKS
     C                   SELECT

      ** Default to 'N' if blank
     C                   WHEN      ApiName = 'BSRT'
     C                   EVAL      DDBLRT = 'N'

      ** Default value from base rate code
     C                   WHEN      ApiName = 'CLIP'
     C                   EVAL      DDBLRT = BABLRT

     C                   ENDSL
     C                   ENDIF

      ** Value must be 'Y' or 'N'
     C                   IF        DDBLRT <> 'Y' and
     C                             DDBLRT <> 'N'
     C                   EVAL      DDBLRTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDBLRT'
     C                   EVAL      MsgIdXAr(Idx) = '5049400'
     C                   ELSE

      ** Issue error if the loan type used is not allowed for
      ** backward looking rate
     C                   IF        ApiName = 'CLIP'

     C                   IF        %LOOKUP(TransType:WLPtyp) = 0 and
     C                             DDBLRT = 'Y'
     C                   EVAL      DDBLRTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDBLRT'
     C                   EVAL      MsgIdXAr(Idx) = '5049403'
     C                   ENDIF
     C
     C                   ENDIF

      ** Issue error if existing base rate is used in a loan
      ** and its backward looking rate value is changed
     C                   IF        ApiName = 'BSRT' and
     C                             *IN80 = *OFF

     C     *LOVAL        SETLL     LECLIPL2
     C                   DOW       *IN90 = *OFF
     C                   READ      LECLIPL2      CLOANL                   90
     C                   IF        TransCCY = CLCCY and
     C                             TransBSRC = CLNBRA and
     C                             DDBLRT <> BABLRT
     C                   EVAL      DDBLRTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDBLRT'
     C                   EVAL      MsgIdXAr(Idx) = '5049428'
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO

     C                   ENDIF

     C                   ENDIF

     C                   IF        DDBLRTOK <> 'N'
     C                   MOVE      DDBLRT        VBLRT
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRFRR - Validate Risk Free Rate Field                       *
      *****************************************************************
     C     SRRFRR        BEGSR

     C                   IF        DDRFRR = *BLANKS

      ** Default value from base rate code
     C                   IF        ApiName = 'CLIP'
     C                   EVAL      DDRFRR = BARFRR
     C                   ENDIF

     C                   ENDIF

      ** Value must exist on ARR Calculator Parameter Details File
     C                   IF        DDBLRT = 'Y'

     C                   EVAL      KSCRFLD = 'RFR'
     C                   EVAL      KINTVAL = DDRFRR
     C     KLIBR         CHAIN     SDLIBRTD
     C                   IF        NOT %FOUND(SDLIBRTD)
     C                   EVAL      DDRFRROK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDRFRR'
     C                   EVAL      MsgIdXAr(Idx) = '5049404'
     C                   ENDIF

     C                   ENDIF

      ** Entry is prohibited if Backward Looking Rate Indicator is 'N'
     C                   IF        DDBLRT = 'N' and
     C                             DDRFRR <> *BLANKS
     C                   EVAL      DDRFRROK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDRFRR'
     C                   EVAL      MsgIdXAr(Idx) = '5049405'
     C                   ENDIF

     C                   IF        DDRFRROK <> 'N'
     C                   MOVE      DDRFRR        VRFRR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCALM - Validate Calculation Method Field                   *
      *****************************************************************
     C     SRCALM        BEGSR

     C                   IF        DDCALM = *BLANKS

      ** Default value from base rate code
     C                   IF        ApiName = 'CLIP'
     C                   EVAL      DDCALM = BACALM
     C                   ENDIF

     C                   ENDIF

      ** Value must exist on ARR Calculator Parameter Details File
     C                   IF        DDBLRT = 'Y'

     C                   EVAL      KSCRFLD = 'METHOD'
     C                   EVAL      KINTVAL = DDCALM
     C     KLIBR         CHAIN     SDLIBRTD
     C                   IF        NOT %FOUND(SDLIBRTD)
     C                   EVAL      DDCALMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCALM'
     C                   EVAL      MsgIdXAr(Idx) = '5049406'
     C                   ENDIF

     C                   ENDIF

      ** Entry is prohibited if Backward Looking Rate Indicator is 'N'
     C                   IF        DDBLRT = 'N' and
     C                             DDCALM <> *BLANKS
     C                   EVAL      DDCALMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCALM'
     C                   EVAL      MsgIdXAr(Idx) = '5049407'
     C                   ENDIF

     C                   IF        DDCALMOK <> 'N'
     C                   MOVE      DDCALM        VCALM
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRBADJ - Validate Benchmark Adjustment Field                 *
      *****************************************************************
     C     SRBADJ        BEGSR

     C                   EVAL      WNumBADJ = 0
     C                   IF        DDBADJ = *BLANKS

      ** Default value from base rate code
     C                   IF        ApiName = 'CLIP'
     C                   EVAL      WNumBADJ = BABADJ
     C                   ENDIF

     C                   ENDIF

      ** Value must be numeric not exceeding 4 int and 7 decimal places
     C                   IF        DDBLRT = 'Y' and
     C                             DDBADJ <> *BLANKS

     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDBADJ        @@ALPH
     C                   CALLB     'ZA0841'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM      7             @@IDP
     C                   PARM      4             @@IINT
     C                   PARM      'N'           @@MTID
     C                   PARM      *ZERO         @@ERCD
     C                   PARM      *ZERO         @@AMT
     C                   PARM                    BNDCSP

     C                   IF        @@ERCD <> *ZERO
     C                   EVAL      DDBADJOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDBADJ'
     C                   EVAL      MsgIdXAr(Idx) = '5049426'
     C                   ELSE

     C                   EVAL      WSign = *BLANK
     C                   IF        @@AMT < 0
     C                   Z-SUB     @@AMT         @@AMT
     C                   EVAL      WSign = '-'
     C                   ENDIF
     C                   MOVE      @@AMT         @@ALPH
     C                   MOVE      @@ALPH        WNumBADJ
     C                   IF        WSign = '-'
     C                   Z-SUB     WNumBADJ      WNumBADJ
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** Entry is prohibited if Backward Looking Rate Indicator is 'N'
     C                   IF        DDBLRT = 'N' and
     C                             DDBADJ <> *BLANKS
     C                   EVAL      DDBADJOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDBADJ'
     C                   EVAL      MsgIdXAr(Idx) = '5049401'
     C                   ENDIF

     C                   IF        DDBADJOK <> 'N'
     C                   Z-ADD     WNumBADJ      VBADJ
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRFLOR - Validate Floor Field                                *
      *****************************************************************
     C     SRFLOR        BEGSR

     C                   EVAL      WNumFLOR = 0
     C                   IF        DDFLOR = *BLANKS

      ** Default value from base rate code
     C                   IF        ApiName = 'CLIP'
     C                   EVAL      WNumFLOR = BAFLOR
     C                   ENDIF

     C                   ENDIF

      ** Value must be numeric not exceeding 4 int and 7 decimal places
     C                   IF        DDBLRT = 'Y' and
     C                             DDFLOR <> *BLANKS

     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDFLOR        @@ALPH
     C                   CALLB     'ZA0841'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM      7             @@IDP
     C                   PARM      4             @@IINT
     C                   PARM      'N'           @@MTID
     C                   PARM      *ZERO         @@ERCD
     C                   PARM      *ZERO         @@AMT
     C                   PARM                    BNDCSP

     C                   IF        @@ERCD <> *ZERO
     C                   EVAL      DDFLOROK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDFLOR'
     C                   EVAL      MsgIdXAr(Idx) = '5049408'
     C                   ELSE

     C                   EVAL      WSign = *BLANK
     C                   IF        @@AMT < 0
     C                   Z-SUB     @@AMT         @@AMT
     C                   EVAL      WSign = '-'
     C                   ENDIF
     C                   MOVE      @@AMT         @@ALPH
     C                   MOVE      @@ALPH        WNumFlor
     C                   IF        WSign = '-'
     C                   Z-SUB     WNumFlor      WNumFlor
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** Entry is prohibited if Backward Looking Rate Indicator is 'N'
     C                   IF        DDBLRT = 'N' and
     C                             DDFLOR <> *BLANKS
     C                   EVAL      DDFLOROK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDFLOR'
     C                   EVAL      MsgIdXAr(Idx) = '5049409'
     C                   ENDIF

     C                   IF        DDFLOROK <> 'N'
     C                   Z-ADD     WNumFLOR      VFLOR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRLBDY - Validate Lookback Days Field                        *
      *****************************************************************
     C     SRLBDY        BEGSR

     C                   EVAL      WDAY = 0
     C                   IF        DDLBDY = *BLANKS

      ** Default value from base rate code
     C                   IF        ApiName = 'CLIP'
     C                   EVAL      WDAY = BALBDY
     C                   ENDIF

     C                   ENDIF

      ** Value must be numeric from 00 to 99
     C                   IF        DDBLRT = 'Y' and
     C                             DDLBDY <> *BLANKS

     C                   IF        DDLBDY < '00' or
     C                             DDLBDY > '99'
     C                   EVAL      DDLBDYOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDLBDY'
     C                   EVAL      MsgIdXAr(Idx) = '5049423'
     C                   ELSE
     C                   MOVEL     DDLBDY        WDAY
     C                   ENDIF

     C                   ENDIF

      ** Entry is prohibited if Backward Looking Rate Indicator is 'N'
     C                   IF        DDBLRT = 'N' and
     C                             DDLBDY <> *BLANKS and
     C                             DDLBDY <> '00'
     C                   EVAL      DDLBDYOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDLBDY'
     C                   EVAL      MsgIdXAr(Idx) = '5049420'
     C                   ENDIF

     C                   IF        DDLBDYOK <> 'N'
     C                   MOVEL     WDAY          DDLBDY
     C                   Z-ADD     WDAY          VLBDY
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRLODY - Validate Lockout Days Field                         *
      *****************************************************************
     C     SRLODY        BEGSR

     C                   EVAL      WDAY = 0
     C                   IF        DDLODY = *BLANKS

      ** Default value from base rate code
     C                   IF        ApiName = 'CLIP'
     C                   EVAL      WDAY = BALODY
     C                   ENDIF

     C                   ENDIF

      ** Value must be numeric from 00 to 99
     C                   IF        DDBLRT = 'Y' and
     C                             DDLODY <> *BLANKS

     C                   IF        DDLODY < '00' or
     C                             DDLODY > '99'
     C                   EVAL      DDLODYOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDLODY'
     C                   EVAL      MsgIdXAr(Idx) = '5049424'
     C                   ELSE
     C                   MOVEL     DDLODY        WDAY
     C                   ENDIF

     C                   ENDIF

      ** Entry is prohibited if Backward Looking Rate Indicator is 'N'
     C                   IF        DDBLRT = 'N' and
     C                             DDLODY <> *BLANKS and
     C                             DDLODY <> '00'
     C                   EVAL      DDLBDYOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDLODY'
     C                   EVAL      MsgIdXAr(Idx) = '5049421'
     C                   ENDIF

     C                   IF        DDLODYOK <> 'N'
     C                   MOVEL     WDAY          DDLODY
     C                   Z-ADD     WDAY          VLODY
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SROPSH - Validate Observation Period Shift Field             *
      *****************************************************************
     C     SROPSH        BEGSR

      ** Default value depending on where this program is called
     C                   IF        DDOPSH = *BLANKS
     C                   SELECT

      ** Default to 'N' if blank
     C                   WHEN      ApiName = 'BSRT'
     C                   EVAL      DDOPSH = 'N'

      ** Default value from base rate code
     C                   WHEN      ApiName = 'CLIP'
     C                   EVAL      DDOPSH = BAOPSH

     C                   ENDSL
     C                   ENDIF

     C                   IF        DDBLRT = 'Y'

      ** Value must be 'Y' or 'N'
     C                   IF        DDOPSH <> 'Y' and
     C                             DDOPSH <> 'N'
     C                   EVAL      DDOPSHOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDOPSH'
     C                   EVAL      MsgIdXAr(Idx) = '5049410'
     C                   ELSE

      ** Cannot be 'Y' if Calculation Method is Simple ARR
     C                   IF        VCALM = 'SARR' and
     C                             DDOPSH = 'Y'
     C                   EVAL      DDOPSHOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDOPSH'
     C                   EVAL      MsgIdXAr(Idx) = '5049412'
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** Entry is prohibited if Backward Looking Rate Indicator is 'N'
     C                   IF        DDBLRT = 'N' and
     C                             DDOPSH <> 'N'
     C                   EVAL      DDOPSHOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDOPSH'
     C                   EVAL      MsgIdXAr(Idx) = '5049417'
     C                   ENDIF

     C                   IF        DDOPSHOK <> 'N'
     C                   MOVE      DDOPSH        VOPSH
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRRDP - Validate Rate Rounding Decimal Places               *
      *****************************************************************
     C     SRRRDP        BEGSR

     C                   EVAL      WDAY = 0

      ** Default value depending on where this program is called
     C                   IF        DDRRDP = *BLANKS
     C                   SELECT

      ** Default to '05' if blank
     C                   WHEN      ApiName = 'BSRT'
     C                   EVAL      WDAY = 05

      ** Default value from base rate code
     C                   WHEN      ApiName = 'CLIP'
     C                   EVAL      WDAY = BARRDP

     C                   ENDSL
     C                   ENDIF

      ** Value must be numeric from 02 to 12
     C                   IF        DDBLRT = 'Y' and
     C                             DDRRDP <> *BLANKS

     C                   IF        DDRRDP < '02' or
     C                             DDRRDP > '12'
     C                   EVAL      DDRRDPOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDRRDP'
     C                   EVAL      MsgIdXAr(Idx) = '5049422'
     C                   ELSE
     C                   MOVEL     DDRRDP        WDAY
     C                   ENDIF

     C                   ENDIF

      ** Entry is prohibited if Backward Looking Rate Indicator is 'N'
     C                   IF        DDBLRT = 'N' and
     C                             DDRRDP <> *BLANKS and
     C                             DDRRDP <> '00'
     C                   EVAL      DDRRDPOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDRRDP'
     C                   EVAL      MsgIdXAr(Idx) = '5049425'
     C                   ENDIF

     C                   IF        DDRRDPOK <> 'N'
     C                   MOVEL     WDAY          DDRRDP
     C                   Z-ADD     WDAY          VRRDP
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRDBAV - Validate Day Basis for Average Field                *
      *****************************************************************
     C     SRDBAV        BEGSR

     C                   EVAL      WDBAV = 0
     C                   IF        DDDBAV = *BLANKS

      ** Default value from base rate code
     C                   IF        ApiName = 'CLIP'
     C                   EVAL      WDBAV = BADBAV
     C                   MOVEL     BADBAV        DDDBAV
     C                   ENDIF

     C                   ENDIF

      ** Value must exist on ARR Calculator Parameter Details File
     C                   IF        DDBLRT = 'Y'

     C                   EVAL      KSCRFLD = 'DAYCOUNT'
     C                   EVAL      KINTVAL = DDDBAV
     C     KLIBR         CHAIN     SDLIBRTD
     C                   IF        NOT %FOUND(SDLIBRTD)
     C                   EVAL      DDDBAVOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDBAV'
     C                   EVAL      MsgIdXAr(Idx) = '5049453'
     C                   ELSE
     C                   MOVEL     DDDBAV        WDBAV
     C                   ENDIF

      ** If value from the base rate code is zero,
      ** default from the Interest Calculation Basis (ICBS)
      ** Map ICBS 3 & 5 to Act/360, 4 to Act/365
     C                   IF        DDDBAVOK <> 'N'
     C                   IF        ApiName = 'CLIP' and
     C                             WDBAV = 0

     C                   SELECT
     C                   WHEN      TransICBS = 3 or
     C                             TransICBS = 5
     C                   Z-ADD     2             WDBAV
     C                   WHEN      TransICBS = 4
     C                   Z-ADD     3             WDBAV
     C                   OTHER
     C                   Z-ADD     TransICBS     WDBAV
     C                   ENDSL

     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

      ** Entry is prohibited if Backward Looking Rate Indicator is 'N'
     C                   IF        DDBLRT = 'N' and
     C                             DDDBAV <> *BLANKS
     C                   EVAL      DDDBAVOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDBAV'
     C                   EVAL      MsgIdXAr(Idx) = '5049455'
     C                   ENDIF

     C                   IF        DDDBAVOK <> 'N'
     C                   MOVEL     WDBAV         DDDBAV
     C                   Z-ADD     WDBAV         VDBAV
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRTKN - Populate Rates Known Field                          *
      *****************************************************************
     C     SRRTKN        BEGSR

      ** Default value to 'N' when transaction is created
     C                   IF        ApiName = 'CLIP' and
     C                             TransCHTP = 'I'
     C                   EVAL      DDRTKN = 'N'
     C                   EVAL      VRTKN = 'N'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    ApiName
     C                   PARM                    TransRef
     C                   PARM                    TransType
     C                   PARM                    TransCCY
     C                   PARM                    TransBSRC
     C                   PARM                    TransICBS
     C                   PARM                    TransCHTP
     C                   PARM                    InpScrfld
     C                   PARM                    Idx
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    OutValfld
     C                   PARM                    RetCodeOut

     C     KLIBR         KLIST
     C                   KFLD                    KSCRFLD
     C                   KFLD                    KINTVAL

      ** Access Dealing details to get the Decimal Separator setting
     C                   CALL      'AODEALR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDDEAL        PARM      SDDEAL        DSSDY

     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      BNDCSP =  '.'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        @RUN = *BLANK
     C                   DUMP
     C                   EVAL      @RUN = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2020
** WLPtyp ** Array for allowed processing type for loan
616264666869707172
