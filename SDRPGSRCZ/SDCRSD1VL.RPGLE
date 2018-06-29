     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CRS Customer Details Validation')             *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module.                             *
      *                                                               *
      *  SDCRSD1VL - Midas CRS Customer Details Validation            *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD051393           Date 29Jun18               *
      *  Prev Amend No. MD051230           Date 08Jun18               *
      *                 MD050572           Date 03May18               *
      *                 MD040876           Date 13Sep16               *
      *                 CGL177             Date 11Jan16               *
      *                 MD036375           Date 02Nov15               *
      *                 MD035388           Date 20Oct15               *
      *                 CGL157  *CREATE    Date 17Aug15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD051393 - Info complete flag                                *
      *  MD051230 - Authorise of customer record in CUSD gets serious *
      *             midas error message                               *
      *  MD050572 - Exception 14 and 15 is not being displayed /      *
      *             triggered                                         *
      *  MD040876 - CRS MQ (Recompile)                                *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD036375 - Exception 3 is displayed even TIN details are comp*
      *  MD033588 - FATCA Screen order rework                         *
      *  CGL157 - CRS Reporting                                       *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** Hook to enable non-core files to be included

      ** Midas SD Customer Details Ext C - Keyed
     FSDCUSXL1  IF   E           K DISK    INFSR(*PSSR)

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
     D CurCrsdDets   E DS                  EXTNAME(SDCRSSPD)
     D PrvCrsdDets   E DS                  EXTNAME(SDCRSSPD)
     D                                     PREFIX(P_)

      ** Transaction Details OK indicators
     D OKCrsdDets    E DS                  EXTNAME(SDECRSHPD)
     D                                     PREFIX(DD)

      ** Valid Transaction Details layout
     D ValidCrsh     E DS                  EXTNAME(SDVCRSHPD)

      ** External DS for CRS Details
     D ValidCusD     E DS                  EXTNAME(SDVCRSDPD)

      ** SD Valid Additional Customer Details
     D SDVACUD1      E DS                  EXTNAME(SDVCUADPD)

      ** Valid Customer Details layout
     D ValidFATCA    E DS                  EXTNAME(SDVFTCSPD)

      ** Ext Customer in File Format
     D NwXcFilFmt    E DS                  EXTNAME(SDVCUXCPD)
     D                                     PREFIX(E_)

      ** (Current) Customer Authority Holder details in file Format                         MD050572
     D ValidCUAH     E DS                  EXTNAME(SDVCUAHPD)                               MD050572
     D                                     PREFIX(V_)                                       MD050572
                                                                                            MD050572
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
                                                                                            MD051230
      ** Override Database Table                                                            MD051230
     D ##OV1           S             50    DIM(1) CTDATA PERRCD(1)                          MD051230
     D ##OV2           S             50    DIM(1) CTDATA PERRCD(1)                          MD051230
     D WMsgLen         S             15P 5 INZ(50)                                          MD051230

      ** Parameter for *Entry
     D RespMode        S              1A

      ** Parameter for Access Object
     D PRtcd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D CGL032          S              1A
     D W               S              2S 0
     D N               S              2S 0

      ** Work fields for bank data
     D WKDFIN          S                   LIKE(BJDFIN)
     D WKRDNB          S                   LIKE(BJRDNB)
     D WKCYCD          S                   LIKE(BJCYCD)
     D PDate           S              8A

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0

     D PBirthDetails   DS                                                                   MD036375
     D  BirthDate              1      8                                                     MD036375
     D  BirthCtry              9     10                                                     MD036375
     D  BirthTown             11     45                                                     MD036375
                                                                                            MD036375
     D PFeature        S              3A
     D*PCrsdS***       S            350A   DIM(30)                                            CGL177
     D PCrsdS          S            223A   DIM(30)                                            CGL177
     D V_CUAHArr       S                   DIM(50) LIKE(ValidCUAH)                          MD050572

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
     I
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

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

      ** Validate CRS Exception of Customer
     C                   EXSR      SrVEXCP

      ** Return to Caller
     C                   RETURN

      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVTYPE - Validate CRS Customer Type
      *****************************************************************

     C     SrVTYPE       BEGSR

      ** Reset variables updated by validation

     C                   EXSR      SRRESETERRS

      ** Validate CRS Customer Type

     C                   CALLB     'SDVTYPE'

      ** INPUTS

      ** Return Code
     C                   PARM                    RetCodeOut

      ** CRS Customer Type
     C                   PARM                    DDTYPE            1

      ** CRS Customer Type Description
     C                   PARM                    DDTYPD           29

      ** OUTPUTS

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** CRS Customer Type - OK
     C                   PARM                    DDOKTYPE          1
     C                   PARM                    CVTYPE


      ** Update error info with that returned from the validation module

     C                   EXSR      SRUPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVSTYP - Validate CRS Customer Sub type
      *****************************************************************
     C     SrVSTYP       BEGSR

      ** Reset variables updated by validation

     C                   EXSR      SRRESETERRS

      ** Validate CRS Customer Sub type

     C                   CALLB     'SDVSTYP'

      ** INPUTS

      ** Return Code
     C                   PARM                    RetCodeOut

      ** CRS Customer Sub type
     C                   PARM                    DDSTYP            2
     C                   PARM                    DDTYPE            1
     C                   PARM                    DDSTYD           29

      ** OUTPUTS

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** CRS Customer Sub type - OK
     C                   PARM                    DDOKSTYP          1
     C                   PARM                    CVSTYP


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
     C                   PARM                    DDACTI                                     MD035388
                                                                                            MD035388
      ** High Value Account (Original)
     C                   PARM                    P_DDHVAL

      ** High Value Account
     C                   PARM                    DDHVAL            1

     C                   PARM      *BLANKS       C_DDHVAL          1                        MD035388
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
     C                   PARM                    CVHVAL

     C                   IF        FldNamXAr(1) = 'DDHVAC'
     C                   EVAL      FldNamXAr(1) = 'DDHVAL'
     C                   ENDIF

     C                   IF        FldNamXAr(2) = 'DDHVAC'
     C                   EVAL      FldNamXAr(2) = 'DDHVAL'
     C                   ENDIF

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
     C                   PARM                    DDCUSN
     C                   PARM      *Blanks       DDNAHL           10
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
     C                   PARM                    CVEXMP
     C                   PARM                    CVEXMD            5 0
     C                   PARM                    CVEXMT            6
     C                   PARM                    CVEXMU           10
     C                   PARM                    CVEXMF            6
     C                   PARM                    CVEXMR

     C                   EVAL      N = 1
     C                   DOW       FldNamXAr(N) <> *Blanks

     C                   IF        FldNamXAr(N) = 'DDEXEM'
     C                   EVAL      FldNamXAr(N) = 'DDEXMP'
     C                   ENDIF

     C                   IF        FldNamXAr(N) = 'DDEXE1'
     C                   EVAL      FldNamXAr(N) = 'DDEXM1'
     C                   ENDIF

     C                   EVAL      N = N + 1
     C                   ENDDO

      ** Update error info with that returned from the validation module

     C                   EXSR      SRUPDATERRS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrVCRIC - Validate CRS Information Complete
      *****************************************************************

     C     SrVCRIC       BEGSR
                                                                                            MD051230
     C                   CALL      'QCMDEXC'                                                MD051230
     C                   PARM                    ##OV1                                      MD051230
     C                   PARM                    WMsgLen                                    MD051230

     C                   EVAL      CUSTID = 'C'
     C                   EVAL      DDINFCO = CVINFO

      ** Reset variables updated by validation

     C                   EXSR      SRResetErrs

      ** Validate CRS Information Complete

     C                   CALLB     'SDVCRIC'

      ** INPUTS

      ** Return Code
     C                   PARM                    RetCodeOut
     C                   PARM                    CurCrsdDets
     C                   PARM                    PCrsdS
     C                   PARM                    ValidCusD
     C                   PARM                    SDVACUD1
     C                   PARM                    CUSTID            1
     C                   PARM                    DDINFCO           1
     C                   PARM                    P_DDINFO                                   MD051393

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
     C                   PARM                    CVINFO
                                                                                            MD051230
     C                   CALL      'QCMDEXC'                                                MD051230
     C                   PARM                    ##OV2                                      MD051230
     C                   PARM                    WMsgLen                                    MD051230

      ** Update error info with that returned from the validation module

     C                   EXSR      SRUpdatErrs

     C                   ENDSR

      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVEXCP - Process Exception of Customer
      *****************************************************************

     C     SrVEXCP       BEGSR

      ** Retrieve Customer Creation Date
     C*****DDCUSN        CHAIN     SDCUSTX0                                                 MD050572
     C     DDCUSN        CHAIN     SDCUSXL1                                                 MD050572
     C                   IF        %FOUND(SDCUSXL1)

      ** Customer Creation Date for SDVEXCP validation
     C                   EVAL      E_XCCUST  = XCCUST
     C                   EVAL      E_XCACCZ  = XCACCZ
     C                   EVAL      E_XCCRDT  = XCCRDT
     C                   EVAL      E_XCLCUS  = XCLCUS
     C                   ELSE
     C                   EVAL      E_XCCUST  = DDCUSN
     C                   EVAL      E_XCACCZ  = *Blanks
     C                   EVAL      E_XCCRDT  = *Zero
     C                   EVAL      E_XCLCUS  = *Blanks
     C                   ENDIF

      ** Reset ValidFATCA External DS since it will not be used:
     C                   RESET                   ValidFATCA

     C                   EVAL      PFeature = 'CRS'

      ** Reset variables updated by validation

     C                   EXSR      SRResetErrs

     C                   CALLB     'SDVEXCP'

      ** INPUTS

      ** Return Code
     C                   PARM                    RetCodeOut
     C                   PARM                    ValidFATCA
     C                   PARM                    NwXcFilFmt
     C                   PARM                    BJRDNB
     C                   PARM                    DDACTN            1                        MD050572
     C                   PARM                    BJDFIN            1                        MD050572
     C                   PARM      'N'           PHasIndicia       1                        MD050572
     C                   PARM                    V_CUAHArr                                  MD050572
     C                   PARM                    CurCrsdDets
     C                   PARM                    PCrsdS
     C                   PARM                    ValidCusD
     C**********         PARM                    PBirthDetails                     MD036375 MD050572
     C**********         PARM      'N'           PHasIndicia       1                        MD050572
     C                   PARM                    PFeature

      ** Warning fields/message IDs/message data (arrays)
      ** from/to caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    CVEXMG
     C                   PARM                    CVEXMI
     C                   PARM                    BJDFIN

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
     C                   PARM                    CurCrsdDets
     C                   PARM                    PrvCrsdDets
      ** ** Valid ACUD Transaction details layout (DS)
     C                   PARM                    SDVACUD1
      ** CRS Country Transaction Details
     C                   PARM                    PCrsdS

      ** Outputs
      ** Transaction Details OK inds
     C                   PARM                    OKCrsdDets

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

      ** Valid Transaction details layout (DS) from/to caller
     C                   PARM                    ValidCrsh

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

     C                   EVAL      DBPGM = 'SDCRSD1VL'
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
** ##OV1                                                                                    MD051230
OVRDBF FILE(SDCRSHL1) TOFILE(SDCRSHL1) SHARE(*NO)                                           MD051230
** ##OV2                                                                                    MD051230
DLTOVR FILE(SDCRSHL1)                                                                       MD051230
