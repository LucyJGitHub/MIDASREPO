     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD FATCA Customer Details 3 Validation')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module.                             *
      *                                                               *
      *  SDFTCS3VL - FATCA Customer Third Details Validation          *
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
 
      ** Validate US Indicium of US Green Card override
      ** value and comments
     C                   EXSR      SrVUSGRC
 
      ** Validate US Indicium of US Identity Document
      ** override value and comments
     C                   EXSR      SrVUSIDD
 
      ** Validate US Indicium of US Joint Account Member
      ** override value and comments
     C                   EXSR      SrVUSJAM
 
     C                   RETURN
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVUSGRC - Validate US Green Card
      *****************************************************************
 
     C     SrVUSGRC      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate US Indicium of US Green Card
 
     C                   CALLB     'SDVUSGRC'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** US Indicium of US Green Card - Override Value (Original)
     C                   PARM                    P_DDGCOV
 
      ** US Indicium of US Green Card - Override Value
     C                   PARM                    DDGCOV
     C                   PARM      DDCUST        DDFLDD
     C                   PARM      'C'           DDRTYP
 
      ** US Indicium of US Green Card - Override Active Doc
     C                   PARM                    DDGCD1
     C                   PARM                    DDGCD2
     C                   PARM                    DDGCD3
     C                   PARM                    DDGCD4
     C                   PARM                    DDGCD5
     C                   PARM                    DDGCS1
     C                   PARM                    DDGCS2
     C                   PARM                    DDGCS3
     C                   PARM                    DDGCS4
     C                   PARM                    DDGCS5
 
      ** US Indicium of US Green Card Comment
     C                   PARM                    DDGCC1
     C                   PARM                    DDGCC2
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of US Green Card - OK
     C                   PARM                    DDGCOVOK          1
     C                   PARM                    DDGCCOOK          1
     C                   PARM                    DDGCD1OK
     C                   PARM                    DDGCD2OK
     C                   PARM                    DDGCD3OK
     C                   PARM                    DDGCD4OK
     C                   PARM                    DDGCD5OK
 
     C                   PARM                    FVGCOV
     C                   PARM                    FVGCD1
     C                   PARM                    FVGCD2
     C                   PARM                    FVGCD3
     C                   PARM                    FVGCD4
     C                   PARM                    FVGCD5
     C                   PARM                    FVGCS1
     C                   PARM                    FVGCS2
     C                   PARM                    FVGCS3
     C                   PARM                    FVGCS4
     C                   PARM                    FVGCS5
     C                   PARM                    FVGCCO
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVUSIDD - Validate US Identity Document
      *****************************************************************
 
     C     SrVUSIDD      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate US Indicium of US Identity Document
 
     C                   CALLB     'SDVUSIDD'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** US Indicium of US Identity Doc - Override Value (Original)
     C                   PARM                    P_DDIDOV
 
      ** US Indicium of US Identity Doc - Override Value
     C                   PARM                    DDIDOV
     C                   PARM      DDCUST        DDFLDD
     C                   PARM      'C'           DDRTYP
 
      ** US Indicium of US Identity Doc - Override Active Doc
     C                   PARM                    DDIDD1
     C                   PARM                    DDIDD2
     C                   PARM                    DDIDD3
     C                   PARM                    DDIDD4
     C                   PARM                    DDIDD5
     C                   PARM                    DDIDS1
     C                   PARM                    DDIDS2
     C                   PARM                    DDIDS3
     C                   PARM                    DDIDS4
     C                   PARM                    DDIDS5
 
      ** US Indicium of US Identity Doc Comment
     C                   PARM                    DDIDC1
     C                   PARM                    DDIDC2
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of US Identity Document - OK
     C                   PARM                    DDIDOVOK          1
 
      ** US Indicium of US Identity Document Comment - OK
     C                   PARM                    DDIDCOOK          1
     C                   PARM                    DDIDD1OK
     C                   PARM                    DDIDD2OK
     C                   PARM                    DDIDD3OK
     C                   PARM                    DDIDD4OK
     C                   PARM                    DDIDD5OK
 
     C                   PARM                    FVIDOV
     C                   PARM                    FVIDD1
     C                   PARM                    FVIDD2
     C                   PARM                    FVIDD3
     C                   PARM                    FVIDD4
     C                   PARM                    FVIDD5
     C                   PARM                    FVIDS1
     C                   PARM                    FVIDS2
     C                   PARM                    FVIDS3
     C                   PARM                    FVIDS4
     C                   PARM                    FVIDS5
     C                   PARM                    FVIDCO
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVUSJAM - Validate US Joint Account Member
      *****************************************************************
 
     C     SrVUSJAM      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate US Indicium of US Joint Account Member
 
     C                   CALLB     'SDVUSJAM'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** US Indicium of US Joint Account Member - Override
      ** Value (Original)
     C                   PARM                    P_DDJAOV
 
      ** US Indicium of US Joint Account Member - Override Value
     C                   PARM                    DDJAOV
     C                   PARM      DDCUST        DDFLDD
     C                   PARM      'C'           DDRTYP
 
      ** US Indicium of US Joint Account Member - Override Active Doc
     C                   PARM                    DDJAD1
     C                   PARM                    DDJAD2
     C                   PARM                    DDJAD3
     C                   PARM                    DDJAD4
     C                   PARM                    DDJAD5
     C                   PARM                    DDJAS1
     C                   PARM                    DDJAS2
     C                   PARM                    DDJAS3
     C                   PARM                    DDJAS4
     C                   PARM                    DDJAS5
 
      ** US Indicium of US Joint Account Member Comment
     C                   PARM                    DDJAC1
     C                   PARM                    DDJAC2
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of US Joint Account Member - OK
     C                   PARM                    DDJAOVOK          1
 
      ** US Indicium of US Joint Account Member Comment - OK
     C                   PARM                    DDJACOOK          1
     C                   PARM                    DDJAD1OK
     C                   PARM                    DDJAD2OK
     C                   PARM                    DDJAD3OK
     C                   PARM                    DDJAD4OK
     C                   PARM                    DDJAD5OK
 
     C                   PARM                    FVJAOV
     C                   PARM                    FVJAD1
     C                   PARM                    FVJAD2
     C                   PARM                    FVJAD3
     C                   PARM                    FVJAD4
     C                   PARM                    FVJAD5
     C                   PARM                    FVJAS1
     C                   PARM                    FVJAS2
     C                   PARM                    FVJAS3
     C                   PARM                    FVJAS4
     C                   PARM                    FVJAS5
     C                   PARM                    FVJACO
 
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
 
     C                   MOVEL     'SDFTCS3VL'   DBPGM
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
