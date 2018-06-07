     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Exception')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVEXCP - Validate Exception of Customer                     *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD050572           Date 03May18               *
      *  Prev Amend No. MD040734           Date 23Aug16               *
      *                 CGL177             Date 11Jan16               *
      *                 MD036459           Date 06Nov15               *
      *                 MD036375           Date 02Nov15               *
      *                 MD036369           Date 29Oct15               *
      *                 MD035388           Date 20Oct15               *
      *                 CGL157             Date 17Aug15               *
      *                 MD046248           Date 27Oct17               *
      *                 MD045238           Date 24Apr17               *
      *                 MD044164           Date 20Feb17               *
      *                 MD042692           Date 20Dec16               *
      *                 CGL154             Date 13Oct14               *
      *                 MD036371           Date 29Oct15               *
      *                 MD036459           Date 06Nov15               *
      *                 MD034071           Date 10Apr15               *
      *                 MD033660           Date 16Mar15               *
      *                 MD033414           Date 28Feb15               *
      *                 MD029839           Date 01Sep14               *
      *                 MD026997           Date 29May14               *
      *                 MD026790A          Date 29May14               *
      *                 MD027064           Date 22May14               *
      *                 MD027076           Date 22May14               *
      *                 MD026497           Date 27Apr14               *
      *                 MD026692           Date 09May13               *
      *                 CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050572 - Exception 14 and 15 is not being displayed /      *
      *             triggered                                         *
      *  MD040734 - CRS Exception other than Due Diligence is still   *
      *             displayed                                         *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD036459 - Exception 1 on insert                             *
      *  MD036375 - Exception 3 is displayed even TIN details are comp*
      *  MD036369 - Duplicate 8 and 9 for FATCA if triggered in CRS   *
      *  MD035388 - FATCA Screen order rework                         *
      *  CGL157 - CRS Reporting                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD045238 - Authority Holder is not recognized as Controlling *
      *             Person                                            *
      *  MD044164 - FATCA Exception 3 still present even if Customer  *
      *             Details comply w/ System Value FATCAUSTINBrthRqd  *
      *  MD042692 - Serious midas error occurred after pressing       *
      *             complete during customer insert                   *
      *  CGL154 - FATCA Reporting (Recompile)                         *
      *  MD036371 - 2 not triggered when new customer has indicia     *
      *  MD036459 - Exception 1 on insert                             *
      *  MD034071 - Exception 10 not triggered properly               *
      *  MD033660 - Include FAINFC = 'A' on Due Diligence Check       *
      *  MD033414 - CGL154 amended exceptions is missing. Apply fix   *
      *             MD0251212 and MD025163                            *
      *  MD025121 - Warning Message Occured when FATCA Classification *
      *             Date defaults by the System Date and do not reach *
      *             expiry date yet                                   *
      *  MD025163 - Exception for Customer/Non-Account holder does    *
      *             not recognize US TIN when subject to reporting is *
      *             set to Y                                          *
      *  MD029839 - OCBC FATCA - SD000554P1 - "The customer is subject*
      *             to reporting but no US tax number is defined."    *
      *             Applied Fix MD027148                              *
      *  MD026997 - Only check US TIN if subject to reporting is 'Y'  *
      *             for Customers/Non-Account Holders created after   *
      *             FATCA Effective Date                              *
      *  MD026790A - Skip Joint Account-related exceptions on Insert  *
      *  MD027064 - System do not recognize input in field            *
      *             "Date of Birth" when FATCAUsTinBirthRqd Sysval is *
      *             "B" or "Y"                                        *
      *  MD027076 - Unable to amend Dormant and Alt Country of        *
      *             Citizenship.                                      *
      *  MD026497 - Inappropriate Exception Message appears upon      *
      *             Customer/Non-Account Holder Insert                *
      *  MD026692 - Exception message when Customer type is set to    *
      *             F or N with unknown subtype is not appearing      *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
 
     FSDFTCSL1  IF   E           K DISK
     F                                     RENAME(SDFTCSD0:SDFTCSD1)
     F                                     PREFIX(J)
 
     FSDFTNHL1  IF   E           K DISK
     F                                     RENAME(SDFTNHD0:SDFTNHD1)
     F                                     PREFIX(J)
 
     FSDCUSXL1  IF   E           K DISK
 
     FSDJACCL0  IF   E           K DISK
 
     FSDJACCL4  IF   E           K DISK
     F                                     RENAME(SDJACCD0:SDJACCD4)
 
     FSDJACCL7  IF   E           K DISK
     F                                     RENAME(SDJACCD0:SDJACCD7)
 
     FSDNAHOL0  IF   E           K DISK
 
     FSDACRVL6  IF   E           K DISK
     F                                     RENAME(SDACRVD0:SDACRVD6)
 
     FSDCUAHLA  IF   E           K DISK
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
 
     D/COPY ZACPYSRC,PSDS
 
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
 
     D SDVFTCS       E DS                  EXTNAME(SDVFTCSPD)
      ** Valid Customer Details layout
 
      ** FATCA Customer Classification Code
     D SDFATC        E DS                  EXTNAME(SDFATCPD)
 
      ** Customer Details File
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
 
      ** Non-Account Holders File
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
 
      ** Midas Module Details Data Structure
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
 
      ** External DS for SAR Details                                                        MD033414
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                MD033414
                                                                                            MD033414
      * Ext Customer in File Format                                                         MD026497
     D NwXcFilFmt    E DS                  EXTNAME(SDVCUXCPD)                               MD026497
                                                                                            MD026497
      ** (Current) Customer Authority Holder details in file Format                         MD045238
     D ValidCUAH     E DS                  EXTNAME(SDVCUAHPD)                               MD045238
     D                                     PREFIX(V_)                                       MD045238
                                                                                            MD045238
      ** CRS Valid Customer Details Screen 1                                                  CGL157
     D SDVCRCS1      E DS                  EXTNAME(SDVCRSHPD)                                 CGL157
                                                                                              CGL157
      ** CRS Valid Customer Details Screen 2                                                  CGL157
     D SDVCRCS2      E DS                  EXTNAME(SDVCRSDPD)                                 CGL157
                                                                                              CGL157
      ** Transaction Details in screen format                                                 CGL157
     D CurCrsdDets   E DS                  EXTNAME(SDCRSSPD)                                  CGL157
     D PrvCrsdDets   E DS                  EXTNAME(SDCRSSPD)                                  CGL157
     D                                     PREFIX(P_)                                         CGL157
                                                                                              CGL157
      ** SDCRDDPD CRS Transaction Details in Screen Format                                    CGL157
     D CrsdDet       E DS                  EXTNAME(SDCRDDPD)                                  CGL157
                                                                                              CGL157
      ** External DS for Bank Details                                                         CGL157
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  CGL157
     D                                     PREFIX(L_)                                         CGL157
                                                                                              CGL157
     D CustIndOverDS   DS
     D  JFAHMOV
     D  JFAMCOV
     D  JFARPOV
     D  JFAAUOV
     D  JFACIOV
     D  JFACBOV
     D  JFACDOV
     D  JFAGCOV
     D  JFAIDOV
     D  JFAJAOV
     D  JFATEOV
     D  JFATXOV
 
     D CustIndSValDS   DS
     D  JFAHMSV
     D  JFAMCSV
     D  JFARPSV
     D  JFAAUSV
     D  JFACISV
     D  JFACBSV
     D  JFACDSV
     D  JFAGCSV
     D  JFAIDSV
     D  JFAJASV
     D  JFATESV
     D  JFATXSV
 
      ** Data Structure for Non-Account Holder Indicia
     D NahoIndOverDS   DS
     D  JFNHMOV
     D  JFNMCOV
     D  JFNRPOV
     D  JFNAUOV
     D  JFNCIOV
     D  JFNCBOV
     D  JFNCDOV
     D  JFNGCOV
     D  JFNIDOV
     D  JFNJAOV
     D  JFNTEOV
     D  JFNTXOV
 
     D NahoIndSvalDS   DS
     D  JFNHMSV
     D  JFNMCSV
     D  JFNRPSV
     D  JFNAUSV
     D  JFNCISV
     D  JFNCBSV
     D  JFNCDSV
     D  JFNGCSV
     D  JFNIDSV
     D  JFNJASV
     D  JFNTESV
     D  JFNTXSV
                                                                                              CGL157
     D PCRSDT          DS                                                                     CGL157
     D  DDCTRY                 1      2                                                       CGL157
     D**DDPREP                 3      3                                              CGL157 MD050572
     D**DDREPT                 4      4                                              CGL157 MD050572
     D**DDREPU                 5     14                                              CGL157 MD050572
     D**DDREPD                15     20                                              CGL157 MD050572
     D**DDREPM                21     26                                              CGL157 MD050572
     D**DDREP1                27     90                                              CGL157 MD050572
     D**DDREP2                91    154                                              CGL157 MD050572
     D**DDEVD1               155    156                                              CGL157 MD050572
     D**DDEVS1               157    159                                              CGL157 MD050572
     D**DDEVD2               160    161                                              CGL157 MD050572
     D**DDEVS2               162    164                                              CGL157 MD050572
     D**DDEVD3               165    166                                              CGL157 MD050572
     D**DDEVS3               167    169                                              CGL157 MD050572
     D**DDEVD4               170    171                                              CGL157 MD050572
     D**DDEVS4               172    174                                              CGL157 MD050572
     D**DDEVD5               175    176                                              CGL157 MD050572
     D**DDEVS5               177    179                                              CGL157 MD050572
     D**DDTINN               180    204                                              CGL157 MD050572
     D**DDEFFD               205    210                                              CGL157 MD050572
     D**DDEXPD               211    216                                              CGL157 MD050572
     D**DDCODOC              217    217                                              CGL157 MD050572
     D**DDJACMC              218    218                                              CGL157 MD050572
     D**DDMAILC              219    219                                              CGL157 MD050572
     D**DDPHONC              220    220                                              CGL157 MD050572
     D**DDRPAYC              221    221                                              CGL157 MD050572
     D**DDPEP1               222    285                                              CGL157 MD050572
     D**DDPEP2               286    349                                              CGL157 MD050572
     D**DDCRSA               350    350                                              CGL157 MD050572
     D**DDTINS               351    351                                              CGL177 MD050572
     D  DDREPT                 3      3                                                     MD050572
     D  DDREPU                 4     13                                                     MD050572
     D  DDREPD                14     19                                                     MD050572
     D  DDREPM                20     25                                                     MD050572
     D  DDREP1                26     89                                                     MD050572
     D  DDREP2                90    153                                                     MD050572
     D  DDEVD1               154    155                                                     MD050572
     D  DDEVS1               156    158                                                     MD050572
     D  DDEVD2               159    160                                                     MD050572
     D  DDEVS2               161    163                                                     MD050572
     D  DDEVD3               164    165                                                     MD050572
     D  DDEVS3               166    168                                                     MD050572
     D  DDEVD4               169    170                                                     MD050572
     D  DDEVS4               171    173                                                     MD050572
     D  DDEVD5               174    175                                                     MD050572
     D  DDEVS5               176    178                                                     MD050572
     D  DDTINN               179    203                                                     MD050572
     D  DDEFFD               204    209                                                     MD050572
     D  DDEXPD               210    215                                                     MD050572
     D  DDCODOC              216    216                                                     MD050572
     D  DDJACMC              217    217                                                     MD050572
     D  DDMAILC              218    218                                                     MD050572
     D  DDPHONC              219    219                                                     MD050572
     D  DDRPAYC              220    220                                                     MD050572
     D  DDCRSA               221    221                                                     MD050572
     D  DDTINS               222    222                                                     MD050572
                                                                                            MD036375
     D PBirthDetails   DS                                                                   MD036375
     D  BirthDate              1      8                                                     MD036375
     D  BirthCtry              9     10                                                     MD036375
     D  BirthTown             11     45                                                     MD036375
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     ** Parameters for AOSVALR0
     D POP01           S             20A
     D POP02           S             20A
     D POP03           S             20A
     D POP04           S             20A
     D POP05           S             20A
     D POP06           S             20A
     D POP07           S             20A
     D POP08           S             20A
     D POP09           S             20A
     D POP10           S             20A
     D PVL01           S            200A
     D PVL02           S            200A
     D PVL03           S            200A
     D PVL04           S            200A
     D PVL05           S            200A
     D PVL06           S            200A
     D PVL07           S            200A
     D PVL08           S            200A
     D PVL09           S            200A
     D PVL10           S            200A
 
      ** Access Object Parameters
     D PRTCD           S              7A
     D POPTN           S              7A
     D PPFTC           S              5A
     D PCUST           S              6A
     D PNAHO           S             10A
     D PInDate         S              8A
     D PMDate          S              5  0
     D WFound          S              1A
 
     D WRUND           S              5S 0
     D WBthDate        S              5S 0
     D WBthDateA       S              8A
     D WBthCntry       S              2A
     D WBthTown        S             35A
     D WExpiryDate     S              5S 0
     D WSvalDftClsCde  S              5A
     D WSvalTinBrthRq  S              1A
     D WSvalExpDayDft  S              3S 0
     D WSvalDftClsTkn  S              5A
     D WSvalEffctDate  S              6A                                                    MD026997
     D WSvalEffDayNo   S              5  0                                                  MD026997
     D WHasIndicia     S              1A
     D WFAEXID         S             30A
     D WFNEXID         S             30A
     D WSysOff         S              2S 0
     D WOvrOff         S              2S 0
     D WIndCnt         C                   CONST(12)
     D WArrCnt         S              2S 0
     D WDays           S              3A                                                    MD026497
     D WSvalDlgNewAC   S              2  0                                                  MD033414
     D WSvalDlgMedInd  S              6A                                                    MD033414
     D WSvalDlgHiInd   S              6A                                                    MD033414
     D WSvalDlgMedEnt  S              6A                                                    MD033414
     D WSvalDlgHiEnt   S              6A                                                    MD033414
     D WDlgDt          S              5  0                                                  MD033414
     D WCRSEftStrtDte  S              6A                                                      CGL157
     D WCRSDlgMedInd   S              6A                                                      CGL157
     D WCRSDlgHiInd    S              6A                                                      CGL157
     D WCRSDlgMedEnt   S              6A                                                      CGL157
     D WCRSDlgHiEnt    S              6A                                                      CGL157
     D WCRSDlgNewAC    S              2  0                                                    CGL157
     D WCRSForTINMan   S              1A                                                      CGL157
     D WCRSLocTINMan   S              1A                                                      CGL157
     D*PCrsdS***       S            350A   DIM(30)                                     CGL157 CGL177
     D PCrsdS          S            351A   DIM(30)                                            CGL177
     D X               S              2S 0                                                    CGL157
     D PFeature        S              3A                                                      CGL157
     D PHasIndicia     S              1A                                                    MD035388
     D NCRSDlgMedInd   S              5  0                                                    CGL177
     D NCRSDlgHiInd    S              5  0                                                    CGL177
     D NCRSDlgMedEnt   S              5  0                                                    CGL177
     D NCRSDlgHiEnt    S              5  0                                                    CGL177
     D LowVal1         S              5  0                                                    CGL177
     D LowVal2         S              5  0                                                    CGL177
     D LowestVal       S              5  0                                                    CGL177
      ** ^Flag to determine if FATCA or CRS                                                   CGL157
      ** Define work field Work File Date                                                   MD033414
     D PIDate          S              6A                                                    MD033414
     D PODate          S              5  0                                                  MD033414
     D PSARD           S              6A                                                    MD033414
     D CGL154          S              1A                                                    MD033414
     D WDayMnt         S              4A                                                    MD036375
     D WCCYY           S              4A                                                    MD036375
     D WNCCYY          S              4P 0                                                  MD036375
     D WDay            S              2A                                                    MD036375
     D WMonth          S              2A                                                    MD036375
     D WYear           S              2A                                                    MD036375
                                                                                            MD036375
      ** Parameter for ZDATE1                                                               MD036375
     D DateIn          S              6A                                                    MD036375
     D DaynoOut        S              5P 0                                                  MD036375
     D ErrorFlag       S              1A                                                    MD036375
     D PErrFlag        S              1A                                                    MD025163
     D***PHasIndicia     S              1A                                         MD035388 MD050572
     D WCINT           S              1A                                                    MD045238
     D Idy             S              3P 0 INZ(0)                                           MD045238
     D V_CUAHArr       S                   DIM(50) LIKE(ValidCUAH)                          MD045238
 
      ** Exception Report Flag Array
     D WExcpRptArr     S              1    Dim(30)
 
      ** Index for arrays of error message ids etc
     D WIx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Initialization
 
     C                   MOVE      *BLANK        ReturnCode
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIdXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             WIx
     C                   EVAL      WRUND = BJRDNB
 
      ** Access System Values
 
     C                   EXSR      SRSVAL
 
      ** Access System Values for CRS                                                         CGL157
                                                                                              CGL157
     C                   IF        PFeature = 'CRS'                                           CGL157
                                                                                              CGL157
      ** Do NOT Validate CRS Info Complete flag only if the CRS Customer type is 'F' (FI)     CGL157
      ** and CRS Exempt is equal to 'Y' (Yes)                                                 CGL157
                                                                                              CGL157
     C                   EXSR      SRSVAL2                                                    CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
      ** FATCA Exception Reporting for Customers
     C                   EXSR      SrExcpCust
 
     C                   EVAL      *INLR = *ON
 
      ** RETURN
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrExcpCust - FATCA Exception Reporting for Customers         *
      *                                                               *
      *****************************************************************
     C     SrExcpCust    BEGSR
 
     C                   EVAL      WArrCnt = 0
 
      ** Initialize Array
     C                   EVAL      WFAEXID = *BLANKS
     C                   MOVE      *BLANKS       WExcpRptArr
 
      ** FATCA classification and US indicia are consistent
     C                   IF        PFeature = 'FTC'                                           CGL157
     C                             OR PFeature = 'ALL'                                        CGL157
     C                   EXSR      SrCSClass
     C                   ENDIF                                                                CGL157
 
      ** new Customer or Non-account holder is subject to reporting
      ** but no US tax number is defined
     C                   IF        PFeature = 'FTC'                                           CGL157
     C                             OR PFeature = 'ALL'                                        CGL157
     C                   EXSR      SrCSRepTxN
     C                   ENDIF                                                                CGL157
 
      ** new Customer or non-account holder is subject to reporting
      ** but no US tax number and/or date and place of birth is defined
     C                   IF        PFeature = 'FTC'                                           CGL157
     C                             OR PFeature = 'ALL'                                        CGL157
     C                   EXSR      SrCSRepBrth
     C                   ENDIF                                                                CGL157
 
      ** Expiry days for a new customer or non-acocunt holder has passed
      ** and the classification is still the default value for new
      ** customer or non-account holder
     C                   IF        PFeature = 'FTC'                                           CGL157
     C                             OR PFeature = 'ALL'                                        CGL157
     C                   EXSR      SrCSExpCls
     C                   ENDIF                                                                CGL157
 
      ** FATCA customer type is defined but no FATCA customer subtype
      ** defined
     C                   IF        PFeature = 'FTC'                                           CGL157
     C                             OR PFeature = 'ALL'                                        CGL157
     C                   EXSR      SrCSSubtyp
     C                   ENDIF                                                                CGL157
 
      ** Customer is flagged as a participating FFI but the GIIN number
      ** information is missing
     C                   IF        PFeature = 'FTC'                                           CGL157
     C                             OR PFeature = 'ALL'                                        CGL157
     C                   EXSR      SrCSGIINno
     C                   ENDIF                                                                CGL157
 
      ** Customer is flagged as a participating FFI but the GIIN
      ** verification date is blank
     C                   IF        PFeature = 'FTC'                                           CGL157
     C                             OR PFeature = 'ALL'                                        CGL157
     C                   EXSR      SrCSGIINDt
     C                   ENDIF                                                                CGL157
 
      ** Customer is not exempt and is flagged as 'NFE'/Passive but
      ** ther are no controlling persons defined
     C                   IF        PFeature = 'FTC'                                           CGL157
     C                             OR PFeature = 'CRS'                                        CGL157
     C                             OR PFeature = 'ALL'                                        CGL157
     C                   EXSR      SrCSNFEiry
     C                   ENDIF                                                                CGL157
 
      ** Customer is not exempt and is flagged as 'Joint account'
      ** but there are no joint account members defined
     C                   IF        PFeature = 'FTC'                                           CGL157
     C                             OR PFeature = 'CRS'                                        CGL157
     C                             OR PFeature = 'ALL'                                        CGL157
     C                   EXSR      SrCSJACMbr
     C                   ENDIF                                                                CGL157
 
      ** Customer is not exempt, is flagged as 'joint account' and has
      ** US inidicia identified, but the individual members of the
      ** joint account do not have US indicia
     C                   IF        PFeature = 'FTC'                                           CGL157
     C                             OR PFeature = 'ALL'                                        CGL157
     C                   EXSR      SrCSJntAcct
     C                   ENDIF                                                                CGL157
 
      ** FATCA inoformation is flagged as 'complete' but customer
      ** or non-account holder has still one of the default statuses
     C                   IF        PFeature = 'FTC'                                           CGL157
     C                             OR PFeature = 'ALL'                                        CGL157
     C                   EXSR      SrCSComplt
     C                   ENDIF                                                                CGL157
 
      ** FATCA account review is passed due date
     C                   IF        PFeature = 'FTC'                                           CGL157
     C                             OR PFeature = 'ALL'                                        CGL157
     C                   EXSR      SrCSActRvw
     C                   ENDIF                                                                CGL157
 
      ** Due diligence period is expired but FATCA information                              MD033414
      ** complete flag still set to 'No'                                                    MD033414
                                                                                            MD033414
     C                   IF        CGL154 = 'Y'                                             MD033414
                                                                                            MD033414
     C                   IF        PFeature = 'FTC'                                           CGL157
     C                             OR PFeature = 'ALL'                                        CGL157
     C                   EXSR      SrCSDlgnce                                               MD033414
     C                   ENDIF                                                                CGL157
                                                                                            MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
      ** CRS New Customer or Non-account holder is subject to reporting                       CGL157
      ** but no TIN is defined                                                                CGL157
     C                   IF        PFeature = 'CRS'                                           CGL157
     C                             OR PFeature = 'ALL'                                        CGL157
     C                   EXSR      SrNewSubTIN                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
      ** CRS Existing Customer or Non-account holder is subject to reporting                  CGL157
      ** but no TIN is defined                                                                CGL157
     C                   IF        PFeature = 'CRS'                                           CGL157
     C                             OR PFeature = 'ALL'                                        CGL157
     C                   EXSR      SrExtSubTIN                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
      ** CRS customer type is defined as NFE, but no CRS customer sub-type defined.           CGL157
     C                   IF        PFeature = 'CRS'                                           CGL157
     C                             OR PFeature = 'ALL'                                        CGL157
     C                   EXSR      SrCRSTypeNFE                                               CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
      ** CRS Due Diligence period has expired but the CRS Information Complete Flag           CGL157
      ** is still set to 'No' or 'Blank'                                                      CGL157
     C                   IF        PFeature = 'CRS'                                           CGL157
     C                             OR PFeature = 'ALL'                                        CGL157
     C                   EXSR      SrCRSDueDlg                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
      ** A CRS account review is passed due date                                              CGL177
     C                   IF        PFeature = 'CRS'                                           CGL177
     C                             OR PFeature = 'ALL'                                        CGL177
     C                   EXSR      SrCRSActRv                                                 CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   MOVEA     WExcpRptArr   DFEXID
     C                   EVAL      DFEXMA = 'N'
     C                   IF        DFEXID <> *BLANKS
     C                   EVAL      DFEXMA = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCSClass - FATCA Classification and US indicia              *
      *                                                               *
      *****************************************************************
     C     SrCSClass     BEGSR
 
     C                   EVAL      PPFTC = FVCLAC
 
      ** Check classification code details of the customer
 
     C                   CALL      'AOFATCR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM                    PPFTC
     C     SDFATC        PARM      SDFATC        DSFDY
 
 
      ** US Indicia NOT allowed
     C                   IF        FCUSIA = 'N'
 
      ** Hold Mail
     C                   IF        FVHMSV = 'Y'
     C                             AND FVHMOV <> 'N'
 
      ** Mailing Country
     C                             OR  FVMCSV = 'Y'
     C                             AND FVMCOV <> 'N'
 
      ** Regular Payment Instructions to US
     C                             OR  FVRPSV = 'Y'
     C                             AND FVRPOV <> 'N'
 
      ** US Account Authority Holder
     C                             OR  FVAUSV = 'Y'
     C                             AND FVAUOV <> 'N'
 
      ** US Citizenship
     C                             OR  FVCISV = 'Y'
     C                             AND FVCIOV <> 'N'
 
      ** US Country of Birth
     C                             OR  FVCBSV = 'Y'
     C                             AND FVCBOV <> 'N'
 
      ** US Country of Domicile
     C                             OR  FVCDSV = 'Y'
     C                             AND FVCDOV <> 'N'
 
      ** US Green Card
     C                             OR  FVGCSV = 'Y'
     C                             AND FVGCOV <> 'N'
 
      ** US Identity Document
     C                             OR  FVIDSV = 'Y'
     C                             AND FVIDOV <> 'N'
 
      ** US Joint Account Members
     C                             OR  FVJASV = 'Y'
     C                             AND FVJAOV <> 'N'
 
      ** US Telephone
     C                             OR  FVTESV = 'Y'
     C                             AND FVTEOV <> 'N'
 
      ** US TIN
     C                             OR  FVTXSV = 'Y'
     C                             AND FVTXOV <> 'N'
                                                                                            MD036459
     C                             OR  PHasIndicia = 'Y'                                    MD036459
 
     C                   EVAL      WArrCnt = WArrCnt +1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'A'
 
     C                   EVAL      WIx = WIx + 1
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0430'
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCSRepTxN - Subject to Reporting but no Tax Number          *
      *                                                               *
      *****************************************************************
     C     SrCSRepTxN    BEGSR
 
      ** Convert FATCA Effective Date to run day number                                     MD026997
     C                   EVAL      ZDATEA = WSvalEffctDate                                  MD026997
     C                   EXSR      ZDATE1                                                   MD026997
     C                   EVAL      WSvalEffDayNo = ZDAYNO                                   MD026997
                                                                                            MD026997
      ** Check the US Indicia for Customer                                                  MD033414
                                                                                            MD033414
     C                   IF        CGL154 = 'Y'                                             MD033414
     C     FVCUST        CHAIN     SDFTCSL1                                                 MD033414
     C                   IF        %FOUND(SDFTCSL1)                                         MD033414
     C                   EXSR      SrChkIndCust                                             MD033414
     C                   ENDIF                                                              MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
      ** Obtain from Screen Indicia Instead of File for current status                      MD036371
     C                   EVAL      WHasIndicia = PHasIndicia                                MD036371
                                                                                            MD036371
      ** Customer Subject to reporting but no US Tax defined
 
     C**********         IF        FVREPT = 'Y'                                             MD033414
     C**********                   AND FVUTIN = *BLANKS                                     MD033414
     C**********                   AND XCCRDT >= WSValEffDayNo                     MD026997 MD033414
     C                   IF        (FVREPT = 'Y'                                            MD033414
     C                             AND FVUTIN = *BLANKS                                     MD033414
     C                             AND XCCRDT >= WSValEffDayNo)                             MD033414
     C                             OR (WHasIndicia = 'Y'                                    MD033414
     C                             AND CGL154 = 'Y'                                         MD033414
     C                             AND FVUTIN = *BLANKS                                     MD033414
     C                             AND XCCRDT >= WSValEffDayNo)                             MD033414
     C                   IF        FVCSST <> 'NP' AND                                       MD027148
     C                             FVRPTT <> 'R'                                            MD027148
     C                   EVAL      WArrCnt = WArrCnt +1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'B'
 
     C                   EVAL      WIx = WIx + 1
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0431'
     C                   ENDIF                                                              MD027148
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCSRepBrth - Subject to Reporting but no Date and Place     *
      *                of Birth                                       *
      *                                                               *
      *****************************************************************
     C     SrCSRepBrth   BEGSR
 
      ** Access Additional Customer Details for Date and Place of Birth
 
     C                   EXSR      SRACUS
 
      ** Check the US Indicia for Customer                                                  MD033414
                                                                                            MD033414
     C                   IF        CGL154 = 'Y'                                             MD033414
     C     FVCUST        CHAIN     SDFTCSL1                                                 MD033414
     C                   IF        %FOUND(SDFTCSL1)                                         MD033414
     C                   EXSR      SrChkIndCust                                             MD033414
     C                   ENDIF                                                              MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
      ** Obtain from Screen Indicia Instead of File for current status                      MD042692
                                                                                            MD042692
     C                   EVAL      WHasIndicia = PHasIndicia                                MD042692
                                                                                            MD042692
      ** Customer Subject to Reporting
 
     C**********         IF        FVREPT = 'Y'                                             MD033414
     C                   IF        (FVREPT = 'Y'                                            MD033414
     C                             AND WSvalTinBrthRq <> 'N')                               MD033414
     C                             OR (WHasIndicia = 'Y'                                    MD033414
     C                             AND CGL154 = 'Y'                                         MD033414
     C                             AND WSvalTinBrthRq <> 'N')                               MD033414
     C                   IF        WSvalTinBrthRq = 'U'
     C**********                   AND FVUTIN = *BLANKS                                     MD027064
     C                             AND DDUTIN = *BLANKS                                     MD027064
 
     C                             OR WSvalTinBrthRq = 'B'
     C**********                   AND WBthDate = *ZERO                                     MD027064
     C                             AND DDDBTH = ' '                                         MD027064
     C**********                   OR WSvalTinBrthRq = 'B'                                  MD044164
     C**********                   AND WBthCntry = *BLANKS                                  MD027064
     C**********                   AND DDBTHC = *BLANKS                            MD027064 MD044164
     C                             OR WSvalTinBrthRq = 'B'
     C**********                   AND WBthTown = *BLANKS                                   MD027064
     C                             AND DDBTHT = *BLANKS                                     MD027064
 
     C                             OR WSvalTinBrthRq = 'Y'
     C**********                   AND FVUTIN = *BLANKS                                     MD027064
     C                             AND DDUTIN = *BLANKS                                     MD027064
     C                             OR WSvalTinBrthRq = 'Y'
     C**********                   AND WBthDate = *ZERO                                     MD027064
     C                             AND DDDBTH = ' '                                         MD027064
     C**********                   OR WSvalTinBrthRq = 'Y'                                  MD044164
     C**********                   AND WBthCntry = *BLANKS                                  MD027064
     C**********                   AND DDBTHC = *BLANKS                            MD027064 MD044164
     C                             OR WSvalTinBrthRq = 'Y'
     C**********                   AND WBthTown = *BLANKS                                   MD027064
     C                             AND DDBTHT = *BLANKS                                     MD027064
 
     C                   EVAL      WArrCnt = WArrCnt +1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'C'
 
     C                   EVAL      WIx = WIx + 1
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0432'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCSExpCls - Expiry days has passed                          *
      *                                                               *
      *****************************************************************
     C     SrCSExpCls    BEGSR
 
     C*****FVCUST        CHAIN     SDCUSTX0                                                 MD027076
     C**********         IF        NOT %FOUND(SDCUSXL1) AND                                 MD027076
     C**********                   FVLCTP <> 'I' AND                                        MD027076
     C**********                   FVCUST <> *BLANKS                                        MD027076
     C**********         EVAL      DBFILE = 'SDCUSXL1'                                      MD027076
     C**********         EVAL      DBASE  = 901                                             MD027076
     C**********         EVAL      DBKEY  = POPTN                                           MD027076
     C**********         EXSR      *PSSR                                                    MD027076
     C**********         ENDIF                                                              MD027076
 
     C**********         IF        FVLCTP <> 'I'                                            MD026497
     C                   EVAL      WExpiryDate = XCCRDT + WSvalExpDayDft
     C                   IF        WExpiryDate < WRUND
     C                             AND FVCLAC = WSvalDftClsCde
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'D'
 
     C                   EVAL      WIx = WIx + 1
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0367'
     C                   ENDIF
     C**********         ENDIF                                                              MD026497
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCSSubtyp - FATCA Customer Type is define but no subtype    *
      *                                                               *
      *****************************************************************
     C     SrCSSubtyp    BEGSR
 
      ** FATCA Customer Type is 'F' (FFI) or 'N' (NFE)
      ** but no FATCA Subtype defined
 
     C                   IF        FVCSTY = 'F'
     C                             AND FVCSST = *BLANKS
     C                             OR FVCSTY = 'N'
     C                             AND FVCSST = *BLANKS
     C                             OR FVCSTY = 'F'                                          MD026692
     C                             AND FVCSST = 'UN'                                        MD026692
     C                             OR FVCSTY = 'N'                                          MD026692
     C                             AND FVCSST = 'UN'                                        MD026692
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'E'
 
     C                   EVAL      WIx = WIx + 1
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0433'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCSGIINno - Customer is participating but no GIIN number    *
      *                                                               *
      *****************************************************************
     C     SrCSGIINno    BEGSR
 
      ** Customer is flagged as a participating FFI but the GIIN number
      ** information is missing
 
     C                   IF        FVCSTY = 'F'
     C                             AND FVCSST = 'PO'
     C                             AND FVGIIN = *BLANKS
     C                             OR FVCSTY = 'F'
     C                             AND FVCSST = 'PS'
     C                             AND FVGIIN = *BLANKS
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'F'
 
     C                   EVAL      WIx = WIx + 1
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0434'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCSGIINDt - Customer is participating but no GIIN date      *
      *                                                               *
      *****************************************************************
     C     SrCSGIINDt    BEGSR
 
      ** Customer is flagged as a participating FFI but the GIIN
      ** verification date is blank
 
     C                   IF        FVCSTY = 'F'
     C                             AND FVCSST = 'PO'
     C                             AND FVGIID = *ZERO
     C                             OR FVCSTY = 'F'
     C                             AND FVCSST = 'PS'
     C                             AND FVGIID = *ZERO
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'G'
 
     C                   EVAL      WIx = WIx + 1
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0435'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCSNFEiry - Customer NFE/Passive not exempt                 *
      *                                                               *
      *****************************************************************
     C     SrCSNFEiry    BEGSR
 
      ** Customer is not exempt and is flagged as 'NFE'/Passive but
      ** ther are no controlling persons defined
 
     C                   IF        FVEXEM <> 'Y'
     C                             AND FVCSTY = 'N'
     C                             AND FVCSST = 'PA'
     C     FVCUST        CHAIN     SDJACCD0
     C                   IF        NOT %FOUND(SDJACCL0)
 
     C                   EVAL      Idy = 1                                                  MD045238
     C                   EVAL      WCINT = 'N'                                              MD045238
     C                   DOW       Idy <= 50                                                MD045238
     C                   CLEAR                   ValidCUAH                                  MD045238
     C                   EVAL      ValidCUAH = V_CUAHArr(Idy)                               MD045238
     C                   IF        FVCUST = V_ACCUST                                        MD045238
     C                             AND V_ACCINT = 'Y'                                       MD045238
     C                   EVAL      Idy = 50                                                 MD045238
     C                   EVAL      WCINT = 'Y'                                              MD045238
     C                   LEAVE                                                              MD045238
     C                   ENDIF                                                              MD045238
     C                   EVAL      Idy = Idy + 1                                            MD045238
     C                   ENDDO                                                              MD045238
                                                                                            MD045238
     C*****FVCUST        CHAIN     SDCUAHD0                                                 MD045238
     C**********         IF        %FOUND(SDCUAHLA)                                         MD045238
     C**********                   AND CACINT <> 'Y'                                        MD045238
     C**********                   OR NOT %FOUND(SDCUAHLA)                                  MD045238
     C                   IF        WCINT = 'N'                                              MD045238
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'H'
 
      ** Skip Joint Account-related Exceptions on Insert                                   MD026790A
      *                                                                                    MD026790A
     C                   IF        DDACTN <> 'I'                                           MD026790A
     C                   EVAL      WIx = WIx + 1
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0436'
     C                   ENDIF                                                             MD026790A
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
                                                                                              CGL157
     C                   IF        DDEXMP <> 'Y'                                              CGL157
     C                             AND DDTYPE = 'N'                                           CGL157
     C                             AND DDSTYP = 'PA'                                          CGL157
     C                             AND PFeature = 'CRS'                                     MD036369
     C     DDCUSN        CHAIN     SDJACCD0                                                   CGL157
     C                   IF        NOT %FOUND(SDJACCL0)                                       CGL157
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL157
     C                   EVAL      WExcpRptArr (WArrCnt) = 'H'                                CGL157
                                                                                              CGL157
     C                   EVAL      WIx = WIx + 1                                              CGL157
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXMI    '                              CGL157
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0436'                                CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCSJACMbr - Customer is not Exempt and flagged as Joint A/c *
      *                                                               *
      *****************************************************************
     C     SrCSJACMbr    BEGSR
 
      ** Customer is not exempt and is flagged as 'Joint account'
      ** but there are no joint account members defined
 
     C                   IF        FVEXEM <> 'Y'
     C                             AND FVCSTY = 'J'
     C                             AND PFeature = 'FTC'                                     MD036369
     C     FVCUST        CHAIN     SDJACCD0
     C                   IF        NOT %FOUND(SDJACCL0)
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'I'
 
      ** Skip Joint Account-related Exceptions on Insert                                   MD026790A
      *                                                                                    MD026790A
     C                   IF        DDACTN <> 'I'                                           MD026790A
     C                   EVAL      WIx = WIx + 1
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0437'
     C                   ENDIF                                                             MD026790A
 
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDEXMP <> 'Y'                                              CGL157
     C                             AND DDTYPE = 'J'                                           CGL157
     C                             AND PFeature = 'CRS'                                     MD036369
     C     DDCUSN        CHAIN     SDJACCD0                                                   CGL157
     C                   IF        NOT %FOUND(SDJACCL0)                                       CGL157
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL157
     C                   EVAL      WExcpRptArr (WArrCnt) = 'I'                                CGL157
                                                                                              CGL157
     C                   EVAL      WIx = WIx + 1                                              CGL157
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXMI    '                              CGL157
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0437'                                CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCSJntAcct - Joint account with members do not have US      *
      *                Indicia                                        *
      *                                                               *
      *****************************************************************
     C     SrCSJntAcct   BEGSR
 
      ** Customer is not exempt, is flagged as 'joint account' and has
      ** US inidicia identified, but the individual members of the
      ** joint account do not have US indicia
 
     C                   EVAL      WHasIndicia =  ' '                                       MD034071
     C                   IF        FVEXEM <> 'Y'
     C                             AND FVCSTY = 'J'
     C                             AND FVJASV = 'Y'
     C                             AND FVJAOV <> 'Y'
     C                             OR FVEXEM <> 'Y'
     C                             AND FVCSTY = 'J'
     C                             AND FVJAOV = 'Y'
 
      ** Read through Joint account members of the Customer
     C     FVCUST        SETLL     SDJACCD0
     C     FVCUST        READE     SDJACCD0
 
     C                   DOW       NOT %EOF (SDJACCL0)
     C                             AND WHasIndicia <> 'Y'
 
     C                   IF        JCCUST <> *BLANKS
     C     JCCUST        CHAIN     SDFTCSD1
     C                   IF        %FOUND(SDFTCSL1)
 
     C                   EXSR      SrChkIndCust
     C                   ENDIF
     C                   ENDIF
     C                   IF        JCNAHO <> *BLANKS
     C     JCNAHO        CHAIN     SDFTNHD1
     C                   IF        %FOUND(SDFTNHL1)
 
     C                   EXSR      SrChkIndNaho
     C                   ENDIF
     C                   ENDIF
 
     C     FVCUST        READE     SDJACCD0
     C                   ENDDO
 
     C                   IF        WHasIndicia <> 'Y'
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'J'
 
      ** Skip Joint Account-related Exceptions on Insert                                   MD026790A
      *                                                                                    MD026790A
     C                   IF        DDACTN <> 'I'                                           MD026790A
     C                   EVAL      WIx = WIx + 1
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0438'
     C                   ENDIF                                                             MD026790A
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCSComplt - Customer flagged as Complete                    *
      *                                                               *
      *****************************************************************
     C     SrCSComplt    BEGSR
 
      ** FATCA inoformation is flagged as 'complete' but customer
      ** or non-account holder has still one of the default statuses
 
     C                   IF        FVINFC = 'Y'
     C                             AND WSvalDftClsCde = FVCLAC
     C                             OR FVINFC = 'Y'
     C                             AND WSvalDftClsTkn = FVCLAC
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'K'
 
     C                   EVAL      WIx = WIx + 1
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0439'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCSActRvw - Account Review is passed due date               *
      *                                                               *
      *****************************************************************
     C     SrCSActRvw    BEGSR
 
      ** FATCA account review is passed due date
 
     C     FVCUST        SETLL     SDACRVD6
     C     FVCUST        READE     SDACRVD6
 
     C                   EVAL      WFOUND = 'N'
 
     C                   DOW       NOT %EOF (SDACRVL6)
     C                             AND WFOUND = 'N'
 
     C                   IF        ARSCDT < WRUND
     C                   EVAL      WFOUND = 'Y'
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'L'
 
     C                   EVAL      WIx = WIx + 1
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0368'
     C                   ENDIF
 
     C     FVCUST        READE     SDACRVD6
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                MD033414
      *****************************************************************                     MD033414
      *                                                               *                     MD033414
      *  SrCSDlgnce - FATCA Customer Diligence Check                  *                     MD033414
      *                                                               *                     MD033414
      *****************************************************************                     MD033414
     C     SrCSDlgnce    BEGSR                                                              MD033414
                                                                                            MD033414
     C                   EVAL      PIDate = *ZERO                                           MD033414
     C                   EVAL      PODate = *ZERO                                           MD033414
                                                                                            MD033414
     C                   EVAL      PIDate = WSvalEffctDate                                  MD033414
     C                   EXSR      SRMdasDay                                                MD033414
                                                                                            MD033414
      ** New Customer                                                                       MD033414
                                                                                            MD033414
     C                   IF        XCCRDT >= PODate                                         MD033414
                                                                                            MD033414
     C                   EVAL      WDlgDt = XCCRDT + WSvalDlgNewAC                          MD033414
     C                   IF        WDlgDt <= WRUND AND                                      MD033414
     C**********                   FVINFC <> 'Y'                                   MD033414 MD033660
     C                             FVINFC <> 'Y' AND FVINFC <> 'A'                          MD033660
     C                   EVAL      WArrCnt = WArrCnt + 1                                    MD033414
     C                   EVAL      WExcpRptArr (WArrCnt) = 'M'                              MD033414
                                                                                            MD033414
     C                   EVAL      WIx = WIx + 1                                            MD033414
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '                            MD033414
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0496'                              MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
     C                   ELSE                                                               MD033414
                                                                                            MD033414
      ** Existing Customer (Created before FATCA effective Date)                            MD033414
                                                                                            MD033414
      ** Existing A/C - Individual/Medium                                                   MD033414
     C                   SELECT                                                             MD033414
     C                   WHEN      FVCSTY = 'P' AND FVHVAC = 'M'                            MD033414
                                                                                            MD033414
     C                   MOVE      WSvalDlgMedIndPIDate                                     MD033414
     C                   EXSR      SRMdasDay                                                MD033414
                                                                                            MD033414
     C                   IF        PODate <= WRUND AND                                      MD033414
     C**********                   FVINFC <> 'Y'                                   MD033414 MD033660
     C                             FVINFC <> 'Y' AND FVINFC <> 'A'                          MD033660
     C                   EVAL      WArrCnt = WArrCnt + 1                                    MD033414
     C                   EVAL      WExcpRptArr (WArrCnt) = 'M'                              MD033414
                                                                                            MD033414
     C                   EVAL      WIx = WIx + 1                                            MD033414
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '                            MD033414
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0496'                              MD033414
                                                                                            MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
      ** Existing A/C - Individual/High                                                     MD033414
                                                                                            MD033414
     C                   WHEN      FVCSTY = 'P' AND FVHVAC = 'H'                            MD033414
                                                                                            MD033414
     C                   MOVE      WSvalDlgHiInd PIDate                                     MD033414
     C                   EXSR      SRMdasDay                                                MD033414
                                                                                            MD033414
     C                   IF        PODate <= WRUND AND                                      MD033414
     C**********                   FVINFC <> 'Y'                                   MD033414 MD033660
     C                             FVINFC <> 'Y' AND FVINFC <> 'A'                          MD033660
     C                   EVAL      WArrCnt = WArrCnt + 1                                    MD033414
     C                   EVAL      WExcpRptArr (WArrCnt) = 'M'                              MD033414
                                                                                            MD033414
     C                   EVAL      WIx = WIx + 1                                            MD033414
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '                            MD033414
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0496'                              MD033414
                                                                                            MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
      ** Existing A/C - Entity/Medium                                                       MD033414
     C                                                                                      MD033414
     C                   WHEN      FVCSTY <> 'P' AND FVHVAC = 'M'                           MD033414
                                                                                            MD033414
     C                   MOVE      WSvalDlgMedEntPIDate                                     MD033414
     C                   EXSR      SRMdasDay                                                MD033414
                                                                                            MD033414
     C                   IF        PODate <= WRUND AND                                      MD033414
     C**********                   FVINFC <> 'Y'                                   MD033414 MD033660
     C                             FVINFC <> 'Y' AND FVINFC <> 'A'                          MD033660
     C                   EVAL      WArrCnt = WArrCnt + 1                                    MD033414
     C                   EVAL      WExcpRptArr (WArrCnt) = 'M'                              MD033414
                                                                                            MD033414
     C                   EVAL      WIx = WIx + 1                                            MD033414
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '                            MD033414
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0496'                              MD033414
                                                                                            MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
      ** Existing A/C - Entity/High                                                         MD033414
                                                                                            MD033414
     C                   WHEN      FVCSTY <> 'P' AND FVHVAC = 'H'                           MD033414
                                                                                            MD033414
     C                   MOVE      WSvalDlgHiEnt PIDate                                     MD033414
     C                   EXSR      SRMdasDay                                                MD033414
                                                                                            MD033414
     C                   IF        PODate <= WRUND AND                                      MD033414
     C**********                   FVINFC <> 'Y'                                   MD033414 MD033660
     C                             FVINFC <> 'Y' AND FVINFC <> 'A'                          MD033660
     C                   EVAL      WArrCnt = WArrCnt + 1                                    MD033414
     C                   EVAL      WExcpRptArr (WArrCnt) = 'M'                              MD033414
                                                                                            MD033414
     C                   EVAL      WIx = WIx + 1                                            MD033414
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '                            MD033414
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0496'                              MD033414
                                                                                            MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
     C                   ENDSL                                                              MD033414
                                                                                            MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
     C                   ENDSR                                                              MD033414
      *****************************************************************                     MD033414
      /EJECT                                                                                MD033414
      *****************************************************************                     MD033414
      *                                                               *                     MD033414
      *  SRMdasDay - Convert Diligence 6A Dates to Midas Day No.      *                     MD033414
      *                                                               *                     MD033414
      *****************************************************************                     MD033414
     C     SRMdasDay     BEGSR                                                              MD033414
                                                                                            MD033414
     C                   CALLB     'ZDATE1'                                                 MD033414
     C                   PARM                    PIDate                                     MD033414
     C                   PARM      *ZERO         PODate                                     MD033414
     C                   PARM                    BJDFIN                                     MD033414
     C                   PARM      *BLANK        PErrFlag                                   MD033414
                                                                                            MD033414
     C                   ENDSR                                                              MD033414
      *****************************************************************                     MD033414
      /EJECT                                                                                MD033414
      *****************************************************************                       CGL157
      *                                                               *                       CGL157
      *  SrNewSubTIN - CRS New Customer Subject to Reporting          *                       CGL157
      *                but no Tax Identification Number               *                       CGL157
      *                                                               *                       CGL157
      *****************************************************************                       CGL157
     C     SrNewSubTIN   BEGSR                                                                CGL157
                                                                                              CGL157
     C                   IF        DDEXMP <> 'Y'                                            MD040734
     C                             AND DDTYPE <> 'F'                                        MD040734
     C                   EVAL      PIDate = WCRSEftStrtDte                                    CGL157
     C                   EXSR      SRMdasDay                                                  CGL157
                                                                                              CGL157
      ** Retrieve data set per PCrsdS record (max 30) for Subject to Reporting                CGL157
     C                   EVAL      X = 1                                                      CGL157
                                                                                              CGL157
     C                   DOW       X < 31                                                     CGL157
                                                                                              CGL157
     C                   EVAL      PCRSDT = PCrsdS(X)                                         CGL157
                                                                                              CGL157
     C                   IF        DDCTRY <> *Blanks                                          CGL157
                                                                                              CGL157
      ** If New Customer is Subject to Reporting but No TIN defined                           CGL157
                                                                                              CGL157
     C                   IF        (DDREPT = 'Y'                                              CGL157
     C                             AND DDTINN = *BLANKS                                       CGL157
     C                             AND XCCRDT >= PODate)                                      CGL157
                                                                                              CGL157
      ** If Country has a CRS agreement, or the system value defines the TIN as mandatory     CGL157
                                                                                              CGL157
      ** If CRS Country is Local Country                                                      CGL157
     C                   IF        L_BJCNCD = DDCTRY                                          CGL157
                                                                                              CGL157
     C                   IF        (DDCRSA = 'Y' OR                                           CGL157
     C                             WCRSLocTINMan = 'Y')                                       CGL157
     C                   EVAL      WArrCnt = WArrCnt +1                                       CGL157
     C                   EVAL      WExcpRptArr (WArrCnt) = 'N'                                CGL157
                                                                                              CGL157
     C                   EVAL      WIx = WIx + 1                                              CGL157
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXMI    '                              CGL157
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0630'                                CGL157
     C                   LEAVE                                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ELSE                                                                 CGL157
      ** If CRS Country is Foreign Country                                                    CGL157
     C                   IF        (DDCRSA = 'Y' OR                                           CGL157
     C                             WCRSForTINMan = 'Y')                                       CGL157
     C                   EVAL      WArrCnt = WArrCnt +1                                       CGL157
     C                   EVAL      WExcpRptArr (WArrCnt) = 'N'                                CGL157
                                                                                              CGL157
     C                   EVAL      WIx = WIx + 1                                              CGL157
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXMI    '                              CGL157
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0630'                                CGL157
     C                   LEAVE                                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   EVAL      X = X + 1                                                  CGL157
                                                                                              CGL157
     C                   ENDDO                                                                CGL157
     C                   ENDIF                                                              MD040734
                                                                                              CGL157
     C                   ENDSR                                                                CGL157
      *****************************************************************                       CGL157
      /EJECT                                                                                  CGL157
      *****************************************************************                       CGL157
      *                                                               *                       CGL157
      *  SrExtSubTIN - CRS Existing Customer Subject to Reporting     *                       CGL157
      *                but no Tax Identification Number               *                       CGL157
      *                                                               *                       CGL157
      *****************************************************************                       CGL157
     C     SrExtSubTIN   BEGSR                                                                CGL157
                                                                                              CGL157
     C                   IF        DDEXMP <> 'Y'                                            MD040734
     C                             AND DDTYPE <> 'F'                                        MD040734
     C                   EVAL      PIDate = WCRSEftStrtDte                                    CGL157
     C                   EXSR      SRMdasDay                                                  CGL157
                                                                                              CGL157
      ** Retrieve data set per PCrsdS record (max 30) for Subject to Reporting                CGL157
     C                   EVAL      X = 1                                                      CGL157
                                                                                              CGL157
     C                   DOW       X < 31                                                     CGL157
                                                                                              CGL157
     C                   EVAL      PCRSDT = PCrsdS(X)                                         CGL157
                                                                                              CGL157
     C                   IF        DDCTRY <> *Blanks                                          CGL157
                                                                                              CGL157
      ** If Existing Customer Subject to Reporting but No TIN defined                         CGL157
                                                                                              CGL157
     C                   IF        (DDREPT = 'Y'                                              CGL157
     C                             AND DDTINN = *BLANKS                                       CGL157
     C                             AND XCCRDT < PODate)                                       CGL157
                                                                                              CGL157
      ** If Country has a CRS agreement, or the system value defines the TIN as mandatory     CGL157
                                                                                              CGL157
      ** If CRS Country is Local Country                                                      CGL157
     C                   IF        L_BJCNCD = DDCTRY                                          CGL157
                                                                                              CGL157
     C                   IF        (DDCRSA = 'Y' OR                                           CGL157
     C                             WCRSLocTINMan = 'Y')                                       CGL157
     C                   EVAL      WArrCnt = WArrCnt +1                                       CGL157
     C                   EVAL      WExcpRptArr (WArrCnt) = 'O'                                CGL157
                                                                                              CGL157
     C                   EVAL      WIx = WIx + 1                                              CGL157
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXMI    '                              CGL157
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0631'                                CGL157
     C                   LEAVE                                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ELSE                                                                 CGL157
      ** If CRS Country is Foreign Country                                                    CGL157
     C                   IF        (DDCRSA = 'Y' OR                                           CGL157
     C                             WCRSForTINMan = 'Y')                                       CGL157
     C                   EVAL      WArrCnt = WArrCnt +1                                       CGL157
     C                   EVAL      WExcpRptArr (WArrCnt) = 'O'                                CGL157
                                                                                              CGL157
     C                   EVAL      WIx = WIx + 1                                              CGL157
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXMI    '                              CGL157
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0631'                                CGL157
     C                   LEAVE                                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   EVAL      X = X + 1                                                  CGL157
                                                                                              CGL157
     C                   ENDDO                                                                CGL157
     C                   ENDIF                                                              MD040734
                                                                                              CGL157
     C                   ENDSR                                                                CGL157
      *****************************************************************                       CGL157
      /EJECT                                                                                  CGL157
      *****************************************************************                       CGL157
      *                                                               *                       CGL157
      *  SrCRSTypeNFE - CRS customer type is defined as NFE, but no   *                       CGL157
      *                 CRS customer sub-type defined.                *                       CGL157
      *                                                               *                       CGL157
      *****************************************************************                       CGL157
     C     SrCRSTypeNFE  BEGSR                                                                CGL157
                                                                                              CGL157
     C                   IF        DDEXMP <> 'Y'                                            MD040734
      ** CRS customer type is defined as NFE, but no CRS customer sub-type defined            CGL157
                                                                                              CGL157
     C                   IF        (DDTYPE = 'N' AND                                          CGL157
     C                             DDSTYP = 'UN')                                             CGL157
     C                             OR (DDTYPE = 'N' AND                                       CGL157
     C                             DDSTYP = *BLANKS)                                          CGL157
     C                   EVAL      WArrCnt = WArrCnt +1                                       CGL157
     C                   EVAL      WExcpRptArr (WArrCnt) = 'P'                                CGL157
                                                                                              CGL157
     C                   EVAL      WIx = WIx + 1                                              CGL157
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXMI    '                              CGL157
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0632'                                CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                              MD040734
                                                                                              CGL157
     C                   ENDSR                                                                CGL157
      *****************************************************************                       CGL157
      /EJECT                                                                                  CGL157
      *****************************************************************                       CGL157
      *                                                               *                       CGL157
      *  SrCRSDueDlg - CRS Due Diligence period has expired but the   *                       CGL157
      *                CRS Info Complete Flag is still set to         *                       CGL157
      *                'No' or 'Blank'                                *                       CGL157
      *                                                               *                       CGL157
      *****************************************************************                       CGL157
     C     SrCRSDueDlg   BEGSR                                                                CGL157
                                                                                              CGL157
      ** CRS Due Diligence period has expired but the CRS Info Complete Flag                  CGL157
      ** is still set to 'No' or 'Blank'                                                      CGL157
                                                                                              CGL157
     C                   EVAL      PIDate = *ZERO                                             CGL157
     C                   EVAL      PODate = *ZERO                                             CGL157
                                                                                              CGL157
     C                   EVAL      PIDate = WCRSEftStrtDte                                    CGL157
     C                   EXSR      SRMdasDay                                                  CGL157
                                                                                              CGL157
      ** New CRS Customer                                                                     CGL157
                                                                                              CGL157
     C                   IF        XCCRDT >= PODate                                           CGL157
                                                                                              CGL157
     C                   EVAL      WDlgDt = XCCRDT + WCRSDlgNewAC                             CGL157
     C                   IF        WDlgDt <= WRUND AND                                        CGL157
     C**********                   DDINFO <> 'Y'                                       CGL157 CGL177
     C                             DDINFO <> 'Y' AND DDINFO <> 'A'                            CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL157
     C                   EVAL      WExcpRptArr (WArrCnt) = 'Q'                                CGL157
                                                                                              CGL157
     C                   EVAL      WIx = WIx + 1                                              CGL157
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXMI    '                              CGL157
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0633'                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL177
     C                   ELSE                                                                 CGL177
                                                                                              CGL177
      ** Existing CRS Customer (Created before CRS Effective Date)                            CGL177
                                                                                              CGL177
     C                   EXSR      SrCRSDlgDte                                                CGL177
                                                                                              CGL177
     C                   SELECT                                                               CGL177
      ** CRS Existing A/C - Individual/Blank or Individual/N                                  CGL177
     C                   WHEN      DDTYPE = 'P' AND DDHVAL = ' '                              CGL177
     C                             OR DDTYPE = 'P' AND DDHVAL = 'N'                           CGL177
                                                                                              CGL177
     C                   IF        LowestVal <= WRUND AND                                     CGL177
     C                             DDINFO <> 'Y' AND DDINFO <> 'A'                            CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL177
     C                   EVAL      WExcpRptArr (WArrCnt) = 'Q'                                CGL177
                                                                                              CGL177
     C                   EVAL      WIx = WIx + 1                                              CGL177
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '                              CGL177
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0633'                                CGL177
                                                                                              CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
      ** CRS Existing A/C - Entity/Blank or Entity/N                                          CGL177
     C                   WHEN      DDTYPE <> 'P' AND DDHVAL = ' '                             CGL177
     C                             OR DDTYPE <> 'P' AND DDHVAL = 'N'                          CGL177
                                                                                              CGL177
     C                   IF        LowestVal <= WRUND AND                                     CGL177
     C                             DDINFO <> 'Y' AND DDINFO <> 'A'                            CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL177
     C                   EVAL      WExcpRptArr (WArrCnt) = 'Q'                                CGL177
                                                                                              CGL177
     C                   EVAL      WIx = WIx + 1                                              CGL177
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '                              CGL177
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0633'                                CGL177
                                                                                              CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
      ** CRS Existing A/C - Individual/Medium or Individual/Low                               CGL177
     C                   WHEN      DDTYPE = 'P' AND DDHVAL = 'M'                              CGL177
     C                             OR DDTYPE = 'P' AND DDHVAL = 'L'                           CGL177
                                                                                              CGL177
     C                   MOVE      WCRSDlgMedInd PIDate                                       CGL177
     C                   EXSR      SRMdasDay                                                  CGL177
                                                                                              CGL177
     C                   IF        PODate <= WRUND AND                                        CGL177
     C                             DDINFO <> 'Y' AND DDINFO <> 'A'                            CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL177
     C                   EVAL      WExcpRptArr (WArrCnt) = 'Q'                                CGL177
                                                                                              CGL177
     C                   EVAL      WIx = WIx + 1                                              CGL177
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '                              CGL177
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0633'                                CGL177
                                                                                              CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
      ** CRS Existing A/C - Individual/High                                                   CGL177
     C                   WHEN      DDTYPE = 'P' AND DDHVAL = 'H'                              CGL177
                                                                                              CGL177
     C                   MOVE      WCRSDlgHiInd  PIDate                                       CGL177
     C                   EXSR      SRMdasDay                                                  CGL177
                                                                                              CGL177
     C                   IF        PODate <= WRUND AND                                        CGL177
     C                             DDINFO <> 'Y' AND DDINFO <> 'A'                            CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL177
     C                   EVAL      WExcpRptArr (WArrCnt) = 'Q'                                CGL177
                                                                                              CGL177
     C                   EVAL      WIx = WIx + 1                                              CGL177
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '                              CGL177
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0633'                                CGL177
                                                                                              CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
      ** CRS Existing A/C - Entity/Medium or Entity/Low                                       CGL177
     C                   WHEN      DDTYPE <> 'P' AND DDHVAL = 'M'                             CGL177
     C                             OR DDTYPE <> 'P' AND DDHVAL = 'L'                          CGL177
                                                                                              CGL177
     C                   MOVE      WCRSDlgMedEnt PIDate                                       CGL177
     C                   EXSR      SRMdasDay                                                  CGL177
                                                                                              CGL177
     C                   IF        PODate <= WRUND AND                                        CGL177
     C                             DDINFO <> 'Y' AND DDINFO <> 'A'                            CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL177
     C                   EVAL      WExcpRptArr (WArrCnt) = 'Q'                                CGL177
                                                                                              CGL177
     C                   EVAL      WIx = WIx + 1                                              CGL177
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '                              CGL177
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0633'                                CGL177
                                                                                              CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
      ** CRS Existing A/C - Entity/High                                                       CGL177
     C                   WHEN      DDTYPE <> 'P' AND DDHVAL = 'H'                             CGL177
                                                                                              CGL177
     C                   MOVE      WCRSDlgHiEnt  PIDate                                       CGL177
     C                   EXSR      SRMdasDay                                                  CGL177
                                                                                              CGL177
     C                   IF        PODate <= WRUND AND                                        CGL177
     C                             DDINFO <> 'Y' AND DDINFO <> 'A'                            CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL177
     C                   EVAL      WExcpRptArr (WArrCnt) = 'Q'                                CGL177
                                                                                              CGL177
     C                   EVAL      WIx = WIx + 1                                              CGL177
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '                              CGL177
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0633'                                CGL177
                                                                                              CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   ENDSL                                                                CGL177
                                                                                              CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ENDSR                                                                CGL157
      *****************************************************************                       CGL157
      /EJECT                                                                                  CGL177
      *****************************************************************                       CGL177
      *                                                               *                       CGL177
      *  SrCRSActRv - CRS Account Review is passed due date           *                       CGL177
      *                                                               *                       CGL177
      *****************************************************************                       CGL177
     C     SrCRSActRv    BEGSR                                                                CGL177
                                                                                              CGL177
     C                   IF        DDEXMP <> 'Y'                                            MD040734
     C                             AND DDTYPE <> 'F'                                        MD040734
      ** CRS account review is passed due date                                                CGL177
                                                                                              CGL177
     C     DDCUSN        SETLL     SDACRVD6                                                   CGL177
     C     DDCUSN        READE     SDACRVD6                                                   CGL177
                                                                                              CGL177
     C                   EVAL      WFOUND = 'N'                                               CGL177
                                                                                              CGL177
     C                   DOW       NOT %EOF (SDACRVL6)                                        CGL177
     C                             AND WFOUND = 'N'                                           CGL177
                                                                                              CGL177
     C                   IF        ARSCDT < WRUND                                             CGL177
     C                   EVAL      WFOUND = 'Y'                                               CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL177
     C                   EVAL      WExcpRptArr (WArrCnt) = 'L'                                CGL177
                                                                                              CGL177
     C                   EVAL      WIx = WIx + 1                                              CGL177
     C                   EVAL      WFldNmXAr(WIx) = 'DDEXID    '                              CGL177
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0368'                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C     DDCUSN        READE     SDACRVD6                                                   CGL177
     C                   ENDDO                                                                CGL177
     C                   ENDIF                                                              MD040734
                                                                                              CGL177
     C                   ENDSR                                                                CGL177
      *****************************************************************                       CGL177
      /EJECT                                                                                  CGL157
      *****************************************************************                       CGL177
      *                                                               *                       CGL177
      *  SrCRSDlgDte - CRS Due Diligence date comparison for CRS High *                       CGL177
      *                Value 'Blank' or 'N', check against earliest   *                       CGL177
      *                defined Due Diligence date                     *                       CGL177
      *                                                               *                       CGL177
      *****************************************************************                       CGL177
     C     SrCRSDlgDte   BEGSR                                                                CGL177
                                                                                              CGL177
      ** CRS Due Diligence period prep for earliest date comparison                           CGL177
     C                   EVAL      PIDate = *ZERO                                             CGL177
     C                   EVAL      PODate = *ZERO                                             CGL177
                                                                                              CGL177
     C                   MOVE      WCRSDlgMedInd PIDate                                       CGL177
     C                   EXSR      SRMdasDay                                                  CGL177
     C                   EVAL      NCRSDlgMedInd = PODate                                     CGL177
                                                                                              CGL177
     C                   MOVE      WCRSDlgHiInd  PIDate                                       CGL177
     C                   EXSR      SRMdasDay                                                  CGL177
     C                   EVAL      NCRSDlgHiInd = PODate                                      CGL177
                                                                                              CGL177
     C                   MOVE      WCRSDlgMedEnt PIDate                                       CGL177
     C                   EXSR      SRMdasDay                                                  CGL177
     C                   EVAL      NCRSDlgMedEnt = PODate                                     CGL177
                                                                                              CGL177
     C                   MOVE      WCRSDlgHiEnt  PIDate                                       CGL177
     C                   EXSR      SRMdasDay                                                  CGL177
     C                   EVAL      NCRSDlgHiEnt = PODate                                      CGL177
                                                                                              CGL177
      ** CRS Due Diligence earliest date comparison                                           CGL177
     C                   IF        NCRSDlgMedInd > NCRSDlgHiInd                               CGL177
     C                   EVAL      LowVal1 = NCRSDlgHiInd                                     CGL177
     C                   ELSE                                                                 CGL177
     C                   EVAL      LowVal1 = NCRSDlgMedInd                                    CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   IF        NCRSDlgMedEnt > NCRSDlgHiEnt                               CGL177
     C                   EVAL      LowVal2 = NCRSDlgHiEnt                                     CGL177
     C                   ELSE                                                                 CGL177
     C                   EVAL      LowVal2 = NCRSDlgMedEnt                                    CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
      ** CRS Due Diligence earliest date                                                      CGL177
     C                   IF        LowVal1 > LowVal2                                          CGL177
     C                   EVAL      LowestVal = LowVal2                                        CGL177
     C                   ELSE                                                                 CGL177
     C                   EVAL      LowestVal = LowVal1                                        CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   ENDSR                                                                CGL177
      *****************************************************************                       CGL177
      /EJECT                                                                                  CGL177
      *****************************************************************                       CGL157
      *                                                               *                       CGL157
      *  SRSVAL2 - Access System Values for CRS                       *                       CGL157
      *                                                               *                       CGL157
      *****************************************************************                       CGL157
     C     SRSVAL2       BEGSR                                                                CGL157
                                                                                              CGL157
     C                   EVAL      POP01 = 'CRSEffectStartDate'                               CGL157
     C                   EVAL      POP02 = 'CRSDiligenceHiEnt'                                CGL157
     C                   EVAL      POP03 = 'CRSDiligenceHiInd'                                CGL157
     C                   EVAL      POP04 = 'CRSDiligenceMedEnt'                               CGL157
     C                   EVAL      POP05 = 'CRSDiligenceMedInd'                               CGL157
     C                   EVAL      POP06 = 'CRSDiligenceNewA/C'                               CGL157
     C                   EVAL      POP07 = 'CRSForTINMandatory'                               CGL157
     C                   EVAL      POP08 = 'CRSLocalTINMandatory'                             CGL157
                                                                                              CGL157
     C                   CALL      'AOSVALR0'                                                 CGL157
     C                   PARM      *BLANKS       PRtcd                                        CGL157
     C                   PARM                    POP01                                        CGL157
     C                   PARM                    PVL01                                        CGL157
     C                   PARM                    POP02                                        CGL157
     C                   PARM                    PVL02                                        CGL157
     C                   PARM                    POP03                                        CGL157
     C                   PARM                    PVL03                                        CGL157
     C                   PARM                    POP04                                        CGL157
     C                   PARM                    PVL04                                        CGL157
     C                   PARM                    POP05                                        CGL157
     C                   PARM                    PVL05                                        CGL157
     C                   PARM                    POP06                                        CGL157
     C                   PARM                    PVL06                                        CGL157
     C                   PARM                    POP07                                        CGL157
     C                   PARM                    PVL07                                        CGL157
     C                   PARM                    POP08                                        CGL157
     C                   PARM                    PVL08                                        CGL157
     C                   PARM                    POP09                                        CGL157
     C                   PARM                    PVL09                                        CGL157
     C                   PARM                    POP10                                        CGL157
     C                   PARM                    PVL10                                        CGL157
                                                                                              CGL157
     C                   EVAL      WCRSEftStrtDte = PVL01                                     CGL157
     C**********         EVAL      WCRSDlgMedInd = PVL02                               CGL157 CGL177
     C                   EVAL      WCRSDlgHiEnt = PVL02                                       CGL177
     C                   EVAL      WCRSDlgHiInd = PVL03                                       CGL157
     C                   EVAL      WCRSDlgMedEnt = PVL04                                      CGL157
     C**********         EVAL      WCRSDlgHiEnt = PVL05                                CGL157 CGL177
     C                   EVAL      WCRSDlgMedInd = PVL05                                      CGL177
     C                   MOVEL     PVL06         WCRSDlgNewAC                                 CGL157
     C                   EVAL      WCRSForTINMan = PVL07                                      CGL157
     C                   EVAL      WCRSLocTINMan = PVL08                                      CGL157
                                                                                              CGL157
     C                   ENDSR                                                                CGL157
      *****************************************************************                       CGL157
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDate10 - Convert Date YYYYMMDD to Midas Date               *
      *                                                               *
      *****************************************************************
     C     SRDate10      BEGSR
 
     C                   CALLB     'ZDATE10'
     C                   PARM                    PInDate
     C                   PARM                    PMDate
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                     MD026997
      *                                                               *                     MD026997
      *  ZDATE1 - Validate & convert date to a day number             *                     MD026997
      *                                                               *                     MD026997
      *****************************************************************                     MD026997
     C     ZDATE1        BEGSR                                                              MD026997
                                                                                            MD026997
     C                   CALLB     'ZDATE1'                                                 MD026997
     C                   PARM                    ZDATEA            6                        MD026997
     C                   PARM                    ZDAYNO            5 0                      MD026997
     C                   PARM      BJDFIN        Format            1                        MD026997
     C                   PARM                    ErrorFlag         1                        MD026997
                                                                                            MD026997
     C                   ENDSR                                                              MD026997
      *****************************************************************                     MD026997
      /EJECT                                                                                MD026997
      *****************************************************************
      *                                                               *
      *  SRSVAL - Access System Values                                *
      *                                                               *
      *****************************************************************
     C     SRSVAL        BEGSR
 
     C                   EVAL      POP01 = 'FATCAUsTinBirthRqd'
     C                   EVAL      POP02 = 'FATCAExpDayDftClsNew'
     C                   EVAL      POP03 = 'FATCADftCLsNewCustNH'
     C                   EVAL      POP04 = 'FATCADftCLsTakeon'
     C                   EVAL      POP05 = 'FATCAEffectStartDate'                           MD026997
     C                   EVAL      POP06 = 'FATCADiligenceNewA/C'                           MD033414
     C                   EVAL      POP07 = 'FATCADiligenceMedInd'                           MD033414
     C                   EVAL      POP08 = 'FATCADiligenceHiInd'                            MD033414
     C                   EVAL      POP09 = 'FATCADiligenceMedEnt'                           MD033414
     C                   EVAL      POP10 = 'FATCADiligenceHiEnt'                            MD033414
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM                    POP01
     C                   PARM                    PVL01
     C                   PARM                    POP02
     C                   PARM                    PVL02
     C                   PARM                    POP03
     C                   PARM                    PVL03
     C                   PARM                    POP04
     C                   PARM                    PVL04
     C                   PARM                    POP05
     C                   PARM                    PVL05
     C                   PARM                    POP06
     C                   PARM                    PVL06
     C                   PARM                    POP07
     C                   PARM                    PVL07
     C                   PARM                    POP08
     C                   PARM                    PVL08
     C                   PARM                    POP09
     C                   PARM                    PVL09
     C                   PARM                    POP10
     C                   PARM                    PVL10
 
     C                   EVAL      WSvalTinBrthRq = PVL01
     C**********         MOVEL     PVL02         WSvalExpDayDft                             MD025121
     C                   EVALR     WDays = %TRIM(PVL02)                                     MD025121
     C                   MOVE      WDays         WSvalExpDayDft                             MD025121
     C                   EVAL      WSvalDftClsCde = PVL03
     C                   EVAL      WSvalDftClsTkn  = PVL04
     C                   EVAL      WSvalEffctDate  = PVL05                                  MD026997
     C                   MOVEL     PVL06         WSvalDlgNewAC                              MD033414
     C                   EVAL      WSvalDlgMedInd = PVL07                                   MD033414
     C                   EVAL      WSvalDlgHiInd = PVL08                                    MD033414
     C                   EVAL      WSvalDlgMedEnt = PVL09                                   MD033414
     C                   EVAL      WSvalDlgHiEnt = PVL10                                    MD033414
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChkIndCust - Check US Indicia for Customer                 *
      *                                                               *
      *****************************************************************
     C     SrChkIndCust  BEGSR
 
     C                   EVAL      WOvrOff = 1
     C                   EVAL      WSysOff = 0
 
      ** Check if any override flag has been set on
      ** If any has been set, this needs to get flagged as having indicia
 
     C                   IF        %SCAN('Y':CustIndOverDS) = 0
 
     C                   DOU       WOvrOff > WIndCnt
     C                             OR  WOvrOff = 0
     C                             OR WHasIndicia = 'Y'
     C                             OR WOvrOff = 12                                          MD033804
 
      ** Check any override as 'N' possibly invalidating
      ** system value Indicia
     C                   EVAL      WOvrOff =
     C                               %SCAN('Y':CustIndSvalDS:WOvrOff)
     C                   EVAL      WSysOff = WOvrOff
     C                   IF        WOvrOff <> 0
     C                   EVAL      WSysOff =
     C                               %SCAN('N':CustIndOverDS:WSysOff)
     C                   ENDIF
 
      ** If offsets match, system value has been overriden
     C                   IF        WSysOff <> WOvrOff
     C                             AND WOvrOff <> 0
     C                   EVAL      WHasIndicia = 'Y'
     C                   ENDIF
     C                   IF        WOvrOff <> 0
     C                   EVAL      WOvrOff = WOvrOff + 1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ELSE
     C                   EVAL      WHasIndicia = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChkIndNAHO - Check US Indicia for Non-Account Holder       *
      *                                                               *
      *****************************************************************
     C     SrChkIndNAHO  BEGSR
 
     C                   EVAL      WOvrOff = 1
     C                   EVAL      WSysOff = 0
 
      ** Check if any override flag has been set on
      ** If any has been set, this needs to get flagged as having indicia
 
     C                   IF        %SCAN('Y':NahoIndOverDS) = 0
 
     C                   DOU       WOvrOff = 0 OR
     C                             WOvrOff > WIndCnt
     C                             OR WHasIndicia = 'Y'
 
      ** Check any override as 'N' possibly invalidating
      ** system value Indicia
 
     C                   EVAL      WOvrOff =
     C                               %SCAN('Y':NahoIndSvalDS:WOvrOff)
     C                   EVAL      WSysOff = WOvrOff
     C                   IF        WOvrOff <> 0
     C                   EVAL      WSysOff =
     C                               %SCAN('N':NahoIndOverDS:WSysOff)
     C                   ENDIF
 
      ** If offsets match, system value has been overriden
     C                   IF        WSysOff <> WOvrOff
     C                             AND WOvrOff <> 0
     C                   EVAL      WHasIndicia = 'Y'
     C                   ENDIF
     C                   IF        WOvrOff <> 0
     C                   EVAL      WOvrOff = WOvrOff + 1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ELSE
     C                   EVAL      WHasIndicia = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRACUS - Access Addiotnal Customer Details                   *
      *                                                               *
      *****************************************************************
     C     SRACUS        BEGSR
 
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      FVCUST        PCUST
     C     SDACUS        PARM      SDACUS        DSLDY
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      WBthDate  = E5BRTH
     C                   EVAL      WBthCntry = E5BTHC
     C                   EVAL      WBthTown  = E5BTHT
     C                   ELSE
     C                   EVAL      WBthDate  = *ZEROS
     C                   EVAL      WBthCntry = *BLANKS
     C                   EVAL      WBthTown  = *BLANKS
     C                   ENDIF
                                                                                            MD036375
     C                   IF        PBirthDetails <> *BLANKS                                 MD036375
     C                   EVAL      WBthCntry = BirthCtry                                    MD036375
     C                   EVAL      WBthTown  = BirthTown                                    MD036375
     C                                                                                      MD036375
     C                   MOVE      BirthDate     WDayMnt                                    MD036375
     C                   MOVEL     BirthDate     WCCYY                                      MD036375
     C                   MOVE      WCCYY         WYear                                      MD036375
                                                                                            MD036375
     C                   MOVEL     WDayMnt       WMonth                                     MD036375
     C                   MOVE      WDayMnt       WDay                                       MD036375
                                                                                            MD036375
     C                   IF        BJDFIN = 'M'                                             MD036375
     C                   EVAL      DateIn = WMonth + WDay + WYear                           MD036375
     C                   ELSE                                                               MD036375
     C                   EVAL      DateIn = WDay + WMonth + WYear                           MD036375
     C                   ENDIF                                                              MD036375
                                                                                            MD036375
     C                   CALLB     'ZDATE1'                                                 MD036375
     C                   PARM                    DateIn                                     MD036375
     C                   PARM                    DaynoOut                                   MD036375
     C                   PARM                    BJDFIN                                     MD036375
     C                   PARM                    ErrorFlag                                  MD036375
                                                                                            MD036375
     C                   EVAL      WBthDate = DaynoOut                                      MD036375
     C                   ENDIF                                                              MD036375
                                                                                            MD036375
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
 
      ** Return Code
     C                   PARM                    ReturnCode
     C                   PARM                    SDVFTCS
     C                   PARM                    NwXcFilFmt                                 MD026497
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    DDACTN            1                       MD026790A
     C                   PARM                    BJDFIN            1                        MD026997
     C                   PARM                    PHasIndicia                                MD042692
     C                   PARM                    V_CUAHArr                                  MD045238
     C                   PARM                    CurCrsdDets                                  CGL157
     C                   PARM                    PCrsdS                                       CGL157
     C                   PARM                    SDVCRCS2                                     CGL157
     C                   PARM                    PFeature                                     CGL157
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DFEXMA            1
     C                   PARM                    DFEXID           30
     C                   PARM                    DDUTIN           25                        MD027064
     C                   PARM                    DDDBTH            8                        MD027064
     C                   PARM                    DDBTHT           35                        MD027064
     C                   PARM                    DDBTHC            2                        MD027064
                                                                                            MD033414
      ** Check if CGL154 is On                                                              MD033414
                                                                                            MD033414
     C                   MOVE      'N'           CGL154                                     MD033414
                                                                                            MD033414
     C                   CALL      'AOSARDR0'                                               MD033414
     C                   PARM      *BLANKS       PRTCD                                      MD033414
     C                   PARM      '*VERIFY'     POPTN                                      MD033414
     C                   PARM      'CGL154'      PSARD                                      MD033414
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD033414
                                                                                            MD033414
     C     PRTCD         IFEQ      *BLANKS                                                  MD033414
                                                                                            MD033414
     C                   EVAL      CGL154 = 'Y'                                             MD033414
                                                                                            MD033414
     C                   ELSE                                                               MD033414
                                                                                            MD033414
     C     PRTCD         IFNE      '*NRF   '                                                MD033414
                                                                                            MD033414
     C     *LOCK         IN        LDA                                                      MD033414
     C                   EVAL      DBFile = 'SCSARDPD'                                      MD033414
     C                   EVAL      DBase = 901                                              MD033414
     C                   OUT       LDA                                                      MD033414
     C                   EXSR      *PSSR                                                    MD033414
                                                                                            MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
     C                   ENDIF                                                              MD033414
 
      ** Access Bank Details                                                                  CGL157
                                                                                              CGL157
     C                   CALL      'AOBANKR0'                                                 CGL157
     C                   PARM      *BLANKS       PRtcd                                        CGL157
     C                   PARM      '*FIRST  '    POptn                                        CGL157
     C     SDBANK        PARM      SDBANK        DSFDY                                        CGL157
                                                                                              CGL157
      ** Database Error                                                                       CGL157
                                                                                              CGL157
     C                   IF        PRtcd <> *BLANK                                            CGL157
     C                   EVAL      DBKEY = POptn                                              CGL157
     C                   EVAL      DBFILE = 'SDBANKPD'                                        CGL157
     C                   EVAL      DBASE = 900                                                CGL157
     C                   EXSR      *PSSR                                                      CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2013
