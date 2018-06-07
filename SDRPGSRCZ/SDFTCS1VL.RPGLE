     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD FATCA Customer Details Primary Validation')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module.                             *
      *                                                               *
      *  SDFTCS1VL - FATCA Customer 1st Details Validation            *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD040876           Date 13Sep16               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD029805           Date 05Sep14               *
      *                 CGL132  *CREATE    Date 15Mar13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD040876 - CRS MQ (Recompile)                                *
      *  MD046248 - Finastra Rebranding                               *
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
 
     D CrFoScnFmt      DS
     D  WCDESC1                1     50
     D  DDPFCE                51    100
     D  DDBRTH               101    106
     D  DDCBTH               107    108
     D  DDBTHT               109    143
     D  DDCNCZ               144    145
     D  DDCDOM               146    147
     D  DDACCZ               148    149
     D  DDUTNN               149    173
 
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
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D DDFLDD          S             10A
     D DDCLACO         S              5A
     D DDCLAFO         S              6A
     D DDCLADO         S              5P 0
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
 
      ** Validate US Indicium of Hold Mail override
      ** value and comments
     C                   EXSR      SrVUSHML
 
      ** Validate US Indicium of Mailing Country override
      ** value and comments
     C                   EXSR      SrVUSMAC
 
      ** Validate US Indicium of Regular Payment Instructions to US
      ** override value and comments
     C                   EXSR      SrVUSRPI
 
     C                   RETURN
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVUSHML - Validate Hold Mail
      *****************************************************************
 
     C     SrVUSHML      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate US Indicium of Hold Mail
 
     C                   CALLB     'SDVUSHML'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** US Indicium of Hold Mail - Override Value (Original)
     C                   PARM                    P_DDHMOV
 
      ** US Indicium of Hold Mail - Override Value
     C                   PARM                    DDHMOV
     C                   PARM      DDCUST        DDFLDD
     C                   PARM      'C'           DDRTYP
 
      ** US Indicium of Hold Mail - Override Active Doc
     C                   PARM                    DDHMD1
     C                   PARM                    DDHMD2
     C                   PARM                    DDHMD3
     C                   PARM                    DDHMD4
     C                   PARM                    DDHMD5
     C                   PARM                    DDHMS1
     C                   PARM                    DDHMS2
     C                   PARM                    DDHMS3
     C                   PARM                    DDHMS4
     C                   PARM                    DDHMS5
 
      ** US Indicium of Hold Mail Comment
     C                   PARM                    DDHMC1
     C                   PARM                    DDHMC2
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of Hold Mail - OK
     C                   PARM                    DDHMOVOK          1
 
      ** US Indicium of Hold Mail Comment - OK
     C                   PARM                    DDHMCOOK          1
     C                   PARM                    DDHMD1OK
     C                   PARM                    DDHMD2OK
     C                   PARM                    DDHMD3OK
     C                   PARM                    DDHMD4OK
     C                   PARM                    DDHMD5OK
 
     C                   PARM                    FVHMOV
     C                   PARM                    FVHMD1
     C                   PARM                    FVHMD2
     C                   PARM                    FVHMD3
     C                   PARM                    FVHMD4
     C                   PARM                    FVHMD5
     C                   PARM                    FVHMS1
     C                   PARM                    FVHMS2
     C                   PARM                    FVHMS3
     C                   PARM                    FVHMS4
     C                   PARM                    FVHMS5
     C                   PARM                    FVHMCO
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVUSMAC - Validate Mailing Country
      *****************************************************************
 
     C     SrVUSMAC      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate US Indicium of Mailing Country
 
     C                   CALLB     'SDVUSMAC'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** US Indicium of Mailing Country - Override Value (Original)
     C                   PARM                    P_DDMCOV
 
      ** US Indicium of Mailing Country - Override Value
     C                   PARM                    DDMCOV
     C                   PARM      DDCUST        DDFLDD
     C                   PARM      'C'           DDRTYP
 
      ** US Indicium of Mailing Country - Override Active Doc
     C                   PARM                    DDMCD1
     C                   PARM                    DDMCD2
     C                   PARM                    DDMCD3
     C                   PARM                    DDMCD4
     C                   PARM                    DDMCD5
     C                   PARM                    DDMCS1
     C                   PARM                    DDMCS2
     C                   PARM                    DDMCS3
     C                   PARM                    DDMCS4
     C                   PARM                    DDMCS5
 
      ** US Indicium of Mailing Country Comment
     C                   PARM                    DDMCC1
     C                   PARM                    DDMCC2
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of Mailing Country - OK
     C                   PARM                    DDMCOVOK          1
 
      ** US Indicium of Mailing Country Comment - OK
     C                   PARM                    DDMCCOOK          1
     C                   PARM                    DDMCD1OK
     C                   PARM                    DDMCD2OK
     C                   PARM                    DDMCD3OK
     C                   PARM                    DDMCD4OK
     C                   PARM                    DDMCD5OK
 
     C                   PARM                    FVMCOV
     C                   PARM                    FVMCD1
     C                   PARM                    FVMCD2
     C                   PARM                    FVMCD3
     C                   PARM                    FVMCD4
     C                   PARM                    FVMCD5
     C                   PARM                    FVMCS1
     C                   PARM                    FVMCS2
     C                   PARM                    FVMCS3
     C                   PARM                    FVMCS4
     C                   PARM                    FVMCS5
     C                   PARM                    FVMCCO
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVUSRPI - Validate US Indicium of Regular Payment Instructions
      *            to US details
      *****************************************************************
 
     C     SrVUSRPI      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate US Indicium of Regular Payment Instructions
      ** to US
 
     C                   CALLB     'SDVUSRPI'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** US Indicium of Regular Payment Instructions
      ** to US - Override Value (Original)
     C                   PARM                    P_DDRPOV
 
      ** US Indicium of Regular Payment Instructions
      ** to US - Override Value
     C                   PARM                    DDRPOV
     C                   PARM      DDCUST        DDFLDD
     C                   PARM      'C'           DDRTYP
 
      ** US Indicium of Regular Payment Instructions
      ** to US Comment - Override Active Doc
     C                   PARM                    DDRPD1
     C                   PARM                    DDRPD2
     C                   PARM                    DDRPD3
     C                   PARM                    DDRPD4
     C                   PARM                    DDRPD5
     C                   PARM                    DDRPS1
     C                   PARM                    DDRPS2
     C                   PARM                    DDRPS3
     C                   PARM                    DDRPS4
     C                   PARM                    DDRPS5
 
      ** US Indicium of Regular Payment Instructions
      ** to US Comment
     C                   PARM                    DDRPC1
     C                   PARM                    DDRPC2
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of Regular Payment Instructions to US - OK
     C                   PARM                    DDRPOVOK          1
 
      ** US Indicium of Regular Payment Instructions to US Comment - OK
     C                   PARM                    DDRPCOOK          1
     C                   PARM                    DDRPD1OK
     C                   PARM                    DDRPD2OK
     C                   PARM                    DDRPD3OK
     C                   PARM                    DDRPD4OK
     C                   PARM                    DDRPD5OK
 
     C                   PARM                    FVRPOV
     C                   PARM                    FVRPD1
     C                   PARM                    FVRPD2
     C                   PARM                    FVRPD3
     C                   PARM                    FVRPD4
     C                   PARM                    FVRPD5
     C                   PARM                    FVRPS1
     C                   PARM                    FVRPS2
     C                   PARM                    FVRPS3
     C                   PARM                    FVRPS4
     C                   PARM                    FVRPS5
     C                   PARM                    FVRPCO
 
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
 
     C                   MOVEL     'SDFTCS2VL'   DBPGM
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
(c) Finastra International Limited 2013
