     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD CRS Cust Type/Subtype Report&Update')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data module                                 *
      *                                                               *
      *  SD000304 - Midas SD CRS Customer Type/Subtype Allocation     *
      *             Report & Update                                   *
      *                                                               *
      *  Function:  This prints a list of customers matching defined  *
      *             criteria and what must be their CRS Customer Type *
      *             type (and sub-type if FFI/NFE)                    *
      *                                                               *
      *             If the program is called in update mode, it also  *
      *             updates the CRS Customer type (and sub-type if    *
      *             FFI/NFE)                                          *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD050780           Date 28Apr18               *
      *                 CGL177             Date 11Jan16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD050780 - Update mode dumps                                 *
      *  CGL177 - CRS Reporting Phase 2                               *
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
      ** CRS Customer Type/Subtype Allocation File
     FSDCRCTL0  IF   E           K DISK
      *
      ** CRS Customer Details File
     FSDCRSHL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** CRS Customer Details File
     FSDCRSDL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** CRS Customer Type/Subtype List File
     FSDCRCLL0  UF A E             DISK    INFSR(*PSSR)
      *
      ** Midas SD CRS Customer Type/Subtype Report
     FSD000304P1O    E             PRINTER INFSR(*PSSR)
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
      ** System value Foreign TIN Always Mandatory
     D SysVal1         C                   'CRSForTINMandatory'
      ** System value Local TIN Always Mandatory
     D SysVal2         C                   'CRSLocalTINMandatory'
      ** System value CSR Effective Date
     D SysVal3         C                   'CRSEffectStartDate'
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
      ** External DS Based On SDCRSHPD
     D SDCRSH        E DS                  EXTNAME(SDCRSHPD)
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

      ** Country of Tax Codes
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)

      ** File Information Data Structure for SD000304P1
     D SPOOL1          DS
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0

      ** Data structure for AOSVALR0 string
     D SVal1           DS           200
     D  SVal11                 1      1
     D SVal2           DS           200
     D  SVal21                 1      1
     D SVal3           DS           200
     D  SVal36                 1      6
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
     D PBefCUAH        S           5000A                                                    MD050780
     D PAftCUAH        S           5000A                                                    MD050780
     D PBefCUXC        S           5000A
     D PAftCUXC        S           5000A
     D PBefCRSH        S           5000A
     D PBefCRSH2       S           5000A
     D PAftCRSH        S           5000A
     D PBefCRSD        S           5000A
     D PAftCRSD        S           5000A
     D PACRV           S              1A
     D PELEC           S              1A
     D PCustN2         S              6A
     D WRecFound       S              1A
     D WSCTRY          S              1A
     D WCRSA           S              1A
     D WCNCD           S              2A
     D WCOLC           S              2A
     D @PCTRT          S              2A
     D @PCTRR          S              2A

      ** Parameter variables for AOSVALR0 string
     D SValK1          S             20
     D SValK2          S             20
     D SValK3          S             20
     D SValK4          S             20
     D SVal4           S            200
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
     C                   EVAL      WRecFound = 'N'
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
     C                   OPEN      SD000304P1

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
     C                   WRITE     SD000304R2
     C                   ENDIF
      *
     C                   DOW       NOT %EOF(SDCUSTL5)
      *
      *
      ** Retrieve CRS Customer Type/Subtype Allocation
     C     BBLINC        CHAIN     SDCRCTL0
      *
      ** Retrieve CRS Customer Details
     C     BBCUST        CHAIN     SDCRSHL0
      ** Save before image of SDCRSHPD
     C                   EVAL      PBefCRSH2 = SDCRSH
      *
      ** Retrieve Customer Extension
     C     BBCUST        CHAIN     SDCUSXL0
      *
     C                   IF        %FOUND(SDCRCTL0)
     C                             AND %FOUND(SDCRSHL0)
     C                   IF        CRTYPE = *BLANKS
     C                             AND (CRINFO = *BLANKS
     C                             OR CRINFO = 'N')

     C                   EXSR      SRDetails
      *
     C                   IF        PMode <> 'R' AND WChange = 'Y'
     C                   EXSR      SRUpdFile
     C                   ENDIF
      *
      ** If called in update mode, update CRS customer file with
      ** the CRS customer type (and sub-type if FFI/NFE)
      ** for the customer.
     C                   IF        PMode = 'U' AND WChange = 'Y'
     C                   EXSR      SRUpdate
     C                   ENDIF
      *
     C                   ENDIF
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

     C                   IF        WRecFound = 'N' AND PMode <> 'F'
     C                   WRITE     SD000304R2
     C                   ENDIF

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
     C                   WRITE     SD000304R0
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
     C                   EVAL      XRRPNM = BBCRNM
     C                   EVAL      XRRPTN = BBCRTN
     C                   EVAL      XRLINC = BBLINC
      ** CRS Customer Type
     C                   EVAL      XRTYPE = CTTYPE
      ** CRS Customer Sub-Type
     C                   EVAL      XRSTYP = CTSTYP
      ** CRS Information Complete
     C                   EVAL      XRINFO = CRINFO
      ** Exempt
     C                   EVAL      XREXMP = CREXMP
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
      ** If CRS Customer Type = 'O' or 'F' then set CRS Information
      ** and CRS Exempt Flag
     C                   IF        CTTYPE = 'O' OR CTTYPE = 'F'
      *
      ** Exempt
     C                   IF        CTEXMP = 'Y' OR CTEXMP = 'N'
     C                   EVAL      XREXMP = CTEXMP
     C                   ENDIF
      *
      ** Complete to 'A' only if all related validation rules are
      ** respected and the CRS Information Complete flag is 'A'
     C                   IF        CTINFO = 'A'
      *
     C                   EVAL      WSCTRY = 'Y'
      *
      ** CRS Country is Subject to Reporting and no TIN is defined and the country
      ** has a CRS agreement if required for the system value setting
     C     BBCUST        SETLL     SDCRSDL0
     C     BBCUST        READE     SDCRSDL0

     C                   DOW       NOT %EOF(SDCRSDL0)
      ** Get CRS agreement
     C                   EVAL      WCNCD = CDCTRY
     C                   EVAL      WCOLC = BBCOLC

     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WCNCD         @PCTRT
     C                   PARM      WCOLC         @PCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY

     C                   IF        PRTCD = '*NRF   '
     C                   EVAL      WCOLC = *BLANK
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WCNCD         @PCTRT
     C                   PARM      WCOLC         @PCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY
     C                   ENDIF

     C                   IF        PRTCD = *BLANK
     C                   EVAL      WCRSA = EWCRSA
     C                   ELSE
     C                   EVAL      WCRSA = *Blanks
     C                   ENDIF

     C                   IF        (CDREPT = 'Y'
     C                             AND CDTINN = *BLANKS)
      ** If CRS Country is Local Country
     C                   IF        BJCNCD = CDCTRY
     C                   IF        (WCRSA = 'Y'
     C                             OR SVAL21 = 'Y')
     C                   EVAL      WSCTRY = 'N'
     C                   LEAVE
     C                   ENDIF
     C                   ELSE
     C                   IF        (WCRSA = 'Y'
     C                             OR SVAL11 = 'Y')
     C                   EVAL      WSCTRY = 'N'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   IF        CDREPT = *BLANKS
     C                   EVAL      WSCTRY = 'N'
     C                   LEAVE
     C                   ENDIF

     C     BBCUST        READE     SDCRSDL0
     C                   ENDDO

      ** Retrieve additional customer details
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BBCUST        PCustNo
     C     SDACUS        PARM      SDACUS        DSLDY

     C                   IF        WSCTRY = 'Y'
     C                             AND CRHVAL <> *BLANKS
     C                   EVAL      XRINFO = CTINFO
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        CTINFO = 'N'
     C                   EVAL      XRINFO = CTINFO
     C                   ENDIF
     C                   ENDIF
      *
      ** Check whether record has changed
     C                   IF        XRINFO <> CRINFO OR
     C                             XRTYPE <> CRTYPE OR
     C                             XRSTYP <> CRSTYP OR
     C                             XREXMP <> CREXMP
     C                   EVAL      WChange = 'Y'
     C                   ELSE
     C                   EVAL      WChange = 'N'
     C                   ENDIF
      *
     C                   IF        PMode <> 'F' AND WChange = 'Y'
     C                   EVAL      WRecFound = 'Y'
     C                   WRITE     SD000304R1
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
      ** Save before image of SDCRSDPD
     C                   IF        CREXMP <> XREXMP AND XREXMP = 'Y'
      ** Exception Flag
     C                   EVAL      CREXMG = 'N'
      ** Reason Exempt
     C                   EVAL      CREXMR = ExemRem
      ** Exempt Date
     C                   EVAL      CREXMD = BJRDNB
     C                   TIME                    WTime
     C                   MOVE      WTime         CREXMT
     C                   EVAL      CREXMU = PSUser
     C                   ENDIF
      ** High Value Indicator
     C                   IF        (CREXMP <> XREXMP AND XREXMP = 'Y'
     C                             AND XRINFO = 'A') OR
     C                             (CRTYPE <> XRTYPE AND
     C                             XRTYPE = 'F')
     C                   EVAL      CRHVAL = 'N'
     C                   ENDIF
      *
      ** CRS Customer SubType
     C                   EVAL      CRSTYP = XRSTYP
      ** CRS Customer Type
     C                   EVAL      CRTYPE = XRTYPE
      ** CRS Information Complete
     C                   EVAL      CRINFO = XRINFO
      ** Exempt
     C                   EVAL      CREXMP = XREXMP
      *
      ** Update CRS customer details
     C                   UPDATE    SDCRSHD0
     C                   EVAL      PBefCRSH = PBefCRSH2
     C                   EVAL      PAftCRSH = SDCRSH
      *
      ** Write to the History of Customer Information
     C                   IF        CSD092 = 'Y'

     C                   CALL      'SD009696'
     C                   PARM      CRCUST        PCustN2
     C                   PARM      *BLANKS       PBefCUST
     C                   PARM      *BLANKS       PAftCUST
     C                   PARM      *BLANKS       PBefACUS
     C                   PARM      *BLANKS       PAftACUS
     C                   PARM      *BLANKS       PBefFTCS
     C                   PARM      *BLANKS       PAftFTCS
     C                   PARM      *BLANKS       PBefJACC
     C                   PARM      *BLANKS       PAftJACC
     C                   PARM      *BLANKS       PBefCUAH                                   MD050780
     C                   PARM      *BLANKS       PAftCUAH                                   MD050780
     C                   PARM      *BLANKS       PBefCUXC
     C                   PARM      *BLANKS       PAftCUXC
     C                   PARM      *BLANKS       PACRV
     C                   PARM      *BLANKS       PELEC
     C                   PARM                    PBefCRSH
     C                   PARM                    PAftCRSH
     C                   PARM      *BLANKS       PBefCRSD
     C                   PARM      *BLANKS       PAftCRSD
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
      ** CRS Customer
     C                   EVAL      CLCUST = XRCUST
      ** Local Institution Code
     C                   EVAL      CLLINC = XRLINC
      ** Local Institution Name
     C                   EVAL      CLLINM = XRLINM
      ** CRS Customer Type
     C                   EVAL      CLTYPE = XRTYPE
      ** CRS Customer SubType
     C                   EVAL      CLSTYP = XRSTYP
      ** CRS Information Complete
     C                   EVAL      CLINFO = XRINFO
      ** Exempt
     C                   EVAL      CLEXMP = XREXMP
      *
     C                   WRITE     SDCRCLD0

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
     C                   EVAL      DBPGM = 'SD000304'
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
     C                   EVAL      DBPGM = 'SD000304'
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
     C                   PARM                    SValK4
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
     C                   EVAL      DBPGM = 'SD000304'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Convert CRS effective date to Midas Day Number
     C                   MOVE      SVal36        PDate
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
     C                   EVAL      DBPGM = 'SD000304'
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
(c) Finastra International Limited 2016
