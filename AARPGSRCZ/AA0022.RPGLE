     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas AA Initialise profit centres for dealing')       *
      *****************************************************************
      *                                                               *
      *  Midas - Analytical Accounting Module                         *
      *                                                               *
      *  AA0022 - Update Dealing module Files with PRFC               *
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
      *  Called By: AAC0022 - AA Dealing PRFC Update                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSW212             Date 03May12               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 04Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAS009             Date 16May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3281            Date 17Jun04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 184967  *CREATE    Date 12Sep00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS009 - EIR/AC Accounting (Recompile)                       *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3281 - Discrepancies on sources (Recompile)               *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDELDPP *
      *  184967 - Partial Replacement Pgm for AA0003                  *
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
      * DEALS  - FX and NAp's Profit centres are to be defaulted      *
      * MMARKET- Money markets are Profit centres are to be defaulted *
      * PCDM   - Call the Profit Centre Default matrix                *
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
 
     FFXDEALPP  UF   E             DISK
     FDEALSDB   UF   E             DISK    PREFIX(B)
      *
     FMMDELDPP  UF   E             DISK
     FDEALSDC   UF   E             DISK    PREFIX(C)
      *
     FMMDENBPP  UF   E             DISK
     FDEALSDD   UF   E             DISK    PREFIX(D)
      *
 
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
      **  Profit Centre Details
 
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
     D PCDMCust        S              6
     D @RTCD           S              7
     D @OPTN           S              7
     D @KEY1           S             10
     D @KYST           S              7
     D RetCode1A       S              1
     D RtnCode         S              7
     D WProfitC        S              4
     D Option          S              7
 
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
      *IF Dealing (FX/Neg. Assets) is switched ON EXSR to populate PRFC
     C                   IF        BGDLFX = 'Y'
     C                   EXSR      DEALS
     C                   ENDIF
      *
      *
      *IF Dealing (Money Markets) is switched ON EXSR to populate PRFC
     C                   IF        BGDLMM = 'Y'
     C                   EXSR      MMARKET
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DEALS - Subroutine to use if Dealing Module is On             *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: PCDM                                                   *
      *                                                               *
      *****************************************************************
 
     C     DEALS         BEGSR
 
      * If the value on the AADTA is not blank then process the FX deals
     C                   IF        AAFXPC <> *BLANKS
     C                   READ      FXDEALPP                               40
      *
      * Do While not EOF
     C                   DOW       *IN40 = '0'
      *
      * If the Profit Centre is blank on the record
     C                   IF        FHPRFC = *Blanks
     C                   EVAL      PCDMBookC = FHBOKC
     C                   EVAL      PCDMTranType = FHTYPE
     C                   EVAL      PCDMSubType = FHSTYP
     C                   EVAL      PCDMBranch = FHMBCA
     C                   MOVEL     FHDCNO        PCDMCust
      *
      * Get default from the Profit Centre Default Matrix
     C                   EXSR      PCDM
      *
      * If the Profit centre is returned blank Use the Profit Centre in AADTA
     C                   IF        WProfitC = *Blanks OR
     C                             WProfitC = FTUAPC
     C                   EVAL      FHPRFC = AAFXPC
      *
     C                   ELSE
     C                   EVAL      FHPRFC = WProfitC
     C                   ENDIF
      *
      * Update the record with the Profit Centre
     C                   UPDATE    FXDEALP0
     C                   ENDIF
      * Read next record
     C                   READ      FXDEALPP                               40
     C                   ENDDO
      *
      *
      * Read the next set of files from DEALSDB
     C                   READ      DEALSDB                                40
      *
      * Do While not EOF
     C                   DOW       *IN40 = '0'
      *
      * If the Profit Centre is blank on the record
     C                   IF        BPRFC = *Blanks
     C                   EVAL      PCDMBookC = BBOKC
     C                   EVAL      PCDMTranType = BDTYP
     C                   EVAL      PCDMSubType = BDLST
     C                   EVAL      PCDMBranch = BBRCA
     C                   MOVEL     BCNUM         PCDMCust
      *
      * Get default from the Profit Centre Default Matrix
     C                   EXSR      PCDM
      *
      * If the Profit centre is returned blank Use the Profit Centre in AADTA
     C                   IF        WProfitC = *Blanks OR
     C                             WProfitC = FTUAPC
     C                   EVAL      BPRFC = AAFXPC
      *
     C                   ELSE
     C                   EVAL      BPRFC = WProfitC
     C                   ENDIF
      *
      * Update the record with the Profit Centre
     C                   UPDATE    DEALSDBF
     C                   ENDIF
      * Read next record
     C                   READ      DEALSDB                                40
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MMARKET - Subroutine to use if Money Markets Module is On     *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: PCDM                                                   *
      *                                                               *
      *****************************************************************
 
     C     MMARKET       BEGSR
 
 
      * If the value on the AADTA is not blank then process the NA deals
     C                   IF        AANAPC <> *BLANKS
     C                   READ      MMDENBPP                               40
      *
      * Do While not EOF
     C                   DOW       *IN40 = '0'
      *
      * If the Profit Centre is blank on the record
     C                   IF        HLPRFC = *Blanks
     C                   EVAL      PCDMBookC = HLBOKC
     C                   EVAL      PCDMTranType = HLTYPE
     C                   EVAL      PCDMSubType = HLSTYP
     C                   EVAL      PCDMBranch = HLBRCA
     C                   MOVEL     HLCNUM        PCDMCust
      *
      * Get default from the Profit Centre Default Matrix
     C                   EXSR      PCDM
      *
      * If the Profit centre is returned blank Use the Profit Centre in AADTA
     C                   IF        WProfitC = *Blanks OR
     C                             WProfitC = FTUAPC
     C                   EVAL      HLPRFC = AANAPC
      *
     C                   ELSE
     C                   EVAL      HLPRFC = WProfitC
     C                   ENDIF
      *
      * Update the record with the Profit Centre
     C                   UPDATE    MMDENBP0
     C                   ENDIF
      * Read next record
     C                   READ      MMDENBPP                               40
     C                   ENDDO
      *
      *
      * Read the next set of files from DEALSDD
     C                   READ      DEALSDD                                40
      *
      * Do While not EOF
     C                   DOW       *IN40 = '0'
      *
      * If the Profit Centre is blank on the record
     C                   IF        DPRFC = *Blanks
     C                   EVAL      PCDMBookC = DBOKC
     C                   EVAL      PCDMTranType = DDTYP
     C                   EVAL      PCDMSubType = DDLST
     C                   EVAL      PCDMBranch = DBRCA
     C                   MOVEL     DCNUM         PCDMCust
      *
      * Get default from the Profit Centre Default Matrix
     C                   EXSR      PCDM
      *
      * If the Profit centre is returned blank Use the Profit Centre in AADTA
     C                   IF        WProfitC = *Blanks OR
     C                             WProfitC = FTUAPC
     C                   EVAL      DPRFC = AANAPC
      *
     C                   ELSE
     C                   EVAL      DPRFC = WProfitC
     C                   ENDIF
      *
      * Update the record with the Profit Centre
     C                   UPDATE    DEALSDDF
     C                   ENDIF
      * Read next record
     C                   READ      DEALSDD                                40
     C                   ENDDO
     C                   ENDIF
     C                   IF        AAMMPC <> *BLANKS
     C                   READ      MMDELDPP                               40
      *
      * Do While not EOF
     C                   DOW       *IN40 = '0'
      *
      * If the Profit Centre is blank on the record
     C                   IF        HKPRFC = *Blanks
     C                   EVAL      PCDMBookC = HKBOKC
     C                   EVAL      PCDMTranType = HKTYPE
     C                   EVAL      PCDMSubType = HKSTYP
     C                   EVAL      PCDMBranch = HKBRCA
     C                   MOVEL     HKCNUM        PCDMCust
      *
      * Get default from the Profit Centre Default Matrix
     C                   EXSR      PCDM
      *
      * If the Profit centre is returned blank Use the Profit Centre in AADTA
     C                   IF        WProfitC = *Blanks OR
     C                             WProfitC = FTUAPC
     C                   EVAL      HKPRFC = AAMMPC
      *
     C                   ELSE
     C                   EVAL      HKPRFC = WProfitC
     C                   ENDIF
      *
      * Update the record with the Profit Centre
     C                   UPDATE    MMDELDP0
     C                   ENDIF
      * Read next record
     C                   READ      MMDELDPP                               40
     C                   ENDDO
      *
      *
      * Read the next set of files from DEALSDC
     C                   READ      DEALSDC                                40
      *
      * Do While not EOF
     C                   DOW       *IN40 = '0'
      *
      * If the Profit Centre is blank on the record
     C                   IF        CPRFC = *Blanks
     C                   EVAL      PCDMBookC = CBOKC
     C                   EVAL      PCDMTranType = CDTYP
     C                   EVAL      PCDMSubType = CDLST
     C                   EVAL      PCDMBranch = CBRCA
     C                   MOVEL     CCNUM         PCDMCust
      *
      * Get default from the Profit Centre Default Matrix
     C                   EXSR      PCDM
      *
      * If the Profit centre is returned blank Use the Profit Centre in AADTA
     C                   IF        WProfitC = *Blanks OR
     C                             WProfitC = FTUAPC
     C                   EVAL      CPRFC = AAMMPC
      *
     C                   ELSE
     C                   EVAL      CPRFC = WProfitC
     C                   ENDIF
      *
      * Update the record with the Profit Centre
     C                   UPDATE    DEALSDCF
     C                   ENDIF
      * Read next record
     C                   READ      DEALSDC                                40
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * PCDM    - Subroutine to Call the Profit Centre Default matrix *
      *                                                               *
      * Called by: Deals, MMarket                                     *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     PCDM          BEGSR
 
      * Move Customer No. into the Field for the call to the Access Object
     C                   EVAL      @KEY1 = PCDMCust
      *
      *Get the Account Officer for the Deal Customer
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1
     C                   PARM      *BLANKS       @KYST
     C     SDCUST        PARM      *BLANKS       DSSDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   EVAL      ACOF = BBACOC
     C                   ELSE
     C                   EVAL      ACOF = *Blanks
     C                   ENDIF
      *Call Profit Centre Default Matrix
     C                   CALL      'AOPRFMR0'
     C                   PARM      *BLANKS       RetCode1A
     C                   PARM      PCDMBookC     BOOK              2            Book Code
     C                   PARM      PCDMTranType  TranType          5            Transacton Type
     C                   PARM      PCDMSubType   SubType           2            Sub Type
     C                   PARM      PCDMBranch    BRAN              3            Branch Code
     C                   PARM      *BLANKS       DEPT              3            Deptment Code
     C                   PARM      *BLANKS       USER             10            User
     C                   PARM                    ACOF              2            Account Officer
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
     C                   EVAL      DBASE  =  003
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
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/*INZSR'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
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
