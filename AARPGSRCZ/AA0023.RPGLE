     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas AA Initialise profit centres for lending')       *
      *****************************************************************
      *                                                               *
      *  Midas - Analytical Accounting Module                         *
      *                                                               *
      *  AA0023   - Update Lending module Files with PRFC             *
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
      *  Called By: AAC0023 - AA Lending PRFC Update                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE141             Date 08Feb16               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CLE042             Date 06Sep05               *
      *                 CSD027             Date 09Dec05               *
      *                 CAS009             Date 16May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAP074             Date 08Aug02               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      *                 CLE028             Date 27Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 192871             Date 17Jul01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CLE011             Date 07Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 184967  *CREATE    Date 12Sep00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS009 - EIR/AC Accounting (Recompile)                       *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *           (Recompile)                                         *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile).               *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *           (Recompile)                                         *
      *  192871 - Account Officer Field in CLOANCL is corrupted       *
      *           from blanks to '**' (from the profit matrix table)  *
      *  CLE011 - Rate Fixing Days for Lending Rollover Processing    *
      *           Recompile                                           *
      *  184967 - Partial Replacement for AA0003                      *
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
      * LENDING - use if Dealing Module is On                         *
      * PCDM    - Call the Profit Centre Default matrix               *
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

     FCLOANCL   UF   E             DISK

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
      *IF Lending  is switched ON EXSR to populate PRFC
     C                   IF        BGCSLN = 'Y'
     C                   EXSR      LENDING
     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   RETURN

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * LENDING - Subroutine to use if Dealing Module is On           *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     LENDING       BEGSR

      * If the value on the AADTA is not blank then process the FX deals
     C                   IF        AALEPC <> *BLANKS
     C                   READ      CLOANCL                                40
      *
      * Do While not EOF
     C                   DOW       *IN40 = '0'
      *
      * If the Profit Centre is blank on the record
     C                   IF        PRFC = *Blanks
     C                   EVAL      PCDMBookC = BOKC
     C                   EVAL      PCDMTranType = LTYP
     C                   EVAL      PCDMSubType = SUTP
     C                   EVAL      PCDMBranch = BRCA
     C                   EVAL      PCDMAcOF = ACOF
     C                   MOVEL     CNUM          PCDMCust
      *
      * Get default from the Profit Centre Default Matrix
     C                   EXSR      PCDM
      *
      * If the Profit centre is returned blank Use the Profit Centre in AADTA
     C                   IF        WProfitC = *Blanks OR
     C                             WProfitC = FTUAPC
     C                   EVAL      PRFC = AALEPC
      *
     C                   ELSE
     C                   EVAL      PRFC = WProfitC
     C                   ENDIF
      *
      * Update the record with the Profit Centre
     C                   UPDATE    CLOANCLF
     C                   ENDIF
      * Read next record
     C                   READ      CLOANCL                                40
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

      *Call Profit Centre Default Matrix
     C                   CALL      'AOPRFMR0'
     C                   PARM      *BLANKS       RetCode1A
     C                   PARM      PCDMBookC     BOOK              2            Book Code
     C                   PARM      PCDMTranType  TranType          5            Transacton Type
     C                   PARM      PCDMSubType   SubType           2            Sub Type
     C                   PARM      PCDMBranch    BRAN              3            Branch Code
     C                   PARM      *BLANKS       DEPT              3            Deptment Code
     C                   PARM      *BLANKS       USER             10            User
     C**********         PARM      PCDMAcOf      ACOF              2           Account Officer192871
     C                   PARM      PCDMAcOf      AOFF              2            A/C Officer   192871
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
     C                   EVAL      DBASE  =  001
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
