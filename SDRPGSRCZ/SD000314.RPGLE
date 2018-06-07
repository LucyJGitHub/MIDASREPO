     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CRS High Value A/C Iden Report & Update')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data module                                 *
      *                                                               *
      *  SD000314 - Midas SD CRS High Value Account Identification    *
      *             Report & Update                                   *
      *                                                               *
      *  Function:  This prints a list of customers matching defined  *
      *             criteria and their current overall value of assets*
      *             If the program is called in update mode, it also  *
      *             updates the high value indicator and              *
      *             classification for the customer.                  *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD039670           Date 26Jul16               *
      *  Prev Amend No. CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD039670 - FATCA Housekeeping program                        *
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
      *  SRCustDet - Customer Details Subroutine                      *
      *  SRNahoDet - Non Account Holder Details Subroutine            *
      *  SRUpdCust - Update CRS Customer Subroutine                   *
      *  SRUpdNaho - Update CRS Non Account Holder Subroutine         *
      *  SRUpdFile - Update Enquiry File Subroutine                   *
      *  SRCalcAst - Calculate Assets Subroutine                      *
      *  SRRtvCurr - Retrieve Currency Details                        *
      *  SRCvtAmount - Convert amount                                 *
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
     FSDCUSTL5  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Non Account Holders
     FSDNAHOL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Joint Accounts by Customer
     FSDJACCL4  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Joint Accounts by Non Account Holder
     FSDJACCL7  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDJACCD0:SDJACCD1)
      *
      ** Retail Accounts by Customer
     FACCNTLC   IF   E           K DISK    INFSR(*PSSR)
      *
      ** Customer Deals
     FCUSDE     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
      *
      ** Loans by Customer
     FLELOANLA  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Security Customer Positions
     FSESEPSLL  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Security Details
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
      *
      ** FF transactions by customer
     FTRANSC    IF   E           K DISK    INFSR(*PSSR)
      *
      ** Instrument Types File
     FINTYP     IF   E           K DISK    INFSR(*PSSR)
      *
      ** FF Market Price File
     FPRICS     IF   E           K DISK    INFSR(*PSSR)
      *
      ** CRS High Value Account Identification File
     FSDCRHVL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** CRS Customer Details File
     FSDCRSHL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FSDCRSHL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(A)
     F                                     RENAME(SDCRSHD0:SDCRSHD1)
      ** CRS Customer - Countries File
     FSDCRSDL2  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** CRS Non Account Holder Details File
     FSDCRNHL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** CRS Non-Account Holder - Countries File
     FSDCRSNL2  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** CRS High Value Account Identification List File
     FSDCRHLL0  UF A E             DISK    INFSR(*PSSR)
      *
      ** Account Review Details File
     FSDACRVL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Midas SD CRS High Value Account Identification Report
     FSD000314P1O    E             PRINTER INFSR(*PSSR)
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
      *
      ** Array Used In Currency Amount Conversion For ZAPNUM
     D POWER8          S              8  4 DIM(8) CTDATA PERRCD(1)
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** System value Low Value Depository Account
     D SysVal2         C                   'FATCALowValDepAcc'
     D SysVal1         C                   'CRSHighValCCY'
     D SysVal3         C                   'CRSHighValAmtEnt'
     D SysVal4         C                   'CRSHighValAmtInd'
     D SysVal5         C                   'CRSLowValAmount'
     D SysVvl1         C                   'AcRevDftFreq'
     D SysVvl2         C                   'CRSDiligenceHiEnt'
     D SysVvl3         C                   'CRSDiligenceHiInd'
     D SysVvl4         C                   'CRSDiligenceMedEnt'
     D SysVvl5         C                   'CRSDiligenceMedInd'
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
      ** External DS Based On SDACUSPD
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
      *
      ** External DS Based On SDCRSHPD
     D SDCRSH        E DS                  EXTNAME(SDCRSHPD)
      *
     D SDCRSD        E DS                  EXTNAME(SDCRSDPD)
      *
     D SDCRSDA       E DS                  EXTNAME(SDCRSDPD)
     D                                     PREFIX(R1:2)
      *
     D SDCRSDB       E DS                  EXTNAME(SDCRSDPD)
     D                                     PREFIX(R2:2)
      *
      ** External DS Based On SCSARDPD
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** External DS Based On SDCURRPD
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** External DS Based On SDNAHOPD
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
      *
      ** Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Extra Long Data Structure
     D DSLDY         E DS                  EXTNAME(DSLDY)

      ** File Information Data Structure for SD000314P1
     D SPOOL1          DS
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0

      ** Data structure for GPAOSVALR0 string
     D SVal1           DS           200
     D  SVal13                 1      3
     D SVal2           DS           200
     D SVal3           DS           200
     D  SVal313                1     13
     D SVal4           DS           200
     D  SVal413                1     13
     D SVal5           DS           200
     D  SVal513                1     13
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
     D PDate           S              5  0
     D PCurr           S              3A
     D PSard           S              6A
     D CSD092          S              1A
     D WRun            S              1A
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D PCustNo         S              6A
     D WChange         S              1A
     D WChgHv          S              1A
     D WHvAm           S             13  0
     D WCust           S              6
     D WHvIn           S              1A
     D PBefCUST        S           5000A
     D PAftCUST        S           5000A
     D PBefACUS        S           5000A
     D PAftACUS        S           5000A
     D PBefFTCS        S           5000A
     D PAftFTCS        S           5000A
     D PBefJACC        S           5000A
     D PAftJACC        S           5000A
     D PBefCUXC        S           5000A
     D PAftCUXC        S           5000A
     D PACRV           S              1A
     D PELEC           S              1A
     D PCustN2         S              6A
     D A               S              4S 0
     D HghValInd       S             13  0
     D HghValEnt       S             13  0
     D LowValue        S             13  0
     D KCCLC           S              5A
     D KCUTP           S              1A
     D KHVIN           S              1A
     D KCUST           S              6A
     D KSCDT           S              5  0
     D KSEQN           S              3  0
     D KISTT           S              5A
     D KYRNO           S              2  0
     D KMTHN           S              2  0
     D KPCAL           S              1A
     D KSTRP           S             15  8
     D PHGVI           S             18A
     D PHGVE           S             18A
     D PLVAM           S             18A
     D PHVCY           S              3A
     D WRCUTP          S              1A
     D WWCSCN          S              6
     D WWCSSV          S             10A
     D WWCSSC          S             10A
     D WWCSBA          S              3A
     D WWTVDN          S             15  0
     D WWAMT           S             19  3
     D WWQOTC          S              1  0
     D WSTRUPDN        S              1A
     D PTimeStamp      S             26Z
     D WTimeStamp      S             26A
     D WHHMMSS         S              6A
     D WHH             S              2A
     D WMM             S              2A
     D WSS             S              2A
     D WxALL           S              1A
     D WrSCDT          S              5  0
      ** Define work field Work File Date
     D PIDate          S              6A
     D PODate          S              5  0
     D PErrFlag        S              1A
     D PBefCRSH        S           5000A
     D PAftCRSH        S           5000A
     D PBefCRSD        S           5000A
     D PAftCRSD        S           5000A

     D WCRSDlgMedInd   S              6A
     D WCRSDlgHiInd    S              6A
     D WCRSDlgMedEnt   S              6A
     D WCRSDlgHiEnt    S              6A

      ** Parameter for AOCUSTR0
     D PKey1           S             10A
     D PKySt           S              7A
      ** Parameter for AONAHOR0
     D WFDCSNH         S             10A

      ** Parameter variables for GPAOSVALR0 string
     D SValK1          S             20
     D SValK2          S             20
     D SValK3          S             20
     D SValK4          S             20
     D SValK5          S             20
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

     D SVvlK1          S             20
     D SVvl1           S            200
     D SVvlK2          S             20
     D SVvl2           S            200
     D SVvlK3          S             20
     D SVvl3           S            200
     D SVvlK4          S             20
     D SVvl4           S            200
     D SVvlK5          S             20
     D SVvl5           S            200
     D SVvlK6          S             20
     D SVvl6           S            200
     D SVvlK7          S             20
     D SVvl7           S            200
     D SVvlK8          S             20
     D SVvl8           S            200
     D SVvlK9          S             20
     D SVvl9           S            200
     D SVvlK0          S             20
     D SVvl10          S            200

      ** Parameters for ZCONVZ1
     D ZAMTCI          S             15  0
     D ZEXCH           S             13P 8
     D ZMD             S              1
     D ZCCYI           S              3
     D ZCCYO           S              3
     D ZCDPI           S              1  0
     D ZCDPO           S              1  0
     D ZAMTCO          S             15  0

      ** Parameters for ZXRATE
     D ZRATE1          S             13P 8
     D ZMDI1           S              1
     D ZRATE2          S             13P 8
     D ZMDI2           S              1
     D ZRATEX          S             13P 8
     D ZMDIX           S              1

      ** Parameters for ZSEDIT
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D ZOUT21          S             21

      ** Parameters for ZALIGN
     D ZALIGNOK        S              1
     D ZFIELD          S             16
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0

      ** Parameters for ZAPNUM
     D ZNOML           S             11  0
     D ZAVPR           S             15  8
     D ZNMDP           S              1  0
     D ZNMCD           S              1  0
     D ZPRCB           S              1
     D ZVALU           S             15  0
     D ZVAL0           S             15  0
     D ZVAL1           S             15  1
     D ZVAL2           S             15  2
     D ZVAL3           S             15  3
     D ZI              S              1  0

      ** Parameters for FFTVCL
     D FFNOC           S              5  0
     D FFTKDM          S              3  0
     D FFMNPF          S             15  8
     D FFNOT1          S             16  3
     D FFTNVL          S             13  0
     D FFNOTK          S             13  0

     D FFFP            DS            15
     D  FFPRIC                 1     15  8
     D  FFINTG                 1      7  0
     D  FFIN                   1      7
     D  FFDCN1                 8      8  0
     D  FFDCN2                 8      9  0
     D  FFDCN3                 8     10  0
     D  FFDECN                 8     10  0
     D  FFDECD                 8     15  0
     D  FFDECA                 8     15
     D  FFDCN4                 9     11  3
     D  FFDCN5                10     12  3
     D  FFDCN6                11     13  3

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
     C                   READ      SDCRSHL0
      ** Save before image of SDCRSHPD
     C                   EVAL      PBefCRSH = SDCRSH
     C                   READ      SDCRNHL0
      *
     C                   IF        PMode <> 'F'
     C                   OPEN      SD000314P1

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
     C                   IF        %EOF(SDCRSHL0) AND %EOF(SDCRNHL0)
     C                             AND PMode <> 'F'
     C                   WRITE     SD000314R2
     C                   ENDIF
      *
     C                   EXSR      SRCust
     C                   EXSR      SRNaho
      *
     C                   COMMIT
     C                   EVAL      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHeader - Header subroutine                                 *
      *                                                               *
      *  Called by: SRCust, SRNaho                                    *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRHeader      BEGSR
      *
     C                   WRITE     SD000314R0
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCust   - Customer Details Subroutine                       *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRCust        BEGSR
      *
      ** Retrieve CRS Customer Details
     C                   DOW       NOT %EOF(SDCRSHL0)
     C                   IF        CRHVAL <> 'N'
     C                             AND CRHVAL <> 'H'
     C                             AND CRINFO <> 'Y'
     C                             AND CRTYPE <> 'F'
     C                             AND CRTYPE <> *BLANKS
      *
      ** Check Criteria List versus CRS Type of Record read
     C                   EVAL      KCUTP = CRTYPE
     C                   EVAL      KHVIN = 'L'
     C                   EVAL      WxALL = 'N'
      *
     C     KCRHVF        CHAIN     SDCRHVL1
      *
     C                   IF        NOT %FOUND(SDCRHVL1)
     C     *LOVAL        SETLL     SDCRHVL1
     C                   READ      SDCRHVL1
     C                   IF        HVCUTP = '*'
     C                   EVAL      WxALL = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
     C     KCRHVF        CHAIN     SDCRHVL1
      *
     C                   IF        %FOUND(SDCRHVL1)
     C                             OR WxALL = 'Y'
      *
      ** Retrieve Customer Report Name and Town
     C                   Eval      PKey1 = CRCUST

     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PKey1
     C                   PARM                    PKySt
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   EVAL      WHvAm = 0
     C                   EVAL      WHvIn = *BLANKS
     C                   MOVE      BBCUST        WCust
      *
      ** Calculate assets
     C                   EXSR      SRCalcAst
      *
      ** Check whether customer has any joint accounts
      ** If so, add the assets from the joint accounts
     C     BBCUST        SETLL     SDJACCL4
     C     BBCUST        READE     SDJACCL4
      *
     C                   DOW       NOT %EOF(SDJACCL4)
     C     JCJANO        CHAIN     SDCRSHL1
     C                   IF        %FOUND(SDCRSHL1) AND
     C                             ACRTYPE = 'J' AND
     C                             ACRHVAL <> 'N'
     C                   MOVE      JCJANO        WCust
      *
      ** Calculate assets
     C                   EXSR      SRCalcAst
     C                   ENDIF
     C     BBCUST        READE     SDJACCL4
     C                   ENDDO
      *
      ** Allocate high value indicator
     C                   SELECT
     C                   WHEN      CRTYPE = 'P' and WHvAM >= HghValInd
     C                   EVAL      WHvIn = 'H'
     C                   WHEN      CRTYPE <> 'P'and WHvAM >= HghValEnt
     C                   EVAL      WHvIn = 'H'
     C                   WHEN      CRTYPE = 'P' AND WHvAM < HghValInd
     C                             AND WHvAm >= LowValue
     C                   EVAL      WHvIn = 'M'
     C                   WHEN      CRTYPE <> 'P' AND WHvAM < HghValEnt
     C                             AND WHvAm >= LowValue
     C                   EVAL      WHvIn = 'M'
     C                   OTHER
     C                   EVAL      WHvIn = 'L'
     C                   ENDSL
      *
      ** Check whether record exists on decision table
     C                   EXSR      SRCustDet
      *
     C                   IF        PMode <> 'R'
     C                   EXSR      SRUpdFile
     C                   ENDIF
      *
      ** If called in update mode, update CRS customer file with
      ** the High Value Indicator for the customer.
     C                   IF        PMode = 'U'
     C                   EXSR      SRUpdCust
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check whether new page is required
     C                   IF        PMode <> 'F'
     C                   EVAL      RqdLn1 = 2
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

     C                   IF        DifLn1 <= RqdLn1
     C                   EXSR      SRHeader
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      SDCRSHL0
      ** Save before image of SDCRSHPD
     C                   EVAL      PBefCRSH = SDCRSH
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNaho - Non Account Holder Detail Subroutine                *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRNaho        BEGSR
      *
      ** Retrieve CRS NAHO Details
     C                   DOW       NOT %EOF(SDCRNHL0)
                                                                                            MD039670
     C                   CALLB     'AONAHOR0'                                               MD039670
     C                   PARM      *BLANKS       Prtcd                                      MD039670
     C                   PARM      '*KEY   '     POptn                                      MD039670
     C                   PARM                    NRNAHO                                     MD039670
     C     SDNAHO        PARM      SDNAHO        DSSDY                                      MD039670
     C                   IF        PRTCD = '*NRF'                                           MD039670
     C                             OR NHCHTP = 'D'                                          MD039670
     C                   READ      SDCRNHL0                                                 MD039670
     C                   ITER                                                               MD039670
     C                   ENDIF                                                              MD039670
     C                   IF        NRHVAL <> 'N'
     C                             AND NRHVAL <> 'H'
     C                             AND NRINFO <> 'Y'
     C                             AND NRTYPE <> 'F'
     C                             AND NRTYPE <> *BLANKS

      *
      ** Check Criteria List versus CRS Type of Record read
     C                   EVAL      KCUTP = NRTYPE
     C                   EVAL      KHVIN = 'L'
     C                   EVAL      WxALL = 'N'
      *
     C     KCRHVF        CHAIN     SDCRHVL1
      *
     C                   IF        NOT %FOUND(SDCRHVL1)
     C     *LOVAL        SETLL     SDCRHVL1
     C                   READ      SDCRHVL1
     C                   IF        HVCUTP = '*'
     C                   EVAL      WxALL = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
     C     KCRHVF        CHAIN     SDCRHVL1
      *
     C                   IF        %FOUND(SDCRHVL1)
     C                             OR WxALL = 'Y'
      *
      ** Retrieve NAHO Report Name and Town
     C                   EVAL      WFDCSNH = NRNAHO
      *
     C                   CALLB     'AONAHOR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    WFDCSNH
     C     SDNAHO        PARM      SDNAHO        DSSDY
      *
     C                   EVAL      WHvAm = 0
     C                   EVAL      WHvIn = *BLANKS
      *
      ** Check whether non account holder is part of a joint account
      ** If so, add the assets from the joint accounts
     C     NHNAHO        SETLL     SDJACCL7
     C     NHNAHO        READE     SDJACCL7
      *
     C                   DOW       NOT %EOF(SDJACCL7)
     C     JCJANO        CHAIN     SDCRSHL1
     C                   IF        %FOUND(SDCRSHL1) AND
     C                             ACRTYPE = 'J' AND
     C                             ACRHVAL <> 'N'
     C                   MOVE      JCJANO        WCust
      *
      ** Calculate assets
     C                   EXSR      SRCalcAst
     C                   ENDIF
     C     NHNAHO        READE     SDJACCL7
     C                   ENDDO
      *
      ** Allocate high value indicator
     C                   SELECT
     C                   WHEN      CRTYPE = 'P' and WHvAM >= HghValInd
     C                   EVAL      WHvIn = 'H'
     C                   WHEN      CRTYPE <> 'P'and WHvAM >= HghValEnt
     C                   EVAL      WHvIn = 'H'
     C                   WHEN      NRTYPE = 'P' AND WHvAM < HghValInd
     C                             AND WHvAm >= LowValue
     C                   EVAL      WHvIn = 'M'
     C                   WHEN      NRTYPE <> 'P' AND WHvAM < HghValEnt
     C                             AND WHvAm >= LowValue
     C                   EVAL      WHvIn = 'M'
     C                   OTHER
     C                   EVAL      WHvIn = 'L'
     C                   ENDSL
      *
      ** Check whether record exists on decision table
     C                   EXSR      SRNahoDet
      *
     C                   IF        PMode <> 'R'
     C                   EXSR      SRUpdFile
     C                   ENDIF
      *
      ** If called in update mode, update CRS Non Account Holder
      ** file with the High Value Indicator for the Non Account Holder.
     C                   IF        PMode = 'U'
     C                   EXSR      SRUpdNaho
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check whether new page is required
     C                   IF        PMode <> 'F'
     C                   EVAL      RqdLn1 = 2
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

     C                   IF        DifLn1 <= RqdLn1
     C                   EXSR      SRHeader
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      SDCRNHL0
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCalcAst - Calculate Assets Subroutine                      *
      *                                                               *
      *  Called by: SRCust, SRNaho                                    *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRCalcAst     BEGSR
      *
      ** Retail and Saving Accounts
     C     WCust         SETLL     ACCNTLC
     C     WCust         READE     ACCNTLC
     C                   DOW       NOT %EOF(ACCNTLC)
      *
      ** Saving accounts
     C                   IF        STYP = 'S' AND LDBL < 0
      *
      ** Convert to high value currency
     C                   EVAL      PCurr = CCY
     C                   EXSR      SRRtvCurr
     C                   EVAL      ZRATE1 = A6SPRT
     C                   EVAL      ZMDI1 = A6MDIN
     C                   EVAL      ZCCYI = PCurr
     C                   EVAL      ZCDPI = A6NBDP
     C                   EVAL      ZAMTCI = LDBL * -1
     C                   EXSR      SRCvtAmount
     C                   ADD       ZAMTCO        WHvAm
      *
     C                   ENDIF
     C     WCust         READE     ACCNTLC
     C                   ENDDO
      *
      ** Money market and Fiduciary Deposits
     C     WCust         SETLL     DEALSDCF
     C     WCust         READE     DEALSDCF                               80
     C                   DOW       *IN80 = *OFF
      *
     C                   IF        RECI = 'D' AND (DTYP = 'TD' OR
     C                             DTYP = 'IT' OR DTYP = 'CD' OR
     C                             DTYP = 'CI' OR DTYP = 'FT' OR
     C                             DTYP = 'DT' OR DTYP = 'LT')
      *
      ** Convert to high value currency
     C                   EVAL      PCurr = CCY
     C                   EXSR      SRRtvCurr
     C                   EVAL      ZRATE1 = A6SPRT
     C                   EVAL      ZMDI1 = A6MDIN
     C                   EVAL      ZCCYI = PCurr
     C                   EVAL      ZCDPI = A6NBDP
     C                   EVAL      ZAMTCI = PCPL
     C                   EXSR      SRCvtAmount
     C                   ADD       ZAMTCO        WHvAm

     C                   ENDIF
     C     WCust         READE     DEALSDCF                               80
     C                   ENDDO
      *
      ** Customer Lending Participations Sold
     C     WCust         SETLL     LELOANLA
     C     WCust         READE     LELOANLA
     C                   DOW       NOT %EOF(LELOANLA)
      *
     C                   IF        PTYP = 66 OR PTYP = 67 OR
     C                             PTYP = 69 OR PTYP = 72
      *
      ** Convert to high value currency
     C                   EVAL      PCurr = CCY
     C                   EXSR      SRRtvCurr
     C                   EVAL      ZRATE1 = A6SPRT
     C                   EVAL      ZMDI1 = A6MDIN
     C                   EVAL      ZCCYI = PCurr
     C                   EVAL      ZCDPI = A6NBDP
     C                   EVAL      ZAMTCI = CPAM
     C                   EXSR      SRCvtAmount
      *
     C                   ADD       ZAMTCO        WHvAm
     C                   ENDIF
     C     WCust         READE     LELOANLA
     C                   ENDDO
      *
      ** Foreign Exchange Deals
     C     WCust         SETLL     DEALSDBF
     C     WCust         READE     DEALSDBF                               80
     C                   DOW       *IN80 = *OFF
      *
     C                   IF        RECI = 'D' AND (DTYP = 'FS' OR
     C                             DTYP = 'FP' OR DTYP = 'CX' OR
     C                             DTYP = 'SW' OR DTYP = 'OP' OR
     C                             DTYP = 'OT' OR DTYP = 'SI' OR
     C                             DTYP = 'PI')
      *
      ** Convert to high value currency
     C                   EVAL      PCurr = SLCY
     C                   EXSR      SRRtvCurr
     C                   EVAL      ZRATE1 = A6SPRT
     C                   EVAL      ZMDI1 = A6MDIN
     C                   EVAL      ZCCYI = PCurr
     C                   EVAL      ZCDPI = A6NBDP
     C                   EVAL      ZAMTCI = SLAM
     C                   EXSR      SRCvtAmount
      *
     C                   ADD       ZAMTCO        WHvAm
     C                   ENDIF
      *
     C     WCust         READE     DEALSDBF                               80
     C                   ENDDO
      *
      ** Forward Rate Agreements
     C     WCust         SETLL     DEALSDGF
     C     WCust         READE     DEALSDGF                               80
     C                   DOW       *IN80 = *OFF
      *
     C                   IF        RECI = 'D' AND (DTYP = 'FR' OR
     C                             DTYP = 'RS' OR DTYP = 'RX' OR
     C                             (DTYP = 'RP' and BYSL = 'B') OR
     C                             (DTYP = 'RR' and BYSL = 'B') OR
     C                             (DTYP = 'RF' and BYSL = 'S'))
      *
      ** Convert to high value currency
     C                   IF        DTYP = 'RX'
     C                   EVAL      PCurr = TCUCY
     C                   EVAL      ZAMTCI = TPAMT
     C                   ELSE
     C                   EVAL      PCurr = UCUCY
     C                   EVAL      ZAMTCI = UPAMT
     C                   ENDIF
      *
     C                   EXSR      SRRtvCurr
     C                   EVAL      ZRATE1 = A6SPRT
     C                   EVAL      ZMDI1 = A6MDIN
     C                   EVAL      ZCCYI = PCurr
     C                   EVAL      ZCDPI = A6NBDP
     C                   EXSR      SRCvtAmount
      *
     C                   ADD       ZAMTCO        WHvAm
     C                   ENDIF
      *
     C     WCust         READE     DEALSDGF                               80
     C                   ENDDO
      *
      ** Securities Customer Positions
     C                   MOVE      BBCUST        WWCSCN
     C                   MOVE      *LOVAL        WWCSSV
     C     KSCSEP        SETLL     SESEPSLL
     C                   READ      SESEPSLL                               47
      *
     C                   DOW       *IN47 = *OFF AND WWCSCN = CSCN
     C                   EVAL      WWCSSC = CSSC
     C                   EVAL      WWCSBA = CSBA
     C                   EVAL      WWTVDN = 0
     C                   DOW       WWCSSC = CSSC  AND WWCSBA = CSBA
     C                             AND *IN47 = *OFF
     C                   ADD       CSNV          WWTVDN
     C                   READ      SESEPSLL                               47
     C                   ENDDO
      *
     C     WWCSSC        CHAIN     SECTY                              48
     C                   IF        *IN48 = *ON OR CHTP = 'D'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SECTY'
     C                   EVAL      DBKEY  = WWCSSC
     C                   EVAL      DBASE  = 5
     C                   EVAL      DBPGM = 'SD000314'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      PCurr = NMCY
     C                   EXSR      SRRtvCurr
      *
      ** Calculate 'Market Value Of Security' In Nominal Ccy Using
      ** Standard Subroutine ZAPNUM
     C                   EVAL      ZNOML =  WWTVDN
     C                   EVAL      ZAVPR = MKPR
     C                   EVAL      ZNMDP = NMDP
     C                   EVAL      ZNMCD = A6NBDP
     C                   EVAL      ZPRCB = SPBS
     C                   EXSR      ZAPNUM
      *
      ** Convert to high value currency
     C                   IF        ZVALU > 0
     C                   EVAL      PCurr = NMCY
     C                   EXSR      SRRtvCurr
     C                   EVAL      ZRATE1 = A6SPRT
     C                   EVAL      ZMDI1 = A6MDIN
     C                   EVAL      ZCCYI = PCurr
     C                   EVAL      ZCDPI = A6NBDP
     C                   EVAL      ZAMTCI = ZVALU
     C                   EXSR      SRCvtAmount
     C                   ADD       ZAMTCO        WHvAm
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Futures and Options
     C                   MOVE      BBCUST        WWCSCN
      *
      ** Read the FF Transactions File
     C     WWCSCN        SETLL     TRANSC
     C                   READ      TRANSC                                 49
      *
     C                   DOW       *IN49 = *OFF AND WWCSCN = CUSC
     C                   EVAL      WWAMT = 0
      *
      ** Only trades with a Transaction Type 'S' (Sold) must be reported
     C                   IF        TRTY = 'S'
      *
      ** Get FF Instrument Types record
     C     ISTT          CHAIN     INTYP
      *
     C                   IF        NOT %FOUND(INTYP)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'INTYP'
     C                   EVAL      DBKEY  = BBCUST
     C                   EVAL      DBASE  = 6
     C                   EVAL      DBPGM = 'SD000314'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Futures with the Instrument Processing Type equal to 7
      ** (Australian) and Options with the Instrument Processing Type
      ** equal to 8 (Australian) must be ignored
     C                   IF        ISPT <> 7 AND ISPT <> 8
      *
     C                   IF        ISPT = 5
     C                   MOVE      OTHC          PCurr
     C                   ELSE
     C                   MOVE      ISCY          PCurr
     C                   ENDIF
      *
     C                   EXSR      SRRtvCurr
      *
      ** Get FF Market Prices record
     C                   IF        ISPT <> 5
     C                   EVAL      KISTT = ISTT
     C                   EVAL      KYRNO = YRNO
     C                   EVAL      KMTHN = MTHN
     C                   EVAL      KPCAL = PCAL
     C                   EVAL      KSTRP = STRP
     C     KPRIC         CHAIN     PRICS
      *
     C                   IF        %FOUND(PRICS)
      *
     C                   IF        ISPT = 1 OR ISPT = 4
     C                   EVAL      NEWP = 100 - NEWP
     C                   ENDIF
      *
     C                   EVAL      FFNOC = NOCO
     C                   EVAL      FFPRIC = NEWP
     C                   EVAL      FFTKDM = TKDM
     C                   EVAL      FFMNPF = MNPF
     C                   EXSR      FFTVCL
     C                   EVAL      WWAMT = FFTNVL * TKVL
     C                   EVAL      WWAMT = WWAMT * 1000
      *
     C                   ENDIF
      *
      ** Instrument processing type = 5
     C                   ELSE
     C                   EVAL      WWAMT = NOCO * CCAM
     C                   EVAL      WWAMT = WWAMT * 1000
     C                   ENDIF
      *
     C                   IF        WWAMT > 0
      *
     C                   IF        QOTC < 0
     C                   Z-SUB     QOTC          WWQOTC
     C                   DO        WWQOTC
     C                   EVAL      WWAMT = WWAMT / 10
     C                   ENDDO
     C                   ENDIF
      *
     C                   EXSR      SRRtvCurr
     C                   EVAL      ZRATE1 = A6SPRT
     C                   EVAL      ZMDI1 = A6MDIN
     C                   EVAL      ZCCYI = PCurr
     C                   EVAL      ZCDPI = A6NBDP
     C                   EVAL      ZAMTCI = WWAMT
     C                   EXSR      SRCvtAmount
     C                   ADD       ZAMTCO        WHvAm
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   READ      TRANSC                                 49
     C                   ENDDO
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCustDet - Customer Details subroutine                      *
      *                                                               *
      *  Called by: SRCust                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRCustDet     BEGSR
      *
      ** Customer Details
     C                   EVAL      XRCUST = BBCUST
     C                   EVAL      XRRPNM = BBCRNM
     C                   EVAL      XRRPTN = BBCRTN
      *
      ** If the field 'Subject to Reporting' is updated to N (No) indicator
     C                   EVAL      WSTRUPDN = 'N'
      *
      ** CRS Customer Type
     C                   EVAL      WRCUTP = CRTYPE
      *
      ** High Value Calculated
     C                   EVAL      ZFLD15 = WHvAm
     C                   EVAL      ZDECS = ZCDPO
     C                   EXSR      SRFmtAmount
     C                   MOVE      ZOUT21        XRHVAM
      *
      ** Check whether High Value Indicator can be changed
     C                   IF        (CRHVAL = *BLANKS AND WHvIn <>
     C                             *BLANKS) OR
     C                             (CRHVAL = 'L' AND WHvIn = 'M') OR
     C                             (CRHVAL = 'L' AND WHvIn = 'H') OR
     C                             (CRHVAL = 'M' AND WHvIn = 'H')
     C                   EVAL      XRHVIN = WHvIn
     C                   EVAL      WChgHV = 'Y'
     C                   ELSE
     C                   EVAL      XRHVIN = CRHVAL
     C                   EVAL      WChgHV = 'N'
     C                   ENDIF
      *
      ** Check decision table
     C                   EVAL      KCUTP = '*'
     C                   EVAL      KHVIN = XRHVIN
     C     KCRHVF        CHAIN     SDCRHVL1
     C                   IF        %FOUND(SDCRHVL1)
     C                   EVAL      XRSUBJ = HVSUBJ
     C                   IF        HVSUBJ = *BLANKS
     C                   GOTO      GetXRSUBJ
     C                   ENDIF
     C                   ELSE
      *
     C                   EVAL      KCUTP = CRTYPE
     C                   EVAL      KHVIN = XRHVIN
     C     KCRHVF        CHAIN     SDCRHVL1
     C                   IF        %FOUND(SDCRHVL1)
     C                   EVAL      XRSUBJ = HVSUBJ
     C                   IF        HVSUBJ = *BLANKS
     C                   GOTO      GetXRSUBJ
     C                   ENDIF
     C                   ELSE
     C     GetXRSUBJ     TAG
      ** Get the initial Subject to Reporting
     C     BBCUST        SETLL     SDCRSDL2
     C     BBCUST        CHAIN     SDCRSDL2
      *
     C                   EVAL      XRSUBJ = CDREPT
     C                   ENDIF
     C                   ENDIF
      *
      ** Subject to Reporting
     C                   IF        (WHvIn = 'L' AND HVSUBJ = 'N'
     C                             AND WChgHV = 'Y') OR
     C                             (XRHVIN = 'L' AND HVSUBJ = 'N'
     C                             AND WChgHV = 'Y')
     C                   EVAL      XRSUBJ = 'N'
     C                   EVAL      WSTRUPDN = 'Y'
     C                   ENDIF
      *
      ** Check whether record has changed
     C                   IF        XRHVIN <> CRHVAL
     C                   EVAL      WChange = 'Y'
     C                   ELSE
     C                   EVAL      WChange = 'N'
     C                   ENDIF
      *
     C                   IF        PMode <> 'F'
     C                   WRITE     SD000314R1
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNahoDet - Non Account Holder Details subroutine            *
      *                                                               *
      *  Called by: SRNaho                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRNahoDet     BEGSR
      *
      ** Non Account Holder Details
     C                   EVAL      XRCUST = NHNAHO
     C                   EVAL      XRRPNM = NHNARN
     C                   EVAL      XRRPTN = NHNATW
      *
      ** If the field 'Subject to Reporting' is updated to N (No) indicator
     C                   EVAL      WSTRUPDN = 'N'
      *
      ** CRS NAHO Type
     C                   EVAL      WRCUTP = NRTYPE
      *
      ** High Value Calculated
     C                   EVAL      ZFLD15 = WHvAm
     C                   EVAL      ZDECS = ZCDPO
     C                   EXSR      SRFmtAmount
     C                   MOVE      ZOUT21        XRHVAM
      *
      ** Check whether High Value Indicator can be changed
     C                   IF        (NRHVAL = *BLANKS AND WHvIn <>
     C                             *BLANKS) OR
     C                             (NRHVAL = 'L' AND WHvIn = 'M') OR
     C                             (NRHVAL = 'L' AND WHvIn = 'H') OR
     C                             (NRHVAL = 'M' AND WHvIn = 'H')
     C                   EVAL      XRHVIN = WHvIn
     C                   EVAL      WChgHV = 'Y'
     C                   ELSE
     C                   EVAL      XRHVIN = NRHVAL
     C                   EVAL      WChgHV = 'N'
     C                   ENDIF
      *
      ** Check decision table
     C                   EVAL      KCUTP = '*'
     C                   EVAL      KHVIN = XRHVIN
     C     KCRHVF        CHAIN     SDCRHVL1
     C                   IF        %FOUND(SDCRHVL1)
     C                   EVAL      XRSUBJ = HVSUBJ
     C                   ELSE
      *
     C                   EVAL      KCUTP = NRTYPE
     C                   EVAL      KHVIN = XRHVIN
     C     KCRHVF        CHAIN     SDCRHVL1
     C                   IF        %FOUND(SDCRHVL1)
     C                   EVAL      XRSUBJ = HVSUBJ
     C                   ELSE
      ** Get the initial Subject to Reporting
     C     NHNAHO        SETLL     SDCRSNL2
     C     NHNAHO        CHAIN     SDCRSNL2
      *
     C                   EVAL      XRSUBJ = CNREPT
     C                   ENDIF
     C                   ENDIF
      *
      ** Subject to Reporting
     C                   IF        (WHvIn = 'L' AND HVSUBJ = 'N'
     C                             AND WChgHV = 'Y') OR
     C                             (XRHVIN = 'L' AND HVSUBJ = 'N'
     C                             AND WChgHV = 'Y')
     C                   EVAL      XRSUBJ = 'N'
     C                   EVAL      WSTRUPDN = 'Y'
     C                   ENDIF
      *
      ** Check whether record has changed
     C                   IF        XRHVIN <> NRHVAL
     C                   EVAL      WChange = 'Y'
     C                   ELSE
     C                   EVAL      WChange = 'N'
     C                   ENDIF
      *
     C                   IF        PMode <> 'F'
     C                   WRITE     SD000314R1
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdCust - Update CRS Customer Subroutine                   *
      *                                                               *
      *  Called by: SRCust                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdCust     BEGSR
      *
      ** High Value Indicator
     C                   EVAL      CRHVAL = XRHVIN
     C                   EVAL      A = 1
      *
      ** Subject to Reporting
     C     BBCUST        SETLL     SDCRSDL2
     C     BBCUST        READE     SDCRSDL2
      *
     C                   DOW       NOT %EOF(SDCRSDL2)
     C                   EVAL      SDCRSDB = SDCRSD
     C                   EVAL      CDREPT = XRSUBJ
     C                   IF        WSTRUPDN = 'Y'
     C                   EVAL      CDREPR = 'Updated by High Value Account' +
     C                             'Identification Tool'
     C                   EVAL      CDREPD = BJRDNB
     C                   EVAL      CDREPU = PSUser
     C                   EXSR      SrTimeStamp
     C                   EVAL      CDREPM = WHHMMSS
     C                   ENDIF
     C                   EVAL      SDCRSDA = SDCRSD
     C                   IF        SDCRSDB <> SDCRSDA
     C                   EVAL      %SUBST(PBefCRSD:A:218) = SDCRSDB
     C                   EVAL      %SUBST(PAftCRSD:A:218) = SDCRSDA
     C                   EVAL      A = A + 218
     C                   ENDIF
     C                   UPDATE    SDCRSDD0
     C     BBCUST        READE     SDCRSDL2
     C                   ENDDO
      *
      ** Save after image of SDCRSHPD
     C                   EVAL      PAftCRSH = SDCRSH
      *
      ** Update CRS customer details
     C                   UPDATE    SDCRSHD0
      *
      ** Generate an account review if the high value indicator is
      ** changed to high
     C                   IF        CSD092 = 'Y'
      *
      ** CRS Existing A/C - Individual/Medium
     C                   SELECT
     C                   WHEN      CRTYPE = 'P' AND CRHVAL = 'M'
     C                   MOVE      WCRSDlgMedInd PIDate
     C                   EXSR      SRMdasDay
     C                   EVAL      WRSCDT = PODate

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
     C                   PARM      *BLANKS       PBefCUXC
     C                   PARM      *BLANKS       PAftCUXC
     C                   PARM      *BLANKS       PACRV
     C                   PARM      *BLANKS       PELEC
     C                   PARM                    PBefCRSH
     C                   PARM                    PAftCRSH
     C                   PARM                    PBefCRSD
     C                   PARM                    PAftCRSD

      ** CRS Existing A/C - Individual/High

     C                   WHEN      CRTYPE = 'P' AND CRHVAL = 'H'
     C                   MOVE      WCRSDlgHiInd  PIDate
     C                   EXSR      SRMdasDay
     C                   EVAL      WRSCDT = PODate

      ** CRS Existing A/C - Entity/Medium
     C
     C                   WHEN      CRTYPE <> 'P' AND CRHVAL = 'M'
     C                   MOVE      WCRSDlgMedEnt PIDate
     C                   EXSR      SRMdasDay
     C                   EVAL      WRSCDT = PODate

      ** CRS Existing A/C - Entity/High

     C                   WHEN      CRTYPE <> 'P' AND CRHVAL = 'H'
     C                   MOVE      WCRSDlgHiEnt  PIDate
     C                   EXSR      SRMdasDay
     C                   EVAL      WRSCDT = PODate

     C                   ENDSL
      *
     C                   IF        WChgHv = 'Y' and  XRHVIN = 'H'
      *
     C                   EVAL      KCUST = XRCUST
     C                   EVAL      KSCDT = BJRDNB
     C                   EVAL      KSEQN = 999
     C     KACRV         SETGT     SDACRVL0
     C                   READP     SDACRVL0
      *
     C                   IF        ARCUST = KCUST AND
     C                             ARSCDT = KSCDT
     C                   EVAL      ARSEQN = ARSEQN + 1
     C                   ELSE
     C                   EVAL      ARSEQN = 1
     C                   ENDIF
      *
     C                   EVAL      ARCUST = XRCUST
     C                   EVAL      ARPURP = 'CRS High Value +
     C                                      Account Review'
     C                   EVAL      ARSCDT = WRSCDT
     C                   EVAL      ARACRF = *BLANKS
     C                   EVAL      ARCOMP = 'N'
     C                   EVAL      ARMAGE = 'G'
     C                   EVAL      ARLTYP = 'I'
     C                   EVAL      ARLUSR = PSUser
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    ARTMST
      *
     C                   WRITE     SDACRVD0
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdNaho - Update CRS Non Account Holder Subroutine         *
      *                                                               *
      *  Called by: SRNaho                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdNaho     BEGSR
      *
      ** High Value Indicator
     C                   EVAL      NRHVAL = XRHVIN
      *
      ** Subject to Reporting
     C     NHNAHO        SETLL     SDCRSNL2
     C     NHNAHO        READE     SDCRSNL2
      *
     C                   DOW       NOT %EOF(SDCRSNL2)
     C                   EVAL      CNREPT = XRSUBJ
     C                   IF        WSTRUPDN = 'Y'
     C                   EVAL      CNREPR = 'Updated by High Value Account' +
     C                             'Identification Tool'
     C                   EVAL      CNREPD = BJRDNB
     C                   EVAL      CNREPU = PSUser
     C                   EXSR      SrTimeStamp
     C                   EVAL      CNREPM = WHHMMSS
     C                   ENDIF
     C                   UPDATE    SDCRSND0
     C     NHNAHO        READE     SDCRSNL2
     C                   ENDDO
      *
      ** Last Change Date
     C                   EVAL      NRLCDT = BJRDNB
      *
      ** Last Change Type
     C                   EVAL      NRCHTP = 'A'
      *
      ** Last Change User Profile
     C                   EVAL      NRLUSR = PSUser
      *
      ** Update CRS customer details
     C                   UPDATE    SDCRNHD0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdFile - Update Enquiry File Subroutine                   *
      *                                                               *
      *  Called by: SRCust, SRNaho                                    *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdFile     BEGSR
      *
      ** CRS Customer/Non Account Holder
     C                   EVAL      HLCUST = XRCUST
      ** Report Name
     C                   EVAL      HLRPNM = XRRPNM
      ** Report Town
     C                   EVAL      HLRPTN = XRRPTN
      ** CRS Customer Type
     C                   EVAL      HLCUTP = WRCUTP
      ** High Value Indicator
     C                   EVAL      HLHVIN = XRHVIN
      ** High Value Calculated
     C                   EVAL      HLHVAM = XRHVAM
      ** Subject to Reporting
     C                   EVAL      HLSUBJ = XRSUBJ
      *
     C                   WRITE     SDCRHLD0
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvCurr - Retrieve Currency Details                        *
      *                                                               *
      *  Called by: SRCalcAst, *INZSR                                 *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRRtvCurr     BEGSR
      *
      ** Retrieve currency information
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = PCurr
     C                   EVAL      DBASE  = 3
     C                   EVAL      DBPGM = 'SD000314'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtAmount - Convert amount                                 *
      *                                                               *
      *  Called by: SRCalcAst                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRCvtAmount   BEGSR
      *
      * Calculate cross exchange rate
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
      ** Outputs
     C                   PARM      *ZEROS        ZRATEX
     C                   PARM      *BLANKS       ZMDIX
      *
      * Convert amount
     C                   CALL      'ZCONVZ1'
      ** Inputs
     C                   PARM                    ZAMTCI
     C                   PARM      ZRATEX        ZEXCH
     C                   PARM      ZMDIX         ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
      ** Output
     C                   PARM      *ZEROS        ZAMTCO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtAmount - Format amount                                  *
      *                                                               *
      *  Called by: SRCustDet, SRNahoDet, *INZSR                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRFmtAmount   BEGSR
      *
      * Format amount
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE
     C                   PARM                    ZOUT21
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAlgAmount - Align amount                                   *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRAlgAmount   BEGSR
      *
      * Align amount
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTimeStamp - Generate Timestamp                             *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrTimeStamp   BEGSR
      *
      ** Generate Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimestamp

     C                   MOVE      PTimestamp    WTimestamp
     C                   EVAL      WHH = %SUBST(WTimestamp:12:2)
     C                   EVAL      WMM = %SUBST(WTimestamp:15:2)
     C                   EVAL      WSS = %SUBST(WTimestamp:18:2)
     C                   EVAL      WHHMMSS = WHH + WMM + WSS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZAPNUM - Calculate AP Numerator                              *
      *                                                               *
      *  Called by: SRCalcAst                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     ZAPNUM        BEGSR
      *
      ** If number of currency decimal places I = 0
     C                   IF        ZNMCD = 0
     C     ZNOML         MULT(H)   ZAVPR         ZVAL0
     C                   EVAL      ZVALU =  ZVAL0
     C                   ENDIF
      *
      ** If number of currency decimal places I = 1
     C                   IF        ZNMCD = 1
     C     ZNOML         MULT(H)   ZAVPR         ZVAL1
     C                   EVAL      ZVALU =  ZVAL1
     C                   ENDIF
      *
      ** If number of currency decimal places I = 2
     C                   IF        ZNMCD = 2
     C     ZNOML         MULT(H)   ZAVPR         ZVAL2
     C                   EVAL      ZVALU =  ZVAL2
     C                   ENDIF
      *
      ** If number of currency decimal places I = 3
     C                   IF        ZNMCD = 3
     C     ZNOML         MULT(H)   ZAVPR         ZVAL3
     C                   EVAL      ZVALU =  ZVAL3
     C                   ENDIF
      *
      ** Set Index ZI equal to 5 - Nominal Decimal Places
     C     5             SUB       ZNMDP         ZI
      *
      ** Multiply ZVALU by POWER8,ZI to get amount with Nominal Decimal Places
     C     ZVALU         MULT      POWER8(ZI)    ZVALU
      *
      ** Price Basis IF = Percentage
     C                   IF        ZPRCB = 'P'
     C     ZVALU         DIV(H)    100           ZVALU
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  FFTVCL - Calculates transaction value for a given number of  *
      *           contracts at a given price in units of the          *
      *           appropriate ticks denominator or minimum price      *
      *           fluctuation (depending on whether the ticks         *
      *           denominator is 100)                                 *
      *                                                               *
      *  Called by: SRCalcAst                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     FFTVCL        BEGSR
      *
      **  If the Ticks Denominator is equal to 100
     C                   IF        FFTKDM = 100
      *
      ** Divide Price by Min Price Fluctuation
     C                   EVAL      FFNOTK = FFPRIC / FFMNPF
     C                   ELSE
      ** Multiply integer of Price by the Ticks Denominator
     C                   EVAL      FFNOTK = FFINTG * FFTKDM
      ** The remaining fraction of the Price should be added to the
      ** result of Price integer X Ticks Denominator
      *
      ** If Ticks Denominator is between 1 & 10 use 1st dec place
     C                   IF        FFTKDM <= 10
     C                   ADD       FFDCN1        FFNOTK
      *
     C                   IF        FFMNPF <> 0
     C                   EVAL      FFNOT1 = FFNOTK + FFDCN4
     C                   EVAL      FFNOTK = FFNOT1 / FFMNPF
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If Ticks Denominator is between 11 & 99 use 1-2nd dec places
     C                   IF        FFTKDM <= 99
     C                   ADD       FFDCN2        FFNOTK
      *
     C                   IF        FFMNPF <> 0
     C                   EVAL      FFNOT1 = FFNOTK + FFDCN5
     C                   EVAL      FFNOTK = FFNOT1 / FFMNPF
     C                   ENDIF
      *
     C                   ELSE
      ** If Ticks Denominator is between 101 & 999 use 1-3rd dec places
     C                   ADD       FFDCN3        FFNOTK
      *
     C                   IF        FFMNPF <> 0
     C                   EVAL      FFNOT1 = FFNOTK + FFDCN6
     C                   EVAL      FFNOTK = FFNOT1 / FFMNPF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Multiply the number of ticks by the number of contracts
     C                   EVAL      FFTNVL = FFNOTK * FFNOC
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMdasDay - Convert Diligence 6A Dates to Midas Day No.      *
      *                                                               *
      *****************************************************************
     C     SRMdasDay     BEGSR

     C                   CALLB     'ZDATE1'
     C                   PARM                    PIDate
     C                   PARM      *ZERO         PODate
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        PErrFlag

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
     C                   PARM                    PHGVI
     C                   PARM                    PHGVE
     C                   PARM                    PLVAM
     C                   PARM                    PHVCY
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
     C                   EVAL      DBPGM = 'SD000314'
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
     C                   EVAL      DBASE  = 2
     C                   EVAL      DBPGM = 'SD000314'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      CSD092 = 'N'
     C                   ELSE
     C                   EVAL      CSD092 = 'Y'
     C                   ENDIF

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      SysVvl1       SVvlK1
     C                   PARM                    SVvl1
     C                   PARM      SysVvl2       SVvlK2
     C                   PARM                    SVvl2
     C                   PARM      SysVvl3       SVvlK3
     C                   PARM                    SVvl3
     C                   PARM      SysVvl4       SVvlK4
     C                   PARM                    SVvl4
     C                   PARM      SysVvl5       SVvlK5
     C                   PARM                    SVvl5
     C                   PARM                    SVvlK6
     C                   PARM                    SVvl6
     C                   PARM                    SVvlK7
     C                   PARM                    SVvl7
     C                   PARM                    SVvlK8
     C                   PARM                    SVvl8
     C                   PARM                    SVvlK9
     C                   PARM                    SVvl9
     C                   PARM                    SVvlK0
     C                   PARM                    SVvl10

     C                   EVAL      WCRSDlgHiEnt = SVvl2
     C                   EVAL      WCRSDlgHiInd = SVvl3
     C                   EVAL      WCRSDlgMedEnt = SVvl4
     C                   EVAL      WCRSDlgMedInd = SVvl5

     C                   IF        PRtcd <> *Blanks  AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBKEY = SVvlK1
     C                   EVAL      DBASE = 5
     C                   EVAL      DBPGM = 'SD000314'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check system value high/low account information
     C                   CALL      'GPAOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      SysVal1       SValK1
     C                   PARM                    SVal1
     C                   PARM      SysVal2       SValK2
     C                   PARM                    SVal2
     C                   PARM      SysVal3       SValK3
     C                   PARM                    SVal3
     C                   PARM      SysVal4       SValK4
     C                   PARM                    SVal4
     C                   PARM      SysVal5       SValK5
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
     C                   EVAL      DBASE = 4
     C                   EVAL      DBPGM = 'SD000314'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** CRS High Value - CRSHighValCCY (SVal13 is from SVal1)
     C                   EVAL      PCurr = SVal13
     C                   EXSR      SRRtvCurr

     C                   EVAL      ZADEC = A6NBDP
     C                   EVAL      ZADIG = 13
      *
      ** CRS High Value - CRSHighValAmtEnt
     C                   EVAL      ZFIELD = SVal313
     C                   EXSR      SRAlgAmount
     C                   MOVE      ZFIELD        HghValEnt
      *
      ** CRS High Value - CRSHighValAmtInd
     C                   EVAL      ZFIELD = SVal413
     C                   EXSR      SRAlgAmount
     C                   MOVE      ZFIELD        HghValInd
      *
      ** CRS Low Value - CRSLowValAmount
     C                   EVAL      ZFIELD = SVal513
     C                   EXSR      SRAlgAmount
     C                   MOVE      ZFIELD        LowValue
      *
      ** Retrieve high value currency rate
     C                   EVAL      PCurr = SVal13
     C                   EXSR      SRRtvCurr
     C                   EVAL      ZRATE2 = A6SPRT
     C                   EVAL      ZMDI2 = A6MDIN
     C                   EVAL      ZCCYO = PCurr
     C                   EVAL      ZCDPO = A6NBDP
      *
      ** Format system values for report
      *
      ** CRSHighValAmtInd
     C                   EVAL      ZFLD15 = HghValInd
     C                   EVAL      ZDECS = A6NBDP
     C                   EXSR      SRFmtAmount
     C                   MOVE      ZOUT21        XRHGVI
      ** Trim all spaces on the left to left adjust the value
      ** on display
     C                   EVAL      XRHGVI = %TRIML(XRHGVI)
     C                   MOVE      ZOUT21        PHGVI
      *
      ** CRSHighValAmtInd
     C                   EVAL      ZFLD15 = HghValEnt
     C                   EVAL      ZDECS = A6NBDP
     C                   EXSR      SRFmtAmount
     C                   MOVE      ZOUT21        XRHGVE
      ** Trim all spaces on the left to left adjust the value
      ** on display
     C                   EVAL      XRHGVE = %TRIML(XRHGVE)
     C                   MOVE      ZOUT21        PHGVE
      *
      ** Low Value Amount
     C                   EVAL      ZFLD15 = LowValue
     C                   EVAL      ZDECS = A6NBDP
     C                   EXSR      SRFmtAmount
     C                   MOVE      ZOUT21        XRLVAM
      ** Trim all spaces on the left to left adjust the value
      ** on display
     C                   EVAL      XRLVAM = %TRIML(XRLVAM)
     C                   MOVE      ZOUT21        PLVAM
      *
      ** High Value Currency
     C                   EVAL      XRHVCY = SVal13
     C                   EVAL      PHVCY = SVal13
      *
     C     KCRHVF        KLIST
     C                   KFLD                    KCUTP
     C                   KFLD                    KHVIN
      *
     C     KACRV         KLIST
     C                   KFLD                    KCUST
     C                   KFLD                    KSCDT
     C                   KFLD                    KSEQN
      *
     C     KSCSEP        KLIST
     C                   KFLD                    WWCSCN
     C                   KFLD                    WWCSSV

     C     KPRIC         KLIST
     C                   KFLD                    KISTT
     C                   KFLD                    KYRNO
     C                   KFLD                    KMTHN
     C                   KFLD                    KPCAL
     C                   KFLD                    KSTRP

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
     C                   EVAL      DBPGM = 'SD000314'
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
**  POWER8 - ARRAY OF POWERS FOR CURRENCY CONVERSION
00000001
00000010
00000100
00001000
00010000
00100000
01000000
10000000
