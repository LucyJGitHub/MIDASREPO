     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas RE retail account balance extract - COB')        *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE240000 - Midas RE retail account balance extract - COB     *
      *                                                               *
      *  Function:  This program will extract retail account balance  *
      *                                                               *
      *                                                               *
      *  Called By: REC240000                                         *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD054826           Date 20Jan20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE095             Date 25Apr14               *
      *                 AR1095876          Date 30Sep13               *
      *                 AR1089939          Date 22Feb13               *
      *                 AR1005261          Date 30Jul12               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG27978           Date 09Aug10               *
      *                 BUG27942           Date 29Jul10               *
      *                 BUG27878           Date 06Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27288           Date 07Apr10               *
      *                 BUG27229A          Date 17Mar10               *
      *                 BUG27229           Date 17Mar10               *
      *                 CAP202  *CREATE    Date 09Feb10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054826 - After processing all the retail accounts, call    *
      *             again access object AOFCLTR0 with *FREE parameter *
      *             to close FCLTY file.                              *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE095 - Rate Fixing for RE Accounts (Recompile)             *
      *  AR1095876 - ABC - Forward Days 1 should = DNWD-1, not just   *
      *              RUND (Child: AR1095877) (Recompile)              *
      *  AR1089939 - REC240000 fails if CLE025 off                    *
      *            - Allow blank Facility Customer Number             *
      *              if CLE025 is off. Change patterned after         *
      *              AR1086965.  (Child: AR1089940)                   *
      *  AR1005261 - Program RE240000 reads RUNDAT everytime, commits *
      *              after every write.                               *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG27978 - Switch on of CAP202 failed                        *
      *  BUG27942 - Current Cleared Balance is updated online (IC)    *
      *             after a transaction (Account transfer) is done    *
      *  BUG27878 - Projected Available Balance Enquiry               *
      *  BUG27288 - A serios Midas error has occured message comes    *
      *             up when completing insert for Batch Details       *
      *             in GL - JRNE                                      *
      *  BUG27229A - RPG Compilation Issues - Redeliver the programs  *
      *              with reference to F1AVA1                         *
      *  BUG27229 - RPG Compilation Issues - Redeliver the programs   *
      *             without reference to F1AVA1                       *
      *  CAP202 - Retail Account Balance Enquiry                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    99         TestB indicator for EQ                          *
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
      **
      *
     FACCNTAB   IF   E             DISK    INFSR(*PSSR)
      ***Retail*Account*Balance*Extract*-*Denormalized*****************                     BUG27288
      *
     F***RERABEL0  O    E             DISK    INFSR(*PSSR)                                  BUG27288
      ***Global*Customers*X-Reference*Retrieval*index******************                     BUG27288
      *
     F***GPCUSTXL1 IF   E           K DISK    INFSR(*PSSR)                                  BUG27288
      ** Midas GL Account Extension File
      *
     FGLACNTL3  IF   E           K DISK    INFSR(*PSSR)
 
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
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSLDY         E DS                  EXTNAME(DSLDY)
 
     D P@FMT         E DS                  EXTNAME(DSSDY)
     D                                     PREFIX(P@)
     D Q@FMT         E DS                  EXTNAME(DSSDY)
     D                                     PREFIX(Q@)
 
     D Z_SDCUR       E DS                  EXTNAME(SDCURRPD)
     D                                     PREFIX(W_)
     D Z_SDCUS       E DS                  EXTNAME(SDCUSTPD)
     D                                     PREFIX(W_)
     D Z_SDBRC       E DS                  EXTNAME(SDBRCHPD)
     D                                     PREFIX(W1)
     D*Z_MEMOS**     E DS                  EXTNAME(MEMOS)                                   BUG27942
     D**********                           PREFIX(W2)                                       BUG27942
     D Z_FCLTM       E DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(W3)
     D Z_FCLTN       E DS                  EXTNAME(FCLTYFN)
     D  WLCD         E                     EXTFLD(LCD)
     D
     D GPRABE        E DS                  EXTNAME(GPRABEPD)                                BUG27288
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
     D KBRCD           S              3A
     D KCNUM           S              6A
     D KACSQ           S              2  0
     D KACNO           S             10  0
     D KCCY            S              3A
     D KACOD           S             10  0
 
     D P@RTCD          S              7A
     D P@OPTN          S              7A
     D P@SARD          S              6A
     D*P@RETL***       S             10  0                                                  BUG27942
     D P@ERMS          S             50A                                                    BUG27288
 
     D P@BRCD          S              3A
     D P@CNUM          S              6A
     D P@CNM10         S             10A
     D P@CCY           S              3A
     D*P@ACOD***       S             10  0                                                  BUG27942
     D*P@ACSQ***       S              2  0                                                  BUG27942
     D P@FCTY          S              3  0
     D P@FCNO          S              2  0
     D P@RCDT          S              1A
     D P@STAT          S              7A
 
     D CLE025          S              1A   INZ('N')
 
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
      *****************************************************************                    AR1005261
      ***Read*in*installation*Data*************************************                    AR1005261
      *****************************************************************                    AR1005261
     C******DTAARA       DEFINE                  RUNDAT                                    AR1005261
     C******DTAARA       DEFINE                  LDA                                       AR1005261
     C**********         IN        RUNDAT                                                  AR1005261
      *****************************************************************                    AR1005261
      ***Set*Date*Format*Indicator**IN98**on*if*date*format*is*MMDDYY**                    AR1005261
      *****************************************************************                    AR1005261
     C**********         IF        AGDFF = 'M'                                             AR1005261
     C**********         EVAL      *IN98 = *ON                                             AR1005261
     C**********         ENDIF                                                             AR1005261
     C                   EXSR      SrMain
 
     C                   EVAL      *INLR = *ON
     C                   Return
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMain - Program Main routine                                 *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SrMain        BEGSR
 
     C     1             SETLL     ACCNTAB
     C                   READ      ACCNTABF
     C                   DOW       NOT %EOF(ACCNTAB)
     C                   IF        ATYP = 'R'
      *
      ** set all values of all keylist
      *
     C                   EVAL      KBRCD = BRCA
     C                   EVAL      KACSQ = ACSQ
     C                   EVAL      KCNUM = CNUM
     C                   EVAL      KCCY = CCY
     C                   EVAL      KACOD = ACOD
      *
     C                   EVAL      ABBRCD = BRCA
     C                   EVAL      ABCNUM = CNUM
     C                   EVAL      ABACNO = ACNO
     C                   EVAL      ABACOD = ACOD
     C                   EVAL      ABACSQ = ACSQ
     C                   EVAL      ABIBAN = IBAN
     C                   EVAL      ABCCY  = CCY
     C                   EVAL      ABACDN = ANAM
      ** Ledger balance
      *
     C**********         CALL      'AOMEMSR0'                                               BUG27942
     C**********         PARM      *BLANKS       P@RTCD                                     BUG27942
     C**********         PARM      '*KEY    '    P@OPTN                                     BUG27942
     C**********         PARM      ACNO          P@RETL                                     BUG27942
     C**********         PARM      *BLANKS       P@CNUM                                     BUG27942
     C**********         PARM      *BLANKS       P@CCY                                      BUG27942
     C**********         PARM      0             P@ACOD                                     BUG27942
     C**********         PARM      0             P@ACSQ                                     BUG27942
     C**********         PARM      *BLANKS       P@BRCD                                     BUG27942
     C*****Z_MEMOS       PARM      *BLANKS       DSFDY                                      BUG27942
 
     C**********         EVAL      ABLDBL = W2LDBLN                                         BUG27942
     C**********         EVAL      ABCLBL = W2CLBLN                                         BUG27942
     C                   EVAL      ABLDBL = LDBL                                            BUG27942
     C                   EVAL      ABCLBL = CLBL                                            BUG27942
     C                   EVAL      ABODLN = ODLN
     C                   EVAL      ABBCOA = BCOA
     C                   EVAL      ABODED = ODED
     C                   TESTB     '2'           RETB                     99
     C   99              EVAL      ABBLCD = 'Y'
     C  N99              EVAL      ABBLCD = 'N'                                             BUG27288
     C                   TESTB     '3'           RETB                     99
     C   99              EVAL      ABBLCC = 'Y'
     C  N99              EVAL      ABBLCC = 'N'                                             BUG27288
     C                   TESTB     '0'           RETB                     99
     C   99              EVAL      ABRFRD = 'Y'
     C  N99              EVAL      ABRFRD = 'N'                                             BUG27288
     C                   TESTB     '1'           RETB                     99
     C   99              EVAL      ABRFRC = 'Y'
     C  N99              EVAL      ABRFRC = 'N'                                             BUG27288
     C                   EVAL      ABHELD = HELD
     C                   EVAL      ABMINB = MINB
     C                   EVAL      ABLMVD = LMVD
     C                   EVAL      ABDACC = DACC
     C                   EVAL      ABDACO = DACO
      *                                                                                     BUG27288
      ** Initialize amount fields                                                           BUG27288
      *                                                                                     BUG27288
     C                   EVAL      ABABAL = *ZERO                                           BUG27288
     C                   EVAL      ABOAM1 = *ZERO                                           BUG27288
     C                   EVAL      ABFAAMT = *ZERO                                          BUG27288
      *
      ** Read GLACNTL3 to get Today's available balance
      *
     C     GLACKey       CHAIN     GLACNTL3
     C                   IF        NOT %FOUND(GLACNTL3)
     C                   EVAL      ABABAL = *ZERO
     C                   EVAL      ABABA2 = *ZERO                                           BUG27878
     C                   EVAL      ABABA3 = *ZERO                                           BUG27878
     C                   EVAL      ABABA4 = *ZERO                                           BUG27878
     C                   EVAL      ABABA5 = *ZERO                                           BUG27878
     C                   EVAL      ABABA6 = *ZERO                                           BUG27878
     C                   EVAL      ABABA7 = *ZERO                                           BUG27878
     C                   EVAL      ABABA8 = *ZERO                                           BUG27878
     C                   EVAL      ABABA9 = *ZERO                                           BUG27878
     C                   EVAL      ABTOLR = *ZERO                                           BUG27878
     C                   EVAL      ABIABC = *BLANK                                          BUG27878
     C                   ELSE                                                              BUG27229A
     C                   EVAL      ABABAL = F1AVA1                                         BUG27229A
     C                   EVAL      ABABA2 = F1AVA2                                          BUG27878
     C                   EVAL      ABABA3 = F1AVA3                                          BUG27878
     C                   EVAL      ABABA4 = F1AVA4                                          BUG27878
     C                   EVAL      ABABA5 = F1AVA5                                          BUG27878
     C                   EVAL      ABABA6 = F1AVA6                                          BUG27878
     C                   EVAL      ABABA7 = F1AVA7                                          BUG27878
     C                   EVAL      ABABA8 = F1AVA8                                          BUG27878
     C                   EVAL      ABABA9 = F1AVA9                                          BUG27878
     C                   EVAL      ABTOLR = F1TOLR                                          BUG27878
     C                   EVAL      ABIABC = F1IABC                                          BUG27878
     C                   ENDIF
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      CCY           P@CCY
     C     Z_SDCUR       PARM      *BLANKS       DSSDY
 
     C                   EVAL      ABCCYN = W_A6CYNM
      ** Customer
     C                   EVALR     P@CNM10 = CNUM
     C                   CALL      'AOCUSTR1'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM                    P@CNM10
     C                   PARM      *BLANKS       P@STAT
     C     Z_SDCUS       PARM      *BLANKS       DSLDY
 
     C                   EVAL      ABCNM1 = W_BBCNA1
     C                   EVAL      ABCNM2 = W_BBCNA2
     C                   EVAL      ABCNM3 = W_BBCNA3
     C                   EVAL      ABCNM4 = W_BBCNA4
     C                   EVAL      ABCRNM = W_BBCRNM                                        BUG27878
     C                   EVAL      ABACOC = W_BBACOC                                        BUG27878
      ** Branch
     C**********         CALL      'AOBRCHR0'                                               BUG27288
     C                   CALL      'AOBRCHR1'                                               BUG27288
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      BRCA          P@BRCD
     C     Z_SDBRC       PARM      *BLANKS       DSSDY
 
     C                   EVAL      ABBRNM = W1A8BRNM
     C                   EVAL      ABZONE = W1A8ZONE                                        BUG27288
      *
      ***Global*Customer***********************************************                     BUG27288
 
     C*****GCUSKey       CHAIN     GPCUSTXL1                                                BUG27288
 
     C**********         IF        %FOUND                                                   BUG27288
     C**********         EVAL      ABGCNM  = CUGCUS                                         BUG27288
     C**********         ELSE                                                               BUG27288
     C**********         EVAL      ABGCNM  = *BLANKS                                        BUG27288
     C**********         ENDIF                                                              BUG27288
 
     C                   EVAL      ABFCCU  = FCCU
     C                   EVAL      ABFACT  = FACT
     C                   EVAL      ABFCNO  = FCNO
 
     C                   IF        ABFCNO = 0
     C                             Or FCCU = *Blanks                                       AR1089939
     C                             And CLE025 <> 'Y'                                       AR1089939
     C**********         EVAL      ABFAAMT = 0                                              BUG27288
     C                   EVAL      ABFAMT = 0                                               BUG27288
     C                   ELSE
 
     C                   EVAL      P@CNUM  = FCCU
     C                   EVAL      P@FCTY  = FACT
     C                   EVAL      P@FCNO  = FCNO
     C                   EXSR      SrFACILT
      *
      ** Set facility amount from FCLTYFM
      *
     C                   EVAL      ABFAMT = W3FAMT
     C                   IF        CLE025 = 'Y'                                             BUG27978
     C                   EVAL      ABOAM1  = OAM1                                           BUG27978
     C                   EVAL      ABFAAMT = ABFAMT - ABOAM1                                BUG27978
     C                   ENDIF                                                              BUG27978
 
     C                   ENDIF
 
     C**********         WRITE     RERABED0                                                 BUG27288
                                                                                            BUG27288
      * Call program GP230000 to update global file GPRABEPD                                BUG27288
                                                                                            BUG27288
     C                   EVAL      I#RecordIMAGE = GPRABE                                   BUG27288
                                                                                            BUG27288
     C                   CALL      'GP230000'                                               BUG27288
     C                   PARM      *BLANK        P@RTCD                                     BUG27288
     C                   PARM      *BLANK        P@ERMS                                     BUG27288
                                                                                            BUG27288
     C**********         PARM      'Y'           I#COMMIT          1              BUG27288 AR1005261
     C                   PARM      ' '           I#COMMIT          1                       AR1005261
     C                   PARM                    I#Delete          1                        BUG27288
     C                   PARM      'Y'           I#GPCustDet       1                        BUG27288
     C                   PARM                    I#RecordIMAGE 32000                        BUG27288
                                                                                            BUG27288
      * Error                                                                               BUG27288
                                                                                            BUG27288
     C     P@RTCD        IFNE      *BLANK                                                   BUG27288
     C                   EVAL      DBKEY  = I#RecordIMAGE                                   BUG27288
     C                   EVAL      DBFILE = 'GPRABEPD'                                      BUG27288
     C                   EVAL      DBASE  = 003                                             BUG27288
     C                   EXSR      *PSSR                                                    BUG27288
     C                   ENDIF                                                              BUG27288
                                                                                            BUG27288
     C                   ENDIF
 
     C                   READ      ACCNTABF
     C                   ENDDO

     C                   CALL      'AOFCLTR0'                                               MD054826
     C                   PARM      *BLANKS       P@RTCD                                     MD054826
     C                   PARM      '*FREE  '     P@OPTN                                     MD054826
     C                   PARM                    P@CNUM                                     MD054826
     C                   PARM                    P@FCTY                                     MD054826
     C                   PARM                    P@FCNO                                     MD054826
     C                   PARM      *BLANKS       P@RCDT                                     MD054826
     C                   PARM      *BLANKS       P@STAT                                     MD054826
     C                   PARM      *BLANKS       P@FMT                                      MD054826
     C                   PARM      *BLANKS       Q@FMT                                      MD054826
                                                                                            MD054826
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFACILT - Call Access program object AOFCLTR0                *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SrFACILT      BEGSR
 
     C                   CALL      'AOFCLTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM                    P@CNUM
     C                   PARM                    P@FCTY
     C                   PARM                    P@FCNO
     C                   PARM      *BLANKS       P@RCDT
     C                   PARM      *BLANKS       P@STAT
     C     Z_FCLTN       PARM      *BLANKS       P@FMT
     C     Z_FCLTM       PARM      *BLANKS       Q@FMT
      *
     C                   IF        P@RTCD <> *BLANKS
     C                   EVAL      DBKEY  = P@CNUM
     C                   EVAL      DBFILE = 'FCLTY'
     C                   EVAL      DBASE = 002
     C                   EXSR      *PSSR
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
 
     C     GCUSKey       KLIST
     C                   KFLD                    KBRCD
     C                   KFLD                    KCNUM
 
     C     GLACKey       KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
     C                   KFLD                    KBRCD
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       P@RTCD
     C                   PARM      '*VERIFY'     P@OPTN
     C                   PARM      'CLE025'      P@SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        P@RTCD <> *BLANKS
     C                              AND P@RTCD <> '*NRF'                                    BUG27978
     C                   EVAL      DBKEY = 'CLE025'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                            BUG27978
     C                   IF        P@RTCD = *BLANKS                                         BUG27978
     C                   EVAL      CLE025 = 'Y'                                             BUG27978
     C                   ENDIF                                                              BUG27978
      *                                                                                    AR1005261
      ** Read in Installation Data                                                         AR1005261
      *                                                                                    AR1005261
     C     *DTAARA       DEFINE                  RUNDAT                                    AR1005261
     C     *DTAARA       DEFINE                  LDA                                       AR1005261
     C                   IN        RUNDAT                                                  AR1005261
      *                                                                                    AR1005261
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY                      AR1005261
      *                                                                                    AR1005261
     C                   IF        AGDFF = 'M'                                             AR1005261
     C                   EVAL      *IN98 = *ON                                             AR1005261
     C                   ENDIF                                                             AR1005261
 
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
     C                   CALL      'DBERRCTL'
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
