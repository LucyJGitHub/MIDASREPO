     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD FATCA Non-A/c Holder details 5 validation')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module.                             *
      *                                                               *
      *  SDFTNH5VL - FATCA Customer Details 5 Validation              *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD052465           Date 10Jan19               *
      *  Prev Amend No. MD040876           Date 13Sep16               *
      *                 CGL177             Date 11Jan16               *
      *                 MD036460           Date 05Nov15               *
      *                 MD036380           Date 03Nov15               *
      *                 MD036356           Date 02Nov15               *
      *                 MD035388           Date 20Oct15               *
      *                 CGL157             Date 17Aug15               *
      *                 MD046248           Date 27Oct17               *
      *                 MD042697           Date 22Nov16               *
      *                 MD036356           Date 02Nov15               *
      *                 MD033414           Date 28Feb15               *
      *                 MD030158           Date 05Sep14               *
      *                 MD030156           Date 02Sep14               *
      *                 MD027456           Date 17Sep14               *
      *                 MD029805           Date 05Sep14               *
      *                 MD029837           Date 22Aug14               *
      *                 MD027458           Date 04Aug14               *
      *                 MD027453           Date 27Aug14               *
      *                 MD027561           Date 03Jul14               *
      *                 MD027560           Date 19Jun14               *
      *                 MD026997           Date 29May14               *
      *                 MD026693A          Date 22May14               *
      *                 MD026693           Date 22May14               *
      *                 MD026550           Date 22May14               *
      *                 MD026887           Date 13May14               *
      *                 MD026494           Date 27Apr14               *
      *                 CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD052465 - Not possible to capture mandatory US TIN for      *
      *             FATCA reporting                                   *
      *  MD040876 - CRS MQ (Recompile)                                *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD036460 - FATCA US Indicia update enhancements              *
      *  MD036380 - FATCA Information Complete Flag cannot be set     *
      *             to yes even if all TIN details are defined        *
      *  MD046248 - Finastra Rebranding                               *
      *  MD033588 - FATCA Screen order rework                         *
      *  CGL157 - CRS Reporting                                       *
      *  MD042697 - Newly insert NAHO is not reflected                *
      *  MD036356 - Multiple NAHO FATCA fields does not default values*
      *             from Main NAHO/CRS Details                        *
      *  MD033414 - CGL154 amended exceptions is missing. Apply       *
      *             fix MD025163                                      *
      *  MD030158 - OCBC FATCA - error not prompted when discrepancy  *
      *             between joint account holders. Apply fix MD-27140 *
      *  MD030156 - OCBC FATCA - The warning prompt for "PS" subtype  *
      *             appears to be inconsistent. Apply fix MD-27288    *
      *  MD025163 - Exception for Customer/Non-Account holder does    *
      *             not recognize US TIN when subject to reporting is *
      *             set to Y                                          *
      *  MD027456 - FATCA Reporting type and FATCA Exempt's Populated *
      *             Time on Newly Inserted NAHO is Invalid            *
      *             Apply Fix MD028155                                *
      *  MD029805 - GIIN number validation                            *
      *  MD029837 - OCBC FATCA - cannot set FATCA complete to "Y"     *
      *             during creation of new customer                   *
      *           - Apply fix MD027454                                *
      *  MD027458 - FATCA Exempt? flag should not be amendable to     *
      *             blank                                             *
      *  MD027453 - FATCA classification Description is not updated   *
      *             automatically when setting a FATCA classification *
      *             Code. Apply Fix MD028137                          *
      *  MD027561 - FATCA Classification Date is not updated to date  *
      *             when FATCA Classification was changed             *
      *  MD027560 - Authority Holder Indicia Not Included as valida-  *
      *             tion to FATCA Info Complete Flag                  *
      *  MD026997 - Only check US TIN if subject to reporting is 'Y'  *
      *             for Customers/Non-Account Holders created after   *
      *             FATCA Effective Date                              *
      *  MD026693A - FATCA Info complete flag error                   *
      *  MD026693 - FATCA Info complete flag error                    *
      *  MD026550 - Require US TIN when Subject to Reporting is 'Y'   *
      *             for all new FATCA Customers/Non-Account Holders   *
      *  MD026887 - Mismatched parameter with SDVFTIC                 *
      *  MD026494 - Dbase error encountered when inserting a          *
      *             transaction in NAHO                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Non Account Holder FATCA Info Retrieval Index                                      MD027454
     FSDFTNHL1  IF   E           K DISK    INFSR(*PSSR)                                     MD027454
                                                                                            MD027454
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
 
      ** New Non-A/C Holder in File Format
     D NwNaFilFmt    E DS                  Extname(SDVNAHLPD)
 
     D CrFoScnFmt      DS
     D  WCDESC1                1     50
     D  WPDESC1               51    100
     D  DDBRTH               101    106
     D  DDCBTH               107    108
     D  DDBTHT               109    143
     D  DDCNCZ               144    145
     D  DDCDOM               146    147
     D  DDACCZ               148    149
     D  DDUTNN               149    173
 
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
                                                                                              CGL157
      ** CRS Transaction Details in screen format                                             CGL157
     D CurCrshDets   E DS                  EXTNAME(SDCRNSPD)                                MD035388
     D                                     PREFIX(C_)                                         CGL157
                                                                                              CGL157
      ** External DS for CRS Details                                                          CGL157
     D ValidCusD     E DS                  EXTNAME(SDVCRSNPD)                               MD036356
      ** External DS for CRS API Format Definition File - Detail                            MD052465
     D TranInCRDD    E DS                  EXTNAME(SDCRDDPD)                                MD052465
     D                                     PREFIX(CR)                                       MD052465
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Override Database Table                                                            MD027454
     D ##OV1           S             50    DIM(1) CTDATA PERRCD(1)                          MD027454
     D ##OV2           S             50    DIM(1) CTDATA PERRCD(1)                          MD027454
                                                                                            MD027454
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
     DSYSVAL1          C                    'FATCAEffectStartDate'                          MD027454
                                                                                            MD027454
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D PCust           S              6A                                                    MD026887
     D WRunDay         S                   LIKE(BJRDNB)
     D DDRPOVO         S              1A
     D DDIDOVO         S              1A
     D DDMCOVO         S              1A
     D FVNFRD          S              5P 0
     D DDINFCO         S              1A
     D NAHCUS          S              1A   INZ('N')
     D WWCOLC          S              2A                                                    MD026693
     D PPTIN1          S             25A                                                    MD026693
     D PPTNC2          S              2A                                                    MD026693
     D PPTIN2          S             25A                                                    MD026693
     D PPTNC3          S              2A                                                    MD026693
     D PPTIN3          S             25A                                                    MD026693
     D PPTNC4          S              2A                                                    MD026693
     D PPTIN4          S             25A                                                    MD026693
     D PPTNC5          S              2A                                                    MD026693
     D PPTIN5          S             25A                                                    MD026693
     D DDDBTH          S              8A                                                    MD026693
     D PIsNew          S              1A   INZ('N')                                         MD027454
     D PDateFormat     S              1A                                                    MD027454
     D WEffDate        S              5P 0                                                  MD027454
     D WNEffDate       S              6P 0                                                  MD027454
     D WMsgLen         S             15P 5 INZ(50)                                          MD027454
 
      ** Parameters for AOSVAL                                                              MD027454
     D PRetCode        S             20A   INZ(*BLANKS)                                     MD027454
     D POP01           S             20A   INZ(*BLANKS)                                     MD027454
     D PVL01           S            200A   INZ(*BLANKS)                                     MD027454
     D POP02           S             20A   INZ(*BLANKS)                                     MD027454
     D PVL02           S            200A   INZ(*BLANKS)                                     MD027454
                                                                                              CGL157
     D PFeature        S              3A   INZ('FTC')                                         CGL157
     D PCrsdS          S            351A   DIM(30)                                            CGL177
     D PHasIndicia     S              1A   INZ('N')                                         MD036356
     D PAINSF          S              1A                                                    MD036460
                                                                                            MD027454
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
 
     C                   CALL      'QCMDEXC'                                                MD027454
     C                   PARM                    ##OV1                                      MD027454
     C                   PARM                    WMsgLen                                    MD027454
                                                                                            MD027454
      ** Check if the Customer is being inserted and                                        MD027454
      ** after Effective Date                                                               MD027454
     C                   EVAL      PIsNew = 'N'                                             MD027454
     C     DDNAHL        CHAIN(N)  SDFTNHL1                                                 MD027454
     C                   IF        NOT %FOUND(SDFTNHL1)                                     MD027454
     C                   IF        DDACTI = ' '                                             MD027454
     C                             AND WRunDay >= WEffDate                                  MD027454
     C                   EVAL      PIsNew = 'Y'                                             MD027454
     C                   ENDIF                                                              MD027454
     C                   ENDIF                                                              MD027454
                                                                                            MD027454
     C                   EVAL      PHasIndicia = 'N'                                        MD036356
                                                                                            MD036356
      ** Check Customer Indicia                                                             MD036356
     C                   EXSR      SrChkIndicia                                             MD036356
                                                                                            MD036356
     C                   EVAL      DDUSID = PSUSER
 
      ** Validate FATCA Customer Type
     C                   EXSR      SrVCSTY
 
      ** Validate High Value Account
     C                   EXSR      SrVHVAC
 
      ** Validate FATCA Customer Sub type
     C                   EXSR      SrVCSST
 
      ** Validate Subject to Reporting
     C                   EXSR      SrVSRPT
 
      ** Validate FATCA Classification Code and Date
     C                   EXSR      SrVCLASS
                                                                                            MD029805
      ** Validate GIIN Number                                                               MD029805
     C                   EXSR      SrVGIINN                                                 MD029805
 
      ** Validate GIIN Last Verification Date
     C                   EXSR      SrVGIIND
 
      ** Validate GIIN Owner
     C                   EXSR      SrVGIINO
 
      ** Validate Mailing Country
     C                   EXSR      SrVMAIL
 
      ** Validate US Phone Number
     C                   EXSR      SrVPHON
 
      ** Validate US Green Card
     C                   EXSR      SrVGRENC
 
      ** Validate Reporting Type and Reporting Type Remark
     C                   EXSR      SrVRPTT
 
      ** Validate Exempt Flag and Remark
     C                   EXSR      SrVEXEM
 
      ** Validate FATCA Information Complete
     C                   EXSR      SrVFTIC
 
      ** Process Exception of customer
     C**********         IF        Idx = 0                                                  MD027288
     C                   EXSR      SrVEXCP
     C**********         ENDIF                                                              MD027288
 
     C                   CALL      'QCMDEXC'                                                MD027454
     C                   PARM                    ##OV2                                      MD027454
     C                   PARM                    WMsgLen                                    MD027454
                                                                                            MD027454
     C                   RETURN
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVCLASS - Validate FATCA Classification Code
      *****************************************************************
 
     C     SrVCLASS      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate FATCA Classification Code and Date
 
     C                   CALLB     'SDVCLASS'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** FATCA Classification Code (Original)
     C                   PARM                    P_DDCLAC
 
      ** FATCA Classification Code
     C                   PARM                    DDCLAC
     C                   PARM                    DDPCLA
 
      ** FATCA Classification Date (Original)
     C                   PARM                    P_DDCLAF
 
      ** FATCA Classification Date
     C                   PARM                    DDCLAF
     C**********         PARM                    WCDESC1                                    MD026494
     C**********         PARM                    WPDESC1                                    MD026494
     C                   PARM                    BJDFIN            1
     C                   PARM                    BJRDNB            5 0
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
 
      ** FATCA Classification Date - OK
     C                   PARM                    DDCLADOK          1
 
      ** FATCA Classification Code - OK
     C                   PARM                    DDCLACOK
     C                   PARM                    DDUSIA            1
     C                   PARM                    FVCLAC            5
     C                   PARM                    FVCLAD            5 0
     C                   PARM                    FVPCLA            5
     C                   PARM                    FVCLAF            6
     C**********         PARM                    WWCLDS           50                        MD028137
     C                   PARM                    WCDESC1          50                        MD028137
     C                   PARM                    WWPFCE           50
     C                   PARM                    WCLAFlag                                   MD027561
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVEXEM - Validate Exempt Flag and Remark
      *****************************************************************
 
     C     SrVEXEM       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Exempt Flag and Remark
 
     C                   CALLB     'SDVEXEM'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** Exempt Flag (Original)
     C                   PARM                    P_DDEXEM
 
      ** Current run date
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
 
      ** User ID
     C                   PARM                    DDUSID           10
     C                   PARM                    DDEXEM            1
     C                   PARM      *BLANKS       DDCUST            6                        MD027458
     C                   PARM                    DDNAHL           10                        MD027458
     C                   PARM                    DDEXE1           64
     C                   PARM                    DDEXE2           64
     C                   PARM                    DDEXE3           64
     C                   PARM                    DDEXE4           64
 
     C                   PARM                    DDEXEF
     C                   PARM                    DDEXET
     C                   PARM                    DDEXEU
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Exempt - OK
     C                   PARM                    DDEXEMOK          1
 
      ** Exempt Remark - OK
     C                   PARM                    DDEXEROK          1
     C                   PARM                    FVEXEM
     C                   PARM                    FVEXED            5 0
     C                   PARM                    FVEXET            6
     C                   PARM                    FVEXEU           10
     C                   PARM                    FVEXDF            6
     C                   PARM                    FVEXER
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVRPTT - Validate Reporting Type and Remarks
      *****************************************************************
 
     C     SrVRPTT       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Reporting Type and Remarks
 
     C                   CALLB     'SDVRPTT'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** Exempt Flag (Original)
     C                   PARM                    P_DDRPTT
 
      ** Current run date
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
 
      ** User ID
     C                   PARM                    DDUSID           10
     C                   PARM                    DDRPTT            1
     C                   PARM                    DDRPT1           64
     C                   PARM                    DDRPT2           64
 
     C                   PARM                    DDRPTD
     C**********         PARM                    DDRPTT                                     MD028155
     C                   PARM                    DDRPTM                                     MD028155
     C                   PARM                    DDRPTU
     C                   PARM                    DDRPDE
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Exempt - OK
     C                   PARM                    DDRPTTOK          1
 
      ** Exempt Remark - OK
     C                   PARM                    DDRPTROK          1
     C                   PARM                    FVRPTT
     C                   PARM                    FVRPTD            5 0
     C                   PARM                    FVRPTM            6
     C                   PARM                    FVRPTU           10
     C                   PARM                    FVRPTF            6
     C                   PARM                    FVRPTR
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
                                                                                            MD029805
      *****************************************************************                     MD029805
     C/EJECT                                                                                MD029805
      *****************************************************************                     MD029805
      * SrVGIINN - Validate GIIN Number                                                     MD029805
      *****************************************************************                     MD029805
                                                                                            MD029805
     C     SrVGIINN      BEGSR                                                              MD029805
                                                                                            MD029805
      ** Reset variables updated by validation                                              MD029805
                                                                                            MD029805
     C                   EXSR      RESETERRS                                                MD029805
                                                                                            MD029805
      ** Validate GIIN Number                                                               MD029805
                                                                                            MD029805
     C                   CALLB     'SDVGIINN'                                               MD029805
                                                                                            MD029805
      ** INPUTS                                                                             MD029805
                                                                                            MD029805
      ** Return Code                                                                        MD029805
     C                   PARM                    RetCodeOut                                 MD029805
                                                                                            MD029805
      ** GIIN Number                                                                        MD029805
     C                   PARM                    DDGIIN           25                        MD029805
     C                   PARM                    DDNHTP                                     MD029805
     C                   PARM                    DDNHST                                     MD029805
                                                                                            MD029805
      ** OUTPUTS                                                                            MD029805
                                                                                            MD029805
      ** Error fields/message IDs/message data (arrays) from/to caller                      MD029805
     C                   PARM                    FldNamXAr                                  MD029805
     C                   PARM                    MsgIDXAr                                   MD029805
     C                   PARM                    MsgDtaXAr                                  MD029805
                                                                                            MD029805
      ** GIIN Number - OK                                                                   MD029805
     C                   PARM                    DDGIINOK          1                        MD029805
     C                   PARM                    FVGIIN                                     MD029805
                                                                                            MD029805
      ** Update error info with that returned from the validation module                    MD029805
                                                                                            MD029805
     C                   EXSR      UPDATERRS                                                MD029805
                                                                                            MD029805
     C                   ENDSR                                                              MD029805
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVGIIND - Validate GIIN Last Verification Date
      *****************************************************************
 
     C     SrVGIIND      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate GIIN Last Verification Date
 
     C                   CALLB     'SDVGIIND'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** GIIN Last Verification Date
     C                   PARM                    DDGIIF            6
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    BJDFIN            1
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** GIIN Last Verification Date - OK
     C                   PARM                    DDGIIDOK          1
     C                   PARM                    FVGIID
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVGIINO - GIIN Owner
      *****************************************************************
 
     C     SrVGIINO      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate GIIN Owner
 
     C                   CALLB     'SDVGIINO'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** GIIN Owner
     C                   PARM                    DDGIIO           10
 
      ** FATCA Customer Sub type
     C                   PARM                    DDNHST            2
     C                   PARM                    DDNHSTOK          1
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** GIIN Owner - OK
     C                   PARM                    DDGIIOOK          1
     C                   PARM                    FVGIIO
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVMAIL - Validate Mailing Country
      *****************************************************************
 
     C     SrVMAIL       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Mailing Country
 
     C                   CALLB     'SDVMAIL'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** Mailing Address
     C                   PARM                    DDMAIL
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Mailing Address - OK
     C                   PARM                    DDMAILOK          1
     C                   PARM                    FVMAIL
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVPHON - Validate US Phone Number
      *****************************************************************
 
     C     SrVPHON       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate US Phone Number
 
     C                   CALLB     'SDVPHON'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** US Phone Number
     C                   PARM                    DDPHNE
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Phone Number - OK
     C                   PARM                    DDPHONOK          1
     C                   PARM                    FVPHON
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVGRENC - Validate US Green Card
      *****************************************************************
 
     C     SrVGRENC      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate US Green Card
 
     C                   CALLB     'SDVGRENC'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** US Green Card
     C                   PARM                    DDGREC            1
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** US Green Card - OK
     C                   PARM                    DDGRECOK          1
     C                   PARM                    FVGREC
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVHVAC - Validate High Value Account
      *****************************************************************
 
     C     SrVHVAC       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate High Value Account
 
     C                   CALLB     'SDVHVAC'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ***Action*Code***************************************************            MD035388 MD042697
     C**********         PARM                    DDACTI                            MD035388 MD042697
      ** Action Code                                                                        MD035388
     C                   PARM                    DDACTI                                     MD035388
                                                                                            MD035388
      ** High Value Account (Original)
     C                   PARM                    P_DDHVAC
 
      ** High Value Account
     C                   PARM                    DDHVAC            1
 
     C                   PARM                    C_DDHVAL                                   MD035388
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
     C                   PARM                    DDHVACOK          1
     C                   PARM                    FVHVAC
 
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVCSTY - Validate FATCA Customer Type
      *****************************************************************
 
     C     SrVCSTY       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate FATCA Customer Type
 
     C                   CALLB     'SDVNHTY'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ***Action*Code***************************************************            MD035388 MD042697
     C**********         PARM                    DDACTI                            MD035388 MD042697
                                                                                            MD035388
      ** FATCA Customer Type
     C                   PARM                    DDNHTP            1
 
      ** FATCA Customer Type Description
     C                   PARM                    DDNHTD
 
     C**********         PARM                    P_DDNHTP                          MD035388 MD042697
                                                                                            MD035388
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** FATCA Customer Type - OK
     C                   PARM                    DDNHT1OK          1
     C                   PARM                    FVNHTY
 
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVCSST - Validate FATCA Customer Sub type
      *****************************************************************
 
     C     SrVCSST       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate FATCA Customer Sub type
 
     C                   CALLB     'SDVNHST'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ***Action*Code***************************************************            MD035388 MD042697
     C**********         PARM                    DDACTI                            MD035388 MD042697
                                                                                            MD035388
      ** FATCA Customer Sub type
     C                   PARM                    DDNHST            2
     C                   PARM                    DDNHTP            1
     C                   PARM                    DDNHSD
 
     C**********         PARM                    P_DDNHST                          MD035388 MD042697
                                                                                            MD035388
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** FATCA Customer Sub type - OK
     C                   PARM                    DDNHSTOK          1
     C                   PARM                    FVNHST
 
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVSRPT - Validate Subject to Reporting Flag
      *****************************************************************
 
     C     SrVSRPT       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Subject to Reporting Flag
 
     C                   CALLB     'SDVSRPT'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** Subject to Reporting Flag
     C                   PARM                    DDREPT            1
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Subject to Reporting Flag - OK
     C                   PARM                    DDREPTOK          1
     C                   PARM                    FVREPT
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVFTIC - Validate FATCA Information Complete
      *****************************************************************
 
     C     SrVFTIC       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate FATCA Information Complete
 
     C                   CALLB     'SDVFTIC'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
     C                   PARM                    DDINFC
     C                   PARM                    P_DDINFC
     C                   PARM                    DDGREC
     C                   PARM                    DDMAIL
     C                   PARM                    DDPHNE
     C                   PARM                    DDCLAC
     C                   PARM                    DDNHTP
     C                   PARM                    DDNHST
     C                   PARM                    DDCISV
     C                   PARM                    DDCIOV
     C                   PARM                    DDTXSV
     C                   PARM                    DDTXOV
     C                   PARM                    DDCDSV
     C                   PARM                    DDCDOV
     C                   PARM                    DDTESV
     C                   PARM                    DDTEOV
     C                   PARM                    DDGCSV
     C                   PARM                    DDGCOV
     C                   PARM                    DDCBSV
     C                   PARM                    DDCBOV
     C                   PARM                    DDJASV
     C                   PARM                    DDJAOV
     C                   PARM                    DDHMSV
     C                   PARM                    DDHMOV
     C                   PARM                    DDRPSV
     C                   PARM                    DDRPOV
     C                   PARM                    DDIDSV
     C                   PARM                    DDIDOV
     C                   PARM                    DDMCSV
     C                   PARM                    DDMCOV
     C                   PARM                    DDEXEM
     C                   PARM                    DDHVAC
     C                   PARM                    DDUTIN
     C**********         PARM      NABTHC        DDCBTH                                     MD026693
     C**********         PARM      NABTHC        DDDBTH                           MD026693 MD026693A
     C                   PARM      NADBTH        DDDBTH                                    MD026693A
     C                   PARM      NABTHT        DDBTHT
     C                   PARM                    DDREPT
     C                   PARM                    DDRPTT
     C                   PARM                    NAHCUS
     C                   PARM                    P_CRDT                                     MD026550
     C                   PARM      BJDFIN        Format            1                        MD026550
     C                   PARM      *BLANKS       PCUST                                      MD026887
     C                   PARM                    WWCOLC                                     MD026693
     C                   PARM                    PPTIN1                                     MD026693
     C                   PARM                    PPTNC2                                     MD026693
     C                   PARM                    PPTIN2                                     MD026693
     C                   PARM                    PPTNC3                                     MD026693
     C                   PARM                    PPTIN3                                     MD026693
     C                   PARM                    PPTNC4                                     MD026693
     C                   PARM                    PPTIN4                                     MD026693
     C                   PARM                    PPTNC5                                     MD026693
     C                   PARM                    PPTIN5                                     MD026693
     C                   PARM                    DDAUSV                                     MD027560
     C**********         PARM      *BLANKS       PCUST                             MD027140 MD042697
     C                   PARM                    PHasIndicia       1                        MD042697
     C                   PARM      'N'           POrigin           1                        MD042697
     C                   PARM                    TranInCRDD                                 MD052465
 
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
 
      ** FATCA Information Complete - OK
     C                   PARM                    DDINFCOK          1
     C                   PARM                    FVINFC            1
     C                   PARM                    PIsNew                                     MD027454
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrVEXCP - Process Exception of Customer
      *****************************************************************
 
     C     SrVEXCP       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Process Exception of Customer
 
 
      ** INPUTS
 
      ** Return Code
 
      ** Warning fields/message IDs/message data (arrays)
      ** from/to caller
 
     C                   CALLB     'SDVNXCP'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
     C                   PARM                    ValidFATCA
     C                   PARM                    NwNaFilFmt
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN                                     MD026997
     C                   PARM                    PHasIndicia                                MD036356
     C                   PARM                    CurCrshDets                                MD035388
     C                   PARM                    PCrsdS                                     MD035388
     C                   PARM                    ValidCusD                                  MD035388
     C                   PARM                    PFeature                                   MD035388
 
      ** Warning fields/message IDs/message data (arrays)
      ** from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    FVEXMA
     C                   PARM                    FVEXID
     C**********         PARM                    BJDFIN                            MD025163 MD042697
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************                     MD036356
     C/EJECT                                                                                MD036356
      *****************************************************************                     MD036356
      * SrChkIndicia - Check Indicia for the customer                                       MD036356
      *****************************************************************                     MD036356
                                                                                            MD036356
     C     SrChkIndicia  BEGSR                                                              MD036356
                                                                                            MD036356
     C                   CALLB     'SDVNINDI'                                               MD036356
     C                   PARM                    RetCodeOut                                 MD036356
                                                                                            MD036356
     C                   PARM                    NwNaFilFmt                                 MD036356
     C                   PARM                    CrFaScnFmt                                 MD036356
      ** Insert Flag                                                                        MD036460
     C                   PARM                    PAINSF                                     MD036460
                                                                                            MD036356
      ** Output - Indicia Flag                                                              MD036356
     C                   PARM                    PHasIndicia                                MD036356
                                                                                            MD036356
     C                   ENDSR                                                              MD036356
                                                                                            MD036356
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
     C                   PARM                    CrFoScnFmt
     C                   PARM                    NwNaFilFmt
     C                   PARM                    P_CRDT            8                        MD026550
     C                   PARM                    WCLAFlag          1                        MD027561
     C                   PARM                    PAINSF                                     MD042697
     C                   PARM                    CurCrshDets                                MD035388
     C                   PARM                    TranInCRDD                                 MD052465
 
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
 
      ** Check FATCA Effective Date system value                                            MD027454
     C                   CALL      'AOSVALR0'                                               MD027454
     C                   PARM      *BLANKS       PRetCode                                   MD027454
     C                   PARM      SYSVAL1       POP01                                      MD027454
     C                   PARM      *BLANKS       PVL01                                      MD027454
     C                   PARM                    POP02                                      MD027454
     C                   PARM                    PVL02                                      MD027454
     C                   PARM                    POP02                                      MD027454
     C                   PARM                    PVL02                                      MD027454
     C                   PARM                    POP02                                      MD027454
     C                   PARM                    PVL02                                      MD027454
     C                   PARM                    POP02                                      MD027454
     C                   PARM                    PVL02                                      MD027454
     C                   PARM                    POP02                                      MD027454
     C                   PARM                    PVL02                                      MD027454
     C                   PARM                    POP02                                      MD027454
     C                   PARM                    PVL02                                      MD027454
     C                   PARM                    POP02                                      MD027454
     C                   PARM                    PVL02                                      MD027454
     C                   PARM                    POP02                                      MD027454
     C                   PARM                    PVL02                                      MD027454
     C                   PARM                    POP02                                      MD027454
     C                   PARM                    PVL02                                      MD027454
                                                                                            MD027454
     C     PRetCode      IFNE      *BLANKS                                                  MD027454
     C                   EVAL      DBKEY = SYSVAL1                                          MD027454
     C                   EVAL      DBFILE = 'SDSVALPD'                                      MD027454
     C                   EVAL      DBASE = 002                                              MD027454
     C                   EXSR      *PSSR                                                    MD027454
     C                   ENDIF                                                              MD027454
                                                                                            MD027454
     C                   IF        PVL01  <> *BLANKS                                        MD027454
     C                   MOVEL     PVL01         WNEffDate                                  MD027454
                                                                                            MD027454
     C                   CALL      'ZDATE1'                             90                  MD027454
     C                   PARM                    PRtCd                                      MD027454
     C                   PARM                    WNEffDate                                  MD027454
     C                   PARM      BJDFIN        PDateFormat                                MD027454
     C                   PARM      *ZERO         WEffDate                                   MD027454
     C                   ENDIF                                                              MD027454
                                                                                            MD027454
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
 
     C                   MOVEL     'SDFTNH5VL'   DBPGM
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
      ** OV1 and OV2 added due to MD027454                                                  MD027454
**  CPY@
(c) Finastra International Limited 2013
** ##OV1
OVRDBF FILE(SDFTNHL1) TOFILE(SDFTNHL1) SHARE(*NO)
** ##OV2
DLTOVR FILE(SDFTNHL1)
