     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Exceptions Update Routine')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000715 - Midas SD Exceptions Update                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD044164           Date 20Feb17               *
      *  Prev Amend No. MD035150           Date 29Jul15               *
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
 
     FSDFTNHL0  UF   E           K DISK    INFSR(*PSSR)
     F**********                           COMMIT                                           MD033947
     F                                     COMMIT(PCommitNAHL)                              MD033947
 
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
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2013
