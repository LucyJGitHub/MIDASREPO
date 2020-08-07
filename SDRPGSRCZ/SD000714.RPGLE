     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Exception Reporting COB Update')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000714 - Midas SD Exception Reporting COB Update           *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CSD100             Date 17Aug17               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD050212           Date 02Apr18               *
      *                 MD051233           Date 03May18               *
      *                 MD050598           Date 03May18               *
      *                 MD040734           Date 23Aug16               *
      *                 CGL177             Date 11Jan16               *
      *                 MD046248           Date 27Oct17               *
      *                 MD044164           Date 20Feb17               *
      *                 MD044160           Date 20Feb17               *
      *                 MD039670           Date 26Jul16               *
      *                 MD034071           Date 10Apr15               *
      *                 MD033501           Date 04Mar15               *
      *                 MD033414           Date 28Feb15               *
      *                 MD024916B          Date 12Feb14               *
      *                 MD029839           Date 01Sep14               *
      *                 MD026790A          Date 29May14               *
      *                 CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD100 - Patronymic and Gender fields for Non-Account Holder *
      *           (Recompile)                                         * 
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD050212 - Replication processing for SDCUSTXC (Recompile)   *
      *  MD051233 - Exception 15 is displayed with Exception 14       *
      *  MD050598 - SDC000714 00001 failed                            *
      *  MD040734 - CRS Exception other than Due Diligence is still   *
      *             displayed                                         *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD044164 - FATCA Exception 3 still present even if Customer  *
      *             Details comply w/ System Value FATCAUSTINBrthRqd  *
      *  MD044160 - FATCA exception initialization did not update     *
      *             customer exceptions                               *
      *  MD039670 - FATCA Housekeeping program                        *
      *  MD034071 - Exception 10 not triggered properly               *
      *  MD033501 - Issue on string operation                         *
      *  MD033414 - CGL154 amended exceptions is missing              *
      *  MD024916B - Issues when CGL133 is switched on                *
      *  MD029839 - OCBC FATCA - SD000554P1 - "The customer is subject*
      *             to reporting but no US tax number is defined."    *
      *             Applied Fix MD027148                              *
      *  MD026790A - Exception Management Flag is not set             *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDFTCSL0  UF   E           K DISK    INFSR(*PSSR)
 
     FSDFTNHL0  UF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD - CRS Customer Details update                                             MD036237
     FSDCRSHL1  UF   E           K DISK    INFSR(*PSSR)                                     MD036237
                                                                                            MD036237
      ** Midas SD Non-account Holders - CRS Details                                         MD036237
     FSDCRNHL1  UF   E           K DISK    INFSR(*PSSR)                                     MD036237
                                                                                            MD036237
      ** Midas SD CRS Customer Details retrieval index                                      MD036237
     FSDCRSDL2  IF   E           K DISK                                                     MD036237
                                                                                            MD036237
      ** Midas SD CRS Country details - NAHO                                                MD036237
     FSDCRSNL2  IF   E           K DISK                                                     MD036237
                                                                                            MD036237
     FSDFTCSL1  IF   E           K DISK
     F                                     RENAME(SDFTCSD0:SDFTCSD1)
     F                                     PREFIX(J)
 
     FSDFTNHL1  IF   E           K DISK
     F                                     RENAME(SDFTNHD0:SDFTNHD1)
     F                                     PREFIX(J)
 
     FSDCUSXL0  IF   E           K DISK
 
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
 
      ** Non-Account Holders File
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Midas Module Details Data Structure
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                            MD033414
      ** External DS for SAR Details                                                        MD033414
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                MD033414
                                                                                            MD036237
      ** External DS for Customer Details                                                   MD036237
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                MD036237
                                                                                            MD036237
      ** External DS for Country of Tax Codes                                               MD036237
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)                                MD036237
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
 
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
     D PNAHO           S             10A
     D PInDate         S              8A
     D PMDate          S              5  0
     D PSARD           S              6A                                                    MD033414
     D CGL154          S              1A                                                    MD033414
     D PInEfDte        S              6A                                                    MD036237
     D PMEfDate        S              5  0                                                  MD036237
     D CGL157          S              1A                                                    MD036237
     D WCNCD           S              2A                                                    MD036237
     D WCOLC           S              2A                                                    MD036237
     D @PCTRT          S              2A                                                    MD036237
     D @PCTRR          S              2A                                                    MD036237
 
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
     D WFNEXID         S             30A
     D WSysOff         S              2S 0
     D WOvrOff         S              2S 0
     D WIndCnt         C                   CONST(12)
     D WArrCnt         S              2S 0
     D WFound          S              1A
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
                                                                                            MD036237
     D WCRSEftStrtDte  S              6A                                                    MD036237
     D WCRSDlgMedInd   S              6A                                                    MD036237
     D WCRSDlgHiInd    S              6A                                                    MD036237
     D WCRSDlgMedEnt   S              6A                                                    MD036237
     D WCRSDlgHiEnt    S              6A                                                    MD036237
     D WCRSDlgNewAC    S              2  0                                                  MD036237
     D WCRSForTINMan   S              1A                                                    MD036237
     D WCRSLocTINMan   S              1A                                                    MD036237
     D WCREXMI         S             30A                                                    MD036237
     D WNREXMI         S             30A                                                    MD036237
     D WDDCRSA         S              1A                                                    MD036237
     D NCRSDlgMedInd   S              5  0                                                    CGL177
     D NCRSDlgHiInd    S              5  0                                                    CGL177
     D NCRSDlgMedEnt   S              5  0                                                    CGL177
     D NCRSDlgHiEnt    S              5  0                                                    CGL177
     D LowVal1         S              5  0                                                    CGL177
     D LowVal2         S              5  0                                                    CGL177
     D LowestVal       S              5  0                                                    CGL177
                                                                                            MD036237
      ** Parameter for AOCUSTR0                                                             MD036237
     D PKey1           S             10A                                                    MD036237
     D PKySt           S              7A                                                    MD036237
 
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
 
      ** FATCA Exception Reporting for Non-Account Holders
     C                   EXSR      SrExcpNAHO
 
     C                   IF        CGL157 = 'Y'                                             MD036237
                                                                                            MD036237
      ** Access System Values for CRS                                                       MD036237
     C                   EXSR      SRSVAL2                                                  MD036237
                                                                                            MD036237
      ** CRS Exception Reporting for Customers                                              MD036237
     C                   EXSR      SrCRSExcCust                                             MD036237
                                                                                            MD036237
      ** CRS Exception Reporting for Non-Account Holders                                    MD036237
     C                   EXSR      SrCRSExcNAHO                                             MD036237
                                                                                            MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
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
 
     C     *LOVAL        SETLL     SDFTCSL0
     C                   READ      SDFTCSL0
 
     C                   DOW       NOT %EOF(SDFTCSL0)
 
     C                   EVAL      WArrCnt = 0
 
      ** Initialize Array
     C                   EVAL      WFAEXID = *BLANKS
     C                   EVAL      WHasIndicia = 'N'                                        MD033414
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
 
     C                   READ      SDFTCSL0
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrExcpNAHO - FATCA Exception Reporting for Non-Account Holder*
      *                                                               *
      *****************************************************************
     C     SrExcpNAHO    BEGSR
 
      ** FATCA Information for Non-Account Holders
 
     C     *LOVAL        SETLL     SDFTNHL0
     C                   READ      SDFTNHL0
 
     C                   DOW       NOT %EOF(SDFTNHL0)
                                                                                            MD039670
     C                   IF        FNNAHO <> *BLANKS                                        MD039670
     C                   CALL      'AONAHOR0'                                               MD039670
     C                   PARM      *BLANKS       PRTCD                                      MD039670
     C                   PARM      '*KEY   '     POPTN                                      MD039670
     C                   PARM      FNNAHO        PNAHO                                      MD039670
     C*****SDNAHO        PARM      SDNAHO        DSSDY                             MD039670 MD051233
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      MD051233
                                                                                            MD039670
     C                   IF        PRTCD = '*NRF'                                           MD039670
     C                             OR NHCHTP = 'D'                                          MD039670
     C                   READ      SDFTNHL0                                                 MD039670
     C                   ITER                                                               MD039670
     C                   ENDIF                                                              MD039670
     C                   ENDIF                                                              MD039670
 
     C                   EVAL      WArrCnt = 0
 
      ** Initialize Array
     C                   EVAL      WFNEXID = *BLANKS
     C                   EVAL      WHasIndicia = 'N'                                        MD033414
     C                   MOVE      *BLANKS       WExcpRptArr
 
      ** FATCA classification and US indicia are consistent
     C                   EXSR      SrNHClass
 
      ** new Customer or Non-account holder is subject to reporting
      ** but no US tax number is defined
     C                   EXSR      SrNHRepTxN
 
      ** new Customer or non-account holder is subject to reporting
      ** but no US tax number and/or date and place of birth is defined
     C                   EXSR      SrNHRepBrth
 
      ** Expiry days for a new customer or non-acocunt holder has passed
      ** and the classification is still the default value for new
      ** customer or non-account holder
     C                   EXSR      SrNHExpCls
 
      ** FATCA customer type is defined but no FATCA customer subtype
      ** defined
     C                   EXSR      SrNHSubtyp
 
      ** Customer is flagged as a participating FFI but the GIIN number
      ** information is missing
     C                   EXSR      SrNHGIINno
 
      ** Customer is flagged as a participating FFI but the GIIN
      ** verification date is blank
     C                   EXSR      SrNHGIINDt
 
      ** FATCA inoformation is flagged as 'complete' but customer
      ** or non-account holder has still one of the default statuses
     C                   EXSR      SrNHComplt
 
      ** Due diligence period is expired but FATCA information                              MD033414
      ** complete flag still set to 'No'                                                    MD033414
                                                                                            MD033414
     C                   IF        CGL154 = 'Y'                                             MD033414
                                                                                            MD033414
     C                   EXSR      SrNHDlgnce                                               MD033414
                                                                                            MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
     C                   MOVEA     WExcpRptArr   WFNEXID
 
      ** Move and update file on change in exceptions
     C                   IF        WFNEXID <> FNEXID
     C                   MOVEA     WExcpRptArr   FNEXID
                                                                                            MD033414
     C                   IF        FNEXID = *BLANKS                                         MD033414
     C                   EVAL      FNEXMA = 'N'                                             MD033414
     C                   ELSE                                                               MD033414
     C                   EVAL      FNEXMA = 'Y'                                             MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
     C                   UPDATE    SDFTNHD0
     C                   ENDIF
 
     C                   READ      SDFTNHL0
 
     C                   ENDDO
 
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
                                                                                            MD033414
     C     FACUST        CHAIN     SDCUSTX0                                                 MD033414
     C                   IF        NOT %FOUND(SDCUSXL0)                                     MD033414
     C                   EVAL      DBFILE = 'SDCUSXL0'                                      MD033414
     C                   EVAL      DBASE  = 901                                             MD033414
     C                   EVAL      DBKEY  = POPTN                                           MD033414
     C                   EXSR      *PSSR                                                    MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
     C                   EVAL      PIDate = *ZERO                                           MD033414
     C                   EVAL      PODate = *ZERO                                           MD033414
                                                                                            MD033414
     C                   EVAL      PIDate = WSvalEftStrDte                                  MD033414
     C                   EXSR      SRMdasDay                                                MD033414
 
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
     C                             AND FAUTIN = *BLANKS                                     MD033414
     C                             AND XCCRDT >= PODate)                                    MD033414
     C                             OR (WHasIndicia = 'Y'                                    MD033414
     C                             AND CGL154 = 'Y'                                         MD033414
     C                             AND FAUTIN = *BLANKS                                     MD033414
     C                             AND XCCRDT >= PODate)                                    MD033414
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
 
     C*****FACUST        CHAIN     SDCUSTX0                                                 MD033414
     C**********         IF        NOT %FOUND(SDCUSXL0)                                     MD033414
     C**********         EVAL      DBFILE = 'SDCUSXL0'                                      MD033414
     C**********         EVAL      DBASE  = 901                                             MD033414
     C**********         EVAL      DBKEY  = POPTN                                           MD033414
     C**********         EXSR      *PSSR                                                    MD033414
     C**********         ENDIF                                                              MD033414
 
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
     C                                                                                      MD033414
     C                   ELSE                                                               MD033414
                                                                                            MD033414
      ** Existing Customer (Created before FATCA effective Date)                            MD033414
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
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNHClass - FATCA Classification and US Indicia              *
      *                                                               *
      *****************************************************************
     C     SrNHClass     BEGSR
 
     C                   EVAL      PPFTC = FNCLAC
 
      ** Check classification code details of the Non-Account Holder
 
     C                   CALL      'AOFATCR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM                    PPFTC
     C     SDFATC        PARM      SDFATC        DSFDY
 
      ** US Indicia NOT allowed
     C                   IF        FCUSIA = 'N'
 
      ** Hold Mail
     C                   IF        FNHMSV = 'Y'
     C                             AND FNHMOV <> 'N'
 
      ** Mailing Country
     C                             OR  FNMCSV = 'Y'
     C                             AND FNMCOV <> 'N'
 
      ** Regular Payment Instructions to US
     C                             OR  FNRPSV = 'Y'
     C                             AND FNRPOV <> 'N'
 
      ** Authority Holder
     C                             OR  FNAUSV = 'Y'
     C                             AND FNAUOV <> 'N'
 
      ** US Citizenship
     C                             OR  FNCISV = 'Y'
     C                             AND FNCIOV <> 'N'
 
      ** US Country of Birth
     C                             OR  FNCBSV = 'Y'
     C                             AND FNCBOV <> 'N'
 
      ** US Country of Domicile
     C                             OR  FNCDSV = 'Y'
     C                             AND FNCDOV <> 'N'
 
      ** US Green Card
     C                             OR  FNGCSV = 'Y'
     C                             AND FNGCOV <> 'N'
 
      ** US Identity Document
     C                             OR  FNIDSV = 'Y'
     C                             AND FNIDOV <> 'N'
 
      ** US Joint Account Members
     C                             OR  FNJASV = 'Y'
     C                             AND FNJAOV <> 'N'
 
      ** US Telephone
     C                             OR  FNTESV = 'Y'
     C                             AND FNTEOV <> 'N'
 
      ** US TIN
     C                             OR  FNTXSV = 'Y'
     C                             AND FNTXOV <> 'N'
 
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'A'
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNHRepTxN - Subject to Reporting but no Tax Number          *
      *                                                               *
      *****************************************************************
     C     SrNHRepTxN    BEGSR
                                                                                            MD033414
      ** Check creation date                                                                MD033414
                                                                                            MD033414
     C     FNNAHO        CHAIN     SDNAHOD0                                                 MD033414
     C                   IF        NOT %FOUND(SDNAHOL0)                                     MD033414
     C                   EVAL      DBFILE = 'SDNAHOPD'                                      MD033414
     C                   EVAL      DBASE  = 901                                             MD033414
     C                   EVAL      DBKEY  = POPTN                                           MD033414
     C                   EXSR      *PSSR                                                    MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
     C                   EVAL      PInDate = NHCRDT                                         MD033414
     C                   EXSR      SRDate10                                                 MD033414
                                                                                            MD033414
     C                   EVAL      PIDate = WSvalEftStrDte                                  MD033414
     C                   EXSR      SRMdasDay                                                MD033414
 
      ** Check the US Indicia for NAHO                                                      MD033414
                                                                                            MD033414
     C                   IF        CGL154 = 'Y'                                             MD033414
     C     FNNAHO        CHAIN     SDFTNHL1                                                 MD033414
     C                   IF        %FOUND(SDFTNHL1)                                         MD033414
     C                   EXSR      SrChkIndNaho                                             MD033414
     C                   ENDIF                                                              MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
      ** Non-Account Holder Subject to reporting but no US Tax defined
 
     C**********         IF        FNREPT = 'Y'                                             MD033414
     C**********                   AND FNUTIN = *BLANKS                                     MD033414
     C                   IF        (FNREPT = 'Y'                                            MD033414
     C                             AND FNUTIN = *BLANKS                                     MD033414
     C                             AND PMDate >= PODate)                                    MD033414
     C                             OR (WHasIndicia = 'Y'                                    MD033414
     C                             AND CGL154 = 'Y'                                         MD033414
     C                             AND FNUTIN = *BLANKS                                     MD033414
     C                             AND PMDate >= PODate)                                    MD033414
     C                   IF        FNNHST <> 'NP' AND                                       MD027148
     C                             FNRPTT <> 'R'                                            MD027148
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'B'
     C                   ENDIF                                                              MD027148
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNHRepBrth - Subject to Reporting but no Date and Place     *
      *                of Birth                                       *
      *                                                               *
      *****************************************************************
     C     SrNHRepBrth   BEGSR
 
      ** Access Non-Account Holder Details for Date and Place of Birth
 
     C                   EXSR      SRNAHO
 
      ** Check the US Indicia for NAHO                                                      MD033414
                                                                                            MD033414
     C                   IF        CGL154 = 'Y'                                             MD033414
     C     FNNAHO        CHAIN     SDFTNHL1                                                 MD033414
     C                   IF        %FOUND(SDFTNHL1)                                         MD033414
     C                   EXSR      SrChkIndNaho                                             MD033414
     C                   ENDIF                                                              MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
      ** Subject to Reporting
 
     C                   IF        FNREPT = 'Y'
     C                             OR (WHasIndicia = 'Y'                                    MD033414
     C                             AND CGL154 = 'Y')                                        MD033414
     C                   IF        WSvalTinBrthRq = 'U'
     C                             AND FNUTIN = *BLANKS
 
     C                             OR WSvalTinBrthRq = 'B'
     C                             AND WBthDateA = *BLANKS
     C**********                   OR WSvalTinBrthRq = 'B'                                  MD044164
     C**********                   AND WBthCntry = *BLANKS                                  MD044164
     C                             OR WSvalTinBrthRq = 'B'
     C                             AND WBthTown = *BLANKS
 
     C                             OR WSvalTinBrthRq = 'Y'
     C                             AND FNUTIN = *BLANKS
     C                             OR WSvalTinBrthRq = 'Y'
     C                             AND WBthDateA = *BLANKS
     C**********                   OR WSvalTinBrthRq = 'Y'                                  MD044164
     C**********                   AND WBthCntry = *BLANKS                                  MD044164
     C                             OR WSvalTinBrthRq = 'Y'
     C                             AND WBthTown = *BLANKS
 
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'C'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNHExpCls - Expiry days has passed                          *
      *                                                               *
      *****************************************************************
     C     SrNHExpCls    BEGSR
 
      ** Check creation date
 
     C*****FNNAHO        CHAIN     SDNAHOD0                                                 MD033414
     C**********         IF        NOT %FOUND(SDNAHOL0)                                     MD033414
     C**********         EVAL      DBFILE = 'SDNAHOPD'                                      MD033414
     C**********         EVAL      DBASE  = 901                                             MD033414
     C**********         EVAL      DBKEY  = POPTN                                           MD033414
     C**********         EXSR      *PSSR                                                    MD033414
     C**********         ENDIF                                                              MD033414
 
     C**********         EVAL      PInDate = NHCRDT                                         MD033414
     C**********         EXSR      SRDate10                                                 MD033414
 
     C                   EVAL      WExpiryDate = PMDate + WSvalExpDayDft
     C                   IF        WExpiryDate < WRUND
     C                             AND FNCLAC = WSvalDftClsCde
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'D'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNHSubtyp - FATCA NAHO Type is define but no subtype        *
      *                                                               *
      *****************************************************************
     C     SrNHSubtyp    BEGSR
 
      ** FATCA Customer Type is 'F' (FFI) or 'N' (NFE)
      ** but no FATCA Subtype defined
 
     C                   IF        FNNHTY = 'F'
     C                             AND FNNHST = *BLANKS
     C                             OR FNNHTY = 'N'
     C                             AND FNNHST = *BLANKS
     C                             OR FNNHTY = 'F'
     C                             AND FNNHST = 'UN'
     C                             OR FNNHTY = 'N'
     C                             AND FNNHST = 'UN'
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'E'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNHGIINno - Non-Account Holder is participating but no      *
      *               GIIN number                                     *
      *                                                               *
      *****************************************************************
     C     SrNHGIINno    BEGSR
 
      ** Naho is flagged as a participating FFI but the GIIN number
      ** information is missing
 
     C                   IF        FNNHTY = 'F'
     C                             AND FNNHST = 'PO'
     C                             AND FNGIIN = *BLANKS
     C                             OR FNNHTY = 'F'
     C                             AND FNNHST = 'PS'
     C                             AND FNGIIN = *BLANKS
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'F'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNHGIINDt - Non-Account Holder is participating but         *
      *               no GIIN date                                    *
      *                                                               *
      *****************************************************************
     C     SrNHGIINDt    BEGSR
 
     C                   IF        FNNHTY = 'F'
     C                             AND FNNHST = 'PO'
     C                             AND FNGIID = *ZERO
     C                             OR FNNHTY = 'F'
     C                             AND FNNHST = 'PS'
     C                             AND FNGIID = *ZERO
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'G'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNHComplt - FATCA Info is Complete                          *
      *                                                               *
      *****************************************************************
     C     SrNHComplt    BEGSR
 
      ** FATCA inoformation is flagged as 'complete' but non-account
      ** holder has still one of the default statuses
 
     C                   IF        FNINFC = 'Y'
     C                             AND WSvalDftClsCde = FNCLAC
     C                             OR FNINFC = 'Y'
     C                             AND WSvalDftClsTkn = FNCLAC
     C                   EVAL      WArrCnt = WArrCnt + 1
     C                   EVAL      WExcpRptArr (WArrCnt) = 'K'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                MD033414
      *****************************************************************                     MD033414
      *                                                               *                     MD033414
      *  SrNHDlgnce - FATCA NAHO Diligence Check                      *                     MD033414
      *                                                               *                     MD033414
      *****************************************************************                     MD033414
     C     SrNHDlgnce    BEGSR                                                              MD033414
                                                                                            MD033414
     C                   EVAL      PIDate = *ZERO                                           MD033414
     C                   EVAL      PODate = *ZERO                                           MD033414
                                                                                            MD033414
     C                   EVAL      PInDate = NHCRDT                                         MD033414
     C                   EXSR      SRDate10                                                 MD033414
                                                                                            MD033414
     C                   EVAL      PIDate = WSvalEftStrDte                                  MD033414
     C                   EXSR      SRMdasDay                                                MD033414
                                                                                            MD033414
      ** New Non-Account Holder                                                             MD033414
                                                                                            MD033414
     C                   IF        PMDate >= PODate                                         MD033414
                                                                                            MD033414
     C                   EVAL      WDlgDt = PMDate + WSvalDlgNewAC                          MD033414
     C                   IF        WDlgDt <= WRUND AND                                      MD033414
     C                             FNINFC <> 'Y'                                            MD033414
     C                   EVAL      WArrCnt = WArrCnt + 1                                    MD033414
     C                   EVAL      WExcpRptArr (WArrCnt) = 'M'                              MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
     C                   ELSE                                                               MD033414
                                                                                            MD033414
      ** Existing Non-Account Holder (Created before FATCA effective date)                  MD033414
                                                                                            MD033414
      ** Existing A/C - Individual/Medium                                                   MD033414
                                                                                            MD033414
     C                   SELECT                                                             MD033414
                                                                                            MD033414
     C                   WHEN      FNNHTY = 'P' AND FNHVAC = 'M'                            MD033414
                                                                                            MD033414
     C                   MOVE      WSvalDlgMedIndPIDate                                     MD033414
     C                   EXSR      SRMdasDay                                                MD033414
                                                                                            MD033414
     C                   IF        PODate <= WRUND AND                                      MD033414
     C                             FNINFC <> 'Y'                                            MD033414
     C                   EVAL      WArrCnt = WArrCnt + 1                                    MD033414
     C                   EVAL      WExcpRptArr (WArrCnt) = 'M'                              MD033414
                                                                                            MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
      ** Existing A/C - Individual/High                                                     MD033414
                                                                                            MD033414
     C                   WHEN      FNNHTY = 'P' AND FNHVAC = 'H'                            MD033414
                                                                                            MD033414
     C                   MOVE      WSvalDlgHiInd PIDate                                     MD033414
     C                   EXSR      SRMdasDay                                                MD033414
                                                                                            MD033414
     C                   IF        PODate <= WRUND AND                                      MD033414
     C                             FNINFC <> 'Y'                                            MD033414
     C                   EVAL      WArrCnt = WArrCnt + 1                                    MD033414
     C                   EVAL      WExcpRptArr (WArrCnt) = 'M'                              MD033414
                                                                                            MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
      ** Existing A/C - Entity/Medium                                                       MD033414
                                                                                            MD033414
     C                   WHEN      FNNHTY <> 'P' AND FNHVAC = 'M'                           MD033414
                                                                                            MD033414
     C                   MOVE      WSvalDlgMedEntPIDate                                     MD033414
     C                   EXSR      SRMdasDay                                                MD033414
                                                                                            MD033414
     C                   IF        PODate <= WRUND AND                                      MD033414
     C                             FNINFC <> 'Y'                                            MD033414
     C                   EVAL      WArrCnt = WArrCnt + 1                                    MD033414
     C                   EVAL      WExcpRptArr (WArrCnt) = 'M'                              MD033414
                                                                                            MD033414
     C                   ENDIF                                                              MD033414
                                                                                            MD033414
      ** Existing A/C - Entity/High                                                         MD033414
                                                                                            MD033414
     C                   WHEN      FNNHTY <> 'P' AND FNHVAC = 'H'                           MD033414
                                                                                            MD033414
     C                   MOVE      WSvalDlgHiEnt PIDate                                     MD033414
     C                   EXSR      SRMdasDay                                                MD033414
                                                                                            MD033414
     C                   IF        PODate <= WRUND AND                                      MD033414
     C                             FNINFC <> 'Y'                                            MD033414
     C                   EVAL      WArrCnt = WArrCnt + 1                                    MD033414
     C                   EVAL      WExcpRptArr (WArrCnt) = 'M'                              MD033414
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
      *****************************************************************                     MD036237
      *                                                               *                     MD036237
      *  SrCRSExcCust - CRS Exception Reporting for Customers         *                     MD036237
      *                                                               *                     MD036237
      *****************************************************************                     MD036237
     C     SrCRSExcCust  BEGSR                                                              MD036237
                                                                                            MD036237
     C     *LOVAL        SETLL     SDCRSHL1                                                 MD036237
     C                   READ      SDCRSHL1                                                 MD036237
                                                                                            MD036237
     C                   DOW       NOT %EOF(SDCRSHL1)                                       MD036237
                                                                                            MD036237
     C                   EVAL      WArrCnt = 0                                              MD036237
                                                                                            MD036237
      ** Initialize Array                                                                   MD036237
     C                   EVAL      WCREXMI = *BLANKS                                        MD036237
     C                   MOVE      *BLANKS       WExcpRptArr                                MD036237
                                                                                           MD036237A
      ** Check creation date                                                               MD036237A
                                                                                           MD036237A
     C     CRCUST        CHAIN     SDCUSTX0                                                MD036237A
     C                   IF        NOT %FOUND(SDCUSXL0)                                    MD036237A
     C                   EVAL      DBFILE = 'SDCUSXL0'                                     MD036237A
     C                   EVAL      DBASE  = 902                                            MD036237A
     C                   EVAL      DBKEY  = POPTN                                          MD036237A
     C                   EXSR      *PSSR                                                   MD036237A
     C                   ENDIF                                                             MD036237A
                                                                                            MD036237
      ** CRS Customer is not exempt and is flagged as 'NFE'/Passive but                     MD036237
      ** there are no controlling persons defined                                           MD036237
     C                   EXSR      SrCRSNFEiry                                              MD036237
                                                                                            MD036237
      ** CRS Customer is not exempt and is flagged as 'Joint account'                       MD036237
      ** but there are no joint account members defined                                     MD036237
     C                   EXSR      SrCRSJACMbr                                              MD036237
                                                                                            MD036237
      ** CRS New Customer or Non-account holder is subject to reporting                     MD036237
      ** but no TIN is defined                                                              MD036237
     C                   EXSR      SrNewSubTIN                                              MD036237
                                                                                            MD036237
      ** CRS Existing Customer or Non-account holder is subject to reporting                MD036237
      ** but no TIN is defined                                                              MD036237
     C                   EXSR      SrExtSubTIN                                              MD036237
                                                                                            MD036237
      ** CRS customer type is defined as NFE, but no CRS customer sub-type defined.         MD036237
     C                   EXSR      SrCRSTypeNFE                                             MD036237
                                                                                            MD036237
      ** CRS Due Diligence period has expired but the CRS Information Complete Flag         MD036237
      ** is still set to 'No' or 'Blank'                                                    MD036237
     C                   EXSR      SrCRSDueDlg                                              MD036237
                                                                                              CGL177
      ** A CRS account review is passed due date                                              CGL177
     C                   EXSR      SrCRSActRv                                                 CGL177
                                                                                            MD036237
     C                   MOVEA     WExcpRptArr   WCREXMI                                    MD036237
                                                                                            MD036237
      ** Move and update file on change in exceptions                                       MD036237
     C                   IF        WCREXMI <> CREXMI                                        MD036237
                                                                                            MD036237
     C                   MOVEA     WExcpRptArr   CREXMI                                     MD036237
                                                                                            MD036237
     C                   IF        %trim(CREXMI) = *BLANKS                                  MD036237
     C                   EVAL      CREXMG = 'N'                                             MD036237
     C                   ELSE                                                               MD036237
     C                   EVAL      CREXMG = 'Y'                                             MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   UPDATE    SDCRSHD0                                                 MD036237
                                                                                            MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   READ      SDCRSHL1                                                 MD036237
                                                                                            MD036237
     C                   ENDDO                                                              MD036237
                                                                                            MD036237
     C                   ENDSR                                                              MD036237
      *****************************************************************                     MD036237
      /EJECT                                                                                MD036237
      *****************************************************************                     MD036237
      *                                                               *                     MD036237
      *  SrCRSNFEiry - CRS Customer NFE/Passive not exempt            *                     MD036237
      *                                                               *                     MD036237
      *****************************************************************                     MD036237
     C     SrCRSNFEiry   BEGSR                                                              MD036237
                                                                                            MD036237
      ** CRS Customer is not exempt and is flagged as 'NFE'/Passive but                     MD036237
      ** there are no controlling persons defined                                           MD036237
                                                                                            MD036237
     C                   IF        CREXMP <> 'Y'                                            MD036237
     C                             AND CRTYPE = 'N'                                         MD036237
     C                             AND CRSTYP = 'PA'                                        MD036237
     C     CRCUST        CHAIN     SDJACCD0                                                 MD036237
     C                   IF        NOT %FOUND(SDJACCL0)                                     MD036237
                                                                                              CGL177
     C     CRCUST        CHAIN     SDCUAHD0                                                   CGL177
     C                   IF        %FOUND(SDCUAHLA)                                           CGL177
     C                             AND CACINT <> 'Y'                                          CGL177
     C                             OR NOT %FOUND(SDCUAHLA)                                    CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                    MD036237
     C                   EVAL      WExcpRptArr (WArrCnt) = 'H'                              MD036237
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   ENDSR                                                              MD036237
      *****************************************************************                     MD036237
      /EJECT                                                                                MD036237
      *****************************************************************                     MD036237
      *                                                               *                     MD036237
      *  SrCRSJACMbr - Customer is not Exempt and flagged as Joint A/c*                     MD036237
      *                                                               *                     MD036237
      *****************************************************************                     MD036237
     C     SrCRSJACMbr   BEGSR                                                              MD036237
                                                                                            MD036237
      ** CRS Customer is not exempt and is flagged as 'Joint account'                       MD036237
      ** but there are no joint account members defined                                     MD036237
                                                                                            MD036237
     C                   IF        CREXMP <> 'Y'                                            MD036237
     C                             AND CRTYPE = 'J'                                         MD036237
     C     CRCUST        CHAIN     SDJACCD0                                                 MD036237
     C                   IF        NOT %FOUND(SDJACCL0)                                     MD036237
     C                   EVAL      WArrCnt = WArrCnt + 1                                    MD036237
     C                   EVAL      WExcpRptArr (WArrCnt) = 'I'                              MD036237
     C                   ENDIF                                                              MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   ENDSR                                                              MD036237
      *****************************************************************                     MD036237
      /EJECT                                                                                MD036237
      *****************************************************************                     MD036237
      *                                                               *                     MD036237
      *  SrNewSubTIN - CRS New Customer Subject to Reporting          *                     MD036237
      *                but no Tax Identification Number               *                     MD036237
      *                                                               *                     MD036237
      *****************************************************************                     MD036237
     C     SrNewSubTIN   BEGSR                                                              MD036237
                                                                                            MD036237
     C                   IF        CREXMP <> 'Y'                                            MD040734
     C                             AND CRTYPE <> 'F'                                        MD040734
     C                   EVAL      PInEfDte = WCRSEftStrtDte                                MD036237
     C                   EXSR      SRDate1                                                  MD036237
                                                                                            MD036237
      ** Read through CRS Customer Detail File - Detail                                     MD036237
     C     CRCUST        SETLL     SDCRSDD0                                                 MD036237
     C     CRCUST        READE     SDCRSDD0                                                 MD036237
                                                                                            MD036237
     C                   DOW       NOT %EOF (SDCRSDL2)                                      MD036237
                                                                                            MD036237
      ** Retrieve first CRS Agreement                                                       MD036237
     C                   EXSR      SrRtvCRSAC                                               MD036237
                                                                                            MD036237
      ** If New Customer is Subject to Reporting but No TIN defined                         MD036237
                                                                                            MD036237
     C                   IF        (CDREPT = 'Y'                                            MD036237
     C                             AND CDTINN = *BLANKS                                     MD036237
     C                             AND XCCRDT >= PMEfDate)                                  MD036237
                                                                                            MD036237
      ** If Country has a CRS agreement, or the system value defines the TIN as mandatory   MD036237
                                                                                            MD036237
      ** If CRS Country is Local Country                                                    MD036237
     C                   IF        BJCNCD = CDCTRY                                          MD036237
                                                                                            MD036237
     C                   IF        (WDDCRSA = 'Y' OR                                        MD036237
     C                             WCRSLocTINMan = 'Y')                                     MD036237
     C                   EVAL      WArrCnt = WArrCnt +1                                     MD036237
     C                   EVAL      WExcpRptArr (WArrCnt) = 'N'                              MD036237
     C                   LEAVE                                                              MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   ELSE                                                               MD036237
      ** If CRS Country is Foreign Country                                                  MD036237
     C                   IF        (WDDCRSA = 'Y' OR                                        MD036237
     C                             WCRSForTINMan = 'Y')                                     MD036237
     C                   EVAL      WArrCnt = WArrCnt +1                                     MD036237
     C                   EVAL      WExcpRptArr (WArrCnt) = 'N'                              MD036237
     C                   LEAVE                                                              MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C     CRCUST        READE     SDCRSDD0                                                 MD036237
     C                   ENDDO                                                              MD036237
     C                   ENDIF                                                              MD040734
                                                                                            MD036237
     C                   ENDSR                                                              MD036237
      *****************************************************************                     MD036237
      /EJECT                                                                                MD036237
      *****************************************************************                     MD036237
      *                                                               *                     MD036237
      *  SrExtSubTIN - CRS Existing Customer Subject to Reporting     *                     MD036237
      *                but no Tax Identification Number               *                     MD036237
      *                                                               *                     MD036237
      *****************************************************************                     MD036237
     C     SrExtSubTIN   BEGSR                                                              MD036237
                                                                                            MD036237
     C                   IF        CREXMP <> 'Y'                                            MD040734
     C                             AND CRTYPE <> 'F'                                        MD040734
     C                   EVAL      PInEfDte = WCRSEftStrtDte                                MD036237
     C                   EXSR      SRDate1                                                  MD036237
                                                                                            MD036237
      ** Read through CRS Customer Detail File - Detail                                     MD036237
     C     CRCUST        SETLL     SDCRSDD0                                                 MD036237
     C     CRCUST        READE     SDCRSDD0                                                 MD036237
                                                                                            MD036237
     C                   DOW       NOT %EOF (SDCRSDL2)                                      MD036237
                                                                                            MD036237
      ** Retrieve first CRS Agreement                                                       MD036237
     C                   EXSR      SrRtvCRSAC                                               MD036237
                                                                                            MD036237
      ** If Existing Customer Subject to Reporting but No TIN defined                       MD036237
                                                                                            MD036237
     C                   IF        (CDREPT = 'Y'                                            MD036237
     C                             AND CDTINN = *BLANKS                                     MD036237
     C                             AND XCCRDT < PMEfDate)                                   MD036237
                                                                                            MD036237
      ** If Country has a CRS agreement, or the system value defines the TIN as mandatory   MD036237
                                                                                            MD036237
      ** If CRS Country is Local Country                                                    MD036237
     C                   IF        BJCNCD = CDCTRY                                          MD036237
                                                                                            MD036237
     C                   IF        (WDDCRSA = 'Y' OR                                        MD036237
     C                             WCRSLocTINMan = 'Y')                                     MD036237
     C                   EVAL      WArrCnt = WArrCnt +1                                     MD036237
     C                   EVAL      WExcpRptArr (WArrCnt) = 'O'                              MD036237
     C                   LEAVE                                                              MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   ELSE                                                               MD036237
      ** If CRS Country is Foreign Country                                                  MD036237
     C                   IF        (WDDCRSA = 'Y' OR                                        MD036237
     C                             WCRSForTINMan = 'Y')                                     MD036237
     C                   EVAL      WArrCnt = WArrCnt +1                                     MD036237
     C                   EVAL      WExcpRptArr (WArrCnt) = 'O'                              MD036237
     C                   LEAVE                                                              MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C     CRCUST        READE     SDCRSDD0                                                 MD036237
     C                   ENDDO                                                              MD036237
     C                   ENDIF                                                              MD040734
                                                                                            MD036237
     C                   ENDSR                                                              MD036237
      *****************************************************************                     MD036237
      /EJECT                                                                                MD036237
      *****************************************************************                     MD036237
      *                                                               *                     MD036237
      *  SrCRSTypeNFE - CRS customer type is defined as NFE, but no   *                     MD036237
      *                 CRS customer sub-type defined.                *                     MD036237
      *                                                               *                     MD036237
      *****************************************************************                     MD036237
     C     SrCRSTypeNFE  BEGSR                                                              MD036237
                                                                                            MD036237
     C                   IF        CREXMP <> 'Y'                                            MD040734
      ** CRS customer type is defined as NFE, but no CRS customer sub-type defined          MD036237
                                                                                            MD036237
     C                   IF        (CRTYPE = 'N' AND                                        MD036237
     C                             CRSTYP = 'UN')                                           MD036237
     C                             OR (CRTYPE = 'N' AND                                     MD036237
     C                             CRSTYP = *BLANKS)                                        MD036237
     C                   EVAL      WArrCnt = WArrCnt +1                                     MD036237
     C                   EVAL      WExcpRptArr (WArrCnt) = 'P'                              MD036237
     C                   ENDIF                                                              MD036237
     C                   ENDIF                                                              MD040734
                                                                                            MD036237
     C                   ENDSR                                                              MD036237
      *****************************************************************                     MD036237
      /EJECT                                                                                MD036237
      *****************************************************************                     MD036237
      *                                                               *                     MD036237
      *  SrCRSDueDlg - CRS Due Diligence period has expired but the   *                     MD036237
      *                CRS Info Complete Flag is still set to         *                     MD036237
      *                'No' or 'Blank'                                *                     MD036237
      *                                                               *                     MD036237
      *****************************************************************                     MD036237
     C     SrCRSDueDlg   BEGSR                                                              MD036237
                                                                                            MD036237
      ** CRS Due Diligence period has expired but the CRS Info Complete Flag                MD036237
      ** is still set to 'No' or 'Blank'                                                    MD036237
                                                                                            MD036237
     C                   EVAL      PIDate = *ZERO                                           MD036237
     C                   EVAL      PODate = *ZERO                                           MD036237
                                                                                            MD036237
     C                   EVAL      PIDate = WCRSEftStrtDte                                  MD036237
     C                   EXSR      SRMdasDay                                                MD036237
                                                                                            MD036237
      ** New CRS Customer                                                                   MD036237
                                                                                            MD036237
     C                   IF        XCCRDT >= PODate                                         MD036237
                                                                                            MD036237
     C                   EVAL      WDlgDt = XCCRDT + WCRSDlgNewAC                           MD036237
     C                   IF        WDlgDt <= WRUND AND                                      MD036237
     C                             CRINFO <> 'Y' AND CRINFO <> 'A'                            CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                    MD036237
     C                   EVAL      WExcpRptArr (WArrCnt) = 'Q'                              MD036237
     C                   ENDIF                                                              MD036237
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
                                                                                            MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   ENDSR                                                              MD036237
      *****************************************************************                     MD036237
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
      /EJECT                                                                                MD036237
      *****************************************************************                     MD036237
      *                                                               *                     MD036237
      *  SrRtvCRSAC - Retrieve CRS Agreement flag for country         *                     MD036237
      *                                                               *                     MD036237
      *****************************************************************                     MD036237
     C     SrRtvCRSAC    BEGSR                                                              MD036237
                                                                                            MD036237
      ** Retrieve Country of Location                                                       MD036237
     C                   Eval      PKey1 = CRCUST                                           MD036237
                                                                                            MD036237
     C                   CALL      'AOCUSTR0'                                               MD036237
     C                   PARM      *Blanks       PRtcd                                      MD036237
     C                   PARM      '*KEY   '     POptn                                      MD036237
     C                   PARM                    PKey1                                      MD036237
     C                   PARM                    PKySt                                      MD036237
     C     SDCUST        PARM      SDCUST        DSSDY                                      MD036237
                                                                                            MD036237
      ** Database Error                                                                     MD036237
                                                                                            MD036237
     C                   IF        PRtcd <> *BLANKS                                         MD036237
     C                             AND Prtcd <> '*CUSCLS'                                   MD050598
     C                             AND Prtcd <> '*CUSDEL'                                   MD050598
     C                   EVAL      DBFILE = 'SDCUSTPD'                                      MD036237
     C                   EVAL      DBASE  =  901                                            MD036237
     C                   EVAL      DBKEY  = POptn                                           MD036237
     C                   OUT       LDA                                                      MD036237
     C                   EXSR      *PSSR                                                    MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
      ** Get CRS agreement                                                                  MD036237
     C                   EVAL      WCNCD = CDCTRY                                           MD036237
     C                   EVAL      WCOLC = BBCOLC                                           MD036237
                                                                                            MD036237
     C                   CALL      'AOCTTXR0'                                               MD036237
     C                   PARM      *BLANKS       PRTCD                                      MD036237
     C                   PARM      '*KEY   '     POPTN                                      MD036237
     C                   PARM      WCNCD         @PCTRT                                     MD036237
     C                   PARM      WCOLC         @PCTRR                                     MD036237
     C     SDCTTX        PARM      SDCTTX        DSFDY                                      MD036237
                                                                                            MD036237
     C                   IF        PRTCD = '*NRF   '                                        MD036237
     C                   EVAL      WCOLC = *BLANK                                           MD036237
     C                   CALL      'AOCTTXR0'                                               MD036237
     C                   PARM      *BLANKS       PRTCD                                      MD036237
     C                   PARM      '*KEY   '     POPTN                                      MD036237
     C                   PARM      WCNCD         @PCTRT                                     MD036237
     C                   PARM      WCOLC         @PCTRR                                     MD036237
     C     SDCTTX        PARM      SDCTTX        DSFDY                                      MD036237
                                                                                            MD036237
     C                   IF        PRTCD = *BLANK                                           MD036237
     C                   EVAL      WDDCRSA = EWCRSA                                         MD036237
     C                   ELSE                                                               MD036237
     C                   EVAL      WDDCRSA = *Blanks                                        MD036237
     C                   ENDIF                                                              MD036237
     C                   ELSE                                                               MD036237
     C                   EVAL      WDDCRSA = EWCRSA                                         MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   ENDSR                                                              MD036237
      *****************************************************************                     MD036237
      /EJECT                                                                                MD036237
      *****************************************************************                     MD036237
      *                                                               *                     MD036237
      *  SrCRSExcNAHO - CRS Exception Reporting for Non-Account Holder*                     MD036237
      *                                                               *                     MD036237
      *****************************************************************                     MD036237
     C     SrCRSExcNAHO  BEGSR                                                              MD036237
                                                                                            MD036237
     C     *LOVAL        SETLL     SDCRNHL1                                                 MD036237
     C                   READ      SDCRNHL1                                                 MD036237
                                                                                            MD036237
     C                   DOW       NOT %EOF(SDCRNHL1)                                       MD036237
                                                                                            MD039670
     C                   IF        NRNAHO <> *BLANKS                                        MD039670
     C                   CALL      'AONAHOR0'                                               MD039670
     C                   PARM      *BLANKS       PRTCD                                      MD039670
     C                   PARM      '*KEY   '     POPTN                                      MD039670
     C                   PARM      NRNAHO        PNAHO                                      MD039670
     C*****SDNAHO        PARM      SDNAHO        DSSDY                             MD039670 MD051233
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      MD051233
                                                                                            MD039670
     C                   IF        PRTCD = '*NRF'                                           MD039670
     C                             OR NHCHTP = 'D'                                          MD039670
     C                   READ      SDCRNHL1                                                 MD039670
     C                   ITER                                                               MD039670
     C                   ENDIF                                                              MD039670
     C                   ENDIF                                                              MD039670
                                                                                            MD036237
     C                   EVAL      WArrCnt = 0                                              MD036237
                                                                                            MD036237
      ** Initialize Array                                                                   MD036237
     C                   EVAL      WNREXMI = *BLANKS                                        MD036237
     C                   MOVE      *BLANKS       WExcpRptArr                                MD036237
                                                                                           MD036237A
      ** Check creation date                                                               MD036237A
                                                                                           MD036237A
     C     NRNAHO        CHAIN     SDNAHOD0                                                MD036237A
     C                   IF        NOT %FOUND(SDNAHOL0)                                    MD036237A
     C                   EVAL      DBFILE = 'SDNAHOPD'                                     MD036237A
     C                   EVAL      DBASE  = 903                                            MD036237A
     C                   EVAL      DBKEY  = POPTN                                          MD036237A
     C                   EXSR      *PSSR                                                   MD036237A
     C                   ENDIF                                                             MD036237A
                                                                                           MD036237A
                                                                                            MD036237
      ** CRS New Non-account holder is subject to reporting but no TIN is defined           MD036237
     C                   EXSR      SrNewSubTINN                                             MD036237
                                                                                            MD036237
      ** CRS Existing Non-account holder is subject to reporting but no TIN is defined      MD036237
     C                   EXSR      SrExtSubTINN                                             MD036237
                                                                                            MD036237
      ** CRS type is defined as NFE, but no CRS customer sub-type defined.                  MD036237
     C                   EXSR      SrCRSTypeNFEN                                            MD036237
                                                                                            MD036237
      ** CRS Due Diligence period has expired but the CRS Information Complete Flag         MD036237
      ** is still set to 'No' or 'Blank'                                                    MD036237
     C                   EXSR      SrCRSDueDlgN                                             MD036237
                                                                                            MD036237
     C                   MOVEA     WExcpRptArr   WNREXMI                                    MD036237
                                                                                            MD036237
      ** Move and update file on change in exceptions                                       MD036237
     C                   IF        WNREXMI <> NREXMI                                        MD036237
                                                                                            MD036237
     C                   MOVEA     WExcpRptArr   NREXMI                                     MD036237
                                                                                            MD036237
     C                   IF        %trim(NREXMI) = *BLANKS                                  MD036237
     C                   EVAL      NREXMG = 'N'                                             MD036237
     C                   ELSE                                                               MD036237
     C                   EVAL      NREXMG = 'Y'                                             MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   UPDATE    SDCRNHD0                                                 MD036237
                                                                                            MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   READ      SDCRNHL1                                                 MD036237
                                                                                            MD036237
     C                   ENDDO                                                              MD036237
                                                                                            MD036237
     C                   ENDSR                                                              MD036237
      *****************************************************************                     MD036237
      /EJECT                                                                                MD036237
      *****************************************************************                     MD036237
      *                                                               *                     MD036237
      *  SrNewSubTINN - CRS New NAHO Subject to Reporting             *                     MD036237
      *                but no Tax Identification Number               *                     MD036237
      *                                                               *                     MD036237
      *****************************************************************                     MD036237
     C     SrNewSubTINN  BEGSR                                                              MD036237
                                                                                            MD036237
     C                   IF        NREXMP <> 'Y'                                            MD040734
     C                             AND NRTYPE <> 'F'                                        MD040734
     C                   EVAL      PInEfDte = WCRSEftStrtDte                                MD036237
     C                   EXSR      SRDate1                                                  MD036237
                                                                                            MD036237
     C**********         EVAL      PInDate = NHCRDT                                MD036237 MD051233
     C**********         EXSR      SRDate10                                        MD036237 MD051233
                                                                                            MD036237
      ** Read through CRS NAHO Detail File - Detail                                         MD036237
     C     NRNAHO        SETLL     SDCRSND0                                                 MD036237
     C     NRNAHO        READE     SDCRSND0                                                 MD036237
                                                                                            MD036237
     C                   DOW       NOT %EOF (SDCRSNL2)                                      MD036237
                                                                                            MD036237
      ** Retrieve first CRS Agreement                                                       MD036237
     C                   EXSR      SrRtvCRSAN                                               MD036237
     C                   EVAL      PInDate = NHCRDT                                         MD051233
     C                   EXSR      SRDate10                                                 MD051233
                                                                                            MD036237
      ** If New NAHO is Subject to Reporting but No TIN defined                             MD036237
                                                                                            MD036237
     C                   IF        (CNREPT = 'Y'                                            MD036237
     C                             AND CNTINN = *BLANKS                                     MD036237
     C                             AND PMDate >= PMEfDate)                                  MD036237
                                                                                            MD036237
      ** If Country has a CRS agreement, or the system value defines the TIN as mandatory   MD036237
                                                                                            MD036237
      ** If CRS Country is Local Country                                                    MD036237
     C                   IF        BJCNCD = CNCTRY                                          MD036237
                                                                                            MD036237
     C                   IF        (WDDCRSA = 'Y' OR                                        MD036237
     C                             WCRSLocTINMan = 'Y')                                     MD036237
     C                   EVAL      WArrCnt = WArrCnt +1                                     MD036237
     C                   EVAL      WExcpRptArr (WArrCnt) = 'N'                              MD036237
     C                   LEAVE                                                              MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   ELSE                                                               MD036237
      ** If CRS Country is Foreign Country                                                  MD036237
     C                   IF        (WDDCRSA = 'Y' OR                                        MD036237
     C                             WCRSForTINMan = 'Y')                                     MD036237
     C                   EVAL      WArrCnt = WArrCnt +1                                     MD036237
     C                   EVAL      WExcpRptArr (WArrCnt) = 'N'                              MD036237
     C                   LEAVE                                                              MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C     NRNAHO        READE     SDCRSND0                                                 MD036237
     C                   ENDDO                                                              MD036237
     C                   ENDIF                                                              MD040734
                                                                                            MD036237
     C                   ENDSR                                                              MD036237
      *****************************************************************                     MD036237
      /EJECT                                                                                MD036237
      *****************************************************************                     MD036237
      *                                                               *                     MD036237
      *  SrExtSubTINN - CRS Existing NAHO Subject to Reporting        *                     MD036237
      *                but no Tax Identification Number               *                     MD036237
      *                                                               *                     MD036237
      *****************************************************************                     MD036237
     C     SrExtSubTINN  BEGSR                                                              MD036237
                                                                                            MD036237
     C                   IF        NREXMP <> 'Y'                                            MD040734
     C                             AND NRTYPE <> 'F'                                        MD040734
     C                   EVAL      PInEfDte = WCRSEftStrtDte                                MD036237
     C                   EXSR      SRDate1                                                  MD036237
                                                                                            MD036237
     C**********         EVAL      PInDate = NHCRDT                                MD036237 MD051233
     C**********         EXSR      SRDate10                                        MD036237 MD051233
                                                                                            MD036237
      ** Read through CRS NAHO Detail File - Detail                                         MD036237
     C     NRNAHO        SETLL     SDCRSND0                                                 MD036237
     C     NRNAHO        READE     SDCRSND0                                                 MD036237
                                                                                            MD036237
     C                   DOW       NOT %EOF (SDCRSNL2)                                      MD036237
                                                                                            MD036237
      ** Retrieve first CRS Agreement                                                       MD036237
     C                   EXSR      SrRtvCRSAN                                               MD036237
     C                   EVAL      PInDate = NHCRDT                                         MD051233
     C                   EXSR      SRDate10                                                 MD051233
                                                                                            MD036237
      ** If Existing NAHO Subject to Reporting but No TIN defined                           MD036237
                                                                                            MD036237
     C                   IF        (CNREPT = 'Y'                                            MD036237
     C                             AND CNTINN = *BLANKS                                     MD036237
     C                             AND PMDate < PMEfDate)                                   MD036237
                                                                                            MD036237
      ** If Country has a CRS agreement, or the system value defines the TIN as mandatory   MD036237
                                                                                            MD036237
      ** If CRS Country is Local Country                                                    MD036237
     C                   IF        BJCNCD = CNCTRY                                          MD036237
                                                                                            MD036237
     C                   IF        (WDDCRSA = 'Y' OR                                        MD036237
     C                             WCRSLocTINMan = 'Y')                                     MD036237
     C                   EVAL      WArrCnt = WArrCnt +1                                     MD036237
     C                   EVAL      WExcpRptArr (WArrCnt) = 'O'                              MD036237
     C                   LEAVE                                                              MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   ELSE                                                               MD036237
      ** If CRS Country is Foreign Country                                                  MD036237
     C                   IF        (WDDCRSA = 'Y' OR                                        MD036237
     C                             WCRSForTINMan = 'Y')                                     MD036237
     C                   EVAL      WArrCnt = WArrCnt +1                                     MD036237
     C                   EVAL      WExcpRptArr (WArrCnt) = 'O'                              MD036237
     C                   LEAVE                                                              MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C     NRNAHO        READE     SDCRSND0                                                 MD036237
     C                   ENDDO                                                              MD036237
     C                   ENDIF                                                              MD040734
                                                                                            MD036237
     C                   ENDSR                                                              MD036237
      *****************************************************************                     MD036237
      /EJECT                                                                                MD036237
      *****************************************************************                     MD036237
      *                                                               *                     MD036237
      *  SrCRSTypeNFEN - CRS type is defined as NFE, but no           *                     MD036237
      *                 CRS sub-type defined.                         *                     MD036237
      *                                                               *                     MD036237
      *****************************************************************                     MD036237
     C     SrCRSTypeNFEN BEGSR                                                              MD036237
                                                                                            MD036237
     C                   IF        NREXMP <> 'Y'                                            MD040734
      ** CRS type is defined as NFE, but no CRS sub-type defined                            MD036237
                                                                                            MD036237
     C                   IF        (NRTYPE = 'N' AND                                        MD036237
     C                             NRSTYP = 'UN')                                           MD036237
     C                             OR (NRTYPE = 'N' AND                                     MD036237
     C                             NRSTYP = *BLANKS)                                        MD036237
     C                   EVAL      WArrCnt = WArrCnt +1                                     MD036237
     C                   EVAL      WExcpRptArr (WArrCnt) = 'P'                              MD036237
     C                   ENDIF                                                              MD036237
     C                   ENDIF                                                              MD040734
                                                                                            MD036237
     C                   ENDSR                                                              MD036237
      *****************************************************************                     MD036237
      /EJECT                                                                                MD036237
      *****************************************************************                     MD036237
      *                                                               *                     MD036237
      *  SrCRSDueDlgN - CRS Due Diligence period has expired but the  *                     MD036237
      *                CRS Info Complete Flag is still set to         *                     MD036237
      *                'No' or 'Blank'                                *                     MD036237
      *                                                               *                     MD036237
      *****************************************************************                     MD036237
     C     SrCRSDueDlgN  BEGSR                                                              MD036237
                                                                                            MD036237
      ** CRS Due Diligence period has expired but the CRS Info Complete Flag                MD036237
      ** is still set to 'No' or 'Blank'                                                    MD036237
                                                                                            MD036237
     C                   EVAL      PIDate = *ZERO                                           MD036237
     C                   EVAL      PODate = *ZERO                                           MD036237
                                                                                            MD036237
     C                   EVAL      PIDate = WCRSEftStrtDte                                  MD036237
     C                   EXSR      SRMdasDay                                                MD036237
                                                                                            MD036237
     C                   EVAL      PInDate = NHCRDT                                         MD036237
     C                   EXSR      SRDate10                                                 MD036237
                                                                                            MD036237
      ** New CRS Customer                                                                   MD036237
                                                                                            MD036237
     C                   IF        PMDate >= PODate                                         MD036237
                                                                                            MD036237
     C                   EVAL      WDlgDt = PMDate + WCRSDlgNewAC                           MD036237
     C                   IF        WDlgDt <= WRUND AND                                      MD036237
     C                             NRINFO <> 'Y' AND NRINFO <> 'A'                            CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                    MD036237
     C                   EVAL      WExcpRptArr (WArrCnt) = 'Q'                              MD036237
     C                   ENDIF                                                              MD036237
                                                                                              CGL177
     C                   ELSE                                                                 CGL177
                                                                                              CGL177
      ** Existing CRS Customer (Created before CRS Effective Date)                            CGL177
                                                                                              CGL177
     C                   EXSR      SrCRSDlgDte                                                CGL177
                                                                                              CGL177
     C                   SELECT                                                               CGL177
      ** CRS Existing A/C - Individual/Blank or Individual/N                                  CGL177
     C                   WHEN      NRTYPE = 'P' AND NRHVAL = ' '                              CGL177
     C                             OR NRTYPE = 'P' AND NRHVAL = 'N'                           CGL177
                                                                                              CGL177
     C                   IF        LowestVal <= WRUND AND                                     CGL177
     C                             NRINFO <> 'Y' AND NRINFO <> 'A'                            CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL177
     C                   EVAL      WExcpRptArr (WArrCnt) = 'Q'                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
      ** CRS Existing A/C - Entity/Blank or Entity/N                                          CGL177
     C                   WHEN      NRTYPE <> 'P' AND NRHVAL = ' '                             CGL177
     C                             OR NRTYPE <> 'P' AND NRHVAL = 'N'                          CGL177
                                                                                              CGL177
     C                   IF        LowestVal <= WRUND AND                                     CGL177
     C                             NRINFO <> 'Y' AND NRINFO <> 'A'                            CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL177
     C                   EVAL      WExcpRptArr (WArrCnt) = 'Q'                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
      ** CRS Existing A/C - Individual/Medium or Individual/Low                               CGL177
     C                   WHEN      NRTYPE = 'P' AND NRHVAL = 'M'                              CGL177
     C                             OR NRTYPE = 'P' AND NRHVAL = 'L'                           CGL177
                                                                                              CGL177
     C                   MOVE      WCRSDlgMedInd PIDate                                       CGL177
     C                   EXSR      SRMdasDay                                                  CGL177
                                                                                              CGL177
     C                   IF        PODate <= WRUND AND                                        CGL177
     C                             NRINFO <> 'Y' AND NRINFO <> 'A'                            CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL177
     C                   EVAL      WExcpRptArr (WArrCnt) = 'Q'                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
      ** CRS Existing A/C - Individual/High                                                   CGL177
                                                                                              CGL177
     C                   WHEN      NRTYPE = 'P' AND NRHVAL = 'H'                              CGL177
                                                                                              CGL177
     C                   MOVE      WCRSDlgHiInd  PIDate                                       CGL177
     C                   EXSR      SRMdasDay                                                  CGL177
                                                                                              CGL177
     C                   IF        PODate <= WRUND AND                                        CGL177
     C                             NRINFO <> 'Y' AND NRINFO <> 'A'                            CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL177
     C                   EVAL      WExcpRptArr (WArrCnt) = 'Q'                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
      ** CRS Existing A/C - Entity/Medium or Entity/Low                                       CGL177
     C                                                                                        CGL177
     C                   WHEN      NRTYPE <> 'P' AND NRHVAL = 'M'                             CGL177
     C                             OR NRTYPE <> 'P' AND NRHVAL = 'L'                          CGL177
                                                                                              CGL177
     C                   MOVE      WCRSDlgMedEnt PIDate                                       CGL177
     C                   EXSR      SRMdasDay                                                  CGL177
                                                                                              CGL177
     C                   IF        PODate <= WRUND AND                                        CGL177
     C                             NRINFO <> 'Y' AND NRINFO <> 'A'                            CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL177
     C                   EVAL      WExcpRptArr (WArrCnt) = 'Q'                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
      ** CRS Existing A/C - Entity/High                                                       CGL177
                                                                                              CGL177
     C                   WHEN      NRTYPE <> 'P' AND NRHVAL = 'H'                             CGL177
                                                                                              CGL177
     C                   MOVE      WCRSDlgHiEnt  PIDate                                       CGL177
     C                   EXSR      SRMdasDay                                                  CGL177
                                                                                              CGL177
     C                   IF        PODate <= WRUND AND                                        CGL177
     C                             NRINFO <> 'Y' AND NRINFO <> 'A'                            CGL177
     C                   EVAL      WArrCnt = WArrCnt + 1                                      CGL177
     C                   EVAL      WExcpRptArr (WArrCnt) = 'Q'                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   ENDSL                                                                CGL177
                                                                                            MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   ENDSR                                                              MD036237
      *****************************************************************                     MD036237
      /EJECT                                                                                MD036237
      *****************************************************************                     MD036237
      *                                                               *                     MD036237
      *  SrRtvCRSAN - Retrieve CRS Agreement flag for country NAHO    *                     MD036237
      *                                                               *                     MD036237
      *****************************************************************                     MD036237
     C     SrRtvCRSAN    BEGSR                                                              MD036237
                                                                                            MD036237
      ** Retrieve Country of Location                                                       MD036237
                                                                                            MD036237
     C                   CALL      'AONAHOR0'                                               MD036237
     C                   PARM      *BLANKS       PRTCD                                      MD036237
     C                   PARM      '*KEY   '     POPTN                                      MD036237
     C                   PARM      CNNAHO        PNAHO                                      MD036237
     C*****SDNAHO        PARM      SDNAHO        DSSDY                             MD036237 MD051233
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      MD051233
                                                                                            MD036237
      ** Database Error                                                                     MD036237
                                                                                            MD036237
     C                   IF        PRtcd <> *BLANKS                                         MD036237
     C                   EVAL      DBFILE = 'SDNAHOPD'                                      MD036237
     C                   EVAL      DBASE  =  901                                            MD036237
     C                   EVAL      DBKEY  = POptn                                           MD036237
     C                   OUT       LDA                                                      MD036237
     C                   EXSR      *PSSR                                                    MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
      ** Get CRS agreement                                                                  MD036237
     C                   EVAL      WCNCD = CNCTRY                                           MD036237
     C                   EVAL      WCOLC = NHCOLC                                           MD036237
                                                                                            MD036237
     C                   CALL      'AOCTTXR0'                                               MD036237
     C                   PARM      *BLANKS       PRTCD                                      MD036237
     C                   PARM      '*KEY   '     POPTN                                      MD036237
     C                   PARM      WCNCD         @PCTRT                                     MD036237
     C                   PARM      WCOLC         @PCTRR                                     MD036237
     C     SDCTTX        PARM      SDCTTX        DSFDY                                      MD036237
                                                                                            MD036237
     C                   IF        PRTCD = '*NRF   '                                        MD036237
     C                   EVAL      WCOLC = *BLANK                                           MD036237
     C                   CALL      'AOCTTXR0'                                               MD036237
     C                   PARM      *BLANKS       PRTCD                                      MD036237
     C                   PARM      '*KEY   '     POPTN                                      MD036237
     C                   PARM      WCNCD         @PCTRT                                     MD036237
     C                   PARM      WCOLC         @PCTRR                                     MD036237
     C     SDCTTX        PARM      SDCTTX        DSFDY                                      MD036237
                                                                                            MD036237
     C                   IF        PRTCD = *BLANK                                           MD036237
     C                   EVAL      WDDCRSA = EWCRSA                                         MD036237
     C                   ELSE                                                               MD036237
     C                   EVAL      WDDCRSA = *Blanks                                        MD036237
     C                   ENDIF                                                              MD036237
     C                   ELSE                                                               MD036237
     C                   EVAL      WDDCRSA = EWCRSA                                         MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   ENDSR                                                              MD036237
      *****************************************************************                     MD036237
      /EJECT                                                                                MD036237
      *****************************************************************                     MD036237
      *                                                               *                     MD036237
      *  SRDate1 - Convert Date DDMMYY to Midas Date                  *                     MD036237
      *                                                               *                     MD036237
      *****************************************************************                     MD036237
     C     SRDate1       BEGSR                                                              MD036237
                                                                                            MD036237
     C                   CALLB     'ZDATE1'                                                 MD036237
     C                   PARM                    PInEfDte                                   MD036237
     C                   PARM      *ZERO         PMEfDate                                   MD036237
     C                   PARM                    BJDFIN                                     MD036237
     C                   PARM      *BLANK        PErrFlag                                   MD036237
                                                                                            MD036237
     C                   ENDSR                                                              MD036237
      *****************************************************************                     MD036237
      /EJECT                                                                                MD036237
      *****************************************************************                     MD036237
      *                                                               *                     MD036237
      *  SRSVAL2 - Access System Values for CRS                       *                     MD036237
      *                                                               *                     MD036237
      *****************************************************************                     MD036237
     C     SRSVAL2       BEGSR                                                              MD036237
                                                                                            MD036237
     C                   EVAL      POP01 = 'CRSEffectStartDate'                             MD036237
     C                   EVAL      POP02 = 'CRSDiligenceHiEnt'                              MD036237
     C                   EVAL      POP03 = 'CRSDiligenceHiInd'                              MD036237
     C                   EVAL      POP04 = 'CRSDiligenceMedEnt'                             MD036237
     C                   EVAL      POP05 = 'CRSDiligenceMedInd'                             MD036237
     C                   EVAL      POP06 = 'CRSDiligenceNewA/C'                             MD036237
     C                   EVAL      POP07 = 'CRSForTINMandatory'                             MD036237
     C                   EVAL      POP08 = 'CRSLocalTINMandatory'                           MD036237
                                                                                            MD036237
     C                   CALL      'AOSVALR0'                                               MD036237
     C                   PARM      *BLANKS       PRtcd                                      MD036237
     C                   PARM                    POP01                                      MD036237
     C                   PARM                    PVL01                                      MD036237
     C                   PARM                    POP02                                      MD036237
     C                   PARM                    PVL02                                      MD036237
     C                   PARM                    POP03                                      MD036237
     C                   PARM                    PVL03                                      MD036237
     C                   PARM                    POP04                                      MD036237
     C                   PARM                    PVL04                                      MD036237
     C                   PARM                    POP05                                      MD036237
     C                   PARM                    PVL05                                      MD036237
     C                   PARM                    POP06                                      MD036237
     C                   PARM                    PVL06                                      MD036237
     C                   PARM                    POP07                                      MD036237
     C                   PARM                    PVL07                                      MD036237
     C                   PARM                    POP08                                      MD036237
     C                   PARM                    PVL08                                      MD036237
     C                   PARM                    POP09                                      MD036237
     C                   PARM                    PVL09                                      MD036237
     C                   PARM                    POP10                                      MD036237
     C                   PARM                    PVL10                                      MD036237
                                                                                            MD036237
     C                   EVAL      WCRSEftStrtDte = PVL01                                   MD036237
     C                   EVAL      WCRSDlgHiEnt = PVL02                                       CGL177
     C                   EVAL      WCRSDlgHiInd = PVL03                                     MD036237
     C                   EVAL      WCRSDlgMedEnt = PVL04                                    MD036237
     C                   EVAL      WCRSDlgMedInd = PVL05                                      CGL177
     C                   MOVEL     PVL06         WCRSDlgNewAC                               MD036237
     C                   EVAL      WCRSForTINMan = PVL07                                    MD036237
     C                   EVAL      WCRSLocTINMan = PVL08                                    MD036237
                                                                                            MD036237
     C                   ENDSR                                                              MD036237
      *****************************************************************                     MD036237
      /EJECT                                                                                MD036237
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
 
      ** Check any override as 'N' possibly invalidating
      ** system value Indicia
     C                   EVAL      WOvrOff =
     C                               %SCAN('Y':CustIndSvalDS:WOvrOff)
     C                   EVAL      WSysOff = WOvrOff
     C                   IF        WOvrOff <> 0
     C                   EVAL      WSysOff =
     C**********                     %SCAN('N':CustIndOverDS:WOvrOff)                       MD033414
     C                               %SCAN('N':CustIndOverDS:WSysOff)                       MD033414
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
 
      ** Check any override as 'N' possibly invalidating
      ** system value Indicia
 
     C                   EVAL      WOvrOff =
     C                               %SCAN('Y':NahoIndSvalDS:WOvrOff)
     C                   EVAL      WSysOff = WOvrOff
     C                   IF        WOvrOff <> 0                                             MD033501
     C                   EVAL      WSysOff =
     C**********                     %SCAN('N':NahoIndOverDS:WOvrOff)              MD024721 MD033414
     C                               %SCAN('N':NahoIndOverDS:WSysOff)                       MD033414
     C                   ENDIF                                                              MD033501
 
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
      *  SRNAHO - Access Addiotnal Customer Details                   *
      *                                                               *
      *****************************************************************
     C     SRNAHO        BEGSR
 
     C                   CALL      'AONAHOR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      FNNAHO        PNAHO
     C*****SDNAHO        PARM      SDNAHO        DSSDY                                      MD051233
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      MD051233
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      WBthDateA = NHDBTH
     C                   EVAL      WBthCntry = NHBTHC
     C                   EVAL      WBthTown  = NHBTHT
     C                   ELSE
     C                   EVAL      WBthDateA = *BLANKS
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
     C                   PARM      'CRE103'      PSARD                                      MD033414
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
 
      ** Check if CGL157 is On                                                              MD036237
                                                                                            MD036237
     C                   MOVE      'N'           CGL157                                     MD036237
                                                                                            MD036237
     C                   CALL      'AOSARDR0'                                               MD036237
     C                   PARM      *BLANKS       PRTCD                                      MD036237
     C                   PARM      '*VERIFY'     POPTN                                      MD036237
     C                   PARM      'CGL157'      PSARD                                      MD036237
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD036237
                                                                                            MD036237
     C     PRTCD         IFEQ      *BLANKS                                                  MD036237
                                                                                            MD036237
     C                   EVAL      CGL157 = 'Y'                                             MD036237
                                                                                            MD036237
     C                   ELSE                                                               MD036237
                                                                                            MD036237
     C     PRTCD         IFNE      '*NRF   '                                                MD036237
                                                                                            MD036237
     C     *LOCK         IN        LDA                                                      MD036237
     C                   EVAL      DBFile = 'SCSARDPD'                                      MD036237
     C                   EVAL      DBase = 103                                              MD036237
     C                   OUT       LDA                                                      MD036237
     C                   EXSR      *PSSR                                                    MD036237
                                                                                            MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   ENDIF                                                              MD036237
                                                                                            MD036237
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2013
