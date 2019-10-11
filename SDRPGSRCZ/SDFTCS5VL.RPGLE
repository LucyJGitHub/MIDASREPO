     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD FATCA Customer Details 5 Validation')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module.                             *
      *                                                               *
      *  SDFTCS5VL - FATCA Customer Details 5 Validation              *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD040876           Date 13Sep16               *
      *                 CGL177             Date 11Jan16               *
      *                 MD036375           Date 02Nov15               *
      *                 MD036356           Date 02Nov15               *
      *                 MD035388           Date 20Oct15               *
      *                 CGL157             Date 17Aug15               *
      *                 MD046248           Date 27Oct17               *
      *                 MD045238           Date 24Apr17               *
      *                 MD042966           Date 20Dec16               *
      *                 MD042794           Date 21Nov16               *
      *                 MD042692           Date 20Dec16               *
      *                 MD036380           Date 03Nov15               *
      *                 MD036375           Date 02Nov15               *
      *                 MD036356           Date 02Nov15               *
      *                 MD030153           Date 03Sep14               *
      *                 MD029837A          Date 22Aug14               *
      *                 MD029805           Date 05Sep14               *
      *                 MD029837           Date 22Aug14               *
      *                 MD027458           Date 04Aug14               *
      *                 MD027760           Date 24Jun14               *
      *                 MD027252           Date 04Aug14               *
      *                 MD027561           Date 03Jul14               *
      *                 MD027560           Date 19Jun14               *
      *                 MD026997           Date 29May14               *
      *                 MD026790A          Date 29May14               *
      *                 MD026835A          Date 22May14               *
      *                 MD026693           Date 22May14               *
      *                 MD026554           Date 22May14               *
      *                 MD027010B          Date 22May14               *
      *                 MD026550           Date 22May14               *
      *                 MD027010           Date 22May14               *
      *                 MD027064           Date 22May14               *
      *                 MD026507A          Date 12May14               *
      *                 MD026497           Date 27Apr14               *
      *                 CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD040876 - CRS MQ (Recompile)                                *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD036375 - Exception 3 is displayed even TIN details are comp*
      *  MD036356 - Multiple NAHO FATCA fields does not default values*
      *            from Main NAHO/CRS Details                         *
      *  MD033588 - FATCA Screen order rework                         *
      *  CGL157 - CRS Reporting                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD045238 - Authority Holder is not recognized as Controlling *
      *             Person                                            *
      *  MD042966 - FATCA US Indicia are not updated upon             *
      *             complete                                          *
      *  MD042692 - Serious midas error occurred after pressing       *
      *             complete during customer insert                   *
      *  MD042794 - Customer with complete FATCA information cannot   *
      *             be inserted due to blocking error                 *
      *  MD036380 - FATCA Information Complete Flag cannot be set     *
      *             to yes even if all TIN details are defined        *
      *  MD036375 - Exception 3 is displayed even TIN details are comp*
      *  MD036356 - Multiple NAHO FATCA fields does not default values*
      *            from Main NAHO/CRS Details                         *
      *  MD030153 - OCBC FATCA - cannot set FATCA complete to Y       *
      *             during creation of new customer                   *
      *             Apply fix MD027454                                *
      *  MD029837A - OCBC FATCA - cannot set FATCA complete to "Y"    *
      *              during creation of new customer                  *
      *  MD029805 - GIIN number validation                            *
      *  MD029837 - OCBC FATCA - cannot set FATCA complete to "Y"     *
      *             during creation of new customer                   *
      *           - Apply fix MD027454                                *
      *  MD027458 - FATCA Exempt? flag should not be amendable to     *
      *             blank                                             *
      *  MD027760 - Multiple Amendments of Override Value do not      *
      *             recognize correct Override Username               *
      *           - Applied fix MD028332                              *
      *  MD027252 - Error Message is displayed when FATCA Customer    *
      *             Type (F or N) is amended to blank                 *
      *  MD027561 - FATCA Classification Date is not updated to date  *
      *             when FATCA Classification was changed             *
      *  MD027560 - Authority Holder Indicia Not Included as valida-  *
      *             tion to FATCA Info Complete Flag                  *
      *  MD026997 - Assume 0 If Creation Date Input is Blank          *
      *  MD026790A - FATCA Exceptions not validated and displayed     *
      *              as expected.                                     *
      *  MD026835A - Override user and override time are wrong        *
      *  MD026693 - FATCA Info complete flag error                    *
      *  MD026554 - Incorrect Error message and Missing Error Message *
      *             when FATCA Customer Type is J                     *
      *           - Apply fix MD025225                                *
      *  MD027010B - FATCA Exempt and Reporting type is incorrect     *
      *  MD026550 - Require US TIN when Subject to Reporting is 'Y'   *
      *             for all new FATCA Customers/Non-Account Holders   *
      *  MD027010 - FATCA Exempt and Reporting type is incorrect      *
      *  MD027064 - System do not recognize input in field            *
      *             "Date of Birth" when FATCAUsTinBirthRqd Sysval is *
      *             "B" or "Y"                                        *
      *  MD026507A - FATCA reporting type date/time details is not    *
      *              updated                                          *
      *  MD026497 - Inappropriate Exception Message appears upon      *
      *             Customer/Non-Account Holder Insert                *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Customer FATCA Info Retrieval Index                                                MD027454
     F***SDFTCSL1  IF   E           K DISK    INFSR(*PSSR)                         MD027454 MD042692
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
 
      ** Additional Customer Details Screen Format                                          MD036375
     D CrTrnScFmt    E DS                  EXTNAME(SDACUDPD)                                MD036375
     D                                     PREFIX(C_)                                       MD036375
                                                                                            MD036375
      ** FATCA Customer Details in screen format
     D CrFaScnFmt    E DS                  EXTNAME(SDFTCRPD)
 
      ** FATCA Customer Details in screen format (Previous)
     D PrFaScnFmt    E DS                  EXTNAME(SDFTCRPD)
     D                                     PREFIX(P_)
 
      ** Additional Customer details
     D CrCuScnFmt    E DS                  EXTNAME (SDCUADPD)
     D                                     PREFIX(AD)
      ** (Current) Customer Authority Holder details in file Format                         MD045238
     D ValidCUAH     E DS                  EXTNAME(SDVCUAHPD)                               MD045238
     D                                     PREFIX(V_)                                       MD045238
     D V_CUAHArr       S                   DIM(50) LIKE(ValidCUAH)                          MD045238
 
     D CrFoScnFmt      DS                                                                   MD036375
     D  WCDESC1                1     50                                                     MD036375
     D  WPDESC1               51    100                                                     MD036375
     D  DDBRTH               101    105                                                     MD036375
     D  DDCBTH               106    107                                                     MD036375
     D  DDBTHT               108    142                                                     MD036375
     D  DDCNCZ               143    144                                                     MD036375
     D  DDCDOM               145    146                                                     MD036375
     D  DDACCZ               147    148                                                     MD036375
     D  DDUTNN               149    173                                                     MD036375
 
      ** FATCA Customer Details OK indicators
     D OKFATCAdet    E DS                  EXTNAME(SDEFTCSPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D ZMUSER          DS            17
     D  WUSRID                 1     10                                                    MD026835A
     D  USRBCH                11     13
 
     D ValidFATCA    E DS                  EXTNAME(SDVFTCSPD)
      ** Valid Customer Details layout
 
      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      * Ext Customer in File Format                                                         MD026497
     D NwXcFilFmt    E DS                  EXTNAME(SDVCUXCPD)                               MD026497
                                                                                            MD026497
      ** Override Database Table                                                            MD027454
     D ##OV1           S             50    DIM(1) CTDATA PERRCD(1)                          MD027454
     D ##OV2           S             50    DIM(1) CTDATA PERRCD(1)                          MD027454
                                                                                            MD027454
      ** CRS Transaction Details in screen format                                             CGL157
     D CurCrsdDets   E DS                  EXTNAME(SDCRSSPD)                                  CGL157
     D                                     PREFIX(C_)                                         CGL157
                                                                                              CGL157
      ** External DS for CRS Details                                                          CGL157
     D ValidCusD     E DS                  EXTNAME(SDVCRSDPD)                                 CGL157
     D PAPARM          DS           100                                                     MD036356
     D  PAMODE                 1      1                                                     MD036356
     D  PADOMC                 2      3                                                     MD036356
     D  PACNCZ                 4      5                                                     MD036356
     D  PACSSN                 6     15                                                     MD036356
     D  PACRNM                16     35                                                     MD036356
     D  PACRTN                36     45                                                     MD036356
     D  PAACCZ                46     47                                                     MD036356
     D  PAINSF                48     48                                                     MD036356
                                                                                            MD036356
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
     DSYSVAL1          C                    'FATCAEffectStartDate'                          MD027454
                                                                                            MD027454
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D WRunDay         S                   LIKE(BJRDNB)
     D DDRPOVO         S              1A
     D DDIDOVO         S              1A
     D DDMCOVO         S              1A
     D FVNFRD          S              5P 0
     D DDINFCO         S              1A
     D ALLCUS          S              1A   INZ('C')
     D***DDBTHT          S             35A                                                  MD036375
     D DDDBTH          S              8A
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
     D PIsNew          S              1A   INZ('N')                                         MD027454
     D PDateFormat     S              1A                                                    MD027454
     D WEffDate        S              5P 0                                                  MD027454
     D WNEffDate       S              6P 0                                                  MD027454
     D WMsgLen         S             15P 5 INZ(50)                                          MD027454
     D DDBBTH          S              6A                                                    MD036380
     D PHasIndicia     S              1A   INZ('N')                                         MD042692
     D POrigin         S              1A                                                    MD042692
 
      ** Parameters for AOSVAL                                                              MD027454
     D PRetCode        S             20A   INZ(*BLANKS)                                     MD027454
     D POP01           S             20A   INZ(*BLANKS)                                     MD027454
     D PVL01           S            200A   INZ(*BLANKS)                                     MD027454
     D POP02           S             20A   INZ(*BLANKS)                                     MD027454
     D PVL02           S            200A   INZ(*BLANKS)                                     MD027454
                                                                                              CGL157
     D PFeature        S              3A   INZ('FTC')                                         CGL157
     D PCrsdS          S            351A   DIM(30)                                            CGL177
                                                                                            MD036375
     D PBirthDetails   DS                                                                   MD036375
     D  BirthDate              1      8                                                     MD036375
     D  BirthCtry              9     10                                                     MD036375
     D  BirthTown             11     45                                                     MD036375
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
 
     C**********         CALL      'QCMDEXC'                                       MD027454 MD042692
     C**********         PARM                    ##OV1                             MD027454 MD042692
     C**********         PARM                    WMsgLen                           MD027454 MD042692
                                                                                            MD027454
      ** Check if the Customer is being inserted and                                        MD027454
      ** after Effective Date                                                               MD027454
     C                   EVAL      PIsNew = 'N'                                             MD027454
     C*****DDCUST        CHAIN(N)  SDFTCSL1                                        MD027454 MD042692
     C**********         IF        NOT %FOUND(SDFTCSL1)                            MD027454 MD042692
     C**********         IF        DDACTI = 'I'                                   MD027454 MD029837A
     C**********         IF        DDACTI = ' '                                   MD029837A MD042692
     C**********                   AND WRunDay >= WEffDate                         MD027454 MD042692
     C                   IF        ADDDACTN = 'I'                                           MD042692
     C                   EVAL      PIsNew = 'Y'                                             MD027454
     C                   ENDIF                                                              MD027454
     C**********         ENDIF                                                     MD027454 MD042692
                                                                                            MD027454
     C**********         IN        ZMUSER                                         MD027010B MD042692
      ** Check whether user is a web browser user, if so overwrite                          MD042692
     C                   CALL      'SFC000026'                                              MD042692
     C                   PARM      *BLANKS       USER             10                        MD042692
      *                                                                                     MD042692
     C                   IF        USER <> *BLANKS                                          MD042692
     C                   EVAL      PSUSER = USER                                            MD042692
     C                   ENDIF                                                              MD042692
     C**********         EVAL      DDUSID = PSUSER                                          MD042692
     C                   IF        DDCSSD <> *BLANKS                                        MD027010
     C                   EVAL      DDUSID = DDCSSD                                          MD027010
     C                   ENDIF                                                              MD027010
                                                                                            MD027561
     C                   MOVEL     DDCSTD        WCLAFlag                                   MD027561
     C                   EVAL      PHasIndicia = 'N'                                        MD042692
                                                                                            MD042692
      ** Check Customer Indicia                                                             MD042692
     C                   EXSR      SrChkIndicia                                             MD042692
                                                                                            MD042692
 
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
     C                   IF        Idx = 0
     C                   EVAL      FVCUST = DDCUST
     C**********         EVAL      FVHMSV = P_DDHMSV                                          CGL177
     C**********         EVAL      FVMCSV = P_DDMCSV                                          CGL177
     C**********         EVAL      FVRPSV = P_DDRPSV                                          CGL177
     C**********         EVAL      FVCISV = P_DDCISV                                          CGL177
     C**********         EVAL      FVCBSV = P_DDCBSV                                          CGL177
     C**********         EVAL      FVCDSV = P_DDCDSV                                          CGL177
     C**********         EVAL      FVGCSV = P_DDGCSV                                          CGL177
     C**********         EVAL      FVIDSV = P_DDIDSV                                          CGL177
     C**********         EVAL      FVJASV = P_DDJASV                                          CGL177
     C**********         EVAL      FVTESV = P_DDTESV                                          CGL177
     C**********         EVAL      FVTXSV = P_DDTXSV                                          CGL177
     C                   EVAL      FVGIIN = DDGIIN
     C                   EVAL      FVUTIN = DDUTIN
     C**********         IF        FVLUSR = *BLANKS                               MD026835A MD028332
     C                   EVAL      FVLUSR = DDCSSD                                         MD026835A
     C**********         ENDIF                                                    MD026835A MD028332
     C                   IF        DDCSSD = *BLANKS                                        MD026835A
     C                   EVAL      DDCSSD = WUSRID                                         MD026835A
     C                   ENDIF                                                             MD026835A
     C                   EXSR      SrVEXCP
     C                   EVAL      DDEXID = FVEXID                                         MD026790A
     C                   EVAL      DDEXMA = FVEXMA                                         MD026790A
     C                   ENDIF
 
     C**********         CALL      'QCMDEXC'                                       MD027454 MD042692
     C**********         PARM                    ##OV2                             MD027454 MD042692
     C**********         PARM                    WMsgLen                           MD027454 MD042692
                                                                                            MD027454
     C                   RETURN
 
      *****************************************************************
     C/EJECT
      *****************************************************************                     MD042692
      * SrChkIndicia - Check Indicia for the customer                                       MD042692
      *****************************************************************                     MD042692
                                                                                            MD042692
     C     SrChkIndicia  BEGSR                                                              MD042692
                                                                                            MD042692
     C                   CALLB     'SDVINDI'                                                MD042692
     C                   PARM                    RetCodeOut                                 MD042692
                                                                                            MD042692
     C**********         PARM                    CrTrnScFmt                        MD042692 MD042966
     C                   PARM                    CrCuScnFmt                                 MD042966
     C                   PARM                    CrFaScnFmt                                 MD042692
     C                   PARM                    PAPARM                                     MD042692
                                                                                            MD042692
      ** Output - Indicia Flag                                                              MD042692
     C                   PARM                    PHasIndicia                                MD042692
                                                                                            MD042692
     C                   ENDSR                                                              MD042692
                                                                                            MD042692
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
     C                   PARM                    WWCLDS           50
     C                   PARM                    WWPFCE           50
     C                   PARM                    WCLAFlag          1                        MD027561
     C                                                                                      MD027561
     C                   IF        WCLAFlag = 'Y'                                           MD027561
     C                   EVAL      DDCSTD = 'Y'                                             MD027561
     C                   ENDIF                                                              MD027561
 
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
     C                   PARM                    DDCUST            6                        MD027458
     C                   PARM      *BLANKS       DDNAHL           10                        MD027458
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
     C**********         PARM                    DDRPTT                                    MD026507A
     C                   PARM                    DDRPTM            8                       MD026507A
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
     C                   PARM                    DDCSTP            1                        MD029805
     C                   PARM                    DDCSST            2                        MD029805
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
     C                   PARM                    DDCSST            2
     C                   PARM                    DDCSSTOK          1
 
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
     C                   PARM                    DDPHON            1
 
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
 
     C                   CALLB     'SDVCSTY'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** Action Code                                                                        MD035388
     C                   PARM                    DDACTI                                     MD035388
                                                                                            MD035388
      ** FATCA Customer Type
     C                   PARM                    DDCSTP            1
 
      ** FATCA Customer Type Description
     C                   PARM                    DDCSTD
 
     C                   PARM                    P_DDCSTP                                   MD035388
     C                   PARM                    C_DDTYPE                                   MD035388
                                                                                            MD035388
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** FATCA Customer Type - OK
     C                   PARM                    DDCST1OK          1
     C                   PARM                    FVCSTY
 
 
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
 
     C                   CALLB     'SDVCSST'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** FATCA Customer Sub type
     C                   PARM                    DDACTI                                     MD035388
     C                   PARM                    DDCSST            2
     C                   PARM                    DDCSTP            1
     C                   PARM                    DDCSSD
                                                                                            MD027252
      ** FATCA Customer Sub type (Previous)                                                 MD027252
     C                   PARM                    P_DDCSTP                                   MD027252
     C                   PARM                    P_DDCSST                                   MD035388
     C                   PARM                    C_DDSTYP                                   MD035388

 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** FATCA Customer Sub type - OK
     C                   PARM                    DDCSSTOK          1
     C                   PARM                    FVCSST
 
 
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
 
     C                   EVAL      DDBTHT = C_DDBTHT                                        MD036380
     C                   EVAL      DDCBTH = C_DDBTHC                                        MD036380
     C                   EVAL      DDBBTH = C_DDDBTH                                        MD036380
 
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
     C                   PARM                    DDPHON
     C                   PARM                    DDCLAC
     C                   PARM                    DDCSTP
     C                   PARM                    DDCSST
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
     C**********         PARM      ADDDDBTH      DDDBTH                                     MD027064
     C                   PARM      ADDDBRTH      DDDBTH                                     MD027064
     C                   PARM      ADDDBTHT      DDBTHT
     C**********         PARM                    DDBBTH                            MD036380 MD042794
     C                   PARM                    DDREPT
     C                   PARM                    DDRPTT
     C                   PARM                    ALLCUS
     C                   PARM                    P_CRDT                                     MD026550
     C                   PARM      BJDFIN        Format            1                        MD026550
     C                   PARM                    DDCUST                                     MD026554
     C                   PARM                    WWCOLC                                     MD026693
     C                   PARM      ADDDTINO      PPTIN1                                     MD026693
     C                   PARM      ADDDTNC2      PPTNC2                                     MD026693
     C                   PARM      ADDDTIN2      PPTIN2                                     MD026693
     C                   PARM      ADDDTNC3      PPTNC3                                     MD026693
     C                   PARM      ADDDTIN3      PPTIN3                                     MD026693
     C                   PARM      ADDDTNC4      PPTNC4                                     MD026693
     C                   PARM      ADDDTIN4      PPTIN4                                     MD026693
     C                   PARM      ADDDTNC5      PPTNC5                                     MD026693
     C                   PARM      ADDDTIN5      PPTIN5                                     MD026693
     C                   PARM                    DDAUSV                                     MD027560
     C**********         PARM                    DDCUST                            MD027140 MD042692
     C                   PARM                    PHasIndicia                                MD042692
     C                   PARM      'C'           POrigin                                    MD042692
 
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
 
     C                   EVAL      BirthDate = C_DDDBTH                                     MD036375
     C                   EVAL      BirthTown = C_DDBTHT                                     MD036375
     C                   EVAL      BirthCtry = C_DDBTHC                                     MD036375
 
      ** Process Exception of Customer
 
     C                   CALLB     'SDVEXCP'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
     C                   PARM                    ValidFATCA
     C                   PARM                    NwXcFilFmt                                 MD026497
     C                   PARM                    BJRDNB
     C                   PARM      ADDDACTN      P_ACTN            1                       MD026790A
     C                   PARM                    BJDFIN                                     MD026997
     C                   PARM                    PHasIndicia                                MD042692
     C                   PARM                    V_CUAHArr                                  MD045238
     C                   PARM                    CurCrsdDets                                MD035388
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
     C                   PARM                    DDUTIN                                     MD027064
     C                   PARM      ADDDBRTH      DDDBTH                                     MD027064
     C                   PARM      ADDDBTHT      DDBTHT                                     MD027064
     C                   PARM      ADDDBTHC      DDBTHC            2                        MD027064
 
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
     C                   PARM                    CrCuScnFmt
     C                   PARM                    P_CRDT            8                        MD026550
     C                   PARM                    WWCOLC                                     MD026693
     C                   PARM                    NwXcFilFmt                                 MD026497
     C                   PARM                    PAPARM                                     MD036356
     C                   PARM                    V_CUAHArr                                  MD045238
     C                   PARM                    CurCrsdDets                                MD035388
 
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
                                                                                           MD026835A
      ** Retrieve ZMUSER details.                                                          MD026835A
     C******DTAARA       DEFINE                  ZMUSER                           MD026835A MD042692
 
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
 
     C                   MOVEL     'SDFTCS5VL'   DBPGM
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
OVRDBF FILE(SDFTCSL1) TOFILE(SDFTCSL1) SHARE(*NO)
** ##OV2
DLTOVR FILE(SDFTCSL1)
