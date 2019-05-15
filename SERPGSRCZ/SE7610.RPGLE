     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Customer income extract')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE7610 - Customer income extract                             *
      *                                                               *
      *  Function:  This module runs in COB. It extract information   *
      *             from position settlement file and output income   *
      *             record to customer income detail file.            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG27723           Date 07Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 CSD079             Date 05Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 220738             Date 28Aug03               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 194312             Date 30Jun01               *
      *                 190204             Date 31May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 187933             Date 21Dec00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187473             Date 07Dec00               *
      *                 CSE023  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27723 - SEC7610 00001 Attempt made to divide by zero      *
      *             for fixed point operation                         *
      *  CSD079 - Enhanced Customer Maintenance API (Recompile)       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  220738 - Dump if customer is closed                          *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  194312 - To avoid Database Error if if event is created      *
      *           by using position settelement I/C option            *
      *           In this case, evnet does not exist in file SEDEVD   *
      *  190204 - Changed Dividend per Unit format from 9N0 to 13N8.  *
      *  187933 - DB error still occurs when Country of treaty on the *
      *           Security is blank                                   *
      *  187473 - Manual input position settlement without dairy      *
      *           event for DV (then program need to work out dividend*
      *           per share).                                         *
      *  CSE023 - Treaty Withholding Tax.                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of file in POSEB1                           *
      *    02         No record found in SECTY                        *
      *    03         No record found in SDWTCSL1                     *
      *    04         No record found in SDINTCLL2                    *
      *    05         No record found in SDTXBSL1                     *
      *    06         No record found in SECEO                        *
      *    07         No record found in POSETA                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR  - Error processing                                     *
      * *INZSR - Initialise                                           *
      * SRMainProc  - Main program processing                         *
      * SRChkPrc    - Check if possition settlements shd be generated *
      * SRFmtDetOut - Set fields for customer income detail           *
      * SRAuditRpt  - Generate audit report                           *
      * SRDBErr     - Database error processing                       *
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
      ** Position settlement by security
     FPOSEB1    IF   E           K DISK    INFSR(*PSSR)
      *
      ** Securities by security shortname
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Withholding tax customer details - retrieve
     FSDWTCSL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Intermediary client details - retrieve
     FSDINTCLL2 IF   E           K DISK    INFSR(*PSSR)
      *
      ** Tax basket - retrieve
     FSDTXBSL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Security events by type, date
     FSECEO     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Position settlement - audit
     FPOSETA    IF   E             DISK    INFSR(*PSSR)
      *
      ** Customer income details
     FSDCUINPD  O    E             DISK    INFSR(*PSSR)
      *
      ** Customer Income extract - audit
     FSECORFLC  IF   E           K DISK    INFSR(*PsSR)
      *
      ** Corporate Action Reference
     FSECODVL2  IF   E           K DISK    INFSR(*PsSR)
      *
      ** Corporate Actions Dividend
     FSE7610AU  O    E             PRINTER USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Array containing copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *                                                                                       187473
      ** +-------- The converted ZPOWERZ1 starts here --------------------+                   187473
      *                                                                                       187473
     D PoArr           S              8  4 DIM(8) CTDATA PERRCD(1)              POWER ARRAY   187473
      *                                                                                       187473
      ** +-------- The converted ZPOWERZ1 ends here ----------------------+                   187473
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *                                                                                       187473
      ** Externally described DS for Currency details                                         187473
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  187473
      *
      ** External DS for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSLDY         E DS                  EXTNAME(DSLDY)                       220738
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             01     01
     D  RecNotFnd             02     02
      *
      ** DS for counter party number
     D                 DS
     D*PCPY*****               1      6S 0                                                    CSD027
     D PCPY                    1      6A                                                      CSD027
     D  Cust                   1      6A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Work variables
     D WRun            S              1
     D WGenRec         S              1    INZ('Y')
     D WPEvt           S              2A
     D WInpRecCnt      S              5P 0 INZ(*ZEROS)
     D WOutRecCnt      S              5P 0 INZ(*ZEROS)
     D WNumRecOnF      S              5P 0 INZ(*ZEROS)
     D @DecPoint       S              1  0                                                    187473
      *
      ** Work parameters for AOCUSTR0
     D PRtCd           S              7A
     D POptn           S              7A
     D PKySt           S              7A
     D PKey1           S             10A
     D PCcy            S              3A                                                      187473
      *
      ** Pointer for the indicator array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** Rename securities fields
     ISECTYDF
     I              RECI                        S_RECI
     I              LCD                         S_LCD
     I              CHTP                        S_CHTP
     I              TNLU                        S_TNLU
     I              EXCD                        S_EXCD
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Main processing
      *
     C                   EXSR      SRMainProc
      *
      ** Auditing
      *
     C                   EXSR      SRAuditRpt
      *
      ** Program termination
      *
     C                   EVAL      *INLR = *On
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMainProc - Main program processing                         *
      *                                                               *
      *****************************************************************
     C     SRMainProc    BEGSR
      *
      ** Set pointer to the first record.
      *
     C     *LOVAL        SETLL     POSEB1
      *
      ** Get first record detail.
      *
     C                   READ      POSEB1                                 01
      *
      ** Repeat while a record is found.
      *
     C                   DOW       EndOfFile = False
      *
      ** Increment input record counter
     C                   EVAL      WInpRecCnt = WInpRecCnt + 1
      *
      ** Process record only if a live record.
     C                   IF        RECI = 'D'
      *
      ** Check if record read should be processed
      *
     C                   EXSR      SRChkPrc
     C                   IF        WGenRec = 'Y'
 
     C     KSecSName     CHAIN     SECTY                              02
      *
      ** If security is found and country of treaty is not blank
      ** extract details to customer income detail file.
     C                   IF        RecNotFnd = False AND CRTT <> *BLANKS
      *
      ** Set fields for output
     C                   EXSR      SRFmtDetOut
      *
      ** Increment output record counter
     C                   EVAL      WOutRecCnt = WOutRecCnt + 1
      *
      ** Write record on customer income detail file.
     C                   WRITE     SDCUIND0
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Read next record to process.
     C                   READ      POSEB1                                 01
 
     C                   ENDDO
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkPrc - Check if security read should be generated        *
      *                                                               *
      *****************************************************************
     C     SRChkPrc      BEGSR
      *
      ** Dividend per share / Coupon rate
      *
     C                   EVAL      WGenRec = 'Y'
     C                   IF        PEVT = 'CP' OR
     C                             PEVT = 'DV'
     C     KSecTypDat    CHAIN     SECEO                              06
 
     C                   IF        *IN06 AND
     C                             PEVT = 'CP'
     C                   EVAL      WPevt = PEVT
     C                   EVAL      PEVT = 'CG'
     C     KSecTypDat    CHAIN     SECEO                              06
     C                   EVAL      PEVT = WPevt
     C                   ENDIF
      *                                                                                       187473
      ** If it is a position settlement for dividend but event not found                      187473
      ** then workout dividend per share based on amount due given.                           187473
      *                                                                                       187473
     C                   IF        *IN06 = '1' and PEVT = 'DV'                                187473
     C                   EVAL      *IN06 = '0'                                                187473
      *                                                                                       187473
      ** Get Nominal currency no. of decimal places.                                          187473
     C                   CALLB     'AOCURRR0'                                                 187473
     C                   PARM      *BLANKS       PRtCd                                        187473
     C                   PARM      '*KEY   '     POptn                                        187473
     C************       PARM      CUNCY         PCcy                                  187473 187933
     C                   PARM      PNCY          PCcy                                         187933
     C     SDCURR        PARM      SDCURR        DSSDY                                        187473
                                                                                              187473
     C                   IF        PRtCd <> *BLANKS                                           187473
     C     *LOCK         IN        LDA                                                        187473
     C                   EVAL      DBKEY = POptn                                              187473
     C                   EVAL      DBFILE = 'SDCURRPD'                                        187473
     C                   EVAL      DBASE = 004                                                187473
     C                   OUT       LDA                                                        187473
     C                   EXSR      *PSSR                                                      187473
     C                   ENDIF                                                                187473
     C                   EVAL      @DecPoint = 5 - NMDP - A6NBDP                              187473
                                                                                            BUG27723
      ** Prevent divide by zero                                                             BUG27723
                                                                                            BUG27723
     C                   IF        PNMP <> *ZERO                                            BUG27723
     C                             AND PoArr(@DecPoint) <> *ZERO                            BUG27723
     C                   EVAL      SDVA = PAMD / PNMP * PoArr(@DecPoint)                      187473
     C                   ELSE                                                               BUG27723
     C                   EVAL      SDVA = *ZERO                                             BUG27723
     C                   ENDIF                                                              BUG27723
     C                   ENDIF                                                                187473
 
      ** Check if date generated is zero. In this case,                                       194312
      ** record does not exist in diary events file.                                          194312
                                                                                              194312
     C     *IN06         IFEQ      *ON                                                        194312
     C     PDTG          IFEQ      *ZERO                                                      194312
     C                   EXSR      SRPOS                                                      194312
     C                   EVAL      WPevt = PEVT                                               194312
     C                   EVAL      *IN06 = *OFF                                               194312
     C                   ENDIF                                                                194312
     C                   ENDIF                                                                194312
                                                                                              194312
     C                   IF        *IN06 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PSSH + PEVT
     C                   EVAL      DBFILE = 'SECE0   '
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
 
     C                   Z-ADD     *ZERO         CURATE
 
     C                   IF        PEVT = 'CP'
     c                   Z-ADD     SNCR          CURATE
     C                   ELSE
 
     C                   Z-ADD     SDVA          CURATE
     C                   ENDIF
 
     C                   ENDIF
     C                   ELSE
      *
     C                   IF        PEVT <> 'MT'
     C     KSecDatTyp    CHAIN     SECORFLC                           06
     C                   IF        NOT *IN06
     C     MACORF        CHAIN     SECODVL2                           06
     C                   IF        NOT *IN06
     C**********         EVAL      CURATE = MDDIVU                                            190204
     C                   EVAL      CURATE = MDDIV1                                            190204
     C                   ELSE
     C                   EVAL      WGenRec = 'N'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WGenRec = 'N'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        PEVT = 'MT'
     C                   Z-ADD     *ZERO         CURATE
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtDetOut - Set fields for customer income detail          *
      *                                                               *
      *****************************************************************
     C     SRFmtDetOut   BEGSR
      *
      ** Record Id.
      *
     C                   EVAL      CURECI = 'D'
      *
      ** Branch code
      *
     C                   EVAL      CUPBCA = PBCA
      *
      ** Customer number
     C                   MOVEL     *BLANKS       CUCUST
      *
      ** If customer type is 'C', then default customer to the
      ** position settlement customer.
      *
     C                   IF        CTYP = 'C'
     C                   MOVEL     PCPY          CUCUST
     C                   ENDIF
      *
      ** If customer type is 'D' and beneficial owner number is not
      ** get the first six character of the beneficial owner number.
      *
     C                   IF        CTYP = 'D' AND BNFO <> *BLANKS
     C                   EVAL      CUCUST = %SUBST(BNFO:1:6)
     C                   ENDIF
      *
      ** Depot
      *
     C                   IF        CTYP = 'D'
     C                   MOVEL     PCPY          CUDPTN
     C                   ELSE
     C                   MOVEL     DEPT          CUDPTN
     C                   ENDIF
      *
      ** Beneficial owner number
      *
     C                   MOVEL     *BLANKS       CUBNOW
     C                   IF        BNFO <> *BLANKS
     C                   MOVEL     BNFO          CUBNOW
     C                   ENDIF
      *
      ** Customer documentation received status
      *
     C     KCustCntry    CHAIN     SDWTCSl1                           03
     C                   IF        *IN03 = *OFF
     C                   EVAL      CUCSDC = WHDCRC
     C                   ELSE
     C                   EVAL      CUCSDC = *BLANK
     C                   ENDIF
      *
      ** Nominal currency
      *
     C                   EVAL      CUNCY = PNCY
      *
      ** Nominal (Holding)
      *
     C                   Z-ADD     PNMP          CUNOML
      *
      ** Value date
      *
     C                   Z-ADD     PSVL          CUVALD
      *
      ** Security shortname
      *
     C                   EVAL      CUSECS = PSSH
      *
      ** Security report name
      *
     C                   EVAL      CUSECR = *BLANKS
     C                   IF        SRPN <> *BLANKS
     C                   EVAL      CUSECR = SRPN
     C                   ENDIF
      *
      ** Country of treaty
      *
     C                   EVAL      CUCRTT = *BLANKS
     C                   IF        CRTX <> *BLANKS
     C                   EVAL      CUCRTT = CRTX
     C                   ENDIF
      *
      ** Tax basket
      *
     C                   EVAL      CUTXBS = TXBS
      *
      ** Exemption code
      *
     C                   EVAL      CUEXCD = EXCD
      *
      ** Income code
      *
     C                   EVAL      CUINCD = ICTP
      *
      ** Position settlement type
      *
     C                   EVAL      CUPSTP = PEVT
      *
      ** Gross dividend / interest amount
      *
     C                   Z-ADD     0             CUGRDI
     C                   IF        PAMD <> *ZERO
     C                   Z-ADD     PAMD          CUGRDI
     C                   ENDIF
      *
      ** Tax withheld deduced at source
      *
     C                   Z-ADD     0             CUTXWS
     C                   IF        TASO <> *ZERO
     C                   Z-ADD     TASO          CUTXWS
     C                   ENDIF
      *
      ** Tax withheld deduced by user
      *
     C                   Z-ADD     0             CUTXWU
     C                   IF        TAUS <> *ZERO
     C                   Z-ADD     TAUS          CUTXWU
     C                   ENDIF
      *
      ** Customer shortname, name and address1, address2, address3, address4
      *
     C******             CALLB     'AOCUSTR0'                                   220738
     C                   CALLB     'AOCUSTR1'                                   220738
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      Cust          PKey1
     C                   PARM                    PKySt
     C***  SDCUST        PARM      SDCUST        DSSDY                                        220738
     C     SDCUST        PARM      SDCUST        DSLDY                                        220738
      *
      ** DB error if customer is not a live customer.
      *
     C*****              IF        PRtCd <> *BLANKS                                           220738
     C                   IF        PRtCd <> *BLANKS  AND
     C                             BBCLST <> 'Y'                                              220738
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY  = PKey1
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE  = 001
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ELSE
     C                   EVAL      CUCUSN = BBCSSN
     C                   EVAL      CUCNAM = BBCNA1
     C                   EVAL      CUADR1 = BBCNA2
     C                   EVAL      CUADR2 = BBCNA3
     C                   EVAL      CUADR3 = BBCNA4
     C                   ENDIF
      *
      ** Beneficial owner details (name, address1, address2, address3)
      *
     C     KIntermed     CHAIN     SDINTCLL2                          04
 
     C                   IF        *IN04 = *OFF
     C                   EVAL      CUBONM = INBONM
     C                   EVAL      CUBOA1 = INBOA1
     C                   EVAL      CUBOA2 = INBOA2
     C                   EVAL      CUBOA3 = INBOA3
     C                   ELSE
     C                   EVAL      CUBONM = *BLANKS
     C                   EVAL      CUBOA1 = *BLANKS
     C                   EVAL      CUBOA2 = *BLANKS
     C                   EVAL      CUBOA3 = *BLANKS
     C                   ENDIF
      *
      ** Customer tax identification number
      *
     C                   EVAL      CUTIN = *BLANKS
     C                   IF        CTIN <> *BLANKS
     C                   EVAL      CUTIN = CTIN
     C                   ENDIF
      *
      ** Tax rate
      *
     C     KTaxBasket    SETGT     SDTXBSL1
     C                   READP     SDTXBSL1                               05
     C                   IF        *IN05 = *OFF AND
     C                             (CRTX = TBCRTT) AND (TXBS = TBTXBS)
     C                   Z-ADD     TBTRAB        CUTXRT
     C                   ELSE
     C                   Z-ADD     *ZERO         CUTXRT
     C                   ENDIF
      *
      ** Total discounted amount
      *
     C                   Z-ADD     0             CUDAMT
     C                   IF        DAMT <> *ZERO
     C                   Z-ADD     DAMT          CUDAMT
     C                   ENDIF
      *
      ** Net dividend / interest
      *
     C                   IF        PEVT = 'MT'
     C                   EVAL      CUNTDV = CUDAMT - CUTXWS - CUTXWU
     C                   ELSE
     C                   EVAL      CUNTDV = CUGRDI - CUTXWS - CUTXWU
     C                   ENDIF
      *
      ** Recipient code
      *
     C                   EVAL      CURPCD = *BLANKS
     C                   IF        RPCD <> *BLANKS
     C                   EVAL      CURPCD = RPCD
     C                   ENDIF
      *
      ** Last change date (position settlement generated date)
      *
     C                   Z-ADD     0             CULCD
     C                   IF        LCD <> *ZERO
     C                   Z-ADD     LCD           CULCD
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAuditRpt - Generate audit report                           *
      *                                                               *
      *****************************************************************
     C     SRAuditRpt    BEGSR
 
     C                   OPEN      SE7610AU
     C                   WRITE     HEADAU
      *
      ** If no record was read, write no details to report.
      *
     C                   IF        WInpRecCnt = *ZEROS
 
     C                   WRITE     NODTLS
 
     C                   ELSE
      *
      ** Retrieve number of live record in audit file.
     C     1             CHAIN     POSETAF                            07
 
     C                   IF        *IN07 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY  = '1'
     C                   EVAL      DBFILE = 'POSETA'
     C                   EVAL      DBASE  = 002
     C                   OUT       LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   WRITE     DBERROR
     C                   CLOSE     SE7610AU
     C                   EXSR      *PSSR
     C                   ELSE
     C                   Z-ADD     NORE          WNumRecOnF
     C                   ENDIF
      *
      ** Move values to printer file fields.
     C                   Z-ADD     WInpRecCnt    RNOINP
     C                   Z-ADD     WNumRecOnF    RRECOF
     C                   Z-ADD     WOutRecCnt    RNOOUT
      *
      ** Generate audit with details.
     C                   WRITE     DETAILS
 
     C                   ENDIF
     C                   CLOSE     SE7610AU
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT                                                                                  194312
      *****************************************************************                       194312
      *                                                               *                       194312
      *  SRPOS - Subroutine to retrieve values needed by program if   *                       194312
      *          diary event does not exist.                          *                       194312
      *                                                               *                       194312
      * Called by:  SRChkPrc                                          *                       194312
      * Calls: None                                                   *                       194312
      *                                                               *                       194312
      *****************************************************************                       194312
                                                                                              194312
     C     SRPOS         BEGSR                                                                194312
                                                                                              194312
     C     PSSH          CHAIN     SECTY                              41                      194312
                                                                                              194312
     C                   IF        *IN41                                                      194312
     C     *LOCK         IN        LDA                                                        194312
     C                   EVAL      DBKEY = PSSH                                               194312
     C                   EVAL      DBFILE = 'SECED'                                           194312
     C                   EVAL      DBASE = 009                                                194312
     C                   OUT       LDA                                                        194312
     C                   EVAL      *INU7 = *ON                                                194312
     C                   EVAL      *INU8 = *ON                                                194312
     C                   EXSR      *PSSR                                                      194312
                                                                                              194312
     C                   ELSE                                                                 194312
     C                   IF        PEVT = 'CP'                                                194312
     C                   EVAL      CPNR = SNCR                                                194312
     C                   EVAL      CURATE = SNCR                                              194312
     C                   ENDIF                                                                194312
     C                   IF        PEVT = 'DV'                                                194312
                                                                                            BUG27723
      ** Prevent divide by zero                                                             BUG27723
                                                                                            BUG27723
     C                   IF        PNMP <> *ZERO                                            BUG27723
     C     PAMD          DIV       PNMP          SDVA                                         194312
     C                   ELSE                                                               BUG27723
     C                   EVAL      SDVA = *ZERO                                             BUG27723
     C                   ENDIF                                                              BUG27723
     C                   EVAL      CURATE = SDVA                                              194312
     C                   ENDIF                                                                194312
     C                   ENDIF                                                                194312
                                                                                              194312
     C                   ENDSR                                                                194312
      *****************************************************************                       194312
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDBErr - Database error processing                          *
      *                                                               *
      *****************************************************************
     C     SRDBErr       BEGSR
 
     C                   OPEN      SE7610AU
     C                   WRITE     HEADAU
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   WRITE     DBERROR
     C                   CLOSE     SE7610AU
 
     C                   EXSR      *PSSR
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Read in installation data
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
      *
      ** Access bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
      *
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBKEY  = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 003
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Key list for securities detail
      *
     C     KSecSName     KLIST
     C                   KFLD                    PSSH
      *
      ** Key list for withholding tax customer detail
      *
     C     KCustCntry    KLIST
     C                   KFLD                    Cust
     C                   KFLD                    CRTX
      *
      ** Key list for intermediary client detail
      *
     C     KIntermed     KLIST
     C                   KFLD                    Cust
     C                   KFLD                    PSSH
     C                   KFLD                    TXBS
     C                   KFLD                    BNFO
      *
      ** Key list for tax basket detail
      *
     C     KTaxBasket    KLIST
     C                   KFLD                    CRTX
     C                   KFLD                    TXBS
     C                   KFLD                    PDUD
      *
      ** Key list for security event Diary/Non diary detail
      *
     C     KSecTypDat    KLIST
     C                   KFLD                    PSSH
     C                   KFLD                    PEVT
     C                   KFLD                    PDUD
      *
      ** Key list for Corporate Action Reference
      *
     C     KSecDatTyp    KLIST
     C                   KFLD                    PSSH
     C                   KFLD                    PDUD
     C                   KFLD                    PEVT
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C*                  IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C*                  ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  PoArr - ARRAY OF POWERS FOR CURRENCY CONVERSION  (MEMBER ZPOWERZ2)                        187473
00000001                                                                                      187473
00000010                                                                                      187473
00000100                                                                                      187473
00001000                                                                                      187473
00010000                                                                                      187473
00100000                                                                                      187473
01000000                                                                                      187473
10000000                                                                                      187473
