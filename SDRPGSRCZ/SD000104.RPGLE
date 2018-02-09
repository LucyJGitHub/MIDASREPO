     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD FATCA Cust Type & Classif. Report&Update')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data module                                 *
      *                                                               *
      *  SD000104 - Midas SD FATCA Customer Type & Classification     *
      *             Allocation Report & Update                        *
      *                                                               *
      *  Function:  This prints a list of customers matching defined  *
      *             criteria and what must be their FATCA customer    *
      *             type (and sub-type if FFI/NFE) and possible       *
      *             classification.                                   *
      *             If the program is called in update mode, it also  *
      *             updates the FACTA customer type (and sub-type if  *
      *             FFI/NFE) and classification for the customer.     *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD027298           Date 06Aug14               *
      *                 MD029848           Date 29Aug14               *
      *                 MD027707           Date 01Jul14               *
      *                 MD027498           Date 20Jun14               *
      *                 MD027578           Date 17Jun14               *
      *                 MD027496           Date 13Jun14               *
      *                 MD026854           Date 29May14               *
      *                 MD027023           Date 22May14               *
      *                 CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD027298 - Incorrect label 'Exempt' (Recompile)              *
      *  MD029848 - (TNT) FATCA Report Issue. Applied fix MD029618    *
      *  MD027707 - FCAT is unable to set Information complete flag   *
      *             to A when FATCA Classification Code is blank      *
      *  MD027498 - Inconsistent behaviour of setting New             *
      *             Classification Code in selection criteria to blank*
      *  MD027578 - FCAT does not follow some validations when        *
      *             setting FATCA Info Complete flag to 'A'           *
      *  MD027496 - High Value Account Indicator is not updated to 'N'*
      *  MD026854 - Alternative country of citizenship is missing in  *
      *             history of customer information                   *
      *  MD027023 - FCAT does not follow some validations when        *
      *             setting FATCA Info Complete flag to 'A'           *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7         Control Indicator                               *
      *    U8         Control Indicator                               *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRHeader - Header Subroutine                                 *
      *  SRDetails - Details Subroutine                               *
      *  SRUpdate - Update Subroutine                                 *
      *  SRUpdFile - Update Enquiry File Subroutine                   *
      *  *PSSR - Error Processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Live Customers
     FSDCUSTL5  IF   E           K DISK
      *
      ** Customer Extension
     FSDCUSXL0  IF   E           K DISK
      *
      ** FATCA Customer Type & Classification Allocation File
     FSDFTCTL0  IF   E           K DISK
      *
      ** FATCA Customer Details File
     FSDFTCSL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** FATCA Customer Type & Classification List File
     FSDFTCLPD  UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Midas SD FATCA Customer Type & Classification Report
     FSD000104P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     USROPN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** System value TIN and/or date and place of birth for
      ** customer and NAH subject to reporting
     D SysVal1         C                   'FATCAUsTinBirthRqd'
      ** System value Default Classification for Take-on
     D*SysVal2**       C                   'FATCADftClsTakeon'                              MD027578
     D SysVal2         C                   'FATCADftCLsTakeon'                              MD027578
      ** System value Default Classification for New Customers
      ** and Non-account Holders
     D*SysVal3**       C                   'FATCADftClsNewCustNH'                           MD027578
     D SysVal3         C                   'FATCADftCLsNewCustNH'                           MD027578
      ** System value FATCA Effective Date
     D SysVal4         C                   'FATCAEffectStartDate'
      ** Exemption remark
     D ExemRem         C                   'Updated by Customer Type-
     D                                      and Allocation Electronic Tool'
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Change Descriptions for the History of Customer Information
      *
      ** External DS for Bank Details ICD retrieval
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS Based On SDFATCPD
     D SDFATC        E DS                  EXTNAME(SDFATCPD)
      *
      ** External DS Based On SDINSTPD
     D SDINST        E DS                  EXTNAME(SDINSTPD)
      *
      ** External DS Based On SDACUSPD
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
      *
      ** External DS Based On SDFTCSPD
     D SDFTCS        E DS                  EXTNAME(SDFTCSPD)
      *
      ** External DS Based On SCSARDPD
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
 
      ** File Information Data Structure for SD000104P1
     D SPOOL1          DS
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** Data structure for AOSVALR0 string
     D SVal1           DS           200
     D  SVal11                 1      1
     D SVal2           DS           200
     D  SVal25                 1      5
     D SVal3           DS           200
     D  SVal35                 1      5
     D SVal4           DS           200
     D  SVal46                 1      6
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PRtcd           S              7A
     D PRetcd          S              7A
     D POptn           S              7A
     D PMode           S              1A
     D PClas           S              5A
     D PLin            S              2A
     D PSard           S              6A
     D CSD092          S              1A
     D WRun            S              1A
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D PCustNo         S              6A
     D WChange         S              1A
     D WTime           S              6  0
     D PBefCUST        S           5000A
     D PAftCUST        S           5000A
     D PBefACUS        S           5000A
     D PAftACUS        S           5000A
     D PBefFTCS        S           5000A
     D PAftFTCS        S           5000A
     D PBefJACC        S           5000A
     D PAftJACC        S           5000A
     D PBefCUAH        S           5000A
     D PAftCUAH        S           5000A
     D PBefCUXC        S           5000A                                                    MD026854
     D PAftCUXC        S           5000A                                                    MD026854
     D PACRV           S              1A
     D PELEC           S              1A
     D WRecFound       S              1A                                                    MD029618
 
      ** Parameter variables for AOSVALR0 string
     D SValK1          S             20
     D SValK2          S             20
     D SValK3          S             20
     D SValK4          S             20
     D SValK5          S             20
     D SVal5           S            200
     D SValK6          S             20
     D SVal6           S            200
     D SValK7          S             20
     D SVal7           S            200
     D SValK8          S             20
     D SVal8           S            200
     D SValK9          S             20
     D SVal9           S            200
     D SValK0          S             20
     D SVal10          S            200
      *
     ** Parameters for ZDATE1
     D PError          S              7A
     D PDate           S              6  0
     D PDateFormat     S              1A
     D PDayNo          S              5  0
 
      ** ZSFILE Parameters
     D ZSEQ            S              5
     D ZENTY           S              3
     D ZSERR           S              1
     D ZSNUM           S              6  0
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - Processing                                             *
      *****************************************************************
      *
      ** Read in Installation Data
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   EVAL      WRecFound = 'N'                                          MD029618
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
      *
      ** Report title
     C                   IF        PMode = 'U'
     C                   EVAL      *IN40 = *ON
     C                   ELSE
     C                   EVAL      *IN40 = *OFF
     C                   ENDIF
      *
     C                   READ      SDCUSTL5
      *
     C                   IF        PMode <> 'F'
     C                   OPEN      SD000104P1
 
     C                   Z-ADD     SFNUM         ZSNUM
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       ZSEQ
     C                   PARM      *BLANKS       ZENTY
     C                   PARM                    SFILE
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
 
      ** error during ZSFILE processing, return to calling program
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   EXSR      SRHeader
     C                   ENDIF
      *
     C                   IF        %EOF(SDCUSTL5) AND PMode <> 'F'
     C                   WRITE     SD000104R2
     C                   ENDIF
      *
     C                   DOW       NOT %EOF(SDCUSTL5)
      *
      *
      ** Retrieve FATCA Customer Type & Classification Allocation
     C     BBLINC        CHAIN     SDFTCTL0
      *
      ** Retrieve FATCA Customer Details
     C     BBCUST        CHAIN     SDFTCSL0
      *
      ** Retrieve Customer Extension
     C     BBCUST        CHAIN     SDCUSXL0
      *
     C                   IF        %FOUND(SDFTCTL0) AND
     C                             %FOUND(SDFTCSL0)
     C                   EXSR      SRDetails
      *
     C                   IF        PMode <> 'R' AND WChange = 'Y'
     C                   EXSR      SRUpdFile
     C                   ENDIF
      *
      ** If called in update mode, update FATCA customer file with
      ** the FACTA customer type (and sub-type if FFI/NFE) and
      ** classification for the customer.
     C                   IF        PMode = 'U' AND WChange = 'Y'
     C                   EXSR      SRUpdate
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check whether new page is required
     C                   IF        PMode <> 'F' AND WChange = 'Y'
     C                   EVAL      RqdLn1 = 2
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   EXSR      SRHeader
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      SDCUSTL5
      *
     C                   ENDDO
                                                                                            MD029618
     C                   IF        WRecFound = 'N' AND PMode <> 'F'                         MD029618
     C                   WRITE     SD000104R2                                               MD029618
     C                   ENDIF                                                              MD029618
                                                                                            MD029618
     C                   COMMIT
     C                   EVAL      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHeader - Header subroutine                                 *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRHeader      BEGSR
      *
     C                   WRITE     SD000104R0
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetails - Details subroutine                               *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRDetails     BEGSR
      ** Customer Details
     C                   EVAL      XRCUST = BBCUST
     C                   EVAL      XRSHNM = BBCSSN
     C                   EVAL      XRRPNM = BBCRNM
     C                   EVAL      XRRPTN = BBCRTN
     C                   EVAL      XRLINC = BBLINC
      ** FATCA Customer Type
     C                   EVAL      XRCUTP = FTCUTP
      ** FATCA Customer Sub-Type
     C                   EVAL      XRCSTY = FTCSTY
      ** FATCA Classification
     C                   IF        FTCLCD <> *BLANKS                                        MD027498
     C                   EVAL      XRCLCD = FTCLCD
     C                   ELSE                                                               MD027498
     C                   EVAL      XRCLCD = FACLAC                                          MD027498
     C                   ENDIF                                                              MD027498
      ** FATCA Information Complete
     C                   EVAL      XRINFO = FAINFC
      ** Exempt
     C                   EVAL      XREXMT = FAEXEM
      *
     C                   IF        FTCUTP = 'O' AND FTEXMT = 'Y'
     C                   EVAL      XREXMT = FTEXMT
     C                   ENDIF
      *
      ** Retrieve description for Local Institution Code
     C                   CALL      'AOINSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      BBLINC        PLin
     C     SDINST        PARM      SDINST        DSFDY
      *
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      XRLINM = AKLINM
     C                   ELSE
     C                   EVAL      XRLINM = *BLANKS
     C                   ENDIF
      *
     C                   IF        FTCLCD <> *BLANKS                                        MD027498
     C                   EVAL      PClas = FTCLCD                                           MD027498
     C                   ELSE                                                               MD027498
     C                   EVAL      PClas = FACLAC                                           MD027498
     C                   ENDIF                                                              MD027498
      ** Retrieve description for FATCA Classification Code
     C                   CALL      'AOFATCR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C**********         PARM      FTCLCD        PClas                                      MD027498
     C                   PARM                    PClas                                      MD027498
     C     SDFATC        PARM      SDFATC        DSFDY
      *
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      XRCLNM = FCDESC
     C                   ELSE
     C                   EVAL      XRCLNM = *BLANKS
     C                   ENDIF
      *
      ** If FATCA Customer Type = 'O' then set FATCA Information
      ** Complete to 'A' only if all related validation rules are
      ** respected and the FATCA Information Complete flag is 'A'
     C                   IF        FTCUTP = 'O' AND FTINFO = 'A'
      *
      ** Retrieve additional customer details
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BBCUST        PCustNo
     C     SDACUS        PARM      SDACUS        DSLDY
 
     C**********         IF        XRCLCD <> *BLANKS AND                                    MD027707
     C**********                   XRCLCD <> SVAL25 AND                                     MD027707
     C                   IF        XRCLCD <> SVAL25 AND                                     MD027707
     C                             XRCLCD <> SVAL35 AND
     C                             FARPTT <> 'U' AND
     C                             FAHVAC <> *BLANKS AND
     C                             FAREPT <> *BLANKS AND
     C                             FACISV <> *BLANKS AND
     C                             FATXSV <> *BLANKS AND
     C                             FACDSV <> *BLANKS AND
     C                             FATESV <> *BLANKS AND
     C                             FAGCSV <> *BLANKS AND
     C                             FACBSV <> *BLANKS AND
     C                             FAJASV <> *BLANKS AND
     C                             FAHMSV <> *BLANKS AND
     C                             FARPSV <> *BLANKS AND
     C                             FAIDSV <> *BLANKS AND
     C                             FAMCSV <> *BLANKS AND
     C                             FAPHON <> *BLANKS AND                                    MD027023
     C                             FAMAIL <> *BLANKS AND                                    MD027023
     C                             FAGREC <> *BLANKS AND                                    MD027023
     C                             FAEXEM <> *BLANKS AND                                    MD027023
     C                             ((SVal11 = 'U' AND
     C                             FAUTIN <> *BLANKS) OR
     C                             (SVal11 = 'B' AND
     C                             E5DBTH <> *BLANKS AND
     C                             E5BTHT <> *BLANKS) OR
     C                             (SVal11 = 'Y' AND
     C                             FAUTIN <> *BLANKS AND
     C                             E5DBTH <> *BLANKS AND
     C                             E5BTHT <> *BLANKS) OR
     C                             (SVal11 = 'N')) AND
     C**********                   ((XCCRDT >= PDayNo AND                                   MD027023
     C**********                   FAREPT = 'Y' AND                                         MD027023
     C**********                   FAUTIN <> *BLANKS AND                                    MD027023
     C**********                   FALCTP = 'I') OR                                         MD027023
     C**********                   (XCCRDT >= PDayNo AND                                    MD027023
     C**********                   FAREPT = 'N' AND                                         MD027023
     C**********                   FALCTP = 'I') OR                                         MD027023
     C**********                   (XCCRDT < PDayNo AND FALCTP = 'I')                       MD027023
     C**********                   OR FALCTP <> 'I')                                        MD027023
     C                             ((XCCRDT >= PDayNo AND                                   MD027023
     C                             FAREPT = 'Y' AND                                         MD027023
     C                             FAUTIN <> *BLANKS) OR                                    MD027023
     C                             (XCCRDT >= PDayNo AND                                    MD027023
     C                             FAREPT = 'N') OR                                         MD027023
     C                             (XCCRDT < PDayNo))                                       MD027023
     C                   EVAL      XRINFO = FTINFO
     C                   ENDIF
     C                   ENDIF
      *
      ** Check whether record has changed
     C                   IF        XRINFO <> FAINFC OR
     C                             XRCUTP <> FACSTY OR
     C                             XRCSTY <> FACSST OR
     C                             XRCLCD <> FACLAC OR
     C                             XREXMT <> FAEXEM
     C                   EVAL      WChange = 'Y'
     C                   ELSE
     C                   EVAL      WChange = 'N'
     C                   ENDIF
      *
     C                   IF        PMode <> 'F' AND WChange = 'Y'
     C                   EVAL      WRecFound = 'Y'                                          MD029618
     C                   WRITE     SD000104R1
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update Subroutine                                 *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdate      BEGSR
      *
      ** Save before image of SDFTCSPD
     C                   EVAL      PBefFTCS = SDFTCS
      ** Subject to Reporting
      ** Reason for Exemption
     C                   IF        FAEXEM <> XREXMT AND XREXMT = 'Y'
     C                   EVAL      FAREPT = 'N'
     C                   EVAL      FAEXER = ExemRem
     C                   EVAL      FAEXED = BJRDNB
     C                   TIME                    WTime
     C                   MOVE      WTime         FAEXET
     C                   EVAL      FAEXEU = PSUser
     C                   ENDIF
      ** High Value Indicator
     C                   IF        (FAEXEM <> XREXMT AND XREXMT = 'Y'
     C**********                   AND XRINFO = 'A') OR                                     MD027496
     C                             AND FTINFO = 'A') OR                                     MD027496
     C                             (FACSTY <> XRCUTP AND
     C                             XRCUTP = 'F')
     C                   EVAL      FAHVAC = 'N'
     C                   ENDIF
      *
      ** FATCA Customer SubType
     C                   EVAL      FACSST = XRCSTY
      ** FATCA Customer Type
     C                   EVAL      FACSTY = XRCUTP
      ** FATCA Information Complete
     C                   EVAL      FAINFC = XRINFO
      ** Exempt
     C                   EVAL      FAEXEM = XREXMT
      ** Last Change Date
     C                   EVAL      FALDAT = BJRDNB
      ** Last Change Type
     C                   EVAL      FALCTP = 'A'
      ** Last Change User Profile
     C                   EVAL      FALUSR = PSUser
      ** If classification has changed
     C                   IF        XRCLCD <> FACLAC
     C                             OR XRCLCD = FACLAC                                       MD027498
     C                             AND FTCLCD <> *BLANKS                                    MD027498
      ** Previous FATCA Classification
     C                   EVAL      FAPCLA = FACLAC
      ** FATCA Classification
     C                   EVAL      FACLAC = XRCLCD
      ** FATCA Classification Date
     C                   EVAL      FACLAD = BJRDNB
     C                   ENDIF
      *
      ** Save after image of SDFTCSPD
     C                   EVAL      PAftFTCS = SDFTCS
      *
      ** Update FATCA customer details
     C                   UPDATE    SDFTCSD0
      *
      ** Write to the History of Customer Information
     C                   IF        CSD092 = 'Y'
      *
     C                   CALL      'SD009696'
     C                   PARM      BBCUST        PCustNo
     C                   PARM      *BLANKS       PBefCUST
     C                   PARM      *BLANKS       PAftCUST
     C                   PARM      *BLANKS       PBefACUS
     C                   PARM      *BLANKS       PAftACUS
     C                   PARM                    PBefFTCS
     C                   PARM                    PAftFTCS
     C                   PARM      *BLANKS       PBefJACC
     C                   PARM      *BLANKS       PAftJACC
     C                   PARM      *BLANKS       PBefCUAH
     C                   PARM      *BLANKS       PAftCUAH
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      *BLANKS       PACRV
     C                   PARM      *BLANKS       PELEC
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdFile - Update Enquiry File Subroutine                   *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdFile     BEGSR
      *
      ** FATCA Customer
     C                   EVAL      FLCUST = XRCUST
      ** Local Institution Code
     C                   EVAL      FLLINC = XRLINC
      ** Local Institution Name
     C                   EVAL      FLLINM = XRLINM
      ** FATCA Customer Type
     C                   EVAL      FLCUTP = XRCUTP
      ** FATCA Customer SubType
     C                   EVAL      FLCSTY = XRCSTY
      ** FATCA Classification Code
     C                   EVAL      FLCLCD = XRCLCD
      ** FATCA Information Complete
     C                   EVAL      FLINFO = XRINFO
      ** Exempt
     C                   EVAL      FLEXMT = XREXMT
      *
     C                   WRITE     SDFTCLD0
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRetcd
     C                   PARM                    PMode
      *
      ** Access installation control data
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBPGM = 'SD000104'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Setup Header fields
     C                   EVAL      RRRUNA = BJMRDT
     C                   EVAL      RRTITL = BJURPT
 
      ** Check whether CSD092 is available
     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSD092'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtcd <> *Blanks
     C                   IF        PRtcd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = PSard
     C                   EVAL      DBASE  = 3
     C                   EVAL      DBPGM = 'SD000104'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      CSD092 = 'N'
     C                   ELSE
     C                   EVAL      CSD092 = 'Y'
     C                   ENDIF
      *
      ** Check system value TIN and/or date and place of birth for
      ** customer and NAH subject to reporting
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      SysVal1       SValK1
     C                   PARM                    SVal1
     C                   PARM      SysVal2       SValK2
     C                   PARM                    SVal2
     C                   PARM      SysVal3       SValK3
     C                   PARM                    SVal3
     C                   PARM      SysVal4       SValK4
     C                   PARM                    SVal4
     C                   PARM                    SValK5
     C                   PARM                    SVal5
     C                   PARM                    SValK6
     C                   PARM                    SVal6
     C                   PARM                    SValK7
     C                   PARM                    SVal7
     C                   PARM                    SValK8
     C                   PARM                    SVal8
     C                   PARM                    SValK9
     C                   PARM                    SVal9
     C                   PARM                    SValK0
     C                   PARM                    SVal10
 
     C                   IF        PRtcd <> *Blanks  AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBKEY = SValK1
     C                   EVAL      DBASE = 2
     C                   EVAL      DBPGM = 'SD000104'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Convert FATCA effective date to Midas Day Number
     C                   MOVE      SVal46        PDate
      *
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       PError
     C                   PARM                    PDate
     C                   PARM      BJDFIN        PDateFormat
     C                   PARM                    PDayNo
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   EVAL      DBPGM = 'SD000104'
     C                   DUMP
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2013
