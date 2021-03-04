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
      *  Last Amend No. CLE172             Date 01Oct20               *
      *  Prev Amend No. CSD103  *CREATE    Date 01Aug20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE172 - LIBOR Deregulation - Lending                        *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *    U7, U8     Database error                                  *
      *    80         BSRC and CCY are not in SDBSRTPD                *
      *    90         End of File for CLOANCL                         *
      *    20         TransRef not in CLOANCL (LERI API)              *                       CLE172
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
      *  SRRTKN - Populate Rates Known Field                          *   	               CLE172				
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
     D TransICBS       S              1S 0                                                    CLE172
     D TransCHTP       S              1A                                                      CLE172

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
     D WSTRAMT         S              1A   DIM(13)
     D INTAMT          S              4A
     D DECAMT          S              7A
     D WNUMAMT1        S             11P 7
     D WNUMAMT2        S             11P 7
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
     D DDRTKNOK        S              1A                                                      CLE172

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

     C                   IF        ApiName = 'CLIP' or                                        CLE172
     C                             ApiName = 'LERI'                                           CLE172
     C                   EVAL      BNDCSP = '.'                                               CLE172
     C                   ENDIF                                                                CLE172
                                                                                              CLE172
      ** If transaction is LERI, default from CLOANCL                                         CLE172
     C                   IF        ApiName = 'LERI'                                           CLE172
                                                                                              CLE172
     C     TransRef      CHAIN     LECLIPL2      CLOANL               20                      CLE172
                                                                                              CLE172
     C                   ENDIF                                                                CLE172

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

      ** Populate Rates Known                                                                 CLE172
     C                   EXSR      SRRTKN                                                     CLE172

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
     C                   EVAL      DDRTKNOK = *BLANK                                          CLE172

      ** Reset Indicators
     C                   SETOFF                                       20
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

      ** Default value from base rate code                                                    CLE172
     C                   WHEN      ApiName = 'CLIP'                                           CLE172
     C                   EVAL      DDBLRT = BABLRT                                            CLE172
                                                                                              CLE172
      ** Default value from loan details                                                      CLE172
     C                   WHEN      ApiName = 'LERI'                                           CLE172
     C                   EVAL      DDBLRT = CLBLRT                                            CLE172

     C                   ENDSL
     C                   ENDIF

      ** Value must be 'Y' or 'N'
     C                   IF        DDBLRT <> 'Y' and
     C                             DDBLRT <> 'N'
     C                   EVAL      DDBLRTOK = 'N'
     C                   EVAL      Idx = Idx + 1
      ** Use BLRT Next Fields if LERI                                                         CLE172
     C                   IF        ApiName = 'LERI'                                           CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDNBLRT'                                 CLE172
     C                   ELSE                                                                 CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDBLRT'
     C                   ENDIF                                                                CLE172
     C                   EVAL      MsgIdXAr(Idx) = '5049400'
     C                   ELSE                                                                 CLE172
                                                                                              CLE172
      ** Issue error if the loan type used is not allowed for                                 CLE172
      ** backward looking rate                                                                CLE172
     C                   IF        ApiName = 'CLIP'                                           CLE172
                                                                                              CLE172
     C                   IF        %LOOKUP(TransType:WLPtyp) = 0 and                          CLE172
     C                             DDBLRT = 'Y'                                               CLE172
     C                   EVAL      DDBLRTOK = 'N'                                             CLE172
     C                   EVAL      Idx = Idx + 1                                              CLE172
      ** Use BLRT Next Fields if LERI                                                         CLE172
     C                   IF        ApiName = 'LERI'                                           CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDNBLRT'                                 CLE172
     C                   ELSE                                                                 CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDBLRT'                                  CLE172
     C                   ENDIF                                                                CLE172
     C                   EVAL      MsgIdXAr(Idx) = '5049403'                                  CLE172
     C                   ENDIF                                                                CLE172
     C                                                                                        CLE172
     C                   ENDIF                                                                CLE172

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

     C                   ENDIF                                                                CLE172

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

     C                   IF        DDRFRR = *BLANKS                                           CLE172
     C                   SELECT                                                               CLE172
                                                                                              CLE172
      ** Default value from base rate code                                                    CLE172
     C                   WHEN      ApiName = 'CLIP'                                           CLE172
     C                   EVAL      DDRFRR = BARFRR                                            CLE172
                                                                                              CLE172
      ** Default value from loan details                                                      CLE172
     C                   WHEN      ApiName = 'LERI'                                           CLE172
     C                   IF        DDBLRT = 'Y'                                               CLE172
     C                   EVAL      DDRFRR = CLRFRR                                            CLE172
     C                   ENDIF                                                                CLE172
                                                                                              CLE172
     C                   ENDSL                                                                CLE172
     C                   ENDIF                                                                CLE172

      ** Value must exist on ARR Calculator Parameter Details File
     C                   IF        DDBLRT = 'Y'

     C                   EVAL      KSCRFLD = 'RFR'
     C                   EVAL      KINTVAL = DDRFRR
     C     KLIBR         CHAIN     SDLIBRTD
     C                   IF        NOT %FOUND(SDLIBRTD)
     C                   EVAL      DDRFRROK = 'N'
     C                   EVAL      Idx = Idx + 1
      ** Use BLRT Next Fields if LERI
     C                   IF        ApiName = 'LERI'                                           CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDNRFRR'                                 CLE172
     C                   ELSE                                                                 CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDRFRR'
     C                   ENDIF                                                                CLE172
     C                   EVAL      MsgIdXAr(Idx) = '5049404'
     C                   ENDIF

     C                   ENDIF

      ** Entry is prohibited if Backward Looking Rate Indicator is 'N'
     C                   IF        DDBLRT = 'N' and
     C                             DDRFRR <> *BLANKS
     C                   EVAL      DDRFRROK = 'N'
     C                   EVAL      Idx = Idx + 1
      ** Use BLRT Next Fields if LERI                                                         CLE172
     C                   IF        ApiName = 'LERI'                                           CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDNRFRR'                                 CLE172
     C                   ELSE                                                                 CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDRFRR'
     C                   ENDIF                                                                CLE172
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

     C                   IF        DDCALM = *BLANKS                                           CLE172
     C                   SELECT                                                               CLE172
                                                                                              CLE172
      ** Default value from base rate code                                                    CLE172
     C                   WHEN      ApiName = 'CLIP'                                           CLE172
     C                   EVAL      DDCALM = BACALM                                            CLE172
                                                                                              CLE172
      ** Default value from loan details                                                      CLE172
     C                   WHEN      ApiName = 'LERI'                                           CLE172
     C                   IF        DDBLRT = 'Y'                                               CLE172
     C                   EVAL      DDCALM = CLCALM                                            CLE172
     C                   ENDIF                                                                CLE172
                                                                                              CLE172
     C                   ENDSL                                                                CLE172
     C                   ENDIF                                                                CLE172

      ** Value must exist on ARR Calculator Parameter Details File
     C                   IF        DDBLRT = 'Y'

     C                   EVAL      KSCRFLD = 'METHOD'
     C                   EVAL      KINTVAL = DDCALM
     C     KLIBR         CHAIN     SDLIBRTD
     C                   IF        NOT %FOUND(SDLIBRTD)
     C                   EVAL      DDCALMOK = 'N'
     C                   EVAL      Idx = Idx + 1
      ** Use BLRT Next Fields if LERI                                                         CLE172
     C                   IF        ApiName = 'LERI'                                           CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDNCALM'                                 CLE172
     C                   ELSE                                                                 CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDCALM'
     C                   ENDIF                                                                CLE172
     C                   EVAL      MsgIdXAr(Idx) = '5049406'
     C                   ENDIF

     C                   ENDIF

      ** Entry is prohibited if Backward Looking Rate Indicator is 'N'
     C                   IF        DDBLRT = 'N' and
     C                             DDCALM <> *BLANKS
     C                   EVAL      DDCALMOK = 'N'
     C                   EVAL      Idx = Idx + 1
      ** Use BLRT Next Fields if LERI                                                         CLE172
     C                   IF        ApiName = 'LERI'                                           CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDNCALM'                                 CLE172
     C                   ELSE                                                                 CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDCALM'
     C                   ENDIF                                                                CLE172
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
     C                   IF        DDBADJ = *BLANKS                                           CLE172
     C                   SELECT                                                               CLE172
                                                                                              CLE172
      ** Default value from base rate code                                                    CLE172
     C                   WHEN      ApiName = 'CLIP'                                           CLE172
     C                   EVAL      WNumBADJ = BABADJ                                          CLE172
                                                                                              CLE172
      ** Default value from loan details                                                      CLE172
     C                   WHEN      ApiName = 'LERI'                                           CLE172
     C                   EVAL      WNumBADJ = CLBADJ                                          CLE172
                                                                                              CLE172
     C                   ENDSL                                                                CLE172
     C                   ENDIF                                                                CLE172

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
      ** Use BLRT Next Fields if LERI                                                         CLE172
     C                   IF        ApiName = 'LERI'                                           CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDNBADJ'                                 CLE172
     C                   ELSE                                                                 CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDBADJ'
     C                   ENDIF                                                                CLE172
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
     C                             DDBADJ <> *BLANKS and
     C                             %TRIMR(DDBADJ) <> '0'
     C                   EVAL      DDBADJOK = 'N'
     C                   EVAL      Idx = Idx + 1
      ** Use BLRT Next Fields if LERI                                                         CLE172
     C                   IF        ApiName = 'LERI'                                           CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDNBADJ'                                 CLE172
     C                   ELSE                                                                 CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDBADJ'
     C                   ENDIF                                                                CLE172
     C                   EVAL      MsgIdXAr(Idx) = '5049401'
     C                   ENDIF

     C                   IF        DDBADJOK <> 'N'
      ** Assign value to screen field if user input is blank
     C                   IF        DDBADJ = *BLANKS
     C                   EVAL      WNUMAMT1 = WNumBADJ
     C                   EXSR      FMTAMT
     C                   MOVE      @@ALPH        DDBADJ
     C                   ENDIF
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
     C                   IF        DDFLOR = *BLANKS                                           CLE172
     C                   SELECT                                                               CLE172
                                                                                              CLE172
      ** Default value from base rate code                                                    CLE172
     C                   WHEN      ApiName = 'CLIP'                                           CLE172
     C                   EVAL      WNumFLOR = BAFLOR                                          CLE172
                                                                                              CLE172
      ** Default value from loan details                                                      CLE172
     C                   WHEN      ApiName = 'LERI'                                           CLE172
     C                   EVAL      WNumFLOR = CLFLOR                                          CLE172
                                                                                              CLE172
     C                   ENDSL                                                                CLE172
     C                   ENDIF                                                                CLE172

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
      ** Use BLRT Next Fields if LERI                                                         CLE172
     C                   IF        ApiName = 'LERI'                                           CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDNFLOR'                                 CLE172
     C                   ELSE                                                                 CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDFLOR'
     C                   ENDIF                                                                CLE172
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
     C                             DDFLOR <> *BLANKS and
     C                             %TRIMR(DDFLOR) <> '0'
     C                   EVAL      DDFLOROK = 'N'
     C                   EVAL      Idx = Idx + 1
      ** Use BLRT Next Fields if LERI                                                         CLE172
     C                   IF        ApiName = 'LERI'                                           CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDNFLOR'                                 CLE172
     C                   ELSE                                                                 CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDFLOR'
     C                   ENDIF                                                                CLE172
     C                   EVAL      MsgIdXAr(Idx) = '5049409'
     C                   ENDIF

     C                   IF        DDFLOROK <> 'N'
      ** Assign value to screen field if user input is blank
     C                   IF        DDFLOR = *BLANKS
     C                   EVAL      WNUMAMT1 = WNumFLOR
     C                   EXSR      FMTAMT
     C                   MOVE      @@ALPH        DDFLOR
     C                   ENDIF
     C                   Z-ADD     WNumFLOR      VFLOR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRLBDY - Validate Lookback Days Field                        *
      *****************************************************************
     C     SRLBDY        BEGSR

     C                   MOVE      '00'          WDAY
     C                   IF        DDLBDY = *BLANKS

     C                   SELECT                                                               CLE172
                                                                                              CLE172
      ** Default value from base rate code                                                    CLE172
     C                   WHEN      ApiName = 'CLIP'                                           CLE172
     C                   MOVE      BALBDY        WDAY                                         CLE172
                                                                                              CLE172
      ** Default value from loan details                                                      CLE172
     C                   WHEN      ApiName = 'LERI'                                           CLE172
     C                   MOVE      CLLBDY        WDAY                                         CLE172
                                                                                              CLE172
     C                   ENDSL                                                                CLE172

     C                   ELSE

      ** Use ZA0841 on input to allow single digit entry in form
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDLBDY        @@ALPH
     C                   CALLB     'ZA0841'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM      0             @@IDP
     C                   PARM      2             @@IINT
     C                   PARM      'N'           @@MTID
     C                   PARM      *ZERO         @@ERCD
     C                   PARM      *ZERO         @@AMT
     C                   PARM                    BNDCSP

     C                   EVAL      WSign = *BLANK
     C                   IF        @@AMT < 0
     C                   Z-SUB     @@AMT         @@AMT
     C                   EVAL      WSign = '-'
     C                   ENDIF
     C                   MOVE      @@ALPH        WDAY
     C                   IF        WSign = '-'
     C                   Z-SUB     WDAY          WDAY
     C                   ENDIF

     C                   ENDIF                                                                CLE172

      ** Value must be numeric from 00 to 99
     C                   IF        DDBLRT = 'Y' and
     C                             DDLBDY <> *BLANKS

     C                   IF        WDAY < 0 or
     C                             WDAY > 99 or
     C                             @@ERCD <> 0
     C                   EVAL      DDLBDYOK = 'N'
     C                   EVAL      Idx = Idx + 1
      ** Use BLRT Next Fields if LERI                                                         CLE172
     C                   IF        ApiName = 'LERI'                                           CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDNLBDY'                                 CLE172
     C                   ELSE                                                                 CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDLBDY'
     C                   ENDIF                                                                CLE172
     C                   EVAL      MsgIdXAr(Idx) = '5049423'
     C                   ENDIF

     C                   ENDIF

      ** Entry is prohibited if Backward Looking Rate Indicator is 'N'
     C                   IF        DDBLRT = 'N' and
     C                             DDLBDY <> *BLANKS and
     C                             %TRIMR(DDLBDY) <> '0'
     C                   EVAL      DDLBDYOK = 'N'
     C                   EVAL      Idx = Idx + 1
      ** Use BLRT Next Fields if LERI                                                         CLE172
     C                   IF        ApiName = 'LERI'                                           CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDNLBDY'                                 CLE172
     C                   ELSE                                                                 CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDLBDY'
     C                   ENDIF                                                                CLE172
     C                   EVAL      MsgIdXAr(Idx) = '5049420'
     C                   ENDIF

     C                   IF        DDLBDYOK <> 'N'
     C                   MOVE      WDAY          DDLBDY
     C                   MOVE      WDAY          VLBDY
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRLODY - Validate Lockout Days Field                         *
      *****************************************************************
     C     SRLODY        BEGSR

     C                   MOVE      '00'          WDAY
     C                   IF        DDLODY = *BLANKS

     C                   SELECT                                                               CLE172
                                                                                              CLE172
      ** Default value from base rate code                                                    CLE172
     C                   WHEN      ApiName = 'CLIP'                                           CLE172
     C                   MOVE      BALODY        WDAY                                         CLE172
                                                                                              CLE172
      ** Default value from loan details                                                      CLE172
     C                   WHEN      ApiName = 'LERI'                                           CLE172
     C                   MOVE      CLLODY        WDAY                                         CLE172
                                                                                              CLE172
     C                   ENDSL                                                                CLE172

     C                   ELSE

      ** Use ZA0841 on input to allow single digit entry in form
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDLODY        @@ALPH
     C                   CALLB     'ZA0841'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM      0             @@IDP
     C                   PARM      2             @@IINT
     C                   PARM      'N'           @@MTID
     C                   PARM      *ZERO         @@ERCD
     C                   PARM      *ZERO         @@AMT
     C                   PARM                    BNDCSP

     C                   EVAL      WSign = *BLANK
     C                   IF        @@AMT < 0
     C                   Z-SUB     @@AMT         @@AMT
     C                   EVAL      WSign = '-'
     C                   ENDIF
     C                   MOVE      @@ALPH        WDAY
     C                   IF        WSign = '-'
     C                   Z-SUB     WDAY          WDAY
     C                   ENDIF

     C                   ENDIF

      ** Value must be numeric from 00 to 99
     C                   IF        DDBLRT = 'Y' and
     C                             DDLODY <> *BLANKS

     C                   IF        WDAY < 0 or
     C                             WDAY > 99 or
     C                             @@ERCD <> 0
     C                   EVAL      DDLODYOK = 'N'
     C                   EVAL      Idx = Idx + 1
      ** Use BLRT Next Fields if LERI                                                         CLE172
     C                   IF        ApiName = 'LERI'                                           CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDNLODY'                                 CLE172
     C                   ELSE                                                                 CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDLODY'
     C                   ENDIF                                                                CLE172
     C                   EVAL      MsgIdXAr(Idx) = '5049424'
     C                   ENDIF

     C                   ENDIF

      ** Entry is prohibited if Backward Looking Rate Indicator is 'N'
     C                   IF        DDBLRT = 'N' and
     C                             DDLODY <> *BLANKS and
     C                             %TRIMR(DDLODY) <> '0'
     C                   EVAL      DDLODYOK = 'N'
     C                   EVAL      Idx = Idx + 1
      ** Use BLRT Next Fields if LERI                                                         CLE172
     C                   IF        ApiName = 'LERI'                                           CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDNLODY'                                 CLE172
     C                   ELSE                                                                 CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDLODY'
     C                   ENDIF                                                                CLE172
     C                   EVAL      MsgIdXAr(Idx) = '5049421'
     C                   ENDIF

     C                   IF        DDLODYOK <> 'N'
     C                   MOVE      WDAY          DDLODY
     C                   MOVE      WDAY          VLODY
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

      ** Default value from base rate code                                                    CLE172
     C                   WHEN      ApiName = 'CLIP'                                           CLE172
     C                   EVAL      DDOPSH = BAOPSH                                            CLE172
                                                                                              CLE172
      ** Default value from loan details                                                      CLE172
     C                   WHEN      ApiName = 'LERI'                                           CLE172
     C                   IF        DDBLRT = 'Y'                                               CLE172
     C                   EVAL      DDOPSH = CLOPSH                                            CLE172
     C                   ELSE                                                                 CLE172
     C                   IF        DDBLRT = 'N'                                               CLE172
     C                   EVAL      DDOPSH = 'N'                                               CLE172
     C                   ENDIF                                                                CLE172
     C                   ENDIF                                                                CLE172

     C                   ENDSL
     C                   ENDIF

     C                   IF        DDBLRT = 'Y'

      ** Value must be 'Y' or 'N'
     C                   IF        DDOPSH <> 'Y' and
     C                             DDOPSH <> 'N'
     C                   EVAL      DDOPSHOK = 'N'
     C                   EVAL      Idx = Idx + 1
      ** Use BLRT Next Fields if LERI                                                         CLE172
     C                   IF        ApiName = 'LERI'                                           CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDNOPSH'                                 CLE172
     C                   ELSE                                                                 CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDOPSH'
     C                   ENDIF                                                                CLE172
     C                   EVAL      MsgIdXAr(Idx) = '5049410'
     C                   ELSE

      ** Cannot be 'Y' if Calculation Method is Simple ARR
     C                   IF        VCALM = 'SARR' and
     C                             DDOPSH = 'Y'
     C                   EVAL      DDOPSHOK = 'N'
     C                   EVAL      Idx = Idx + 1
      ** Use BLRT Next Fields if LERI                                                         CLE172
     C                   IF        ApiName = 'LERI'                                           CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDNOPSH'                                 CLE172
     C                   ELSE                                                                 CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDOPSH'
     C                   ENDIF                                                                CLE172
     C                   EVAL      MsgIdXAr(Idx) = '5049412'
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** Entry is prohibited if Backward Looking Rate Indicator is 'N'
     C                   IF        DDBLRT = 'N' and
     C                             DDOPSH <> 'N'
     C                   EVAL      DDOPSHOK = 'N'
     C                   EVAL      Idx = Idx + 1
      ** Use BLRT Next Fields if LERI                                                         CLE172
     C                   IF        ApiName = 'LERI'                                           CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDNOPSH'                                 CLE172
     C                   ELSE                                                                 CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDOPSH'
     C                   ENDIF                                                                CLE172
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

     C                   MOVE      '00'          WDAY

      ** Default value depending on where this program is called
     C                   IF        DDRRDP = *BLANKS

     C                   SELECT

      ** Default to '05'
     C                   WHEN      ApiName = 'BSRT'
     C                   MOVE      '05'          WDAY

      ** Default value from base rate code                                                    CLE172
     C                   WHEN      ApiName = 'CLIP'                                           CLE172
     C                   MOVE      BARRDP        WDAY                                         CLE172
                                                                                              CLE172
      ** Default value from loan details                                                      CLE172
     C                   WHEN      ApiName = 'LERI'                                           CLE172
     C                   MOVE      CLRRDP        WDAY                                         CLE172

     C                   ENDSL

     C                   ELSE

      ** Use ZA0841 on input to allow single digit entry in form
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDRRDP        @@ALPH
     C                   CALLB     'ZA0841'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM      0             @@IDP
     C                   PARM      2             @@IINT
     C                   PARM      'N'           @@MTID
     C                   PARM      *ZERO         @@ERCD
     C                   PARM      *ZERO         @@AMT
     C                   PARM                    BNDCSP

     C                   EVAL      WSign = *BLANK
     C                   IF        @@AMT < 0
     C                   Z-SUB     @@AMT         @@AMT
     C                   EVAL      WSign = '-'
     C                   ENDIF
     C                   MOVE      @@ALPH        WDAY
     C                   IF        WSign = '-'
     C                   Z-SUB     WDAY          WDAY
     C                   ENDIF

     C                   ENDIF

      ** Value must be numeric from 02 to 12
     C                   IF        DDBLRT = 'Y' and
     C                             DDRRDP <> *BLANKS

     C                   IF        WDAY < 2 or
     C                             WDAY > 12 or
     C                             @@ERCD <> 0
     C                   EVAL      DDRRDPOK = 'N'
     C                   EVAL      Idx = Idx + 1
      ** Use BLRT Next Fields if LERI                                                         CLE172
     C                   IF        ApiName = 'LERI'                                           CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDNRRDP'                                 CLE172
     C                   ELSE                                                                 CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDRRDP'
     C                   ENDIF                                                                CLE172
     C                   EVAL      MsgIdXAr(Idx) = '5049422'
     C                   ENDIF

     C                   ENDIF

      ** Entry is prohibited if Backward Looking Rate Indicator is 'N'
     C                   IF        DDBLRT = 'N' and
     C                             DDRRDP <> *BLANKS and
     C                             %TRIMR(DDRRDP) <> '0'
     C                   EVAL      DDRRDPOK = 'N'
     C                   EVAL      Idx = Idx + 1
      ** Use BLRT Next Fields if LERI                                                         CLE172
     C                   IF        ApiName = 'LERI'                                           CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDNRRDP'                                 CLE172
     C                   ELSE                                                                 CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDRRDP'
     C                   ENDIF                                                                CLE172
     C                   EVAL      MsgIdXAr(Idx) = '5049425'
     C                   ENDIF

     C                   IF        DDRRDPOK <> 'N'
     C                   MOVE      WDAY          DDRRDP
     C                   MOVE      WDAY          VRRDP
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRDBAV - Validate Day Basis for Average Field                *
      *****************************************************************
     C     SRDBAV        BEGSR

     C                   EVAL      WDBAV = 0
     C                   IF        DDDBAV = *BLANKS                                           CLE172
     C                   SELECT                                                               CLE172
                                                                                              CLE172
      ** Default value from base rate code                                                    CLE172
     C                   WHEN      ApiName = 'CLIP'                                           CLE172
     C                   EVAL      WDBAV = BADBAV                                             CLE172
     C                   MOVEL     BADBAV        DDDBAV                                       CLE172
                                                                                              CLE172
      ** Default value from loan details                                                      CLE172
     C                   WHEN      ApiName = 'LERI'                                           CLE172
     C                   IF        DDBLRT = 'Y'                                               CLE172
     C                   EVAL      WDBAV = CLDBAV                                             CLE172
     C                   MOVEL     CLDBAV        DDDBAV                                       CLE172
     C                   ENDIF                                                                CLE172
                                                                                              CLE172
     C                   ENDSL                                                                CLE172
     C                   ENDIF                                                                CLE172

      ** Value must exist on ARR Calculator Parameter Details File
     C                   IF        DDBLRT = 'Y'

     C                   EVAL      KSCRFLD = 'DAYCOUNT'
     C                   EVAL      KINTVAL = DDDBAV
     C     KLIBR         CHAIN     SDLIBRTD
     C                   IF        NOT %FOUND(SDLIBRTD)
     C                   EVAL      DDDBAVOK = 'N'
     C                   EVAL      Idx = Idx + 1
      ** Use BLRT Next Fields if LERI                                                         CLE172
     C                   IF        ApiName = 'LERI'                                           CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDNDBAV'                                 CLE172
     C                   ELSE                                                                 CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDDBAV'
     C                   ENDIF                                                                CLE172
     C                   EVAL      MsgIdXAr(Idx) = '5049453'
     C                   ELSE
     C                   MOVEL     DDDBAV        WDBAV
     C                   ENDIF

      ** If value from the base rate code is zero,                                            CLE172
      ** default from the Interest Calculation Basis (ICBS)                                   CLE172
      ** Map ICBS 3 & 5 to Act/360, 4 to Act/365                                              CLE172
     C                   IF        DDDBAVOK <> 'N'                                            CLE172
     C                   IF        ApiName = 'CLIP' and                                       CLE172
     C                             WDBAV = 0                                                  CLE172
                                                                                              CLE172
     C                   SELECT                                                               CLE172
     C                   WHEN      TransICBS = 3 or                                           CLE172
     C                             TransICBS = 5                                              CLE172
     C                   Z-ADD     2             WDBAV                                        CLE172
     C                   WHEN      TransICBS = 4                                              CLE172
     C                   Z-ADD     3             WDBAV                                        CLE172
     C                   OTHER                                                                CLE172
     C                   Z-ADD     TransICBS     WDBAV                                        CLE172
     C                   ENDSL                                                                CLE172
                                                                                              CLE172
     C                   ENDIF                                                                CLE172
     C                   ENDIF                                                                CLE172

     C                   ENDIF

      ** Entry is prohibited if Backward Looking Rate Indicator is 'N'
     C                   IF        DDBLRT = 'N' and
     C                             DDDBAV <> *BLANKS and
     C                             DDDBAV <> '0'
     C                   EVAL      DDDBAVOK = 'N'
     C                   EVAL      Idx = Idx + 1
      ** Use BLRT Next Fields if LERI                                                         CLE172
     C                   IF        ApiName = 'LERI'                                           CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDNDBAV'                                 CLE172
     C                   ELSE                                                                 CLE172
     C                   EVAL      FldNamXAr(Idx) = 'DDDBAV'
     C                   ENDIF                                                                CLE172
     C                   EVAL      MsgIdXAr(Idx) = '5049455'
     C                   ENDIF

     C                   IF        DDDBAVOK <> 'N'
     C                   MOVEL     WDBAV         DDDBAV
     C                   Z-ADD     WDBAV         VDBAV
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CLE172
      *  SRRTKN - Populate Rates Known Field                          *                       CLE172
      *****************************************************************                       CLE172
     C     SRRTKN        BEGSR                                                                CLE172
                                                                                              CLE172
      ** Default value to 'N' when transaction is created                                     CLE172
     C                   IF        ApiName = 'CLIP' and                                       CLE172
     C                             TransCHTP = 'I'                                            CLE172
     C                   EVAL      DDRTKN = 'N'                                               CLE172
     C                   EVAL      VRTKN = 'N'                                                CLE172
     C                   ENDIF                                                                CLE172
                                                                                              CLE172
     C                   ENDSR                                                                CLE172
      *****************************************************************                       CLE172
      /EJECT                                                                                  CLE172
      *****************************************************************
      *  FMTAMT - Format Amount                                       *
      *****************************************************************
     C     FMTAMT        BEGSR

     C                   EVAL      WNUMAMT2 = WNUMAMT1
     C                   IF        WNUMAMT2 < 0
     C                   Z-SUB     WNUMAMT2      WNUMAMT2
     C                   ENDIF
     C                   MOVEL     WNUMAMT2      INTAMT
     C                   MOVE      WNUMAMT2      DECAMT
     C                   IF        WNUMAMT1 < 0
     C                   MOVEA     '-'           WSTRAMT(1)
     C                   MOVEA     INTAMT        WSTRAMT(2)
     C                   MOVEA     BNDCSP        WSTRAMT(6)
     C                   MOVEA     DECAMT        WSTRAMT(7)
     C                   ELSE
     C                   MOVEA     INTAMT        WSTRAMT(1)
     C                   MOVEA     BNDCSP        WSTRAMT(5)
     C                   MOVEA     DECAMT        WSTRAMT(6)
     C                   ENDIF

     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVEA     WSTRAMT       @@ALPH
     C                   CALLB     'ZA0841'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM      7             @@IDP
     C                   PARM      4             @@IINT
     C                   PARM      'N'           @@MTID
     C                   PARM      *ZERO         @@ERCD
     C                   PARM      *ZERO         @@AMT
     C                   PARM                    BNDCSP

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
     C                   PARM                    TransICBS                                    CLE172
     C                   PARM                    TransCHTP                                    CLE172
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
     C                   EVAL      BNDCSP = '.'
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
