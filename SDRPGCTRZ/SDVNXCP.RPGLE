     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Exception')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVNXCP - Validate Exception of Non-account Holder           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD029839           Date 01Sep14               *
      *  Prev Amend No. MD026997           Date 29May14               *
      *                 MD026497           Date 27Apr14               *
      *                 CGL132   *CREATE   Date 01Feb14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD029839 - OCBC FATCA - SD000554P1 - "The customer is subject*
      *             to reporting but no US tax number is defined."    *
      *             Applied Fix MD027148                              *
      *  MD026997 - Only check US TIN if subject to reporting is 'Y'  *
      *             for Customers/Non-Account Holders created after   *
      *             FATCA Effective Date                              *
      *  MD026497 - Inappropriate Exception Message appears upon      *
      *             Customer/Non-Account Holder Insert                *
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
 
     FSDCUSXL0  IF   E           K DISK
 
     FSDJACCL0  IF   E           K DISK
 
     FSDJACCL4  IF   E           K DISK
     F                                     RENAME(SDJACCD0:SDJACCD4)
 
     FSDJACCL7  IF   E           K DISK
     F                                     RENAME(SDJACCD0:SDJACCD7)
 
     FSDNAHOL1  IF   E           K DISK
 
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
 
     D SDVFTNH       E DS                  EXTNAME(SDVFTNHPD)
      ** Valid Customer Details layout
 
      ** New Non-A/C Holder in File Format
     D NwNaFilFmt    E DS                  Extname(SDVNAHLPD)
 
      ** FATCA Customer Classification Code
     D SDFATC        E DS                  EXTNAME(SDFATCPD)
 
      ** Non-Account Holders File
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
 
      ** Midas Module Details Data Structure
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D CustIndOverDS   DS
     D  JFAHMOV
     D  JFAMCOV
     D  JFARPOV
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
     D  JFNCISV
     D  JFNCBSV
     D  JFNCDSV
     D  JFNGCSV
     D  JFNIDSV
     D  JFNJASV
     D  JFNTESV
     D  JFNTXSV
 
 
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
     D WIndCnt         C                   CONST(11)
     D WArrCnt         S              2S 0
     D WDays           S              3A                                                    MD026497
 
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
 
      ** FATCA Exception Reporting for Non-Account Holders
     C                   EXSR      SrExcpNAHO
 
     C                   EVAL      *INLR = *ON
 
      ** RETURN
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrExcpNAHO - FATCA Exception Reporting for Non-Account Holder*
      *                                                               *
      *****************************************************************
     C     SrExcpNAHO    BEGSR
 
      ** FATCA Information for Non-Account Holders
 
     C                   EVAL      WArrCnt = 0
 
      ** Initialize Array
     C                   EVAL      WFNEXID = *BLANKS
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
      *  SRNAHO - Access Addiotnal Customer Details                   *
      *                                                               *
      *****************************************************************
     C     SRNAHO        BEGSR
 
     C                   EVAL      WBthDateA = NADBTH
     C                   EVAL      WBthCntry = NABTHC
     C                   EVAL      WBthTown  = NABTHT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNHClass - FATCA Classification and US Indicia              *
      *                                                               *
      *****************************************************************
     C     SrNHClass     BEGSR
 
     C                   EVAL      PPFTC = FVCLAC
 
      ** Check classification code details of the Non-Account Holder
 
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
 
     C                   EVAL      WArrCnt = WArrCnt + 1
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
      *  SrNHRepTxN - Subject to Reporting but no Tax Number          *
      *                                                               *
      *****************************************************************
     C     SrNHRepTxN    BEGSR
 
      ** Convert FATCA Effective Date to run day number                                     MD026997
     C                   EVAL      ZDATEA = WSvalEffctDate                                  MD026997
     C                   EXSR      ZDATE1                                                   MD026997
     C                   EVAL      WSvalEffDayNo = ZDAYNO                                   MD026997
                                                                                            MD026997
      ** Convert Creation Date to run day number                                            MD026997
     C                   EVAL      PInDate = NACRDT                                         MD026997
     C                   EXSR      SRDate10                                                 MD026997
                                                                                            MD026997
      ** Non-Account Holder Subject to reporting but no US Tax defined
 
     C                   IF        FVREPT = 'Y'
     C                             AND FVUTIN = *BLANKS
     C                             AND PMDate >= WSvalEffDayNo                              MD026997
     C                                                                                      MD026997
     C                   IF        FVNHST <> 'NP' AND                                       MD027148
     C                             FVRPTT <> 'R'                                            MD027148
     C                   EVAL      WArrCnt = WArrCnt + 1
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
      *  SrNHRepBrth - Subject to Reporting but no Date and Place     *
      *                of Birth                                       *
      *                                                               *
      *****************************************************************
     C     SrNHRepBrth   BEGSR
 
      ** Access Non-Account Holder Details for Date and Place of Birth
 
     C                   EXSR      SRNAHO
 
      ** Subject to Reporting
 
     C                   IF        FVREPT = 'Y'
     C                   IF        WSvalTinBrthRq = 'U'
     C                             AND FVUTIN = *BLANKS
 
     C                             OR WSvalTinBrthRq = 'B'
     C                             AND WBthDateA = *BLANKS
     C                             OR WSvalTinBrthRq = 'B'
     C                             AND WBthCntry = *BLANKS
     C                             OR WSvalTinBrthRq = 'B'
     C                             AND WBthTown = *BLANKS
 
     C                             OR WSvalTinBrthRq = 'Y'
     C                             AND FVUTIN = *BLANKS
     C                             OR WSvalTinBrthRq = 'Y'
     C                             AND WBthDateA = *BLANKS
     C                             OR WSvalTinBrthRq = 'Y'
     C                             AND WBthCntry = *BLANKS
     C                             OR WSvalTinBrthRq = 'Y'
     C                             AND WBthTown = *BLANKS
 
     C                   EVAL      WArrCnt = WArrCnt + 1
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
      *  SrNHExpCls - Expiry days has passed                          *
      *                                                               *
      *****************************************************************
     C     SrNHExpCls    BEGSR
 
      ** Check creation date
 
     C     FVNAHO        CHAIN     SDNAHOD0
     C                   IF        NOT %FOUND(SDNAHOL1) AND
     C                             FVLCTP <> 'I' AND
     C                             FVNAHO <> *BLANKS
     C                   EVAL      DBFILE = 'SDNAHOPD'
     C                   EVAL      DBASE  = 901
     C                   EVAL      DBKEY  = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C**********         IF        FVLCTP <> 'I'                                            MD026497
     C**********         EVAL      PInDate = NHCRDT                                         MD026497
     C                   EVAL      PInDate = NACRDT                                         MD026497
     C                   EXSR      SRDate10
 
     C                   EVAL      WExpiryDate = PMDate + WSvalExpDayDft
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
      *  SrNHSubtyp - FATCA NAHO Type is define but no subtype        *
      *                                                               *
      *****************************************************************
     C     SrNHSubtyp    BEGSR
 
      ** FATCA Customer Type is 'F' (FFI) or 'N' (NFE)
      ** but no FATCA Subtype defined
 
     C                   IF        FVNHTY = 'F'
     C                             AND FVNHST = *BLANKS
     C                             OR FVNHTY = 'N'
     C                             AND FVNHST = *BLANKS
     C                             OR FVNHTY = 'F'
     C                             AND FVNHST = 'UN'
     C                             OR FVNHTY = 'N'
     C                             AND FVNHST = 'UN'
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
      *  SrNHGIINno - Non-Account Holder is participating but no      *
      *               GIIN number                                     *
      *                                                               *
      *****************************************************************
     C     SrNHGIINno    BEGSR
 
      ** Naho is flagged as a participating FFI but the GIIN number
      ** information is missing
 
     C                   IF        FVNHTY = 'F'
     C                             AND FVNHST = 'PO'
     C                             AND FVGIIN = *BLANKS
     C                             OR FVNHTY = 'F'
     C                             AND FVNHST = 'PS'
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
      *  SrNHGIINDt - Non-Account Holder is participating but         *
      *               no GIIN date                                    *
      *                                                               *
      *****************************************************************
     C     SrNHGIINDt    BEGSR
 
     C                   IF        FVNHTY = 'F'
     C                             AND FVNHST = 'PO'
     C                             AND FVGIID = *ZERO
     C                             OR FVNHTY = 'F'
     C                             AND FVNHST = 'PS'
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
      *  SrNHComplt - FATCA Info is Complete                          *
      *                                                               *
      *****************************************************************
     C     SrNHComplt    BEGSR
 
      ** FATCA inoformation is flagged as 'complete' but non-account
      ** holder has still one of the default statuses
 
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
     C                   EVAL      POP04 = 'FATCADftClsTakeon'
     C                   EVAL      POP05 = 'FATCAEffectStartDate'                           MD026997
 
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
     C**********         MOVEL     PVL02         WSvalExpDayDft                             MD026497
     C                   EVALR     WDays = %TRIM(PVL02)                                     MD026497
     C                   MOVE      WDays         WSvalExpDayDft                             MD026497
     C                   EVAL      WSvalDftClsCde = PVL03
     C                   EVAL      WSvalDftClsTkn  = PVL04
     C                   EVAL      WSvalEffctDate  = PVL05                                  MD026997
 
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
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Return Code
     C                   PARM                    ReturnCode
     C                   PARM                    SDVFTNH
     C                   PARM                    NwNaFilFmt
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    BJDFIN            1                        MD026997
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DFEXMA            1
     C                   PARM                    DFEXID           30
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2014
