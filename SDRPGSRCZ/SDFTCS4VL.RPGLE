     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD FATCA Customer Details 4 Validation')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module.                             *
      *                                                               *
      *  SDFTCS4VL - FATCA Customer Details 4 Validation              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD029805           Date 05Sep14               *
      *  Prev Amend No. CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD029805 - GIIN number validation (Recompile)                *
      *  CGL132 - Foreign Account Tax Compliance Act                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D/COPY ZACPYSRC,STDDECLARE
 
     D/COPY ZACPYSRC,PSDS
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
     D/COPY ZACPYSRC,ERR_XARRYS
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** FATCA Customer Details in screen format
     D CrFaScnFmt    E DS                  EXTNAME(SDFTCRPD)
 
      ** FATCA Customer Details in screen format (Previous)
     D PrFaScnFmt    E DS                  EXTNAME(SDFTCRPD)
     D                                     PREFIX(P_)
 
      ** FATCA Customer Details OK indicators
     D OKFATCAdet    E DS                  EXTNAME(SDEFTCSPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
     D ValidFATCA    E DS                  EXTNAME(SDVFTCSPD)
      ** Valid Customer Details layout
 
      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
     D DDRTYP          S              1A
     D DDFLDD          S             10A
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D WRunDay         S                   LIKE(BJRDNB)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Validate US Indicium of US Telephone
      ** override value and comments
     C                   EXSR      SrVUSTEL
 
      ** Validate US Indicium of US Tax identification
      ** number override value and comments
     C                   EXSR      SrVUSTIN
 
      ** Validate US Indicium of US Account Authority
      ** Holder override value and comments
     C                   EXSR      SrVUSAAH
 
     C                   RETURN
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVUSTEL - Validate US Telephone
      *****************************************************************
 
     C     SrVUSTEL      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate US Indicium of US Telephone
 
     C                   CALLB     'SDVUSTEL'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** US Indicium of US Telephone - Override Value (Original)
     C                   PARM                    P_DDTEOV
 
      ** US Indicium of US Telephone - Override Value
     C                   PARM                    DDTEOV
     C                   PARM      DDCUST        DDFLDD
     C                   PARM      'C'           DDRTYP
 
      ** US Indicium of US Telephone - Override Active Doc
     C                   PARM                    DDTED1
     C                   PARM                    DDTED2
     C                   PARM                    DDTED3
     C                   PARM                    DDTED4
     C                   PARM                    DDTED5
     C                   PARM                    DDTES1
     C                   PARM                    DDTES2
     C                   PARM                    DDTES3
     C                   PARM                    DDTES4
     C                   PARM                    DDTES5
 
      ** US Indicium of US Telephone Comment
     C                   PARM                    DDTEC1
     C                   PARM                    DDTEC2
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of US Telephone - OK
     C                   PARM                    DDTEOVOK          1
 
      ** US Indicium of US Telephone Comment - OK
     C                   PARM                    DDTECOOK          1
     C                   PARM                    DDTED1OK
     C                   PARM                    DDTED2OK
     C                   PARM                    DDTED3OK
     C                   PARM                    DDTED4OK
     C                   PARM                    DDTED5OK
 
     C                   PARM                    FVTEOV
     C                   PARM                    FVTED1
     C                   PARM                    FVTED2
     C                   PARM                    FVTED3
     C                   PARM                    FVTED4
     C                   PARM                    FVTED5
     C                   PARM                    FVTES1
     C                   PARM                    FVTES2
     C                   PARM                    FVTES3
     C                   PARM                    FVTES4
     C                   PARM                    FVTES5
     C                   PARM                    FVTECO
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVUSTIN - Validate US Tax Identification Number
      *****************************************************************
 
     C     SrVUSTIN      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate US Indicium of US Tax Identification Number
 
     C                   CALLB     'SDVUSTIN'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** US Indicium of US TIN - Override Value (Original)
     C                   PARM                    P_DDTXOV
 
      ** US Indicium of US TIN - Override Value
     C                   PARM                    DDTXOV
     C                   PARM      DDCUST        DDFLDD
     C                   PARM      'C'           DDRTYP
 
      ** US Indicium of US TIN - Override Active Doc
     C                   PARM                    DDTXD1
     C                   PARM                    DDTXD2
     C                   PARM                    DDTXD3
     C                   PARM                    DDTXD4
     C                   PARM                    DDTXD5
     C                   PARM                    DDTXS1
     C                   PARM                    DDTXS2
     C                   PARM                    DDTXS3
     C                   PARM                    DDTXS4
     C                   PARM                    DDTXS5
 
      ** US Indicium of US TIN Comment
     C                   PARM                    DDTXC1
     C                   PARM                    DDTXC2
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of US TIN - OK
     C                   PARM                    DDTXOVOK          1
 
      ** US Indicium of US TIN Comment - OK
     C                   PARM                    DDTXCOOK          1
     C                   PARM                    DDTXD1OK
     C                   PARM                    DDTXD2OK
     C                   PARM                    DDTXD3OK
     C                   PARM                    DDTXD4OK
     C                   PARM                    DDTXD5OK
 
     C                   PARM                    FVTXOV
     C                   PARM                    FVTXD1
     C                   PARM                    FVTXD2
     C                   PARM                    FVTXD3
     C                   PARM                    FVTXD4
     C                   PARM                    FVTXD5
     C                   PARM                    FVTXS1
     C                   PARM                    FVTXS2
     C                   PARM                    FVTXS3
     C                   PARM                    FVTXS4
     C                   PARM                    FVTXS5
     C                   PARM                    FVTXCO
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVUSAAH - Validate US Account Authority Holder
      *****************************************************************
 
     C     SrVUSAAH      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate US Indicium of US Account Authority Holder
 
     C                   CALLB     'SDVUSAAH'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** US Indicium of US Authority Holder
      ** - Override Value (Original)
     C                   PARM                    P_DDAUOV
 
      ** US Indicium of US Authority Holder - Override Value
     C                   PARM                    DDAUOV
     C                   PARM      DDCUST        DDFLDD
     C                   PARM      'C'           DDRTYP
 
      ** US Indicium of US Authority Holder
      ** - Override Active Doc
     C                   PARM                    DDAUD1
     C                   PARM                    DDAUD2
     C                   PARM                    DDAUD3
     C                   PARM                    DDAUD4
     C                   PARM                    DDAUD5
     C                   PARM                    DDAUS1
     C                   PARM                    DDAUS2
     C                   PARM                    DDAUS3
     C                   PARM                    DDAUS4
     C                   PARM                    DDAUS5
 
      ** US Indicium of US Authority Holder Comment
     C                   PARM                    DDAUC1
     C                   PARM                    DDAUC2
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of US Authority Holder - OK
     C                   PARM                    DDAUOVOK          1
 
      ** US Indicium of US Authority Holder Comment - OK
     C                   PARM                    DDAUCOOK          1
     C                   PARM                    DDAUD1OK
     C                   PARM                    DDAUD2OK
     C                   PARM                    DDAUD3OK
     C                   PARM                    DDAUD4OK
     C                   PARM                    DDAUD5OK
 
     C                   PARM                    FVAUOV
     C                   PARM                    FVAUD1
     C                   PARM                    FVAUD2
     C                   PARM                    FVAUD3
     C                   PARM                    FVAUD4
     C                   PARM                    FVAUD5
     C                   PARM                    FVAUS1
     C                   PARM                    FVAUS2
     C                   PARM                    FVAUS3
     C                   PARM                    FVAUS4
     C                   PARM                    FVAUS5
     C                   PARM                    FVAUCO
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
 
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
 
      ** Reset error & warning fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
 
     C     UPDATERRS     BEGSR
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
 
      ** Set Error Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
 
      ** Update warning fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
 
      ** Set Warning Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
 
      ** Response mode
     C                   PARM                    RespMode          1
 
      ** FATCA Customer Details
     C                   PARM                    CrFaScnFmt
     C                   PARM                    PrFaScnFmt
 
      ** OUTPUTS
 
      ** FATCA Customer Details OK inds
     C                   PARM                    OKFATCAdet
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      ** Valid FATCA Customer details layout (DS) from/to caller
     C                   PARM                    ValidFATCA
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
 
      ** Check if switchable feature CGL132 is switched on.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGL132'      @SARD             6
 
      ** Database error
 
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CGL132'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   EXSR      SRERR
     C                   END
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CGL132            1
     C                   ELSE
     C                   MOVE      'N'           CGL132
     C                   END
 
     C                   EVAL      WRunDay = BJRDNB
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
 
     C     SRERR         BEGSR
 
     C                   MOVEL     'SDFTCS4VL'   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
 
      **  Terminate the program
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
