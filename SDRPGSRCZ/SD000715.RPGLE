     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Exceptions Update Routine')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000715 - Midas SD Exceptions Update                        *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD051230           Date 08Jun18               *
      *  Prev Amend No. MD040734           Date 23Aug16               *
      *               . CGL177             Date 11Jan16               *
      *                 CGL157             Date 17Aug15               *
      *                 MD046248           Date 27Oct17               *
      *                 MD044164           Date 20Feb17               *
      *                 MD035150           Date 29Jul15               *
      *                 MD034071           Date 10Apr15               *
      *                 MD033804           Date 23Mar15               *
      *                 MD033414           Date 28Feb15               *
      *                 MD029839           Date 01Sep14               *
      *                 MD027115A          Date 24May14               *
      *                 MD027115           Date 22May14               *
      *                 MD026790A          Date 21May14               *
      *                 MD026790 *CREATE   Date 09May14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD051230 - Authorise of customer record in CUSD gets serious *
      *             midas error message                               *
      *  MD040734 - CRS Exception other than Due Diligence is still   *
      *             displayed                                         *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  CGL157 - CRS Reporting                                       *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD044164 - FATCA Exception 3 still present even if Customer  *
      *             Details comply w/ System Value FATCAUSTINBrthRqd  *
      *  MD035150 - Exception is bypassed by Joint Account when it is *
      *             amended                                           *
      *  MD034071 - Exception 10 not triggered properly               *
      *  MD033804 - Database error encountered when a non-account     *
      *             holder is included for FATCA reporting            *
      *  MD033414 - CGL154 amended exceptions is missing              *
      *  MD029839 - OCBC FATCA - SD000554P1 - "The customer is subject*
      *             to reporting but no US tax number is defined."    *
      *             Applied Fix MD027148                              *
      *  MD027115A- SDCUSXL0 Needs to be under Commitment Control     *
      *  MD027115 - Joint Account Exception updates                   *
      *  MD026790A - Exception Management Flag is not set             *
      *  MD026790 - Update Exceptions with JACM Updates               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDFTCSL0  UF   E           K DISK    INFSR(*PSSR)
     F**********                           COMMIT                                           MD033947
     F                                     COMMIT(PCommitCUSD)                              MD033947
 
     F***SDFTNHL0  UF   E           K DISK    INFSR(*PSSR)                                  MD051230
     F**********                           COMMIT                                           MD033947
     F**********                           COMMIT(PCommitNAHL)                     MD033947 MD051230
                                                                                              CGL157
      ** Midas SD - CRS Customer Details update                                               CGL157
     FSDCRSHL1  UF   E           K DISK    INFSR(*PSSR)                                       CGL157
                                                                                              CGL157
      ** Midas SD CRS Customer Details retrieval index                                        CGL157
     FSDCRSDL2  IF   E           K DISK    INFSR(*PSSR)                                       CGL157
                                                                                              CGL157
     FSDFTCSL1  IF   E           K DISK
     F                                     RENAME(SDFTCSD0:SDFTCSD1)
     F                                     PREFIX(J)
 
     FSDFTNHL1  IF   E           K DISK
     F                                     RENAME(SDFTNHD0:SDFTNHD1)
     F                                     PREFIX(J)
 
     FSDCUSXL0  IF   E           K DISK
     F                                     COMMIT                                          MD027115A
 
     FSDJACCL0  IF   E           K DISK
 
     FSDJACCL4  IF   E           K DISK
     F                                     RENAME(SDJACCD0:SDJACCD4)
 
     FSDJACCL7  IF   E           K DISK
     F                                     RENAME(SDJACCD0:SDJACCD7)
 
     FSDACRVL6  IF   E           K DISK
     F                                     RENAME(SDACRVD0:SDACRVD6)
 
     FSDCUAHLA  IF   E           K DISK
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Copyright Statement Array
     D CPY@            S             80A   DIM(1) CTDATA
 
      ** Local Data Area Data Structure
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
 
      ** FATCA Customer Classification Code
     D SDFATC        E DS                  EXTNAME(SDFATCPD)
 
      ** Customer Details File
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Midas Module Details Data Structure
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
                                                                                            MD033414
      ** External DS for SAR Details                                                        MD033414
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                MD033414
                                                                                              CGL157
      ** External DS for Customer Details                                                     CGL157
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CGL157
                                                                                              CGL157
      ** External DS for Country of Tax Codes                                                 CGL157
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)                                  CGL157
 
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
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
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
     D PInDate         S              8A
     D PMDate          S              5  0
     D PSARD           S              6A                                                    MD033414
     D CGL154          S              1A                                                    MD033414
     D PInEfDte        S              6A                                                      CGL157
     D PMEfDate        S              5  0                                                    CGL157
     D CGL157          S              1A                                                      CGL157
     D WCNCD           S              2A                                                      CGL157
     D WCOLC           S              2A                                                      CGL157
     D @PCTRT          S              2A                                                      CGL157
     D @PCTRR          S              2A                                                      CGL157
 
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
     D WHasIndicia     S              1A
     D WFAEXID         S             30A
     D WSysOff         S              2S 0
     D WOvrOff         S              2S 0
     D WIndCnt         C                   CONST(12)
     D WArrCnt         S              2S 0
     D WFound          S              1A
     D PCommitCUSD     S              1A                                                    MD033947
     D PCommitNAHL     S              1A                                                    MD033947
     D WSvalEftStrDte  S              6A                                                    MD033414
     D WSvalDlgNewAC   S              2  0                                                  MD033414
     D WSvalDlgMedInd  S              6A                                                    MD033414
     D WSvalDlgHiInd   S              6A                                                    MD033414
     D WSvalDlgMedEnt  S              6A                                                    MD033414
     D WSvalDlgHiEnt   S              6A                                                    MD033414
     D WDlgDt          S              5  0                                                  MD033414
      ** Define work field Work File Date                                                   MD033414
     D PIDate          S              6A                                                    MD033414
     D PODate          S              5  0                                                  MD033414
     D PErrFlag        S              1A                                                    MD033414
                                                                                              CGL157
     D WCRSEftStrtDte  S              6A                                                      CGL157
     D WCRSDlgMedInd   S              6A                                                      CGL157
     D WCRSDlgHiInd    S              6A                                                      CGL157
     D WCRSDlgMedEnt   S              6A                                                      CGL157
     D WCRSDlgHiEnt    S              6A                                                      CGL157
     D WCRSDlgNewAC    S              2  0                                                    CGL157
     D WCRSForTINMan   S              1A                                                      CGL157
     D WCRSLocTINMan   S              1A                                                      CGL157
     D WCREXMI         S             30A                                                      CGL157
     D WDDCRSA         S              1A                                                      CGL157
     D NCRSDlgMedInd   S              5  0                                                    CGL177
     D NCRSDlgHiInd    S              5  0                                                    CGL177
     D NCRSDlgMedEnt   S              5  0                                                    CGL177
     D NCRSDlgHiEnt    S              5  0                                                    CGL177
     D LowVal1         S              5  0                                                    CGL177
     D LowVal2         S              5  0                                                    CGL177
     D LowestVal       S              5  0                                                    CGL177
                                                                                              CGL157
      ** Parameter for AOCUSTR0                                                               CGL157
     D PKey1           S             10A                                                      CGL157
     D PKySt           S              7A                                                      CGL157
 
      ** Exception Report Flag Array
     D WExcpRptArr     S              1    Dim(30)
 
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Access System Values
 
     C                   EXSR      SRSVAL
 
      ** FATCA Exception Reporting for Customers
     C                   EXSR      SrExcpCust
 
     C                   IF        CGL157 = 'Y'                                               CGL157
                                                                                              CGL157
      ** Access System Values for CRS                                                         CGL157
     C                   EXSR      SRSVAL2                                                    CGL157
                                                                                              CGL157
      ** CRS Exception Reporting for Customers                                                CGL157
     C                   EXSR      SrCRSExcCust                                               CGL157
                                                                                              CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrExcpCust - FATCA Exception Reporting for Customers         *
      *                                                               *
      *****************************************************************
     C     SrExcpCust    BEGSR
 
     C     P_Cust        CHAIN     SDFTCSL0
 
     C                   IF        %FOUND(SDFTCSL0)
 
     C                   EVAL      WArrCnt = 0
 
      ** Initialize Array
     C                   EVAL      WFAEXID = *BLANKS
     C                   MOVE      *BLANKS       WExcpRptArr
 
      ** FATCA classification and US indicia are consistent
     C                   EXSR      SrCSClass
 
      ** new Customer or Non-account holder is subject to reporting
      ** but no US tax number is defined
     C                   EXSR      SrCSRepTxN
 
      ** new Customer or non-account holder is subject to reporting
      ** but no US tax number and/or date and place of birth is defined
     C                   EXSR      SrCSRepBrth
 
      ** Expiry days for a new customer or non-acocunt holder has passed
      ** and the classification is still the default value for new
      ** customer or non-account holder
     C                   EXSR      SrCSExpCls
 
      ** FATCA customer type is defined but no FATCA customer subtype
      ** defined
     C                   EXSR      SrCSSubtyp
 
      ** Customer is flagged as a participating FFI but the GIIN number
      ** information is missing
     C                   EXSR      SrCSGIINno
 
      ** Customer is flagged as a participating FFI but the GIIN
      ** verification date is blank
     C                   EXSR      SrCSGIINDt
 
      ** Customer is not exempt and is flagged as 'NFE'/Passive but
      ** ther are no controlling persons defined
     C                   EXSR      SrCSNFEiry
 
      ** Customer is not exempt and is flagged as 'Joint account'
      ** but there are no joint account members defined
     C                   EXSR      SrCSJACMbr
 
      ** Customer is not exempt, is flagged as 'joint account' and has
      ** US inidicia identified, but the individual members of the
      ** joint account do not have US indicia
     C                   EXSR      SrCSJntAcct
 
      ** FATCA inoformation is flagged as 'complete' but customer
      ** or non-account holder has still one of the default statuses
     C                   EXSR      SrCSComplt
 
      ** FATCA account review is passed due date
     C                   EXSR      SrCSActRvw
 
      ** Due diligence period is expired but FATCA information                              MD033414
      ** complete flag still set to 'No'                                                    MD033414
                                                                                            MD033414
     C                   IF        CGL154 = 'Y'                                             MD033414
                                                                                            MD033414
     C                   EXSR      SrCSDlgnce                                               MD033414
                                                                                            MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
     C                   MOVEA     WExcpRptArr   WFAEXID
 
      ** Move and update file on change in exceptions
     C                   IF        WFAEXID <> FAEXID
 
     C                   MOVEA     WExcpRptArr   FAEXID
                                                                                           MD026790A
     C                   IF        %trim(FAEXID) = *BLANKS                                 MD026790A
     C                   EVAL      FAEXMA = 'N'                                            MD026790A
     C                   ELSE                                                              MD026790A
     C                   EVAL      FAEXMA = 'Y'                                            MD026790A
     C                   ENDIF                                                             MD026790A
                                                                                           MD026790A
     C                   UPDATE    SDFTCSD0
 
     C                   ENDIF
 
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
 
     C                   EVAL      PPFTC = FACLAC
 
      ** Check classification code details of the customer
 
     C                   CALL      'AOFATCR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM                    PPFTC
     C     SDFATC        PARM      SDFATC        DSFDY
 
 
      ** US Indicia NOT allowed
     C                   IF        FCUSIA = 'N'
 
      ** Hold Mail
     C                   IF        FAHMSV = 'Y'
     C                             AND FAHMOV <> 'N'
 
      ** Mailing Country
     C                             OR  FAMCSV = 'Y'
     C                             AND FAMCOV <> 'N'
 
      ** Regular Payment Instructions to US
     C                             OR  FARPSV = 'Y'
     C                             AND FARPOV <> 'N'
 
      ** Authority Holder
     C                             OR  FAAUSV = 'Y'
     C                             AND FAAUOV <> 'N'
 
      ** US Citizenship
     C                             OR  FACISV = 'Y'
     C                             AND FACIOV <> 'N'
 
      ** US Country of Birth
     C                             OR  FACBSV = 'Y'
     C                             AND FACBOV <> 'N'
 
      ** US Country of Domicile
     C                             OR  FACDSV = 'Y'
     C                             AND FACDOV <> 'N'
 
      ** US Green Card
     C                             OR  FAGCSV = 'Y'
     C                             AND FAGCOV <> 'N'
 
      ** US Identity Document
     C                             OR  FAIDSV = 'Y'
     C                             AND FAIDOV <> 'N'
 
      ** US Joint Account Members
     C                             OR  FAJASV = 'Y'
     C                             AND FAJAOV <> 'N'
 
      ** US Telephone
     C                             OR  FATESV = 'Y'
     C                             AND FATEOV <> 'N'
 
      ** US TIN
     C                             OR  FATXSV = 'Y'
     C                             AND FATXOV <> 'N'
 
     C                   EVAL      WArrCnt = WArrCnt +1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'A'
 
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
 
     C     FACUST        CHAIN     SDCUSTX0                                                 MD035150
     C                   IF        NOT %FOUND(SDCUSXL0)                                     MD035150
     C                   EVAL      DBFILE = 'SDCUSXL0'                                      MD035150
     C                   EVAL      DBASE  = 901                                             MD035150
     C                   EVAL      DBKEY  = POPTN                                           MD035150
     C                   EXSR      *PSSR                                                    MD035150
     C                   ENDIF                                                              MD035150
                                                                                            MD035150
     C                   EVAL      PIDate = *ZERO                                           MD035150
     C                   EVAL      PODate = *ZERO                                           MD035150
                                                                                            MD035150
     C                   EVAL      PIDate = WSvalEftStrDte                                  MD035150
     C                   EXSR      SRMdasDay                                                MD035150
                                                                                            MD035150
      ** Check the US Indicia for Customer                                                  MD033414
                                                                                            MD033414
     C                   IF        CGL154 = 'Y'                                             MD033414
     C     FACUST        CHAIN     SDFTCSL1                                                 MD033414
     C                   IF        %FOUND(SDFTCSL1)                                         MD033414
     C                   EXSR      SrChkIndCust                                             MD033414
     C                   ENDIF                                                              MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
      ** Customer Subject to reporting but no US Tax defined
 
     C**********         IF        FAREPT = 'Y'                                             MD033414
     C**********                   AND FAUTIN = *BLANKS                                     MD033414
     C                   IF        (FAREPT = 'Y'                                            MD033414
     C**********                   AND FAUTIN = *BLANKS)                           MD033414 MD035150
     C                             AND FAUTIN = *BLANKS                                     MD035150
     C                             AND XCCRDT >= PODate)                                    MD035150
     C                             OR (WHasIndicia = 'Y'                                    MD033414
     C                             AND CGL154 = 'Y'                                         MD033414
     C**********                   AND FAUTIN = *BLANKS)                           MD033414 MD035150
     C                             AND FAUTIN = *BLANKS                                     MD035150
     C                             AND XCCRDT >= PODate)                                    MD035150
     C                   IF        FACSST <> 'NP' AND                                       MD027148
     C                             FARPTT <> 'R'                                            MD027148
     C                   EVAL      WArrCnt = WArrCnt +1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'B'
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
     C     FACUST        CHAIN     SDFTCSL1                                                 MD033414
     C                   IF        %FOUND(SDFTCSL1)                                         MD033414
     C                   EXSR      SrChkIndCust                                             MD033414
     C                   ENDIF                                                              MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
      ** Customer Subject to Reporting
 
     C                   IF        FAREPT = 'Y'
     C                             OR (WHasIndicia = 'Y'                                    MD033414
     C                             AND CGL154 = 'Y')                                        MD033414
     C                   IF        WSvalTinBrthRq = 'U'
     C                             AND FAUTIN = *BLANKS
 
     C                             OR WSvalTinBrthRq = 'B'
     C                             AND WBthDate = *ZERO
     C**********                   OR WSvalTinBrthRq = 'B'                                  MD044164
     C**********                   AND WBthCntry = *BLANKS                                  MD044164
     C                             OR WSvalTinBrthRq = 'B'
     C                             AND WBthTown = *BLANKS
 
     C                             OR WSvalTinBrthRq = 'Y'
     C                             AND FAUTIN = *BLANKS
     C                             OR WSvalTinBrthRq = 'Y'
     C                             AND WBthDate = *ZERO
     C**********                   OR WSvalTinBrthRq = 'Y'                                  MD044164
     C**********                   AND WBthCntry = *BLANKS                                  MD044164
     C                             OR WSvalTinBrthRq = 'Y'
     C                             AND WBthTown = *BLANKS
 
     C                   EVAL      WArrCnt = WArrCnt +1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'C'
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
 
     C     FACUST        CHAIN     SDCUSTX0
     C                   IF        NOT %FOUND(SDCUSXL0)
     C                   EVAL      DBFILE = 'SDCUSXL0'
     C                   EVAL      DBASE  = 901
     C                   EVAL      DBKEY  = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WExpiryDate = XCCRDT + WSvalExpDayDft
     C                   IF        WExpiryDate < WRUND
     C                             AND FACLAC = WSvalDftClsCde
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'D'
     C                   ENDIF
 
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
 
     C                   IF        FACSTY = 'F'
     C                             AND FACSST = *BLANKS
     C                             OR FACSTY = 'N'
     C                             AND FACSST = *BLANKS
     C                             OR FACSTY = 'F'
     C                             AND FACSST = 'UN'
     C                             OR FACSTY = 'N'
     C                             AND FACSST = 'UN'
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'E'
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
 
     C                   IF        FACSTY = 'F'
     C                             AND FACSST = 'PO'
     C                             AND FAGIIN = *BLANKS
     C                             OR FACSTY = 'F'
     C                             AND FACSST = 'PS'
     C                             AND FAGIIN = *BLANKS
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'F'
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
 
     C                   IF        FACSTY = 'F'
     C                             AND FACSST = 'PO'
     C                             AND FAGIID = *ZERO
     C                             OR FACSTY = 'F'
     C                             AND FACSST = 'PS'
     C                             AND FAGIID = *ZERO
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'G'
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
 
     C                   IF        FAEXEM <> 'Y'
     C                             AND FACSTY = 'N'
     C                             AND FACSST = 'PA'
     C     FACUST        CHAIN     SDJACCD0
     C                   IF        NOT %FOUND(SDJACCL0)
 
     C     FACUST        CHAIN     SDCUAHD0
     C                   IF        %FOUND(SDCUAHLA)
     C                             AND CACINT <> 'Y'
     C                             OR NOT %FOUND(SDCUAHLA)
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'H'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
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
 
     C                   IF        FAEXEM <> 'Y'
     C                             AND FACSTY = 'J'
     C     FACUST        CHAIN     SDJACCD0
     C                   IF        NOT %FOUND(SDJACCL0)
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'I'
     C                   ENDIF
     C                   ENDIF
 
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
     C                   IF        FAEXEM <> 'Y'
     C                             AND FACSTY = 'J'
     C                             AND FAJASV = 'Y'
     C                             AND FAJAOV <> 'Y'
     C                             OR FAEXEM <> 'Y'
     C                             AND FACSTY = 'J'
     C                             AND FAJAOV = 'Y'
 
      ** Read through Joint account members of the Customer
     C     FACUST        SETLL     SDJACCD0
     C     FACUST        READE     SDJACCD0
 
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
 
     C     FACUST        READE     SDJACCD0
     C                   ENDDO
 
     C                   IF        WHasIndicia <> 'Y'
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'J'
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
 
     C                   IF        FAINFC = 'Y'
     C                             AND WSvalDftClsCde = FACLAC
     C                             OR FAINFC = 'Y'
     C                             AND WSvalDftClsTkn = FACLAC
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'K'
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
 
     C     FACUST        SETLL     SDACRVD6
     C     FACUST        READE     SDACRVD6
 
     C                   EVAL      WFOUND = 'N'
 
     C                   DOW       NOT %EOF (SDACRVL6)
     C                             AND WFOUND = 'N'
 
     C                   IF        ARSCDT < WRUND
     C                   EVAL      WFOUND = 'Y'
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'L'
     C                   ENDIF
 
     C     FACUST        READE     SDACRVD6
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
     C                   EVAL      PIDate = WSvalEftStrDte                                  MD033414
     C                   EXSR      SRMdasDay                                                MD033414
                                                                                            MD033414
      ** New Customer                                                                       MD033414
                                                                                            MD033414
     C                   IF        XCCRDT >= PODate                                         MD033414
                                                                                            MD033414
     C                   EVAL      WDlgDt = XCCRDT + WSvalDlgNewAC                          MD033414
     C                   IF        WDlgDt <= WRUND AND                                      MD033414
     C                             FAINFC <> 'Y'                                            MD033414
     C                   EVAL      WArrCnt = WArrCnt + 1                                    MD033414
     C                   EVAL      WExcpRptArr (WArrCnt) = 'M'                              MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
     C                   ELSE                                                               MD033414
                                                                                            MD033414
      ** Existing Customer (Created before FATCA effective date)                            MD033414
                                                                                            MD033414
      ** Existing A/C - Individual/Medium                                                   MD033414
     C                   SELECT                                                             MD033414
     C                   WHEN      FACSTY = 'P' AND FAHVAC = 'M'                            MD033414
                                                                                            MD033414
     C                   MOVE      WSvalDlgMedIndPIDate                                     MD033414
     C                   EXSR      SRMdasDay                                                MD033414
                                                                                            MD033414
     C                   IF        PODate <= WRUND AND                                      MD033414
     C                             FAINFC <> 'Y'                                            MD033414
     C                   EVAL      WArrCnt = WArrCnt + 1                                    MD033414
     C                   EVAL      WExcpRptArr (WArrCnt) = 'M'                              MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
      ** Existing A/C - Individual/High                                                     MD033414
     C                   WHEN      FACSTY = 'P' AND FAHVAC = 'H'                            MD033414
                                                                                            MD033414
     C                   MOVE      WSvalDlgHiInd PIDate                                     MD033414
     C                   EXSR      SRMdasDay                                                MD033414
                                                                                            MD033414
     C                   IF        PODate <= WRUND AND                                      MD033414
     C                             FAINFC <> 'Y'                                            MD033414
     C                   EVAL      WArrCnt = WArrCnt + 1                                    MD033414
     C                   EVAL      WExcpRptArr (WArrCnt) = 'M'                              MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
      ** Existing A/C - Entity/Medium                                                       MD033414
     C                   WHEN      FACSTY <> 'P' AND FAHVAC = 'M'                           MD033414
                                                                                            MD033414
     C                   MOVE      WSvalDlgMedEntPIDate                                     MD033414
     C                   EXSR      SRMdasDay                                                MD033414
                                                                                            MD033414
     C                   IF        PODate <= WRUND AND                                      MD033414
     C                             FAINFC <> 'Y'                                            MD033414
     C                   EVAL      WArrCnt = WArrCnt + 1                                    MD033414
     C                   EVAL      WExcpRptArr (WArrCnt) = 'M'                              MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
      ** Existing A/C - Entity/High                                                         MD033414
     C                   WHEN      FACSTY <> 'P' AND FAHVAC = 'H'                           MD033414
                                                                                            MD033414
     C                   MOVE      WSvalDlgHiEnt PIDate                                     MD033414
     C                   EXSR      SRMdasDay                                                MD033414
                                                                                            MD033414
     C                   IF        PODate <= WRUND AND                                      MD033414
     C                             FAINFC <> 'Y'                                            MD033414
     C                   EVAL      WArrCnt = WArrCnt + 1                                    MD033414
     C                   EVAL      WExcpRptArr (WArrCnt) = 'M'                              MD033414
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
      /EJECT
      *****************************************************************                       CGL157
      *                                                               *                       CGL157
      *  SrCRSExcCust - CRS Exception Reporting for Customers         *                       CGL157
      *                                                               *                       CGL157
      *****************************************************************                       CGL157
     C     SrCRSExcCust  BEGSR                                                                CGL157
                                                                                              CGL157
     C     P_Cust        CHAIN     SDCRSHL1                                                   CGL157
                                                                                              CGL157
     C                   IF        %FOUND(SDCRSHL1)                                           CGL157
                                                                                              CGL157
     C                   EVAL      WArrCnt = 0                                                CGL157
                                                                                              CGL157
      ** Initialize Array                                                                     CGL157
     C                   EVAL      WCREXMI = *BLANKS                                          CGL157
     C                   MOVE      *BLANKS       WExcpRptArr                                  CGL157
                                                                                              CGL157
      ** CRS Customer is not exempt and is flagged as 'NFE'/Passive but                       CGL157
      ** there are no controlling persons defined                                             CGL157
     C                   EXSR      SrCRSNFEiry                                                CGL157
                                                                                              CGL157
      ** CRS Customer is not exempt and is flagged as 'Joint account'                         CGL157
      ** but there are no joint account members defined                                       CGL157
     C                   EXSR      SrCRSJACMbr                                                CGL157
                                                                                              CGL157
      ** CRS New Customer or Non-account holder is subject to reporting                       CGL157
      ** but no TIN is defined                                                                CGL157
     C                   EXSR      SrNewSubTIN                                                CGL157
                                                                                              CGL157
      ** CRS Existing Customer or Non-account holder is subject to reporting                  CGL157
      ** but no TIN is defined                                                                CGL157
     C                   EXSR      SrExtSubTIN                                                CGL157
                                                                                              CGL157
      ** CRS customer type is defined as NFE, but no CRS customer sub-type defined.           CGL157
     C                   EXSR      SrCRSTypeNFE                                               CGL157
                                                                                              CGL157
      ** CRS Due Diligence period has expired but the CRS Information Complete Flag           CGL157
      ** is still set to 'No' or 'Blank'                                                      CGL157
     C                   EXSR      SrCRSDueDlg                                                CGL157
                                                                                              CGL177
      ** A CRS account review is passed due date                                              CGL177
     C                   EXSR      SrCRSActRv                                                 CGL177
                                                                                              CGL157
     C                   MOVEA     WExcpRptArr   WCREXMI                                      CGL157
                                                                                              CGL157
      ** Move and update file on change in exceptions                                         CGL157
     C                   IF        WCREXMI <> CREXMI                                          CGL157
                                                                                              CGL157
     C                   MOVEA     WExcpRptArr   CREXMI                                       CGL157
                                                                                              CGL157
     C                   IF        %trim(CREXMI) = *BLANKS                                    CGL157
     C                   EVAL      CREXMG = 'N'                                               CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      CREXMG = 'Y'                                               CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   UPDATE    SDCRSHD0                                                   CGL157
                                                                                              CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ENDSR                                                                CGL157
      *****************************************************************                       CGL157
      /EJECT                                                                                  CGL157
      *****************************************************************                       CGL157
      *                                                               *                       CGL157
      *  SrCRSNFEiry - CRS Customer NFE/Passive not exempt            *                       CGL157
      *                                                               *                       CGL157
      *****************************************************************                       CGL157
     C     SrCRSNFEiry   BEGSR                                                                CGL157
                                                                                              CGL157
      ** CRS Customer is not exempt and is flagged as 'NFE'/Passive but                       CGL157
      ** there are no controlling persons defined                                             CGL157
                                                                                              CGL157
     C                   IF        CREXMP <> 'Y'                                              CGL157
     C                             AND CRTYPE = 'N'                                           CGL157
     C                             AND CRSTYP = 'PA'                                          CGL157
     C     P_Cust        CHAIN     SDJACCD0                                                   CGL157
     C                   IF        NOT %FOUND(SDJACCL0)                                       CGL157
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL157
     C                   EVAL      WExcpRptArr (WArrCnt) = 'H'                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ENDSR                                                                CGL157
      *****************************************************************                       CGL157
      /EJECT                                                                                  CGL157
      *****************************************************************                       CGL157
      *                                                               *                       CGL157
      *  SrCRSJACMbr - Customer is not Exempt and flagged as Joint A/c*                       CGL157
      *                                                               *                       CGL157
      *****************************************************************                       CGL157
     C     SrCRSJACMbr   BEGSR                                                                CGL157
                                                                                              CGL157
      ** CRS Customer is not exempt and is flagged as 'Joint account'                         CGL157
      ** but there are no joint account members defined                                       CGL157
                                                                                              CGL157
     C                   IF        CREXMP <> 'Y'                                              CGL157
     C                             AND CRTYPE = 'J'                                           CGL157
     C     CRCUST        CHAIN     SDJACCD0                                                   CGL157
     C                   IF        NOT %FOUND(SDJACCL0)                                       CGL157
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL157
     C                   EVAL      WExcpRptArr (WArrCnt) = 'I'                                CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ENDSR                                                                CGL157
      *****************************************************************                       CGL157
      /EJECT                                                                                  CGL157
      *****************************************************************                       CGL157
      *                                                               *                       CGL157
      *  SrNewSubTIN - CRS New Customer Subject to Reporting          *                       CGL157
      *                but no Tax Identification Number               *                       CGL157
      *                                                               *                       CGL157
      *****************************************************************                       CGL157
     C     SrNewSubTIN   BEGSR                                                                CGL157
                                                                                              CGL157
     C                   IF        CREXMP <> 'Y'                                            MD040734
     C                             AND CRTYPE <> 'F'                                        MD040734
     C                   EVAL      PInEfDte = WCRSEftStrtDte                                  CGL157
     C                   EXSR      SRDate1                                                    CGL157
                                                                                              CGL157
      ** Read through CRS Customer Detail File - Detail                                       CGL157
     C     P_Cust        SETLL     SDCRSDD0                                                   CGL157
     C     P_Cust        READE     SDCRSDD0                                                   CGL157
                                                                                              CGL157
     C                   DOW       NOT %EOF (SDCRSDL2)                                        CGL157
                                                                                              CGL157
      ** Retrieve first CRS Agreement                                                         CGL157
     C                   EXSR      SrRtvCRSA                                                  CGL157
                                                                                              CGL157
      ** If New Customer is Subject to Reporting but No TIN defined                           CGL157
                                                                                              CGL157
     C                   IF        (CDREPT = 'Y'                                              CGL157
     C                             AND CDTINN = *BLANKS                                       CGL157
     C                             AND XCCRDT >= PMEfDate)                                    CGL157
                                                                                              CGL157
      ** If Country has a CRS agreement, or the system value defines the TIN as mandatory     CGL157
                                                                                              CGL157
      ** If CRS Country is Local Country                                                      CGL157
     C                   IF        BJCNCD = CDCTRY                                            CGL157
                                                                                              CGL157
     C                   IF        (WDDCRSA = 'Y' OR                                          CGL157
     C                             WCRSLocTINMan = 'Y')                                       CGL157
     C                   EVAL      WArrCnt = WArrCnt +1                                       CGL157
     C                   EVAL      WExcpRptArr (WArrCnt) = 'N'                                CGL157
     C                   LEAVE                                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ELSE                                                                 CGL157
      ** If CRS Country is Foreign Country                                                    CGL157
     C                   IF        (WDDCRSA = 'Y' OR                                          CGL157
     C                             WCRSForTINMan = 'Y')                                       CGL157
     C                   EVAL      WArrCnt = WArrCnt +1                                       CGL157
     C                   EVAL      WExcpRptArr (WArrCnt) = 'N'                                CGL157
     C                   LEAVE                                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C     P_Cust        READE     SDCRSDD0                                                   CGL157
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
     C                   IF        CREXMP <> 'Y'                                            MD040734
     C                             AND CRTYPE <> 'F'                                        MD040734
     C                   EVAL      PInEfDte = WCRSEftStrtDte                                  CGL157
     C                   EXSR      SRDate1                                                    CGL157
                                                                                              CGL157
      ** Read through CRS Customer Detail File - Detail                                       CGL157
     C     P_Cust        SETLL     SDCRSDD0                                                   CGL157
     C     P_Cust        READE     SDCRSDD0                                                   CGL157
                                                                                              CGL157
     C                   DOW       NOT %EOF (SDCRSDL2)                                        CGL157
                                                                                              CGL157
      ** Retrieve first CRS Agreement                                                         CGL157
     C                   EXSR      SrRtvCRSA                                                  CGL157
                                                                                              CGL157
      ** If Existing Customer Subject to Reporting but No TIN defined                         CGL157
                                                                                              CGL157
     C                   IF        (CDREPT = 'Y'                                              CGL157
     C                             AND CDTINN = *BLANKS                                       CGL157
     C                             AND XCCRDT < PMEfDate)                                     CGL157
                                                                                              CGL157
      ** If Country has a CRS agreement, or the system value defines the TIN as mandatory     CGL157
                                                                                              CGL157
      ** If CRS Country is Local Country                                                      CGL157
     C                   IF        BJCNCD = CDCTRY                                            CGL157
                                                                                              CGL157
     C                   IF        (WDDCRSA = 'Y' OR                                          CGL157
     C                             WCRSLocTINMan = 'Y')                                       CGL157
     C                   EVAL      WArrCnt = WArrCnt +1                                       CGL157
     C                   EVAL      WExcpRptArr (WArrCnt) = 'O'                                CGL157
     C                   LEAVE                                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ELSE                                                                 CGL157
      ** If CRS Country is Foreign Country                                                    CGL157
     C                   IF        (WDDCRSA = 'Y' OR                                          CGL157
     C                             WCRSForTINMan = 'Y')                                       CGL157
     C                   EVAL      WArrCnt = WArrCnt +1                                       CGL157
     C                   EVAL      WExcpRptArr (WArrCnt) = 'O'                                CGL157
     C                   LEAVE                                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C     P_Cust        READE     SDCRSDD0                                                   CGL157
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
     C                   IF        CREXMP <> 'Y'                                            MD040734
      ** CRS customer type is defined as NFE, but no CRS customer sub-type defined            CGL157
                                                                                              CGL157
     C                   IF        (CRTYPE = 'N' AND                                          CGL157
     C                             CRSTYP = 'UN')                                             CGL157
     C                             OR (CRTYPE = 'N' AND                                       CGL157
     C                             CRSTYP = *BLANKS)                                          CGL157
     C                   EVAL      WArrCnt = WArrCnt +1                                       CGL157
     C                   EVAL      WExcpRptArr (WArrCnt) = 'P'                                CGL157
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
     C**********                   CRINFO <> 'Y'                                       CGL157 CGL177
     C                             CRINFO <> 'Y' AND CRINFO <> 'A'                            CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL157
     C                   EVAL      WExcpRptArr (WArrCnt) = 'Q'                                CGL157
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
     C                   WHEN      CRTYPE = 'P' AND CRHVAL = ' '                              CGL177
     C                             OR CRTYPE = 'P' AND CRHVAL = 'N'                           CGL177
                                                                                              CGL177
     C                   IF        LowestVal <= WRUND AND                                     CGL177
     C                             CRINFO <> 'Y' AND CRINFO <> 'A'                            CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL177
     C                   EVAL      WExcpRptArr (WArrCnt) = 'Q'                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
      ** CRS Existing A/C - Entity/Blank or Entity/N                                          CGL177
     C                   WHEN      CRTYPE <> 'P' AND CRHVAL = ' '                             CGL177
     C                             OR CRTYPE <> 'P' AND CRHVAL = 'N'                          CGL177
                                                                                              CGL177
     C                   IF        LowestVal <= WRUND AND                                     CGL177
     C                             CRINFO <> 'Y' AND CRINFO <> 'A'                            CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL177
     C                   EVAL      WExcpRptArr (WArrCnt) = 'Q'                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
      ** CRS Existing A/C - Individual/Medium  or Individual/Low                              CGL177
     C                   WHEN      CRTYPE = 'P' AND CRHVAL = 'M'                              CGL177
     C                             OR CRTYPE = 'P' AND CRHVAL = 'L'                           CGL177
                                                                                              CGL177
     C                   MOVE      WCRSDlgMedInd PIDate                                       CGL177
     C                   EXSR      SRMdasDay                                                  CGL177
                                                                                              CGL177
     C                   IF        PODate <= WRUND AND                                        CGL177
     C                             CRINFO <> 'Y' AND CRINFO <> 'A'                            CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL177
     C                   EVAL      WExcpRptArr (WArrCnt) = 'Q'                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
      ** CRS Existing A/C - Individual/High                                                   CGL177
                                                                                              CGL177
     C                   WHEN      CRTYPE = 'P' AND CRHVAL = 'H'                              CGL177
                                                                                              CGL177
     C                   MOVE      WCRSDlgHiInd  PIDate                                       CGL177
     C                   EXSR      SRMdasDay                                                  CGL177
                                                                                              CGL177
     C                   IF        PODate <= WRUND AND                                        CGL177
     C                             CRINFO <> 'Y' AND CRINFO <> 'A'                            CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL177
     C                   EVAL      WExcpRptArr (WArrCnt) = 'Q'                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
      ** CRS Existing A/C - Entity/Medium or Entity/Low                                       CGL177
     C                                                                                        CGL177
     C                   WHEN      CRTYPE <> 'P' AND CRHVAL = 'M'                             CGL177
     C                             OR CRTYPE <> 'P' AND CRHVAL = 'L'                          CGL177
                                                                                              CGL177
     C                   MOVE      WCRSDlgMedEnt PIDate                                       CGL177
     C                   EXSR      SRMdasDay                                                  CGL177
                                                                                              CGL177
     C                   IF        PODate <= WRUND AND                                        CGL177
     C                             CRINFO <> 'Y' AND CRINFO <> 'A'                            CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL177
     C                   EVAL      WExcpRptArr (WArrCnt) = 'Q'                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
      ** CRS Existing A/C - Entity/High                                                       CGL177
                                                                                              CGL177
     C                   WHEN      CRTYPE <> 'P' AND CRHVAL = 'H'                             CGL177
                                                                                              CGL177
     C                   MOVE      WCRSDlgHiEnt  PIDate                                       CGL177
     C                   EXSR      SRMdasDay                                                  CGL177
                                                                                              CGL177
     C                   IF        PODate <= WRUND AND                                        CGL177
     C                             CRINFO <> 'Y' AND CRINFO <> 'A'                            CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL177
     C                   EVAL      WExcpRptArr (WArrCnt) = 'Q'                                CGL177
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
      *****************************************************************                       CGL177
      *                                                               *                       CGL177
      *  SrCRSActRv - CRS Account Review is passed due date           *                       CGL177
      *                                                               *                       CGL177
      *****************************************************************                       CGL177
     C     SrCRSActRv    BEGSR                                                                CGL177
                                                                                              CGL177
     C                   IF        CREXMP <> 'Y'                                            MD040734
     C                             AND CRTYPE <> 'F'                                        MD040734
      ** CRS account review is passed due date                                                CGL177
                                                                                              CGL177
     C     CRCUST        SETLL     SDACRVD6                                                   CGL177
     C     CRCUST        READE     SDACRVD6                                                   CGL177
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
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C     CRCUST        READE     SDACRVD6                                                   CGL177
     C                   ENDDO                                                                CGL177
     C                   ENDIF                                                              MD040734
                                                                                              CGL177
     C                   ENDSR                                                                CGL177
      *****************************************************************                       CGL177
      /EJECT                                                                                  CGL157
      *****************************************************************                       CGL157
      *                                                               *                       CGL157
      *  SrRtvCRSA - Retrieve CRS Agreement flag for country          *                       CGL157
      *                                                               *                       CGL157
      *****************************************************************                       CGL157
     C     SrRtvCRSA     BEGSR                                                                CGL157
                                                                                              CGL157
      ** Retrieve Country of Location                                                         CGL157
     C                   Eval      PKey1 = P_Cust                                             CGL157
                                                                                              CGL157
     C                   CALL      'AOCUSTR0'                                                 CGL157
     C                   PARM      *Blanks       PRtcd                                        CGL157
     C                   PARM      '*KEY   '     POptn                                        CGL157
     C                   PARM                    PKey1                                        CGL157
     C                   PARM                    PKySt                                        CGL157
     C     SDCUST        PARM      SDCUST        DSSDY                                        CGL157
                                                                                              CGL157
      ** Database Error                                                                       CGL157
                                                                                              CGL157
     C                   IF        PRtcd <> *BLANKS                                           CGL157
     C                   EVAL      DBFILE = 'SDCUSTPD'                                        CGL157
     C                   EVAL      DBASE  =  901                                              CGL157
     C                   EVAL      DBKEY  = POptn                                             CGL157
     C                   OUT       LDA                                                        CGL157
     C                   EXSR      *PSSR                                                      CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
      ** Get CRS agreement                                                                    CGL157
     C                   EVAL      WCNCD = CDCTRY                                             CGL157
     C                   EVAL      WCOLC = BBCOLC                                             CGL157
                                                                                              CGL157
     C                   CALL      'AOCTTXR0'                                                 CGL157
     C                   PARM      *BLANKS       PRTCD                                        CGL157
     C                   PARM      '*KEY   '     POPTN                                        CGL157
     C                   PARM      WCNCD         @PCTRT                                       CGL157
     C                   PARM      WCOLC         @PCTRR                                       CGL157
     C     SDCTTX        PARM      SDCTTX        DSFDY                                        CGL157
                                                                                              CGL157
     C                   IF        PRTCD = '*NRF   '                                          CGL157
     C                   EVAL      WCOLC = *BLANK                                             CGL157
     C                   CALL      'AOCTTXR0'                                                 CGL157
     C                   PARM      *BLANKS       PRTCD                                        CGL157
     C                   PARM      '*KEY   '     POPTN                                        CGL157
     C                   PARM      WCNCD         @PCTRT                                       CGL157
     C                   PARM      WCOLC         @PCTRR                                       CGL157
     C     SDCTTX        PARM      SDCTTX        DSFDY                                        CGL157
                                                                                              CGL157
     C                   IF        PRTCD = *BLANK                                             CGL157
     C                   EVAL      WDDCRSA = EWCRSA                                           CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      WDDCRSA = *Blanks                                          CGL157
     C                   ENDIF                                                                CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      WDDCRSA = EWCRSA                                           CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ENDSR                                                                CGL157
      *****************************************************************                       CGL157
      /EJECT                                                                                  CGL157
      *****************************************************************                       CGL157
      *                                                               *                       CGL157
      *  SRDate1 - Convert Date DDMMYY to Midas Date                  *                       CGL157
      *                                                               *                       CGL157
      *****************************************************************                       CGL157
     C     SRDate1       BEGSR                                                                CGL157
                                                                                              CGL157
     C                   CALLB     'ZDATE1'                                                   CGL157
     C                   PARM                    PInEfDte                                     CGL157
     C                   PARM      *ZERO         PMEfDate                                     CGL157
     C                   PARM                    BJDFIN                                       CGL157
     C                   PARM      *BLANK        PErrFlag                                     CGL157
                                                                                              CGL157
     C                   ENDSR                                                                CGL157
      *****************************************************************                       CGL157
      /EJECT                                                                                  CGL157
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
      /EJECT                                                                                  CGL157
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
 
     C                   DOU       WOvrOff = 0 OR WOvrOff > WIndCnt
     C                             OR WHasIndicia = 'Y'
     C                             OR WOvrOff = 12                                          MD033804
 
      ** Check any override as 'N' possibly invalidating
      ** system value Indicia
     C                   EVAL      WOvrOff =
     C                               %SCAN('Y':CustIndSvalDS:WOvrOff)
     C                   EVAL      WSysOff = WOvrOff
     C                   IF        WOvrOff <> 0
     C                   EVAL      WSysOff =
     C                               %SCAN('N':CustIndOverDS:WOvrOff)
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
 
     C                   DOU       WOvrOff = 0 OR WOvrOff > WIndCnt
     C                             OR WHasIndicia = 'Y'
     C                             OR WOvrOff = 12                                          MD033804
 
      ** Check any override as 'N' possibly invalidating
      ** system value Indicia
 
     C                   EVAL      WOvrOff =
     C                               %SCAN('Y':NahoIndSvalDS:WOvrOff)
     C                   EVAL      WSysOff = WOvrOff
     C                   IF        WOvrOff <> 0                                             MD027115
     C                   EVAL      WSysOff =
     C                               %SCAN('N':NahoIndOverDS:WOvrOff)
     C                   ENDIF                                                              MD027115
 
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
     C                   PARM      FACUST        PCUST
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
 
     C                   ENDSR
      *****************************************************************
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
      *****************************************************************
      *                                                               *
      *  SRSVAL - Access System Values                                *
      *                                                               *
      *****************************************************************
     C     SRSVAL        BEGSR
 
     C                   EVAL      POP01 = 'FATCAUsTinBirthRqd'
     C                   EVAL      POP02 = 'FATCAExpDayDftClsNew'
     C                   EVAL      POP03 = 'FATCADftCLsNewCustNH'
     C                   EVAL      POP04 = 'FATCADftClsTakeon'
     C                   EVAL      POP05 = 'FATCAEffectStartDate'                           MD033414
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
     C                   MOVEL     PVL02         WSvalExpDayDft
     C                   EVAL      WSvalDftClsCde = PVL03
     C                   EVAL      WSvalDftClsTkn  = PVL04
     C                   EVAL      WSvalEftStrDte = PVL05                                   MD033414
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
      *  *PSSR - Program Exception Subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    P_Cust            6
     C                   PARM                    PCommitCUSD                                MD033947
     C                   PARM                    PCommitNAHL                                MD033947
 
      ** Access Bank details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 101
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WRUND = BJRDNB
     C                   ENDIF
 
      ** Access Midas Module details.
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDMMODPD'
     C                   EVAL      DBase = 102
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
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
     C                   EVAL      DBase = 103                                              MD033414
     C                   OUT       LDA                                                      MD033414
     C                   EXSR      *PSSR                                                    MD033414
                                                                                            MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
     C                   ENDIF                                                              MD033414
 
      ** Check if CGL157 is On                                                                CGL157
                                                                                              CGL157
     C                   MOVE      'N'           CGL157                                       CGL157
                                                                                              CGL157
     C                   CALL      'AOSARDR0'                                                 CGL157
     C                   PARM      *BLANKS       PRTCD                                        CGL157
     C                   PARM      '*VERIFY'     POPTN                                        CGL157
     C                   PARM      'CGL157'      PSARD                                        CGL157
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL157
                                                                                              CGL157
     C     PRTCD         IFEQ      *BLANKS                                                    CGL157
                                                                                              CGL157
     C                   EVAL      CGL157 = 'Y'                                               CGL157
                                                                                              CGL157
     C                   ELSE                                                                 CGL157
                                                                                              CGL157
     C     PRTCD         IFNE      '*NRF   '                                                  CGL157
                                                                                              CGL157
     C     *LOCK         IN        LDA                                                        CGL157
     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL157
     C                   EVAL      DBase = 103                                                CGL157
     C                   OUT       LDA                                                        CGL157
     C                   EXSR      *PSSR                                                      CGL157
                                                                                              CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2013
