     H DEBUG FTRANS                                                                      /*222594*/
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ER Records Type 28 Generation')
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ERLU150 - Midas ER Records Type 28 Generation                *
      *                                                               *
      *  Function:  This program generates Record type 028 from       *
      *             ERLUTRPD.                                         *
      *                                                               *
      *  Called By: ERC0702 - ER Interface to FRS Component           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Last Amend No. 225555             Date 01Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027A            Date 03May06               *
      *                 CER001             Date 25Apr05               *
      *                 222594             Date 25Mar03               *
      *                 ULX047             Date 25Mar03               *
      *  Prev Amend No. 214603             Date 04Feb03               *
      *                 ULX046  *CREATE    Date 29Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  225555 - Add discount/premium amount, amount to amortize     *
      *           and 'Prix d'Acquisition'. Recompile only over       *
      *           changed ERLUTRPD.                                   *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  222594 - Midas must change special character in RT28 and RT29*
      *  ULX047 - CSSF Market Values Calculation                      *
      *  214603 - Several problems due to ULX046                      *
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
 
     F***ERLU28PP**O    E             DISK    INFSR(*PSSR)                                    CER001
     FERL28XPD  O    E             DISK    INFSR(*PSSR)                                       CER001
      ** Midas Automatique Calculation of "TCA" rate
 
     FERLU150AU O    E             PRINTER INFSR(*PSSR)
      ** Midas ER Records Type 28 Generation - Audit
 
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
     D TCode                          4S 0 DIM(9) CTDATA PERRCD(1)
 
     D                 DS
      ** Data Structure to redefine Code Schema A.
     D EXSCHA                         8S 0                                      Code Schema A
     D  GenCode                1      3S 0                                      Generic Code
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D BJMRDT          S              7                                         Run date
     D BJURPT          S             53                                         Report Title
 
     D @RUN            S              1
 
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
 
      ** Audit repot header
 
     C                   WRITE     HEADAU
 
      ** Read all records
 
     C*****1****         SETLL     ERLUTRPD                                                   CER001
     C**********         READ      ERLUTRPD                                                   CER001
     C**********         DOW       NOT %EOF(ERLUTRPD)                                         CER001
     C     1             SETLL     ERLTRXPD                                                   CER001
     C                   READ      ERLTRXPD                                                   CER001
     C                   DOW       NOT %EOF(ERLTRXPD)                                         CER001
 
      ** Increase the number of record read.
 
     C                   EVAL      RCOUNT = RCOUNT + 1
 
      ** The transaction original currency ISO code (EXCCYL) is 'EUR'.
      ** OR MUST BE AN 'IN' CURRENCY                                            ULX047
      ** And Annual rate is not zeros.
 
     C                   IF        EXCCYL = 'EUR'
     C                             AND EXANIR <> 0
     C                             AND EXCTRF <> *BLANKS                        214603
     C                             OR  EXprfo = 'Y'                             ULX047
     C                             AND EXANIR <> 0                              ULX047
     C                             AND EXCTRF <> *BLANKS                        ULX047
 
      ** The CCSF Item Number (EXSCHA) must start with '104' (Créances sur la clientèle)
      ** or with '202' (Dettes envers la clientèle).
 
     C                   IF        GenCode = 104
     C                             OR GenCode = 202
 
      ** The CSSF Economic Sector Code (EXECOS) must be in TEcoSector
 
     C     EXECOS        LOOKUP    TCode                                  99
 
     C                   IF        %EQUAL
 
      ** Standard Record Type
 
     C                   EVAL      EXRECT = 028
 
      ** Unique Contract Reference
 
     C                   EVAL      EXCTRF = EXCTRF
 
      ** Annual Interest Rate
 
     C                   EVAL      EXANIR = EXANIR
 
      ** Number of Capitalisation/Reimbursements periods
 
     C                   EVAL      EXNCAP = EXNCAP
 
      ** Increase the number of record Generated.
 
     C                   EVAL      RGENER = RGENER + 1
 
     C                   WRITE     ERLU28D0
 
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
     C                   PARM                    BJMRDT                         Run date
     C                   PARM                    BJURPT                         Report Title
 
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  LDA
 
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
      ** Array 'FTRANS' change to ERL28XPD instead of ERLU28PP                                CER001
      *
**FTRANS                                                                                     222594
*EQUATE   ERL28XPD
*EQUATE   C144504EC551C552C554C956C164C368406A406FC571C572C5744079407A407D
*EQUATE   407E407F
*EQUATE   C181C282C383C484C585C686C787C888C989D191D292D393D494D595D696D797
*EQUATE   D898D999
*EQUATE   E2A2E3A3E4A4E5A5E6A6E7A7E8A8E9A940E0E4FE
**CTDATA TCode
1000 - Non-financial companies and quasi-companies in the public and private sector - UM and Others
1100 - Agriculture, industry, energy and construction - LU
1200 - Commerce, catering trade and hotels/residential - LU
1300 - Transport and communication - LU
1400 - Other commercial services - LU
3000 - Non-profit making households and institutions for households - Others
3110 - Households - Sole traders - LU
3120 - Households - Natural persons - LU
3200 - Non-profit making institutions for households - LU and UM
