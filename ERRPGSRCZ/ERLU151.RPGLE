     H DEBUG FTRANS                                                                      /*222594*/
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ER Records Type 29 Generation')                  *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ERLU151 - Midas ER Records Type 29 Generation                *
      *                                                               *
      *  Function:  This program generates Record type 029 from       *
      *             ERLUTRPD.                                         *
      *                                                               *
      *  Called By: PGM/ERLU151 - ER Records Type 29 Generation       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CLE154             Date 07Aug12               *      
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 225555             Date 01Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 CER001             Date 25Apr05               *
      *                 222594             Date 25Mar03               *
      *                 218459             Date 03Jun03               *
      *                 ULX047             Date 25Mar03               *
      *                 UPG402             Date 03Oct04
      *                 ULX046  *CREATE    Date 29Oct02               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *      
      *  CLE148 - Alpha Loan Reference                                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (recompiled)                                        *
      *  225555 - Add discount/premium amount, amount to amortize     *
      *           and 'Prix d'Acquisition'. Recompile only over       *
      *           changed ERLUTRPD.                                   *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  222594 - Midas must change special character in RT28 and RT29*
      *  218459 - Wrong files in the xxCADLIB                         *
      *  ULX047 - CSSF Market Values Calculation                      *
      *  UPG402 - Recompile due to R4.02 upgrade                      *
      *  ULX046 - Circulars 2002/170-174-175 Integration              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    99         Working indicator.                              *
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
 
     F***ERLUTRPD**IF   E             DISK    INFSR(*PSSR)                                    CER001
     FERLTRXPD  IF   E             DISK    INFSR(*PSSR)                                       CER001
      ** MIDAS ER Production Extract
 
     F***HISTR*****IF   E           K DISK    INFSR(*PSSR)  INCLUDE(HISTSHPF)                 CER001
     FLEHISXL0  IF   E           K DISK    INFSR(*PSSR)  INCLUDE(HISTSHPF)                    CER001
      ** Midas LE History file
 
     F***ERLVENL1**IF   E           K DISK    INFSR(*PSSR)                                    CER001
     FERLVNXL1  IF   E           K DISK    INFSR(*PSSR)                                       CER001
      ** Midas ER Customer Lending Events - Rtv. file
 
     F*DBANKL1  IF   E           K DISK    INFSR(*PSSR)                         218459
     F***ERBANKL1**IF   E           K DISK    INFSR(*PSSR)                             218459 CER001
     FERBNKXL0  IF   E           K DISK    INFSR(*PSSR)                                       CER001
      ** Midas SD Bank details ICD retrieve logical
 
     F*DCURRL0  IF   E           K DISK    INFSR(*PSSR)                         218459
     FSDCURRL1  IF   E           K DISK    INFSR(*PSSR)                         218459
      ** Midas SD Currency codes
 
     FSDCURRLD  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Currencies field by SWIFT currency code
 
     F***ERLU29PP**O    E             DISK    INFSR(*PSSR)                                    CER001
     FERL29XPD  O    E             DISK    INFSR(*PSSR)                                       CER001
      ** Midas Automatique Calculation of "TAEG" rate
 
     FERLU151AU O    E             PRINTER INFSR(*PSSR)
      ** Midas ER Records Type 29 Generation - Audit
 
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
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D                 DS
      **  Arrays containing the CCSF Economic Sector Code to process.
     D TCode                          4S 0 DIM(4) CTDATA PERRCD(1)
 
     D                 DS
      ** Data Structure to redefine Code Schema A.
     D EXSCHA                         8S 0
     D  GenCode                1      3S 0
 
     D                 DS
      ** Data Structure to redefine Origine of record
     D***EXORIG                        20                                                     CER001
     D EXORIG                        26                                                       CER001
     D**LoanRef                6     11S 0                                                    CLE148
     D  LoanRef                6     11A                                                      CLE148
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Program parameters
 
     D RBJMRDT         S              7
     D RBJURPT         S             53
 
      ** CALCON working fields
 
     D INAMNT          S             16  0
     D @@RAT1          S             13  8
     D @@MDI1          S              1
     D @@NBD1          S              1  0
     D @@RAT2          S             13  8
     D @@MDI2          S              1
     D @@NBD2          S              1  0
 
      ** ZDATE9 Parameters
 
     D @@DAYN          S              5P 0
     D DateOut         S              8S 0
     D @@RTN           S              1
 
     D*LoanCust**      S              6S 0                                                   CSD027A
     D LoanCust        S              6A                                                     CSD027A
     D @RUN            S              1
     D WkIntCap        S                   LIKE(EXCREP)                         Interest Capitat
 
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
 
      ** Read all records
 
     C*****1****         SETLL     ERLUTRPD                                                   CER001
     C**********         READ      ERLUTRPD                                                   CER001
     C**********         DOW       NOT %EOF(ERLUTRPD)                                         CER001
     C     1             SETLL     ERLTRXPD                                                   CER001
     C                   READ      ERLTRXPD                                                   CER001
     C                   DOW       NOT %EOF(ERLTRXPD)                                         CER001
 
      ** Increase the number of record read.
 
     C                   EVAL      RCOUNT = RCOUNT + 1
 
      ** Select ERLUTRPD records according the following criteria:
 
     C                   IF            EXLOTD  = 'LEN'
     C                             AND EXCCYL  = 'EUR'
     C                             AND GenCode = 104
     C                             AND EXNWDC  = 1                              New Deposit/Credit
     C                             AND EXCTRF  <> *BLANKS
     C                             OR  EXLOTD  = 'LEN'                          ULX047
     C                             AND EXPRFO  = 'Y'                            ULX047
     C                             AND GenCode = 104                            ULX047
     C                             AND EXNWDC  = 1                              ULX047
     C                             AND EXCTRF  <> *BLANKS                       ULX047
 
     C                   IF            EXAMTY  = 1
     C                             OR  EXAMTY  = 2
 
     C     EXECOS        LOOKUP    TCode                                  99
     C                   IF        %EQUAL
 
      ** Common fields
      ** -------------
 
      ** Standard Record Type
 
     C                   EVAL      EXRECT = 029
 
      ** Unique Contract Reference
 
     C                   EVAL      EXCTRF = EXCTRF
 
      ** Net Credit Amount in Capital Currency
 
     C                   EVAL      EXLNCR = EXLNCR
 
      ** Number of Days Between the Reimbursement Date and the Start
 
     C                   EVAL      EXDYSD = 0
 
      ** Retrieve repayments in the Customer Lending History file.
      ** ---------------------------------------------------------
 
     C                   MOVE      EXCUST        LoanCust
 
     C*****KHISTR        SETLL     HISTR                                                      CER001
     C*****KHISTR        READE     HISTR                                                      CER001
     C**********         DOW       NOT %EOF(HISTR)                                            CER001
     C     KHISTR        SETLL     LEHISXL0                                                   CER001
     C     KHISTR        READE     LEHISXL0                                                   CER001
     C                   DOW       NOT %EOF(LEHISXL0)                                         CER001
 
     C                   IF            AMTP = 'MR'
     C                             OR  AMTP = 'RE'
 
      ** Credit Reimbursement Amount in Capital Currency
 
     C                   EVAL      INAMNT = PRAM + INTA
     C                   IF        INAMNT <> 0
     C                   EXSR      CALCON
     C                   EVAL      EXCREP = OUTAMT * (10**(3-@@NBD1))
     C                   ELSE
     C                   EVAL      EXCREP = *ZEROS
     C                   ENDIF
 
     C                   IF        EXCREP < 0
     C                   EVAL      EXCRES = '-'
     C                   EVAL      EXCREP = EXCREP * -1
     C                   ELSE
     C                   EVAL      EXCRES = '+'
     C                   ENDIF
 
      ** Reimbursement Date
 
     C                   IF        VDAT <> 0
     C                   CALLB     'ZDATE9'
     C                   PARM      VDAT          @@DAYN
     C                   PARM      *ZEROS        DateOut
     C                   PARM      *BLANKS       @@RTN
 
     C                   IF        @@RTN <> '0'
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'ZDATE9'
     C                   MOVEL(P)  VDAT          DBKEY
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  004
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'MAIN'
     C                   OUT       LDA
     C                   WRITE     DBERROR
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      EXREID = DateOut
     C                   ELSE
     C                   EVAL      EXREID = *ZEROS
     C                   ENDIF
 
      ** Increase the number of record Generated.
 
     C                   EVAL      RGENER = RGENER + 1
 
     C                   WRITE     ERLU29D0
 
     C                   ENDIF
 
     C*****KHISTR        READE     HISTR                                                      CER001
     C     KHISTR        READE     LEHISXL0                                                   CER001
     C                   ENDDO
 
      ** Remaining Instalments from the reporting date till the maturity.
      ** ----------------------------------------------------------------
 
     C                   EVAL      WkIntCap = *ZEROS                            Interest Capitalized
 
     C*****LoanRef       SETLL     ERLVENL1                                                   CER001
     C*****LoanRef       READE     ERLVENL1                                                   CER001
     C     LoanRef       SETLL     ERLVNXL1                                                   CER001
     C     LoanRef       READE     ERLVNXL1                                                   CER001
 
     C**********         DOW       NOT %EOF(ERLVENL1)                                         CER001
     C                   DOW       NOT %EOF(ERLVNXL1)                                         CER001
 
      ** If the interests are capitalized, the interest amount should be kept to be
      ** substracted from the principal amount at maturity date.
 
     C                   IF        ETYP2 = 'X2'                                 Event: Int. Capital.
     C                   EVAL      WkIntCap = WkIntCap + EAMT
     C*****LoanRef       READE     ERLVENL1                                                   CER001
     C     LoanRef       READE     ERLVNXL1                                                   CER001
     C                   ITER
     C                   ENDIF
 
      ** Credit Reimbursement Amount in Capital Currency
 
     C                   EVAL      EXCREP = EAMT * (10**(3-@@NBD1))
 
      ** If the interests are capitalized, the interest amount should be
      ** substracted from the principal amount at maturity date.
 
     C                   IF        ETYP2 = 'M1'                                 Event: Princ. Matur.
     C                             AND WkIntCap <> *ZEROS
     C                   EVAL      WkIntCap = WkIntCap * (10**(3-@@NBD1))
     C                   EVAL      EXCREP = EXCREP - WkIntCap
     C                   EVAL      WkIntCap = *ZEROS
     C                   ENDIF
 
     C                   IF        EXCREP < 0
     C                   EVAL      EXCRES = '-'
     C                   EVAL      EXCREP = EXCREP * -1
     C                   ELSE
     C                   EVAL      EXCRES = '+'
     C                   ENDIF
 
      ** Reimbursement Date
 
     C                   IF        EDAT <> 0
     C                   CALLB     'ZDATE9'
     C                   PARM      EDAT          @@DAYN
     C                   PARM      *ZEROS        DateOut
     C                   PARM      *BLANKS       @@RTN
 
     C                   IF        @@RTN <> '0'
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'ZDATE9'
     C                   MOVEL(P)  EDAT          DBKEY
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  005
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'MAIN'
     C                   OUT       LDA
     C                   WRITE     DBERROR
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      EXREID = DateOut
     C                   ELSE
     C                   EVAL      EXREID = *ZEROS
     C                   ENDIF
 
      ** Increase the number of record Generated.
 
     C                   EVAL      RGENER = RGENER + 1
 
     C                   WRITE     ERLU29D0
 
     C*****LoanRef       READE     ERLVENL1                                                   CER001
     C     LoanRef       READE     ERLVNXL1                                                   CER001
     C                   ENDDO
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Read next record
 
     C**********         READ      ERLUTRPD                                                   CER001
     C                   READ      ERLTRXPD                                                   CER001
 
     C                   ENDDO
 
      ** Audit report control
 
     C                   WRITE     CONTROL
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      **********************************************************************
      /EJECT
      **********************************************************************
      **
      **   CALCON     Convert Amount to Report CCY
      **
      **   INPUT  : INAMNT 160
      **   OUTPUT : OUTAMT 160
      **
      **********************************************************************
 
     C     CALCON        BEGSR
 
     C                   Z-ADD     0             OUTAMT           16 0
 
     C     @@MDI1        IFEQ      'M'
     C     @@MDI2        ANDEQ     'D'
     C     @@RAT1        MULT      @@RAT2        WWRAT            13 8
     C     INAMNT        MULT(H)   WWRAT         OUTAMT
     C                   END
 
     C     @@MDI1        IFEQ      'M'
     C     @@MDI2        ANDEQ     'M'
     C     INAMNT        MULT      @@RAT1        OUTAMT
     C     OUTAMT        DIV(H)    @@RAT2        OUTAMT
     C                   END
 
     C     @@MDI1        IFEQ      'D'
     C     @@MDI2        ANDEQ     'D'
     C     INAMNT        MULT      @@RAT2        OUTAMT
     C     OUTAMT        DIV(H)    @@RAT1        OUTAMT
     C                   END
 
     C     @@MDI1        IFEQ      'D'
     C     @@MDI2        ANDEQ     'M'
     C     @@RAT1        MULT      @@RAT2        WWRAT
     C     INAMNT        DIV(H)    WWRAT         OUTAMT
     C                   END
 
     C     OUTAMT        DIV(H)    10            OUTAMT
     C     OUTAMT        MULT      10            OUTAMT
 
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
 
     C     *ENTRY        PLIST
     C                   PARM                    RBJMRDT
     C                   PARM                    RBJURPT
 
      ** Audit report header
 
     C                   WRITE     HEADAU
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  LDA
 
      ** Retrieve the Base currency.
 
     C*    'BANK      '  CHAIN     SDBANKL1                                     218459
     C*****'BANK      '  CHAIN     ERBANKL1                                            218459 CER001
     C     'BANK      '  CHAIN     ERBNKXL0                                            218459 CER001
 
     C*                  IF        NOT %FOUND(SDBANKL1)                         218459
     C**********         IF        NOT %FOUND(ERBANKL1)                                218459 CER001
     C                   IF        NOT %FOUND(ERBNKXL0)                                218459 CER001
 
      ** Data base error in file SDBANKL1
 
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C*                  EVAL      DBFILE =  'SDBANKL1'                         218459
     C**********         EVAL      DBFILE =  'ERBANKL1'                                218459 CER001
     C                   EVAL      DBFILE =  'ERBNKXL0'                                218459 CER001
     C                   EVAL      DBKEY  =  'BANK'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  '*INZSR'
     C                   OUT       LDA
     C                   WRITE     DBERROR
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve the Base currency details.
 
     C*    BJCYCD        CHAIN     SDCURRL0                                     218459
     C     BJCYCD        CHAIN     SDCURRL1                                     218459
 
     C*                  IF        NOT %FOUND(SDCURRL0)                         218459
     C                   IF        NOT %FOUND(SDCURRL1)                         218459
 
      ** Data base error in file SDCURRL0
 
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C*                  EVAL      DBFILE =  'SDCURRL0'                         218459
     C                   EVAL      DBFILE =  'SDCURRL1'                         218459
     C                   EVAL      DBKEY  =  BJCYCD
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  '*INZSR'
     C                   OUT       LDA
     C                   WRITE     DBERROR
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      @@RAT2  =  A6SPRT
     C                   EVAL      @@MDI2  =  A6MDIN
     C                   EVAL      @@NBD2  =  A6NBDP
 
      ** Retrieve the EUR currency details.
 
     C     'EUR'         CHAIN     SDCURRLD
 
     C                   IF        NOT %FOUND(SDCURRLD)
 
      ** Data base error in file SDCURRLD
 
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDCURRLD'
     C                   EVAL      DBKEY  =  'EUR'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  003
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  '*INZSR'
     C                   OUT       LDA
     C                   WRITE     DBERROR
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      @@RAT1  =  A6SPRT
     C                   EVAL      @@MDI1  =  A6MDIN
     C                   EVAL      @@NBD1  =  A6NBDP
 
      ** Key field to access the Customer Lending History file.
 
     C     KHISTR        KLIST
     C                   KFLD                    EXBRCD
     C                   KFLD                    LoanCust
     C                   KFLD                    LoanRef
 
     C                   ENDSR
 
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
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      *
      ** Array 'FTRANS' change to ERL29XPD instead of ERLU29PP                                CER001
      *
**FTRANS                                                                                      222594
*EQUATE   ERL29XPD
*EQUATE   C144504EC551C552C554C956C164C368406A406FC571C572C5744079407A407D
*EQUATE   407E407F
*EQUATE   C181C282C383C484C585C686C787C888C989D191D292D393D494D595D696D797
*EQUATE   D898D999
*EQUATE   E2A2E3A3E4A4E5A5E6A6E7A7E8A8E9A940E0E4FE
**CTDATA TCode
3000 - Non-profit making households and institutions for households - Others
3110 - Households - Sole traders - LU
3120 - Households - Natural persons - LU
3200 - Non-profit making institutions for households - LU and UM
