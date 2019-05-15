     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD FATCA Non-A/c Holder details 3 validation')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module.                             *
      *                                                               *
      *  SDFTNH2VL - FATCA Customer Secondary Details Validation      *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD029805           Date 05Sep14               *
      *                 CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD029805 - GIIN number validation (Recompile)                *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
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
     D CrFaScnFmt    E DS                  EXTNAME(SDFTNRPD)
 
      ** FATCA Customer Details in screen format (Previous)
     D PrFaScnFmt    E DS                  EXTNAME(SDFTNRPD)
     D                                     PREFIX(P_)
 
      ** FATCA Customer Details OK indicators
     D OKFATCAdet    E DS                  EXTNAME(SDEFTNHPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
     D ValidFATCA    E DS                  EXTNAME(SDVFTNHPD)
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
 
      ** Validate US Indicium of US citizenship override value
      ** and comments
     C                   EXSR      SrVUSCIT
 
      ** Validate US Indicium of US Country of Birth override
      ** value and comments
     C                   EXSR      SrVUSCOB
 
      ** Validate US Indicium of US Country of Domicile override
      ** value and comments
     C                   EXSR      SrVUSCOD
 
     C                   RETURN
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVUSCIT - Validate US Indicium of Citizenship details
      *****************************************************************
 
     C     SrVUSCIT      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate US Indicium of Citizenship details
 
     C                   CALLB     'SDVUSCIT'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** US Indicium of Citizenship - Override Value (Original)
     C                   PARM                    P_DDCIOV
 
      ** US Indicium of Citizenship - Override Value
     C                   PARM                    DDCIOV
     C                   PARM                    DDNAHL
     C                   PARM      'N'           DDRTYP
 
      ** US Indicium of Citizenship - Override Active Doc
     C                   PARM                    DDCID1
     C                   PARM                    DDCID2
     C                   PARM                    DDCID3
     C                   PARM                    DDCID4
     C                   PARM                    DDCID5
     C                   PARM                    DDCIS1
     C                   PARM                    DDCIS2
     C                   PARM                    DDCIS3
     C                   PARM                    DDCIS4
     C                   PARM                    DDCIS5
 
      ** US Indicium of Citizenship Comment
     C                   PARM                    DDCIC1
     C                   PARM                    DDCIC2
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of Citizenship - OK
     C                   PARM                    DDCIOVOK          1
 
      ** US Indicium of Citizenship Comment - OK
     C                   PARM                    DDCICOOK          1
     C                   PARM                    DDCID1OK
     C                   PARM                    DDCID2OK
     C                   PARM                    DDCID3OK
     C                   PARM                    DDCID4OK
     C                   PARM                    DDCID5OK
 
     C                   PARM                    FVCIOV
     C                   PARM                    FVCID1
     C                   PARM                    FVCID2
     C                   PARM                    FVCID3
     C                   PARM                    FVCID4
     C                   PARM                    FVCID5
     C                   PARM                    FVCIS1
     C                   PARM                    FVCIS2
     C                   PARM                    FVCIS3
     C                   PARM                    FVCIS4
     C                   PARM                    FVCIS5
     C                   PARM                    FVCICO
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVUSCOB - Validate US Indicium of US Country of Birth
      *            details
      *****************************************************************
 
     C     SrVUSCOB      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate US Indicium of US Country of Birth details
 
     C                   CALLB     'SDVUSCOB'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** US Indicium of Country of Birth - Override Value (Original)
     C                   PARM                    P_DDCBOV
 
      ** US Indicium of Country of Birth - Override Value
     C                   PARM                    DDCBOV
     C                   PARM                    DDNAHL
     C                   PARM      'N'           DDRTYP
 
      ** US Indicium of Country of Birth - Override Active Doc
     C                   PARM                    DDCBD1
     C                   PARM                    DDCBD2
     C                   PARM                    DDCBD3
     C                   PARM                    DDCBD4
     C                   PARM                    DDCBD5
     C                   PARM                    DDCBS1
     C                   PARM                    DDCBS2
     C                   PARM                    DDCBS3
     C                   PARM                    DDCBS4
     C                   PARM                    DDCBS5
 
      ** US Indicium of Country of Birth Comment
     C                   PARM                    DDCBC1
     C                   PARM                    DDCBC2
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of Country of Birth - OK
     C                   PARM                    DDCBOVOK          1
 
      ** US Indicium of Country of Birth Comment - OK
     C                   PARM                    DDCBCOOK          1
     C                   PARM                    DDCBD1OK
     C                   PARM                    DDCBD2OK
     C                   PARM                    DDCBD3OK
     C                   PARM                    DDCBD4OK
     C                   PARM                    DDCBD5OK
 
     C                   PARM                    FVCBOV
     C                   PARM                    FVCBD1
     C                   PARM                    FVCBD2
     C                   PARM                    FVCBD3
     C                   PARM                    FVCBD4
     C                   PARM                    FVCBD5
     C                   PARM                    FVCBS1
     C                   PARM                    FVCBS2
     C                   PARM                    FVCBS3
     C                   PARM                    FVCBS4
     C                   PARM                    FVCBS5
     C                   PARM                    FVCBCO
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVUSCOD - Validate US Indicium of US Country of Domicile
      *            details
      *****************************************************************
 
     C     SrVUSCOD      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate US Indicium of US Country of Domicile details
 
     C                   CALLB     'SDVUSCOD'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** US Indicium of Country of Domicile - Override Value (Original)
     C                   PARM                    P_DDCDOV
 
      ** US Indicium of Country of Domicile - Override Value
     C                   PARM                    DDCDOV
     C                   PARM                    DDNAHL
     C                   PARM      'N'           DDRTYP
 
      ** US Indicium of Country of Domicile - Override Active Doc
     C                   PARM                    DDCDD1
     C                   PARM                    DDCDD2
     C                   PARM                    DDCDD3
     C                   PARM                    DDCDD4
     C                   PARM                    DDCDD5
     C                   PARM                    DDCDS1
     C                   PARM                    DDCDS2
     C                   PARM                    DDCDS3
     C                   PARM                    DDCDS4
     C                   PARM                    DDCDS5
 
      ** US Indicium of Country of Domicile Comment
     C                   PARM                    DDCDC1
     C                   PARM                    DDCDC2
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Indicium of Country of Domicile - OK
     C                   PARM                    DDCDOVOK          1
 
      ** US Indicium of Country of Domicile Comment - OK
     C                   PARM                    DDCDCOOK          1
     C                   PARM                    DDCDD1OK
     C                   PARM                    DDCDD2OK
     C                   PARM                    DDCDD3OK
     C                   PARM                    DDCDD4OK
     C                   PARM                    DDCDD5OK
 
     C                   PARM                    FVCDOV
     C                   PARM                    FVCDD1
     C                   PARM                    FVCDD2
     C                   PARM                    FVCDD3
     C                   PARM                    FVCDD4
     C                   PARM                    FVCDD5
     C                   PARM                    FVCDS1
     C                   PARM                    FVCDS2
     C                   PARM                    FVCDS3
     C                   PARM                    FVCDS4
     C                   PARM                    FVCDS5
     C                   PARM                    FVCDCO
 
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
 
     C                   MOVEL     'SDFTNH2VL'   DBPGM
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
