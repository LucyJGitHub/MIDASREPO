     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas AA Initialise profit centres for securities')
      *****************************************************************
      *                                                               *
      *  Midas - Analytical Accounting Module                         *
      *                                                               *
      *  AA0025   - Update Securities module Files with PRFC          *
      *             Populate the transactions.                        *
      *                                                               *
      *  Function:  This program uses the Profit Centre Default       *
      *             Matrix (PCDM) to fill the empty profit centre     *
      *             on each of the files.  If it is not possible to   *
      *             default from the PCDM it defaults the PRFC        *
      *                                                               *
      *             NOTE: This program DOES NOT pass Department and   *
      *             User to the PCDM (it passes Blanks) As these are  *
      *             generally unavailable from the transaction file.  *
      *                                                               *
      *  Called By: AAC0025 - Securities trans PRFC Update            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD045894           Date 23Jun17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 234300             Date 22Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 222727             Date 05Nov03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 207006             Date 18Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
     2*                 184967  *CREATE    Date 12Sep00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD045894 - PCAM utility override value of RECI               *
      *  234300 - Recompiled over changed in PF/HSTTRD.               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  207006 - Add Counterparty & Market Centre to SSI (Recompile) *
      *  184967 - Partial Replacement for AA0006                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    40         End of File                                     *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SRTRAD - update trades                                        *
      * SRHSTT - update Historic trades                               *
      * SRDEPO - update Depot Movements                               *
      * SRPOSS - update Position Settlements                          *
      * PCDM   - Call the Profit Centre Default matrix                *
      * SRVLCN - Validate Security customer                           *
      * ACOfficer - Retrieve Account Officer                          *
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
 
     FTRADSD    UF   E             DISK
     FHSTTRD    UF   E             DISK
 
     FDPTMVD    UF   E             DISK
 
     FSEPCCD    IF   E           K DISK
     FSEPCBD    IF   E           K DISK
 
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
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D AADTA         E DS                  EXTNAME(AADTA)
      **  AA Data Area
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for Midas modules details
 
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
      **  Profit Centre Details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **  Customer Details
 
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      **  SE ICD
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      **  SE ICD
 
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)
      ** PCA ICD
 
     D DSFDY         E DS
      **  Short Data Structure for Access Programs
 
     D DSSDY         E DS
      **  Short Data Structure for Access Programs
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D PCDMBookC       S              2
     D PCDMTranType    S              5
     D PCDMSubType     S              2
     D PCDMBranch      S              3
     D PCDMAcOf        S              2
     D PCDMCust        S              6
     D @RTCD           S              7
     D @OPTN           S              7
     D @KEY1           S             10
     D @KYST           S              7
     D RetCode1A       S              1
     D RtnCode         S              7
     D WProfitC        S              4
     D Option          S              7
     D WCust           S              6
     D KeyBkBook       S              2
     D KeyBkBrch       S              3
     D KeyBkSeSN       S             10
     D KeyBkMktI       S              1
     D*KeyTrCnum       S              6  0                                                    CSD027
     D KeyTrCnum       S              6                                                       CSD027
     D KeyTrBrch       S              3
     D KeyTrSeSN       S             10
 
     ISEPCCDF                                                                               MD045894
     I              RECI                        CRECI                                       MD045894
     I              LCD                         CLCD                                        MD045894
     I              CHTP                        CCHTP                                       MD045894
     I              TNLU                        CTNLU                                       MD045894
     I              PTFR                        CPTFR                                       MD045894
     ISEPCBDF                                                                               MD045894
     I              RECI                        BRECI                                       MD045894
     I              LCD                         BLCD                                        MD045894
     I              CHTP                        BCHTP                                       MD045894
     I              TNLU                        BTNLU                                       MD045894
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
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE                  AADTA
     C                   IN        RUNDAT
     C                   IN        AADTA
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   END
 
      *
      *IF Securities is switched ON EXSR to populate PRFC
     C                   IF        BGSECS = 'Y'
 
      * If the value on the AADTA is not blank then process the FX deals
     C                   IF        AABKPC <> *BLANKS  AND
     C                             AATRPC <> *BLANKS
      * Update trades
     C                   EXSR      SRTRAD
      * Update historic trades
     C                   EXSR      SRHSTT
      * Update depot movements
     C                   EXSR      SRDEPO
      *
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTRAD - Subroutine to update trades                          *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: PCDM, ACOfficer, SRVLCN                                *
      *                                                               *
      *****************************************************************
 
     C     SRTRAD        BEGSR
     C                   READ      TRADSD                                 40
      *
      * Do While not EOF
     C                   DOW       *IN40 = '0'
      *
      **  Initialise update flag
     C                   EVAL      *IN50 = '0'
      *
      **  Test to see if the Customer is a valid Securities Customer
     C                   MOVEL     TCNR          WCust
     C                   EXSR      SRVLCN
      *
      **  If the book profit centre is blank, update it
     C                   IF        BPRC = *Blanks
     C                   EVAL      KeyBkBook = TDBK
     C                   EVAL      KeyBkBrch = TDBA
     C                   EVAL      KeyBkSeSN = TDSS
     C                   EVAL      KeyBkMktI = TDMI
      *
      * Chain on SEPCBD
     C     BookKey       CHAIN     SEPCBD                             40
      *
     C                   IF        *IN40 = '1' OR
     C                             PCBK = *Blanks
 
     C                   EVAL      PCDMBookC = TDBK
     C                   EVAL      PCDMTranType = TDTP
     C                   EVAL      PCDMSubType = TSUB
     C                   EVAL      PCDMBranch = TDBA
     C                   MOVEL     TCNR          PCDMCust
     C                   MOVEL     TCNR          @KEY1
      *
      *Get Account Officer
     C                   EXSR      ACOfficer
      *
      * Get default from the Profit Centre Default Matrix
     C                   EXSR      PCDM
      *
      * If the Profit centre is returned blank Use the Profit Centre in AADTA
     C                   IF        WProfitC = *Blanks OR
     C                             WProfitC = FTUAPC
     C                   EVAL      BPRC = AABKPC
     C                   EVAL      *IN50 = '1'
      *
     C                   ELSE
     C                   EVAL      BPRC = WProfitC
     C                   EVAL      *IN50 = '1'
     C                   ENDIF
      *
      * ELSE Exists on SEPCBD and contains a Profit Centre
     C                   ELSE
     C                   MOVE      PCBK          BPRC
     C                   EVAL      *IN50 = '1'
      * ENDIF for existing/not existing on SEPCBD
     C                   ENDIF
     C                   ENDIF
      *
      **  If the transaction profit centre is blank, update it
     C                   IF        TPRC = *Blanks
     C                   EVAL      *IN50 = '1'
      *
      **  For portfolio cust, set to transaction profit centre in AADTA
     C                   IF        BFCLAS = 'S' OR
     C                             BFCLAS = 'D'
      *
     C                   EVAL      KeyTrCNum = TCNR
     C                   EVAL      KeyTrBrch = TDBA
     C                   EVAL      KeyTrSeSN = TDSS
 
     C     TranKey       CHAIN     SEPCCD                             40
      *
     C                   IF        *IN40 = '1' OR
     C                             PCCU = *Blanks
 
     C                   EVAL      PCDMBookC = TDBK
     C                   EVAL      PCDMTranType = TDTP
     C                   EVAL      PCDMSubType = TSUB
     C                   EVAL      PCDMBranch = TDBA
     C                   MOVEL     TCNR          PCDMCust
     C                   MOVEL     TCNR          @KEY1
      *
      *Get Account Officer
     C                   EXSR      ACOfficer
      *
      * Get default from the Profit Centre Default Matrix
     C                   EXSR      PCDM
      *
      * If the Profit centre is returned blank Use the Profit Centre in AADTA
     C                   IF        WProfitC = *Blanks OR
     C                             WProfitC = FTUAPC
     C                   EVAL      TPRC = AATRPC
      *
     C                   ELSE
     C                   EVAL      TPRC = WProfitC
     C                   ENDIF
      *
      * ELSE Exists on SEPCBD and contains a Profit Centre
     C                   ELSE
     C                   MOVE      PCCU          TPRC
      * ENDIF for existing/not existing on SEPCCD
     C                   ENDIF
      *
      * Else If Not 'S' or 'D' make TPRC = BPRC
     C                   ELSE
     C                   EVAL      TPRC = BPRC
     C                   ENDIF
     C                   ENDIF
      *
      * Update the record with the Profit Centre
     C                   IF        *IN50 = '1'
     C                   UPDATE    TRADSDF
     C                   ENDIF
      * Read next record
     C                   READ      TRADSD                                 40
     C                   ENDDO
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRHSTT - Subroutine to update Historic trades                 *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: PCDM, ACOfficer, SRVLCN                                *
      *                                                               *
      *****************************************************************
 
     C     SRHSTT        BEGSR
     C                   READ      HSTTRD                                 40
      *
      * Do While not EOF
     C                   DOW       *IN40 = '0'
      *
      **  Initialise update flag
     C                   EVAL      *IN50 = '0'
      *
      **  Test to see if the Customer is a valid Securities Customer
     C                   MOVEL     TCNR          WCust
     C                   EXSR      SRVLCN
      *
      **  If the book profit centre is blank, update it
     C                   IF        BPRC = *Blanks
      *
     C                   EVAL      KeyBkBook = TDBK
     C                   EVAL      KeyBkBrch = TDBA
     C                   EVAL      KeyBkSeSN = TDSS
     C                   EVAL      KeyBkMktI = TDMI
      *
      * Chain on SEPCBD
     C     BookKey       CHAIN     SEPCBD                             40
      *
     C                   IF        *IN40 = '1' OR
     C                             PCBK = *Blanks
 
     C                   EVAL      PCDMBookC = TDBK
     C                   EVAL      PCDMTranType = TDTP
     C                   EVAL      PCDMSubType = TSUB
     C                   EVAL      PCDMBranch = TDBA
     C                   EVAL      PCDMCust = *Blanks
     C                   EVAL      PCDMAcOf = *Blanks
     C                   MOVEL     TCNR          PCDMCust
     C                   MOVEL     TCNR          @KEY1
      *
      *Get Account Officer
     C                   EXSR      ACOfficer
      *
      * Get default from the Profit Centre Default Matrix
     C                   EXSR      PCDM
      *
      * If the Profit centre is returned blank Use the Profit Centre in AADTA
     C                   IF        WProfitC = *Blanks OR
     C                             WProfitC = FTUAPC
     C                   EVAL      BPRC = AABKPC
     C                   EVAL      *IN50 = '1'
      *
     C                   ELSE
     C                   EVAL      BPRC = WProfitC
     C                   EVAL      *IN50 = '1'
     C                   ENDIF
      *
      * ELSE Exists on SEPCBD and contains a Profit Centre
     C                   ELSE
     C                   MOVE      PCBK          BPRC
     C                   EVAL      *IN50 = '1'
      * ENDIF for existing/not existing on SEPCBD
     C                   ENDIF
     C                   ENDIF
      *
      **  If the transaction profit centre is blank, update it
     C                   IF        TPRC = *Blanks
     C                   EVAL      *IN50 = '1'
      *
      **  For portfolio cust, set to transaction profit centre in AADTA
     C                   IF        BFCLAS = 'S' OR
     C                             BFCLAS = 'D'
      *
     C                   EVAL      KeyTrCNum = TCNR
     C                   EVAL      KeyTrBrch = TDBA
     C                   EVAL      KeyTrSeSN = TDSS
 
     C     TranKey       CHAIN     SEPCCD                             40
      *
     C                   IF        *IN40 = '1' OR
     C                             PCCU = *Blanks
      *
     C                   EVAL      PCDMBookC = TDBK
     C                   EVAL      PCDMTranType = TDTP
     C                   EVAL      PCDMSubType = TSUB
     C                   EVAL      PCDMBranch = TDBA
     C                   MOVEL     TCNR          PCDMCust
     C                   MOVEL     TCNR          @KEY1
      *
      *Get Account Officer
     C                   EXSR      ACOfficer
      *
      * Get default from the Profit Centre Default Matrix
     C                   EXSR      PCDM
      *
      * If the Profit centre is returned blank Use the Profit Centre in AADTA
     C                   IF        WProfitC = *Blanks OR
     C                             WProfitC = FTUAPC
     C                   EVAL      TPRC = AATRPC
      *
     C                   ELSE
     C                   EVAL      TPRC = WProfitC
     C                   ENDIF
      *
      * ELSE Exists on SEPCBD and contains a Profit Centre
     C                   ELSE
     C                   MOVE      PCCU          TPRC
      * ENDIF for existing/not existing on SEPCCD
     C                   ENDIF
      *
      *
      * Else If Not 'S' or 'D' make TPRC = BPRC
     C                   ELSE
     C                   EVAL      TPRC = BPRC
     C                   ENDIF
     C                   ENDIF
      *
      * Update the record with the Profit Centre
     C                   IF        *IN50 = '1'
     C                   UPDATE    HSTTRDF
     C                   ENDIF
      * Read next record
     C                   READ      HSTTRD                                 40
     C                   ENDDO
 
     C                   ENDSR
 
     ***********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDEPO - Subroutine to update Depot Movements                 *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: PCDM, ACOfficer                                        *
      *                                                               *
      *****************************************************************
 
     C     SRDEPO        BEGSR
     C                   READ      DPTMVD                                 40
      *
      * Do While not EOF
     C                   DOW       *IN40 = '0'
      *
      **  If the book profit centre is blank, update it
     C                   IF        DPPC = *Blanks
      *
      **  If the depot movement is Walk In or Walk Out Transaction PRFC
      **  Used
     C                   IF        DPMV = 'WI' OR
     C                             DPMV = 'WO'
      *
     C                   EVAL      KeyTrCNum = DPBN
     C                   EVAL      KeyTrBrch = DPBA
     C                   EVAL      KeyTrSeSN = DPSS
 
     C     TranKey       CHAIN     SEPCCD                             40
      *
     C                   IF        *IN40 = '1' OR
     C                             PCCU = *Blanks
      *
     C                   EVAL      PCDMBookC = DPBK
     C                   EVAL      PCDMTranType = *Blanks
     C                   EVAL      PCDMSubType = *Blanks
     C                   EVAL      PCDMBranch = DPBA
     C                   MOVEL     DPBN          PCDMCust
     C                   MOVEL     DPBN          @KEY1
      *
     C                   EXSR      ACOfficer
      *
      * Get default from the Profit Centre Default Matrix
     C                   EXSR      PCDM
      *
      * If the Profit centre is returned blank Use the Profit Centre in AADTA
     C                   IF        WProfitC = *Blanks OR
     C                             WProfitC = FTUAPC
     C                   EVAL      DPPC = AATRPC
      *
     C                   ELSE
     C                   EVAL      DPPC = WProfitC
     C                   ENDIF
      * Else the Profit Centre from SEPCCD is used
     C                   ELSE
     C                   EVAL      DPPC = PCCU
     C                   ENDIF
      *
      * ELSE IF Not a Walk In or Walk Out
     C                   ELSE
     C                   EVAL      PCDMBookC = DPBK
     C                   EVAL      PCDMTranType = *Blanks
     C                   EVAL      PCDMSubType = *Blanks
     C                   EVAL      PCDMBranch = DPBA
     C                   MOVEL     DPBN          PCDMCust
     C                   MOVEL     DPBN          @KEY1
      *
     C                   EXSR      ACOfficer
      *
      * Get default from the Profit Centre Default Matrix
     C                   EXSR      PCDM
      *
      * If the Profit centre is returned blank Or Default Use BVSEPC
     C                   IF        WProfitC = *Blanks OR
     C                             WProfitC = FTUAPC
     C                   EVAL      DPPC = BVSEPC
      *
     C                   ELSE
     C                   EVAL      DPPC = WProfitC
     C                   ENDIF
     C                   ENDIF
      *
      * Update the record with the Profit Centre
     C                   UPDATE    DPTMVDF
     C                   ENDIF
      * Read next record
     C                   READ      DPTMVD                                 40
     C                   ENDDO
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * PCDM    - Subroutine to Call the Profit Centre Default matrix *
      *                                                               *
      * Called by: SRTRAD, SRHSTT, SRDEPO,                            *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     PCDM          BEGSR
 
      *Call Profit Centre Default Matrix
     C                   CALL      'AOPRFMR0'
     C                   PARM      *BLANKS       RetCode1A
     C                   PARM      PCDMBookC     BOOK              2            Book Code
     C                   PARM      PCDMTranType  TranType          5            Transacton Type
     C                   PARM      PCDMSubType   SubType           2            Sub Type
     C                   PARM      PCDMBranch    BRAN              3            Branch Code
     C                   PARM      *BLANKS       DEPT              3            Deptment Code
     C                   PARM      *BLANKS       USER             10            User
     C                   PARM      PCDMAcOf      ACOF              2            Account Officer
     C                   PARM      PCDMCust      CUST              6            Customer Number
     C     WProfitC      PARM      *Blanks       PRFC              4            Profit Centre
      *
     C     WProfitC      IFNE      *BLANKS
     C                   CALL      'AOPRFCR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WProfitC      @WKPR             4
     C     SDPRFC        PARM      SDPRFC        DSFDY
      *
      ** Data base error in file (file)
     C     @RTCD         IFNE      *BLANKS
      *
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDPRFCPD'
     C                   EVAL      DBKEY  =  'WProfitC'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/PCDM'
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
     C                   MOVEL     DSPCCD        WProfitC
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVLCN - Validate Security customer                           *
      *                                                               *
      * Called by: SRTRAD, SRHSTT,                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRVLCN        BEGSR
      **  Validate Security Customer
      *
     C                   CALL      'AOSECSR0'
     C                   PARM      '*DBERR'      PRTCD             7
     C                   PARM      '*KEY'        POPTN             7
     C                   PARM                    WCust
     C     SDSECS        PARM      SDSECS        DSFDY
      *
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ACOfficer - Retrieve Account Officer                          *
      *                                                               *
      * Called by: SRTRAD, SRHSTT, SRDEPO,                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     ACOfficer     BEGSR
      **  Get Account Officer
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1
     C                   PARM      *BLANKS       @KYST
     C     SDCUST        PARM      *BLANKS       DSSDY
      *
     C                   If        @RTCD = *Blanks
     C                   EVAL      PCDMAcOf = BBACOC
     C                   ELSE
     C                   EVAL      PCDMAcOf = *Blanks
     C                   ENDIF
      *
     C                   ENDSR
 
      **********************************************************************
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
      ** GET MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       RtnCode
     C                   PARM      '*FIRST'      Option
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** DATABASE ERROR
      *
     C                   IF        RtnCode <> *BLANKS
      ** Data base error in file (file)
      *
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDMMODPD'
     C                   EVAL      DBKEY  =  'KEY'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/*INZSR'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
      *
      **  Access SE ICD to get SE Profit Centre
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR'      PRTCD             7
     C                   PARM      '*FIRST'      POPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
 
      *
      ** GET PCA ICD
      *
     C                   CALL      'AOPCACR0'
     C                   PARM      *BLANKS       RtnCode
     C                   PARM      '*FIRST'      Option
     C     SDPCAC        PARM      SDPCAC        DSFDY
      *
      ** DATABASE ERROR
      *
     C                   IF        RtnCode <> *BLANKS
      ** Data base error in file (file)
      *
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDPCACPD'
     C                   EVAL      DBKEY  =  'KEY'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/*INZSR'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
     C     BookKey       KLIST
     C                   KFLD                    KeyBkBook
     C                   KFLD                    KeyBkBrch
     C                   KFLD                    KeyBkSeSN
     C                   KFLD                    KeyBkMktI
 
     C     TranKey       KLIST
     C                   KFLD                    KeyTrCnum
     C                   KFLD                    KeyTrBrch
     C                   KFLD                    KeyTrSeSN
 
     C                   ENDSR
 
      *
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
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
