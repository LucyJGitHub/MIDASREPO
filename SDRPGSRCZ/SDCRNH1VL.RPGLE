     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CRS Non-Account Holder Details - Valdn')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCRNH1VL - Midas CRS Non-Account Holder Detail Validation   *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD041294           Date 19Sep16               *
      *  Prev Amend No. MD040876           Date 13Sep16               *
      *                 CGL177             Date 11Jan16               *
      *                 MD036356           Date 02Nov15               *
      *                 MD035388           Date 20Oct15               *
      *                 CGL157  *CREATE    Date 17Aug15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041294 - Customer extension details is missing in          *
      *             CUSD repair browse                                *
      *  MD040876 - CRS MQ (Recompile)                                *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD036356 - Multiple NAHO FATCA fields does not default values*
      *             from Main NAHO/CRS Details                        *
      *  MD035388 - FATCA Screen order rework                         *
      *  CGL157 - CRS Reporting                                       *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** Hook to enable non-core files to be included

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY includes the MM standard declares:
      /COPY ZACPYSRC,STDDECLARE

      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS

      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      /COPY ZACPYSRC,ERR_ARRAYS

      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      /COPY ZACPYSRC,ERR_XARRYS

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

      ** Transaction Details in screen format
     D CurCrnhDets   E DS                  EXTNAME(SDCRNSPD)
     D PrvCrnhDets   E DS                  EXTNAME(SDCRNSPD)
     D                                     PREFIX(P_)

      ** Transaction Details OK indicators
     D OKCrnhDets    E DS                  EXTNAME(SDECRNHPD)
     D                                     PREFIX(DD)

      ** Valid Transaction Details layout
     D ValidCrnh     E DS                  EXTNAME(SDVCRNHPD)

      ** External DS for CRS Details
     D ValidNahD     E DS                  EXTNAME(SDVCRSNPD)

      ** New Non-A/C Holder in File Format
     D NwNaFilFmt    E DS                  Extname(SDVNAHLPD)

      ** New Non-A/C Holder in File Format - FATCA Details
     D NwFaFilFmt    E DS                  EXTNAME(SDVFTNHPD)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Midas SD Midas modules Data Structure
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

     D ZMUSER          DS            17
     D  USRBCH                11     13



      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Parameter for *Entry
     D RespMode        S              1A

      ** Parameter for Access Object
     D PRtcd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D CGL032          S              1A

      ** Work fields for bank data
     D WKDFIN          S                   LIKE(BJDFIN)
     D WKRDNB          S                   LIKE(BJRDNB)
     D WKCYCD          S                   LIKE(BJCYCD)
     D PDate           S              8A

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0

     D PFeature        S              3A
     D PCrsdS          S            351A   DIM(30)                                            CGL177
     D PHasIndicia     S              1A   INZ('N')                                         MD036356

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

     C                   EVAL      PHasIndicia = 'N'                                        MD035356

      ** Validate CRS Type
     C                   EXSR      SrVTYPE

      ** Validate CRS Sub-Type
     C                   EXSR      SrVSTYP

      ** Validate High Value Account
     C                   EXSR      SrVHVAC

      ** Validate Exempt Flag and Remark
     C                   EXSR      SrVEXEM

      ** Validate CRS Information Complete
     C                   EXSR      SrVCRIC

      ** Validate CRS Exception of Non-Account Holder
     C                   EXSR      SrVEXCP

      ** Return to Caller
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVTYPE - Validate CRS Type
      *****************************************************************

     C     SrVTYPE       BEGSR

      ** Reset variables updated by validation

     C                   EXSR      SRRESETERRS

      ** Validate CRS Type

     C                   CALLB     'SDVTYPE'

      ** INPUTS

      ** Return Code
     C                   PARM                    RetCodeOut

      ** CRS Type
     C                   PARM                    DDTYPE            1

      ** CRS Type Description
     C                   PARM                    DDTYPD

      ** OUTPUTS

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** CRS Type - OK
     C                   PARM                    DDOKTYPE          1
     C                   PARM                    NVTYPE


      ** Update error info with that returned from the validation module

     C                   EXSR      SRUPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVSTYP - Validate CRS Sub type
      *****************************************************************
     C     SrVSTYP       BEGSR

      ** Reset variables updated by validation

     C                   EXSR      SRRESETERRS

      ** Validate CRS Sub type

     C                   CALLB     'SDVSTYP'

      ** INPUTS

      ** Return Code
     C                   PARM                    RetCodeOut

      ** CRS Sub type
     C                   PARM                    DDSTYP            2
     C                   PARM                    DDTYPE            1
     C                   PARM                    DDSTYD

      ** OUTPUTS

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** CRS  Sub type - OK
     C                   PARM                    DDOKSTYP          1
     C                   PARM                    NVSTYP


      ** Update error info with that returned from the validation module

     C                   EXSR      SRUPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVHVAC - Validate High Value Account
      *****************************************************************
     C     SrVHVAC       BEGSR

      ** Reset variables updated by validation

     C                   EXSR      SRRESETERRS

      ** Validate High Value Account

     C                   CALLB     'SDVHVAC'

      ** INPUTS

      ** Return Code
     C                   PARM                    RetCodeOut

      ** Action Code                                                                        MD035388
     C                   PARM                    DDACTR                                     MD035388
                                                                                            MD035388
      ** High Value Account (Original)
     C                   PARM                    P_DDHVAL

      ** High Value Account
     C                   PARM                    DDHVAL            1

     C                   PARM      DDHVAL        C_DDHVAL          1                        MD035388
                                                                                            MD035388
      ** OUTPUTS

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays)
      ** from/to caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

      ** High Value Account - OK
     C                   PARM                    DDOKHVAL          1
     C                   PARM                    NVHVAL


      ** Update error info with that returned from the validation module

     C                   EXSR      SRUPDATERRS

     C                   ENDSR

      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVEXEM - Validate Exempt Flag and Remark
      *****************************************************************

     C     SrVEXEM       BEGSR

      ** Reset variables updated by validation

     C                   EXSR      SRRESETERRS

      ** Validate Exempt Flag and Remark

     C                   CALLB     'SDVEXEM'

      ** INPUTS

      ** Return Code
     C                   PARM                    RetCodeOut

      ** Exempt Flag (Original)
     C                   PARM                    P_DDEXMP

      ** Current run date
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN

      ** User ID
     C                   PARM                    DDUSID           10
     C                   PARM                    DDEXMP            1
     C                   PARM      *Blanks       DDCUST            6
     C                   PARM                    DDNAHL           10
     C                   PARM                    DDEXM1           64
     C                   PARM                    DDEXM2           64
     C                   PARM                    DDEXM3           64
     C                   PARM                    DDEXM4           64

     C                   PARM                    DDEXMF
     C                   PARM                    DDEXMT
     C                   PARM                    DDEXMU

      ** OUTPUTS

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Exempt - OK
     C                   PARM                    DDOKEXMP          1

      ** Exempt Remark - OK
     C                   PARM                    DDOKEXMR          1
     C                   PARM                    NVEXMP
     C                   PARM                    NVEXMD            5 0
     C                   PARM                    NVEXMT            6
     C                   PARM                    NVEXMU           10
     C                   PARM                    NVEXMF            6
     C                   PARM                    NVEXMR

      ** Update error info with that returned from the validation module

     C                   EXSR      SRUPDATERRS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrVCRIC - Validate CRS Information Complete
      *****************************************************************

     C     SrVCRIC       BEGSR

     C                   EVAL      NAHLID = 'N'
     C                   EVAL      DDINFCO = NVINFO

      ** Reset variables updated by validation

     C                   EXSR      SRResetErrs

      ** Validate CRS Information Complete

     C                   CALLB     'SDVCRIN'

      ** INPUTS

      ** Return Code
     C                   PARM                    RetCodeOut
     C                   PARM                    CurCrnhDets
     C                   PARM                    PCrsdS
     C                   PARM                    ValidNahD
     C                   PARM                    NwNaFilFmt
     C                   PARM                    NAHLID            1
     C                   PARM                    DDINFCO           1

      ** OUTPUTS

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays)
      ** from/to caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

      ** CRS Information Complete - OK
     C                   PARM                    DDOKINFC
     C                   PARM                    NVINFO

      ** Update error info with that returned from the validation module

     C                   EXSR      SRUpdatErrs

     C                   ENDSR

      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVEXCP - Process Exception of Non-Account Holder
      *****************************************************************

     C     SrVEXCP       BEGSR

     C                   EVAL      PFeature = 'CRS'

      ** Reset variables updated by validation

     C                   EXSR      SRResetErrs

     C                   CALLB     'SDVNXCP'

      ** INPUTS

      ** Return Code
     C                   PARM                    RetCodeOut
     C                   PARM                    NwFaFilFmt
     C                   PARM                    NwNaFilFmt
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
     C                   PARM                    PHasIndicia                                MD036356
     C                   PARM                    CurCrnhDets
     C                   PARM                    PCrsdS
     C                   PARM                    ValidNahD
     C                   PARM                    PFeature

      ** Warning fields/message IDs/message data (arrays)
      ** from/to caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    NVEXMG
     C                   PARM                    NVEXMI

      ** Update error info with that returned from the validation module

     C                   EXSR      SRUpdatErrs

     C                   ENDSR

      *****************************************************************
     C/EJECT
      *****************************************************************
      * SRRESETERRS - Reset error information that is received back   *
      *    from each validation module.                               *
      *****************************************************************
     C     SRRESETERRS   BEGSR

     C                   EVAL      RetCodeOut = *Blanks

      ** Reset error & warning fields/message IDs/message data (arrays)
     C                   EVAL      FldNamXAr = *Blanks
     C                   EVAL      MsgIDXAr  = *Blanks
     C                   EVAL      MsgDtaXAr = *Blanks
     C                   EVAL      WFldNmXAr = *Blanks
     C                   EVAL      WMsgIDXAr = *Blanks
     C                   EVAL      WMsgDtXAr = *Blanks

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUPDATERRS - Update error information with that received back*
      *    from each validation module.                               *
      *****************************************************************
     C     SRUPDATERRS   BEGSR

      ** Update error fields/message IDs/message data (arrays)

     C                   Z-ADD     1             I                 3 0
     C     *Blanks       LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF

      ** Set Error Index
     C                   Z-ADD     1             I
     C     *Blanks       LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx

      ** Update warning fields/message IDs/message data (arrays)

     C                   Z-ADD     1             I
     C     *Blanks       LOOKUP    WFldNamArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF

      ** Set Warning Index
     C                   Z-ADD     1             I
     C     *Blanks       LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Inputs
      ** Response mode
     C                   PARM                    RespMode

      ** Transaction Details
     C                   PARM                    CurCrnhDets
     C                   PARM                    PrvCrnhDets
      **  New Non-A/C Holder in File Format
     C                   PARM                    NwNaFilFmt
     C                   PARM                    NwFaFilFmt
      ** CRS Country Transaction Details
     C                   PARM                    PCrsdS

      ** Outputs
      ** Transaction Details OK inds
     C                   PARM                    OKCrnhDets

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
     C                   PARM                    WIdx

      ** Valid Transaction details layout (DS) from/to caller
     C                   PARM                    ValidCrnh

      ** Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  =  900
     C                   EVAL      DBKEY  = POptn
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WKDFIN = BJDFIN
     C                   EVAL      WKRDNB = BJRDNB
     C                   EVAL      WKCYCD = BJCYCD
     C                   ENDIF

     C                   EVAL      DDUSID = PSUSER

      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR

     C                   EVAL      DBPGM = 'SDCRNH1VL'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP

      **  Terminate the program

     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************

      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE

      *****************************************************************
** CTDATA CPY@
(c) Finastra International Limited 2013
