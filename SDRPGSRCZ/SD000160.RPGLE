     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD IGA Country Update')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data module                                 *
      *                                                               *
      *  SD000160 - Midas SD IGA Country Update                       *
      *                                                               *
      *  Function:  This prints a list of all FFIs for which the      *
      *             country IGA status has changed.                   *
      *             If the program is called in update mode, it also  *
      *             updates the FACTA customer sub-type and           *
      *             classification code                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD027251           Date 05Aug14               *
      *  Prev Amend No. MD026854           Date 29May14               *
      *                 CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD027251 - Previous Classification is not updated by FATCA   *
      *             IGA Tool during update mode                       *
      *             Applied Fix MD028213                              *
      *  MD026854 - Alternative country of citizenship is missing in  *
      *             history of customer information                   *
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
      *  SRCust - Process Customer Details                            *
      *  SRHeader - Header Subroutine                                 *
      *  SRCustDet - Customer Details Subroutine                      *
      *  SRUpdCust - Update Customer Subroutine                       *
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
      ** Customer Details by Country of Domicile
     FSDCUSTLK  IF   E           K DISK
      *
      ** FATCA Customer Details File
     FSDFTCSL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** IGA Country Update
     FSDFTIGPD  UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Midas SD IGA Country Update Report
     FSD000160P1O    E             PRINTER INFSR(*PSSR)
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
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** External DS for Bank Details ICD retrieval
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS Based On SDCTRYPD
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      *
      ** External DS Based On SDFTCSPD
     D SDFTCS        E DS                  EXTNAME(SDFTCSPD)
      *
      ** External DS Based On SCSARDPD
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Second DS for access programs, long data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** File Information Data Structure for SD000160P1
     D SPOOL1          DS
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
      *
      ** Selected Countries Array
     D SelCtryArr      S              2    Dim(500)
     D X               S              3  0
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PRtcd           S              7
     D PRetcd          S              7
     D POptn           S              7
     D PMode           S              1
     D PCArr           S           1000
     D PM1ST           S              2
     D PM1CC           S              5
     D PM2ST           S              2
     D PM2CC           S              5
     D PCtry           S              2
     D PSard           S              6A
     D CSD092          S              1A
     D WRun            S              1
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D WChange         S              1A
     D PCustNo         S              6A
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
 
      ** ZSFILE Parameters
     D ZSEQ            S              5
     D ZENTY           S              3
     D ZSERR           S              1
     D ZSNUM           S              6  0
      *
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
      ** Selected Countries Array
     C                   MOVEA     PCArr         SelCtryArr
     C                   EVAL      X=1
      *
     C                   EXSR      SRCust
      *
     C                   COMMIT
     C                   EVAL      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCust - Process Customer Details                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRCust        BEGSR
      *
     C     SelCtryArr(X) SETLL     SDCUSTLK
     C     SelCtryArr(X) READE     SDCUSTLK
     C                   IF        PMode <> 'F'
     C                   OPEN      SD000160P1
 
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
     C                   DOW       SelCtryArr(X) <> *BLANKS
     C                   DOW       NOT %EOF(SDCUSTLK)
      *
      ** Retrieve FATCA Customer Details
     C     BBCUST        CHAIN     SDFTCSL0
      *
     C                   IF        %FOUND(SDFTCSL0)  AND FACSTY = 'F'
     C                             AND (FACSST = 'NP' OR
     C                             FACSST = 'UN')
     C                   EXSR      SRCustDet
     C                   IF        PMode <> 'R' AND WChange = 'Y'
     C                   EXSR      SRUpdFile
     C                   ENDIF
      *
      ** If called in update mode, update FATCA customer file with
      ** the new FFI sub-type and new FATCA classification code
     C                   IF        PMode = 'U' AND WChange = 'Y'
     C                   EXSR      SRUpdCust
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check whether new page is required
     C                   IF        PMode <> 'F' AND WChange = 'Y'
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   EXSR      SRHeader
     C                   ENDIF
     C                   ENDIF
      *
     C     SelCtryArr(X) READE     SDCUSTLK
      *
     C                   ENDDO
     C                   EVAL      X=X+1
     C     SelCtryArr(X) SETLL     SDCUSTLK
     C     SelCtryArr(X) READE     SDCUSTLK
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHeader - Header subroutine                                 *
      *                                                               *
      *  Called by: SRCust                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRHeader      BEGSR
      *
     C                   WRITE     SD000160R0
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCustDet - Customer Details Subroutine                      *
      *                                                               *
      *  Called by: SRCust                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRCustDet     BEGSR
      *
      ** Country Details
     C                   EVAL      XRCNCD = BBCOLC
      *
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      BBCOLC        PCtry
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      XRCNNM = A4CNNM
     C                   ELSE
     C                   EVAL      XRCNNM = *BLANKS
     C                   ENDIF
      ** Customer Details
     C                   EVAL      XRCUST = BBCUST
     C                   EVAL      XRRPNM = BBCRNM
     C                   EVAL      XRRPTN = BBCRTN
      ** New FFI Sub-Type and new FATCA Classification Code
      ** Model 1 IGA
     C                   IF        A4FAAT = 'M1R' OR
     C                             A4FAAT = 'M1N'
     C                   EVAL      XRFFST = PM1ST
      *
     C                   IF        PM1CC <> *BLANKS
     C                   EVAL      XRCLAC = PM1CC
     C                   ELSE
     C                   EVAL      XRCLAC = FACLAC
     C                   ENDIF
      *
     C                   ELSE
      ** Model 2 IGA
     C                   IF        A4FAAT = 'M2R' OR
     C                             A4FAAT = 'M2N'
     C                   EVAL      XRFFST = PM2ST
      *
     C                   IF        PM2CC <> *BLANKS
     C                   EVAL      XRCLAC = PM2CC
     C                   ELSE
     C                   EVAL      XRCLAC = FACLAC
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      XRFFST = FACSST
     C                   EVAL      XRCLAC = FACLAC
     C                   ENDIF
     C                   ENDIF
      *
      ** Check whether record has changed
     C                   IF        XRFFST <> FACSST OR
     C                             XRCLAC <> FACLAC
     C                   EVAL      WChange = 'Y'
     C                   ELSE
     C                   EVAL      WChange = 'N'
     C                   ENDIF
      *
     C                   IF        PMode <> 'F' AND WChange = 'Y'
     C                   WRITE     SD000160R1
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdCust - Update Customer Subroutine                       *
      *                                                               *
      *  Called by: SRCust                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdCust     BEGSR
      *
      ** Save before image of SDFTCSPD
     C                   EVAL      PBefFTCS = SDFTCS
      ** FATCA Customer SubType
     C                   EVAL      FACSST = XRFFST
      ** Set Previous FATCA Classification Code if PMnCCC <> Blanks                         MD028213
     C                   IF        PM1CC <> ' '                                             MD028213
     C                             AND (A4FAAT = 'M1R'                                      MD028213
     C                             OR A4FAAT = 'M1N')                                       MD028213
     C                             OR PM2CC <> ' '                                          MD028213
     C                             AND (A4FAAT = 'M2R'                                      MD028213
     C                             OR A4FAAT = 'M2N')                                       MD028213
     C                   EVAL      FAPCLA = FACLAC                                          MD028213
     C                   ENDIF                                                              MD028213
      ** FATCA Classification Code
     C                   EVAL      FACLAC = XRCLAC
      ** Last Change Date
     C                   EVAL      FALDAT = BJRDNB
      ** Last Change Type
     C                   EVAL      FALCTP = 'A'
      ** Last Change User Profile
     C                   EVAL      FALUSR = PSUser
      ** Save after image of SDFTCSPD
     C                   EVAL      PAftFTCS = SDFTCS
      *
     C                   UPDATE    SDFTCSD0
      *
      ** Write to the History of Customer Information
     C                   IF        CSD092 = 'Y'
     C**********         CALL      'SDC009696'                                              MD026854
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
      *  Called by: SRCust                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdFile     BEGSR
      *
      ** Country Details
     C                   EVAL      IGCNCD = XRCNCD
     C                   EVAL      IGCNNM = XRCNNM
      ** Customer Details
     C                   EVAL      IGCUST = XRCUST
     C                   EVAL      IGRPNM = XRRPNM
     C                   EVAL      IGRPTN = XRRPTN
      ** New FFI Sub-Type
     C                   EVAL      IGFFST = XRFFST
      ** New FATCA Classification Code
     C                   EVAL      IGCLAC = XRCLAC
      *
     C                   WRITE     SDFTIGD0
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
     C                   PARM                    PCArr
     C                   PARM                    PM1ST
     C                   PARM                    PM1CC
     C                   PARM                    PM2ST
     C                   PARM                    PM2CC
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
     C                   EVAL      DBPGM = 'SD000160'
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
     C                   EVAL      DBPGM = 'SD000160'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      CSD092 = 'N'
     C                   ELSE
     C                   EVAL      CSD092 = 'Y'
     C                   ENDIF
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
     C                   EVAL      DBPGM = 'SD000160'
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
(c) Misys International Banking Systems Ltd. 2013
