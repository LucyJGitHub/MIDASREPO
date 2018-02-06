     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas AA Initialise profit centres for securities')
      *****************************************************************
      *                                                               *
      *  Midas - Analytical Accounting Module                         *
      *                                                               *
      *  AA0027  - Update Securities module Position Settlements file *
      *            Populates the settlements with profit centres      *
      *                                                               *
      *  Function:  This program uses the Book and Position Profit    *
      *             Centres to fill the empty profit centre the file  *
      *             If it is does not exist or is blank then the      *
      *             Profit Centre is defaulted in from AADTA          *
      *                                                               *
      *  Called By: AAC0027 - Position Settlements PRFC Update        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD045894           Date 23Jun17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG3122            Date 17Jul04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 184967  *CREATE    Date 12Sep00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD045894 - PCAM utility override value of RECI               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
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
     FPOSETD    UF   E             DISK
 
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
 
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      **  SE ICD
 
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)
      **  PCA ICD
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      **  SE ICD
 
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
     D KeyTrCnum       S              6A                                                      CSD027
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
      *Only run if AA0007 has previously run
     C                   IF        AAPCBC = 'Y'
      *
      *IF Securities is switched ON EXSR to populate PRFC
     C                   IF        BGSECS = 'Y'
 
      * If the value on the AADTA is not blank then process the FX deals
     C                   IF        AABKPC <> *BLANKS  AND
     C                             AATRPC <> *BLANKS
      * Update position settlements
     C                   EXSR      SRPOSS
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPOSS - Subroutine to update Position Settlements            *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: PCDM, ACOfficer, SRVLCN                                *
      *                                                               *
      *****************************************************************
 
     C     SRPOSS        BEGSR
     C                   READ      POSETD                                 40
      *
      * Do While not EOF
     C                   DOW       *IN40 = '0'
      *
      **  If the book profit centre is blank, update it
     C                   IF        PPFC = *Blanks
      *
      **  Test to see if the Customer is a valid Securities Customer
     C                   MOVEL     PCPY          WCust
     C                   EXSR      SRVLCN
      *
     C                   IF        BFCLAS = 'S' OR
     C                             BFCLAS = 'D'
      *
     C                   EVAL      KeyTrCNum = PCPY
     C                   EVAL      KeyTrBrch = PBCA
     C                   EVAL      KeyTrSeSN = PSSH
      *
      * Chain on SEPCCD
     C     TranKey       CHAIN     SEPCCD                             40
      *
     C                   IF        *IN40 = '1' OR
     C                             PCCU = *Blanks
     C                   EVAL      PPFC = BVSEPC
     C                   ELSE
     C                   EVAL      PPFC = PCCU
     C                   ENDIF
      *
      *Else If Not 'S' or 'D' Use Book Profit Centre
     C                   ELSE
     C                   EVAL      KeyBkBook = PBCD
     C                   EVAL      KeyBkBrch = PBCA
     C                   EVAL      KeyBkSeSN = PSSH
     C                   EVAL      KeyBkMktI = PMAR
      *
      * Chain on SEPCBD
     C     BookKey       CHAIN     SEPCBD                             40
      *
     C                   IF        *IN40 = '1' OR
     C                             PCBK = *Blanks
     C                   EVAL      PPFC = AABKPC
      *
     C                   ELSE
     C                   EVAL      PPFC = PCBK
     C                   ENDIF
     C                   ENDIF
      * Update the record with the Profit Centre
     C                   UPDATE    POSETDF
     C                   ENDIF
      * Read next record
     C                   READ      POSETD                                 40
     C                   ENDDO
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVLCN - Validate Security customer                           *
      *                                                               *
      * Called by: SRPOSS                                             *
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
