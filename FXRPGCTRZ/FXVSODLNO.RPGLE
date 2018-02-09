     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas Validate Swap/Option Deal Number')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FXVSODLNO - Validate Swap/Option Deal Number                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *      
      *                 CDL094             Date 11Jun14               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      *                 247129             Date 02Jun08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248269             Date 25Jun07               *
      *                 BUG13699           Date 01Apr07               *
      *                 244705             Date 09Jan07               *
      *                 244631             Date 05Jan07               *
      *                 243736             Date 11Dec06               *
      *                 BUG13284           Date 31Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242477             Date 27Sep06               *
      *                 CDL049             Date 07Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 08Sep97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  247129 - Enhance fix 244631                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248269 - Use original spot rate in validating the exchange   *
      *           rate of an Option takedown deal.                    *
      *  BUG13699 - Dealing-Foreign Exchange-Unable to insert Option  *
      *             Take Down Transaction Error Message Appears       *
      *  244705 - Apply fix 244631.                                   *
      *  244631 - Preventative fix to not check if when 1st leg deal  *
      *           changes to 'SW' that 'SW' and the deal subtype      *
      *           exist as a valid dealtype/subtype combination       *
      *         - annotated as BUG13284                               *
      *  243736 - Only issue the error message 'FXM0446' if the       *
      *           user attempted to authorise the 2nd leg of the      *
      *           swap deal before authorising the 1st leg.           *
      *         - annotated as BUG13284                               *
      *  BUG13284 - Error Msg appears when authorising trades         *
      *  242477 - Applied fix 200709.  Incorrect deals update due to  *
      *           authorisation of 2nd leg of swap before authorising *
      *           the 1st leg.  Prevent authorisation of the 2nd leg  *
      *           if 1st leg is not yet authorised.                   *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in FXDEALPP.*
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  CAP002 - Conversion of FX inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FFXDEALLL  IF   E           K DISK    INFSR(*PSSR)
 
     FFDDTSTL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG13284
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the FX standard declares
     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
     D/COPY ZACPYSRC,STDDECLARE                                                               209009
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
 
     D RelDealDts      DS
      ** Related Deal Details (when deal is option takedown or swap.
      ** Thus related deal will be other leg of swap or option).
     D  RelDBRC                1      3
     D  RelCCY1                4      6
     D  RelCCY2                7      9
     D  RelDAM1               10     24  0
     D  RelDAM2               25     39  0
     D**RelDCNO*              40     45  0                                                    CSD027
     D  RelDCNO               40     45                                                       CSD027
     D  RelDCSN               46     55
     D  RelDDYY               56     59  0                                      deal date - year
     D  RelDDMM               60     61  0                                      deal date - mnth
     D  RelDDDD               62     63  0                                      deal date - day
     D  RelVDYY               64     67  0                                      val date - year
     D  RelVDMM               68     69  0                                      val date - mnth
     D  RelVDDD               70     71  0                                      val date - day
     D  RelDOEY               72     75  0                                      opt date - year
     D  RelDOEM               76     77  0                                      opt date - mnth
     D  RelDOED               78     79  0                                      opt date - day
     D  RelMGPT               80     86  2                                      opt date - day
     D  RelMGBS               87     87                                         opt date - day
     D  RelDXRT               88    100  8                                      opt date - day
     D  RelOSRT              101    113  8                                                    248269
 
 
     D                 DS
      **  Data structure for date in, to change format.
     D  DateIn                 1      8  0
     D  @@YY                   1      4  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0
 
     D  @DTIDS         DS                                                                   BUG13284
      ** Data structure for SR ZA0680 - date input to subroutine                            BUG13284
     D  @@DTIN                 1      8  0                                                  BUG13284
     D  @@YYYY                 1      4  0                                                  BUG13284
     D  @@CC                   1      2  0                                                  BUG13284
     D  @@MTH                  5      6  0                                                  BUG13284
     D  @@DAY                  7      8  0                                                  BUG13284
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
                                                                                            BUG13284
      ** Array for SR ZA0680 - cumulative days in year for 4 year period                    BUG13284
     D @YD             S              5  0 DIM(4) CTDATA PERRCD(4) ASCEND                   BUG13284
                                                                                            BUG13284
      ** Array for SR ZA0680 - cumulative days in year per month                            BUG13284
     D @MD             S              5  0 DIM(13) CTDATA PERRCD(13) ASCEND                 BUG13284
     D ValueDte1       S              5  0                                                  BUG13284
     D ValueDte2       S              5  0                                                  BUG13284
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
      *
      ** SDNOV - SWAP/OPTION DEAL NUMBER VALIDATION
      *
     C                   EXSR      SDNOV
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SDNOV - SWAP/OPTION DEAL NUMBER VALIDATION
      *****************************************************************
     C     SDNOV         BEGSR
      *
      * If deal type is not 'OT' or 'SW' and broker code is not 'SWAP'
      *
     C     DDDLTP        IFNE      'OT'
     C     DDDLTP        ANDNE     'SW'
     C     DDBRKR        ANDNE     'SWAP'
     C     DDDTYP        ANDNE     'S'                                                        242477
      *
      * Swap/option deal number can't be defined
      *
     C     DDSDNO        IFNE      *BLANKS
     C                   MOVE      'N'           DDSdnoOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSDNO'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0186'     MsgIdXAr(Idx)
     C                   END
     C                   END
      *
      * If deal type is 'OT' or 'SW' or broker code is 'SWAP'
      *
     C     DDDLTP        IFEQ      'OT'
     C     DDDLTP        OREQ      'SW'
     C     DDBRKR        OREQ      'SWAP'
      *
      * Swap/option deal number must be defined
      *
     C     DDSDNO        IFEQ      *BLANKS
     C                   MOVE      'N'           DDSdnoOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSDNO'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0185'     MsgIdXAr(Idx)
     C                   END
      *
      * If swap/option deal number is defined
      *
     C     DDSDNO        IFNE      *BLANKS
     C                   TESTN                   DDSDNO               9798
      *
      * Get the related deal
      *
     C     *IN97         IFEQ      '1'
     C     *IN98         OREQ      '1'
     C                   MOVE      DDDLNO        @DLKEY            6 0                      BUG13284
     C     @DLKEY        CHAIN     FXDEALLL                           99                    BUG13284
     C     *IN99         IFEQ      '0'                                                      BUG13284
     C                   MOVEL     FHVDYY        @@YYYY                                     BUG13284
     C                   MOVEL     FHVDMM        @@MTH                                      BUG13284
     C                   MOVEL     FHVDDD        @@DAY                                      BUG13284
     C                   EXSR      ZA0680                                                   BUG13284
     C                   MOVEL     @@MDNO        ValueDte1                                  BUG13284
     C                   ENDIF                                                              BUG13284
     C                   MOVE      DDSDNO        @DLKEY            6 0
     C     @DLKEY        CHAIN     FXDEALLL                           99
     C     *IN99         IFEQ      '0'                                                      BUG13284
     C                   MOVEL     FHVDYY        @@YYYY                                     BUG13284
     C                   MOVEL     FHVDMM        @@MTH                                      BUG13284
     C                   MOVEL     FHVDDD        @@DAY                                      BUG13284
     C                   EXSR      ZA0680                                                   BUG13284
     C                   MOVE      @@MDNO        ValueDte2                                  BUG13284
     C                   ENDIF                                                              BUG13284
     C                   END
      *
      *  Error in related deal number
      *
     C     *IN97         IFEQ      '0'
     C     *IN98         ANDEQ     '0'
     C     *IN99         OREQ      '1'
     C     FHDLTF        ORNE      ' '
     C                   MOVE      'N'           DDSdnoOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSDNO'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0184'     MsgIdXAr(Idx)
     C                   ELSE
      *
      * If Related deal is deleted
      *
     C     FHDDLT        IFEQ      'D'
     C                   MOVE      'N'           DDSdnoOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSDNO'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0183'     MsgIdXAr(Idx)
     C                   END
      *
      * If Related deal is not deleted
      *
     C     FHDDLT        IFNE      'D'
     C     FHTYPE        IFNE      'OP'                                                       247129
     C     FHTYPE        ANDNE     'OT'                                                       247129
      *                                                                                     BUG13284
     C                   IF        (DDDLTP='SW')                                            BUG13699
      * Check if related deal subtype and 'SW' as dealtype exist as a                       BUG13284
      * valid dealtype/subtype combination                                                  BUG13284
     C                   Eval      KTYPE = 'SW'                                             BUG13284
     C                   Eval      KSTYP = FHSTYP                                           BUG13284
                                                                                            BUG13284
     C     KDTST         CHAIN     FDDTSTL1                           96                    BUG13284
     C     *IN96         IFEQ      '1'                                                      BUG13284
     C                   MOVE      'N'           DDSdnoOK                                   BUG13284
     C                   ADD       1             Idx                                        BUG13284
     C                   MOVEL     'DDSDNO'      FldNamXAr(Idx)                             BUG13284
     C                   MOVEL     'FXM0447'     MsgIdXAr(Idx)                              BUG13284
     C                   END                                                                BUG13284
     C                   ENDIF                                                              BUG13699
                                                                                            BUG13284
     C                   ENDIF                                                                247129
      *
      * If deal is an option takedown
      * errors if: related deal is not an option
      *            related deal is matured
      *            related deal is not authorized
      *
     C     DDDLTP        IFEQ      'OT'
     C     FHTYPE        IFNE      'OP'
     C                   MOVE      'N'           DDSdnoOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSDNO'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0187'     MsgIdXAr(Idx)
     C                   END
      *
     C     FHDSTS        IFEQ      'M'
     C                   MOVE      'N'           DDSdnoOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSDNO'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0254'     MsgIdXAr(Idx)
     C                   END
      *
     C     FHDSTS        IFNE      'M'
     C     FHDSTS        ANDNE     'A'
     C                   MOVE      'N'           DDSdnoOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSDNO'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0191'     MsgIdXAr(Idx)
     C                   END
     C                   END
      *
      * If deal type of this deal is swap, related deal can't be an option
      *
     C     DDDLTP        IFEQ      'SW'
     C     DDBRKR        OREQ      'SWAP'
     C     FHTYPE        IFEQ      'OP'
     C     FHTYPE        OREQ      'OT'
     C                   MOVE      'N'           DDSdnoOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSDNO'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0188'     MsgIdXAr(Idx)
     C                   END
     C                   END
      *                                                                                       242477
      ** If authorising 2nd leg of a  swap deal,  check if 1st leg                            242477
      ** is already authorised. For the case of swap broker deals,                            242477
      ** allow  authorisation  if 1st leg  has already  expired or                            242477
      ** matured.                                                                             242477
      *                                                                                       242477
     C     DDACTN        IFEQ      'X'                                                        242477
     C     FHDSTS        IFNE      'A'                                                        242477
     C     FHDSTS        ANDNE     'E'                                                        242477
     C     FHDSTS        ANDNE     'M'                                                        242477
     C     ValueDte1     ANDGT     ValueDte2                                                BUG13284
     C                   MOVE      'N'           DDSdnoOK                                     242477
     C                   ADD       1             Idx                                          242477
     C                   MOVEL     'DDSDNO'      FldNamXAr(Idx)                               242477
     C                   MOVEL     'FXM0446'     MsgIdXAr(Idx)                                242477
     C                   ENDIF                                                                242477
     C                   ENDIF                                                                242477
      *
      * If deal type of this deal is swap
      *
     C     DDDLTP        IFEQ      'SW'
     C     DDSdnoOK      ANDEQ     'Y'
      *
      * Related deal must point to this deal
      *
     C     FHDADN        IFNE      *BLANKS
     C     FHDADN        ANDNE     DDDLNO
     C                   MOVE      'N'           DDSdnoOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSDNO'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0189'     MsgIdXAr(Idx)
     C                   END
      *
      * Related deal can't be matured unless this is an amend/authorize
      *
     C     FHDSTS        IFEQ      'M'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'X'
     C                   MOVE      'N'           DDSdnoOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSDNO'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0255'     MsgIdXAr(Idx)
     C                   END
      *
      * Convert date done on related deal to day number
      *
     C                   Z-ADD     FHDTYY        @@YY
     C                   Z-ADD     FHDTMM        @@MM
     C                   Z-ADD     FHDTDD        @@DD
     C     DateIn        IFNE      0
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM      *ZERO         @@MDNO            5 0
     C                   ELSE
     C                   Z-ADD     0             @@MDNO
     C                   END
      *
      * Date done on related deal must be run date if this is an insert
      *
     C     @@MDNO        IFNE      BJRDNB
     C     DDACTN        ANDEQ     'I'
     C                   MOVE      'N'           DDSdnoOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSDNO'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0190'     MsgIdXAr(Idx)
     C                   END
      *
     C                   END                                                    DDDLTP EQ 'SW'
     C                   END                                                    FHDDLT NE 'D'
     C                   END                                                    *IN97  EQ '0'
     C                   END                                                    DDSDNO NE BLANK
     C                   END                                                    DDDLTP EQ 'OT'
      *
      ** If Swap/option deal number is valid,
      ** Store related:
      ** . deal branch
      ** . currency 1, currency 2
      ** . amount 1, amount 2
      ** . customer number & shortname
      ** . deal done date YY/MM/DD
      ** . deal value date YY/MM/DD
      ** . deal option end date YY/MM/DD
      ** . margin points & buy/sell ind
      ** . exchange rate
     C     DDSdnoOK      IFEQ      'Y'
     C     DDSDNO        ANDNE     *BLANKS
     C                   MOVEL     FHDBRC        RelDBRC           3
     C                   MOVEL     FHCCY1        RelCCY1           3
     C                   MOVEL     FHCCY2        RelCCY2           3
     C                   MOVEL     FHDAM1        RelDAM1          15 0
     C                   MOVEL     FHDAM2        RelDAM2          15 0
     C**********         MOVEL     FHDCNO        RelDCNO           6 0                        CSD027
     C                   MOVEL     FHDCNO        RelDCNO           6                          CSD027
     C                   MOVEL     FHDCSN        RelDCSN          10
     C                   MOVEL     FHDDYY        RelDDYY           4 0          deal date - year
     C                   MOVEL     FHDDMM        RelDDMM           2 0          deal date - mnth
     C                   MOVEL     FHDDDD        RelDDDD           2 0          deal date - day
     C                   MOVEL     FHVDYY        RelVDYY           4 0          val date - year
     C                   MOVEL     FHVDMM        RelVDMM           2 0          val date - mnth
     C                   MOVEL     FHVDDD        RelVDDD           2 0          val date - day
     C                   MOVEL     FHDOEY        RelDOEY           4 0          opt date - year
     C                   MOVEL     FHDOEM        RelDOEM           2 0          opt date - mnth
     C                   MOVEL     FHDOED        RelDOED           2 0          opt date - day
     C                   MOVEL     FHMGPT        RelMGPT           7 2          opt date - day
     C                   MOVEL     FHMGBS        RelMGBS           1            opt date - day
     C                   MOVEL     FHDXRT        RelDXRT          13 8          opt date - day
     C                   MOVEL     FHOSRT        RelOSRT          13 8                        248269
     C                   ELSE
     C                   CLEAR                   RelDealDts
     C                   END
      *
     C                   ENDSR
     C*****************************************************************                     BUG13284
      /EJECT                                                                                BUG13284
     C*****************************************************************                     BUG13284
     C*                                                               *                     BUG13284
     C* ZA0680 - THIS SUBROUTINE CONVERTS YYYYMMDD FORMAT DATE TO     *                     BUG13284
     C*          MIDAS DAY NUMBER FORMAT (NO. DAYS FROM 31/12/71)     *                     BUG13284
     C*                                                               *                     BUG13284
     C* CALLED BY : SDNOV                                             *                     BUG13284
     C*                                                               *                     BUG13284
     C* INPUT : @@DTIN DATE (YYYYMMDD) - IN DATA STRUCTURE (SIZE: 8N) *                     BUG13284
     C*                                                               *                     BUG13284
     C* OUTPUT : @@MDNO MIDAS DAY NUMBER  (SIZE : 5N)                 *                     BUG13284
     C*                                                               *                     BUG13284
     C* USES :   @@CC   NUMBER OF CENTURIES IN DATE                   *                     BUG13284
     C*          @@DAY  DAY NUMBER                                    *                     BUG13284
     C*          @@REM  REMAINDER FROM DIVIDE                         *                     BUG13284
     C*          @@MTH  MONTH NUMBER                                  *                     BUG13284
     C*          @MD    COMPILATION TIME ARRAY FOR CUMULATIVE DAYS IN *                     BUG13284
     C*                 MONTH                                         *                     BUG13284
     C*          @@WK2  WORK FIELD (2,0)                              *                     BUG13284
     C*          @@WK5  WORK FIELD (5,0)                              *                     BUG13284
     C*          @@YYYY YEAR (4 CHARACTER)                            *                     BUG13284
     C*          @YD    COMPILATION TIME ARRAY FOR CUMULATIVE DAYS IN *                     BUG13284
     C*                 A FOUR YEAR PERIOD                            *                     BUG13284
     C*                                                               *                     BUG13284
     C*****************************************************************                     BUG13284
     C*                                                                                     BUG13284
     C     ZA0680        BEGSR                                                              BUG13284
     C*                                                                                     BUG13284
     C**  CLEAR OUT ANY 'OLD' DATA IN FIELD                                                 BUG13284
     C                   Z-ADD     0             @@MDNO            5 0                      BUG13284
     C*                                                                                     BUG13284
     C     @@DTIN        CABEQ     0             ZA0689                                     BUG13284
     C*                                                                                     BUG13284
     C**   IF DATE GREATER THAN 31/12/2071 NEED EXTRA PROCESSING                            BUG13284
     C**   WORK OUT THE NUMBER OF CENTURIES PASSED SINCE 1971,                              BUG13284
     C**   BY SUBTRACTING 1972 FROM THE YEAR FIELD.                                         BUG13284
     C     @@YYYY        IFGE      2072                                         B1          BUG13284
     C     @@YYYY        SUB       1972          @@YYYY                         *1          BUG13284
     C*                                                                                     BUG13284
     C**   MULTIPLY BY NUMBER OF DAYS IN CENTURY (SINCE 1971)                               BUG13284
     C**   THEN RESTORE THE YEAR WHICH WAS INPUT BACK TO THE                                BUG13284
     C**   ORIGINAL VALUE BEFORE CONTINUING WITH NORMAL CALCULATIONS.                       BUG13284
     C**                                                                                    BUG13284
     C     @@CC          MULT      36524         @@MDNO                         *1          BUG13284
     C     @@YYYY        ADD       1972          @@YYYY                         *1          BUG13284
     C                   END                                                    E1          BUG13284
     C*                                                                                     BUG13284
     C     @@YYYY        ADD       28            @@WK2             2 0                      BUG13284
     C*                                                                                     BUG13284
     C     @@WK2         DIV       4             @@WK2                                      BUG13284
     C                   MVR                     @@REM             1 0                      BUG13284
     C*                                                                                     BUG13284
     C**    MULTIPLY BY NUMBER OF DAYS IN FOUR YEAR PERIOD                                  BUG13284
     C     @@WK2         MULT      1461          @@WK5             5 0                      BUG13284
     C                   ADD       @@WK5         @@MDNO                                     BUG13284
     C*                                                                                     BUG13284
     C**  CHECK REMAINDER AND MONTH NUMBER                                                  BUG13284
     C     @@REM         IFEQ      0                                            B1          BUG13284
     C     @@MTH         ANDGT     2                                            B1          BUG13284
     C                   ADD       1             @@MDNO                         *1          BUG13284
     C                   END                                                    E1          BUG13284
     C*                                                                                     BUG13284
     C**  YEAR NOT LEAP YEAR,  ADD CUMULATIVE DAYS FOR YEAR                                 BUG13284
     C     @@REM         IFNE      0                                            B1          BUG13284
     C                   ADD       @YD(@@REM)    @@MDNO                         *1          BUG13284
     C                   END                                                    E1          BUG13284
     C*                                                                                     BUG13284
     C**  ADD MONTHS THIS YEAR                                                              BUG13284
     C                   ADD       @MD(@@MTH)    @@MDNO                                     BUG13284
     C*                                                                                     BUG13284
     C**  ADD DAYS THIS MONTH                                                               BUG13284
     C                   ADD       @@DAY         @@MDNO                                     BUG13284
     C*                                                                                     BUG13284
     C     ZA0689        ENDSR                                                **ZA0689 TAG**BUG13284
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Deal Screen fields
     C                   PARM                    DDACTN            1            action code
     C                   PARM                    DDDLNO            6            action code
     C                   PARM                    DDDLTP            2            action code
     C                   PARM                    DDBRKR            4            action code
     C                   PARM                    DDSDNO            6            SW/OP deal no
      *
      * ICD
     C                   PARM                    BJRDNB            5 0
      *
      * OUTPUTS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Swap/option deal no - OK
     C                   PARM                    DDSdnoOK          1              SW/OP deal no
      *
      ** Related deal details
     C                   PARM                    RelDealDts                       SW/OP deal no
     C                   PARM                    DDDTYP            1                          242477
      *
      * Key List for CHAIN to FDDTSTL1                                                      BUG13284
      *                                                                                     BUG13284
     C     KDTST         KLIST                                                              BUG13284
     C                   KFLD                    KTYPE             2                        BUG13284
     C                   KFLD                    KSTYP             2                        BUG13284
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
