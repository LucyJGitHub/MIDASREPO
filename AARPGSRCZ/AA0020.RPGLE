     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas AA Initialise retail & nostro a/cs prft cent')   *
      *****************************************************************
      *                                                               *
      *  Midas - Profit Centre Accounting Module                      *
      *                                                               *
      *  AA0020 - Initialise Retail & Nostro a/cs Prft Cent           *
      *         - Rewrite of AA0001                                   *
      *                                                               *
      *  Function:  This program fills Nostro and retail accounts     *
      *             the profit centre from the Default Matrix or      *
      *             AADTA.                                            *
      *                                                               *
      *             NOTE: This program DOES NOT pass Department and   *
      *             User to the PCDM (it passes Blanks) As these are  *
      *             generally unavailable from the transaction file.  *
      *                                                               *
      *  Called By: AAC0020 - Nostro/Retail accounts PRFC default     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD046874           Date 31Jul17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 184967   *CREATE   Date 12Sep00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046874 - Incorrectly update the Retail's account type      *
      *             causing database error in REC62N component        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  184967 - PCA Implementation Utilities                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    40         ACCNTAB EOF                                     *
      *    41         SDNOSTL2 Chain Fail                             *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
 
     FACCNTAB   UF   E           K DISK
      **  Accounts Master File
      *
     FSDNOSTL2  IF   E           K DISK
      **  Nostro details
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
     D WAccType        S              1    INZ(' ')                                         MD046874
 
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
     C     *LOCK         IN        AADTA
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   END
 
     C                   READ      ACCNTAB                                40
      *
      * Do While not EOF
     C                   DOW       *IN40 = '0'
     C                   EVAL      WAccType = ATYP                                          MD046874
      *
      ** If retail account, check whether in fact it is a nostro
     C                   IF        ATYP = 'R'
     C                   MOVEL     CNUM          A7CUST
     C                   EVAL      A7CYCD = CCY
     C                   MOVEL     ACOD          A7ACCD
     C                   EVAL      A7ACSN = ACSQ
     C                   EVAL      A7BRCD = BRCA
     C     NostroKey     CHAIN     SDNOSTL2                           41
      *
     C                   IF        *IN41 = '0'
     C**********         EVAL      ATYP = 'N'                                               MD046874
     C                   EVAL      WAccType = 'N'                                           MD046874
     C                   ENDIF
      *ENDIF ATYP = 'R'
     C                   ENDIF
      *
      *  If the profit centre is blank, use the
      *  default matrix to allocate a profit centre
     C                   IF        PRFC = *Blanks
     C                   EVAL      PCDMBookC = *Blanks
     C                   EVAL      PCDMTranType = *Blanks
     C                   EVAL      PCDMSubType = *Blanks
     C                   EVAL      PCDMBranch = BRCA
     C                   MOVEL     CNUM          PCDMCust
      *
      * Get default from the Profit Centre Default Matrix
     C                   EXSR      PCDM
      *
      * If the Profit centre is returned blank or equals the Unallocated PRFC
      * Use the Profit Centre in AADTA
     C                   IF        WProfitC = *Blanks OR
     C                             WProfitC = FTUAPC
      *
      * If Account type is Retail
     C**********         IF        ATYP = 'R'                                               MD046874
     C                   IF        WAccType = 'R'                                           MD046874
     C                   EVAL      PRFC = AAREPC
     C                   UPDATE    ACCNTABF
     C                   ENDIF
      *
      * If Account type is Nostro
     C**********         IF        ATYP = 'N'                                               MD046874
     C                   IF        WAccType = 'N'                                           MD046874
     C                   EVAL      PRFC = AANSPC
     C                   UPDATE    ACCNTABF
     C                   ENDIF
      *
      * Else Profit Cente not Blank
     C                   ELSE
     C                   EVAL      PRFC = WProfitC
     C                   UPDATE    ACCNTABF
      *
      * ENDIF for a return of blank profit centre
     C                   ENDIF
      * ENDIF for IF PRFC is blank on the file
     C                   ENDIF
      *
      * Read next record
     C                   READ      ACCNTAB                                40
     C                   ENDDO
 
      * This program has run suucessfully and therefor it should be
      * flagged as having run.  This allows AA0002 to run.
     C                   EVAL      AARNPI = 'Y'
     C                   OUT       AADTA
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * PCDM    - Subroutine to Call the Profit Centre Default matrix *
      *                                                               *
      * Called by: MAIN                                               *
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
     C     WProfitC      PARM      *Blanks       DMFC              4            Profit Centre
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
     C                   EVAL      DBASE  =  002
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
     C                   EVAL      DBASE  =  003
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/*INZSR'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
      *
      **  Nostro key
      *
     C     NostroKey     KLIST
     C                   KFLD                    A7CUST
     C                   KFLD                    A7CYCD
     C                   KFLD                    A7ACCD
     C                   KFLD                    A7ACSN
     C                   KFLD                    A7BRCD
 
     C                   ENDSR
 
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
