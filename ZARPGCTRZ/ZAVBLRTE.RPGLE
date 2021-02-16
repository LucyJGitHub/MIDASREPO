     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Validate backward-looking rate fields')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data module                                 *
      *                                                               *
      *  ZAVBLRTE - Validate backward-looking rate fields             *
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
      *  Last Amend No. CSD103 *CREATE     Date 10Aug20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7, U8     Database error                                  *
      *    20         No Loan reference found                         *
      *    29         No Loan reference input                         *
      *    30         No Currency and BaseRateCode input              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *  SDBLRT - Default  Backward-Looking Rate                      *
      *  SRBLRT - Validate Backward-Looking Rate                      *
      *  SDRFRR - Default  Risk Free Rate                             *
      *  SRRFRR - Validate Risk Free Rate                             *
      *  SDCALM - Default  Calculation Method                         *
      *  SRCALM - Validate Calculation Method                         *
      *  SDBADJ - Default  Benchmark Adjustment                       *
      *  SRBADJ - Validate Benchmark Adjustment                       *
      *  SDFLOR - Default  Floor                                      *
      *  SRFLOR - Validate Floor                                      *
      *  SDLBDY - Default  Lookback Days                              *
      *  SRLBDY - Validate Lookback Days                              *
      *  SDLODY - Default  Lockout Days                               *
      *  SRLODY - Validate Lockout Days                               *
      *  SDOPSH - Default  Observation Period Shift                   *
      *  SROPSH - Validate Observation Period Shift                   *
      *  SDDBAV - Default  Day Basis for Average                      *
      *  SRDBAV - Validate Day Basis for Average                      *
      *  SDRTKN - Default  Rates Known                                *
      *  SRRTKN - Validate Rates Known                                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

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

      *
      ** Program Status Data Structure
      *
     D/COPY ZACPYSRC,STD_D_SPEC

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** The maximum size of the appended error arrays
      *
     D XArrayMax       C                   CONST(40)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Array of fields in error
      *
     D FldNamXAr       S             10A   DIM(XArrayMax)
      *
      ** Array of error message IDs
      *
     D MsgIdXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
	
      *
      ** Array for Input
      *
     D ArrayInp        S              1A   DIM(200)

      *
      ** DS for Access Programs: Short Data Structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access programs: Long Sata Structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)

      *
      ** DS for SC Switchable Features
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** DS for Dealing details
      *
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D                                     PREFIX(DL)
      *
      ** DS for Base Rate details
      *
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
     D                                     PREFIX(B)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1

     D ApiName         S              4A

      *
      ** Index for arrays of error message ids
      *
     D Idx             S              3P 0
      *
      ** Passed index value
      *
     D Ix              S              3P 0

      *
      ** Input Screen fields
      *
     D InpScrfld       DS           200
      *
      ** Output Valid fields
      *
     D OutValfld       DS           200

      *
      ** BSRT Backward-Looking Rate Valid fields (Output)
      *
     D BsrtValfld      DS
     D  BVBLRT                 1      1A
     D  BVRFRR                 2     11A
     D  BVCALM                12     15A
     D  BVBADJ                16     22P 7
     D  BVFLOR                27     37P 7
     D  BVLBDY                42     43S 0
     D  BVLODY                44     45S 0
     D  BVOPSH                46     46A
     D  BVRRDP                47     48S 0
     D  BVDBAV                49     49S 0

      *
      ** Parameters for access objects
      *
     D PRTCD           S              7A
     D POPTN           S              7A
     D PKEY1           S              3A
     D PKEY2           S              2A
	
      *
      ** Parameters for calling ZA0841
      *
     D @@ALPH          S             16A
     D @@MTID          S              1A
     D @@AMT           S             15P 0
     D @@ERCD          S              1P 0
     D @@IDP           S              3P 0
     D @@IINT          S              3P 0

     D WDAY            S              2S 0
     D WNumBadj        S             11P 7
     D WNumFlor        S             11P 7
     D WSign           S              1A

      *
      ** Work fields for base rate key list
      *
     D WFCYCD          S              3A
     D WFBSRC          S              2A
      *
      ** Work fields for cloancl key list
      *
     D WFLNRF          S              6A

      *
      ** Generic screen fields
      *
     D  DDBLRT         S              1A
     D  DDRFRR         S             10A
     D  DDCALM         S              4A
     D  DDBADJ         S             13A
     D  DDFLOR         S             13A
     D  DDLBDY         S              2A
     D  DDLODY         S              2A
     D  DDOPSH         S              1A
     D  DDRRDP         S              2A
     D  DDDBAV         S              1A
     D  DDRTKN         S              1A

      *
      ** Generic valid fields
      *
     D  VBLRT          S              1A
     D  VRFRR          S             10A
     D  VCALM          S              4A
     D  VBADJ          S             11P 0
     D  VFLOR          S             11P 0
     D  VLBDY          S              2S 0
     D  VLODY          S              2S 0
     D  VOPSH          S              1A
     D  VRRDP          S              2S 0
     D  VDBAV          S              1S 0
     D  VRTKN          S              1A

      *
      ** OK fields
      *
     D  DDBLRTOK       S              1A
     D  DDRFRROK       S              1A
     D  DDCALMOK       S              1A
     D  DDBADJOK       S              1A
     D  DDFLOROK       S              1A
     D  DDLBDYOK       S              1A
     D  DDLODYOK       S              1A
     D  DDOPSHOK       S              1A
     D  DDRRDPOK       S              1A
     D  DDDBAVOK       S              1A
     D  DDRTKNOK       S              1A

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
     C                   EXSR      RSTFLDS
      *
     C     ApiName       IFEQ      'BSRT'
      *
      ** Access Base Rate Details
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WFCYCD        PKEY1
     C                   PARM      WFBSRC        PKEY2
     C     SDBSRT        PARM      SDBSRT        DSSDY
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      BBABSRC       WFBSRC
     C                   ENDIF
      *
     C                   MOVEA     InpScrfld     ArrayInp
     C                   MOVEA     ArrayInp(1)   DDBLRT
     C                   MOVEA     ArrayInp(2)   DDRFRR
     C                   MOVEA     ArrayInp(12)  DDCALM
     C                   MOVEA     ArrayInp(16)  DDBADJ
     C                   MOVEA     ArrayInp(29)  DDFLOR
     C                   MOVEA     ArrayInp(42)  DDLBDY
     C                   MOVEA     ArrayInp(44)  DDLODY
     C                   MOVEA     ArrayInp(46)  DDOPSH
     C                   MOVEA     ArrayInp(47)  DDRRDP
     C                   MOVEA     ArrayInp(49)  DDDBAV
      *
     C                   EXSR      SDBLRT
     C                   EXSR      SRBLRT
     C                   EXSR      SDRFRR
     C                   EXSR      SRRFRR
     C                   EXSR      SDCALM
     C                   EXSR      SRCALM
     C                   EXSR      SDBADJ
     C                   EXSR      SRBADJ
     C                   EXSR      SDFLOR
     C                   EXSR      SRFLOR
     C                   EXSR      SDLBDY
     C                   EXSR      SRLBDY
     C                   EXSR      SDLODY
     C                   EXSR      SRLODY
     C                   EXSR      SDOPSH
     C                   EXSR      SROPSH
     C                   EXSR      SDRRDP
     C                   EXSR      SRRRDP
     C                   EXSR      SDDBAV
     C                   EXSR      SRDBAV
      *
     C                   MOVE      VBLRT         BVBLRT
     C                   MOVE      VRFRR         BVRFRR
     C                   MOVE      VCALM         BVCALM
     C                   Z-ADD     VBADJ         BVBADJ
     C                   Z-ADD     VFLOR         BVFLOR
     C                   Z-ADD     VLBDY         BVLBDY
     C                   Z-ADD     VLODY         BVLODY
     C                   MOVE      VOPSH         BVOPSH
     C                   Z-ADD     VRRDP         BVRRDP
     C                   Z-ADD     VDBAV         BVDBAV
     C                   MOVEL     BsrtValfld    OutValfld
      *
     C                   ENDIF
      *
      ** If a new error was found, set the return code appropriately
      *
     C                   IF        Idx > Ix
     C                   EVAL      RetCodeOut = 'Error'
     C                   ENDIF

     C                   RETURN

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
      *
     C     *ENTRY        PLIST
     C                   PARM                    ApiName                        In Param
     C                   PARM                    WFCYCD                         In param
     C                   PARM                    WFBSRC                         In param
     C                   PARM                    WFLNRF                         In param
     C                   PARM                    InpScrfld                      In/Out param
     C                   PARM                    Idx                            In/Out param
     C                   PARM                    FldNamXAr                      In/Out param
     C                   PARM                    MsgIdXAr                       In/Out param
     C                   PARM                    OutValfld                      Out param
     C                   PARM                    RetCodeOut                     Out param
      *
      ** Access Dealing Details
      *
     C                   CALL      'AODEALR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDDEAL        PARM      SDDEAL        DSSDY
      *
     C     PRTCD         IFNE      *BLANK
     C                   EVAL      DLBNDCSP =  '.'
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  RSTFLDS  - Subroutine for resetting work fields              *
      *                                                               *
      *****************************************************************
     C     RSTFLDS       BEGSR
      *
     C                   MOVE      *BLANKS       ArrayInp
     C                   Z-ADD     Idx           Ix                             Store index
     C                   SETOFF                                       30
      *
     C     WFCYCD        IFEQ      *BLANKS
     C     WFBSRC        OREQ      *BLANKS
     C                   SETON                                        30
     C                   ENDIF
      *
     C     ApiName       IFEQ      'BSRT'
     C                   EVAL      DLBNDCSP =  '.'
     C                   ENDIF
      *
      ** Reset OK Fields
      *
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
      *
     C                   ENDSR
      *

      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDBLRT - Default backward-looking rate                       *
      *****************************************************************
     C     SDBLRT        BEGSR
      *
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRBLRT - Validate backward-looking rate                      *
      *****************************************************************
     C     SRBLRT        BEGSR
      *
     C     DDBLRTOK      IFNE      'N'
     C                   MOVE      DDBLRT        VBLRT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDRFRR - Default Risk Free Rate                              *
      *****************************************************************
     C     SDRFRR        BEGSR
      *
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRFRR - Validate Risk Free Rate                             *
      *****************************************************************
     C     SRRFRR        BEGSR
      *
     C     DDRFRROK      IFNE      'N'
     C                   MOVE      DDRFRR        VRFRR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDCALM - Default Calculation Method                          *
      *****************************************************************
     C     SDCALM        BEGSR
      *
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCALM - Validate Calculation Method                         *
      *****************************************************************
     C     SRCALM        BEGSR
      *
     C     DDCALMOK      IFNE      'N'
     C                   MOVE      DDCALM        VCALM
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDBADJ - Default benchmark adjustment                        *
      *****************************************************************
     C     SDBADJ        BEGSR
      *
     C                   Z-ADD     0             WNumBadj                       Reset WNumBadj
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRBADJ - Validate benchmark adjustment                       *
      *****************************************************************
     C     SRBADJ        BEGSR
      *
     C     DDBADJ        IFNE      *BLANKS                                      Not blanks
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDBADJ        @@ALPH
     C                   CALLB     'ZA0841'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH                         Display field
     C                   PARM      8             @@IDP                          no.of dec.plcs
     C                   PARM      5             @@IINT                         no.of integers
     C                   PARM      'N'           @@MTID                         Mil/Thou
     C                   PARM      *ZERO         @@ERCD                         Error code
     C                   PARM      *ZERO         @@AMT                          File field
     C                   PARM                    DLBNDCSP
      *
     C     @@ERCD        IFNE      0                                             Not numeric
      *
      ** Benchmark Adjustment is not numeric
      *
     C                   MOVE      'N'           DDBADJOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBADJ'      FldNamXAr(Idx)
     C                   MOVEL     '5049426'     MsgIdXAr(Idx)
     C                   ELSE                                                    If numeric
      *
     C                   MOVE      *BLANK        WSign
     C     @@AMT         IFLT      0
     C                   Z-SUB     @@AMT         @@AMT
     C                   MOVE      '-'           WSign
     C                   ENDIF
     C                   MOVE      @@AMT         @@ALPH
     C                   MOVE      @@ALPH        WNumBadj
     C     WSign         IFEQ      '-'
     C                   Z-SUB     WNumBadj      WNumBadj
     C                   ENDIF
     C                   ENDIF                                                   END numeric
     C                   ENDIF                                                  END blanks
      *
     C     VBLRT         IFNE      'Y'
     C     WNumBadj      ANDNE     *ZEROS
      *
      ** Backward-Looking Rate is N and Benchmark Adjustment is not 0
      *
     C                   MOVE      'N'           DDBADJOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBADJ'      FldNamXAr(Idx)
     C                   MOVEL     '5049401'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C     DDBADJOK      IFNE      'N'
     C                   Z-ADD     WNumBadj      VBADJ
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDFLOR - Default Floor                                       *
      *****************************************************************
     C     SDFLOR        BEGSR
      *
     C                   Z-ADD     0             WNumFlor                       Reset WNumFlor
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRFLOR - Validate Floor                                      *
      *****************************************************************
     C     SRFLOR        BEGSR
      *
     C     DDFLOR        IFNE      *BLANKS                                      Not blanks
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDFLOR        @@ALPH
     C                   CALLB     'ZA0841'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH                         Display field
     C                   PARM      8             @@IDP                          no.of dec.plcs
     C                   PARM      5             @@IINT                         no.of integers
     C                   PARM      'N'           @@MTID                         Mil/Thou
     C                   PARM      *ZERO         @@ERCD                         Error code
     C                   PARM      *ZERO         @@AMT                          File field
     C                   PARM                    DLBNDCSP
      *
     C     @@ERCD        IFNE      0                                             Not numeric
      *
      ** Floor is not numeric
      *
     C                   MOVE      'N'           DDFLOROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFLOR'      FldNamXAr(Idx)
     C                   MOVEL     '5049426'     MsgIdXAr(Idx)
     C                   ELSE                                                    If numeric
      *
     C                   MOVE      *BLANK        WSign
     C     @@AMT         IFLT      0
     C                   Z-SUB     @@AMT         @@AMT
     C                   MOVE      '-'           WSign
     C                   ENDIF
     C                   MOVE      @@AMT         @@ALPH
     C                   MOVE      @@ALPH        WNumFlor
     C     WSign         IFEQ      '-'
     C                   Z-SUB     WNumFlor      WNumFlor
     C                   ENDIF
     C                   ENDIF                                                   END numeric
     C                   ENDIF                                                  END blanks
      *
     C     VBLRT         IFNE      'Y'
     C     WNumFlor      ANDNE     *ZEROS
      *
      ** Backward-Looking Rate is N and Floor is not 0
      *
     C                   MOVE      'N'           DDFLOROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFLOR'      FldNamXAr(Idx)
     C                   MOVEL     '5049401'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C     DDFLOROK      IFNE      'N'
     C                   Z-ADD     WNumFlor      VFLOR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *  SDLBDY - Default lookback days                               *
      *****************************************************************
     C     SDLBDY        BEGSR
      *
     C                   Z-ADD     0             WDAY                           Reset WDAY
      *
     C                   MOVE      DDLBDY        WDAY
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRLBDY - Validate lookback days for settlement               *
      *****************************************************************
     C     SRLBDY        BEGSR
      *
     C     DDLBDY        IFNE      *BLANKS                                      Not blank
     C     WDAY          ANDEQ     0                                            And not def.
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDLBDY        @@ALPH
     C                   CALLB     'ZA0841'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH                         Display field
     C                   PARM      0             @@IDP                          no.of dec.plcs
     C                   PARM      2             @@IINT                         no.of integers
     C                   PARM      'N'           @@MTID                         Mil/Thou
     C                   PARM      *ZERO         @@ERCD                         Error code
     C                   PARM      *ZERO         @@AMT                          File field
     C                   PARM                    DLBNDCSP
      *
     C     @@ERCD        IFNE      0                                             Not numeric
     C     @@AMT         ORLT      0
      *
      ** Lookback Days is not numeric
      *
     C                   MOVE      'N'           DDLBDYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDLBDY'      FldNamXAr(Idx)
     C                   MOVEL     '5049423'     MsgIdXAr(Idx)
     C                   ELSE                                                    If numeric
     C                   MOVE      @@AMT         WDAY
      *
     C     VBLRT         IFNE      'Y'
     C     WDAY          ANDNE     0
      *
      ** Backward-Looking Rate is N and Lookback Days is not 0
      *
     C                   MOVE      'N'           DDLBDYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDLBDY'      FldNamXAr(Idx)
     C                   MOVEL     '5049420'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF                                                   END numeric
     C                   ENDIF                                                  END not blank
      *
     C     DDLBDYOK      IFNE      'N'
     C                   MOVE      WDAY          DDLBDY
     C                   Z-ADD     WDAY          VLBDY
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDLODY - Default lockout days                                *
      *****************************************************************
     C     SDLODY        BEGSR
      *
     C                   Z-ADD     0             WDAY                           Reset WDAY
      *
     C                   MOVE      DDLODY        WDAY
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRLODY - Validate lockout days                               *
      *****************************************************************
     C     SRLODY        BEGSR
      *
     C     DDLODY        IFNE      *BLANKS                                      Not blank
     C     WDAY          ANDEQ     0                                            And not def.
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDLODY        @@ALPH
     C                   CALLB     'ZA0841'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH                         Display field
     C                   PARM      0             @@IDP                          no.of dec.plcs
     C                   PARM      2             @@IINT                         no.of integers
     C                   PARM      'N'           @@MTID                         Mil/Thou
     C                   PARM      *ZERO         @@ERCD                         Error code
     C                   PARM      *ZERO         @@AMT                          File field
     C                   PARM                    DLBNDCSP
      *
     C     @@ERCD        IFNE      0                                             Not numeric
     C     @@AMT         ORLT      0
      *
      ** Lockout Days is not numeric
      *
     C                   MOVE      'N'           DDLODYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDLODY'      FldNamXAr(Idx)
     C                   MOVEL     '5049424'     MsgIdXAr(Idx)
     C                   ELSE                                                    If numeric
     C                   MOVE      @@AMT         WDAY
      *
     C     VBLRT         IFNE      'Y'
     C     WDAY          ANDNE     *ZEROS
      *
      ** Backward-Looking Rate is N and Lockout Days is not 0
      *
     C                   MOVE      'N'           DDLODYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDLODY'      FldNamXAr(Idx)
     C                   MOVEL     '5049421'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF                                                   END numeric
     C                   ENDIF                                                  END not blank
      *
     C     DDLODYOK      IFNE      'N'
     C                   MOVE      WDAY          DDLODY
     C                   Z-ADD     WDAY          VLODY
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDOPSH - Default Observation Period Shift                    *
      *****************************************************************
     C     SDOPSH        BEGSR
      *
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SROPSH - Validate Observation Period Shift                   *
      *****************************************************************
     C     SROPSH        BEGSR
      *
     C     DDOPSHOK      IFNE      'N'
     C                   MOVE      DDOPSH        VOPSH
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDRRDP - Rate Rounding Decimal Places                        *
      *****************************************************************
     C     SDRRDP        BEGSR
      *
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRRDP - Rate Rounding Decimal Places                        *
      *****************************************************************
     C     SRRRDP        BEGSR
      *
     C     DDRRDPOK      IFNE      'N'
     C                   MOVE      DDRRDP        VRRDP
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDDBAV - Day Basis for Average                               *
      *****************************************************************
     C     SDDBAV        BEGSR
      *
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRDBAV - Day Basis for Average                               *
      *****************************************************************
     C     SRDBAV        BEGSR
      *
     C     DDDBAVOK      IFNE      'N'
     C                   MOVE      DDDBAV        VDBAV
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDRTKN - Rates Known                                         *
      *****************************************************************
     C     SDRTKN        BEGSR
      *
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRTKN - Rates Known                                         *
      *****************************************************************
     C     SRRTKN        BEGSR
      *
     C     DDRTKNOK      IFNE      'N'
     C                   MOVE      DDRTKN        VRTKN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   DUMP
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
      *
     C                   CALLB     'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2020
